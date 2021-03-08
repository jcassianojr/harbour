*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK56.PRG
*+
*+    Functions: Function SCROLLBARNEW()
*+               Function SCROLLBARDISPLAY()
*+               Function SCROLLBARUPDATE()
*+               Function ACHRETB()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊


#INCLUDE "INKEY.CH"

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

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function SCROLLBARNEW()
*+
*+    Called from ( mlib16.prg   )   1 - function basbro()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
function SCROLLBARNEW( NTOPROW, NTOPCOLUMN, NBOTTOMROW, ;
                   ccolorstring, ninitposition )

local ascrollbar := array( TB_ELEMENTS )                    //6

ascrollbar[ TB_ROWTOP ]    := ntoprow   //1
ascrollbar[ TB_COLTOP ]    := ntopcolumn                    //2
ascrollbar[ TB_ROWBOTTOM ] := nbottomrow                    //3
ascrollbar[ TB_COLBOTTOM ] := ntopcolumn                    //4

// cor padrao to White on Black if none specified
if ccolorstring == nil
   ccolorstring := "W/N"
endif
ascrollbar[ TB_COLOR ] := ccolorstring  //5

// Set the starting position
if ninitposition == nil
   ninitposition := 1
endif
ascrollbar[ TB_POSITION ] := ninitposition                  //6

return ascrollbar

/***
*  ScrollBarDisplay( <aScrollBar> ) --> aScrollBar
*  Display a scoll bar array to the screen
*
*/

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function SCROLLBARDISPLAY()
*+
*+    Called from ( mlib16.prg   )   1 - function basbro()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
function SCROLLBARDISPLAY( ASCROLLBAR )

local coldcolor
local nrow

coldcolor := setcolor( ascrollbar[ TB_COLOR ] )

// Draw the arrows
@ ascrollbar[ TB_ROWTOP ], ascrollbar[ TB_COLTOP ]       say TB_UPARROW         
@ ascrollbar[ TB_ROWBOTTOM ], ascrollbar[ TB_COLBOTTOM ] say TB_DNARROW         

// Draw the background
for nrow := ( ascrollbar[ TB_ROWTOP ] + 1 ) to ( ascrollbar[ TB_ROWBOTTOM ] - 1 )
   @ nrow, ascrollbar[ TB_COLTOP ] say TB_BACKGROUND         
next

setcolor( coldcolor )

return ascrollbar

/***
*+  ScrollBarUpdate( <aScrollBar>, <nCurrent>, <nTotal>,
*+     <lForceUpdate> ) --> aScrollBar
*+
*+  Update scroll bar array with new tab position and redisplay tab
*+
*+    Function SCROLLBARUPDATE()
*+
*+    Called from ( disk56.prg   )   1 - function achretb()
*+                ( mlib16.prg   )   1 - function basbro()
*+
*/

function SCROLLBARUPDATE( ascrollbar, ncurrent, ntotal, lforceupdate )

local coldcolor
local nnewposition
local nscrollheight := ( ascrollbar[ TB_ROWBOTTOM ] - 1 ) - ;
                         ( ascrollbar[ TB_ROWTOP ] )

if ntotal < 1
   ntotal := 1
endif

if ncurrent < 1
   ncurrent := 1
endif

if ncurrent > ntotal
   ncurrent := ntotal
endif

if lforceupdate == nil
   lforceupdate := .F.
endif

coldcolor := setcolor( ascrollbar[ TB_COLOR ] )

// Determine the new position
nnewposition := round( ( ncurrent / ntotal ) * nscrollheight, 0 )

// Resolve algorythm oversights
nnewposition := if( nnewposition < 1, 1, nnewposition )
nnewposition := if( ncurrent == 1, 1, nnewposition )
nnewposition := if( ncurrent >= ntotal, nscrollheight, nnewposition )

