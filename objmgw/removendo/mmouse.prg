*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\MMOUSE.PRG
*+
*+    Functions: Function OPCAO()
*+               Function menu()
*+               Static Function HighLight()
*+               Static Function DeHighLight()
*+               Function ColorSplit()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:55 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

/***
* Menu.prg
*
*/

#include "Inkey.ch"
#include "Colors.ch"
#include "Commands.ch"
#include "Mouse.ch"

static aMenuColors

// #xtranslate definitions for prompt psuedo object
#xtranslate :promptRow   => \[1\]
#xtranslate :promptCol   => \[2\]
#xtranslate :promptText  => \[3\]
#xtranslate :promptAccl  => \[4\]
#xtranslate :promptAmp   => \[5\]
#xtranslate :promptmes   => \[6\]

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function OPCAO()
*+
*+    Called from ( disk69.prg   )   3 - function getfile()
*+                ( flib08.prg   )  11 - function checkimp()
*+                                   5 - function imphp()
*+                                   1 - function impext()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function OPCAO( nRow, nCol, cText, nAccl, cMES, bEXE )

local nWhereAmp
local cHighlight := ""
if valtype( cMES ) # "C"
   cMES := ""
endif
if valtype( nACCL ) # "N"
   nACCL := 0
endif
if ( nWhereAmp := at( "&", cText ) ) > 0
   cText := substr( cText, 1, nWhereAmp - 1 ) + ;
                    substr( cText, nWhereAmp + 1 )
endif

aadd( aMenuPrompts, { nRow, nCol, cText, nAccl, nWhereAmp, cMES, bEXE } )

return NIL

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function menu( nCurrentPrompt, nMES )

local aPrompt
local nKey       := 0
local lHadAccl   := .F.
local nAccl
local nNewPrompt
local lHadHotKey := .F.
local aEvent
local nMouse
local nPrompt
local lHadDbl    := .F.
local mTELA      := ""
local mTEMPVAR   := ""
if valtype( nMES ) # "N"
   nMES := 24
endif

default nCurrentPrompt to 1
aMenuColors := ColorSplit()

dispbegin()
for nPrompt := 1 to len( aMenuPrompts )
   if nPrompt == nCurrentPrompt
      HighLight( nPrompt, nMES )
   else
      DeHighLight( nPrompt, nMES )
   endif
next
dispend()

nNewPrompt := nCurrentPrompt
while nKey != K_ENTER .and. nKey != K_ESC .and. ;
      ! lHadHotKey .and. !lHadDbl
   nKEY := 0
   while nKEY = 0
      nKEY := HOTINKEY()
      LERMOUSE( nKEY )
      if MOUSE_B = 2                    //Dois Botoes
         nKEY := K_ESC
      endif
   enddo
   //Minusculos para Maisculos
   if nKEY > 96 .and. nKEY < 123
      nKEY := asc( upper( chr( nKEY ) ) )
   endif
   if nKEY > 0
      if ( nAccl := ascan( aMenuPrompts, ;
                    { | aPrompt | aPrompt:promptAccl == nKey } ) ) > 0
         nNewPrompt := nAccl
         lHadHotKey := .T.
      else
         do case
         case nKey == K_DOWN .or. nKey == K_RIGHT
            if nCurrentPrompt == len( aMenuPrompts )
               if set( _SET_WRAP )
                  nNewPrompt := 1
               endif
            else
               nNewPrompt ++
            endif
         case nKey == K_UP .or. nKey == K_LEFT
            if nCurrentPrompt == 1
               if set( _SET_WRAP )
                  nNewPrompt := len( aMenuPrompts )
               endif
            else
               nNewPrompt --
            endif
            //            CASE MOUSE_b=2
            //                 nMouse := Ascan(aMenuPrompts, ;
            //                 {|aPrompt| MOUSE_Y == aPrompt[1] ;
            //                 .AND. MOUSE_X >= aPrompt[2] ;
            //                 .AND. MOUSE_X <= aPrompt[2] + ;
            //                 Len(aPrompt[3]) - 1})
            //                 IF nMouse > 0
            //                    nNewPrompt := nMouse
            //                 ENDIF
         case MOUSE_B = 1
            nMouse := ascan( aMenuPrompts, ;
                             { | aPrompt | MOUSE_Y == aPrompt[ 1 ] ;
                             .and. MOUSE_X >= aPrompt[ 2 ] ;
                             .and. MOUSE_X <= aPrompt[ 2 ] + ;
                             len( aPrompt[ 3 ] ) - 1 } )
            if nMouse > 0
               nNewPrompt := nMouse
               nKEY       := K_ENTER
            endif
         endcase
      endif
   endif

   if nNewPrompt != nCurrentPrompt
      DeHighlight( nCurrentPrompt, nMES )
      Highlight( nNewPrompt, nMES )
      nCurrentPrompt := nNewPrompt
   endif

   if nKEY = K_ENTER .and. valtype( aMenuPrompts[ nCurrentPrompt, 7 ] ) = "B"
      mTEMPVAR := eval( aMenuPrompts[ nCurrentPrompt, 7 ] )
      nKEY     := 0
   endif

