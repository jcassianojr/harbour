*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib28.prg
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
*+    Function ULTIMOREG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ULTIMOREG(ARQWORK,FIEWORK,eVAR,lSOMA,nIND,lOPEN)


if valtype(lOPEN) # "L"
   lOPEN := .T.
endif
if valtype(nIND) # "N"
   nIND := 1
endif
if valtype(lSOMA) # "L"
   lSOMA := .T.
endif
if type("cVIDE") = "C"
   if cVIDE = "T"
      lOPEN := .F.
   endif
endif
if lOPEN
   if !USEREDE(ARQWORK,1,nIND)
      retu 0
   endif
endif
dbgobottom()
RETORNO := &FIEWORK.
if lOPEN
   dbclosearea()
endif
if valtype(eVAR) = "C"
   &eVAR. := if(lSOMA,RETORNO := RETORNO+1,RETORNO)
endif
retu RETORNO


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ULTIMOITEM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ULTIMOITEM(cARQ,eKEY,mCOMP1,mCOMP2,eCAM,eVAR,lSOMA)


local nRETU := 0
if !USEREDE(cARQ,1,1)
   retu .F.
endif
dbgotop()
dbseek(eKEY)
while &mCOMP1. = &mCOMP2. .and. !eof()
   nRETU := &eCAM.
   dbskip()
enddo
dbclosearea()
if valtype(eVAR) = "C"
   if valtype(lSOMA) # "L"
      lSOMA := .T.
   endif
   &eVAR. := if(lSOMA,nRETU := nRETU+1,nRETU)
endif
retu nRETU

