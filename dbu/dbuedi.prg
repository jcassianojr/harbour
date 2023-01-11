*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    DBUEDI.PRG
*+
*+    Functions: Function EDITXT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+
function EDITXT
LOCAL NOMEARQ
if ! lEDITXT
   ALERTX( 'Ja esta sendo editado um texto' )
   return .f.
endif
nomearq := win_GetOpenFileName(, "Ler conteudo", HB_CWD(), "txt", "*.txt", 1 )
if ! HB_FILEEXISTS( nomearq)
   ALERTX( 'Nao Encontrei Este Arquivo' )
   return .F.
endif
lEDITXT := .F.
EDItarq( nomearq )
lEDITXT := .T.
return .t.
