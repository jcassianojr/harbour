*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_2b.prg
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
*+    Documentado em 27-Dez-2024 as  9:32 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


#INCLUDE "INKEY.CH"

CABE2('FOPTO_2B - Apagar Movimento Ponto')
if MDG("Deseja funcionario por funcionario")
   FOPTO2B01()
else
   FOPTO2B02()
endif


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO2B01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO2B01


while .T.
   set key K_F11 to TECLAF11
   mNUMERO := 0
   MDS("Digite o Numero")
   @ 24,40 get mNUMERO         
   if !READCUR() .or. mNUMERO = 0
      set key K_F11
      retu
   endif
   set key K_F11
   FOPTO2B02("NUMERO="+alltrim(str(mNUMERO)))
enddo


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO2B02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO2B02(cFILTRO)


cPN := "PN"+ANOMESW
if !NETUSE(cPN)
   dbcloseall()
   return
endif
if valtype(cFILTRO) # "C"
   FILTRO := ''
   FI     := trim(FILTRO)
   FILTRO := FILTRO(FI)
else
   FILTRO := cFILTRO
endif
set filter to &FILTRO
GRAPP := 1
GRAPT := lastrec()
GRAPT('Aguarde Estou Apagando Dados')
dbgotop()
while !eof()
   netrecdel()
   dbskip()
enddo
dbcloseall()


*+ EOF: fopto_2b.prg
*+
