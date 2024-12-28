// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo3g.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "BOX.CH"

caRQCUR  := PEGCAMINI( "CURSO" ) + "CURSO"
caRQmp05 := PEGCAMINI( "MP05" ) + "MP05"
cARQTRE  := PEGCAMINI( "TREIN" ) + "TREIN"
cARQTRI  := PEGCAMINI( "TREII" ) + "TREII"

PADRAO( cARQTRE, cARQTRE, "' '+STR(mTREIN,  8)+' '+mCURSO", "mTREIN", "Cadastro de Treinamentos", "Treinto  Curso", ;
      {|| PEGCHAVE( "mTREIN", ULTIMOREG( cARQTRE, "TREIN", .T. ), "Treinamento:" ) }, {|| tFO3G() }, {|| gFO3G() }, {|| FO_FOR( "GRUPO='TREIN'" ) } )
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO3G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gFO3G

   @  4, 1  SAY mTREIN PICTURE '99999999'
   @  4, 10 GET mCURSO VALID VERSEHA( cARQCUR,, mCURSO, "DESCUR", '"Curso N„o CadastradO"', .T., ;
      { { "DESCUR", "mDESCUR" }, { "CARGA", "mCARGA" }, { "TIPCUR", "mTIPCUR" }, { "CERT", "mCERT" } } )
   @  4, 21 GET mDESCUR
   @  6, 1  GET mCARGA   PICTURE '99999.99'
   @  6, 10 GET mTIPCUR
   @  6, 24 GET mCERT
   @  6, 36 GET mDATACUR
   @  6, 45 GET mDATFIM
   @  6, 54 GET mHORINI  PICTURE '99.99'
   @  6, 61 GET mHORFIM  PICTURE '99.99'
   @  8, 1  GET mNINSTU  PICTURE '99999999'                                                                        VALID VERSEHA( PES,, mNINSTU, "NOME", '"Funcionario N„o CadastradO"', .T., { { "NOME", "mINSTRU" } } )
   @  8, 10 GET mINSTRU
   @ 10, 1  GET mAREA    VALID VERSEHA( cARQMP05,, mAREA, "DESCRI", '"AREA N„o Cadastrada"', .T., { { "RESPON", "mRESPO" } } )
   @ 10, 6  GET mRESPO
   READCUR()
   IF MDG( "Deseja Alterar Participantes" )
      xTREIN := mTREIN
      PADRAO( cARQTRI, cARQTRI, "' '+STR(mTREIN,8)+' '+STR(mNUMFUN,8)+' '+mNOMFUN+' '+mCOMPAR+' '+mAVALIA", "STR(mTREIN,8)+STR(mNUMFUN,8)", "Participantes Treinamento", "Treinto  Funcionario" + spac( 39 ) + "C A", ;
         {|| iFO3GA() }, {|| tFO3GA() }, {|| gFO3GA() }, {|| FO_FOR( "GRUPO='TREII'" ) }, { .F., "TREIN=XTREIN", .F. } )
      mTREIN := xTREIN
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO3G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFO3G

   hb_DispBox( 2, 0, 23, 79, B_SINGLE + " " )
   @  3, 1  SAY "Treinto  Curso"
   @  5, 1  SAY "Carga    T (I-Interno) Certificado Data     Fim" + spac( 6 ) + "hr.Ini hr.Fim"
   @  6, 12 SAY "(E-Externo)   (S/N)"
   @  7, 1  SAY "Instrutor"
   @  9, 1  SAY "Area Responsavel"
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO3GA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFO3GA

   hb_DispBox( 2, 0, 23, 79, B_SINGLE + " " )
   @  3, 1 SAY "Treinto  Funcionario"
   @  5, 1 SAY "Compareceu  Avalia‡„o"
   @  6, 3 SAY "(S/N)" + spac( 7 ) + "(S/N)"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO3GA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFO3GA

   VERSEHA( PES,, mNUMFUN, "NOME", '"Funcionario N„o CadastradO"', .T., { { "NOME", "mNOMFUN" } } )
   @  4, 1  SAY mTREIN  PICTURE '99999999'
   @  4, 10 SAY mNUMFUN PICTURE '99999999'
   @  4, 19 SAY mNOMFUN
   @  6, 1  GET mCOMPAR VALID mCOMPAR $ "SN"
   @  6, 13 GET mAVALIA VALID mAVALIA $ "SN"
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFO3GA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iFO3GA

   MDS( 'Funcionario Numero : ' )
   @ 24, 40 GET mNUMFUN VALID VERSEHA( PES,, mNUMFUN, "NOME", '"Funcionario N„o CadastradO"', .T., { { "NOME", "mNOMFUN" } } )
   READCUR()
   mTREIN := xTREIN
   mCHAVE := Str( xTREIN, 8 ) + Str( mNUMFUN, 8 )
   RETU .T.

// + EOF: fo3g.prg
// +
