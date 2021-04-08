*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib04.prg
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


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKCID()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKCID(cSIGLA,cNOME)

local lRETU := .F.
LOCAL aLAT  := {"","","","","",""}
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
ZDDD    := ""
ZCEP    := ""
ZCEPFIM := ""
ZKM     := 0
ZRUA    := ""
if cSIGLA = "XX"
   MDS("Exterior nao ser  checada cidade")
   retu .T.
endif
if !VERSEHA("MD10",cSIGLA+ALLTRIM(upper(TIRACE(&cNOME.))),,,.F.,1)
   MDE("MADA01"," : "+&cNOME.+" ")
   &cNOME. := ESCOLHECID(cSIGLA,&cNOME.)
endif
if !USEREDE("MD10",1,1)
   retu lRETU
endif
dbgotop()
IF dbseek(cSIGLA+upper(TIRACE(&cNOME.)))
   lRETU   := .T.
   ZDDD    := DDD
   ZCEP    := INICEP
   ZCEPFIM := FIMCEP
   //ZKM     := KM
   aLAT[ 1 ] := LATITUDE
   aLAT[ 2 ] := LONGITUDE
   aLAT[ 3 ] := HEMISFERIO
   IF CORSIT = 1
      ZRUA := "C" + cCODIBGE
   ENDIF
endif
IF dbseek(zESTADO+zCIDADE)
   aLAT[ 4 ] := LATITUDE
   aLAT[ 5 ] := LONGITUDE
   aLAT[ 6 ] := HEMISFERIO
endif
dbclosearea()
zKM := calcgeokm(geotodec(aLAT[1],aLAT[3]),geotodec(aLAT[2],aLAT[3]),geotodec(aLAT[4],aLAT[6]),geotodec(aLAT[5],aLAT[6]))
retu lRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ESCOLHECID()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ESCOLHECID(cSIGLA,cCIDADE)


local aCID := {}
local nPOS
if valtype(cSIGLA) # "C"
   cSIGLA := "SP"
endif
if valtype(cCIDADE) # "C"
   cCIDADE := space(35)
endif
MDS("Aguarde Pesquisando Cidades do Estado")
if !USEREDE("MD10",1,1)
   retu cCIDADE
endif
dbgotop()
dbseek(cSIGLA)
while UF = cSIGLA .and. !eof()
   aadd(aCID,NOME)
   dbskip()
enddo
dbclosearea()
if !empty(aCID)
   nPOS    := ascan(aCID,cCIDADE)
   nPOS    := if(nPOS > 1,nPOS,1)
   nPOS    := ESCARR(aCID,4,5,24 - 3,63,nPOS,"Escolha o Cidade Desejado")
   nPOS    := if(nPOS > 1,nPOS,1)
   cCIDADE := aCID[nPOS]
endif
retu cCIDADE

