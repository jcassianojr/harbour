// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo2.prg
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => C:\DEVELOP\CLIPPER\MANA5\ITAESBRA\M_BO2.PRG
// +
// +    Reformatted by Click! 2.03 on Nov-23-2004 at 12:13 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// Modo de Trabalho no Video
// #INCLUDE "COMANDO.CH"
MDI( " н Imprimir Programa de Trabalho" )
IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cEMP   := AllTrim( IMP( "ZEMP" ) )
cRESET := IMP( "RESET" )

lSALDO := SENHAX( "MBO201" )
lPARTI := SENHAX( "MBO202" )

IF lSALDO
lSALDO := MDG( "Listar Saldo do Processo" )
ENDIF

IF lPARTI
lPARTI := MDG( "Listar Participacao Produto NAO=ESTOQUE" )
ENDIF
lCLIFOL := MDG( "Um Cliente por Folha" )
lORDEM  := MDG( "Ordem (Sim) Numero (NAO) Cognome" )

FILTRO   := ''
FILTRO   := RFILORD( "MO02", .F. )
mOBSMBO2 := Space( 70 )
nNRCOPIA := 1
@ 23, 00 SAY "Nr copias"
@ 23, 20 GET nNRCOPIA
@ 24, 00 SAY "Obs:"
@ 24, 05 GET mOBSMBO2
READCUR()
mOBSMBO2 := AllTrim( mOBSMBO2 )
@ 23, 00 SAY Space( 80 )
@ 24, 00 SAY Space( 80 )

CTLIN := 80
IF !USEMULT( { { "MS01", 1, 2 }, { "OF01", 1, 1 }, { "MO02", 1, 99 }, { "MA01", 1, 1 }, { "MO01", 1, 1 } } )
RETU .F.
ENDIF
ZPAGINA := 0
dbSelectAr( "MO02" )
IF lORDEM
dbSetOrder( 5 )
ELSE
dbSetOrder( 2 )
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
nLASTREC := LastRec()
nPOSREC  := 1
dbGoTop()
IF Eof()
dbCloseAll()
ALERTX( "Sem Resultados Para o Filtro" )
RETU .F.
ENDIF
IMPRESSORA()
lCLIENTE := .T.

