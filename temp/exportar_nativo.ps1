$folder = Get-Location
$files = Get-ChildItem -Path $folder -Filter *.mdb
$files += Get-ChildItem -Path $folder -Filter *.accdb

foreach ($file in $files) {
    $ext = $file.Extension.Substring(1).ToLower()
    Write-Host "Processando arquivo nativo: $($file.Name)"
    
    $sqlFile = Join-Path $folder "$($file.BaseName)-$ext.sql"
    
    "/* SCRIPT SQL DIALETO ACCESS - ORIGEM: $($file.Name) */" > $sqlFile
    "/* GERADO EM: $(Get-Date) */`n" >> $sqlFile

    if ($ext -eq "mdb") {
        $connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=$($file.FullName);"
    } else {
        $connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$($file.FullName);"
    }
    
    $connection = New-Object System.Data.OleDb.OleDbConnection($connString)
    
    try {
        $connection.Open()
        
        # Cria o catálogo ADOX para ler os índices nativos
        $catalog = New-Object -ComObject "ADOX.Catalog"
        $catalog.ActiveConnection = $connection.ConnectionString

        # --------------------------------------------------
        # PASSO 1A: GERAR O DDL (TABELAS)
        # --------------------------------------------------
        "/* ============================================= */" >> $sqlFile
        "/* PASSO 1A: ESTRUTURA DAS TABELAS (CREATE TABLE)*/" >> $sqlFile
        "/* ============================================= */`n" >> $sqlFile

        foreach ($adoxTable in $catalog.Tables) {
            if ($adoxTable.Type -ne "TABLE") { continue }
            $tableName = $adoxTable.Name
            
            $ddl = "CREATE TABLE [$tableName] (`n"
            $colLines = @()

            foreach ($col in $adoxTable.Columns) {
                $colName = $col.Name
                $typeId = $col.Type
                $colSize = $col.DefinedSize
                
                # Verifica propriedades de Autonumeração e Nulo
                $isAutoInc = $false
                try { $isAutoInc = $col.Properties.Item("AutoIncrement").Value } catch {}
                
                $isNullable = ""
                try { if ($col.Attributes -band 2) { $isNullable = "" } else { $isNullable = " NOT NULL" } } catch {}

                $accessType = "TEXT(255)"
                if ($isAutoInc) {
                    $accessType = "COUNTER"
                } else {
                    switch ($typeId) {
                        202 { $accessType = "TEXT($colSize)" } # adVarWChar
                        203 { $accessType = "MEMO" }           # adLongVarWChar
                        3   { $accessType = "LONG" }           # adInteger
                        2   { $accessType = "INTEGER" }        # adSmallInt
                        17  { $accessType = "BYTE" }           # adUnsignedTinyInt
                        4   { $accessType = "SINGLE" }         # adSingle
                        5   { $accessType = "DOUBLE" }         # adDouble
                        6   { $accessType = "CURRENCY" }       # adCurrency
                        7   { $accessType = "DATETIME" }       # adDate
                        11  { $accessType = "BIT" }            # adBoolean
                        72  { $accessType = "GUID" }           # adGUID
                        205 { $accessType = "LONGBINARY" }     # adLongVarBinary
                        Default { $accessType = "TEXT(255)" }
                    }
                }
                $colLines += "    [$colName] $accessType$isNullable"
            }
            
            $ddl += ($colLines -join ",`n") + "`n);"
            $ddl >> $sqlFile
            "`n" >> $sqlFile
        }

        # --------------------------------------------------
        # PASSO 1B: GERAR OS INDICES NATIVOS (CREATE INDEX)
        # --------------------------------------------------
        "/* ============================================= */" >> $sqlFile
        "/* PASSO 1B: INDICES DAS TABELAS (CREATE INDEX)  */" >> $sqlFile
        "/* ============================================= */`n" >> $sqlFile

        foreach ($adoxTable in $catalog.Tables) {
            if ($adoxTable.Type -ne "TABLE") { continue }
            $tableName = $adoxTable.Name

            foreach ($index in $adoxTable.Indexes) {
                # Ignora os índices internos criados automaticamente para ligar Foreign Keys 
                if ($index.Name -match "^Reference" -or $index.Name -match "^PrimaryKey") {
                    # Se preferir mapear explicitamente a Primary Key como comando separado:
                    if ($index.PrimaryKey) {
                        $idxCols = @()
                        foreach ($col in $index.Columns) { $idxCols += "[$($col.Name)]" }
                        $idxColsStr = $idxCols -join ", "
                        "ALTER TABLE [$tableName] ADD CONSTRAINT [PK_$tableName] PRIMARY KEY ($idxColsStr);" >> $sqlFile
                        continue
                    }
                }

                $unique = if ($index.Unique) { "UNIQUE " } else { "" }
                $idxCols = @()
                foreach ($col in $index.Columns) {
                    $descending = if ($col.SortOrder -eq 2) { " DESC" } else { "" }
                    $idxCols += "[$($col.Name)]$descending"
                }
                $idxColsStr = $idxCols -join ", "
                
                "CREATE $($unique)INDEX [$($index.Name)] ON [$tableName] ($idxColsStr);" >> $sqlFile
            }
            "" >> $sqlFile
        }

        # --------------------------------------------------
        # PASSO 2: GERAR OS INSERTS DOS DADOS
        # --------------------------------------------------
        "/* ============================================= */" >> $sqlFile
        "/* PASSO 2: INSERCAO DOS DADOS (INSERT INTO)     */" >> $sqlFile
        "/* ============================================= */`n" >> $sqlFile

        foreach ($adoxTable in $catalog.Tables) {
            if ($adoxTable.Type -ne "TABLE") { continue }
            $tableName = $adoxTable.Name
            
            $command = $connection.CreateCommand()
            $command.CommandText = "SELECT * FROM [$tableName]"
            $reader = $command.ExecuteReader()

            while ($reader.Read()) {
                $fields = @()
                $values = @()

                for ($i = 0; $i -lt $reader.FieldCount; $i++) {
                    $fields += "[$($reader.GetName($i))]"
                    $val = $reader.GetValue($i)
                    
                    if ($val -eq [DBNull]::Value) {
                        $values += "NULL"
                    } elseif ($reader.GetFieldType($i).Name -match "String|DateTime|Guid") {
                        $escaped = $val.ToString().Replace("'", "''")
                        $values += "'$escaped'"
                    } elseif ($reader.GetFieldType($i).Name -eq "Boolean") {
                        $values += if ($val) { "True" } else { "False" }
                    } else {
                        $values += $val.ToString().Replace(",", ".")
                    }
                }

                $fieldsStr = $fields -join ", "
                $valuesStr = $values -join ", "
                "INSERT INTO [$tableName] ($fieldsStr) VALUES ($valuesStr);" >> $sqlFile
            }
            $reader.Close()
            "`n" >> $sqlFile
        }
        Write-Host " -> Gerado com sucesso: $($file.BaseName)-$ext.sql"
    }
    catch {
        Write-Error "Erro no arquivo $($file.Name): $_"
    }
    finally {
        $connection.Close()
        # Libera o objeto COM do ADOX da memória
        if ($catalog) { [System.Runtime.Interopservices.Marshal]::ReleaseComObject($catalog) | Out-Null }
    }
}