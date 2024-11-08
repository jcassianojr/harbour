
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUUTIL.PRG
*+
*+    Functions: Function setup()
*+               Function multibox()
*+               Function matrix()
*+               Function to_ok()
*+               Function to_can()
*+               Function ok_button()
*+               Function can_button()
*+               Function filelist()
*+               Function fieldlist()
*+               Function itemlist()
*+               Function i_func()
*+               Function getfile()
*+               Function g_getfile()
*+               Function genfield()
*+               Function get_exp()
*+               Function not_empty()
*+               Function filebox()
*+               Function box_title()
*+               Function get_k_trim()
*+               Function sysmenu()
*+               Function menu_key()
*+               Function mu_func()
*+               Function xkey_clear()
*+               Function xkey_norm()
*+               Function lite_fkey()
*+               Function dim_fkey()
*+               Function key_ready()
*+               Function read_key()
*+               Function raw_key()
*+               Function q_check()
*+               clear_gets()
*+               Function all_fields()
*+               Function not_target()
*+               Function dup_ntx()
*+               Function stat_msg()
*+               Function error_msg()
*+               Function error_off()
*+               Function rsvp()
*+               Function name()
*+               Function pad()
*+               Function aseek()
*+               Function array_ins()
*+               Function array_del()
*+               Function afull()
*+               Function array_sort()
*+               Function array_dir()
*+               Function ntx_key()
*+               Function isdata()
*+               Function lpad()
*+               Function hi_cur()
*+               Function dehi_cur()
*+               Function enter_rc()
*+               Function OBTER()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function setup()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function setup

private k
private t
private n
private i
private j
private field_n
private s_alias
private k_filter
private ntx
private file_name
private k_1
private k_2
private k_3
private k_4
private k_5
private k_6
private k_7

stat_msg( "Preparando para ver" )

if M->need_field
   need_field := .F.

   k := afull( M->field_list )

   n := 1
   i := 1

   do while M->n <= 6 .and. M->i <= len( M->field_list )

      if empty( dbf[ M->n ] )
         exit

      endif

      field_n := "field_n" + substr( "123456", M->n, 1 )

      if .not. empty( &field_n[ 1 ] )
         s_alias := if( M->n > 1, name( dbf[ M->n ] ) + "->", "" )
         afill( M->field_list, M->s_alias, M->i, afull( &field_n ) )

         j := 1

         do while M->j <= len( &field_n ) .and. M->i <= len( M->field_list )

            if empty( &field_n[ M->j ] )
               exit

            endif

            field_list[ M->i ] = field_list[ M->i ] + &field_n[ M->j ]

            i := M->i + 1
            j := M->j + 1

         enddo
      endif

      n := M->n + 1

   enddo

   if M->i <= M->k
      afill( M->field_list, "", M->i )

   endif
endif

if M->need_ntx
   need_ntx := .F.

   n := 1

   do while M->n <= 6

      if empty( dbf[ M->n ] )
         exit

      endif

      ntx := "ntx" + substr( "123456", M->n, 1 )

      if .not. empty( &ntx[ 1 ] )
         k_1 := k_2 := k_3 := k_4 := k_5 := k_6 := k_7 := ""

         select( M->n )

         i := 1

         do while M->i <= 7 .and. empty( M->view_err )

            if empty( &ntx[ M->i ] )
               exit

            endif

            file_name := &ntx[ M->i ]

            if file( M->file_name )
               k  := "k_" + substr( "1234567", M->i, 1 )
               &k := M->file_name
               i  := M->i + 1

            else
               view_err := "No Pode-se abrir arquivo de indice " + M->file_name

            endif
         enddo

         if empty( M->view_err )
            set index to &k_1, &k_2, &k_3, &k_4, &k_5, &k_6, &k_7

         else
            need_ntx := .T.
            return 0

         endif
      endif

      n := M->n + 1

   enddo
endif

if M->need_relat
   need_relat := .F.

   for j := 1 to 5
      select( M->j )
      set relation to

   next

   j := 1

   do while M->j <= len( M->k_relate )

      if empty( k_relate[ M->j ] )
         exit

      endif

      n := asc( s_relate[ M->j ] ) - asc( "A" ) + 1
      select( M->n )

      k := k_relate[ M->j ]
      t := substr( t_relate[ M->j ], 2 )

      set relation additive to &k INTO &t

      j := M->j + 1

   enddo

   select 1
   go top

endif

if M->need_filtr
   need_filtr := .F.

   n := 1

   do while M->n <= 6

      if empty( dbf[ M->n ] )
         exit

      endif

      k_filter := "kf" + substr( "123456", M->n, 1 )

      if .not. empty( &k_filter )
         select( M->n )

         do case

         case M->n = 1
            set filter to &kf1

         case M->n = 2
            set filter to &kf2

         case M->n = 3
            set filter to &kf3

         case M->n = 4
            set filter to &kf4

         case M->n = 5
            set filter to &kf5

         case M->n = 6
            set filter to &kf6

         endcase

         go top

      endif

      n := M->n + 1

   enddo
endif

stat_msg( "" )
return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function multibox()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function multibox

parameters wt, wl, wh, beg_c, boxarray
local saveColor
private sysparam
private state
private cursor
private funcn
private winbuff
private save_help
private prime_help
private x
private colorNorm
private colorHilite

