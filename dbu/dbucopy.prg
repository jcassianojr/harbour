*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUCOPY.PRG
*+
*+    Functions: Procedure capprep()
*+               Function copy_title()
*+               Function trg_getfil()
*+               Function do_copy()
*+               Function appe_title()
*+               Function src_getfil()
*+               Function do_append()
*+               Function repl_title()
*+               Function repl_field()
*+               Function with_exp()
*+               Function do_replace()
*+               Function for_exp()
*+               Function while_exp()
*+               Function scope_num()
*+               Function tog_sdf()
*+               Function tog_delim()
*+
*+    Reformatted by Click! 2.03 on Jun-27-2003 at  6:24 pm
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

#INCLUDE "BOX.CH"
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Procedure capprep()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
procedure capprep

private filename
private files
private fi_disp
private okee_dokee
private cur_el
private rel_row
private def_ext
private mode
private fi_done
private for_cond
private while_cond
private how_many
private bcur
private for_row
private height
private field_mvar
private with_what

if M->func_sel = 3
   help_code := 22

   select( M->cur_area )

   field_mvar := ""
   with_what  := ""

   DECLARE field_m[ fcount() ]
   all_fields( M->cur_area, M->field_m )

   DECLARE boxarray[ 9 ]
   boxarray[ 1 ] = "repl_title(sysparam)"
   boxarray[ 2 ] = "repl_field(sysparam)"
   boxarray[ 3 ] = "with_exp(sysparam)"
   boxarray[ 4 ] = "for_exp(sysparam)"
   boxarray[ 5 ] = "while_exp(sysparam)"
   boxarray[ 6 ] = "scope_num(sysparam)"
   boxarray[ 7 ] = "ok_button(sysparam)"
   boxarray[ 8 ] = "can_button(sysparam)"
   boxarray[ 9 ] = "fieldlist(sysparam)"

   bcur       := 9
   for_row    := 6
   height     := 10
   okee_dokee := "do_replace()"
   fi_disp    := "repl_field(3)"

else
   filename := ""

   DECLARE txt_list[ adir( "*." +zEXPOREXT ) + 20 ]
   array_dir( "*."+zEXPOREXT, txt_list )

   DECLARE boxarray[ 10 ]

   if M->func_sel = 1
      pegparexp()
      help_code := 12
      bcur      := 2
      boxarray[ 1 ] = "copy_title(sysparam)"
      boxarray[ 2 ] = "trg_getfil(sysparam)"
      fi_disp    := "trg_getfil(3)"
      okee_dokee := "do_copy()"

   else
      pegparexp()
      help_code := 15
      bcur      := 10
      boxarray[ 1 ] = "appe_title(sysparam)"
      boxarray[ 2 ] = "src_getfil(sysparam)"
      fi_disp    := "src_getfil(3)"
      okee_dokee := "do_append()"

   endif

   boxarray[ 3 ] = "for_exp(sysparam)"
   boxarray[ 4 ] = "while_exp(sysparam)"
   boxarray[ 5 ] = "scope_num(sysparam)"
   boxarray[ 6 ] = "tog_sdf(sysparam)"
   boxarray[ 7 ] = "ok_button(sysparam)"
   boxarray[ 8 ] = "tog_delim(sysparam)"
   boxarray[ 9 ] = "can_button(sysparam)"
   boxarray[ 10 ] = "filelist(sysparam)"

   for_row := 5
   height  := 11

   files   := "dbf_list"
   def_ext := ".dbf"

   fi_done := "not_empty('filename')"

endif

for_cond := while_cond := ""

mode     := cur_el := 1
rel_row  := 0
how_many := 0

multibox( 8, 17, M->height, M->bcur, M->boxarray )
return

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function copy_title()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function copy_title

parameters sysparam

return box_title( M->sysparam, "Copiar " + ;
                  substr( M->cur_dbf, rat( hb_ps(), M->cur_dbf ) + 1 ) + ;
                  " para " )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function trg_getfil()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function trg_getfil

parameters sysparam

help_code := M->prime_help
return getfile( M->sysparam, 3 )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function do_copy()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function do_copy

private done
private add_name
private new_el

done := .F.

