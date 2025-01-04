// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4a.prg Alterar Cadastro De Faltas
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

FUNCTION fopto_4a()

   PADRAO( "TABFALTA", "TABFALTA", "mCODIGO+' '+mNOME", "mCODIGO", "FOPTO_4A - Codigos Faltas e Atrasos", "Codigo Descri‡„o", ;
      {|| PEGCHAVE( "mCODIGO", Space( 2 ), "Codigo:" ) }, {|| tFOPTO4A() }, {|| gFOPTO4A() }, {|| FO_RELL( "PONTOCAD03" ) },, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO4A()

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2 SAY "Codigo  Descricao"
   @  7, 2 SAY "Observa‡ao"
   @ 11, 3 SAY "Apura  Formula de Apuracao"
   @ 15, 2 SAY "Excluir da Apuracao Padrao"
   @ 16, 2 SAY "Codigos de importacao     "
   @ 17, 2 SAY "Codigos FGTS Entrada/Saida"
   @ 18, 2 SAY "Absenteismo Codigo/Justifica(S/N)"

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO4A

   @  6, 2  SAY mCODIGO
   @  6, 10 GET mNOME
   @  8, 2  GET mOBS
   @ 12, 5  GET mAPURA    VALID mAPURA $ "SN "                                                                    PICT "!"
   @ 12, 10 GET mFORMULA
   @ 15, 30 GET mMACPAD   VALID mMACPAD $ "SN "                                                                   PICT "!"
   @ 16, 30 GET mCODIMP01
   @ 16, 35 GET mCODIMP02
   @ 17, 30 GET mCODFGS   VALID Empty( mCODFGS ) .OR. CHECKTAB( "FDEM" + PadR( mCODFGS, 5 ), 24, 0, "Motivo nao Cadastrado" )
   @ 17, 35 GET mCODFGR   VALID Empty( mCODFGR ) .OR. CHECKTAB( "FDEM" + PadR( mCODFGR, 5 ), 24, 0, "Motivo nao Cadastrado" )
   @ 18, 37 GET mRHABCOD
   @ 18, 41 GET mRHABJUST VALID mRHABJUST $ "SN "                                                                 PICT "!"
   READCUR()

   RETURN .T.

// + EOF: fopto_4a.prg
// +