colorNorm   := color8
colorHilite := color10

box_open := .T.

save_help  := M->help_code
prime_help := M->help_code

DECLARE box_row[ len( M->boxarray ) ]
DECLARE box_col[ len( M->boxarray ) ]

winbuff := savescreen( M->wt, M->wl, M->wt + M->wh + 1, M->wl + 45 )

saveColor := setcolor( M->colorNorm )
scroll( M->wt, M->wl, M->wt + M->wh + 1, M->wl + 45, 0 )
HB_dispbox( M->wt, M->wl, M->wt + M->wh + 1, 79,frame)

//@ M->wt, M->wl, M->wt + M->wh + 1, M->wl + 45 box frame

sysparam := 1

for cursor := 1 to len( M->boxarray )
   funcn := boxarray[ M->cursor ]
   x     := &funcn
   box_row[ M->cursor ] = row()
   box_col[ M->cursor ] = col()

next

cursor := M->beg_c
state  := 2

do while M->state <> 0 .and. M->state <> 4
   funcn := boxarray[ M->cursor ]

   do case

   case M->state = 2

      if .not. key_ready()
         sysparam := 2
         x        := &funcn

         read_key()

      endif

      do case

      case M->keystroke = 13 .or. isdata( M->keystroke )
         state := 3

      case q_check()
         state := 0

      otherwise
         sysparam := 3
         x        := &funcn

         cursor := matrix( M->cursor, M->keystroke )

      endcase

   case M->state = 3
      sysparam := 4

      state := &funcn

   endcase
enddo

restscreen( M->wt, M->wl, M->wt + M->wh + 1, M->wl + 45, M->winbuff )
setcolor( saveColor )

keystroke := 0
box_open  := .F.
help_code := M->save_help

return M->state

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function matrix()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function matrix

parameters old_curs, k
private old_row
private old_col
private test_curs
private new_curs

old_row := row()
old_col := box_col[ M->old_curs ]

new_curs := M->old_curs

test_curs := M->old_curs

do case

case M->k = 19 .or. M->k = 219

   do while M->test_curs > 2
      test_curs := M->test_curs - 1

      if box_col[ M->test_curs ] < M->old_col .and. ;
                 box_row[ M->test_curs ] >= M->old_row

         if box_row[ M->test_curs ] < box_row[ M->new_curs ] ;
                    .or. M->new_curs = M->old_curs
            new_curs := M->test_curs

         endif
      endif
   enddo

case M->k = 4

   do while M->test_curs < len( M->box_col )
      test_curs := M->test_curs + 1

      if box_col[ M->test_curs ] > M->old_col .and. ;
                 box_row[ M->test_curs ] <= M->old_row

         if box_row[ M->test_curs ] > box_row[ M->new_curs ] ;
                    .or. M->new_curs = M->old_curs
            new_curs := M->test_curs

         endif
      endif
   enddo

case M->k = 5

   do while M->test_curs > 2
      test_curs := M->test_curs - 1

      if box_row[ M->test_curs ] < M->old_row .and. ;
                 box_col[ M->test_curs ] <= M->old_col

         if box_col[ M->test_curs ] > box_col[ M->new_curs ] ;
                    .or. M->new_curs = M->old_curs
            new_curs := M->test_curs

         endif
      endif
   enddo

case M->k = 24

   do while M->test_curs < len( M->box_row )
      test_curs := M->test_curs + 1

      if box_row[ M->test_curs ] > M->old_row .and. ;
                 box_col[ M->test_curs ] >= M->old_col

         if box_col[ M->test_curs ] < box_col[ M->new_curs ] ;
                    .or. M->new_curs = M->old_curs
            new_curs := M->test_curs

         endif
      endif
   enddo
endcase

return M->new_curs

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function to_ok()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function to_ok

cursor := ascan( M->boxarray, "ok_button(sysparam)" ) - 1

keyboard chr( 24 )

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function to_can()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function to_can

cursor := ascan( M->boxarray, "can_button(sysparam)" )

keyboard chr( 24 )

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ok_button()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ok_button

parameters sysparam
local saveColor
private ok
private reply

help_code := M->prime_help

ok        := " Ok "
reply     := 2
saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + M->wh, M->wl + 8 say M->ok

   if M->sysparam = 1
      @ M->wt + M->wh, M->wl + 9 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->wt + M->wh, M->wl + 8 say M->ok

case M->sysparam = 4 .and. M->keystroke = 13

   if &okee_dokee
      reply := 4

   endif
endcase

setcolor( saveColor )
return M->reply

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function can_button()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function can_button

parameters sysparam
local saveColor
private can
private reply

help_code := M->prime_help

can       := " Cancele "
reply     := 2
saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + M->wh, M->wl + 17 say M->can

   if M->sysparam = 1
      @ M->wt + M->wh, M->wl + 17 say ""

   endif

case M->sysparam = 2
   saveColor := setcolor( M->colorHilite )
   @ M->wt + M->wh, M->wl + 17 say M->can

case M->sysparam = 4 .and. M->keystroke = 13
   reply := 0

endcase

setcolor( saveColor )
return M->reply

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function filelist()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function filelist

parameters sysparam

return itemlist( M->sysparam, 32, "filename", M->files, "*" + M->def_ext, .T. )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function fieldlist()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function fieldlist

