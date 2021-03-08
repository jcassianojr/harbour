*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => DISK52.PRG
*+
*+    Functions: Function HELP()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function HELP()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func HELP( programa, linha, variavel )  //F1- AJUDA AO USUARIO
LOCAL aAMBIENTE

if EMPTY(HELPARQ)
   ALERTX("HELP: Variavel HelpARQ Em Branco")
   retu .T.
endif

if programa = "MEMOEDIT" .or. programa = "HELP"
   retu .T.
endif
if type( "HELPDBF" ) = "C" .and. programa # "ERRO" .and. PROGRAMA # "ERRODOS"
   helppos := helpdbf
else
   helppos := programa
endif
helppos  := padr( helppos, 8 )
variavel := padr( variavel, 10 )

aAMBIENTE:=SALVAA()

if ! netuse(HELPARQ)
   restaa(aAMBIENTE)
   retu .T.
endif
dbgotop()
if ! dbseek( helppos + variavel )
   netrecapp()
   field->dbf   := helppos
   field->campo := variavel
   field->dado  := variavel
endif
if empty( ARQUIVO )
   HLP_DESC := DESCRICAO
else
   HLP_DESC := hb_memoread(HB_CWD()+ "MAN\" + ARQUIVO )
endif
HLP_DADO := DADO
if empty( HLP_DADO )
   HLP_DADO := "Nao Cadastrado"
endif
if empty( HLP_DESC )
   HLP_DESC := HLP_DADO
endif
dbclosearea()
MEMOVIEW( HLP_DESC, 02, 00, MAXROW() - 2, MAXCOL(),, HLP_DADO, "W/N,N/W,N,N,N/W" )
restaa(aAMBIENTE)
retu .T.




*+ EOF: DISK52.PRG
