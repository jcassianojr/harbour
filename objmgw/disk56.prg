// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk56.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
// +
// +    Source Module => C:\DEVELOP\OBJ\DISK56.PRG
// +
// +    Functions: Function SCROLLBARNEW()
// +               Function SCROLLBARDISPLAY()
// +               Function SCROLLBARUPDATE()
// +               Function ACHRETB()
// +
// +    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
// +
// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊


#include "INKEY.CH"

#define  TB_UPARROW        CHR(024)
#define  TB_DNARROW        CHR(025)
#define  TB_BACKGROUND     CHR(176)
#define  TB_HIGHLIGHT      CHR(178)
#define  TB_ROWTOP         1
#define  TB_COLTOP         2
#define  TB_ROWBOTTOM      3
#define  TB_COLBOTTOM      4
#define  TB_COLOR          5
#define  TB_POSITION       6
#define  TB_ELEMENTS       6

/***
*  ScrollBarNew( <nTopRow>, <nTopColumn>, <nBottomRow>,
*     <cColorString>, <nInitPosition> ) --> aScrollBar
*
*  Create a new scroll bar array with the specified coordinates
*
*/

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function SCROLLBARNEW()
// +
// +    Called from ( mlib16.prg   )   1 - function basbro()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SCROLLBARNEW()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SCROLLBARNEW( NTOPROW, NTOPCOLUMN, NBOTTOMROW, ;
      ccolorstring, ninitposition )

   LOCAL ascrollbar := Array( TB_ELEMENTS )  // 6

   ascrollbar[ TB_ROWTOP ]    := ntoprow   // 1
   ascrollbar[ TB_COLTOP ]    := ntopcolumn  // 2
   ascrollbar[ TB_ROWBOTTOM ] := nbottomrow  // 3
   ascrollbar[ TB_COLBOTTOM ] := ntopcolumn  // 4

// cor padrao to White on Black if none specified
   IF ccolorstring == nil
      ccolorstring := "W/N"
   ENDIF
   ascrollbar[ TB_COLOR ] := ccolorstring  // 5

// Set the starting position
   IF ninitposition == nil
      ninitposition := 1
   ENDIF
   ascrollbar[ TB_POSITION ] := ninitposition  // 6

   RETURN ascrollbar

/***
*  ScrollBarDisplay( <aScrollBar> ) --> aScrollBar
*  Display a scoll bar array to the screen
*
*/

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function SCROLLBARDISPLAY()
// +
// +    Called from ( mlib16.prg   )   1 - function basbro()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SCROLLBARDISPLAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SCROLLBARDISPLAY( ASCROLLBAR )

   LOCAL coldcolor
   LOCAL nrow

   coldcolor := SetColor( ascrollbar[ TB_COLOR ] )

// Draw the arrows
   @ ascrollbar[ TB_ROWTOP ], ascrollbar[ TB_COLTOP ]       SAY TB_UPARROW
   @ ascrollbar[ TB_ROWBOTTOM ], ascrollbar[ TB_COLBOTTOM ] SAY TB_DNARROW

// Draw the background
   FOR nrow := ( ascrollbar[ TB_ROWTOP ] + 1 ) TO ( ascrollbar[ TB_ROWBOTTOM ] - 1 )
      @ nrow, ascrollbar[ TB_COLTOP ] SAY TB_BACKGROUND
   NEXT

   SetColor( coldcolor )

   RETURN ascrollbar

/***
*+  ScrollBarUpdate( <aScrollBar>, <nCurrent>, <nTotal>,
*+
*+     <lForceUpdate> ) --> aScrollBar
*+
*+
*+
*+  Update scroll bar array with new tab position and redisplay tab
*+
*+
*+
*+    Function SCROLLBARUPDATE()
*+
*+
*+
*+    Called from ( disk56.prg   )   1 - function achretb()
*+
*+                ( mlib16.prg   )   1 - function basbro()
*+
*+
*+
*/


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SCROLLBARUPDATE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SCROLLBARUPDATE( ascrollbar, ncurrent, ntotal, lforceupdate )

   LOCAL coldcolor
   LOCAL nnewposition
   LOCAL nscrollheight := ( ascrollbar[ TB_ROWBOTTOM ] - 1 ) - ;
      ( ascrollbar[ TB_ROWTOP ] )

   IF ntotal < 1
      ntotal := 1
   ENDIF

   IF ncurrent < 1
      ncurrent := 1
   ENDIF

   IF ncurrent > ntotal
      ncurrent := ntotal
   ENDIF

   IF lforceupdate == nil
      lforceupdate := .F.
   ENDIF

   coldcolor := SetColor( ascrollbar[ TB_COLOR ] )

// Determine the new position
   nnewposition := Round( ( ncurrent / ntotal ) * nscrollheight, 0 )

