$folder = Get-Location

# Garante que os arquivos sejam tratados sempre como um Array/Lista
$files = @(Get-ChildItem -Path $folder -Filter *.mdb)
$files += @(Get-ChildItem -Path $folder -Filter *.accdb)

# Função auxiliar para mapear tipos numéricos/texto do ADOX para o DBML
function Mapear-TipoDBML ($typeNum, $definedSize) {
    switch ($typeNum) {
        2   { return "INTEGER" }         # adSmallInt
        3   { return "INTEGER" }         # adInteger
        4   { return "FLOAT" }           # adSingle
        5   { return "DOUBLE" }          # adDouble
        6   { return "DOUBLE" }          # adCurrency
        7   { return "DATETIME" }        # adDate
        11  { return "BOOLEAN" }         # adBoolean
        17  { return "INTEGER" }         # adUnsignedTinyInt (Byte)
        72  { return "VARCHAR(40)" }     # adGUID
        128 { return "VARBINARY($definedSize)" } # adBinary
        202 { return "VARCHAR($definedSize)" }   # adVarWChar (Texto Curto)
        203 { return "LONGTEXT" }        # adLongVarWChar (Memo / Texto Longo)
        default { return "LONGTEXT" }    # Fallback
    }
}

foreach ($file in $files) {
    if ($null -eq $file) { continue }
    
    $ext = $file.Extension.Substring(1).ToLower()
    Write-Host "Processando arquivo nativo com tabelas e indices sincronizados: $($file.Name)"
    
    $sqlFile = Join-Path $folder "$($file.BaseName)-$ext.sql"
    $dbmlFile = Join-Path $folder "$($file.BaseName).dbml"
    
    "/* SCRIPT SQL DIALETO ACCESS - ORIGEM: $($file.Name) */" > $sqlFile
    "/* GERADO EM: $(Get-Date) */`n" >> $sqlFile

    # Inicializa a string que guardará a estrutura DBML
    $dbmlContent = "/* ESTRUTURA DBML - ORIGEM: $($file.Name) */`r`n"
    $dbmlContent += "/* GERADO EM: $(Get-Date) */`r`n`r`n"
    
    if ($ext -eq "mdb") {
        $connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=$($file.FullName);"
    } else {
        $connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$($file.FullName);"
    }
    
    $connection = New-Object System.Data.OleDb.OleDbConnection($connString)
    
    try {
        $connection.Open()
        
        # Cria o catálogo ADOX vinculado à conexão atual
        $catalog = New-Object -ComObject "ADOX.Catalog"
        $catalog.ActiveConnection = $connection.ConnectionString

        $tabelasProcessar = @()

        # --------------------------------------------------
        # PASSO 1: GERAR O DDL (TABELAS) E ESTRUTURA DBML VIA ADOX
        # --------------------------------------------------
        foreach ($adoxTable in $catalog.Tables) {
            if ($adoxTable.Type -eq "TABLE") {
                $tableName = $adoxTable.Name
                $tabelasProcessar += $tableName

                # 1. Mapeia os campos da Chave Primária primeiro
                $pkFields = @()
                foreach ($index in $adoxTable.Indexes) {
                    if ($index.PrimaryKey) {
                        foreach ($col in $index.Columns) {
                            $pkFields += $col.Name
                        }
                    }
                }

                # Inicia a tabela no SQL e no DBML
                "CREATE TABLE [$tableName] (" >> $sqlFile
                $dbmlContent += "Table `"$tableName`" {`r`n"
                
                $colLines = @()

                # 2. Varre as colunas e monta as propriedades básicas
                foreach ($adoxCol in $adoxTable.Columns) {
                    $colName = $adoxCol.Name
                    $typeNum = $adoxCol.Type
                    $definedSize = $adoxCol.DefinedSize
                    
                    $allowsNull = ($adoxCol.Attributes -band 2) -eq 2
                    $nullText = if ($allowsNull) { "NULL" } else { "NOT NULL" }

                    # Fluxo do SQL Nativo Original
                    $sqlDataType = "MEMO"
                    switch ($typeNum) {
                        3   { $sqlDataType = "INT" }
                        4   { $sqlDataType = "REAL" }
                        5   { $sqlDataType = "DOUBLE" }
                        6   { $sqlDataType = "MONEY" }
                        7   { $sqlDataType = "DATETIME" }
                        11  { $sqlDataType = "BIT" }
                        17  { $sqlDataType = "BYTE" }
                        128 { $sqlDataType = "LONGBINARY" }
                        202 { $sqlDataType = "VARCHAR($definedSize)" }
                        203 { $sqlDataType = "MEMO" }
                    }
                    $colLines += "  [$colName] $sqlDataType $nullText"

                    # Fluxo de Mapeamento para os campos no DBML
                    $dbmlType = Mapear-TipoDBML $typeNum $definedSize
                    
                    $dbmlProps = @()
                    if ($pkFields -contains $colName) { $dbmlProps += "pk" }
                    if (-not $allowsNull) { $dbmlProps += "not null" }
                    
                    try {
                        $defaultVal = $adoxCol.Properties.Item("Default Value").Value
                        if ($defaultVal -and $defaultVal.ToString() -notmatch "^\s*$") {
                            $cleanDefault = $defaultVal.ToString().Replace('"', '').Replace("'", "")
                            $dbmlProps += "default: $cleanDefault"
                        }
                    } catch {}

                    $propsStr = ""
                    if ($dbmlProps.Count -gt 0) {
                        $propsStr = " [" + ($dbmlProps -join ", ") + "]"
                    }

                    $dbmlContent += "  `"$colName`" $dbmlType$propsStr`r`n"
                }

                # Fecha a estrutura principal da tabela no SQL (Colunas e PK)
                $sqlFileText = $colLines -join ",`n"
                if ($pkFields.Count -gt 0) {
                    $pkStr = $pkFields -join ", "
                    $sqlFileText += ",`n  CONSTRAINT [PK_$tableName] PRIMARY KEY ($pkStr)"
                }
                $sqlFileText += "`n);`n"
                $sqlFileText >> $sqlFile

                # 3. EXTRAÇÃO E SINCRONIZAÇÃO DOS INDEXES (Para DBML e para SQL)
                $indexesBlock = @()
                $sqlIndexesBlock = @()

                foreach ($index in $adoxTable.Indexes) {
                    # Ignora a PrimaryKey pois ela já é criada dentro da instrução CONSTRAINT da tabela
                    if (-not $index.PrimaryKey) {
                        $indexCols = @()
                        $sqlIndexCols = @()
                        
                        foreach ($col in $index.Columns) {
                            $indexCols += $col.Name
                            $sqlIndexCols += "[$($col.Name)]"
                        }
                        
                        # Atributo Único (Unique Index) se aplicável
                        $isUnique = if ($index.Unique) { "UNIQUE " } else { "" }

                        if ($indexCols.Count -eq 1) {
                            # Índice simples
                            $indexesBlock += "    $($indexCols[0])"
                            $sqlIndexesBlock += "CREATE $($isUnique)INDEX [$($index.Name)] ON [$tableName] ($($sqlIndexCols[0]));"
                        } elseif ($indexCols.Count -gt 1) {
                            # Índice composto
                            $colsJoined = $indexCols -join ", "
                            $sqlColsJoined = $sqlIndexCols -join ", "
                            $indexesBlock += "    ($colsJoined)"
                            $sqlIndexesBlock += "CREATE $($isUnique)INDEX [$($index.Name)] ON [$tableName] ($sqlColsJoined);"
                        }
                    }
                }

                # Escreve os índices encontrados no arquivo DBML
                if ($indexesBlock.Count -gt 0) {
                    $dbmlContent += "`r`n  Indexes {`r`n"
                    foreach ($idxLine in $indexesBlock) {
                        $dbmlContent += "$idxLine`r`n"
                    }
                    $dbmlContent += "  }`r`n"
                }

                # Fecha a definição da tabela no DBML
                $dbmlContent += "}`r`n`r`n"

                # Escreve os índices encontrados de forma física no arquivo SQL
                if ($sqlIndexesBlock.Count -gt 0) {
                    foreach ($sqlIdxLine in $sqlIndexesBlock) {
                        $sqlIdxLine >> $sqlFile
                    }
                    "`n" >> $sqlFile
                }
            }
        }

        # Grava o arquivo .dbml finalizado da base de dados atual
        $dbmlContent | Out-File -FilePath $dbmlFile -Encoding utf8

        # --------------------------------------------------
        # PASSO 2: EXPORTAR OS DADOS DO SQL (SUA LÓGICA ORIGINAL)
        # --------------------------------------------------
        foreach ($tableName in $tabelasProcessar) {
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
        Write-Host " -> Gerados com sucesso: $($file.BaseName)-$ext.sql e $($file.BaseName).dbml"
    }
    catch {
        Write-Error "Erro no arquivo $($file.Name): $_"
    }
    finally {
        $connection.Close()
        if ($catalog) {
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($catalog) | Out-Null
        }
    }
}