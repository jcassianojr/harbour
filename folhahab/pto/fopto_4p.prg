// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4p.prg  Cadastro de Usuarios
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "INKEY.CH"
#include "BOX.CH"

FUNCTION fopto_4p()

   IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC"  // So troca Senha
      ALERTX( "Acesso Permitido Somente Para o Supervisor" )
      RETU .F.
   ENDIF

   PADRAO( "MUSER", "MUSER", "' '+mUSUARIO+' '+mVALIDADE+' '+mEQUIVALE", "mUSUARIO", "FOPTO_4P - Cadastro de Usuarios", "Usuario    Validade Equivalencia", ;
      {|| iFOPTO4P() }, {|| tFOPTO4P() }, {|| gFOPTO4P() },,, 2 )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4P()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION iFOPTO4P

   mUSUARIO := Space( 10 )
   MDS( "Digite o Usuario" )
   @ 24, 40 GET mUSUARIO
   READCUR()
   mUSUARIO := XENCODE( mUSUARIO )
   mCHAVE   := mUSUARIO

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4P()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO4P

   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  3, 1 SAY "Usuario    Validade   Equivalencia"
   @  5, 1 SAY "Senha" + spac( 6 ) + "Fonte Letra No Folha"

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4P()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO4P

   mUSUARIO  := PadR( XDECODE( mUSUARIO ), 10 )
   mEQUIVALE := PadR( XDECODE( mEQUIVALE ), 10 )
   mSENHA    := PadR( XDECODE( mSENHA ), 8 )
   mVALIDADE := XDECDAT( mVALIDADE )
// Get nas Menvars
   @  4, 1  GET mUSUARIO
   @  4, 12 GET mVALIDADE
   @  4, 23 GET mEQUIVALE
   @  6, 1  GET mSENHA    VALID ALLTRUE( CheckPass( mSENHA, .T. ) ) // //remover alltrue apos complemento harbour,vo,vb,xsharp permitir minusculas numeros e acentos
   @  6, 12 GET mARQFON   PICT "9999999"
   @  6, 20 GET mFOLHANO  PICT "9999999"
// @  8, 10 get mEMAIL_USU
// @  8, 33 get mEMAIL_SEN
// @  9, 10 get mEMAIL_CTA
// @ 10, 10 get mEMAIL_POR
// @ 10, 15 get mEMAIL_SER
   READCUR()


// cria antes do encode
   aVALOR    := ENCODEVAL( mUSUARIO )
   mPOSTEL01 := aVALOR[ 1 ]
   mPOSTEL02 := aVALOR[ 2 ]
   mPOSTEL03 := aVALOR[ 3 ]
   mPOSTEL04 := aVALOR[ 4 ]
   mPOSTEL05 := aVALOR[ 5 ]
   mPOSTEL06 := aVALOR[ 6 ]
   mPOSTEL07 := aVALOR[ 7 ]
   mPOSTEL08 := aVALOR[ 8 ]
   mPOSTEL09 := aVALOR[ 9 ]
   mPOSTEL10 := aVALOR[ 10 ]


   ALERTX( DECODEVAL( aVALOR ) )

   aVALOR    := ENCODEVAL( mSENHA )
   mPOSTEL11 := aVALOR[ 1 ]
   mPOSTEL12 := aVALOR[ 2 ]
   mPOSTEL13 := aVALOR[ 3 ]
   mPOSTEL14 := aVALOR[ 4 ]
   mPOSTEL15 := aVALOR[ 5 ]
   mPOSTEL16 := aVALOR[ 6 ]
   mPOSTEL17 := aVALOR[ 7 ]
   mPOSTEL18 := aVALOR[ 8 ]


// ALERTX(DECODEVAL(aVALOR))



   IF !Empty( mUSUARIO ) .AND. !Empty( mSENHA )
      mCHAVEH := StrToHex( hb_SHA256( Upper( AllTrim( mUSUARIO ) ) + AllTrim( mSENHA ), .T. ) )
      // mSENHA :=""  //apagar apos complemento harbour,vo,vb,xsharp permitir minusculas numeros e acentos
   ENDIF
   mUSUARIO  := XENCODE( mUSUARIO )
   mEQUIVALE := XENCODE( mEQUIVALE )
   mSENHA    := XENCODE( mSENHA, .F. )  // sem upper
   mVALIDADE := XENCODE( StrTran( DToC( mVALIDADE ), '/', '' ) )
   mCHAVE    := mUSUARIO

   RETURN .T.




// + EOF: fopto_4p.prg
// +
