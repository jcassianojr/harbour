*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib41.prg
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
*+    Function VERSEHA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func VERSEHA(ARQWORK,BUSWORK,cMES1,cMES2,lMES,nIND,nLIN,nCOL,lVAZIO)


local RETORNO
local cMESS   := ""
local cDBF    := alias()

if valtype(lMES) # "L"
   lMES := .F.
endif
if valtype(nIND) # "N"
   nIND := 1
endif
if valtype(lVAZIO) = "L"
   if lVAZIO
      if empty(BUSWORK)
         retu .T.
      endif
   endif
endif
if !USEREDE(ARQWORK,1,nIND)
   retu .F.
endif
dbgotop()
RETORNO := dbseek(BUSWORK)
if valtype(cMES1) = "C" .and. RETORNO
   cMESS := &cMES1.
endif
if valtype(cMES2) = "C" .and. !RETORNO
   cMESS := &cMES2.
endif
dbclosearea()
if !empty(cMESS)
   if !RETORNO .and. lMES
      if left(cMESS,1) # "X"  //Quando comeca com x troca para MDE
         ALERTX(cMESS)
      else
         MDE(substr(cMESS,2))
      endif
   endif
   if valtype(nLIN) = "N"
      @ nLIN,nCOL say cMESS         
   else
      MDS(cMESS)
   endif
endif
if !empty(cDBF)
   sele &cDBF.
endif
retu RETORNO

