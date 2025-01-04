// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_26.prg Calculando Ponto
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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



FUNCTION fopto_26()

   CABE2( 'FOPTO_26 - Calculando Ponto' )
   FN   := 8 / 7   // Fator do Adicional Noturno
   FDIA := 7.33
   aBCO := {}
   aFOR := {}
   aTOL := {}

   aEVED := {}
   aEVEC := {}
   aEVEB := {}
   PegFeriados()


// IF ! MDG("Calcular o Ponto")
// RETU
// ENDIF

   aRELFXREF := {}
   IF !NETUSE( "PTOHOREF" )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      AAdd( aRELFXREF, { RELOGIO, HORINI, HORFIM } )
      dbSkip()
   ENDDO
   dbCloseArea()


   IF !NETUSE( "FOPTOCON" )
      RETU .F.
   ENDIF
   IF !dbSeek( nremp )
      dbGoTop()
   ENDIF
   FOR X := 1 TO 24
      cVAR := "OP" + StrZero( X, 2 )
      AAdd( aFOR, &cVAR )
      IF X < 11
         cVAR := "TOL" + StrZero( X, 2 )
         AAdd( aTOL, &cVAR )
      ENDIF
   NEXT X
// 1 //ENTRADA
// 2 //SAIDA REFEICAO
// 3 //ENTRADA REFEICAO
// 4 //SAIDA
// 5 //EXTRA
// 6 //ENTRADA
// 7 //SAIDA
// 8 //ENTRADA
// 9 //SAIDA
   dbCloseAll()

   IF !NETUSE( "FOPTOBCO",,,,, .F., )
      RETU .F.
   ENDIF
   FOR X := 1 TO 24
      cVAR := "BCO" + StrZero( X, 2 )
      AAdd( aBCO, &cVAR )
   NEXT X
   AAdd( aBCO, BCOHR )
   dbCloseAll()

   cPN := "PN" + ANOMESW
   cPT := "PT" + ANOMESW
   cPD := "PD" + ANOMESW
   cPE := "PE" + ANOMESW
   cPX := "PX" + ANOMESW
   cPA := "PA" + ANOMESW

   IF !NETUSE( cPN )
      RETU
   ENDIF
   FILTRO := FILTRO( "" )
   SET FILTER TO &FILTRO

