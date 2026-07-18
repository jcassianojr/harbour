// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foic1b.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :     FOIC1B.PRG: Listar Relatorio Gerencial
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:16
// :
// :  Procs & Fncts: FOIC1B()
// :
// :     Documentado 05/13/94 em 14:55                DISK!  vers„o 5.01
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


CTLIN := 80
FL    := 0
IF !CHECKIMP( 0 )
RETU .F.
ENDIF
IMPRESSORA()
dbSelectAr( "AJUGERD" )
dbGoTop()
DEP := DEPTO
SET := SETOR
SEC := SECAO
WHILE !Eof()
IF CTLIN > 50
FL++
@  1, 0   SAY IMPSTR( cIMPCOM )
@  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
@  3, 05  SAY IMPCHR( cIMPTIT ) + 'RELATORIO GERENCIAL: ' + MMES + '/' + StrZero( ANO, 4 )
@  5, 0   SAY POS1
@  5, 50  SAY TIPORES
@  5, 100 SAY Time()
@  5, 110 SAY Date()
@  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
@  6, 0   SAY REPL( '-', 132 )
@  7, 1   SAY 'NOME'
@  7, 16  SAY '|ADM'
@  7, 21  SAY 'DEM'
@  7, 25  SAY 'ATI'
@  7, 28  SAY "|SALARIO"
COL := 38
dbSelectAr( "TILRESG" )
dbGoTop()
WHILE !Eof()
@  7, COL   SAY '|'
@  7, COL + 1 SAY TITULO
COL := COL + 17
SKIP
ENDDO
@  7, 123 SAY "|TURNOVER"
COL := 39
FOR X := 1 TO 5
@  8, COL   SAY 'QTDE'
@  8, COL + 6 SAY 'VALOR'
COL := COL + 17
NEXT
@  9, 1 SAY REPL( '-', 132 )
CTLIN := 10
ENDIF
dbSelectAr( "AJUGERD" )
CTLIN++
@ CTLIN, 0  SAY NOME
@ CTLIN, 17 SAY ADM     PICT '###'
@ CTLIN, 21 SAY DEM     PICT '###'
@ CTLIN, 25 SAY ATI     PICT '###'
@ CTLIN, 29 SAY SALARIO PICT '########.'
COL := 39
FOR X := 1 TO 5
QTX := 'QT' + Str( X, 1 )
VLX := 'VL' + Str( X, 1 )
@ CTLIN, COL   SAY &QTX PICT '####.'
@ CTLIN, COL + 6 SAY &VLX PICT '########.'
COL := COL + 17
NEXT X
@ CTLIN, 124 SAY TURN PICT '########.'
CTLIN++
DEPSETSEC := Str( DEPTO, 4 ) + Str( SETOR, 3 ) + Str( SECAO, 3 )
@ CTLIN, 0 SAY DEPSETSEC
PER := IF( TOTT[ 11 ] # 0, ( ADM / TOTT[ 11 ] * 100 ), 0 )
@ CTLIN, 17 SAY PER PICT '##.'
PRE := IF( TOTT[ 12 ] # 0, ( DEM / TOTT[ 12 ] * 100 ), 0 )
@ CTLIN, 21 SAY PER PICT '##.'
PER := IF( TOTT[ 13 ] # 0, ( ATI / TOTT[ 13 ] * 100 ), 0 )
@ CTLIN, 25 SAY PER PICT '##.'
PER := IF( TOTT[ 14 ] # 0, ( SALARIO / TOTT[ 14 ] * 100 ), 0 )
@ CTLIN, 33 SAY PER PICT '##.#%'
COL := 39
FOR X := 1 TO 5
QTX := 'QT' + Str( X, 1 )
VLX := 'VL' + Str( X, 1 )
PER := IF( TOTT[ X ] # 0, ( &QTX / TOTT[ X ] * 100 ), 0 )
@ CTLIN, COL SAY PER PICT '##.#%'
PER := IF( TOTT[ X + 5 ] # 0, ( &VLX / TOTT[ X + 5 ] * 100 ), 0 )
@ CTLIN, COL + 10 SAY PER PICT '##.#%'
COL := COL + 17
NEXT X
PER := IF( TOTT[ 15 ] # 0, ( TURN / TOTT[ 16 ] * 100 ), 0 )
@ CTLIN, 128 SAY PER PICT '##.#%'
// ******************************TOTALIZANDO DEPTO/SETOR
FOR Q := 1 TO 5
QTW := 'QT' + Str( Q, 1 )
VLW := 'VL' + Str( Q, 1 )
TOTD[ Q ] = TOTD[ Q ] + &QTW
TOTD[ Q + 5 ] = TOTD[ Q + 5 ] + &VLW
TOTS[ Q ] = TOTS[ Q ] + &QTW
TOTS[ Q + 5 ] = TOTS[ Q + 5 ] + &VLW
NEXT X
TOTD[ 11 ] = TOTD[ 11 ] + ADM
TOTD[ 12 ] = TOTD[ 12 ] + DEM
TOTD[ 13 ] = TOTD[ 13 ] + ATI
TOTD[ 14 ] = TOTD[ 14 ] + SALARIO
TOTD[ 15 ] = TOTD[ 15 ] + TURN
TOTS[ 11 ] = TOTS[ 11 ] + ADM
TOTS[ 12 ] = TOTS[ 12 ] + DEM
TOTS[ 13 ] = TOTS[ 13 ] + ATI
TOTS[ 14 ] = TOTS[ 14 ] + SALARIO
TOTS[ 15 ] = TOTS[ 15 ] + TURN
// *****************************FINAL TOTALIZACAO
SKIP
IF SETOR # SET .OR. ( SETOR = SET .AND. DEPTO # DEP )
SET := SETOR
IF CC = 3
CTLIN++
@ CTLIN, 1 SAY REPL( '=', 132 )
// **************************TOTAL SETOR
CTLIN++
@ CTLIN, 1  SAY 'TOTAL Setor:'
@ CTLIN, 17 SAY TOTS[ 11 ]       PICT '###'
@ CTLIN, 21 SAY TOTS[ 12 ]       PICT '###'
@ CTLIN, 25 SAY TOTS[ 13 ]       PICT '###'
@ CTLIN, 28 SAY TOTS[ 14 ]       PICT '#########.'
COL := 39
FOR X := 1 TO 5
@ CTLIN, COL   SAY TOTS[ X ]   PICT '####.'
@ CTLIN, COL + 6 SAY TOTS[ X + 5 ] PICT '########.'
COL := COL + 17
NEXT X
@ CTLIN, 124 SAY TOTS[ 15 ] PICT '########.'
CTLIN++
AFill( TOTS, 0 )
ENDIF
ENDIF
IF DEPTO # DEP
DEP := DEPTO
IF CC # 1
CTLIN++
@ CTLIN, 1 SAY REPL( '|', 132 )
// **************************TOTAL DEPTO
CTLIN++
@ CTLIN, 1  SAY 'TOTAL Depto:'
@ CTLIN, 17 SAY TOTD[ 11 ]       PICT '###'
@ CTLIN, 21 SAY TOTD[ 12 ]       PICT '###'
@ CTLIN, 25 SAY TOTD[ 13 ]       PICT '###'
@ CTLIN, 28 SAY TOTD[ 14 ]       PICT '#########.'
COL := 39
FOR X := 1 TO 5
@ CTLIN, COL   SAY TOTD[ X ]   PICT '####.'
@ CTLIN, COL + 6 SAY TOTD[ X + 5 ] PICT '########.'
COL := COL + 17
NEXT X
@ CTLIN, 124 SAY TOTD[ 15 ] PICT '########.'
CTLIN++
AFill( TOTD, 0 )
ENDIF
ENDIF
ENDDO
CTLIN++
@ CTLIN, 1 SAY REPL( '-', 132 )
CTLIN++
@ CTLIN, 1  SAY 'TOTAL Geral'
@ CTLIN, 17 SAY TOTT[ 11 ]      PICT '###'
@ CTLIN, 21 SAY TOTT[ 12 ]      PICT '###'
@ CTLIN, 25 SAY TOTT[ 13 ]      PICT '###'
@ CTLIN, 28 SAY TOTT[ 14 ]      PICT '#########.'
COL := 39
FOR X := 1 TO 5
@ CTLIN, COL   SAY TOTT[ X ]   PICT '####.'
@ CTLIN, COL + 6 SAY TOTT[ X + 5 ] PICT '########.'
COL := COL + 17
NEXT X
@ CTLIN, 124 SAY TOTT[ 15 ] PICT '########.'
CTLIN++
@ CTLIN, 1 SAY 'Obs: A Linha inferior exibe o percentual'
CTLIN++
@ CTLIN, 1 SAY REPL( '-', 132 )
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()
RETU
// : FIM: FOIC1B.PRG

// + EOF: foic1b.prg
// +
