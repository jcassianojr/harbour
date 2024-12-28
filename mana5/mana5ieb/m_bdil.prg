// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdil.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BDIL.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdil()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdil

   PARA cTIPOLIV

   IF ValType( cTIPOLIV ) # "C"
      cTIPOLIV := "S"
   ENDIF

   MDI( " Э Imprimir Livros Fiscal" )

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF



   DO CASE
   CASE cTIPOLIV = "E"
      aRETU := PERFEC( { "MK01", "MK06" }, { "K1", "K6" }, { "MK91", "MK96" } )
   CASE cTIPOLIV = "SE"
      aRETU := PERFEC( { "MK01", "MK09" }, { "K1", "K9" }, { "MK91", "MK90" } )
   CASE cTIPOLIV = "SS"
      aRETU := PERFEC( { "MM01", "MM09" }, { "M1", "M9" }, { "MM91", "MM90" } )
   OTHERWISE
      aRETU := PERFEC( { "MM01", "MM06" }, { "M1", "M6" }, { "MM91", "MM96" } )
   ENDCASE
   nMES         := aRETU[ 1 ]
   nANO         := aRETU[ 2 ]
   ARQWORK1     := aRETU[ 5, 1 ]
   ARQWORK2     := aRETU[ 5, 2 ]
   mCOMPETENCIA := aRETU[ 7 ]


   cTIPOCAN := "T"
   cAPUNEW  := "S"
   @ 22, 00 SAY "Digite o M€s e o ano"
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 22, 40 GET nMES                                          PICT "99"
   @ 22, 45 GET nANO                                          PICT "9999"
   @ 23, 50 GET cTIPOCAN                                      PICT "!"    VALID cTIPOCAN $ "TCN"
   @ 24, 40 GET cAPUNEW                                       PICT "!"    VALID cAPUNEW $ "SN"
   IF !READCUR()
      RETU .F.
   ENDIF

   PRIV wNOME, wINSCR, wCGC, wJUCESPC, wJUCESPD
   PRIV wIMUNICI, wENDERECO, wCIDADE, wESTADO, wCEP, wBAIRRO
   pegempmbdi()


   FILTRO := ''
   DO CASE
   CASE cTIPOLIV = "E"
      FILTRO := RFILORD( "MK06", .F. )
   CASE cTIPOLIV = "SE"
      FILTRO := RFILORD( "MK09", .F. )
   CASE cTIPOLIV = "SS"
      FILTRO := RFILORD( "MM09", .F. )
   OTHERWISE
      FILTRO := RFILORD( "MM06", .F. )
   ENDCASE

