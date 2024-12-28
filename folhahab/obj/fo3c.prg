// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo3c.prg
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



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fo3c()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fo3c

   PARA cARQ

   IF cARQ = "FO_CBON"
      PADRAO( cARQ, cARQ, "' '+mCODIGO+' '+STRZERO(mCAGEDESCO,2)+' '+mNOME", "mCODIGO", "Codigos", "Codigo Escolaridade Nome", ;
         {|| PEGCHAVE( "mCODIGO", Space( 5 ), "Codigo:" ) }, {|| mds( "Desc:" ) }, {|| gcadcbo() }, {|| FO_FOR( "GRUPO='CBO'" ) } )
   ELSE
      PADRAO( cARQ, cARQ, "' '+mCODIGO+' '+mNOME+' '", "mCODIGO", "Codigos", "Codigo Nome", ;
         {|| PEGCHAVE( "mCODIGO", Space( 5 ), "Codigo:" ) }, {|| mds( "Desc:" ) }, {|| gcadcbo() }, {|| FO_FOR( "GRUPO='CBO'" ) } )
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gCADCBO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gCADCBO

   @ MaxRow(), 08 GET mNOME PICT "@S50"
   IF cARQ = "FO_CBON"
      @ MaxRow(), 60 GET mCAGEDESCO
   ENDIF

   READCUR()



// + EOF: fo3c.prg
// +