do case

  case empty( M->filename )
     error_msg( "Destino nao selecionado" )
  
  case M->filename == M->cur_dbf
     error_msg( "Arquivo nao pode ser copiado para se mesmo" )
  
  case .not. empty( M->for_cond ) .and. type( M->for_cond ) <> "L"
     error_msg( "PARA condiaao nao a uma expressao lagica" )
  
  case .not. empty( M->while_cond ) .and. type( M->while_cond ) <> "L"
     error_msg( "ENQUANTO condiaao nao a uma expressao lagica" )
  
  otherwise
     if file( M->filename )
        if rsvp( "Arquivo Destino " + if( aseek( M->dbf, M->filename ) > 0, ;
                 "Esta aberto", "Existe" ) + "...Sobreponha? (S/N)" ) <> "S"
           return .F.
        endif
     endif
  
     stat_msg( "Copiando" )
  
     if aseek( M->dbf, M->filename ) > 0
        select( aseek( M->dbf, M->filename ) )
        dbclosearea()
        need_field := need_ntx := need_relat := need_filtr := .T.
     endif
  
     select( M->cur_area )
  
     if rat( lower(M->def_ext), lower(M->filename) ) = len( M->filename ) - 3
        add_name := .not. HB_FILEEXISTS( name( M->filename ) + M->def_ext )
     else
        add_name := .F.
     endif
  
     if empty( M->for_cond )
        for_cond := ".T."
     endif
  
     if empty( M->while_cond )
        while_cond := ".T."
  
        if M->how_many = 0
           go top
  
        endif
     endif
  
  
     nLASTREC:=LASTREC()
     zei_fort( nLASTREC,,,0)
      
     do case
  
         case M->mode = 1 .and. M->how_many = 0
            COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1)  for &for_cond
      
         case M->mode = 1 .and. M->how_many > 0
            COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1)       for &for_cond
  
         case M->mode = 2 .and. M->how_many = 0
           COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond          SDF
  
         case M->mode = 2 .and. M->how_many > 0
           COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1)          for &for_cond SDF
  
         case M->mode = 3 .and. M->how_many = 0
         
         
            DO CASE
               CASE zREGSEP=chr(34) .OR. zREGSEP=chr(39)
                    COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH ( { zDELIMITE, zREGSE } )
               CASE  zDELIMITE=","
                    COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED
               CASE zDELIMITE="9"
                    COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH TAB
               CASE zDELIMITE="|"
                    COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH PIPE
               OTHERWISE     
                    COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH &zDELIMITE
            ENDCASE
       
//              COPY to &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond  DELIMITED
  
         case M->mode = 3 .and. M->how_many > 0
  
          DO CASE
               CASE zREGSEP=chr(34) .OR. zREGSEP=chr(39)
                    COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH ( { zDELIMITE, zREGSE } )
               CASE  zDELIMITE=","
                    COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED
               CASE zDELIMITE="9"
                    COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED WITH TAB
               CASE zDELIMITE="|"
                    COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED WITH PIPE
               OTHERWISE     
                    COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond DELIMITED WITH &zDELIMITE
            ENDCASE
    
  
  //            COPY to &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1)  for &for_cond DELIMITED
  
     endcase
  
     if aseek( M->dbf, M->filename ) > 0
        select( aseek( M->dbf, M->filename ) )
         DBUREDE( filename,, ABERTURA )
     endif
  
     if file( name( M->filename ) + M->def_ext ) .and. M->add_name
         new_el := afull( &files ) + 1
  
         if M->new_el <= len( &files )
            &files[ M->new_el ] = M->filename
            array_sort( &files )
  
         endif
     endif
  
    stat_msg( "Arquivo Copiado" )
    done := .T.

endcase

return M->done

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function appe_title()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function appe_title

parameters sysparam

return box_title( M->sysparam, "Anexar para " + ;
                  substr( M->cur_dbf, rat( hb_ps(), M->cur_dbf ) + 1 ) + ;
                  " de" )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function src_getfil()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function src_getfil

parameters sysparam

help_code := M->prime_help
return getfile( M->sysparam, 3 )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function do_append()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function do_append

private done

done := .F.

do case

case empty( M->filename )
   error_msg( "Fonte nao Selecionada" )

