*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUEDIT.PRG
*+
*+    Functions:  browse()
*+               Function xmemo()
*+               Static Function tog_insert()
*+               Static Function show_insert()
*+               Static Function statline()
*+               Static Function move_ptr()
*+               Function movp_title()
*+               Function movp_exp()
*+               Function do_seek()
*+               Function do_goto()
*+               Function do_locate()
*+               Function do_skip()
*+               Static Function EmptyFile()
*+               Static Function DoGet()
*+               Static Function ExitKey()
*+               Static Function FreshOrder()
*+               Static Function Skipped()
*+
*+    Reformatted by Click! 2.03 on Jun-27-2003 at  6:24 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "BOX.CH"
#include "inkey.ch"
#include "memoedit.ch"


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Punction browse()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function browse

local i
local j
local nHelpSave
local cNtx
local cFieldArray
local cFieldName
local nWa
local cMemo
local oB
local nRec
local cBrowseBuf
local nPrimeArea
local nHsepRow
local cEditField
local bAlias
local cAlias
local nCType
local cHead
local lMore
local lCanAppend
local cMemoBuff
local aMoveExp
local cPrimeDbf
local nColorSave
local lAppend
local lGotKey
local lKillAppend
local bColBlock
memvar keystroke
memvar help_code
memvar func_sel
memvar cur_area
memvar cur_dbf
memvar field_list
memvar frame
memvar curs_on
memvar cur_ntx
memvar ntx1
memvar dbf
memvar local_func
memvar box_open
memvar color1
memvar color7
memvar color8
memvar color9

nCType  := setcursor( 0 )
curs_on := .f.

nHelpSave := help_code

cBrowseBuf := savescreen( 8, 0, MaxRow()-1, MaxCol() )

aMoveExp := array( 4 )
afill( aMoveExp, "" )

nHsepRow := 11

if ( func_sel == 1 )
   nPrimeArea  := cur_area
   cFieldArray := "field_n" + substr( "123456", cur_area, 1 )
   cNtx        := "ntx" + substr( "123456", cur_area, 1 )
   cur_ntx     := &cNtx[ 1 ]
   cPrimeDbf   := substr( cur_dbf,  Rat(hb_ps(), cur_dbf ) + 1 )
   lCanAppend  := .T.
else
   nPrimeArea  := 1
   cFieldArray := "field_list"
   cur_ntx     := ntx1[ 1 ]
   cPrimeDbf   := substr( dbf[ 1 ],  Rat(hb_ps(), dbf[ 1 ] ) + 1 )
   lCanAppend  := .F.

   if ( "->" $ field_list[ afull( field_list ) ] )
      nHsepRow := 12
   end
end

bAlias := &( "{|i| if('->' $" + cFieldArray + "[i], Substr(" + ;
             cFieldArray + "[i], 1, At('->'," + cFieldArray + ;
             "[i]) - 1), '')}" )

select( nPrimeArea )
if ( eof() )
   go top
end

lAppend := .F.
nRec    := 0

nColorSave := setcolor( color7 )
oB         := tbrowsedb( 10, 1,  MaxRow()-1, MaxCol()-1 )

oB:headSep   := "-б-"
oB:colSep    := " н "
oB:footSep   := "-Я-"
oB:skipBlock := { | x | Skipped( x, lAppend ) }

j := len( &cFieldArray )
for i := 1 to j
   if ( empty( &cFieldArray[ i ] ) )
      exit
   end

   cEditField := &cFieldArray[ i ]
   if ( "->" $ cEditField )
      cAlias     := substr( cEditField, 1, at( "->", cEditField ) + 1 )
      cFieldName := substr( cEditField, at( "->", cEditField ) + 2 )
      cHead      := cAlias + ";" + cFieldName
      nWa        := select( cAlias )
   else
      cAlias     := ""
      cFieldName := cHead := cEditField
      nWa        := select()
   end

   if ( valtype( &cEditField ) == "M" )
      bColBlock := &( "{|| '  <Memo>  '}" )
   else
      bColBlock := fieldwblock( cFieldName, nWa )
   end

   oB:addColumn( tbcolumnnew( cHead, bColBlock ) )
