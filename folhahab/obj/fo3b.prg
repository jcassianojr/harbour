// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo3b.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "BOX.CH"
PADRAO( "FO_FAI", "FO_FAI", "' '+mFAIXA+' '+mDESCRICAO+' '+STR(mVALOR, 12, 2)+' '+STR(mINDICE,  8, 3)", "mFAIXA", "Cadastro de Faixas Salarias", "Ni Descri‡„o" + spac( 42 ) + "Valor" + spac( 8 ) + "Indice", ;
      {|| PEGCHAVE( "mFAIXA", Space( 2 ), "Codigo:" ) }, {|| tFO3B() }, {|| gFO3B() }, {|| FO_FOR( "GRUPO='FUNCAO'" ) } )
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO3B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gFO3B

   @  5, 1  SAY mFAIXA
   @  5, 4  GET mDESCRICAO
   @  5, 55 GET mVALOR     PICTURE '999999999.99'
   @  5, 68 GET mINDICE    PICTURE '9999.999'
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO3B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFO3B

   hb_DispBox( 3, 0, 23, 79, B_DOUBLE + " " )
   @  4, 1 SAY "Ni Descri‡„o" + spac( 42 ) + "Valor" + spac( 8 ) + "Indice"
   RETU .T.



// + EOF: fo3b.prg
// +
