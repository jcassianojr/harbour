*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_3d.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


////#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_3d()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fopto_3d

para nTIPO

if !MDL('FOPTO_3D - Passagens de Funcion rios n„o encontrados')
   retu
endif

CTLIN := 80
cPD   := PARQDIO()
PAG   := 1
DIAX  := date()


if !NETUSE(cPD)
   retu
endif
FILTRO := ''
FI     := trim(FILTRO)
FILTRO := FILTRO(FI)
set filter to &FILTRO


if !NETUSE(PES)
   dbcloseall()
   retu
endif

dbselectar(cPD)
dbgotop()
while !eof()
   @ 24,00 say NUMERO         
   @ 24,10 say HORA           
   @ 24,20 say DATA           
   mNUMERO := NUMERO
   dbselectar(PES)
   dbgotop()
   if !dbseek(mNUMERO)
      IMPRESSORA()
      if CTLIN > 50
         CABEC("Passagens de Funcion rios n„o encontrados","")
         CTLIN := 8
      endif
      dbselectar(cPD)
      @ CTLIN,00 say NUMERO         
      @ CTLIN,10 say HORA           
      @ CTLIN,20 say DATA           
      CTLIN ++
      VIDEO()
   endif
   dbselectar(cPD)
   dbskip()
enddo
IMPRESSORA()
IMPFOL()
dbcloseall()
IMPEND()


*+ EOF: fopto_3d.prg
*+
