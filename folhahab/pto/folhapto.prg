// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folhapto.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX
REQUEST HB_GT_WVG_DEFAULT

#include "HBGTINFO.CH"
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
   Set( _SET_CONFIRM, .F. )

   SET TALK OFF '' checar nao tem ainda na std.ch changelog.txt

   Set( _SET_MESSAGE, 6, .T. )

   MVINFOConfTela( "Folha Modulo Ponto" )

   netregosok()
   hb_langSelect( 'PT' )
   hb_idleState()

   HELPARQ    := "FOLREL"  // arquivo=nome da dbf do help
   HELPDBF    := "FOPTO"
   ZCODMANA5  := 1
   ZCONTINUA  := " "
   ZERRO      := ""
   zNERRO     := 0
   ZCTRALMOCO := ""

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

   cRDDEXT := "CDX"

   deletaarq( "TEMP*.*" )
   deletaarq( "*.tmp" )
   deletaarq( "*.LOG" )

// Inicializa o Mouse
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

// Competencia ponto
   ZDATAINI := Date()
   ZDATAFIM := Date()
   ZFECHADO := "N"
   ZTIPVID  := "T"

   ZDIRE := "ERRO ZDIRE"
   ZDIRN := "ERRO ZDIRN"

   INFOR( "MUSER", "USUARIO", "MUSER", .T. )
   INFOR( "FOLOPT", "ITEMENU+STR(POSICAO,2)", "FOLOPT", .T. )
   INFOR( "MUSERM", "CONTROLE", "MUSERM", .T. )
   INFOR( "FOLREL", "DBF+CAMPO", "FOLREL", .T. )
   INFOR( "FIRMA", "NRCLIEN", "FIRMA", .T. )
   INFOR( "FOPTONTX", "DBF+NTX+STR(SEQ,3)", "FOPTONTX", .T. )
   INFOR( "FOPTOCOM", "STR(ANO,4)+STR(MES,2)+STR(EMPRESA,8)", "FOPTOCOM", .T. )


// ALERTX(DECODEVAL({218,206,224,190,230,226,230}))
// ALERTX(DECODEVAL({164,162,160,158,224,198,226,230}))


   ZDATA := Date()
   IF ValType( ZUSER ) # "C"
      ZUSER := Space( 10 )
      ZUSER := PadR( NNETWHOAMI(), 10 )
      IF Empty( ZUSER )
         ZUSER := PadR( "USUARIO", 10 )
      ENDIF
      MDS( "Seu nome, por favor: " )
      @ 24, 40 GET ZUSER VALID !Empty( ZUSER )
      READ
   ENDIF
   IF Empty( ZUSER )
      QUIT
   ENDIF
   ZUSER := Upper( ZUSER )

   ZSUPER := .F.
   IF ZUSER = "SUPERVISOR" .OR. ZUSER = "SOFTEC"
      ZSUPER := .T.
   ENDIF


   IF At( "__$", ZUSER ) > 0 .AND. At( "%__", ZUSER ) > 0
      ZUSER  := SubStr( ZUSER, 4 )
      ZUSER  := Left( ZUSER, Len( ZUSER ) - 3 )
      cSENHA := XDECODE( OBTER( "MUSER",, ENCODE( ZUSER ), "SENHA" ) )
   ENDIF

   MDS( "Senha" )
   IF Empty( cSENHA )
      cSENHA := PEGAPASS( 24, 10, 8,, "*", .F. )
      // PEGAPASS( PW_ROW, PW_COL, PW_LEN, PW_COR, ECHO_CHAR, p_upcase, p_echochar )
   ENDIF



// ALERTX(cSENHA)

   IF ZUSER = "ADMLOG" .OR. ZUSER = "ADMINISTRADOR" .OR. ZUSER = "ADMIN"
      cUSUARIO := "SUPERVISOR"
   END IF

   IF ZUSER <> "SUPERVISOR"
      IF !VERSEHA( "MUSER",, ENCODE( ZUSER ) )
         ALERTX( "Usuario Nao Cadastrado" )
         QUIT
      ENDIF
      IF XDECDAT( OBTER( "MUSER",, ENCODE( ZUSER ), "VALIDADE" ) ) < ZDATA
         ALERTX( "Seu acesso expirou comunique ao Supervisor" )
         QUIT
      ENDIF
   ENDIF


