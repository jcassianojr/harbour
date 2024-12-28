// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_dc.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_D6.PRG: Informe
// :   Linguagem   : Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

aTEL01 := EDITPEG( "IRRF01" )
PADRAO( "IRRF01", "IRRF01", "' '+STR(mNUMERO,  8)+' '+mNOME+' '+mCGC", "mNUMERO", "IRRF Juridico Avulso", "Numero   Nome" + spac( 37 ) + "CGC", ;
      {|| PEGCHAVE( "mNUMERO", ULTIMOREG( "IRRF01", "NUMERO", .T. ), ":" ) }, "IRRF01", {|| gDC() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gDC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gDC

   EDITSAY( aTEL01 )
   IF MDG( "Alterar Itens" )
      xNUMERO := mNUMERO
      PADRAO( "IRRF02", "IRRF02", "' '+STR(mNUMERO,  8)+' '+STR(mITEM,  2)+' '+STR(mMES,  4)+' '+mDARF+' '+mNATUREZA+' '+STR(mRENDA, 12, 2)+' '+STR(mALIQUOTA,  5, 2)+' '+STR(mIRRF,  8, 2)", ;
         "STR(mNUMERO,8)+STR(mITEM,2)", "Itens Informe", "Numero   It Mes  Cod  Natureza" + spac( 13 ) + "Renda       Aliq. Reten‡„o", ;
         {|| iDC02() }, "IRRF02", "IRRF02",, { .F., "NUMERO=xNUMERO", .F. } )
      mNUMERO := xNUMERO
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iDC02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iDC02

   MDS( 'Numero do Item: ' )
   @ 24, 40 GET mITEM
   READCUR()
   mNUMERO := xNUMERO
   mCHAVE  := Str( xNUMERO, 4 ) + Str( mITEM, 2 )
   RETU .T.

// + EOF: folis_dc.prg
// +
