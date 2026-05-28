Attribute VB_Name = "dcompareMain"
' Bibliotecas necessárias no seu VBP:
' 1. Microsoft ADO Ext. 6.0 for DDL and Security (ADOX)
' 2. Microsoft ActiveX Data Objects 6.1 (ADO)
' 3. RC6 (vbRichClient6)

' Esta coleção guardará os scripts SQL que detectarmos que estão faltando
Public colScriptsPendentes As Collection
Sub Main()
  dCompare.Show
End Sub

Public Function ArquivoExiste(ByVal FilePath As String) As Boolean
    ArquivoExiste = (Dir(FilePath, vbNormal + vbHidden + vbSystem) <> "")
End Function

Public Function GeraConexao(ByVal Caminho As String)
    Dim sProvider As String
    If LCase(Right(Caminho, 5)) = "accdb" Then
        sProvider = "Microsoft.ACE.OLEDB.12.0"
    Else
        sProvider = "Microsoft.Jet.OLEDB.4.0"
    End If
    GeraConexao = "Provider=" & sProvider & ";Data Source=" & Caminho
End Function

Public Sub LimparScripts()
    Set colScriptsPendentes = New Collection
End Sub

Public Function AbrirCatalog(ByVal sCaminho As String) As Object
    ' Retorna um objeto ADOX.Catalog para ler a estrutura do MDB
    Dim cat As Object
    Set cat = CreateObject("ADOX.Catalog")
    
    ' String de conexão genérica para MDB/ACCDB
    cat.ActiveConnection = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & sCaminho
    Set AbrirCatalog = cat
End Function

Public Sub AdicionarScript(ByVal sSQL As String)
    If colScriptsPendentes Is Nothing Then Set colScriptsPendentes = New Collection
    colScriptsPendentes.Add sSQL
    Debug.Print "Script Adicionado: " & sSQL
End Sub

Public Function ValidarOuCriarDestino(ByVal cCaminho As String) As Boolean
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' 1. Checagem: O arquivo já existe?
    If fso.FileExists(cCaminho) Then
        ' Se existe, perguntamos se o usuário quer APENAS abrir para comparar
        ' ou se ele tem certeza que é o destino correto.
        Dim resposta As VbMsgBoxResult
        resposta = MsgBox("O arquivo de destino já existe." & vbCrLf & _
                          "Deseja utilizá-lo para sincronização?" & vbCrLf & vbCrLf & _
                          "Atenção: A estrutura pode ser alterada.", vbYesNo + vbInformation, "Confirmação")
        
        If resposta = vbYes Then
            ValidarOuCriarDestino = True
        Else
            ValidarOuCriarDestino = False
        End If
    Else
        ' 2. Se não existe, perguntamos se quer criar
        If MsgBox("O arquivo de destino não existe. Deseja criá-lo agora?", vbYesNo + vbQuestion) = vbYes Then
            ' Chama a rotina de criação que vimos anteriormente
            ValidarOuCriarDestino = CriarNovoDestino(cCaminho)
        Else
            ValidarOuCriarDestino = False
        End If
    End If
    
    Set fso = Nothing
End Function
' Adicione isto ao seu modDCompare.bas
Public Function CriarNovoDestino(ByVal cCaminho As String) As Boolean
    Dim lExiste As Boolean
    lExiste = (Dir(cCaminho) <> "")
    
    ' 1. Verificação de Segurança: Se existe e tem dados, abortar para não sobrescrever
    If lExiste And FileLen(cCaminho) > 0 Then
        MsgBox "Atenção: O arquivo já existe e contém dados. Não é possível sobrescrever.", vbCritical
        CriarNovoDestino = False
        Exit Function
    End If
    
    ' 2. Confirmação
    If MsgBox("O arquivo de destino será criado agora. Prosseguir?", vbYesNo + vbQuestion) = vbNo Then
        CriarNovoDestino = False
        Exit Function
    End If
    
    ' 3. Se existe (arquivo vazio de 0 bytes) ou não existe, vamos criar
    If lExiste Then Kill cCaminho
    
    Dim sExt As String
    sExt = LCase(cCaminho)
    
    If EArquivoSQLite(sExt) > 0 Then
        ' Cria via motor RC6
        CriarNovoDestino = CriarSQLite(cCaminho)
    Else
        ' Cria via ADOX (MDB ou ACCDB)
        Dim nTIPO As Integer
        nTIPO = IIf(InStr(sExt, ".accdb") > 0, 6, 5)
        CriarNovoDestino = CriaMdbAccess(cCaminho, True, nTIPO)
    End If
