// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk01.prg
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

// **
// ** DISK01.PRG   : Nome do Programa
// ** Gerado em    : Mar‡o 31, 1994
// ** Programador  : Softec Sistemas
// ** Linguagem    : Clipper 5.x
// **

#include "BOX.CH"

// *******************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAPT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC GRAPT( cTITULO )   // Marca a evolucao da transferencia do arquivo

// *******************
   TMARCAR := SaveScreen( 18, 15, 21, 70 )
   SetColor( "N/BG" )
   hb_DispBox( 17, 13, 20, 68, B_DOUBLE + " " )
   SetColor( "+GR/BG" )
   hb_Scroll( 18, 14, 19, 67 )
   @ 17, 14 SAY " " + cTITULO + " "
   @ 18, 15 SAY SPAC( 48 ) + "100%"
   @ 19, 16 SAY REPL( 'Ý', 50 )
   MDS( "Transferindo dados, Aguarde ..." )
   RETU TMARCAR

// ***********

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAPS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRAPS  // Marca a evolucao da transferencia do arquivo

// ***********
   PRIV X, Y
   SetColor( "R" )
   X    := GRAPP / GRAPT * 50
   Y    := GRAPP / GRAPT * 100
   PORC := REPL( 'Ý', X )
   @ 19, 16 SAY PORC
   SetColor( "+GR/BG" )
   IF X > 2
      @ 18, 16 + X - 3 SAY SPAC( 3 )
   END
   IF Y > 99
      @ 18, 16 + X - 2 SAY Y PICT '999'
      SetColor( "R" )
      @ 19, 16 SAY PORC + 'Ý'
      SetColor( "+GR/BG" )
   ELSE
      @ 18, 16 + X - 1 SAY Y PICT '99'
   END
   @ 18, Col() SAY '%'
   SetColor( "W/N,N/W" )
   GRAPP++
   RETU

// + EOF: disk01.prg
// +
