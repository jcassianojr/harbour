*:*****************************************************************************
*:
*:   RECUAPO1.PRG: Gerenciador de arquivo recuapo1
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:14
*:
*:  Procs & Fncts: RECUAPO1()
*:
*:          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : RECUARQ1()         (fun‡„o    em RECUARQ1.PRG)
*:               : RECUARQ3()         (fun‡„o    em RECUARQ3.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"

CABE2("Gerenciador de Arquivos")
FILTRO='C:ARQUIVO.EXT'
TRABALHO='ARQUIVO.EXT'
BEMOTE=""
DO WHILE .T.
   HB_dispbox( 8, 0, 24, 79,B_DOUBLE+" ")
   @ 12,48 SAY 'Ç'+REPL('-',30)+'¶'
   @ 16,48 SAY 'Ç'+REPL('-',30)+'¶'
   @ 20,48 SAY 'Ç'+REPL('-',30)+'¶'
   @ 21,51 SAY "Drive   :"
   @ 22,51 SAY "Espa‡o  :"
   @ 23,51 SAY "Memoria :"
   @ 14,53 SAY FILTRO
   @ 18,53 SAY HB_CWD()
   @ 21,61 SAY DISKNAME()+':'
   @ 22,61 SAY STR(DISKSPACE(3))+' bytes '
   @ 23,61 SAY STR(MEMORY(0))+' Kbytes '
   OPCAO(09,51," &Arquivos",65)
   OPCAO(13,51," &Filtro",70)
   OPCAO(17,51," &Diretorio",68)
   OP:=MENU(,0)
   DO CASE
   CASE OP=1 ; RECUARQ1(1)
   CASE OP=2
      @ 14,53 GET FILTRO
      READCUR()
   CASE OP=3 ; RECUARQ3()
   OTHERWISE ; RETU
   ENDCASE
ENDDO
*: FIM: RECUAPO1.PRG
