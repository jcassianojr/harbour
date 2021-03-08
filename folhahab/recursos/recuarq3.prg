*:*****************************************************************************
*:
*:   RECUARQ3.PRG: Gerencia diret¢rios
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:23
*:
*:  Procs & Fncts: RECUARQ3()
*:
*:          Chama: RECUDIR()          (fun‡„o    em RECUDIR.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"
DIR=SPAC(30)
HB_dispbox( 8,48, 24, 79,B_DOUBLE+" ")
OPCAO( 12, 55," &Mudar  Diretorio",77)
OPCAO( 16, 55," &Criar  Diretorio",67)
OPCAO( 20, 55," &Apagar Diretorio",65)
KEY:=MENU(,0)
DO CASE
CASE KEY=1 ; RECUDIR()
CASE KEY=2.OR.KEY=3
   @ 9+KEY*4,49 GET DIR
   READCUR()
   DIR=ALLTRIM(DIR)
OTHERWISE ; RETU
ENDCASE
IF ! EMPTY(DIR)
   IF KEY=2
      DIRMAKE(DIR)
   ELSE
      DIRREMOVE(DIR)
   ENDIF
ENDIF
RETU
*: FIM: RECUARQ3.PRG
