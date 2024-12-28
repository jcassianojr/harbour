// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_d3.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_D3.PRG: Alterar m‚dia de variaveis para 13o. Sal rio
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************
#include "BOX.CH"

CABE2( 'Alterar m‚dia de variaveis para 13o. Sal rio' )
PARA CC
IF CC = 0
IF !NETUSE( "FO_VAR" )   // AREDE("FO_VAR","FO_VAR",0)
RETU
ENDIF
ENDIF
IF CC = 1
IF !NETUSE( "FO_VBR" )   // AREDE("FO_VBR","FO_VBR",0)
RETU
ENDIF
ENDIF
FILTRO := FILTRO( "" )
SET FILTER TO &FILTRO
dbGoTop()
DECLARE CAMPOS[ 1 ]
CAMPOS[ 1 ] = '" "+STR(NUMERO,5)+" "+STR(CONTA)+" "+STR(HORAS,6,2)+" "+STR(VALOR,14,2)+" "'
// CLEAR TYPEAHEAD
hb_keyClear()
KEYBOARD " "
hb_DispBox( 8, 0, 24, 79, B_DOUBLE )
@ 09, 02 SAY "Num. Conta Horas Valor"
@ 10, 00 SAY 'Æ' + REPL( '-', 78 ) + 'µ'
dbEdit( 11, 1, 23, 36, CAMPOS, "VAREDIT", .T., "", "", "", "", "" )
dbCloseAll()
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: VAREDIT()
// !
// !    Chamado por: FOLIS_D3.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VAREDIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC VAREDIT

   KEY := LastKey()
   DO CASE
   CASE KEY = 27
      RETU ( 0 )
   CASE KEY = 13
      SetCursor( 1 )
      NETRECLOCK()
      @ Row(), 14 GET HORAS PICT '###.##'
      @ Row(), 21 GET VALOR PICT '###,###,###.##'
      READCUR()
      dbUnlock()
      SetCursor( 0 )
   ENDCASE
   RETU ( 1 )
// : FIM: FOLIS_D3.PRG

// + EOF: folis_d3.prg
// +
