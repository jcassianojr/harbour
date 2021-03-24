*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\RFE\FOLHARFE.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-2-2003 at  8:34 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT
REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

#INCLUDE "INKEY.CH"

function main
PARA ZUSER,cSENHA

MVINFOConfTela("Folha rescisao e ferias")


netregosok()

HB_IDLESTATE()
Set( _SET_CODEPAGE, "PTISO")   
HB_LANGSELECT('PT') 
rddsetdefault( "DBFCDX" )
Set( _SET_OPTIMIZE, .t.)
Set( _SET_DELETED, .t.)
Set( _SET_SOFTSEEK, .t.)
__SetCentury( .t. )
Set( _SET_EPOCH, year( date() ) - 60 )
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
SetCursor(.t.)

//Set( _SET_SCOREBOARD, .f. )
//Set( _SET_TYPEAHEAD, 50 )
//Set( _SET_WRAP, .t. )
//Set( _SET_EXACT, .f. )
//Set( _SET_CONFIRM, .F.) //checar alguns .t.

SETMODE(25,80)
cls

Set( _SET_CONSOLE, .F. )
SET TALK OFF ''checar nao tem ainda na std.ch changelog.txt
SET SAFETY OFF ''checar nao tem ainda na std.ch changelog.txt


ACENTUA=.T.
SetKey( 39, {|| AC_AGUDO() } )
SetKey( 94, {|| AC_CIRC() } )
SetKey( 96, {|| AC_CRASE() } )
SetKey( 126, {|| AC_TIL() } )
SetKey( K_ALT_S, {|| ACENTUA := ! ACENTUA, ALERT( "Acentuacao: " +if(acentua,"ligada","desligada") )} )   //usar {|| ACENTUA := ! ACENTUA, mds(if(acentua,"ligado","desligado")) }
SetKey( K_F12  , {|| __SetCentury( ! __SetCentury() ) , alert("Seculos em Datas: " +if(__SetCentury(),"ligado","desligado")) } ) //usar {|| __SetCentury( ! __SetCentury() ) , mds(if(__SetCentury(),"ligado","desligado")) }

SetKey( K_F1, {|| HELP() } )  //checar alguns nao tem help

SetKey( K_F2, {|| TELE() } )
SetKey( K_F3, {|| NOTEP() } )
SetKey( K_F4, {|| AGEN() } )
SetKey( K_F5, {|| TECLAS() } )
SetKey( K_F8, {|| hb_run("calc") } )
SetKey( K_F10, {|| MUDADATA() } )


//RELOGIO()

HELPARQ := "FOLREL"                     //nome da dbf do help
READVAR := ""

NREMP    := 0
DXDIA    := date()
ZDIRE:="ERRO ZDIRE"
ZDIRN:="ERRO ZDIRN"
ZCODMANA5=1
ZERRO:=""
zNERRO:=0


//
cRDDEXT="CDX"

IF ! NETUSE("CONFIGU",,,,,.F.,) //BREDE("CONFIGU",1)
   RETU
ENDIF
TEMPO    := TEMP
IM1      := IMPRE
DRI      := DRIVE
ZMOEDA01 := alltrim( MOEDA01 )
ZMOEDA02 := alltrim( MOEDA02 )
ZMOEDA03 := alltrim( MOEDA03 )
ZMOEDA04 := alltrim( MOEDA04 )
ZMOEDA05 := alltrim( MOEDA05 )
ZMOEDA06 := alltrim( MOEDA06 )
dbcloseall()

//Inicializa o Mouse Clipper 5.3c
set( _SET_EVENTMASK, HB_INKEY_ALL )
lMOUSE       := mpresent()
MOUSE_X      := 0
MOUSE_Y      := 0
MOUSE_B      := 0
aMENUPROMPTS := {}
if lMOUSE
   cls
   msetbounds()
   msetcursor( .T. )
endif

deletaarq("TEMP*.*")
deletaarq("*.tmp")
deletaarq("*.LOG")

//Variaveis Controle Impressora,Video Arquivo
cARQSPO:=""
nTIPSPO:=0
cIMPCOM:=CHR(15)
cIMPEXP:=CHR(18)
cIMPTIT:=CHR(14)
cIMPNEG:=CHR(27)+CHR(69)
cIMPNER:=CHR(27)+CHR(70)
cIMPORI:=""
lIMPEMAIL:=.F.


ZUSER := padr( NNETWHOAMI(), 10 )


INFOR( "FIRMA", "NRCLIEN", "FIRMA" ,.T.)
INFOR( "MUSER", "USUARIO", "MUSER" ,.T.)
INFOR( "FOLREL", "DBF+CAMPO", "FOLREL" ,.T.)
INFOR( "FIRMA", "NRCLIEN", "FIRMA" ,.T.)
INFOR("RELCONTA","CODIGO","RELCONTA",.T.)
INFOR("FORFENTX","DBF+NTX+STR(SEQ,3)","FORFENTX",.T.)

MUDADATA()
CONSEN := .T.
while .T.
   LOGOTIPO( "MODULO RESCISAO E FERIAS" )
   while NREMP = 0
      NREMP=ESCOLHEXI( "FIRMA", "NREMP" , "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN")
      if ! netuse("firma")
         LOOP
      endif
      dbgotop()
      IF dbseek( NREMP )
         MSG2     := alltrim( RAZAO )
         MSG3     := SENHA
         MESHORA  := if( HORASMES > 220, HORASMES, 220 )
         RECOIRRF := PAGAR
         ZCODMANA5 = CODMANA5
      else
         MDT( 'EMPRESA NAO CADASTRADA' )
         NREMP := 0
      endif
      dbcloseall()
   enddo
   ANOWORK := substr( strzero( year( DXDIA ), 4 ), 3, 2 )
   ANOUSO  := year( DXDIA )


   //Verifica o ano Se nao e'padrao 00 (ano atual)
   if ! pegfolpat()
      loop
   endif

   //Senha
   NRSEN:=pegfolsen()

   //competencia
   OP      := pegfolmes()
   MES     := OP
   MESTRAB := MES
   MMES    := MMES( OP )
   EMP    := strzero( NREMP, 4 )
   ARQMES := strzero( MES, 2 )
   if NRSEN <> 'DiReT'
      PES := 'FO_PES'
      FOL := 'FP' + EMP + ARQMES
   else
      PES := 'FO_DIR'
      FOL := 'SO' + EMP + ARQMES
   endif
   @  7,  0 clear
   if ! file(ZDIRE+ FOL + ".DBF" )
      ALERTX( "Falta Arquivo de Folha do Mes" )
      NREMP := 0
      loop
   endif
   MDS( 'Aguarde organizacao dos arquivos' )
   if file( ZDIRE + FOL + ".DBF" )
      INFOR( ZDIRE + FOL, "CONTROLE", ZDIRE + FOL, .T. )
   endif
   if file( ZDIRE + "FO_DIR.DBF" )
      INFOR( ZDIRE + "FO_DIR", "NUMERO", ZDIRE + "FO_DIR", .T. )
   endif
   if file( ZDIRE + "FO_PES.DBF" )
      INFOR( ZDIRE + "FO_PES", "NUMERO", ZDIRE + "FO_PES", .T. )
   endif
   FORESM()
   if !MDG( 'DESEJA CONTINUAR NA FOLHA ' )
      FIM( "" )
   endif
   if MDG( 'DESEJA MUDAR A EMPRESA  ??' )
      CONSEN := .T.
      NREMP  := 0
   endif
enddo

*+ EOF: FOLHARFE.PRG
