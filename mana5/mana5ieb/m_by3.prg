// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_by3.prg
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
// +    Source Module => J:\ITAESBRA\M_BY3.PRG
// +
// +    Functions: Function MBY301()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

MDI( " Э Ficha do Produto" )
CTLIN   := 80
nGERITE := 0
nGERMED := 0
nGERQTD := 0
nCORTE  := 125
FILTRO  := ''
FILTRO  := RFILORD( "MY03TMP", .F. )
aLAY    := PEGLAY( "MEXPOR1", "MBY301" )
aRETU   := PERFEC( { "MY03" }, { "Y3" }, { "Y399" }, { "DATOPR" } )
cARQ    := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]
lANAL   := MDG( "Deseja Analitico" )
lPRO    := MDG( "Resumo do Produto" )
lGER    := MDG( "Resumo Geral" )
lGRA    := .F.
IF aRETU[ 6 ] = 2   // Mes Fechado
IF MDG( "Gravar Apura‡„o" )
lGRA := SENHAX( "MBY003" )
ENDIF
ENDIF

// nHANDT:=FCREate("teste.txt")

dINI := dFIM := zDATA
MDS( "Confirme o Periodo %Corte" )
@ 24, 30 GET dINI
@ 24, 40 GET dFIM
@ 24, 50 GET nCORTE PICT "999.99"
IF !READCUR()
RETU .F.
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
// cAE := IMP( "AE" )
// cAC := IMP( "AC" )
cAE := aCHR[ 2 ]
cAC := aCHR[ 1 ]


ZAPARQ( { { "MY03TMP", .F., .F. } } )

IF !USEMULT( { { "MS01", 1, 1 }, { "MS06", 1, 1 }, { cARQ, 1, 1 }, { "MB01", 1, 1 } } )
RETU .F.
ENDIF

IF lGRA
IF !USEREDE( "RDT", 0, 99 )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| ANO = aRETU[ 2 ] .AND. MES = aRETU[ 1 ] }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK
ENDIF

IF MDG( "Checar Codigos Internos" )
dbSelectAr( "MS06" )
dbSetOrder( 6 )
dbSelectAr( carq )
dbSetOrder( 5 )
dbGoTop()
WHILE !Eof()
cCODIGOINT := CODIGOINT
cCODIGO    := ""
nSEQ       := 0
nSSQ       := 0
dbSelectAr( "MS06" )
dbGoTop()
IF dbSeek( cCODIGOINT )
cCODIGO := CODIGO
nSEQ    := SEQ
nSSQ    := SSQ
ENDIF
dbSelectAr( carq )
WHILE cCODIGOINT = CODIGOINT .AND. !Eof()
IF Empty( codigo ) .AND. !Empty( cCODIGO ) .AND. !Empty( CODIGOINT )
netreclock()
FIELD->CODIGO := cCODIGO
FIELD->SEQ    := nSEQ
FIELD->SSQ    := nSSQ
dbUnlock()
ENDIF
dbSkip()
ENDDO
ENDDO
dbSelectAr( "MS06" )
dbSetOrder( 1 )
dbSelectAr( carq )
dbSetOrder( 1 )
ENDIF

dbSelectAr( cARQ )
dbGoTop()
WHILE !Eof()
IF DATOPR >= dINI .AND. DATOPR < dFIM
MBY301( CODIGO )
dbSelectAr( cARQ )
MBY301( CODIG2 )
ENDIF
dbSelectAr( cARQ )
dbSkip()
ENDDO
dbSelectAr( cARQ )
dbCloseArea()

