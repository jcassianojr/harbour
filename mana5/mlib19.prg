*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib19.prg
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
*+    Function ESCOLHELOG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ESCOLHELOG(eNOME)


cNOME := &eNOME.
if !empty(aLOG1)
   nPOS    := ascan(aLOG2,cNOME)
   nPOS    := if(nPOS > 1,nPOS,1)
   nPOS    := ESCARR(aLOG1,4,5,24 - 3,63,nPOS,"Escolha o Logradouro")
   nPOS    := if(nPOS > 1,nPOS,1)
   cNOME   := aLOG2[nPOS]
   &eNOME. := cNOME
endif
retu .T.

