*:*****************************************************************************
*:
*:       FOGA.PRG: Cadastro de para Planilha de Entrada
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:02
*:
*:  Procs & Fncts: FOGA()
*:               : CADFOGA()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : NSHOW1()           (fun‡„o    em FOLPROC.PRG)
*:               : CADFOGA()          (fun‡„o    em FOGA.PRG, chamado  no Dbedit())
*:
*:     Arq. Dados: FO_PLENT
*:
*:         Indice:  FO_PLENT   NOME DA PLANILHA
*:                             NOME
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************

CABEX('Cadastro de para Planilha de Entrada')
IF ! netuse("FO_PLENT") //AREDE("FO_PLENT","FO_PLENT",0)
   RETU
ENDIF
PCK=.F.
DBGOTOP()
DECLARE CAMPOS[1]
CAMPOS[1]="' '+NOME+' '+STR(C01)+' '+STR(C02)+' '+STR(C03)+' '+STR(C04)+' '+STR(C05)+' '+STR(C06)+' '+STR(C07)+' '+STR(C08)+' '+STR(C09)+' '+STR(C10)+' '+STR(C11)+' '+STR(C12)+' '+STR(C13)+' '+STR(C14)+' '+STR(C15)+' '+STR(C16)+' '+STR(C17)+' '+STR(C18)"
IF ! NSHOW1()
   DBCLOSEALL()
   RETU
ENDIF
SET COLOR TO
@ 08,00 CLEAR
@ 08,00 SAY REPL('-',80)
@ 21,00 SAY REPL('-',80)
//CLEAR TYPEAHEAD
hb_keyClear()
KEYBOARD " "
DBEDIT(09,00,20,79,CAMPOS,"CADFOGA",.T.,"","","","","")
DBCLOSEALL()
netuse("FO_PLENT",pck)
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: CADFOGA()
*!
*!    Chamado por: FOGA.PRG
*!
*!*****************************************************************************
FUNC CADFOGA
PARAMETERS MODO
KEY=LASTKEY()
DO CASE
CASE KEY = 27
   RETU(0)
CASE KEY = 13
   netreclock()
   GFOGA(row())
   RETU(1)
CASE KEY = 22.OR.MODO=3
   MD()
   netrecapp()
   GFOGA(23)
   @ 22,00 CLEAR
   RETU(2)
CASE KEY = 10
   PESQ=SPAC(6)
   MDS('CODIGO')
   @ 24,30 GET PESQ
   READCUR()
   DBGOTOP()
   if ! dbSEEK(PESQ)
      MDT('Codigo localizada no Arquivo')
   ENDIF
   @ 22,00 CLEAR
   RETU(2)
CASE KEY = 7
   DELEREC()
   @ 22,00 CLEA
   RETU(2)
OTHERWISE
   RETU(1)
ENDCASE
RETU(1)

func GFOGA(nrow)
   @ nROW, 1 GET NOME
   @ nROW, 8 GET C01
   @ nROW,12 GET C02
   @ nROW,16 GET C03
   @ nROW,20 GET C04
   @ nROW,24 GET C05
   @ nROW,28 GET C06
   @ nROW,32 GET C07
   @ nROW,36 GET C08
   @ nROW,40 GET C09
   @ nROW,44 GET C10
   @ nROW,48 GET C11
   @ nROW,52 GET C12
   @ nROW,56 GET C13
   @ nROW,60 GET C14
   @ nROW,64 GET C15
   @ nROW,68 GET C16
   @ nROW,72 GET C17
   @ nROW,76 GET C18
   READCUR()
   dbunlock()

*: FIM: FOGA.PRG
