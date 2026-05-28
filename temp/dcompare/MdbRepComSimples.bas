Attribute VB_Name = "MdbRepComSimples"
Option Explicit

Public Enum enumDatabaseType
  [MSAccess2000] ' .mdb
  [MSAccess2007] ' .accdb
End Enum



''' <summary>
''' Compacta e repara uma base de dados Access (.mdb ou .accdb)
''' </summary>
Public Function CompactAccess(xDatabaseLocation As String, _
                              Optional xDatabasePassword As String, _
                              Optional DatabaseType As enumDatabaseType = MSAccess2000) As Boolean

    Dim jro As Object
    Dim strSource As String
    Dim strDest As String
    Dim strTempFile As String
    Dim strProvider As String
    Dim strPass As String

    On Error GoTo CompactAccess_Err
    CompactAccess = False

    ' 1. Definir o Provedor e Extensão
    If DatabaseType = MSAccess2007 Or InStr(LCase(xDatabaseLocation), ".accdb") > 0 Then
        strProvider = "Microsoft.ACE.OLEDB.12.0"
    Else
        strProvider = "Microsoft.Jet.OLEDB.4.0"
    End If

    ' 2. Configurar a senha se existir
    If Len(xDatabasePassword) > 0 Then
        strPass = ";Jet OLEDB:Database Password=" & xDatabasePassword
    Else
        strPass = ""
    End If

    ' 3. Definir ficheiro temporário
    strTempFile = xDatabaseLocation & ".temp"
    If Dir(strTempFile) <> "" Then Kill strTempFile

    ' 4. Montar strings de conexão
    strSource = "Provider=" & strProvider & ";Data Source=" & xDatabaseLocation & strPass
    strDest = "Provider=" & strProvider & ";Data Source=" & strTempFile & strPass

    ' 5. Instanciar JRO via Late Binding (Evita fechar o programa por DLL)
    Set jro = CreateObject("JRO.JetEngine")
    
    ' Executa a compactação
    jro.CompactDataBase strSource, strDest
    
    ' 6. Substituir o original pelo compactado
    Kill xDatabaseLocation
    Name strTempFile As xDatabaseLocation

    CompactAccess = True
    Set jro = Nothing
    Exit Function

CompactAccess_Err:
    MsgBox "Erro ao compactar base de dados:" & vbCrLf & Err.Description, vbCritical, "Compactação"
    If Dir(strTempFile) <> "" Then Kill strTempFile
    Set jro = Nothing
End Function

