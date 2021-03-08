*:*****************************************************************************
*:
*:    FORESM.PRG : Folha - Ferias e Rescisao
*:    Linguagem  : Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/26/94      8:52
*:
*:  Procs & Fncts: FORESM()
*:
*:          Chama: FORES_A()          (fun‡„o    em FORES_A.PRG)
*:               : FORES_B()          (fun‡„o    em FORES_B.PRG)
*:               : FORES_C()          (fun‡„o    em FORES_C.PRG)
*:               : FORES_D()          (fun‡„o    em FORES_D.PRG)
*:               : FORES_E()          (fun‡„o    em FORES_E.PRG)
*:
*:     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"

SET MESS TO 6 CENT
WHILE .T.
   SETCOLOR("+W/BR,N/W")
   @ 00,00 CLEA
   @ 00,00 SAY " <<FOLHA - FERIAS E RESCISAO>> v5.3b"
   SETCOLOR("W/N")
   HB_dispbox( 1, 0, 07, 79,B_DOUBLE)   
   @ 03,00 SAY "Ç"
   @ 03,01 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 05,01 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 2,24  SAY MSG2
   SETCOLOR("W/R")
   HB_dispbox( 8,21, 10, 58,B_DOUBLE)   
   SETCOLOR("W/N")
   @ 13,01 CLEA TO 19,77
   @ 09,27 SAY "M E N U   P R I N C I P A L"
   HB_dispbox(12, 1, 20, 78,B_DOUBLE)   
   @ 13,02 SAY "²²²²²²²   ²²²²²   ²²²²     ²²  ²²     ²²          ß"
   @ 14,02 SAY " ²²   ²  ²²   ²²   ²²      ²²  ²²    ²²²²    Ûßß Ûßß ÛßßÛ Û ÛßÛ Ûßß"
   @ 15,02 SAY " ²²   ²  ²²   ²²   ²²      ²²  ²²   ²²  ²²   Ûß  Ûß  ÛßÛ  Û ÛßÛ ßßÛ  Ü"
   @ 16,02 SAY "²²²²     ²²   ²²   ²²      ²²²²²²   ²²  ²²   ß   ßßß ß  ß ß ß ß ßßß ß ß"
   @ 17,02 SAY " ²² ²    ²²   ²²   ²²  ²   ²²  ²²   ²²²²²²   ÛßßÛ Ûßß Ûßß Ûßß Û Ûßß ÛßÛ ÛßÛ"
   @ 18,02 SAY " ²²      ²²   ²²   ²²  ²²  ²²  ²²   ²²  ²²   ÛßÛ  Ûß  ßßÛ Û   Û ßßÛ ÛßÛ Û Û"
   @ 19,02 SAY "²²²²      ²²²²²   ²²²²²²²  ²²  ²²   ²²  ²²   ß  ß ßßß ßßß ßßß ß ßßß ß ß ßßß"
   SETCOLOR("+W/BR,N/W")
   @ 04,02 PROM "  Cadastro  " MESS "  Manipula‡„o do Cadastro de Remanajamento F‚rias  "
   @ 04,16 PROM "  Planilhas " MESS "  Listagens de Planilhas de F‚rias  "
   @ 04,30 PROM "  Calculos  " MESS "  Calcular Rescis„o e F‚rias  "
   @ 04,44 PROM " Transferir " MESS "  Transfere Calculos de Ferias e Rescisao para a Folha  "
   @ 04,58 PROM "  Recibos   " MESS "  Emite Recibos de F‚rias, Abono e Rescis„o  "
   @ 04,72 PROM " Sair " MESS " Abandonar o sistema "
   MENU TO OPCAO
   DO CASE
   CASE OPCAO = 1 ; FORES_A()
   CASE OPCAO = 2 ; FORES_B()
   CASE OPCAO = 3 ; FORES_C()
   CASE OPCAO = 4 ; FORES_D()
   CASE OPCAO = 5 ; FORES_E()
   OTHERWISE      ; RETU
   ENDCASE
ENDDO
*: FIM: FORESM.PRG
