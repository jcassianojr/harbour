// +--------------------------------------------------------------------
// +
// +    Programa  : folis_b.prg calcular 13o. Salario/ Transferir
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


FUNCTION folis_b()

   DO WHILE .T.
      CABE3( "  Calcular 13o. Salario/ Transferir   ", 24, 79 )
      SetColor( "W/N,N/W" )
      @ 17, 6 SAY "Somente Contas com T1=0 Plano de Contas"
      @ 20, 6 SAY "Somente Contas com T2=0 Plano de Contas"
      @ 23, 6 SAY "Somente Contas com TC=0 Plano de Contas"
      SetColor( "+GR/BG" )
      @ 10, 1 PROM " A - Calcular 1¦ Parcela  de 13§ Sal rio" + SPAC( 38 )
      @ 12, 1 PROM " B - Calcular 2¦ Parcela  de 13§ Sal rio" + SPAC( 38 )
      @ 14, 1 PROM " C - Calcular Complemento de 13§ Sal rio" + SPAC( 38 )
      @ 16, 1 PROM " D - Transferir 1¦ Parcela  de 13§ Sal rio para Folha de Pagamento do mˆs     "
      @ 19, 1 PROM " E - Transferir 2¦ Parcela  de 13§ Sal rio para Folha de Pagamento do mˆs     "
      @ 22, 1 PROM " F - Transferir Complemento de 13§ Sal rio para Folha de Pagamento do mˆs     "
      MENU TO OPCAO2
      DO CASE
      CASE OPCAO2 = 1
         FOLIS_B1( 1 )
      CASE OPCAO2 = 2
         FOLIS_B1( 2 )
      CASE OPCAO2 = 3
         FOLIS_B1( 3 )
      CASE OPCAO2 = 4
         FOLIS_B4( 1 )
      CASE OPCAO2 = 5
         FOLIS_B4( 2 )
      CASE OPCAO2 = 6
         FOLIS_B4( 3 )
      OTHERWISE
         RETU
      ENDCASE
   ENDDO

   RETURN

// + EOF: folis_b.prg
// +
