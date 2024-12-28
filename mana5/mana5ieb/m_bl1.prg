// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bl1.prg
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

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_BL1.PRG
// +
// +    Reformatted by Click! 2.03 on Jun-11-2002 at  4:29 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
MDI( " þ Imprimir Contas a Pagar por Data de Vencimento " )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cEMP   := IMP( "ZEMP" )
nCOPIA := 1

FILTRO := ''
FILTRO := RFILORD( "ML01", .F. )

nIND := NUMIND( "ML01" )

lCOM := MDG( "Comprimido" )
lCAB := MDG( "Cabe‡ario" )
lDIA := MDG( "Total do Dia" )
MDS( "Digite N?de Copias" )
@ 24, 40 GET nCOPIA
READCUR()

IF !USEREDE( "ML01", 1, 1 )
RETU
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
IMPRESSORA()
FOR X := 1 TO NCOPIA
CTLIN   := 80
TOT1    := TOT2 := 0.00
ZPAGINA := 0

IF Lcom
@  0, 0 SAY IMPSTR( aCHR[ 1 ] )
ENDIF

dbGoTop()
WHILE !Eof()
DAT  := VENCIMENT
TOT1 := 0
WHILE DAT = VENCIMENT .AND. !Eof()
IF CTLIN > 55
IF lCAB
ZPAGINA++
@  0, 0   SAY cEMP
@  1, 01  SAY 'M_BL1'
@  1, 20  SAY 'CONTAS A PAGAR POR DATA DE VENCIMENTO'
@  1, 80  SAY Time()
@  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
@  1, 110 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 )
@  2, 0   SAY repl( '-', 132 )
@ 03, 01  SAY ' NUMERO '
@ 03, 14  SAY 'EMISSAO'
@ 03, 25  SAY 'FORNECEDOR'
@ 03, 45  SAY 'VENCERA' // 45
@ 03, 55  SAY ' VALOR TITULO ' // 57
@ 03, 71  SAY 'COD' // NOVO
@ 03, 76  SAY 'BCO'
@ 03, 80  SAY 'OBSERVACAO:'
@ 04, 0   SAY repl( '-', 132 )
CTLIN := 5
ELSE
CTLIN := 1
ENDIF
ENDIF
@ CTLIN, 01 SAY NRNOTA PICT '99999999'
IF !Empty( TIPFAT )
@ CTLIN, 09 SAY '-' + TIPFAT
ENDIF
@ CTLIN, 14 SAY DATA
@ CTLIN, 25 SAY StrZero( FORNECEDO, 5 )
@ CTLIN, 31 SAY COGNOME
@ CTLIN, 45 SAY VENCIMENT
@ CTLIN, 55 SAY VALATUAL             PICT '999,999,999.99'
@ CTLIN, 71 SAY COD
@ CTLIN, 82 SAY BANCO
@ CTLIN, 86 SAY Left( OBS1, 40 )
TOT1 += VALATUAL
TOT2 += VALATUAL
CTLIN++
dbSkip()
ENDDO
IF TOT1 > 0 .AND. lDIA
@ CTLIN, 0 SAY repl( '-', 132 )
CTLIN++
@ CTLIN, 58 SAY TOT1           PICT '999,999,999.99'
@ CTLIN, 76 SAY 'Total do Dia'
CTLIN++
@ CTLIN, 0 SAY repl( '-', 132 )
CTLIN++
ENDIF
ENDDO
IF TOT2 > 0
CTLIN++
@ CTLIN, 58 SAY TOT2           PICT '999,999,999.99'
@ CTLIN, 76 SAY 'Total Geral '
CTLIN++
ENDIF
NEXT X
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()

// + EOF: M_BL1.PRG

// + EOF: m_bl1.prg
// +
