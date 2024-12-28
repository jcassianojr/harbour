// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1w.prg
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

PRIV xUF := ""

caRQ := PEGCAMINI( "MD10" ) + "MD10"

PADRAO( carq, carq, "' '+mUF+' '+mNOME+' '+mDDD+' '+mINICEP+' '+mFIMCEP", "mUF", "Cadastro de Cidades", "UF Nome" + spac( 32 ) + "DDD    Faixa de CEPs", ;
      {|| iMADA() }, {|| tMADA() }, {|| gMADA() }, {|| FO_FOR( "GRUPO='MD10'" ) } )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iMADA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iMADA()

   MDS( "Digite UF + NOME" )
   @ 24, 30 GET mUF
   @ 24, 35 GET mNOME
   READCUR()
   mCHAVE := mUF + mNOME

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tMADA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tMADA

   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  3, 1  SAY "UF Nome" + spac( 32 ) + "DDD    Faixa de CEPs              KM"
   @  6, 1  SAY "Codigo do Municipio            Arquivo"
   @  4, 1  SAY mUF
   @  4, 4  SAY mNOME
   @  4, 40 SAY mDDD
   @  4, 45 SAY mINICEP                                                   PICT '99999999'
   @  4, 55 SAY mFIMCEP                                                   PICT '99999999'
   @  6, 21 SAY mCODIBGE

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMADA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gMADA

   @  4, 1  SAY mUF
   @  4, 4  SAY mNOME
   @  4, 40 GET mDDD
   @  4, 45 GET mINICEP  PICT '99999999' VALID CHKUFCEP( mINICEP, mUF )
   @  4, 55 GET mFIMCEP  PICT '99999999' VALID CHKUFCEP( mFIMCEP, mUF )
   @  6, 21 GET mCODIBGE
   READCUR()

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECKCID( cUF, cESTADO, LMES, cIBGE, aVAR )  // {{"UF","mUF"},{"NOME","mCIDADE"}} //,,{{"CODIBGE","mIBGE"}}

   LOCAL cARQ, lRETU  // exemplos fopto_42,fo7a

   lRETU := .F.
   caRQ  := PEGCAMINI( "MD10" ) + "MD10"
   IF ValType( cIBGE ) = "C"
      lRETU := VERSEHA( cARQ, 3, cIBGE, "CODIBGE+' '+UF+' '+NOME", "'Codigo Ibge Invalido'", lMES, aVAR )
   ELSE
      lRETU := VERSEHA( cARQ, 1, cUF + cESTADO, "CODIBGE+' '+UF+' '+NOME", "'Cidade Invalida'", lMES, aVAR )
   ENDIF

   RETURN lRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CheckBacen()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CheckBacen( nBacen, cPAIS, lMES, aVAR )

   LOCAL cARQ, lRETU

   lRETU := .F.
   caRQ  := PEGCAMINI( "MD10" ) + "MD10"
   IF nBACEN <> "N"
      nBACEN := Val( nBACEN )
   ENDIF
   caRQ := PEGCAMINI( "PAISES" ) + "PAISES"
   IF !Empty( nBacen )
      lRETU := VERSEHA( cARQ, 5, nBACEN, "STR(BACEN)+' '+NOME", "'Codigo Bacen Invalido'", lMES, aVAR )
   ELSE
      lRETU := VERSEHA( cARQ, 3, cPAIS, "STR(BACEN)+' '+NOME", "'Pais Invalido", lMES, aVAR )
   ENDIF

   RETURN lRETU

// + EOF: fo1w.prg
// +
