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
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


// ******************************************************************************

//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

PADRAO("CONTAS","CONTAS","STR(mCODIGO)+' '+mDESCR","mCODIGO","FOPTO_4I - Cadastro de Contas","Codigo Descri‡„o",;
 {|| PEGCHAVE("mCODIGO",0,"Codigo:")},{|| tFOPTO4I()},{|| gFOPTO4I()},{|| FO_RELL("PONTOCAD10")},,2)
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO4I()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gFOPTO4I


@ 24,00 clea
@ 24,00 say mCODIGO         
@ 24,10 get mDESCR          
READCUR()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO4I()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func tFOPTO4I


@ 24,00 clea
@ 24,00 say mCODIGO         
@ 24,10 say mDESCR          
retu .T.


*+ EOF: fopto_4i.prg
*+
