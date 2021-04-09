*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib03.prg
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
*+    Function CHECKUF()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKUF(cSIGLA)


if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endi
IF cSIGLA = "XX" .or. cSIGLA = "EX" .OR. cSIGLA = "??"
   ZRUA := ""
ENDIF
if !VERSEHA("MD05",&cSIGLA.,"'Estado de : '+NOMEEXT")
   MDE("MAD501"," : "+&cSIGLA.+" ")
   &cSIGLA. := ESCOLHEUF(&cSIGLA.)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ESCOLHEUF()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ESCOLHEUF(cUF)


local aUF1 := {}
local aUF2 := {}
local nPOS
if valtype(cUF) # "C"
   cUF := "SP"
endif
if !USEREDE("MD05",1,1)
   retu cUF
endif
dbgotop()
while !eof()
   aadd(aUF1,UFICMS+" "+NOMEEXT)
   aadd(aUF2,UFICMS)
   dbskip()
enddo
dbclosearea()
nPOS := ascan(aUF2,cUF)
nPOS := if(nPOS > 1,nPOS,1)
nPOS := ESCARR(aUF1,4,5,24 - 3,63,nPOS,"Escolha o Estado Desejado")
nPOS := if(nPOS > 1,nPOS,1)
cUF  := aUF2[nPOS]
retu cUF

