// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_by6.prg
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

// #INCLUDE "COMANDO.CH"

MDI( " Ý Ficha do Produto Media Interna" )

nALPHA  := 0.5
cMEDIA  := "I"
cTIPMED := "A"

@ 19, 00 SAY "Alpha"
@ 20, 00 SAY "Tipo Calculo Media"
@ 21, 00 SAY "(A)mostra (G)eral"
@ 23, 00 SAY "Gravar Campo"
@ 24, 00 SAY "(M)edia (1)Aux1 (2)Aux2 (I)nt"
@ 19, 50 GET nALPHA
@ 21, 50 GET cTIPMED                         VALID cTIPMED $ "AG"
@ 24, 50 GET cMEDIA                          VALID cMEDIA $ "M12I"
IF !READCUR()
RETU .F.
ENDIF


aRETU := PERFEC( { "MY03" }, { "Y3" }, { "Y399" }, { "DATOPR" } )
cARQ  := aRETU[ 5, 1 ]

IF !USEMULT( { { "MS06", 1, 1 }, { cARQ, 0, 99 }, { "MY03MID", 0, 99 } } )
RETU .F.
ENDIF

dbSelectAr( "MY03MID" )
ZAP
MBY601( 1 )
MBY601( 2 )
dbSelectAr( cARQ )
dbCloseArea()



dbSelectAr( "MS06" )
dbGoTop()
WHILE !Eof()
netreclock()
DO CASE
CASE cMEDIA = "M"
FIELD->PCHORMED := 0
CASE cMEDIA = "I"
FIELD->PCHORAMD := 0
CASE cMEDIA = "1"
FIELD->PCHORAX1 := 0
CASE cMEDIA = "2"
FIELD->PCHORAX2 := 0
ENDCASE
dbUnlock()
dbSkip()
ENDDO




dbSelectAr( "MY03MID" )
dbSetOrder( 2 )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
mCODIGO := CODIGO
mSEQ    := SEQ
mSSQ    := SSQ
nRECINI := RecNo()
nRECFIM := RecNo()

// Conta os Registro
nCONTA := 0
WHILE mCODIGO = CODIGO .AND. SEQ = mSEQ .AND. SSQ = mSSQ .AND. !Eof()
@ 24, 00 SAY RecNo()
nCONTA++
nRECFIM := RecNo()
dbSkip()
ENDDO
nRECPAS := RecNo()
nREGAPA := Round( nCONTA * nALPHA / 2, 0 )

// Marca Inciais
nCONTA := 0
dbGoto( nRECINI )
WHILE mCODIGO = CODIGO .AND. SEQ = mSEQ .AND. SSQ = mSSQ .AND. !Eof()
@ 24, 00 SAY RecNo()
IF nCONTA = nREGAPA
EXIT
ENDIF
nCONTA++
FIELD->TIRADO := .T.
dbSkip()
ENDDO

// Marca Finais
nCONTA := 0
dbGoto( nRECFIM )
WHILE mCODIGO = CODIGO .AND. SEQ = mSEQ .AND. SSQ = mSSQ .AND. !Bof()
@ 24, 00 SAY RecNo()
IF nCONTA = nREGAPA
EXIT
ENDIF
nCONTA++
FIELD->TIRADO := .T.
dbSkip( - 1 )
ENDDO

// Soma Nao Marcados
nQTDDE := 0
nHORAS := 0
nCONTA := 0
nMEDIA := 0
dbGoto( nRECINI )
WHILE mCODIGO = CODIGO .AND. SEQ = mSEQ .AND. SSQ = mSSQ .AND. !Eof()
@ 24, 00 SAY RecNo()
IF !TIRADO
nCONTA++
nQTDDE += QTDDE
nMEDIA += PCHORA
nHORAS += HORAS
ENDIF
dbSkip()
ENDDO