End Function
Public Function EArquivoSQLite(ByVal cCaminho As String) As Boolean
    Dim sExt As String
    sExt = LCase(Right(cCaminho, 6)) ' Pega a extensão final
    
    ' Lista de extensões que o seu sistema aceita como SQLite
    If InStr(cCaminho, ".sqlite") > 0 Or _
       InStr(cCaminho, ".db") > 0 Or _
       InStr(cCaminho, ".db3") > 0 Or _
       InStr(cCaminho, ".fossil") > 0 Then
       
       EArquivoSQLite = True
    Else
       EArquivoSQLite = False
    End If
End Function
Public Function CriarSQLite(ByVal cCaminho As String) As Boolean
    On Error GoTo Erro
    Dim oConn As New RC6.cConnection
    
    ' O método OpenDB cria o arquivo automaticamente se ele não existir
    oConn.OpenDB cCaminho
    
    CriarSQLite = True
    Exit Function
Erro:
    MsgBox "Erro ao criar SQLite: " & Err.Description, vbCritical
    CriarSQLite = False
End Function
Public Function CompactarSQLite(ByVal sCaminho As String) As Boolean
    On Error GoTo Erro
    Dim oConn As New RC6.cConnection
    
    ' 1. Abre o banco de dados
    oConn.OpenDB sCaminho
    
    ' 2. O comando VACUUM reorganiza e compacta o ficheiro
    oConn.Execute "VACUUM"
    
    
    CompactarSQLite = True
    Exit Function
    
Erro:
    MsgBox "Erro ao compactar SQLite: " & Err.Description, vbCritical
    CompactarSQLite = False
End Function

Public Sub GerarInfoTabelasAccess(ByVal sCaminho As String, ByRef txtDestino As TextBox)
    Dim conn As Object
    Dim cat As Object ' ADOX.Catalog
    Dim tbl As Object ' ADOX.Table
    Dim idx As Object ' ADOX.Index
    Dim col As Object ' ADOX.Column
    Dim fld As Object ' ADODB.Field
    Dim rs As Object
    
    ' Conexão via ADO
    Set conn = CreateObject("ADODB.Connection")
    conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & sCaminho & ";"
    
    ' Usamos o ADOX para ler a estrutura (Catalog)
    Set cat = CreateObject("ADOX.Catalog")
    Set cat.ActiveConnection = conn
    
    txtDestino.Text = "Estrutura Access (ADOX): " & sCaminho & vbCrLf & String(60, "-") & vbCrLf
    
    For Each tbl In cat.Tables
        If tbl.Type = "TABLE" Then
            txtDestino.Text = txtDestino.Text & vbCrLf & "TABELA: " & tbl.Name & vbCrLf
            
            ' --- CAMPOS ---
            txtDestino.Text = txtDestino.Text & "  [Campos]:" & vbCrLf
            ' --- Lógica Refinada para Precisão e Escala ---
