// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo1.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// #INCLUDE "COMANDO.CH"
// Modo de Trabalho no Video
MDI( " þ Imprimir Pedidos por Ordem de Clientes" )

IF !CHECKIMP( 0 )
RETURN .F.
ENDIF
cZEMP  := IMP( "ZEMP" )
cRESET := IMP( "RESET" )

FILTRO := ''
FILTRO := RFILORD( "MO02", .F. )
lANA   := MDG( "Deseja Analitico" )
lRES   := MDG( "Deseja Resumo" )

IF !USEMULT( { { "MA01", 1, 1 }, { "MO01", 1, 1 }, { "MO02", 1, 5 } } )
RETU .F.
ENDIF

dbSelectAr( "MO02" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF

ZPAGINA := 0
CTLIN   := 80
aMES    := {}
aVAL    := {}
aQTD    := {}
AAdd( aMES, "ATRASO" )   // Atraso
AAdd( aVAL, 0 )  // Valor Zerado
AAdd( aQTD, 0 )

IMPRESSORA()
dbSelectAr( "MO02" )
dbGoTop()
WHILE !Eof()
mCOGN      := COGNOME
mFORNECEDO := FORNECEDO
aCMES      := {}
aCVAL      := {}
aCQTD      := {}
lCLIENTE   := .T.
AAdd( aCMES, "ATRASO" )   // Atraso Cliente
AAdd( aCVAL, 0 )  // Valor Zerado Cliente
AAdd( aCQTD, 0 )
dbSelectAr( "MA01" )
dbGoTop()
CID := if( dbSeek( mFORNECEDO ), CIDADE, "" )
dbSelectAr( "MO02" )
WHILE mFORNECEDO = FORNECEDO .AND. !Eof()
IF CTLIN > 55 .AND. lANA
ZPAGINA++
lCLIENTE := .T.
@  0, 0   SAY cRESET
@  0, 10  SAY cZEMP
@  1, 1   SAY 'M_BO1'
@  1, 10  SAY 'Pedidos Por Cliente'
@  1, 60  SAY ACENTO( 'P gina: ' ) + Str( ZPAGINA, 2 )
@  1, 80  SAY 'Emitida em: ' + DToC( ZDATA )
@  1, 100 SAY Time()
@  2, 0   SAY repl( '-', 130 )
@  3, 00  SAY impchr( cIMPCOM )
@ 03, 02  SAY 'PEDIDO'
@ 03, 10  SAY 'T'
@ 03, 17  SAY 'COGIGO DA PECA'
@ 03, 40  SAY 'NOME DA PECA'
@ 03, 56  SAY 'PEDIDO  CLIENTE'
@ 03, 74  SAY 'Quantidade'
@ 03, 93  SAY 'UN'
@ 03, 98  SAY 'PRAZO'
@ 03, 107 SAY 'IPI'
@ 03, 111 SAY 'CONSUMO'
@ 03, 120 SAY 'PRECO UNITARIO'
@ 03, 137 SAY '** TOTAL **'
@ 03, 150 SAY 'BASE PRECO'
@ 03, 162 SAY 'COND'
@ 03, 168 SAY 'MP'
@ 03, 171 SAY 'OBSERVACOES'
@ 04, 0   SAY impchr( cIMPEXP ) + repl( '-', 130 ) + impchr( cIMPCOM )
CTLIN := 5
ENDIF
IF lCLIENTE .AND. lANA
IF CTLIN <> 5  // Posicao sem ser cabecario
CTLIN++
@ CTLIN, 0 SAY repl( '-', 130 ) + impchr( cIMPCOM )
CTLIN++
ENDIF
@ CTLIN, 0 SAY impchr( cIMPEXP )
@ CTLIN, 5 SAY impchr( cIMPTIT ) + Str( FORNECEDO, 5, 0 ) + ' ' + COGNOME + '  ' + CID + impchr( cIMPEXP )
CTLIN++
@ CTLIN, 0 SAY repl( '-', 130 ) + impchr( cIMPCOM )
CTLIN++
lCLIENTE := .F.
ENDIF
IF QTDESAL > 0.00
mPEDIDO := PEDIDO
COND    := ""
PEDCLI  := ""
dbSelectAr( "MO01" )
dbGoTop()
IF dbSeek( mPEDIDO )
COND   := CONDPAG
PEDCLI := PEDIDOCLI
ENDIF
dbSelectAr( "MO02" )
IF lANA
@ CTLIN, 00 SAY PEDIDO                                     PICT '99999.99'
@ CTLIN, 09 SAY TIPOSERV
@ CTLIN, 11 SAY Left( CODIGO, 20 ) // Codigo da peca
@ CTLIN, 31 SAY SubStr( NOME, 1, 20 ) // Nome da peca
@ CTLIN, 52 SAY Left( PEDCLI, 10 ) // Pedido do cliente (mo01)
DO CASE
CASE UNID = 'CT'
@ CTLIN, 63 SAY Str( QTDEPED, 9, 2 )
@ CTLIN, 73 SAY Str( QTDEENT, 9, 2 )
@ CTLIN, 83 SAY Str( QTDESAL, 9, 2 )
CASE UNID = 'ML'
@ CTLIN, 63 SAY Str( QTDEPED, 9, 3 )
@ CTLIN, 73 SAY Str( QTDEENT, 9, 3 )
@ CTLIN, 83 SAY Str( QTDESAL, 9, 3 )
CASE UNID = 'HR'
@ CTLIN, 63 SAY Str( HORAPED, 9, 3 )
@ CTLIN, 73 SAY Str( HORAENT, 9, 3 )
@ CTLIN, 83 SAY Str( HORASAL, 9, 3 )
OTHERWISE
@ CTLIN, 63 SAY Str( QTDEPED, 9, 0 )
@ CTLIN, 73 SAY Str( QTDEENT, 9, 0 )
@ CTLIN, 83 SAY Str( QTDESAL, 9, 0 )
ENDCASE
@ CTLIN, 93  SAY UNID // Unidade
@ CTLIN, 96  SAY ENTREGA // Prazo (data)
@ CTLIN, 108 SAY IPI
@ CTLIN, 115 SAY CONSUMO
ENDIF
mVALOR   := VALOR
mTEMPVAL := 0
IF Empty( INDICE )
IF lANA
@ CTLIN, 118 SAY VALOR PICT '@E 999,999,999.99' // Preco unitario 140
ENDIF
ELSE
PREIND( INDICE, ZDATA, "mTEMPVAL" )
mVALOR := Round( mTEMPVAL * VALIND, 4 )
IF lANA
@ CTLIN, 118 SAY mVALOR PICT '@E 999,999,999.99' // Preco unitario 140
ENDIF
ENDIF
IF UNID = "HR"
xTOTALVAL := HORASAL * mVALOR
ELSE
xTOTALVAL := QTDESAL * mVALOR   // Acha o Valor Total
ENDIF
IF lANA
@ CTLIN, 134 SAY xTOTALVAL               PICT '@E 999,999,999.99' // 156
@ CTLIN, 150 SAY "LISTA PRECO"
@ CTLIN, 163 SAY COND
@ CTLIN, 168 SAY MATPRIMA
@ CTLIN, 172 SAY SubStr( OBSERVACAO, 1, 30 )
CTLIN++
ENDIF
IF ENTREGA < ZDATA
aCVAL[ 1 ] += xTOTALVAL
aCQTD[ 1 ] += CONVUN( QTDESAL, UNID )
aVAL[ 1 ] += xTOTALVAL
aQTD[ 1 ] += CONVUN( QTDESAL, UNID )
ELSE
cBUSCA := Left( cMES( ENTREGA ), 3 ) + "/" + StrZero( Year( ENTREGA ), 4 )
nPOS   := AScan( aCMES, cBUSCA )
IF nPOS > 0
aCVAL[ NPOS ] += xTOTALVAL
aCQTD[ NPOS ] += CONVUN( QTDESAL, UNID )
ELSE
AAdd( aCMES, cBUSCA )
AAdd( aCVAL, xTOTALVAL )
AAdd( aCQTD, CONVUN( QTDESAL, UNID ) )
ENDIF
nPOS := AScan( aMES, cBUSCA )
IF nPOS > 0
aVAL[ NPOS ] += xTOTALVAL
aQTD[ NPOS ] += CONVUN( QTDESAL, UNID )
ELSE
AAdd( aMES, cBUSCA )
AAdd( aVAL, xTOTALVAL )
AAdd( aQTD, CONVUN( QTDESAL, UNID ) )
ENDIF
ENDIF
ENDIF
dbSelectAr( "MO02" )
dbSkip()
ENDDO
nCOL := 0
nGER := 0
nQTD := 0
FOR W := 1 TO Len( aCMES )
IF nCOL > 120
CTLIN++
nCOL := 0
ENDIF
IF lANA
@ CTLIN, nCOL    SAY "Total " + aCMES[ W ]
@ CTLIN, nCOL + 15 SAY aCVAL[ W ]          PICT '@E 999,999.99'
@ CTLIN, nCOL + 30 SAY aCQTD[ W ]          PICT '@E 999,999,999'
ENDIF
nGER += aCVAL[ W ]
nQTD += aCQTD[ W ]
nCOL += 45
NEXT W
IF nCOL > 120 .AND. lANA
CTLIN++
nCOL := 0
ENDIF
IF lANA
@ CTLIN, nCOL    SAY "Total Geral"
@ CTLIN, nCOL + 15 SAY nGER          PICT '@E 999,999.99'
@ CTLIN, nCOL + 30 SAY nQTD          PICT '@E 999,999,999'
ENDIF
ENDDO
dbCloseAll()
IF lRES
ZPAGINA++// Pula p gina e imprime o cabecario e totais dos meses.
@  0, 12  SAY cRESET
@  0, 0   SAY impchr( cIMPTIT ) + cZEMP + impchr( cIMPEXP ) // Nome da Empresa
@  1, 110 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 ) // No. da P gina
@  2, 110 SAY 'Emitida em: ' + DToC( ZDATA )
@  3, 01  SAY 'M_BO1'
@  3, 115 SAY Time()
@  5, 30  SAY impchr( cIMPTIT ) + 'CADASTRO DE PEDIDOS POR CLIENTE' + impchr( cIMPEXP )
@  7, 0   SAY repl( '-', 130 )
CTLIN := 9
nGER  := 0
nQTD  := 0
FOR W := 1 TO Len( aMES )
CTLIN++
@ CTLIN, 15 SAY "Total " + aMES[ W ]
@ CTLIN, 30 SAY aVAL[ W ]          PICT '@E 999,999,999.99'
@ CTLIN, 45 SAY aQTD[ W ]          PICT '@E 999,999,999'
nGER += aVAL[ W ]
nQTD += aQTD[ W ]
NEXT W
CTLIN++
@ CTLIN, 15 SAY "Total Geral"
@ CTLIN, 30 SAY nGER          PICT '@E 999,999,999.99'
@ CTLIN, 45 SAY nQTD          PICT '@E 999,999,999'
ENDIF
VIDEO()
IMPEND()


// + EOF: m_bo1.prg
// +
