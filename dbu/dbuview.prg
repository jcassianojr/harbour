*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUVIEW.PRG
*+
*+    Functions: SET_VIEW()
*+               Function channel()
*+               Function bar_menu()
*+               Function bar_func()
*+               Function list_array()
*+               Function set_deflt()
*+               Function bline()
*+               Function draw_view()
*+               Function d_copy()
*+               Function open_dbf()
*+               Function dopen_titl()
*+               Function do_opendbf()
*+               Function get_ntx()
*+               Function xopen_titl()
*+               Function do_openntx()
*+               Function get_field()
*+               Function getfield()
*+               Function fsel_title()
*+               Function do_fsel()
*+               Function set_relation()
*+               Function draw_relat()
*+               Function get_relation()
*+               Function disp_relation()
*+               Function c_search()
*+               Function ctrl_key()
*+               Function get_filter()
*+               Function fltr_title()
*+               Function getfilter()
*+               Function do_filter()
*+               Function clear_dbf()
*+               Function save_view()
*+               Function vcrea_titl()
*+               Function do_creavew()
*+               Function put_line()
*+               Function set_from()
*+               Function vopen_titl()
*+               Function do_openvew()
*+               Function get_line()
*+
*+    Reformatted by Click! 2.03 on Jun-27-2003 at  6:25 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "BOX.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    SET_VIEW()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function SET_VIEW

local saveColor
private bar_line
private empty_line
private ntx
private field_n
private el
private cur_row
private t_row
private ch_draw
private strn
private is_redraw
private is_insert
private horiz_keys
private prev_area
private i

saveColor := setcolor( M->color1 )

DECLARE d_array[ len( M->ntx1 ) ]

horiz_keys := chr( 4 ) + chr( 19 ) + chr( 1 ) + chr( 6 )
bar_line   := ""
empty_line := ""
prev_area  := 0
ch_draw    := .F.

help_code := 1

keystroke := 0

set_deflt()

if .not. empty( M->view_err )
   error_msg( M->view_err )
   view_err := ""

endif

do while .not. q_check()

   do case

   case M->cur_area = 0
      cur_area := aseek( M->dbf, M->cur_dbf )

      if M->cur_area = 0

         for i := 1 to 3
            store row_a[ M->i ] to cr1[ M->i ], cr2[ M->i ], cr3[ M->i ], ;
                    cr4[ M->i ], cr5[ M->i ], cr6[ M->i ]
            store 1 to el1[ M->i ], el2[ M->i ], el3[ M->i ], el4[ M->i ], ;
                    el5[ M->i ], el6[ M->i ]

         next

         cur_dbf  := dbf[ 1 ]
         cur_area := page := 1

         set_deflt()

      endif

      draw_view( 0 )

   case M->cur_area <> M->prev_area
      cur_dbf := dbf[ M->cur_area ]

      strn := substr( "123456", M->cur_area, 1 )

      ntx     := "ntx" + strn
      field_n := "field_n" + strn
      el      := "el" + strn

      t_row := "cr" + strn

      if M->page > 1 .and. M->prev_area <> 0
         &el[ M->page ] = &el[ M->page ] + ;
                 &cur_row[ M->page ] - &t_row[ M->page ]

         &t_row[ M->page ] = &cur_row[ M->page ]

      endif

      cur_row := M->t_row

      prev_area := M->cur_area

   case M->keystroke = 19

      if M->cur_area > 1
         cur_area := M->cur_area - 1

      endif

      keystroke := 0

   case M->keystroke = 1
      cur_area  := 1
      keystroke := 0

   case M->keystroke = 4

      if M->cur_area < 6 .and. .not. empty( M->cur_dbf )
         cur_area := M->cur_area + 1

         if empty( dbf[ M->cur_area ] )
            page := 1
            set_deflt()

         endif
      endif

      keystroke := 0

   case M->keystroke = 6

      if M->cur_area < 6 .and. .not. empty( M->cur_dbf )
         i := afull( M->dbf )

         if M->i < 6 .and. ( M->page = 1 .or. M->cur_area = M->i )
            cur_area := M->i + 1

            page := 1
            set_deflt()

         else
            cur_area := M->i

         endif

      endif

      keystroke := 0

   case M->keystroke = 18 .or. M->keystroke = 5

      if M->page > 1
         page := M->page - 1
         set_deflt()

      endif

      keystroke := 0

   case M->keystroke = 3 .or. M->keystroke = 24

      if M->page < 3 .and. .not. empty( M->cur_dbf )
         page := M->page + 1
         set_deflt()

         &el[ M->page ] = &el[ M->page ] - ;
                 ( &cur_row[ M->page ] - row_a[ M->page ] )
         &cur_row[ M->page ] = row_a[ M->page ]

      endif

      keystroke := 0

   case M->keystroke = 22 .or. M->keystroke = 13 .or. ;
              isdata( M->keystroke ) .or. ( M->local_func = 2 .and. ;
              ( M->local_sel = 1 .or. M->local_sel = 2 ) ) .or. ;
              ( M->local_func = 8 .and. M->local_sel = 3 )

      if M->local_func <> 0
         page := M->local_sel
         set_deflt()

         keystroke := 22

      endif

      if M->page = 1 .and. M->n_files < 14
         is_redraw := M->cur_area < 6 .and. ( M->keystroke = 22 .or. ;
                 empty( M->cur_dbf ) )

         is_insert := ( M->keystroke = 22 .and. ;
                        .not. empty( M->cur_dbf ) .and. M->cur_area < 6 )

         if M->is_redraw
            draw_view( M->cur_area )

            setcolor( M->color2 )
            @ row_a[  1 ], column[ M->cur_area ] + 2 say space( 8 )
            setcolor( M->color1 )

         else
            hi_cur()

         endif

         ch_draw := open_dbf( M->is_insert, .F. )

         if M->ch_draw
            channel( &ntx, &field_n, &el, &cur_row, ;
                     M->cur_area, M->cur_area )

            cur_dbf := dbf[ M->cur_area ]

         else

            if M->is_redraw
               draw_view( 0 )

            else
               dehi_cur()

            endif
         endif

      else

         if M->page > 1
            channel( &ntx, &field_n, &el, &cur_row, ;
                     M->cur_area, M->cur_area )

         else
            error_msg( "Muitos Arquivos j  abertos" )

         endif
      endif

      keystroke := 0

   case M->keystroke = 7

      if M->page = 1 .and. .not. empty( M->cur_dbf )
         stat_msg( "Fechando o Arquivo" )
         clear_dbf( M->cur_area, 2 )

         if M->cur_area = 6
            ch_draw := .T.
            channel( &ntx, &field_n, &el, &cur_row, ;
                     M->cur_area, M->cur_area )

         else
            draw_view( 0 )

         endif

         cur_dbf := dbf[ M->cur_area ]

         stat_msg( "" )

      else

         if M->page > 1
            channel( &ntx, &field_n, &el, &cur_row, ;
                     M->cur_area, M->cur_area )

         endif
      endif

      keystroke := 0

   case M->local_func = 8 .and. M->local_sel = 1
      set_relation()
      keystroke := 0

   case M->local_func = 8 .and. M->local_sel = 2
      get_filter()
      keystroke := 0

   case M->local_func = 8 .and. M->local_sel = 4
      ABERTURA     := if( rsvp( "Deseja Abertura Exclusiva S/N " ) = "S", .T., .F. )
      keystroke    := 0
      m->local_sel := 0

   case M->local_func = 8 .and. M->local_sel = 5
      if rsvp( "Deseja Vizualizar Registros Apagados S/N " ) = "S"
         set dele OFF
      else
         set dele on
      endif
      keystroke    := 0
      m->local_sel := 0

   case M->local_func = 8 .and. M->local_sel = 6
        tipodbfesc()

      keystroke    := 0
      m->local_sel := 0

   case M->local_func = 8 .and. M->local_sel = 7
   
       pegparexp()
      
       keystroke    := 0
       m->local_sel := 0      

   case M->local_func = 2 .and. M->local_sel = 3
      set_from( .T. )

      if .not. empty( M->view_file ) .and. M->keystroke = 13
         cur_area := 0
         cur_dbf  := ""

      endif

      keystroke := 0

   case M->local_func = 4
      save_view()
      keystroke := 0

   otherwise

      do case

      case M->page = 1

         if .not. key_ready()
            hi_cur()

            read_key()

            dehi_cur()

         endif

      case M->page = 2
         d_copy( &ntx )

         bar_menu( column[ M->cur_area ] + 2, ;
                   column[ M->cur_area ] + 9, M->d_array )

      case M->page = 3
         bar_menu( column[ M->cur_area ] + 1, ;
                   column[ M->cur_area ] + 10, &field_n )

      endcase

      if M->keystroke = 27

         if rsvp( "Sair para o DOS? (S/N)" ) <> "S"
            keystroke := 0
         endif
      endif
   endcase
