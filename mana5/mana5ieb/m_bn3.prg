// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bn3.prg
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
// +    Source Module => J:\ITAESBRA\M_BN3.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
MDI( " Э Imprimir Contas Recebidas por Data de Pagamento" )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cEMP    := IMP( "ZEMP" )
lCOM    := MDG( "Comprimido" )
lDIA    := MDG( "Totais do Dia" )
CTLIN   := 80
ZPAGINA := 0
TOT1    := TOT2 := 0.00


aRETU   := PERFEC( { "MN01PG" }, { "MN" }, { "MN99" } )
ARQWORK := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]



FILTRO := ''
FILTRO := RFILORD( ARQWORK, .F. )


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
TOT1 := 0
DAT  := DATAPG   // DAT :=VENCIMENT
WHILE DATAPG = DAT .AND. !Eof()
IF CTLIN > 55
ZPAGINA++
@  0, 0   SAY cEMP
@  1, 01  SAY 'M_BN3'
@  1, 20  SAY 'CONTAS RECEBIDAS POR DATA DE PAGAMENTO' + impchr( cIMPEXP )
@  1, 80  SAY Time()
@  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
@  1, 110 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 )
@  2, 0   SAY repl( '-', 132 )
@ 03, 01  SAY ' NUMERO '
@ 03, 14  SAY ACENTO( 'EMISSЋO' )
@ 03, 27  SAY 'CLIENTE '
@ 03, 47  SAY 'VENCIMENT'
@ 03, 59  SAY 'VALOR TITULO '
@ 03, 76  SAY 'PAGO EM'
@ 03, 84  SAY '     VALOR PAGO'
@ 03, 101 SAY ACENTO( 'OBSERVAЂЋO:' )
@ 04, 0   SAY repl( '-', 132 )
CTLIN := 5
ENDIF
@ CTLIN, 01 SAY NUMERO PICT '99999999'
IF !Empty( TIPFAT )
@ CTLIN, 09 SAY '-' + TIPFAT
ENDIF
@ CTLIN, 14 SAY DATA // NOVO
@ CTLIN, 25 SAY StrZero( FORNECEDO, 5 )
@ CTLIN, 32 SAY COGNOME
@ CTLIN, 45 SAY VENCIMENT
@ CTLIN, 55 SAY VALOR                PICT '999,999,999.99'
@ CTLIN, 73 SAY DATAPG
@ CTLIN, 83 SAY VALORPG              PICT '999,999,999.99'
@ CTLIN, 99 SAY Left( OBS1, 31 ) // 99
TOT1 += VALORPG   // Soma dos Valores pagos (por dia e geral)
TOT2 += VALORPG
CTLIN++
dbSkip()
ENDDO
IF TOT1 > 0 .AND. lDIA
CTLIN++
@ CTLIN, 83 SAY TOT1                 PICT '999,999,999.99' // 58
@ CTLIN, 98 SAY 'Total do Dia' // 76
CTLIN++
@ CTLIN, 0 SAY repl( '-', 132 )
CTLIN++
ENDIF
ENDDO
IF TOT2 > 0
@ CTLIN, 0 SAY repl( '-', 132 )
CTLIN++
@ CTLIN, 83 SAY TOT2                 PICT '999,999,999.99' // 58
@ CTLIN, 98 SAY 'Total Geral ' // 76
CTLIN++
@ CTLIN, 0 SAY repl( '-', 132 )
CTLIN++
ENDIF
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()

// + EOF: M_BN3.PRG

// + EOF: m_bn3.prg
// +
