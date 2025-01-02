// +--------------------------------------------------------------------
// +
// +    Programa  : recuger2.prg  ditor de Cartas
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 2-Jan-2025 as  7:33 pm
// +
// +--------------------------------------------------------------------
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RECUGER2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION RECUGER2()

   PADRAO( 'RECUEDIT', 'RECUEDIT', "' '+mARQUIVO+' '+mDESCRICAO+' '", "mARQUIVO", "Codigos", "Arquivo Descricao", ;
      {|| PEGCHAVE( "mARQUIVO", Space( 8 ), "Arquivo" ) }, {|| tREDIT() }, {|| gREDIT() }, {|| lREDIT() } )

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tREDIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tREDIT

   @ 10, 2  SAY "Nome do Arquivo do Texto :"
   @ 11, 2  SAY "Descri‡„o Do Arquivo :"
   @ 13, 2  SAY "Set-up Inicial de Impress„o:"
   @ 16, 03 SAY "Margem Esquerda    :"
   @ 17, 03 SAY "Margem Direita     :"
   @ 18, 03 SAY "Margem Superior    :"
   @ 19, 03 SAY "Margem Inferior    :"
   @ 20, 03 SAY "Linhas  Formul rio :"
   @ 21, 03 SAY "Colunas Formul rio :"

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gREDIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gREDIT

   @ 10, 31 SAY mARQUIVO
   @ 12, 2  GET mDESCRICAO
   @ 14, 2  GET mSETUP
   @ 16, 25 GET mMARESQ    PICT '##'
   @ 17, 25 GET mMARDIR    PICT '##'
   @ 18, 25 GET mMARSUP    PICT '##'
   @ 19, 25 GET mMARINF    PICT '##'
   @ 20, 25 GET mMARLIN    PICT '##'
   @ 21, 24 GET mMARCOL    PICT '###'
   READCUR()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function lREDIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION lREDIT

   mARQUIVO := ProfileString( "FOLHA.INI", "PATH", "RECUEDIT", "" ) + MEMVAR->mARQUIVO + ".txt"
   imparq( MEMVAR->marquivo, MEMVAR->msetup, MEMVAR->mmarlin, MEMVAR->mmarinf, MEMVAR->mmarsup, MEMVAR->mmaresq, MEMVAR->mmardir, MEMVAR->mmarcol )   // ,mgraf)

   RETURN .T.



// + EOF: recuger2.prg
// +
