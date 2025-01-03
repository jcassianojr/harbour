// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_37.prg Analise do Ponto
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "INKEY.CH"

function fopto_37()
CABE2( "FOPTO_37 - Analise do Ponto" )

dDATAINI := zdataini
dDATAFIM := zdatafim
cPN      := "PN" + ANOMESW
cPNA     := "PN" + Right( StrZero( nANOANT, 4 ), 2 ) + StrZero( NMESANT, 2 )
cPE      := "PE" + ANOMESW

MDS( "Digite o Periodo " )
@ 24, 40 GET dDATAINI
@ 24, 50 GET dDATAFIM
IF !READCUR()
RETU .F.
ENDIF

FOPTO37()

PADRAO( "FOPTOATR", "FOPTOATR", "STR(mNUMERO,6)+' '+left(mNOME,25)+' '+DTOC(mDATA)+' '+mCODANL+' '+mCOD+' '+mSOD+' '+mBCOSN+' '+STR(mRENT,5,2)+' '+STR(mENT,5,2)+' '+STR(mRSAI,5,2)+' '+STR(mSAI,5,2)", "STR(mNUMERO,8)+DTOS(mDATA)+mCODANL", ;
      "Atraso/Faltas/Saida", ;
      "Numero Nome                      Data    ERR CO SO BH Entr Ent  Said  Sai", ;
      {|| alltrue() }, {|| alltrue() }, {|| gFOPTO37() }, {|| ALLTRUE() }, .T., 2 )

IF ZFECHADO = "S"
ALERTX( "Mês já fechado não sera feito lançamentos" )
RETURN
ENDIF
lLAN11 := MDG( "Lancar 11" )
lLAN35 := MDG( "Lancar 35" )
lLAN24 := MDG( "Lancar 24" )
IF !lLAN11 .AND. !lLAN35 .AND. !lLAN24
RETURN
ENDIF

cPX := "PX" + ANOMESW
CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
IF !netuse( "foptoatr" )
RETURN
ENDIF
IF !netuse( cPX )
dbCloseAll()
RETURN
ENDIF
dbSelectAr( cPX )
initvars()
clrvars()
dbSelectAr( "foptoatr" )
dbGoTop()
WHILE !Eof()
IF ( CODANL = "11" .AND. llan11 ) .OR. ( CODANL = "35" .AND. llan35 ) .OR. ( CODANL = "24" .AND. llan24 )
mNUMERO := NUMERO
mDATA   := DATA
mCONTA  := 1
mHORAS  := HORXXX
mOBS    := OBSATR
dbSelectAr( cPX )
dbGoTop()
IF !dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) + Str( mCONTA, 2 ) )
netrecapp()
replvars()
ENDIF
ENDIF
dbSelectAr( "foptOatr" )
dbSkip()
ENDDO
dbCloseAll()

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO37()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO37

