// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7d.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :       FO7D.PRG: Cadastro Simples Funcionarios
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 22/10/97     11:25
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

IF !MDL( 'CADASTRO SIMPLES FUNCIONARIOS', 0 )
RETU .F.
ENDIF

POS1 := SPAC( 40 )
MDS( 'Digite Cabe‡ario Complementar' )
@ 24, 35 GET POS1
READCUR()

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

IF !NETUSE( "FUNCAO" )
RETU
ENDIF

CTLIN := 80
QTFUN := FL := SALTOT := 0

IMPRESSORA()
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
IF CTLIN > 55
FL++
@  1, 0   SAY IF( IM1 = 'A', IMPstr( Cimpcom ), impstr( Cimpexp ) )
@  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
@  3, 18  SAY IMPCHR( cIMPTIT ) + 'CADASTRO SIMPLES DE FUNCIONARIOS'
@  5, 0   SAY POS1
@  5, 100 SAY Time()
@  5, 110 SAY Date()
@  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
@  6, 0   SAY REPL( '-', 132 )
@  7, 1   SAY 'DEPTO'
@  7, 7   SAY 'SETOR'
@  7, 13  SAY 'SECAO'
@  7, 19  SAY 'CHAPA'
@  7, 25  SAY 'REGISTRO'
@  7, 34  SAY 'NOME'
@  7, 64  SAY 'ADMITIDO'
@  7, 73  SAY 'TIPO'
@  7, 80  SAY 'FUNCAO'
@  7, 107 SAY 'SALARIO'
@  7, 127 SAY 'AO MES '
@  8, 0   SAY REPL( '-', 132 )
CTLIN := 9
ENDIF
dbSelectAr( PES )
@ CTLIN, 2  SAY DEPTO
@ CTLIN, 8  SAY SETOR
@ CTLIN, 14 SAY SECAO
@ CTLIN, 20 SAY CHAPA
@ CTLIN, 26 SAY NUMERO
@ CTLIN, 33 SAY NOME
@ CTLIN, 64 SAY ADMITIDO
@ CTLIN, 74 SAY TIPO
@ CTLIN, 76 SAY FUNCAO
@ CTLIN, 80 SAY '-' + OBTER( "FUNCAO",, FUNCAO, "FNOME" )
dbSelectAr( PES )
VAR1 := SALM := SALH := 0
SALHM()
@ CTLIN, 101 SAY VAR1 PICT '###,###,###.##'
@ CTLIN, 119 SAY SALM PICT '###,###,###.##'
SALTOT += SALM
QTFUN++
CTLIN++
dbSkip()
ENDDO
@ PRow() + 1, 0  SAY REPL( '-', 132 )
@ PRow() + 1, 20 SAY 'Quantidade de Funcionarios --> '
@ PRow(), 53    SAY QTFUN                             PICTURE '###'
@ PRow(), 117   SAY SALTOT                            PICT '#,###,###,###.##'
IMPFOL()
VIDEO()
dbCloseAll()
IMPEND()
dbCloseAll()
RETU .T.
// : FIM: FO7D.PRG

// + EOF: fo7d.prg
// +
