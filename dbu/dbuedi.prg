*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUEDI.PRG
*+
*+    Functions: Function EDITXT()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function EDITXT()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func EDITXT
if !lEDITXT
   ALERTX( 'J  esta sendo editado um texto' )
   retu
endif
@ 24, 00 clear
priv DADO    := space( 80 )
MDS( "Digite o nome do Arquivo" )
@ 24, 40 get DADO pict "@S40"
READDBU()
DADO := alltrim( DADO )
if ! HB_FILEEXISTS( DADO )
   ALERTX( 'N„o Encontrei Este Arquivo' )
   retu .F.
endif
lEDITXT := .F.
EDItarq( DADO )
lEDITXT := .T.
retu



