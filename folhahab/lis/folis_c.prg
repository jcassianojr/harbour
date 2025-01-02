// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c.prg menu de relatorios
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +

function folis_c()
IMPHP()


WHILE .T.
CABE3( "  Planilhas, F.Financeira, Rais, Dirf Informe ", 24, 79 )
@ 06, 1 PROM " A - Previs„o Contabil 13§ Sal rio (Sal rio Base)                             "
@ 07, 1 PROM " B - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAtual)   "
@ 08, 1 PROM " C - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAnterior)"
@ 09, 1 PROM " D - Resumo de uma Conta em um Per¡odo de Meses                               "
@ 10, 1 PROM " E - FICHA FINANCEIRA ANUAL                                      (132 Colunas)"
@ 11, 1 PROM " F - INFORME DE RENDIMENTOS                                       (80 Colunas)"
@ 12, 1 PROM " G - INFORME DE RENDIMENTOS ANEXO                                 (80 Colunas)"
@ 13, 1 PROM " H - DIRF - Resumo                                                            "
@ 14, 1 PROM " I - RAIS - Resumo Empresa                                                    "
@ 15, 1 PROM " J - RAIS - Resumo Funcion rio                                                "
@ 16, 1 PROM " K - RAIS - Resumo Modelo Formul rio                                          "
@ 17, 1 PROM " L - RAIS - Checagem Dados Funcionarios                                       "
@ 18, 1 PROM " M - Previs„o 13o. Salario Acumulada                                          "
@ 19, 1 PROM " N - Informe de Rendimentos Avulso Juridico                                   "
MENU TO OPCAO2
DO CASE
CASE OPCAO2 = 1    // a
FOLIS_C1()
CASE OPCAO2 = 2    // b
FOLIS_C2( 0 )
CASE OPCAO2 = 3    // c
FOLIS_C2( 1 )
CASE OPCAO2 = 4    // d
FOLIS_C4()
CASE OPCAO2 = 5    // e
FOLIS_C5()
CASE OPCAO2 = 6    // f
FOLIS_C6( "R", 0 )
CASE OPCAO2 = 7    // g
FOLIS_C7()
CASE OPCAO2 = 8
FOLIS_C8()
CASE OPCAO2 = 9
FOLIS_CA()
CASE OPCAO2 = 10
FOLIS_CB()
CASE OPCAO2 = 11
ALERTX( "Somente Via GDRAIS/Validador" )
// CASE OPCAO2= 11 ; FOLIS_C9()
CASE OPCAO2 = 12
FOLIS_CC()
CASE OPCAO2 = 13
FOLIS_CD()
CASE OPCAO2 = 14
FOLIS_CE()
OTHERWISE
RETU
ENDCASE
ENDDO
return

// + EOF: folis_c.prg
// +
