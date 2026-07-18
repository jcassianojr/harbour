// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foal.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOAL.PRG: Inclus„o de uma ocorrencia
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :  Atualizado em: 18/11/97     11:32
// :
// :*****************************************************************************
#include "BOX.CH"

PADRAO( "FO_OCO", "FO_OCO", "' '+STR(mNUMERO,  8)+' '+mNOMEF+' '+mCODIGO+' '+DTOC(mDATASAIDA)+' '+DTOC(mDATARETORN)", "STR(mNUMERO,8)+DTOS(mDATASAIDA)", "Cadastro de Ocorrencias", "Numero   Nome:" + spac( 26 ) + "C. Saida    Retorno", ;
      {|| iFOAL() }, {|| tFOAL( .T. ) }, {|| gFOAL( .T. ) }, {|| FO_FOR( "GRUPO='FO_OCO'" ) } )
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC tFOAL( lFUNC )

   hb_DispBox( 3, 0, 23, 79, B_DOUBLE + " " )
   IF lFUNC
      @  4, 2 SAY "Depto Setor Se‡„o Chapa Numero   Nome:"
   ENDIF
   @  6, 2  SAY "C¢digo do Ocorrˆncia :    -"
   @  7, 16 SAY "Data     FGTS PAGO Dias"
   @  8, 2  SAY "Ocorrˆncia :"
   @  9, 2  SAY "Retorno    :"
   @ 13, 2  SAY "Conta de Lan‡amento:" + spac( 6 ) + "Valor Pago:" + spac( 15 ) + "Abate FGTS :"
   @ 15, 25 SAY "Dias pagos pela empresa :" + spac( 9 ) + "Termino :"
   @ 17, 2  SAY "Tem direito 13§ Sal rio :    Prazo M ximo Dias :" + spac( 9 ) + "Termino :"
   @ 19, 2  SAY "Obs:"
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOAL( lFUNC )

   IF lFUNC
      IF netuse( pes )   // AREDE(PES,PES,1)
         dbGoTop()
         IF dbSeek( mNUMERO )
            mDEPTO := DEPTO
            mSETOR := SETOR
            mSECAO := SECAO
            mCHAPA := CHAPA
            mNOMEF := NOME
         ENDIF
         dbCloseArea()
      ENDIF
      @  5, 2  SAY mDEPTO     PICTURE '9999'
      @  5, 9  SAY mSETOR     PICTURE '999'
      @  5, 15 SAY mSECAO     PICTURE '999'
      @  5, 20 SAY mCHAPA     PICTURE '99999'
      @  5, 26 SAY mNUMERO    PICTURE '99999999'
      @  5, 35 SAY mNOMEF
      @  8, 16 SAY mDATASAIDA
   ELSE
      @  8, 16 GET mDATASAIDA
   ENDIF
   @ 06, 30 SAY mNOME
   @ 15, 69 SAY mDATAFIMPA
   @ 17, 69 SAY mDATAFIM13



   @  7, 25 GET mCODIGO    VALID xFOAL( 1 )
   @  8, 25 GET mCODFGS    VALID Empty( mCODFGS ) .OR. CHECKTAB( "FDEM" + PadR( mCODFGS, 5 ), 24, 0, "Motivo n„o Cadastrado" )
   @  8, 31 GET mPGFGS     VALID mPGFGS $ "SN "
   @  8, 36 GET mDIASS     PICTURE '99'
   @  9, 16 GET mDATARETOR VALID Empty( mDATARETOR ) .OR. mDATARETOR >= mDATASAIDA
   @  9, 25 GET mCODFGR    VALID Empty( mCODFGR ) .OR. CHECKTAB( "FDEM" + PadR( mCODFGR, 5 ), 24, 0, "Motivo n„o Cadastrado" )
   @  9, 31 GET mPGFGR     VALID mPGFGR $ "SN "
   @  9, 36 GET mDIASR     PICTURE '99'
   @ 13, 23 GET mCONTA     PICTURE '999'
   @ 13, 40 GET mVALPG     PICTURE '999999999.99'
   @ 13, 67 GET mABTFGTS   VALID mABTFGTS $ "SN "
   @ 15, 52 GET mPERIODOPA PICTURE '999'                                                                           VALID xFOAL( 2 )
   @ 17, 28 GET mTEM_13_SA VALID mTEM_13_SA $ "SN "
   @ 17, 52 GET mPRAZOMAXI PICT '9999'                                                                             VALID xFOAL( 2 )
   @ 19, 7  GET mOBS
   @ 20, 7  GET mOBS2
   READCUR()
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION iFOAL

   @ 24, 00
   @ 24, 00 SAY "Numero e Data Ocorrencia"
   @ 24, 30 GET mNUMERO
   @ 24, 40 GET mDATASAIDA
   READCUR()
   mCHAVE := Str( mNUMERO, 8 ) + DToS( mDATASAIDA )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function xFOAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION xFOAL( nTIP )

   IF nTIP = 1
      IF netuse( "TABFALTA" )
         dbGoTop()
         IF dbSeek( mCODIGO )
            IF Empty( mNOME )
               mNOME := SubStr( NOME, 1, 30 )
            ENDIF
            IF Empty( mCODFGS )
               mCODFGS := CODFGS
            ENDIF
            IF Empty( mCODFOR )
               mCODFGR := CODFGR
            ENDIF
         ENDIF
         dbCloseArea()
      ENDIF
   ENDIF
   mDATAFIMPA := mDATASAIDA + mPERIODOPAG - 1
   mDATAFIM13 := mDATASAIDA + mPRAZOMAXIM - 1
   @ 06, 30 SAY mNOME
   @ 15, 69 SAY mDATAFIMPA
   @ 17, 69 SAY mDATAFIM13
   RETU .T.

// + EOF: foal.prg
// +
