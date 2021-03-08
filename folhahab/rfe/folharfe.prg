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
REQUEST DBFCDX

#INCLUDE "INKEY.CH"

function main
PARA ZUSER,cSENHA

MVINFOConfTela("Folha rescisao e ferias")

/*
//hb_gtInfo( HB_GTI_ICONFILE, "aplicativo.ico" )
hb_gtInfo( HB_GTI_WINTITLE, "aplicativo - WVG" )
HB_GtInfo( HB_GTI_FONTNAME, "Lucida Console" ) // fonte
Hb_GtInfo( HB_GTI_SELECTCOPY,.T.)
Hb_GtInfo( HB_GTI_RESIZABLE, .T. )
HB_GtInfo( HB_GTI_ISFULLSCREEN, .F. ) //.t. nao aparece _x barra de titulo
HB_GTINFO( HB_GTI_CLOSABLE, .T. )
HB_GtInfo( HB_GTI_MAXIMIZED, .T. ) //starts in Maximized Window
hb_gtInfo( HB_GTI_ALTENTER, .T. )   // allow <Alt-Enter> for full screen
hb_gtInfo( HB_GTI_CLOSEMODE, 1 )    // 1 - sends HB_K_CLOSE on Window x-Close
*/

netregosok()
HB_LANGSELECT('PT')       
HB_IDLESTATE()

clear
set soft on
set cons OFF
SET TALK OFF
SET SAFE OFF
set date BRIT
set cons OFF
set dele on

set key 39 to AC_AGUDO                  //SET-UP ACENTUACAO
set key 94 to AC_CIRC
set key 96 to AC_CRASE
set key 126 to AC_TIL
set key K_ALT_S to LIGA_ACENTO          //A TECLA ALT_S LIGA E DESLIGA A ACENTUACAO

ACENTUA := .T.
set key K_F1 to HELP                    // AJUDA ON LINE
set key K_F2 to TELE                    // AGENDA TELEFONICA
set key K_F3 to NOTEP                   // BLOCO DE ANOTACOES
set key K_F4 to AGEN                    // AGENDA
set key K_F5 to TECLAS                  // TECLADO
//set key K_F6 to GRMEMO                  // MEMORANDO
set key K_F7 to CALEND                  // CALENDARIO
set key K_F8 to CALC                    // CALCULADORA
set key K_F9 to RELOGIO                 // RELOGIO
set key K_F10 to MUDADATA               // ALTERACAO DE DATA OPERACIONAL
set key K_F11 to SECULO

set epoch to year( date() ) - 60        //Flutuante


RELOGIO()

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
RDDSETDEFAULT("DBFCDX")
cRDDEXT="CDX"
SET OPTIMIZE ON


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
