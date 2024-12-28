// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bs4.prg
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

// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
// +
// +    Source Module => J:\ITAESBRA\M_BS4.PRG
// +
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

// #INCLUDE "COMANDO.CH"
MDI( " Ý Controle de Entrega/Entregar" )
PARA nTIPO, nIND

// Verificando a Impressora
IF !CHECKIMP( 0 )
RETURN .F.
ENDIF

cIMPAE := IMP( "AE" )

// Pegando o Filtro do Relatorio
// FILTRO := ''
// FILTRO := RFILORD( "MS01", .F. )
CRIARVARS( "BS5" )
CRIARVARS( "BS6" )


sMBS401 := SENHAX( "MBS401",, .F. )
aBS4001 := PEGLAY( "MEXPOR1", "BS4001" )
aBS4002 := PEGLAY( "MEXPOR1", "BS4002" )

lBAS := MDG( "Resumo Dia a Dia" )
lRES := MDG( "Resumo Final Produto" )
lCLI := MDG( "Resumo Cliente e Apura‡Æo Grava‡Æo" )
lCOM := MDG( "Resumo de Composi‡„o" )
lCAN := .T.
IF nTIPO = 1 .OR. nTIPO = 3
lCAN := MDG( "Incluir Canceladas" )
ENDIF
nCOT01 := nCOT02 := nCOT03 := nCOT04 := 0
aPROD  := {}
aCLIC  := {}
aCLID  := {}

ARQNFI := "MM02"
ARQNF  := "MM01"

lGRA   := .F.
FILTRA := ''
IF nTIPO = 1
aRETU  := PERFEC( { "MM02", "MM01" }, { "M2", "M1" }, { "MM92", "MM91" } )
mMES   := aRETU[ 1 ]
mANO   := aRETU[ 2 ]
ARQNFI := aRETU[ 5, 1 ]
ARQNF  := aRETU[ 5, 2 ]
cCAB   := aRETU[ 7 ]

// Pegando o Filtro do Relatorio
FILTRA := RFILORD( "MM02", .F. )
IF aRETU[ 6 ] = 2  // Mes Fechado
lGRA := MDG( "Gravar Apura‡„o" )
IF lGRA
lGRA := SENHAX( "MBS402" )
ENDIF
ENDIF
ENDIF

IF nTIPO = 2
ARQNFI   := "MO02"
OPERACAO := "XXX"  // Fixa Varivel que n„o tem em Pedidos
// Pegando o Filtro do Relatorio
FILTRA := RFILORD( "MO02", .F. )
ENDIF


mds( "Abrindo Arquivos" )
IF nTIPO = 1
IF !USEMULT( { { ARQNFI, 1, nIND }, { ARQNF, 1, 1 }, { "MS01", 1, 1 } } )
RETU .F.
ENDIF
ENDIF
IF nTIPO = 2 .OR. ntipo = 3
IF !USEMULT( { { ARQNFI, 1, nIND }, { "MS01", 1, 1 } } )
RETU .F.
ENDIF
ENDIF
// MDS( "Filtro de Produtos" )
// dbselectar( "MS01" )
// if !empty( FILTRO )
// set filter to &FILTRO.
// endif

dbSelectAr( ARQNFI )
IF !Empty( FILTRA )
mds( "Filtro Notas" )
SET FILTER TO &FILTRA.
ENDIF

