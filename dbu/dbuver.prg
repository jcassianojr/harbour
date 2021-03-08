*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUVER.PRG
*+
*+    Functions: Function VERTXT()
*+
*+    Reformatted by Click! 2.03 on Jun-27-2003 at  6:25 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ


*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function VERTXT()
*+
*+    Called from ( dbu.prg      )   1 - 
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func VERTXT

if !lVERTXT
   ALERTX( 'J  esta sendo exibido um texto' )
   retu
endif
VER_ROW := row()
VER_COL := col()
VER_SCR := savescreen( 00, 00, 24, 79 )
VER_COR := setcolor()
@ 24, 00 clear
priv GETLIST := {}
priv DADO    := space( 80 )
MDS( "Digite o nome do Arquivo" )
@ 24, 40 get DADO pict "@S40"        
READDBU()
DADO := alltrim( DADO )
if ! HB_FILEEXISTS( DADO )
   ALERTX( 'N„o Encontrei Este Arquivo' )
   setcolor( VER_COR )
   restscreen( 00, 00, 24, 79, VER_SCR )
   setpos( VER_ROW, VER_COL )
   retu .F.
endif
lVERTXT := .F.
clea
setcolor( "N/W" )
@ 00, 00 clear to 00, 79
@ 24, 00 clear to 24, 79
@ 24, 00 say '[Arq.:' + DADO + ']'                                                                                                                 
@ 00, 00 say "       " + spac( 6 ) + "           ЭЭ Mover: " + chr( 24 ) + " " + chr( 25 ) + " PGUP PGDN  HOME  END          Э Sair: ESC "         
setcolor( "W/R" )
//READTEXT( DADO, 01, 00, 23, 79 )
vertxt(dado)
setcolor( VER_COR )
restscreen( 00, 00, 24, 79, VER_SCR )
setpos( VER_ROW, VER_COL )
lVERTXT := .T.
retu

*+ EOF: DBUVER.PRG
