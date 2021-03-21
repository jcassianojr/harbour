*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK65.PRG
*+
*+    Functions: Function CALEND()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

#INCLUDE "INKEY.CH"

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function CALEND()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func CALEND

priv HELPDBF := "CALEND"
X_POS    := row()
Y_POS    := col()
C_COR    := setcolor()
C_CUR    := setcursor( 0 )
CA_TELA  := savescreen( 0, 0, 16, 45 )
MOVCLE_X := 0
MOVCLE_Y := 0
CA_DATA  := date()
CA_MES   := month( CA_DATA )
CA_ANO   := year( CA_DATA )
CA_DIA   := day( CA_DATA )
CA_DIA1  := ctod( "01/" + str( CA_MES, 2 ) + "/" + subs( str( CA_ANO, 4 ), 3 ) )
C_VARDIA := "   1    2    3    4    5    6    7    8    9   10   11   12   13"
C_VARDIA += "   14   15   16   17   18   19   20   21   22   23   24"
C_VARDIA += "   25   26   27   28   29   30   31 "
while .T.
   setcolor( "W/BG" )
   if 24 = 24
      //    CAIXA(MOVCLE_X,MOVCLE_Y,MOVCLE_X+15,MOVCLE_Y+43,SPACE(9))
   endif
   @ MOVCLE_X + 00, MOVCLE_Y + 00 to MOVCLE_X + 15, MOVCLE_Y + 43
   setcolor( "N/W" )
   @ MOVCLE_X, MOVCLE_Y say "Э" + space( 16 ) + "Calend rio" + space( 16 ) + "Э"         
   setcolor( "N/W" )
   @ MOVCLE_X + 02, MOVCLE_Y + 02 clear to MOVCLE_X + 12, MOVCLE_Y + 40
   setcolor( "N/BG" )
   @ MOVCLE_X + 06, 04 + MOVCLE_Y say " Dom  Seg  Ter  Qua  Qui  Sex  Sab "         
   setcolor( "+W/W" )
   if at( subs( str( CA_MES + 100, 3 ), 2 ), "01 03 05 07 08 10 12" ) <> 0
      CA_VAR  := C_VARDIA + space( 32 )
      ULT_DIA := 31
   else
      if CA_MES <> 2
         CA_VAR  := subs( C_VARDIA, 1, 150 ) + space( 32 )
         ULT_DIA := 30
      else
         if int( CA_ANO / 4 ) = CA_ANO / 4
            CA_VAR  := subs( C_VARDIA, 1, 145 ) + space( 32 )
            ULT_DIA := 29
         else
            CA_VAR  := subs( C_VARDIA, 1, 140 ) + space( 32 )
            ULT_DIA := 28
         endif
      endif
   endif
   V_AR := iif( dow( CA_DIA1 ) > 1, repl( "     ", dow( CA_DIA1 ) - 1 ) + CA_VAR, CA_VAR )
   X_X  := 1
   while .T.
      if len( V_AR ) < X_X * 35
         exit
      endif
      setcolor( "+W/W" )
      SEM_ANA := subs( V_AR, ( 35 * X_X ) - 34, 34 )
      @ MOVCLE_X + 07 + X_X, 03 + MOVCLE_Y say " " + SEM_ANA + "  "         
      set color to N/W
      @ MOVCLE_X + 07 + X_X, 02 + MOVCLE_Y say "Э"                           
      @ MOVCLE_X + 07 + X_X, 40 + MOVCLE_Y say "Э"                           
      @ MOVCLE_X + 07 + X_X, 04 + MOVCLE_Y say subs( SEM_ANA, 1, 5 )         
      SEM_ANA := " " + SEM_ANA
      if at( str( CA_DIA, 5 ), SEM_ANA ) <> 0
         POS := at( str( CA_DIA, 5 ), SEM_ANA )
         if POS = 1
            setcolor( "N/BG" )
            @ MOVCLE_X + 07 + X_X, 04 + MOVCLE_Y say str( CA_DIA, 4 )         
         else
            setcolor( "+W/BG" )
            @ MOVCLE_X + 07 + X_X, 03 + POS + MOVCLE_Y say str( CA_DIA, 4 )         
         endif
      endif
      X_X ++
   enddo
   setcolor( "N/W" )
   @ MOVCLE_X + 02, MOVCLE_Y + 02 to MOVCLE_X + 07 + X_X, MOVCLE_Y + 40
   MES_ANO := subs( "Janeiro  FevereiroMar‡o    Abril    Maio     Junho    Julho    Agosto   Setembro Outubro  Novembro Dezembro ", CA_MES * 9 - 8, 9 )
   MES_ANO := alltrim( str( day( CA_DATA ), 2 ) ) + " de " + trim( MES_ANO )
   MES_ANO += " de " + str( year( CA_DATA ), 4 )
   @ MOVCLE_X + 04, 02 + ( 39 - len( MES_ANO ) ) / 2 + MOVCLE_Y say MES_ANO         
   C_TEC := inkey( 0 )
   if C_TEC = K_ESC .OR.C_TEC = K_ENTER
      exit
   endif
   if C_TEC = K_PGUP .or. C_TEC = K_PGDN .or. C_TEC = K_INS .or. C_TEC = K_DEL
      restscreen( MOVCLE_X + 00, MOVCLE_Y + 00, MOVCLE_X + 16, MOVCLE_Y + 45, CA_TELA )
      MOVCLE_X -= if( C_TEC = K_PGUP, 1, 0 )
      MOVCLE_X += if( C_TEC = K_PGDN, 1, 0 )
      MOVCLE_Y -= if( C_TEC = K_DEL, 1, 0 )
      MOVCLE_Y += if( C_TEC = K_INS, 1, 0 )
      MOVCLE_X := if( MOVCLE_X < 0, 0, MOVCLE_X )
      MOVCLE_X := if( MOVCLE_X + 15 > 24, 9, MOVCLE_X )
      MOVCLE_Y := if( MOVCLE_Y < 0, 0, MOVCLE_Y )
      MOVCLE_Y := if( MOVCLE_Y + 43 > 79, 36, MOVCLE_Y )
      CA_TELA  := savescreen( MOVCLE_X + 00, MOVCLE_Y + 00, MOVCLE_X + 16, MOVCLE_Y + 45 )
   endif
   do case
   case C_TEC = K_F1
      HELP( "CALEND", 0, "AJUDA" )
   case C_TEC = K_UP  //K_PGUP
      CA_MES --
      if CA_MES = 0
         CA_MES := 12
         CA_ANO --
      endif
   case C_TEC = K_DOWN //K_PGDN
      CA_MES ++
      if CA_MES = 13
         CA_MES := 1
         CA_ANO ++
      endif
   case C_TEC = K_HOME 
      CA_MES := 1
   case C_TEC = K_END 
      CA_MES := 12
   case C_TEC = K_RIGHT//K_INS 
      CA_ANO ++
   case C_TEC = K_LEFT//K_DEL 
      CA_ANO --
   endcase
   //Se o dia for 31 trocando mes para trinta n„o travar
   CA_DIA  := if( CA_DIA > ULT_DIA, ULT_DIA, CA_DIA )
   CA_DATA := ctod( str( CA_DIA, 2 ) + "/" + str( CA_MES, 2 ) + "/" + str( CA_ANO, 4 ) )
   CA_DIA1 := ctod( "01/" + str( CA_MES, 2 ) + "/" + subs( str( CA_ANO, 4 ), 3 ) )
enddo
restscreen( MOVCLE_X + 00, MOVCLE_Y + 00, MOVCLE_X + 16, MOVCLE_Y + 45, CA_TELA )
setcolor( C_COR )
setcursor( C_CUR )
@ X_POS, Y_POS say ""
READVAR := CA_DATA         
retu .T.

*+ EOF: DISK65.PRG
