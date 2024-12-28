// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib37.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "box.ch"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MARCAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MARCAR( cTITULO )

   LOCAL COR   := SetColor()
   LOCAL aTELA := SaveScreen( 18, 15, 21, 70 )

   SetColor( 'N/W,' + zCOR002 )
   hb_DispBox( 17, 13, 20, 68, B_DOUBLE, 'W' )
   IF PCount() > 0
      @ 17, 14 SAY " " + cTITULO + " "
   ENDIF
   @ 18, 15 SAY spac( 48 ) + "100%"
   SetColor( 'BG/W' )
   @ 19, 16 SAY repl( '±', 50 )
   SetColor( COR )
   RETU aTELA



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MARCAR1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MARCAR1

   LOCAL COR := SetColor()
   PRIV X
   PRIV Y
   PRIV PORC

   SetColor( ZCOR010 )
   X    := xGRAF / GRAF * 50
   Y    := xGRAF / GRAF * 100
   X    := if( X > 50, 50, X )
   Y    := if( Y > 100, 100, Y )
   PORC := repl( 'Û', X )
   SetColor( 'B/W' )
   @ 19, 16 SAY PORC
// IF X>2
// @ 18,16+X-3 SAY SPAC(3)
// ENDIF
   IF Y > 99
      SetColor( 'N/W' )
      @ 18, 16       SAY spac( 16 + X - 2 - 16 )
      @ 18, 16 + X - 2 SAY Y                   PICT '999'
      SetColor( 'B/W' )
      @ 19, 16 SAY PORC + 'Û'
   ELSE
      SetColor( 'N/W' )
      @ 18, 16       SAY spac( 16 + X - 1 - 16 )
      @ 18, 16 + X - 1 SAY Y                   PICT '99'
   ENDIF
   @ 18, Col() SAY '%'
   xGRAF++
   SetColor( COR )
   RETU .T.


// + EOF: mlib37.prg
// +
