// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_am7.prg
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




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_am7()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_am7

   PARA cARQ

   PADRAO( 0, 1, 0, cARQ, "Req" + spac( 6 ) + "Cliente" + spac( 15 ) + "Produto" + spac( 18 ) + "NF", ;
      "' '+STR(mREQDEV,8)+' '+STR(mCLIENTE,8)+' '+mCOGCLI+' '+mPRODUTO+' '+STR(mNF,8)", ;
      "MAM7",,, {|| ULTIMOREG( caRQ, "REQDEV", "mREQDEV" ) } )

// + EOF: m_am7.prg
// +
