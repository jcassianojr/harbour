*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib22.prg
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


// *****************
//  lGET - Se exibe ou se efetua o get
//  COR1 - Cor da Descri‡„o Campo
//  COR2 - Cor do Get Campo
//  COR3 - Cor do Say Campo
//  COR4 - Cor do Say Campo Em Destaque
//

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function EDITGET()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func EDITGET(lGET,cCOR1,cCOR2,cCOR3,cCOR4)


local nPAG
local nELE
local X
local Y
local nCOL := 0
local nPOS
local aCOR
if valtype(lGET) # "L"
   lGET := .T.
endif
if valtype(cCOR1) = "A"
   aCOR  := cCOR1
   cCOR1 := aCOR[1]
   cCOR2 := aCOR[2]
   cCOR3 := aCOR[3]
   cCOR4 := aCOR[4]
endif
if valtype(cCOR1) # "C"
   cCOR1 := "W/N,N/W,N,N,W/N"
endif
if valtype(cCOR2) # "C"
   cCOR2 := "W/N,N/W,N,N,W/N"
endif
if valtype(cCOR3) # "C"
   cCOR3 := "W/N,N/W,N,N,W/N"
endif
if valtype(cCOR4) # "C"
   cCOR4 := "W/N,N/W,N,N,W/N"
endif
nPAG := int(len(aGETS) / 20)+1
nELE := len(aGETS)
nDIM := len(aGETS[1])
for X := 1 to nELE
   if len(trim(aGETS[X,1])) > nCOL
      nCOL := len(trim(aGETS[X,1]))
   endif
next
nCOL += 3
//Se for exibir mostra somente uma pagina
if !lGET
   nPAG := 1
endif
for X := 1 to nPAG
   HB_dispbox(2,0,24 - 1,79,B_DOUBLE)
   for Y := 1 to 20
      nPOS := Y+((X - 1) * 20)
      if nPOS <= nELE
         cVARGET := trim(aGETS[nPOS,2])
         cLEN    := &cVARGET.
         setcolor(cCOR1)
         @ Y+2,02 say aGETS[nPOS,1]         
         if !lGET
            setcolor(cCOR3)
            if valtype(cLEN) = "C" .and. len(cLEN) > 35
               @ Y+2,nCOL say left(&cVARGET.,35)         
            else
               @ Y+2,nCOL say &cVARGET.         
            endif
         else
            setcolor(cCOR2)
            do case
               case nDIM = 4
                  cVARCOND := trim(aGETS[nPOS,3])
                  cVARWHEN := trim(aGETS[nPOS,4])
                  do case
                     case empty(cVARCOND) .and. empty(cVARWHEN)
                        if valtype(cLEN) = "C" .and. len(cLEN) > 35
                           @ Y+2,nCOL get &cVARGET. pict "@S35"        
                        else
                           @ Y+2,nCOL get &cVARGET.         
                        endif
                     case empty(cVARCOND) .and. !empty(cVARWHEN)
                        if valtype(cLEN) = "C" .and. len(cLEN) > 35
                           @ Y+2,nCOL get &cVARGET. pict "@S35" when &cVARWHEN.       
                        else
                           @ Y+2,nCOL get &cVARGET. when &cVARWHEN.        
                        endif
                     case !empty(cVARCOND) .and. empty(cVARWHEN)
                        if valtype(cLEN) = "C" .and. len(cLEN) > 35
                           @ Y+2,nCOL get &cVARGET. pict "@S35" valid &cVARCOND.       
                        else
                           @ Y+2,nCOL get &cVARGET. valid &cVARCOND.        
                        endif
                     case !empty(cVARCOND) .and. !empty(cVARWHEN)
                        if valtype(cLEN) = "C" .and. len(cLEN) > 35
                           @ Y+2,nCOL get &cVARGET. pict "@S35" valid &cVARCOND. when &cVARWHEN.      
                        else
                           @ Y+2,nCOL get &cVARGET. valid &cVARCOND. when &cVARWHEN.       
                        endif
                  endcase
               case nDIM = 3
                  cVARCOND := trim(aGETS[nPOS,3])
                  if empty(cVARCOND)
                     if valtype(cLEN) = "C" .and. len(cLEN) > 35
                        @ Y+2,nCOL get &cVARGET. pict "@S35"        
                     else
                        @ Y+2,nCOL get &cVARGET.         
                     endif
                  else
                     if valtype(cLEN) = "C" .and. len(cLEN) > 35
                        @ Y+2,nCOL get &cVARGET. pict "@S35" valid &cVARCOND.       
                     else
                        @ Y+2,nCOL get &cVARGET. valid &cVARCOND.        
                     endif
                  endif
               otherwise
                  if valtype(cLEN) = "C" .and. len(cLEN) > 35
                     @ Y+2,nCOL get &cVARGET. pict "@S35"        
                  else
                     @ Y+2,nCOL get &cVARGET.         
                  endif
            endcase
         endif
      endif
   next Y
   READCUR()
next X
retu .T.

