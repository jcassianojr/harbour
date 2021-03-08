*:*****************************************************************************
*:
*:  FOLIS_C.PRG  : Relat¢rios
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************

IMPHP()


WHILE .T.
   CABE3("  Planilhas, F.Financeira, Rais, Dirf Informe " ,24,79)
   @ 06,1 PROM " A - Previs„o Contabil 13§ Sal rio (Sal rio Base)                             "
   @ 07,1 PROM " B - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAtual)   "
   @ 08,1 PROM " C - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAnterior)"
   @ 09,1 PROM " D - Resumo de uma Conta em um Per¡odo de Meses                               "
   @ 10,1 PROM " E - FICHA FINANCEIRA ANUAL                                      (132 Colunas)"
   @ 11,1 PROM " F - INFORME DE RENDIMENTOS                                       (80 Colunas)"
   @ 12,1 PROM " G - INFORME DE RENDIMENTOS ANEXO                                 (80 Colunas)"
   @ 13,1 PROM " H - DIRF - Resumo                                                            "
   @ 14,1 PROM " I - RAIS - Resumo Empresa                                                    "
   @ 15,1 PROM " J - RAIS - Resumo Funcion rio                                                "
   @ 16,1 PROM " K - RAIS - Resumo Modelo Formul rio                                          "
   @ 17,1 PROM " L - RAIS - Checagem Dados Funcionarios                                       "
   @ 18,1 PROM " M - Previs„o 13o. Salario Acumulada                                          "
   @ 19,1 PROM " N - Informe de Rendimentos Avulso Juridico                                   "
   MENU TO OPCAO2
   DO CASE
      CASE OPCAO2 = 1 ; FOLIS_C1() //a
      CASE OPCAO2 = 2 ; FOLIS_C2(0) //b
      CASE OPCAO2 = 3 ; FOLIS_C2(1) //c
      CASE OPCAO2 = 4 ; FOLIS_C4() //d
      CASE OPCAO2 = 5 ; FOLIS_C5() //e
      CASE OPCAO2 = 6 ; FOLIS_C6("R",0) //f
      CASE OPCAO2 = 7 ; FOLIS_C7() //g
      CASE OPCAO2 = 8 ; FOLIS_C8()
      CASE OPCAO2 = 9 ; FOLIS_CA()
      CASE OPCAO2= 10 ; FOLIS_CB()
      CASE OPCAO2= 11 ; ALERTX("Somente Via GDRAIS/Validador")
  //    CASE OPCAO2= 11 ; FOLIS_C9()
      CASE OPCAO2= 12 ; FOLIS_CC()
      CASE OPCAO2= 13 ; FOLIS_CD()
      CASE OPCAO2= 14 ; FOLIS_CE()
   OTHERWISE     ; RETU
   ENDCASE
ENDDO

*: FIM: FOLIS_C.PRG
