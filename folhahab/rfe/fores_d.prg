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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :    FORES_D.PRG: Menu de Transferˆncias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94     12:20
// :
// :  Procs & Fncts: FORES_D()
// :
// :          Chama: CABE3()            (fun‡„o    em FORESP.PRG)
// :               : FORES_D1()         (fun‡„o    em FORES_D1.PRG)
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************


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
// : FIM: FORES_D.PRG

*+ EOF: fores_d.prg
*+