// Variaveis do Sistema
   SEQ  := 0
   ZFOL := ZLIM := ZLIV := 0
   ZULT := ZDATA

   DO CASE
   CASE cTIPOLIV = "E"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGE", "FILIME", "FILIVE", "FILANE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   CASE cTIPOLIV = "SE"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISE", "FILIMISE", "FILIVISE", "FILANISE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   CASE cTIPOLIV = "SS"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISS", "FILIMISS", "FILIVISS", "FILANISS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   OTHERWISE
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGS", "FILIMS", "FILIVS", "FILANS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   ENDCASE

   lPRIMEIRO := .T.
   nLISTA    := 8
   CTLIN     := 80
   aTOTGER   := Array( 11 )
   aTOTFOL   := Array( 11 )
   aTOTCOD   := Array( 11 )
   AFill( aTOTGER, 0 )
   AFill( aTOTFOL, 0 )
   AFill( aTOTCOD, 0 )
   aUF  := {}
   aVAL := {}

   IF MDG( "Iniciar Dados" )
      mVAL01 := mVAL02 := mVAL03 := mVAL04 := mVAL05 := mVAL06 := 0
      mVAL07 := mVAL08 := mVAL09 := mVAL10 := mVAL11 := 0
      TELASAY( "MBDIE1" )
      EDITSAY( "MBDIE1" )
      aTOTGER   := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10, mVAL11 }
      aTOTFOL   := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10, mVAL11 }
      lPRIMEIRO := .F.
      CTLIN     := 13
   ENDIF

   IF !USEMULT( { { ARQWORK1, 1, 1 }, { ARQWORK2, 1, 0 }, { "MA01", 1, 1 }, { "MB01", 1, 1 } } )
      RETU .F.
   ENDIF

   MDS( "Imprimindo..." )

   IMPRESSORA()

   IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
      impchr( cIMPEXP )
   ENDIF


   dbSelectAr( ARQWORK2 )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
      ordDestroy( "temp" )
      ordCreate(, "temp", "STR(LOTE,5)" )
      ordSetFocus( "temp" )
   ELSE
      IF cAPUNEW = "N"
         ordDestroy( "temp" )
         ordCreate(, "temp", "STR(LOTE,5)+DOPER+STR(DIPI,4,1)+CHKIPI+STR(DICM,5,2)" )
         ordSetFocus( "temp" )
      ELSE
         ordDestroy( "temp" )
         ordCreate(, "temp", "STR(LOTE,5)+DCFONEW+STR(DIPI,4,1)+CHKIPI+STR(DICM,5,2)" )
         ordSetFocus( "temp" )
      ENDIF
   ENDIF

   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      xORDEM     := ORDEM
      xLOTE      := LOTE
      xDATA      := DATA
      xDATAREF   := DATAREF
      xNUMERO    := NUMERO
      xFORNECEDO := FORNECEDO
      xDOPER     := IF( cAPUNEW = "N", DOPER, DCFONEW )
      xSUBDOPER  := SUBDOPER
      xDIPAM     := DIPAM
      mESPECIE   := ""
      mSERIE     := ""
      mTIPOFOR   := ""
      mFORNECEDO := 0
      xOBS       := ""
      mCHAVE     := xNUMERO
      IF cTIPOLIV = "E" .OR. cTIPOLIV = "SE"
         mCHAVE := Str( xNUMERO, 8 ) + Str( xFORNECEDO, 5 )
      ENDIF
      IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
         mESPECIE   := ESPECIE
         mSERIE     := SERIE
         mTIPOFOR   := TIPOFOR
         mFORNECEDO := FORNECEDO
      ELSE
         dbSelectAr( ARQWORK1 )
         dbGoTop()
         IF dbSeek( mCHAVE )
            mESPECIE   := ESPECIE
            mSERIE     := SERIE
            mTIPOFOR   := TIPOCLI
            mFORNECEDO := FORNECEDO
         ENDIF
      ENDIF
      mNOMEFOR := ""
      mCGCFORN := ""
      mINSCFOR := ""
      mUFFORN  := ""
      mCCM     := ""
      mPESSOA  := ""
      dbSelectAr( if( mTIPOFOR = "C", "MA01", "MB01" ) )
      dbGoTop()
      IF dbSeek( mFORNECEDO )
         mNOMEFOR := NOME
         mCGCFORN := CGC
         mINSCFOR := if( mTIPOFOR = "C", INSCR, IESTADUAL )
         mUFFORN  := ESTADO
         mCCM     := IMUNICIPI
         mPESSOA  := PESSOA
      ENDIF
      dbSelectAr( ARQWORK2 )
      WHILE xLOTE = LOTE .AND. !Eof()
         xDOPER    := IF( cAPUNEW = "N", DOPER, DCFONEW )
         xSUBDOPER := SUBDOPER
         xDIPI     := DIPI
         xDICM     := DICM
         xOBS      := OBS
         xCHKIPI   := CHKIPI
         xCODREC   := ""
         IF cTIPOLIV = "SE" .OR. cTIPOLIV = "SS"
            xCODREC := CODREC
         ENDIF
         WHILE xLOTE = LOTE .AND. xDOPER = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. xDIPI = DIPI .AND. xCHKIPI = CHKIPI .AND. xDICM = DICM .AND. !Eof()
            IF SOMACANCEL()
               aTOTCOD[ 1 ] += DVALORNF
               aTOTCOD[ 2 ] += DBASEICM
               aTOTCOD[ 3 ] += DVALICM
               aTOTCOD[ 4 ] += ISENTAICM
               aTOTCOD[ 5 ] += OUTRAICM
               aTOTCOD[ 6 ] += OBSICM
               aTOTCOD[ 7 ] += DBASEIPI
               aTOTCOD[ 8 ] += DVALIPI
               aTOTCOD[ 9 ] += ISENTAIPI
               aTOTCOD[ 10 ] += OUTRAIPI
               aTOTCOD[ 11 ] += OBSIPI
            ENDIF
            dbSkip()
         ENDDO
         nREFLIS := 6
         IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
            nREFLIS := 6
         ENDIF
         IF cTIPOLIV = "S"
            nREFLIS := 6
         ENDIF
         IF nLISTA > nREFLIS
            IF !lPRIMEIRO
               @ CTLIN, 0 SAY "Sub-total a transportar"
               CTLIN++
               @ CTLIN, 0 SAY mBDIL03()
               CTLIN++
               mBDIL01( { aTOTFOL[ 1 ], aTOTFOL[ 2 ], aTOTFOL[ 3 ], aTOTFOL[ 4 ], aTOTFOL[ 5 ], aTOTFOL[ 6 ] } )
               IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
                  mBDIL01( { 0, aTOTFOL[ 7 ], aTOTFOL[ 8 ], aTOTFOL[ 9 ], aTOTFOL[ 10 ], aTOTFOL[ 11 ] }, .T. )
               ENDIF
            ENDIF
            mBDIL02()
            IF cTIPOLIV = "SE"
               @  1, 0 SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S "
               @  2, 0 SAY "REF.:" + mCOMPETENCIA + " DATA:" + DToC( ZDATA ) + " HORA:" + Left( Time(), 5 ) + " F.:" + Str( ZFOL, 4 )
            ELSE
               @  1, 0 SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S  REF.:" + mCOMPETENCIA + " DATA:" + DToC( ZDATA ) + " HORA:" + Left( Time(), 5 ) + " F.:" + Str( ZFOL, 4 )
               @  2, 0 SAY repl( "-", 132 )
            ENDIF
            DO CASE
            CASE cTIPOLIV = "E"
               @  3, 0 SAY "L I V R O   D E   R E G I S T R O   D E   E N T R A D A S - RE - MODELO P1"
            CASE cTIPOLIV = "SE"
               @  3, 0 SAY "REGISTRO DE SERVICOS TOMADOS OU INTERMEDIADOS DE TERCEIROS - MODELO 56"
            CASE cTIPOLIV = "SS"
               @  3, 0 SAY "REGISTRO DE SERVICOS - MODELO 57"
            OTHERWISE
               @  3, 0 SAY "L I V R O   D E   R E G I S T R O   D E   S A I D A S     - RE - MODELO P2"
            ENDCASE
            @  4, 0 SAY "FIRMA:" + Trim( wNOME )
            // @  4,  7  say wNOME
            IF cTIPOLIV = "SE"
               @  4, 43 SAY "MES OU PERIODO/ANO:" + mCOMPETENCIA
            ELSE
               @  4, 71 SAY "MES OU PERIODO/ANO:" + mCOMPETENCIA
            ENDIF
            CTLIN := 5
            IF cTIPOLIV = "SE"
               @ CTLIN, 0 SAY "INSC.EST.:" + wINSCR + " CNPJ:" + wCGC
               CTLIN++
               @ CTLIN, 0 SAY "JUCESP:" + Trim( wJUCESPC ) + " em" + DToC( wJUCESPD ) + " INSC. Municipal:" + wIMUNICI
            ELSE
               @ CTLIN, 0 SAY "INSC.EST.:" + wINSCR + " CNPJ:" + wCGC + " Jucesp:" + Trim( wJUCESPC ) + " em" + DToC( wJUCESPD ) + " INSC. Municipal:" + wIMUNICI
            ENDIF
            // @  5, 11  say wINSCR
            // @  5, 32  say wCGC
            // @  5, 59  say wJUCESPC
            // @  5, 78  say wJUCESPD
            // @  5, 105 say wIMUNICI
            CTLIN++
            @ CTLIN, 0 SAY "ENDEREЂO:" + AllTrim( wENDERECO ) + " Cidade:" + AllTrim( wCIDADE ) + " Estado:" + wESTADO + " CEP:" + wCEP
            // @  CTLIN, 10  say wENDERECO
            // @  CTLIN, 59  say wCIDADE
            // @  CTLIN, 103 say wESTADO
            // @  CTLIN, 111 say wCEP
            CTLIN++
            IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
               @ CTLIN, 0 SAY repl( "-", 132 )
            ELSE
               @ CTLIN, 0 SAY repl( "-", 80 )
            ENDIF
            CTLIN++
            IF lPRIMEIRO
               lPRIMEIRO := .F.
               CTLIN++
               // CTLIN     :=8
            ELSE
               @ CTLIN, 0 SAY "Sub-total de transporte"
               CTLIN++
               @ CTLIN, 0 SAY mBDIL03()
               CTLIN++
               // CTLIN:= 10
               mBDIL01( { aTOTFOL[ 1 ], aTOTFOL[ 2 ], aTOTFOL[ 3 ], aTOTFOL[ 4 ], aTOTFOL[ 5 ], aTOTFOL[ 6 ] } )
               CTLIN++
               // CTLIN:= 11
               IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
                  mBDIL01( { 0, aTOTFOL[ 7 ], aTOTFOL[ 8 ], aTOTFOL[ 9 ], aTOTFOL[ 10 ], aTOTFOL[ 11 ] }, .T. )
                  CTLIN++
                  // CTLIN := 13
               ELSE
                  @ CTLIN, 0 SAY repl( "-", 80 ) // 132 Traco SS E SE
                  CTLIN++
                  // CTLIN:=12
               ENDIF
            ENDIF
            ZFOL++
            nLISTA := 1
         ENDIF
         nPOS := AScan( aUF, mUFFORN )
         IF nPOS > 0
            aVAL[ nPOS, 1 ] += aTOTCOD[ 1 ]
            aVAL[ nPOS, 2 ] += aTOTCOD[ 2 ]
         ELSE
            AAdd( aUF, mUFFORN )
            AAdd( aVAL, { aTOTCOD[ 1 ], aTOTCOD[ 2 ] } )
         ENDIF
         IF cTIPOLIV = "SE"
            @ CTLIN, 0 SAY "SEQUENCIA-" + StrZero( xLOTE, 5 ) + " DATA ENTRADA-" + DToC( xDATAREF ) + " DATA DOCUMENTO-" + DToC( xDATA )
            CTLIN++
            @ CTLIN, 0 SAY "ESPECIE-" + mESPECIE + " SERIE-" + mSERIE + " NUMERO DOC.-" + Str( xNUMERO, 8 ) + " UF-" + mUFFORN
            CTLIN++
         ELSE
            @ CTLIN, 0 SAY "SEQUENCIA-" + StrZero( xLOTE, 5 ) + " DATA ENTRADA-" + DToC( xDATAREF ) ;
               +" DATA DOCUMENTO-" + DToC( xDATA ) + " ESPECIE-" + mESPECIE + " SERIE-" + mSERIE + " NUMERO DOC.-" ;
               +Str( xNUMERO, 8 ) + IF( cTIPOLIV = "E" .OR. cTIPOLIV = "SE", "", " UF-" + mUFFORN )
            CTLIN++
         ENDIF
         IF cTIPOLIV = "E"
            @ CTLIN, 0 SAY "EMITENTE-" + mNOMEFOR + IF( mPESSOA = "F", " CPF-", " CNPJ-" ) + mCGCFORN + ;
               " INSCR.EST.-" + mINSCFOR + IF( cTIPOLIV = "SE", " CCM-" + mCCM, "" ) + " UF-" + mUFFORN
            CTLIN++
         ENDIF
         IF cTIPOLIV = "SE"
            @ CTLIN, 0 SAY "EMITENTE-" + mNOMEFOR + IF( mPESSOA = "F", " CPF-", " CNPJ-" ) + mCGCFORN
            CTLIN++
            @ CTLIN, 0 SAY "INSCR.EST.-" + mINSCFOR + IF( cTIPOLIV = "SE", " CCM-" + mCCM, "" ) + " UF-" + mUFFORN
            CTLIN++
         ENDIF

         IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
         ELSE
            @ CTLIN, 0 SAY "CODIGO FISCAL-                        CODIGO CONTABIL-" + spac( 17 ) + "OBS-"
            IF cAPUNEW = "N"
               @ CTLIN, 15 SAY xDOPER
               @ CTLIN, 19 SAY xSUBDOPER
            ELSE
               @ CTLIN, 15 SAY xDOPER PICT "@R 9.999"
            ENDIF
            @ CTLIN, 34 SAY xDIPAM
            @ CTLIN, 76 SAY XOBS
            CTLIN++
         ENDIF
         @ CTLIN, 0 SAY mBDIL03()
         CTLIN++
         mXICM := if( aTOTCOD[ 3 ] > 0, "T", "" )
         mXIPI := if( aTOTCOD[ 8 ] > 0, "T", "" )
         mXICM += if( aTOTCOD[ 4 ] > 0, "I", "" )
         mXIPI += if( aTOTCOD[ 9 ] > 0, "I", "" )
         mXICM += if( aTOTCOD[ 5 ] > 0, "O", "" )
         mXIPI += if( aTOTCOD[ 10 ] > 0, "O", "" )
         mXICM += if( aTOTCOD[ 6 ] > 0, "B", "" )
         mXIPI += if( aTOTCOD[ 11 ] > 0, "B", "" )
         IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
            mBDIL01( { aTOTCOD[ 1 ], aTOTCOD[ 2 ], aTOTCOD[ 3 ], aTOTCOD[ 4 ], aTOTCOD[ 5 ], aTOTCOD[ 6 ] }, .F., { "COD.ICMS-", mXICM, xDICM } )
            mBDIL01( { 0, aTOTCOD[ 7 ], aTOTCOD[ 8 ], aTOTCOD[ 9 ], aTOTCOD[ 10 ], aTOTCOD[ 11 ] }, .T., { "COD.IPI -", mXIPI, xDIPI } )
         ELSE
            mBDIL01( { aTOTCOD[ 1 ], aTOTCOD[ 2 ], aTOTCOD[ 3 ], aTOTCOD[ 4 ], aTOTCOD[ 5 ], aTOTCOD[ 6 ] }, .T., { "COD.REC -", XCODREC, "" } )
         ENDIF
         nLISTA++
         FOR X := 1 TO 11
            aTOTGER[ X ] += aTOTCOD[ X ]
            aTOTFOL[ X ] += aTOTCOD[ X ]
         NEXT X
         AFill( aTOTCOD, 0 )
      ENDDO
      dbSelectAr( ARQWORK2 )
   ENDDO
