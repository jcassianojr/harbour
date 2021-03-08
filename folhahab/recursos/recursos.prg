*:*****************************************************************************
*:
*:   RECURSOS.PRG: Programa Principal
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:42
*:
*:*****************************************************************************


#INCLUDE "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT
REQUEST HB_LANG_PT
REQUEST DBFCDX

#INCLUDE "INKEY.CH"


function main

MVINFOConfTela("Recursos")

HB_LANGSELECT('PT')       
HB_IDLESTATE()
netregosok()


SET DATE BRITI
SET SCOR OFF
SET TALK OFF
SET CONF OFF
SET DELE ON
SET SOFT ON

PUBLIC BUSCA

rddsetdefault( "DBFCDX" )
cRDDEXT="CDX"
SET OPTIMIZE ON

PATHX:=HB_CWD() 
ZDIRE:=HB_CWD()
ZDIRN:=HB_CWD()
SET PATH TO &PATHX
ZDATA=DATE()
DXDIA=DATE()
ANOUSO  := year( DXDIA )
ZCODMANA5=1
ZERRO:=""
zNERRO:=0

HELPARQ="TOOLHELP"
READVAR=""


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

set( _SET_EVENTMASK, HB_INKEY_ALL)
lMOUSE:=.F.
MOUSE_X      := 0
MOUSE_Y      := 0
MOUSE_B      := 0
aMENUPROMPTS := {}


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

ZDIRE:="ERRO"
ZUSER:=PADR(NNETWHOAMI(),10)


INFOR("RECURNTX","DBF+NTX+STR(SEQ,3)","RECURNTX",.T.)

RECUMENU()                                                    && CHAMA O MENU
retu nil

function corrigeendereco
return nil

function m_da
return nil

*: FIM: RECURSOS.PRG
