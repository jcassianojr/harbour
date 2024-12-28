// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mmouseN.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => C:\DEVELOP\OBJ\MMOUSEN.PRG
// +
// +    Functions: Function OPCAO()
// +               Function menu()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OPCAO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION OPCAO( nRow, nCol, cText, nAccl, cMES, bEXE )

   cTEXT := StrTran( ctext, "&", "" )
   @ nRow, nCOL PROMPT cTEXT MESSAGE cMES

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
FUNCTION menu( nCurrentPrompt, nMES )

   IF ValType( nMES ) = "N"
      Set( _SET_MESSAGE, nMES, .T. )
   ENDIF
   MENU TO nCurrentPrompt

   RETURN nCurrentPrompt

// + EOF: mmouseN.prg
// +
