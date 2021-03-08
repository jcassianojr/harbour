*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib01.prg
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
*+    Function CHECKTAB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKTAB(cTAB,cNOME,cERRO,cSTR1,cSTR2,lVAZIO,nLEN)

local cBUSCA
LOCAL cDBF   := ALIAS()
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
cBUSCA := &cNOME.
if valtype(nLEN) = "N"
   cBUSCA := strzero(cBUSCA,nLEN)
endif
if valtype(lVAZIO) = "L"
   if lVAZIO
      if empty(cBUSCA)
         retu .T.
      endif
   endif
endif
if !VERSEHA("MD02",padr(cTAB,12)+padr(cBUSCA,12),,,.F.)
   MDE(cERRO," : "+cBUSCA+" ")
   if valtype(nLEN) = "N"
      &cNOME. := val(ESCOLHETAB(cTAB,cBUSCA,cSTR1,cSTR2,nLEN))
   else
      &cNOME. := ESCOLHETAB(cTAB,CBUSCA,cSTR1,cSTR2,nLEN)
   endif
endif
IF !EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ESCOLHETAB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ESCOLHETAB(cTAB,cNOME,cSTR1,cSTR2,nLEN)

local aTABA := {}
local aTABB := {}
local nPOS
MDS("Aguarde Pesquisando Tabela")
if !USEREDE("MD02",1,1)
   retu cNOME
endif
dbgotop()
dbseek(cTAB)
while CODIGO = cTAB .and. !eof()
   if valtype(cSTR1) # "C"
      aadd(aTABA,CODIGO1+' '+DESCRICAO)
   else
      aadd(aTABA,&cSTR1.)
   endif
   if valtype(cSTR2) # "C"
      if valtype(nLEN) = "N"
         aadd(aTABB,left(CODIGO1,nLEN))
      else
         aadd(aTABB,CODIGO1)
      endif
   else
      aadd(aTABB,&cSTR2.)
   endif
   dbskip()
enddo
dbclosearea()
if !empty(aTABA)
   nPOS  := ascan(aTABB,cNOME)
   nPOS  := if(nPOS > 1,nPOS,1)
   nPOS  := ESCARR(aTABA,4,5,24 - 3,63,nPOS,"Escolha o Item")
   nPOS  := if(nPOS > 1,nPOS,1)
   cNOME := aTABB[nPOS]
endif
retu cNOME

