*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib17.prg
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

#INCLUDE "BOX.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEGBUS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEGBUS(cARQ,nIND,cTITULO)


// *****************************
local RETORNO
local FORMULA
local cTELA   := savescreen(4,5,24 - 3,63)
HB_dispbox(4,5,24 - 3,63,B_DOUBLE)
if valtype(nIND) # "N"
   nIND := 1
endif
if valtype(cTITULO) = "C"
   @  5,7 say cTITULO         
else
   @  5,7 say "Digite a Busca"         
endif
for X := 1 to 3
   if !empty(aIND[nIND,X,3])
      priv cVARGET := aIND[nIND,X,3]
      cLEN := &cVARGET.
      @ X * 2+6,7 say aIND[nIND,X,4]         
      if valtype(cLEN) # "U"
         if valtype(cLEN) = "C" .and. len(cLEN) > 35
            @ X * 2+7,7 get &cVARGET. pict "@S40"        
         else
            @ X * 2+7,7 get &cVARGET.         
         endif
      endif
   endif
next X
READCUR()
FORMULA := aIND[nIND,4]
RETORNO := if(empty(FORMULA),&cVARGET.,&FORMULA.)
//Se for a primeira Chave Atualiza a variavel busca padr„o
if nIND = 1
   FORMULA  := aIND[1,4]
   VARIAVEL := aIND[1,1,3]
   mCHAVE   := if(empty(FORMULA),&VARIAVEL.,&FORMULA.)
endif
restscreen(4,5,24 - 3,63,cTELA)
retu RETORNO