// Overwrite the old position (if different), then draw in the new one
if nnewposition <> ascrollbar[ TB_POSITION ] .or. lforceupdate
   @ ( ascrollbar[ TB_POSITION ] + ascrollbar[ TB_ROWTOP ] ), ;
       ascrollbar[ TB_COLTOP ] say TB_BACKGROUND
   @ ( nnewposition + ascrollbar[ TB_ROWTOP ] ), ascrollbar[ TB_COLTOP ] say ;         
      TB_HIGHLIGHT
   ascrollbar[ TB_POSITION ] := nnewposition
endif

setcolor( coldcolor )

return ascrollbar

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function ACHRETB()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
function ACHRETB( nStatus, nElement, nRelative )
local nKEY:=0
if nStatus == 0
   SCROLLBARUPDATE( aSBAR, nElement, nSBAR, .T. )
endif
nKEY:=lastkey()
if nKEY>0
   //CLEAR TYPEAHEAD
   //hb_keyClear()
ENDIF   
do case
	case nkey= K_ENTER               //
	   retu 1
	case nkey= K_ESC               //
	   retu 0
	case nkey= K_INS  				// 22      Ins, Ctrl-V 
	   retu 0
	case nkey= K_DEL                //   7       Del, Ctrl-G pEXC 
	   retu 1
	case nkey= K_CTRL_ENTER        //    10       Ctrl-Enter pBUS 
	   retu 0
	case nkey= K_CTRL_F2          //     -21      Ctrl-F2 pBU1 
	   retu 0
	case nkey= K_CTRL_F3       //        -22      Ctrl-F3 pBU2 
	   retu 0
	case nkey= K_CTRL_F4       //        -23      Ctrl-F3 pBU3 
	   retu 0
	case nkey= K_ALT_F1               // -30     Alt-F1 LK_ALT_F1
	   retu 1
	case nkey= K_ALT_F2              //  -31     Alt-F2  LK_ALT_F2 
	   retu 1
	case nkey= K_ALT_F3             //   -32     Alt-F3  LK_ALT_F3 
	   retu 1
	case nkey= K_ALT_F4             //   -33     Alt-F4  LK_ALT_F4 
	   retu 1
	case nkey= K_ALT_F5            //    -34     Alt-F5  LK_ALT_F5 
	   retu 1
	case nkey= K_ALT_F6           //     -35     Alt-F6  LK_ALT_F6 
	   retu 1
	case nkey= K_ALT_F7           //     -36     Alt-F7  LK_ALT_F7 
	   retu 1
	case nkey= K_ALT_F8           //     -37     Alt-F8  LK_ALT_F8 
	   retu 1
	case nkey= K_ALT_F9           //     -38     Alt-F9  LK_ALT_F9 
	   retu 1
	case nkey= K_ALT_F10         //       -39    Alt-F10 LK_ALT_F10 
	   retu 1	   
	case nkey= K_SH_F1           //      -10     Shift-F1 LK_SHI_F1 
	   retu 1
	case nkey= K_SH_F2          //       -11     Shift-F2 LK_SHI_F2 
	   retu 1
	case nkey= K_SH_F3           //      -12      Shift-F3 LK_SHI_F3 
	   retu 1
	case nkey= K_SH_F4            //     -13      Shift-F4 LK_SHI_F4 
	   retu 1
	case nkey= K_SH_F5            //     -14      Shift-F5 LK_SHI_F5 
	   retu 1
	case nkey= K_SH_F6           //      -15      Shift-F6 LK_SHI_F6 
	   retu 1
	case nkey= K_SH_F7           //      -16      Shift-F7 LK_SHI_F7 
	   retu 1
	case nkey= K_SH_F8            //     -17     Shift-F8 LK_SHI_F8 
	   retu 1
	case nkey= K_SH_F10          //      -19    Shift-F10 LK_SHI_F9 
	   retu 1
	case nkey= K_TAB                 //  9     Tab, Ctrl-I LK_TAB 
	   retu 1
	case nKEY = K_HOME                 //HOME VIRA CTRL_PGUP
	   keyboard chr( K_CTRL_PGUP )
	   retu 1
	case nKEY = K_END                  //END  VIRA CTRL_PGDN
	   keyboard chr( K_CTRL_PGDN )
	   retu 1
	otherwise 
	   retu 2
	endcase
retu 2

*+ EOF: DISK56.PRG
