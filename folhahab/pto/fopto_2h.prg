// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2h.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto_2h()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_2h

   PARA lPER

   IF ZFECHADO = "S"
      ALERTX( "Mes ja Fechado" )
      RETU .F.
   ENDIF
   IF ValType( lPER ) # "L"
      lPER := .T.
   ENDIF
   CABE2( "FOPTO_2H - Lancar Ocorrencias - " + ANOMESW )
   IF lPER
      IF !MDG( "Lancar Ocorrencias" )
         RETU .F.
      ENDIF
   ENDIF


// Ocorrencias entre meses proximo mes
   nANOPRO := ANOUSO
   nMESPRO := MESTRAB + 1
   IF nMESPRO = 13
      nMESPRO := 1
      nANOPRO := nANOPRO + 1
   ENDIF

   cPRO := "PO" + Right( StrZero( nANOPRO, 4 ), 2 ) + StrZero( NMESPRO, 2 )
   CHECKCRI( cPRO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )


   cPO := "PO" + ANOMESW
   cPN := "PN" + ANOMESW

   IF !NETUSE( cPO )
      RETU .F.
   ENDIF
   IF !NETUSE( cPN )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( cPRO )
      dbCloseAll()
      RETU .F.
   ENDIF



   dbSelectAr( cPO )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dINI    := OCOINI
      dFIM    := OCOFIM
      mCOD    := OCOCOD
      mRED    := OCORED
      mBCO    := OCOBCO
      mFOL    := OCOFOL
      mEXT    := OCOEXT
      mSOD    := OCOSUB
      mALM    := OCOALM
      mMOT    := OCOMOT
      IF Empty( dFIM )
         dFIM := dINI
      ENDIF



      fopto2h()
      IF DFIM > ZDATAFIM
         dbSelectAr( cPRO )
         dbGoTop()
         IF !dbSeek( Str( mNUMERO, 8 ) + DToS( dINI ) )
            netrecapp()
            field->NUMERO := mNUMERO
            field->OCOINI := dINI
         ELSE
            netreclock()
         ENDIF
         field->OCOFIM := dFIM
         field->OCOCOD := mCOD
         field->OCORED := mRED
         field->OCOBCO := mBCO
         field->OCOFOL := mFOL
         field->OCOEXT := mEXT
         field->OCOSUB := mSOD
         field->OCOALM := mALM
         field->OCOMOT := mMOT
         dbUnlock()
      ENDIF
      dbSelectAr( cPO )
      dbSkip()
      zei_fort( nLASTREC,,, 1 )
   ENDDO
   dbCloseAll()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto2h()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fopto2h( lZERCOD )

   LOCAL dFIMTMP

   IF ValType( LZERCOD ) # "L"
      lZERCOD := .F.
   ENDIF
   dINITMP := dINI   // So lanca as competencias
   IF dINITMP < ZDATAINI
      dINITMP := ZDATAINI
   ENDIF
   dFIMTMP := dFIM
   IF dFIMTMP > ZDATAFIM
      dFIMTMP := ZDATAFIM
   ENDIF
   dbSelectAr( cPN )
   FOR J := dINITMP TO dFIMTMP
      @ 24, 00 SAY Str( mNUMERO, 8 ) + " - " + DToC( J )
      dbGoTop()
      IF dbSeek( Str( mNUMERO, 8 ) + DToS( J ) )
         netreclock()
         IF !Empty( mCOD ) .OR. lZERCOD
            field->COD := mCOD
         ENDIF
         IF !Empty( mSOD )
            field->SOD := mSOD
         ENDIF
         IF !Empty( mRED )
            field->REDSN := mRED
         ENDIF
         IF !Empty( mBCO )
            field->BCOSN := mBCO
         ENDIF
         IF !Empty( mFOL )
            field->FOLSN := mFOL
         ENDIF
         IF !Empty( mALM )
            field->ALMOCO := mALM
         ENDIF
         IF !Empty( mEXT )
            field->EXTSN := mEXT
         ENDIF
         dbUnlock()
      ENDIF
   NEXT

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SomaPoCesta()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SomaPoCesta( mNUMERO )

   LOCAL nRETU := 0

   cALIAS := Alias()
   dbSelectAr( cPO )
   dbGoTop()
   dbSeek( Str( mNUMERO, 8 ) )
   WHILE mNUMERO = NUMERO .AND. !Eof()
      IF ABONA = "C"
         nRETU += HRABO
      ENDIF
      dbSkip()
   ENDDO
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN nRETU


// + EOF: fopto_2h.prg
// +
