// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : manb.prg
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

#include "BOX.CH"

// :*****************************************************************************
// :
// :       MANB .PRG:
// :      Linguagem: harbour
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/27/94     11:54
// :
// :  Procs & Fncts: MANB()
// :
// :     Documentado 05/13/94 em 14:48                DISK!  vers„o 5.01
// :*****************************************************************************
STATIC KEY := 1
CRIARVARS( "MANREG" )
CRIARVARS( "MANREL" )
CRIARVARS( "MANRE1" )
aMENU := Array( 33 )
aMESS := Array( 33 )
AFill( aMENU, Space( 25 ) )
AFill( aMESS, Space( 75 ) )
WHILE .T.
@  2, 0 CLEAR
hb_DispBox( 4, 2, 12, 60, B_DOUBLE )
K := 1
OPCAO( 6, 4, " &A - Padr„o             ", 65 )
OPCAO( 8, 4, " &B - Gerador            ", 66 )
OPCAO( 10, 4, " &C - Gerador Padr„o     ", 67 )
K := MENU(, 0 )
IF K = 0
RETU
ENDIF
EXIT
ENDDO
IF K > 0
aCHR := IMPHP()
ENDIF
IF K = 2
ARQREL := "MANREL"
ARQRE1 := "MANRE1"
ENDIF
IF K = 3
ARQREL := "PADREL"
ARQRE1 := "PADRE1"
K      := 2
ENDIF

IF USEREDE( "MANOPT", 1, 1 )
dbGoTop()
dbSeek( "B" )
WHILE ITEMENU = "B" .AND. !Eof()
IF POSICAO > 0 .AND. POSICAO < 34
aMENU[ POSICAO ] := PadR( DESCP, 25 )
aMESS[ POSICAO ] := DESCM
ENDIF
dbSkip()
ENDDO
dbCloseArea()
ENDIF

WHILE .T.
MDI( " Ý Vocˆ est  escolhendo o Cadastro para Listagem" )
Set( _SET_MESSAGE, 2, .T. )
SetColor( ZCOR008 )
FOR X := 1 TO 11
OPCAO( X * 2 + 2, 1, " &" + LTrim( aMENU[ X ] ), Asc( Left( AllTrim( aMENU[ X ] ), 1 ) ), aMESS[ X ] )
NEXT X
FOR X := 12 TO 22
OPCAO( ( X - 11 ) * 2 + 2, 27, " &" + LTrim( aMENU[ X ] ), Asc( Left( AllTrim( aMENU[ X ] ), 1 ) ), aMESS[ X ] )
NEXT X
FOR X := 23 TO 33
OPCAO( ( X - 22 ) * 2 + 2, 53, " &" + LTrim( aMENU[ X ] ), Asc( Left( AllTrim( aMENU[ X ] ), 1 ) ), aMESS[ X ] )
NEXT X
KEY := MENU( 1, 2 )
IF KEY > 0
IF !ENTMNU( "B", KEY )
LOOP
ENDIF
mGRUPO := OBTER( "MANREG", KEY, "GRUPO" )
IF !Empty( mGRUPO ) .AND. K = 2
MANB1( 3 )
LOOP
ENDIF
ENDIF
DO CASE
CASE KEY = 1
CASE KEY = 2
CASE KEY = 3
CASE KEY = 4
CASE KEY = 5
AUTOMENU( " Ý Equipamentos", "MBE", 24, "MANSUB" )
CASE KEY = 6
CASE KEY = 7
CASE KEY = 8
CASE KEY = 9
AUTOMENU( " Ý Plano de Contas", "MBI", 24, "MANSUB" )
CASE KEY = 10
CASE KEY = 11
AUTOMENU( " Ý Nota Fiscal de Compras", "MBK", 24, "MANSUB" )
CASE KEY = 12
AUTOMENU( " Ý Contas Pagar/Pagas", "MBL", 24, "MANSUB" )
CASE KEY = 13
AUTOMENU( " Ý Nota Fiscal de Vendas", "MBM", 24, "MANSUB" )
CASE KEY = 14
AUTOMENU( " Ý Contas Receber/Recebidas Pagas", "MBN", 24, "MANSUB" )
CASE KEY = 15
AUTOMENU( " Ý Pedidos", "MBO", 24, "MANSUB" )
CASE KEY = 16
CASE KEY = 17
CASE KEY = 18
CASE KEY = 19
AUTOMENU( " Ý Produtos", "MBS", 24, "MANSUB" )
CASE KEY = 20
CASE KEY = 21
CASE KEY = 22
CASE KEY = 23
CASE KEY = 24
CASE KEY = 25
AUTOMENU( " Ý Requisicoes", "MBY", 24, "MANSUB" )
CASE KEY = 26
CASE KEY = 27
CASE KEY = 28
CASE KEY = 29
CASE KEY = 30
CASE KEY = 31
CASE KEY = 32
AUTOMENU( " Ý Informe", "MB6", 24, "MANSUB" )
CASE KEY = 33
AUTOMENU( " Ý Faturamento", "MB7", 24, "MANSUB" )
OTHERWISE
EXIT
ENDCASE
ENDDO
// : FIM: MANB.PRG


// + EOF: manb.prg
// +