next

stat_msg( "" )
scroll( 8, 0, MaxRow()-1, MaxCol(), 0 )
HB_dispbox( 8, 0, MaxRow()-1, MaxCol(),frame)
@ nHsepRow,  0 say "Ц"         
@ nHsepRow, 79 say "Е"         

cAlias      := ""
lKillAppend := .f.
if ( ( lastrec() == 0 ) .and. lCanAppend )
   keystroke := K_DOWN
   lGotKey   := .t.
else
   lGotKey := .f.
end

lMore := .t.
while ( lMore )
   if ( !lGotKey )
      while ( !oB:stabilize() )
         if ( ( keystroke := inkey() ) != 0 )
            lGotKey := .t.
            exit
         end
      end
   end

   if ( !lGotKey )
      if ( oB:hitBottom .and. lCanAppend )
         if ( !lAppend .or. recno() != lastrec() + 1 )
            if ( lAppend )
               oB:refreshCurrent()
               while ( !oB:stabilize() ) 
               end
               go bottom
            else
               lAppend := .t.
               setcursor( 1 )
               curs_on := .t.
            end

            oB:down()
            while ( !oB:stabilize() ) 
            end
            oB:colorRect( { oB:rowPos, 1, oB:rowPos, oB:colCount }, { 2, 2 } )
         end
      end

      cAlias := eval( bAlias, oB:colPos )
      statline( oB, lAppend, cAlias )

      while ( !oB:stabilize() ) 
      end

      keystroke := inkey( 0 )
   else
      lGotKey := .f.
   end

   do case
   case keystroke == K_DOWN
      if ( lAppend )
         oB:hitBottom := .t.
      else
         oB:down()
      end

   case keystroke == K_UP
      if ( lAppend )
         lKillAppend := .t.
      else
         oB:up()
      end

   case keystroke == K_PGDN
      if ( lAppend )
         oB:hitBottom := .t.
      else
         oB:pageDown()
      end

   case keystroke == K_PGUP
      if ( lAppend )
         lKillAppend := .t.
      else
         oB:pageUp()
      end

   case keystroke == K_CTRL_PGUP
      if ( lAppend )
         lKillAppend := .t.
      else
         oB:goTop()
      end

   case keystroke == K_CTRL_PGDN
      if ( lAppend )
         lKillAppend := .t.
      else
         oB:goBottom()
      end

   case keystroke == K_RIGHT
      oB:right()

   case keystroke == K_LEFT
      oB:left()

   case keystroke == K_HOME
      oB:home()

   case keystroke == K_END
      oB:end()

   case keystroke == K_CTRL_LEFT
      oB:panLeft()

   case keystroke == K_CTRL_RIGHT
      oB:panRight()

   case keystroke == K_CTRL_HOME
      oB:panHome()

   case keystroke == K_CTRL_END
      oB:panEnd()

   case keystroke == K_DEL
      while ( !oB:stabilize() ) 
      end
      cAlias := eval( bAlias, oB:colPos )
      if ( !empty( cAlias ) )
         select( cAlias )
      end

      if ( recno() != lastrec() + 1 )
         if deleted()
            recall
         else
            netrecdel()
         end
      end

      select( nPrimeArea )

   case keystroke == K_INS
      tog_insert()

   case keystroke == K_ENTER .or. ;
              keystroke == K_ALT_INS .or. ;
              keystroke == K_ALT_O .or. ;
              keystroke == K_ALT_P .or. ;
              keystroke == K_ALT_G .or. ;
              keystroke == K_ALT_K .or. ;
              keystroke == K_ALT_L .or. ;
              keystroke == K_ALT_B .or. ;
              keystroke == K_ALT_N .or. ;
              keystroke == K_ALT_M

      while ( !oB:stabilize() ) 
      end
      cAlias := eval( bAlias, oB:colPos )

      if ( !empty( cAlias ) )
         select( cAlias )
      end

      if ( !lAppend .and. ( recno() == lastrec() + 1 ) )
         select( nPrimeArea )
         loop
      end

      select( nPrimeArea )

      oB:hitTop := .f.
      Statline( oB, lAppend, cAlias )
      while ( !oB:stabilize() ) 
      end

      cEditField := &cFieldArray[ oB:colPos ]

      setcursor( 1 )
      curs_on := .t.

      if keystroke == K_ALT_INS
         XALTINS()
      endif

      if ( type( cEditField ) == "M" )
         help_code := 19
         box_open  := .t.

         cMemoBuff := savescreen( 08, 00, maxrow(), maxcol()-1 )

         setcolor( color8 )
         scroll( 08, 00, maxrow(), maxcol()-1, 0 )
         HB_dispbox( 8, 0, MaxRow()-1, MaxCol(),frame)
         @ 24, 01 say 'Linha:' + spac( 5 ) + 'Coluna:'         
         @ 24, 40 say 'Ctrl+W -> Grava, ESC -> Anula '         

         setcolor( color9 )
         @ 08, ( ( 76 - len( cEditField ) ) / 2 ) say "  " + cEditField + "  "         

         setcolor( color8 )
         //cMemo := memoedit( &cEditField, 09, 01, 22, 78, .T., "xmemo" )
         cMemo := MemoEdit(&cEditField, 11, 11, MaxRow()-3, 68,.T.,"xmemo")

         if lastkey() == K_CTRL_END

            if ( lAppend .and. eof() )
               netrecapp()
            end

            netreclock()
            field->&cEditField := cMemo
            dbunlock()

            oB:refreshCurrent()

            keystroke := K_RIGHT
            lGotKey   := .t.
         else
            keystroke := 0
         end

                  
         RestScreen(08, 00, MaxRow(), maxcol()-1, cMemoBuff)
         
         box_open := .F.
      else
         setcolor( color1 )
         keystroke := DoGet( oB, lAppend, cAlias )
         lGotKey   := ( keystroke != 0 )
      end

      if ( !lAppend )
         setcursor( 0 )
         curs_on := .f.
      end

      help_code := nHelpSave
      setcolor( color7 )

      //Control+Ins - Capturando
   case keystroke == K_CTRL_INS
      while ( !oB:stabilize() ) 
      end
      cAlias := eval( bAlias, oB:colPos )
      if ( !empty( cAlias ) )
         select( cAlias )
      end
      if ( !lAppend .and. ( recno() == lastrec() + 1 ) )
         select( nPrimeArea )
         loop
      end
      select( nPrimeArea )
      oB:hitTop := .f.
      Statline( oB, lAppend, cAlias )
      while ( !oB:stabilize() ) 
      end
      cEditField := &cFieldArray[ oB:colPos ]
      READVAR    := &cEditField
   otherwise
      if ( isdata( keystroke ) )
         keyboard chr( K_ENTER ) + chr( keystroke )
      else
         //Chama Leityra da Tecla
         sysmenu()

         do case
         case q_check()
            lMore := .f.

         case local_func == 7
            nRec := recno()
            move_ptr( aMoveExp, cPrimeDbf )

            if ( nRec != recno() )
               if ( lAppend )
                  lKillAppend := .t.
               else
                  FreshOrder( oB )
               end
            end
         end
      end
   end

   if ( lKillAppend )
      lKillAppend := .f.
      lAppend     := .f.

      FreshOrder( oB )
      setcursor( 0 )
      curs_on := .f.
   end
