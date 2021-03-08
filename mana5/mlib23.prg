*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib23.prg
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
*+    Function PEGACAMPO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEGACAMPO(cARQUIVO,cBUSCA,cVARBUSCA,cVARGRAVA,nIND,lVAZIO,lOPEN,aPAD)


local lRET   := .T.
local X
local dbfuso := alias()
if valtype(nIND) # "N"
   nIND := 1
endif
if empty(cARQUIVO)  //Fixas buscar de referencia manter
   gravavars(cVARGRAVA,aPAD)
   retu .F.
endif
if valtype(lOPEN) # "L"
   lOPEN := .T.
endif
if valtype(lVAZIO) = "L"
   if lVAZIO
      if empty(&cBUSCA)
         gravavars(cVARGRAVA,aPAD)
         retu .T.
      endif
   endif
endif
if lOPEN
   if !USEREDE(cARQUIVO,1,nIND)
      gravavars(cVARGRAVA,aPAD)
      retu .F.
   endif
else
   dbselectar(cARQUIVO)
endif
dbgotop()
if dbseek(&cBUSCA.)
   if valtype(cVARGRAVA) = "C" .and. valtype(cVARBUSCA) = "C"
      &cVARGRAVA. := &cVARBUSCA.
   else
      gravavars(cVARGRAVA,cvarbusca)
   endif
else
   gravavars(cVARGRAVA,aPAD)
   lRET := .F.
endif
if lOPEN
   dbclosearea()
endif
if !empty(dbfuso)
   dbselectar(dbfuso)
endif
return lRET


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVAVARS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func GRAVAVARS(aCam,Aval)

local x
local campo
local valor
if valtype(aCAM) = "A" .and. valtype(aVal) = "A"
   for X := 1 to len(aCAM)
      campo   := aCAM[X]
      valor   := aVAL[X]
      &campo. := &valor.
   next X
endif



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVAVAR2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func GRAVAVAR2(aDAD)

GRAVAVARS(aDAD[1],aDAD[2])

