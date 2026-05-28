Attribute VB_Name = "criamdbaccdb"
                            
    'OLEDB:Engine Type=5
  'Unknown                      0
  'Microsoft Jet 1.0            1
  'Microsoft Jet 1.1            2
  'Microsoft Jet 2.0            3
  'Microsoft Jet 3.x(97)        4
  'Microsoft Jet 4.x(2000)      5
  'JetEngineType_Ace12 =        6         accdb
  
  
                            
                            


''' <summary>
''' Cria um novo banco de dados Access (.mdb ou .accdb) usando ADOX.
''' </summary>
''' <param name="cARQORI">Caminho completo do arquivo a ser criado.</param>
''' <param name="lCRIA">Se True, cria sem perguntar ao usuário.</param>
''' <param name="nTIPO">Tipo do motor (5 para Jet/MDB, 6 para ACE/ACCDB).</param>
Public Function CriaMdbAccess(ByVal cARQORI As String, _
                            Optional ByVal lCRIA As Boolean = False, _
                            Optional ByVal nTIPO As Integer = 5) As Boolean
                            
    ' Definições de Engine Type:
    ' 5 = Microsoft Jet 4.x (formato 2000/2003 .mdb)
    ' 6 = Microsoft Access 2007-2016 (formato .accdb)
                            'Dim cat As Object
    Dim cat As ADOX.Catalog
    Dim sConn As String
    
    On Error GoTo trataerro
    CriaMdbAccess = False
    Set cat = New ADOX.Catalog
    
    ' Verifica se o arquivo já existe antes de tentar criar
    If Not ArquivoExiste(cARQORI) Then
        ' Se lCRIA for falso, você pode usar sua função de mensagem MDG para confirmar
        ' Se não tiver a função MDG, remova a verificação Or MDG(...)
        If lCRIA Then
            
            ' Instancia o catálogo usando Late Binding para evitar crashes de DLL
            'Set cat = CreateObject("ADOX.Catalog")
            'acima com new
            
            ' Define a String de Conexão baseada na extensão ou no tipo solicitado
            If nTIPO = 6 Or InStr(LCase(cARQORI), ".accdb") > 0 Then
                ' Provedor ACE para arquivos modernos
                sConn = "Provider=Microsoft.ACE.OLEDB.12.0;" & _
                        "Data Source=" & cARQORI & ";" & _
                        "Jet OLEDB:Engine Type=6;"
            Else
                ' Provedor Jet para arquivos legados
                sConn = "Provider=Microsoft.Jet.OLEDB.4.0;" & _
                        "Data Source=" & cARQORI & ";" & _
                        "Jet OLEDB:Engine Type=" & nTIPO & ";"
            End If
            
            ' Cria o arquivo fisicamente
            cat.Create sConn
            
            CriaMdbAccess = True
        End If
    Else
        ' Arquivo já existe
        CriaMdbAccess = True
    End If

SAIDA:
    Set cat = Nothing
    Exit Function

trataerro:
    MsgBox "Erro ao criar banco de dados: " & Err.Description, vbCritical, "CriaMdbAccess"
    CriaMdbAccess = False
    Resume SAIDA
End Function