case M->filename == M->cur_dbf
   error_msg( "Arquivo nao pode ser anexado a si praprio" )

case .not. HB_FILEEXISTS( M->filename )
   error_msg( "Nao Pode-se abrir " + M->filename )

case .not. empty( M->for_cond ) .and. type( M->for_cond ) <> "L"
   error_msg( "PARA condiaao nao a uma expressao lagica" )

case .not. empty( M->while_cond ) .and. type( M->while_cond ) <> "L"
   error_msg( "ENQUANTO condiaao nao a uma expressao lagica" )

otherwise

   if aseek( M->dbf, M->filename ) > 0
      select( aseek( M->dbf, M->filename ) )
      dbcloseare()
      need_field := need_ntx := need_relat := need_filtr := .T.

   endif

   stat_msg( "Anexando" )
   select( M->cur_area )

   if empty( M->for_cond )
      for_cond := ".T."
   endif

   if empty( M->while_cond )
      while_cond := ".T."
   endif
   

   do case
   case M->mode = 1 .and. M->how_many = 0
      nLASTREC:=NetRegCount(filename)
      zei_fort( nLASTREC,,,0)
      append from &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for   &for_cond

   case M->mode = 1 .and. M->how_many > 0
      nLASTREC:=NetRegCount(filename)
      zei_fort( nLASTREC,,,0)
      append from &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond

   case M->mode = 2 .and. M->how_many = 0
      nLASTREC:=FLINECOUNT(filename)
      zei_fort( nLASTREC,,,0)
      append from &filename while &while_cond..and.zei_fort(nLASTREC,,,1) for  &for_cond SDF

   case M->mode = 2 .and. M->how_many > 0
      nLASTREC:=FLINECOUNT(filename)
      zei_fort( nLASTREC,,,0)
      append from &filename next M->how_many while &while_cond..and.zei_fort(nLASTREC,,,1) for &for_cond SDF

   case M->mode = 3 .and. M->how_many = 0
      nLASTREC:=FLINECOUNT(filename)
      zei_fort( nLASTREC,,,0)
      DO CASE
         CASE zREGSEP=chr(34) .OR. zREGSEP=chr(39)
              append from &filename while &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH ( { zDELIMITE, zREGSE } )
         CASE  zDELIMITE=","
              append from &filename while &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED
         CASE zDELIMITE="9"
              append from &filename while &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH TAB
         CASE zDELIMITE="|"
              append from &filename while &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH PIPE
         OTHERWISE     
              append from &filename while &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH &zDELIMITE
      ENDCASE
   case M->mode = 3 .and. M->how_many > 0
      nLASTREC:=FLINECOUNT(filename)
      zei_fort( nLASTREC,,,0)
      DO CASE
         CASE zREGSEP=chr(34) .OR. zREGSEP=chr(39)
              append from &filename next M->how_many while  &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH ( { zDELIMITE, zREGSE } )
         CASE  zDELIMITE=","
              append from &filename next M->how_many while  &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED
         CASE zDELIMITE="9"
              append from &filename next M->how_many while  &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED WITH TAB
         CASE zDELIMITE="|"
              append from &filename next M->how_many while  &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED WITH PIPE
         OTHERWISE     
              append from &filename next M->how_many while  &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED  WITH &zDELIMITE
      ENDCASE
      
      
      
//      append from &filename next M->how_many while  &while_cond. .and. zei_fort(nLASTREC,,,1) for &for_cond DELIMITED

   endcase

   if aseek( M->dbf, M->filename ) > 0
      select( aseek( M->dbf, M->filename ) )
      DBUREDE( filename,, ABERTURA )
   endif

   stat_msg( "Anexar completado" )
   done := .T.

endcase

return M->done

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function repl_title()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function repl_title

parameters sysparam

return box_title( M->sysparam, "Repor em " + ;
                  substr( M->cur_dbf, rat( hb_ps(), M->cur_dbf ) + 1 ) + ;
                  "..." )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function repl_field()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function repl_field

parameters sysparam

help_code := M->prime_help
return genfield( M->sysparam, .T. )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function with_exp()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function with_exp

parameters sysparam
private rval

