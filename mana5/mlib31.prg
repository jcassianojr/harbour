// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib31.prg
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



#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CKEMPTY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CKEMPTY( eVAR )

   IF !Empty( eVAR )
      RETU .T.
   ENDIF
   RETU MDG( "Aceitar Campo Vazio" )





// + EOF: mlib31.prg
// +
