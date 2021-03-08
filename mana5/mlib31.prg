*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib31.prg
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
*+    Function CKEMPTY()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC CKEMPTY(eVAR)

IF !EMPTY(eVAR)
   RETU .T.
ENDIF
RETU MDG("Aceitar Campo Vazio")




