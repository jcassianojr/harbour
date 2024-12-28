// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo0m.prg
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

// :*****************************************************************************
// :
// :       FO0L.PRG: Cadastro de Tipos de Vale Transporte
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:05
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"

PADRAO( "VTCOMP", "VTCOMP", "' '+STR(mCODIGO)+' '+mDESCR+' '+STR(mVALOR, 10, 2)", "mCODIGO", "Codigos Vale Transporte", "Cod  Descricacao" + spac( 20 ) + "Atualiz. Valor", ;
      {|| PEGCHAVE( "mCODIGO", ULTIMOREG( "VTCOMP", "CODIGO", .T. ), "Codigo" ) }, {|| tFO0M() }, {|| gFO0M() }, {|| FO_RELL( "TABTRANS" ) } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO0M()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC tFO0M

   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  3, 1 SAY "Cod  Descri‡ao" + spac( 42 ) + "Valor"
   @  6, 1 SAY "C¢digos Qtde"
   @  7, 1 SAY "01-"
   @  8, 1 SAY "02-"
   @  9, 1 SAY "03-"
   @ 10, 1 SAY "04-"
   @ 11, 1 SAY "05-"
   @ 12, 1 SAY "06-"
   @ 13, 1 SAY "07-"
   @ 14, 1 SAY "08-"
   @ 15, 1 SAY "09-"
   @ 16, 1 SAY "10-"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO0M()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFO0M

   @  4, 1  SAY mCODIGO PICTURE '9999'
   @  4, 6  GET mDESCR
   @  4, 57 GET mVALOR  PICTURE '999999999.99'
   @  7, 4  GET mCOD01  PICTURE '9999'
   @  7, 9  GET mQTD01  PICTURE '999'
   @  8, 4  GET mCOD02  PICTURE '9999'
   @  8, 9  GET mQTD02  PICTURE '999'
   @  9, 4  GET mCOD03  PICTURE '9999'
   @  9, 9  GET mQTD03  PICTURE '999'
   @ 10, 4  GET mCOD04  PICTURE '9999'
   @ 10, 9  GET mQTD04  PICTURE '999'
   @ 11, 4  GET mCOD05  PICTURE '9999'
   @ 11, 9  GET mQTD05  PICTURE '999'
   @ 12, 4  GET mCOD06  PICTURE '9999'
   @ 12, 9  GET mQTD06  PICTURE '999'
   @ 13, 4  GET mCOD07  PICTURE '9999'
   @ 13, 9  GET mQTD07  PICTURE '999'
   @ 14, 4  GET mCOD08  PICTURE '9999'
   @ 14, 9  GET mQTD08  PICTURE '999'
   @ 15, 4  GET mCOD09  PICTURE '9999'
   @ 15, 9  GET mQTD09  PICTURE '999'
   @ 16, 4  GET mCOD10  PICTURE '9999'
   @ 16, 9  GET mQTD10  PICTURE '999'
   READCUR()
   RETU .T.

// + EOF: fo0m.prg
// +