enddo

if nKEY = K_ESC
   nCurrentPrompt := 0
endif

aMenuPrompts := {}

return nCurrentPrompt

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function HighLight()
*+
*+    Called from ( mmouse.prg   )   2 - function menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static function HighLight( nPrompt, nMES )

local aPrompt := aMenuPrompts[ nPrompt ]

@ aPrompt:promptRow, aPrompt:promptCol ;
        say substr( aPrompt:promptText, 1, ;
        aPrompt:promptAmp - 1 ) ;
        color aMenuColors[ GET_COLOR ]

@ aPrompt:promptRow, ;
        aPrompt:promptCol + aPrompt:promptAmp - 1 ;
        say substr( aPrompt:promptText, ;
        aPrompt:promptAmp, 1 ) ;
        color aMenuColors[ UNSEL_GET_COLOR ]

@ aPrompt:promptRow, ;
        aPrompt:promptCol + aPrompt:promptAmp ;
        say substr( aPrompt:promptText, ;
        aPrompt:promptAmp + 1 ) ;
        color aMenuColors[ GET_COLOR ]

if nMES > 0
   @ nMES,  0 say padc( alltrim( aPrompt:promptMes ), 80 ) color aMenuColors[ UNSEL_GET_COLOR ]        
endif

return NIL

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function DeHighLight()
*+
*+    Called from ( mmouse.prg   )   2 - function menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static function DeHighLight( nPrompt, nMES )

local aPrompt := aMenuPrompts[ nPrompt ]

@ aPrompt:promptRow, aPrompt:promptCol ;
        say substr( aPrompt:promptText, 1, ;
        aPrompt:promptAmp - 1 ) ;
        color aMenuColors[ SAY_COLOR ]

@ aPrompt:promptRow, ;
        aPrompt:promptCol + ;
        aPrompt:promptAmp - 1 ;
        say substr( aPrompt:promptText, ;
        aPrompt:promptAmp, 1 ) ;
        color aMenuColors[ UNSEL_GET_COLOR ]

@ aPrompt:promptRow, ;
        aPrompt:promptCol + aPrompt:promptAmp ;
        say substr( aPrompt:promptText, ;
        aPrompt:promptAmp + 1 ) ;
        color aMenuColors[ SAY_COLOR ]

if nMES > 0
   @ nMES,  0 say padc( alltrim( aPrompt:promptMes ), 80 ) color aMenuColors[ UNSEL_GET_COLOR ]        
endif

return NIL

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ColorSplit()
*+
*+    Called from ( mmouse.prg   )   1 - function menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ColorSplit( cColor )

local nColor
local nNextComma
local aColors[ 5 ]

default cColor to setcolor()
for nColor := 1 to 4
   nNextComma        := at( ",", cColor )
   aColors[ nColor ] := substr( cColor, 1, nNextComma - 1 )
   cColor            := substr( cColor, nNextComma + 1 )
next

aColors[ 5 ] := cColor

return aColors

*+ EOF: MMOUSE.PRG
