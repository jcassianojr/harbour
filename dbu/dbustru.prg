*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUSTRU.PRG
*+
*+    Functions: Procedure modi_stru()
*+               Function stru_row()
*+               Function stru_item()
*+               Function no_append()
*+               Function stru_ck()
*+               Function field_check()
*+               Function stru_title()
*+               Function do_modstru()
*+
*+    Reformatted by Click! 2.03 on Jun-27-2003 at  6:24 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Procedure modi_stru()
*+
*+    Called from ( dbu.prg      )   1 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

#INCLUDE "BOX.CH"
procedure modi_stru

local saveColor
private filename
private fill_row
private cur_row
private rec1
private m_item
private i
private n
private f_name
private f_type
private f_len
private f_dec
private prev_rec
private field_id
private stru_ok
private is_insert
private is_append
private altered
private type_n
private empty_row
private not_empty
private old_help
private chg_name
private len_temp
private stru_name
private wstru_buff
private temparq


old_help  := help_code
saveColor := setcolor( M->color7 )

wstru_buff := savescreen( 8, 20, 23, 59 )

DECLARE ffield[ 4 ]
DECLARE field_col[ 4 ]
DECLARE data_type[ 23 ]
DECLARE l_usr[ 23 ]



ffield[ 1 ] = "field_name"
ffield[ 2 ] = "field_type"
ffield[ 3 ] = "field_len"
ffield[ 4 ] = "field_dec"

field_col[ 1 ] = 22
field_col[ 2 ] = 35
field_col[ 3 ] = 48
field_col[ 4 ] = 55




data_type[ 1 ] = "Caracter "
data_type[ 2 ] = "Numerico "
data_type[ 3 ] = "Data     "
data_type[ 4 ] = "Logico   "
data_type[ 5 ] = "Memoria  "
data_type[6] = "BLOB     "
data_type[7] = "Image    "
data_type[8] = "OLE      "
data_type[9] = "VarLength"
data_type[10] = "Any      "
data_type[11] = "Float    "
data_type[12] = "Double   "
data_type[13] = "Double   "
data_type[14] = "Double   "
data_type[15] = "Currency "
data_type[16] = "Integer  "
data_type[17] = "Integer  "
data_type[18] = "Integer  "
data_type[19] = "Autoinc  "
data_type[20] = "Modtime  "
data_type[21] = "Rowver   "
data_type[22] = "Timestamp"
data_type[23] = "Time/stmp"


l_usr[1] = 3			&& character - variable len
l_usr[2] = 4			&& numeric - variable len and dec
l_usr[3] = 3			&& date - fixed len - 3, 4 or 8
l_usr[4] = 2			&& logical - fixed len - 1
l_usr[5] = 3			&& memo - fixed len - 10 or 4
l_usr[6] = 3			&& "W" - fixed len - 10 or 4
l_usr[7] = 3			&& "P" - fixed len - 10 or 4
l_usr[8] = 3			&& "G" - fixed len - 10 or 4
l_usr[9] = 3			&& "Q" - variable len
l_usr[10] = 3			&& "V" len 4 or 6 or above dec 0
l_usr[11] = 4			&& "F" like "N"
l_usr[12] = 4			&& "8" len 8
l_usr[13] = 4			&& "B" len 8
l_usr[14] = 4			&& "Z" len 8
l_usr[15] = 2			&& "Y" len 8, dec 4
l_usr[16] = 4			&& "I" len 1-4 or 8, default 4
l_usr[17] = 2			&& "2" len 2 dec 0
l_usr[18] = 2			&& "4" len 4 dec 0
l_usr[19] = 2			&& "+" len 4 dec 0
l_usr[20] = 2			&& "=" len 8 dec 0
l_usr[21] = 2			&& "^" len 8 dec 0
l_usr[22] = 2			&& "@" len 8 dec 0
l_usr[23] = 3			&& "T" len 4 or 8 dec 0



type_n    := 1
altered   := .F.
chg_name  := .T.
prev_rec  := 0
n         := 1
i         := 0
cur_row   := 13
is_insert := .F.
keystroke := 999
filename  := ""

empty_row := "           |           |       |    "
not_empty := "           | Caracter  |    10 |    "