// Grava Media
IF nQTDDE > 0 .AND. nHORAS > 0
dbSelectAr( "MS06" )
dbGoTop()
IF dbSeek( PadR( mCODIGO, 24 ) + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
netreclock()
IF cTIPMED = "G"
DO CASE
CASE cMEDIA = "M"
FIELD->PCHORMED := Round( nQTDDE / nHORAS, 0 )
CASE cMEDIA = "I"
FIELD->PCHORAMD := Round( nQTDDE / nHORAS, 0 )
CASE cMEDIA = "1"
FIELD->PCHORAX1 := Round( nQTDDE / nHORAS, 0 )
CASE cMEDIA = "2"
FIELD->PCHORAX2 := Round( nQTDDE / nHORAS, 0 )
ENDCASE
ENDIF
IF cTIPMED = "A"
DO CASE
CASE cMEDIA = "M"
FIELD->PCHORMED := Round( nMEDIA / nCONTA, 0 )
CASE cMEDIA = "I"
FIELD->PCHORAMD := Round( nMEDIA / nCONTA, 0 )
CASE cMEDIA = "1"
FIELD->PCHORAX1 := Round( nMEDIA / nCONTA, 0 )
CASE cMEDIA = "2"
FIELD->PCHORAX2 := Round( nMEDIA / nCONTA, 0 )
ENDCASE
ENDIF
dbUnlock()
ENDIF
ENDIF

dbSelectAr( "MY03MID" )
dbGoto( nRECPAS )
ENDDO
dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBY601()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MBY601( nPASSO )

   dbSelectAr( cARQ )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   MDS( "Criando Indices" )
   IF nPASSO = 1
      ordDestroy( "temp" )
      ordCreate(, "temp", "codigo+str(seq,3)+str(ssq,3)" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "codig2+str(seq,3)+str(ssq,3)" )
      ordSetFocus( "temp" )
   ENDIF
   MDS( "" )
   @ 24, 60 SAY nPASSO
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      WHILE ( Empty( IF( nPASSO = 1, CODIGO, CODIG2 ) ) .OR. SSQ = 99 .OR. CODMAQ = "TER" .OR. SEQ = 0 .OR. SSQ = 0 ) .AND. !Eof()
         @ 24, 00 SAY RecNo()
         dbSkip()
      ENDDO
      cCODIGO  := IF( nPASSO = 1, CODIGO, CODIG2 )
      mCODIGO  := cCODIGO
      mSEQ     := SEQ
      mSSQ     := SSQ
      mDATAINI := CToD( Space( 8 ) )
      dbSelectAr( "MS06" )
      dbGoTop()
      IF dbSeek( PadR( cCODIGO, 24 ) + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
         mDATAINI := DATAINI
      ENDIF
      dbSelectAr( cARQ )
      WHILE mCODIGO = IF( nPASSO = 1, CODIGO, CODIG2 ) .AND. SEQ = mSEQ .AND. SSQ = mSSQ .AND. !Eof()
         @ 24, 00 SAY RecNo()
         IF !Empty( mDATAINI ) .OR. DATOPR >= mDATAINI
            mHORAS  := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
            mQTDDE  := QTDDE
            mDATOPR := DATOPR
            mHORAS  := Round( mHORAS, 2 )
            mTIRADO := .F.
            mPCHORA := 0
            mINIOPR := INIOPR
            mFIMOPR := FIMOPR
            mPARADA := PARADA
            IF mQTDDE > 0 .AND. mHORAS > 0
               mPCHORA := Round( mQTDDE / mHORAS, 0 )
            ENDIF
            IF mPCHORA > 1 .AND. BXMY03 # "N"
               IF !Empty( mCODIGO )
                  NOVOOPA( "MY03MID" )
               ENDIF
            ENDIF
         ENDIF
         dbSelectAr( cARQ )
         dbSkip()
      ENDDO
      dbSelectAr( cARQ )
   ENDDO


// + EOF: M_BY3.PRG

// + EOF: m_by6.prg
// +
