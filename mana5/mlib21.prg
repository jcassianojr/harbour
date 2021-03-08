*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib21.prg
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
*+    Function TIPCAD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func TIPCAD(cTIP,cVAR,nROW,nCOL,cVA2)


local cARQ  := "MA01"
local cTIT  := ""
local lRETU := .T.
if !cTIP $ "CFVTPM"
   cTIP := ESCOLHETAB("TIPCAD",cTIP,,1)
endif
do case
   case cTIP = "C"
      cARQ := "MA01"
      cTIT := "CLIENTE       "
   case cTIP = "F"
      cARQ := "MB01"
      cTIT := "FORNECEDOR    "
   case cTIP = "V"
      cARQ := "MC01"
      cTIT := "VENDEDOR      "
   case cTIP = "T"
      cARQ := "MG01"
      cTIT := "TRANSPORTADORA"
   case cTIP = "P"
      cARQ := "M301"
      cTIT := "PORTO         "
   case cTIP = "M"
      cARQ := "MP03"
      cTIT := "MAO DE OBRA   "
   otherwise
      lRETU := .F.
endcase
if valtype(nROW) = "N" .and. valtype(nCOL) = "N"
   @ nROW,nCOL say cTIT         
endif
if valtype(cVAR) = "C"
   &cVAR. := cARQ
endif
if valtype(cVA2) = "C"
   &cVA2. := cTIP
endif
retu lRETU

