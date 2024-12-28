*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_a1.prg
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
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :  FOLIS_A1.PRG : Acumulando Folhas do Ano
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function folis_a1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function folis_a1

PARA CC
CABE2('Acumulando Folhas do Ano')
IF !MDG('Deseja Realmente Acumular')
   RETU
ENDIF
IF CC = 0
   netzap(res)
   IF !netuse(RES,,.F.,,,,)   //nao compartilahdo
      RETU
   ENDIF
   FOR P := 1 TO 12
      MDS('Acumulando o Mes de '+MMES(P)+' nao interrompa')
      ARQTRAB := STRZERO(P,2)
      IF NRSEN # 'DiReT'
         FOT := 'FP'+EMP+ARQTRAB+'.DBF'
      ELSE
         FOT := 'SO'+EMP+ARQTRAB+'.DBF'
      ENDIF

      nLASTREC := NetRegCount(FOT)
      zei_fort(nLASTREC,,,0)
      APPE FROM &FOT FIELDS NUMERO,CONTA,HORAS,VALOR while zei_fort(nLASTREC,,,1)

      nLASTREC := LASTREC()
      zei_fort(nLASTREC,,,0)
      DBEval({|| netgrvcam("MES",P)},{|| MES = 0},{|| zei_fort(nLASTREC,,,1)})
   NEXT P
   MDS('Aguarde Finalizando Acumulo de Folhas')
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEval({|| netgrvcam("CONTROLE",(NUMERO * 10000000+CONTA * 100+MES))},,{|| zei_fort(nLASTREC,,,1)})
   INFOR(RES,"CONTROLE",ZDIRE+RES)  //sEMPRE NECESSARIO rEINDEXAR
ENDIF
RETU .T.


// : FIM: FOLIS_A1.PRG

*+ EOF: folis_a1.prg
*+