// Pegando Eventos
   aEVED := {}
   aEVEC := {}
   aEVEB := {}
   PegFeriados()


   aFTB := {}
   IF !NETZAP( "foptoatr" )
      RETU .F.
   ENDIF

   IF !NETUSE( "FOPTOCON" )
      RETU .F.
   ENDIF
   IF !dbSeek( nremp )
      dbGoTop()
   ENDIF
   ZTOL01 := TOL01
   ZTOL02 := TOL02
   ZTOL03 := TOL03
   ZTOL04 := TOL04
   ZTOL05 := TOL05
   dbCloseAll()

   IF !netuse( "foptoatr" )
      RETU .F.
   ENDIF
   IF !NETUSE( "FO_RELHR" )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( "FOPTOHRE" )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( PES )
      dbCloseAll()
      RETU .F.
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
   FILTRO := FILTRO( FILTRO )
   SET FILTER TO &FILTRO
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )

   IF !netuse( cPN )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !netuse( cPNA )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !netuse( "TABFALTA" )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( cPE )
      dbCloseAll()
      RETU
   ENDIF

   cPD := "PD" + ANOMESW
   cPP := "PP" + ANOMESW
   cPA := "PA" + ANOMESW
   IF !NETUSE( cPD )
      dbCloseAll()
      RETURN 0
   ENDIF
   IF !NETUSE( cPP )
      dbCloseAll()
      RETURN 0
   ENDIF
   IF !NETUSE( cPA )
      dbCloseAll()
      RETURN 0
   ENDIF


   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      petela( 5 )
      mNUMERO   := NUMERO
      mPIS      := PIS
      mNOME     := NOME
      mGRUPO    := "  "
      mTURNO    := " "
      mSITUACAO := SITUACAO
      lREVESAR  := .F.
      lESCALA   := .F.
      aFOLGA    := {}
      aREF      := {}
      nSAIANT   := 0
      cCODANT   := ""
      dbSelectArea( cPNA )
      dbGoTop()
      IF dbSeek( Str( mNUMERO, 8 ) + DToS( dDATAINI - 1 ) )
         nSAIANT := SAI
         cCODANT := COD
      ENDIF
      IF Empty( nSAIANT )
         dbSelectArea( cPN )
         dbGoTop()
         IF dbSeek( Str( mNUMERO, 8 ) + DToS( dDATAINI - 1 ) )
            nSAIANT := SAI
            cCODANT := COD
         ENDIF
      ENDIF
      PEGHORFIX( mNUMERO )
      dbSelectAr( cPN )
      dbGoTop()
      dbSeek( Str( mNUMERO, 8 ) + DToS( dDATAINI ) )
      WHILE mNUMERO = NUMERO .AND. !Eof()
         // dIAX := DATA
         mDATA := DATA
         nDOW  := DoW( DATA )
         IF DATA >= dDATAINI .AND. DATA <= dDATAFIM
            lESC     := .F.
            aMSGERRO := {}
            RENT     := 0
            RALS     := 0
            RALE     := 0
            RSAI     := 0
            lESCALA  := .F.
            lESCFOL  := .F.
            IF !Empty( mGRUPO ) .AND. mTURNO = "S"   // Reveza e tem escala
               mESCALA := mGRUPO + DToS( DATA )
               dbSelectAr( cPE )
               dbGoTop()
               IF dbSeek( mESCALA )
                  RENT    := ENTREV
                  RALS    := ALIREV
                  RALE    := ALSREV
                  RSAI    := SAIREV
                  lESCALA := .T.
                  IF FOLGASN = "S"
                     lESCFOL := .T.
                  ENDIF
               ELSE
                  lESC := .T.
                  AAdd( aMSGERRO, { "FE", "Falta Escala", 0 } )
               ENDIF
            ELSE   // Horario Fixo
               nDOW := DoW( DATA )
               IF Empty( aREF[ nDOW, 1 ] )  // tOdos dia da semana mesmo horario
                  RENT := aREF[ 8, 1 ]
                  RALS := aREF[ 8, 2 ]
                  RALE := aREF[ 8, 3 ]
                  RSAI := aREF[ 8, 4 ]
               ELSE  // dia da semana com outro horario
                  RENT := aREF[ ndow, 1 ]
                  RALS := aREF[ ndow, 2 ]
                  RALE := aREF[ ndow, 3 ]
                  RSAI := aREF[ ndow, 4 ]
               ENDIF
            ENDIF
            dbSelectAr( cPN )

            peghorflex()

            lNESC := !lESCALA
            DO    := COD = "DO" .OR. SOD = "DO"  // codigo=domingo
            lFOL  := ( COD = "FO" .OR. ( aFOLGA[ nDOW ] = "S" .AND. Lnesc ) ) .AND. Empty( CODREV ) .OR. ( FOLSN = "S" ) .OR. ( lESCFOL )


            lLISTA := .T.
            IF ENT <= ( IF( ENTREV > 0, ENTREV, RENT ) + ZTOL01 )  // entrou no trabalhar no normal ou correcao de horario
               lLISTA := .F.
            ENDIF

            lSAI := .F.
            IF ( sai - ZTOL04 ) < ( IF( SAIREV > 0, SAIREV, RSAI ) ) .AND. !lFOL .AND. ENT > 0 .AND. SAI > 0   // Saiu antes do horario
               AAdd( aMSGERRO, { "SA", "Saida Antecipada", 0 } )
               lSAI := .T.
            ENDIF

            IF COD = "DO" .OR. SOD = "DO" .AND. Empty( ENT ) .AND. Empty( RENT )   // domingo
               lLISTA := .F.
            ENDIF
            IF COD = "SA" .OR. SOD = "SA" .AND. Empty( ENT ) .AND. Empty( RENT )   // sabado
               lLISTA := .F.
            ENDIF
            IF COD = "FO" .OR. SOD = "FO" .AND. Empty( ENT ) .AND. Empty( RENT )   // folga
               lLISTA := .F.
            ENDIF
            IF COD = "FN" .OR. SOD = "FN" .AND. Empty( ENT )   // ferias
               lLISTA := .F.
            ENDIF
            IF COD = "AF" .OR. SOD = "AF" .AND. Empty( ENT )   // Afastado
               lLISTA := .F.
            ENDIF
            IF COD = "FE" .OR. SOD = "FE" .AND. Empty( ENT )   // feriado
               lLISTA := .F.
            ENDIF
            IF COD = "BH" .OR. SOD = "BH" .AND. Empty( ENT )   // banco de horas
               lLISTA := .F.
            ENDIF
            IF COD = "RH" .OR. SOD = "RH" .AND. Empty( ENT )   // reducao de horario
               lLISTA := .F.   // sem jornada
            ENDIF

            // Nao Listas Saida
            IF COD = "DO" .OR. SOD = "DO" .AND. Empty( SAI ) .AND. Empty( RSAI )   // domingo
               lSAI := .F.
            ENDIF
            IF COD = "SA" .OR. SOD = "SA" .AND. Empty( SAI ) .AND. Empty( RSAI )   // sabado
               lSAI := .F.
            ENDIF
            IF COD = "FO" .OR. SOD = "FO" .AND. Empty( SAI ) .AND. Empty( RSAI )   // folga
               lSAI := .F.
            ENDIF
            IF COD = "FN" .OR. SOD = "FN" .AND. Empty( SAI )   // ferias
               lSAI := .F.
            ENDIF
            IF COD = "AF" .OR. SOD = "AF" .AND. Empty( SAI )   // Afastado
               lSAI := .F.
            ENDIF
            IF COD = "FE" .OR. SOD = "FE" .AND. Empty( SAI )   // feriado
               lSAI := .F.
            ENDIF
            IF COD = "BH" .OR. SOD = "BH" .AND. Empty( SAI )   // banco de horas
               lSAI := .F.
            ENDIF
            IF COD = "RH" .OR. SOD = "RH" .AND. Empty( SAI )   // reducao de jornada
               lSAI := .F.
            ENDIF


            lEXT := .F.
            EH   := .F.  // Exedeu horario para extra
            IH   := .F.  // Iniciou HoraRio para extra
            IF ZTOL05 > 0
               IF SAI > 0 .AND. RSAI > 0
                  EH     := CHOR( SAI ) - CHOR( RSAI ) > ZTOL05  // Exedeu horario para extra
                  nEXTRA := CHOR( SAI ) - CHOR( RSAI )
                  IF EH .AND. !lFOL
                     IF nEXTRA > 2
                        AAdd( aMSGERRO, { "EJ", "Excedeu Jornada > 2 horas", 0 } )
                     ELSE
                        AAdd( aMSGERRO, { "EJ", "Excedeu Jornada", 0 } )
                     ENDIF
                  ENDIF
               ENDIF
               IF RENT > 0 .AND. ENT > 0
                  IH     := CHOR( RENT ) - CHOR( ENT ) > ZTOL05  // Iniciou Horaio para extra
                  nEXTRA := CHOR( RENT ) - CHOR( ENT )
                  IF IH .AND. !lFOL
                     IF nEXTRA > 2
                        AAdd( aMSGERRO, { "IA", "Iniciou antecipadamente > 2 horas", 0 } )
                     ELSE
                        AAdd( aMSGERRO, { "IA", "Iniciou antecipadamente", 0 } )
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            IF EXTSN = "T"
               EH := .T.
            ENDIF
            IF EH .OR. IH
               lEXT := .T.
            ENDIF

            IF !Empty( ALE ) .AND. Empty( ALS )
               AAdd( aMSGERRO, { "ER", "Entrada sem Saida Intervalo Refeicao", 0 } )
            ENDIF
            IF !Empty( ALS ) .AND. Empty( ALE )
               AAdd( aMSGERRO, { "SR", "Saida sem Entrada Intervalo Refeicao", 0 } )
            ENDIF
            IF !Empty( ENT ) .AND. Empty( SAI )
               AAdd( aMSGERRO, { "ES", "Entrada Sem Saida", 0 } )
            ENDIF
            IF !Empty( SAI ) .AND. Empty( ENT )
               AAdd( aMSGERRO, { "SE", "Saida Sem Entrada", 0 } )
            ENDIF

            IF !Empty( mSITUACAO ) .AND. ( !Empty( ENT ) .OR. !Empty( SAI ) )
               AAdd( aMSGERRO, { "SI", "Funcionario em situacao: " + mSITUACAO + " marcou o ponto", 0 } )
            ENDIF

            IF ( COD = "FN" .OR. SOD = "FN" ) .AND. ( !Empty( ENT ) .OR. !Empty( SAI ) )
               AAdd( aMSGERRO, { "FN", "Funcionario em Ferias FN marcou o ponto", 0 } )
            ENDIF




            IF ( COD = "SA" .OR. SOD = "SA" ) .AND. nDOW <> 7
               AAdd( aMSGERRO, { "S?", "Codigo SA sem ser sabado", 0 } )
            ENDIF

            IF ( COD = "DO" .OR. SOD = "DO" ) .AND. nDOW <> 1
               AAdd( aMSGERRO, { "D?", "Codigo DO sem ser domingo", 0 } )
            ENDIF

            IF ( COD = "FE" .OR. SOD = "FE" ) .AND. AScan( aEVED, Str( Day( mDATA ), 2 ) + Str( Month( mDATA ), 2 ) ) = 0
               AAdd( aMSGERRO, { "F?", "Codigo FE sem feriado cadastrado", 0 } )
            ENDIF


            nHORA11 := 0
            IF !Empty( nSAIANT ) .AND. !Empty( ENT ) .AND. ENT <= SAI  // .AND.! lFOL
               nHORA11 := 24 - CHOR( nSAIANT )
               nHORA11 += CHOR( ENT )
               IF nHORA11 < 11
                  cMSGERRO := "Saida:" + Str( nSAIANT, 5, 2 ) + " Retorno:" + Str( ENT, 5, 2 ) + " com menos de 11 horas Diferenca=" + Str( 11 - nHORA11, 5, 2 )
                  AAdd( aMSGERRO, { "11", cMSGERRO, 11 - nHORA11 } )
               ENDIF
            ENDIF

            nHORA24 := 0
            IF !Empty( nSAIANT ) .AND. !Empty( ENT ) .AND. ENT <= SAI .AND. cCODANT = "DO"   // .AND.! lFOL
               nHORA24 := 24 - CHOR( nSAIANT )
               nHORA24 += CHOR( ENT )
               IF nHORA24 < 24
                  cMSGERRO := "Saida:" + Str( nSAIANT, 5, 2 ) + " Retorno:" + Str( ENT, 5, 2 ) + " com menos de 24 horas DE Folga=" + Str( 24 - nHORA24, 5, 2 )
                  AAdd( aMSGERRO, { "24", cMSGERRO, 24 - nHORA24 } )
               ENDIF
            ENDIF



            IF ENT > 0 .AND. SAI > 0 .AND. ( COD = "FE" .OR. SOD = "FE" )
               nEXTRA := CHOR( ENT ) - CHOR( SAI )
               IF nEXTRA > 8
                  AAdd( aMSGERRO, { "EF", "Extra no Feridado >8 horas", 0 } )
               ELSE
                  AAdd( aMSGERRO, { "EF", "Extra no Feridado", 0 } )
               ENDIF
            ENDIF


            IF lFOL .AND. ENT > 0 .AND. SAI > 0 .AND. ( COD = "DO" .OR. COD = "SA" .OR. COD = "FO" )
               nEXTRA := CHOR( ENT ) - CHOR( SAI )
               IF nEXTRA > 8
                  AAdd( aMSGERRO, { "FT", "Folga Trabalhada >8 Horas", 0 } )
               ELSE
                  AAdd( aMSGERRO, { "FT", "Folga Trabalhada", 0 } )
               ENDIF
               mDT := mDATA
               IF DoW( mDT ) = 1
                  mDT++
               ENDIF
               IF DoW( mDT ) = 7
                  mDT += 2
               ENDIF
               IF AScan( aFTB, Str( mNUMERO, 8 ) + DToS( mDT ) ) = 0
                  AAdd( aFTB, Str( mNUMERO, 8 ) + DToS( mDT ) )
               ENDIF
            ENDIF

            nPASSAGENS := VERPASSAGENS( mNUMERO, DATA, .F., .F., mPIS )
            IF nPASSAGENS > 1 .AND. Int( nPASSAGENS / 2 ) <> nPASSAGENS / 2
               AAdd( aMSGERRO, { "PI", "Passagens impares Favor descartar desnecessarias", 0 } )
            ENDIF
            dbSelectAr( cPN )

            IF Len( aMSGERRO ) > 0
               aVAL := { RSAI, SAI, RENT, ENT, COD, SOD, DATA, BCOSN }
               // 1    2    3   4   5   6   7    8
               FOR i := 1 TO Len( aMSGERRO )
                  dbSelectAr( "foptoatr" )
                  netrecapp()
                  foptoatr->numero := mNUMERO
                  foptoatr->nome   := mNOME
                  foptoatr->DATA   := AvaL[ 7 ]
                  foptoatr->ent    := aVAL[ 4 ]
                  foptoatr->rent   := AVAL[ 3 ]
                  foptoatr->rsai   := aVAL[ 1 ]
                  foptoatr->sai    := AVAL[ 2 ]
                  foptoatr->COD    := aVAL[ 5 ]
                  foptoatr->SOD    := AVAL[ 6 ]
                  foptoatr->bcosn  := aval[ 8 ]
                  foptoatr->codanl := aMSGERRO[ I, 1 ]
                  foptoatr->obsatr := aMSGERRO[ I, 2 ]
                  foptoatr->HORXXX := aMSGERRO[ I, 3 ]
               NEXT
            ENDIF
         ENDIF
         dbSelectAr( cPN )
         nSAIANT := SAI
         cCODANT := COD
         dbSkip()
      ENDDO
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   FOR i := 1 TO Len( aFTB )
      nHORAS  := 0
      mNUMERO := 0
      dbSelectAr( cPN )
      dbGoTop()
      IF dbSeek( aFTB[ i ] )   // segunda
         mNUMERO := NUMERO
         mDATA   := DATA
         IF ent > 0
            nHORAS += CHOR( ENT )
         ELSE
            Nhoras += 24
         ENDIF
         dbSkip( - 1 )   // domingo
         IF numero = mNUMERO .AND. ent <= sai
            IF ent = 0 .OR. sai = 0
               Nhoras += 24
            ELSE
               IF ent > 0
                  nHORAS += CHOR( ENT )
               ENDIF
               IF sai > 0
                  nHORAS += 24 - CHOR( SAI )
               ENDIF
            ENDIF
         ENDIF
         dbSkip( - 1 )
         lSAB := numero = mNUMERO .AND. COD = "SA"
         IF numero = mNUMERO .AND. COD = "SA" .AND. ent <= sai   // sabado folga
            IF ent = 0 .OR. sai = 0
               Nhoras += 24
            ELSE
               IF ent > 0
                  nHORAS += CHOR( ENT )
               ENDIF
               IF sai > 0
                  nHORAS += 24 - CHOR( SAI )
               ENDIF
            ENDIF
         ENDIF
         IF numero = mNUMERO .AND. COD <> "SA" .AND. ent <= sai  // sabado trabalhado so saida
            IF ent = 0 .OR. sai = 0
               Nhoras += 24
            ELSE
               IF sai > 0
                  nHORAS += 24 - CHOR( SAI )
               ENDIF
            ENDIF
         ENDIF
         IF lSAB   // Folga no sabado pego saida da sexta
            dbSkip( - 1 )  // domingo
            IF numero = mNUMERO .AND. ent <= sai
               IF ent = 0 .OR. sai = 0
                  Nhoras += 24
               ELSE
                  IF sai > 0
                     nHORAS += 24 - CHOR( SAI )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF nHORAS < 35 .AND. mNUMERO > 0
         mNOME := ""
         dbSelectAr( pes )
         dbGoTop()
         IF dbSeek( mNUMERO )
            mNOME := NOME
         ENDIF
         dbSelectAr( "foptoatr" )
         netrecapp()
         foptoatr->numero := mNUMERO
         foptoatr->nome   := mNOME
         foptoatr->DATA   := mDATA
         foptoatr->codanl := "35"
         foptoatr->obsatr := "Folga Inferior a 35"
         foptoatr->HORXXX := 35 - nhoras
      ENDIF
      dbSelectAr( cPN )
   NEXT i

   dbCloseAll()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO37()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO37

   IF ZFECHADO = "S"
      ALERTX( "MES JA FECHADO" )
      RETURN .F.
   ENDIF
   cTMP := " "
   CLSBOX( 03, 0, 24, 79 )

   verpassagens( mNUMERO, mDATA, .T., .T. )
   nSALDO := pegsaldobco( mNUMERO, nANOANT, nMESANT, .T. )

   @ 04, 01 SAY mNUMERO
   @ 04, 15 SAY mNOME
   @ 06, 01 SAY mDATA
   @ 06, 10 SAY mENT
   @ 06, 16 SAY mRENT
   @ 06, 30 SAY mSAI
   @ 06, 36 SAY mRSAI
   @ 06, 47 SAY mCODANL
   @ 06, 50 SAY mCOD
   @ 06, 53 SAY mSOD
   @ 07, 00 SAY mOBSATR
   @ 08, 30 SAY "Banco"
   @ 08, 36 SAY mBCOSN
   @ 08, 49 SAY StrZero( nMESANT, 2 ) + "/" + StrZero( nANOANT, 4 )
   @ 08, 57 SAY nSALDO                                    PICT "9999.99"


   @ 23, 00 SAY "(O)ocorrencia|Horario(A)vulso|Correcao(H)orario|(E)mail|(C)reditosAvulsos (D)escarte"
   @ 24, 78 GET cTMP                                                                                   PICT "@!" VALID cTMP $ "OAHEC "
   readcur()


   aOLD := { mNUMERO, mNOME, mDATA, mENT, mRENT, mSAI, mRSAI, mCOD, mSOD, mBCOSN, mHORXXX, mOBSATR }
