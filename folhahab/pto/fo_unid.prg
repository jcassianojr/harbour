// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo_unid.prg unidades funcionais
// +
// +
// +
// +     Sistema:FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"

FUNCTION fo_unid()

   PADRAO( "UNID", "UNID", "mCODIGO+' '+mNOME+' '+STR(mNUMERO,4)+' '+mMODIRETA", "mCODIGO", "FOUNID - Cadastro de Unidade Funcional", "Codigo Nome", ;
      {|| PEGCHAVE( "mCODIGO", Space( 10 ), "Codigo Unidade" ) }, {|| tFOUNID() }, {|| gFOUNID() }, {|| FO_RELL( "FOUNID" ) },, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOUNID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOUNID

   @  6, 01 SAY mCODIGO
   @  6, 12 GET mNOME
   @  6, 68 GET MNUMERO
   @  6, 76 GET mMODIRETA VALID mMODIRETA $ "SNACDI "
   READCUR()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOunid()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOunid

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 01 SAY "Codigo"
   @  5, 12 SAY "Nome"
   @  5, 68 SAY "Ccusto"
   @  5, 76 SAY "M"

   RETURN .T.

// + EOF: fo_unid.prg
// +
