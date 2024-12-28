// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_by2.prg
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
// +    Source Module => J:\ITAESBRA\M_BY2.PRG
// +
// +    Functions: Function CABMBY2()
// +               Function CABMBY2B()
// +               Function MBY201()
// +               Function MBY202()
// +
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//
//
//
//
// #INCLUDE "COMANDO.CH"

MDI( " Э Ficha da Maquina" )
CTLIN := 80
aGER  := {}
lANA  := MDG( "Deseja Analitico" )
lDIA  := MDG( "Deseja Resumo Dia" )
lMES  := MDG( "Deseja Resumo Mensal" )
lGER  := MDG( "Deseja Resumo Geral" )
lP24  := MDG( "Escala 24 Somente Dias Escalados" )


FILTRO := ''
FILTRO := RFILORD( "MY03", .F. )

nSEQ    := 0
aRETU   := PERFEC( { "MY03", "MY03A", "ME03" }, { "Y3", "YA", "E3" }, { "Y399", "YA99", "E399" }, { "DATOPR", "PADRAO", "DATA" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQ    := aRETU[ 5, 1 ]
cARQ2   := aRETU[ 5, 2 ]
cARQ3   := aRETU[ 5, 3 ]
cCAB    := aRETU[ 7 ]
lGRA    := .F.
IF aRETU[ 6 ] = 2   // Mes Fechado
lGRA := MDG( "Gravar Apura‡„o" )
IF lGRA
lGRA := SENHAX( "MBY002" )
ENDIF
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
// cAE := IMP( "AE" )
// cAC := IMP( "AC" )
cAE := aCHR[ 2 ]
cAC := aCHR[ 1 ]


IF !USEMULT( { { CARQ, 1, 1 }, { cARQ2, 1, 1 }, { cARQ3, 1, 1 }, { "MS06", 1, 1 }, { "ME01", 1, 1 } } )
RETU .F.
ENDIF

IF lGRA
IF !USEMULT( { { "RD", 0, 99 }, { "RDE", 0, 99 } } )
RETU .F.
ENDIF
dbSelectAr( "RD" )
dbSetOrder( 2 )
dbGoTop()
IF dbSeek( Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
nSEQ := SEQ
ENDIF
IF nSEQ > 0
dbSelectAr( "RDE" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| SEQ = nSEQ }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK
ENDIF
ENDIF

dbSelectAr( cARQ )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "CODMAQ + dtos( DATOPR ) + str( INIOPR, 5, 2 )" )
ordSetFocus( "temp" )



IMPRESSORA()
dbSelectAr( cARQ )
dbGoTop()
WHILE !Eof()
IF CODMAQ = "TER"  // Pula Tratamento Terceiros
WHILE CODMAQ = "TER" .AND. !Eof()
dbSkip()
ENDDO
ENDIF
nCODMAQ := CODMAQ
mNOME   := ""
aMES    := {}
aME2    := {}
lGRAVA  := .T.
dbSelectAr( "ME01" )
dbGoTop()
IF dbSeek( nCODMAQ )
mNOME  := NOME
lGRAVA := if( APUEFI = "N", .F., .T. )
ENDIF
VIDEO()
@ 24, 00 SAY "Maquina: " + nCODMAQ + " " + mNOME
IMPRESSORA()
IF CTLIN # 80
@ CTLIN, 0  SAY "Maquina: " + nCODMAQ
@ CTLIN, 20 SAY mNOME
CTLIN++
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
ENDIF
dbSelectAr( cARQ )
WHILE nCODMAQ = CODMAQ .AND. !Eof()
nDIA := DATOPR
aDIA := { 0, 0, 0, 0, 0 }
WHILE nCODMAQ = CODMAQ .AND. nDIA = DATOPR .AND. !Eof()
IF BXMY03 <> "N" .AND. EXCMAQ <> "S"
mCHAVE  := PadR( CODIGO, 24 ) + Str( SEQ, 3 ) + Str( SSQ, 3 )
nPCHORA := 0
dbSelectAr( "MS06" )
dbGoTop()
IF dbSeek( mCHAVE )
IF nDIA >= DATAINI
nPCHORA := PCHORA
ENDIF
ENDIF
dbSelectAr( cARQ )
nHORAS := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
nHORAS := Round( nHORAS, 2 )
IF nHORAS < 0
ALERTX( "Cheque Horas Requisi‡„o" + Str( numero ) )
nHORAS := 0
ENDIF
IF QTDDE < 0
ALERTX( "Cheque Quantidade Requisi‡„o" + Str( numero ) )
ENDIF
nFEITO := 0
IF QTDDE > 0 .AND. nHORAS > 0.001
nFEITO := Round( QTDDE / nHORAS, 2 )
ENDIF
nHREF := 0
IF nPCHORA > 0 .AND. nFEITO > 0
nHREF := Round( if( nPCHORA > 0, nFEITO / nPCHORA, 0 ), 2 )
ENDIF
nHRE2 := 0
IF QTDDE > 0 .AND. nPCHORA > 0
nHRE2 := Round( if( nPCHORA > 0, QTDDE / nPCHORA, 0 ), 2 )
ENDIF
IF TPMY03 = "S"
nHREF   := 1
nHRE2   := nHORAS
nPCHORA := nFEITO
ENDIF
nPARADA := 0
// Calculos passiveis de implanta‡„o
nPER01 := nHREF * 100
nPER02 := nHREF * 100
nPER03 := 100
aDIA[ 1 ] += nHORAS
aDIA[ 3 ] += nHRE2
aDIA[ 4 ] += QTDDE
netgrvcam( "HORUSO", nHORAS )
IF lANA
CABMBY2( .T. )
@ CTLIN, 0   SAY NUMERO
@ CTLIN, 9   SAY DATOPR
@ CTLIN, 18  SAY Left( CODIGO, 15 )
@ CTLIN, 34  SAY SEQ
@ CTLIN, 38  SAY SSQ
@ CTLIN, 42  SAY CODOPE          PICT "9999"
@ CTLIN, 51  SAY INIOPR          PICT "99.99"
@ CTLIN, 57  SAY FIMOPR          PICT "99.99"
@ CTLIN, 63  SAY nHORAS          PICT "99.99"
@ CTLIN, 69  SAY nPARADA         PICT "99.99"
@ CTLIN, 75  SAY QTDDE           PICT "999999"
@ CTLIN, 82  SAY nFEITO          PICT "9999.99"
@ CTLIN, 90  SAY nPCHORA         PICT "9999"
@ CTLIN, 95  SAY nHRE2           PICT "99.99"
@ CTLIN, 101 SAY nPER01          PICT "999.99"
CTLIN++
ENDIF
mCHAVE := NUMERO
dbSelectAr( cARQ2 )
dbGoTop()
dbSeek( Str( mCHAVE, 8 ) )
WHILE mCHAVE = NUMERO .AND. !Eof()
aDIA[ 2 ] += TEMPO
IF lANA
@ CTLIN, 35 SAY CODPAR
@ CTLIN, 51 SAY PINI         PICT "99.99"
@ CTLIN, 57 SAY PFIM         PICT "99.99"
@ CTLIN, 69 SAY TEMPO        PICT "99.99"
@ CTLIN, 75 SAY Left( OBS, 55 )
CTLIN++
ENDIF
dbSkip()
ENDDO
ENDIF
dbSelectAr( cARQ )
dbSkip()
ENDDO
nESC := 0
dbSelectAr( cARQ3 )
dbGoTop()
IF dbSeek( nCODMAQ + DToS( nDIA ) )
nESC := ESTQINI
ENDIF
IF Empty( nESC )
nTOT := aDIA[ 1 ] + aDIA[ 2 ]
ELSE
nTOT := nESC
ENDIF
nDIF   := nTOT - aDIA[ 2 ]
nTO2   := aDIA[ 1 ] + aDIA[ 2 ]
nDI2   := nTO2 - aDIA[ 2 ]
nPER01 := PERC( aDIA[ 3 ], nDIF )
nPER02 := PERC( aDIA[ 3 ], nTOT )
nPER03 := PERC( aDIA[ 1 ], nTOT )
IF lDIA
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
@ CTLIN, 59  SAY "Esc"
@ CTLIN, 67  SAY "HRs"
@ CTLIN, 75  SAY "Par"
@ CTLIN, 83  SAY "Qtdde"
@ CTLIN, 91  SAY "Hr.Pr."
@ CTLIN, 99  SAY "Efi"
@ CTLIN, 107 SAY "Pro"
@ CTLIN, 115 SAY "Utl"
CTLIN++
MBY202( { "Escala", nDIA, nDIF, nESC, aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ],, "Apontada" )
MBY201( aDIA[ 3 ], aDIA[ 1 ], 24 - aDIA[ 2 ], 24,, "24 Horas" )
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
ENDIF
AAdd( aMES, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, nDIA, aDIA[ 4 ], nESC } )
AAdd( aME2, nCODMAQ + DToS( nDIA ) )
dbSelectAr( cARQ )
ENDDO
aDIA  := { 0, 0, 0, 0, 0 }
nDIAS := 0
dbSelectAr( cARQ3 )
dbGoTop()
dbSeek( nCODMAQ )
WHILE NUMERO = nCODMAQ .AND. !Eof()
IF ESTQINI > 0
nPOS := AScan( aME2, nCODMAQ + DToS( DATA ) )
IF nPOS > 0
aDIA[ 1 ] += aMES[ nPOS, 1 ]
aDIA[ 2 ] += aMES[ nPOS, 2 ]
aDIA[ 3 ] += aMES[ nPOS, 3 ]
aDIA[ 4 ] += aMES[ nPOS, 8 ]   // Qtde
aDIA[ 5 ] += aMES[ nPOS, 9 ]   // Escala
IF lMES
CABMBY2B( .T. )
MBY202( { "", aMES[ nPOS, 7 ], 0, aMES[ nPOS, 9 ], aMES[ nPOS, 1 ], aMES[ nPOS, 2 ], aMES[ nPOS, 8 ], aMES[ nPOS, 3 ], aMES[ nPOS, 4 ], aMES[ nPOS, 5 ], aMES[ nPOS, 6 ] } )
ENDIF
ELSE
aDIA[ 5 ] += ESTQINI
IF lMES
CABMBY2B( .T. )
MBY202( { "", DATA, 0, ESTQINI, 0, 0, 0, 0, 0, 0, 0 } )
ENDIF
ENDIF
IF lP24
nDIAS++// Soma 24 de dias Escalados
ENDIF
ENDIF
IF !lP24
nDIAS++// Soma 24 de dias Escalados
ENDIF
dbSkip()
ENDDO

dbSelectAr( cARQ )
IF Empty( aDIA[ 5 ] )
nTOT := aDIA[ 1 ] + aDIA[ 2 ]
ELSE
nTOT := aDIA[ 5 ]
ENDIF
nPER01 := PERC( aDIA[ 3 ], nTOT - aDIA[ 2 ] )
nPER02 := PERC( aDIA[ 3 ], nTOT )
nPER03 := PERC( aDIA[ 1 ], nTOT )
nPER04 := PERC( aDIA[ 3 ], aDIA[ 1 ] )
nPER05 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )
nPER06 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )

