// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_c.prg
// +
// +
// +
// +     Sistema:
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

// :*****************************************************************************
// :
// :   FORES_C.PRG : Menu de Calculos
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:03
// :
// :  Procs & Fncts: FORES_C()
// :
// :          Chama: CABE3()            (fun‡„o    em FORESP.PRG)
// :               : FORES_C1()         (fun‡„o    em FORES_C1.PRG)
// :               : FORES_C3()         (fun‡„o    em FORES_C3.PRG)
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************


FUNCTION fores_c()

   WHILE .T.
      CABE3( "  Calcular F‚rias e Rescis„o  ", 13 )
      @ 09, 1 PROM '  A - Calcular F‚rias de Um Funcion rio                '
      @ 10, 1 PROM '  B - Calcular Complemento de F‚rias de Um Funcion rio '
      @ 11, 1 PROM '  C - Calcular Rescis„o de Um Funcion rio              '
      @ 12, 1 PROM '  D - Calcular Complemento Rescis„o de Um Funcion rio  '
      MENU TO OPCAO2
      DO CASE
      CASE OPCAO2 = 1
         FORES_C1( 1 )
      CASE OPCAO2 = 2
         FORES_C1( 2 )
      CASE OPCAO2 = 3
         FORES_C3( 1 )
      CASE OPCAO2 = 4
         FORES_C3( 2 )
      OTHERWISE
         RETU
      ENDCASE
   ENDDO

   RETURN

// + EOF: fores_c.prg
// +
