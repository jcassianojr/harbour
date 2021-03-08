*:*****************************************************************************
*:
*:       FOA4.PRG: Alterar Lan‡amentos para Folha de Pagamento
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:28
*:
*:  Procs & Fncts: FOA4()
*:               : VAREDIT()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : VAREDIT()          (fun‡„o    em FOA4.PRG, chamado  no Dbedit())
*:               : FODZER             (processo  em FOLPROC.PRG)
*:
*:
*:    Arq. Dados : FO_PFE - Folha de F‚rias
*:                 FO_RSS - Folha de Rescis„o
*:                 FO_COMP - Folha Complementar
*:
*:       Indices : RSS        Codigo de Trabalho
*:                            CONTROLE
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"

CABEX('Alterar Lan‡amentos para Folha de Pagamento')
PARA CC
IF ! netuse("CONTAS") //AREDE("CONTAS","CONTAS",0)
   RETU .F.
ENDIF

IF ! ARQUSAR(CC)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2:=ALIAS()

DBGOTOP()
DECLARE CAMPOS[1]
IF CC#2.AND.CC#3.AND.CC#5
   CAMPOS[1]='PADR(" "+STR(NUMERO,5)+" "+STR(CONTA)+" "+STR(HORAS,6,2)+" "+STR(VALOR,14,2)+" ",76)'
ELSE
   CAMPOS[1]='PADR(" "+STR(NUMERO,5)+" "+STR(CONTA)+" "+STR(HORAS,6,2)+" "+STR(VALOR,14,2)+" "+STR(MES1,2)+" "+STR(VALORMES1,18,2)+" "+STR(MES2,2)+" "+STR(VALORMES2,18,2)+" ",77)'
ENDIF
HB_dispbox( 3, 0, 24, 79,B_DOUBLE+" ")
IF CC#2.AND.CC#3.AND.CC#5
   @ 04,04 SAY "Num. Conta Horas Valor"
ELSE
   @ 04,04 SAY "Num. Conta Horas Valor Mes1 ValorMes1 Mes2 ValorMes2"
ENDIF
@ 5,00 SAY 'Æ'+REPL('-',78)+'µ'
NOBREAK()
DBEDIT(6,1,23,78,CAMPOS,"VAREDIT",.T.,"","","","","")
FODZER()
DBCLOSEALL()
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: VAREDIT()
*!
*!    Chamado por: FOA4.PRG
*!
*!*****************************************************************************
FUNC VAREDIT
KEY=LASTKEY()
DO CASE
CASE KEY = 27
   RETU(0)
CASE KEY = 13
   mCONTA:=CONTA
   DBSELECTAR("CONTAS")
   DBGOTOP()
   if DBSEEK(mCONTA)
      IF ACEITE="S".AND.ZUSER#"SUPERVISOR"
         ALERTX("Conta: "+STR(mCONTA)+" Acesso Limitado ao Supervisor")
         DBSELECTAR(cSELE2)
         RETU 1
      ENDIF
   ELSE
      ALERTX("Conta: "+STR(mCONTA)+" Acesso Limitado ao Supervisor")
      DBSELECTAR(cSELE2)
      RETU 1
   ENDIF
   DBSELECTAR(cSELE2)
   netreclock()
   @ ROW(),13 GET HORAS PICT '###.##'
   @ ROW(),20 GET VALOR PICT '###,###,###.##'
   IF CC=2.OR.CC=3.OR.CC=5
      @ ROW(),COL()+1 GET MES1
      @ ROW(),COL()+1 GET VALORMES1
      @ ROW(),COL()+1 GET MES2
      @ ROW(),COL()+1 GET VALORMES2
   ENDIF
   READCUR()
   dbunlock()
ENDCASE
RETU(1)
*: FIM: FOA4.PRG
