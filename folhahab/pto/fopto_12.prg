// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_12.prg
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
// +    Function fopto_12()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_12

   PARA DCORTE, DCORTF, cFILTRO

   CABE2( 'FOPTO_12 - Transferir Relogio para Ponto' )

   lPER := .F.
   IF ValType( DCORTE ) # "D" .AND. ValType( DCORTF ) # "D"
      lPER   := .T.
      DCORTE := zdataini
      DCORTF := zdatafim
      IF !MDG( 'Voce tem certeza' )
         RETU
      ENDIF
      MDS( 'Digite o periodo ' )
      @ 24, 40 GET DCORTE
      @ 24, 60 GET DCORTF
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF

   IF lPER
      IF MDG( "Lancar Correcoes" )
         FOPTO_2I()
         lPER := .F.
      ELSE
         lPER := .T.
      ENDIF
   ELSE
      FOPTO_2I( .F. )
   ENDIF



   cPE := "PE" + ANOMESW
   cPN := "PN" + ANOMESW
   cPD := "PD" + ANOMESW


   MDS( 'Aguarde Estou Transferindo Dados' )
   IF !netuse( cPD )
      RETU
   ENDIF
   IF ValType( cFILTRO ) = "C"
      FILTRO := cFILTRO
   ELSE
      FILTRO := FILTRO( "" )
   ENDIF
   SET FILTER TO &FILTRO
   IF !NETUSE( cPN )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "FO_RELHR" )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( cPE )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( PES )
      dbCloseAll()
      RETU
   ENDIF
   IF !netuse( "FOPTOHRE" )
      dbCloseAll()
      RETU
   ENDIF

   IF !netuse( "escalpad" )
      dbCloseAll()
      RETU .F.
   ENDIF


   @ 24, 00 SAY Space( 80 )
   dbSelectAr( Cpd )
   GRAPP := 1
   GRAPT := LastRec()
   GRAPT( 'AGUARDE TRANSFERINDO DADOS ' )
   dbGoTop()

   WHILE !Eof()
      IF DATA >= DCORTE .AND. DATA <= DCORTF
         mGRUPO  := "  "
         mTURNO  := " "
         mCODREV := " "
         // NUM     := NUMERO         //Numero que passou
         mNUMERO := NUMERO   // Numero que passou ou Corrigido quando provisorio
         mDATA   := DATA
         mPIS    := PIS
         HOR     := 0
         HOR1    := 0
         nALMI   := 0
         nALMF   := 0
         nFALI   := 0
         nFALS   := 0
         RENT    := 0
         RSAI    := 0
         RALS    := 0
         RALE    := 0
         aHORAS  := {}

         @ 24, 00 SAY Space( 80 )
         @ 24, 00 SAY mNUMERO
         @ 24, 10 SAY mDATA
         @ 24, 20 SAY mPIS


         IF !Empty( mPIS )
            dbSelectAr( PES )
            dbSetOrder( 4 )
            dbGoTop()
            IF dbSeek( mPIS )
               lNUMERO := .F.
               WHILE mPIS = PIS .AND. !Eof()   // verifica readmissao transferencia
                  IF NUMERO = mNUMERO
                     lNUMERO := .T.
                     EXIT
                  ENDIF
                  dbSkip()
               ENDDO
               IF !lNUMERO
                  mNUMERO := 0
               ENDIF
               IF NUMERO <> mNUMERO
                  dbSelectAr( cPD )  // salta caso nao haja o funcionario
                  dbSkip()
                  LOOP
               ENDIF
            ELSE
               dbSelectAr( cPD )   // salta caso nao haja o funcionario
               dbSkip()
               LOOP
            ENDIF
            dbSetOrder( 1 )
         ENDIF


         // ******************* Salta caso nao haja o funcionario
         dbSelectAr( PES )
         dbGoTop()
         dbSetOrder( 1 )
         IF !dbSeek( mNUMERO )
            dbSelectAr( cPD )
            WHILE NUMERO = mNUMERO .AND. !Eof()  // NUMERO=NUM
               dbSkip()
            ENDDO
            LOOP
         ENDIF




         dbSelectAr( cPD )
         WHILE NUMERO = mNUMERO .AND. DATA = mDATA .AND. !Eof()
            @ 24, 30 SAY RecNo()
            IF Empty( mPIS ) .OR. PIS = mPIS
               IF HORA > 0 .AND. TIPOM <> "D"
                  nHORA := HORA
                  AAdd( aHORAS, nHORA )
                  IF Empty( HOR )
                     HOR := nHORA
                  ELSE
                     HOR1 := nHORA
                  ENDIF
               ENDIF
            ELSE
               dbSkip()
               LOOP
            ENDIF
            GRAPS()
            dbSkip()
         ENDDO

         FOR K := 1 TO 5
            IF HOR + ( 0.01 * K ) = HOR1
               HOR1 := 0
            ENDIF
         NEXT K

         aTEMPHOR := aHORAS  // Retira Marcacoes Seguidas 5 minutos
         aHORAS   := {}
         FOR J := 1 TO Len( aTEMPHOR )
            nTHORA := aTEMPHOR[ J ]
            lTEM1  := .T.
            FOR K := 1 TO 5
               IF AScan( aTEMPHOR, nTHORA - ( 0.01 * K ) ) > 0
                  lTEM1 := .F.
               ENDIF
            NEXT K
            IF lTEM1
               AAdd( aHORAS, aTEMPHOR[ J ] )
            ENDIF
         NEXT

         // ********************* Pega o Horario Basico do Funcionario
         aFOLGA  := {}
         aREF    := {}
         mMARALM := "S"
         mHORREF := ""
         peghorfix( mNUMERO )

         lESCALA  := .F.
         lSAINOT  := .F.
         lVIRADA  := .F.
         lFERIADO := .F.
         lTROCA   := .F.

         IF !Empty( mGRUPO ) .AND. mTURNO = "S"  // Reveza e tem escala
            mESCALA := mGRUPO + DToS( mDATA )
            mSEQESC := 0
            dbSelectAr( cPE )
            dbGoTop()
            IF dbSeek( mESCALA )
               lESCALA := .T.
               RENT    := CHOR( ENTREV )
               RALS    := CHOR( ALIREV )
               RALE    := CHOR( ALSREV )
               RSAI    := CHOR( SAIREV )
               mCODREV := CODREV
               mSEQESC := SEQ
            ENDIF

            // Dia Seguinte verificar dia anterior
            mESCALA := mGRUPO + DToS( mDATA - 1 )
            dbSelectAr( cPE )
            dbGoTop()
            IF dbSeek( mESCALA )
               IF SAIREV < ENTREV
                  lSAINOT := .T.
               ENDIF
            ELSE
               mSEQESC--// 1 dia do mes com DO pega sequencia da escala
               dbSelectAr( "ESCALPAD" )
               dbGoTop()
               IF dbSeek( mGRUPO + Str( mSEQESC, 2 ) )
                  IF SAIREV < ENTREV
                     lSAINOT := .T.
                  ENDIF
               ENDIF
            ENDIF
            dbSelectAr( cPN )

         ELSE
            IF Empty( aREF[ DoW( mDATA ), 1 ] )
               RENT := CHOR( aREF[ 8, 1 ] )
               RALS := CHOR( aREF[ 8, 2 ] )
               RALE := CHOR( aREF[ 8, 3 ] )
               RSAI := CHOR( aREF[ 8, 4 ] )
            ELSE
               RENT := CHOR( aREF[ DoW( mDATA ), 1 ] )
               RALS := CHOR( aREF[ DoW( mDATA ), 2 ] )
               RALE := CHOR( aREF[ DoW( mDATA ), 3 ] )
               RSAI := CHOR( aREF[ DoW( mDATA ), 4 ] )
            ENDIF
            IF aFOLGA[ DoW( mDATA ) ] = "S" .AND. RENT > RSAI
               lSAINOT := .T.
            ENDIF
            IF aFOLGA[ DoW( mDATA ) ] = "V"  // Virada Noite/Dia
               lVIRADA := .T.
            ENDIF
         ENDIF

         // ****************************************
         CODOLD := ""
         mFOLSN := " "
         dbSelectAr( cPN )   // Abre Arquivo de Ponto
         dbGoTop()
         IF dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) )
            IF !Empty( CODREV )  // Verifica se nAo h  horario especial no dia
               RENT    := CHOR( ENTREV )
               RALS    := CHOR( ALIREV )
               RALE    := CHOR( ALSREV )
               RSAI    := CHOR( SAIREV )
               mCODREV := CODREV
            ENDIF
            CODOLD := COD
            mFOLSN := FOLSN
         ENDIF
         IF ( COD = "FE" .OR. SOD = "FE" ) .AND. RENT > RSAI
            lFERIADO := .T.
         ENDIF
         IF VIRADA = "S"
            lTROCA := .T.
         ENDIF

         // ****************************************
         dbSelectAr( cPN )   // Verifica  se nAo horario especial no dia anterior
         dbGoTop()
         IF dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA - 1 ) )
            IF !Empty( CODREV )  // Verifica se nao h  horario especial no dia
               IF ( aFOLGA[ DoW( mDATA ) ] = "S" .OR. mFOLSN = "S" .OR. CODOLD = "FJ" ) .AND. CHOR( ENTREV ) > CHOR( SAIREV )
                  lSAINOT := .T.   // anterior ajusta saida noturno se hoje for folga
               ENDIF
            ENDIF
            IF lFERIADO
               netreclock()
               FIELD->FOLSN := "V"
               dbUnlock()
            ENDIF
            IF ( COD = "FJ" .OR. COD = "FD" .OR. COD = "FI" ) .AND. lSAINOT  // Falta e Falta Injustificada
               lSAINOT := .F.
            ENDIF
            IF COD = "FN" .OR. ( COD = "FE" .AND. ent = 0 )  // retorno de ferias
               lSAINOT := .F.
            ENDIF
            IF VIRADA = "N"
               lSAINOT := .F.
            ENDIF
         ENDIF

         // Ajusta para Inversao de horarios Vigias//Turno Noturnos
         IF RENT > RSAI
            lTROCA := .T.
         ENDIF

         calchor1( 1 )

         IF !Empty( HOR ) .AND. lVIRADA  // trabalhou a noite saiu manha e voltou a tarde
            mONTEM := mDATA - 1
            FOPTO12GRV( Str( mNUMERO, 8 ) + DToS( mONTEM ), "SAI", "HOR" )
            IF Len( aHORAS ) > 1
               HOR := aHORAS[ 2 ]
            ENDIF
            IF Len( aHORAS ) > 2
               HOR1 := aHORAS[ 3 ]
            ENDIF
            // Ahoras(1) e a saida da noite anterior
            calchor1( 2 )
         ENDIF

         // Evita duplicacoes de horarios
         IF HOR1 = HOR
            HOR1 := 0
         ENDIF

         DO CASE

         CASE lTROCA .AND. !Empty( HOR1 ) .AND. !Empty( HOR ) .AND. HOR1 > HOR
            FOPTO12GRV( Str( mNUMERO, 8 ) + DToS( mDATA ), "ENT", "HOR1" )
            mDATA--
            nDIFF := Abs( aHORAS[ 1 ] - RSAI )
            FOR Z := 2 TO Len( aHORAS )
               IF Abs( aHORAS[ Z ] - RSAI ) < nDIFF
                  nDIFF := Abs( aHORAS[ Z ] - RSAI )
                  HOR   := aHORAS[ Z ]
               ENDIF
            NEXT
            FOPTO12GRV( Str( mNUMERO, 8 ) + DToS( mDATA ), "SAI", "HOR" )

         CASE Empty( HOR1 ) .AND. !Empty( HOR ) .AND. lTROCA .AND. !lSAINOT
            FOPTO12GRV( Str( mNUMERO, 8 ) + DToS( mDATA ), "ENT", "HOR" )

         CASE !Empty( HOR ) .AND. Empty( HOR1 ) .AND. lSAINOT
            mDATA--
            FOPTO12GRV( Str( mNUMERO, 8 ) + DToS( mDATA ), "SAI", "HOR" )


         OTHERWISE
            BUSCA := Str( mNUMERO, 8 ) + DToS( mDATA )
            dbGoTop()
            IF dbSeek( BUSCA )
               netreclock()
               IF !Empty( HOR1 )
                  IF HOR < HOR1
                     field->ENT := HOR
                     field->SAI := HOR1
                  ELSE
                     field->ENT := HOR1
                     field->SAI := HOR
                  ENDIF
               ELSE
                  nHREN := 0
                  nHRSA := 0
                  nFHRE := 0
                  nFHRS := 0
                  IF !Empty( aHORAS ) .AND. !Empty( RENT ) .AND. !Empty( RSAI )
                     FOR j := 1 TO Len( aHORAS )
                        nCALCI := Abs( RENT - aHORAS[ J ] )
                        nCALCS := Abs( RSAI - aHORAS[ J ] )
                        IF ( Empty( nFHRE ) .OR. nFHRE > nCALCI ) .AND. !Empty( nHREN )
                           IF nCALCI = 0
                              nCALCI := .01  // Fixa 1 para nao errar no reprocesso
                           ENDIF
                           nFHRE := nCALCI
                           nHREN := aHORAS[ J ]
                        ENDIF
                        IF Empty( nFHRS ) .OR. nFHRS > nCALCS
                           nFHRS := nCALCS
                           nHRSA := aHORAS[ J ]
                        ENDIF
                     NEXT J
                     field->ENT := nHREN
                     field->SAI := nHRSA
                  ELSE
                     field->ENT := HOR
                  ENDIF
               ENDIF
               FIXENTSAI()
               dbUnlock()
            ENDIF
         ENDCASE

         // Calcula o Almoco
         IF !Empty( aHORAS ) .AND. !Empty( RALS ) .AND. !Empty( RALE )
            FOR j := 1 TO Len( aHORAS )
               nCALCI := Abs( RALS - aHORAS[ J ] - .25 )   // Referencia 15 minutos depois
               nCALCS := Abs( RALE - aHORAS[ J ] )
               IF ( Empty( nFALI ) .OR. nFALI > nCALCI ) .AND. aHORAS[ J ] # ENT
                  IF nCALCI = 0
                     nCALCI := .01   // Fixa 1 para nao errar no reprocesso
                  ENDIF
                  nFALI := nCALCI
                  nALMI := aHORAS[ J ]
               ENDIF
               IF ( Empty( nFALS ) .OR. nFALS > nCALCS ) .AND. aHORAS[ J ] # SAI .AND. aHORAS[ J ] # ENT
                  nFALS := nCALCS
                  nALMF := aHORAS[ J ]
               ENDIF
            NEXT J
            IF nALMF = nALMI .OR. Empty( nALMI )   // Horarios Coincidente tenta o anterior
               nPOSA := AScan( aHORAS, nALMF )
               nPOSA--// Pegar Horario Seguinte
               IF nPOSA >= 2   // 1a. Sempre entrada
                  nTEMPH := aHORAS[ nPOSA ]
                  IF nTEMPH # SAI .AND. nTEMPH # ENT .AND. nTEMPH <> nALMI
                     nALMI := nTEMPH
                  ENDIF
               ENDIF
            ENDIF
            IF nALMF = nALMI .OR. Empty( nALMF )   // Horarios Coincidente tenta o seguinte
               nPOSA := AScan( aHORAS, nALMI )
               nPOSA++// Pegar Horario Seguinte
               IF nPOSA <= Len( aHORAS )
                  nTEMPH := aHORAS[ nPOSA ]
                  IF nTEMPH # SAI .AND. nTEMPH # ENT .AND. nTEMPH <> nALMF
                     nALMF := nTEMPH
                  ENDIF
               ENDIF
            ENDIF

         ENDIF

         // Diversas marcacoes do cartao em menos de cinco minutos
         lGRVALM := .T.
         IF nALMI # ENT .AND. nALMI # SAI
            lGRVALM := .F.
         ENDIF
         IF ENT > 0 .AND. nALMI > 0 .AND. Abs( ENT - nALMI ) > 5
            lGRVALM := .F.
         ENDIF
         IF ENT > 0 .AND. nALMF > 0 .AND. Abs( ENT - nALMF ) > 5
            lGRVALM := .F.
         ENDIF
         IF SAI > 0 .AND. nALMI > 0 .AND. Abs( SAI - nALMI ) > 5
            lGRVALM := .F.
         ENDIF
         IF SAI > 0 .AND. nALMF > 0 .AND. Abs( SAI - nALMF ) > 5
            lGRVALM := .F.
         ENDIF



         netreclock()
         IF !Empty( nALMI ) .AND. !Empty( RALS ) .AND. lGRVALM .AND. Abs( nALMI - RALS ) < 2
            field->ALS := nALMI
         ELSE
            field->ALS := 0
         ENDIF
         IF !Empty( nALMF ) .AND. !Empty( RALE ) .AND. lGRVALM .AND. Abs( nALMF - RALE ) < 2
            field->ALE := nALMF
         ELSE
            field->ALE := 0
         ENDIF
         IF !lTROCA
            IF Empty( SAI ) .AND. !Empty( ENT )
               IF Abs( RENT - ENT ) > Abs( RSAI - SAI )
                  field->SAI := ENT
                  field->ENT := 0
               ENDIF
            ENDIF
            IF Empty( ENT ) .AND. !Empty( SAI )
               IF Abs( RENT - ENT ) < Abs( RSAI - SAI )
                  field->ENT := SAI
                  field->SAI := 0
               ENDIF
            ENDIF
         ENDIF
         IF mMARALM = "N"
            field->ALS := 0
            field->ALE := 0
         ENDIF
         dbUnlock()
         dbSelectAr( cPD )
      ELSE   // Fora data de Corte
         dbSelectAr( cPD )
         dbSkip()
      ENDIF
   ENDDO
   dbCloseAll()

   IF lPER
   ELSE
      // FOPTO_2I(.F.)  acima para lancar aftderr e inclusoes cPM
      FOPTO_2J( .F. )
      FOPTO_2H( .F. )
   ENDIF
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXENTSAI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FIXENTSAI

   IF !Empty( ENT ) .AND. !Empty( SAI ) .AND. !lTROCA .AND. !lSAINOT
      IF Abs( SAI - ENT ) < .15
         field->SAI := 0
      ENDIF
      IF Abs( ENT - SAI ) < .15
         field->SAI := 0
      ENDIF
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO12GRV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO12GRV( eBUSCA, cCAM, cVAL )

   dbGoTop()
   IF dbSeek( eBUSCA )
      netreclock()
      field->&cCAM. := &cVAL.
      FIXENTSAI()
      dbUnlock()
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function calchor1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC calchor1( nINICIO )

   IF !Empty( RENT ) .AND. !Empty( RSAI ) .AND. !Empty( aHORAS ) .AND. !lTROCA
      nHREN := 0
      nHRSA := 0
      nFHRE := 0
      nFHRS := 0
      FOR j := nINICIO TO Len( aHORAS )
         nCALCI := Abs( RENT - aHORAS[ J ] )
         nCALCS := Abs( RSAI - aHORAS[ J ] )
         IF ( Empty( nFHRE ) .OR. nFHRE > nCALCI ) .AND. !Empty( nHREN )
            IF nCALCI = 0
               nCALCI := .01   // Fixa 1 para nao errar no reprocesso
            ENDIF
            nFHRE := nCALCI
            nHREN := aHORAS[ J ]
         ENDIF
         IF Empty( nFHRS ) .OR. nFHRS > nCALCS
            nFHRS := nCALCS
            nHRSA := aHORAS[ J ]
         ENDIF
      NEXT J
      IF !Empty( nHREN )
         HOR := nHREN
      ENDIF
      IF !Empty( nHRSA ) .AND. HOR1 < nHRSA
         HOR1 := nHRSA
      ENDIF
   ENDIF


// + EOF: fopto_12.prg
// +