mds( "Iniciando" )
CTLIN  := 60
nOLDOS := 0
dOLDDA := CToD( "00/00/00" )
IMPRESSORA()
dbSelectAr( "MS01" )
dbGoTop()
WHILE !Eof()
VIDEO()
@ 24, 00 SAY CODIGO
@ 24, 75 SAY "   "
IMPRESSORA()
nTOT      := 0
nTOTSAL   := 0
nCON01    := nCON02 := nCON03 := nCON04 := 0
mCODIGO   := CODIGO
mNOME     := NOME
mSEQAREA  := SEQAREA
mULTIMONF := ULTIMONF
mULTIMOFA := ULTIMOFA
// CTLIN    := 60
lTEM := .F.
lFOL := .T.
dbSelectAr( ARQNFI )
dbGoTop()
dbSeek( mCODIGO )
WHILE CODIGO = mCODIGO .AND. !Eof()
VIDEO()
@ 24, 75 SAY "GRV"
IMPRESSORA()
IF nTIPO # 2
IF NUMERO > mULTIMONF .AND. TIPOENT = "P"  // so atualiza se for produto
mULTIMONF := NUMERO
mULTIMOFA := DATA
ENDIF
IF TIPOENT <> "P" .AND. mULTIMONF = NUMERO
mULTIMONF := 0
mULTIMOFA := CToD( Space( 8 ) )
ENDIF
ENDIF
lCANCELA := .F.
IF nTIPO = 1
mNUMERO := NUMERO
dbSelectAr( ARQNF )
dbGoTop()
IF dbSeek( mNUMERO )
IF CANCELADA = "S"
lCANCELA := .T.
ENDIF
ENDIF
ENDIF
VIDEO()
IF nTIPO = 1 .OR. nTIPO = 3
@ 24, 30 SAY NUMERO
ELSE
@ 24, 30 SAY PEDIDO
ENDIF
IMPRESSORA()
dbSelectAr( ARQNFI )
IF IF( nTIPO = 2, .T., APURA # "N" .AND. ESPECIE # "NFC" .AND. !Empty( OS ) .AND. ( lCAN .OR. !lCANCELA ) .AND. TIPOENT = "P" )
lTEM := .T.
IF CTLIN > 50 .AND. lBAS
@  0, 0  SAY cIMPAE + "CONTROLE DE ENTREGAS"
@  1, 0  SAY "M_BS4 "
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
@  2, 0  SAY "PECA: " + AllTrim( mCODIGO ) + " - " + ACENTO( mNOME )
IF nTIPO = 2
@  3, 0 SAY "Data                   OS          Qtdde  Saldo  Entrega CD Cliente"
ELSE
@  3, 0 SAY "Data        No.        OS   Preco  Qtdde  Progr  Entrega CD Cliente"
ENDIF
@  4, 0 SAY repl( "-", 80 )
CTLIN := 5
lFOL  := .F.
ELSE
IF lFOL .AND. Lbas
@ ctlin, 0 SAY repl( "-", 80 )
ctlin++
@ ctlin, 0 SAY "PECA: " + AllTrim( mCODIGO ) + " - " + ACENTO( mNOME )
ctlin++
@ ctlin, 0 SAY repl( "-", 80 )
ctlin++
lFOL := .F.
ENDIF
ENDIF
IF lBAS
@ CTLIN, 0 SAY DATA
ENDIF
IF nTIPO = 2
IF lBAS
@ CTLIN, 18 SAY OS                   PICT "9999.99"
@ CTLIN, 34 SAY CONVUN( QTDEPED, UNID ) PICT "@E 999999"
@ CTLIN, 41 SAY CONVUN( QTDESAL, UNID ) PICT "@E 999999"
@ CTLIN, 48 SAY ENTREGA
@ CTLIN, 59 SAY FORNECEDO            PICT "999999"
@ CTLIN, 66 SAY COGNOME
ENDIF
nTOT    += CONVUN( QTDEPED, UNID )
nTOTSAL += CONVUN( QTDESAL, UNID )
ENDIF
IF nTIPO = 1 .OR. nTIPO = 3
IF lBAS
@ CTLIN, 9  SAY Str( NUMERO, 6 )
@ CTLIN, 16 SAY IF( lCANCELA, "*", "" )
@ CTLIN, 18 SAY OS                  PICT "9999.99"
IF sMBS401
@ CTLIN, 26 SAY PRECO PICT "@E 9999.99"
ENDIF
@ CTLIN, 34 SAY CONVUN( QTDE, UNID )    PICT "@E 999999"
@ CTLIN, 41 SAY CONVUN( QTDESAL, UNID ) PICT "@E 999999"
@ CTLIN, 48 SAY ENTREGA
ENDIF
nGRU1   := nGRU2 := nGRU3 := 0
nQTD1   := nQTD2 := nQTD3 := 0
cCODERR := ""
// IF OS#nOLDOS.OR.dOLDDA#DATA
DO CASE
CASE DATA = ENTREGA .AND. QTDE # QTDESAL
cCODERR := "F2"
nCON03++
nCOT03++
nGRU3 := 1
nQTD3 := QTDE
CASE DATA <= ENTREGA
cCODERR := "FO"
nCON01++
nCOT01++
nGRU1 := 1
nQTD1 := QTDE
CASE DATA = ENTREGA .AND. QTDE = QTDESAL
cCODERR := "FO"
nCON01++
nCOT01++
nGRU1 := 1
nQTD1 := QTDE
CASE DATA > ENTREGA .AND. QTDE = QTDESAL
cCODERR := "F1"
nCON02++
nCOT02++
nGRU2 := 1
nQTD2 := QTDE
OTHERWISE
cCODERR := "F2"
nCON03++
nCOT03++
nGRU3 := 1
nQTD3 := QTDE
ENDCASE
IF lBAS
@ CTLIN, 57 SAY cCODERR
@ CTLIN, 59 SAY FORNECEDO          PICT "999999"
@ CTLIN, 66 SAY AllTrim( PEDIDOCLI )
ENDIF
nCON04++
nCOT04++
nOLDOS := OS
dOLDDA := DATA
nTOT   += CONVUN( QTDE, UNID )
nPOS   := AScan( aCLIC, mCODIGO + Str( FORNECEDO, 8 ) )
IF nPOS > 0
aCLID[ NPOS, 2 ] += nGRU1
aCLID[ NPOS, 3 ] += nGRU2
aCLID[ NPOS, 4 ] += nGRU3
aCLID[ NPOS, 5 ]++
aCLID[ NPOS, 6 ] += CONVUN( QTDE, UNID )
aCLID[ NPOS, 8 ] += CONVUN( nQTD1, UNID )
aCLID[ NPOS, 9 ] += CONVUN( nQTD2, UNID )
aCLID[ NPOS, 10 ] += CONVUN( nQTD3, UNID )
ELSE
AAdd( aCLIC, mCODIGO + Str( FORNECEDO, 8 ) )
AAdd( aCLID, { mCODIGO, nGRU1, nGRU2, nGRU3, 1, CONVUN( QTDE, UNID ), FORNECEDO, CONVUN( nQTD1, UNID ), CONVUN( nQTD2, UNID ), CONVUN( nQTD3, UNID ) } )
ENDIF
ENDIF
CTLIN++
ENDIF
dbSelectAr( ARQNFI )
dbSkip()
ENDDO
IF lTEM .AND. Ntipo # 2
IF lBAS
@ CTLIN, 0  SAY "Total"
@ CTLIN, 40 SAY nTOT    PICT "@E 9999,999"
CTLIN++
nPER01 := PERC( nCON01, nCON04 )
nPER02 := PERC( nCON02, nCON04 )
nPER03 := PERC( nCON03, nCON04 )
@ CTLIN, 0 SAY "FO:  " + Str( nCON01, 5 ) + " F1:  " + Str( nCON02, 5 ) + " F2:  " + Str( nCON03, 5 ) + " Ent:  " + Str( nCON04, 5 )
CTLIN++
@ CTLIN, 0 SAY "FO: " + Str( nPER01, 6, 2 ) + " F1: " + Str( nPER02, 6, 2 ) + " F2: " + Str( nPER03, 6, 2 )
IMPFOL()
ENDIF
AAdd( aPROD, { mCODIGO, nCON01, nCON02, nCON03, nCON04, nTOT, mSEQAREA, mNOME } )
ENDIF
IF Ntipo # 2
dbSelectAr( "MS01" )
NETRECLOCK()
FIELD->ULTIMONF := mULTIMONF
FIELD->ULTIMOFA := mULTIMOFA
dbUnlock()
ENDIF
IF Ntipo = 2 .AND. ntot > 0
@ ctlin, 0 SAY repl( "-", 80 )
ctlin++
@ ctlin, 0  SAY "Total "
@ CTLIN, 34 SAY nTOT     PICT "@E 999999"
@ CTLIN, 41 SAY nTOTSAL  PICT "@E 999999"
ctlin++
@ ctlin, 0 SAY repl( "-", 80 )
ENDIF
dbSelectAr( "MS01" )
IF mCODIGO = CODIGO
WHILE mCODIGO = CODIGO .AND. !Eof()   // Salto diferentes compradores
dbSkip()
ENDDO
ELSE
dbSkip()
ENDIF
ENDDO
dbCloseAll()

IF lRES .AND. Ntipo # 2
VIDEO()
IMPRESSORA()
nTOTAL := 0
@  0, 0  SAY "Resumo Final Produto"
@  1, 0  SAY "Codigo"
@  1, 25 SAY "FO      F1      F2      ENT    QTDE"
CTLIN := 3
FOR W := 1 TO Len( aPROD )
@ CTLIN, 0  SAY aPROD[ W, 1 ]
@ CTLIN, 25 SAY aPROD[ W, 2 ] PICT "999"
@ CTLIN, 32 SAY aPROD[ W, 3 ] PICT "999"
@ CTLIN, 39 SAY aPROD[ W, 4 ] PICT "999"
@ CTLIN, 46 SAY aPROD[ W, 5 ] PICT "999"
@ CTLIN, 53 SAY aPROD[ W, 6 ] PICT "@E 9999,999"
CTLIN++
@ CTLIN, 25 SAY PERC( aPROD[ W, 2 ], aPROD[ W, 5 ] ) PICT "999.99%"
@ CTLIN, 32 SAY PERC( aPROD[ W, 3 ], aPROD[ W, 5 ] ) PICT "999.99%"
@ CTLIN, 39 SAY PERC( aPROD[ W, 4 ], aPROD[ W, 5 ] ) PICT "999.99%"
nTOTAL += aPROD[ W, 6 ]
CTLIN++
NEXT W
@ CTLIN, 0 SAY repl( "-", 80 )
CTLIN++
@ CTLIN, 0  SAY "Total"
@ CTLIN, 24 SAY nCOT01  PICT "9999"
@ CTLIN, 31 SAY nCOT02  PICT "9999"
@ CTLIN, 38 SAY nCOT03  PICT "9999"
@ CTLIN, 45 SAY nCOT04  PICT "9999"
@ CTLIN, 53 SAY nTOTAL  PICT "@E 9999,999"
CTLIN++
@ CTLIN, 25 SAY PERC( nCOT01, nCOT04 ) PICT "999.99%"
@ CTLIN, 32 SAY PERC( nCOT02, nCOT04 ) PICT "999.99%"
@ CTLIN, 39 SAY PERC( nCOT03, nCOT04 ) PICT "999.99%"
IMPFOL()
dbCloseAll()
ENDIF

IF lCOM
aCOM  := {}
aMAT  := {}
aCOMQ := {}
aMATQ := {}
VIDEO()
IF !USEREDE( "MS03", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
MDS( "Calculando Composi‡„o" )
IMPRESSORA()
FOR W := 1 TO Len( aPROD )
dbGoTop()
dbSeek( aPROD[ W, 1 ] )
WHILE AllTrim( aPROD[ W, 1 ] ) = AllTrim( CODIGO ) .AND. !Eof()
IF TIPOENT = "M"   // Materia Prima
nPOS := AScan( aMAT, CODCOMP )
IF nPOS > 0
aMATQ[ nPOS ] += QTDDE * aPROD[ W, 6 ]
ELSE
AAdd( aMAT, CODCOMP )
AAdd( aMATQ, QTDDE * aPROD[ W, 6 ] )
ENDIF
ENDIF
IF TIPOENT = "C"   // Componentes
nPOS := AScan( aCOM, CODCOMP )
IF nPOS > 0
aCOMQ[ nPOS ] += QTDDE * aPROD[ W, 6 ]
ELSE
AAdd( aCOM, CODCOMP )
AAdd( aCOMQ, QTDDE * aPROD[ W, 6 ] )
ENDIF
ENDIF
dbSkip()
ENDDO
NEXT W
dbCloseAll()
CTLIN := 80
FOR W := 1 TO Len( aCOM )
IF CTLIN > 50
@  0, 0  SAY "Resumo Final Produto Composi‡„o Componentes"
@  1, 00 SAY "Componente"
@  1, 25 SAY "Quantidade"
CTLIN := 3
ENDIF
@ CTLIN, 0  SAY aCOM[ W ]
@ CTLIN, 25 SAY aCOMQ[ W ] PICT "@E 9999,999.99"
CTLIN++
NEXT W
IMPFOL()
CTLIN := 80
FOR W := 1 TO Len( aMAT )
IF CTLIN > 50
@  0, 0  SAY "Resumo Final Produto Composi‡„o Materia Prima"
@  1, 00 SAY "Mat. Prima"
@  1, 25 SAY "Quantidade"
CTLIN := 3
ENDIF
@ CTLIN, 0  SAY aMAT[ W ]
@ CTLIN, 25 SAY aMATQ[ W ] PICT "@E 9999,999.99"
CTLIN++
NEXT W
IMPFOL()
ENDIF

IF lCLI .AND. Ntipo # 2
VIDEO()
IF !USEMULT( { { "MA01", 1, 1 }, { "MS01", 1, 1 } } )
RETU .F.
ENDIF
IF lGRA
IF !USEMULT( { { "BS5", 0, 99 }, { "BS6", 0, 99 }, { "BS1", 0, 99 }, { "BS2", 0, 99 } } )
RETU .F.
ENDIF
dbSelectAr( "BS1" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = aRETU[ 1 ] .AND. ANO = aRETU[ 2 ] }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
dbSelectAr( "BS2" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = aRETU[ 1 ] .AND. ANO = aRETU[ 2 ] }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
dbSelectAr( "BS5" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = aRETU[ 1 ] .AND. ANO = aRETU[ 2 ] }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
dbSelectAr( "BS6" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = aRETU[ 1 ] .AND. ANO = aRETU[ 2 ] }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
IF !USEMULT( { { "BS5", 1, 99 }, { "BS6", 1, 99 }, { "BS1", 1, 99 }, { "BS2", 1, 99 } } )
RETU .F.
ENDIF
ENDIF
CTLIN  := 80
nT01   := nT02 := nT03 := nT04 := 0
nT06   := nT08 := nT09 := nT10 := 0
aGRUPO := {}
aGRUPD := {}
IMPRESSORA()
dbSelectAr( "MA01" )
dbGoTop()
WHILE !Eof()
lPRI     := .T.
nG01     := nG02 := nG03 := nG04 := 0
nG06     := nG08 := nG09 := nG10 := 0
mCOGCLI  := COGNOME
mGRUPO   := GRUPOEMP
mCLIENTE := NUMERO
mNOMECLI := NOME
FOR W := 1 TO Len( aCLID )
IF aCLID[ W, 7 ] = NUMERO
IF CTLIN > 50
@  0, 0  SAY "Resumo Final Cliente"
@  1, 0  SAY "Codigo"
@  1, 25 SAY "FO"
@  1, 35 SAY "F1"
@  1, 45 SAY "F2"
@  1, 55 SAY "ENT"
@  2, 0  SAY "Qtde"
CTLIN := 3
ENDIF
IF lPRI
@ CTLIN, 0 SAY repl( "=", 80 )
CTLIN++
@ CTLIN, 0  SAY NUMERO
@ CTLIN, 10 SAY NOME
CTLIN++
@ CTLIN, 0 SAY repl( "-", 80 )
CTLIN++
lPRI := .F.
ENDIF
GRAVAVAR2( aBS4001 )
@ CTLIN, 0  SAY aCLID[ W, 1 ]
@ CTLIN, 25 SAY aCLID[ W, 2 ] PICT "999"
@ CTLIN, 35 SAY aCLID[ W, 3 ] PICT "999"
@ CTLIN, 45 SAY aCLID[ W, 4 ] PICT "999"
@ CTLIN, 50 SAY aCLID[ W, 5 ] PICT "999"
CTLIN++
@ CTLIN, 25 SAY mPER01 PICT "999.99%"
@ CTLIN, 35 SAY mPER02 PICT "999.99%"
@ CTLIN, 45 SAY mPER03 PICT "999.99%"
CTLIN++
@ CTLIN, 25 SAY aCLID[ W, 8 ]  PICT "@E 9999,999"
@ CTLIN, 35 SAY aCLID[ W, 9 ]  PICT "@E 9999,999"
@ CTLIN, 45 SAY aCLID[ W, 10 ] PICT "@E 9999,999"
@ CTLIN, 55 SAY aCLID[ W, 6 ]  PICT "@E 9999,999"
CTLIN++
@ CTLIN, 25 SAY mPEQ01 PICT "999.99%"
@ CTLIN, 35 SAY mPEQ02 PICT "999.99%"
@ CTLIN, 45 SAY mPEQ03 PICT "999.99%"
CTLIN++
CTLIN++
IF lGRA
mCODIGO := AllTrim( aCLID[ W, 1 ] )
mQTDDE  := aCLID[ W, 6 ]
mF0     := aCLID[ W, 2 ]
mF1     := aCLID[ W, 3 ]
mF2     := aCLID[ W, 4 ]
mENT    := aCLID[ W, 5 ]
mQTD01  := aCLID[ W, 8 ]
mQTD02  := aCLID[ W, 9 ]
mQTD03  := aCLID[ W, 10 ]
mNOME   := ""
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( mCODIGO )
mNOME := NOME
FOR J := 1 TO 10
cSTR := "mSET" + StrZero( J, 2 )
IF At( Chr( 48 + J ), SEQAREA ) > 0
&cSTR. := mQTDDE
ELSE
&cSTR. := 0
ENDIF
NEXT J
ELSE
FOR J := 1 TO 10
cSTR   := "mSET" + StrZero( J, 2 )
&cSTR. := 0
NEXT J
ENDIF
NOVOOPA( "BS5", .T., .T. )
ENDIF
ENDIF
dbSelectAr( "MA01" )
NEXT W
IF nG01 + nG02 + nG03 + nG04 > 0
mPER01 := PERC( NG01, NG04 )
mPER02 := PERC( NG02, NG04 )
mPER03 := PERC( NG03, NG04 )
mPEQ01 := PERC( NG08, NG06 )
mPEQ02 := PERC( NG09, NG06 )
mPEQ03 := PERC( NG10, NG06 )
mF0    := NG01
mF1    := NG02
mF2    := NG03
mENT   := NG04
mQTDDE := NG06
mQTD01 := NG08
mQTD02 := NG09
mQTD03 := NG10
mNOME  := mNOMECLI
IF lGRA
NOVOOPA( "BS6", .T., .T. )
ENDIF
@ CTLIN, 0 SAY repl( "-", 80 )
CTLIN++
@ CTLIN, 0  SAY "TOTAL"
@ CTLIN, 25 SAY nG01    PICT "999"
@ CTLIN, 35 SAY nG02    PICT "999"
@ CTLIN, 45 SAY nG03    PICT "999"
@ CTLIN, 55 SAY nG04    PICT "999"
CTLIN++
@ CTLIN, 25 SAY mPER01 PICT "999.99%"
@ CTLIN, 35 SAY mPER02 PICT "999.99%"
@ CTLIN, 45 SAY mPER03 PICT "999.99%"
CTLIN++
@ CTLIN, 25 SAY nG08 PICT "@E 9999,999"
@ CTLIN, 35 SAY nG09 PICT "@E 9999,999"
@ CTLIN, 45 SAY nG10 PICT "@E 9999,999"
@ CTLIN, 55 SAY nG06 PICT "@E 9999,999"
CTLIN++
@ CTLIN, 25 SAY mPEQ01 PICT "999.99%"
@ CTLIN, 35 SAY mPEQ02 PICT "999.99%"
@ CTLIN, 45 SAY mPEQ03 PICT "999.99%"
CTLIN++
@ CTLIN, 0 SAY repl( "=", 80 )
CTLIN++
nPOS := AScan( aGRUPO, mGRUPO )
IF nPOS > 0
aGRUPD[ NPOS, 1 ] += NG01
aGRUPD[ NPOS, 2 ] += NG02
aGRUPD[ NPOS, 3 ] += NG03
aGRUPD[ NPOS, 4 ] += NG04
aGRUPD[ NPOS, 5 ] += NG06
aGRUPD[ NPOS, 6 ] += NG08
aGRUPD[ NPOS, 7 ] += NG09
aGRUPD[ NPOS, 8 ] += NG10
ELSE
AAdd( aGRUPO, mGRUPO )
AAdd( aGRUPD, { NG01, NG02, NG03, NG04, NG06, NG08, NG09, NG10 } )
ENDIF
ENDIF
dbSelectAr( "MA01" )
dbSkip()
ENDDO
mPER01 := PERC( NT01, NT04 )
mPER02 := PERC( NT02, NT04 )
mPER03 := PERC( NT03, NT04 )
mPEQ01 := PERC( NT08, NT06 )
mPEQ02 := PERC( NT09, NT06 )
mPEQ03 := PERC( NT10, NT06 )
mF0    := NT01
mF1    := NT02
mF2    := NT03
mENT   := NT04
mQTDDE := NT06
mQTD01 := NT08
mQTD02 := NT09
mQTD03 := NT10
IF lGRA
NOVOOPA( "BS1", .T., .T. )
ENDIF
IMPFOL()
IF lGRA
FOR X := 1 TO Len( aGRUPO )
GRAVAVAR2( aBS4002 )
NOVOOPA( "BS2", .T., .T. )
NEXT X
ENDIF
dbCloseAll()
ENDIF
VIDEO()
IMPEND()


// + EOF: M_BS4.PRG

// + EOF: m_bs4.prg
// +