parameters sysparam

return itemlist( M->sysparam, 34, "field_mvar", "field_m", "Fields", .F. )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function itemlist()
*+
*+    Called from ( dbuutil.prg  )   1 - function filelist()
*+                                   1 - function fieldlist()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function itemlist

parameters sysparam, l_rel, mvar, items, i_title, go_ok
local saveColor
private n
private x
private i_full

help_code := M->prime_help
saveColor := setcolor( colorNorm )

i_full := afull( &items )

do case

case M->sysparam = 1
   scroll( M->wt + 1, M->wl + M->l_rel - 1, M->wt + M->wh, M->wl + 44, 0 )
   HB_dispbox( M->wt, M->wl + M->l_rel - 2, M->wt + M->wh + 1, M->wl + 45,M->lframe)
   //@ M->wt, M->wl + M->l_rel - 2, M->wt + M->wh + 1, M->wl + 45 ;
           //box M->lframe

   i_title := replicate( "-", ( ( 46 - M->l_rel - len( M->i_title ) ) / 2 ) - 1 ) ;
                         + " " + M->i_title + " "
   i_title := M->i_title + replicate( "-", ( 46 - M->l_rel - len( M->i_title ) ) )

   @ M->wt + 1, M->wl + M->l_rel - 1 say M->i_title

   if .not. empty( &items[ 1 ] )
      achoice( M->wt + 2, M->wl + M->l_rel, M->wt + M->wh, M->wl + 43, ;
               &items, .F., "i_func", M->cur_el, M->rel_row )

   endif

   @ M->wt + 2, M->wl + M->l_rel say ""

case M->sysparam = 2

   if empty( &items[ 1 ] )
      keyboard ( chr( 219 ) )

   else
      cur_el  := M->cur_el - M->rel_row + row() - M->wt - 2
      rel_row := row() - M->wt - 2

      n := achoice( M->wt + 2, M->wl + M->l_rel, M->wt + M->wh, ;
                    M->wl + 43, &items, .T., "i_func", M->cur_el, ;
                    M->rel_row )

      sysmenu()

      do case

      case M->keystroke = 13
         &mvar := &items[ M->n ]

         x := &fi_disp

         if M->go_ok
            to_ok()

         else
            keyboard chr( 219 ) + chr( 24 )

         endif

      case M->keystroke = 19
         keyboard chr( 219 )

      case M->keystroke = 0

         keyboard chr( 11 )

      otherwise
         keyboard chr( M->keystroke )

      endcase
   endif
endcase

setcolor( saveColor )
return 2

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function i_func()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function i_func

parameters amod, sel, rel
private r
private srow
private scol

srow := row()
scol := col()

if M->error_on
   error_off()

endif

if M->amod = 4
   r := 0

else
   cur_el  := M->sel
   rel_row := M->rel

   r := 2

   keystroke := lastkey()

endif

if M->cur_el > M->rel_row + 1
   @ M->wt + 2, M->wl + 44 say M->more_up

else
   @ M->wt + 2, M->wl + 44 say " "

endif

if M->i_full - M->cur_el > M->wh - 2 - M->rel_row
   @ M->wt + M->wh, M->wl + 44 say M->more_down

else
   @ M->wt + M->wh, M->wl + 44 say " "

endif

if M->amod = 3

   do case

   case M->keystroke = 27
      r := 0

   case M->keystroke = 13 .or. M->keystroke = 19 .or. M->keystroke = 219
      r := 1

   case M->keystroke = 1
      keyboard chr( 31 )

   case M->keystroke = 6
      keyboard chr( 30 )

   case isdata( M->keystroke )
      r := 3

   case menu_key() <> 0
      r := 0

   endcase
endif

@ M->srow, M->scol say ""

return M->r

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function getfile()
*+
*+    Called from ( dbucopy.prg  )   1 - function trg_getfil()
*+                                   1 - function src_getfil()
*+                ( dbuindx.prg  )   1 - function ntx_getfil()
*+                ( dbuutil.prg  )   1 - function g_getfile()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function getfile

parameters sysparam, row_off
local saveColor
private irow
private name_temp

help_code := M->prime_help

irow      := M->wt + M->row_off
saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->irow, M->wl + 2 say "Arquivo " + pad( M->filename, 20 )

   if M->sysparam = 1
      @ M->irow, M->wl + 9 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->irow, M->wl + 9 say pad( M->filename, 20 )

case M->sysparam = 4

   if M->keystroke <> 13
      
      keyboard chr( M->keystroke )

   endif

   set key 24 to clear_gets

   name_temp := enter_rc( M->filename, M->irow, M->wl + 9, 64, "@KS20", M->color9 )

   set key 24 to

   if .not. empty( M->name_temp )

      if .not. ( rat( ".", M->name_temp ) > rat( hb_ps(), M->name_temp ) )
         name_temp := M->name_temp + M->def_ext

      endif

      filename := M->name_temp

   else

      if M->keystroke = 13 .or. M->keystroke = 24
         M->filename := ""

      endif
   endif

   if M->keystroke = 13

      if &fi_done
         @ M->irow, M->wl + 9 say pad( M->filename, 20 )

      endif

   else

      if M->keystroke <> 27 .and. .not. isdata( M->keystroke )
         keyboard chr( M->keystroke )

      endif
   endif
