*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    MLIB06.PRG
*+
*+    Function LERMOUSE() setas as variaves MOUSE_X,MOUSE_Y,MOUSE_B
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function LERMOUSE() setas as variaves MOUSE_X,MOUSE_Y,MOUSE_B
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func LERMOUSE( nKEY )
IF ! lMOUSE
  MOUSE_X := ROW()
  MOUSE_Y := COL()
  MOUSE_B := 0
  return nKEY
ENDIF
MOUSE_X := mcol()
MOUSE_Y := mrow()
MOUSE_B := 0
do case
    case nKey == K_LBUTTONDOWN 
       MOUSE_B := 1
    case nKey == K_RBUTTONDOWN 
       MOUSE_B := 2
    case nKey == K_LBUTTONDOWN .and. nKey == K_RBUTTONDOWN 
       MOUSE_B := 3   
       nKEY := K_ESC
    CASE nKey == K_LDBLCLK
       MOUSE_B := 4
       nKEY := K_ENTER
    CASE  nKey == K_MWFORWARD 
       MOUSE_B := 5
       nKEY := K_UP
    CASE  nKey == K_MWBACKWARD 
       MOUSE_B := 6
       nKEY := K_DOWN
endcase
return nkey


*+ EOF: MLIB06.PRG
