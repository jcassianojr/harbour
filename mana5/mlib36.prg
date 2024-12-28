// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib36.prg
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
// +    Function MDI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MDI( cMES, lFUN, lMES, cARQ )

   LOCAL pCOR := SetColor()

   IF ValType( lFUN ) # "L"
      lFUN := .T.
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   SetColor( ZCOR002 )
   IF ValType( cARQ ) # "C"
      @ 01, 00 SAY PadR( cMES, 80 )
   ELSE
      @ 01, 00 SAY PadR( cMES + OBTER( zARQ, PadR( cARQ, 8 ), Trim( "DESCRICAO" ) ), 80 )
   ENDIF
   IF lFUN
      MDF()
   ENDIF
   IF lMES
      @ 24, 00
   ENDIF
   SetColor( pCOR )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MDF

   SetColor( ZCOR004 )
   @ 02, 00 CLEAR TO 24 - 1, 79
   RETU .T.


// + EOF: mlib36.prg
// +
