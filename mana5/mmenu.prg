// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mmenu.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


SetColor( "N/N" )
CLS

WHILE .T.
SetColor( ZCOR001 )
@  0, 0 SAY PadR( " Manager Mana5 Versao 5.53b", 80 )
MDI( " ю Menu Principal do Sistema" )
SetColor( 'N/N' )
@ 24, 00 SAY Replicate( " ", 80 )
// MDS("Voc€ est  no Menu Principal")
Set( _SET_MESSAGE, 3, .T. )
SetColor( ZCOR006 )
// @  8,0 SAY " ЫЫЫ  ЫЫЫЫЫЫЫЫЫ   ЫЫЫ     ЫЫЫЫЫЫЫ   ЫЫЫЫЫЫЫ   ЫЫЫЫЫЫЫЬ    ЫЫЫЫЫЫЫЫ       ЫЫЫ   "
// @  9,0 SAY "°ЫЫЫ °°°°ЫЫЫ°°  °ЫЫЫЫЫ   °ЫЫЫ°°°  °ЫЫЫ°°°°ЫЫ °ЫЫЫ°°°ЫЫЬ  °ЫЫЫ°°°ЫЫЫ    °ЫЫЫЫЫ  "
// @ 10,0 SAY "°ЫЫЫ    °ЫЫЫ   °ЫЫЫ°ЫЫЫ  °ЫЫЫ     °ЫЫЫ   °°  °ЫЫЫ  °ЫЫЯ  °ЫЫЫ  °°ЫЫЫ  °ЫЫЫ°ЫЫЫ "
// @ 11,0 SAY "°ЫЫЫ    °ЫЫЫ  °ЫЫЫ °°ЫЫЫ °ЫЫЫЫЫЫ  °°ЫЫЫЫЫЫЫ  °ЫЫЫЫЫЫЫЬ   °ЫЫЫ   ЫЫЫ  °ЫЫЫ °°ЫЫЫ"
// @ 12,0 SAY "°ЫЫЫ    °ЫЫЫ  °ЫЫЫ  °ЫЫЫ °ЫЫЫ°°    °°°°°°ЫЫЫ °ЫЫЫ°°°ЫЫЫ  °ЫЫЫЫЫЫЫЫ   °ЫЫЫ  °ЫЫЫ"
// @ 13,0 SAY "°ЫЫЫ    °ЫЫЫ  °ЫЫЫЫЫЫЫЫЫ °ЫЫЫ           °ЫЫЫ °ЫЫЫ  °°ЫЫЫ °ЫЫЫ°°°ЫЫЫ  °ЫЫЫЫЫЫЫЫЫ"
// @ 14,0 SAY "°ЫЫЫ    °ЫЫЫ  °ЫЫЫ°°°ЫЫЫ °ЫЫЫ      ЫЫ   °ЫЫЫ °ЫЫЫ   ЫЫЫ  °ЫЫЫ  °°ЫЫЫ °ЫЫЫ°°°ЫЫЫ"
// @ 15,0 SAY "°ЫЫЫ    °ЫЫЫ  °ЫЫЫ  °ЫЫЫ °ЫЫЫЫЫЫЫ °°ЫЫЫЫЫЫЫ  °ЫЫЫЫЫЫЫЫ   °ЫЫЫ   °ЫЫЫ °ЫЫЫ  °ЫЫЫ"
// @ 16,0 SAY "°°°     °°°   °°°   °°°  °°°°°°°   °°°°°°°   °°°°°°°°    °°°    °°°  °°°   °°° "
SetColor( "W+/N" )
@ 19, 18 SAY "      SISTEMA DE GESTAO MRP      "
SetColor( SubStr( ZCOR007, At( ",", ZCOR007 ) + 1 ) )
@ 22, 00 SAY "              Ajuda        Telememo        Anotacoes        Agenda        Teclas "
@ 23, 00 SAY "                                                                          Data   "
SetColor( SubStr( ZCOR007, RAt( ",", ZCOR007 ) + 1 ) )
@ 22, 0 SAY "Teclas de"
@ 23, 0 SAY " Funcoes "
SetColor( ZCOR007 )
@ 22, 11 SAY "F1" // help
@ 22, 24 SAY "F2" // tele
@ 22, 40 SAY "F3" // notep
@ 22, 57 SAY "F4" // aggen
@ 22, 70 SAY "F5" // teclas
// @ 23,11 SAY "F6"
// @ 23,24 SAY "F7"
// @ 23,40 SAY "F8"    //
// @ 23,57 SAY "F9"
@ 23, 70 SAY "F10" //
SetColor( ZCOR005 )
OPCAO( 2, 0, " &Cadastros  ", 67, "Entra no Sub-Menu de Cadastros" )
OPCAO( 2, 13, " &Relatўrios ", 82, "Entra no Sub-Menu de Relatorios" )
OPCAO( 2, 26, " &Parѓmetros ", 80, "Entra no Sub-Menu de Parametros" )
OPCAO( 2, 39, " &Servi‡os   ", 83, "Entra no Sub-Menu de Servicos" )
OPCAO( 2, 52, " &Manual     ", 77, "Apresenta o Manual" )
OPCAO( 2, 65, " &Encerrar   ", 69, "Encerra o Programa" )
KEY := MENU()
DO CASE
CASE KEY = 1
MANA()
CASE KEY = 2
MANB()
CASE KEY = 3
MANC()
CASE KEY = 4
MAND()
CASE KEY = 5
MANE()
CASE KEY = 6
CLS
SetCursor( 1 )
RETURN NIL
OTHERWISE
IF mdg( "Encerrar Programa" )
APAGAREG( "MUSERN", AllTrim( ZUSER ), .F. )
SetCursor( 1 )
CLS
QUIT
ENDIF
ENDCASE
ENDDO

   RETURN NIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ACESSO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ACESSO

   RETURN .T.

// + EOF: mmenu.prg
// +
