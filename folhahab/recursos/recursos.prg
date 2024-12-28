
// :*****************************************************************************
// :
// :   RECURSOS.PRG: Programa Principal
// :      Linguagem: Clipper 5.x
// :        Sistema: RECURSOS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/28/94     11:42
// :
// :*****************************************************************************


#INCLUDE "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT
REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

#INCLUDE "INKEY.CH"
#include "tshead.ch"




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function main()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function main

PUBLIC BUSCA
MVINFOConfTela("Recursos - Modulo de Utilidades")

HB_LANGSELECT('PT')
HB_IDLESTATE()
netregosok()


HB_IDLESTATE()
Set(_SET_CODEPAGE,"PTISO")
HB_LANGSELECT('PT')
rddsetdefault("DBFCDX")
Set(_SET_OPTIMIZE,.t.)
Set(_SET_DELETED,.t.)
Set(_SET_SOFTSEEK,.t.)
__SetCentury(.t.)
Set(_SET_EPOCH,year(date()) - 60)
Set(_SET_DATEFORMAT,"dd/mm/yyyy")
SetCursor(.t.)

Set(_SET_SCOREBOARD,.f.)
//Set( _SET_TYPEAHEAD, 50 )
//Set( _SET_WRAP, .t. )
//Set( _SET_EXACT, .f. )
Set(_SET_CONFIRM,.F.)   //checar alguns .t.

SET TALK OFF  //''checar nao tem ainda na std.ch changelog.txt
SET SAFETY OFF  //''checar nao tem ainda na std.ch changelog.txt

memvar->cRDDEXT := "CDX"

memvar->PATHX := HB_CWD()
memvar->ZDIRE := HB_CWD()
memvar->ZDIRN := HB_CWD()

Set(_SET_PATH,memvar->PATHX)
memvar->ZDATA     := DATE()
memvar->DXDIA     := DATE()
memvar->ANOUSO    := year(memvar->DXDIA)
memvar->ZCODMANA5 := 1
memvar->ZERRO     := ""
memvar->zNERRO    := 0

memvar->HELPARQ := "TOOLHELP"
memvar->READVAR := ""


memvar->ACENTUA := .T.
SetKey(39,{|| AC_AGUDO()})
SetKey(94,{|| AC_CIRC()})
SetKey(96,{|| AC_CRASE()})
SetKey(126,{|| AC_TIL()})
SetKey(K_ALT_S,{|| memvar->ACENTUA := !memvar->ACENTUA,ALERT("Acentuacao: "+if(memvar->acentua,"ligada","desligada"))})   //usar {|| ACENTUA := ! ACENTUA, mds(if(acentua,"ligado","desligado")) }
SetKey(K_F12,{|| __SetCentury(!__SetCentury()),alert("Seculos em Datas: "+if(__SetCentury(),"ligado","desligado"))})  //usar {|| __SetCentury( ! __SetCentury() ) , mds(if(__SetCentury(),"ligado","desligado")) }

SetKey(K_F1,{|| HELP()})  //checar alguns nao tem help

SetKey(K_F2,{|| TELE()})
SetKey(K_F3,{|| NOTEP()})
SetKey(K_F4,{|| AGEN()})
SetKey(K_F5,{|| TECLAS()})
SetKey(K_F8,{|| hb_run("calc")})
SetKey(K_F10,{|| MUDADATA()})

//RELOGIO()

set(_SET_EVENTMASK,HB_INKEY_ALL)
memvar->lMOUSE       := .F.
memvar->MOUSE_X      := 0
memvar->MOUSE_Y      := 0
memvar->MOUSE_B      := 0
memvar->aMENUPROMPTS := {}


deletaarq("TEMP*.*")
deletaarq("*.tmp")
deletaarq("*.LOG")


//Variaveis Controle Impressora,Video Arquivo
memvar->cARQSPO   := ""
memvar->nTIPSPO   := 0
memvar->cIMPCOM   := CHR(15)
memvar->cIMPEXP   := CHR(18)
memvar->cIMPTIT   := CHR(14)
memvar->cIMPNEG   := CHR(27)+CHR(69)
memvar->cIMPNER   := CHR(27)+CHR(70)
memvar->cIMPORI   := ""
memvar->lIMPEMAIL := .F.

memvar->ZDIRE := "ERRO"
memvar->ZUSER := PADR(NNETWHOAMI(),10)


INFOR("RECURNTX","DBF+NTX+STR(SEQ,3)","RECURNTX",.T.)

RECUMENU()  // CHAMA O MENU
retu nil


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function corrigeendereco()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function corrigeendereco

return nil


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_da()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_da

return nil

// : FIM: RECURSOS.PRG

*+ FIM recursos.prg
*+
