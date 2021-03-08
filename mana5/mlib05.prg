*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib05.prg
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
*+    Function MDE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MDE(cCODIGO,cMESS,cCOR)

local cDESC := ""
if valtype(cCOR) # "C"
   cCOR := "W/N,N/W,N,N,N/W"
endif
if valtype(cMESS) # "C"
   cMESS := ""
endif
if USEREDE("MMES",1,1)
   dbgotop()
   dbseek(cCODIGO)
   if found()
      cMESS := alltrim(MENSAGEM)+cMESS
      cDESC := DESCRICAO
   else
      cMESS := "N„o Cadastrada Mensagem "+cCODIGO
      cDESC := cMESS
   endif
   dbclosearea()
else
   retu .T.
endif
setcolor(cCOR)
nKEY := ALERTX(cMESS,{"   OK    ","  Ajuda  "})
//Pediu Ajuda
if nKEY = 2
   MEMOVIEW(cDESC,8,9,15,74,,"Ajuda de Erro")
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CALCVAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CALCVAR(mVAR,nRES,nROW,nCOL,cEST)


&mVAR. := nRES
if valtype(cEST) = "C"
   @ nROW,nCOL say &mVAR. pict cEST        
else
   @ nROW,nCOL say &mVAR.         
endif
retu .T.

