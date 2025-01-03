// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_a.prg Cadastramento/Atualiza‡„o/Verifica‡„o Dados F‚rias
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


FUNCTION fores_a()

   WHILE .T.
      CABE3( "  Cadastramento/Atualiza‡„o/Verifica‡„o Dados F‚rias  ", 18 )
      @ 09, 1 PROM ' A - Revisar Aquisitivos de ferias de um funcionario  '
      @ 10, 1 PROM ' B - Remanejar F‚rias       =>  Prepara Cadastro de F‚rias coletivamente     '
      @ 11, 1 PROM ' C - Revisar F‚rias         =>  Verifica e Alterar dados do Remanejamento    '
      @ 12, 1 PROM ' D - Exibir Simples         =>  Verifica no Video os Dados B sicos F‚rias    '
      @ 13, 1 PROM ' E - Baixar F‚rias          =>  Baixar F‚rias j  Gozadas, Excluir Relat¢rios '
      @ 14, 1 PROM " F - Indexar Arquivos" + SPAC( 28 ) + "(Criar Arquivos de Trabalho)"
      @ 15, 1 PROM " G - Configurar Indexa‡„o" + SPAC( 17 ) + "(Seleciona Arquivos para Indexa‡„o)"
      @ 17, 1 PROM " H - Consulta Provis„o Acumulada"
// @ 16,1 PROM " I - Configurar Formul rio de Rescis„o"
      MENU TO OPCAO2
      DO CASE
      CASE OPCAO2 = 1
         FORES_A1()
      CASE OPCAO2 = 2
         FORES_A2()
      CASE OPCAO2 = 3
         FORES_A3()
      CASE OPCAO2 = 4
         FORES_A4()
      CASE OPCAO2 = 5
         FORES_A5()
      CASE OPCAO2 = 6
         FOy2( 0, "FORFENTX" )
         FORES_A8( 0 )
      CASE OPCAO2 = 7
         FOY2( 1, "FORFENTX" )

      CASE OPCAO2 = 8
         FORES_A9()
// CASE OPCAO2=9 ; FOFA()
      OTHERWISE
         RETU
      ENDCASE
   ENDDO

   RETURN

// + EOF: fores_a.prg
// +
