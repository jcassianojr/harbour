*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    DISK66.PRG
*+
*+    Functions: Function TECLAS()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function TECLAS()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function TECLAS( cPRO, nLIN, cVAR ) //ajuda nas teclas
local I      := 0
priv HELPDBF := "TECLAS"
while .T.
   cPRO := procname( I )
   cPRO := if( cPRO = "HOTINKEY", "INKEY", cPRO )
   do case
   case empty( cPRO ) 
      exit
   case cPRO = "ACHOICE" 
      exit
   case cPRO = "__MENUTO" 
      exit
   case cPRO = "READCUR" 
      exit
   case cPRO = "MDG" 
      exit
   case cPRO = "ALERTX" 
      exit
   case cPRO = "INKEY" 
      exit
   case cPRO = "MENU" 
      exit
   case cPRO = "MSGYESNO" 
      exit
   case cPRO = "MSGEXCLAMATION" 
      exit
   case cPRO = "MSGWARNING" 
      exit
   case cPRO = "MSGSTOP" 
      exit
   case cPRO = "ALERT" 
      exit
   endcase
   I ++
enddo
HELP( "TECLAS", 0, cPRO )
retu .T.



*+ EOF: DISK66.PRG
