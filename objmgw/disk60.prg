*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK60.PRG
*+
*+    Functions: Function GRMEMO()
*+               Function CAIXA()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "BOX.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function GRMEMO()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func GRMEMO         //F6 - Memoria

cur_mem   := setcursor()
scr_mem   := savescreen( 00, 00, 24, 79 )
cor_mem   := setcolor()
lin_mem   := row()
col_mem   := col()
v_kbyte   := 640
v_memoria := memory( 0 )
clear
v_escala         := v_kbyte / 5
v_kbyte1         := v_kbyte
COL              := 11
v_contador       := v_num := v_num2 := 2
v_contador1      := str( v_contador, 1 )
perc&v_contador2 := v_kbyte - v_memoria
setcolor( "B/N" )
HB_dispbox( 0, 0, 24, 79, B_DOUBLE+" ")
setcolor( "B/W" )
@  8, 30 say "MemЂria DisponЁvel   : " + str( memory( 0 ), 4 ) + " KBytes"         
@ 11, 30 say "MemЂria Maior Bloco  : " + str( memory( 1 ), 4 ) + " KBytes"         
@ 14, 30 say "MemЂria Para Corrida : " + str( memory( 2 ), 4 ) + " KBytes"         
while v_num <= 20
   @ v_num,  3 say str( v_kbyte, 4 ) + " -"         
   v_kbyte -= v_escala
   v_num   += 4
enddo
@ v_num,  3 say str( v_kbyte, 4 ) + " -"         
v_num3     := str( v_num2, 1 )
bar&v_num3 := int( perc&v_num3 * 20 / v_kbyte1 )
alt&v_num3 := 20 - bar&v_num3 + 1
v_tamanho  := 20
while v_tamanho >= alt&v_num3
   @ v_tamanho + 1, COL say repl( chr( 219 ), 2 )         
   v_tamanho --
enddo
v_num2 ++
@ v_tamanho + 2, 3 say str( perc&v_num3, 4 ) + " " + chr( 205 ) + chr( 16 )         
inkey( 0 )
setcolor( cor_mem )
setcursor( cur_mem )
restscreen( 00, 00, 24, 79, scr_mem )
setpos( lin_mem, col_mem )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CAIXA()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func CAIXA( LS, CS, LI, CI, MOLDURA )
local VTELA := savescreen( LS + 1, CS + 2, LI + 1, CI + 2 )
hb_default(@moldura,b_double)
if 24 = 24
   if len( VTELA ) > 2048
      VTELA := transform( substr( VTELA, 1, 2048 ), replicate( "X" + chr( 8 ), 1000 ) ) + ;
                          transform( substr( VTELA, 2049 ), replicate( "X" + chr( 8 ), 1000 ) )
   else
      VTELA := transform( VTELA, replicate( "X" + chr( 8 ), len( VTELA ) / 2 ) )
   endif
endif
restscreen( LS + 1, CS + 2, LI + 1, CI + 2, VTELA )
HB_DISPBOX(LS, CS, LI, CI,MOLDURA+" ")
return

*+ EOF: DISK60.PRG
