*:*****************************************************************************
*:
*:        FOE.PRG: Menu de Exibi��o de Dados
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/07/98
*:
*:*****************************************************************************
#INCLUDE "BOX.CH"

PRIV HELPDBF
WHILE .T.
   HELPDBF="FOE"
   CABEX("Menu de Exibicao de Dados")
   HB_dispbox( 7, 0, 19, 22,B_DOUBLE+" ")   
   oPCAO(  8,01 , " &1 - Pagamento       ",49)
   oPCAO(  9,01 , " &2 - Ferias          ",50)
   oPCAO( 10,01 , " &3 - Rescisao        ",51)
   oPCAO( 11,01 , " &4 - 13o.Salario     ",52)
   oPCAO( 12,01 , " &5 - Complemento     ",53)
   oPCAO( 13,01 , " &6 - Vale Transporte ",54)
   oPCAO( 14,01 , " &7 - Folha Semanal   ",55)
   oPCAO( 15,01 , " &8 - Folha RPA       ",56)
   oPCAO( 16,01 , " &A - Adiantamento    ",65)
   oPCAO( 17,01 , " &B - Premio          ",66)
   ARQ:=MENU(,0)
   TELA=SAVESCREEN(07,00,19,22)
   IF ARQ=0
      RETU
   ELSE
      FOEE()
   ENDIF
ENDDO

*!*****************************************************************************
*!
*!      Procedure: FOEE
*!
*!    Chamado por: FOE.PRG
*!
*!*****************************************************************************
PROC FOEE
WHILE .T.
   CABEX("Menu de Exibicao de Dados")
   RESTSCREEN(07,00,19,22,TELA)
   @ 09,25 SAY REPL('�',3)+CHR(16)
   HB_dispbox( 7,32, 21, 68,B_DOUBLE+" ")   
   @ 09,33 PROM "  A - Resumos                      "
   @ 11,33 PROM "  B - Entrada de Dados             "
   @ 13,33 PROM "  C - Mapa de Distribuicao Notas   "
   @ 15,33 PROM "  D - Pgto Executado Completo      "
   @ 17,33 PROM "  E - Pgto Executado Simples       "
   MENU TO TIP
   DO CASE
      CASE TIP=1
           DO CASE
              CASE ARQ=10 ; FOE21(1,'Premio Tributado')
              CASE ARQ=9  ; FOE21(2,'Adiantamento Salarial')
              OTHER       ; FOE6(ARQ)
           ENDCASE
      CASE TIP=2 ; FOE22(ARQ)
      CASE TIP=3 ; HELPDBF="FO07" ; FOE2A(ARQ)
      CASE TIP=4 ; FOE23(ARQ)
      CASE TIP=5 ; FOE24(ARQ)
      OTHERWISE  ; EXIT
   ENDCASE
ENDDO
RETU

*: FIM: FOE.PRG