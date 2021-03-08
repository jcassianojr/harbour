*+ýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýý
*+
*+    Source Module => C:\DEVELOP\OBJ\SECULO.PRG
*+
*+    Functions: Function seculo()
*+
*+
*+ýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýýý

*+ññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññ
*+
*+    Function seculo()
*+
*+ññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññ
*+
func seculo

local nANO   := year( date() ) - 60
priv GETLIST := {}
@ 24,  0
if ALERTX( "Ajustar Ano de Referencia", { "Sim", "Nao" } ) = 1
   @ 24,  0 say "Digite o Centen rio"
   @ 24, 20 get nANO                  pict "9999"
   read
   set epoch to nANO
   //hb_setUpdateEpoch(nANO)
endif
if ALERTX( "Exibir Quatro digitos ", { "Sim", "Nao" } ) = 1
   set century on
   @ 24,  0 say "Quatro Digitos para digitar o Ano"
else
   set century off
   @ 24,  0 say "Dois Digitos para digitar o Ano"
endif

*+ EOF: SECULO.PRG
