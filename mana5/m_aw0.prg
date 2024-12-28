// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aw0.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AW3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_AW3

   PARA ARQWORK

   PADRAO( 0, 1, 0, ARQWORK, "Pedido   Itp Ite Entregar Fornecedor" + spac( 12 ) + "Codigo" + spac( 7 ) + "Saldo", ;
      "' '+STR(mCOMPED,8)+' '+STR(mITEM,3)+' '+STR(mITEENT,  3)+' '+DTOC(mDATENT)+' '+STR(mCOMFOR,8)+' '+mCOMCOG+' '+mITECOD+' '+STR(mQTDSAL,12,3)", ;
      "MAW3" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AWX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AWX

   mPEDIDO := 0
   mDATA01 := ZDATA
   MDS( "Pedido No. e Data" )
   @ 24, 30 GET mPEDIDO PICT "9999999"
   @ 24, 40 GET mDATA01
   IF !READCUR()
      RETU .F.
   ENDIF
   M_AWX1( mPEDIDO, mDATA01, ZUSER + ": Baixa Manual" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AWX1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AWX1

   PARA mPEDIDO, mDATA01, mOBS

   IF ValType( mOBS ) # "C"
      mOBS := ""
   ENDIF
   CRIARVARS( "MW01" )
   CRIARVARS( "MW02" )
   CRIARVARS( "MW03" )
   IF !IGUALVARS( "MW01", mPEDIDO )
      RETU .F.
   ENDIF
   mCOMDFEC  := mDATA01
   mBAIXAOBS := mOBS
   IF NOVOREG( "MW01BX", mPEDIDO )
      BXITEM( "MW02", "MW02BX", Str( mPEDIDO, 8 ), "mPEDIDO", "COMPED" )
      BXITEM( "MW03", "MW03BX", Str( mPEDIDO, 8 ), "mPEDIDO", "COMPED" )
      APAGAREG( "MW01", mPEDIDO, .F., .F. )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AW4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AW4

   PARA ARQWORK, nUSOTIP

   ZSETOR := PadR( OBTER( "MUSER", ENCODE( ZUSER ), "SETOR" ), 7 )
   DO CASE
   CASE nUSOTIP = 2 .OR. nUSOTIP = 1
      PADRAO( 0, 1, 0, ARQWORK, "No" + spac( 7 ) + "Data     Ue" + spac( 6 ) + "T Codigo" + spac( 7 ) + "Saldo      L C GRU", ;
         "' '+STR(mRECCOM,  8)+' '+DTOC(mRECDAT)+' '+mRECUE+' '+mRECTIP+' '+mRECCOD+' '+STR(mRELQTDS,12,2)+' '+mLIRER+' '+mLICER+' '+mRECGRU", ;
         "MAW4",,, {|| MAW402() }, {|| PADARR( ARQWORK, ZSETOR, "ALLTRIM(RECUE)", "ALLTRIM(ZSETOR)", 2 ) },,,,,,, {|| !ALLTRUE( ALERTX( "Somente Baixa Permitida" ) ) } )
   CASE nUSOTIP = 0
      PADRAO( 0, 1, 0, ARQWORK, "No" + spac( 7 ) + "Data     Ue" + spac( 6 ) + "T Codigo" + spac( 7 ) + "Saldo      L C GRU", ;
         "' '+STR(mRECCOM,  8)+' '+DTOC(mRECDAT)+' '+mRECUE+' '+mRECTIP+' '+mRECCOD+' '+STR(mRELQTDS,12,2)+' '+mLIRER+' '+mLICER+' '+mRECGRU", ;
         "MAW4",,, {|| MAW402() }, {|| PADARR( ARQWORK, ZSETOR, "ALLTRIM(RECUE)", "ALLTRIM(ZSETOR)", 3 ) },,,,,,, {|| !ALLTRUE( ALERTX( "Somente Baixa Permitida" ) ) } )
   OTHERWISE
      PADRAO( 0, 1, 0, ARQWORK, "No" + spac( 7 ) + "Data     Ue" + spac( 6 ) + "T Codigo" + spac( 7 ) + "Saldo      L C GRU", ;
         "' '+STR(mRECCOM,  8)+' '+DTOC(mRECDAT)+' '+mRECUE+' '+mRECTIP+' '+mRECCOD+' '+STR(mRELQTDS,12,2)+' '+mLIRER+' '+mLICER+' '+mRECGRU", ;
         "MAW4",,, {|| MAW402() },,,,,,,, {|| !ALLTRUE( ALERTX( "Somente Baixa Permitida" ) ) } )
   ENDCASE
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW402()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW402

   mRECCOM := OBTER( "MANEMP", ZNUMERO, "RECCOM" )
   mRECCOM++
   GRAVAMVAR( "MANEMP", ZNUMERO, "RECCOM", "mRECCOM" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW401()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW401

   LOCAL nITEM

   DO CASE
   CASE mRECTIP = "M"
      PEGACAMPO( "MU01", "mRECCOD", { "PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)", "CTACONTB", "UNIDADE", "APLICACAO", "ULTPRC", "CCM" }, { "mRECNOM", "mRECCTA", "mRECUND", "mRECO01", "mRECULT", "mRECCCM" } )
   CASE mRECTIP = "B"
      PEGACAMPO( "MR01", "mRECCOD", { "PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)", "CTACONTB", "UNIDADE", "APLICACAO", "ULTPRC", "CCM" }, { "mRECNOM", "mRECCTA", "mRECUND", "mRECO01", "mRECULT", "mRECCCM" } )
   CASE mRECTIP = "C"
      PEGACAMPO( "MT01", "mRECCOD", { "PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)", "CTACONTB", "UNIDADE", "APLICACAO", "ULTPRC", "CCM" }, { "mRECNOM", "mRECCTA", "mRECUND", "mRECO01", "mRECULT", "mRECCCM" } )
   CASE mRECTIP = "O"
      PEGACAMPO( "MW05", "mRECCOD", { "PADR(NOME,200)", "CTACONTB", "UNIDADE", "MW05GRU", "ESTQSAL", "ULTPRC", "CCM" }, { "mRECNOM", "mRECCTA", "mRECUND", "mRECGRU", "mRECESQ", "mRECULT", "mRECCCM" } )
   CASE mRECTIP = "R"
      PEGACAMPO( "MW07", "mRECCOD", { "PADR(NOME,200)", "CTACONTB", "UNIDADE", "MW05GRU", "ESTQSAL", "ULTPRC", "CCM" }, { "mRECNOM", "mRECCTA", "mRECUND", "mRECGRU", "mRECESQ", "mRECULT", "mRECCCM" } )
   CASE mRECTIP = "I"
      PEGACAMPO( "ME04", "mRECCOD", { "PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)", "ULTPRC" }, { "mRECNOM", "mRECULT" } )
   CASE mRECTIP = "T"
      PEGACAMPO( "MP03", "mRECCOD", { "PADR(NOM2,200)", "APLICACAO", "CCM", "ULTPRC" }, { "mRECNOM", "mRECO01", "mRECCCM", "mRECULT" } )
   ENDCASE
   mCOMF01 := mCOMF02 := mCOMF03 := 0
   mITEP01 := mITEP02 := mITEP03 := 0
   mITEU01 := mITEU02 := mITEU03 := ""
   mITED01 := mITED02 := mITED03 := CToD( Space( 8 ) )
   IF mRECTIP # "X"
      IF USEREDE( "MW08", 1, 2 )
         nITEM := 1
         dbGoTop()
         dbSeek( mRECTIP + PadR( mRECCOD, 24 ) )
         WHILE .T.
            IF mRECTIP # ITETIP .OR. AllTrim( mRECCOD ) # AllTrim( ITECOD ) .OR. Eof()
               EXIT
            ELSE
               DO CASE
               CASE nITEM = 1
                  mCOMF01 := COMFOR
                  mITEP01 := ITEPRC
                  mITEU01 := ITEUNI
                  mITED01 := DATA
               CASE nITEM = 2
                  mCOMF02 := COMFOR
                  mITEP02 := ITEPRC
                  mITEU02 := ITEUNI
                  mITED02 := DATA
               CASE nITEM = 3
                  mCOMF03 := COMFOR
                  mITEP03 := ITEPRC
                  mITEU03 := ITEUNI
                  mITED03 := DATA
               ENDCASE
            ENDIF
            dbSkip()
            nITEM++
            IF nITEM = 4
               EXIT
            ENDIF
         ENDDO
         dbCloseArea()
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW403()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW403

   LOCAL cNORMA

   aMAW403 := PEGLAY( "MEXPOR1", "MAW403" )
   aMAW413 := PEGLAY( "MEXPOR1", "MAW413" )
   CRIARVARS( "MW08" )
   CRIARVARS( "MW04" )
   CRIARVARS( "MY04" )
   CRIARVARS( "MW02" )
   WHILE .T.
      cVAR2  := 0
      cVIDE  := ""
      cOBSFO := Space( 50 )
      cOBSNF := Space( 50 )
      cOBSPR := 0
      cESTQ  := "N"
      MDI( " Ý Baixa Requisi‡Æo" )
      @ 06, 00 SAY "Requisi‡Æo :"
      @ 07, 00 SAY "Fornecedor :"
      @ 08, 00 SAY "Nota Fiscal:"
      @ 09, 00 SAY "Pre‡o      :"
      @ 10, 00 SAY "Grava Estq :"
      @ 06, 15 GET cVAR2
      @ 07, 15 GET mNUMMB01
      @ 07, 25 GET cOBSFO
      @ 08, 15 GET mNRNOTA
      @ 08, 25 GET cOBSNF
      @ 09, 15 GET cOBSPR         PICT "999999999.999999"
      @ 10, 15 GET cESTQ          VALID cESTQ $ "SN"
      IF !READCUR()
         EXIT
      ENDIF
      IF Empty( cVAR2 )
         EXIT
      ENDIF
      IF MDG( "Baixar Requisi‡„o - " + Str( cVAR2 ) )
         IF IGUALVARS( "MW04", cVAR2 )
            mOBSFO := cOBSFO
            mOBSNF := cOBSNF
            mOBSPR := cOBSPR
            IF NOVOREG( "MW04PG", cVAR2 )
               APAGAREG( "MW04", cVAR2 )
               IF cESTQ = "S"
                  GRAVAVAR2( aMAW403 )
                  mTIPOENT   := mTIPO2
                  mFORNECEDO := mNUMMB01
                  ULTIMOREG( "MY04", "NUMERO", "mNUMERO" )
                  IF NOVOREG( "MY04", mNUMERO )
                     yCODIGO   := mCODIGO
                     mOLDQTDDE := 0
                     MAK2K05( "I", "MY04E" )
                  ENDIF
               ENDIF
               GRAVAVAR2( aMAW413 )
               IF mITETIP $ "MCOITRB"
                  IF mITEPRC > 0
                     MAWULTPRC( ESTQARQ( mITETIP, 1 ), mITECOD, { mITEPRC, mITEUNI, ZDATA } )
                     IF mITETIP = "T"
                        cNORMA := AllTrim( OBTER( "MP03", mITECOD, "NORMA" ) )
                        IF !Empty( cNORMA )
                           MAWULTPRC( "ETI", cNORMA, { mITEPRC, mITEUNI, ZDATA } )
                        ENDIF
                     ENDIF
                     NOVOREG( "MW08", mITETIP + mITECOD + Str( mCOMFOR, 8 ) + DToS( mDATA ), .F., .F. )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW6A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW6A

   aPER   := PEDPER( .T. )
   mMESES := aPER[ 7 ]
   IF !aPER[ 5 ]
      RETU .F.
   ENDIF
   IF !USEREDE( "MW06", 1, 99 )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      mTIPO   := TIPO
      mCODIGO := AllTrim( CODIGO )
      mUSO    := 0
      @ 24, 00 SAY mTIPO + " " + mCODIGO + " " + StrZero( RecNo() )
      WHILE mTIPO = TIPO .AND. mCODIGO = Trim( CODIGO ) .AND. !Eof()
         CALCPER( aPER, ANO, MES, {|| mUSO := mUSO + USO } )
         dbSkip()
      ENDDO
      IF mUSO > 0
         mUSO /= mMESES
         IF mTIPO $ "MCOTR"
            GRAVAMVAR( ESTQARQ( mTIPO, 1 ), mCODIGO, "CCM", "mUSO",, .F. )
         ENDIF
      ENDIF
      dbSelectAr( "MW06" )
   ENDDO
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW6

   LOCAL aRETU

   aRETU := PEGMES( { "Y4" } )
   cARQ  := aRETU[ 5, 1 ]
   mMES  := aRETU[ 1 ]
   mANO  := aRETU[ 2 ]
   IF MDG( "Acumular Media Consumiveis" )
      IF !USEREDE( cARQ, 1, 0 )
         RETU .F.
      ENDIF
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      ordDestroy( "temp" )
      ordCreate(, "temp", "TIPO2+CODIGO" )
      ordSetFocus( "temp" )
      IF !USEREDE( "MW06", 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      dbSelectAr( cARQ )
      dbGoTop()
      WHILE !Eof()
         mTIPO   := TIPO2
         mCODIGO := CODIGO
         mUSO    := 0
         @ 24, 20 SAY mTIPO + " " + mCODIGO
         WHILE mTIPO = TIPO2 .AND. mCODIGO = CODIGO .AND. !Eof()
            @ 24, 60 SAY RecNo()
            IF TIPO1 = "S" .AND. NAOMEDIO <> "S"
               mUSO += QTDE
            ENDIF
            dbSkip()
         ENDDO
         MAW601()
         dbSelectAr( cARQ )
      ENDDO
      dbCloseAll()
   ENDIF
   IF MDG( "Acumular Media Materia Prima CRM" )
      MAW602( "M" )
   ENDIF
   IF MDG( "Acumular Media Componentes CRM" )
      MAW602( "C" )
   ENDIF
   IF MDG( "Acumular Media Terceiros/Tratamentos CRM" )
      MAW602( "T" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW602()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW602( cTIPO )

   IF !USEREDE( "CRM", 1, 0 )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "TIPOE+CBUSCA" )
   ordSetFocus( "temp" )


   IF !USEREDE( "MW06", 1, 99 )
      dbCloseAll()
      RETU .F.
   ENDIF
   mTIPO := cTIPO  // Somente Materia Prima
   dbSelectAr( "CRM" )
   dbGoTop()
   dbSeek( cTIPO )
   WHILE TIPOE = cTIPO .AND. !Eof()
      mCODIGO := AllTrim( CBUSCA )
      mUSO    := 0
      @ 24, 20 SAY mTIPO + " " + mCODIGO
      WHILE mCODIGO = AllTrim( CBUSCA ) .AND. !Eof()
         @ 24, 60 SAY RecNo()
         IF Month( DATA ) = mMES .AND. Year( DATA ) = mANO
            mUSO += QTDE
         ENDIF
         dbSkip()
      ENDDO
      MAW601()
      dbSelectAr( "CRM" )
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW601()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW601

   IF mUSO > 0
      dbSelectAr( "MW06" )
      dbGoTop()
      IF dbSeek( mTIPO + PadR( mCODIGO, 15 ) + Str( mANO, 4 ) + Str( mMES, 2 ) )
         netgrvcam( "USO", mUSO )
      ELSE
         NOVOOPA()
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW7()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW7

   mOS     := 0
   mITEM   := 0
   wQTDE   := 0
   mNUMERO := 0
   mNRNOTA := 0
   mDATA   := ZDATA
   MDS( "Pedido Item Qtde" )
   @ 24, 30 GET mOS   PICT "9999999"
   @ 24, 40 GET mITEM PICT "999"
   IF !READCUR()
      RETU .F.
   ENDIF
   wQTDE := OBTER( "MW02", Str( mOS, 8 ) + Str( mITEM, 3 ), "ITESAL" )
   @ 24, 45 GET wQTDE PICT "99999.999"
   IF !READCUR()
      RETU .F.
   ENDIF
   IF MDG( "Baixar Residuo" )
      MAY04( "R" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW8()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW8( aARQ )

   IF ValType( aARQ ) # "A"
      aRETU := PERFEC( { "MW01BX", "MW02BX", "MY04" }, { "W1", "W2", "Y4" }, { "XXXX", "XXXX", "XXXX" }, { "PADRAO", "PADRAO", "PADRAO" } )
      cARQ  := aRETU[ 5, 1 ]
      cARQ2 := aRETU[ 5, 2 ]
      cREQ  := aRETU[ 5, 3 ]
   ELSE
      cARQ  := aARQ[ 1 ]
      cARQ2 := aARQ[ 2 ]
      cREQ  := aARQ[ 3 ]
   ENDIF
   IF !USEMULT( { { cARQ, 1, 99 }, { cARQ2, 1, 99 }, { cREQ, 1, 99 } } )
      RETU
   ENDIF
   dbSelectAr( cREQ )
   dbGoTop()
   WHILE !Eof()
      IF !Empty( os ) .AND. !Empty( item )
         aDAD := { Str( OS, 8 ) + Str( ITEM, 3 ), NUMERO, NRNOTA, DATA, OS }
         dbSelectAr( cARQ2 )
         dbGoTop()
         IF dbSeek( aDAD[ 1 ] )
            netreclock()
            IF Empty( RECNUM ) .OR. RECNUM <> aDAD[ 2 ]
               field->RECNUM := aDAD[ 2 ]
            ENDIF
            IF Empty( RECNOT ) .OR. RECNOT <> aDAD[ 3 ]
               field->RECNOT := aDAD[ 3 ]
            ENDIF
            IF Empty( REQDAT ) .OR. REQDAT <> aDAD[ 4 ]
               field->REQDAT := aDAD[ 4 ]
            ENDIF
            dbUnlock()
         ENDIF
         dbSelectAr( cARQ )
         dbGoTop()
         IF dbSeek( aDAD[ 5 ] )
            IF Empty( COMDFEC )
               netgrvcam( "COMDFEC", aDAD[ 4 ] )
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( cREQ )
      dbSkip()
      @ 24, 00 SAY NUMERO
   ENDDO
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AWREA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AWREA

   MDI( "Calcular Reajuste" )
   cTIPO     := " "
   cGRUPO    := "   "
   mFORINI   := 0
   mFORFIM   := 0
   mVIGENCIA := ZDATA
   mVERIFICA := ZDATA + 365
   mPERC     := 000.0000
   @ 10, 10 SAY "Tipo:"
   @ 10, 30 SAY "Grupo:"
   @ 12, 10 SAY "Do Fornecedor:"
   @ 12, 30 SAY "Ao Fornecedor:"
   @ 14, 10 SAY "Vigencia:"
   @ 16, 10 SAY "Verificar Preco:"
   @ 18, 10 SAY "Percentual:"
   @ 10, 20 GET cTIPO
   @ 10, 40 GET cGRUPO
   @ 12, 20 GET mFORINI
   @ 12, 40 GET mFORFIM
   @ 14, 20 GET mVIGENCIA
   @ 16, 20 GET mVERIFICA
   @ 18, 20 GET mPERC
   IF !READCUR()
      RETU .F.
   ENDIF
   IF Empty( cGRUPO )
      ALERTX( "Grupo NÆo Preenchido" )
      RETU .F.
   ENDIF
   cARQ    := ESTQARQ( cTIPO, 1 )
   mINDICE := 1 + ( mPERC / 100 )

   IF !USEMULT( { { "MW01", 1, 1 }, { "MW02", 1, 1 }, { cARQ, 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MW02" )
   dbGoTop()
   WHILE !Eof()
      lAUMENTA := .F.
      IF ITETIP = cTIPO
         mPEDIDO := COMPED
         cCODIGO := AllTrim( ITECOD )
         dbSelectAr( "MW01" )
         dbGoTop()
         IF dbSeek( mPEDIDO )
            IF COMFOR >= mFORINI .AND. COMFOR <= mFORFIM
               dbSelectAr( cARQ )
               dbGoTop()
               IF dbSeek( cCODIGO )
                  IF cGRUPO = CODMW
                     lAUMENTA := .T.
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( "MW02" )
      IF lAUMENTA
         netreclock()
         field->ITEPRC   := Round( ITEPRC * mINDICE, 5 )
         field->VIGENCIA := mVIGENCIA
         field->VERIFICA := mVERIFICA
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   IF MDG( "Checar Ultimos Pre‡os" )
      MW08CHK()
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MW08CHK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MW08CHK

   MDI( "Checando Pedidos/Ultimos Pre‡os" )
   IF !USEMULT( { { "MW02", 1, 99 }, { "MW01", 1, 99 }, { "MW08", 1, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MW08" )
   INITVARS()
   CLRVARS()

   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      zei_fort()
      netgrvcam( "PEDATIVO", "N" )
      dbSkip()
   ENDDO
   dbSelectAr( "MW02" )
   INITVARS()
   CLRVARS()

   dbGoTop()
   WHILE !Eof()
      IF ITETIP <> "X"
         IF Empty( CODMW ) .AND. ITETIP = "M"
            netreclock()
            field->CODMW := OBTER( "MU01", ITECOD, "CODMW",,,,,, "" )
            dbUnlock()
         ENDIF
         dbSelectAr( "MW02" )
         EQUVARS()
         dbSelectAr( "MW01" )
         dbGoTop()
         IF dbSeek( mCOMPED )
            mCOMFOR := COMFOR
            MW08CHK01( .F. )
         ENDIF
      ENDIF
      dbSelectAr( "MW02" )
      dbSkip()
      @ 24, 00 SAY RecNo()
      @ 24, 40 SAY mCOMPED
   ENDDO
   dbCloseAll()
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MW08CHK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MW08CHK01( lOPEN, dDATACHK )

   IF ValType( lOPEN ) # "L"
      lOPEN := .T.
   ENDIF
   IF mITETIP $ "MCOITRB"
      IF Empty( mVIGENCIA )
         mVIGENCIA := ZDATA
      ENDIF
      IF mITEPRC > 0
         MAWULTPRC( ESTQARQ( mITETIP, 1 ), mITECOD, { mITEPRC, mITEUNI, mVIGENCIA } )
      ENDIF
      IF !Empty( mCOMFOR ) .AND. !Empty( mITEPRC )
         mDATA := ZDATA
         IF Empty( mVIGENCIA )
            mDATAINI := mDATA
         ELSE
            mDATAINI := mVIGENCIA
         ENDIF
         lMW08 := .T.
         IF lOPEN
            WHILE !USEREDE( "MW08", 1, 99 )
            ENDDO
         ELSE
            dbSelectAr( "MW08" )
         ENDIF
         dbGoTop()
         dbSeek( mITETIP + PadR( mITECOD, 24 ) + Str( mCOMFOR, 8 ) )
         WHILE ITETIP = mITETIP .AND. AllTrim( ITECOD ) = AllTrim( mITECOD ) .AND. COMFOR = mCOMFOR .AND. !Eof()
            IF ITEPRC = mITEPRC
               lMW08 := .F.
               IF DATAINI <> mVIGENCIA .AND. mITETIP $ "MCT"
                  GRAVACAMPO( { "PEDATIVO", "CODMW", "DATA", "COMPED", "ITEM", "DATAINI" }, { "'S'", "mCODMW", "mDATA", "mCOMPED", "mITEM", "mVIGENCIA" } )
               ELSE
                  GRAVACAMPO( { "PEDATIVO", "CODMW", "DATA", "COMPED", "ITEM" }, { "'S'", "mCODMW", "mDATA", "mCOMPED", "mITEM" } )
               ENDIF
            ENDIF
            dbSkip()
         ENDDO
         IF lMW08  // Grava se Nao tiver o Mesmo Preco
            mPEDATIVO := "S"
            netrecapp()
            REPLVARS()
         ENDIF
         IF lOPEN
            dbCloseArea()
         ENDIF
      ENDIF
   ENDIF
   IF mITETIP = "T"
      cNORMA := AllTrim( OBTER( "MP03", mITECOD, "NORMA" ) )
      IF !Empty( cNORMA )
         MAWULTPRC( "ETI", cNORMA, { mITEPRC, mITEUNI, mVIGENCIA } )
      ENDIF
   ENDIF
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AWRET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AWRET

   MDI( "Retornar Pedido Baixado" )
   mPED  := 0
   mITE  := 0
   cARQ  := "MW01BX"
   cARQ2 := "MW02BX"
   MDS( "Pedido" )
   @ 24, 30 GET mPED
// @ 24,40 GET mITE
   READCUR()
   IF MDG( "Mes Fechado" )
      cVAR  := MESANO()
      cARQ  := "W1" + cVAR
      cARQ2 := "W2" + cVAR
   ENDIF
   IF !USEMULT( { { "MW01", 1, 99 }, { "MW02", 1, 99 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MW01" )
   INITVARS()
   CLRVARS()
   dbSelectAr( "MW02" )
   INITVARS()
   CLRVARS()
   dbSelectAr( cARQ2 )
   dbGoTop()
   dbSeek( Str( mPED, 8 ) )
   WHILE COMPED = mPED .AND. !Eof()
      EQUVARS()
      // mITEENT := 0 nao alterar dava erro
      // mITERES := 0 mantinha o pedido em aberto
      // se necessario sera feito via ajuste mawretqtd()
      mITESAL := mITEQTD
      NOVOOPA( "MW02", Str( mPED, 8 ) + Str( mITE, 3 ) )
      dbSelectAr( cARQ2 )
      netrecdel()
      dbSkip()
   ENDDO
   dbSelectAr( cARQ )
   dbGoTop()
   IF dbSeek( mPED )
      EQUVARS()
      mTRAVAPED := ""
      NOVOOPA( "MW01", mPED )
      dbSelectAr( cARQ )
      netrecdel()
   ENDIF
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWULT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWULT

   IF MDG( "Checar Componetes" )
      MAWULT01( "C" )
   ENDIF
   IF MDG( "Checar Tratamentos" )
      MAWULT01( "T" )
   ENDIF
   IF MDG( "Checar Consumiveis" )
      MAWULT01( "O" )
   ENDIF
   IF MDG( "Checar Itens Manuten‡Æo" )
      MAWULT01( "R" )
   ENDIF
   IF MDG( "Checar Materia Prima" )
      MAWULT01( "M" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWULT01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWULT01

   PARA cTIPO

   cARQ := ESTQARQ( cTIPO, 1 )
   IF !USEMULT( { { cARQ, 1, 1 }, { "MW08", 1, 2 } } )
      RETU .F.
   ENDIF
   dbSelectAr( cARQ )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY CODIGO
      mCODIGO := AllTrim( CODIGO )
      mCODMW  := CODMW
      aVAL    := { 0, "", CToD( Space( 8 ) ) }
      dbSelectAr( "MW08" )
      dbGoTop()
      dbSeek( cTIPO + mCODIGO )
      IF cTIPO = ITETIP .AND. AllTrim( ITECOD ) == mCODIGO
         aVAL := { ITEPRC, ITEUNI, DATA }
         netgrvcam( "CODMW", mCODMW )
      ENDIF
      dbSelectAr( cARQ )
      IF aVAL[ 1 ] > 0
         netreclock()
         IF aVAL[ 3 ] >= ULTDATA
            field->ULTPRC  := aVAL[ 1 ]
            field->ULTUND  := aVAL[ 2 ]
            field->ULTDATA := aVAL[ 3 ]
         ENDIF
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWULTPRC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWULTPRC( cARQ, eBUSCA, aDAD )

   eBUSCA := AllTrim( eBUSCA )
   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   IF dbSeek( eBUSCA )
      IF aDAD[ 3 ] >= ULTDATA
         netreclock()
         field->ULTPRC  := aDAD[ 1 ]
         field->ULTUND  := aDAD[ 2 ]
         field->ULTDATA := aDAD[ 3 ]
         dbUnlock()
      ENDIF
   ENDIF
   dbCloseArea()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWRETQTD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWRETQTD

// aMAW403 := PEGLAY( "MEXPOR1", "MAW403" )
// aMAW413 := PEGLAY( "MEXPOR1", "MAW413" )
// CRIARVARS( "MW08" )
// CRIARVARS( "MW04" )
   CRIARVARS( "MY04" )
   CRIARVARS( "MW02" )
   MDI( " Ý Ajuste Quantidades Entregues Pedido" )
   cARQ1 := "MW01"
   cARQ2 := "MW02"
   IF MDG( "Baixados" )
      cARQ1 := "MW01BX"
      cARQ2 := "MW02BX"
      IF MDG( "Mes Fechado" )
         cVAR  := MESANO()
         cARQ1 := "W1" + cVAR
         cARQ2 := "W2" + cVAR
      ENDIF
   ENDIF
   mOS   := 0
   mITEM := 0
   @ 22, 00 SAY "Pedido Item Qtde"
   @ 22, 30 GET mOS                PICT "9999999"
   @ 22, 40 GET mITEM              PICT "999"
   IF !READCUR()
      RETU .F.
   ENDIF
   IF IGUALVARS( cARQ2, Str( mOS, 8 ) + Str( mITEM, 3 ) )
      xITEENT := mITEENT
      @ 23, 00 SAY "Qtde"
      @ 23, 20 SAY "Entregue"
      @ 23, 40 SAY "Residuo"
      @ 23, 60 SAY "Saldo"
      @ 24, 00 SAY mITEQTD
      @ 24, 60 SAY mITESAL
      @ 24, 20 GET mITEENT
      @ 24, 40 GET mITERES
      IF READCUR()
         GRAVAMVAR( CARQ2, Str( mOS, 8 ) + Str( mITEM, 3 ), { "ITEENT", "ITERES", "ITESAL" }, { "mITEENT", "mITERES", "mITEQTD-(mITEENT+mITERES)" } )
         IF xITEENT <> mITEENT
            mTIPO3   := "AJU"
            mDATA    := ZDATA
            mTIPO2   := mITETIP
            mTIPOENT := mITETIP
            mCODIGO  := mITECOD
            mUNID    := mITEUNI
            mOS      := mCOMPED
            // mITEM=mITEM
            mNRNOTA    := mRECNOT
            mREQINT    := mRECNUM
            mPRCMW02   := mITEPRC
            mCODDEP    := mITECTA
            mTECNICO   := ZIDFOLHA
            mFORNECEDO := OBTER( cARQ1, mCOMPED, "COMFOR" )
            mNUMMB01   := mFORNECEDO
            mOBS       := "Ajuste qtde entregue Pedido"
            ULTIMOREG( "MY04", "NUMERO", "mNUMERO" )
            mQTDE     := xITEENT - mITEENT
            yCODIGO   := mCODIGO
            mOLDQTDDE := 0
            IF mQTDE > 0   // tirar entrada
               mTIPO1 := "S"
               MAK2K05( "E", "MY04E" )  // estoque entrada
            ELSE
               mTIPO1 := "E"   // incluir entrada
               mQTDE  := Abs( mQTDE )
               MAK2K05( "I", "MY04E" )  // estoque entrada
            ENDIF
            NOVOREG( "MY04", mNUMERO )
         ENDIF
      ENDIF
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWMUDFOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWMUDFOR

   nORI := 0
   nDES := 0
   MDI( "Ý Trocar No Fornecedor" )
   MDS( "Origem Destino" )
   @ 24, 20 GET nORI PICT "99999"
   @ 24, 30 GET nDES PICT "99999"
   IF !READCUR()
      RETU .F.
   ENDIF
   IF nORI = 0 .OR. nDES = 0
      ALERTX( "Necessario Preencher N§ Fornecedor Origem/Destino" )
      RETU .F.
   ENDIF
   IF !MDG( "Mudar " + Str( nORI ) + " para " + Str( nDES ) )
      RETU .F.
   ENDIF
   IF !MDG( "Realmente Mudar " + Str( nORI ) + " para " + Str( nDES ) )
      RETU .F.
   ENDIF
   IF USEREDE( "MW01", 0, 99 )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netgrvcam( "COMFOR", nDES ) }, {|| COMFOR = nORI }, {|| zei_fort( nLASTREC,,, 1 ) } )
      dbCloseAll()
   ENDIF





// + EOF: m_aw0.prg
// +