// Resolve algorythm oversights
   nnewposition := if( nnewposition < 1, 1, nnewposition )
   nnewposition := if( ncurrent == 1, 1, nnewposition )
   nnewposition := if( ncurrent >= ntotal, nscrollheight, nnewposition )

// Overwrite the old position (if different), then draw in the new one
   IF nnewposition <> ascrollbar[ TB_POSITION ] .OR. lforceupdate
      @ ( ascrollbar[ TB_POSITION ] + ascrollbar[ TB_ROWTOP ] ), ;
         ascrollbar[ TB_COLTOP ] SAY TB_BACKGROUND
      @ ( nnewposition + ascrollbar[ TB_ROWTOP ] ), ascrollbar[ TB_COLTOP ] SAY ;
         TB_HIGHLIGHT
      ascrollbar[ TB_POSITION ] := nnewposition
   ENDIF

   SetColor( coldcolor )

   RETURN ascrollbar

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function ACHRETB()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ACHRETB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ACHRETB( nStatus, nElement, nRelative )

   LOCAL nKEY := 0

   IF nStatus == 0
      SCROLLBARUPDATE( aSBAR, nElement, nSBAR, .T. )
   ENDIF
   nKEY := LastKey()
   IF nKEY > 0
      // CLEAR TYPEAHEAD
      // hb_keyClear()
   ENDIF
   DO CASE
   CASE nkey = K_ENTER   //
      RETU 1
   CASE nkey = K_ESC   //
      RETU 0
   CASE nkey = K_INS   // 22      Ins, Ctrl-V
      RETU 0
   CASE nkey = K_DEL   // 7       Del, Ctrl-G pEXC
      RETU 1
   CASE nkey = K_CTRL_ENTER  // 10       Ctrl-Enter pBUS
      RETU 0
   CASE nkey = K_CTRL_F2   // -21      Ctrl-F2 pBU1
      RETU 0
   CASE nkey = K_CTRL_F3   // -22      Ctrl-F3 pBU2
      RETU 0
   CASE nkey = K_CTRL_F4   // -23      Ctrl-F3 pBU3
      RETU 0
   CASE nkey = K_ALT_F1  // -30     Alt-F1 LK_ALT_F1
      RETU 1
   CASE nkey = K_ALT_F2  // -31     Alt-F2  LK_ALT_F2
      RETU 1
   CASE nkey = K_ALT_F3  // -32     Alt-F3  LK_ALT_F3
      RETU 1
   CASE nkey = K_ALT_F4  // -33     Alt-F4  LK_ALT_F4
      RETU 1
   CASE nkey = K_ALT_F5  // -34     Alt-F5  LK_ALT_F5
      RETU 1
   CASE nkey = K_ALT_F6  // -35     Alt-F6  LK_ALT_F6
      RETU 1
   CASE nkey = K_ALT_F7  // -36     Alt-F7  LK_ALT_F7
      RETU 1
   CASE nkey = K_ALT_F8  // -37     Alt-F8  LK_ALT_F8
      RETU 1
   CASE nkey = K_ALT_F9  // -38     Alt-F9  LK_ALT_F9
      RETU 1
   CASE nkey = K_ALT_F10   // -39    Alt-F10 LK_ALT_F10
      RETU 1
   CASE nkey = K_SH_F1   // -10     Shift-F1 LK_SHI_F1
      RETU 1
   CASE nkey = K_SH_F2   // -11     Shift-F2 LK_SHI_F2
      RETU 1
   CASE nkey = K_SH_F3   // -12      Shift-F3 LK_SHI_F3
      RETU 1
   CASE nkey = K_SH_F4   // -13      Shift-F4 LK_SHI_F4
      RETU 1
   CASE nkey = K_SH_F5   // -14      Shift-F5 LK_SHI_F5
      RETU 1
   CASE nkey = K_SH_F6   // -15      Shift-F6 LK_SHI_F6
      RETU 1
   CASE nkey = K_SH_F7   // -16      Shift-F7 LK_SHI_F7
      RETU 1
   CASE nkey = K_SH_F8   // -17     Shift-F8 LK_SHI_F8
      RETU 1
   CASE nkey = K_SH_F10  // -19    Shift-F10 LK_SHI_F9
      RETU 1
   CASE nkey = K_TAB   // 9     Tab, Ctrl-I LK_TAB
      RETU 1
   CASE nKEY = K_HOME  // HOME VIRA CTRL_PGUP
      KEYBOARD Chr( K_CTRL_PGUP )
      RETU 1
   CASE nKEY = K_END   // END  VIRA CTRL_PGDN
      KEYBOARD Chr( K_CTRL_PGDN )
      RETU 1
   OTHERWISE
      RETU 2
   ENDCASE
   RETU 2

// + EOF: DISK56.PRG

// + EOF: disk56.prg
// +