IMPRESSORA()
dbSelectAr( "MY03TMP" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
WHILE !Eof()
cCODIGO := CODIGO
lCOD    := .T.
mNOME   := ""
nITEM   := 0
nMEDIA  := 0
nQTDP   := 0
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( cCODIGO )
mNOME := NOME
ENDIF
VIDEO()
IMPRESSORA()
dbSelectAr( "MY03TMP" )
WHILE cCODIGO = CODIGO .AND. !Eof()
mSEQ    := SEQ
mSSQ    := SSQ
lSEQ    := .T.
nHORAS  := 0
nQTDDE  := 0
mDOPER  := ""
mPCHORA := 0
mPCHOR3 := 0
mPCHOR4 := 0
nDIA    := DATOPR
dbSelectAr( "MS06" )
dbGoTop()
IF dbSeek( cCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
IF nDIA >= DATAINI
mDOPER  := if( lANAL, Left( DESCRI, 60 ), Left( DESCRI, 40 ) )
mPCHORA := PCHORA
mPCHOR3 := PCHOR3
mPCHOR4 := PCHOR4
ENDIF
ENDIF
dbSelectAr( "MY03TMP" )
WHILE cCODIGO = CODIGO .AND. mSEQ = SEQ .AND. mSSQ = SSQ .AND. !Eof()
VIDEO()
@ 24, 00 SAY cCODIGO
@ 24, 30 SAY mSEQ
@ 24, 35 SAY mSSQ
IMPRESSORA()
IF CTLIN > 55
@  0, 0  SAY cAE + "Ficha do Produto"
@  1, 0  SAY cAC + "M_BY3"
@  1, 10 SAY "Competencia: " + cCAB
@  2, 10 SAY "Periodo: " + DToC( dINI ) + " a " + DToC( dFIM )
@  2, 60 SAY Time()
@  2, 70 SAY ZDATA
@  3, 00 SAY "Data"
@  3, 10 SAY "Qtdde"
@  3, 20 SAY "Horas"
@  3, 30 SAY "Media"
@  4, 0  SAY repl( "-", 80 )
CTLIN := 5
lSEQ  := .T.
lCOD  := .T.
ENDIF
IF lCOD
@ CTLIN, 0 SAY repl( "-", 80 )
CTLIN++
@ CTLIN, 0  SAY "Produto: " + Left( cCODIGO, 15 )
@ CTLIN, 30 SAY mNOME
CTLIN++
@ CTLIN, 0 SAY repl( "-", 80 )
CTLIN++
lCOD := .F.
ENDIF
IF lSEQ .AND. lANAL
@ CTLIN, 0 SAY mSEQ
@ CTLIN, 4 SAY mSSQ
@ CTLIN, 9 SAY mDOPER
CTLIN++
IF mPCHOR3 > 0
@ CTLIN, 0 SAY "Tempo Padrao Ajustado para Calculo (Pe‡a Simetrica): Real=" + Str( mPCHOR3 )
CTLIN++
ENDIF
lSEQ := .F.
ENDIF
dbSelectAr( "MY03TMP" )
IF lANAL
@ CTLIN, 00 SAY DATOPR
@ CTLIN, 09 SAY QTDDE                  PICT "999999999"
@ CTLIN, 19 SAY HORAS                  PICT "9999.99"
@ CTLIN, 27 SAY Round( QTDDE / HORAS, 2 ) PICT "9999999.99"
CTLIN++
ENDIF
nHORAS += HORAS
nQTDDE += QTDDE
dbSkip()
ENDDO
nAPURA := 0
IF nQTDDE > 0 .AND. nHORAS > 0
nAPURA := Round( nQTDDE / nHORAS, 2 )
ENDIF
mMEDIA := 0
mCORTE := 0
mMEDI4 := 0
mCORT4 := 0
mMEDIA := PERC( nAPURA, mPCHORA )
IF mMEDIA > nCORTE
mCORTE := mMEDIA
mMEDIA := nCORTE
ENDIF
mMEDI4 := PERC( nAPURA, mPCHOR4 )
IF mMEDI4 > nCORTE
mCORT4 := mMEDI4
mMEDI4 := nCORTE
ENDIF
IF lANAL
@ CTLIN, 0 SAY "Total Dia"
ELSE
@ CTLIN, 0 SAY mSEQ
@ CTLIN, 4 SAY mSSQ
ENDIF
@ CTLIN, 9  SAY nQTDDE  PICT "999999999"
@ CTLIN, 19 SAY nHORAS  PICT "9999.99"
@ CTLIN, 27 SAY nAPURA  PICT "999999.99"
@ CTLIN, 37 SAY mPCHORA PICT "99999"
@ CTLIN, 47 SAY mMEDIA  PICT "9999.99"
IF mCORTE > 0
@ CTLIN, 57 SAY mCORTE PICT "9999.99"
ENDIF
CTLIN++
IF !lANAL
@ CTLIN, 00 SAY Left( mDOPER, 80 )
CTLIN++
IF mPCHOR3 > 0
@ CTLIN, 0 SAY "Tempo Padrao Ajustado para Calculo (Pe‡a Simetrica): Real=" + Str( mPCHOR3 )
CTLIN++
ENDIF
ENDIF
IF mSEQ > 0 .AND. mSSQ > 0 .AND. mMEDIA > 0
IF lGRA
// 'for xTMP=1 to len(aLAY)
// ''    FWRITE(nHANDT,ALAY[1][X],aLAY[2][X])
// ''NEXT
GRAVALAY( aLAY, "RDT",,,, .T., .T. )
// GRAVALAY( aLAY, cARQ, nIND, lOPE, cBUS, lAPE,lLOG)
ENDIF
nITEM++
nMEDIA += mMEDIA
ENDIF
nQTDP += nQTDDE
ENDDO
IF lPRO
@ CTLIN, 00 SAY "Total:"
@ CTLIN, 9  SAY nQTDP    PICT "999999999"
@ CTLIN, 27 SAY nMEDIA   PICT "999999.99"
@ CTLIN, 37 SAY nITEM    PICT "99999"
ENDIF
IF nITEM > 0 .AND. nMEDIA > 0
IF lPRO
@ CTLIN, 47 SAY Round( nMEDIA / nITEM, 2 ) PICT "9999.99"
ENDIF
nGERITE++
nGERMED += nMEDIA / nITEM
ENDIF
IF lPRO
CTLIN++
ENDIF
nGERQTD += nQTDP
dbSelectAr( "MY03TMP" )
ENDDO
dbCloseAll()
IF lGRA
IF nGERITE > 0 .AND. nGERMED > 0
GRAVAMVAR( "RD", Str( aRETU[ 2 ], 4 ) + Str( aRETU[ 1 ], 2 ), "PRPE", "round(nGERMED/nGERITE,2)", 2 )
ENDIF
ENDIF

IF lGER
@ CTLIN, 00 SAY "Total:"
@ CTLIN, 9  SAY nGERQTD  PICT "999999999"
@ CTLIN, 27 SAY nGERMED  PICT "999999.99"
@ CTLIN, 37 SAY nGERITE  PICT "99999"
IF nGERITE > 0 .AND. nGERMED > 0
@ CTLIN, 47 SAY Round( nGERMED / nGERITE, 2 ) PICT "9999.99"
ENDIF
ENDIF
CTLIN++
@ CTLIN, 0 SAY "" // Ajusta Ultima Linha Video
IMPFOL()
IMPEND()
// FCLOSE(nHANDT)

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBY301()
// +
// +    Called from ( m_by3.prg    )   2 - function mby202()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBY301()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBY301( cCODIGO )

   IF Empty( cCODIGO )
      RETU .F.
   ENDIF
// IF CODMAQ="TER" //Pular Terceiros
// retu .F.
// ENDIF
   IF BXMY03 = "N"
      RETU .F.
   ENDIF
   @ 24, 00 SAY NUMERO
   mCHAVE  := cCODIGO
   mSEQ    := SEQ
   mSSQ    := SSQ
   mHORAS  := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
   mQTDDE  := QTDDE
   mDATOPR := DATOPR
   mHORAS  := Round( mHORAS, 2 )
   IF mHORAS <= 0
      IF PARADA = 0 .AND. ( INIOPR <> FIMOPR )
         ALERTX( "Cheque Horas Requisi‡„o" + Str( numero ) )
      ENDIF
      nHORAS := 0
      RETU .F.
   ENDIF
   IF mQTDDE <= 0
      IF PARADA = 0
         ALERTX( "Cheque Quantidade Requisi‡„o" + Str( numero ) )
      ENDIF
      nQTDDE := 0
      RETU .F.
   ENDIF
   dbSelectAr( "MY03TMP" )
   dbGoTop()
   IF !dbSeek( cCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) + DToS( mDATOPR ) )
      netrecapp()
      field->CODIGO := cCODIGO
      field->SEQ    := mSEQ
      field->SSQ    := mSSQ
      field->DATOPR := mDATOPR
   ENDIF
   field->QTDDE := QTDDE + mQTDDE
   field->HORAS := HORAS + mHORAS
   RETU .T.

// + EOF: M_BY3.PRG

// + EOF: m_by3.prg
// +
