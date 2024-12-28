// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ak4.prg
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
// :   M_AK4  .PRG :
// :   Linguagem   : Clipper 5.x
// :        Sistema: C:MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :
// :*****************************************************************************


// Variaveis

aRETU   := PEGMES( { "" }, .F., { "" } )
ARQWORK := "K4" + aRETU[ 4 ] + aRETU[ 3 ]
nANO    := aRETU[ 2 ]
nMES    := aRETU[ 1 ]


// Checagem do Arquivo Mensal
CHECKARQ( "MK04", ARQWORK,,, ZDIRP + "E" + StrZero( znumero, 3 ) + StrZero( aRETU[ 2 ], 4 ) + "\", aRETU[ 2 ], aRETU[ 1 ] )


PADRAO( 0,, 0, ARQWORK, "N.Lanc.  Data     Fornecedor" + spac( 11 ) + "UE   CONTA" + spac( 15 ) + "Valor", ;
      "' '+STR(mNRNOTA,  8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+mCENTRO+mGASTO+' '+mCONTA+' '+STR(mVALORMES, 12, 2)", ;
      "MAK4",,, {|| ULTIMOREG( ARQWORK, "NRNOTA", "mNRNOTA" ) } )

// + EOF: m_ak4.prg
// +
