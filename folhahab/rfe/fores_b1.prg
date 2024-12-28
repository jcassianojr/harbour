// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_b1.prg
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
// :  FORES_B1.PRG : PLANILHA DE FERIAS SIMPLES
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:01
// :
// :  Procs & Fncts: FORES_B1()
// :
// :          Chama: MDL()              (fun‡„o    em FORESP.PRG)
// :
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

IF !MDL( 'PLANILHA DE FERIAS SIMPLES', 0 )
RETU
ENDIF

IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD( .T. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ValType( INX ) = "N"
dbSetOrder( INX )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )
ENDIF
SET FILTER TO &FILTRO

CTLIN := 80
FL    := 0
IMPRESSORA()
dbGoTop()
WHILE !Eof()
IF CTLIN > 60
FL++
@  1, 1   SAY IF( IM1 = "A", IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
@  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
@  3, 120 SAY 'FL: ' + StrZero( FL, 4 )
@  4, 110 SAY 'DATA: ' + DToC( DXDIA )
@  5, 0   SAY REPL( '-', 132 )
@  6, 20  SAY IMPCHR( cIMPTIT ) + 'PLANILHA DE CONTROLE DE FERIAS'
@  7, 0   SAY REPL( '-', 132 )
@  8, 0   SAY '|'
@  8, 1   SAY 'NRo.'
@  8, 6   SAY '|'
@  8, 7   SAY 'NOME'
@  8, 37  SAY '|'
@  8, 38  SAY 'ADMITIDO'
FOR X := 1 TO 12
@  8, X * 4 + 42 SAY '|' + SubStr( MMES( X ), 1, 3 )
NEXT X
@  8, 103 SAY 'OBSERVACOES DIVERSAS'
@  8, 131 SAY '|'
@  9, 0   SAY REPL( '-', 132 )
CTLIN := 10
ENDIF
@ CTLIN, 0  SAY '|'
@ CTLIN, 1  SAY NUMERO
@ CTLIN, 6  SAY '|'
@ CTLIN, 7  SAY NOME
@ CTLIN, 37 SAY '|'
@ CTLIN, 38 SAY ADMITIDO
FOR X := 1 TO 13
@ CTLIN, X * 4 + 42 SAY '|'
NEXT X
@ CTLIN, 131 SAY '|'
CTLIN++
@ CTLIN, 0 SAY REPL( '-', 132 )
CTLIN++
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()

   RETURN

// : FIM: FORES_B1.PRG

// + EOF: fores_b1.prg
// +
