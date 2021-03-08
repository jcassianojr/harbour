*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_13.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:15 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

CABE2( 'FOPTO_13 - Ver/Imprimir Arquivo do RelЂgio-TXT' )
ntipo := PEGRELOGIO()
DADO  := pegarqcon( nTIPO, "TXT" )
FOPTO13(DADO)

FUNC FOPTO13(DADO)
if MDG( "Visualizar" )
   VERTXT( DADO,,, { 4, 0, 24, 79 }, .F. )
endif
if MDG( "Imprimir" )
   IMPARQ( DADO )
endif
retu


*+ EOF: FOPTO_13.PRG