For Each col In tbl.Columns
    Dim sTipoFormatado As String
    Dim nPrec As Integer, nScale As Integer
    
    ' Obtém o tipo base
    sTipoFormatado = GetTipoNome(col.Type)
    
    ' Inicializa precisão e escala
    nPrec = 0
    nScale = 0
    
    ' Tenta capturar as propriedades de precisão (Numeric/Decimal)
    On Error Resume Next
    nPrec = col.Properties("NumericPrecision").Value
    nScale = col.Properties("NumericScale").Value
    On Error GoTo 0
    
    ' --- APLICANDO A LÓGICA DE EXIBIÇÃO (Igual ao seu Harbour) ---
    Dim sDetalhe As String
    
    ' Caso 1: Se for numérico (Precision > 0)
    If nPrec > 0 Then
        ' Se nScale for 0, mostra apenas (10). Se for > 0, mostra (10,2)
        If nScale > 0 Then
            sDetalhe = "(" & nPrec & "," & nScale & ")"
        Else
            sDetalhe = "(" & nPrec & ")"
        End If
        
    ' Caso 2: Se for Texto/Char (Tratamento conforme sua regra de 250)
    ElseIf col.Type = 129 Or col.Type = 200 Or col.Type = 202 Or col.Type = 203 Then
        Dim nLen As Long
        nLen = col.DefinedSize
        If nLen <= 0 Or nLen > 250 Then nLen = 250
        sDetalhe = "(" & nLen & ")"
        
    ' Caso 3: Campos Lógicos (L)
    ElseIf col.Type = 11 Then
        sDetalhe = "(1)"
        
    ' Caso 4: Outros casos
    Else
        sDetalhe = ""
    End If
    
    ' Saída Final no seu Relatório
    txtDestino.Text = txtDestino.Text & "    - " & col.Name & " [" & sTipoFormatado & "]" & sDetalhe & vbCrLf
Next col
            
            ' --- ÍNDICES E SEUS CAMPOS ---
            txtDestino.Text = txtDestino.Text & "  [Índices]:" & vbCrLf
            For Each idx In tbl.Indexes
                txtDestino.Text = txtDestino.Text & "    * Índice: " & idx.Name & " (Primary: " & idx.PrimaryKey & ")" & vbCrLf
                
                ' Listando os campos que compõem este índice
                For Each col In idx.Columns
                    txtDestino.Text = txtDestino.Text & "      -> Campo: " & col.Name & vbCrLf
                Next
            Next
            txtDestino.Text = txtDestino.Text & String(40, ".") & vbCrLf
        End If
    Next
    
    conn.Close
End Sub
' Função auxiliar para converter o número do tipo de dados em texto legível
Public Function GetTipoNome(ByVal nTIPO As Integer) As String
    Select Case nTIPO
        Case 0: GetTipoNome = "Empty"
        Case 2: GetTipoNome = "SmallInt"
        Case 3: GetTipoNome = "Integer"
        Case 4: GetTipoNome = "Single"
        Case 5: GetTipoNome = "Double"
        Case 6: GetTipoNome = "Currency"
        Case 7: GetTipoNome = "Date"
        Case 8: GetTipoNome = "BSTR"
        Case 9: GetTipoNome = "IDispatch"
        Case 10: GetTipoNome = "Error"
        Case 11: GetTipoNome = "Boolean"
        Case 14: GetTipoNome = "Decimal"
        Case 16: GetTipoNome = "TinyInt"
        Case 17: GetTipoNome = "UnsignedTinyInt"
        Case 18: GetTipoNome = "UnsignedSmallInt"
        Case 19: GetTipoNome = "UnsignedInt"
        Case 20: GetTipoNome = "BigInt"
        Case 21: GetTipoNome = "UnsignedBigInt"
        Case 72: GetTipoNome = "GUID"
        Case 128: GetTipoNome = "Binary"
        Case 129: GetTipoNome = "Char"
        Case 130: GetTipoNome = "WChar"
        Case 131: GetTipoNome = "Numeric"
        Case 132: GetTipoNome = "UserDefined"
        Case 133: GetTipoNome = "DBDate"
        Case 134: GetTipoNome = "DBTime"
        Case 135: GetTipoNome = "DBTimeStamp"
        Case 136: GetTipoNome = "Chapter"
        Case 200: GetTipoNome = "VarChar"
        Case 201: GetTipoNome = "LongVarChar"
        Case 202: GetTipoNome = "VarWChar" ' O famoso 202
        Case 203: GetTipoNome = "LongVarWChar(Memo)"
        Case 204: GetTipoNome = "VarBinary"
        Case 205: GetTipoNome = "LongVarBinary(Ole)"
        Case Else: GetTipoNome = "Tipo:" & nTIPO
    End Select
