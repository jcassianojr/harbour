*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib02.prg
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
*+    Function TECLAF11()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func TECLAF11

para cPRO,nLIN,cVAR
LOCAL lACHEI  := .F.
priv eEXECUTE

if type("HELPDBF") = "C"
   if PEGACAMPO("MF11","PADR(cVAR,10)+PADR(HELPDBF,10)","EXECUTE","eEXECUTE")
      &cVAR. := &eEXECUTE.
      lACHEI := .T.
   else
      if PEGACAMPO("MF11","ALLTRIM(cVAR)","EXECUTE","eEXECUTE")
         &cVAR. := &eEXECUTE.
         lACHEI := .T.
      endif
   endif
else
   if PEGACAMPO("MF11","ALLTRIM(cVAR)","EXECUTE","eEXECUTE")
      &cVAR. := &eEXECUTE.
      lACHEI := .T.
   endif
endif
IF !lACHEI
   IF TYPE(cVAR) = "D"
      CALEND()
      IF VALTYPE(READVAR) = "D"
         IF MDG("USAR "+STRVAL(READVAR))
            &cVAR. := READVAR
         ENDIF
      ENDIF
   ENDIF
   IF TYPE(cVAR) = "N"
      CALC()
      IF VALTYPE(READVAR) = "N"
         IF MDG("USAR "+STRVAL(READVAR))
            READVAR := READVAR
         ENDIF
         &cVAR. := READVAR
      ENDIF
   ENDIF
ENDIF
retu .T.

