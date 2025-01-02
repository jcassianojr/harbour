// +--------------------------------------------------------------------
// +
// +    Programa  : folis_a.prg Acumula Folhas Anuais,Sal.Variavel 13§,Rais,Infome e Dirf
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

FUNCTION folis_a()

   WHILE .T.
      CABE3( "  Acumula Folhas Anuais,Sal.Variavel 13§,Rais,Infome e Dirf  ", 24, 79 )
      @ 10, 1 PROM " A - Acumular Folhas de Pagamento do Ano de Trabalho" + SPAC( 26 )
      @ 12, 1 PROM " B - Acumular M‚dia de Sal rio Variavel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc) "
      @ 14, 1 PROM " C - Acumular Dados das Folha de Pagamento para a RAIS" + SPAC( 24 )
      @ 16, 1 PROM " D - Acumular Dados das Folha de Pagamento para INFORME DE RENDIMENTO" + SPAC( 9 )
      @ 17, 1 PROM " E - Acumular Dados das Folha de Pagamento para DIRF" + SPAC( 26 )
      @ 19, 1 PROM " F - Criar Arquivo para RAIS  p/ Programa SEPRO/RAIS                          "
      @ 20, 1 PROM " G - Criar Arquivo para Dirf  p/ Programa RECEITA/DIRF                        "
      @ 21, 1 PROM " H - Criar Arquivo Dirf Juridica Avulsa                                       "
      MENU TO OPC
      DO CASE
      CASE OPC = 1
         FOLIS_A1( 0 )
      CASE OPC = 2
         FOLIS_A2()
      CASE OPC = 3
         FOLIS_A3()
      CASE OPC = 4
         FOLIS_A4()
      CASE OPC = 5
         FOLIS_A5()
      CASE OPC = 6
         FOLIS_A6()
      CASE OPC = 7
         FOLIS_A7()
      CASE OPC = 8
         FOLIS_A8()
      OTHERWISE
         RETU
      ENDCASE
   ENDDO

   RETURN .T.

// + EOF: folis_a.prg
// +
