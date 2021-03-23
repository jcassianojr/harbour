*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK54.PRG
*+
*+    Functions: Function AC_AGUDO()
*+               Function AC_CRASE()
*+               Function AC_TIL()
*+               Function AC_CIRC()
*+               Function Acentuar()
*+               Function liga_acento()
*+               Function Acento()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function AC_AGUDO()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func AC_AGUDO

set key 39 to
ACENTUAR( "AGU" )
SetKey( 39, {|| AC_AGUDO() } )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function AC_CRASE()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func AC_CRASE

Acentuar( "CRA" )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function AC_TIL()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func AC_TIL

Acentuar( "TIL" )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function AC_CIRC()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func AC_CIRC

ACENTUAR( "CIR" )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Acentuar()
*+
*+    Called from ( disk54.prg   )   1 - function ac_agudo()
*+                                   1 - function ac_crase()
*+                                   1 - function ac_til()
*+                                   1 - function ac_circ()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func Acentuar( cTIPO )

local cDOS
local cWIN
local cBUS
local nPOS
cBUS := { "A", "a", "E", "e", "I", "i", "O", "o", "U", "u", "C", "c" }
do case
case cTIPO = "CRA"  //Crase
   cDOS := CHARCNVMT( "Здоуы" )
   cWIN := CHARCNVMT( "+р+шньв=+љЧч" )
case cTIPO = "AGU"  //Agudo
   cDOS := CHARCNVMT( "Е жЁрЂщЃ" )
   cWIN := CHARCNVMT( "-с+щ-эгѓ+њЧч" )
case cTIPO = "CIR"  //Circunflexo
   cDOS := CHARCNVMT( "Жвзтъ" )
   cWIN := CHARCNVMT( "-т-ъ+юдєнћЧч" )
case cTIPO = "TIL"  //Til
   cBUS := { "A", "a", "O", "o", "N", "n" }
   cDOS := CHARCNVMT( "ЧЦхфЅЄ" )
   cWIN := CHARCNVMT( "у+iѕбё" )
case cTIPO = "TRE"  //Trema
   cDOS := CHARCNVMT( "ги" )
   cWIN := CHARCNVMT( "-ф-ыЯяжі_ќЧч" )
case cTIPO = "GRA"  //Grau
   cBUS := { "A", "a" }
   cDOS := CHARCNVMT( "" )
   cWIN := CHARCNVMT( "+х" )
endcase
xkey := inkey( 0 )
ykey := chr( xkey )
nPOS := ascan( cBUS, yKEY )
if nPOS > 0
   Kkey := if( ACENTUA, cDOS[ nPOS ], cWIN[ nPOS ] )
else
   kkey := ykey
endif
keyboard ( kkey )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function liga_acento()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func liga_acento

if mdg( "Ligar Acentuacao")
	 SetKey( 39, {|| AC_AGUDO() } )
	SetKey( 94, {|| AC_CIRC() } )
	SetKey( 96, {|| AC_CRASE() } )
	SetKey( 126, {|| AC_TIL() } )
   if MDG( "Acentuacao para Windows")
      ACENTUA := .F.
   else
      ACENTUA := .T.
   endif
else
   set key 39 to
   set key 94 to
   set key 96 to
   set key 126 to
endif
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Acento()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func Acento( texto )

local ag   := chr( 8 ) + chr( 39 )
local ti   := chr( 8 ) + chr( 126 )
local cr   := chr( 8 ) + chr( 96 )
local ci   := chr( 8 ) + chr( 94 )
local ce   := chr( 8 ) + chr( 44 )
local sp   := 0
local X
local aORI := { " ", "", "Ё", "Ђ", "Ѓ", ;
                "Е", "", "ж", "р", "щ", ;
                "", "", "", "", "З", ;
                "", "", "Ж", "в", "т", ;
                "Ц", "", "ф", "", "Ч", "", "", "х" }
local aDES := { "a" + ag, "e" + ag, "i" + ag, "o" + ag, "u" + ag, ;
                "A" + ag, "E" + ag, "I" + ag, "O" + ag, "U" + ag, ;
                "a" + ci, "e" + ci, "o" + ci, "a" + cr, "A" + cr, ;
                "c" + ce, "C" + ce, "A" + ci, "E" + ci, "O" + ci, ;
                "a" + ti, "a" + ti, "o" + ti, "o" + ti, "A" + ti, "A" + ti, "O" + ti, "O" + ti }
if valtype( TEXTO ) # "C"
   retu TEXTO
endif
if type( "nTIPSPO" ) # "U"              //Nao passado tipo spoll
   retu TEXTO
endif
if nTIPSPO <> 2 .and. nTIPSPO <> 3 .and. nTIPSPO <> 4       //LPT1 LPT2 LPT3
   retu TEXTO
endif
for X := 1 to len( aORI )
   if at( aORI[ X ], texto ) > 0
      texto := strtran( texto, aORI[ X ], aDES[ X ] )
      sp ++
   endif
next
if sp > 0
   texto += space( sp )
endif
retu ( texto )

*+ EOF: DISK54.PRG
