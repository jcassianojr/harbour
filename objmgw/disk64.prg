*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    DISK64.PRG
*+
*+    Functions: Function VERTXT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function VERTXT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func VERTXT( cARQ, cCOR1, cCOR2, aPOS, lTELA )

local nLINI := 0
local nCOLI := 0
local nLINF := 24
local nCOLF := 79
LOCAL aAMB
if valtype( lTELA ) # "L"
   lTELA := .T.
endif
if valtype( aPOS ) = "A"
   nLINI := aPOS[ 1 ]
   nCOLI := aPOS[ 2 ]
   nLINF := aPOS[ 3 ]
   nCOLF := aPOS[ 4 ]
endif
aAMB:=SALVAA()
if ! FILE( cARQ )
   restaa(aAMB)  
   ALERTX( 'Nao Encontrei Este Arquivo' )
   return .F.
endif
cls
setcolor( if( valtype( cCOR1 ) # "C", "N/W", cCOR1 ) )
@ nLINI, nCOLI clear to nLINF, nCOLF
@ nLINF, nCOLI say '[Arq.:' + cARQ + ']'                                                                                                                 
@ nLINI, nCOLI say "       " + spac( 6 ) + "           нн Mover: " + chr( 24 ) + " " + chr( 25 ) + " PGUP PGDN  HOME  END          н Sair: ESC "         
setcolor( if( valtype( cCOR2 ) # "C", "W/R", cCOR2 ) )
FILEVIEWG( cARQ, nLINI + 1, nCOLI, nLINF - 1, nCOLF, , cARQ, )
restaa(aAMB)  
return

*+ EOF: DISK64.PRG
