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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_BL1.PRG   : Imprimir Duplicata em formulario continuo
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Documentado em: Julho 28, 1994 as 17:39:37                DISK!  vers„o 5.01
// :*****************************************************************************
// Modo de Trabalho no Video
MDI( " þ Imprimir Contas a Pagar por Data de Vencimento " )

nIND   := NUMIND( "ML01" )
FILTRO := ''
FILTRO := RFILORD( "ML01", .F. )
CTLIN  := NRCOPIA := 1
VEZES  := 0
IF !CHECKIMP()
RETU .F.
ENDIF
@ 24, 00
@ 24, 00 SAY "N£mero de copias:" GET NRCOPIA PICT '99'
READCUR()
WHILE VEZES < NRCOPIA
VEZES++
CTLIN := 80
IF !USEREDE( "ML01", 1, nIND )
RETU
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
ZPAGINA := 0
IF !Eof()
SET DEVICE TO PRINT
ENDIF
TOT1 := TOT2 := 0.00
DAT  := VENCIMENT
WHILE !Eof()
IF CTLIN > 55
ZPAGINA++
@  0, 0  SAY IMP( "RESET" ) + impchr( Cimpexp )
@  0, 0  SAY IMP( "ZEMP" )
@  1, 59 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 )
@  2, 01 SAY 'M_AL1'
@  2, 35 SAY Time()
@  2, 59 SAY 'Emitida em: ' + DToC( ZDATA )
@  3, 00 SAY impchr( Cimptit ) + 'Contas a Pagar por Data de Vencimento'
@  4, 0  SAY '*' + REPL( '-', 78 ) + '*' + impchr( Cimpcom )
@ 05, 88 SAY 'DIAS'
@ 06, 01 SAY ' NUMERO '
@ 06, 12 SAY 'FORNECEDOR'
@ 06, 31 SAY 'TELEFONE'
@ 06, 45 SAY ''
@ 06, 51 SAY ' VENCERA'
@ 06, 70 SAY ' VALOR TITULO '
@ 06, 85 SAY 'SI'
@ 06, 88 SAY 'ATRASO'
@ 06, 95 SAY 'OBSERVACAO:'
@ 07, 0  SAY impchr( Cimpexp ) + '*' + REPL( '-', 78 ) + '*' + impchr( Cimpcom )
CTLIN := 08
ENDIF
@ CTLIN, 01 SAY NRNOTA PICT '99999999'
IF !Empty( TIPFAT )
@ CTLIN, 09 SAY '-' + TIPFAT
ENDIF
@ CTLIN, 12 SAY StrZero( CLIENTE, 5 )
@ CTLIN, 18 SAY COGNOME
@ CTLIN, 31 SAY DDD
@ CTLIN, 36 SAY TELEFONE
@ CTLIN, 45 SAY ' '
@ CTLIN, 51 SAY VENCIMENT
@ CTLIN, 70 SAY VALOR              PICT '999,999,999.99'
@ CTLIN, 85 SAY SITUACAO           PICT '99'
IF ZDATA > VENCIMENT
@ CTLIN, 90 SAY ( ZDATA - VENCIMENT ) PICT '999'
ENDIF
@ CTLIN, 95 SAY Left( OBS1, 34 )
TOT1 += VALOR
TOT2 += VALOR
CTLIN++
dbSkip()
IF DAT <> VENCIMENT
@ CTLIN, 70 SAY '--------------'
CTLIN++
@ CTLIN, 70 SAY TOT1           PICT '999,999,999.99'
@ CTLIN, 86 SAY 'Total do Dia'
CTLIN++
@ CTLIN, 70 SAY '--------------'
CTLIN++
DAT  := VENCIMENT
TOT1 := 0.00
ENDIF
ENDDO
@ CTLIN, 70 SAY '--------------'
CTLIN++
@ CTLIN, 70 SAY TOT2           PICT '999,999,999.99'
@ CTLIN, 86 SAY 'Total Geral '
CTLIN++
IF ZPAGINA > 0
@ CTLIN, 0 SAY '*' + REPL( '-', 131 ) + '*' + Chr( 13 ) + impchr( Cimpexp )
CTLIN++
ENDIF
ENDDO
IF ZPAGINA > 0
IMPFOL()
ENDIF
SET DEVICE TO SCREEN
dbCloseArea()
RETU

// ** EOF ***

// + EOF: m_bl1.prg
// +
