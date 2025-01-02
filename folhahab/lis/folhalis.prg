// +--------------------------------------------------------------------
// +
// +    Programa  : folhalis.prg  programa main inicial
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX
REQUEST HB_GT_WVG_DEFAULT

#include "INKEY.CH"
#include "HBGTINFO.CH"
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

   MVINFOConfTela( "Modulo Folha Anuais" )


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
   Set( _SET_SCOREBOARD, .F. )
   Set( _SET_TYPEAHEAD, 50 )
   Set( _SET_WRAP, .T. )
   Set( _SET_EXACT, .F. )
   SetCursor( .T. )
   Set( _SET_CONFIRM, .T. )


   SET TALK OFF '' checar nao tem ainda na std.ch changelog.txt


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

   HELPARQ   := "FOLREL"   // nome da dbf do help
   READVAR   := ""
   ZCODMANA5 := 1
   ZERRO     := ""
   zNERRO    := 0


// Inicializa o Mouse Clipper 5.3c
   Set( _SET_EVENTMASK, HB_INKEY_ALL )
   lMOUSE       := MPresent()
   MOUSE_X      := 0
   MOUSE_Y      := 0
   MOUSE_B      := 0
   aMENUPROMPTS := {}
   IF lMOUSE
      CLS
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


   ZDIRE := "ERRO ZDIRE"
   ZDIRN := "ERRO ZDIRN"
   PATHX := hb_cwd()
   ZUSER := PadR( NNETWHOAMI(), 10 )

// OP_SENHA=' '
   NREMP  := 0
   DXDIA  := Date()
   ZDATA  := Date()
   ANO    := Year( DXDIA )
   CONSEN := .T.

   cRDDEXT := "CDX"

   IF !NETUSE( "CONFIGU",,,,, .F., )
      RETU
   ENDIF
   TEMPO := TEMP
   IM1   := IMPRE
   dbCloseAll()


   INFOR( "FIRMA", "NRCLIEN", "FIRMA", .T. )
   INFOR( "MUSER", "USUARIO", "MUSER", .T. )
   INFOR( "FOLREL", "DBF+CAMPO", "FOLREL", .T. )
   INFOR( "RELCONTA", "CODIGO", "RELCONTA", .T. )
   INFOR( "FOLISNTX", "DBF+NTX+STR(SEQ,3)", "FOLISNTX", .T. )


   MUDADATA()
   WHILE .T.
      LOGOTIPO()
      WHILE NREMP = 0
         NREMP := ESCOLHEXI( "FIRMA", "NREMP", "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN" )
         IF !NETUSE( "FIRMA" )
            LOOP
         ENDIF
         dbGoTop()
         IF dbSeek( NREMP )
            MSG2      := AllTrim( RAZAO )
            MSG3      := SENHA
            MESHORA   := IF( HORASMES > 220, HORASMES, 220 )
            RECOIRRF  := PAGAR
            zCGC      := CGC
            ZCODMANA5 := CODMANA5
         ELSE
            MDT( 'EMPRESA NAO CADASTRADA' )
            NREMP := 0
         ENDIF
         dbCloseAll()
      ENDDO
      ANOWORK := SubStr( StrZero( Year( DXDIA ), 4 ), 3, 2 )
      ANOUSO  := Year( DXDIA )

      // path
      IF !pegfolpat()
         LOOP
      ENDIF

      // senha
      NRSEN := pegfolsen()

      // competencia
      OP      := pegfolmes()
      MES     := OP
      MESTRAB := OP
      MMES    := MMES( OP )
      EMP     := StrZero( NREMP, 4 )
      ARQMES  := StrZero( MES, 2 )
      IF NRSEN <> 'DiReT'
         PES := 'FO_PES'
         RES := 'FO_RES'
         FOL := 'FP' + EMP + ARQMES
         F13 := 'FO_FP13'
      ELSE
         PES := 'FO_DIR'
         RES := 'FO_RDD'
         FOL := 'SO' + EMP + ARQMES
         F13 := 'FO_SO13'
      ENDIF
      IF !File( ZDIRE + FOL + ".DBF" )
         ALERTX( "Falta Arquivo de Folha do Mes" )
         NREMP := 0
         LOOP
      ENDIF
      MDS( 'Aguarde organiza‡„o dos arquivos' )
      IF File( ZDIRE + FOL + ".DBF" )
         INFOR( ZDIRE + FOL, "CONTROLE", ZDIRE + FOL, .T. )
      ENDIF
      IF File( ZDIRE + "FO_DIR.DBF" )
         INFOR( ZDIRE + "FO_DIR", "NUMERO", ZDIRE + "FO_DIR", .T. )
      ENDIF
      IF File( ZDIRE + "FO_PES.DBF" )
         INFOR( ZDIRE + "FO_PES", "NUMERO", ZDIRE + "FO_PES", .T. )
      ENDIF
      FOLISM()
      IF !MDG( 'DESEJA CONTINUAR no m¢dulo listas anuais' )
         FIM( "" )
      ENDIF
      IF MDG( 'DESEJA MUDAR A EMPRESA' )
         CONSEN := .T.
         NREMP  := 0
      ENDIF
   ENDDO
// : FIM: FOLHALIS.PRG

// + EOF: folhalis.prg
// +
