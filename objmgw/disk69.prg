*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK69.PRG
*+
*+    Functions: Function GETFILE()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:55 am
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

#include "inkey.ch"

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function GETFILE()
*+
*+    Called from ( getsys.prg   )   2 - procedure getapplykey()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
function GETFILE( GET )

local aCARGO    := GET:CARGO
local ctempscrn := savescreen( 24, 0, 24, 79 )
local coldcolor := setcolor()
local nrow      := row()
local ncol      := col()
local nOPCAO
local cCAMINHO  := ""

priv aMENUPROMPTS := {}

// Posicionamento da matriz cargo
//     1     2      3        4          5        6        7
// {"FILE",<var>,<coords>,<(boxcol)>,<caminh>,<extens>,<impset>} ;

//Verifica Coordenadas
if valtype( aCARGO[ 3 ] ) # "A"
   aCORRDS := { 0, 0, 24, maxcol() }
endif

//Seta as Cores
if valtype( aCARGO[ 4 ] ) = "C"
   setcolor( aCARGO[ 4 ] )
endif

//Monta Caminho amplo
if valtype( aCARGO[ 5 ] ) = "C"         //Caminho
   cCAMINHO := alltrim( aCARGO[ 5 ] )
endif
if valtype( aCARGO[ 2 ] ) = "C"
   cCAMINHO += alltrim( aCARGO[ 2 ] )   //Nome do Arquivo
endif
if valtype( aCARGO[ 6 ] ) = "C"
   cCAMINHO += "." + alltrim( aCARGO[ 6 ] )                 //Extensao
endif

@ 24, 00 clea
OPCAO( 24, 10, " &Editar ", 69 )
OPCAO( 24, 30, " &Imprimir ", 73 )
OPCAO( 24, 50, " &Ver ", 86 )
nOPCAO := menu(, 0 )

do case
case nOPCAO = 1 
   EDITARQ( cCAMINHO )
case nOPCAO = 2
   if valtype( aCARGO[ 7 ] ) # "A"
      IMPARQ( cCAMINHO )
   else
      IMPARQ( cCAMINHO, aCARGO[ 7, 1 ], aCARGO[ 7, 2 ], aCARGO[ 7, 3 ], aCARGO[ 7, 4 ], ;
              aCARGO[ 7 ,  5 ], aCARGO[ 7 ,  6 ], aCARGO[ 7 ,  7 ], aCARGO[ 7 ,  8 ] )
   endif
case nOPCAO = 3 
   VERTXT( cCAMINHO )
endcase

restscreen( 24, 0, 24, 79, ctempscrn )
setcolor( coldcolor )
setpos( nrow, ncol )

return nil

*+ EOF: DISK69.PRG
