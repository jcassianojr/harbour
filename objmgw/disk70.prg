// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk70.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => C:\DEVELOP\OBJ\DISK70.PRG
// +
// +    Functions: Function GravaCampo()
// +               Function GravaERRO()
// +               Function CLRVARS()
// +               Function EQUVARS()
// +               Function FREEVARS()
// +               Function INITVARS()
// +               Function REPLVARS()
// +               Function MAKEVAR()
// +               Function MAKE_EMPTY()
// +
// +    Reformatted by Click! 2.03 on Sep-13-2004 at  9:55 am
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


// GravaCampo Funcaao Replace otimizada
// aCAMPO (Matriz ou Variavel) //Requer Haspas sofrer  Macro
// aVAR   (Matriz ou Variavel) //Requer Haspas sofrer  Macro
// cUSO   (Mensagem Auxiliar caso Haja Erro
// Somente grava se o tipo do campo do arquivo for igual ao da varivel
// Nao Grava se o campo do arquivo nao existir
// Caso o campo seja caracter e a variavel nao faz as conversoes e grava
// Caso o campo seja MEMO  e a variavel nao faz as conversoes e grava
// Caso o campo seja numerico corta os dados caso o tamanho da varivel
// seja maior que o campo e grava
// Exibe uma mensagem do erro no video
// Grava no erro.txt o ocorrido
// Bye Bye Type Mismatch
// Bye Bye Data Width

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +
// +    Function GravaCampo(aCAMPO, aVAR, cUSO, lLOCK, lMES, lMACRO ,lLOG)
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GravaCampo()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GravaCampo( aCAMPO, aVAR, cUSO, lLOCK, lMES, lMACRO, lLOG )

   LOCAL cERRO
   LOCAL nHANDLE
   LOCAL cTIPOV
   LOCAL cTIPOC
   LOCAL XCAMPO
   LOCAL XPOS
   LOCAL XPOSDBF
   LOCAL aSTRU
   LOCAL nLEN
   LOCAL nDEC
   LOCAL nERRO   := 0
   LOCAL eTMP
   LOCAL eUSO
   LOCAL eVAR
   LOCAL eCAMPO

   IF ValType( lLOG ) # "L"
      lLOG := .F.
   ENDIF
   IF ValType( lLOCK ) # "L"
      lLOCK := .T.
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF ValType( lMACRO ) # "L"
      lMACRO := .T.
   ENDIF
   IF lLOG
      nHANLOG := FCreate( "GRAVACAM.TXT" )
   ENDIF
   IF lLOCK
      netreclock()
   ENDIF
   aSTRU := dbStruct()
   IF ValType( aCAMPO ) = "C" .AND. ValType( aVAR ) = "C"  // nao E mantriz
      eVAR   := aVAR
      eCAMPO := aCAMPO
      aCAMPO := { eCAMPO }   // Vira uma matriz
      aVAR   := { eVAR }
   ENDIF
   FOR XCAMPO := 1 TO Len( aVAR )
      eVAR   := aVAR[ XCAMPO ]
      eCAMPO := aCAMPO[ XCAMPO ]
      IF lMACRO
         cTIPOV := Type( eVAR )
      ELSE
         cTIPOV := ValType( eVAR )
      ENDIF
      cTIPOC  := Type( eCAMPO )
      nERRO   := 0
      nPOSDBF := 0
      FOR XPOS := 1 TO Len( aSTRU )
         IF Upper( AllTrim( aSTRU[ XPOS, 1 ] ) ) = Upper( AllTrim( eCAMPO ) )
            nPOSDBF := XPOS
         ENDIF
      NEXT
      IF lLOG
         FWrite( nHANLOG, &eCAMPO + " " + ( lMACRO, &eVAR, eVAR ) + Chr( 13 ) + Chr( 10 ) )
      ENDIF
      IF cTIPOV = cTIPOC .AND. nPOSDBF > 0
         IF cTIPOC = "N"
            IF lMACRO
               eUSO := AllTrim( Str( &eVAR ) )
            ELSE
               eUSO := AllTrim( Str( eVAR ) )
            ENDIF
            nDEC    := At( ".", eUSO )  // Posicao
            nTAM    := Len( eUSO )
            eTMPVAL := repl( "9", aSTRU[ nPOSDBF, 3 ] )  // Faz 9999... Conforme tam
            IF aSTRU[ NPOSDBF, 4 ] > 0
               eTMPVAL += "." + repl( "9", aSTRU[ nPOSDBF, 4 ] )
            ENDIF
            eTMPVAL := Val( eTMPVAL )
            IF if( lMACRO, &eVAR., eVAR ) > eTMPVAL
               nERRO := 1
               IF aSTRU[ NPOSDBF, 4 ] > 0
                  eUSO := Right( Str( Round( if( lMACRO, &eVAR, eVAR ), aSTRU[ nPOSDBF, 4 ] ) ), aSTRU[ nPOSDBF, 3 ] )
               ELSE
                  eUSO := Right( Str( Int( if( lMACRO, &eVAR, eVAR ) ) ), aSTRU[ nPOSDBF, 3 ] )
               ENDIF
               field->&eCAMPO := Val( eUSO )
            ELSE
               field->&eCAMPO := if( lMACRO, &eVAR, eVAR )
            ENDIF
         ELSE
            field->&eCAMPO := if( lMACRO, &eVAR, eVAR )
         ENDIF
      ELSE
         nERRO := 2
      ENDIF
      IF nERRO > 0
         cERRO := "Arquivo: " + AllTrim( Alias() ) + Chr( 13 ) + Chr( 10 )
         cERRO += " Variavel: " + AllTrim( STRVAL( if( lMACRO, &eVAR, eVAR ) ) ) + " Tipo: " + cTIPOV  // +" Tamanho:"+STR(LEN(&eVAR))+chr(13)+chr(10)
         cERRO += " Campo: " + eCAMPO + " Tipo: " + cTIPOC
         IF nPOSDBF = 0
            cERRO += Chr( 13 ) + Chr( 10 ) + "Campo Arquivo Inexistente: " + eCAMPO
         ENDIF
         IF nERRO == 1
            cERRO += Chr( 13 ) + Chr( 10 ) + "Variavel Excede Tamanho do Campo: " + Str( aSTRU[ nPOSDBF, 3 ] ) + " Decimais: " + Str( aSTRU[ nPOSDBF, 4 ] )
         ENDIF
         IF lMES
            ALERTX( cERRO )
         ENDIF
         GRAVAERRO(, cERRO )
         IF ValType( cUSO ) = "C"
            GRAVAERRO(, cUSO )
         ENDIF
         IF cTIPOC = "C"
            field->&eCAMPO := STRVAL( if( lMACRO, &eVAR, eVAR ) )
         ENDIF
         IF cTIPOC = "M"
            field->&eCAMPO := STRVAL( if( lMACRO, &eVAR, eVAR ) )
         ENDIF
      ENDIF
   NEXT XCAMPO
   IF lLOG
      FClose( nHANLOG )
   ENDIF
   IF lLOCK
      dbUnlock()
   ENDIF
   dbCommit()

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +
// +    Function GravaERRO(cARQ, aMES)
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GravaERRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GravaERRO( cARQ, aMES )

   LOCAL X

   IF ValType( cARQ ) # "C"
      cARQ := "ERRO.TXT"
   ENDIF
   IF ValType( aMES ) # "A"  // Transforme em matriz se nao for
      aMES := { aMES }
   ENDIF
   IF !hb_FileExists( cARQ )
      nhandle := FCreate( cARQ )
   ELSE
      nhandle := FOpen( cARQ, 1 )
      FSeek( nhandle, 0, 2 )
   ENDIF
   FOR X := 1 TO Len( aMES )
      FWrite( nHandle, STRVAL( aMES[ X ] ) + Chr( 13 ) + Chr( 10 ) )
   NEXT X
   FClose( nHandle )

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function CLRVARS()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CLRVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CLRVARS()

   LOCAL aSTRU

   aSTRU := dbStruct()
   FOR XPOS := 1 TO Len( aSTRU )
      field_name  := "m" + Lower( aSTRU[ XPOS, 1 ] )
      &field_name := MAKEVAR( aSTRU[ XPOS, 2 ], aSTRU[ xPOS, 3 ], aSTRU[ xPOS, 4 ] )
   NEXT

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function EQUVARS()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function EQUVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION EQUVARS

