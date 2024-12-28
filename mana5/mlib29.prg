// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib29.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// Teclas Operacionais
#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function USEREDE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION USEREDE( cARQ, nMOD, nIND, cARE, lMES, nTIME )  // Arquivo,Modo,Indices,Area,mensagem,tempo

   LOCAL cARQDIR := ""
   LOCAL aARQIND := {}
   PRIVATE X

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF ValType( cARQ ) # "C"
      @ 24, 00
      @ 24, 00 SAY "Arquivo"
      @ 24, 10 SAY cARQ
      @ 24, 50 SAY "Tipo:" + ValType( cARQ )
      ALERTX( "Funcao USEREDE, Nome do Arquivo nao e Caracter" )
      RETURN .F.
   ENDIF
   cARQ := Upper( CARQ )
   cARQ := StrTran( cARQ, ".DBF", "" )
   IF ValType( nMOD ) # "N"
      ALERTX( "Funcao USEREDE, Modo de Abertura nao e Numerico" )
      RETURN .F.
   ENDIF
   IF nMOD < 0 .OR. nMOD > 1   // 0-Exclusivo 1-Compartilhado
      ALERTX( "Funcao USEREDE, Modo de Abertura fora de parametro" )
      RETURN .F.
   ENDIF
   IF ValType( nIND ) # "N"  // 0-Nenhum n-Especifico 99-Todos
      ALERTX( "Funcao USEREDE, Indices nao e Numerico" )
      RETURN .F.
   ENDIF
   IF PCount() = 4
      IF ValType( cARE ) # "C"
         ALERTX( "Funcao USEREDE, Area nao e Caracter" )
         RETURN .F.
      ENDIF
   ENDIF
// Abrindo o Arquivo de Configura‡„o do Arquivo
   IF !USECHK( ZDIRC + ZARQ, ZDIRC + ZARQ, .T. )
      RETURN .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( cARQ )
      dbCloseArea()
      IF lMES
         ALERTX( "Falta configuracao do Arquivo de Dados " + cARQ )
      ENDIF
      RETURN .F.
   ENDIF

// Carrega o Diret¢rio do Arquivo
   cARQDIR := LOCALARQ( PADRAO, CAMINHO )

// Carrega o Driver
   cDRIVER := DRIVER
   dbCloseArea()
   IF Empty( cDRIVER )
      cDRIVER := "DBFCDX"
   ENDIF
// Verifica a existencia do Arquivo
   IF !File( cARQDIR + cARQ + ".DBF" )
      IF lMES
         ALERTX( "O Sistema nAo Encontrou o Arquivo " + cARQ )
      ENDIF
      RETURN .F.
   ENDIF
// Carrega Indices
   IF nIND > 0
      IF cDRIVER = "DBFCDX"  // somente um elemento aARQIND com o mesmo nome do arquivo
         AAdd( aARQIND, cARQ )  // Mesmo Nome do Arquivo
      ELSE   // ntx pega e adiciona na aarqind
         // Abrindo o Arquivo de Configura‡„o de Indexacao
         IF !USECHK( ZDIRC + ZARQ1, ZDIRC + ZARQ1, .T. )
            RETURN .F.
         ENDIF
         dbGoTop()
         IF nIND = 99
            IF !dbSeek( PadR( cARQ, 8 ) + Str( 1, 2 ) )
               dbCloseArea()
               ALERTX( "Falta configuracao Indexacao " + cARQ + Str( 1, 2 ) )
               RETURN .F.
            ENDIF
            WHILE PadR( cARQ, 8 ) = ARQUIVO .AND. !Eof()
               AAdd( aARQIND, INDICE )
               dbSkip()
            ENDDO
         ELSE
            IF !dbSeek( PadR( cARQ, 8 ) + Str( nIND, 2 ) )
               dbCloseArea()
               ALERTX( "Falta configuracao Indexacao " + cARQ + Str( nIND, 2 ) )
               RETURN .F.
            ENDIF
            AAdd( aARQIND, INDICE )
         ENDIF
         dbCloseArea()
      ENDIF
   ENDIF
// Verifica a Existencia dos Indices
   IF nIND > 0
      FOR X := 1 TO Len( aARQIND )
         IF !File( cARQDIR + aARQIND[ X ] + if( cDRIVER = "DBFCDX", ".CDX", ".NTX" ) )
            ALERTX( "Falta arquivo de Indice: " + aARQIND[ X ] + " de " + cARQ )
            IF MDG( "Indexar " + cARQ )
               M_DB( "ARQUIVO='" + cARQ + "'" )
            ENDIF
            RETURN .F.
         ENDIF
      NEXT X
   ENDIF
