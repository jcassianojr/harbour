*:*****************************************************************************
*:
*:   RECUMENU.PRG: Menu Principal Recurso
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:31
*:
*:  Procs & Fncts: RECUMENU()
*:
*:          Chama: RECUGER()          (fun‡„o    em RECUGER.PRG)
*:               : RECUAPO()          (fun‡„o    em RECUAPO.PRG)
*:               : RECUSER()          (fun‡„o    em RECUSER.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"
PUBLIC DADO
DXDIA=DATE()
SET MESS TO 6 CENT
DO WHILE .T.
   SETCOLOR("+W/BR, N/W")
   @ 00,00 CLEA
   @ 00,00 SAY " <<RECURSOS>> v5.3b"
   SETCOLOR("W/N")
   HB_dispbox( 1, 0, 07, 79,B_DOUBLE+" ")   
   @ 03,00 SAY "Ç"
   @ 03,01 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 05,01 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 2,24  SAY 'MODULO DE UTILITARIOS'
   SETCOLOR("W/R")
   HB_dispbox( 8,21, 10, 58,B_DOUBLE+" ")   
   SETCOLOR("W/N")
   @ 13,01 CLEA TO 19,77
   @ 09,27 SAY "M E N U   P R I N C I P A L"
   HB_dispbox(12, 1, 20, 78,B_DOUBLE+" ")   
   @ 13,05 SAY "²²²²²²   ²²²²²²²    ²²²²²  ²²  ²²   ²²²²²²    ²²²²     ²²²²²    ²²²²"
   @ 14,05 SAY " ²²  ²²   ²²   ²   ²²  ²²  ²²  ²²    ²²  ²²  ²²  ²²   ²²   ²²  ²²  ²²"
   @ 15,05 SAY " ²²  ²²   ²²      ²²       ²²  ²²    ²²  ²²  ²²       ²²   ²²  ²²"
   @ 16,05 SAY " ²²²²²    ²²²²    ²²       ²²  ²²    ²²²²²    ²²²²    ²²   ²²   ²²²²"
   @ 17,05 SAY " ²²²²     ²²      ²²       ²²  ²²    ²²²²        ²²   ²²   ²²      ²²"
   @ 18,05 SAY " ²²  ²²   ²²   ²   ²²  ²²  ²²  ²²    ²²  ²²  ²²  ²²   ²²   ²²  ²²  ²²"
   @ 19,05 SAY "²²²  ²²  ²²²²²²²    ²²²²    ²²²²    ²²²  ²²   ²²²²     ²²²²²    ²²²² "
   SETCOLOR("+W/BR, N/W")
   OPCAO( 04,04 , "   &Geradores  "    ,71,"  Etiquetas, Cartas, Dbf editor, Formul rios                      ")
   OPCAO( 04,21 , "     &Apoio    "    ,65,"  Arquivos, Utilit rios, Telememo, Agenda, Bloco de Anota‡”es     ")
   OPCAO( 04,37 , " &Servicos gerais  ",83, "              Diversos - Apuracoes - Configuracoes                ")
   OPCAO( 04,58 , " &Encerrar "        ,69, "                Encerra as atividades no sistema                  ")
   OPCAO:=MENU(,6)
   SETCOLOR("+W/BR")
   DO CASE
   CASE OPCAO=1 ; RECUGER()
   CASE OPCAO=2 ; RECUAPO()
   CASE OPCAO=3 ; RECUSER()
   OTHERWISE
      IF MDG('Deseja Realmente Sair do Programa')
         FIM('')
      ENDIF
   ENDCASE
ENDDO
*: FIM: RECUMENU.PRG