// Carrega dos campos da b. de dados as variaveis de memoria criadas por INITVARS.
   LOCAL field_cnt    := FCount()
   LOCAL counter      := 0
   PRIVATE field_name
// Carrega cada uma das variaveis do campo correspondente
   FOR counter := 1 TO field_cnt
      field_name   := Lower( field( counter ) )
      m&field_name := &field_name
   NEXT

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function FREEVARS()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FREEVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FREEVARS

// Libera as variaveis criadas por INITVARS.
   LOCAL counter      := 0
   LOCAL field_cnt    := FCount()
   PRIVATE field_name
// Libera cada uma das variaveis de campo.
   FOR counter := 1 TO field_cnt
      field_name := Lower( field( counter ) )
      RELEASE m&field_name
   NEXT

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function INITVARS()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function INITVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION INITVARS

// Cria variaveis de memoria para cada campo da base de dados ativa.
// Atencao: Esta rotina declara uma variavel de memoria PUBLICA para
// cada campo da base de dados selecionada. Libera as variaveis,
// chamando FREEVARS quando voce nao precisa mais delas.
   LOCAL field_cnt    := FCount()
   LOCAL counter      := 0
   PRIVATE field_name
// Obtem o numero de campos.
   field_cnt := FCount()
// Declara uma variavel publica para cada campo.
   FOR counter := 1 TO field_cnt
      field_name := Lower( field( counter ) )
      PUBLIC m&field_name
   NEXT

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function REPLVARS(lCHECK)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function REPLVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION REPLVARS( lCHECK, lVAZIO )

