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
HB_LANGSELECT('PT')       
HB_IDLESTATE()


SET DATE BRITI
SET SCORE OFF
SET TALK OFF
SET DELE ON
SET CONF OFF
SET SOFT ON


SET KEY  39 TO AC_AGUDO          &&SET-UP ACENTUACAO
SET KEY  94 TO AC_CIRC
SET KEY  96 TO AC_CRASE
SET KEY 126 TO AC_TIL
SET KEY K_ALT_S TO LIGA_ACENTO   &&A TECLA ALT_S LIGA E DESLIGA A ACENTUACAO

ACENTUA=.T.
SET KEY K_F1  TO HELP        // AJUDA ON LINE
SET KEY K_F2  TO TELE        // AGENDA TELEFONICA
SET KEY K_F3  TO NOTEP       // BLOCO DE ANOTACOES
SET KEY K_F4  TO AGEN        // AGENDA
SET KEY K_F5  TO TECLAS      // TECLADO
//SET KEY K_F6  TO GRMEMO      // MEMORANDO
SET KEY K_F7  TO CALEND      // CALENDARIO
SET KEY K_F8  TO CALC        // CALCULADORA
SET KEY K_F9  TO RELOGIO     // RELOGIO
SET KEY K_F10 TO MUDADATA    // ALTERACAO DE DATA OPERACIONAL
SET KEY K_F12 TO SECULO

SET EPOCH TO YEAR(DATE())-60 //Flutuante

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


//
RDDSETDEFAULT("DBFCDX")
SET OPTIMIZE ON
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
