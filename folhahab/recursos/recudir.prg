*:*****************************************************************************
*:
*:    RECUDIR.PRG: Le Arvore de Diret¢rio
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:24
*:
*:  Procs & Fncts: RECUDIR()
*:               : GETDIRS()
*:
*:          Chama: GETDIRS()          (fun‡„o    em RECUDIR.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************


#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

@ 08,00 CLEA
MDS('Aguarde lendo arvore de diret¢rio')
DIR:={}
AADD(DIR,"\")
COUNTER:=0
WHILE ++COUNTER<=LEN(DIR)
   LOOK:=GETDIRS(DIR[COUNTER])
   IF ! EMPTY(LEN(LOOK))
      AEVAL(LOOK,{|X| AADD(DIR,X)})
   ENDIF
ENDDO
ASORT(DIR)
HB_DIsPBOX(8,0,23,79,B_DOUBLE+" ")
POSX=ASCAN(DIR,HB_CWD())
POSX=IF(POSX=0,1,POSX)
@ 24,00 SAY PADC(HB_CWD(),80)
CHOICE=ACHOICE(9,1,22,60,DIR,,,POSX)
IF CHOICE#0
   mudar=ALLTRIM(DIR[choice])
   mudar=SUBSTR(mudar,1,LEN(mudar)-1)
   HB_CWD(mudar)
   //DIRCHANGE(mudar)
ENDIF
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: GETDIRS()
*!
*!    Chamado por: RECUDIR.PRG
*!
*!*****************************************************************************
FUNC GETDIRS(pattern)
LOCAL ARRAY:={}
AEVAL(DIRECTORY(PATTERN+"*.","D"),{|X| IF(X[5]="D".AND. !("."$X[1]),AADD(ARRAY,PATTERN+X[1]+"\"),"")})
RETU(ARRAY)

*: FIM: RECUDIR.PRG
