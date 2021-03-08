*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlibc.prg
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
*+    Function CONVUN()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CONVUN(nQTDE,cUNI)

do case
   case cUNI == "CT"
      nQTDE := nQTDE * 100
   case cUNI == "ML"
      nQTDE := nQTDE * 1000
endcase
retu nQTDE



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PERC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC PERC(nBAS,nDIV)

LOCAL nPER := 0
IF VALTYPE(nBAS) # "N"
   ALERTX("PERC nBAS NÆo E Numerico")
   RETU 0
ENDIF
IF VALTYPE(nDIV) # "N"
   ALERTX("PERC nDIV NÆo E Numerico")
   RETU 0
ENDIF
IF nBAS > 0 .AND. nDIV > 0
   IF nBAS = nDIV
      nPER := 100
   ELSE
      nPER := round(nBAS / nDIV * 100,2)
   ENDIF
ENDIF
RETU nPER



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PER2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC PER2(nBAS,nDIV,nARR)

LOCAL nPER := 0
IF nBAS > 0 .AND. nDIV > 0
   IF nBAS = nDIV
      nPER := 100
   ELSE
      nPER := nBAS * nDIV / 100
   ENDIF
ENDIF
IF VALTYPE(nARR) = "N"
   nPER := ROUND(nPER,nARR)
ENDIF
RETU nPER