enddo

if M->sysfunc = 3 .and. M->func_sel = 1 .and. empty( M->cur_dbf )
   draw_view( M->cur_area )

endif

return

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function channel()
*+
*+    Called from ( dbuview.prg  )   4 - set_view()
*+                                   1 - function draw_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function channel

parameters ch_ntx, ch_field_n, ch_el, ch_cur_row, n, dbf_num
local saveColor
private f_n
private is_ins
private temp_buff
private d_item

saveColor := setcolor( M->color1 )

do case

case M->ch_draw
   scroll( row_a[ 2 ], column[ M->n ], row_x[ 2 ], column[ M->n ] + 11, 0 )
   scroll( row_a[ 3 ], column[ M->n ], row_x[ 3 ], column[ M->n ] + 11, 0 )

   @ row_a[  1 ], column[ M->n ] + 2 say pad( name( dbf[ M->dbf_num ] ), 8 )

   if .not. empty( ch_ntx[ 1 ] )
      d_copy( M->ch_ntx )
      list_array( row_a[ 2 ], column[ M->n ] + 2, row_x[ 2 ], column[ M->n ] + 9, ;
                  M->d_array, ch_el[ 2 ] - ( ch_cur_row[ 2 ] - row_a[ 2 ] ) )

   endif

   list_array( row_a[ 3 ], column[ M->n ] + 1, row_x[ 3 ], column[ M->n ] + 10, ;
               M->ch_field_n, ch_el[ 3 ] - ( ch_cur_row[ 3 ] - row_a[ 3 ] ) )

   ch_draw := .F.

case M->keystroke = 22 .or. M->keystroke = 13 .or. isdata( M->keystroke )

   if isdata( M->keystroke )
      keyboard chr( M->keystroke )

   endif

   is_ins := ( M->keystroke = 22 )

   do case

   case M->page = 2 .and. ( M->n_files < 14 .or. ( M->keystroke <> 22 ;
              .and. .not. empty( ch_ntx[ ch_el[ 2 ] ] ) ) )
      temp_buff := savescreen( row_a[ 2 ], column[ M->n ] + 1, ;
                               row_x[ 2 ], column[ M->n ] + 11 )

      if M->is_ins

         if ch_el[ 2 ] + row_x[ 2 ] - ch_cur_row[ 2 ] = afull( M->ch_ntx )
            @ row_x[  2 ], column[ M->n ] + 11 say M->more_down

         endif

         if ch_cur_row[ 2 ] < row_x[ 2 ]
            scroll( ch_cur_row[ 2 ], column[ M->n ] + 1, ;
                    row_x[ 2 ], column[ M->n ] + 10, - 1 )

         endif

         d_item := space( 8 )

      else
         d_item := pad( name( ch_ntx[ ch_el[ 2 ] ] ), 8 )

      endif

      setcolor( M->color2 )
      @ ch_cur_row[  2 ], column[ M->n ] + 2 say M->d_item
      setcolor( M->color1 )

      f_n := get_ntx( ch_cur_row[ 2 ], column[ M->n ] + 2, ;
                      ch_ntx[ ch_el[ 2 ] ], M->is_ins )

      if .not. M->f_n == ch_ntx[ ch_el[ 2 ] ] .and. .not. empty( M->f_n )
         need_ntx := .T.

         if M->is_ins
            array_ins( M->ch_ntx, ch_el[ 2 ] )

         endif

         ch_ntx[ ch_el[ 2 ] ] = M->f_n

         if ch_el[ 2 ] = 1
            not_target( M->n, .T. )

         endif

         @ ch_cur_row[  2 ], column[ M->n ] + 2 ;
                 say pad( name( ch_ntx[ ch_el[ 2 ] ] ), 8 )

      else
         restscreen( row_a[ 2 ], column[ M->n ] + 1, ;
                     row_x[ 2 ], column[ M->n ] + 11, M->temp_buff )

      endif

   case M->page = 3
      temp_buff := savescreen( row_a[ 3 ], column[ M->n ] + 1, ;
                               row_x[ 3 ], column[ M->n ] + 11 )

      if M->is_ins

         if ch_el[ 3 ] + row_x[ 3 ] - ch_cur_row[ 3 ] = afull( M->ch_field_n )
            @ row_x[  3 ], column[ M->n ] + 11 say M->more_down

         endif

         if ch_cur_row[ 3 ] < row_x[ 3 ]
            scroll( ch_cur_row[ 3 ], column[ M->n ] + 1, ;
                    row_x[ 3 ], column[ M->n ] + 10, - 1 )

         endif

         d_item := space( 10 )

      else
         d_item := pad( ch_field_n[ ch_el[ 3 ] ], 10 )

      endif

      setcolor( M->color2 )
      @ ch_cur_row[  3 ], column[ M->n ] + 1 say M->d_item
      setcolor( M->color1 )

      f_n := get_field( ch_cur_row[ 3 ], column[ M->n ] + 1, M->n, ;
                        ch_field_n[ ch_el[ 3 ] ] )

      if ( M->is_ins .or. .not. M->f_n == ch_field_n[ ch_el[ 3 ] ] ) ;
           .and. .not. empty( M->f_n )
         need_field := .T.

         if M->is_ins
            array_ins( M->ch_field_n, ch_el[ 3 ] )

         endif

         ch_field_n[ ch_el[ 3 ] ] = M->f_n

         @ ch_cur_row[  3 ], column[ M->n ] + 1 ;
                 say pad( ch_field_n[ ch_el[ 3 ] ], 10 )

      else
         restscreen( row_a[ 3 ], column[ M->n ] + 1, ;
                     row_x[ 3 ], column[ M->n ] + 11, M->temp_buff )

      endif
   endcase

case M->keystroke = 7

   do case

   case M->page = 2 .and. .not. empty( ch_ntx[ ch_el[ 2 ] ] )
      need_ntx := .T.

      if ch_el[ 2 ] = 1
         not_target( M->n, .T. )

      endif

      select( M->n )

      close index

      array_del( M->ch_ntx, ch_el[ 2 ] )

      n_files := M->n_files - 1

      if ch_cur_row[ 2 ] < row_x[ 2 ]
         scroll( ch_cur_row[ 2 ], column[ M->n ] + 1, ;
                 row_x[ 2 ], column[ M->n ] + 9, 1 )

      endif

      @ row_x[  2 ], column[ M->n ] + 2 ;
              say pad( name( ch_ntx[ ch_el[ 2 ] + row_x[ 2 ] - ch_cur_row[ 2 ] ] ), 8 )

      if afull( M->ch_ntx ) - ch_el[ 2 ] = row_x[ 2 ] - ch_cur_row[ 2 ]
         @ row_x[  2 ], column[ M->n ] + 11 say " "

      endif

   case M->page = 3 .and. .not. empty( ch_field_n[ ch_el[ 3 ] ] )
      need_field := .T.

      array_del( M->ch_field_n, ch_el[ 3 ] )

      if ch_cur_row[ 3 ] < row_x[ 3 ]
         scroll( ch_cur_row[ 3 ], column[ M->n ] + 1, ;
                 row_x[ 3 ], column[ M->n ] + 10, 1 )

      endif

      @ row_x[  3 ], column[ M->n ] + 1 ;
              say pad( ch_field_n[ ch_el[ 3 ] + row_x[ 3 ] - ch_cur_row[ 3 ] ], 10 )

      if afull( M->ch_field_n ) - ch_el[ 3 ] = row_x[ 3 ] - ch_cur_row[ 3 ]
         @ row_x[  3 ], column[ M->n ] + 11 say " "

      endif
   endcase
