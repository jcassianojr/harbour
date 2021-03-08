*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib25.prg
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEGAGET()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEGAGET(cARQ)


aGETS := {}
if !USEREDE(HELPARQ,1,2)
   retu .F.
endif
dbgotop()
dbseek(padr(cARQ,8)+str(0,3))
if found()
   while DBF = cARQ .and. !eof()
      if !empty(SEQ)
         do case
            case type("CONDICAO") = "C" .and. type("PRECOND") = "C"
               aadd(aGETS,{DADO,CAMPO,CONDICAO,PRECOND})
            case type("CONDICAO") = "C"
               aadd(aGETS,{DADO,CAMPO,CONDICAO})
            otherwise
               aadd(aGETS,{DADO,CAMPO})
         endcase
      endif
      dbskip()
   enddo
else
   dbclosearea()
   ALERTX("Falta Configura‡„o dos Campos para o Edit")
   retu .F.
endif
dbclosearea()
if len(aGETS) = 0
   ALERTX("Falta Configura‡„o para o modo Edit")
   retu .F.
endif
retu .T.