end

restscreen( 8, 0, MaxRow()-1, MaxCol(), cBrowseBuf )
setcolor( nColorSave )
setcursor( nCType )
curs_on := ( nCType != 0 )
stat_msg( "" )

return

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function xmemo()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func xmemo( mmode, line, col )

local nRet
memvar keystroke
memvar local_func
setcolor( color9 )
@ 24, 07 say line pict '####'        
@ 24, 19 say col  pict '####'        
setcolor( color8 )

nRet := 0

if mmode <> ME_IDLE
   keystroke := lastkey()
   sysmenu()

   do case
   case keystroke == K_ALT_INS
      XALTINS()
   case keystroke == K_INS
      tog_insert()
      nRet := ME_IGNORE

   case keystroke == K_ESC
      if mmode == ME_UNKEYX
         if rsvp( "Ok. Abandonar Mudanas? (S/N)" ) <> "S"
            nRet := ME_IGNORE
         end
      end
   end
end

return ( nRet )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function tog_insert()
*+
*+    Called from ( dbuedit.prg  )   1 - browse()
*+                                   1 - function xmemo()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func tog_insert

local nCType

readinsert( !readinsert() )
nCType := setcursor( 0 )
show_insert()
setcursor( nCType )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function show_insert()
*+
*+    Called from ( dbuedit.prg  )   1 - static function tog_insert()
*+                                   1 - static function statline()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func show_insert