End Function

Public Sub GerarInfoTabelasSQLite(ByVal sCaminho As String, ByRef txtDestino As TextBox)
    Dim oConn As RC6.cConnection
    Dim oRS As RC6.cRecordset
    Dim oFldRS As RC6.cRecordset
    Dim oIdxRS As RC6.cRecordset
    Dim sSQL As String
    Dim sTabela As String
    
    Set oConn = New_c.Connection(sCaminho)
    txtDestino.Text = "Estrutura Completa: " & sCaminho & vbCrLf & String(40, "-") & vbCrLf

    ' 1. Lista tabelas (Com a query que já validamos)
    sSQL = "SELECT name FROM sqlite_master WHERE type = 'table' AND SUBSTR(name, 1, 7) <> 'sqlite_'"
    Set oRS = oConn.OpenRecordset(sSQL)
    
    Do While Not oRS.EOF
        sTabela = oRS!Name
        txtDestino.Text = txtDestino.Text & vbCrLf & "TABELA: " & sTabela & vbCrLf
        
        ' 2. Campos com Tipos (Usando PRAGMA que agora deve funcionar)
        txtDestino.Text = txtDestino.Text & "  [Campos]:" & vbCrLf
        Set oFldRS = oConn.OpenRecordset("PRAGMA table_info([" & sTabela & "])")
        Do While Not oFldRS.EOF
            ' 'name' e 'type' são colunas padrão do PRAGMA table_info
            txtDestino.Text = txtDestino.Text & "    - " & oFldRS!Name & " (" & oFldRS!Type & ")" & vbCrLf
            oFldRS.MoveNext
        Loop
        
        ' 3. Índices (Usando PRAGMA index_list)
        'txtDestino.Text = txtDestino.Text & "  [Índices]:" & vbCrLf
        'Set oIdxRS = oConn.OpenRecordset("PRAGMA index_list([" & sTabela & "])")
        'Do While Not oIdxRS.EOF
        '    txtDestino.Text = txtDestino.Text & "    * " & oIdxRS!Name & vbCrLf
        '    oIdxRS.MoveNext
        'Loop
        
        ' 3. ÍNDICES
        txtDestino.Text = txtDestino.Text & "  [Índices]:" & vbCrLf
        Set oIdxRS = oConn.OpenRecordset("PRAGMA index_list([" & sTabela & "])")
        
        Do While Not oIdxRS.EOF
            Dim sNomeIndice As String
            sNomeIndice = oIdxRS!Name
            txtDestino.Text = txtDestino.Text & "    * Índice: " & sNomeIndice & vbCrLf
            
            ' Detalhes do Índice (Campos que compõem o índice)
            Dim oIdxInfoRS As RC6.cRecordset
            Set oIdxInfoRS = oConn.OpenRecordset("PRAGMA index_info([" & sNomeIndice & "])")
            
            Do While Not oIdxInfoRS.EOF
                ' oIdxInfoRS!name traz o nome da coluna que está no índice
                txtDestino.Text = txtDestino.Text & "      -> Campo: " & oIdxInfoRS!Name & vbCrLf
                oIdxInfoRS.MoveNext
            Loop
            
            oIdxRS.MoveNext
        Loop
        
        
        oRS.MoveNext
    Loop

    Set oRS = Nothing
    Set oConn = Nothing
End Sub
