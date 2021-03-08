*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib36.prg
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




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MDI(cMES,lFUN,lMES,cARQ)


local pCOR := setcolor()
if valtype(lFUN) # "L"
   lFUN := .T.
endif
if valtype(lMES) # "L"
   lMES := .T.
endif
setcolor(ZCOR002)
if valtype(cARQ) # "C"
   @ 01,00 say padr(cMES,80)         
else
   @ 01,00 say padr(cMES+OBTER(zARQ,padr(cARQ,8),trim("DESCRICAO")),80)         
endif
if lFUN
   MDF()
endif
if lMES
   @ 24,00
endif
setcolor(pCOR)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDF()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MDF


setcolor(ZCOR004)
@ 02,00 clear to 24 - 1,79
retu .T.