local nColorSave

nColorSave := setcolor( color7 )
@  9,  4 say if( readinsert(), "<Inserindo>", "           " )         
setcolor( nColorSave )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function statline()
*+
*+    Called from ( dbuedit.prg  )   3 - browse()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func statline( oB, lAppend, cAlias )

local cColorSave
local cCurrAlias
local lNoFilter
local nWaSave
local nCType

nCType := setcursor( 0 )

nWaSave := select()
if ( !empty( cAlias ) )
   select( cAlias )
end

cColorSave := setcolor( color7 )

show_insert()

lNoFilter := empty( &( "kf" + substr( "123456", select(), 1 ) ) )
@  9, 16 say if( lNoFilter, "        ", "<Filtro>" )         

@  9, 41 say if( empty( cAlias ), space( 10 ), Lpad( cAlias + "->", 10 ) ) ;         
        + "Reg :"

if ( EmptyFile() .and. .not. lAppend )
   @  9, 57 say "<nada>              "         
elseif ( eof() )
   @  9, 28 say "         "                                               
   @  9, 57 say "            " + if( lAppend, "<novo>", "<fim>" )         
else
   @  9, 28 say if( deleted(), "<Apagado>", "         " )                                        
   @  9, 57 say pad( ltrim( str( recno() ) ) + "/" + ltrim( str( lastrec() ) ), 15 ) + ;         
           if( oB:hitTop, " <Ini>", if( oB:hitBottom, " <fim>", "      " ) )
end

setcolor( cColorSave )
select( nWaSave )
setcursor( nCType )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function move_ptr()
*+
*+    Called from ( dbuedit.prg  )   1 - browse()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func move_ptr( aMoveExp, cPrimeDbf )

local nHelpSave
local aBox
memvar okee_dokee
memvar k_trim
memvar movp_sel
memvar titl_str
memvar exp_label
memvar help_code
memvar local_sel
memvar ntx_expr
private okee_dokee
private k_trim
private movp_sel
private titl_str
private exp_label
private ntx_expr

nHelpSave := help_code

movp_sel := local_sel

k_trim := aMoveExp[ movp_sel ]

aBox := array( 4 )

aBox[ 1 ] := "movp_title(sysparam)"
aBox[ 2 ] := "movp_exp(sysparam)"
aBox[ 3 ] := "ok_button(sysparam)"
aBox[ 4 ] := "can_button(sysparam)"

do case
case movp_sel == 1
   okee_dokee := "do_seek()"
   titl_str   := "Busca no Arquivo " + cPrimeDbf + "..."
   exp_label  := "Expresso"
   ntx_expr   := indexkey( 0 )
   help_code  := 13

case movp_sel == 2
   okee_dokee := "do_goto()"
   titl_str   := "Mover pontos no arquivo " + cPrimeDbf + " para..."
   exp_label  := "Registro#"
   help_code  := 14

case movp_sel == 3
   okee_dokee := "do_locate()"
   titl_str   := "Localizando no arquivo " + cPrimeDbf + "..."
   exp_label  := "Expresso"
   help_code  := 10