endcase

setcolor( saveColor )
return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function bar_menu()
*+
*+    Called from ( dbuview.prg  )   2 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function bar_menu

parameters l, r, array
local saveColor
private num_d
private num_full
private cur_el
private rel_row
private x
private t
private b

keystroke := nextkey()

if chr( M->keystroke ) $ M->horiz_keys
   inkey()
   return 0

endif

t := row_a[ M->page ]
b := row_x[ M->page ]

num_full := afull( M->array )

num_d := M->num_full

if M->num_d < len( M->array )
   num_d := M->num_d + 1

   array[ M->num_d ] = " "

endif

x := if( M->r - M->l > 7, 1, 2 )

rel_row := &cur_row[ M->page ] - M->t

saveColor := setcolor( M->color4 )
achoice( M->t, M->l, M->b, M->r, M->array, .T., ;
         "bar_func", &el[ M->page ], M->rel_row )
setcolor( saveColor )

&cur_row[ M->page ] = M->rel_row + M->t

if array[ M->num_d ] == " "
   array[ M->num_d ] = ""

endif

sysmenu()

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function bar_func()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function bar_func

parameters mode, bar_el, row
private ret_code

keystroke := lastkey()

ret_code := 2

&el[ M->page ] = M->bar_el
rel_row := M->row

if M->error_on
   error_off()

endif

do case

case M->mode = 0
   @ M->t, M->r + M->x say if( M->bar_el > M->row + 1, M->more_up, " " )
   @ M->b, M->r + M->x say if( M->num_full > ;
           ( M->bar_el + M->b - M->t - M->row ), ;
           M->more_down, " " )

case M->mode = 1 .or. M->mode = 2
   ret_code := 0

case M->mode = 3

   do case

   case chr( M->keystroke ) $ M->horiz_keys
      ret_code := 0

   case M->keystroke = 27
      ret_code := 0

   case M->keystroke = 13
      ret_code := 1

   case isdata( M->keystroke )
      ret_code := 1

   case M->keystroke = 22 .or. M->keystroke = 7
      ret_code := 1

   case menu_key() <> 0
      ret_code := 0

   endcase

case M->mode = 4
   ret_code := 0

endcase

return M->ret_code

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function list_array()
*+
*+    Called from ( dbuview.prg  )   2 - function channel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function list_array

parameters t, l, b, r, array, top_el
local saveColor
private bottom_el
private num_full
private x

saveColor := setcolor( M->color4 )
if .not. empty( array[ M->top_el ] )
   bottom_el := M->top_el + M->b - M->t

   num_full := afull( M->array )

   x := if( M->r - M->l > 7, 1, 2 )

   if M->top_el > 1 .and. M->bottom_el = M->num_full + 1
      array[ M->bottom_el ] = " "

   endif

   achoice( M->t, M->l, M->b, M->r, M->array, .F., "", M->top_el )
   setcolor( M->color1 )

   @ M->t, M->r + M->x say if( M->top_el > 1, M->more_up, " " )
   @ M->b, M->r + M->x say if( M->bottom_el < M->num_full, M->more_down, " " )

   if array[ M->bottom_el ] == " "
      array[ M->bottom_el ] = ""

   endif
endif

setcolor( saveColor )
return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function set_deflt()
*+
*+    Called from ( dbuview.prg  )   7 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function set_deflt

if M->page = 2
   menu_deflt[ 2 ] := menu_deflt[ 3 ] := 2

else
   menu_deflt[ 2 ] := menu_deflt[ 3 ] := 1

endif

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function bline()
*+
*+    Called from ( dbuview.prg  )   1 - function draw_view()
*+                                   1 - function set_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function bline

parameters num_slots
private i
private k

if num_slots < 6
   num_slots ++

endif

bar_line   := "------------"
empty_line := ""

k := 1

do while M->k < M->num_slots
   bar_line   := M->bar_line + "б------------"
   empty_line := M->empty_line + space( 12 ) + "н"

   k := M->k + 1

enddo

i := int( ( 80 - len( M->bar_line ) ) / 2 )

for k := 1 to M->num_slots
   column[ M->k ] = M->i + ( 13 * ( M->k - 1 ) )

next

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function draw_view()
*+
*+    Called from ( dbuview.prg  )   5 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function draw_view

parameters blank_area
private i
private j
private ntx
private field_n
private el
private cur_row
private strnum

i := afull( M->dbf )

if M->i < 6 .and. blank_area <> 0
   i := M->i + 1

endif

bline( M->i )
LAYOUT()

@ row_a[  1 ] - 2, 36          say "Arquivos"
@ row_a[  1 ] - 1, column[ 1 ] say M->bar_line
@ row_a[  1 ], column[ 1 ]     say M->empty_line

@ row_a[  2 ] - 2, 36          say "Indices"
@ row_a[  2 ] - 1, column[ 1 ] say M->bar_line
@ row_a[  2 ], column[ 1 ]     say M->empty_line
@ row_a[  2 ] + 1, column[ 1 ] say M->empty_line
@ row_a[  2 ] + 2, column[ 1 ] say M->empty_line

@ row_a[  3 ] - 2, 36          say "Campos"
@ row_a[  3 ] - 1, column[ 1 ] say M->bar_line

for i := row_a[ 3 ] to row_x[ 3 ]
   @ M->i, column[ 1 ] say M->empty_line

next

i := 1
j := 1

do while M->j <= 6

   if empty( dbf[ M->i ] )
      exit

   endif

   if M->j <> M->blank_area
      strnum := substr( "123456", M->i, 1 )

      ntx     := "ntx" + strnum
      field_n := "field_n" + strnum
      el      := "el" + strnum
      cur_row := "cr" + strnum

      ch_draw := .T.
      channel( &ntx, &field_n, &el, &cur_row, M->j, M->i )

      i := M->i + 1

   endif

   j := M->j + 1

enddo

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function d_copy()
*+
*+    Called from ( dbuview.prg  )   1 - set_view()
*+                                   1 - function channel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function d_copy

parameters array
private i

afill( M->d_array, "" )

i := 1

do while M->i <= len( M->array )

   if empty( array[ M->i ] )
      exit

   endif

   d_array[ M->i ] = name( array[ M->i ] )

   i := M->i + 1

enddo

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function open_dbf()
*+
*+    Called from ( dbustru.prg  )   1 - modi_stru()
*+                ( dbuview.prg  )   1 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function open_dbf

parameters is_insert, not_view
private shift
private filename
private a_temp
private f_row
private d_col
private ret_val
private old_help

if M->n_files >= 14
   error_msg( "Muitos arquivos j  abertos" )
   return .F.

endif

old_help  := M->help_code
help_code := 6

filename := ""

f_row := cr1[ 1 ]
d_col := column[ M->cur_area ] + 2

shift := if( M->is_insert, 1, 0 )

select( M->cur_area )

if M->not_view
   filename := M->cur_dbf
   ret_val  := do_opendbf()

else
   ret_val := .F.

   if isdata( M->keystroke )
      keyboard chr( M->keystroke )

      filename := enter_rc( dbf[ M->cur_area ], M->f_row, M->d_col, 64, "@KS8", ;
                            M->color1 )

      if .not. empty( M->filename )

         if .not. ( rat( ".", M->filename ) > rat( hb_ps(), M->filename ) )
            filename := M->filename + ".dbf"

         endif

         ret_val := do_opendbf()

         if .not. M->ret_val
            @ M->f_row, M->d_col say pad( name( M->cur_dbf ), 8 )

         endif

      else
         @ M->f_row, M->d_col say pad( name( M->cur_dbf ), 8 )

      endif

      if menu_key() <> 0
         keyboard chr( M->keystroke )

      else
         keystroke := 0

      endif

   else
      ret_val := filebox( ".dbf", "dbf_list", "dopen_titl", ;
                          "do_opendbf", .F., 8 ) <> 0

   endif
