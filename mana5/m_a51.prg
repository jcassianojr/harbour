// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a51.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


PADRAO( 0, 1, 0, ARQWORK, "Codigo - Descricao" + SPAC( 47 ) + "Tipo", ;
      "' '+mCODSER+' '+mDESSER+' '+mTIPSER", ;
      "MA51", "MA5101", {|| gMA51() } )


// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMA51()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMA51

   SetColor( PAD002 )
   @ 24, 1  SAY "Tipo 1-Entrada 2-Sa¡da 3-Servi‡os A-Ent+Sai B+Ent+Ser C-Sai+Ser T(odos)"
   @  4, 1  SAY mCODSER
   @  4, 7  GET mDESSER
   @  4, 68 GET mTIPSER                                                                   PICT "!" VALID mTIPSER $ "123ABCT"
   READCUR()
   RETU .T.



// + EOF: m_a51.prg
// +
