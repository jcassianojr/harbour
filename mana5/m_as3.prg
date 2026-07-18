// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_as3.prg
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
// :   M_AS3  .PRG : Composicao do Produto
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Procs & Fncts: fMAS3()
// :
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



PADRAO( 1, 1, 0, "MS03", "Codigo   T Codigo" + spac( 6 ) + "Componente" + spac( 31 ) + "Qtdde", ;
      "' '+mCODIGO+' '+mTIPOENT+' '+mCODCOMP+' '+mNOMECOMP+' '+STR(mQTDDE,8,4)", ;
      "MAS3",,, {|| mCODIGO := xCODIGO }, {|| PADARR( "MS03", XCODIGO, "XCODIGO", "CODIGO" ) } )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAS302()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAS302

   IF Empty( mNOMECOMP )
      mNOMECOMP := OBTER( ESTQARQ( mTIPOENT, 1 ), mCODCOMP, "NOME" )
   ENDIF
   IF Empty( mPRECO )
      DO CASE
      CASE mTIPOENT $ "EHT"
         mPRECO := OBTER( ESTQARQ( mTIPOENT, 1 ), mCODCOMP, "VALOR" )
      CASE mTIPOENT $ "MCS"
         mPRECO := OBTER( ESTQARQ( mTIPOENT, 1 ), mCODCOMP, "PRECUST" )
      CASE mTIPOENT = "P"
         mPRECO := OBTER( "MS01", mCODCOMP, "CUSTF" )
      CASE mTIPOENT = "O"
         mPRECO := OBTER( "MW05", mCODCOMP, "COTVAL" )
      CASE mTIPOENT = "R"
         mPRECO := OBTER( "MW07", mCODCOMP, "COTVAL" )
      ENDCASE
   ENDIF
   RETU .T.



// + EOF: m_as3.prg
// +