if .not. empty( M->cur_dbf )

   stat_msg( "Lendo Estrutura do Arquivo" )
   stru_name := M->cur_dbf
   temparq:=trocaext(stru_name, "_stru.dbf" )
   
   select( M->cur_area )

   __dbCopyXStruct( temparq ) //COPY to &temparq STRUCTURE EXTENDED

   select 10
   DBUREDE( temparq )
   stru_ok   := .T.
   is_append := .F.

   stat_msg( "" )

else

   
   stru_name:=WIN_GETSAVEFILENAME( , "Novo Arquivo", HB_CWD(),"dbf", "*.txt" , 1,, "novoarquivo.dbf")
   temparq:=trocaext(stru_name,"_stru.dbf")
   
   select 10
   __dbCreate( temparq,,, .F., ) //CREATE &temparq
  
   netrecapp()
   field->field_type := "C"
   field->field_len  := 10
   field->field_dec  := 0

   stru_ok   := .F.
   is_append := .T.
 //  stru_name := "" zera para pegar abaixo o novo no nome mas feito aqui pelo win_getsavefilename

endif

scroll( 8, 20, 23, 59, 0 )
HB_dispbox( 8, 20, 23, 59,M->frame)

@  9, field_col[ 1 ] ;
        say "Estrutura de " + pad( if( empty( stru_name ), "<novo arquivo>", ;
        substr( stru_name, rat( hb_ps(), stru_name ) + 1 ) ), 13 )

@ 11, 20 say " Nome Campo   Tipo        Tamanho  Dec"
@ 12, 20 say "|------------|-----------|-------|-----|"
@ 23, 33 say "|-----------|-------|"

do while .not. q_check()

   do case

   case keystroke = 999
      scroll( 13, 21, 22, 58, 0 )
      rec1     := recno()
      fill_row := 13

      do while .not. eof() .and. fill_row <= 22
         stru_row( fill_row )

         skip
         fill_row ++

      enddo

      do while fill_row <= 22
         @ fill_row, field_col[ 1 ] say empty_row
         fill_row ++

      enddo

      goto rec1
      fill_row := 13

      do while fill_row < cur_row
         skip

         if eof()
            cur_row := fill_row
            go bottom
            exit

         endif

         fill_row ++

      enddo

      keystroke := 0

   case keystroke = 13 .or. isdata( keystroke )

      if n = 2
         type_n = AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")
         //type_n := at( field_type, "CNDLM" )

      else
         set cursor on

         if keystroke <> 13
            keyboard chr( keystroke )

         endif
      endif

      field_id := ffield[ n ]

      m_item := &field_id

      set key 5 to clear_gets
      set key 24 to clear_gets
      xkey_clear()

      do case

      case n = 1
         setcolor( M->color1 )
         @ cur_row, field_col[ 1 ] get field_name picture "@!K"
         READDBU()
         setcolor( M->color7 )
         keystroke := lastkey()

      case n = 2

         do case

         CASE UPPER(CHR(keystroke)) $ "CNDLMWPGQVF8BZYI24+=^@T"
         //case upper( chr( keystroke ) ) $ "CNDLM"