// IF ! MDG("Iniciar Calcular do Ponto")
// dbcloseall()
// RETU
// /ENDIF

   IF !NETUSE( "FO_RELHR" )
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( "FOPTOHRE" )
      dbCloseAll()
      RETU
   ENDIF


   IF !NETUSE( PES )
      dbCloseAll()
      RETURN
   ENDIF
   INITVARS()
   CLRVARS()

   IF !NETUSE( cPE )
      dbCloseAll()
      RETURN
   ENDIF

   IF !NETUSE( cPX )
      dbCloseAll()
      RETURN
   ENDIF

   IF !NETUSE( cPA )
      dbCloseAll()
      RETURN
   ENDIF

   IF !NETUSE( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
      dbCloseAll()
      RETU
   ENDIF
   cSELE6 := Alias()


   dbSelectArea( cPN )
   GRAPP := 1
   GRAPT := LastRec()
   GRAPT( 'AGUARDE CALCULANDO O PONTO ' )
   dbGoTop()
   WHILE !Eof()
      NUM    := NUMERO
      mGRUPO := "  "
      mTURNO := " "
      lSAD   := .F.
      hSAIA  := 0

      aFOLGA    := {}
      aREF      := {}
      dDATAREF1 := CToD( Space( 8 ) )
      peghorfix( num )

      dbSelectAr( cSELE6 )
      nSALDOBCO := pegsaldobco( NUM, nANOANT, nMESANT )
      nVALBCO   := 0


      dbSelectAr( pes )
      dbGoTop()
      IF dbSeek( NUM )
         PETELA( 9 )
         EQUVARS()
      ELSE
         CLRVARS()
      ENDIF
      IF Empty( dDATAREF1 )
         dDATAREF1 := mADMITIDO
      ENDIF
      lT1 := mTIPO = "1" .OR. mTIPO = "M"
      lT5 := mTIPO = "5" .OR. mTIPO = "H"


      dbSelectArea( cPN )
      WHILE NUM = NUMERO .AND. !Eof()
         IF Empty( DATA )  // Evita Erro data em Branco
            dbSkip()
            LOOP
         ENDIF
         IF Empty( NUMERO )  // Evita Erro Numero em Branco
            dbSkip()
            LOOP
         ENDIF
         mDATA     := DATA
         nDOW      := DoW( DATA )
         vEXT      := 0
         vEXTALM   := 0
         vEXTNEW   := 0
         vEXT2OLD  := 0
         vEXT2     := 0
         vEXTVIR   := 0  // Extras Virada Noite Folga
         VBCO01    := 0
         VBCO01OLD := 0
         lBCO      := if( BCOSN = "S", .T., .F. )
         lRED      := if( REDSN = "S", .T., .F. )
         lNRED     := !lRED
         RENT      := 0
         RALS      := 0
         RALE      := 0
         RSAI      := 0
         lESCALA   := .F.
         lESCFOL   := .F.



         IF Empty( CODREV )  // N„o h  horario codificado
            IF !Empty( mGRUPO ) .AND. mTURNO = "S"   // Reveza e tem escala
               lESCALA := .F.
               mESCALA := mGRUPO + DToS( DATA )
               dbSelectAr( cPE )
               dbGoTop()
               IF dbSeek( mESCALA )
                  lESCALA := .T.
                  RENT    := CHOR( ENTREV )
                  RALS    := CHOR( ALIREV )
                  RALE    := CHOR( ALSREV )
                  RSAI    := CHOR( SAIREV )
                  IF FOLGASN = "S"
                     lESCFOL := .T.
                  ENDIF
               ENDIF
               dbSelectAr( cPN )
            ELSE
               IF Empty( aREF[ nDOW, 1 ] )
                  IF aFOLGA[ nDOW ] <> "S"   // Se nao for folga pega padrao
                     RENT := CHOR( aREF[ 8, 1 ] )
                     RALS := CHOR( aREF[ 8, 2 ] )
                     RALE := CHOR( aREF[ 8, 3 ] )
                     RSAI := CHOR( aREF[ 8, 4 ] )
                  ENDIF
               ELSE
                  RENT := CHOR( aREF[ nDOW, 1 ] )
                  RALS := CHOR( aREF[ nDOW, 2 ] )
                  RALE := CHOR( aREF[ nDOW, 3 ] )
                  RSAI := CHOR( aREF[ nDOW, 4 ] )
               ENDIF
            ENDIF
         ELSE  // Horario Especifico do dia
            RENT := CHOR( ENTREV )
            RALS := CHOR( ALIREV )
            RALE := CHOR( ALSREV )
            RSAI := CHOR( SAIREV )
         ENDIF


         peghorflex()


// --------------Inicio Formulas-------------------//

// Horas Em Decimais
         CENT := CHOR( ENT )   // Hora entrada em decimal de hora
         CSAI := CHOR( SAI )   // Hora saida em decimal de hora
         CALS := CHOR( ALS )   // Hora saida almoco em decimal de hora
         CALE := CHOR( ALE )   // Hora entrada almoco em decimal de hora

// Variaves de Preenchimento
         lSAI  := SAI > 0  // Preencheu Saida
         lENT  := ENT > 0  // Preencheu Entrada
         lALS  := ALS > 0  // Preencheu Saida Almoco
         lALE  := ALE > 0  // Preencheu Retorno Almoco
         lCENT := CENT > 0   // Tem Horas Entrada
         lCSAI := CSAI > 0   // Tem Horas Saida
         lCALS := CALS > 0   // Tem Horas Saida Almoco
         lCALE := CALE > 0   // Tem Horas Retorno Almoco

// Horas a Trabalhar
         HREF := RSAI - RENT
         IF !Empty( RSAI ) .AND. !Empty( RENT )  // Horas Reais Noturno
            IF RSAI < RENT
               HREF := 24 - RENT + RSAI
            ENDIF
         ENDIF



// Horas Almocos
         HREA := RALE - RALS
         RALM := RALE - RALS
         HRE1 := HREF - IF( RALS > 0 .AND. RALE > 0, RALM, IF( RENT > 0, 1, 0 ) )  // Horas Referencia Menos 1 (Almoco Indicado)

// Horas Trabalhadas
         HTAB := CSAI - CENT
         HXAB := 0
         HXMI := 0
         IF !Empty( SAI ) .AND. !Empty( ENT )
            HXAB := Int( SAI ) - Int( ENT ) - 1
            HXMI := 0
            IF ( ENT - Int( ENT ) ) > 0
               HXMI += Abs( .60 - ( ENT - Int( ENT ) ) )
            ELSE
               HXAB += 1
            ENDIF
            HXMI += ( SAI - Int( SAI ) )
            IF HXMI > .60
               HXAB += 1
               HXMI -= .60
            ENDIF
            HXAB += HXMI
            IF Round( HXAB - Int( HXAB ), 2 ) >= 0.60
               HXAB := HXAB + 1 - .60
            ENDIF
            HXMI := ( Int( HXAB ) * 60 ) + ( ( HXAB - Int( HXAB ) ) * 100 )
         ENDIF
         IF !Empty( SAI ) .AND. !Empty( ENT )  // Horas Trabalhadas Vigias
            IF SAI < ENT
               HTAB := 24 - CENT + CSAI
            ENDIF
         ENDIF

         BENT  := if( Abs( RENT - CENT ) < aTOL[ 6 ], RENT, CENT )
         BSAI  := if( Abs( RSAI - CSAI ) < aTOL[ 7 ], RSAI, CSAI )
         BENT2 := if( Abs( RENT - CENT ) < aTOL[ 8 ], RENT, CENT )
         BSAI2 := if( Abs( RSAI - CSAI ) < aTOL[ 9 ], RSAI, CSAI )

// Horas Almoco
         IF lALE .AND. lALS
            HALM := CALE - CALS  // Horas no almo‡o
         ELSE
            HALM := 0
         ENDIF

// Horas Reais Horario - Almoco
         IF Round( HREA, 2 ) > .5 .OR. At( "EMPRESA", ZEMPRESA ) > 0 .OR. At( "EMPREMPORARIO", ZEMPRESA ) > 0  // round colocado pela evitar falha
            HATB := HREF - HREA
         ELSE
            HATB := HREF   // horario de turno tambem desconta intervalo
         ENDIF   // pois a empresa e que paga

// Tem algumas horas
         HT  := HTAB > 0
         NHT := !HT

         DIF1 := 0
         DIF2 := 0
// Diferenca Reais Trabalhadas
         IF !Empty( HTAB ) .AND. !Empty( HREF )
            DIF1 := HTAB - HREF  // Horas Trabalhadas - Referencia
            DIF2 := HREF - HTAB  // Horas Referencias - Trabalhada
         ENDIF
         DIF9 := DIF2
         IF RALS > 0 .AND. lCSAI .AND. CSAI <= RALS
            DIF9 := DIF9 - RALM
         ENDIF
         IF RALE > 0 .AND. lCENT .AND. CENT >= RALE
            DIF9 := DIF9 - RALM
         ENDIF

// Codigos
         CO   := !Empty( COD ) .AND. !Empty( SOD )   // Marcou algum codigo
         NCO  := Empty( COD ) .AND. Empty( SOD )   // nao marcou nenhum codigo
         SA   := COD = "SA" .OR. SOD = "SA"  // codigo=sabado
         DO   := COD = "DO" .OR. SOD = "DO"  // codigo=domingo
         FE   := COD = "FE" .OR. SOD = "FE"  // codigo=feriado
         FO   := COD = "FO" .OR. SOD = "FO"  // codigo=folga
         lFN  := COD = "FN" .OR. SOD = "FN"  // ferias
         lINJ := COD = "AI" .OR. COD = "FI" .OR. SOD = "AI" .OR. SOD = "FI"  // Atraso ou Folta Injustificada
         lFD  := COD = "FD" .OR. COD = "FI" .OR. SOD = "FD" .OR. SOD = "FI"  // Faltas DSR ou Faltra Injusticada
         lFD2 := COD = "FD" .OR. SOD = "FD"
         lDF  := COD = "DF" .OR. SOD = "DF"  // evitar confundir dom LFD lFD2
         lFI  := COD = "FI" .OR. SOD = "FI"
         lAP  := COD = "AP" .OR. SOD = "AP"
         lRH  := COD = "RH" .OR. SOD = "RH"
         lAM  := COD = "AM" .OR. SOD = "AM"
         lAX  := COD = "AX" .OR. SOD = "AX"  // codigo=AX
         lAZ  := COD = "AZ" .OR. SOD = "AZ"  // codigo=AZ
         lA5  := COD = "A5" .OR. SOD = "A5"  // codigo=A5 aposentadoria

         IF !Empty( mSITUACAO ) .AND. ( lENT .OR. lSAI )
            ALERTX( "Funcionário em situação: " + mSITUACAO + " marcou o ponto" )
         ENDIF

         IF lFN .AND. ( lENT .OR. lSAI )
            ALERTX( "Funcionário em Ferias FN marcou o ponto" )
         ENDIF


         IF SA .AND. DoW( DATA ) <> 7
            ALERTX( "Codigo SA sem ser sabado" )
         ENDIF
         IF DO .AND. DoW( DATA ) <> 1
            ALERTX( " Codigo DO sem ser domingo" )
         ENDIF
         IF FE .AND. AScan( aEVED, Str( Day( DATA ), 2 ) + Str( Month( DATA ), 2 ) ) = 0
            ALERTX( " Codigo FE sem feriado cadastrado " )
         ENDIF




         lAXZ := lAX .OR. lAZ

// Controle De escala
         lESC  := lESCALA
         lNESC := !lESCALA
         lTRO  := ENT > SAI  // Saida Maior que Entrada


// Folga
         lFOL := ( FO .OR. ( aFOLGA[ nDOW ] = "S" .AND. Lnesc ) ) .AND. Empty( CODREV ) .OR. ( FOLSN = "S" ) .OR. ( lESCFOL )
         NFOL := !lFOL
         IF lESCALA
            DDSR := FO .OR. do
         ELSE
            DDSR := FE .OR. FO .OR. do
         ENDIF
         DOE    := DO .OR. FE
         DNUTI  := FE .OR. FO .OR. DO .OR. SA  // Dia nao util
         DUTI   := !DNUTI  // Dia util
         SAHT   := SA .AND. HT
         SAHTFO := SAHT .AND. lFOL   // Sabado Horas e Folga


// Atraso Entrada

         AE   := lCENT .AND. CENT > RENT + aTOL[ 1 ]
         AEL  := AE .AND. !lFOL
         AELJ := AEL .AND. COD # "AJ" .AND. SOD # "AJ"
         DIF3 := CENT - RENT
// td()
         IF CENT < RALE .AND. CENT > RALS .AND. lCENT .AND. RALS > 0 .AND. RALE > 0 .AND. !lTRO
            DIF3 := DIF3 - ( CENT - RALS )
         ENDIF
         vDIF3 := IF( AELJ, DIF3, 0 )

// Atraso Saida
         AS   := lCSAI .AND. CSAI < RSAI - aTOL[ 4 ]
         ASL  := AS .AND. !lFOL
         ASLJ := ASL .AND. COD # "AJ" .AND. SOD # "AJ"
         DIF4 := RSAI - CSAI
         IF CSAI < RALS .AND. lCSAI .AND. RALS > 0 .AND. !lTRO
            DIF4 := DIF4 - RALM
         ENDIF
         vDIF4 := IF( ASLJ, DIF4, 0 )
         IF EXTSN = "V"
            DIF4  := 0
            vDIF4 := 0
         ENDIF

// FUNCIONARIO ENTRA 22:00 SAI POR EXEMPLO 22:30 com horario das 22:00 as 6:00 virada
         IF VIRADA = "S" .AND. CSAI > 0 .AND. CENT > 0 .AND. ( CSAI > CENT .AND. cSAI > RENT .AND. cSAI < 24.01 )
            DIF4 := ( 24 - cSAI ) + RSAI - RALM
// DIF3:=0
// vDIF3:=0
            AS    := .T.
            ASL   := AS .AND. !lFOL
            ASLJ  := ASL .AND. COD # "AJ" .AND. SOD # "AJ"
            vDIF4 := IF( ASLJ, DIF4, 0 )

         ENDIF

         IF ( DIF3 > 0 .OR. DIF4 > 0 ) .AND. DIF3 < ATOL[ 1 ] .AND. DIF4 < ATOL[ 4 ]   // tolerancia entra e saida nao desconta nada
            DIF3 := 0
            DIF4 := 0
         ENDIF
         IF DIF3 < 0
            DIF3 := 0
         ENDIF
         IF DIF4 < 0
            DIF4 := 0
         ENDIF

// Saida Antecipada Almoco
         AALS  := lCALS .AND. CALS < RALS - aTOL[ 2 ]  // saiu mais cedo para almoco
         AALSL := AALS .AND. !lFOL
         AALSJ := AALS .AND. COD # "AJ" .AND. SOD # "AJ"
         DIF7  := RALS - CALS
         vDIF7 := IF( AALSJ, DIF7, 0 )

// Retorno Atraso Almoco
         AALE  := lCALE .AND. CALE + aTOL[ 3 ] > RALE  // voltou apos o horario almoco
         AALEL := AALS .AND. !lFOL
         AALEJ := AALS .AND. COD # "AJ" .AND. SOD # "AJ"
         DIF8  := CALE - RALE  // Retorno mais tarde Almoco
         vDIF8 := IF( AALEJ, DIF8, 0 )

// Horas Extras
         EH    := .F.  // Exedeu horario para extra
         IH    := .F.  // Iniciou HoraRio para extra
         EIH   := .F.  // ent+sai horario
         DIF05 := 0
         DIF06 := 0
         DIF10 := 0
         IF aTOL[ 5 ] > 0
            IF cSAI > 0 .AND. RSAI > 0
               EH    := CSAI - RSAI > aTOL[ 5 ]  // Exedeu horario para extra
               DIF10 += ( CSAI - RSAI )
            ENDIF
            IF RENT > 0 .AND. CENT > 0
               IH    := RENT - CENT > aTOL[ 5 ]  // Iniciou Horario para extra
               DIF10 += ( RENT - CENT )
            ENDIF
         ENDIF
         IF DIF10 > aTOL[ 5 ]
            EIH := .T.
         ELSE
            DIF10 := 0
         ENDIF
         IF EXTSN = "V"
            EH := .T.
         ENDIF

// td()
         HH   := EH .OR. IH  // Extra entrada ou saida
         EHH  := EH .AND. !lFOL .AND. HT
         IHH  := IH .AND. !lFOL .AND. HT
         DIF5 := CSAI - RSAI   // Excedentes Saida
         DIF6 := RENT - CENT   // Excedentes Entrada

         IF EHH
            IF EXTSN = "V"
               DIF5 := ( 24 - RSAI ) + CSAI
            ENDIF
         ENDIF
         vDIF5  := IF( EHH, DIF5, 0 )
         vDIF6  := IF( IHH, DIF6, 0 )
         vDIF56 := vDIF5 - vDIF6

// Adcional Noturno 7/8
         HRAN := if( SAI > 22.15, ( SAI - 22 ) * FN, 0 ) + if( lTRO .AND. lSAI, if( ENT < 22, 2.29, ( 24 - ENT ) * FN ) + if( SAI > 5, 5.71, SAI * FN ), 0 )
         IF ENT = 0.01
            HRAN += if( SAI > 5, 5.71, SAI * FN )
         ENDIF
         HRANE := if( SAI > 22.15, ( RSAI - 22 ) * FN, 0 ) + if( lTRO .AND. lSAI, if( SAI > 5 .AND. EH, ( 5 - RSAI ) * FN, ( RSAI - CSAI ) * FN ), 0 )
         IF DOE
            HRANE := HRAN
         ENDIF
         HRANR := HRAN - HRANE
         IF HRANR > 8
            HRANR := 8
         ENDIF
         HRANT := CHOR( HRAN )
         IF EH .AND. lTRO .AND. lSAI .AND. SAI > 5
            HRANT += DIF5 * FN
         ENDIF
// HRANT := if( SAI > 22.15, ( SAI - 22 ) * FN, 0 ) + if( lTRO .and. lSAI, if( ENT < 22, 2.29, ( 24 - ENT ) * FN ) +  SAI * FN ,0)

         BENT  := if( Abs( RENT - CENT ) < aTOL[ 6 ], RENT, CENT )
         BSAI  := if( Abs( RSAI - CSAI ) < aTOL[ 7 ], RSAI, CSAI )
         BENT2 := if( Abs( RENT - CENT ) < aTOL[ 8 ], RENT, CENT )
         BSAI2 := if( Abs( RSAI - CSAI ) < aTOL[ 9 ], RSAI, CSAI )

// Adcional Norturno 8/8
         XRAN  := if( BSAI > 22.15, ( BSAI - 22 ), 0 ) + if( lTRO .AND. lSAI, if( BENT < 22, 2, ( 24 - BENT ) ) + if( BSAI > 5, 5, BSAI ), 0 )
         XRANE := if( BSAI > 22.15, ( RSAI - 22 ), 0 ) + if( lTRO .AND. lSAI, if( BSAI > 5 .AND. EH, ( 5 - RSAI ), ( RSAI - CSAI ) ), 0 )
         IF FE .OR. FO .OR. SA
            XRANE := XRAN
         ENDIF
         XRANR := XRAN - XRANE
         IF XRANR > 8
            XRANR := 8
         ENDIF


         DIF4B := RSAI - BSAI  // best Atraso Saida
         IF CSAI - Int( CSAI ) < .33
            DIF4B := RSAI - Int( CSAI )  // best Atraso Saida BCO
            IF Abs( RALS - CSAI ) < 1
               DIF4B--
            ENDIF
         ENDIF
         BTAB  := BSAI - BENT  // Horas Trabalhadas Best
         BTAB2 := BSAI2 - BENT2  // Horas Trabalhadas Best 2
         BTAB3 := BTAB2 - if( BTAB2 > 0 .AND. CSAI > RALS .AND. CSAI > RALE, RALM, 0 )
         IF DDSR .AND. RALS = 0 .AND. RALS = 0 .AND. HALM > 0
            BTAB3 := BTAB3 - HALM  // trabalhou domingo folga nao tem hora referencia descontar almoco
         ENDIF
         IF !Empty( BSAI ) .AND. !Empty( BENT )  // Horas Trabalhadas Vigias
            IF BSAI < BENT
               BTAB  := 24 - BENT + BSAI
               BTAB2 := 24 - BENT2 + BSAI2
               BTAB3 := BTAB2  // - if( BTAB2 > 0 .and. CSAI > RALS .and. CSAI > RALE, RALM, 0 )
            ENDIF
         ENDIF
         lFAL := .F.
         IF !HT .AND. DUTI .AND. !lFN .AND. COD # "AB"
            lFAL := .T.
         ENDIF
         lNJUS  := NCO .OR. lINJ
         lHTO   := HT .AND. lFOL
         lHTN   := HT .AND. NFOL
         lITA01 := COD # "FJ" .AND. COD # "CH" .AND. COD # "AV" .AND. COD # "AT" .AND. COD # "AF" .AND. COD # "DF" .AND. COD # "SN" .AND. COD # "CS" .AND. COD # "LR" .AND. COD # "AP" .AND. COD # "AM"
         lITA02 := !lFN .AND. NFOL .AND. NHT .AND. COD # "SN" .AND. COD # "AT" .AND. COD # "FJ" .AND. COD # "AF" .AND. COD # "AD" .AND. COD # "AJ" .AND. HREF > 0
         lITA03 := lHTN .AND. COD # "AJ" .AND. COD # "AD"
         lITA04 := !EHH .AND. !IHH .AND. BTAB > 0
         lITA05 := lITA03 .AND. !EHH .AND. !FE
         lITA06 := AELJ .AND. lBCO .AND. !FE
         lITA07 := lITA02 .AND. !FE
         lITA08 := lHTO .OR. FE
         lITA09 := lITA07 .OR. COD = "PO"
         vITA01 := BTAB3 * if( DOE, 2, 1 )
         vITA02 := if( lITA05, DIF4B, 0 ) + if( lITA06, DIF3, 0 )
         IF Empty( RSAI ) .AND. lBCO
            DIF5 := BTAB - IF( RALS > 0 .AND. RALE > 0, RALM, 1 )
         ENDIF

         IF FOLSN = "V"
            vEXTVIR := CSAI
         ENDIF
         IF ( EHH .OR. IHH ) .AND. ( DIF5 > aTOL[ 10 ] .OR. DIF6 > aTOL[ 10 ] ) .AND. ( aTOL[ 10 ] > 0 )
            IF DIF5 > 0
               EHH := .T.
            ENDIF
            IF DIF6 > 0
               IHH := .T.
            ENDIF
         ENDIF
         IF EHH
            vEXT += DIF5
         ENDIF
         IF IHH
            vEXT += DIF6
         ENDIF
         IF EXTSN = "T"  // marcado para todas horas extras
            vEXT := BTAB - HREA  // HALM
         ENDIF
         IF EXTSN = "Z"
            vEXT := 0
         ENDIF
         IF EXTSN = "A"  // almoco uma hora
            vEXTALM := 1
         ENDIF
         IF EXTSN = "5"  // almoco meia hora
            vEXTALM := .5
         ENDIF
         IF EIH
            vEXTNEW := DIF10
         ENDIF
         IF NFOL
            vEXT2OLD := vEXT
            vEXT2    := vEXTNEW
         ELSE
            vEXT2OLD := BTAB3
            vEXT2    := BTAB3
         ENDIF
         VBCO01OLD := VEXT2OLD - VITA02  // Extras - Atrasos
         VBCO01    := VEXT2 - VITA02


// Gravando Valores
         dbSelectAr( cPN )
         NETRECLOCK()
         FOR X := 1 TO 24

            cVAR   := "CTA" + StrZero( X, 2 )
            cFOR   := if( lBCO .AND. !Empty( aBCO[ X ] ), aBCO[ X ], aFOR[ X ] )   // Formula Diferente Qdo Bco
            nVALOR := if( Empty( cFOR ), &cVAR, &cFOR )
            IF nVALOR > 999.99
               nVALOR := 0
            ENDIF
            field->&cVAR := nVALOR
         NEXT X
         IF lBCO   // Conta Horas
            cFOR   := aBCO[ 25 ]
            nVALOR := if( Empty( cFOR ), BCOHRS, &cFOR. )
            IF nVALOR > 999.99
               nVALOR := 0
            ENDIF
            FIELD->BCOHRS := nVALOR
         ELSE
            field->BCOHRS := 0
         ENDIF

// Horas trabalhadas
         FIELD->HTRAB := BTAB

         lSAD  := .F.
         hSAIA := 0
         IF !Empty( CSAI ) .AND. !Empty( CENT )  // Horas Trabalhadas Vigias
            IF CSAI < CENT
               lSAD  := .T.
               hSAIA := CSAI
            ENDIF
         ENDIF
// Creditos avulsos
         dbSelectAr( cPX )
         dbGoTop()
         dbSeek( Str( NUM, 8 ) + DToS( mDATA ) )
         WHILE NUM = NUMERO .AND. mDATA = DATA .AND. !Eof()
            IF CONTA > 0 .AND. CONTA < 25
               cCTA   := "CTA" + StrZero( CONTA, 2 )
               nHORAS := HORAS
               dbSelectArea( cPN )
               field->&cCTA := &cCTA + nHORAS
            ENDIF
            dbSelectAr( cPX )
            IF CONTA = 99
               nHORAS := HORAS
               dbSelectArea( cPN )
               field->BCOHRS := BCOHRS + nHORAS
            ENDIF
            dbSelectAr( cPX )
            dbSkip()
         ENDDO
         dbSelectArea( cPN )
         netreclock()
         GRAPS()
         dbSkip()
      ENDDO
   ENDDO
   dbCloseAll()

   FOPTO_23( FILTRO )

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function peghorflex()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION peghorflex()

// Horarios Flexiveis
   IF SOD = "_A"
      RENT := CHOR( ENT )
   ENDIF
   IF SOD = "_9"
      RENT := CHOR( ENT )
   ENDIF
   IF SOD = "_8"
      RENT := CHOR( ENT )
   ENDIF

/*
if mdata<ctod("01/08/2010")  //sem reducao
   IF SOD="_A"
      RSAI := CHOR( ENT + 10)
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT + 9)
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT + 8)
   ENDIF
ENDIF
IF mdata<ctod("01/01/2011")  //1a reducao
   IF SOD="_A"
      RSAI := CHOR( ENT )+9.9
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.9
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.9
   ENDIF
endif
 IF mdata<ctod("01/01/2011")  //2a reducao
 IF SOD="_A"
      RSAI := CHOR( ENT )+9.8
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.8
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.8
   ENDIF
endif
 IF mdata>=ctod("01/07/2011")     //3a reducao
   IF SOD="_A"
      RSAI := CHOR( ENT )+9.7
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.7
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.7
   ENDIF
endif
*/

   IF mdata >= CToD( "01/01/2012" )  // 4a reducao
      IF SOD = "_A"
         RSAI := CHOR( ENT ) + 9.6
      ENDIF
      IF SOD = "_9"
         RSAI := CHOR( ENT ) + 8.6
      ENDIF
      IF SOD = "_8"
         RSAI := CHOR( ENT ) + 7.6
      ENDIF
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function BCOEXTRA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION BCOEXTRA( nVALOR )

   nVALBCO := 0
   IF ValType( nVALOR ) <> 'N'
      RETURN 0
   ENDIF
   IF nSALDOBCO = 0
      RETURN nVALOR
   ENDIF
   IF nVALOR = 0
      RETURN nVALOR
   ENDIF
   IF nSALDOBCO > 0
      RETURN nVALOR
   ENDIF
   nSALDOPOS := nSALDOBCO * -1

   DO CASE
   CASE nSALDOPOS >= nVALOR
      nSALDOBCO := Round( nSALDOBCO, 2 ) + Round( nVALOR, 2 )
      nVALBCO   := nVALOR
      lBCO      := .T.
      nVALOR    := 0
   CASE nVALOR > nSALDOPOS
      nVALOR    := nVALOR - nSALDOPOS
      nVALBCO   := nSALDOPOS
      nSALDOBCO := 0
      lBCO      := .T.
   END CASE

   RETURN nVALOR

// + EOF: fopto_26.prg
// +
