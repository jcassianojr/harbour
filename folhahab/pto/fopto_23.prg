// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_23.prg
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


// empresa 89 testes de calculos semanais


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto_23()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_23

   PARA cFILTRO

   CABE2( 'FOPTO_23 - Totalizar o Ponto' )
   aVI    := PEGCX( "I" )
   aFS    := PEGCX( "F" )
   nMES   := MESTRAB
   nANO   := ANOUSO
   aEMP89 := {}


   IF !netuse( "foptoval" )
      RETU .F.
   ENDIF
   IF !dbSeek( nremp )
      dbGoTop()
   ENDIF
   aVAL := { FVAL01, FVAL02, FVAL03, FVAL04, FVAL05, FVAL06, FVAL07, FVAL08, ;
      FVAL09, FVAL10, FVAL11, FVAL12, FVAL13, FVAL14, FVAL15, FVAL16, ;
      FVAL17, FVAL18, FVAL19, FVAL20, FVAL21, FVAL22, FVAL23, FVAL24 }
   aFIN := { FFIN01, FFIN02, FFIN03, FFIN04, FFIN05, FFIN06, FFIN07, FFIN08, ;
      FFIN09, FFIN10, FFIN11, FFIN12, FFIN13, FFIN14, FFIN15, FFIN16, ;
      FFIN17, FFIN18, FFIN19, FFIN20, FFIN21, FFIN22, FFIN23, FFIN24 }

   dbCloseAll()

   IF !NETUSE( "FOPTOBCO",,,,, .F., )
      RETU .F.
   ENDIF
   cBCOTT := BCOTT
   cBCOFT := BCOFT
   dbCloseAll()

   cPN := "PN" + ANOMESW
   cPT := "PT" + ANOMESW
   cPD := "PD" + ANOMESW
   cPS := "PS" + ANOMESW
   cPO := "PO" + ANOMESW

   IF !netuse( pes )
      RETU
   ENDIF
   INITVARS()
   CLRVARS()

   IF ValType( cFILTRO ) = "C"
      FILTRO := cFILTRO
   ELSE
      FILTRO := ""
      FI     := Trim( FILTRO )
      FILTRO := FILTRO( FI )
   ENDIF
   SET FILTER TO &FILTRO

   IF !netuse( cPN )
      dbCloseAll()
      RETURN
   ENDIF

   IF !NETUSE( cPT )
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( cPS )
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( cPO )
      dbCloseAll()
      RETURN
   ENDIF


   IF !netuse( "fo_ptt" )
      dbCloseAll()
      RETURN
   ENDIF
   initvars()
   clrvars()

   IF !netuse( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
      dbCloseAll()
      RETU
   ENDIF
   cALIAS6 := Alias()


   mMES := MESTRAB
   mANO := ANOUSO

   aTOT := Array( 24 )
   aSEM := Array( 24 )
   aUSO := Array( 24 )

   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      dbSelectAr( pes )
      PETELA( 8 )
      IF ( ( Empty( DEMITIDO ) ) .OR. ( Month( DEMITIDO ) >= nMES .AND. Year( DEMITIDO ) >= nANO ) )
         VALPIS( PIS, .T., .F., FIELD->EVINC )
      ENDIF
      TSA := TIPO
      AFill( aTOT, 0 )
      AFill( aSEM, 0 )
      FOR X := 1 TO 24
         cVAR := aVI[ X ]
         IF !Empty( cVAR )
            aTOT[ X ] = &CVAR.
         ENDIF
      NEXT X
      nBCOHRS := 0
      lTEM    := .F.
      EQUVARS()
      NUM     := NUMERO
      NOM     := NOME
      BUSCA   := Str( NUM, 8 )
      nHORBCO := 0
      nDIABCO := 0
      nRECNO  := 0

      dbSelectAr( cALIAS6 )
      nHORBCO := pegsaldobco( NUM, nANOANT, nMESANT, .F. )

      dbSelectAr( "fo_ptt" )
      aTOTANO := PEGTOTANO( NUM, .F. )


      TA01 := aTOTANO[ 1 ]   // inicia totais anuais
      TA02 := aTOTANO[ 2 ]
      TA03 := aTOTANO[ 3 ]
      TA04 := aTOTANO[ 4 ]
      TA05 := aTOTANO[ 5 ]
      TA06 := aTOTANO[ 6 ]
      TA07 := aTOTANO[ 7 ]
      TA08 := aTOTANO[ 8 ]
      TA09 := aTOTANO[ 9 ]
      TA10 := aTOTANO[ 10 ]
      TA11 := aTOTANO[ 11 ]
      TA12 := aTOTANO[ 12 ]
      TA13 := aTOTANO[ 13 ]
      TA14 := aTOTANO[ 14 ]
      TA15 := aTOTANO[ 15 ]
      TA16 := aTOTANO[ 16 ]
      TA17 := aTOTANO[ 17 ]
      TA18 := aTOTANO[ 18 ]
      TA19 := aTOTANO[ 19 ]
      TA20 := aTOTANO[ 20 ]
      TA21 := aTOTANO[ 21 ]
      TA22 := aTOTANO[ 22 ]
      TA23 := aTOTANO[ 23 ]
      TA24 := aTOTANO[ 24 ]

      // 50 %  100%FE/FO 100%N FE/FO 50%N
      TANO59 := aTOTANO[ 5 ] + aTOTANO[ 9 ] + aTOTANO[ 6 ] + aTOTANO[ 17 ]
      lANO59 := tANO59 >= 286

      T01 := T02 := T03 := T04 := T05 := T06 := T07 := T08 := 0
      T09 := T10 := T11 := T12 := T13 := T14 := T15 := T16 := 0
      T17 := T18 := T19 := T20 := T21 := T22 := T23 := T24 := 0


      dbSelectAr( cPN )
      dbGoTop()
      dbSeek( BUSCA )
      WHILE NUMERO = NUM .AND. !Eof()
         lTEM := .T.
         FOR x := 1 TO 24
            cVAR   := "T" + StrZero( X, 2 )
            &cVAR. := aTOT[ X ]
         NEXT x
         AFill( aUSO, 0 )
         FOR X := 1 TO 24
            IF At( "ITAESBRA", ZEMPRESA ) > 0 .OR. At( "IMBRIZI", ZEMPRESA ) > 0   // Calculos especiais Clientes
               nDIFHN := 0
               netreclock()
               IF X = 4 .AND. CTA04 > 0  // 100% 150% (Noturna)
                  IF aTOT[ 4 ] + CTA04 <= 8
                     FIELD->CTA06 := CTA04
                  ELSE
                     IF aTOT[ 4 ] > 8
                        FIELD->CTA19 := CTA04
                     ELSE
                        nDIFHN       := 8 - aTOT[ 4 ]
                        FIELD->CTA06 := nDIFHN
                        FIELD->CTA19 := CTA04 - nDIFHN
                     ENDIF
                  ENDIF
               ENDIF
               IF X = 2 .AND. CTA02 > 0  // 100% 150%
                  IF aTOT[ 2 ] + CTA02 <= 8
                     IF lANO59
                        FIELD->CTA07 := nDIFHN   // 130 %
                        FIELD->CTA09 := 0
                     ELSE
                        FIELD->CTA09 := CTA02  // 100 %
                     ENDIF
                  ELSE
                     IF aTOT[ 2 ] > 8
                        FIELD->CTA10 := CTA02  // 150 %
                     ELSE
                        nDIFHN := 8 - aTOT[ 2 ]
                        IF lANO59
                           FIELD->CTA07 := nDIFHN  // 130 %
                           FIELD->CTA09 := 0
                        ELSE
                           FIELD->CTA09 := nDIFHN  // 100 %
                        ENDIF
                        FIELD->CTA10 := CTA02 - nDIFHN   // 150 %
                     ENDIF
                  ENDIF
               ENDIF
               IF X = 1 .AND. CTA01 > 0  // 50% 75%
                  IF aTOT[ 1 ] + CTA01 <= 30
                     IF lANO59
                        FIELD->CTA08 := CTA01  // 75%
                        FIELD->CTA05 := 0
                     ELSE
                        FIELD->CTA05 := CTA01  // 50%
                     ENDIF
                  ELSE
                     IF aTOT[ 1 ] > 30
                        FIELD->CTA08 := CTA01  // 75%
                     ELSE
                        nDIFHN := 30 - aTOT[ 1 ]
                        IF lANO59
                           FIELD->CTA08 := CTA01   // nDIFHN    // 75%
                           FIELD->CTA05 := 0
                        ELSE
                           FIELD->CTA05 := nDIFHN  // 50%
                           FIELD->CTA08 := CTA01 - nDIFHN  // 75%
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               dbUnlock()
            ENDIF

            cVAR   := aFS[ X ]
            cVARTA := "TA" + StrZero( X, 2 )
            IF !Empty( cVAR )
               aTOT[ X ] = &CVAR.
               aUSO[ X ] := &CVAR.
               &cVARTA.  := aTOTANO[ X ] + &CVAR.  // Soma com o incial para evitar soma acumulativa
            ELSE
               cVAR := "CTA" + StrZero( X, 2 )
               aTOT[ X ] += &cVAR.
               aUSO[ X ] := &CVAR.
               &cVARTA.  := aTOTANO[ X ] + &CVAR.  // Soma com o incial para evitar soma acumulativa
            ENDIF
            cVAR   := "T" + StrZero( X, 2 )
            &cVAR. := aTOT[ X ]

         NEXT X


         IF BCOSN = "S" .OR. BCOHRS <> 0.00
            nBCOHRS := if( Empty( cBCOTT ), nBCOHRS + BCOHRS, &cBCOTT )
         ENDIF
         FOR X := 1 TO 24
            aSEM[ X ] += aUSO[ X ]
         NEXT X
         mDATA := DATA

         dbSelectAr( cPN )
         dbSkip()


         IF DoW( mDATA ) = 1   // .OR. NUMERO <> NUM .OR. Eof() //Total da Semana //1=domingo ou ultima semana
            mSEMINI := mDATA
            WHILE DoW( mSEMINI ) <> 2
               mSEMINI--
            ENDDO
            IF mSEMINI < zdataini
               mSEMINI := zdataini
            ENDIF
            dbSelectAr( cPS )
            dbGoTop()
            IF !dbSeek( Str( NUM, 8 ) + DToS( mDATA ) )
               netrecapp()
               FIELD->NUMERO := NUM
               FIELD->SEMFIM := mDATA
               FIELD->SEMINI := mDATA - 6
               field->NOME   := NOM
               FIELD->MES    := nMES
               FIELD->ANO    := nANO
            ELSE
               netreclock()
            ENDIF
            FOR X := 1 TO 24
               cVAR          := "CTA" + StrZero( X, 2 )
               FIELD->&cVAR. := aSEM[ X ]
            NEXT X
            IF NREMP = 89 .AND. DoW( mDATA ) = 1
               FIELD->CTA04 := Int( CTA03 / 60 ) + ( Mod( CTA03, 60 ) / 100 )
               FIELD->CTA05 := CTA03 - 2190  // IF(NUMERO=99995,1590,2190) 1590 minutos 26h30min 2190 minutos 36h30min agora todos 36:30'
               FIELD->CTA06 := Int( Abs( CTA05 ) / 60 ) + ( Mod( Abs( CTA05 ), 60 ) / 100 )
               AAdd( aEMP89, { NUM, mDATA, CTA03, CTA04, CTA05, CTA06 } )
            ENDIF
            dbUnlock()
            AFill( aSEM, 0 )
         ENDIF

         dbSelectAr( cPN )
      ENDDO
      IF lTEM
         // Fechando os Valores
         FOR W := 1 TO 24
            cVAL := aFIN[ W ]
            IF !Empty( cVAL )
               aTOT[ W ] := &cVAL.
            ENDIF
         NEXT W
         dbSelectAr( cPT )
         dbGoTop()
         IF !dbSeek( NUM )
            netrecapp()
            field->NUMERO := NUM
            field->NOME   := NOM
            FIELD->MES    := nMES
            FIELD->ANO    := nANO
         ELSE
            netreclock()
         ENDIF
         // Calculando as Horas
         FOR X := 1 TO 24
            cVAR         := "CTA" + StrZero( X, 2 )
            field->&cVAR := aTOT[ X ]
         NEXT X
         field->BCOHRS := if( Empty( cBCOFT ), nBCOHRS, &cBCOFT )
         // field->BCOHRS := nBCOHRS
         // Calculando os Valores
         FOR W := 1 TO 24
            IF !Empty( aVAL[ W ] )
               cVAL          := aVAL[ W ]
               fVAL          := "VAL" + StrZero( W, 2 )
               field->&fVAL. := &cVAL.
            ENDIF
         NEXT W
         dbUnlock()
         equvars()
         dbSelectAr( "fo_ptt" )
         dbGoTop()
         IF !dbSeek( Str( mNUMERO, 8 ) + Str( mANO, 4 ) + Str( mMES, 2 ) )
            netrecapp()
         ELSE
            netreclock()
         ENDIF
         replvars()
      ENDIF
      dbSelectAr( pes )
      dbSkip()
   ENDDO
   IF Len( aEMP89 ) > 0
      FOR X := 1 TO Len( aEMP89 )
         dbSelectAr( cPN )
         dbGoTop()
         IF dbSeek( Str( Aemp89[ x,  1 ], 8 ) + DToS( Aemp89[ x,  2 ] ) )
            netreclock()
            field->CTA13 := aEMP89[ X, 3 ]
            field->CTA14 := aEMP89[ X, 4 ]
            field->CTA15 := aEMP89[ X, 5 ]
            field->CTA16 := aEMP89[ X, 6 ]
            dbUnlock()
         ENDIF
      NEXT X
   ENDIF
   dbCloseAll()

   RETURN


// + EOF: fopto_23.prg
// +
