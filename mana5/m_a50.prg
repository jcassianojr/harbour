// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a50.prg
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


// :*****************************************************************************
// :
// :      M_A50.PRG: Sub Menu Fiscal
// :      Linguagem: harbour
// :        Sistema: Mana5
// :          Autor: Equipe Disk    (Hugo Boss em 14.12.1994)
// :      Copyright (c) 1994 by  jcassiano Sistemas Ltda.
// :
// :  Procs & Fncts: fMA6()
// :
// :      Este ‚ chamado por :
// :
// :      Programas Ä  MANA .PRG  - Submenu de Cadastros Gerais
// :                   MMENU.PRG  - Menu Principal do Sistema Manager 5.01
// :                   MANA5.PRG  - Programa Principal do Sistema
// :
// :  Documentado em: 14.12.1994 as 08:39:17                DISK!  vers„o 5.01
// :*****************************************************************************



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA5X01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MA5X01

   PADRAO( 0, 1, 0, "FI_INV", "Codigo   Class.Fiscal   Descri‡„o" + spac( 32 ) + "Quantidade", ;
      "' '+STR(mNUMERO,8)+' '+mCLASSIFI+' '+mNOME+' '+STR(mQTDDE,10,2)", ;
      "MA5", "MA5001", "MA5001", {|| ULTIMOREG( "FI_INV", "NUMERO", "mNUMERO" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA5X02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA5X02

   PADRAO( 0, 1, 0, "FI_MES", "Empresa Competencia", ;
      "' '+STR(mNUMERO,5)+' '+STR(mANO,4)+' '+STR(mMES,2)", ;
      "MA53", "MA5301", "MA5301", ;
      {|| mNUMERO := ZNUMERO }, {|| PADARR( "FI_MES", Str( ZNUMERO, 5 ), "NUMERO", "ZNUMERO" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_A51()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC m_A51( cARQ )

   PADRAO( 0, 1, 0, cARQ, "Codigo - Descricao" + SPAC( 47 ) + "Tipo Cont", ;
      "' '+mCODSER+' '+mDESSER+' '+mTIPSER+' '+mEXPCONT", "MA51" )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_A54()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_A54

   nANO := Year( ZDATA )
   nMES := Month( ZDATA )
   MDS( "Digite o Mˆs e o ano" )
   @ 24, 40 GET nMES
   @ 24, 45 GET nANO
   READCUR()
   PADRAO( 0, 1, 0, "FI_OCO", "Ano/Mes T It Ocorencia" + spac( 22 ) + "Valor/ICM    Valor/IPI", ;
      "' '+STR(mANO,4)+' '+STR(mMES,2)+' '+mTIPO+' '+STR(mITEM,2)+' '+mDESCRICAO+' '+STR(mVALICM,12,2)+' '+STR(mVALIPI,12,2)", ;
      "MA54", "MA5401", "MA5401", ;
      {|| iMA54() }, {|| PADARR( "FI_OCO", Str( nANO, 4 ) + Str( nMES, 2 ), "STR(nANO,4)+STR(nMES,2)", "STR(ANO,4)+STR(MES,2)" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iMA54()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iMA54

   mANO := nANO
   mMES := nMES
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_A5J()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_A5J( cARQ )

   PADRAO( 0, 1, 0, cARQ, "Seq      Data     Descrica‡„o" + spac( 20 ) + "Credito      Debito", ;
      "' '+STR(mSEQ,8)+' '+DTOC(mDATA)+' '+mDESCR+' '+STR(mCREDITO,12,2)+' '+STR(mDEBITO,12,2)", ;
      "MA5J",,, {|| ULTIMOREG( cARQ, "SEQ", "mSEQ" ) } )
   RETU .T.

// + EOF: m_a50.prg
// +
