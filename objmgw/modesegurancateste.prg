PROCEDURE Main()
LOCAL cServer, cUser, cPassword

// Passa o nome da seção exatamente como foi gerado no VB6
cServer   := LerDoCofre( "BANCOTESTE", "Server" )
cUser     := LerDoCofre( "BANCOTESTE", "User" )
cPassword := LerDoCofre( "BANCOTESTE", "Password" )

IF Empty( cServer )
    ? "Erro: Banco nao configurado ou arquivo nao encontrado!"
    WAIT
    QUIT
ENDIF

? "Conectando ao servidor: " + cServer
? "Usuario recuperado   : " + cUser
// Aqui você faz a chamada de conexão usando as variáveis limpas na memória

WAIT
RETURN