help_code := M->prime_help
rval      := get_exp( M->sysparam, "COM    ", 4, "with_what" )

if M->sysparam = 4 .and. lastkey() = 13 .and. .not. empty( M->with_what )
   get_exp( 3, "COM    ", 4, "with_what" )
   to_ok()

endif

return M->rval

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function do_replace()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function do_replace
private done
M->done := .F.
do case
   case empty( M->field_mvar )
        error_msg( "Campo nao selecionado" )
   case empty( M->with_what )
        error_msg( "Reposicao expressao nao selecionada" )
   case type( M->with_what ) <> type( M->field_mvar ) .and. ;
                 ! ( type( M->field_mvar ) == "M" ) .and. ;
                 ! ( type( M->with_what ) == "UI" )
        error_msg( "Expressao de reposicao e campos sao de tipos diferentes" )
   case .not. empty( M->for_cond ) .and. type( M->for_cond ) <> "L"
        error_msg( "PARA condicao nao a uma expressao logica" )
   case .not. empty( M->while_cond ) .and. type( M->while_cond ) <> "L"
        error_msg( "ENQUANTO condicao nao a uma expressao lagica" )
   otherwise
      stat_msg( "Repondo Arquivo" )
      dbsetorder(0)
      if empty( M->for_cond )
         for_cond := ".T."
      endif
      if empty( M->while_cond )
         while_cond := ".T."
         if M->how_many = 0
            dbgotop()
         endif
      endif
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)      
      if M->how_many = 0
         while &while_cond. .and. !eof()
            if &for_cond
               netreclock()
               field->&field_mvar := &with_what
               dbunlock()
            endif
            zei_fort(nLASTREC,,,1)            
            dbskip()
         enddo
      else
         DBEval( {|| netgrvcam("field_mvar",&with_what) }, {|| &for_cond}, {|| &while_cond. .AND. zei_fort(nLASTREC,,,1)}, M->how_many,, .F. )
      endif
      stat_msg( "Reposicao completa" )
      dbsetorder(1)
      done := .T.
endcase
return M->done

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function for_exp()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function for_exp

parameters sysparam

help_code := 16
return get_exp( M->sysparam, "PARA   ", M->for_row, "for_cond" )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function while_exp()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function while_exp

parameters sysparam

help_code := 16
return get_exp( M->sysparam, "ENQUANTO", M->for_row + 1, "while_cond" )

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function scope_num()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function scope_num

parameters sysparam
local saveColor
private old_scope

help_code := 17
saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + M->for_row + 2, M->wl + 2 ;
           say "LIMITE " + pad( if( M->how_many = 0, "TUDO", ;
           "OUTRO" + ltrim( str( M->how_many ) ) ), 20 )

   if M->sysparam = 1
      @ M->wt + M->for_row + 2, M->wl + 9 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->wt + M->for_row + 2, M->wl + 9 ;
           say pad( if( M->how_many = 0, ;
           "TUDO", "OUTRO" + ltrim( str( M->how_many ) ) ), 20 )

case M->sysparam = 4

   if chr( M->keystroke ) $ "0123456789" + chr( 13 )

      if M->keystroke <> 13
         keyboard chr( M->keystroke )

      endif

      old_scope := M->how_many

      set key 5 to clear_gets
      set key 24 to clear_gets
      xkey_clear()

      setcolor( M->colorHilite )
      @ M->wt + M->for_row + 2, M->wl + 9 say pad( "OUTRO", 20 )

      setcolor( M->colorNorm )
      @ M->wt + M->for_row + 2, M->wl + 14 ;
              get M->how_many picture "99999999"
      READDBU()

      keystroke := lastkey()

      set key 5 to
      set key 24 to
      xkey_norm()

      if M->keystroke = 13
         to_ok()
         @ M->wt + M->for_row + 2, M->wl + 9 ;
                 say pad( if( M->how_many = 0, "TUDO", "OUTRO " + ;
                 ltrim( str( M->how_many ) ) ), 20 )

      else

         if menu_key() <> 0
            how_many := M->old_scope

         endif

         if M->keystroke <> 27 .and. .not. isdata( M->keystroke )
            keyboard chr( M->keystroke )

         endif
      endif

   else
      how_many := 0

   endif
