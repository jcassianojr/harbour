// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlibnf.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\MLIBNF.PRG
// +
// +    Functions: Function NFCOD()
// +               Function PEGLOTE()
// +               Function NFBAS()
// +               Function NFBICM()
// +               Function NFBIPI()
// +               Function NFIPI()
// +               Function NFVIPI()
// +               Function NFVICM()
// +
// +    Reformatted by Click! 2.03 on Nov-25-2003 at  5:05 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// * Traz dados Basicos Conforme Codigo
// *
// *
// *

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFCOD()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFCOD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC NFCOD( lPEGLIS )

   LOCAL cDBF := Alias()

   IF mTIPOENT = "X"   // Nada Faz Quando X
      RETU .T.
   ENDIF
   IF ValType( lPEGLIS ) # "L"
      lPEGLIS := .F.
      IF nREF = 2
         lPEGLIS := .T.
      ENDIF
   ENDIF
   PRIV cNOME   := ""
   PRIV cCODIGO := AllTrim( mCODIGO )
   PRIV GETLIST := {}
   IF xCODIGO # mCODIGO
      nLENNOME := Len( mNOME )   // Tamanho do Arquivo
      DO CASE
      CASE mTIPOENT = "I"
         PEGACAMPO( "ME04", "cCODIGO", { "PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)" }, { "cNOME" } )
      CASE mTIPOENT = "F"
         PEGACAMPO( "FERRAM", "cCODIGO", { "NOME" }, { "cNOME" } )
      CASE mTIPOENT = "O" .OR. mTIPOENT = "R"
         PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "cCODIGO", { "NOME", "UNIDADE", "REDICM", "CODIPI", "CLASSIPI", "IPI" }, ;
            { "cNOME", "mUNID", "mREDICM", "mCODIPI", "mCLASSIPI", "mIPI" } )
      CASE mTIPOENT = "T"
         PEGACAMPO( "MP03", "cCODIGO", { "REDICM", "SPACE(45)", "CODIPI", "CLASSIPI", "IPI" }, ;
            { "mREDICM", "mNOME", "mCODIPI", "mCLASSIPI", "mIPI" } )
         MMTRA( "mNOME" )
         mNOME   := PadR( "Pedido:" + mNOME, 45 )
         cCODIGO := AllTrim( OBTER( "MP03", cCODIGO, "SUBPROD",,,,,, "" ) )
         IF !Empty( cCODIGO )  // Sub Produto
            PEGACAMPO( "MQ01", "cCODIGO", { "NOME", "UNIDADE", "PESLIQ", "PRECUST" }, { "cNOME", "mUNID", "mPESO", "mPRECO" } )
            lPEGLIS := .F.
         ELSE
            cCODIGO := AllTrim( mCODIGO )
            cCODIGO := AllTrim( OBTER( "MP03", cCODIGO, "SUBAPL",,,,,, "" ) )
            IF Empty( cCODIGO )
               cCODIGO := AllTrim( mCODIGO )
               cCODIGO := AllTrim( OBTER( "MP03", cCODIGO, "APLICACAO",,,,,, "" ) )
            ENDIF
            IF Empty( cCODIGO )
               cCODIGO := AllTrim( mCODIGO )
            ENDIF
            WHILE !PEGACAMPO( "MS01", "cCODIGO", { "NOME", "UNID", "PESOUNI" }, { "cNOME", "mUNID", "mPESO" }, 2 )
               cCODIGO := PadR( cCODIGO, 24 )
               ALERTX( "Aplicao Produto NЦo Encontrado" )
               @ 24, 00 GET cCODIGO
               READCUR()
               cCODIGO := AllTrim( cCODIGO )
            ENDDO
         ENDIF
         cNOME += mNOME
         // Verifica se tem Reducao Especial de ICMS
         mREDICM  := OBTER( "MM08", mTIPOENT + PadR( mCODIGO, 24 ) + Str( mFORNECEDO, 8 ), "REDICM",,,,,, mREDICM )
         mCODITAB := cCODIGO
         IF Empty( mPISCON ) .OR. INCLUI
            mPISCON := OBTER( "MP03", mCODIGO, "PISCON" )
         ENDIF
      CASE mTIPOENT = "D"
         cNOME := OBTER( "MI01", cCODIGO, "NOME" )
      CASE mTIPOENT = "M" .OR. mTIPOENT = "C" .OR. mTIPOENT = "S" .OR. mTIPOENT = "B"
         IF Empty( mPRECO ) .OR. INCLUI .AND. mTIPOENT = "S" .AND. mTIPOENT = "B"
            mPRECO := OBTER( ESTQARQ( mTIPOENT, 1 ), cCODIGO, "PRECUST" )
         ENDIF
         IF Empty( mPRECO ) .OR. INCLUI .AND. mTIPOENT = "M" .AND. mTIPOENT = "C"
            mPRECO := OBTER( ESTQARQ( mTIPOENT, 1 ), cCODIGO, "ULTPRC" )
         ENDIF
         IF Empty( mPISCON ) .OR. INCLUI
            mPISCON := OBTER( ESTQARQ( mTIPOENT, 1 ), cCODIGO, "PISCON" )
         ENDIF
         IF mTIPOENT = "B" .AND. ( Empty( mPESO ) .OR. INCLUI )
            mPESO := OBTER( "MR01", cCODIGO, "PESLIQ" )
         ENDIF
         IF mTIPOENT = "S" .AND. ( Empty( mPESO ) .OR. INCLUI )
            mPESO := OBTER( "MQ01", cCODIGO, "PESLIQ" )
         ENDIF
         PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "cCODIGO", { "ALLTRIM(NOME)+' '+ALLTRIM(NOM2)", "CODIPI", "UNIDADE", "CLASSIPI" }, { "cNOME", "mCODIPI", "mUNID", "mCLASSIPI" } )
         IF mTIPOSERV = "R"
            mPRECO := Round( mPRECO * .52, 4 )
         ENDIF
      CASE mTIPOENT = "P"
         mINDICE := ""
         PEGACAMPO( "MS01", "cCODIGO", { "NOME", "CODIPI", "UNID", "INDICE" }, { "cNOME", "mCODIPI", "mUNID", "mINDICE" }, 2 )
         IF Empty( mPESO ) .OR. INCLUI
            mPESO := OBTER( "MS01", cCODIGO, "PESOUNI", 2 )
         ENDIF
      ENDCASE
      IF mTIPOENT = "P" .OR. mTIPOENT = "T"
         cUNID := mUNID
         IF Empty( mPRECO ) .OR. ( INCLUI .AND. lPEGLIS )
            IF Empty( mLISTA ) .AND. mFORNECEDO > 0
               mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" )
            ENDIF
            IF mTIPOENT = "P"
               aPRC := MS02PRC( cCODIGO, mLISTA, .T., "mUNID", "mCODIPI" )
            ELSE
               aPRC := MS02PRC( cCODIGO, mLISTA, .T., "cUNID",,, .F. )
            ENDIF
            IF lPEGLIS
               mLISTANR := mLISTA
               cCODIGO  := PadR( cCODIGO, 24 )
               WHILE .T.
                  MDS( "Digite NЇ da Lista de Preo" )
                  @ 24, 40 GET mLISTANR PICT "9999999"
                  IF mTIPOENT = "T"
                     @ 24, 50 GET cCODIGO
                  ENDIF
                  READCUR()
                  IF Empty( mLISTANR )
                     EXIT
                  ENDIF
                  IF mTIPOENT = "P"
                     aPRC  := MS02PRC( cCODIGO, mLISTANR, .T., "mUNID", "mCODIPI" )
                     mUNID := cUNID
                  ELSE
                     aPRC := MS02PRC( cCODIGO, mLISTANR, .T., "cUNID" )
                  ENDIF
                  IF aPRC[ 1 ] > 0
                     EXIT
                  ENDIF
               ENDDO
            ENDIF
            IF aPRC[ 1 ] > 0
               IF Empty( mINDICE )
                  mPRECO := aPRC[ 1 ]
               ELSE
                  mVALIND := aPRC[ 1 ]
               ENDIF
               mDATABASE := aPRC[ 3 ]
            ENDIF
         ENDIF
         IF mTIPOSERV = "R" .OR. mTIPOSERV = "V" .OR. mTIPOSERV = "T"
            DO CASE
            CASE mTIPOSERV = "R"
               mPRECO := Round( mPRECO * .38, 4 )
            CASE mTIPOSERV = "V"
               mPRECO := Round( mPRECO * .52, 4 )
            CASE mTIPOSERV = "T"
               mPRECO := Round( mPRECO * .3, 4 )
            ENDCASE
            IF cUNID = "CT"
               mUNID  := "PC"
               mPRECO := Round( mPRECO / 100, 4 )
            ENDIF
            IF cUNID = "ML"
               mUNID  := "PC"
               mPRECO := Round( mPRECO / 1000, 4 )
            ENDIF
            mPRECO := Round( mPRECO, 2 )
         ENDIF
      ENDIF
      cNOME := AllTrim( cNOME )
      mNOME := SubStr( cNOME, 1, nLENNOME )
      IF Len( cNOME ) > nLENNOME
         mLINADD01 := SubStr( cNOME, nLENNOME + 1, 45 )
         IF Len( cNOME ) > nLENNOME + 45
            mLINADD02 := SubStr( cNOME, nLENNOME + 46, 45 )
            IF Len( cNOME ) > nLENNOME + 90
               mLINADD03 := SubStr( cNOME, nLENNOME + 91, 45 )
               IF Len( cNOME ) > nLENNOME + 135
                  mLINADD04 := SubStr( cNOME, nLENNOME + 136, 45 )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF mTIPOENT = "T"
         mIPI := 0
      ELSE
         IF !Empty( mCODIPI )
            mIPI := OBTER( "MD03", mCODIPI, "ALIQUOTA" )
         ENDIF
      ENDIF
      IF !Empty( mCODIPI )
         CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM", mCFONEW, 2, "mDIPIPI", "mDIPICM" )
      ENDIF
      xCODIGO := mCODIGO
   ENDIF
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function PEGLOTE()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGLOTE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGLOTE( nTIP, dDATA, cVAR )

   LOCAL cCHAVE

   cCHAVE := Str( ZNUMERO, 5 )
   cCHAVE += StrZero( Year( dDATA ), 4 )
   cCHAVE += StrZero( Month( dDATA ), 2 )
   IF !USEREDE( "FI_MES", 1, 1 )
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( cCHAVE )
      netreclock()
      IF nTIP = 1
         &cVAR.        := FISEQE + 1
         field->FISEQE := FISEQE + 1
         field->FILANE := dDATA
      ENDIF
      IF nTIP = 5
         &cVAR.          := FISEQISE + 1
         field->FISEQISE := FISEQISE + 1
         field->FILANISE := dDATA
      ENDIF
      IF nTIP = 6
         &cVAR.          := FISEQISS + 1
         field->FISEQISS := FISEQISS + 1
         field->FILANISS := dDATA
      ENDIF
      dbUnlock()
   ENDIF
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFBAS()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFBAS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NFBAS( nVALFRE, nREDICM, cTIP )

   LOCAL nPERICM := 100

   IF ValType( cTIP ) # "C"
      cTIP := "S"
   ENDIF
   IF ValType( nVALFRE ) # "N"
      nVALFRE := 0
   ENDIF
   IF ValType( nREDICM ) # "N"
      nREDICM := 0
   ENDIF
   IF nREDICM > 0
      nPERICM := 100 - nREDICM
   ENDIF
   mVALORMER := Round( mQTDE * mPRECO, 2 )
   IF xVALORMER # mVALORMER
      mBASEIPI  := mVALORMER + nVALFRE
      mVALORIPI := Round( mBASEIPI * ( mIPI / 100 ), 2 )
      IF mSOMANF = "S"
         mVALORTOT := mVALORMER + mVALORIPI + nVALFRE
      ELSE
         mVALORTOT := mVALORMER + nVALFRE
      ENDIF
      IF nREDICM > 0
         IF mCONSUMO = "S"
            mBASEICM := Round( mVALORTOT * nPERICM / 100, 2 )
         ELSE
            mBASEICM := Round( ( mVALORMER + nVALFRE ) * nPERICM / 100, 2 )
         ENDIF
      ELSE
         IF mCONSUMO = "S"
            mBASEICM := mVALORTOT
         ELSE
            mBASEICM := mVALORMER + nVALFRE
         ENDIF
      ENDIF
      xBASEICM  := mBASEICM
      mVALORICM := Round( mBASEICM * ( mICM / 100 ), 2 )
      xVALORMER := mVALORMER
   ENDIF
   IF Empty( mVALORIPI ) .AND. mIPI > 0
      mVALORIPI := Round( mBASEIPI * ( mIPI / 100 ), 2 )
   ENDIF
   IF Empty( mVALORICM ) .AND. mICM > 0
      mVALORICM := Round( mBASEICM * ( mICM / 100 ), 2 )
   ENDIF
   IF mSOMANF = "S"
      mVALORTOT := mVALORMER + mVALORIPI + nVALFRE
   ELSE
      mVALORTOT := mVALORMER + nVALFRE
   ENDIF
   IF cTIP = "S"
      @ 14, 15 SAY mVALORMER PICT "@E 999,999,999,999.99"
      @ 18, 15 SAY mVALORTOT PICT "@E 999,999,999,999.99"
   ELSE
      // @ 12,15 SAY mVALORMER PICT "@E 999,999,999,999.99"
      // @ 17,15 SAY mVALORTOT PICT "@E 999,999,999,999.99"
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFBICM()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFBICM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NFBICM

   IF xBASEICM # mBASEICM
      IF mICM > 0
         mVALORICM := Round( mBASEICM * ( mICM / 100 ), 2 )
      ELSE
         mVALORICM := 0
      ENDIF
      xBASEICM := mBASEICM
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFBIPI()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFBIPI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NFBIPI

   IF xBASEIPI # mBASEIPI
      IF mIPI > 0
         mVALORIPI := Round( mBASEIPI * ( mIPI / 100 ), 2 )
      ENDIF
      xBASEIPI := mBASEIPI
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFIPI()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFIPI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NFIPI()

   IF xIPI # mIPI
      IF mIPI > 0
         mVALORIPI := Round( mBASEIPI * ( mIPI / 100 ), 2 )
      ENDIF
      xIPI := mIPI
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFVIPI()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFVIPI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NFVIPI

   IF Empty( mIPI ) .AND. Empty( mVALORIPI )
      mBASEIPI := 0
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function NFVICM()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NFVICM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NFVICM

   IF Empty( mICM ) .AND. Empty( mVALORICM )
      mBASEICM := 0
   ENDIF
   RETU .T.

// + EOF: MLIBNF.PRG

// + EOF: mlibnf.prg
// +