case movp_sel == 4
   okee_dokee := "do_skip()"
   titl_str   := "Pulando registro no arquivo " + cPrimeDbf + "..."
   exp_label  := "NЃmero"
   help_code  := 20
end

set key K_INS to tog_insert
multibox( 14, 17, 5, 2, aBox )
set key K_INS to

aMoveExp[ movp_sel ] := k_trim

help_code := nHelpSave

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function movp_title()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func movp_title( sysparam )

memvar titl_str
return ( box_title( sysparam, titl_str ) )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function movp_exp()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func movp_exp( sysparam )

memvar exp_label
return ( get_k_trim( sysparam, exp_label ) )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_seek()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func do_seek

local lDone
local nRec
local cSeekType
memvar k_trim
memvar ntx_expr

lDone := .F.

if empty( k_trim )
   error_msg( "Expresso no entrada" )
else
   stat_msg( "Procurando.." )

   nRec := recno()

   cSeekType := type( ntx_expr )

   do case
   case cSeekType == "C"
      seek k_trim

   case cSeekType == "N"
      seek val( k_trim )

   case cSeekType == "D"
      seek ctod( k_trim )
   end

   if found()
      stat_msg( "Encontrado" )
      lDone := .T.
   else
      error_msg( "No Encontrado" )
      goto nRec
   end
end

return ( lDone )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_goto()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func do_goto

local lDone
local nWhich
memvar k_trim

lDone  := .F.
nWhich := val( k_trim )

do case
case empty( k_trim )
   error_msg( "NЃmero de Registro no fornecido" )

case .not. substr( ltrim( k_trim ), 1, 1 ) $ "-+1234567890"
   error_msg( "NЃmero de Registro no  numrico" )

case nWhich <= 0 .or. nWhich > lastrec()
   error_msg( "Registro fora de faixa" )

otherwise
   goto nWhich
   lDone := .T.

end

return ( lDone )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_locate()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func do_locate

local lDone
local nRec
memvar k_trim

lDone := .F.

do case
case empty( k_trim )
   error_msg( "Expresso no forencida" )

case type( k_trim ) <> "L"
   error_msg( "Expresso tipo deve ser LЂgica" )

otherwise
   nRec := recno()
   stat_msg( "Procurando.." )

   if &k_trim
      skip
   end

   locate for &k_trim while .T.

   if found()
      stat_msg( "Achado" )
      lDone := .T.

   else
      error_msg( "No Achado" )
      goto nRec
   end
end

return ( lDone )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_skip()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func do_skip

local lDone
local nSkip
memvar k_trim

lDone := .F.
nSkip := val( k_trim )

do case
case empty( k_trim )
   error_msg( "Fornea o nЃmero de saltos" )

case .not. substr( ltrim( k_trim ), 1, 1 ) $ "-+1234567890"
   error_msg( "Saltos no  um valor nЃmerico" )

case nSkip == 0
   error_msg( "Salto com valor zero" )

otherwise
   lDone := .T.

   skip nSkip

   if eof()
      go bottom
   end

   if bof()
      go top
   end
end

return ( lDone )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function EmptyFile()
*+
*+    Called from ( dbuedit.prg  )   1 - static function statline()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func EmptyFile()

if ( lastrec() == 0 )
   return ( .t. )
end

if ( ( eof() .or. recno() == lastrec() + 1 ) .and. bof() )
   return ( .t. )
end

return ( .f. )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function DoGet()
*+
*+    Called from ( dbuedit.prg  )   1 -  browse()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func DoGet( oB, lAppend, cAlias )

local lExitSave
local oCol
local oGet
local nKey
local cExpr
local xEval
local lFresh
local nWaSave

lExitSave := set( _SET_EXIT, .t. )
nWaSave   := select()
if ( !empty( cAlias ) )
   select( cAlias )
end

set key K_INS to tog_insert
xkey_clear()

cExpr := indexkey( 0 )
if ( !empty( cExpr ) )
   xEval := &cExpr
end

oCol := oB:getColumn( oB:colPos )

mGetVar := eval( oCol:block )