//            type_n    := at( upper( chr( keystroke ) ), "CNDLM" )
          	type_n = AT(UPPER(CHR(keystroke)), "CNDLMWPGQVF8BZYI24+=^@T")
            keystroke := 13

         case keystroke = 32
            type_n := if( type_n = 5, 1, type_n + 1 )

         case keystroke <> 13
            keystroke := 0

         endcase

         IF m_item <> SUBSTR("CNDLMWPGQVF8BZYI24+=^@T", type_n, 1)
         //if m_item <> substr( "CNDLM", type_n, 1 )
            //REPLACE field_type WITH SUBSTR("CNDLMWPGQVF8BZYI24+=^@T", type_n, 1)
            field->field_type := SUBSTR("CNDLMWPGQVF8BZYI24+=^@T", type_n, 1)
            //field->field_type := substr( "CNDLM", type_n, 1 )

            do case

               case field_type = "C"
                  field->field_dec := 0
               
               CASE field_type = "Q"
                  IF field_len > 255
                     field->field_len := 255                     
                  ELSEIF field_len = 0
                     field->field_len := 1                     
                  ENDIF
                  REPLACE field_dec WITH 0

               CASE field_type = "V"
                  IF field_len <> 4 .AND. field_len < 6
                     field->field_len := 6                     
                  ENDIF
                  field->field_dec := 0
                  

               CASE field_type $ "NF"
                  * numeric
                     if m_item = "C" .and. ( field_dec <> 0 .or.  field_len > 19 )
                        field->field_len := 10
                        field->field_dec := 0
                     endif

               CASE field_type = "I"
                  IF field_len = 0 .OR. (field_len > 4 .AND. field_len <> 8)
                      field->field_len := 4                     
                  ENDIF

               CASE field_type = "Y"
                   field->field_len := 8
                   field->field_dec := 4

                  

               CASE field_type $ "8BZ"
                  IF field_len <> 8
                     field->field_len := 8
                     
                  ENDIF

               CASE field_type = "2"
                  
                  field->field_len := 2
                  field->field_dec := 0

                                    

               CASE field_type = "4"
                  field->field_len := 4
                  field->field_dec := 0



               CASE field_type = "T"
                  IF field_len <> 4 .AND. field_len <> 8
                     field->field_len := 8                     
                  ENDIF
                  field->field_dec := 0
                  

               CASE field_type = "@"
                  field->field_len := 8
                  field->field_dec := 0
               
                  

               CASE field_type = "D"
                  IF field_len <> 3 .AND. field_len <> 4 .AND. field_len <> 8
                     field->field_len := 8
                  ENDIF
                  field->field_dec := 0


               case field_type = "L"
                  field->field_len := 1
                  field->field_dec := 0

               CASE field_type $ "MVWPG"
                  IF field_len <> 10 .AND. field_len <> 4
                     field->field_len := 10
                     
                  ENDIF
                  field->field_dec := 0
                  

               CASE field_type = "+"
                  field->field_len := 4                  
                  field->field_dec := 0

               CASE field_type $ "=^"
                  field->field_len := 8                                    
                  field->field_dec := 0
                  
                   
            endcase

            @ cur_row, field_col[ 3 ] say str( field_len, 4 )

          	IF field_type $ "NFYI8BZ" //if field_type = "N"
               @ cur_row, field_col[ 4 ] say field_dec

            else
               @ cur_row, field_col[ 4 ] say "   "

            endif
         endif new type

      case n = 3

         if field_type = "C"
            len_temp := ( 256 * field_dec ) + field_len

         else
            len_temp := field_len

         endif

         setcolor( M->color1 )
         @ cur_row, field_col[ n ] get len_temp picture "9999"
         READDBU()
         setcolor( M->color7 )
         keystroke := lastkey()

         if menu_key() = 0

            if field_type = "C"
               field->field_len := ( len_temp % 256 )
               field->field_dec := int( len_temp / 256 )

            else

               if len_temp < 256
                  field->field_len := len_temp

               else
                  keystroke := 0

               endif
            endif
         endif

      case n = 4
         setcolor( M->color1 )
         @ cur_row, field_col[ n ] get field_dec
         READDBU()
         setcolor( M->color7 )
         keystroke := lastkey()

      endcase

      set key 5 to
      set key 24 to
      xkey_norm()
      set cursor OFF

      if menu_key() <> 0
         field->&field_id := m_item
         keyboard chr( keystroke )

      endif

      if m_item <> &field_id
         stru_ok := .F.
         altered := .T.

         if n > 1
            chg_name := .F.

         endif
      endif

      do case

      case keystroke = 18 .or. keystroke = 5
         keystroke := 5

      case keystroke = 3 .or. keystroke = 24
         keystroke := 24

      case keystroke = 13 .or. ;
                 ( isdata( keystroke ) .and. keystroke <> 32 )
         keystroke := 4

      otherwise
         keystroke := 0

      endcase

      stru_item()

   case keystroke = 5 .and. recno() > 1

      if is_append

         if .not. stru_ck( .F. )
            no_append()

         endif
      endif

      if stru_ck( .T. )
         skip - 1

         if cur_row = 13
            scroll( 13, 21, 22, 58, - 1 )

            stru_row( 13 )

         else
            cur_row --

         endif

         is_append := .F.
         is_insert := .F.

      else
         n := i

      endif

      keystroke := 0

   case keystroke = 24

      if stru_ck( recno() < lastrec() )
         skip

         if eof()
            netrecapp()
            field->field_type := "C"
            field->field_len  := 10
            field->field_dec  := 0
            is_append         := .T.
            stru_ok           := .F.
            n                 := 1

            if cur_row < 22
               @ cur_row + 1, field_col[ 1 ] say not_empty

            endif

         else
            is_insert := .F.

         endif

         if cur_row = 22
            scroll( 13, 21, 22, 58, 1 )

            stru_row( 22 )

         else
            cur_row ++

         endif

      else
         n := i

      endif

      keystroke := 0

   case keystroke = 4

    	IF n < l_usr[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")] //if n < l_usr[ at( field_type, "CNDLM" ) ]
         n ++

      endif

      keystroke := 0

   case keystroke = 19

      if n > 1
         n --

      endif

      keystroke := 0

   case keystroke = 18
      keystroke := 0

      if recno() = 1
         loop

      endif

      if is_append

         if .not. stru_ck( .F. )
            no_append()

         endif
      endif

      if stru_ck( .T. )
         is_append := .F.
         is_insert := .F.

         if recno() = cur_row - 12
            go top
            cur_row := 13

         else
            skip - ( 9 + cur_row - 13 )
            keystroke := 999

         endif

      else
         n := i

      endif

   case keystroke = 3
      keystroke := 0

      if is_append
         loop

      endif

      if stru_ck( .T. )
         is_insert := .F.

         if lastrec() - recno() <= 22 - cur_row
            cur_row += lastrec() - recno()
            go bottom

         else
            keystroke := 999
            skip 9 - ( cur_row - 13 )

            if eof()
               go bottom

            endif
         endif

      else
         n := i

      endif

   case keystroke = 31
      keystroke := 0

      if recno() = 1
         loop

      endif

      if is_append

         if .not. stru_ck( .F. )
            no_append()

         endif
      endif

      if stru_ck( .T. )
         is_append := .F.
         is_insert := .F.

         if recno() > cur_row - 12
            keystroke := 999

         endif

         go top
         cur_row := 13

      else
         n := i

      endif

   case keystroke = 30
      keystroke := 0

      if is_append
         loop

      endif

      if stru_ck( .T. )
         is_insert := .F.

         if lastrec() - recno() <= 22 - cur_row
            cur_row += lastrec() - recno()
            go bottom

         else
            keystroke := 999
            go bottom
            skip - 9
            cur_row := 22

         endif

      else
         n := i

      endif

   case keystroke = 6 .or. keystroke = 23
      keystroke := 0
      n = l_usr[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")]
      //n         := l_usr[ at( field_type, "CNDLM" ) ]

   case keystroke = 1 .or. keystroke = 29   
 			* update field/record number on screen
 			//@ 9,field_col[1] + 26 SAY "Field " + pad(LTRIM(STR(RECNO())), 5)
			IF n > l_usr[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")]
 				* check for n out of range
				n = l_usr[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")]
 			ENDIF
      keystroke := 0
//      n         := 1

   case keystroke = 22

      if stru_ck( .T. )
         n         := 1
         stru_ok   := .F.
         is_append := .F.
         is_insert := .T.
         rec1      := recno()

         netrecapp()

         do while rec1 < recno()
            skip - 1

            f_name := field_name
            f_type := field_type
            f_len  := field_len
            f_dec  := field_dec

            skip
            field->field_name := f_name
            field->field_type := f_type
            field->field_len  := f_len
            field->field_dec  := f_dec

            skip - 1

         enddo

         field->field_name := space( 10 )
         field->field_type := "C"
         field->field_len  := 10
         field->field_dec  := 0

         if cur_row < 22
            scroll( ( cur_row ), 21, 22, 58, - 1 )

         endif

         @ cur_row, field_col[ 1 ] say not_empty

      else
         n := i

      endif

      keystroke := 0

   case keystroke = 7 .and. lastrec() > 1
      rec1 := recno()
      netrecdel()
      pack

      if rec1 > lastrec()
         go bottom

         if cur_row = 13
            stru_row( 13 )

         else
            @ cur_row, field_col[ 1 ] say empty_row
            cur_row --

         endif

      else

         if cur_row < 22
            scroll( ( cur_row ), 21, 22, 58, 1 )

         endif

         goto rec1
         skip 22 - cur_row

         if .not. eof()
            stru_row( 22 )

         else
            @ 22, field_col[ 1 ] say empty_row

         endif

         goto rec1

         prev_rec := 0

      endif

      if .not. is_append .and. .not. is_insert
         altered  := .T.
         chg_name := .F.

      endif

      is_append := .F.
      is_insert := .F.
      stru_ok   := .T.
      keystroke := 0

   case prev_rec <> recno()
      prev_rec := recno()

      @  9, field_col[ 1 ] + 26 say "Campo " + pad( ltrim( str( recno() ) ), 5 )
      
      
      IF n > l_usr[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")]
 				* check for n out of range
				n = l_usr[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")]
 			ENDIF
      

//      if n > l_usr[ at( field_type, "CNDLM" ) ]
//         n := l_usr[ at( field_type, "CNDLM" ) ]
//
//      endif

   case local_func = 4
      local_func := 0

      if .not. stru_ck( .T. )
         n := i
         loop

      endif

      is_append := .F.
      is_insert := .F.
      filename  := stru_name

      if filebox( ".dbf", "dbf_list", "stru_title", ;
                  "do_modstru", .T., 13 ) <> 0
         stru_name := filename

         @  9, field_col[ 1 ] + 13 ;
                 say pad( if( empty( stru_name ), "<novo arquivo>", ;
                 substr( stru_name, rat( hb_ps(), stru_name ) + 1 ) ), 13 )

         if aseek( dbf, filename ) = 0
            cur_dbf := filename

            open_dbf( .F., .T. )

            select 10

         endif

         keystroke := 27
         cur_area  := 0

      endif

      stat_msg( "" )

   otherwise

      if .not. key_ready()
         setcolor( M->color2 )
         stru_item()
         setcolor( M->color7 )

         read_key()

         if .not. ( keystroke = 13 .or. isdata( keystroke ) )
            stru_item()

         endif
      endif

      if keystroke = 27 .and. altered

         if rsvp( "Ok Abondonar Mudancas? (S/N)" ) <> "S"
            keystroke := 0

         endif
      endif
   endcase
enddo create / modify structure
if select( TEMPARQ ) # 0
   dbselectar( TEMPARQ )
endif
dbclosearea()
ferase(temparq)
//ferase( temparq + ".dbf" )
//ferase( temparq + ".TMP" )
stat_msg( "" )

restscreen( 8, 20, 23, 59, M->wstru_buff )

setcolor( saveColor )
return

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function stru_row()
*+
*+    Called from ( dbustru.prg  )   5 - procedure modi_stru()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function stru_row

parameters fill_row

@ fill_row, field_col[ 1 ] ;
        say field_name + " | " + data_type[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")] + " | "
        
        
if field_type = "C"
   @ fill_row, field_col[ 3 ] say str( ( ( 256 * field_dec ) + field_len ), 4 ) + ;
           " н    "

else
   @ fill_row, field_col[ 3 ] say str( field_len, 4 ) + " н    "

   IF field_type $ "NFYI8BZ" //if field_type = "N"
      @ fill_row, field_col[ 4 ] say field_dec

   endif
endif

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function stru_item()
*+
*+    Called from ( dbustru.prg  )   3 - procedure modi_stru()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function stru_item

do case

case n = 1
   @ cur_row, field_col[ 1 ] say field_name

case n = 2
   @ cur_row,field_col[2] SAY data_type[AT(LEFT(field_type, 1), "CNDLMWPGQVF8BZYI24+=^@T")]
   //@ cur_row, field_col[ 2 ] say data_type[ at( field_type, "CNDLM" ) ]

case n = 3

   if field_type = "C"
      @ cur_row, field_col[ n ] say str( ( ( 256 * field_dec ) + ;
              field_len ), 4 )

   else
      @ cur_row, field_col[ n ] say str( field_len, 4 )

   endif

case n = 4
   @ cur_row, field_col[ 4 ] say field_dec

endcase

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function no_append()
*+
*+    Called from ( dbustru.prg  )   3 - procedure modi_stru()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function no_append

netrecdel()
pack
dbgobottom()
dbskip()

if ( recno() = cur_row - 12 ) .or. keystroke = 5
   @ cur_row, field_col[ 1 ] say empty_row

endif

stru_ok := .T.

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function stru_ck()
*+
*+    Called from ( dbustru.prg  )  11 - procedure modi_stru()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function stru_ck

parameters disp_err

if .not. stru_ok
   i       := field_check( disp_err )
   stru_ok := ( i = 0 )

endif

return stru_ok

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function field_check()
*+
*+    Called from ( dbustru.prg  )   1 - function stru_ck()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function field_check

parameters disp_err
private pos
private test_num
private test_name
private status
private err_msg

status  := 0
err_msg := ""

pos := len( trim( field_name ) )

if pos = 0
   status  := 1
   err_msg := "Campo sem nome"

endif

if status = 0

   do while pos > 0 .and. substr( field_name, pos, 1 ) $ ;
              "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
      pos --

   enddo

   if pos > 0 .or. substr( field_name, 1, 1 ) $ "0123456789_"
      status  := 1
      err_msg := "Nome ilegal de Campo"

      if keystroke = 24
         disp_err := .T.

      endif
   endif
endif

if status = 0
   test_num  := recno()
   test_name := field_name
   locate for field_name = test_name .and. recno() <> test_num

   if found()
      status  := 1
      err_msg := "Nome de campos duplicados"

      if keystroke = 24
         disp_err := .T.

      endif
   endif

   goto test_num

endif

if status = 0

   if field_type = "C"
      test_num := ( 256 * field_dec ) + field_len

      if test_num <= 0 .or. test_num > 1024
         status  := 3
         err_msg := "Tamanho de Campo invalido"

         if keystroke = 24
            disp_err := .T.

         endif
      endif

   else

      if field_len <= 0 .or. field_len > 19
         status  := 3
         err_msg := "Tamanho de Campo invalido"

         if keystroke = 24
            disp_err := .T.

         endif
      endif
   endif
endif

IF field_type $ "NFYI8BZ" .AND. status = 0
//if field_type = "N" .and. status = 0

   if field_dec > if( field_len < 3, 0, if( field_len > 17, 15, field_len - 2 ) )
      status  := 4
      err_msg := "Tamanho de decimais invalido"

      if keystroke = 24
         disp_err := .T.

      endif
   endif
endif

if status > 0 .and. disp_err
   error_msg( err_msg )

endif

return status

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function stru_title()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function stru_title

parameters sysparam

return box_title( M->sysparam, "Salvando estrutura para..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_modstru()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_modstru

private stru_done
private i
private is_open
private new_name
private name_temp
private add_name
private dbt_spec
private dbt_temp
private rec1

do case

case empty( filename )
   error_msg( "Nome de Arquivo nao fornecido" )
   stru_done := .F.

otherwise
   i       := aseek( dbf, filename )
   is_open := ( i > 0 )

   if file( filename ) .and. .not. ( filename == cur_dbf )

      if rsvp( filename + if( is_open, " J  est  aberto", ;
               " ou j  existe" ) + ;
               "...Sobreponha? (S/N)" ) <> "S"
         return .F.

      endif
   endif

   if is_open
      name_temp := "ntx" + substr( "123456", i, 1 )
      need_ntx  := need_ntx .or. .not. empty( &name_temp[ 1 ] )

      not_target( i, .F. )

      select( M->i )
      dbclosearea()

      name_temp := "kf" + substr( "123456", i, 1 )

      if .not. empty( &name_temp )
         need_filtr := .T.

      endif

      select 10

   endif

   rec1 := recno()
   dbclosearea()

   add_name := .not. HB_FILEEXISTS( name( filename ) + ".dbf" )

   if file( filename )
      new_name := " "

      if chg_name .and. altered
         new_name := rsvp( "Trocar nome(s) de Campos? (S/N)" )

         if .not. new_name $ "SN"
            DBUREDE( temparq )
            goto rec1
            return .F.

         endif
      endif


      name_bak  := trocaext(filename,"_temp.dbf") //substr( filename, 1, rat( hb_ps(), filename ) ) +  substr( FILENAME, 1, at( ".", FILENAME ) - 1 ) + ".bak"
      name_temp := trocaext(temparq,"_temp.dbf") //substr( filename, 1, rat( hb_ps(), filename ) ) +  temparq + ".bak"

      cORIMEMO:=hb_rddInfo( RDDI_MEMOEXT)

      cFILEMEMO:=TROCAEXT(filename,cORIMEMO)
	  IF FILE(cFILEMEMO)					   
		 dbt_spec := cFILEMEMO //substr( filename, 1, rat( ".", filename ) )  +   "DBT"
		 dbt_temp := trocaext(cFILEMEMO,"_TEMP"+_cORIMEMO)//substr( name_temp, 1, rat( ".", name_temp ) ) +  "DBT"
	  endif	  

//	  IF FILE(substr( filename, 1, rat( ".", filename ) )  +   "DBT")					   
//		 dbt_spec := substr( filename, 1, rat( ".", filename ) )  +   "DBT"
//		 dbt_temp := substr( name_temp, 1, rat( ".", name_temp ) ) +  "DBT"
//	  endif	  

	 // IF FILE(substr( filename, 1, rat( ".", filename ) )  +   "FPT")					   
	//	 dbt_spec := substr( filename, 1, rat( ".", filename ) )  +   "FPT"
	//	 dbt_temp := substr( name_temp, 1, rat( ".", name_temp ) ) +  "FPT"
	  //endif	  

	  //IF FILE(substr( filename, 1, rat( ".", filename ) )  +   "SMT")					   
	//	 dbt_spec := substr( filename, 1, rat( ".", filename ) )  +   "SMT"
	//	 dbt_temp := substr( name_temp, 1, rat( ".", name_temp ) ) +  "SMT"
	 // endif	  

      if file( dbt_spec )

         if new_name = "S"
            new_name := rsvp( "Atencao: Memos serao perdidos ...Continue? (S/N)" )

            if new_name <> "S"
               DBUREDE( temparq )
               goto rec1
               return .F.

            endif
         endif

         if file( DBT_TEMP )
            ferase( DBT_TEMP )
         endif
         
         Frename(dbt_spec,dbt_temp) //         rename &dbt_spec to &dbt_temp

      endif

      stat_msg( if( new_name <> "S", "Alterando estrutura do Arquivo",  "Alternado nome(s) de campo" ) )

      if file( NAME_BAK )
         ferase( NAME_BAK )
      endif

      Frename(filename,name_bak)

      aSTRU := {}
      dbselectar( TEMPARQ )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      dbeval( { || aadd( aSTRU, { FIELD_NAME, FIELD_TYPE, FIELD_LEN, FIELD_DEC } ) } , {|| zei_fort(nLASTREC,,,1)})
      dbcreate( FILENAME, aSTRU )
      DBUREDE( FILENAME )
      dbselectar( substr( FILENAME, 1, at( ".", FILENAME ) - 1 ) )

      if new_name = "S"
         dbselectar( substr( FILENAME, 1, at( ".", FILENAME ) - 1 ) )
         dbclosearea()
         temparq2 := trocaext(temparq , ".txt")
         DBUREDE( name_bak )
         nLASTREC:=LASTREC()
         zei_fort( nLASTREC,,,0)
         
         COPY to &temparq2 SDF while zei_fort(nLASTREC,,,1)
         dbclosearea()
         DBUREDE( filename )
         
         nLASTREC:=flinecount(temparq2)
         zei_fort( nLASTREC,,,0)         
         append from &temparq2 SDF while zei_fort(nLASTREC,,,1)         
         ferase( temparq2 )
         
      else
      
         nLASTREC:=NetRegCount(name_bak)
         zei_fort( nLASTREC,,,0)
         append from &name_bak while zei_fort(nLASTREC,,,1)
         
      endif

      if file( name_temp )
         ferase(name_temp) //erase &name_temp
      endif
      if file( dbt_temp )
         ferase(dbt_temp) //erase &dbt_temp
      endif

      if is_open
         dbclosearea()
         select( M->i )
         DBUREDE( filename )
         name_temp := "field_n" + substr( "123456", M->i, 1 )
         all_fields( M->i, &name_temp )
         select 10
      endif

   else
      stat_msg( "Criando um novo arquivo" )
      CREATE &filename from &temparq
      dbclosearea()

      if at( ".dbf", lower(filename) ) = len( filename ) - 3 .and.  HB_FILEEXISTS( name( filename ) + ".dbf" ) .and. add_name
         i := afull( dbf_list ) + 1

         if i <= len( dbf_list )
            dbf_list[ i ] = filename
            array_sort( dbf_list )

         endif
      endif
   endif

   dbclosearea()
   stru_done := .T.

endcase

return stru_done

*+ EOF: DBUSTRU.PRG
