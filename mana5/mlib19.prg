// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib19.prg
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
// +    Function ESCOLHELOG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC ESCOLHELOG( eNOME )

   cNOME := &eNOME.
   IF !Empty( aLOG1 )
      nPOS    := AScan( aLOG2, cNOME )
      nPOS    := if( nPOS > 1, nPOS, 1 )
      nPOS    := ESCARR( aLOG1, 4, 5, 24 - 3, 63, nPOS, "Escolha o Logradouro" )
      nPOS    := if( nPOS > 1, nPOS, 1 )
      cNOME   := aLOG2[ nPOS ]
      &eNOME. := cNOME
   ENDIF
   RETU .T.


// + EOF: mlib19.prg
// +
