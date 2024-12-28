// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib17.prg
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


#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGBUS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGBUS( cARQ, nIND, cTITULO )

   LOCAL RETORNO
   LOCAL FORMULA
   LOCAL cTELA   := SaveScreen( 4, 5, 24 - 3, 63 )

   hb_DispBox( 4, 5, 24 - 3, 63, B_DOUBLE + " " )
   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( cTITULO ) = "C"
      @  5, 7 SAY cTITULO
   ELSE
      @  5, 7 SAY "Digite a Busca"
   ENDIF
   FOR X := 1 TO 3
      IF !Empty( aIND[ nIND, X, 3 ] )
         PRIV cVARGET := aIND[ nIND, X, 3 ]
         cLEN := &cVARGET.
         @ X * 2 + 6, 7 SAY aIND[ nIND, X, 4 ]
         IF ValType( cLEN ) # "U"
            IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
               @ X * 2 + 7, 7 GET &cVARGET. PICT "@S40"
            ELSE
               @ X * 2 + 7, 7 GET &cVARGET.
            ENDIF
         ENDIF
      ENDIF
   NEXT X
   READCUR()
   FORMULA := aIND[ nIND, 4 ]
   RETORNO := if( Empty( FORMULA ), &cVARGET., &FORMULA. )
// Se for a primeira Chave Atualiza a variavel busca padr„o
   IF nIND = 1
      FORMULA  := aIND[ 1, 4 ]
      VARIAVEL := aIND[ 1, 1, 3 ]
      mCHAVE   := if( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
   ENDIF
   RestScreen( 4, 5, 24 - 3, 63, cTELA )
   RETU RETORNO


// + EOF: mlib17.prg
// +
