*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib07.prg
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
*+    Function CRIARVARS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CRIARVARS(ARQWORK,lTIPO,lOPEN)


if valtype(lTIPO) <> "L"
   lTIPO := .T.
endif
if valtype(lOPEN) <> "L"
   lOPEN := .T.
endif
if lOPEN
   if !USEREDE(ARQWORK,1,0)
      retu
   endif
endif
INITVARS()
if lTIPO
   CLRVARS()
endif
dbclosearea()
retu .T.

