// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo3a.prg
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
caRQCUR := PEGCAMINI( "CURSO" ) + "CURSO"


PADRAO( "FUNCAO", "FUNCAO", "' '+STR(mCODIGO,  4)+' '+mNOME+' '+mFAIXA+' '+STR(mVALOR, 11, 2)+' '+mCBONEW", "mCODIGO", "Cadastro de Funcoes", "Cod.  Nome" + spac( 37 ) + "Ni Valor" + spac( 7 ) + "CBO", ;
      {|| PEGCHAVE( "mCODIGO", ULTIMOREG( "FUNCAO", "CODIGO", .T. ), "Funcao:" ) }, "FUNC01", {|| gFO3A() }, {|| FO_FOR( "GRUPO='FUNCAO'" ) } )
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO3A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gFO3A

   EDITSAY( "FUNC01" )
   TELASAY( "FUNC02" )
   EDITSAY( "FUNC02" )
   TELASAY( "FUNC03" )
   EDITSAY( "FUNC03" )
   IF MDG( "Alterar Cursos Necessarios" )
      xCODIGO := mCODIGO
      PADRAO( "FUNCAC", "FUNCAC", "' '+STR(mCODIGO,  4)+' '+mCURSO+' '+mDESCUR", "STR(mCODIGO,4)+mCURSO", "Cadastro de Fun‡”es/Cursos", "Funcao Curso    Descricao", ;
         {|| iFO3AA() }, {|| tFO3AA() }, {|| gFO3AA() }, {|| FO_FOR( "GRUPO='FUNCAC'" ) }, { .F., "CODIGO=xCODIGO", .F. } )
      mCODIGO := xCODIGO
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO3AA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION tFO3AA

   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  3, 1 SAY "Funcao Curso" + spac( 6 ) + "Descri‡„o"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO3AA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gFO3AA

   VERSEHA( CARQCUR,, mCURSO, "DESCUR", '"CURSO N„o CadastradO"', .T., { { "DESCUR", "mDESCUR" } } )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFO3AA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION iFO3AA

   MDS( 'Codigo do Curso: ' )
   @ 24, 40 GET mCURSO VALID VERSEHA( CARQCUR,, mCURSO, "DESCUR", '"CURSO N„o CadastradO"', .T., { { "DESCUR", "mDESCUR" } } )
   READCUR()
   mCODIGO := xCODIGO
   mCHAVE  := Str( xCODIGO, 4 ) + mCURSO
   RETU .T.

// + EOF: fo3a.prg
// +