endcase

setcolor( saveColor )
return 2

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function g_getfile()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function g_getfile

parameters sysparam

return getfile( M->sysparam, 4 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function genfield()
*+
*+    Called from ( dbucopy.prg  )   1 - function repl_field()
*+                ( dbuview.prg  )   1 - function getfield()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function genfield

parameters sysparam, is_replace

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + 3, M->wl + 2 say "Arquivo" + pad( M->field_mvar, 20 )

   if M->sysparam = 1
      @ M->wt + 3, M->wl + 9 say ""

   endif

case M->sysparam = 2 .or. M->sysparam = 4

   if M->lkey = 5
      keyboard chr( 4 )

   else

      if M->is_replace
         keyboard chr( 24 )

      else

         if empty( M->field_mvar )
            to_can()

         else
            to_ok()

         endif
      endif
   endif
endcase

return 2

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_exp()
*+
*+    Called from ( dbucopy.prg  )   2 - function with_exp()
*+                                   1 - function for_exp()
*+                                   1 - function while_exp()
*+                ( dbuindx.prg  )   1 - function ntx_exp()
*+                                   1 - function ntx_tag()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_exp

parameters sysparam, xlable, row_off, mvar
local saveColor
private erow
private k_input

erow      := M->wt + M->row_off
saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->erow, M->wl + 2 say M->xlable + pad( &mvar, 20 )

   if M->sysparam = 1
      @ M->erow, M->wl + 9 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->erow, M->wl + 9 say pad( &mvar, 20 )

case M->sysparam = 4

   if M->keystroke <> 13
      keyboard chr( M->keystroke )

   endif

   set key 5 to clear_gets
   set key 24 to clear_gets

   k_input := enter_rc( &mvar, M->erow, M->wl + 9, 127, "@KS20", M->color9 )

   set key 5 to
   set key 24 to

   if .not. empty( M->k_input )
      &mvar := M->k_input

      if M->keystroke <> 5 .and. .not. isdata( M->keystroke )
         keystroke := 24

      endif

   else

      if M->keystroke = 13 .or. M->keystroke = 5 .or. M->keystroke = 24
         &mvar := ""

      endif
   endif

   if M->keystroke <> 13 .and. M->keystroke <> 27 .and. ;
              .not. isdata( M->keystroke )
      keyboard chr( M->keystroke )

   endif
endcase

setcolor( saveColor )
return 2

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function not_empty()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function not_empty

parameters mvar
private done_ok

done_ok := .not. empty( &mvar )

if M->done_ok
   to_ok()

endif

return M->done_ok

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function filebox()
*+
*+                ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuview.prg  )   1 - function open_dbf()
*+                                   1 - function get_ntx()
*+                                   1 - function save_view()
*+                                   1 - function set_from()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function filebox

parameters def_ext, files, titl_func, do_func, creat_flag, box_top
private rel_row
private cur_el
private fi_disp
private okee_dokee
private fi_done
private bcur

DECLARE boxarray[ 5 ]

boxarray[ 1 ] = M->titl_func + "(sysparam)"
boxarray[ 2 ] = "g_getfile(sysparam)"
boxarray[ 3 ] = "ok_button(sysparam)"
boxarray[ 4 ] = "can_button(sysparam)"
boxarray[ 5 ] = "filelist(sysparam)"

cur_el     := 1
rel_row    := 0
fi_disp    := "g_getfile(3)"
fi_done    := "not_empty('filename')"
okee_dokee := M->do_func + "()"

if M->creat_flag

   if empty( filename )
      bcur := 2

   else
      bcur := 3

   endif

else
   bcur := 5

endif

return multibox( M->box_top, 17, 7, M->bcur, M->boxarray )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function box_title()
*+
*+    Called from ( dbucopy.prg  )   1 - function copy_title()
*+                                   1 - function appe_title()
*+                                   1 - function repl_title()
*+                ( dbuedit.prg  )   1 - function movp_title()
*+                ( dbuger.prg   )   1 - function sdf_cab()
*+                                   1 - function dlm_cab()
*+                                   1 - function def_cab()
*+                ( dbuindx.prg  )   1 - function ntx_title()
*+                ( dbustru.prg  )   1 - function stru_title()
*+                ( dbuview.prg  )   1 - function dopen_titl()
*+                                   1 - function xopen_titl()
*+                                   1 - function fsel_title()
*+                                   1 - function fltr_title()
*+                                   1 - function vcrea_titl()
*+                                   1 - function vopen_titl()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function box_title

parameters sysparam, boxtitle

if M->sysparam = 1
   @ M->wt + 1, M->wl + 2 say M->boxtitle
   @ M->wt + 1, M->wl + 2 say ""

endif

return 2

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_k_trim()
*+
*+    Called from ( dbuedit.prg  )   1 - function movp_exp()
*+                ( dbuview.prg  )   1 - function getfilter()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_k_trim

parameters sysparam, k_label
local saveColor
private k_input

saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + 3, M->wl + 2 say pad( M->k_label, 12 ) + pad( M->k_trim, 30 )

   if M->sysparam = 1
      @ M->wt + 3, M->wl + 9 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->wt + 3, M->wl + 14 say pad( M->k_trim, 30 )

