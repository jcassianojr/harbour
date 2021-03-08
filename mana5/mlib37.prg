*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib37.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "box.ch"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MARCAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MARCAR(cTITULO)


local COR   := setcolor()
local aTELA := savescreen(18,15,21,70)
setcolor('N/W,'+zCOR002)
hb_dispbox(17,13,20,68,B_DOUBLE,'W')
if pcount() > 0
   @ 17,14 say " "+cTITULO+" "         
endif
@ 18,15 say spac(48)+"100%"         
setcolor('BG/W')
@ 19,16 say repl('±',50)         
setcolor(COR)
retu aTELA


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MARCAR1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MARCAR1


local COR := setcolor()
priv X
priv Y
priv PORC
setcolor(ZCOR010)
X    := xGRAF / GRAF * 50
Y    := xGRAF / GRAF * 100
X    := if(X > 50,50,X)
Y    := if(Y > 100,100,Y)
PORC := repl('Û',X)
setcolor('B/W')
@ 19,16 say PORC         
//IF X>2
//   @ 18,16+X-3 SAY SPAC(3)
//ENDIF
if Y > 99
   setcolor('N/W')
   @ 18,16       say spac(16+X - 2 - 16)                   
   @ 18,16+X - 2 say Y                   pict '999'        
   setcolor('B/W')
   @ 19,16 say PORC+'Û'         
else
   setcolor('N/W')
   @ 18,16       say spac(16+X - 1 - 16)                  
   @ 18,16+X - 1 say Y                   pict '99'        
endif
@ 18,col() say '%'         
xGRAF ++
setcolor(COR)
retu .T.

