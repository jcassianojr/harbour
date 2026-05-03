// +--------------------------------------------------------------------
// +
// +    Programa  : adoerror.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// + 
// + Essa função, ShowAdoError, é uma rotina de tratamento de exceções voltada especificamente
// +  para operações ADO (ActiveX Data Objects) em Harbour. Ela é projetada para capturar e exibir 
// +  detalhes técnicos quando ocorre uma falha na conexão ou execução de comandos em um banco de dados SQL via ADO.
// +
// +--------------------------------------------------------------------
// +

/*
A função tenta extrair o máximo de contexto possível para facilitar o debug:

    Identificação do Usuário: Utiliza NNETWHOAMI() para identificar quem gerou o erro (comum em ambientes de rede Novell/Netware ou simulados).

    Erros Nativos do ADO: Ela acessa a coleção oCon:Errors. O ADO pode retornar múltiplos erros de uma vez; o código foca no último erro ocorrido (nAdoErrors - 1).

    Contexto da Conexão: Ela extrai a ConnectionString, o Provider e o State da conexão, o que é crucial para saber se o banco caiu ou se as credenciais expiraram.

    Informações do Harbour: Adiciona a operação (oErr:Operation) e a descrição do objeto de erro nativo do Harbour.
*/

FUNCTION ShowAdoError( oERR, oCon, cMESSAGE, lMES )

   LOCAL nAdoErrors := 0
   LOCAL oAdoErr
   LOCAL cERRO:=""
   LOCAL i:=0 // Contador para o loop

   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF

   cERRO      := NNETWHOAMI() + hb_osNewLine()
   nAdoErrors := oCon:Errors:Count()
   
   
   IF nAdoErrors > 0
      // Início do Loop para percorrer todos os erros [Melhoria]
      FOR i := 0 TO ( nAdoErrors - 1 )
         oAdoErr := oCon:Errors( i )
         cERRO += "--- Erro ADO #" + AllTrim(Str(i + 1)) + " ---" + hb_osNewLine()
         cERRO += "Desc: " + oAdoErr:Description + hb_osNewLine()
         cERRO += "Fonte: " + oAdoErr:Source + hb_osNewLine()
         cERRO += "SQL State: " + hb_ValToExp( oAdoErr:SQLState ) + hb_osNewLine()
         cERRO += "Native Error: " + hb_ValToExp( oAdoErr:NativeError ) + hb_osNewLine()
      NEXT
      
      // Detalhes da Conexão (mantidos conforme original)
      cERRO += "--- Contexto da Conexão ---" + hb_osNewLine()
      cERRO += "String: " + oCon:ConnectionString + hb_osNewLine()
      cERRO += "Provider: " + hb_ValToExp( oCon:Provider ) + hb_osNewLine()
      cERRO += "Status Conexão: " + hb_ValToExp( oCon:State ) + hb_osNewLine()
   ELSE
      cERRO += 'Outros Erros (Coleção ADO vazia)' + hb_osNewLine()
   ENDIF
   
  /*
   IF nAdoErrors > 0
      oAdoErr := oCon:Errors( nAdoErrors - 1 )
      cERRO   += oAdoErr:Description + hb_osNewLine() + oAdoErr:Source
      cERRO   += oCon:ConnectionString + hb_osNewLine()
      cERRO   += hb_ValToExp( oCon:Provider ) + hb_osNewLine()
      cERRO   += hb_ValToExp( oCon:State ) + hb_osNewLine()
   ELSE
      cERRO += 'Outros Erros' + hb_osNewLine()
   ENDIF
   */
   
   
   // Mensagem personalizada do desenvolvedor
   IF ValType( cMESSAGE ) = "C" //mensagem adicional para idenficar local programa chamada a criterio do programador
      cERRO += hb_osNewLine() + cMESSAGE
      hb_MemoWrit( "showadoercmd" + ArqLogDataHora( "log" ), cMESSAGE )
   ENDIF
   
   // Erro nativo do Harbour (Objeto oErr)
   cERRO += hb_osNewLine() + oErr:Operation + " " + oErr:Description
   
   // Gravação do Log Completo
   hb_MemoWrit( "showadoerror" + ArqLogDataHora( "log" ), cERRO )
   
   // Exibição visual
   IF lMES
      ALERTX( cERRO )
   ENDIF

   RETURN NIL

// + EOF: adoerror.prg
// +