FOR x := 1 TO nNRCOPIA
dbSelectAr( "MO02" )
dbGoTop()
WHILE !Eof()
video()
@ 24, 00 SAY FORNECEDO
impressora()
nFORNECEDO := FORNECEDO
cCOGNOME   := COGNOME
cCLIENTE   := Str( nFORNECEDO, 5, 0 )
dbSelectAr( "MA01" )
dbGoTop()
IF dbSeek( nFORNECEDO )
cCLIENTE := Str( nFORNECEDO, 5, 0 ) + '-' + Trim( COGNOME ) + '-' + Trim( CIDADE )
IF !Empty( siSco )
ccliente += " Cisco:" + sISCO
ENDIF
IF !Empty( planta )
ccliente += " Planta:" + Planta
ENDIF
IF !Empty( doca )
ccliente += + " Doca:" + DOCA
ENDIF
ENDIF
dbSelectAr( "MO02" )
WHILE IF( lORDEM, nFORNECEDO = FORNECEDO, cCOGNOME = COGNOME ) .AND. !Eof()
video()
@ 24, 20 SAY PEDIDO
ZEI_FORT( nLASTREC, .T., nPOSREC )
nPOSREC++
impressora()
IF QTDESAL > 0
IF CTLIN > 50
ZPAGINA++
IF nTIPSPO = 2 .OR. nTIPSPO = 3 .OR. nTIPSPO = 4
@  0, 0 SAY cRESET
ENDIF
@  0, 1   SAY impchr( cIMPTIT ) + cEMP + impchr( cIMPEXP )
@  1, 1   SAY 'M_BO2'
@  1, 10  SAY 'PROGRAMA DE TRABALHO'
@  1, 60  SAY ACENTO( 'P gina: ' ) + Str( ZPAGINA, 2 )
@  1, 80  SAY 'Emitida em: ' + DToC( ZDATA )
@  1, 100 SAY Time()
@  2, 0   SAY mOBSMBO2
@  3, 0   SAY repl( '-', 130 )
@  4, 03  SAY 'O.S.'
@  4, 09  SAY 'P'
@  4, 11  SAY 'Codigo'
@  4, 27  SAY 'Nome'
@  4, 53  SAY 'Ped Cli'
@  4, 63  SAY 'Qtde'
@  4, 72  SAY 'Entreg'
@  4, 81  SAY 'Saldo'
@  4, 90  SAY 'Fabricar'
@  4, 99  SAY 'UN'
@  4, 102 SAY 'Entrega'
@  4, 111 SAY 'PL'
IF lPARTI
@  4, 114 SAY "Parti"
ELSE
@  4, 114 SAY "Estq"
ENDIF
@  4, 121 SAY 'Obs:'
CTLIN    := 5
lCLIENTE := .T.
ENDIF
IF lCLIENTE
@ CTLIN, 0 SAY repl( '-', 130 )
CTLIN++
@ CTLIN, 5 SAY impchr( cIMPTIT ) + AllTrim( cCLIENTE ) + impchr( cIMPEXP )
CTLIN++
@ CTLIN, 0 SAY repl( '-', 130 )
CTLIN++
lCLIENTE := .F.
ENDIF
nPEDIDO := PEDIDO
PEDCLI  := ""
COND    := ""
dbSelectAr( "MO01" )
dbGoTop()
IF dbSeek( nPEDIDO )
PEDCLI := PEDIDOCLI
COND   := CONDPAG
ENDIF
dbSelectAr( "MO02" )
@ CTLIN, 00 SAY OS                                             PICT '99999.99'
@ CTLIN, 09 SAY TIPOSERV
@ CTLIN, 11 SAY Left( CODIGO, 15 ) // CODIGO DA PECA
@ CTLIN, 27 SAY Left( NOME, 25 ) // NOME DA PECA
@ CTLIN, 53 SAY Left( PEDCLI, 9 ) // 51  PEDIDO DO CLIENTE (MO01)
DO CASE
CASE UNID = 'CT'
@ CTLIN, 63 SAY Str( QTDEPED, 8, 2 )
@ CTLIN, 72 SAY Str( QTDEENT, 8, 2 )
@ CTLIN, 81 SAY Str( QTDESAL, 8, 2 )
CASE UNID = 'ML'
@ CTLIN, 63 SAY Str( QTDEPED, 8, 3 )
@ CTLIN, 72 SAY Str( QTDEENT, 8, 3 )
@ CTLIN, 81 SAY Str( QTDESAL, 8, 3 )
CASE UNID = 'HR'
@ CTLIN, 63 SAY Str( HORAPED, 8, 3 )
@ CTLIN, 72 SAY Str( HORAENT, 8, 3 )
@ CTLIN, 81 SAY Str( HORASAL, 8, 3 )
OTHERWISE
@ CTLIN, 63 SAY Str( QTDEPED, 8, 0 )
@ CTLIN, 72 SAY Str( QTDEENT, 8, 0 )
@ CTLIN, 81 SAY Str( QTDESAL, 8, 0 )
ENDCASE
IF lSALDO
mCHAVE := Str( PEDIDO, 8, 2 ) + Str( ITEM, 3 )
dbSelectAr( "OF01" )
dbGoTop()
IF dbSeek( mCHAVE )
@ CTLIN, 90 SAY Str( QSALDO, 8, 2 )
ENDIF
dbSelectAr( "MO02" )
ENDIF
@ CTLIN, 99  SAY UNID
@ CTLIN, 102 SAY ENTREGA
@ CTLIN, 111 SAY PLANTA
mCODIGO := CODIGO
// if lPARTI
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( mCODIGO )
IF lPARTI
@ CTLIN, 114 SAY PARTI
ELSE
@ CTLIN, 114 SAY Str( convun( ESTQSAL, unid ), 8, 0 )
ENDIF
ENDIF
dbSelectAr( "MO02" )
// endif
@ CTLIN, 123 SAY impchr( cIMPCOM ) + SubStr( OBSERVACAO, 1, 15 ) + impchr( cIMPEXP )
CTLIN++
ENDIF
dbSelectAr( "MO02" )
dbSkip()
ENDDO
lCLIENTE := .T.
IF lCLIFOL
CTLIN := 56
ENDIF
ENDDO
NEXT
dbCloseAll()
@ CTLIN, 0 SAY "" // Ajuste Uma Lina Para o Video
VIDEO()
IMPEND()

// + EOF: M_BO2.PRG

// + EOF: m_bo2.prg
// +
