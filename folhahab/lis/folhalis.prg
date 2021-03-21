*:*****************************************************************************
*:
*:
*:   FOLHALIS.PRG: Nome do Programa
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/26/94      8:00
*:
*:*****************************************************************************

REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX
REQUEST HB_GT_WVG_DEFAULT

#INCLUDE "INKEY.CH"
#INCLUDE "HBGTINFO.CH"


function main
PARA ZUSER,cSENHA


MVINFOConfTela("Modulo Folha Anuais")

/*
hb_gtInfo( HB_GTI_ICONFILE, "folhapto.ico" )
hb_gtInfo( HB_GTI_WINTITLE, "folhapto - WVG" )
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
Set( _SET_SCOREBOARD, .f. )
Set( _SET_TYPEAHEAD, 50 )
Set( _SET_WRAP, .t. )
Set( _SET_EXACT, .f. )
SetCursor(.t.)
Set( _SET_CONFIRM, .t.)


SET TALK OFF ''checar nao tem ainda na std.ch changelog.txt


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

RELOGIO()

HELPARQ="FOLREL"                         &&nome da dbf do help
READVAR=""
ZCODMANA5=1
ZERRO:=""
zNERRO:=0


//Inicializa o Mouse Clipper 5.3c
SET ( _SET_EVENTMASK, HB_INKEY_ALL )
lMOUSE:=MPRESENT()
MOUSE_X:=0
MOUSE_Y:=0
MOUSE_B:=0
aMENUPROMPTS:={}
IF lMOUSE
   CLS
   MSETBOUNDS()
   MSETCURSOR ( .T. )
ENDIF

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


ZDIRE:="ERRO ZDIRE"
ZDIRN:="ERRO ZDIRN"
PATHX=HB_CWD() 
ZUSER:=PADR(NNETWHOAMI(),10)

//OP_SENHA=' '
NREMP=0
DXDIA=DATE()
ZDATA:=DATE()
ANO=YEAR(DXDIA)
CONSEN=.T.

cRDDEXT="CDX"

IF ! NETUSE("CONFIGU",,,,,.F.,)
   RETU
ENDIF
TEMPO=TEMP
IM1=IMPRE
DBCLOSEALL()


INFOR( "FIRMA", "NRCLIEN", "FIRMA" ,.T.)
INFOR( "MUSER", "USUARIO", "MUSER" ,.T.)
INFOR( "FOLREL", "DBF+CAMPO", "FOLREL" ,.T.)
INFOR("RELCONTA","CODIGO","RELCONTA",.T.)
INFOR("FOLISNTX","DBF+NTX+STR(SEQ,3)","FOLISNTX",.T.)


MUDADATA()
WHILE .T.
   LOGOTIPO()
   WHILE NREMP = 0
      NREMP=ESCOLHEXI( "FIRMA", "NREMP" , "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN")
      IF ! NETUSE("FIRMA")
         LOOP
      ENDIF
      DBGOTOP()
      IF DBSEEK(NREMP)
         MSG2=ALLTRIM(RAZAO)
         MSG3=SENHA
         MESHORA=IF(HORASMES>220,HORASMES,220)
         RECOIRRF=PAGAR
         zCGC     := CGC         
         ZCODMANA5 = CODMANA5
      ELSE
         MDT('EMPRESA NAO CADASTRADA')
         NREMP = 0
      ENDIF
      DBCLOSEALL()
   ENDDO
   ANOWORK=SUBSTR(STRZERO(YEAR(DXDIA),4),3,2)
   ANOUSO  := year( DXDIA )

   //path   
   if ! pegfolpat()
      loop
   endif

   //senha
   NRSEN:=pegfolsen()

   //competencia
   OP:=pegfolmes()
   MES=OP
   MESTRAB=OP
   MMES=MMES(OP)
   EMP    = STRZERO(NREMP,4)
   ARQMES = STRZERO(MES,2)
   IF NRSEN <> 'DiReT'
      PES = 'FO_PES'
      RES = 'FO_RES'
      FOL = 'FP'+EMP+ARQMES
      F13 = 'FO_FP13'
   ELSE
      PES = 'FO_DIR'
      RES = 'FO_RDD'
      FOL = 'SO'+EMP+ARQMES
      F13 = 'FO_SO13'
   ENDIF
   IF ! FILE(ZDIRE+FOL+".DBF")
      ALERTX("Falta Arquivo de Folha do Mes")
      NREMP=0
      LOOP
   ENDIF
   MDS('Aguarde organiza‡„o dos arquivos')
   IF FILE(ZDIRE+FOL+".DBF")
      INFOR(ZDIRE+FOL,"CONTROLE",ZDIRE+FOL,.T.)
   ENDIF
   IF FILE(ZDIRE+"FO_DIR.DBF")
      INFOR(ZDIRE+"FO_DIR","NUMERO",ZDIRE+"FO_DIR",.T.)
   ENDIF
   IF FILE(ZDIRE+"FO_PES.DBF")
      INFOR(ZDIRE+"FO_PES","NUMERO",ZDIRE+"FO_PES",.T.)
   ENDIF
   FOLISM()
   IF ! MDG('DESEJA CONTINUAR no m¢dulo listas anuais')
      FIM("")
   ENDIF
   IF MDG('DESEJA MUDAR A EMPRESA')
      CONSEN=.T.
      NREMP=0
   ENDIF
ENDDO
*: FIM: FOLHALIS.PRG
