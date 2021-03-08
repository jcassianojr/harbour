*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib30.prg
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


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ACHMOU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ACHMOU(nStatus,nElement,nRelative)


SCROLLBARUPDATE(aSBAR,nElement,nSBAR,.T.)
setcolor(substr(cCOR,at(",",cCOR)+1))
@ nRELATIVE+5,1 say padr(eval(bELE,nElement),78)         
nKEY  := 0
cMOVE := ""
while nKEY = 0
   nKEY := HOTINKEY()
   nKEY := LERMOUSE(nKEY)
   do case
      case MOUSE_B = 1 .and. MOUSE_Y = 4
         nKEY := K_UP
      case MOUSE_B = 1 .and. MOUSE_Y = MAXROW() - 1
         nKEY := K_DOWN
      case MOUSE_B = 2
         nKEY := K_ESC
      case MOUSE_Y = 1 .and. MOUSE_B = 1 .and. MOUSE_X < 4
         nKEY := K_ESC
      case MOUSE_B = 1 .and. row() = MOUSE_Y .and. MOUSE_X # MAXCOL() - 1
         nKEY := K_ENTER
   endcase
   if MOUSE_X = 79 .and. MOUSE_B = 1
      do case
         case MOUSE_Y = 03
            nKEY := K_HOME
         case MOUSE_Y >= 5 .and. MOUSE_Y <= 13
            nKEY := K_PGUP
         case MOUSE_Y >= 14 .and. MOUSE_Y <= 22
            nKEY := K_PGDN
         case MOUSE_Y = MAXROW()
            nKEY := K_END
      endcase
   endif
   if MOUSE_Y = MAXROW() .and. MOUSE_B = 1
      do case
         case MOUSE_X > 00 .and. MOUSE_X < 07
            nKEY := K_INS
         case MOUSE_X > 09 .and. MOUSE_X < 17
            nKEY := K_DEL
         case MOUSE_X > 19 .and. MOUSE_X < 30
            nKEY := K_ENTER
         case MOUSE_X > 32 .and. MOUSE_X < 47
            nKEY := K_CTRL_RET
         case MOUSE_X > 49 .and. MOUSE_X < 62
            nKEY := K_ALT_F10
      endcase
   endif
   if MOUSE_B = 1 .and. MOUSE_Y > 4 .and. MOUSE_Y < MAXROW() - 1 .and. MOUSE_X # MAXCOL() - 1 .and. row() # MOUSE_Y
      if MOUSE_Y < row()
         nKEY  := 255   //Apenas Para Sair do Loop
         cMOVE := repl(chr(K_UP),row() - MOUSE_Y)
      else
         nKEY  := 255
         cMOVE := repl(chr(K_DOWN),MOUSE_Y - row())
      endif
   endif
enddo
setcolor(cCOR)
@ nRELATIVE+5,1 say padr(eval(bELE,nElement),78)         
do case
   case nKEY = K_HOME   //HOME VIRA CTRL_PGUP
      nKEY := K_CTRL_PGUP
   case nKEY = K_END  //END  VIRA CTRL_PGDN
      nKEY := K_CTRL_PGDN
endcase
do case
   case nKEY = K_ENTER
      retu 1
   case nKEY = K_INS
      retu 0
   case nKEY = K_DEL
      retu 1
   case nKEY = K_CTRL_RET
      retu 0
   case nKEY = K_ALT_F1
      retu 1
   case nKEY = K_ALT_F2
      retu 1
   case nKEY = K_ALT_F3
      retu 1
   case nKEY = K_ALT_F4
      retu 1
   case nKEY = K_ALT_F5
      retu 1
   case nKEY = K_ALT_F6
      retu 1
   case nKEY = K_ALT_F7
      retu 1
   case nKEY = K_ALT_F8
      retu 1
   case nKEY = K_ALT_F9
      retu 1
   case nKEY = K_ALT_F10
      retu 1
   case nKEY = K_SH_F1
      retu 1
   case nKEY = K_SH_F2
      retu 1
   case nKEY = K_SH_F3
      retu 1
   case nKEY = K_SH_F4
      retu 1
   case nKEY = K_SH_F5
      retu 1
   case nKEY = K_SH_F6
      retu 1
   case nKEY = K_SH_F7
      retu 1
   case nKEY = K_SH_F8
      retu 1
   case nKEY = K_SH_F9
      retu 1
   case nKEY = K_ALT_ENTER
      retu 1
   case nKEY = K_CTRL_DEL
      retu 1
   case nKEY = K_ESC
      retu 0
endcase
if empty(cMOVE)
   keyboard chr(nKEY)
else
   keyboard cMOVE
endif
retu 2


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CABVID()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CABVID(cCOR,nPOS,xR1,xR2)


if valtype(xR1) # "N"
   xR1 := 2
endif
if valtype(xR2) # "N"
   xR2 := 24
endif
setcolor(cCOR)
HB_dispbox(xR1,0,xR2 - 1,79,B_DOUBLE)
@ xR1+1,1  say cCBAS                                                                                 
@ xR1+1,79 say "Ý"                                                                                   
@ xR1+2,0  say '+'+replicate('-',77)+'AÝ'                                                            
@ xR2,0    say "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Lista"+spac(17)+"Ý"         
setcolor(cCOR)
ScrollBarUpdate(aSBAR,nPOS,nSBAR,.T.)
ScrollBarDisplay(aSBAR)
retu .T.

