*:*****************************************************************************
*:
*:        FOI.PRG: Menu de Resumos - Opera‡„o a realizar
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:11
*:
*:*****************************************************************************

#INCLUDE "BOX.CH"

IMPHP()


WHILE .T.
   HELPDBF="FOC"
   CABEX("Menu de Resumos - Tipo de Resumos")
   HB_DISPBOX(07,00,23,19,B_DOUBLE+" ")
   OPCAO(09,01," &1 - Configurado  ",49)
   OPCAO(11,01," &2 - Depto I      ",50)
   OPCAO(13,01," &3 - Depto II     ",51)
   OPCAO(15,01," &4 - Ap. Contabil ",52)
   OPCAO(17,01," &5 - Apura‡„o II  ",53)
   OPCAO(19,01," &6 - Anual Empresa",54)
   OPCAO(21,01," &7 - Gerencial    ",55)
   TIP:=MENU(,0)
   TELA=SAVESCREEN(07,00,23,19)
   IF TIP#0
      DO CASE
         CASE TIP=6 ; HELPDBF="FOIF"
      ENDCASE
      FOII()
   ELSE
      RETU
   ENDIF
ENDDO

*!*****************************************************************************
*!
*!      Procedure: FOII
*!
*!    Chamado por: FOI.PRG
*!
*!          Chama: FOIIA              (processo  em FOI.PRG)
*!               : FOIIB              (processo  em FOI.PRG)
*!               : FOID()             (fun‡„o    em FOID.PRG)
*!               : FOID1()            (fun‡„o    em FOID1.PRG)
*!               : FOIF1()            (fun‡„o    em FOIF1.PRG)
*!               : FOIB()             (fun‡„o    em FOIB.PRG)
*!
*!*****************************************************************************
PROC FOII
WHILE .T.
   CABEX ("Menu de Resumos - Opera‡„o a realizar")
   RESTSCREEN(07,00,21,19,TELA)
   HB_DISPBOX(07,20,17,39,B_DOUBLE+" ")
   @ 09,21 PROM "  A - Listar      "
   @ 11,21 PROM "  B - Acumular    "
   @ 13,21 PROM "  C - Titulos     "
   MENU TO OPR
   TELB=SAVESCREEN(07,20,17,39)
   IF OPR=0
      RETU
   ENDIF
   DO CASE
   CASE OPR=1.AND.(TIP=1.OR.TIP=4) ; FOIIA()
   CASE OPR=1.AND.(TIP=2.OR.TIP=3) ; FOIIB()
   CASE OPR=1.AND.TIP=5
      IF MDG('Deseja Contabil')
         FOID(6)
      ELSE
         FOID1()
      ENDIF
   CASE OPR=1.AND.TIP=6 ; FOIF1()
   CASE OPR=2.AND.(TIP=1.OR.TIP=4) ; MDT('Este resumo n„o necessita acumla‡„o')
   CASE OPR=2.AND.(TIP=2.OR.TIP=3.OR.TIP=5.OR.TIP=6) ; FOIIA()
   CASE OPR=3.AND.TIP=1                     ; FOIB(1)
   CASE OPR=3.AND.(TIP=2.OR.TIP=4.OR.TIP=5.OR.TIP=6) ; MDT('Este resumo n„o utiliza titulos')
   CASE OPR=3.AND.TIP=3                     ; FOIB(2)
   OTHERWISE            ; EXIT
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!      Procedure: FOIIA
*!
*!    Chamado por: FOII               (processo  em FOI.PRG)
*!
*!          Chama: FOIA()             (fun‡„o    em FOIA.PRG)
*!               : FOI20()            (fun‡„o    em FOI20.PRG)
*!               : FOIC0()            (fun‡„o    em FOIC0.PRG)
*!               : FOID()             (fun‡„o    em FOID.PRG)
*!               : FOID0()            (fun‡„o    em FOID0.PRG)
*!               : FOIF0()            (fun‡„o    em FOIF0.PRG)
*!
*!*****************************************************************************
PROC FOIIA
WHILE .T.
   CABEX ("Menu de Resumos - Arquivo para Acumular")
   RESTSCREEN(07,00,21,19,TELA)
   RESTSCREEN(07,20,17,39,TELB)
   oPCAO(  8,01 , " &1 - Pagamento       ",49)
   oPCAO(  9,01 , " &2 - Ferias          ",50)
   oPCAO( 10,01 , " &3 - Rescis„o        ",51)
   oPCAO( 11,01 , " &4 - 13o.Salario     ",52)
   oPCAO( 12,01 , " &5 - Complemento     ",53)
   oPCAO( 13,01 , " &6 - Vale Transporte ",54)
   oPCAO( 14,01 , " &7 - Folha Semanal   ",55)
   oPCAO( 15,01 , " &8 - Folha RPA       ",56)
   ARQ:=MENU(,0)
   IF ARQ=0
      EXIT
   ENDIF
   DO CASE
      CASE TIP=1 ; FOIA(ARQ)
      CASE TIP=2 ; FOI20(ARQ)
      CASE TIP=3 ; FOIC0(ARQ)
      CASE TIP=4 ; FOID(ARQ)
      CASE TIP=5 ; FOID0(ARQ)
      CASE TIP=6 ; FOIF0(ARQ)
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!      Procedure: FOIIB
*!
*!    Chamado por: FOII               (processo  em FOI.PRG)
*!
*!          Chama: FOI2B()            (fun‡„o    em FOI2B.PRG)
*!               : FOI2A()            (fun‡„o    em FOI2A.PRG)
*!               : FOIC1()            (fun‡„o    em FOIC1.PRG)
*!
*!*****************************************************************************
PROC FOIIB
WHILE .T.
   CABEX ("Menu de Resumos - Grupo a Listar")
   RESTSCREEN(07,00,21,19,TELA)
   RESTSCREEN(07,20,17,39,TELB)
   HB_DISPBOX(07,40,15,59,B_DOUBLE+" ")
   @ 09,41 PROM "  L - Depto       "
   @ 11,41 PROM "  M - Setor       "
   @ 13,41 PROM "  N - Se‡„o       "
   MENU TO LST
   IF LST=0
      EXIT
   ENDIF
   DO CASE
   CASE TIP=2
      IF MDG('Deseja Contabil')
         FOI2B(LST)
      ELSE
         FOI2A(LST)
      ENDIF
   CASE TIP=3 ; FOIC1(LST)
   ENDCASE
ENDDO
RETU
*: FIM: FOI.PRG
