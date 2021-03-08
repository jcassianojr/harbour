*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK50.PRG
*+
*+    Functions: Function CALC()
*+               Function tCALC()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CALC()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func CALC

local varuso
priv nCOL    := 50
calc_row := row()
calc_col := col()
calc_scr := savescreen( 2, nCOL - 1, 21, nCOL + 23 )
calc_cor := setcolor()
calc_cur := setcursor()
priv HELPDBF := "CALCULA"
priv GETLIST := {}
operand1   := 0
operand2   := 0
result     := 0
decount    := 2
loperator  := 61
KEY        := 0
COL        := nCOL + 4
equalsmode := .T.
firstpass  := .T.
memexist   := .F.
oper2str   := ""
memstr     := ""
picstring  := "9,999,999,999.99"

tCALC( 0 )

// ***************************
//  Main program control     *
// ***************************
do while KEY <> 27  // Escape exits
   @  8, COL say ""         
   KEY := 0
   while KEY = 0
      KEY := inkey()
   enddo
   do case
   case KEY = K_LEFT .and. nCOL > 1
      tCALC( - 1 )
   case KEY = K_RIGHT .and. nCOL < 56
      tCALC( + 1 )
   case KEY = 27    //       * Input = ESC              *
      loop
      // ***************************
      //  Input = (*)(+)(/)(+)(=)  *
      // ***************************
   case KEY = K_F1  //Ajuda
      HELP( "CALCULA", 0, "AJUDA" )
   case KEY = 418
      READVAR := alltrim( Strval( READVAR ) )
      keyboard READVAR
   case KEY = 42 .or. KEY = 43 .or. KEY = 45 ;
              .or. KEY = 47 .or. KEY = 61 .or. KEY = 13     // Operators
      && (/,+,-,*,=,ENTER)
      if KEY = 13
         KEY := 61  // ENTER=Equal Sign
      endif
      if KEY = 45   // Minus Sign:
         if len( oper2str ) = 0 .and. loperator <> 61       // Assign '-' to
            oper2str := "-"             // input (neg val)
            @  8, COL say "-"         
            COL ++
            loop
         endif
         if oper2str = "-"              // Toggle if already
            oper2str := ""              // one there and
            @  8, COL - 1 say " " // change stacked         
            COL --  // operator to '-'
            loperator := KEY
            @  6, nCOL + 18 say chr( loperator )         
            loop
         endif
      endif

      if KEY = 61   // Equals Sign:
         @  6, nCOL + 18 say " "         
         if equalsmode .and. len( trim( oper2str ) ) = 0    // Equals was last
            loperator := KEY            // key-no input
            loop
         else
            equalsmode := .T.           // Otherwise,
         endif      // turn equalsmode
      endif         // on-process input

      if equalsmode                     // Equalsmode:
         if len( trim( oper2str ) ) = 0                     // Blank out current
            loperator := KEY            // operator if no
            @  6, nCOL + 18 say if( KEY = 61, " ", chr( loperator ) ) // input; keep         
            loop    // equalsmode on
         else
            if KEY <> 61                // Otherwise,
               equalsmode := .F.        // toggle off and
               firstpass  := if( loperator = 61, .T., .F. )                     // process as a
            endif   // firstpass if
         endif      // if last "mode"
      endif         // was equalsmode

      if firstpass  // Firstpass:
         firstpass := .F.               // firstpass merely
         result    := val( oper2str )   // assigns input
         loperator := KEY               // to result, and
         operand1  := 0                 // stacks the
         operand2  := 0                 // operator for
         @  3, nCOL + 2  say operand1   picture picstring + "  " // processing the        
         @  4, nCOL + 2  say result     picture picstring // next input line              
         @  6, nCOL + 2  say result     picture picstring                                 
         @  6, nCOL + 18 say chr( KEY )                                                   
         COL := nCOL + 4
         @  8, COL say space( 13 )         
         operand1 := result
         oper2str := ""
         loop
      endif

      if len( trim( oper2str ) ) = 0    // If no input,
         loperator := KEY               // then change the
         if valtype( loperator ) = "N"
            @  6, nCOL + 18 say chr( loperator ) // stacked operator         
         endif
         loop       // loop to top
      endif

      operand2 := val( oper2str )       // Process operator:
      do case
      case loperator = 42               // (*) Multiply
         result := operand1 * operand2
      case loperator = 43               // (+) Add
         result := operand1 + operand2
      case loperator = 45               // (-) Subtract
         result := operand1 - operand2
      case loperator = 47               // (/) Divide
         result := operand1 / operand2
      endcase
      @  3, nCOL + 2  say operand1                                              picture picstring // Update display        
      @  4, nCOL + 2  say operand2                                              picture picstring                          
      @  6, nCOL + 2  say result                                                picture picstring                          
      @  3, nCOL + 18 say chr( loperator )                                                                                 
      @  6, nCOL + 18 say iif( KEY = 61, " ", chr( KEY ) ) // Don't display (=)                                            
      loperator := KEY
      COL       := nCOL + 4
      @  8, COL say space( 13 ) // Set up for next         
      operand1 := result                // operation
      oper2str := ""
      loop
      // ***************************
      //  Input = (.) or (1 thru 9)*
      // ***************************
   case KEY = 46 .or. ( KEY >= 48 .and. KEY <= 57 )         // Period (.) and
      && numbers (1-9):
      if len( oper2str ) = 13           // Upper limit of
         ?? chr( 7 )                    // input = 13 chrs
      else
         oper2str += chr( KEY )         // Otherwise, add
         @  8, COL say chr( KEY ) // digit as char         
         COL ++     // to input string
      endif
      loop
      // ***************************
      //  Input = Backspace        *
      // ***************************
   case KEY = 8 .or. KEY = 127          // Backspace:

      if len( oper2str ) = 0            // Beep if there
         ?? chr( 7 )                    // ain't anything
      else
         oper2str := left( oper2str, len( oper2str ) - 1 )  // Otherwise,
         COL --     // shorten input
         @  8, COL say " " // string         
      endif
      loop
      // ***************************
      //  Input = C/c : Clear      *
      // ***************************
   case KEY = 67 .or. KEY = 99          // Clear:
      operand1 := 0                     // Init values and
      operand2 := 0                     // the input string
      result   := 0
      oper2str := ""
      @  3, nCOL + 2 say operand1 picture picstring + "  " // Update display        
      @  4, nCOL + 2 say operand2 picture picstring                                 
      @  6, nCOL + 2 say result   picture picstring + "  "                          
      firstpass := .T.                  // Init more stuff
      loperator := 61
      COL       := nCOL + 4
      @  8, COL say space( 13 )         
      loop
      // ***************************
      //  Input = E/e: Clear Entry *
      // ***************************
   case KEY = 69 .or. KEY = 101         // Clear Entry:
      oper2str := ""                    // Init input string
      COL      := nCOL + 4
      @  8, COL say space( 13 )         
      loop
      // ***************************
      //  Input = V/v : Clear Mem  *
      // ***************************
   case KEY = 86 .or. KEY = 118         // Clear Mem:
      if memexist   // Init mem string
         memstr := ""                   // and clear mem
         @  3, nCOL - 20 clear to 6, nCOL                   // display
         memexist := .F.
      endif
      loop
      // ****************************
      //  Input = B/b: Mem to Entry *
      // ****************************
   case KEY = 66 .or. KEY = 98          // Mem to Entry:
      oper2str := memstr                // troca input
      COL      := nCOL + 4              // string with me
      @  8, COL say space( 13 ) // string and         
      @  8, COL say oper2str // display               
      COL += len( oper2str )
      loop
      // *******************************
      //  Input = N/n ou M/m: Assign Mem *
      // *******************************
   case KEY = 78 .or. KEY = 110 .or. KEY = 77 .or. KEY = 109                    // Assign Mem:
      if .not. memexist                 // If mem isn't
         @  3, 25 say "   ConteЃdo MemЂria      " // on, display         
         @  4, 25 say " +-------------------+   "                        
         @  5, 25 say " н                   н   "                        
         @  6, 25 say " +-------------------+   "                        
         memexist := .T.
      else          // Otherwise,
         @  5, 28 say space( 16 ) // clear existing         
      endif
      if KEY = - 4  // F5=copy input
         memstr := oper2str
      else          // F6=copy result
         memstr := trim( transform( result, "@zb " + picstring ) )
      endif
      @  5, 28 say memstr // Display         
      loop
      // ***************************
      //  Input = D/d: Decimals    *
      // ***************************                                && Decimals:
   case KEY = 68 .or. KEY = 100
      @ 24,  0 clea
      @ 24,  2 say "NЃmero de Casas Decimais: " get decount picture "9" range 0, 9      
      read
      @ 24,  0 say padc( "C-Limpar E-Limpar Entrada ESC-Exit D-Casas Decimais", 80 )         
      if mod( readkey(), 256 ) <> 12
         if decount <> 0
            picstring := right( "9,999,999,999", 15 - decount ) + "." + replicate( "9", decount )
         else
            picstring := "9,999,999,999.99"
         endif
         set decimals to decount        // Update display
         @  3, nCOL + 2 say operand1 picture picstring        
         @  4, nCOL + 2 say operand2 picture picstring        
         @  6, nCOL + 2 say result   picture picstring        
      endif
      loop
      // ****************************
      //  Input = None of the Above *
      // ****************************
   otherwise        // If the keypress
      ?? chr( 7 )   // was bad, beep
   endcase
