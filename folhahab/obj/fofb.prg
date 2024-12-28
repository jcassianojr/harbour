// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fofb.prg
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
// :       FOFB.PRG: Cadastro de Mensagens nos Holleriths
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 10/03/99
// :
// :*****************************************************************************

#include "BOX.CH"

PADRAO( "MESHOL", "MESHOL", "' '+mNOME+' '+LEFT(mMES1,50)", "mNOME", "Cadastro de Mensagens", "Nome Mensagem", ;
      {|| PEGCHAVE( "mNOME", Space( 6 ), "Codigo:" ) }, {|| MESHOLT() }, {|| MESHOLG() }, {|| FO_FOR( "GRUPO='MESHOL'" ) } )
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MESHOLG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MESHOLG

   @ 11, 26 GET mNOME
   @ 14, 26 GET mMES1
   @ 16, 26 GET mMES2
   @ 18, 26 GET mMES3
   READCUR()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MESHOLT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MESHOLT

   hb_DispBox( 8, 0, 20, 78, B_DOUBLE + " " )
   @ 11, 13 SAY "Mensagem  " + Chr( 16 ) + SPAC( 10 ) + Chr( 17 )
   @ 14, 13 SAY "1  Linha " + Chr( 26 )
   @ 16, 13 SAY "2  Linha " + Chr( 26 )
   @ 18, 13 SAY "3  Linha " + Chr( 26 )
   @ 08, 00 SAY " - "
   @ 08, 03 SAY SPAC( 23 ) + "Mensagens  Para  Holleriths" + SPAC( 26 )
   hb_Scroll( 09, 79, 21, 79 )
   @ 21, 01 SAY SPAC( 78 )
   RETU .T.

// : FIM: FOFB.PRG

// + EOF: fofb.prg
// +