case M->sysparam = 4

   if M->keystroke <> 13
      keyboard chr( M->keystroke )

   endif

   set key 24 to clear_gets

   k_input := enter_rc( M->k_trim, M->wt + 3, M->wl + 14, 127, "@KS30", ;
                        M->color9 )

   set key 24 to

   if .not. empty( M->k_input )
      k_trim := M->k_input

      keystroke := 24

   else

      if M->keystroke = 13 .or. M->keystroke = 24
         k_trim := ""

         keystroke := 24

      endif
   endif

   if M->keystroke <> 13 .and. M->keystroke <> 27 .and. ;
              .not. isdata( M->keystroke )
      keyboard chr( M->keystroke )

   endif
endcase

setcolor( saveColor )
return 2

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function sysmenu()
*+
*+    Called from ( dbuedit.prg  )   1 - browse()
*+                                   1 - function xmemo()
*+                ( dbuutil.prg  )   1 - function itemlist()
*+                                   1 - function key_ready()
*+                ( dbuview.prg  )   1 - function bar_menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function sysmenu

local saveColor
private menu_func
private menu_sel
private menu_buf
private a
private ml
private mr
private mb
private prev_func
private sav_row
private sav_col
private x
if M->keystroke = 0
   return .F.
endif
menu_func  := menu_key()
local_func := 0
if M->menu_func = 0
   return .T.
endif
sav_row := row()
sav_col := col()
if M->error_on
   error_off()
endif
menu_sel  := 0
prev_func := 0
x         := M->menu_func
saveColor := setcolor()
while M->menu_func > 0 .and. M->menu_sel = 0
   if M->menu_func <> M->prev_func      //Trocou Menu
      lite_fkey( M->menu_func )
      prev_func := M->menu_func
      a         := func_title[ M->menu_func ]
      M->ml     := ( 9 *  M->menu_func ) - 17
      M->mr     := ( ( 9 * M->menu_func ) - 6 )
      M->mb     := ( 2 + len( &a._m ) )                     //Pega a array das Funcoes
      menu_buf  := savescreen( 2, M->ml - 1, M->mb + 1, M->mr + 1 )
      setcolor( M->color6 )
      HB_dispbox( 2, M->ml - 1, M->mb + 1, M->mr + 1,mframe)
      //@  2, M->ml - 1, M->mb + 1, M->mr + 1 box mframe
   endif
   setcolor( M->color5 )
   menu_sel := achoice( 3, M->ml, M->mb, M->mr, &a._m, &a._b, "mu_func", ;
                        menu_deflt[ M->menu_func ], menu_deflt[ M->menu_func ] - 1 )
                        

   do case

   case M->keystroke = 27
      menu_func := 0

   case M->keystroke = 4
      menu_func := if( M->menu_func < 9, M->menu_func + 1, 2 )

   case M->keystroke = 19
      menu_func := if( M->menu_func > 2, M->menu_func - 1, 9 )

   case M->x <> 0
      menu_func := M->x

   endcase

   if M->menu_func <> M->prev_func .or. M->menu_sel <> 0
      dim_fkey( M->prev_func )
      restscreen( 2, M->ml - 1, M->mb + 1, M->mr + 1, M->menu_buf )

   endif
enddo

if M->menu_func <> 0
   menu_deflt[ M->menu_func ] = M->menu_sel

endif


//Menus que Saem do loop (sem necessidade de checar dbf_aberto) f2=2 f3=3 ...
//exit_str definida no dbu.prg
if ltrim( str( M->menu_func ) ) $ M->exit_str  .or. (M->menu_func = 2 .and. M->menu_sel > 3 ) //menus que saem do loop exit_str ou //abir outros databases
   sysfunc  := M->menu_func
   func_sel := M->menu_sel
else
   local_func := M->menu_func
   local_sel  := M->menu_sel
endif

@ M->sav_row, M->sav_col say ""

keystroke := 0
setcolor( saveColor )

return menu_func <> 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function menu_key()
*+
*+    Called from ( dbucopy.prg  )   1 - function scope_num()
*+                ( dbuedit.prg  )   1 - static function exitkey()
*+                ( dbustru.prg  )   2 - modi_stru()
*+                ( dbuutil.prg  )   1 - function i_func()
*+                                   1 - function sysmenu()
*+                                   1 - function mu_func()
*+                                   1 - function enter_rc()
*+                ( dbuview.prg  )   1 - function bar_func()
*+                                   1 - function open_dbf()
*+                                   1 - function get_ntx()
*+                                   1 - function get_field()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function menu_key

private num
num := 0
do case
case M->keystroke = 28
   HELP()
case M->keystroke = K_ALT_H
   XCAPTXT()
case M->keystroke = K_ALT_J
   XEDIWOR()
case M->keystroke = K_ALT_F
   XGRATXT()
case M->keystroke < 0 .and. M->keystroke > - 9
   num := 1 - M->keystroke
case M->keystroke >= 249 .and. M->keystroke < 256
   num := 257 - M->keystroke
endcase
retu M->num

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function mu_func()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function mu_func

parameters amod, sel, rel
private r

if M->amod = 4
   keystroke := inkey( 0 )

   r := 0

else
   keystroke := lastkey()

   r := 2

endif

x := menu_key()

