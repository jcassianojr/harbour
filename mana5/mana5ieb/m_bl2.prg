// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bl2.prg
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
// +    Source Module => J:\ITAESBRA\M_BL2.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no VЎdeo
MDI( " Э Imprimir Relatўrio de Contas Pagas" )

lCOM := MDG( "Comprimido" )
lDIA := MDG( "Total do Dia" )

// Verifica a Impressora
IF !CHECKIMP( 0 )
RETURN .F.
ENDIF
cEMP := IMP( "ZEMP" )

// Grupo da Listagem
FILTRO := ''
FILTRO := RFILORD( "ML01PG", .F. )


aRETU   := PERFEC( { "ML01PG" }, { "ML" }, { "ML99" } )
ARQWORK := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]

TOTPG1  := TOTPG2 := 0.00
ZPAGINA := 0
CTLIN   := 80

IF !USEREDE( ARQWORK, 1, 0 )
RETU
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "datapg" )
ordSetFocus( "temp" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF

IMPRESSORA()
IF Lcom
@  0, 0 SAY IMPSTR( aCHR[ 1 ] )
ENDIF

dbGoTop()
WHILE !Eof()
TOTPG1 := 0.00
DAT    := DATAPG   // VENCIMENT
WHILE dat = datapg .AND. !Eof()
IF CTLIN > 55
ZPAGINA++
@  0, 0   SAY cEMP
@  1, 01  SAY 'M_BL2'
@  1, 20  SAY 'CONTAS PAGAS POR DATA DE PAGAMENTO'
@  1, 80  SAY Time()
@  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
@  1, 110 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 )
@  2, 0   SAY repl( '-', 132 )
@ 03, 01  SAY 'Numero '
@ 03, 14  SAY 'Emissao'
@ 03, 23  SAY 'Fornecedor'
@ 03, 42  SAY 'Vcto'
@ 03, 51  SAY 'Valor'
@ 03, 64  SAY 'Dep'
@ 03, 68  SAY 'Bco'
@ 03, 72  SAY 'Data Pg'
@ 03, 81  SAY 'Valor Pg'
@ 03, 94  SAY 'Diferen‡a'
@ 03, 107 SAY 'Obs'
@ 04, 0   SAY repl( '-', 132 )
CTLIN := 5
ENDIF
@ CTLIN, 01 SAY NRNOTA PICT '99999999'
IF !Empty( TIPFAT )
@ CTLIN, 09 SAY '-' + TIPFAT
ENDIF
@ CTLIN, 14  SAY DATA
@ CTLIN, 23  SAY StrZero( FORNECEDO, 5 )
@ CTLIN, 29  SAY COGNOME
@ CTLIN, 42  SAY VENCIMENT
@ CTLIN, 51  SAY VALOR                PICT '@E 99999,999.99'
@ CTLIN, 64  SAY COD
@ CTLIN, 68  SAY BANCO
@ CTLIN, 72  SAY DATAPG
@ CTLIN, 81  SAY VALORPG              PICT '@E 99999,999.99'
@ CTLIN, 94  SAY DIFERENCA            PICT '@E 99999,999.99'
@ CTLIN, 107 SAY Left( OBS1, 20 )
TOTPG1 += VALORPG
TOTPG2 += VALORPG
CTLIN++
dbSkip()
ENDDO
IF TOTPG1 > 0 .AND. lDIA
CTLIN++
@ CTLIN, 90  SAY 'Total do Dia'
@ CTLIN, 106 SAY TOTPG1         PICT '999,999,999.99'
CTLIN++
@ CTLIN, 0 SAY repl( '-', 132 )
CTLIN++
ENDIF
ENDDO
IF TOTPG2 > 0
CTLIN++
@ CTLIN, 90  SAY 'Total Geral '
@ CTLIN, 106 SAY TOTPG2         PICT '999,999,999.99'
ENDIF
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()

// + EOF: m_bl2.prg
// +
