*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_d6.prg
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
*+    Documentado em 14-Out-2026 as  4:52 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function folis_d6()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION folis_d6()


@ 08,00 CLEAR
@ 10,10 SAY "VOCE IRè CONVERTER SUA FOLHA DE PAGAMENTO PELO INDICE"         
@ 11,10 SAY "QUE VOCE DIGITAR SO FAÄA ESTE PROCESSO UMA UNICA VEZ"          
INDICE := 1000.00000
MDS("Digite o Indice")
@ 24,40 GET INDICE PICT "999,999,999,999.999999"        
READCUR()
@ 12,10 SAY "CONVERTER POR "                                         
@ 12,30 SAY INDICE           PICT "@E 999,999,999,999.999999"        
IF !MDG("VOCE TEM CERTEZA")
   RETU .F.
ENDIF
IF !MDG("VOCE TEM RELMENTE CERTEZA")
   RETU .F.
ENDIF
IF !MDG("VOCE TEM ABSOLUTA CERTEZA")
   RETU .F.
ENDIF
ORI := ZDIRE+FOL+".DBF"
BAK := ZDIRE+FOL+".BAK"
MDS("AGUARDE CONVERSéO")
FILEcopy(ORI,BAK)
IF !NETUSE(FOL,,,,,.F.,)  // BREDE(FOL,0)
   RETU .F.
ENDIF
FILTRO := FILTRO()
SET FILTER TO &FILTRO

nLASTREC := LastRec()
Zei_fort(nLASTREC,,,0)
dbEval({|| netgrvcam("VALOR",VALOR / INDICE)},,{|| zei_fort(nLASTREC,,,1)})

dbCloseAll()

RETURN


*+ EOF: folis_d6.prg
*+
