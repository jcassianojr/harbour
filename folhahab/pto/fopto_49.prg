// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_49.prg
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

FUNCTION fopto_49()

   PADRAO( "FOPTOEVE", "FOPTOEVE", "STR(mDIA,2)+' '+STR(mMES,2)+' '+mCODIGO+' '+mDESCRICAO", "STR(mDIA,2)+STR(mMES,2)", "FOPTO_49 - Feriados", "Dia Mˆs Codigo Descri‡„o", ;
      {|| iFOPTO49() }, {|| tFOPTO49() }, {|| gFOPTO49() }, {|| FO_RELL( "PONTOCAD02" ) },, 2 )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO49()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gFOPTO49

// Get nas Menvars
   @  9, 13 GET mDIA       PICT '99'
   @ 10, 13 GET mMES       PICT '99'
   @ 11, 13 GET mCODIGO
   @ 12, 13 GET mDESCRICAO
   @ 13, 13 GET mBCOSN     PICT "!"  VALID mBCOSN $ "SN "
   @ 13, 51 GET mREDSN     PICT "!"  VALID mREDSN $ "SN "
   @ 14, 13 GET mFOLSN     PICT "!"  VALID mFOLSN $ "SNM "
   READCUR()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO49()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iFOPTO49

   MDS( "Digite a Data e o Mes :" )
   @ 24, 50 GET mDIA
   @ 24, 60 GET mMES
   READCUR()
   mCHAVE := Str( mDIA, 2 ) + Str( mMES, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO49()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO49

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  9, 1  SAY "Dia" + spac( 7 ) + ":    Dia do Mˆs ou Dia da Semana Conforme Tabela Abaixo"
   @ 10, 1  SAY "Mes" + spac( 7 ) + ":    Deixe em Branco Para dia da Semana"
   @ 11, 1  SAY "Codigo    :"
   @ 12, 1  SAY "Descricao :"
   @ 13, 1  SAY "Banco Hora:   (S)im (N)„o" + spac( 8 ) + "Reducao Jornada:    (S)im (N)ao"
   @ 14, 1  SAY "Folga     :   (S)im (N)„o"
   @ 15, 13 SAY "1 - Domingo"
   @ 16, 13 SAY "2 - Segunda"
   @ 17, 13 SAY "3 - Ter‡a"
   @ 18, 13 SAY "4 - Quarta"
   @ 19, 13 SAY "5 - Quinta"
   @ 20, 13 SAY "6 - Sexta"
   @ 21, 13 SAY "7 - S bado"

   RETURN .T.


// + EOF: fopto_49.prg
// +
