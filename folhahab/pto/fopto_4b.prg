// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4b.prg
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


// Teclas Operacionais
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"

PEGPTOHOR( "XX", .T., .F. )   // Verifica indices

PADRAO( "FOPTOHOR", "FOPTOHOR", "' '+str(mNUMERO,8)+' '+mCODIGO+' '+STR(mENT,  6, 2)+' '+STR(mALMI,  6, 2)+' '+STR(mALMF,  6, 2)+' '+STR(mSAI,  6, 2)+' '+mVIRADA+' '+mFOLGASN", ;
      "mNUMERO", "FOPTO_4B - Horarios Basico", "Numero Cod Entrad Almoco       Saida V F", ;
      {|| iFOPTO4B() }, {|| tFOPTO4B() }, {|| gFOPTO4B() }, {|| FO_RELL( "PONTOCAD04" ) },, 2,,, "X" )
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iFOPTO4B

   mNUMERO := ULTIMOREG( "FOPTOHOR", "NUMERO", .T. )
   mCODIGO := "  "
   @ 24, 00 GET mNUMERO
   @ 24, 20 GET mCODIGO VALID !Empty( mCODIGO ) .AND. !verseha( "FOPTOHOR", 2, mCODIGO, "'Codigo Ja Cadastrado:'+NOME",, .T. ) .AND. !PEGFOLGA( mCODIGO )
   READCUR()
   mCHAVE := mNUMERO

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC tFOPTO4B

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  6, 2  SAY "Numero    Cod Ent    Refeicao" + spac( 5 ) + "Saida  Noite Folga"
   @  7, 35 SAY "S/N"
   @  8, 2  SAY "Descricao"
   @ 10, 2  SAY "Codigo de Apuracao "
   @ 11, 5  SAY "-"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4B

   @  7, 2  SAY mNUMERO
   @  7, 12 SAY mCODIGO
   @  7, 15 GET mENT     PICT '999.99'               WHEN INCLUI
   @  7, 22 GET mALMI    PICT '999.99'               WHEN INCLUI
   @  7, 29 GET mALMF    PICT '999.99'               WHEN INCLUI
   @  7, 36 GET mSAI     PICT '999.99'               WHEN INCLUI
   @  7, 43 GET mVIRADA  PICT "!"                    VALID mVIRADA $ " SN"  WHEN INCLUI .OR. Empty( mVIRADA )
   @  7, 50 GET mFOLGASN PICT "!"                    VALID mFOLGASN $ " SN" WHEN INCLUI .OR. Empty( mFOLGASN )
   @  8, 12 GET mNOME    WHEN PTO4B01() .AND. INCLUI
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PTO4B01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PTO4B01

   IF Empty( mNOME )
      mNOME := Str( mENT, 5, 2 ) + " "
      IF !Empty( mALMI )
         mNOME += Str( mALMI, 5, 2 ) + " "
         mNOME += Str( mALMF, 5, 2 ) + " "
      ENDIF
      mNOME += Str( mSAI, 5, 2 )
   ENDIF
   RETU .T.


// + EOF: fopto_4b.prg
// +
