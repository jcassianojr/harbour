// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ay3.prg
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



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_ay3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_ay3

   PARA nTIPO

   ARQWORK := "MY03"
   ARQWOR2 := "MY03A"
   IF nTIPO = 2
      cVAR    := MESANO()
      ARQWORK := "Y3" + cVAR
      ARQWOR2 := "YA" + cVAR
   ENDIF
   IF nTIPO = 3
      ARQWORK := "Y399"
      ARQWOR2 := "YA99"
   ENDIF

   zxCODIGO := ""
   PRIV mTOTAL

   lMAY301 := SENHAX( "MAY301" )

   PADRAX( 0,, 0, { ARQWORK, "OR01", ARQWOR2 }, "Numero   Data     Codigo" + spac( 19 ) + "Seq SSQ Qtdde", ;
      "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+PADR(TRIM(mCODIGO)+'/'+TRIM(mCODIG2),30)+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+STR(mQTDDE,12,3)", "MAY301", "MAY301", ;
      ,, {|| MAY3POS() }, {|| mNUMERO := ULTIMOREG( ARQWORK, "NUMERO", "mNUMERO" ) } ;
      , "MAY3" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY3POS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY3POS( nUSO )

   IF ValType( nUSO ) # "N"
      nUSO := 1
   ENDIF
   zxCODIGO := mCODIGO
   IF ARQWORK # "MY03"
      ALERTX( "Mes Fechado NÆo Grava Altera‡oes Estoque" )
   ELSE
      MAY304()
      IF !Empty( mCODIG2 )
         zxCODIGO := mCODIG2
         MAY304()
      ENDIF
   ENDIF
   IF nUSO = 1
      IF mCODMAQ <> "TER" .AND. MDG( "Lan‡ar Paradas" )
         xNUMERO := mNUMERO
         PADRAO( 1, 1, 0, ARQWOR2, "Req" + spac( 6 ) + "Par Co Ini   Fim   Tempo", ;
            "' '+STR(mNUMERO,8)+' '+STR(mITEM,3)+' '+mCODPAR+' '+STR(mPINI,5,2)+' '+STR(mPFIM,5,2)+' '+STR(mTEMPO,5,2)", "MAY3A", "MAY3A1", "MAY3A1", ;
            {|| MAY3IINC() }, {|| PADARR( ARQWOR2, Str( xNUMERO, 8 ), "NUMERO", "XNUMERO" ) },,, ;
            ,,, "mTEMPO" )
         hb_keyClear()
         hb_keyPut( 88 )   // KEYINS(88)
         IF cVIDE # "T"
            GRAVAMVAR( ARQWORK, xNUMERO, "PARADA", "mTOTAL" )
         ELSE
            mPARADA := mTOTAL
         ENDIF
         IF cVIDE = "T"
            dbSelectAr( ARQWORK )
         ENDIF
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY3IINC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY3IINC

   mNUMERO := xNUMERO
   ULTIMOITEM( ARQWOR2, Str( xNUMERO, 8 ), "NUMERO", "XNUMERO", "ITEM", "mITEM", .T. )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY302()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY302

   IF cVIDE # 'T'  // Sub Rotinas Fecham arquivo
      WHILE !USEREDE( ARQWORK, 1, 2 )
      ENDDO
   ELSE
      dbSelectAr( ARQWORK )
      dbSetOrder( 2 )
   ENDIF
   dbGoTop()
   dbSeek( mCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) + mCODMAQ )
   IF mCODIGO = CODIGO .AND. mSEQ = SEQ .AND. mSSQ = SSQ .AND. mCODMAQ = CODMAQ .AND. !Eof()
      mANTREF := VALREF
   ENDIF
   IF cVIDE # 'T'
      dbCloseArea()
   ELSE
      dbSetOrder( 1 )
      dbGoTop()
      dbSeek( mNUMERO )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY303()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY303

   zMEDIA := OBTER( "MANEMP", ZNUMERO, "MEDIA" )
   PRIV mTOTAL
   mOS     := 0
   INCLUI  := .T.  // Marca Para Processar
   CORPAX  := CORARR( "MAY3" )
   ARQWORK := "MY03"
   CRIARVARS( "MY03" )
   mBXMY03 := "S"
   TELASAY( "MAY301" )
   EDITSAY( "MAY302" )
   MAY3POS( 2 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY304()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY304

   LOCAL cERRO

   cERRO := Str( mNUMERO ) + " " + AllTrim( zxCODIGO ) + " Opr:" + Str( mSEQ, 3 ) + "/" + Str( mSSQ, 3 )
   IF !INCLUI
      ALERTX( "Altera‡„o N„o Grava Estoques" )
      GRAVALOG( cERRO, "VER", ARQWORK )
      RETU .F.
   ENDIF
   IF mBXMY03 = "N"
      ALERTX( "Requisicao Marcada Nao Baixar Estoque" )
      GRAVALOG( cERRO, "BXM", ARQWORK )
      RETU .F.
   ENDIF
   IF OBTER( "MS06", zxCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ), "PULREQ" ) = "S"  // Opera‡”es Nulas
      ALERTX( "Opera‡ao Marcada Pular NÆo Grava Estoque" )
      GRAVALOG( cERRO, "PUL", ARQWORK )
      RETU .F.
   ENDIF
   IF ( mSEQ > 0 .OR. mSSQ > 0 ) .AND. !VERSEHA( "MS06", zxCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
      ALERTX( "Opera‡ao Nao Cadastrada NÆo Grava Estoque" )
      GRAVALOG( cERRO, "OPE", ARQWORK )
      RETU .F.
   ENDIF

   GRAVALOG( cERRO, "INI", ARQWORK )

   MDS( "Abrindo Sequencia Operacao" )
   WHILE !userede( "MS06REQ", 1, 99 )
   ENDDO
   aREQOUT := {}
   dbSelectAr( "MS06REQ" )
   dbSetOrder( 2 )   // Produto Sequencia
   dbGoTop()
   dbSeek( zxCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
   WHILE AllTrim( CODIGO ) = AllTrim( zxCODIGO ) .AND. seq = mSEQ .AND. SSQ = mSSQ .AND. !Eof()
      AAdd( aREQOUT, { BXCOD, BXSEQ, BXSSQ, BXFAT } )
      // ALERTX(BXCOD+STR(BXSEQ)+STR(BXSSQ))
      dbSkip()
   ENDDO
   dbCloseArea()


   aSUB := {}
   WHILE !USEREDE( "MS06", 1, 99 )
   ENDDO
   WHILE !USEREDE( "MS96", 1, 99 )
   ENDDO
   dbSelectAr( "MS06" )
   dbSetOrder( 1 )
   dbGoTop()
   IF dbSeek( zxCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
      xESTQSAL := ESTQSAL
      GRAVALAY( { { "ARQUIVO", "USUARIO", "QTDE", "DATA", "NUMERO", "CODIGO", "SEQ", "SSQ", "ESTQXXX" }, ;
         { "'MY03'", "ZUSER", "mQTDDE", "IF(EMPTY(mDATA),ZDATA,mDATA)", "mNUMERO", "zxCODIGO", "mSEQ", "mSSQ", "xESTQSAL" } }, ;
         "MS96",, .F.,, .T. )
      netreclock()
      field->ESTQENT := ESTQENT + mQTDDE
      field->ESTQSAL := ESTQINI + ESTQENT - ESTQSAI
      dbUnlock()
      xESTQSAL := ESTQSAL
      GRAVALAY( { { "ESTQYYY" }, { "XESTQSAL" } }, "MS96",, .F.,, .F. )
      IF TIPBAI $ "SPCMOT"   // Incluindo Estoque Sub Outras
         mNRNOTA    := 0
         mQTDE      := mQTDDE
         mTIPOENT   := TIPBAI
         yCODIGO    := CODFEC
         mOLDQTDDE  := 0
         mFORNECEDO := 0
         MAY02( TIPORR( TIPBAI, 2 ), TIPORR( TIPBAI, 2 ) + "BX", TIPORR( TIPBAI, 1 ), mQTDDE )   // Distribuindo o Estoque do Componente
         MAK2K05( "I", "MY03I" )
         dbSelectAr( "MS06" )
      ENDIF
      lSTOP := .F.
      dbSkip( - 1 )
      WHILE AllTrim( CODIGO ) = AllTrim( zxCODIGO ) .AND. !Bof() .AND. !lSTOP
         IF TIPFEC = "7" .OR. TIPFEC = "P"
            lSTOP := .T.
         ENDIF
         IF PULREQ # "S" .AND. !lSTOP
            xESTQSAL := ESTQSAL
            xSEQ     := SEQ
            xSSQ     := SSQ
            GRAVALAY( { { "ARQUIVO", "USUARIO", "QTDE", "DATA", "NUMERO", "CODIGO", "SEQ", "SSQ", "ESTQXXX" }, ;
               { "'MY03'", "ZUSER", "mQTDDE", "IF(EMPTY(mDATA),ZDATA,mDATA)", "mNUMERO", "zxCODIGO", "XSEQ", "XSSQ", "xESTQSAL" } }, ;
               "MS96",, .F.,, .T. )
            netreclock()
            field->ESTQSAI := ESTQSAI + mQTDDE
            field->ESTQSAL := ESTQINI + ESTQENT - ESTQSAI
            dbUnlock()
            xESTQSAL := ESTQSAL
            GRAVALAY( { { "ESTQYYY" }, { "XESTQSAL" } }, "MS96",, .F.,, .F. )
            lSTOP := .T.
         ENDIF
         dbSkip( - 1 )
      ENDDO
      IF dbSeek( zxCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )  // Retorna ao Registro
         IF TIPFEC = "9" .OR. TIPFEC = "8"   // Baixar spmt baixa conjunto (7)*fator
            dbSkip( - 1 )
            WHILE AllTrim( CODIGO ) = AllTrim( zxCODIGO ) .AND. !Bof()
               IF TIPFEC = "7"
                  xESTQSAL := ESTQSAL
                  xSEQ     := SEQ
                  xSSQ     := SSQ
                  GRAVALAY( { { "ARQUIVO", "USUARIO", "QTDE", "DATA", "NUMERO", "CODIGO", "SEQ", "SSQ", "ESTQXXX" }, ;
                     { "'MY03'", "ZUSER", "mQTDDE", "IF(EMPTY(mDATA),ZDATA,mDATA)", "mNUMERO", "zxCODIGO", "XSEQ", "XSSQ", "xESTQSAL" } }, ;
                     "MS96",, .F.,, .T. )
                  netreclock()
                  field->ESTQSAI := ESTQSAI + ( mQTDDE * FATOR )
                  field->ESTQSAL := ESTQINI + ESTQENT - ESTQSAI
                  dbUnlock()
                  xESTQSAL := ESTQSAL
                  GRAVALAY( { { "ESTQYYY" }, { "XESTQSAL" } }, "MS96",, .F.,, .F. )
                  IF TIPBAI $ "SPCMOT"   // Incluindo Baixando Estoque Outras
                     mNRNOTA    := 0
                     mQTDE      := ( mQTDDE * FATOR )
                     mTIPOENT   := TIPBAI
                     yCODIGO    := CODFEC
                     mOLDQTDDE  := 0
                     mFORNECEDO := 0
                     MAY02( TIPORR( TIPBAI, 2 ), TIPORR( TIPBAI, 2 ) + "BX", TIPORR( TIPBAI, 1 ), mQTDDE )   // Distribuindo o Estoque do Componente
                     MAM2K05( "I", "MY03I" )
                     dbSelectAr( "MS06" )
                  ENDIF
               ENDIF
               dbSkip( - 1 )
            ENDDO
         ENDIF
      ENDIF
   ELSE
      GRAVALOG( cERRO, "OPX", ARQWORK )
   ENDIF
// Sub Baixas
   nSUBBAI := Len( aREQOUT )
   FOR x := 1 TO nSUBBAI
      dbSelectAr( "MS06" )
      dbSetOrder( 1 )
      dbGoTop()
      IF dbSeek( PadR( aREQOUT[ X, 1 ], 24 ) + Str( aREQOUT[ X, 2 ], 3 ) + Str( aREQOUT[ X, 3 ], 3 ) )
         // ALERTX("Baixando "+CODIGO+STR(SEQ)+STR(SSQ))
         nSUBQTDE := mQTDDE * aREQOUT[ X, 4 ]
         xESTQSAL := ESTQSAL
         GRAVALAY( { { "ARQUIVO", "USUARIO", "QTDE", "DATA", "NUMERO", "CODIGO", "SEQ", "SSQ", "ESTQXXX" }, ;
            { "'MY03'", "ZUSER", "nSUBQTDE", "IF(EMPTY(mDATA),ZDATA,mDATA)", "mNUMERO", "zxCODIGO", "mSEQ", "mSSQ", "xESTQSAL" } }, ;
            "MS96",, .F.,, .T. )
         netreclock()
         field->ESTQSAI := ESTQSAI + nSUBQTDE
         field->ESTQSAL := ESTQINI + ESTQENT - ESTQSAI
         dbUnlock()
         xESTQSAL := ESTQSAL
         GRAVALAY( { { "ESTQYYY" }, { "XESTQSAL" } }, "MS96",, .F.,, .F. )
      ENDIF
   NEXT x
   dbSelectAr( "MS06" )
   dbCloseArea()
   dbSelectAr( "MS96" )
   dbCloseArea()

   GRAVALOG( cERRO, "FS1", ARQWORK )

   MDS( "Abrindo Composicao" )
   aCOMP := {}
   WHILE !USEREDE( "MS03", 1, 2 )
   ENDDO
   dbGoTop()
   dbSeek( zxCODIGO )
   WHILE zxCODIGO = CODIGO .AND. !Eof()
      IF BSEQ = mSEQ .AND. BSSQ = mSSQ
         IF BAIXAC = "S"
            AAdd( aCOMP, { TIPOENT, CODCOMP, mQTDDE * QTDDE, mOS, BAIXAC } )  // Quantidade OS*Quantidade componete
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   MDS( "Gravando Composicao" )
   OLDTIPOENT := " "
   FOR W := 1 TO Len( aCOMP )  // Baixando o Estoque Componentes
      mFORNECEDO := 0
      mOLDQTDDE  := 0
      mCODIGO    := aCOMP[ W, 2 ]
      yCODIGO    := mCODIGO
      mQTDE      := aCOMP[ W, 3 ]
      mTIPOENT   := aCOMP[ W, 1 ]
      mTIPENT    := aCOMP[ W, 1 ]
      mBAIXAC    := aCOMP[ W, 5 ]
      MAM2K05( "I", ARQWORK + "S" + mTIPOENT )
   NEXT W
   mTIPOENT := OLDTIPOENT
   GRAVALOG( cERRO, "FIM", ARQWORK )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY305()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY305()

   PRIV nALMI := nALMF := 0

   PEGACAMPO( "FOPTOHOR", "mTURNO", { "ALMI", "ALMF" }, { "nALMI", "nALMF" } )
   IF mINIOPR <= nALMI .AND. mFIMOPR >= nALMF
      mALMINI := nALMI
      mALMFIM := nALMF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY306()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY306()

   PRIV nALMI := nALMF := 0

   PEGACAMPO( "FOPTOHOR", mTURNO, { "ALMI", "ALMF" }, { "nALMI", "nALMF" } )
   IF mPINI <= nALMI .AND. mPFIM >= nALMF
      mPALI := nALMI
      mPALF := nALMF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY307()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY307()

   IF cVIDE # "T"
      ALLTRUE( VERSEHA( ARQWORK, mCODMAQ + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) + mCODIGO + DToS( mDATOPR ), "'Similar o.'+STR(NUMERO)", "''", .T., 4 ) )
   ELSE
      dbSelectAr( ARQWORK )
      dbSetOrder( 4 )
      IF dbSeek( mCODMAQ + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) + mCODIGO + DToS( mDATOPR ) )
         MDS( 'Similar o.' + Str( NUMERO ) )
      ENDIF
      dbSelectAr( ARQWORK )
      dbSetOrder( 1 )
      dbSeek( mNUMERO )
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY3AVL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY3AVL()

   ARQWORK := "MY03"
   ARQWOR2 := "MY03A"
   CRIARVARS( "MY03" )
   CRIARVARS( "MY03A" )
   CRIARVARS( "OR01" )
   zxCODIGO := ""
   PRIV mTOTAL
   lMAY301 := SENHAX( "MAY301" )
   aMAYTEL := TELAPEG( "MAY301" )
   aMAYGET := EDITPEG( "MAY301" )
   cVIDE   := "X"
   WHILE .T.
      INCLUI := .T.
      CRIARVARS( "MY03" )
      // Desenha a Tela
      TELASAY( aMAYTEL )
      // Get nas Menvars
      EDITSAY( aMAYGET )
      WHILE !USEREDE( "MY03", 1, 99 )
      ENDDO
      dbGoBottom()
      mNUMERO := NUMERO
      mNUMERO++
      netrecapp()
      // mNUMERO:=RECNO()
      REPLVARS()
      dbCommit()
      dbCloseAll()
      FOR X := 1 TO 3000   // Delay Aguardando Grava‡ao
      NEXT X
      MAY3POS()
      IF !MDG( "Outro Lan‡amento" )
         EXIT
      ENDIF
   ENDDO
   RELEASE ALL LIKE m *


// + EOF: m_ay3.prg
// +
