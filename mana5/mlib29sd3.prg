// +--------------------------------------------------------------------
// +
// +    Programa  : mlib29.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024-2026,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +--------------------------------------------------------------------

// Teclas Operacionais
#include "INKEY.CH"
#include "dbinfo.ch"
#include "try.ch"
#include "ads.ch"

REQUEST ADSADT
#ifdef USE_PXRDD
    REQUEST PXRDD   // Carrega a RDD do Paradox criada acima
#endif


// +--------------------------------------------------------------------
// +    Function USEREDE()
// +--------------------------------------------------------------------
FUNCTION USEREDE( cARQ, nMOD, nIND, cARE, lMES, nTIME, lOPENCON )  // Arquivo,Modo,Indices,Area,mensagem,tempo,abrirConexao

   LOCAL cARQDIR := ""
   LOCAL aARQIND := {}
   LOCAL cTableExt, cOrdExt
   LOCAL cDbPath, cTableName, nPosCol
   LOCAL cOldRdd := RddSetDefault()  // Salva a RDD padrão atual
   PRIVATE X
   LOCAL cPADRAO
   LOCAL cCAMINHO

   // Obtem as extensoes dinamicamente via hb_rddInfo com Try/Catch e fallbacks
   TRY
      cTableExt := hb_rddInfo( RDDI_TABLEEXT )
      cTableExt := strtran(cTableExt,".","")
   CATCH
      cTableExt := ""
   END

   IF Empty( cTableExt )
      cTableExt := "dbf"
   ENDIF

   TRY
      cOrdExt := hb_rddInfo( RDDI_ORDBAGEXT )
      cOrdExt := strtran(cOrdExt,".","")
   CATCH
      cOrdExt := ""
   END

   IF Empty( cOrdExt )
      cOrdExt := "cdx"
   ENDIF

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF

   IF ValType( lOPENCON ) # "L"
      lOPENCON := .F.
   ENDIF

   IF ValType( cARQ ) # "C"
      @ 24, 00
      @ 24, 00 SAY "Arquivo"
      @ 24, 10 SAY cARQ
      @ 24, 50 SAY "Tipo:" + ValType( cARQ )
      ALERTX( "Funcao USEREDE, Nome do Arquivo nao e Caracter" )
      RddSetDefault( cOldRdd )
      RETURN .F.
   ENDIF

  // Abrindo o Arquivo de Configuracao do Arquivo
   IF !USECHK( ZDIRC + ZARQ, ZDIRC + ZARQ, .T. )
      RddSetDefault( cOldRdd )
      RETURN .F.
   ENDIF

   dbGoTop()
   IF !dbSeek( cTableName )
      dbCloseArea()
      IF lMES
         ALERTX( "Falta configuracao do Arquivo de Dados " + cTableName )
      ENDIF
      RddSetDefault( cOldRdd )
      RETURN .F.
   ENDIF

   // Carrega o Diretorio do Arquivo
   cARQDIR := LOCALARQ( PADRAO, CAMINHO )
   dbCloseArea()


   // Tratamento para SL3RDD recebendo no formato caminho:tabela
   nPosCol := At( ":", cARQ )
   IF nPosCol > 0
      cDbPath    := SubStr( cARQ, 1, nPosCol - 1 )
      cTableName := SubStr( cARQ, nPosCol + 1 )
   ELSE
      cTableName := Upper( cARQ )
      cTableName := StrTran( cTableName, "." + Upper( cTableExt ), "" )
      cTableName := StrTran( cTableName, ".DBF", "" )
   ENDIF

   IF ValType( nMOD ) # "N"
      ALERTX( "Funcao USEREDE, Modo de Abertura nao e Numerico" )
      RddSetDefault( cOldRdd )
      RETURN .F.
   ENDIF

   IF nMOD < 0 .OR. nMOD > 1   // 0-Exclusivo 1-Compartilhado
      ALERTX( "Funcao USEREDE, Modo de Abertura fora de parametro" )
      RddSetDefault( cOldRdd )
      RETURN .F.
   ENDIF

   // Carrega o Driver previamente com tratativa robusta via CASE
   cDRIVER := DRIVER
   IF ValType( cDRIVER ) # "C" .OR. Empty( cDRIVER )
      DO CASE
      CASE Upper( cTableExt ) == "SQLITE" .OR. "SL3" $ Upper( cTableExt )
         cDRIVER := "SL3RDD"
      CASE Upper( cTableExt ) == "ADT"
         cDRIVER := "ADSADT"
      #ifdef USE_PXRDD
      CASE Upper( cTableExt ) == "DB"
         cDRIVER := "PXRDD"
      #endif
      OTHERWISE
         cDRIVER :=  "DBFCDX"
      ENDCASE
   ELSE
      cDRIVER := AllTrim( cDRIVER )
   ENDIF

   // Se o driver for ADSADT, configura as definições do Advantage e altera o RddSetDefault
   IF cDRIVER == "ADSADT"
      AdsSetServerType( ADS_LOCAL_SERVER )
      AdsSetFileType( ADS_ADT )
      RddSetDefault( "ADSADT" )
   ENDIF

   // Valida nIND apenas se nao for SL3RDD ou PXRDD
   IF cDRIVER <> "SL3RDD" .AND. cDRIVER <> "PXRDD"
      IF ValType( nIND ) # "N"
         ALERTX( "Funcao USEREDE, Indices nao e Numerico" )
         RddSetDefault( cOldRdd )
         RETURN .F.
      ENDIF
   ENDIF

   IF PCount() = 4
      IF ValType( cARE ) # "C"
         ALERTX( "Funcao USEREDE, Area nao e Caracter" )
         RddSetDefault( cOldRdd )
         RETURN .F.
      ENDIF
   ENDIF

   

   // Se for SL3RDD e lOPENCON for verdadeiro, conecta na base e usa o nome da tabela
   IF cDRIVER == "SL3RDD" .AND. lOPENCON .AND. !Empty( cDbPath )
      DBSL3CONNECTION( cDbPath, .T. )
      cARQ := cTableName
   ELSE
      // Verifica a existencia do Arquivo padrao se nao for SL3RDD
      IF cDRIVER # "SL3RDD"
         IF !File( cARQDIR + cTableName + "." + cTableExt )
            IF lMES
               ALERTX( "O Sistema nao Encontrou o Arquivo " + cTableName )
            ENDIF
            RddSetDefault( cOldRdd )
            RETURN .F.
         ENDIF
      ENDIF
      cARQ := cARQDIR + cTableName
   ENDIF

   // Carrega Indices (Ignora se for SL3RDD ou PXRDD)
   IF nIND > 0 .AND. cDRIVER <> "SL3RDD" .AND. cDRIVER <> "PXRDD"
      IF cDRIVER = "DBFCDX"  // somente um elemento aARQIND com o mesmo nome do arquivo
         AAdd( aARQIND, cTableName )  // Mesmo Nome do Arquivo
      ELSE   // ntx pega e adiciona na aarqind
         // Abrindo o Arquivo de Configuracao de Indexacao
         IF !USECHK( ZDIRC + ZARQ1, ZDIRC + ZARQ1, .T. )
            RddSetDefault( cOldRdd )
            RETURN .F.
         ENDIF
         dbGoTop()
         IF nIND = 99
            IF !dbSeek( PadR( cTableName, 8 ) + Str( 1, 2 ) )
               dbCloseArea()
               ALERTX( "Falta configuracao Indexacao " + cTableName + Str( 1, 2 ) )
               RddSetDefault( cOldRdd )
               RETURN .F.
            ENDIF
            WHILE PadR( cTableName, 8 ) = ARQUIVO .AND. !Eof()
               AAdd( aARQIND, INDICE )
               dbSkip()
            ENDDO
         ELSE
            IF !dbSeek( PadR( cTableName, 8 ) + Str( nIND, 2 ) )
               dbCloseArea()
               ALERTX( "Falta configuracao Indexacao " + cTableName + Str( nIND, 2 ) )
               RddSetDefault( cOldRdd )
               RETURN .F.
            ENDIF
            AAdd( aARQIND, INDICE )
         ENDIF
         dbCloseArea()
      ENDIF
   ENDIF

   // Verifica a Existencia dos Indices (Ignora se for SL3RDD ou PXRDD)
   IF nIND > 0 .AND. cDRIVER <> "SL3RDD" .AND. cDRIVER <> "PXRDD"
      FOR X := 1 TO Len( aARQIND )
         IF !File( cARQDIR + aARQIND[ X ] + if( cDRIVER = "DBFCDX", "." + cOrdExt, ".NTX" ) )
            ALERTX( "Falta arquivo de Indice: " + aARQIND[ X ] + " de " + cTableName )
            IF MDG( "Indexar " + cTableName )
               M_DB( "ARQUIVO='" + cTableName + "'" )
            ENDIF
            RddSetDefault( cOldRdd )
            RETURN .F.
         ENDIF
      NEXT X
   ENDIF

   // Inicia Abertura dos Arquivos
   IF SELECT( cTableName ) # 0  // Evita Reabertura
      dbSelectAr( cTableName )
      dbCloseArea()
   ENDIF

   WHILE .T.
      lNEW := .T.
      IF ValType( cARE ) = "C"
         SELE ( cARE )
         lNEW := .F.
      ENDIF
      lSHARE := if( nMOD = 1, .T., .F. )
      
      // Repassando lOPENCON para a USECHK
      IF USECHK( cARQ, , lSHARE, cDRIVER, lNEW, nTIME, lMES, lOPENCON )
         EXIT
      ENDIF
   ENDDO

   IF nIND = 0 .OR. cDRIVER == "SL3RDD" .OR. cDRIVER == "PXRDD"
      RddSetDefault( cOldRdd )
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
            RddSetDefault( cOldRdd )
            RETURN .F.
         ENDIF
         MDS( "Nao Estou Conseguindo Abrir indice " + aARQIND[ X ] )
      ENDDO
   NEXT X

   IF cDRIVER = "DBFCDX" .AND. nIND # 99
      dbSetOrder( nIND )
   ENDIF

   RddSetDefault( cOldRdd )  // Restaura a RDD original antes de concluir com sucesso

   RETURN .T.

