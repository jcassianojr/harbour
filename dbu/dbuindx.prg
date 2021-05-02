*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUINDX.PRG
*+
*+    Functions: make_ntx()
*+               Function ntx_title()
*+               Function ntx_getfil()
*+               Function ntx_done()
*+               Function ntx_exp()
*+               Function ntx_tag()
*+               Function ntx_exist()
*+               Function do_index()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн



*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    make_ntx()
*+
*+    Called from ( dbu.prg      )   1 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function make_ntx

local saveColor
private filename
private files
private fi_disp
private okee_dokee
private cur_el
private rel_row
private def_ext
private bcur
private fi_done
private el
private cr
private ntx
private k_exp
private k_tag

cr  := "cr" + substr( "123456", M->cur_area, 1 )
el  := "el" + substr( "123456", M->cur_area, 1 )
ntx := "ntx" + substr( "123456", M->cur_area, 1 )

filename := &ntx[ &el[ 2 ] ]

saveColor := setcolor( M->color2 )
@ &cr[  2 ], column[ M->cur_area ] + 2 say pad( name( M->filename ), 8 )

select( M->cur_area )
set filter to
close index
need_filtr := .T.
need_ntx   := .T.
not_target( select(), .F. )
select( M->cur_area )

cur_el  := 1
rel_row := 0
files   := "ntx_list"
def_ext := XEXT()

if .not. empty( M->filename )
   k_exp := ntx_key( M->filename )
   bcur  := 4
else
   k_exp := ""
   bcur  := 2
endif
k_tag := space( 40 )

boxarray := {}

aadd( boxarray, "ntx_title(sysparam)" )
aadd( boxarray, "ntx_getfil(sysparam)" )
aadd( boxarray, "ntx_exp(sysparam)" )
if tipodbf = 2 .or. tipodbf = 4 //.or. tipodbf = 6
   aadd( boxarray, "ntx_tag(sysparam)" )
endif
aadd( boxarray, "ok_button(sysparam)" )
aadd( boxarray, "can_button(sysparam)" )
aadd( boxarray, "filelist(sysparam)" )

fi_disp    := "ntx_exist()"
fi_done    := "ntx_done()"
okee_dokee := "do_index()"

if multibox( 13, 17, 9, M->bcur, M->boxarray ) <> 0 .and. ;
             aseek( &ntx, M->filename ) = 0

   if M->n_files < 14 .or. .not. empty( &ntx[ &el[ 2 ] ] )

      if empty( &ntx[ &el[ 2 ] ] )
         n_files := M->n_files + 1

      endif

      &ntx[ &el[ 2 ] ] = M->filename

   endif
endif

saveColor := setcolor( M->color1 )
@ &cr[  2 ], column[ M->cur_area ] + 2 say pad( name( &ntx[ &el[ 2 ] ] ), 8 )

setcolor( saveColor )
return

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_title()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_title

parameters sysparam

return box_title( M->sysparam, "Indice " + ;
                  substr( M->cur_dbf, rat( hb_ps(), M->cur_dbf ) + 1 ) + ;
                  " para..." )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_getfil()
*+
*+    Called from ( dbuindx.prg  )   1 - function ntx_exist()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_getfil

parameters sysparam

return getfile( M->sysparam, 4 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_done()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_done

private done_ok

done_ok := .not. empty( M->filename )

if M->done_ok

   if file( M->filename ) .and. empty( M->k_exp )
      k_exp := ntx_key( M->filename )
      ntx_exp( 3 )

   endif

   if empty( M->k_exp )
      keyboard chr( 24 )

   else
      to_ok()

   endif
endif

return M->done_ok

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_exp()
*+
*+    Called from ( dbuindx.prg  )   1 - function ntx_done()
*+                                   1 - function ntx_exist()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_exp

parameters sysparam

return get_exp( M->sysparam, "CHAVE  ", 5, "k_exp" )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_tag()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_tag

parameters sysparam
return get_exp( M->sysparam, "TAG    ", 6, "k_tag" )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ntx_exist()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ntx_exist

if empty( M->k_exp )
   k_exp := ntx_key( M->filename )

endif

ntx_getfil( 3 )
ntx_exp( 3 )

return 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function do_index()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function do_index

private done
private n_dup
private new_el
private add_name

n_dup := dup_ntx( M->filename )

do case

case empty( M->filename )
   error_msg( "Arquivo de indice no selecionado" )
   done := .F.

case M->n_dup > 0 .and. M->n_dup <> select()
   error_msg( "Indice em uso em outro arquivo" )
   done := .F.

case empty( M->k_exp )
   error_msg( "Chave de para indexao no fornecida" )
   done := .F.
case ( TIPODBF = 2 .or. TIPODBF = 4  ) .and. empty( M->K_TAG )   //OR TIPODBF=6
   error_msg( "Nome da TAG indexao no fornecida" )
   done := .F.

case .not. type( M->k_exp ) $ "CND"
   error_msg( "Expresso chave no e v lida" )
   done := .F.

otherwise
   stat_msg( "Criando Arquivo de Indice" )
   mds("")
   add_name := .not. HB_FILEEXISTS( name( M->filename ) + XEXT() )
   
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   if tipodbf = 1 .or. tipodbf = 3 // .or. tipodbf = 5
      if left( K_EXP, 1 ) # "<"
         index on &k_exp to &filename eval zei_fort(nLASTREC,,,1)
      else
         K_EXP := substr( K_EXP, 2 )
         index on &k_exp to &filename eval zei_fort(nLASTREC,,,1)
      endif
   else
      if left( K_EXP, 1 ) # "<"
         index on &k_exp tag &K_TAG to &filename eval zei_fort(nLASTREC,,,1)
      else
         K_EXP := substr( K_EXP, 2 )
         index on &k_exp tag &K_TAG to &filename eval zei_fort(nLASTREC,,,1)
      endif
   endif
   close index

   if at( lower(XEXT()), lower(M->filename) ) = len( M->filename ) - 3 .and. ;
          HB_FILEEXISTS( name( M->filename ) + XEXT() ) .and. M->add_name

      new_el := afull( M->ntx_list ) + 1

      if M->new_el <= len( M->ntx_list )
         ntx_list[ M->new_el ] = M->filename
         array_sort( M->ntx_list )

      endif
   endif

   stat_msg( "Arquivo Indexado" )
   done := .T.

endcase

return M->done



*+ EOF: DBUINDX.PRG
