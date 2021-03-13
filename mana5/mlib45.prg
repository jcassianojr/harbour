*+--------------------------------------------------------------------
*+
*+    Programa  : mlib45.prg
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2021, Jorge Cassiano
*+
*+    Documentado em 13/03/2O21
*+
*+--------------------------------------------------------------------
*+


#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+    Function ZAPARQ()
*+
*+--------------------------------------------------------------------
*+
funcTION ZAPARQ(aARQ)
local W
if valtype(aARQ) # "A"
   ALERTX("Parametro ZAPARQ n„o ‚ Matriz")
   return .F.
endif
for W := 1 to len(aARQ)
   MDS("Zerando Arquivo: "+aARQ[W,1])
   while ! USEREDE(aARQ[W,1],0,99)
   enddo
   zap
   dbsetorder(1)
   if aARQ[W,2]
      dbclosearea()
   endif
   if aARQ[W,3]
      INITVARS()
      CLRVARS()
   endif
next W


*+--------------------------------------------------------------------
*+
*+    Function NOVOREG()
*+
*+--------------------------------------------------------------------
*+
function NOVOREG(cARQ,eCHAVE,lMES,lLOG,nIND)
local RETORNO := .F.
if valtype(lMES) # "L"
   lMES := .T.
endif
if valtype(lLOG) # "L"
   lLOG := .T.
endif
if !USEREDE(cARQ,1,99)
   retuRN .F.
endif
IF VALTYPE(nIND) = "N"
   DBSETORDER(nIND)
ENDIF
dbgotop()
if !dbseek(eCHAVE)
   netrecapp()
   REPLVARS()
   RETORNO := .T.
endif
dbunlock()
dbcommit()
dbclosearea()
if !RETORNO .and. lMES
   ALERTX("Registro ja cadastrado com esta chave")
endif
if lLOG
   gravalog(eCHAVE,"INS",cARQ)
endif
retuRN RETORNO


*+--------------------------------------------------------------------
*+
*+    Function USEMULT()
*+
*+--------------------------------------------------------------------
*+
function USEMULT(aARQ)
local W
if valtype(aARQ) # "A"
   ALERTX("Parametro USEMULT nAo E Matriz")
   retuRN .F.
endif
for W := 1 to len(aARQ)
   if !USEREDE(aARQ[W,1],aARQ[W,2],aARQ[W,3])
      dbcloseall()
      retuRN .F.
   endif
   if aARQ[W,3] = 99
      dbsetorder(1)
   endif
next W
retuRN .T.


*+--------------------------------------------------------------------
*+
*+    Function NOVOOPE()
*+
*+--------------------------------------------------------------------
*+
funcTION NOVOOPE(cARQ,eCHAVE)


if valtype(cARQ) = "C"
   dbselectar(cARQ)
endif
dbgotop()
if !dbseek(eCHAVE)
   netrecapp()
   REPLVARS()
else
   MDS("Registro ja Cadastrado: "+STRVAL(cARQ)+STRVAL(eCHAVE))
   retuRN .F.
endif
retuRN .T.

//Arquivo,Lock

*+--------------------------------------------------------------------
*+
*+    Function NOVOOPA()
*+
*+--------------------------------------------------------------------
*+
funcTION NOVOOPA(cARQ,lUNL,lREP,lCHECK)

if valtype(lUNL) # "L"
   lUNL := .T.
endif
if valtype(lREP) # "L"
   lREP := .T.
endif
if valtype(lCHECK) # "L"
   lCHECK := .T.
endif
if valtype(cARQ) = "C"
   dbselectar(cARQ)
endif
netrecapp()
if lREP
   REPLVARS(lCHECK)
endif
if lUNL
   dbunlock()
endif
retuRN .T.

*+--------------------------------------------------------------------
*+
*+    Function ntxtmp()
*+
*+--------------------------------------------------------------------
*+
//function ntxtmp
//local carq
//cARQ := TMPFILE(cRDDEXT)
//caRQ := substr(cARQ,1,at(".",cARQ) - 1)
//return carq



