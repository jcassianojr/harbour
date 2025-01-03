// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_b.prg Planilhas de F‚rias
// +
// +
// +
// +     Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


FUNCTION fores_b()

   IMPHP()
   WHILE .T.
      CABE3( "  Planilhas de F‚rias  ", 16 )
      @ 09, 1 PROM ' A - F‚rias Simples          => Planilha B sica de F‚rias                     '
      @ 10, 1 PROM ' B - F‚rias Completa         => Planilha Completa de F‚rias                   '
      @ 11, 1 PROM ' C - F‚rias Administrativa   => Planilha F‚rias a gozar                       '
      @ 12, 1 PROM ' D - F‚rias Cont bil         => Planilha Destinada a Contabilidade            '
      @ 13, 1 PROM ' E - Funcion rios em F‚rias  => Planilha Funcion rios em f‚rias em um periodo '
      @ 14, 1 PROM ' F - Provis„o Ferias Acumulada '
      MENU TO OPCAO2
      DO CASE
      CASE OPCAO2 = 1
         FORES_B1()
      CASE OPCAO2 = 2
         FORES_B2()
      CASE OPCAO2 = 3
         FORES_B3()
      CASE OPCAO2 = 4
         FORES_B4()
      CASE OPCAO2 = 5
         FORES_B5()
      CASE OPCAO2 = 6
         FORES_B6()
      OTHERWISE
         RETU
      ENDCASE
   ENDDO

   RETURN

// + EOF: fores_b.prg
// +
