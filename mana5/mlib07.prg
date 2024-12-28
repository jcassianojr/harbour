// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib07.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CRIARVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CRIARVARS( ARQWORK, lTIPO, lOPEN )

   IF ValType( lTIPO ) <> "L"
      lTIPO := .T.
   ENDIF
   IF ValType( lOPEN ) <> "L"
      lOPEN := .T.
   ENDIF
   IF lOPEN
      IF !USEREDE( ARQWORK, 1, 0 )
         RETU
      ENDIF
   ENDIF
   INITVARS()
   IF lTIPO
      CLRVARS()
   ENDIF
   dbCloseArea()
   RETU .T.


// + EOF: mlib07.prg
// +