if type( "mGetVar" ) = "C"
   do case
   case keystroke == K_ALT_O 
      XPOSESQ( "", 0, "mGetVar" )
   case keystroke == K_ALT_P 
      XPOSDIR( "", 0, "mGetVar" )
   case keystroke == K_ALT_G 
      XCENTER( "", 0, "mGetVar" )
   case keystroke == K_ALT_K 
      TIRACE( mGetVar )
   case keystroke == K_ALT_L 
      XEXPAND( "", 0, "mGetVar" )
   case keystroke == K_ALT_B 
      XCAPFIRS( "", 0, "mGetVar" )
   case keystroke == K_ALT_N 
      CONVMINI( mGetVar )
   case keystroke == K_ALT_M 
      CONVMAIS( mGetVar )
   endcase
endif

//Verifica se mGetVar e caracter e com string maior 78 da um pict @S
if type( "mGetVar" ) = "C" .and. len( mGetVar ) > MaxCol()-1
   oGet := getnew( row(), col(), ;
                   { | x | if( pcount() == 0, mGetVar, mGetVar := x ) }, ;
                   "mGetVar", "@S"+hb_ntos( MaxCol()-1 ) )
else
   oGet := getnew( row(), col(), ;
                   { | x | if( pcount() == 0, mGetVar, mGetVar := x ) }, ;
                   "mGetVar" )
endif
lFresh := .f.

if ( readmodal( { oGet } ) )
   if ( lAppend .and. recno() == lastrec() + 1 )
      netrecapp()
   end

   eval( oCol:block, mGetVar )

   if ( !empty( cExpr ) .and. !lAppend )
      if ( xEval != &cExpr )
         lFresh := .t.
      end
   end
end

select( nWaSave )
if ( lFresh )
   FreshOrder( oB )

   nKey := 0
else
   oB:refreshCurrent()

   nKey := ExitKey( lAppend )
end

if ( lAppend )
   oB:colorRect( { oB:rowPos, 1, oB:rowPos, oB:colCount }, { 2, 2 } )
end

set( _SET_EXIT, lExitSave )
set key K_INS to
xkey_norm()

return ( nKey )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function ExitKey()
*+
*+    Called from ( dbuedit.prg  )   1 - static function doget()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func ExitKey( lAppend )

memvar keystroke

keystroke := lastkey()
if ( keystroke == K_PGDN )
   if ( lAppend )
      keystroke := 0
   else
      keystroke := K_DOWN
   end

elseif ( keystroke == K_PGUP )
   if ( lAppend )
      keystroke := 0
   else
      keystroke := K_UP
   end

elseif ( keystroke == K_ENTER .or. isdata( keystroke ) )
   keystroke := K_RIGHT

elseif ( keystroke != K_UP .and. keystroke != K_DOWN .and. menu_key() == 0 )
   keystroke := 0
end

return ( keystroke )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function FreshOrder()
*+
*+    Called from ( dbuedit.prg  )   2 -  browse()
*+                                   1 - static function doget()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func FreshOrder( oB )

local nRec

nRec := recno()
oB:refreshAll()

while ( !oB:stabilize() ) 
end

if ( nRec != lastrec() + 1 )
   while ( recno() != nRec )
      oB:up()
      while ( !oB:stabilize() ) 
      end
   end
end

return ( NIL )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Static Function Skipped()
*+
*+    Called from ( dbuedit.prg  )   1 -  browse()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
static func Skipped( nRequest, lAppend )

local nCount

nCount := 0
if ( lastrec() != 0 )
   if ( nRequest == 0 )
      skip 0

   elseif ( nRequest > 0 .and. recno() != lastrec() + 1 )
      while ( nCount < nRequest )
         skip 1
         if ( eof() )
            if ( lAppend )
               nCount ++
            else
               skip - 1
            end

            exit
         end

         nCount ++
      end

   elseif ( nRequest < 0 )
      while ( nCount > nRequest )
         skip - 1
         if ( bof() )
            exit
         end

         nCount --
      end
   end
end

return ( nCount ) 

*+ EOF: DBUEDIT.PRG
