*+ýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýý
*+
*+    Source Module => DISK62.PRG
*+
*+    Functions: Function RELOGIO()
*+
*+
*+ýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýý

*+ññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññ
*+
*+    Function RELOGIO()
*+
*+ññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññ
*+
func RELOGIO( nROW )

static lRELOGIO := .F.
lRELOGIO := !lRELOGIO
if valtype( nROW ) # "N"
   nROW := 00
endif
if lRELOGIO
   SHOWTIME( nROW, 72, .T. )
else
   SHOWTIME()
   @ nROW, 72 clea to nROW, 79
endif

*+ EOF: DISK62.PRG
