// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ad5.prg
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
// :   M_AD5  .PRG : Al¡quotas Estaduais de ICMS
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :*****************************************************************************





// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_ad5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_ad5

   PARA wMAD5

   xUF := "  "


   PADRAX( wMAD5,, 0, { "MD05", "MD10" }, "UF Z   %     %R  Estado" + spac( 15 ) + "Capital", ;
      "mUFICMS+' '+mZONAFRANCA+' '+STR(mALIQUOTA,  5, 2)+' '+STR(mALIQUOTAR,  5, 2)+' '+mNOMEEXT+' '+mCAPITAL+' '+mINICEP+' '+mFIMCEP", "MAD501", "MAD501", ;
      {|| MAD5REP( .T. ) },, {|| MAD5REP( .F. ) } )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAD5REP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAD5REP( lPERG )

   IF lPERG .OR. mdg( "Deseja Alterar Cadastro de Cidades" )
      mUF := mUFICMS
      xUF := mUFICMS
      PADRAO( 1, 1, 0, "MD10", "UF Nome" + spac( 32 ) + "DDD    Faixa de CEPs     Feriado", ;
         "' '+mUF+' '+mNOME+' '+mDDD+' '+mINICEP+' '+mFIMCEP+' '+DTOC(mFERIADO)", ;
         "MADA",,, {|| mUF := xUF }, {|| PADARR( "MD10", XUF, "UF", "XUF", 1 ) } )
   ENDIF
   RETU .T.

// + EOF: m_ad5.prg
// +
