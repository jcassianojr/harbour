*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_18.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:15 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

CABE2( 'FOPTO_18 - Criando Arquivo TXT Com Base Arquivo Reserva' )

ntipo := PEGRELOGIO()

cDD := TARQREL( nTIPO, .F. )

if ! REDEFILE( cDD, "DBF", .T. )
   retu .F.
endif

TIPC:=pegarqcon( nTIPO, "PRO" )

FO21CRI(cDD,"FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )

if ! NETUSE(cDD) 
   retu .F.
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
cTXT += ".TXT"
if TIPC = "S"
   COPY to &cTXT. SDF while zei_fort(nLASTREC,,,1)
endif
if TIPC = "D"
   COPY to &cTXT. DELI while zei_fort(nLASTREC,,,1)
endif
dbcloseall()

*+ EOF: FOPTO_18.PRG