// 1      2    3      4    5    6    7     8    9    10       11     12
   DO CASE
   CASE cTMP = "O"
      cPO := "PO" + ANOMESW
      CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )
      CRIARVARS( cPO )
      mNUMERO := aOLD[ 1 ]
      mOCOINI := aOLD[ 3 ]
      tFOPTO4t()
      gFOPTO4t()
      NOVOREG( cPO, cPO, Str( mNUMERO, 8 ) + DToS( mOCOINI ) )
   CASE cTMP = "A"
      cPM := "PM" + ANOMESW
      CHECKCRI( cPM, "FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )
      CRIARVARS( cPM )
      mNUMERO := aOLD[ 1 ]
      mDATOCO := aOLD[ 3 ]
      mTIPOCO := "T"
      tFOPTO4m()
      gFOPTO4m()
      NOVOREG( cPM, cPM, Str( mNUMERO, 8 ) + DToS( mDATOCO ) + mTIPOCO )
   CASE cTMP = "H"
      cPH := "PH" + ANOMESW
      CHECKCRI( cPH, "FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )
      CRIARVARS( cPH )
      mNUMERO := aOLD[ 1 ]
      mOCOINI := aOLD[ 3 ]
      tFOPTO4L()
      gFOPTO4L()
      NOVOREG( cPH, cPH, Str( mNUMERO, 8 ) + DToS( mOCOINI ) )
   CASE cTMP = "C"
      cPX := "PX" + ANOMESW
      CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
      CRIARVARS( cPX )
      mNUMERO := aOLD[ 1 ]
      mDATA   := aOLD[ 3 ]
      mCONTA  := 1
      mHORAS  := aOLD[ 11 ]
      mOBS    := aOLD[ 12 ]
      tFOPTO48()
      gFOPTO48()
      NOVOREG( cPX, cPX, Str( mNUMERO, 8 ) + DToS( mDATA ) + Str( mCONTA, 2 ) )
   CASE cTMP = "D"
      CRIARVARS( "AFDTERR" )
      mNUMERO := aOLD[ 1 ]
      mDATA   := aOLD[ 3 ]
      mHORAS  := 0.00  // aqui pode ser qualquer horario do dia a descartar
      iAFDTERR()   // uso o include para pegar a data
      TELASAY( "AFDTER" )
      EDITSAY( "AFDTER" )
      NOVOREG( "AFDTERR", "AFDTERR", ( mNUMero, 8 ) + DToS( mDATA ) + Str( mHORA, 5, 2 ) )
      gAFDTERR()   // grava pd com TIPOM='D'
   CASE cTMP = "E"
      cASSUNTO  := PadR( "Ponto:" + DToC( mDATA ) + " " + Str( mNUMERO, 8 ) + " " + mNOME, 60 )
      cCORPOMSG := PadR( mOBSATR, 60 )
      FILETOEMAIL(, cASSUNTO, cCORPOMSG )
   OTHERWISE
      RETURN .T.
   END CASE
   mNUMERO := aOLD[ 1 ]
   mNOME   := aOLD[ 2 ]
   mDATA   := aOLD[ 3 ]
   mENT    := aOLD[ 4 ]
   mRENT   := aOLD[ 5 ]
   mSAI    := aOLD[ 6 ]
   mRSAI   := aOLD[ 7 ]
   mCOD    := aOLD[ 8 ]
   mSOD    := aOLD[ 9 ]
   mBCOSN  := aOLD[ 10 ]
   mHORXXX := aOLD[ 11 ]
   mOBSATR := aOLD[ 12 ]

   RETURN .T.


// + EOF: fopto_37.prg
// +
