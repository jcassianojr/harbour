*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4i.prg
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
*+    Documentado em 15-Out-2026 as 10:22 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_4i()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto_4i()


PADRAO("CONTAS","CONTAS","STR(mCODIGO)+' '+mDESCR","mCODIGO","FOPTO_4I - Cadastro de Contas","Codigo Descri‡„o",;
 {|| PEGCHAVE("mCODIGO",0,"Codigo:")},{|| tFOPTO4I()},{|| gFOPTO4I()},{|| FO_RELL("PONTOCAD10")},,2)
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4I()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4I


@ 24,00 clea
@ 24,00 SAY mCODIGO         
@ 24,10 GET mDESCR          
READCUR()
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4I()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4I


@ 24,00 clea
@ 24,00 SAY mCODIGO         
@ 24,10 SAY mDESCR          
RETU .T.



*+ EOF: fopto_4i.prg
*+
