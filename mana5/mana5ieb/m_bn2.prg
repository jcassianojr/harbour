// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bn2.prg
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
// +    Source Module => J:\ITAESBRA\M_BN2.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"


// Modo de Trabalho no Video
MDI( " þ Imprimir Contas a Receber Data de Vencimento " )

// Checando a Impressora
IF !CHECKIMP( 0 )
RETURN .F.
ENDIF
cEMP := IMP( "ZEMP" )


lCOM := MDG( "Comprimido" )


// Filtro de Trabalho
FILTRO := ''
FILTRO := RFILORD( "MN01", .F. )

CTLIN   := 80
ZPAGINA := 0
TOT1    := TOT2 := 0.00

// Abrindo o Arquivo
IF !USEREDE( "MN01", 1, 1 )
RETU
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF

IMPRESSORA()
IF Lcom
@  0, 0 SAY IMPSTR( aCHR[ 1 ] )
ENDIF

dbGoTop()
WHILE !Eof()
TOT1  := 0.00
DAT   := VENCIMENT
nITEM := 0
WHILE VENCIMENT = DAT .AND. !Eof()
IF CTLIN > 55
ZPAGINA++
@  0, 0   SAY cEMP
@  1, 01  SAY 'M_BN2'
@  1, 20  SAY 'CONTAS A RECEBER POR DATA DE VENCIMENTO'
@  1, 80  SAY Time()
@  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
@  1, 110 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 )
@  2, 0   SAY repl( '-', 132 )
@ 03, 01  SAY ' NUMERO '
@ 03, 14  SAY ACENTO( 'EMISSŽO' )
@ 03, 27  SAY 'CLIENTE '
@ 03, 47  SAY ACENTO( 'VENCER' )
@ 03, 62  SAY ' VALOR TITULO '
@ 03, 76  SAY 'BANCO' // NOVO
@ 03, 84  SAY 'DOC.BOL.' // NOVO
@ 03, 103 SAY ACENTO( 'OBSERVA€ŽO:' )
@ 04, 0   SAY repl( '-', 132 )
CTLIN := 5
ENDIF
@ CTLIN, 01 SAY NUMERO PICT '99999999'
IF !Empty( TIPFAT )
@ CTLIN, 09 SAY '-' + TIPFAT
ENDIF
@ CTLIN, 12 SAY DATA // NOVO
@ CTLIN, 25 SAY StrZero( FORNECEDO, 5 )
@ CTLIN, 32 SAY COGNOME
@ CTLIN, 45 SAY VENCIMENT
@ CTLIN, 57 SAY VALATUAL             PICT '999,999,999.99'
@ CTLIN, 74 SAY BANCO // NOVO
@ CTLIN, 81 SAY DOCBOL // NOVO
@ CTLIN, 99 SAY Left( OBS1, 31 )
TOT1 += VALATUAL
TOT2 += VALATUAL
nITEM++
CTLIN++
dbSkip()
ENDDO
IF nITEM > 0
CTLIN++
@ CTLIN, 58 SAY TOT1           PICT '999,999,999.99'
@ CTLIN, 76 SAY 'Total do Dia'
CTLIN++
@ CTLIN, 1 SAY repl( '-', 132 )
CTLIN++
ENDIF
ENDDO
IF TOT2 > 0
@ CTLIN, 1 SAY repl( '-', 132 )
CTLIN++
@ CTLIN, 58 SAY TOT2           PICT '999,999,999.99'
@ CTLIN, 76 SAY 'Total Geral '
CTLIN++
ENDIF
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()

// + EOF: M_BN2.PRG

// + EOF: m_bn2.prg
// +
