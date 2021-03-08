*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib43.prg
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


#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PADDEL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PADDEL(cARQ,eBUSCA,eCOMP1,eCOMP2,nIND)


local cDBF := alias()
while !USEREDE(cARQ,1,99)
enddo
IF VALTYPE(nIND) = "N"
   DBSETORDER(nIND)
ENDIF
dbseek(eBUSCA)
while &eCOMP1. = &eCOMP2. .and. !eof()
   DELEREG(,,.T.,.F.)
enddo
dbclosearea()
if !empty(cDBF)
   dbselectar(cDBF)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function BXITEM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func BXITEM(cARQ,cARQBX,eBUSCA,eCOMP1,eCOMP2)


while !USEREDE(cARQ,1,99)
enddo
while !USEREDE(cARQBX,1,99)
enddo
dbselectar(cARQ)
dbgotop()
dbseek(eBUSCA)
while &eCOMP1. = &eCOMP2. .and. !eof()
   EQUVARS()
   NOVOOPA(cARQBX,.T.,.T.)
   DELEREG(cARQ,,.T.,.F.)
enddo
dbcloseall()
retu .T.

