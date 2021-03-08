*:*****************************************************************************
*:
*:       FOAA.PRG: Cadastro Sequencia de Lancamento pre-progamados
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:31
*:
*:  Procs & Fncts: FOAA()
*:               : CADSEQ()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : NSHOW1()           (fun‡„o    em FOLPROC.PRG)
*:               : CADSEQ()           (fun‡„o    em FOAA.PRG, chamado  no Dbedit())
*:
*:    Arq. Dados : FO_LAN - Pr‚ Lan‡amento de Dados
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"

IF ZUSER<>"SUPERVISOR"  
   ALERTX("Acesso Permitido Somente Para o Supervisor")
   RETU
ENDIF


CABEX('Cadastro Sequencia de Lancamento pre-progamados')
PCK=.F.
IF ! NETUSE("FO_LAN") //BREDE("FO_LAN",0)
   RETU
ENDIF
DBGOTOP()
DECLARE CAMPOS[1]
CAMPOS[1]="' '+STR(CONTA,3)+' '+STR(VALOR,10,2)+' '+SUBSTR(GRUPO,1,60)"
IF ! NSHOW1()
   RETU
ENDIF
SET COLOR TO
@ 08,00 CLEAR
HB_DISPBOX(8,0,23,79,B_DOUBLE+" ")
@  9, 2 SAY "Cta    Valor"+SPAC(6)+"Grupo"
@ 10, 0 SAY '+'+REPL('-',78)+'Ý'
hb_keyClear()
//CLEAR TYPEAHEAD
KEYBOARD " "
DBEDIT(11,1,22,78,CAMPOS,"CADSEQ",.T.,"","","","","")
DBCLOSEALL()
NETPACK("FO_LAN",PCK)
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: CADSEQ()
*!
*!    Chamado por: FOAA.PRG
*!
*!*****************************************************************************
FUNC CADSEQ
PARAMETERS MODO
KEY=LASTKEY()
DO CASE
CASE KEY = 27
   RETU(0)
CASE KEY = 13
   NETRECLOCK()
   @ ROW(),03 GET CONTA
   @ ROW(),07 GET VALOR
   @ ROW(),18 GET GRUPO PICT "@S60"
   READCUR()
   DBUNLOCK()
   RETU(1)
CASE KEY = 22.OR.MODO=3
   MD()
   NETRECAPP()
   @ 24,03 GET CONTA
   @ 24,07 GET VALOR
   @ 24,18 GET GRUPO PICT "@S60"
   READCUR()
   DBUNLOCK()
   MD()
   RETU(2)
CASE KEY = 7
   DELEREC()
   RETU(2)
OTHERWISE
   RETU(1)
ENDCASE
RETU(1)

*: FIM: FOAA.PRG
