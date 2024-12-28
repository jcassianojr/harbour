// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_by5.prg
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
// +    Source Module => J:\ITAESBRA\M_BY5.PRG
// +
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

MDI( " Э Controle de Paradas" )
CTLIN := 80
nSEQ  := 0
lANA  := MDG( "Resumo Analitico" )
lSIN  := MDG( "Resumo Sintetico" )
lMAQ  := MDG( "Resumo Maquinas" )

MDS( "Filtro Requisi‡oes" )
FILTRO := ''
FILTRO := RFILORD( "MY03", .F. )
MDS( "Filtro Paradas" )
FILTR2 := ''
FILTR2 := RFILORD( "MY03A", .F. )

aCPAR  := {}
aCPARD := {}
aCPAD  := {}
aCPADD := {}
nCON   := 0

IF !USEREDE( "MD02", 1, 1 )
RETU .F.
ENDIF
dbGoTop()
dbSeek( "CODPAR" )
WHILE "CODPAR " = AllTrim( CODIGO ) .AND. !Eof()
AAdd( aCPAR, Left( CODIGO1, 3 ) )
AAdd( aCPARD, { 0, DESCRICAO } )
dbSkip()
ENDDO

dbGoTop()
dbSeek( "CODPARD" )
WHILE AllTrim( CODIGO ) = "CODPARD" .AND. !Eof()
AAdd( aCPAD, Left( CODIGO1, 1 ) )
AAdd( aCPADD, { 0, DESCRICAO } )
dbSkip()
ENDDO
dbCloseArea()

// Matriz Maquinas
nCOD := Len( aCPAR )

