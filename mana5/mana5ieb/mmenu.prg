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
// +    Documentado em 28-Dez-2024 as 10:48 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      MMENU.PRG: Menu Principal do Manager
// :      Linguagem: harbour
// :        Sistema: MANA5 - empresa
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :  Atualizado em: 05/05/94     10:41
// :
// :*****************************************************************************
SetColor( "N/N" )
CLS

// ACESSO()


WHILE .T.
SetColor( ZCOR001 )
@  0, 0 SAY PadR( " ў Disk Softwares Manager Versao 5.53b", 80 )
IF At( "ITAESBR2", Upper( CurDir() ) ) > 0
@  0, 50 SAY "Firma II Filial"
ENDIF
MDI( " ў Menu Principal do Sistema" )
SetColor( 'N/N' )
@ 24, 00 SAY Replicate( " ", 80 )
Set( _SET_MESSAGE, 3, .T. )
SetColor( ZCOR006 )
@  8, 0 SAY " ллл  ллллллллл   ллл     ллллллл   ллллллл   лллллллм    лллллллл       ллл   "
@  9, 0 SAY "Аллл ААААлллАА  Аллллл   АлллААА  АлллААААлл АлллАААллм  АлллАААллл    Аллллл  "
@ 10, 0 SAY "Аллл    Аллл   АлллАллл  Аллл     Аллл   АА  Аллл  Аллп  Аллл  ААллл  АлллАллл "
@ 11, 0 SAY "Аллл    Аллл  Аллл ААллл Алллллл  ААллллллл  Алллллллм   Аллл   ллл  Аллл ААллл"
@ 12, 0 SAY "Аллл    Аллл  Аллл  Аллл АлллАА    ААААААллл АлллАААллл  Алллллллл   Аллл  Аллл"
@ 13, 0 SAY "Аллл    Аллл  Аллллллллл Аллл           Аллл Аллл  ААллл АлллАААллл  Аллллллллл"
@ 14, 0 SAY "Аллл    Аллл  АлллАААллл Аллл      лл   Аллл Аллл   ллл  Аллл  ААллл АлллАААллл"
@ 15, 0 SAY "Аллл    Аллл  Аллл  Аллл Аллллллл ААллллллл  Алллллллл   Аллл   Аллл Аллл  Аллл"
@ 16, 0 SAY "ААА     ААА   ААА   ААА  ААААААА   ААААААА   АААААААА    ААА    ААА  ААА   ААА "
SetColor( "W+/N" )
@ 19, 18 SAY "      GERENCIADOR  DE  BANCO  DE  DADOS"
SetColor( SubStr( ZCOR007, At( ",", ZCOR007 ) + 1 ) )
@ 22, 00 SAY "              Ajuda        Telememo        Anotaaoes        Agenda        Teclas "
@ 23, 00 SAY "              Memeria      Calendario      Calculadora      Relegio       Data   "
SetColor( SubStr( ZCOR007, RAt( ",", ZCOR007 ) + 1 ) )
@ 22, 0 SAY "Teclas de"
@ 23, 0 SAY " Funaoes "
SetColor( ZCOR007 )
@ 22, 11 SAY "F1"
@ 22, 24 SAY "F2"
@ 22, 40 SAY "F3"
@ 22, 57 SAY "F4"
@ 22, 70 SAY "F5"
@ 23, 11 SAY "F6"
@ 23, 24 SAY "F7"
@ 23, 40 SAY "F8"
@ 23, 57 SAY "F9"
@ 23, 70 SAY "F10"
SetColor( ZCOR005 )
OPCAO( 2, 0, " &Cadastros  ", 67, "Entra no Sub-Menu de Cadastros" )
OPCAO( 2, 13, " &Relaterios ", 82, "Entra no Sub-Menu de Relaterios" )
OPCAO( 2, 26, " &Parametros ", 80, "Entra no Sub-Menu de Parametros" )
OPCAO( 2, 39, " &Servicos   ", 83, "Entra no Sub-Menu de Servicos" )
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
RETU
OTHERWISE
IF mdg( "Encerrar Programa" )
APAGAREG( "MUSERN", AllTrim( ZUSER ), .F. )
SetCursor( 1 )
CLS
QUIT
ENDIF
ENDCASE
ENDDO



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
