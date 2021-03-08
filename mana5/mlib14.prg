*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib14.prg
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


#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function METNVI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func METNVI(cARQ,bINS,bDEL,bAL1,bAL2,bBUS,cCOR,nOPR,bLIS)


while .T.
   MDF()
   MDS("INS=Novo DEL=Apagar ENTER=Alterar CTRL+ENTER=Busca ALT+F10=Listar ESC=Sair")
   setcolor(cCOR)
   KEY := 0
   while KEY = 0
      KEY := HOTINKEY()
      KEY := LERMOUSE(KEY)
      if MOUSE_Y = MAXROW() .and. MOUSE_B = 2
         do case
            case MOUSE_X > 0 .and. MOUSE_X < 7
               KEY := K_INS
            case MOUSE_X > 9 .and. MOUSE_X < 18
               KEY := K_DEL
            case MOUSE_X > 20 .and. MOUSE_X < 32
               KEY := K_ENTER
            case MOUSE_X > 34 .and. MOUSE_X < 49
               KEY := K_CTRL_RET
            case MOUSE_X > 51 .and. MOUSE_X < 64
               KEY := K_ALT_F10
            case MOUSE_X > 66 .and. MOUSE_X < 74
               KEY := K_ESC
         endcase
      endif
      if MOUSE_Y = 1 .and. MOUSE_B = 2 .and. MOUSE_X < 4
         KEY := K_ESC
      endif
   enddo
   do case
      case KEY = K_INS
         eval(bINS)
      case KEY = K_ENTER .and. nOPR # 3
         eval(bAL1)
      case KEY = K_ENTER .and. nOPR = 3
         eval(bAL2)
         retu
      case KEY = K_DEL
         eval(bDEL)
      case KEY = K_ALT_F10
         if valtype(bLIS) = "B"
            eval(bLIS)
         else
            MANLISTA()
         endif
      case KEY = K_CTRL_RET
         nIBUS  := if(lPBUS,NUMIND(cARQ),nIBUS)
         mCHAVE := PEGBUS(cARQ,nIBUS)
         nREG   := REGBUS(cARQ,nIBUS,mCHAVE)
         eval(bBUS)
      case KEY = K_ESC
         exit
      otherwise
         loop
   endcase
enddo
retu .T.