// 23/12/2022 checagem hash ou senha
   cCHAVE := StrToHex( hb_SHA256( AllTrim( Upper( zuser ) ) + AllTrim( cSENHA ), .T. ) )

// alertX(CCHAVE)

   IF cCHAVE = OBTER( "MUSER",, ENCODE( ZUSER ), "CHAVEH" ) .OR. ;
         cCHAVE = OBTER( "MUSER",, ENCODE( ZUSER ), "CHAVEWW" ) .OR. ;
         cCHAVE = OBTER( "MUSER",, ENCODE( ZUSER ), "CHAVEWC" ) .OR. ;
         cCHAVE = OBTER( "MUSER",, ENCODE( ZUSER ), "CHAVEWS" )
      // cARQ,eSemUso, KEYINDEX, cCAMPO, nIND, nROW, nCOL, cMES, cMES2, cDEF
      // ALERTX("HASH OK")
   ELSE
      IF cSENHA # XDECODE( OBTER( "MUSER",, ENCODE( ZUSER ), "SENHA" ) )
         ALERTX( "Senha nao Confere, retente ou comunique ao Supervisor" )
         QUIT
      ENDIF
   ENDIF

   READVAR  := ""
   OP_SENHA := 0
   NREMP    := 0
   DXDIA    := Date()
   CONSEN   := .T.
   PUBLIC TELA
   PUBLIC DADO

   MUDADATA()

// Controle Secundario Ponto
   lSECBCO := .F.

   WHILE .T.
      LOGOTIPO( "MODULO PONTO" )
      DO WHILE NREMP = 0
         NREMP := ESCOLHEXI( "FIRMA", "NREMP", "STR(NRCLIEN,8)+' '+COGNOME+' '+RAZAO", "NRCLIEN", "CRTPONTO<>'N'" )
         IF !NETUSE( "FIRMA" )
            LOOP
         ENDIF
         dbGoTop()
         IF !dbSeek( NREMP )
            MDT( 'EMPRESA NAO CADASTRADA' )
            NREMP := 0
         ELSE
            MSG3       := SENHA
            ZEMPRESA   := RAZAO
            zPESSOA    := PESSOA
            zCGC       := CGC
            ZCODMANA5  := CODMANA5   // uso folget
            ZCTRALMOCO := CTRALMOCO
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
      NRSEN := pegfolsen( .F. )

      // Compentencia
      OP      := PEGFOLMES()
      MES     := OP
      MESTRAB := OP
      MESWORK := StrZero( mestrab, 2 )
      ANOMESW := ANOWORK + MESWORK
      MMES    := MMES( OP )
      // Competencia Anterior
      nANOANT := ANOUSO
      nMESANT := MESTRAB - 1
      IF nMESANT = 0
         nMESANT := 12
         nANOANT := nANOANT - 1
      ENDIF
      EMP    := StrZero( NREMP, 4 )
      PES    := 'FO_PES'
      PESIND := "FO_PES"
      FOL    := 'FP' + EMP + StrZero( MES, 2 )
      @ 07, 00 clea

      IF !hb_FileExists( ZDIRE + FOL + ".DBF" )
         ALERTX( "Falta Arquivo de Folha do Mes" )
         NREMP := 0
         LOOP
      ENDIF
      MDS( 'Aguarde organizacao dos arquivos' )
      IF File( ZDIRE + FOL + ".DBF" )
         INFOR( ZDIRE + FOL, "CONTROLE", ZDIRE + FOL, .T. )
      ENDIF
      IF File( ZDIRE + "FO_PES.DBF" )
         INFOR( ZDIRE + "FO_PES", "NUMERO", ZDIRE + "FO_PES", .T. )
      ENDIF
      pegcompete()
      FOPTOM()
      SetColor( "W/N,N/W" )
      IF !MDG( 'Deseja continuar no Ponto/Relogio ' )
         FIM( "" )
      ENDIF
      IF MDG( 'Deseja mudar a Empresa' )
         CONSEN := .T.
         NREMP  := 0
      ENDIF
   ENDDO



// + EOF: folhapto.prg
// +