// +--------------------------------------------------------------------
// +    Function USECHK()
// +--------------------------------------------------------------------
FUNCTION USECHK( cARQ, cIND, lSHA, cDRIVER, lNEW, nTIME, lMES, lOPENCON )

   LOCAL cTableExt, cOrdExt
   LOCAL cDbfFile
   LOCAL cEXT
   LOCAL cOldRdd := RddSetDefault()  // Salva a RDD padrão atual

   TRY
      cTableExt := hb_rddInfo( RDDI_TABLEEXT )
      cTableExt := strtran(cTableExt,".","")
   CATCH
      cTableExt := ""
   END

   IF Empty( cTableExt )
      cTableExt := "dbf"
   ENDIF

   TRY
      cOrdExt := hb_rddInfo( RDDI_ORDBAGEXT )
      cOrdExt := strtran(cOrdExt,".","")
   CATCH
      cOrdExt := ""
   END

   IF Empty( cOrdExt )
      cOrdExt := "cdx"
   ENDIF

   cEXT := StrTran( Upper( cTableExt ), ".", "" )

   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF

   IF ValType( lOPENCON ) <> "L"
      lOPENCON := .F.
   ENDIF

   IF ValType( cDRIVER ) # "C" .OR. Empty( cDRIVER )
      DO CASE
      CASE cEXT == "SQLITE" .OR. "SL3" $ Upper( cTableExt )
         cDRIVER := "SL3RDD"
      CASE cEXT == "ADT"
         cDRIVER := "ADSADT"
      #ifdef USE_PXRDD
      CASE cEXT == "DB"
         cDRIVER := "PXRDD"
      #endif
      OTHERWISE
         cDRIVER := "DBFCDX"
      ENDCASE
   ELSE
      cDRIVER := AllTrim( cDRIVER )
   ENDIF

   // Se o driver for ADSADT, configura o Advantage e ajusta o RddSetDefault
   IF cDRIVER == "ADSADT"
      AdsSetServerType( ADS_LOCAL_SERVER )
      AdsSetFileType( ADS_ADT )
      RddSetDefault( "ADSADT" )
   ENDIF

   IF ValType( lNEW ) # "L"
      lNEW := .T.
   ENDIF

   IF ValType( nTIME ) # "N"
      nTIME := -1
   ENDIF

   // Evita duplicar a extensao caso ela ja venha inclusa no nome
   IF Lower( Right( cARQ, Len( cTableExt ) + 1 ) ) != "." + Lower( cTableExt )
      cDbfFile := cARQ + "." + cTableExt
   ELSE
      cDbfFile := cARQ
   ENDIF

   IF cDRIVER # "SL3RDD" .AND. cDRIVER # "PXRDD" .AND. !File( cDbfFile ) .AND. !File( cARQ )
      IF lMES
         ALERTX( "Falta Arquivo: " + cARQ )
      ELSE
         MDT( "Falta Arquivo: " + cARQ )
      ENDIF
      RddSetDefault( cOldRdd )  // Restaura a RDD original antes de sair
      RETURN .F.
   ENDIF

   WHILE .T.
      dbUseArea( lNEW, cDRIVER, cARQ, , lSHA, .F. )
      IF !NetErr()
         EXIT
      ENDIF

      IF nTIME > 0
         nTIME := nTIME - 1
      ENDIF

      IF nTIME = 0
         RddSetDefault( cOldRdd )  // Restaura a RDD original antes de sair
         RETURN .F.
      ENDIF

      IF nTIME = -2
         IF !MDG( "Deseja Retentar" )
            RddSetDefault( cOldRdd )  // Restaura a RDD original antes de sair
            RETURN .F.
         ENDIF
      ENDIF

      MDS( "Nao Estou Conseguindo Abrir arquivo " + cARQ )
      KEY := Inkey( 1 )
      IF KEY = K_ESC
         RddSetDefault( cOldRdd )  // Restaura a RDD original antes de sair
         RETURN .F.
      ENDIF
   ENDDO

   // Abre indices apenas se nao for SL3RDD ou PXRDD
   IF ValType( cIND ) = "C" .AND. cDRIVER <> "SL3RDD" .AND. cDRIVER <> "PXRDD"
      IF cDRIVER = "DBFCDX"
         ordListAdd( cIND )
      ELSE
         dbSetIndex( cIND )
      ENDIF
   ENDIF

   RddSetDefault( cOldRdd )  // Restaura a RDD original ao concluir com sucesso

   RETURN .T.

// +--------------------------------------------------------------------
// +    Function LOCALARQ()
// +--------------------------------------------------------------------
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
   
FUNCTION MARQSLITE( cARQ,cPADRAO, cCAMINHO )

   cARQDIR := ZDIRP
   DO CASE
   CASE cPADRAO = 'S'
      cARQDIR := "mana5_emp.sqlite"
   CASE cPADRAO = 'N'
      cARQDIR := "mana5.sqlite"
   CASE cPADRAO = 'C'
      cARQDIR := "mana5_configur.sqlite"
   CASE cPADRAO = 'I'
      cARQDIR := ""
   CASE cPADRAO = 'A'
      cARQDIR := ""
   CASE cPADRAO = 'B'
      cARQDIR :=  ""
   CASE cPADRAO = "X"
      cARQDIR := AllTrim( cCAMINHO )
   OTHERWISE
      cARQDIR := "mana5.sqlite"
   ENDCASE

   RETURN cARQDIR


// + EOF: mlib29.prg