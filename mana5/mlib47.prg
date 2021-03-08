*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib47.prg
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
*+    Function IMPREL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func IMPREL


para mGRUPO,mCODIGO,ARQREL,ARQRE1
local cTELA
if IGUALVARS(ARQREL,mGRUPO+mCODIGO)
   cTELA := savescreen(00,00,2,79)
   MANB2()
   IMPEND()
   restscreen(00,00,2,79,cTELA)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MANLISTA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MANLISTA(cGRUPO)


if valtype(cGRUPO) # "C" .and. type("ZGRUPO") = "C"
   cGRUPO := zGRUPO
endif
if MDG("Relatorios Especificos")
   priv ARQREL := "MANREL"
   priv ARQRE1 := "MANRE1"
else
   priv ARQREL := "PADREL"
   priv ARQRE1 := "PADRE1"
endif
CRIARVARS("MANREL")
mMENU  := cGRUPO
mGRUPO := cGRUPO
aMCN21 := {}  //Matriz com os dizeres do Achoice
aMCN22 := {}  //Codigo do Relatorio
M_CN2(3)  //Chama com 3 para Escolher relatorio
retu .T.