endif

if M->ret_val
   a_temp := "field_n" + substr( "123456", M->cur_area, 1 )
   all_fields( M->cur_area, &a_temp )

   a_temp := "cr" + substr( "123456", M->cur_area, 1 )
   &a_temp[ 2 ] = row_a[ 2 ]
   &a_temp[ 3 ] = row_a[ 3 ]

   a_temp := "el" + substr( "123456", M->cur_area, 1 )
   afill( &a_temp, 1 )

endif

help_code := M->old_help

return M->ret_val

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function dopen_titl()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function dopen_titl

parameters sysparam

return box_title( M->sysparam, "Abrindo arquivo de Dados..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_opendbf()
*+
*+    Called from ( dbuview.prg  )   2 - function open_dbf()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_opendbf

private done

do case

case empty( M->filename )
   error_msg( "Arquivo de dados no Selecionado" )
   done := .F.

case .not. HB_FILEEXISTS( M->filename )
   error_msg( "No pode ser aberto " + M->filename )
   done := .F.

case aseek( M->dbf, M->filename ) > 0 .and. ;
               .not. ( dbf[ M->cur_area ] == M->filename .and. M->shift = 0 )
   error_msg( "Arquivo de Dados est  aberto em duas areas" )
   done := .F.

otherwise
   stat_msg( "Abrindo o arquivo" )

   if .not. empty( dbf[ M->cur_area ] )
      clear_dbf( M->cur_area, M->shift )

   endif

   n_files := M->n_files + 1

   dbf[ M->cur_area ] = M->filename

   select( M->cur_area )
   DBUREDE( filename,, ABERTURA )
   aINDICES:=FILENAMES(tiraext(filename)+"*"+XEXT())
   IF LEN(aINDICES)>0
      cNtx        := "ntx" + substr( "123456",M->cur_area, 1 )
      afill(&cNTX., "" )
      FOR X=1 TO LEN(aINDICES)
         IF X<8
            &cNTX.[X]:=aINDICES[X]
         ENDIF
      NEXT X
      IF TIPODBF = 2 .OR. TIPODBF = 4 .OR. TIPODBF = 6 //CDX MDX
         ORDSETFOCUS(1)
         dbgotop()
      ENDIF
  ENDIF

   stat_msg( "" )

   done := .T.

endcase

return M->done

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_ntx()
*+
*+    Called from ( dbuview.prg  )   1 - function channel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_ntx

parameters d_row, d_col, org_file, is_ins
private filename
private old_help

if M->n_files >= 14
   error_msg( "Muitos arquivos j  abertos" )
   return ""

endif

old_help  := M->help_code
help_code := 8

filename := ""

if isdata( M->keystroke )
   keyboard chr( M->keystroke )

   filename := enter_rc( M->org_file, M->d_row, M->d_col, 64, "@KS8", M->color1 )

   if .not. empty( M->filename )

      if .not. ( rat( ".", M->filename ) > rat( hb_ps(), M->filename ) )
         filename += XEXT()

      endif

      if .not. do_openntx()
         filename := ""

      endif
   endif

   if menu_key() <> 0
      keyboard chr( M->keystroke )

   else
      keystroke := 0

   endif

else

   if filebox( XEXT(), "ntx_list", "xopen_titl", "do_openntx", .F., 13 ) = 0
      filename := ""

   endif
endif

help_code := M->old_help

return M->filename

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function xopen_titl()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function xopen_titl

parameters sysparam

return box_title( M->sysparam, "Abrindo Arquivo de Indice..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_openntx()
*+
*+    Called from ( dbuview.prg  )   1 - function get_ntx()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_openntx

private done

do case

case empty( M->filename )
   error_msg( "Arquivo de indice no selecionado" )
   done := .F.

case .not. HB_FILEEXISTS( M->filename )
   error_msg( "No pode ser aberto " + M->filename )
   done := .F.

case dup_ntx( M->filename ) <> 0 .and. ;
                 ( M->is_ins .or. .not. M->filename == M->org_file )
   error_msg( "Arquivo de indice j  est  aberto" )
   done := .F.

otherwise

   if empty( M->org_file ) .or. M->is_ins
      n_files := M->n_files + 1

   endif

   done := .T.

endcase

return M->done

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_field()
*+
*+    Called from ( dbuview.prg  )   1 - function channel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_field

parameters f_row, d_col, work_area, org_field
private field_mvar
private rel_row
private cur_el
private okee_dokee
private fi_disp
private old_help

old_help  := M->help_code
help_code := 2

field_mvar := ""

select( M->work_area )

DECLARE field_m[ fcount() ]
all_fields( M->work_area, M->field_m )

if isdata( M->keystroke )
   keyboard chr( M->keystroke )

   field_mvar := enter_rc( M->org_field, M->f_row, M->d_col, 10, "@K!", M->color1 )

   if .not. empty( M->field_mvar )

      if .not. do_fsel()
         field_mvar := ""

      endif

   endif

   if menu_key() <> 0
      keyboard chr( M->keystroke )

   else
      keystroke := 0

   endif

else
   DECLARE boxarray[ 5 ]

   boxarray[ 1 ] = "fsel_title(sysparam)"
   boxarray[ 2 ] = "getfield(sysparam)"
   boxarray[ 3 ] = "ok_button(sysparam)"
   boxarray[ 4 ] = "can_button(sysparam)"
   boxarray[ 5 ] = "fieldlist(sysparam)"

   cur_el  := 1
   rel_row := 0

   okee_dokee := "do_fsel()"
   fi_disp    := "getfield(3)"

   if multibox( 7, 17, 5, 5, M->boxarray ) = 0
      field_mvar := ""

   endif
endif

help_code := M->old_help

return M->field_mvar

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function getfield()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function getfield

parameters sysparam

return genfield( M->sysparam, .F. )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function fsel_title()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function fsel_title

parameters sysparam

return box_title( M->sysparam, "Arquivo Selecionado..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_fsel()
*+
*+    Called from ( dbuview.prg  )   1 - function get_field()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_fsel

private done

do case

case empty( M->field_mvar )
   error_msg( "Nome de campo no selecionado" )
   done := .F.

case aseek( M->field_m, M->field_mvar ) = 0
   error_msg( M->field_mvar + " no existe" )
   done := .F.

otherwise
   done := .T.

endcase

return M->done

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function set_relation()
*+
*+    Called from ( dbuview.prg  )   1 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function set_relation

local saveColor
private c_row
private c_el
private rel_buff
private pos_r
private width
private old_help
private k
private n_area
private ls
private lk
private lt
private cNorm
private cHilite

cNorm     := color7
cHilite   := color2
saveColor := setcolor( M->cNorm )

old_help  := M->help_code
help_code := 9

box_open := .T.

if empty( M->bar_line )
   bline( afull( M->dbf ) )

endif

width := len( M->bar_line ) - 1

pos_r := column[ 1 ] + M->width

rel_buff := savescreen( 8, column[ 1 ] - 1, 23, M->pos_r + 1 )

scroll( 8, column[ 1 ] - 1, 23, M->pos_r + 1, 0 )
@  8, column[ 1 ] - 1, 23, M->pos_r + 1 box M->frame

@  9, 35          say "Relaes"
@ 10, column[ 1 ] say M->bar_line

c_row := 11
c_el  := 1

draw_relat( 1 )

keystroke := 0

do while .not. q_check()

   do case

   case M->keystroke = 18

      if M->c_el > ( ( M->c_row - 11 ) / 2 ) + 1
         c_el := M->c_el - 5

         if M->c_el < ( ( M->c_row - 11 ) / 2 ) + 1
            c_el := ( ( M->c_row - 11 ) / 2 ) + 1

         endif

         draw_relat( M->c_el - ( ( M->c_row - 11 ) / 2 ) )

      else

         if M->c_el > 1
            c_el  := 1
            c_row := 11

         endif
      endif

      keystroke := 0

   case M->keystroke = 3
      k := afull( M->k_relate )

      if M->k < len( M->k_relate )
         k := M->k + 1

      endif

      if M->c_el < M->k - ( ( 21 - M->c_row ) / 2 )
         c_el := M->c_el + 5

         if M->c_el > M->k - ( ( 21 - M->c_row ) / 2 )
            c_el := M->k - ( ( 21 - M->c_row ) / 2 )

         endif

         draw_relat( M->c_el - ( ( M->c_row - 11 ) / 2 ) )

      else

         if M->c_el < M->k
            c_row := M->c_row + ( ( M->k - M->c_el ) * 2 )
            c_el  := M->k

         endif
      endif

      keystroke := 0

   case M->keystroke = 22 .or. isdata( M->keystroke )

      k := M->c_el + ( ( 21 - M->c_row ) / 2 ) + 1

      ls := s_relate[ len( M->s_relate ) ]
      lk := k_relate[ len( M->k_relate ) ]
      lt := t_relate[ len( M->t_relate ) ]

      array_ins( M->s_relate, M->c_el )
      array_ins( M->k_relate, M->c_el )
      array_ins( M->t_relate, M->c_el )

      if M->c_row < 21
         scroll( M->c_row, column[ 1 ], 22, M->pos_r - 1, - 2 )

      else
         @ M->c_row + 1, column[ 1 ] say space( M->width )

      endif

      if M->k <= len( M->k_relate )

         if .not. empty( k_relate[ M->k ] )
            @ 22, M->pos_r say M->more_down

         endif
      endif

      get_relation( M->c_row, M->c_el )

      if .not. empty( k_relate[ M->c_el ] )
         disp_relation( M->c_row, M->c_el, color7 )

      else
         store "x" to s_relate[ M->c_el ], ;
                 k_relate[ M->c_el ], t_relate[ M->c_el ]

         array_del( M->s_relate, M->c_el )
         array_del( M->k_relate, M->c_el )
         array_del( M->t_relate, M->c_el )

         s_relate[ len( M->s_relate ) ] = M->ls
         k_relate[ len( M->k_relate ) ] = M->lk
         t_relate[ len( M->t_relate ) ] = M->lt

         if M->c_row < 21
            scroll( M->c_row, column[ 1 ], 22, M->pos_r - 1, 2 )

         else
            @ 21, column[ 1 ] say space( M->width )
            @ 22, column[ 1 ] say space( M->width )

         endif

         disp_relation( 21, M->c_el + ( ( 21 - M->c_row ) / 2 ), color7 )

      endif

      if M->k <= len( M->k_relate )

         if empty( k_relate[ M->k ] )
            @ 22, M->pos_r say " "

         endif
      endif

      keystroke := 0

   case M->keystroke = 13
      get_relation( M->c_row, M->c_el )

      disp_relation( M->c_row, M->c_el, color7 )

      keystroke := 0

   case M->keystroke = 7 .and. .not. empty( k_relate[ M->c_el ] )
      need_relat := .T.

      n_area := asc( s_relate[ M->c_el ] ) - asc( "A" ) + 1
      select( M->n_area )

      set relation to

      array_del( M->s_relate, M->c_el )
      array_del( M->k_relate, M->c_el )
      array_del( M->t_relate, M->c_el )

      if M->c_row < 21
         scroll( M->c_row, column[ 1 ], 22, M->pos_r - 1, 2 )

      else
         @ 21, column[ 1 ] say space( M->width )
         @ 22, column[ 1 ] say space( M->width )

      endif

      disp_relation( 21, M->c_el + ( ( 21 - M->c_row ) / 2 ), color7 )

      if M->c_el < len( M->k_relate ) - ( ( 21 - M->c_row ) / 2 )

         if empty( k_relate[ M->c_el + ( ( 21 - M->c_row ) / 2 ) + 1 ] )
            @ 22, M->pos_r say " "

         endif
      endif

      keystroke := 0

   case M->keystroke = 5 .and. M->c_el > 1
      c_el := M->c_el - 1

      if M->c_row > 11
         c_row := M->c_row - 2

      else
         scroll( 11, column[ 1 ], 22, M->pos_r - 1, - 2 )

         disp_relation( 11, M->c_el, color7 )

         if M->c_el <= len( M->k_relate ) - 6

            if .not. empty( k_relate[ M->c_el + 6 ] )
               @ 22, M->pos_r say M->more_down

            endif
         endif

         if M->c_el = 1
            @ 11, M->pos_r say " "

         endif
      endif

      keystroke := 0

   case M->keystroke = 24 .and. .not. ;
              ( empty( k_relate[ M->c_el ] ) .or. M->c_el = len( M->k_relate ) )
      c_el := M->c_el + 1

      if c_row < 22 - 2
         c_row := M->c_row + 2

      else
         scroll( 11, column[ 1 ], 22, M->pos_r - 1, 2 )

         @ 11, M->pos_r say M->more_up

         if .not. empty( k_relate[ M->c_el ] )
            disp_relation( 21, M->c_el, color7 )

         endif

         if M->c_el < len( M->k_relate )

            if empty( k_relate[ M->c_el + 1 ] )
               @ 22, M->pos_r say " "

            endif

         else
            @ 22, M->pos_r say " "

         endif
      endif

      keystroke := 0

   otherwise

      if .not. key_ready()
         disp_relation( M->c_row, M->c_el, cHilite )

         setcolor( M->cHilite )
         @ M->c_row, column[ 1 ] + 2 ;
                 say if( empty( k_relate[ M->c_el ] ), " ", "" )
         setcolor( M->cNorm )

         read_key()

         disp_relation( M->c_row, M->c_el, cNorm )

         @ M->c_row, column[ 1 ] + 2 say ""

      endif
   endcase
enddo

restscreen( 8, column[ 1 ] - 1, 23, M->pos_r + 1, M->rel_buff )

help_code := M->old_help

box_open := .F.

keystroke := 0
setcolor( saveColor )
return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function draw_relat()
*+
*+    Called from ( dbuview.prg  )   3 - function set_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function draw_relat

parameters start_el
private i

scroll( 11, column[ 1 ], 22, M->pos_r, 0 )

i := 0

do while M->i < 6 .and. M->start_el + M->i <= len( M->k_relate )

   if empty( k_relate[ M->start_el + M->i ] )
      exit

   endif

   disp_relation( 11 + ( 2 * M->i ), M->start_el + M->i, color7 )

   i := M->i + 1

enddo

if M->start_el > 1
   @ 11, M->pos_r say M->more_up

endif

if M->start_el + M->i <= len( M->k_relate )

   if .not. empty( k_relate[ M->start_el + M->i ] )
      @ 22, M->pos_r say M->more_down

   endif
endif

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_relation()
*+
*+    Called from ( dbuview.prg  )   2 - function set_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_relation

parameters row_n, element

private stroke
private k_input
private k_trim
private s_alias
private t_alias
private i
private j
private q
private pos_c
private ntx_expr
private k_type
private ok

if isdata( M->keystroke )
   i := c_search( upper( chr( M->keystroke ) ), M->dbf, 0, afull( M->dbf ) )

   if substr( dbf[ M->i ], 1, 1 ) = upper( chr( M->keystroke ) )
      keyboard chr( 13 )

   endif

else

   if empty( k_relate[ M->element ] )
      i := 1

   else
      i := asc( s_relate[ M->element ] ) - asc( "A" ) + 1

   endif
endif

j      := 0
stroke := 0

do while .not. ( M->j > 0 .and. M->stroke = 13 )

   do case

   case M->stroke = 13

      if M->i < 6

         if .not. empty( dbf[ M->i + 1 ] )

            if .not. empty( k_relate[ M->element ] )
               j := asc( t_relate[ M->element ] ) - asc( "A" ) + 1

            endif

            if M->j <= M->i
               j := M->i + 1

            endif
         endif
      endif

      stroke := 0

   case M->stroke = 4

      if M->j = 0 .and. M->i < 6

         if .not. empty( dbf[ M->i + 1 ] )
            i := M->i + 1

         endif

      else

         if M->j > 0 .and. M->j < 6

            if .not. empty( dbf[ M->j + 1 ] )
               j := M->j + 1

            endif
         endif
      endif

      stroke := 0

   case M->stroke = 19

      if M->j = 0 .and. M->i > 1
         i := M->i - 1

      else

         if M->j > 0
            j := M->j - 1

            if M->j = M->i
               j := 0

            endif
         endif
      endif

      stroke := 0

   case isdata( M->stroke )
      q := c_search( upper( chr( M->stroke ) ), M->dbf, M->i, afull( M->dbf ) )

      if substr( dbf[ M->q ], 1, 1 ) = upper( chr( M->stroke ) )

         if M->j = 0
            i := M->q
            keyboard chr( 13 )

         else

            if M->q > M->i
               j := M->q
               keyboard chr( 13 )

            else
               j := 0
               i := M->q

            endif
         endif
      endif

      stroke := 0

   case M->stroke = 27
      @ M->row_n, column[ 1 ] say space( M->width )
      return 0

   otherwise

      if M->j = 0
         @ M->row_n, column[ 1 ] say space( M->width )

         s_alias := name( dbf[ M->i ] )

         setcolor( M->color12 )
         @ M->row_n, column[ M->i ] + 2 say M->s_alias
         setcolor( M->cNorm )

      else
         t_alias := name( dbf[ M->j ] )

         pos_c := column[ M->i ] + 2 + len( M->s_alias )

         @ M->row_n, M->pos_c say space( M->pos_r - M->pos_c )

         @ M->row_n, M->pos_c ;
                 say replicate( "-", column[ M->j ] - M->pos_c + 1 ) + chr( 16 )

         setcolor( M->color12 )
         ?? t_alias
         setcolor( M->cNorm )

      endif

      stroke := raw_key()

   endcase
enddo

setcolor( M->cHilite )
@ M->row_n, column[ M->i ] + 2 say M->s_alias
@ M->row_n, column[ M->j ] + 2 say M->t_alias
setcolor( M->cNorm )

select( M->j )
ntx_expr := ctrl_key()

if empty( M->ntx_expr )
   k_type := "N"

else
   k_type := type( M->ntx_expr )

endif

select( M->i )

k_trim := k_relate[ M->element ]
ok     := .F.

do while .not. M->ok
   k_trim := enter_rc( M->k_trim, M->row_n + 1, column[ M->i ] + 2, ;
                       127, "@KS" + ltrim( str( M->pos_r - column[ M->i ] - 2 ) ), ;
                       M->color1 )

   ok := empty( M->k_trim ) .or. type( M->k_trim ) = M->k_type

   if .not. M->ok
      error_msg( "Expresso Invalida" )

   endif
enddo

@ M->row_n + 1, column[ 1 ] say space( M->width )

if empty( M->k_trim )
   return 0

endif

need_relat := .T.

k_relate[ M->element ] = M->k_trim
s_relate[ M->element ] = chr( M->i + asc( "A" ) - 1 ) + M->s_alias
t_relate[ M->element ] = chr( M->j + asc( "A" ) - 1 ) + M->t_alias

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function disp_relation()
*+
*+    Called from ( dbuview.prg  )   8 - function set_relation()
*+                                   1 - function draw_relat()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function disp_relation

parameters disp_row, element, cSpecial
private j
private k

if empty( k_relate[ M->element ] )
   @ M->disp_row, column[ 1 ]     say space( M->width )
   @ M->disp_row + 1, column[ 1 ] say space( M->width )
   return 0

endif

j := asc( s_relate[ M->element ] ) - asc( "A" ) + 1
k := asc( t_relate[ M->element ] ) - asc( "A" ) + 1

setcolor( M->cSpecial )
@ M->disp_row, column[ M->j ] + 2 say substr( s_relate[ M->element ], 2 )
setcolor( M->cNorm )

?? replicate( "-", column[ M->k ] - col() + 1 ) + chr( 16 )

setcolor( M->cSpecial )
?? substr( t_relate[ M->element ], 2 )
setcolor( M->cNorm )

@ M->disp_row + 1, column[ M->j ] + 2 ;
        say pad( k_relate[ M->element ], M->pos_r - column[ M->j ] - 2 )

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function c_search()
*+
*+    Called from ( dbuview.prg  )   2 - function get_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function c_search

parameters c, array, cur_el, num_d
private chr_el

chr_el := M->cur_el + 1

do while M->chr_el <= M->num_d

   if upper( substr( array[ M->chr_el ], 1, 1 ) ) = upper( M->c )
      exit

   endif

   chr_el := M->chr_el + 1

enddo

if M->chr_el > M->num_d
   chr_el := 1

   do while M->chr_el < M->cur_el .and. ;
              upper( substr( array[ M->chr_el ], 1, 1 ) ) <> upper( M->c )

      chr_el := M->chr_el + 1

   enddo
endif

return M->chr_el

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ctrl_key()
*+
*+    Called from ( dbuview.prg  )   1 - function get_relation()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ctrl_key

private key
private ntx

if M->need_ntx
   ntx := "ntx" + ltrim( str( select() ) )

   key := ntx_key( &ntx[ 1 ] )

else
   key := indexkey( 0 )

endif

return M->key

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_filter()
*+
*+    Called from ( dbuview.prg  )   1 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_filter

private k_filter
private k_trim
private old_help

old_help  := M->help_code
help_code := 7

k_filter := "kf" + substr( "123456", M->cur_area, 1 )
k_trim   := &k_filter

select( M->cur_area )

hi_cur()

DECLARE boxarray[ 4 ]

boxarray[ 1 ] = "fltr_title(sysparam)"
boxarray[ 2 ] = "getfilter(sysparam)"
boxarray[ 3 ] = "ok_button(sysparam)"
boxarray[ 4 ] = "can_button(sysparam)"

okee_dokee := "do_filter()"

multibox( 7, 17, 5, 2, M->boxarray )

help_code := M->old_help

dehi_cur()

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function fltr_title()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function fltr_title

parameters sysparam

return box_title( M->sysparam, "Setar filtro para " + ;
                  substr( M->cur_dbf, rat( hb_ps(), M->cur_dbf ) + 1 ) + ;
                  " para..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function getfilter()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function getfilter

parameters sysparam

return get_k_trim( M->sysparam, "Condio" )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_filter()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_filter

private done
private k_sample

if empty( M->k_trim )
   done := .T.

   if .not. empty( &k_filter )
      set filter to

      &k_filter := ""

   endif

else

   if type( M->k_trim ) = "L"
      done := .T.

      if .not. ( &k_filter == M->k_trim )
         need_filtr := .T.
         &k_filter  := M->k_trim

      endif

   else
      done := .F.
      error_msg( "Filtro precisa ser uma expresso lЂgica" )

   endif
endif

return M->done

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function clear_dbf()
*+
*+    Called from ( dbuview.prg  )   1 - set_view()
*+                                   1 - function do_opendbf()
*+                                   1 - function do_openvew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function clear_dbf

parameters work_area, shift
private s_alias
private c_area
private temp
private xtemp
private i
private file_name
private alias_6
private n_active

n_active := afull( M->dbf )

s_alias := name( dbf[ M->work_area ] )

alias_6 := ""

temp := "ntx" + substr( "123456", M->work_area, 1 )

do case

case M->shift = 0
   dbf[ M->work_area ] = ""

   n_files := M->n_files - afull( &temp ) - 1

case M->shift = 1

   if .not. empty( dbf[ 6 ] )
      alias_6 := name( dbf[ 6 ] )

      n_files := M->n_files - afull( M->ntx6 ) - 1

   endif

   shift := if( empty( dbf[ M->work_area ] ) .or. M->work_area = 6, 0, 1 )

   array_ins( M->dbf, M->work_area )

case M->shift = 2
   array_del( M->dbf, M->work_area )

   shift := if( empty( dbf[ M->work_area ] ), 0, 2 )

   n_files := M->n_files - afull( &temp ) - 1

endcase

i := 1

do while M->i <= M->n_active
   c_area := chr( M->i + asc( "A" ) - 1 )
   select( M->i )

   if M->i = M->work_area .or. ( M->i > M->work_area .and. M->shift <> 0 )
      dbclosearea()

   endif

   temp := "kf" + substr( "123456", M->i, 1 )

   if ( ( ( M->s_alias + "->" $ upper( &temp ) ) .or. ;
          ( M->i = M->work_area .and. .not. empty( &temp ) ) ) ;
          .and. M->shift <> 1 ) .or. ( .not. empty( M->alias_6 ) .and. ;
          M->alias_6 + "->" $ upper( &temp ) .and. M->shift = 1 )

      set filter to

      need_filtr := .T.

      &temp := ""

   endif

   i := M->i + 1

enddo

do case

case M->shift = 0
   temp := "ntx" + substr( "123456", M->work_area, 1 )
   afill( &temp, "" )

   temp := "field_n" + substr( "123456", M->work_area, 1 )
   afill( &temp, "" )

   temp  := "kf" + substr( "123456", M->work_area, 1 )
   &temp := ""

case M->shift = 1
   need_filtr := .T.
   need_ntx   := .T.

   i := 6

   do while empty( dbf[ M->i ] )
      i := M->i - 1

   enddo

   do while M->i > M->work_area
      temp  := "ntx" + substr( "123456", M->i, 1 )
      xtemp := "ntx" + substr( "123456", M->i - 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "field_n" + substr( "123456", M->i, 1 )
      xtemp := "field_n" + substr( "123456", M->i - 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "cr" + substr( "123456", M->i, 1 )
      xtemp := "cr" + substr( "123456", M->i - 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "el" + substr( "123456", M->i, 1 )
      xtemp := "el" + substr( "123456", M->i - 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "kf" + substr( "123456", M->i, 1 )
      xtemp := "kf" + substr( "123456", M->i - 1, 1 )
      &temp := &xtemp

      i := M->i - 1

   enddo

   xtemp := substr( "123456", M->i, 1 )

   temp := "ntx" + xtemp
   afill( &temp, "" )

   temp := "field_n" + xtemp
   afill( &temp, "" )

   temp  := "kf" + xtemp
   &temp := ""

   temp := "cr" + xtemp
   &temp[ 2 ] = row_a[ 2 ]
   &temp[ 3 ] = row_a[ 3 ]

   temp := "el" + xtemp
   afill( &temp, 1 )

case M->shift = 2
   need_filtr := .T.
   need_ntx   := .T.

   i := M->work_area

   do while M->i < 6 .and. .not. empty( dbf[ M->i ] )
      temp  := "ntx" + substr( "123456", M->i, 1 )
      xtemp := "ntx" + substr( "123456", M->i + 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "field_n" + substr( "123456", M->i, 1 )
      xtemp := "field_n" + substr( "123456", M->i + 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "cr" + substr( "123456", M->i, 1 )
      xtemp := "cr" + substr( "123456", M->i + 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "el" + substr( "123456", M->i, 1 )
      xtemp := "el" + substr( "123456", M->i + 1, 1 )
      acopy( &xtemp, &temp )

      temp  := "kf" + substr( "123456", M->i, 1 )
      xtemp := "kf" + substr( "123456", M->i + 1, 1 )
      &temp := &xtemp

      i := M->i + 1

   enddo

   xtemp := substr( "123456", M->i, 1 )

   temp := "ntx" + M->xtemp
   afill( &temp, "" )

   temp := "field_n" + M->xtemp
   afill( &temp, "" )

   temp  := "kf" + M->xtemp
   &temp := ""

   temp := "cr" + M->xtemp
   &temp[ 2 ] = row_a[ 2 ]
   &temp[ 3 ] = row_a[ 3 ]

   temp := "el" + M->xtemp
   afill( &temp, 1 )

endcase

need_field := .T.

c_area := chr( M->work_area + asc( "A" ) - 1 )

i := 1

do while M->i <= len( M->k_relate )

   if empty( k_relate[ M->i ] )
      exit

   endif

   if ( ( substr( s_relate[ M->i ], 1, 1 ) = M->c_area .or. ;
          substr( t_relate[ M->i ], 1, 1 ) = M->c_area ) .and. M->shift <> 1 ) .or. ;
          ( M->shift = 1 .and. substr( t_relate[ M->i ], 1, 1 ) = "F" )

      array_del( M->s_relate, M->i )
      array_del( M->k_relate, M->i )
      array_del( M->t_relate, M->i )
      need_relat := .T.

   else

      if ( M->shift = 2 .and. substr( s_relate[ M->i ], 1, 1 ) > M->c_area ) .or. ;
           ( M->shift = 1 .and. substr( s_relate[ M->i ], 1, 1 ) >= M->c_area )

         s_relate[ M->i ] = chr( asc( substr( s_relate[ M->i ], 1, 1 ) ) + ;
                 if( M->shift = 1, 1, - 1 ) ) + ;
                 substr( s_relate[ M->i ], 2 )
         need_relat := .T.

      endif

      if ( M->shift = 2 .and. substr( t_relate[ M->i ], 1, 1 ) > M->c_area ) .or. ;
           ( M->shift = 1 .and. substr( t_relate[ M->i ], 1, 1 ) >= M->c_area )

         t_relate[ M->i ] = chr( asc( substr( t_relate[ M->i ], 1, 1 ) ) + ;
                 if( M->shift = 1, 1, - 1 ) ) + ;
                 substr( t_relate[ M->i ], 2 )
         need_relat := .T.

      endif

      i := M->i + 1

   endif
enddo

if M->shift <> 0
   i := 6

   do while M->i >= M->work_area

      if .not. empty( dbf[ M->i ] )
         c_area := chr( M->i + asc( "A" ) - 1 )
         select( M->i )
         file_name := dbf[ M->i ]
         DBUREDE( file_name,, ABERTURA )

      endif

      i := M->i - 1

   enddo
endif

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function save_view()
*+
*+    Called from ( dbuview.prg  )   1 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function save_view

private filename
private old_help

old_help  := M->help_code
help_code := 21

if empty( M->view_file ) .and. .not. empty( dbf[ 1 ] )
   filename := name( dbf[ 1 ] ) + ".vew"

else
   filename := M->view_file

endif

filebox( ".vew", "vew_list", "vcrea_titl", "do_creavew", .T., 8 )

help_code := M->old_help

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function vcrea_titl()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function vcrea_titl

parameters sysparam

return box_title( M->sysparam, "Salvando Viso como..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_creavew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_creavew

private i
private j
private k
private m_name
private l_name
private add_name

if empty( M->filename )
   error_msg( "Arquivo de viso no selecionado" )
   return .F.

endif

select 10

stat_msg( "Criando arquivo de Viso" )

add_name := .not. HB_FILEEXISTS( name( filename ) + ".vew" )

CREATE ddbbuuuu

netrecapp()
field->field_name := "ITEM_NAME"
field->field_type := "C"
field->field_len  := 10
dbunlock()

netrecapp()
field->field_name := "CONTENTS"
field->field_type := "C"
field->field_len  := 10
dbunlock()

dbclosearea()
CREATE &filename from ddbbuuuu

view_file := M->filename

DBUREDE( view_file, "ddbbuuuu", ABERTURA )

Ferase("ddbbuuuu.dbf")

netrecapp()
field->item_name := "cur_dir"
dbunlock()
put_line( cur_dir )

netrecapp()
field->item_name := "n_files"
dbunlock()
put_line( ltrim( str( n_files ) ) )

i := 1

do while i <= 6

   if empty( dbf[ i ] )
      exit

   endif

   m_name := "kf" + substr( "123456", i, 1 )

   if .not. empty( &m_name )
      netrecapp()
      field->item_name := m_name
      dbunlock()
      put_line( &m_name )

   endif

   i ++

enddo

i := 1

do while i <= 6

   if empty( dbf[ i ] )
      exit

   endif

   netrecapp()
   field->item_name := "dbf"
   dbunlock()
   put_line( dbf[ i ] )

   i ++

enddo

l_name := "ntx"

for k := 1 to 2
   i := 1

   do while i <= 6

      if empty( dbf[ i ] )
         exit

      endif

      m_name := l_name + substr( "123456", i, 1 )

      j := 1

      do while j <= len( &m_name )

         if empty( &m_name[ j ] )
            exit

         endif


         netrecapp()
         field->item_name := m_name
         dbunlock()
         put_line( &m_name[ j ] )

         j ++

      enddo

      i ++

   enddo

   l_name := "field_n"

next

i := 1

do while i <= 3
   m_name := substr( "skt", i, 1 ) + "_relate"
   j      := 1

   do while j <= len( &m_name )

      if empty( &m_name[ j ] )
         exit

      endif

      netrecapp()
      field->item_name := m_name
      dbunlock()
      put_line( &m_name[ j ] )

      j ++

   enddo

   i ++

enddo

dbclosearea()

if at( ".vew", filename ) = len( filename ) - 3 .and. ;
       HB_FILEEXISTS( name( filename ) + ".vew" ) .and. add_name

   i := afull( vew_list ) + 1

   if i <= len( vew_list )
      vew_list[ i ] = filename

      array_sort( vew_list )

   endif
endif

stat_msg( "" )

return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function put_line()
*+
*+    Called from ( dbuview.prg  )   6 - function do_creavew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function put_line

parameters line
private pos
netreclock()
field->contents := line
dbunlock()

pos := len( contents ) + 1

do while pos <= len( line )
   netrecapp()
   field->contents := substr( line, pos )
   dbunlock()

   pos += len( contents )

enddo

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function set_from()
*+
*+    Called from ( dbu.prg      )   1 -
*+                ( dbuview.prg  )   1 - set_view()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function set_from

parameters from_view
private filename
private old_help

old_help  := M->help_code
help_code := 21

filename := M->view_file

if M->from_view

   if filebox( ".vew", "vew_list", "vopen_titl", "do_openvew", .F., 8 ) <> 0
      keystroke := 13

   endif

else
   do_openvew()

endif

help_code := M->old_help

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function vopen_titl()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function vopen_titl

parameters sysparam

return box_title( M->sysparam, "Relendo Viso de..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_openvew()
*+
*+    Called from ( dbuview.prg  )   1 - function set_from()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_openvew

private m_name
private i
private done

do case

case empty( M->filename )
   error_msg( "Viso no selecionado" )
   done := .F.

case .not. HB_FILEEXISTS( M->filename )
   error_msg( "No Pude Abrir " + M->filename )
   done := .F.

otherwise
   select 10

   DBUREDE( filename, "ddbbuuuu", ABERTURA )

   if .not. ( type( "item_name" ) = "C" .and. type( "contents" ) = "C" )
      dbclosearea()
      error_msg( "Invalido arquivo de viso" )
      return .F.

   endif

   view_file := M->filename

   need_field := need_ntx := need_relat := need_filtr := .T.
   stat_msg( "Restaurando Viso" )

   i := 6

   do while M->i > 0

      if .not. empty( dbf[ M->i ] )
         clear_dbf( M->i, 0 )

      endif

      i := M->i - 1

   enddo

   select 10

   cur_dir := get_line()
   n_files := val( get_line() )

   if trim( item_name ) == "k_filter"
      netreclock()
      field->item_name := "kf1"
      dbunlock()
      kf1 := get_line()

   else

      do while substr( item_name, 1, 2 ) == "kf"
         m_name := trim( item_name )

         &m_name := get_line()

      enddo
   endif

   do while .not. eof()
      m_name := trim( item_name )
      i      := 1

      do while trim( item_name ) == m_name
         &m_name[ i ] = get_line()

         i ++

      enddo
   enddo

   dbclosearea()

   i := 1

   do while M->i <= 6

      if empty( dbf[ M->i ] )
         exit

      endif

      select( M->i )

      filename := dbf[ M->i ]
      DBUREDE( filename,, ABERTURA )

      i := M->i + 1

   enddo

   stat_msg( "" )
   done := .T.

endcase

return M->done

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function get_line()
*+
*+    Called from ( dbuview.prg  )   5 - function do_openvew()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function get_line

private line

line := trim( contents )
skip

do while len( trim( item_name ) ) = 0 .and. .not. eof()
   line += trim( contents )
   skip

enddo

return line


function pegparexp
       //30/12/2O22 Inclusao MYS MYSQL
       zEXPOREXT:=PADR(zEXPOREXT,4)
       @ MAxrow()-2,0 clear 
       @ MAXROW()-1,0 CLEAR
       @ MAXROW()  ,0 CLEAR
       @ maxrow()-2,0 say "Delimitador ,;|#~ 9=(TAB)"
       @ maxrow()-2,30 say "Extensao DLM,CVS,UNL,XLS,XML,SQL,JSON" 
       @ maxrow()-1,0 say  "Separador Decimal ,. "
       @ maxrow()-1,23 say "Digitos Ano 2/4"
       @ maxrow()-1,41 say "Separador Data /-( )"
       @ maxrow()-1,64 say "Sep Reg "+chr(34)+chr(39)+"( ) "
       @ maxrow()  ,0 say  "Formato data Ano/mes/dia DMA AMD MDA SQL MYS"
       @ maxrow()  ,38 say "Converter (N)ao oemto(A)nsi ansito(O)em"  

       @ maxrow()-2,26 get zDELIMITE PICT "!"    VALID zDELIMITE $ ",;|#~9"       
       @ maxrow()-2,68 get zEXPOREXT PICT "!!!!"  VALID zEXPOREXT="DLM" .OR. zEXPOREXT="CVS" .OR. zEXPOREXT="UNL" .OR. zEXPOREXT="XLS" .OR. zEXPOREXT="XML" .OR. zEXPOREXT="SQL" .OR. zEXPOREXT="JSON"
       @ maxrow()-1,21 get zDECSIM               VALID zDECSIM $ ",."       
       @ maxrow()-1,39 get zANOTAM   PICT "9"    VALID zANOTAM $ "24"
       @ maxrow()-1,62 get zANOSEP               VALID zANOSEP $ "/- "
       @ maxrow()-1,78 get zregSEP               VALID zregsEP $ chr(34)+chr(39)+" "
       @ maxrow()  ,33 get zANOFOR   PICT "!!!"  VALID zANOFOR="DMA".OR.zANOFOR="AMD".OR.zANOFOR="MDA" .OR. zANOFOR="SQL" .OR. zANOFOR="MYS"
       @ maxrow()  ,78 get zCNVCHAR  PICT "!"    VALID zCNVCHAR $ "NAO"  
       readcur() 
	   
	   zEXPOREXT=ALLTRIM(ZEXPOREXT)
       IF zEXPOREXT="XLS".AND.zDELIMITE<>"9"
          error_msg( "XLS requer requerer 9=(TAB)" )
          zDELIMITE="9"
       ENDIF
       IF zDELIMITE="9"
          zDELIMITE=CHR(9)
       ENDIF
       IF zEXPOREXT="SQL"
          zDELIMITE:=","
       ENDIF
	   IF zEXPOREXT="JSON"
	      zDELIMITE:=""
	   ENDIF

       @ MAxrow(),0 clear
       @ MAxrow()-2,0 clear 
       @ MAXROW()-1,0 CLEAR
    
     // criar_m[5]:=ZEXPOREXT agora usa geradoc 0 que pergunta o tipo  de exportacao
     // util_m[7]:=ZEXPOREXT agora usa multidocs 0 que pegunta o tipo de exportacao
	  layout()
return 

*+ EOF: DBUVIEW.PRG
