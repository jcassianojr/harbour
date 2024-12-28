// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_adic.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

//
// m_adic -> Registros Iniciais DIPI
//
//
//


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_adic()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_adic

   PARA wMADIC, lOPEN, lDIPI

   IF ValType( lOPEN ) # "L"
      lOPEN := .T.
   ENDIF
   IF ValType( lDIPI ) # "L"
      lDIPI := .F.
   ENDIF
   mORDEM := IF( wMADIC = 1, ULTIMOREG( ARQWORK4, "ORDEM" ), mNUMERO )
   IF wMADIC = 1
      mORDEM++
   ENDIF
   xORDEM := mORDEM
   xBUSCA := IF( wMADIC = 1, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ), Str( mNUMERO, 8 ) )
   xCOUNT := 1
   IF lOPEN
      WHILE !USEREDE( ARQWORK2, 1, 1 )
      ENDDO
      WHILE !USEREDE( ARQWORK4, 1, 99 )
      ENDDO
   ENDIF
   dbSelectAr( ARQWORK2 )
   dbGoTop()
   dbSeek( xBUSCA )
   WHILE xBUSCA = IF( wMADIC = 1, Str( NRNOTA, 8 ) + Str( FORNECEDO, 5 ), Str( NUMERO, 8 ) ) .AND. !Eof()
      IF wMADIC = 1
         mNUMERO := NRNOTA
         mITEM   := ITEM
      ENDIF
      IF wMADIC = 2
         mITEM := SEQ
         IF Empty( mITEM )
            mITEM := xCOUNT
            xCOUNT++
         ENDIF
         mDATAREF := mDATA
      ENDIF
      mTIPOFOR  := mTIPOCLI
      mDCFONEW  := mCFONEW
      mSUBDOPER := mSUBOPER
      IF TIPOENT = "B"
         IF !Empty( mCFONEWB )
            mDCFONEW := mCFONEWB
         ENDIF
      ENDIF
      mCONSUMO   := CONSUMO
      mDBASEICM  := BASEICM
      mDICM      := ICM
      mDVALICM   := VALORICM
      mDBASEIPI  := BASEIPI
      mDIPI      := IPI
      mDVALIPI   := VALORIPI
      mDCLASSIPI := CLASSIPI
      mDVALORNF  := VALORTOT
      mUNIDADE   := UNID
      mQUANT     := QTDE
      mDIPIPI    := DIPIPI
      mDIPICM    := DIPICM
      mDPISCON   := PISCON
      mDOPER     := ""
      mDIPAM     := ""
      IF lOPEN
         mDOPER := OBTER( "MD04", mDCFONEW, "CFO", 2 )
         mDIPAM := OBTER( "MD04", mDCFONEW, "DIPAM", 2 )
         IF lDIPI
            mDIPIPI := OBTER( "MD04", mDCFONEW, "DIPIPI", 2 )
            mDIPICM := OBTER( "MD04", mDCFONEW, "DIPICM", 2 )
         ENDIF
      ELSE
         dbSelectAr( "MD04" )
         dbGoTop()
         IF dbSeek( mDCFONEW )
            mDOPER := CFO
            mDIPAM := DIPAM
            IF lDIPI
               mDIPIPI := DIPIPI
               mDIPICM := DIPICM
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( ARQWORK2 )
      mISENTAIPI := 0
      mOUTRAIPI  := 0
      mOUTRAICM  := 0
      mISENTAICM := 0
      mCHKIPI    := ""
      IF !Empty( mDIPICM )
         netgrvcam( "DIPICM", mDIPICM )
      ENDIF
      IF !Empty( mDIPIPI )
         netgrvcam( "DIPIPI", mDIPIPI )
      ENDIF
      IF Empty( IPI )
         IF DIPIPI = "I"
            mDBASEIPI  := 0
            mISENTAIPI := VALORTOT
         ENDIF
         IF DIPIPI = "O"
            mDBASEIPI := 0
            mOUTRAIPI := VALORTOT
         ENDIF
      ENDIF
      IF Empty( ICM )
         IF DIPICM = "I"
            mDBASEICM  := 0
            mISENTAICM := VALORTOT
         ENDIF
         IF DIPICM = "O"
            mDBASEICM := 0
            mOUTRAICM := VALORTOT
         ENDIF
      ENDIF
      IF !Empty( ICM ) .AND. VALORTOT > BASEICM
         mDBASEICM := BASEICM
         IF DIPICM = "R"
            mISENTAICM := VALORMER - BASEICM
            mCHKIPI    := "R"
         ENDIF
         IF DIPICM = "O"
            mOUTRAICM := VALORTOT - BASEICM
         ENDIF
         IF DIPICM = "I"
            mISENTAICM := VALORTOT - BASEICM
         ENDIF
      ENDIF
      IF !Empty( IPI ) .AND. VALORTOT > BASEIPI
         mDBASEIPI := BASEIPI
         IF DIPIPI = "O"
            mOUTRAIPI := VALORTOT - BASEIPI
         ENDIF
         IF DIPIPI = "I"
            mISENTAIPI := VALORTOT - BASEIPI
         ENDIF
      ENDIF
      mPULASIN := " "
      IF mDVALORNF < 0.00  // desconto nf manuaus e outros descontos
         mPULASIN := "S"
      ENDIF
      IF TIPOENT = "X"
         cTMPCOD := AllTrim( CODIGO )
         IF cTMPCOD = "SEGURO" .OR. cTMPCOD = "PISCONFINS" ;
               .OR. cTMPCOD = "COMPLEMENTO" .OR. cTMPCOD = "NAOTRIBUTADO" .OR. cTMPCOD = "ACESSORIAS"
            mPULASIN := "S"
         ENDIF
      ENDIF
      NOVOOPA( ARQWORK4, .T. )
      dbSelectAr( ARQWORK2 )
      dbSkip()
   ENDDO
   IF lOPEN
      dbSelectAr( ARQWORK2 )
      dbCloseArea()
      dbSelectAr( ARQWORK4 )
      dbCloseArea()
   ENDIF

// + EOF: m_adic.prg
// +
