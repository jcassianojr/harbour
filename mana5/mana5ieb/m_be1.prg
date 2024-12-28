// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_be1.prg
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
// +    Source Module => J:\ITAESBRA\M_BE.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"
MDI( " þ Imprimir Equipamentos por Grupo" )

// Checa a Impressora
IF !CHECKIMP( 0 )
RETURN .F.
ENDIF
cRESET := IMP( "RESET" )
cEMP   := IMP( "ZEMP" )

// N?ero de C?ias
NRCOPIA := 1
@ 24, 00
@ 24, 00 SAY "N?ero de copias:" GET NRCOPIA PICT '99'
IF !READCUR()
RETU .F.
ENDIF

// Filtro da Listagem
FILTRO := ''
FILTRO := RFILORD( "ME01", .F. )

// Abertura do Arquivo Nome + Modelo
IF !USEREDE( "ME01", 1, 2 )
RETU
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
IF Eof()
dbCloseAll()
RETU .F.
ENDIF
IMPRESSORA()
FOR X := 1 TO NRCOPIA
CTLIN   := 80
ZPAGINA := 0
dbGoTop()
WHILE !Eof()
xMODELO := MODELO
xNOME   := NOME
nMODELO := 0
WHILE NOME = xNOME .AND. MODELO = xMODELO .AND. !Eof()
nMODELO++
dbSkip()
ENDDO
IF CTLIN > 56
ZPAGINA++
@  0, 0  SAY cRESET
@  0, 0  SAY cEMP
@  1, 60 SAY ACENTO( 'P gina: ' ) + Str( ZPAGINA, 2 )
@  2, 60 SAY 'Emitida em: ' + DToC( ZDATA )
@  3, 01 SAY 'M_BE'
@  3, 70 SAY Time()
@  5, 00 SAY impchr( cIMPTIT ) + ACENTO( 'Resumo de M quinas e Equipamentos por Modelo' )
@  7, 0  SAY repl( '-', 80 )
@  8, 0  SAY "Nome" + spac( 37 ) + "Modelo" + spac( 15 ) + "Quantidade"
@ 09, 0  SAY repl( '-', 80 )
CTLIN := 10
ENDIF
@ CTLIN, 0  SAY ACENTO( xNOME )
@ CTLIN, 41 SAY ACENTO( xMODELO )
@ CTLIN, 62 SAY nMODELO
CTLIN++
ENDDO
NEXT X
IMPFOL()
VIDEO()
dbCloseAll()
IMPEND()

// + EOF: M_BE.PRG

// + EOF: m_be1.prg
// +
