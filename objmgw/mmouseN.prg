*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mmousen.prg
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
*+    Documentado em 16-Out-2026 as  8:02 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OPCAO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION OPCAO(nRow,nCol,cText,nAccl,cMES,bEXE)


cTEXT := StrTran(ctext,"&","")
@ nRow,nCOL PROMPT cTEXT MESSAGE cMES

RETURN NIL

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function menu()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function menu()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION menu(nCurrentPrompt,nMES)


IF ValType(nMES) = "N"
   Set(_SET_MESSAGE,nMES,.T.)
ENDIF
MENU TO nCurrentPrompt

RETURN nCurrentPrompt


*+ EOF: mmousen.prg
*+