endcase

setcolor( saveColor )
return 2

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function tog_sdf()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function tog_sdf

parameters sysparam
local saveColor

help_code := 11
saveColor := setcolor( M->colorNorm )

do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + 9, M->wl + 8 say " SDF "

   if M->mode = 2
       HB_dispbox( M->wt + 8, M->wl + 7, M->wt + 10,M->wl + 13,sframe)
     // @ M->wt + 8, M->wl + 7, M->wt + 10, M->wl + 13 box sframe

   endif

   if M->sysparam = 1
      @ M->wt + 9, M->wl + 9 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->wt + 9, M->wl + 8 say " SDF "

case M->sysparam = 4 .and. M->keystroke = 13

   if M->mode = 2
      HB_scroll(  M->wt + 8, M->wl + 7, M->wt + 10, M->wl + 13)
      //@ M->wt + 8, M->wl + 7, M->wt + 10, M->wl + 13 box "        "
      mode := 1

      cur_el  := 1
      rel_row := 0
      files   := "dbf_list"
      def_ext := ".dbf"
      filelist( 1 )

   else

      if M->mode = 3
         hb_scroll(M->wt + 8, M->wl + 16, M->wt + 10, M->wl + 28)

      else
         cur_el  := 1
         rel_row := 0
         files   := "txt_list"
         def_ext := ".txt"
         filelist( 1 )

      endif
      HB_dispbox( M->wt + 8, M->wl + 7, M->wt + 10, M->wl + 13,sframe)
      //@ M->wt + 8, M->wl + 7, M->wt + 10, M->wl + 13 box sframe
      mode := 2

   endif
endcase

setcolor( saveColor )
return 2

*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
*+    Function tog_delim()
*+
*+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
*+
function tog_delim

parameters sysparam
local saveColor

help_code := 11
saveColor := setcolor( M->colorNorm )
do case

case M->sysparam = 1 .or. M->sysparam = 3
   @ M->wt + 9, M->wl + 17 say " DELIMITADO "

   if M->mode = 3
      HB_dispbox( M->wt + 8, M->wl + 16, M->wt + 10, M->wl + 28,sframe)
      //@ M->wt + 8, M->wl + 16, M->wt + 10, M->wl + 28 box sframe

   endif

   if M->sysparam = 1
      @ M->wt + 9, M->wl + 17 say ""

   endif

case M->sysparam = 2
   setcolor( M->colorHilite )
   @ M->wt + 9, M->wl + 17 say " DELIMITADO "

case M->sysparam = 4 .and. M->keystroke = 13

   if M->mode = 3
      hb_scroll(M->wt + 8, M->wl + 16, M->wt + 10, M->wl + 28)
      mode := 1

      cur_el  := 1
      rel_row := 0
      files   := "dbf_list"
      def_ext := ".dbf"
      filelist( 1 )

   else

      if M->mode = 2
         hb_Scroll( M->wt + 8, M->wl + 7, M->wt + 10, M->wl + 13 )

      else
         cur_el  := 1
         rel_row := 0
         files   := "txt_list"
         def_ext := ".txt"
         filelist( 1 )

      endif
      HB_dispbox( M->wt + 8, M->wl + 16, M->wt + 10, M->wl + 28,sframe)
      //@ M->wt + 8, M->wl + 16, M->wt + 10, M->wl + 28 box sframe
      mode := 3

   endif
endcase

setcolor( saveColor )
return 2

funcTION copybkdbf(cFILE)
LOCAL aARQ
LOCAL XY
LOCAL cORI
LOCAL cBAK
aARQ:=directory(tiraext(cFILE)+".*") //pega todas dados.dbf dados.cdx dados.fpt .... --> dados.*
FOR XY:=1 TO LEN(aARQ)
    cORI := lower(aARQ[XY,1])
	cBAK := "copia_"+cORI
	if file( cBAK  )
	   stat_msg( "Apagando Backup Anterior "+cBAK )
	   DELETEFILE( cBAK )
	endif
	stat_msg( "Criando Backup "+cORI )
	if file( cORI)
	   filecopy(cORI,cBAK)
	ENDIF
NEXT XY   
retuRN


*+ EOF: DBUCOPY.PRG
