*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_cx.prg
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
// :
// :   FORES_CX.PRG: Nome do Programa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:05
// :
// :  Procs & Fncts: FORES_CX()
// :
// :          Chama: ACUVAR()           (fun‡„o    em FORESP.PRG)
// :               : VALVAR()           (fun‡„o    em FORESP.PRG)
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************


MDS('Acumulando Salario Variavel 13§ Salario')
MESINI := MONTH(INI13)
MESFIM := MONTH(FIM13)
ACUVAR('SAL_13=0',.F.,.T.)
MESES := MESFIM - MESINI+1
MDS('Aguarde Calculando a Media')
NUM      := CTR
ANOATUAL := .F.
DBSELECTAR(PES)
IF (YEAR(ADMITIDO) = ANO) .AND. (MONTH(ADMITIDO) > 1)
   ANOATUAL := .T.
   MESESA   := MESFIM - MONTH(ADMITIDO)+1
ENDIF
DBSELECTAR("FO_VAR")
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
IF ANOATUAL
   DBEval({|| netgrvcam("HORAS",HORAS / MESESA)},{|| NUMERO = NUM},{|| zei_fort(nLASTREC,,,1)})
   zei_fort(nLASTREC,,,0)
   DBEval({|| netgrvcam("VALOR",VALOR / MESESA)},{|| NUMERO = NUM},{|| zei_fort(nLASTREC,,,1)})
ELSE
   DBEval({|| netgrvcam("HORAS",HORAS / MESES)},{|| NUMERO = NUM},{|| zei_fort(nLASTREC,,,1)})
   zei_fort(nLASTREC,,,0)
   DBEval({|| netgrvcam("VALOR",VALOR / MESES)},{|| NUMERO = NUM},{|| zei_fort(nLASTREC,,,1)})
ENDIF
DBSELECTAR("FO_VAR")
MDS('Calculando Salario Variavel 13§ Sal rio')
SALV13 := VALVAR('SAL_13=0')
RETU
// : FIM: FORES_CX.PRG

*+ EOF: fores_cx.prg
*+
