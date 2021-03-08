*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK68.PRG
*+
*+    Functions: Function CARDCHEK()
*+               Function CHECKCTA()
*+               Function CALCDIG()
*+               Function DAC10()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

#INCLUDE "INKEY.CH"

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function CARDCHEK()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
function CARDCHEK( Arg1 )

local Local1
local Local2
local Local3
local Local4
local Local5
local lRETU  := .F.
local aCards := { "AmEx", "Visa", "MasterCard", "Discover", ;
                  "Carte Blanche", "Diners", "JCB" }

if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif

Local3 := 0

if valtype( aRG1 ) # "C"
   ARg1 := strzero( aRG1, len( arg1 ) )
endif

ARg1 := TIRAOUT( aRG1 )
Arg1 := alltrim( Arg1 )

if empty( ARG1 )
   ALERTX( "Numero N苚 Informado" )
   retu .F.
endif

if ( left( Arg1, 1 ) == "0" )
   ALERTX( "Numero Come嘺ndo com Zero" )
   retu .F.
endif

if ( len( Arg1 ) < 16 )
   Local4 := replicate( "0", 16 - len( Arg1 ) ) + Arg1
else
   Local4 := Arg1
endif
for Local1 := 1 to 15 Step 2
   Local2 := val( substr( Local4, Local1, 1 ) ) * 2
   if ( Local2 > 9 )
      Local3 += ( 1 + Local2 % 10 )
   else
      Local3 += Local2
   endif
next
for Local1 := 2 to 16 Step 2
   Local3 += val( substr( Local4, Local1, 1 ) )
next
if ( Local3 == 0 .or. Local3 % 10 != 0 )
   Local5 := - 1
else
   Local4 := left( Arg1, 2 )
   do case
   case Local4 == "34" .or. Local4 == "37"
      Local5 := 1
   case Local4 == "36"
      Local5 := 6
   case Local4 == "38"
      if ( substr( Arg1, 3, 1 ) == "9" )
         Local5 := 5
      else
         Local5 := 6
      endif
   case Local4 == "31" .or. Local4 == "33" .or. Local4 == "35"
      Local4 := left( Arg1, 6 )
      do case
      case Local4 >= "311200" .and. Local4 <= "312099"
         Local5 := 7
      case Local4 >= "315800" .and. Local4 <= "315999"
         Local5 := 7
      case Local4 >= "333700" .and. Local4 <= "334999"
         Local5 := 7
      case Local4 >= "352800" .and. Local4 <= "358999"
         Local5 := 7
      otherwise
         Local5 := - 1
      endcase
   case Local4 == "30"
      Local4 := left( Arg1, 6 )
      if ( Local4 >= "308800" .and. Local4 <= "309499" )
         Local5 := 7
      elseif ( Local4 >= "309600" .and. Local4 <= "310299" )
         Local5 := 7
      else
         Local5 := 6
      endif
   case left( Local4, 1 ) == "4"
      Local5 := 2
   case Local4 >= "51" .and. Local4 <= "55"
      Local5 := 3
   case Local4 == "60" .and. substr( Arg1, 3, 2 ) == "11"
      Local5 := 4
   case left( Local4, 1 ) == "9"
      Local5 := 5
   otherwise
      Local5 := 0
   endcase
endif
if local5 > 0
   lRETU := .T.
   ALERTX( aCards[ local5 ] )
else
   ALERTX( "Nero Inv爈ido" )
endif
return lRETU

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function CHECKCTA()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
func CHECKCTA( cBANCO, cAGENCIA, cCONTA )

local eTOT := 0
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if valtype( cBANCO ) = "N"
   cBANCO := strzero( cBANCO, 3 )
endif
if cBANCO # "033" .and. cBANCO # "237" .and. cBANCO # "341"
   retu .T.
endif
//Ajustando Conta
cCONTA := strtran( cCONTA, " ", "" )
cCONTA := TIRAOUT( cCONTA )
//Ajustando Agencia
cAGENCIA := strtran( cAGENCIA, " ", "" )
cAGENCIA := TIRAOUT( cAGENCIA )
do case
case cBANCO = "033"
   if len( cCONTA ) # 9
      ALERTX( "Quantidade de Digitos da Conta Diferente de 9" )
      retu .F.
   endif
   cAGENCIA := right( cAGENCIA, 3 )
   eTOT     += CALCDIG( 7, substr( cAGENCIA, 1, 1 ) )
   eTOT     += CALCDIG( 3, substr( cAGENCIA, 2, 1 ) )
   eTOT     += CALCDIG( 1, substr( cAGENCIA, 3, 1 ) )
   eTOT     += CALCDIG( 9, substr( cCONTA, 1, 1 ) )
   eTOT     += CALCDIG( 7, substr( cCONTA, 2, 1 ) )
   eTOT     += CALCDIG( 1, substr( cCONTA, 3, 1 ) )
   eTOT     += CALCDIG( 3, substr( cCONTA, 4, 1 ) )
   eTOT     += CALCDIG( 1, substr( cCONTA, 5, 1 ) )
   eTOT     += CALCDIG( 9, substr( cCONTA, 6, 1 ) )
   eTOT     += CALCDIG( 7, substr( cCONTA, 7, 1 ) )
   eTOT     += CALCDIG( 3, substr( cCONTA, 8, 1 ) )
   eTOT     := strzero( eTOT )
   eTOT     := right( eTOT, 1 )
   eTOT     := if( val( eTOT ) > 0, 10 - val( eTOT ), 0 )
   if eTOT # val( substr( cCONTA, 9, 1 ) )
      ALERTX( "Checagem da Conta n刼 Confere" )
      retu .F.
   endif
case cBANCO = "341"
   if ( dac10( cAGENCIA + left( cCONTA, 5 ) ) != right( cCONTA, 1 ) )
      ALERTX( "Checagem da Conta n刼 Confere" )
      retu .F.
   endif
case cBANCO = "237"
   eTOT := 0
   nFIM := len( cCONTA )
   nINI := nFIM
   nFIM --
   for X := 1 to nFIM
      eTOT += nINI * val( substr( cCONTA, X, 1 ) )
      nINI --
   next X
   nRES := eTOT % 11
   nRES := 11 - nRES
   nRES := if( nRES = 10, "P", str( nRES, 1 ) )
   if nRES <> right( cCONTA, 1 )
      ALERTX( "Digito de Controle n刼 confere" )
      retu .F.
   endif
endcase
retu .T.

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function CALCDIG()
*+
*+    Called from ( disk68.prg   )  11 - function checkcta()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
func CALCDIG( n1, n2 )

local eRETU
if valtype( N2 ) = "C"
   N2 := val( N2 )
endif
eRETU := N1 * N2
eRETU := strzero( eRETU )
eRETU := right( eRETU, 1 )
eRETU := val( eRETU )
retu eRETU

// *******************************

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function DAC10()
*+
*+    Called from ( disk68.prg   )   1 - function checkcta()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
function DAC10( Arg1 )

local cnumero
local ninicio
local ntotal
local ccpoaux
local x
ninicio := len( alltrim( Arg1 ) ) + 1
ntotal  := 0
if ( ninicio < 2 )
   ninicio := 2
endif
ccpoaux := "0" + alltrim( Arg1 )
for x := ninicio to 1 step - 2
   cnumero := substr( ccpoaux, x, 1 )
   ntotal  += at( cnumero, "516273849" )
   ntotal  += val( substr( ccpoaux, x - 1, 1 ) )
next
return alltrim( str( at( substr( str( ntotal, 3 ), 3, 1 ), "987654321" ) ) )

*+ EOF: DISK68.PRG
