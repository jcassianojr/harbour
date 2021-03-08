*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK58.PRG
*+
*+    Functions: Function GETMEMO()
*+               Function nade()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

#include "inkey.ch"

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function GETMEMO()
*+
*+    Called from ( getsys.prg   )   2 - procedure getapplykey()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
function GETMEMO( GET )

local aCARGO    := GET:CARGO
local ctempscrn
local acoords   := aCARGO[ 3 ]
local coldcolor := setcolor()
local nrow      := row()
local ncol      := col()

//Verifica Coordenadas
if valtype( aCOORDS ) # "A"
   aCORRDS := { 0, 0, 24, maxcol() }
endif
//Salva a tela
ctempscrn := savescreen( acoords[ 1 ], acoords[ 2 ], acoords[ 3 ], acoords[ 4 ] )

//Seta as Cores
if valtype( aCARGO[ 4 ] ) = "C"
   setcolor( aCARGO[ 4 ] )
endif

@ acoords[  1 ], acoords[ 2 ] to acoords[ 3 ], acoords[ 4 ]
@ acoords[  1 ], acoords[ 2 ] say 'Linha:' + spac( 5 ) + 'Coluna:'                         
@ acoords[  3 ], acoords[ 2 ] say 'Ctrl+W -> Grava, ESC -> Anula, Alt+T ->Teclas '         
setcursor( if( readinsert(), 1, 2 ) )
lstatus := acoords[ 1 ]
cstatus := acoords[ 2 ]

GET:VARPUT( GET:cargo[ 2 ] := memoedit( GET:cargo[ 2 ], acoords[ 1 ] + 1, acoords[ 2 ] + 1, acoords[ 3 ] - 1, acoords[ 4 ] - 1, .T., "NADE" ) )

GET:UPDATEBUFFER()
GET:DISPLAY()

restscreen( acoords[ 1 ], acoords[ 2 ], acoords[ 3 ], acoords[ 4 ], ctempscrn )
setcolor( coldcolor )
setpos( nrow, ncol )

return nil

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function nade()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func nade( modo, linha, coluna )

setcolor( "N/W" )
@ lstatus, cstatus + 7  say linha  pict '####'        
@ lstatus, cstatus + 19 say coluna pict '####'        
setcolor( "W/N" )
do case
case lastkey() = 418 
   XALTINS()
case lastkey() = K_ALT_H 
   XCAPTXT()
case lastkey() = K_ALT_J 
   XEDIWOR()
//case lastkey() = K_ALT_T 
//   TECLASHELP() 
//   retu ( 32 )
case lastkey() = K_ESC
   if MDG( 'Deseja Abandonar Altera‡”es' )
      @ 24, 00
      retu ( 0 )
   endif
   @ 24, 00
   retu ( 32 )
case lastkey() = K_CTRL_W 
   retu ( 23 )
endcase
retu 32

*+ EOF: DISK58.PRG
