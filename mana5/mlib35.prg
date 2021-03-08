*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib35.prg
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
*+    Function COR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func COR(cCOR,lOPEN,lSET)

local cCORRET := "W/N,N/W,N,N,N/W"
IF VALTYPE(lOPEN) # "L"
   lOPEN := .T.
ENDIF
IF VALTYPE(lSET) # "L"
   lSET := .F.
ENDIF
IF lOPEN
   if !USEREDE("CORES",1,1)
      IF lSET
         SETCOLOR(cCORRET)
      ENDIF
      retu cCORRET
   endif
ELSE
   dbselectar("CORES")
ENDIF
dbgotop()
if dbseek(cCOR)
   cCORRET := alltrim(COR1)+","
   cCORRET += alltrim(COR2)+","
   cCORRET += alltrim(COR3)+","
   cCORRET += alltrim(COR4)+","
   cCORRET += alltrim(COR5)
endif
IF lOPEN
   dbclosearea()
ENDIF
IF lSET
   SETCOLOR(cCORRET)
ENDIF
retu cCORRET


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CORARR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CORARR(aCOR,aVAR)

local cSTR,cVAR,I
local aRETU := {}
local nFIM  := len(aCOR)
if valtype(aCOR) = "C"
   cSTR := aCOR
   nFIM := 7
   do case
      case len(aCOR) = 3
         cSTR += "00"
      case len(aCOR) = 4
         cSTR += "0"
   endcase
   ACOR := {cSTR+"1",cSTR+"2",cSTR+"5",cSTR+"6",cSTR+"7",cSTR+"3",cSTR+"4"}
endif
if !USEREDE("CORES",1,1)
   for i := 1 to nFIM
      IF VALTYPE(aVAR) = "A"
         cVAR  := aVAR[I]
         &cVAR := "W/N,N/W,N,N,N/W"
      ELSE
         aadd(aRETU,"W/N,N/W,N,N,N/W")
      ENDIF
   next i
else
   for i := 1 to nFIM
      IF VALTYPE(aVAR) = "A"
         cVAR  := aVAR[I]
         &cVAR := COR(aCOR[I],.F.)
      ELSE
         aadd(aRETU,COR(aCOR[I],.F.))
      ENDIF
   next i
   dbclosearea()
endif
retu aRETU

