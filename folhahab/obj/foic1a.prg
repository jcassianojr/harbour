// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foic1a.prg
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
// :     FOIC1A.PRG: Listar Relatorio Gerencial
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:15
// :
// :  Procs & Fncts: FOIC1A()
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
@  1, 0   SAY IMPSTR( cIMPEXP )
@  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
@  3, 05  SAY IMPCHR( cIMPTIT ) + 'RELATORIO GERENCIAL: ' + MMES + '/' + StrZero( ANO, 4 )
@  5, 0   SAY POS1
@  5, 50  SAY TIPORES
@  5, 100 SAY Time()
@  5, 110 SAY Date()
@  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
@  6, 0   SAY IMPSTR( cIMPCOM ) + REPL( '-', 230 )
@  7, 0   SAY "Codigo" + SPAC( 7 ) + "Nome" + SPAC( 12 ) + "Funcionario Salario" + SPAC( 13 ) + "Admitidos   Demitidos"
COL := 85
dbSelectAr( "TILRESG" )
dbGoTop()
WHILE !Eof()
@  7, COL SAY TITULO
COL := COL + 29
SKIP
ENDDO
@  8, 0   SAY "Dep  Set Sec" + SPAC( 17 ) + "No.  Peso       Valor" + SPAC( 4 ) + "Peso   No.  Peso   No.  Pe"
@  8, 80  SAY "so   Horas        Valor" + SPAC( 4 ) + "Peso   Horas       Valor" + SPAC( 4 ) + "Peso   Horas        Valor"
@  8, 165 SAY "Peso   Horas        Valor" + SPAC( 4 ) + "Peso   Horas        Valor" + SPAC( 4 ) + "Peso"
@  9, 1   SAY REPL( '-', 230 )
CTLIN := 10
ENDIF
dbSelectAr( "AJUGERD" )
CTLIN  := CTLIN + 1
PERATI := IF( TOTT[ 13 ] # 0, ( ATI / TOTT[ 13 ] * 100 ), 0 )
PERSAL := IF( TOTT[ 14 ] # 0, ( SALARIO / TOTT[ 14 ] * 100 ), 0 )
PERADM := IF( TOTT[ 11 ] # 0, ( ADM / TOTT[ 11 ] * 100 ), 0 )
PERDEM := IF( TOTT[ 12 ] # 0, ( DEM / TOTT[ 12 ] * 100 ), 0 )
@ CTLIN, 0  SAY Str( DEPTO, 4 ) + Str( SETOR, 4 ) + Str( SECAO, 4 )
@ CTLIN, 13 SAY NOME
@ CTLIN, 29 SAY ATI                                    PICT '###'
@ CTLIN, 34 SAY PERATI                                 PICT '##.##%'
@ CTLIN, 41 SAY SALARIO                                PICT '$###,###,###'
@ CTLIN, 54 SAY PERSAL                                 PICT '##.##%'
@ CTLIN, 61 SAY ADM                                    PICT '###'
@ CTLIN, 66 SAY PERADM                                 PICT '##.##%'
@ CTLIN, 73 SAY DEM                                    PICT '###'
@ CTLIN, 78 SAY PERDEM                                 PICT '##.##%'
COL := 85
FOR X := 1 TO 5
QTX := 'QT' + Str( X, 1 )
VLX := 'VL' + Str( X, 1 )
PER := IF( TOTT[ X + 5 ] # 0, ( &VLX / TOTT[ X + 5 ] * 100 ), 0 )

// ************       PERCENTUAL DAS HORAS
// ************       PER=IF(TOTT[X]#0  ,(&QTX/TOTT[X]*100)  ,0)
IF &QTX. # 0
@ CTLIN, COL SAY &QTX PICT "#,###.##"
ENDIF
IF &VLX. # 0
@ CTLIN, COL + 9 SAY &VLX PICT '$###,###,###'
ENDIF
IF PER # 0
@ CTLIN, COL + 22 SAY PER PICT '##.##%'
ENDIF
COL := COL + 29
NEXT X
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
CTLIN := CTLIN + 1
@ CTLIN, 0 SAY REPL( '=', 230 )
// **************************TOTAL SETOR
CTLIN := CTLIN + 1
@ CTLIN, 1  SAY 'TOTAL Setor:'
@ CTLIN, 29 SAY TOTS[ 13 ]       PICT '###'
@ CTLIN, 41 SAY TOTS[ 14 ]       PICT '$###,###,###'
@ CTLIN, 61 SAY TOTS[ 11 ]       PICT '###'
@ CTLIN, 73 SAY TOTS[ 12 ]       PICT '###'
COL := 85
FOR X := 1 TO 5
IF TOTS[ X ] # 0
@ CTLIN, COL SAY TOTS[ X ] PICT "#,###.##"
ENDIF
IF TOTS[ X + 5 ] # 0
@ CTLIN, COL + 9 SAY TOTS[ X + 5 ] PICT '$###,###,###'
ENDIF
COL := COL + 29
NEXT X
CTLIN := CTLIN + 1
AFill( TOTS, 0 )
ENDIF
ENDIF
IF DEPTO # DEP
DEP := DEPTO
IF CC # 1
CTLIN := CTLIN + 1
@ CTLIN, 1 SAY REPL( '|', 230 )
// **************************TOTAL DEPTO
CTLIN := CTLIN + 1
@ CTLIN, 1  SAY 'TOTAL Depto:'
@ CTLIN, 29 SAY TOTD[ 13 ]       PICT '###'
@ CTLIN, 41 SAY TOTD[ 14 ]       PICT '$###,###,###'
@ CTLIN, 61 SAY TOTD[ 11 ]       PICT '###'
@ CTLIN, 73 SAY TOTD[ 12 ]       PICT '###'
COL := 85
FOR X := 1 TO 5
IF TOTD[ X ] # 0
@ CTLIN, COL SAY TOTD[ X ] PICT "#,###.##"
ENDIF
IF TOTS[ X + 5 ] # 0
@ CTLIN, COL + 9 SAY TOTD[ X + 5 ] PICT '$###,###,###'
ENDIF
COL := COL + 29
NEXT X
CTLIN := CTLIN + 1
AFill( TOTD, 0 )
ENDIF
ENDIF
ENDDO
CTLIN := CTLIN + 1
@ CTLIN, 1 SAY REPL( '-', 230 )
CTLIN := CTLIN + 1
@ CTLIN, 1  SAY 'TOTAL Geral'
@ CTLIN, 29 SAY TOTT[ 13 ]      PICT '###'
@ CTLIN, 41 SAY TOTT[ 14 ]      PICT '$###,###,###'
@ CTLIN, 61 SAY TOTT[ 11 ]      PICT '###'
@ CTLIN, 73 SAY TOTT[ 12 ]      PICT '###'
COL := 85
FOR X := 1 TO 5
IF TOTT[ X ] # 0
@ CTLIN, COL SAY TOTT[ X ] PICT "#,###.##"
ENDIF
IF TOTT[ X + 5 ] # 0
@ CTLIN, COL + 9 SAY TOTT[ X + 5 ] PICT '$###,###,###'
ENDIF
COL := COL + 29
NEXT X
CTLIN := CTLIN + 1
@ CTLIN + 1, 0 SAY REPL( '-', 230 )
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()
RETU
// : FIM: FOIC1A.PRG

// + EOF: foic1a.prg
// +