// Substitui o registro pelo valor das variaveis de memoria.
   LOCAL field_cnt    := FCount()
   LOCAL counter      := 0
   LOCAL aCAM
   LOCAL aDAD
   PRIVATE field_name
   IF ValType( lCHECK ) # "L"
      lCHECK := .T.
   ENDIF
   IF ValType( lVAZIO ) # "L"
      lVAZIO := .F.
   ENDIF

// Obtem o numero de campos.
   field_cnt := FCount()
   IF lCHECK   // Com Checagem chama gravacampo
      // Substitui cada um dos campos pelas variaveis a eles associadas.
      aCAM := {}
      aVAR := {}
      FOR counter := 1 TO field_cnt
         field_name := Lower( field( counter ) )
         IF !lVAZIO .OR. ( Empty( field->&field_name ) .AND. !Empty( m&field_name ) )
            AAdd( Acam, field_name )
            AAdd( AVAR, "m" + field_name )
         ENDIF
      NEXT
      gravacampo( aCAM, aVAR,,, )   // GravaCampo(aCAMPO, aVAR, cUSO, lLOCK, lMES, lMACRO ,lLOG)
   ELSE  // Sem checagem
      FOR counter := 1 TO field_cnt
         field_name := Lower( field( counter ) )
         IF !lVAZIO .OR. ( Empty( field->&field_name ) .AND. !Empty( m&field_name ) )
            field->&field_name := m&field_name
         ENDIF
      NEXT
   ENDIF

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAKEVAR()
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKEVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MAKEVAR( cTIPO, nLEN, nDEC )

   LOCAL eRETU

   eRETU := NIL
   IF ValType( nLEN ) # "N"
      nLEN := 1
   ENDIF
   IF ValType( nDEC ) # "N"
      nDEC := 0
   ENDIF
   DO CASE
   CASE cTIPO = "C" .OR. cTIPO = "M"
      eRETU := spac( nLEN )
   CASE cTIPO = "D"
      eRETU := CToD( "  /  /  " )
   CASE cTIPO = "L"
      eRETU := .F.
   CASE cTIPO = "N"
      eRETU := Val( Str( 0, nLEN, nDEC ) )
   ENDCASE

   RETURN eRETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAKE_EMPTY()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKE_EMPTY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MAKE_EMPTY( eCAMPO )

   LOCAL eRETU
   LOCAL aSTRU
   LOCAL xPOSDBF
   LOCAL xPOS

   eRETU := NIL
   IF !Empty( Alias() )
      aSTRU   := dbStruct()
      nPOSDBF := 0
      FOR XPOS := 1 TO Len( aSTRU )
         IF Upper( AllTrim( aSTRU[ XPOS, 1 ] ) ) = Upper( AllTrim( eCAMPO ) )
            nPOSDBF := XPOS
         ENDIF
      NEXT
      IF nPOSDBF > 0
         eRETU := MAKEVAR( aSTRU[ nPOSDBF, 2 ], aSTRU[ nPOSDBF, 3 ], aSTRU[ nPOSDBF, 4 ] )
      ENDIF
   ENDIF
   RETU eRETU

// + EOF: DISK70.PRG

// + EOF: disk70.prg
// +
