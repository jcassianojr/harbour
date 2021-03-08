*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_2B.PRG
*+
*+    Functions: Function FOPTO2B01()
*+               Function FOPTO2B02()
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

CABE2( 'FOPTO_2B - Apagar Movimento Ponto' )
if MDG( "Deseja funcionario por funcionario" )
   FOPTO2B01()
else
   FOPTO2B02()
endif

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO2B01()
*+
*+    Called from ( fopto_2b.prg )   1 - function fo29apg()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO2B01

while .T.
  set key K_F11 to TECLAF11
   mNUMERO := 0
   MDS( "Digite o Numero" )
   @ 24, 40 get mNUMERO         
   if !READCUR() .or. mNUMERO = 0
      set key K_F11 
      retu
   endif
   set key K_F11 
   FOPTO2B02( "NUMERO=" + alltrim( str( mNUMERO ) ) )
enddo

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO2B02()
*+
*+    Called from ( fopto_2b.prg )   1 - function fo29apg()
*+                                   1 - function fopto2b01()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO2B02( cFILTRO )

cPN := "PN" + ANOMESW 
if ! NETUSE(cPN)
   dbcloseall() 
   return
endif
if valtype( cFILTRO ) # "C"
   FILTRO := ''
   FI     := trim( FILTRO )
   FILTRO := FILTRO( FI )
else
   FILTRO := cFILTRO
endif
set filter to &FILTRO
GRAPP := 1
GRAPT := lastrec()
GRAPT( 'Aguarde Estou Apagando Dados' )
dbgotop()
while !eof()
   netrecdel()
   dbskip()
enddo
dbcloseall()

*+ EOF: FOPTO_2B.PRG
