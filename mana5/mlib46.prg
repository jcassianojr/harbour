*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib46.prg
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
*+    Function APAGAREG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func APAGAREG(cARq,eBUSCA,lPERG,lMOVE,nIND,lLOG)  //ABRE UM ARQUIVO E MARCA DELECAO


// *****************************        &&PARA ARQUIVO,INDICE,CHAVE DE BUSCA
if valtype(lPERG) # "L"
   lPERG := .T.
endif
if valtype(lMOVE) # "L"
   lMOVE := .T.
endif
if valtype(nIND) # "N"
   nIND := 1
endif
if valtype(lLOG) # "L"
   lLOG := .T.
endif
if lPERG
   if !mdg('Vocˆ Deseja Realmente Apagar? (S/n)','S')
      retu .F.
   endif
endif
if !USEREDE(cARq,1,99)
   retu .F.
endif
dbsetorder(nIND)
DELEREG(,eBUSCA,,lLOG)
//Ajusta Registro Paginado
if lMOVE
   if type("cVIDE") = "C"
      if cVIDE = "P"
         if valtype(nREG) = "N"
            set ORDER to nIND
            dbskip()
            EQUVARS()
            nREG := recno()
         endif
      endif
   endif
endif
dbclosearea()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function DELEREG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func DELEREG(cARQ,eBUSCA,lSAL,lLOG,lTOP)


if valtype(lSAL) # "L"
   lSAL := .F.
endif
if valtype(lLOG) # "L"
   lLOG := .T.
endif
if valtype(lTOP) # "L"
   lTOP := .F.
endif
if valtype(cARQ) = "C"
   dbselectar(cARQ)
endif
if lTOP
   dbgotop()
endif
if valtype(eBUSCA) # "U"
   dbgotop()
   if !dbseek(eBUSCA)
      retu .F.
   endif
endif
netrecdel()
if lSAL
   dbskip()
endif
if lLOG
   gravalog(eBUSCA,"DEL",cARQ)
endif
retu .T.

