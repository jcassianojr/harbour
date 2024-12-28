// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folharfe.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
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

   PARA ZUSER, cSENHA

   MVINFOConfTela( "Folha rescisao e ferias" )


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

// Set( _SET_SCOREBOARD, .f. )
// Set( _SET_TYPEAHEAD, 50 )
// Set( _SET_WRAP, .t. )
// Set( _SET_EXACT, .f. )
// Set( _SET_CONFIRM, .F.) //checar alguns .t.

   SetMode( 25, 80 )
   cls

   Set( _SET_CONSOLE, .F. )
   SET TALK OFF '' checar nao tem ainda na std.ch changelog.txt
   SET SAFETY OFF '' checar nao tem ainda na std.ch changelog.txt


   ACENTUA := .T.
   SetKey( 39, {|| AC_AGUDO() } )
   SetKey( 94, {|| AC_CIRC() } )
   SetKey( 96, {|| AC_CRASE() } )
   SetKey( 126, {|| AC_TIL() } )
   SetKey( K_ALT_S, {|| ACENTUA := !ACENTUA, Alert( "Acentuacao: " + if( acentua, "ligada", "desligada" ) ) } )   // usar {|| ACENTUA := ! ACENTUA, mds(if(acentua,"ligado","desligado")) }
   SetKey( K_F12, {|| __SetCentury( !__SetCentury() ), Alert( "Seculos em Datas: " + if( __SetCentury(), "ligado", "desligado" ) ) } )  // usar {|| __SetCentury( ! __SetCentury() ) , mds(if(__SetCentury(),"ligado","desligado")) }

   SetKey( K_F1, {|| HELP() } )  // checar alguns nao tem help

   SetKey( K_F2, {|| TELE() } )
   SetKey( K_F3, {|| NOTEP() } )
   SetKey( K_F4, {|| AGEN() } )
   SetKey( K_F5, {|| TECLAS() } )
   SetKey( K_F8, {|| hb_run( "calc" ) } )
   SetKey( K_F10, {|| MUDADATA() } )


// RELOGIO()

   HELPARQ := "FOLREL"   // nome da dbf do help
   READVAR := ""

   NREMP     := 0
   DXDIA     := Date()
   ZDIRE     := "ERRO ZDIRE"
   ZDIRN     := "ERRO ZDIRN"
   ZCODMANA5 := 1
   ZERRO     := ""
   zNERRO    := 0


//
   cRDDEXT := "CDX"

   IF !NETUSE( "CONFIGU",,,,, .F., )  // BREDE("CONFIGU",1)
      RETU
   ENDIF
   TEMPO    := TEMP
   IM1      := IMPRE
   DRI      := DRIVE
   ZMOEDA01 := AllTrim( MOEDA01 )
   ZMOEDA02 := AllTrim( MOEDA02 )
   ZMOEDA03 := AllTrim( MOEDA03 )
   ZMOEDA04 := AllTrim( MOEDA04 )
   ZMOEDA05 := AllTrim( MOEDA05 )
   ZMOEDA06 := AllTrim( MOEDA06 )
   dbCloseAll()

// Inicializa o Mouse Clipper 5.3c
   Set( _SET_EVENTMASK, HB_INKEY_ALL )
   lMOUSE       := MPresent()
   MOUSE_X      := 0
   MOUSE_Y      := 0
   MOUSE_B      := 0
   aMENUPROMPTS := {}
   IF lMOUSE
      cls
      MSetBounds()
      MSetCursor( .T. )
   ENDIF

   deletaarq( "TEMP*.*" )
   deletaarq( "*.tmp" )
   deletaarq( "*.LOG" )

// Variaveis Controle Impressora,Video Arquivo
   cARQSPO   := ""
   nTIPSPO   := 0
   cIMPCOM   := Chr( 15 )
   cIMPEXP   := Chr( 18 )
   cIMPTIT   := Chr( 14 )
   cIMPNEG   := Chr( 27 ) + Chr( 69 )
   cIMPNER   := Chr( 27 ) + Chr( 70 )
   cIMPORI   := ""
   lIMPEMAIL := .F.


   ZUSER := PadR( NNETWHOAMI(), 10 )


   INFOR( "FIRMA", "NRCLIEN", "FIRMA", .T. )
   INFOR( "MUSER", "USUARIO", "MUSER", .T. )
   INFOR( "FOLREL", "DBF+CAMPO", "FOLREL", .T. )
   INFOR( "FIRMA", "NRCLIEN", "FIRMA", .T. )
   INFOR( "RELCONTA", "CODIGO", "RELCONTA", .T. )
   INFOR( "FORFENTX", "DBF+NTX+STR(SEQ,3)", "FORFENTX", .T. )

   MUDADATA()
   CONSEN := .T.
   WHILE .T.
      LOGOTIPO( "MODULO RESCISAO E FERIAS" )
      WHILE NREMP = 0
         NREMP := ESCOLHEXI( "FIRMA", "NREMP", "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN" )
         IF !netuse( "firma" )
            LOOP
         ENDIF
         dbGoTop()
         IF dbSeek( NREMP )
            MSG2      := AllTrim( RAZAO )
            MSG3      := SENHA
            MESHORA   := if( HORASMES > 220, HORASMES, 220 )
            RECOIRRF  := PAGAR
            ZCODMANA5 := CODMANA5
         ELSE
            MDT( 'EMPRESA NAO CADASTRADA' )
            NREMP := 0
         ENDIF
         dbCloseAll()
      ENDDO
      ANOWORK := SubStr( StrZero( Year( DXDIA ), 4 ), 3, 2 )
      ANOUSO  := Year( DXDIA )


      // Verifica o ano Se nao e'padrao 00 (ano atual)
      IF !pegfolpat()
         LOOP
      ENDIF

      // Senha
      NRSEN := pegfolsen()

      // competencia
      OP      := pegfolmes()
      MES     := OP
      MESTRAB := MES
      MMES    := MMES( OP )
      EMP     := StrZero( NREMP, 4 )
      ARQMES  := StrZero( MES, 2 )
      IF NRSEN <> 'DiReT'
         PES := 'FO_PES'
         FOL := 'FP' + EMP + ARQMES
      ELSE
         PES := 'FO_DIR'
         FOL := 'SO' + EMP + ARQMES
      ENDIF
      @  7, 0 clear
      IF !File( ZDIRE + FOL + ".DBF" )
         ALERTX( "Falta Arquivo de Folha do Mes" )
         NREMP := 0
         LOOP
      ENDIF
      MDS( 'Aguarde organizacao dos arquivos' )
      IF File( ZDIRE + FOL + ".DBF" )
         INFOR( ZDIRE + FOL, "CONTROLE", ZDIRE + FOL, .T. )
      ENDIF
      IF File( ZDIRE + "FO_DIR.DBF" )
         INFOR( ZDIRE + "FO_DIR", "NUMERO", ZDIRE + "FO_DIR", .T. )
      ENDIF
      IF File( ZDIRE + "FO_PES.DBF" )
         INFOR( ZDIRE + "FO_PES", "NUMERO", ZDIRE + "FO_PES", .T. )
      ENDIF
      FORESM()
      IF !MDG( 'DESEJA CONTINUAR NA FOLHA ' )
         FIM( "" )
      ENDIF
      IF MDG( 'DESEJA MUDAR A EMPRESA  ??' )
         CONSEN := .T.
         NREMP  := 0
      ENDIF
   ENDDO


// + EOF: folharfe.prg
// +
