// +--------------------------------------------------------------------
// +
// +    Programa  : recursos.prg Programa Principal
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 2-Jan-2025 as  7:33 pm
// +
// +--------------------------------------------------------------------
// +



#include "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT
REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

#include "INKEY.CH"
#include "tshead.ch"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function main()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION main

   PUBLIC BUSCA

   MVINFOConfTela( "Recursos - Modulo de Utilidades" )


//   ALERT(ProfileString("FOLHA.INI","MPOINT","CONECCAO",""))

   hb_langSelect( 'PT' )
   hb_idleState()
   netregosok()


   hb_idleState()
   Set( _SET_CODEPAGE, "PTISO" )
   hb_langSelect( 'PT' )
   rddSetDefault( "DBFCDX" )
   Set( _SET_OPTIMIZE, .T. )
   Set( _SET_DELETED, .T. )
   Set( _SET_SOFTSEEK, .T. )
   __SetCentury( .T. )
   Set( _SET_EPOCH, Year( Date() ) - 60 )
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
   SetCursor( .T. )

   Set( _SET_SCOREBOARD, .F. )
// Set( _SET_TYPEAHEAD, 50 )
// Set( _SET_WRAP, .t. )
// Set( _SET_EXACT, .f. )
   Set( _SET_CONFIRM, .F. )   // checar alguns .t.

   SET TALK OFF  // ''checar nao tem ainda na std.ch changelog.txt
   SET SAFETY OFF  // ''checar nao tem ainda na std.ch changelog.txt

   memvar->cRDDEXT := "CDX"

   memvar->PATHX := hb_cwd()
   memvar->ZDIRE := hb_cwd()
   memvar->ZDIRN := hb_cwd()

   Set( _SET_PATH, memvar->PATHX )
   memvar->ZDATA     := Date()
   memvar->DXDIA     := Date()
   memvar->ANOUSO    := Year( memvar->DXDIA )
   memvar->ZCODMANA5 := 1
   memvar->ZERRO     := ""
   memvar->zNERRO    := 0

   memvar->HELPARQ := "TOOLHELP"
   memvar->READVAR := ""


   memvar->ACENTUA := .T.
   SetKey( 39, {|| AC_AGUDO() } )
   SetKey( 94, {|| AC_CIRC() } )
   SetKey( 96, {|| AC_CRASE() } )
   SetKey( 126, {|| AC_TIL() } )
   SetKey( K_ALT_S, {|| memvar->ACENTUA := !memvar->ACENTUA, Alert( "Acentuacao: " + if( memvar->acentua, "ligada", "desligada" ) ) } )   // usar {|| ACENTUA := ! ACENTUA, mds(if(acentua,"ligado","desligado")) }
   SetKey( K_F12, {|| __SetCentury( !__SetCentury() ), Alert( "Seculos em Datas: " + if( __SetCentury(), "ligado", "desligado" ) ) } )  // usar {|| __SetCentury( ! __SetCentury() ) , mds(if(__SetCentury(),"ligado","desligado")) }

   SetKey( K_F1, {|| HELP() } )  // checar alguns nao tem help

   SetKey( K_F2, {|| TELE() } )
   SetKey( K_F3, {|| NOTEP() } )
   SetKey( K_F4, {|| AGEN() } )
   SetKey( K_F5, {|| TECLAS() } )
   SetKey( K_F8, {|| hb_run( "calc" ) } )
   SetKey( K_F10, {|| MUDADATA() } )

// RELOGIO()

   Set( _SET_EVENTMASK, HB_INKEY_ALL )
   memvar->lMOUSE       := .F.
   memvar->MOUSE_X      := 0
   memvar->MOUSE_Y      := 0
   memvar->MOUSE_B      := 0
   memvar->aMENUPROMPTS := {}


   deletaarq( "TEMP*.*" )
   deletaarq( "*.tmp" )
   deletaarq( "*.LOG" )


// Variaveis Controle Impressora,Video Arquivo
   memvar->cARQSPO   := ""
   memvar->nTIPSPO   := 0
   memvar->cIMPCOM   := Chr( 15 )
   memvar->cIMPEXP   := Chr( 18 )
   memvar->cIMPTIT   := Chr( 14 )
   memvar->cIMPNEG   := Chr( 27 ) + Chr( 69 )
   memvar->cIMPNER   := Chr( 27 ) + Chr( 70 )
   memvar->cIMPORI   := ""
   memvar->lIMPEMAIL := .F.

   memvar->ZDIRE := "ERRO"
   memvar->ZUSER := PadR( NNETWHOAMI(), 10 )


   INFOR( "RECURNTX", "DBF+NTX+STR(SEQ,3)", "RECURNTX", .T. )



   RECUMENU()  // CHAMA O MENU
   RETU NIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function corrigeendereco()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION corrigeendereco


   RETURN NIL


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_da()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_da
   RETURN NIL

// + EOF: recursos.prg
// +
