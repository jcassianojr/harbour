// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_a4.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :  FORES_A4.PRG : Exibir Remanejamento de F‚rias
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      8:58
// :
// :  Procs & Fncts: FORES_A4()
// :
// :          Chama: CABE2()            (fun‡„o    em FORESP.PRG)
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************


#include "BOX.CH"
CABE2( 'Exibir Remanejamento de F‚rias' )
hb_DispBox( 8, 0, 24, 79, B_DOUBLE )
@ 08, 08 SAY "-" + REPL( '-', 32 ) + "-" + REPL( '-', 21 ) + "-" + REPL( '-', 4 ) + "-" + REPL( '-', 6 ) + "-"
@ 09, 02 SAY "Num.  Ý Nome:" + SPAC( 26 ) + "Ý Periodo  Aquisitivo Ý JuzÝ SaldoÝ Ok"
@ 10, 00 SAY 'Ý' + REPL( '-', 7 ) + "+" + REPL( '-', 32 ) + "+" + REPL( '-', 21 ) + "+" + REPL( '-', 4 ) + "+" + REPL( '-', 6 ) + "+" + REPL( '-', 3 ) + 'Ý'
FOR X := 11 TO 23
@ X, 00 SAY "Ý       Ý" + SPAC( 32 ) + "Ý          …          Ý    Ý      Ý   Ý"
NEXT
@ 24, 08 SAY "-" + REPL( '-', 32 ) + "-" + REPL( '-', 21 ) + "-" + REPL( '-', 4 ) + "-" + REPL( '-', 6 ) + "-"
CTLIN := 11
IF !NETUSE( "FO_FER" )  // AREDE("FO_FER","FO_FER",0)
RETU
ENDIF
FI     := ''
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
IF CTLIN > 23
Inkey( 0 )
IF LastKey() = 27
dbCloseAll()
RETU
ENDIF
@  8, 0 CLEAR TO 23, 79
CTLIN := 9
FOR X := 11 TO 23
@ X, 00 SAY "Ý       Ý" + SPAC( 32 ) + "Ý          …          Ý    Ý      Ý   Ý"
NEXT
ENDIF
@ CTLIN, 02 SAY NUMERO
@ CTLIN, 10 SAY NOME
@ CTLIN, 43 SAY DATFERIAS
@ CTLIN, 54 SAY DATFERIASF
@ CTLIN, 65 SAY DIASJUS
@ CTLIN, 71 SAY DIASGOZA3
@ CTLIN, 77 SAY BAIXADO
CTLIN++
dbSkip()
ENDDO
Inkey( 0 )
dbCloseAll()
RETU
// : FIM: FORES_A4.PRG

// + EOF: fores_a4.prg
// +
