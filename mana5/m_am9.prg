// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_am9.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_am9()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_am9

   PARA cARQ

   mESTADO := "  "
   ZESTADO := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
   ARQUSO  := ""
   xDAT01  := CToD( Space( 8 ) )
   CRIARVARS( "ML01" )

   PADRAO( 0, 1, 0, cARQ, "Lote  Nota Fiscal  Data     Cliente/Fornecedor CFO   CodRec Valor", ;
      "' '+STR(mLOTE,5)+' '+STR(mNUMERO,8)+' '+STR(mITEM,3)+' '+DTOC(mDATA)+' '+STR(mFORNECEDO,5)+' '+mCOGNOME+' '+mDCFONEW+' '+mCODREC+' '+STR(mDVALORNF,15,2)", ;
      "M9",,, {|| ULTIMOREG( cARQ, "LOTE", "mLOTE" ) } ;
      ,,, {|| M9POSIGU() },,, {|| M9POSREP() } )





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M9POSIGU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M9POSIGU

// ALERTX("EQU")
   xDAT01 := mDAT01
   RETU .F.  // Para Continuar



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M9POSREP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M9POSREP

// ALERTX("REP")
   IF cARQ = "MK09"
      CPAGA := if( INCLUI, OBTER( "MD04", mDCFONEW, "CONTAS", 2,,,,, "S" ), "N" )
      @ 24, 00 clea
      @ 24, 05 SAY "Transfere Dados para o Contas a Pagar <S/N> ?  " GET CPAGA PICT '@!' VALID CPAGA $ 'SN'
      READCUR()
      IF cPAGA = "S"
         mNRNOTA    := mNUMERO
         mVENCIMENT := mDAT01
         mTIPOCLI   := mTIPOFOR
         mVALOR     := mVAL01
         mVALATUAL  := mVAL01
         mCOD       := mCODDEP
         mTIPFAT    := " "
         // Evita Conflito mesmo Campo
         mSITUACAO := 0
         // Apaga o Da Data Antiga Evitar Erro
         APAGAREG( "ML01", DToS( xDAT01 ) + Str( mNRNOTA, 8 ) + mTIPFAT, .F. )
         APAGAREG( "ML01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT, .F. )
         NOVOREG( "ML01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MM09IMP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MM09IMP( cTIPO )

   MDI( " Ý Importando Notas" )
   IF cTIPO = "E"
      aRETU := PERFEC( { "MK01" }, { "K1" }, { "MK91" }, { "DATAREF" } )
   ELSE
      aRETU := PERFEC( { "MM01" }, { "M1" }, { "MM91" }, { "DATAREF" } )
   ENDIF
   nMESUSO := aRETU[ 1 ]
   nANOUSO := aRETU[ 2 ]
   cARQ    := aRETU[ 5, 1 ]
   IF cTIPO = "E"
      cDES := "MK09"
   ELSE
      cDES := "MM09"
   ENDIF
   IF !USEMULT( { { cDES, 1, 99 }, { cARQ, 1, 0 }, { "MB01", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( cDES )
   INITVARS()
   CLRVARS()
   dbSelectAr( cARQ )
   INITVARS()
   CLRVARS()
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cTIPO = "E"
      ordDestroy( "temp" )
      ordCreate(, "temp", "dataref" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "data" )
      ordSetFocus( "temp" )
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      IF ESPECIE = "NFS"
         EQUVARS()
         mESPECIE := ""
         mSERIE   := ""
         mCODREC  := ""
         IF mTIPOCLI = "F"
            dbSelectAr( "MB01" )
            dbGoTop()
            IF dbSeek( mFORNECEDO )
               mESPECIE := NFSESP
               mSERIE   := NFSSER
               mCODREC  := NFSCOD
            ENDIF
         ENDIF
         IF cTIPO = "E"
            mNUMERO := mNRNOTA
         ENDIF
         dbSelectAr( cDES )
         dbGoTop()
         IF !dbSeek( Str( mNUMERO, 8 ) + Str( mFORNECEDO, 8 ) )
            mITEM     := 1
            mSITUACAO := 'T'
            IF cTIPO = "E"
               mNUMERO := mNRNOTA
            ENDIF
            IF cTIPO = "S"
               mDATAREF := mDATA
               mORDEM   := mNUMERO
            ENDIF
            mDVALORNF := mTOTNF
            mTIPOFOR  := mTIPOCLI
            mDCFONEW  := mCFONEW
            // mDBASEICM := mTOTBICM
            mDICM    := mICM
            mDVALICM := mTOTICM
            PEGLOTE( IF( cTIPO = "E", 5, 6 ), mDATAREF, "mLOTE" )
            IF cTIPO = "E"
               mORDEM := mLOTE
            ENDIF
            NOVOOPA( cDES )
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbCloseAll()
   RELEASE ALL LIKE m *



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MM09DES()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MM09DES( cTIPO, cLAY )

   IF ValType( cTIPO ) # "C"
      cTIPO := "S"
   ENDIF
   IF ValType( cLAY ) # "C"
      cLAY := "SP"
      IF MDG( "SIM=GIS NAO=SP" )
         cLAY := "GIS"
      ENDIF
   ENDIF
   SET CENTURY ON
   ARQ := "C:\TEMP\DES.TXT" + Space( 40 )
   MDS( "Confirme o Arquivo" )
   @ 24, 20 GET ARQ
   IF !READCUR()
      RETU .F.
   ENDIF
   IF cTIPO = "E"
      aRETU := PERFEC( { "MK01", "MK09" }, { "K1", "K9" }, { "MK91", "MK90" } )
   ELSE
      aRETU := PERFEC( { "MM01", "MM09" }, { "M1", "M9" }, { "MM91", "MM90" } )
   ENDIF
   nMES         := aRETU[ 1 ]
   nANO         := aRETU[ 2 ]
   ARQWORK1     := aRETU[ 5, 1 ]
   ARQWORK2     := aRETU[ 5, 2 ]
   mCOMPETENCIA := aRETU[ 7 ]
   mCGCUSO      := TIRAOUT( OBTER( "MANEMP", ZNUMERO, "CGC" ) )

   IF !USEMULT( { { ARQWORK1, 1, 1 }, { ARQWORK2, 1, 0 }, { "MA01", 1, 1 }, { "MB01", 1, 1 } } )
      RETU .F.
   ENDIF


   USO := FCreate( ARQ )
   IF FError() # 0
      ALERTX( "Erro na Cria‡„o do Arquivo" )
      RETU
   ENDIF


   dbSelectAr( arqwork2 )
   dbGoTop()
   WHILE !Eof()
      xFORNECEDO := FORNECEDO
      mCGCFORN   := ""
      mCIDADE    := ""
      mUF        := ""
      mTIPOFOR   := TIPOFOR
      mPESSOA    := " "
      mNOME      := ""
      mCCM       := ""
      mIE        := ""
      mCEP       := ""
      mEND       := ""
      mBAI       := ""
      dbSelectAr( if( mTIPOFOR = "C", "MA01", "MB01" ) )
      dbGoTop()
      IF dbSeek( xFORNECEDO )
         mCCM    := AllTrim( IMUNICIPI )
         mCIDADE := TIRACE( CIDADE )
         mUF     := ESTADO
         mPESSOA := PESSOA
         mNOME   := TIRACE( NOME )
         mCEP    := CEP
         mEND    := TIRACE( ENDERECO )
         mBAI    := TIRACE( BAIRRO )
         mIE     := if( mTIPOFOR = "C", INSCR, IESTADUAL )
         IF PESSOA = "F"
            mCGCFORN := "000" + AllTrim( TIRAOUT( CGC ) )
            IF !VALCPF( CGC )
               ALERTX( Str( xFORNECEDO, 8 ) + " " + CGC )
            ENDIF
         ELSE
            IF !VALCGC( CGC,,, mUF )
               ALERTX( Str( xFORNECEDO, 8 ) + " " + CGC )
            ENDIF
            mCGCFORN := AllTrim( TIRAOUT( CGC ) )
         ENDIF
      ELSE
         ALERTX( Str( xFORNECEDO, 8 ) + " Nao Encontrado" )
      ENDIF
      mCGCFORN := StrZero( Val( mCGCFORN ), 14 )  // Possiveis Erros de Tipo
      dbSelectAr( ARQWORK2 )
      cESPECIE := PadR( especie, 5 )
      IF cLAY = "SP"
         IF Empty( cESPECIE )
            IF mCIDADE = "SAO PAULO"
               cESPECIE := "NFS  "
            ELSE
               cESPECIE := "FORA "
            ENDIF
         ENDIF
         IF cESPECIE = "NFS  " .AND. mCIDADE = "SAO PAULO" .AND. SERIE = "UN"
            ALERTX( "Verificar NF: " + Str( NUMERO, 8 ) + "SAO PAULO NFS UN" )
         ENDIF
         FWrite( USO, mCGCUSO )   // 1-cgc
         FWrite( USO, cESPECIE )  // 2-especie tipo NFS,RPA....
         IF Empty( SERIE )
            FWrite( USO, PadR( "-", 5 ) )  // 3-serie
         ELSE
            FWrite( USO, PadR( serie, 5 ) )
         ENDIF
         FWrite( USO, StrZero( numero, 8 ) )   // 4-numero
         FWrite( USO, DToC( dataref ) )   // 5-data
         FWrite( USO, GRVVAL( DVALORNF, 15, 2 ) )   // 6-valor do documento
         FWrite( USO, StrZero( Val( codrec ), 5 ) )  // 7-codigo recolhimento
         FWrite( USO, GRVVAL( DBASEICM, 15, 2 ) )   // 8-valor da base ICM = ISS
         FWrite( USO, mCGCFORN )  // 9 cgc do tomador
         FWrite( USO, mUF )   // 10 UF
         FWrite( USO, PadR( mCIDADE, 50 ) )  // 11 CIDADE
         FWrite( USO, PadR( TIRACE( OBS ), 200 ) )   // 12 OBS
         FWrite( USO, Chr( 13 ) + Chr( 10 ) )
      ENDIF
      IF cLAY = "GIS"
         FWrite( USO, "T" )   // 1
         FWrite( USO, StrZero( numero, 10 ) )  // 2
         FWrite( USO, PadR( serie, 10 ) )  // 3
         FWrite( USO, DToC( dataref ) )   // 4
         FWrite( USO, SITUACAO )  // 5 1-NORMAL 4-ISENTA 3-ANULADA 5-RETIDA
         FWrite( USO, GRVVAL( DVALORNF, 12, 2 ) )   // 6
         FWrite( USO, PadR( codrec, 10 ) )   // 7
         IF mPESSOA = "F"
            FWrite( USO, "1" )  // 8
         ELSE
            FWrite( USO, "2" )  // 8
         ENDIF
         FWrite( USO, "S" )   // 9
         FWrite( USO, PadR( mNOME, 100 ) )   // 10
         mDIG := "  "
         nLEN := Len( mCCM )
         IF nLEN > 0
            IF SubStr( mCCM, nLEN - 2, 1 ) = "-"
               mDIG := SubStr( mCCM, nLEN - 1 )
               mCCM := SubStr( mCCM, 1, nLEN - 2 )
            ENDIF
            IF SubStr( mCCM, nLEN - 1, 1 ) = "-"
               mDIG := "0" + SubStr( mCCM, nLEN )
               mCCM := SubStr( mCCM, 1, nLEN - 1 )
            ENDIF
         ENDIF
         FWrite( USO, StrZero( Val( TIRAOUT( mCCM ) ), 10 ) )  // 11 Imunicipi
         FWrite( USO, mDIG )  // 12 digito
         FWrite( USO, mCGCFORN )  // 13
         IF mIE = "ISENTO"
            FWrite( USO, "S" )  // 14
            FWrite( USO, repl( "0", 15 ) )   // 15
         ELSE
            FWrite( USO, "N" )  // 14
            FWrite( USO, StrZero( Val( TIRAOUT( mIE ) ), 15 ) )  // 15
         ENDIF
         FWrite( USO, StrZero( Val( TIRAOUT( mCEP ) ), 8 ) )   // 16
         FWrite( USO, Space( 5 ) )  // 17
         FWrite( USO, Space( 5 ) )  // 18
         FWrite( USO, PadR( mEND, 50 ) )   // 19
         FWrite( USO, Space( 40 ) )   // 20
         FWrite( USO, Space( 10 ) )   // 21
         FWrite( USO, PadR( mBAI, 50 ) )   // 22
         FWrite( USO, mUF )   // 23
         FWrite( USO, PadR( mCIDADE, 50 ) )  // 24
         FWrite( USO, "D" )   // 25
         FWrite( USO, " " )   // 26
         FWrite( USO, Space( 10 ) )   // 27
         FWrite( USO, Chr( 13 ) + Chr( 10 ) )
      ENDIF
      dbSelectAr( ARQWORK2 )
      dbSkip()
   ENDDO
// FWRITE(USO,CHR(26))
   FClose( ARQ )
   SET CENTURY OFF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MM09VOL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MM09VOL

   MDI( " Ý Importar Gerado Des" )
   aRETU   := PERFEC( { "MK01", "MK09" }, { "K1", "K9" }, { "MK91", "MK99" }, { "DATAREF", "DATAREF" } )
   nMESUSO := aRETU[ 1 ]
   nANOUSO := aRETU[ 2 ]
   cARQNF  := aRETU[ 5, 1 ]
   cARQ    := aRETU[ 5, 2 ]

   cARQUIVO := "C:\TEMP\DES.TXT" + Space( 40 )
   @ 24, 00 GET cARQUIVO
   IF !READCUR()
      RETU .F.
   ENDIF
   cARQUIVO := AllTrim( CARQUIVO )
   IF !File( cARQUIVO )
      ALERTX( "Arquivo Des NÆo Encontrado" )
      RETU .F.
   ENDIF


   IF !USEMULT( { { cARQ, 1, 99 }, { cARQNF, 1, 99 }, { "MB01", 1, ZIMB }, { "MA01", 1, ZIMA } } )
      RETU .F.
   ENDIF

   dbSelectAr( cARQ )
   INITVARS()
   CLRVARS()
   nHANDLE := hb_fopen( cARQUIVO )
   IF nHANDLE <= 0
      dbCloseAll()
      ALERTX( "Erro Abrindo " + Carquivo )
      RETU .F.
   ENDIF


   WHILE .T.
      cVAR := FREADLINE( nHANDLE )
      @ 23, 00 SAY cVAR
      IF cVAR = "__FINAL__"
         EXIT
      ENDIF
      mITEM     := 1
      mSITUACAO := 'T'
      mESPECIE  := SubStr( cVAR, 15, 5 )
      mSERIE    := SubStr( cVAR, 20, 5 )
      mNUMERO   := Val( SubStr( cVAR, 25, 8 ) )
      mDATA     := CToD( SubStr( cVAR, 33, 10 ) )
      mDATAREF  := mDATA
      mDVALORNF := Val( SubStr( cVAR, 43, 15 ) ) / 100
      mCODREC   := SubStr( cVAR, 58, 5 )
      mDBASEICM := Val( SubStr( cVAR, 63, 15 ) ) / 100
      mCGC      := SubStr( cVAR, 78, 14 )
      IF Left( mCGC, 3 ) = "000"  // CPF
         mCGC := SubStr( mCGC, 4, 3 ) + "." + SubStr( mCGC, 7, 3 ) + "." + SubStr( mCGC, 10, 3 ) + "-" + SubStr( mCGC, 13, 2 )
      ELSE
         mCGC := Left( mCGC, 2 ) + "." + SubStr( mCGC, 3, 3 ) + "." + SubStr( mCGC, 6, 3 ) + "/" + SubStr( mCGC, 9, 4 ) + "-" + SubStr( mCGC, 13, 2 )
      ENDIF
      mFORNECEDO := 0
      mCOGNOME   := ""
      mTIPOFOR   := "F"
      mESPECIE   := ""
      mSERIE     := ""
      mCODREC    := ""
      dbSelectAr( "MB01" )
      dbGoTop()
      IF dbSeek( mCGC )
         mFORNECEDO := NUMERO
         mCOGNOME   := COGNOME
         mESPECIE   := NFSESP
         mSERIE     := NFSSER
         mCODREC    := NFSCOD
      ENDIF
      IF mFORNECEDO = 0  // Tenta Cliente
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( mCGC )
            mFORNECEDO := NUMERO
            mCOGNOME   := COGNOME
            mTIPOFOR   := "C"
         ENDIF
      ENDIF
      IF mFORNECEDO > 0
         dbSelectAr( cARQNF )
         dbGoTop()
         IF dbSeek( Str( mNUMERO, 8 ) + Str( mFORNECEDO, 5 ) )
            mDCFONEW := CFONEW
            mDATA    := DATA
         ENDIF
      ENDIF
      PEGLOTE( 5, mDATAREF, "mLOTE" )
      mORDEM := mLOTE
      NOVOOPA( cARQ )
   ENDDO
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MM09LOTE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MM09LOTE( cTIPO )

   IF cTIPO = "E"
      aRETU := PERFEC( { "MK09" }, { "K9" }, { "MK90" } )
   ELSE
      aRETU := PERFEC( { "MM09" }, { "M9" }, { "MM90" } )
   ENDIF
   nMES  := aRETU[ 1 ]
   nANO  := aRETU[ 2 ]
   cARQ  := aRETU[ 5, 1 ]
   nLOTE := 1
   IF !MDG( "Ajustar Lotes " + aRETU[ 7 ] )
      RETU .F.
   ENDIF
   IF !USEREDE( cARQ, 1, 0 )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "DATAREF" )
   ordSetFocus( "temp" )
   dbGoTop()
   WHILE !Eof()
      GRAVACAMPO( { "LOTE", "ORDEM" }, { "nLOTE", "nLOTE" } )
      nLOTE++
      dbSkip()
   ENDDO
   dbCloseAll()
   M_DB( "ARQUIVO='" + cARQ + "'" )



// + EOF: m_am9.prg
// +
