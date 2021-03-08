*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\CLIPPER\FOLHA\PTO\FOPTO_4I.PRG
*+
*+    Functions: Function iFOPTO4I()
*+               Function gFOPTO4I()
*+               Function tFOPTO4I()
*+
*+    Reformatted by Click! 2.03 on Sep-17-2000 at 12:08 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// ******************************************************************************

//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

PADRAO( "CONTAS", "CONTAS", "STR(mCODIGO)+' '+mDESCR", "mCODIGO", "FOPTO_4I - Cadastro de Contas", "Codigo Descri‡„o", ;
        {|| PEGCHAVE("mCODIGO",0,"Codigo:")}, { || tFOPTO4I() }, { || gFOPTO4I() }, { || FO_RELL( "PONTOCAD10" ) },, 2 )
retu .T.


*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function gFOPTO4I()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func gFOPTO4I

@ 24, 00 clea
@ 24, 00 say mCODIGO         
@ 24, 10 get mDESCR          
READCUR()
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function tFOPTO4I()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func tFOPTO4I

@ 24, 00 clea
@ 24, 00 say mCODIGO         
@ 24, 10 say mDESCR          
retu .T.

*+ EOF: FOPTO_4I.PRG