if M->amod = 3

   do case

   case M->keystroke = 13 .or. M->x = M->menu_func
      r := 1

   case M->keystroke = 27 .or. M->keystroke = 19 .or. ;
              M->keystroke = 4 .or. M->x <> 0
      r := 0

   case M->keystroke = 1
      keyboard chr( 31 )

   case M->keystroke = 6
      keyboard chr( 30 )

   case isdata( M->keystroke )
      r := 3

   endcase
endif

return M->r

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function xkey_clear()
*+
*+    Called from ( dbucopy.prg  )   1 - function scope_num()
*+                ( dbuedit.prg  )   1 - static function doget()
*+                ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuutil.prg  )   1 - function enter_rc()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function xkey_clear

private i

for i := 1 to 7
   set key - ( M->i ) to clear_gets

next

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function xkey_norm()
*+
*+    Called from ( dbucopy.prg  )   1 - function scope_num()
*+                ( dbuedit.prg  )   1 - static function doget()
*+                ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuutil.prg  )   1 - function enter_rc()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function xkey_norm

private i

for i := 1 to 7
   set key - ( M->i ) to

next

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function lite_fkey()
*+
*+    Called from ( dbuutil.prg  )   1 - function sysmenu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func lite_fkey( k_num )

local saveColor
memvar color6

saveColor := setcolor( M->color11 )
@  1, ( 9 * k_num ) - 18 say padc( func_title[ k_num ], 9 )
setcolor( saveColor )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function dim_fkey()
*+
*+    Called from ( dbuutil.prg  )   1 - function sysmenu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func dim_fkey( k_num )

local saveColor
memvar color1

saveColor := setcolor( M->color1 )
@  1, ( 9 * k_num ) - 18 say padc( func_title[ k_num ], 9 )
setcolor( saveColor )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function key_ready()
*+
*+    Called from ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuutil.prg  )   1 - function multibox()
*+                                   1 - function read_key()
*+                ( dbuview.prg  )   1 - set_view()
*+                                   1 - function set_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function key_ready

lkey := M->keystroke

keystroke := inkey()

return ( sysmenu() .or. M->keystroke <> 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function read_key()
*+
*+    Called from ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuutil.prg  )   1 - function multibox()
*+                ( dbuview.prg  )   1 - set_view()
*+                                   1 - function set_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function read_key

do while .not. key_ready()

enddo

if M->error_on
   error_off()

endif

return M->keystroke

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function raw_key()
*+
*+    Called from ( dbuutil.prg  )   1 - function rsvp()
*+                ( dbuview.prg  )   1 - function get_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function raw_key

private k

k := inkey( 0 )

if M->error_on
   error_off()

endif

return k

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function q_check()
*+
*+    Called from ( dbu.prg      )   1 -
*+                ( dbuedit.prg  )   1 - browse()
*+                ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuutil.prg  )   1 - function multibox()
*+                ( dbuview.prg  )   1 - set_view()
*+                                   1 - function set_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function q_check