// Inicia Abertura dos Arquivos
   IF SELECT ( cARQ ) # 0  // Evita Reabertura
      dbSelectAr( cARQ )
      dbCloseArea()
   ENDIF
   WHILE .T.
      lNEW := .T.
      IF ValType( cARE ) = "C"
         SELE ( cARE )
         lNEW := .F.
      ENDIF
      lSHARE := if( nMOD = 1, .T., .F. )
      IF useCHK( cARQDIR + cARQ,, lSHARE, cDRIVER, lNEW, nTIME )
         EXIT
      ENDIF
   ENDDO
   IF nIND = 0
      RETURN .T.
   ENDIF
   FOR X := 1 TO Len( aARQIND )
      WHILE .T.
         IF cDRIVER = "DBFCDX"
            ordListAdd( cARQDIR + aARQIND[ X ] )
         ELSE
            dbSetIndex( cARQDIR + aARQIND[ X ] )
         ENDIF
         IF !NetErr()
            EXIT
         ENDIF
         KEY := Inkey( .5 )
         IF KEY = K_ESC
            dbCloseArea()
            RETURN .F.
         ENDIF
         MDS( "Nao Estou Conseguindo Abrir indice " + aARQIND[ X ] )
      ENDDO
   NEXT X
   IF cDRIVER = "DBFCDX" .AND. nIND # 99
      dbSetOrder( nIND )
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function USECHK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION USECHK( cARQ, cIND, lSHA, cDRIVER, lNEW, nTIME, lMES )

   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF
   IF ValType( cDRIVER ) # "C" .OR. Empty( cDRIVER )
      cDRIVER := IF( cRDDEXT = "CDX" .OR. Empty( CRDDEXT ), "DBFCDX", "DBFNTX" )
   ELSE
      cDRIVER := AllTrim( cDRIVER )
   ENDIF
   IF ValType( lNEW ) # "L"
      lNEW := .T.
   ENDIF
   IF ValType( nTIME ) # "N"
      nTIME := -1
   ENDIF
   IF !File( cARQ + ".DBF" )
      IF lMES
         ALERTX( "Falta Arquivo: " + Carq )
      ELSE
         MDT( "Falta Arquivo: " + Carq )
      ENDIF
      RETURN .F.
   ENDIF
   WHILE .T.
      // DBUSEAREA( [<lNewArea>], [<cDriver>], <cName>, [<xcAlias>],[<lShared>], [<lReadonly>])
      // dbusearea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )

      dbUseArea( lNEW, cDRIVER, cARQ,, lSHA, .F. )
      IF !NetErr()
         EXIT
      ENDIF
      IF nTIME > 0
         nTIME := nTIME - 1
      ENDIF
      IF nTIME = 0
         RETURN .F.
      ENDIF
      // -1 nao faz nada
      IF nTIME = -2
         IF !MDG( "Deseja Retentar" )
            RETURN .F.
         ENDIF
      ENDIF
      MDS( "Nao Estou Conseguindo Abrir aquivo " + cARQ )
      KEY := Inkey( 1 )
      IF KEY = K_ESC
         RETURN .F.
      ENDIF
   ENDDO
   IF ValType( cIND ) = "C"
      IF cDRIVER = "DBFCDX"
         ordListAdd( cIND )
      ELSE
         dbSetIndex( cIND )
      ENDIF
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LOCALARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION LOCALARQ( cPADRAO, cCAMINHO )

   cARQDIR := ZDIRP
   DO CASE
   CASE cPADRAO = 'S'
      cARQDIR := ZDIRE
   CASE cPADRAO = 'N'
      cARQDIR := ZDIRP
   CASE cPADRAO = 'C'
      cARQDIR := ZDIRC
   CASE cPADRAO = 'I'
      cARQDIR := ZDIRI
   CASE cPADRAO = 'A'
      cARQDIR := ZDIRA
   CASE cPADRAO = 'B'
      cARQDIR := ZDIRB
   CASE cPADRAO = "X"
      cARQDIR := AllTrim( cCAMINHO )
   OTHERWISE
      cARQDIR := ZDIRP
   ENDCASE

   RETURN cARQDIR

// + EOF: mlib29.prg
// +
