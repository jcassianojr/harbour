// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_adi3.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_adi3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_adi3

   PARA cARQ

   ARQWORK4 := cARQ
// Pegando Cores de Trabalho
   CORMAX  := CORARR( "MDI2" )
   mESTADO := "  "
   ZESTADO := OBTER( "MANEMP", ZNUMERO, "ESTADO" )


   PADRAO( 0, 1, 0, cARQ, "Ordem   N.Fiscal   Data           Tipo  Fornecedor" + spac( 13 ) + "Total do Item", ;
      "' '+STR(mITEM,2)+' '+STR(mORDEM,8)+' '+STR(mNUMERO,6)+' '+DTOC(mDATA)+' '+mDCFONEW+' '+mTIPOFOR+' '+STR(mFORNECEDO,5)+' '+mCOGNOME+' '+STR(mDVALORNF,12,2)+' '+STR(mLOTE,5)+' '+mUNIDADE", ;
      "MDI2", {|| tMADX() }, {|| gMADX( 1 ) },,,,,,,,,,,, .T. )

// + EOF: m_adi3.prg
// +
