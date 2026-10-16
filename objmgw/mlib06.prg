*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib06.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 16-Out-2026 as  4:13 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "INKEY.CH"

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function LERMOUSE() setas as variaves MOUSE_X,MOUSE_Y,MOUSE_B
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LERMOUSE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC LERMOUSE(nKEY)



IF !lMOUSE
   MOUSE_X := Row()
   MOUSE_Y := Col()
   MOUSE_B := 0
   RETURN nKEY
ENDIF
MOUSE_X := MCol()
MOUSE_Y := MRow()
MOUSE_B := 0
DO CASE
CASE nKey == K_LBUTTONDOWN
   MOUSE_B := 1
CASE nKey == K_RBUTTONDOWN
   MOUSE_B := 2
CASE nKey == K_LBUTTONDOWN .AND. nKey == K_RBUTTONDOWN
   MOUSE_B := 3
   nKEY    := K_ESC
CASE nKey == K_LDBLCLK
   MOUSE_B := 4
   nKEY    := K_ENTER
CASE nKey == K_MWFORWARD
   MOUSE_B := 5
   nKEY    := K_UP
CASE nKey == K_MWBACKWARD
   MOUSE_B := 6
   nKEY    := K_DOWN
ENDCASE

RETURN nkey




*+ EOF: mlib06.prg
*+
