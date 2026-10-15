*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_d.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 15-Out-2026 as 10:57 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fores_d()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fores_d()


WHILE .T.
   CABE3("  Transferir Calculos de Rescis„o ou F‚rias ",13)
   @ 09,1 PROM '  A - Ferias              =>  Transfere Calculo de Ferias para Folha     '
   @ 10,1 PROM '  B - Complemento F‚rias  =>  Transfere Complemento de Ferias para Folha '
   @ 11,1 PROM '  C - Rescis„o            =>  Transfere Calculo de Rescis„o para Folha   '
   @ 12,1 PROM '  D - Rescis„o Complemento=>  Transfere Calculo de Rescis„o para Folha   '
   MENU TO OPCAO2
   DO CASE
   CASE OPCAO2 = 1
      FORES_D1(0)
   CASE OPCAO2 = 2
      FORES_D1(1)
   CASE OPCAO2 = 3
      FORES_D1(2)
   CASE OPCAO2 = 4
      FORES_D1(3)
   OTHERWISE
      RETU
   ENDCASE
ENDDO

RETURN
// : FIM: FORES_D.PRG


*+ EOF: fores_d.prg
*+
