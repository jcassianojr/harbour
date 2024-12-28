// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2i.prg
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
// +    Function fopto_2i()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_2i

   PARA lPER

   IF ZFECHADO = "S"
      ALERTX( "Mes ja Fechado" )
      RETU .F.
   ENDIF
   IF ValType( lPER ) # "L"
      lPER := .T.
   ENDIF
   CABE2( "FOPTO_2I - Lancar Horarios Avulsos - " + ANOMESW )
   IF lPER
      IF !MDG( "Lancar Horarios Avulsos" )
         RETU .F.
      ENDIF
   ENDIF

   cPM := "PM" + ANOMESW
   cPN := "PN" + ANOMESW
   cPD := "PD" + ANOMESW



   IF !NETUSE( cPM )
      RETU .F.
   ENDIF
   IF !NETUSE( cPN )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( cPD )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( "AFDTERR" )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( PES )
      dbCloseAll()
      RETU .F.
   ENDIF


   dbSelectAr( cPM )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      mPIS    := ''
      dbSelectAr( pes )
      dbGoTop()
      IF dbSeek( mNUMERO )
         mPIS := PIS
      ENDIF
      dbSelectAr( cPM )
      dDAT := DATOCO
      tOCO := TIPOCO
      hOCO := HOROCO
      hOC2 := HOROC2
      hOC3 := HOROC3
      hOC4 := HOROC4
      cZER := IF( Type( "ZERHOR" ) = "C", ZERHOR, " " )  // zerhor competencia antigas
      dbSelectAr( cPN )
      dbGoTop()
      IF dbSeek( Str( mNUMERO, 8 ) + DToS( dDAT ) )
         netreclock()
         IF ( tOCO = "E" .OR. tOCO = "T" ) .AND. !Empty( hOCO )
            field->ENT    := hOCO
            field->MUDENT := "*"
         ENDIF
         IF ( tOCO = "1" .OR. tOCO = "T" ) .AND. !Empty( hOC2 )
            field->ALS    := hOC2
            field->MUDALS := "*"
         ENDIF
         IF ( tOCO = "2" .OR. tOCO = "T" ) .AND. !Empty( hOC3 )
            field->ALE    := hOC3
            field->MUDALE := "*"
         ENDIF
         IF ( tOCO = "N" .OR. tOCO = "S" .OR. tOCO = "T" ) .AND. !Empty( hOC4 )
            field->SAI    := hOC4
            field->MUDSAI := "*"
         ENDIF
         IF Empty( hOCO ) .AND. cZER = "S"
            DO CASE
            CASE tOCO = "E"
               field->ENT    := 0
               field->MUDENT := "*"
            CASE tOCO = "S" .OR. tOCO = "N"
               field->SAI    := 0
               field->MUDSAI := "*"
            CASE tOCO = "1"
               field->ALS    := 0
               field->MUDALS := "*"
            CASE tOCO = "2"
               field->ALE    := 0
               field->MUDALE := "*"
            CASE tOCO = "T"
               field->ENT    := 0
               field->ALS    := 0
               field->ALE    := 0
               field->SAI    := 0
               field->MUDENT := "*"
               field->MUDALS := "*"
               field->MUDALE := "*"
               field->MUDSAI := "*"
            ENDCASE
         ENDIF
         dbUnlock()
      ENDIF
      IF ( tOCO = "E" .OR. tOCO = "T" ) .AND. !Empty( hOCO )
         dbSelectAr( cPD )
         dbGoTop()
         IF !dbSeek( Str( mNUMero, 8 ) + DToS( ddat ) + Str( hOCO, 5, 2 ) )
            netrecapp()
            field->NUMERO := mNUMERO
            FIELD->DATA   := dDAT
            FIELD->HORA   := hOCO
            FIELD->TIPOM  := "E"
            FIELD->TIPOR  := "I"
            IF !Empty( mpIS )
               FIELD->PIS := mPIS
            ENDIF
         ENDIF
      ENDIF
      // IF (tOCO = "1".OR.tOCO="T").AND.! EMPTY(hOC2)
      // ENDIF
      // IF (tOCO = "2".OR.tOCO="T").AND.! EMPTY(hOC3)
      // ENDIF
      IF ( tOCO = "S" .OR. tOCO = "T" .OR. tOCO = "N" ) .AND. !Empty( hOC4 )
         IF tOCO = "N"   // para efeito relogio saida noturno tem que
            dDAT++
         ENDIF
         dbSelectAr( cPD )
         dbGoTop()
         IF !dbSeek( Str( mNUMero, 8 ) + DToS( ddat ) + Str( hOC4, 5, 2 ) )
            netrecapp()
            field->NUMERO := mNUMERO
            FIELD->DATA   := dDAT
            FIELD->HORA   := hOC4
            FIELD->TIPOM  := "S"
            FIELD->TIPOR  := "I"
            IF !Empty( mpIS )
               FIELD->PIS := mPIS
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( cPM )
      dbSkip()
      zei_fort( nLASTREC,,, 1 )
   ENDDO
   dbSelectAr( "AFDTERR" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      mCHAVE  := Str( NUMero, 8 ) + DToS( DATA ) + Str( HORA, 5, 2 )
      mNUMERO := NUMERO
      mDATA   := DATA
      mHORA   := HORA
      IF !Empty( MOTOCO )
         dbSelectAr( cPD )
         dbGoTop()
         IF dbSeek( mCHAVE )
            netreclock()
            field->numero := mNUMERO
            field->DATA   := mDATA
            field->hora   := mHORA
            field->TIPOM  := "D"
         ENDIF
      ENDIF
      dbSelectAr( "AFDTERR" )
      dbSkip()
      zei_fort( nLASTREC,,, 1 )
   ENDDO
   dbCloseAll()


// + EOF: fopto_2i.prg
// +
