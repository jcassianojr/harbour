// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4r.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// ******************************************************************************
// :
// :  FOPTO_4R.PRG :
// :     Linguagem : harbour
// :        Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto_4r()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_4r

   PARA nTIPO

   cARQ    := "XXXX"
   cTIPVID := "T"
   IF nTIPO = 1  // Atuais
      carq := IF( lSECBCO, "BCOBAK", "BCOHRS" )
      IF zFECHADO = "S"
         cTIPVID := "V"
      ENDIF
   ENDIF
   IF nTIPO = 2  // Arquivados
      carq    := IF( lSECBCO, "BCODEK", "BCODEM" )
      cTIPVID := "V"
   ENDIF




   PADRAO( cARQ, cARQ, ;
      "STR(mNUMERO,6)+' '+STR(mANO,4)+' '+STR(mMES,2)+' '+STR(mSALANT,7,2)+' '+STR(mCREDITO,7,2)+' '+STR(mDEBITO,7,2)+' '+STR(mSALDO,7,2)+' '+STR(mDIAANT,7,2)+' '+STR(mDIACRE,7,2)+' '+STR(mDIADEB,7,2)+' '+STR(mDIASAL,7,2)" ;
      , "STR(mNUMERO,8)+STR(mANO,4)+STR(mMES,2)", ;
      "FOPTO_4R - Saldo Banco de Horas", ;
      "Numero   Ano Mes Anterior     Credito" + spac( 6 ) + "Debito" + spac( 7 ) + "Saldo", ;
      {|| iFOPTO4R() }, {|| tFOPTO4R() }, {|| gFOPTO4R() }, {|| ALLTRUE() }, .T., 2,,, cTIPVID )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4R()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iFOPTO4R

   MDS( 'Digite Func Ano Mes' )
   @ 24, 30 GET mNUMERO
   @ 24, 40 GET mANO
   @ 24, 50 GET mMES
   mCHAVE := Str( mNUMERO, 8 ) + Str( mANO, 4 ) + Str( mMES, 2 )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4R()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4R

   @  6, 2  SAY mNUMERO  PICT '99999999'
   @  6, 11 SAY mANO     PICT '9999'
   @  6, 16 SAY mMES     PICT '99'
   @  7, 19 GET mSALANT  PICT '999999999.99' VALID cFOPTO4R()
   @  7, 32 GET mCREDITO PICT '999999999.99' VALID cFOPTO4R()
   @  7, 45 GET mDEBITO  PICT '999999999.99' VALID cFOPTO4R()
   @  7, 58 SAY mSALDO   PICT '999999999.99'
   @  8, 19 GET mDIAANT  PICT '999999999.99' VALID cFOPTO4R2()
   @  8, 32 GET mDIACRE  PICT '999999999.99' VALID cFOPTO4R2()
   @  8, 45 GET mDIADEB  PICT '999999999.99' VALID cFOPTO4R2()
   @  8, 58 SAY mDIASAL  PICT '999999999.99'
   READCUR()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4R()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4R

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2 SAY "Numero   Ano Mes Anterior     Credito" + spac( 6 ) + "Debito" + spac( 7 ) + "Saldo"
   @  7, 2 SAY "Horas"
   @  8, 2 SAY "Dias"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function cFOPTO4R()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC cFOPTO4R

   mSALDO := mSALANT + mCREDITO - mDEBITO
   @  7, 58 SAY mSALDO PICTURE '999999999.99'
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function cFOPTO4R2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC cFOPTO4R2

   mDIASAL := mDIAANT + mDIACRE - mDIADEB
   @  8, 58 SAY mDIASAL PICTURE '999999999.99'
   RETU .T.

// : FIM: FOPTO_4R.PRG

// + EOF: fopto_4r.prg
// +