return ( M->cur_func <> M->sysfunc .or. M->keystroke = 27 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    clear_gets()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function clear_gets

parameters dummy1, dummy2, dummy3

clear gets
return

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function all_fields()
*+
*+    Called from ( dbu.prg      )   1 -
*+                ( dbucopy.prg  )   1 - capprep()
*+                ( dbustru.prg  )   1 - function do_modstru()
*+                ( dbuview.prg  )   1 - function open_dbf()
*+                                   1 - function get_field()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function all_fields

parameters work_area, field_a

stat_msg( "Lendo Estrutura do Arquivo" )

need_field := .T.

select( M->work_area )

afill( M->field_a, "", afields( M->field_a ) + 1 )

stat_msg( "" )
return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function not_target()
*+
*+    Called from ( dbuindx.prg  )   1 -make_ntx()
*+                ( dbustru.prg  )   1 - function do_modstru()
*+                ( dbuview.prg  )   2 - function channel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function not_target

parameters n, do_del
private i

i := 1

do while M->i <= len( M->k_relate )

   if empty( k_relate[ M->i ] )
      exit

   endif

   if t_relate[ M->i ] == chr( M->n + asc( "A" ) - 1 ) + name( dbf[ M->n ] )
      need_relat := .T.

      select( M->n )

      set relation to

      if M->do_del
         array_del( M->s_relate, M->i )
         array_del( M->k_relate, M->i )
         array_del( M->t_relate, M->i )

      else
         i := M->i + 1

      endif

   else
      i := M->i + 1

   endif
enddo

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function dup_ntx()
*+
*+    Called from ( dbuindx.prg  )   1 - function do_index()
*+                ( dbuview.prg  )   1 - function do_openntx()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function dup_ntx

parameters ntx_file
private ntx
private i

i := 1

do while M->i <= 6

   if empty( dbf[ M->i ] )
      exit

   endif

   ntx := "ntx" + substr( "123456", M->i, 1 )

   if aseek( &ntx, M->ntx_file ) > 0
      return M->i

   endif

   i := M->i + 1

enddo

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function stat_msg()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func stat_msg( string )

local saveColor

saveColor := setcolor( M->color1 )
@  3,  0 say pad( string, 80 )
setcolor( saveColor )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function error_msg()
*+
*+    Called from ( dbu.prg      )   1 -
*+                ( dbucopy.prg  )   4 - function do_copy()
*+                                   5 - function do_append()
*+                                   5 - function do_replace()
*+                ( dbuedit.prg  )   2 - function do_seek()
*+                                   3 - function do_goto()
*+                                   3 - function do_locate()
*+                                   3 - function do_skip()
*+                ( dbuindx.prg  )   5 - function do_index()
*+                ( dbustru.prg  )   1 - function field_check()
*+                                   1 - function do_modstru()
*+                ( dbuutil.prg  )   1 - function rsvp()
*+                ( dbuview.prg  )   2 - set_view()
*+                                   1 - function open_dbf()
*+                                   3 - function do_opendbf()
*+                                   1 - function get_ntx()
*+                                   3 - function do_openntx()
*+                                   2 - function do_fsel()
*+                                   1 - function get_relation()
*+                                   1 - function do_filter()
*+                                   1 - function do_creavew()
*+                                   3 - function do_openvew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func error_msg( string )

local saveColor

saveColor := setcolor( M->color3 )
@  3,  0 say string

setcolor( M->color1 )
@ row(), col()

error_on := .T.
setcolor( saveColor )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function error_off()
*+
*+    Called from ( dbuutil.prg  )   1 - function i_func()
*+                                   1 - function sysmenu()
*+                                   1 - function read_key()
*+                                   1 - function raw_key()
*+                                   1 - function enter_rc()
*+                ( dbuview.prg  )   1 - function bar_func()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func error_off

local saveColor

error_on := .F.

saveColor := setcolor( M->color1 )
@  3,  0
setcolor( saveColor )

return ( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function rsvp()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function rsvp(cMES)
RETURN IF(MsgYesNo( cMES ),"S","N")

/*
parameters string
private c

c := " "

do while .not. ( M->c $ "SN" + chr( 27 ) )
   error_msg( M->string + "  " )

   @  3, len( M->string ) + 1 say ""

   set cursor on

   c := upper( chr( raw_key() ) )

   if .not. M->curs_on
      set cursor OFF

   endif
enddo

return M->c
*/

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function name()
*+
*+    Called from ( dbucopy.prg  )   2 - function do_copy()
*+                ( dbuindx.prg  )   2 - make_ntx()
*+                                   2 - function do_index()
*+                ( dbustru.prg  )   2 - function do_modstru()
*+                ( dbuutil.prg  )   1 - function setup()
*+                                   1 - function not_target()
*+                                   1 - function hi_cur()
*+                                   1 - function dehi_cur()
*+                ( dbuview.prg  )   4 - function channel()
*+                                   1 - function d_copy()
*+                                   2 - function open_dbf()
*+                                   2 - function get_relation()
*+                                   2 - function clear_dbf()
*+                                   1 - function save_view()
*+                                   2 - function do_creavew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function name

parameters spec
private p

p := substr( M->spec, rat( hb_ps(), M->spec ) + 1 )

if "." $ M->p
   p := substr( M->p, 1, at( ".", M->p ) - 1 )

endif

return M->p

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function pad()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function pad

parameters s, n

return substr( M->s + space( M->n ), 1, M->n )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function aseek()
*+
*+    Called from ( dbucopy.prg  )   5 - function do_copy()
*+                                   4 - function do_append()
*+                ( dbuindx.prg  )   1 - make_ntx()
*+                ( dbustru.prg  )   1 - modi_stru()
*+                                   1 - function do_modstru()
*+                ( dbuutil.prg  )   1 - function dup_ntx()
*+                ( dbuview.prg  )   1 - set_view()
*+                                   1 - function do_opendbf()
*+                                   1 - function do_fsel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function aseek

parameters array, exp
private pos
private num_el

num_el := afull( M->array )

if M->num_el = 0
   return 0

endif

set exact on

pos := ascan( M->array, M->exp, 1, M->num_el )

set exact OFF

return M->pos

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function array_ins()
*+
*+    Called from ( dbuview.prg  )   2 - function channel()
*+                                   3 - function set_relation()
*+                                   1 - function clear_dbf()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function array_ins

parameters array, pos

ains( M->array, M->pos )

array[ M->pos ] = ""

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function array_del()
*+
*+    Called from ( dbuutil.prg  )   3 - function not_target()
*+                ( dbuview.prg  )   2 - function channel()
*+                                   6 - function set_relation()
*+                                   4 - function clear_dbf()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function array_del

parameters array, pos

adel( M->array, M->pos )

array[ len( M->array ) ] = ""

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function afull()
*+
*+    Called from ( dbucopy.prg  )   1 - function do_copy()
*+                ( dbuedit.prg  )   1 - browse()
*+                ( dbuindx.prg  )   1 - function do_index()
*+                ( dbustru.prg  )   1 - function do_modstru()
*+                ( dbuutil.prg  )   2 - function setup()
*+                                   1 - function itemlist()
*+                                   1 - function aseek()
*+                                   1 - function array_sort()
*+                ( dbuview.prg  )   1 - set_view()
*+                                   4 - function channel()
*+                                   1 - function bar_menu()
*+                                   1 - function list_array()
*+                                   1 - function draw_view()
*+                                   2 - function set_relation()
*+                                   2 - function get_relation()
*+                                   4 - function clear_dbf()
*+                                   1 - function do_creavew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function afull

parameters array
private i

set exact on

i := ascan( M->array, "" )

set exact OFF

if M->i = 0
   i := len( M->array )

else
   i := M->i - 1

endif

return M->i

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function array_sort()
*+
*+    Called from ( dbucopy.prg  )   1 - function do_copy()
*+                ( dbuindx.prg  )   1 - function do_index()
*+                ( dbustru.prg  )   1 - function do_modstru()
*+                ( dbuutil.prg  )   1 - function array_dir()
*+                ( dbuview.prg  )   1 - function do_creavew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function array_sort

parameters array

asort( M->array, 1, afull( M->array ) )

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function array_dir()
*+
*+    Called from ( dbu.prg      )   6 -
*+                ( dbucopy.prg  )   1 - capprep()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function array_dir

parameters skeleton, array

afill( M->array, "" )

adir( M->skeleton, M->array )

array_sort( M->array )

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_key()
*+
*+    Called from ( dbuindx.prg  )   1 - make_ntx()
*+                                   1 - function ntx_done()
*+                                   1 - function ntx_exist()
*+                ( dbuview.prg  )   1 - function ctrl_key()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_key

parameters filename
private k
private buffer
private handle
private k_pos

k := ""

if file( M->filename )

   if lower(XEXT()) = ".ntx"
      k_pos := 23

   else
      k_pos := 25

   endif

   handle := hb_fopen( M->filename )

   if ferror() = 0
      buffer := space( 512 )

      fread( M->handle, @buffer, 512 )

      k := HB_BSUBSTR( M->buffer, M->k_pos )

      k := trim( HB_BSUBSTR( M->k, 1, at( chr( 0 ), M->k ) - 1 ) )

   endif

   fclose( M->handle )

endif

return M->k

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function isdata()
*+
*+    Called from ( dbucopy.prg  )   1 - function scope_num()
*+                ( dbuedit.prg  )   1 - browse()
*+                                   1 - static function exitkey()
*+                ( dbustru.prg  )   3 - modi_stru()
*+                ( dbuutil.prg  )   1 - function multibox()
*+                                   1 - function i_func()
*+                                   1 - function getfile()
*+                                   2 - function get_exp()
*+                                   1 - function get_k_trim()
*+                                   1 - function mu_func()
*+                ( dbuview.prg  )   1 - set_view()
*+                                   2 - function channel()
*+                                   1 - function bar_func()
*+                                   1 - function open_dbf()
*+                                   1 - function get_ntx()
*+                                   1 - function get_field()
*+                                   1 - function set_relation()
*+                                   2 - function get_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function isdata

parameters k

return ( M->k >= 32 .and. M->k < 249 .and. M->k <> 219 .and. chr( M->k ) <> ";" )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function lpad()
*+
*+    Called from ( dbuedit.prg  )   1 - static function statline()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function lpad

parameters string, n

return ( space( M->n - len( M->string ) ) + M->string )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function hi_cur()
*+
*+    Called from ( dbu.prg      )   3 -
*+                ( dbuview.prg  )   2 - set_view()
*+                                   1 - function get_filter()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function hi_cur

local saveColor

if M->cur_area > 0
   saveColor := setcolor( M->color2 )
   @ row_a[  1 ], column[ M->cur_area ] + 2 say pad( name( M->cur_dbf ), 8 )
   setcolor( saveColor )

endif

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function dehi_cur()
*+
*+    Called from ( dbu.prg      )   3 -
*+                ( dbuview.prg  )   2 - set_view()
*+                                   1 - function get_filter()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function dehi_cur

local saveColor

if M->cur_area > 0
   saveColor := setcolor( M->color1 )
   @ row_a[  1 ], column[ M->cur_area ] + 2 say pad( name( M->cur_dbf ), 8 )
   setcolor( saveColor )

endif

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function enter_rc()
*+
*+    Called from ( dbu.prg      )   1 -
*+                ( dbuutil.prg  )   1 - function getfile()
*+                                   1 - function get_exp()
*+                                   1 - function get_k_trim()
*+                ( dbuview.prg  )   1 - function open_dbf()
*+                                   1 - function get_ntx()
*+                                   1 - function get_field()
*+                                   1 - function get_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function enter_rc

parameters org_str, r, c, max_len, pfunc, cString
local saveColor
private wk_str
xkey_clear()
wk_str    := pad( M->org_str, M->max_len )
saveColor := setcolor( M->cString )
if !empty( M->pfunc )
   @ r, c get M->wk_str picture M->pfunc
else
   @ r, c get M->wk_str
endif
READDBU()

keystroke := lastkey()

xkey_norm()

if M->error_on
   error_off()
endif

if M->keystroke = 27 .or. menu_key() <> 0
   wk_str := ""

endif

setcolor( saveColor )
return trim( M->wk_str )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function OBTER() usada em replace
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function OBTER( XARQ, XINX, XSEE, XCAM )    //SEEK MAIS RETORNO CAMPO
DBF_USO := alias()
use &XARQ index &XINX NEW SHARED
while neterr()
enddo
dbgotop()
dbseek( XSEE )
OBTIDO := if( found(), &XCAM, MAKE_EMPTY( XCAM ) )
dbclosearea()
if !empty( DBF_USO )
   sele &DBF_USO
endif
return  OBTIDO 



*+ EOF: DBUUTIL.PRG
