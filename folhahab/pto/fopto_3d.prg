*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_3D.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

////#INCLUDE "COMANDO.CH"

function fopto_3d
para nTIPO

if !MDL( 'FOPTO_3D - Passagens de Funcion rios n„o encontrados' )
   retu
endif

CTLIN := 80
cPD   := PARQDIO()
PAG   := 1
DIAX  := date()


if ! NETUSE(cPD) 
   retu
endif
FILTRO := ''
FI     := trim( FILTRO )
FILTRO := FILTRO( FI )
set filter to &FILTRO


if ! NETUSE(PES) 
   dbcloseall()
   retu
endif

dbselectar( cPD )
dbgotop()
while !eof()
   @ 24, 00 say NUMERO         
   @ 24, 10 say HORA           
   @ 24, 20 say DATA           
   mNUMERO := NUMERO
   dbselectar( PES )
   dbgotop()
   if !dbseek( mNUMERO )
      IMPRESSORA()
      if CTLIN > 50
         CABEC( "Passagens de Funcion rios n„o encontrados", "" )
         CTLIN := 8
      endif
      dbselectar( cPD )
      @ CTLIN, 00 say NUMERO         
      @ CTLIN, 10 say HORA           
      @ CTLIN, 20 say DATA           
      CTLIN ++
      VIDEO()
   endif
   dbselectar( cPD )
   dbskip()
enddo
IMPRESSORA()
IMPFOL()
dbcloseall()
IMPEND()

*+ EOF: FOPTO_3D.PRG