aRETU   := PERFEC( { "MY03", "MY03A" }, { "Y3", "YA" }, { "Y399", "YA99" }, { "DATOPR", "PADRAO" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQ    := aRETU[ 5, 1 ]
cARQ2   := aRETU[ 5, 2 ]
cCAB    := aRETU[ 7 ]
lGRA    := .F.
IF aRETU[ 6 ] = 2   // Mes Fechado
lGRA := MDG( "Gravar Apura‡„o" )
IF lGRA
lGRA := SENHAX( "MBY005" )
ENDIF
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
// cAE := IMP( "AE" )
// cAC := IMP( "AC" )
cAE := aCHR[ 2 ]
cAC := aCHR[ 1 ]


IF !USEMULT( { { CARQ2, 1, 1 }, { cARQ, 1, 1 } } )
RETU .F.
ENDIF

dbSelectAr( cARQ2 )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "CODPAR + str( NUMERO, 8 )" )
ordSetFocus( "temp" )
IF !Empty( FILTR2 )
SET FILTER TO &FILTR2
ENDIF

dbSelectAr( cARQ )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF

IF lGRA
IF !USEMULT( { { "RD", 0, 99 }, { "RDP", 0, 99 }, { "RDPD", 0, 99 } } )
RETU .F.
ENDIF
dbSelectAr( "RD" )
dbSetOrder( 2 )
dbGoTop()
IF dbSeek( Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
nSEQ := SEQ
ENDIF
IF nSEQ > 0
dbSelectAr( "RDP" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| SEQ = nSEQ }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK

dbSelectAr( "RDPD" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| SEQ = nSEQ }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK

ENDIF
ENDIF

MDS( "Apurando: " )
aMAQ  := {}
aMAQD := {}
IMPRESSORA()
dbSelectAr( CARQ2 )
dbGoTop()
WHILE !Eof()
// IF CODMAQ="TER" //Pula Tratamento Terceiros
// WHILE CODMAQ="TER".AND.! EOF()
// DBSKIP()
// ENDDO
// ENDIF
nCODPAR := CODPAR
CTLIN   := 80
WHILE nCODPAR = CODPAR .AND. !Eof()
nTEMPO := 0
VIDEO()
@ 24, 10 SAY nCODPAR
@ 24, 20 SAY NUMERO
IMPRESSORA()
IF CTLIN > 55 .AND. lANA
@  0, 0  SAY cAE + "Ficha de Parada"
@  1, 0  SAY cAC + "M_BY5"
@  1, 10 SAY cCAB
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
@  2, 00 SAY "Codigo Parada " + nCODPAR
@  3, 0  SAY "Numero"
@  3, 9  SAY "Item"
@  3, 13 SAY "Cod"
@  3, 18 SAY "Ini"
@  3, 26 SAY "Fim"
@  3, 32 SAY "Tot"
@  3, 38 SAY "OBS"
@  4, 0  SAY repl( "-", 132 )
CTLIN := 5
ENDIF
mNUMERO := NUMERO
dbSelectAr( cARQ )
IF dbSeek( mNUMERO )  // Se tem cabecario requisicao
mCODMAQ := CODMAQ
dbSelectAr( CARQ2 )
IF lANA
@ CTLIN, 0  SAY NUMERO
@ CTLIN, 9  SAY ITEM
@ CTLIN, 13 SAY CODPAR
@ CTLIN, 16 SAY CODPARD
@ CTLIN, 18 SAY PINI
@ CTLIN, 26 SAY PFIM
@ CTLIN, 32 SAY TEMPO
@ CTLIN, 38 SAY OBS
CTLIN++
ENDIF
nTEMPO := TEMPO
nPOS   := AScan( aMAQ, mCODMAQ )
IF nPOS = 0
aTEMP := Array( nCOD )
AFill( aTEMP, 0 )
AAdd( aMAQ, mCODMAQ )
AAdd( aMAQD, aTEMP )
nPOS := Len( aMAQ )
ENDIF
nPOSC := AScan( aCPAR, CODPAR )
IF nPOSC > 0
aMAQD[ nPOS, nPOSC ] += TEMPO
ENDIF
IF nCODPAR = "999"
nPOS := AScan( aCPAD, CODPARD )
IF nPOS > 0
aCPADD[ nPOS, 1 ] += TEMPO
ELSE
nCODPARD := CODPARD
VIDEO()
ALERTX( "Cheque Sub-Codigo: 999/" + nCODPARD + " Requisi‡„o:" + Str( mNUMERO ) )
lGRA := .F.
IF !MDG( "Continuar Nao Grava Apuracao" )
dbCloseAll()
RETU
ENDIF
impressora()
ENDIF
ENDIF
nPOS := AScan( aCPAR, nCODPAR )
IF nPOS > 0
aCPARD[ NPOS, 1 ] += TEMPO
ELSE
VIDEO()
ALERTX( "Cheque Codigo: " + nCODPAR + " Requisi‡„o:" + Str( mNUMERO ) )
lGRA := .F.
IF !MDG( "Continuar Nao Grava Apuracao" )
dbCloseAll()
RETU
ENDIF
impressora()
ENDIF
ENDIF
dbSelectAr( CARQ2 )
dbSkip()
ENDDO
ENDDO

IMPFOL()
IF lSIN
@  0, 0  SAY cAE + "Ficha de Paradas"
@  1, 0  SAY cAC + "M_BY5B"
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
@  2, 00 SAY "Resumo Geral"
@  2, 20 SAY cCAB
@  3, 0  SAY repl( "-", 132 )
@  4, 0  SAY "Codigo"
@  4, 70 SAY "Horas"
@  5, 00 SAY repl( "-", 132 )
CTLIN := 6
ENDIF
nHORAS := 0
FOR X := 1 TO Len( aCPAR )
nHORAS += aCPARD[ X, 1 ]
IF lSIN
@ CTLIN, 0  SAY aCPAR[ X ]
@ CTLIN, 5  SAY aCPARD[ X, 2 ]
@ CTLIN, 70 SAY aCPARD[ X, 1 ] PICT "99999.99"
CTLIN++
ENDIF
IF nSEQ > 0
IF !Empty( aCPAR[ X ] ) .AND. lGRA
dbSelectAr( "RDP" )
netrecapp()
field->SEQ    := nSEQ
field->NUMERO := aCPAR[ X ]
field->HP     := aCPARD[ X, 1 ]
field->NOME   := aCPARD[ X, 2 ]
ENDIF
ENDIF
NEXT X

FOR X := 1 TO Len( acPAD )
IF lSIN
@ CTLIN, 0  SAY acPAD[ X ]
@ CTLIN, 5  SAY acPADD[ X, 2 ]
@ CTLIN, 70 SAY acPADD[ X, 1 ] PICT "99999.99"
CTLIN++
ENDIF
IF nSEQ > 0
IF !Empty( acPAD[ X ] ) .AND. lGRA
dbSelectAr( "RDPD" )
netrecapp()
field->SEQ    := nSEQ
field->NUMERO := acPAD[ X ]
field->HP     := acPADD[ X, 1 ]
field->NOME   := acPADD[ X, 2 ]
ENDIF
ENDIF
NEXT X
IF lSIN
// Totais
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
@ CTLIN, 0  SAY "Geral"
@ CTLIN, 15 SAY nHORAS  PICT "9999.99"
CTLIN++
@ CTLIN, 0 SAY repl( "-", 132 )
ENDIF
IF lGRA
dbSelectAr( "RD" )
dbSetOrder( 1 )
dbGoTop()
IF dbSeek( nSEQ )
field->PAHP := nHORAS
ENDIF
dbCloseAll()
ENDIF

IF lMAQ
CTLIN := 80
aTEMP := Array( nCOD )
AFill( aTEMP, 0 )
aGER := aTEMP
FOR X := 1 TO Len( aMAQ )
IF CTLIN > 55
@  0, 0  SAY cAE + "Ficha de Paradas Resumos Maquinas"
@  1, 0  SAY cAC + "M_BY5C"
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
@  2, 00 SAY "Resumo Geral"
@  3, 0  SAY repl( "-", 132 )
@  4, 0  SAY "Maquina"
@  5, 0  SAY repl( "-", 132 )
CTLIN := 6
ENDIF
@ CTLIN, 0 SAY aMAQ[ X ]
@ CTLIN, 5 SAY ACENTO( OBTER( "ME01", aMAQ[ X ], "NOME" ) )
CTLIN++
nTOT := 0
FOR W := 1 TO Len( aCPAR )
@ CTLIN, 0  SAY aCPAR[ W ]
@ CTLIN, 5  SAY aCPARD[ W, 2 ]
@ CTLIN, 70 SAY aMAQD[ X, W ]  PICT "99999.99"
aGER[ W ] += aMAQD[ X, W ]
nTOT += aMAQD[ X, W ]
CTLIN++
NEXT W
@ CTLIN, 0  SAY "Total Equipamento"
@ CTLIN, 70 SAY nTOT                PICT "99999.99"
CTLIN++
NEXT X
nTOT := 0
@ CTLIN, 0 SAY "Total Geral"
CTLIN++
FOR W := 1 TO Len( aCPAR )
@ CTLIN, 0  SAY aCPAR[ W ]
@ CTLIN, 5  SAY aCPARD[ W, 2 ]
@ CTLIN, 70 SAY aGER[ W ]     PICT "99999.99"
nTOT += aGER[ W ]
CTLIN++
NEXT W
ENDIF
IMPFOL()
IMPEND()

// + EOF: M_BY5.PRG

// + EOF: m_by5.prg
// +