nPER07 := PERC( aDIA[ 3 ], ( 24 * nDIAS ) - aDIA[ 2 ] )
nPER08 := PERC( aDIA[ 3 ], 24 * nDIAS )
nPER09 := PERC( aDIA[ 1 ], 24 * nDIAS )

IF lMES
MBY201( aDIA[ 3 ], aDIA[ 1 ], nTOT - aDIA[ 2 ], nTOT, { aDIA[ 5 ], aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ] },, "Escala: " + mNOME )
MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ],, "Apontada" )
MBY201( aDIA[ 3 ], aDIA[ 1 ], ( 24 * nDIAS ) - aDIA[ 2 ], 24 * nDIAS,, "24Horas/Dia" )
@ CTLIN, 0 SAY repl( "=", 132 )
CTLIN++
ENDIF
AAdd( aGER, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, ;
         nCODMAQ, mNOME, aDIA[ 4 ], aDIA[ 5 ], lGRAVA, 24 * nDIAS, ;
         nPER04, nPER05, nPER06, nPER07, nPER08, nPER09 } )
dbSelectAr( cARQ )
ENDDO
IF lGER
CTLIN := 80  // For‡ar Iniciar Uma FOLHA
ENDIF
aDIA := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
FOR X := 1 TO Len( aGER )
aDIA[ 1 ] += aGER[ X, 1 ]   // trabalhadas
aDIA[ 2 ] += aGER[ X, 2 ]   // paradas
aDIA[ 3 ] += aGER[ X, 3 ]   // hora referencia
aDIA[ 4 ] += aGER[ X, 9 ]   // Qtde
aDIA[ 5 ] += aGER[ X, 10 ]  // Escala
aDIA[ 6 ] += aGER[ X, 12 ]  // 24 Horas
IF lGER
CABMBY2B( .F. )
MBY202( { aGER[ X, 7 ], aGER[ X, 8 ], 0, aGER[ X, 10 ], aGER[ X, 1 ], aGER[ X, 2 ], aGER[ X, 9 ], aGER[ X, 3 ], aGER[ X, 4 ], aGER[ X, 5 ], aGER[ X, 6 ] } )
CTLIN++
ENDIF
IF nSEQ > 0 .AND. lGRA .AND. aGER[ X, 11 ]
dbSelectAr( "RDE" )
netrecapp()
field->SEQ    := nSEQ
field->HD     := aGER[ X, 10 ]   // Escalas
field->HDRE   := aGER[ X, 1 ] + aGER[ X, 2 ]  // Horas Liquidas+Paradas
field->HD24   := aGER[ X, 12 ]   // Escala 24 horas
field->HP     := aGER[ X, 2 ]  // Horas Paradas
field->HT     := aGER[ X, 1 ]
field->PE     := aGER[ X, 4 ]
field->PP     := aGER[ X, 5 ]
field->PU     := aGER[ X, 6 ]
field->NUMERO := aGER[ X, 7 ]
field->NOME   := aGER[ X, 8 ]
field->QP     := aGER[ X, 9 ]
field->PERE   := aGER[ X, 13 ]
field->PPRE   := aGER[ X, 14 ]
field->PURE   := aGER[ X, 15 ]
field->PE24   := aGER[ X, 16 ]
field->PP24   := aGER[ X, 17 ]
field->PU24   := aGER[ X, 18 ]
ENDIF
NEXT X
IF Empty( aDIA[ 5 ] )
nTOT := aDIA[ 1 ] + aDIA[ 2 ]
ELSE
nTOT := aDIA[ 5 ]
ENDIF
nPER01 := PERC( aDIA[ 3 ], nTOT - aDIA[ 2 ] )
nPER02 := PERC( aDIA[ 3 ], nTOT )
nPER03 := PERC( aDIA[ 1 ], nTOT )
nPER04 := PERC( aDIA[ 3 ], aDIA[ 1 ] )
nPER05 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )
nPER06 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )
nPER07 := PERC( aDIA[ 3 ], aDIA[ 6 ] - aDIA[ 2 ] )
nPER08 := PERC( aDIA[ 3 ], aDIA[ 6 ] )
nPER09 := PERC( aDIA[ 1 ], aDIA[ 6 ] )
IF lGER
MBY201( aDIA[ 3 ], aDIA[ 1 ], nTOT - aDIA[ 2 ], nTOT, { aDIA[ 5 ], aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ] } )
MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )  // Apontadas
MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 6 ] - aDIA[ 2 ], aDIA[ 6 ] )  // 24 HORAS
ENDIF
IMPFOL()
IF lGRA
dbSelectAr( "RD" )
dbSetOrder( 1 )
dbGoTop()
IF dbSeek( nSEQ )
field->EQHD   := aDIA[ 5 ]
field->EQHP   := aDIA[ 2 ]
field->EQHT   := aDIA[ 1 ]
field->EQQP   := aDIA[ 4 ]
field->EQH24  := aDIA[ 6 ]
field->EQPE   := nPER01
field->EQPP   := nPER02
field->EQPU   := nPER03
field->EQPERE := nPER04
field->EQPPRE := nPER05
field->EQPURE := nPER06
field->EQPE24 := nPER07
field->EQPP24 := nPER08
field->EQPU24 := nPER09
ENDIF
ENDIF
dbCloseAll()
IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function CABMBY2()
// +
// +    Called from ( m_by2.prg    )   1 - function cabmby1()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABMBY2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CABMBY2( lSAYF )

   IF CTLIN > 55
      @  0, 0   SAY cAE + "Ficha do Equipamento"
      @  1, 0   SAY cAC + "M_BY2"
      @  1, 60  SAY Time()
      @  1, 70  SAY ZDATA
      @  2, 0   SAY "Req."
      @  2, 9   SAY "Data"
      @  2, 18  SAY "Peca No."
      @  2, 34  SAY "Ope"
      @  2, 42  SAY "Op"
      @  2, 51  SAY "Ini"
      @  2, 57  SAY "Fim"
      @  2, 63  SAY "HRs"
      @  2, 69  SAY "Par"
      @  2, 75  SAY "Qtdde"
      @  2, 82  SAY "Real"
      @  2, 90  SAY "Pad"
      @  2, 95  SAY "Hr.Pr."
      @  2, 101 SAY "Efi"
      @  2, 108 SAY "Pro"
      @  2, 115 SAY "Utl"
      CTLIN := 3
      IF lSAYF
         @ CTLIN, 0  SAY "Equipamento: " + nCODMAQ
         @ CTLIN, 20 SAY mNOME
         CTLIN++
         @ CTLIN, 0 SAY repl( "-", 132 )
         CTLIN++
      ENDIF
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function CABMBY2B()
// +
// +    Called from ( m_by2.prg    )   3 - function cabmby1()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABMBY2B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CABMBY2B( lSAYF )

   IF CTLIN > 55
      @  0, 0   SAY cAE + "Ficha do Equipamento"
      @  1, 0   SAY cAC + "M_BY2"
      @  1, 60  SAY Time()
      @  1, 70  SAY ZDATA
      @  2, 59  SAY "Esc"
      @  2, 71  SAY "HRs"
      @  2, 85  SAY "Par"
      @  2, 93  SAY "Qtdde"
      @  2, 101 SAY "Hr.Pr."
      @  2, 110 SAY "Efi"
      @  2, 117 SAY "Pro"
      @  2, 124 SAY "Utl"
      CTLIN := 3
      IF lSAYF
         @ CTLIN, 0  SAY "Equipamento: " + nCODMAQ
         @ CTLIN, 20 SAY mNOME
         CTLIN++
         @ CTLIN, 0 SAY repl( "-", 132 )
         CTLIN++
      ENDIF
   ENDIF

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBY201()
// +
// +    Called from ( m_by2.prg    )   8 - function cabmby1()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBY201()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBY201( nVAL1, nVAL2, nDIFR, nTOTR, aVAL, cTITULO )

   LOCAL aPER := { 0, 0, 0 }

   aPER[ 1 ] := PERC( nVAL1, nDIFR )
   aPER[ 2 ] := PERC( nVAL1, nTOTR )
   aPER[ 3 ] := PERC( nVAL2, nTOTR )
   IF ValType( cTITULO ) # "U"
      @ CTLIN, 0 SAY Left( cTITULO, 40 )
   ENDIF
   @ CTLIN, 41 SAY nTOTR PICT "99999.99"
   @ CTLIN, 50 SAY nDIFR PICT "99999.99"
   IF ValType( aVAL ) = "A"
      @ CTLIN, 59  SAY aVAL[ 1 ] PICT "9999999.99"
      @ CTLIN, 71  SAY aVAL[ 2 ] PICT "999999.99"
      @ CTLIN, 85  SAY aVAL[ 3 ] PICT "9999.99"
      @ CTLIN, 93  SAY aVAL[ 4 ] PICT "9999999"
      @ CTLIN, 101 SAY aVAL[ 5 ] PICT "99999.99"
   ENDIF
   @ CTLIN, 110 SAY aPER[ 1 ] PICT "999.99"
   @ CTLIN, 117 SAY aPER[ 2 ] PICT "999.99"
   @ CTLIN, 124 SAY aPER[ 3 ] PICT "999.99"
   CTLIN++
   RETU aPER

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBY202()
// +
// +    Called from ( m_by2.prg    )   4 - function cabmby1()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBY202()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBY202( aVAL )

   @ CTLIN, 0 SAY aVAL[ 1 ]
   @ CTLIN, 9 SAY PadR( STRVAL( aVAL[ 2 ] ), 40 )
   IF aVAL[ 3 ] > 0
      @ CTLIN, 50 SAY aVAL[ 3 ] PICT "9999.99"
   ENDIF
   @ CTLIN, 59  SAY aVAL[ 4 ]  PICT "9999999.99"
   @ CTLIN, 71  SAY aVAL[ 5 ]  PICT "999999.99"
   @ CTLIN, 85  SAY aVAL[ 6 ]  PICT "9999.99"
   @ CTLIN, 93  SAY aVAL[ 7 ]  PICT "9999999"
   @ CTLIN, 101 SAY aVAL[ 8 ]  PICT "99999.99"
   @ CTLIN, 110 SAY aVAL[ 9 ]  PICT "999.99"
   @ CTLIN, 117 SAY aVAL[ 10 ] PICT "999.99"
   @ CTLIN, 124 SAY aVAL[ 11 ] PICT "999.99"
   CTLIN++
   RETU .T.

// + EOF: M_BY2.PRG

// + EOF: m_by2.prg
// +
