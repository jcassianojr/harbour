// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_b71.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_B71.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no V?eo
MDI( " þ Imprimir Previs„o de Faturamento" )

nIND := NUMIND( "MO02" )

// Variaveis de Trabalho
CRIARVARS( "MA01" )
CRIARVARS( "MO02" )

FILTRO := ''
FILTRO := RFILORD( "MO02", .F. )
CTLIN  := NRCOPIA := 1
VEZES  := 0

IF !CHECKIMP( 0 )
RETURN .F.
ENDIF
cEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )
@ 24, 00
@ 24, 00 SAY "N?ero de c?ias:" GET NRCOPIA PICT '99'
READCUR()
WHILE VEZES < NRCOPIA
VEZES++
CTLIN := 80
IF !USEREDE( "MO02", 1, 99 )
RETU
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
ZPAGINA   := 0
L2        := repl( "-", 80 )  // DECLARACAO DE VARIAVEIS
CO        := "|"
mVALORMER := mTOT := 0.00
mENTREGA  := ENTREGA
MMES      := Month( ENTREGA )

IF !Eof()
IMPRESSORA()
ENDIF

WHILE !Eof()
IF Month( ENTREGA ) = MMES
mVALORMER := VALORMER + mVALORMER
ELSE
IF CTLIN > 55
ZPAGINA++
@  0, 12  SAY cRESET
@  0, 0   SAY impchr( cIMPTIT ) + cEMP + impchr( cIMPEXP ) // Nome da Empresa
@  1, 110 SAY ACENTO( 'P gina: ' ) + Str( ZPAGINA, 2 ) // No. da P gina
@  2, 110 SAY 'Emitida em: ' + DToC( ZDATA )
@  3, 01  SAY 'M_B71'
@  3, 115 SAY Time()
@  5, 30  SAY impchr( cIMPTIT ) + '    PREVISAO DE FATURAMENTO    ' + impchr( cIMPEXP )
@  7, 0   SAY repl( '-', 130 )
CTLIN := 09
@ CTLIN, 02 SAY 'Mes de Referencia'
@ CTLIN, 33 SAY '  Valor Total Mercadorias'
CTLIN++
ENDIF
RETORNO := ' '
CMES( mENTREGA )
@ CTLIN, 02 SAY RETORNO + '-' + Str( Year( mENTREGA ), 4 )
@ CTLIN, 33 SAY mVALORMER                         PICT '@E 999,999,999.99'
CTLIN++
mTOT      := mVALORMER + mTOT
mVALORMER := 0.00
mVALORMER += VALORMER
mENTREGA  := ENTREGA
MMES      := Month( ENTREGA )
ENDIF

dbSkip()
RETORNO := ' '
CMES( mENTREGA )
@ CTLIN, 02 SAY RETORNO + '-' + Str( Year( mENTREGA ), 4 )
@ CTLIN, 33 SAY mVALORMER                         PICT '@E 999,999,999.99'
CTLIN++
mTOT += mVALORMER
@ CTLIN, 00 SAY repl( '-', 79 )
CTLIN++
@ CTLIN, 33 SAY mTOT PICT '@E 999,999,999,999,999.99'
CTLIN++
@ CTLIN, 00 SAY repl( '-', 79 )
CTLIN++
ENDDO
ENDDO
dbCloseArea()
IMPFOL()
VIDEO()
IMPEND()
RETU

// + EOF: M_B71.PRG

// + EOF: m_b71.prg
// +
