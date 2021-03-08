*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => C:\DEVELO~1\CLIPPER\FOLHA\OBJ\FOAT.PRG
*+
*+    Reformatted by Click! 2.03 on Jan-21-2002 at  4:03 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
#INCLUDE "BOX.CH"

set color to +W/B
HB_dispbox( 9, 0, 13, 79,B_DOUBLE+" ")
@  9, 10 say "Â" + repl( 'Ä', 37 ) + "Â"                                                                            
@ 13, 10 say "Á" + repl( 'Ä', 37 ) + "Á"                                                                            
@ 10,  2 say "C¢digo  ³ Descri‡„o" + spac( 27 ) + "³ Valor de Cada Passe"                                           
@ 11,  0 say 'Ã' + repl( 'Ä', 9 ) + "Å" + repl( 'Ä', 37 ) + "Å" + repl( 'Ä', 30 ) + '´'                             
@ 12, 10 say "³" + spac( 37 ) + "³"                                                                                 
@ 12, 03 say CODIGO                                                                     pict '####'                 
@ 12, 12 say DESCR                                                                                                  
@ 12, 50 say VALOR                                                                      picture "###,###.##"        
set colo to
retu

*+ EOF: FOAT.PRG
