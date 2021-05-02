*:*****************************************************************************
*:
*:        FOG.PRG: MENU MPRINCIPAL DE PLANILHAS
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/08/98
*:
*:*****************************************************************************

#INCLUDE "BOX.CH"
IMPHP()

WHILE .T.
   CABEX("Menu de Planilhas")
   HB_DISPBOX(07,00,17,30,B_DOUBLE+" ")
   @ 09,01 PROM " 1 - Entrada Dados               "  
   @ 11,01 PROM " 2 - Hor. Trabalho               "
   @ 13,01 PROM " 3 - Faltas                      "
   @ 14,01 PROM " 4 - Trocar Descritivo Turno     " 
   @ 15,01 PROM " 5 - Multiplas Troca Desc.Turno  "    
   MENU TO ARQ
   TELA=SAVESCREEN(07,00,17,30)
   DO CASE
      CASE ARQ=1 ; FOGAA()
      CASE ARQ=2 ; FOGBB()
      CASE ARQ=3 ; ALERTX("Utilize o Modulo Ponto, Voce Tera mais Recursos")
      case ARQ = 4 //4 trocar descritivo turno individual 
           trocahtt(1)     
      case ARQ = 5 //5 trocar descritivo turno multiplos
           trocahtt(2)     
      OTHERWISE  ; RETU
   ENDCASE
ENDDO


*!*****************************************************************************
*!
*!       FOGAA
*!
*!*****************************************************************************
FUNCTION FOGAA
WHILE .T.
   CABEX("Planilha de Entrada de Dados: ")
   RESTSCREEN(07,00,15,22,TELA)
   HB_DISPBOX(07,29,15,50,B_DOUBLE+" ")
   @ 09,30 PROM " A - Altera Contas  "
   @ 11,30 PROM " B - Lista Simples  "
   @ 13,30 PROM " C - Lista Completa "
   @ 15,30 PROM " D - Reduzida       "
   MENU TO OPCAO
   DO CASE
      CASE OPCAO=1 ; FOGA()
      CASE OPCAO=2 ; FOG2(0)
      CASE OPCAO=3 ; FOG2(1)
      CASE OPCAO=4 ; FO_RELL("FICHALANCMEN")
      OTHERWISE    ; RETU
   ENDCASE
ENDDO

*!*****************************************************************************
*!
*!       FOGBB
*!
*!*****************************************************************************
FUNCTION FOGBB
WHILE .T.
   CABEX("Planilha de Horario Trabalho: ")
   RESTSCREEN(07,00,15,22,TELA)
   HB_DISPBOX(07,29,21,51,B_DOUBLE+" ")
   @ 09,30 PROM " A - Recria Planilha "
   @ 11,30 PROM " B - Altera Dados    "
   @ 13,30 PROM " C - Lista Simples   "
   @ 15,30 PROM " D - Acordo Compen.  "
   @ 17,30 PROM " F - Horario Padroes "
   MENU TO OPCAO
   DO CASE
      CASE OPCAO=1 ; FOGB(1)
      CASE OPCAO=2 ; FOG6()
      CASE OPCAO=3 ; FOG7()
      CASE OPCAO=4 ; FOG8()
      CASE OPCAO=5 ; FOGE()
      OTHERWISE    ; RETU
   ENDCASE
ENDDO

