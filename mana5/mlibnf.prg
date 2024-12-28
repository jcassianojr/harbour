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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
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

   IF ValType( lPEGLIS ) # "L"
      lPEGLIS := .F.
   ENDIF
   PRIV cNOME   := "", cCODIGO := AllTrim( mCODIGO )
   PRIV GETLIST := {}
   IF xCODIGO # mCODIGO
      nLENNOME := Len( mNOME )   // Tamanho do Arquivo
      DO CASE
      CASE mTIPOENT = "F"
         PEGACAMPO( "FERRAM", "cCODIGO", { "NOME" }, { "cNOME" } )
      CASE mTIPOENT = "O" .OR. mTIPOENT = "R"
         PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "cCODIGO", { "NOME", "UNIDADE", "REDICM", "CODIPI", "CLASSIPI", "IPI" }, ;
            { "cNOME", "mUNID", "mREDICM", "mCODIPI", "mCLASSIPI", "mIPI" } )
      CASE mTIPOENT = "T"
         PEGACAMPO( "MP03", "cCODIGO", { "REDICM", "padr(NORMA,45)", "CODIPI", "CLASSIPI", "IPI" }, ;
            { "mREDICM", "mNOME", "mCODIPI", "mCLASSIPI", "mIPI" } )
         cCODIGO := AllTrim( OBTER( "MP03", cCODIGO, "SUBPROD",,,,,, "" ) )
         IF !Empty( cCODIGO )  // Sub Produto
            PEGACAMPO( "MQ01", "cCODIGO", { "NOME", "UNIDADE", "PESLIQ", "PRECUST" }, { "cNOME", "mUNID", "mPESO", "mPRECO" } )
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
               ALERTX( "Aplicacao Produto Nao Encontrado" )
               @ 24, 00 GET cCODIGO
               READCUR()
               cCODIGO := AllTrim( cCODIGO )
            ENDDO
         ENDIF
         cNOME += mNOME
         // Verifica se tem Reducao Especial de ICMS
         mREDICM  := OBTER( "MM08", mTIPOENT + PadR( mCODIGO, 24 ) + Str( mFORNECEDO, 8 ), "REDICM",,,,,, mREDICM )
         mCODITAB := cCODIGO
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
         IF Empty( mPRECO ) .OR. INCLUI
            IF Empty( mLISTA ) .AND. mFORNECEDO > 0
               mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" )
            ENDIF
            aPRC := MS02PRC( mCODIGO, mLISTA, .T., "mUNID", "mCODIPI" )
            IF lPEGLIS
               WHILE .T.
                  IF !MDG( "Digitar Lista de Pre‡o" )
                     EXIT
                  ENDIF
                  mLISTANR := mlISTA
                  MDS( "Digite Numero da Lista de Pre‡o" )
                  @ 24, 50 GET mLISTANR
                  READCUR()
                  aPRC := MS02PRC( mCODIGO, mLISTANR, .T., "mUNID", "mCODIPI" )
                  IF aPRC[ 1 ] > 0
                     EXIT
                  ENDIF
               ENDDO
            ENDIF
            IF Empty( mINDICE )
               mPRECO := aPRC[ 1 ]
            ELSE
               mVALIND := aPRC[ 1 ]
            ENDIF
            mDATABASE := aPRC[ 3 ]
         ENDIF
         IF mTIPOSERV = "R" .OR. mTIPOSERV = "V"
            IF mTIPOSERV = "R"
               mPRECO := Round( mPRECO * .38, 4 )
            ELSE
               mPRECO := Round( mPRECO * .52, 4 )
            ENDIF
            IF mUNID = "CT"
               mUNID  := "PC"
               mPRECO := Round( mPRECO / 100, 4 )
            ENDIF
            IF mUNID = "ML"
               mUNID  := "PC"
               mPRECO := Round( mPRECO / 1000, 4 )
            ENDIF
         ENDIF
      ENDCASE
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
         CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM", mCFONEW, 2 )
      ENDIF
      xCODIGO := mCODIGO
   ENDIF
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU .T.




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
         FIELD->FISEQE := FISEQE + 1
         FIELD->FILANE := dDATA
      ENDIF
      IF nTIP = 5
         &cVAR.          := FISEQISE + 1
         FIELD->FISEQISE := FISEQISE + 1
         FIELD->FILANISE := dDATA
      ENDIF
      IF nTIP = 6
         &cVAR.          := FISEQISS + 1
         FIELD->FISEQISS := FISEQISS + 1
         FIELD->FILANISS := dDATA
      ENDIF
      dbUnlock()
   ENDIF
   RETU




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

// + EOF: mlibnf.prg
// +
