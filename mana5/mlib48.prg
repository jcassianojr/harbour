*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib48.prg
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
*+    Function CHECKEXI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKEXI(cARQ,eBUSCA,cSTR1,cSTR2,cMES,lVAZIO,nPERT,lCOND,nIND,nIND2)


local cBUSCA
local cDBF    := ALIAS()
local nINDEXI

if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if valtype(nIND) # "N"  //Indice Busca
   nIND := 1
endif
if valtype(nIND2) # "N"   //Indice Escolha
   nINDEXI := nIND
endif
if valtype(eBUSCA) = "A"
   cBUSCA := eBUSCA[1]
   cBUSCA := &cBUSCA.
else
   cBUSCA := &eBUSCA.
endif
if valtype(lVAZIO) = "L"
   if lVAZIO
      if empty(cBUSCA)
         retu .T.
      endif
   endif
endif
if valtype(nPERT) # "N"
   nPERT := 0
endif
if !VERSEHA(cARQ,cBUSCA,cSTR1,,.F.,nIND)
   if valtype(cMES) = "C"
      MDE(cMES," : "+STRVAL(cBUSCA)+" ")
   endif
   do case
      case nPERT = 0
         if valtype(eBUSCA) = "A"
            cBUSCA   := eBUSCA[2]
            &cBUSCA. := ESCOLHEXI(cARQ,&cBUSCA.,cSTR1,cSTR2,lCOND,nINDEXI)
         else
            &eBUSCA. := ESCOLHEXI(cARQ,&eBUSCA.,cSTR1,cSTR2,lCOND,nINDEXI)
         endif
   endcase
endif
IF !EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ESCOLHEXI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ESCOLHEXI(cARQ,cNOME,cSTR1,cSTR2,lCOND,nIND)


local aTABA := {}
local aTABB := {}
local nPOS
if valtype(nIND) # "N"
   nIND := 1
endif
MDS("Aguarde Pesquisando Tabela")
if !USEREDE(cARQ,1,nIND)
   retu cNOME
endif
dbgotop()
while !eof()
   if valtype(lCOND) # "C"
      aadd(aTABA,&cSTR1.)
      aadd(aTABB,&cSTR2.)
   else
      if &lCOND.
         aadd(aTABA,&cSTR1.)
         aadd(aTABB,&cSTR2.)
      endif
   endif
   dbskip()
enddo
dbclosearea()
if !empty(aTABA)
   nPOS := ascan(aTABB,cNOME)
   nPOS := if(nPOS > 1,nPOS,1)
   nPOS := ESCARR(aTABA,4,5,24 - 3,63,nPOS,"Escolha o Item")
   nPOS := if(nPOS > 1,nPOS,1)
   if lastkey() = K_ENTER
      cNOME := aTABB[nPOS]
   ENDIF
endif
retu cNOME

