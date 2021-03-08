*:*****************************************************************************
*:
*:   FOLIS_D3.PRG: Alterar m‚dia de variaveis para 13o. Sal rio
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************
#INCLUDE "BOX.CH"

CABE2('Alterar m‚dia de variaveis para 13o. Sal rio')
PARA CC
IF CC=0
   IF ! NETUSE("FO_VAR") //AREDE("FO_VAR","FO_VAR",0)
      RETU
   ENDIF
ENDIF
IF CC=1
   IF ! NETUSE("FO_VBR") //AREDE("FO_VBR","FO_VBR",0)
      RETU
   ENDIF
ENDIF
FILTRO=FILTRO("")
SET FILTER TO &FILTRO
DBGOTOP()
DECLARE CAMPOS[1]
CAMPOS[1]='" "+STR(NUMERO,5)+" "+STR(CONTA)+" "+STR(HORAS,6,2)+" "+STR(VALOR,14,2)+" "'
//CLEAR TYPEAHEAD
hb_keyClear()
KEYBOARD " "
HB_dispbox( 8, 0, 24, 79,B_DOUBLE)
@ 09,02 SAY "Num. Conta Horas Valor"
@ 10,00 SAY 'Æ'+REPL('-',78)+'µ'
DBEDIT(11,1,23,36,CAMPOS,"VAREDIT",.T.,"","","","","")
DBCLOSEALL()
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: VAREDIT()
*!
*!    Chamado por: FOLIS_D3.PRG
*!
*!*****************************************************************************
FUNC VAREDIT
KEY=LASTKEY()
DO CASE
CASE KEY = 27
   RETU(0)
CASE KEY = 13
   SETCURSOR(1)
   NETRECLOCK()
   @ ROW(),14 GET HORAS PICT '###.##'
   @ ROW(),21 GET VALOR PICT '###,###,###.##'
   READCUR()
   DBUNLOCK()
   SETCURSOR(0)
ENDCASE
RETU(1)
*: FIM: FOLIS_D3.PRG