// Total Geral
   @ CTLIN, 0 SAY "Total"
   CTLIN++
   @ CTLIN, 0 SAY mBDIL03()
   CTLIN++

   mBDIL01( { aTOTGER[ 1 ], aTOTGER[ 2 ], aTOTGER[ 3 ], aTOTGER[ 4 ], aTOTGER[ 5 ], aTOTGER[ 6 ] } )
   IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
      mBDIL01( { 0, aTOTGER[ 7 ], aTOTGER[ 8 ], aTOTGER[ 9 ], aTOTGER[ 10 ], aTOTGER[ 11 ] }, .T. )
   ENDIF
   dbCloseAll()
   mBDIL02()
   VIDEO()
   IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
      MBDII( .F. )
   ENDIF
   IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mBDIL01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mBDIL01( aDIZ, lTRACO, aSUB )

   lSUB := .F.
   IF ValType( lTRACO ) # "L"
      lTRACO := .F.
   ENDIF
   IF ValType( aSUB ) = "A"
      lSUB := .T.
   ENDIF
   IF aDIZ[ 1 ] > 0
      @ CTLIN, 3 SAY aDIZ[ 1 ] PICT "@E 9999,999,999.99"
   ENDIF
   IF lSUB
      @ CTLIN, 20 SAY aSUB[ 1 ]
      @ CTLIN, 30 SAY aSUB[ 2 ]
   ENDIF
   @ CTLIN, 37 SAY aDIZ[ 2 ] PICT "@E 9999,999,999.99"
   IF lSUB
      @ CTLIN, 55 SAY aSUB[ 3 ]
   ENDIF
   IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
      @ CTLIN, 63 SAY aDIZ[ 3 ] PICT "@E 999,999.99"
   ELSE
      @ CTLIN, 63 SAY aDIZ[ 3 ] PICT "@E 9999,999,999.99"
   ENDIF
   IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
   ELSE
      @ CTLIN, 81  SAY aDIZ[ 4 ] PICT "@E 9999,999,999.99"
      @ CTLIN, 99  SAY aDIZ[ 5 ] PICT "@E 9999,999,999.99"
      @ CTLIN, 117 SAY aDIZ[ 6 ] PICT "@E 9999,999,999.99"
   ENDIF
   CTLIN++
   IF lTRACO
      IF cTIPOLIV = "SS" .OR. cTIPOLIV = "SE"
         @ CTLIN, 0 SAY repl( "-", 80 )
      ELSE
         @ CTLIN, 0 SAY repl( "-", 132 )
      ENDIF
      CTLIN++
   ENDIF
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mBDIL02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mBDIL02()

   IF ZFOL = ZLIM
      DO CASE
      CASE cTIPOLIV = "E"
         M_BDIN( 4,, xDATAREF )
         ZLIV++
         ZFOL := 1
         M_BDIN( 3,, xDATAREF )
         ZFOL := 2
      CASE cTIPOLIV = "SE"
         M_BDIN( 10,, xDATAREF )
         ZLIV++
         ZFOL := 1
         M_BDIN( 9,, xDATAREF )
         ZFOL := 2
      CASE cTIPOLIV = "SS"
         M_BDIN( 11,, xDATAREF )
         ZLIV++
         ZFOL := 1
         M_BDIN( 12,, xDATAREF )
         ZFOL := 2
      OTHERWISE
         M_BDIN( 2,, xDATAREF )
         ZLIV++
         ZFOL := 1
         M_BDIN( 1,, xDATAREF )
         ZFOL := 2
      ENDCASE
   ENDIF
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mBDIL03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mBDIL03()

   LOCAL cTEXTO

   IF cTIPOLIV == "E" .OR. cTIPOLIV == "S"
      cTEXTO := "VALOR CONT./SUBST." + spac( 19 ) + "BASE DE CALCULO            VALOR ICMS/IPI      VALOR ISENTO      VALOR OUTROS   OBSERVACAO"
   ELSE
      cTEXTO := "VALOR CONT./SUBST." + spac( 19 ) + "BASE DE CALCULO            VALOR ISS"
   ENDIF
   RETU cTEXTO
// + EOF: M_BDIL.PRG

// + EOF: m_bdil.prg
// +