enddo
setcursor( calc_cur )
setcolor( calc_cor )
restscreen( 2, nCOL - 1, 21, nCOL + 23, calc_scr )
setpos( calc_row, calc_col )
//READVAR := str( result )
READVAR := result 
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tCALC()
*+
*+    Called from ( disk50.prg   )   3 - function calc()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func tCALC( nREF )

if nREF # 0
   restscreen( 2, nCOL - 1, 21, nCOL + 23, calc_scr )
   nCOL     += nREF
   COL      += nREF
   calc_scr := savescreen( 2, nCOL - 1, 21, nCOL + 23 )
endif
//Tela da Calculadora
@  2, nCOL     say "+" + replicate( '-', 20 ) + "+"                                                                                                                                     
@  3, nCOL     say "н" + spac( 20 ) + "н"                                                                                                                                               
@  4, nCOL     say "н" + spac( 20 ) + "н"                                                                                                                                               
@  5, nCOL     say "н " + replicate( '-', 18 ) + " н"                                                                                                                                   
@  6, nCOL     say "н" + spac( 20 ) + "н"                                                                                                                                               
@  7, nCOL - 1 say "+-" + replicate( '-', 20 ) + "-+"                                                                                                                                   
@  8, nCOL - 1 say "н" + spac( 22 ) + "н"                                                                                                                                               
@  9, nCOL - 1 say "+-" + replicate( '-', 20 ) + "-+"                                                                                                                                   
@ 10, nCOL     say "н+" + replicate( '-', 3 ) + "++" + replicate( '-', 3 ) + "++" + replicate( '-', 3 ) + "++" + replicate( '-', 3 ) + "+н"                                             
@ 11, nCOL     say replicate( 'н', 2 ) + "   " + replicate( 'н', 2 ) + " / " + replicate( 'н', 2 ) + " * " + replicate( 'н', 2 ) + " - " + replicate( 'н', 2 )                          
@ 12, nCOL     say "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "нн"                                             
@ 13, nCOL     say replicate( 'н', 2 ) + " 7 " + replicate( 'н', 2 ) + " 8 " + replicate( 'н', 2 ) + " 9 " + replicate( 'н', 2 ) + "   " + replicate( 'н', 2 )                          
@ 14, nCOL     say "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "нн + " + replicate( 'н', 2 )                                                 
@ 15, nCOL     say replicate( 'н', 2 ) + " 4 " + replicate( 'н', 2 ) + " 5 " + replicate( 'н', 2 ) + " 6 " + replicate( 'н', 2 ) + "   " + replicate( 'н', 2 )                          
@ 16, nCOL     say "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "нн"                                             
@ 17, nCOL     say replicate( 'н', 2 ) + " 1 " + replicate( 'н', 2 ) + " 2 " + replicate( 'н', 2 ) + " 3 " + replicate( 'н', 2 ) + "   " + replicate( 'н', 2 )                          
@ 18, nCOL     say "н+" + replicate( '-', 3 ) + replicate( '-', 2 ) + replicate( '-', 3 ) + "н+" + replicate( '-', 3 ) + "нн = " + replicate( 'н', 2 )                                  
@ 19, nCOL     say replicate( 'н', 2 ) + "   0    " + replicate( 'н', 2 ) + " . " + replicate( 'н', 2 ) + "   " + replicate( 'н', 2 )                                                   
@ 20, nCOL     say "н+" + replicate( '-', 8 ) + "++" + replicate( '-', 3 ) + "++" + replicate( '-', 3 ) + "+н"                                                                          
@ 21, nCOL     say "+" + replicate( '-', 20 ) + "+"                                                                                                                                     
@  3, nCOL + 2 say operand1                                                                                                                                    picture picstring        
@  4, nCOL + 2 say operand2                                                                                                                                    picture picstring        
@  6, nCOL + 2 say result                                                                                                                                      picture picstring        
@ 24,  0       say padc( "C-Limpar E-Limpar Entrada ESC-Exit D-Casas Decimais", 80 )                                                                                                    
retu .T.

*+ EOF: DISK50.PRG
