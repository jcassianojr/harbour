// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folha1.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FOLHA.PRG: Programa Principal
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:30
// :
// :
// :     Documentado 05/13/94 em 14:53                DISK!  vers„o 5.01
// :*****************************************************************************

#include "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT

REQUEST HB_CODEPAGE_PTISO
REQUEST HB_LANG_PT
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

   MVINFOConfTela( "Folha" )

   netregosok()
   hb_langSelect( 'PT' )
   hb_idleState()

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
   Set( _SET_WRAP, .T. )
   Set( _SET_CONSOLE, .F. )

   SET TALK OFF '' checar nao tem ainda na std.ch changelog.txt
   SET SAFETY OFF '' checar nao tem ainda na std.ch changelog.txt

   SetColor( "W+/N" )

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
// SetKey( K_F8, {|| hb_run("calc") } )
   SetKey( K_F10, {|| MUDADATA() } )

   deletaarq( "TEMP*.*" )
   deletaarq( "*.tmp" )
   deletaarq( "*.LOG" )

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

   HELPARQ   := "FOLREL"
   HELPDBF   := "FOLHA1"
   READVAR   := ""
   ZDIRE     := "ERRO ZDIRE"
   ZDIRN     := "ERRO ZDIRN"
   ZCODMANA5 := 1
   ZERRO     := ""
   zNERRO    := 0

   cRDDEXT := "CDX"

   IF !NETUSE( "CONFIGU",,,,, .F., )
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

   LOGOTIPO( "FOLHA DE PAGAMENTO" )

   PCK     := .F.
   DXDIA   := Date()
   ZDATA   := Date()
   mSEMANA := 0
   NREMP   := 0
   CONSEN  := .T.

   INFOR( "MUSER", "USUARIO", "MUSER", .T. )
   INFOR( "FIRMA", "NRCLIEN", "FIRMA", .T. )
   INFOR( "FOLHANTX", "DBF+NTX+STR(SEQ,3)", "FOLHANTX", .T. )

   NOBREAK()
   MUDADATA()

   ZUSER := Space( 10 )
   ZUSER := PadR( NNETWHOAMI(), 10 )
   IF Empty( ZUSER )
      ZUSER := PadR( "USUARIO", 10 )
   ENDIF
   MDS( "Seu nome, por favor: " )
   @ 24, 40 GET ZUSER VALID !Empty( ZUSER )
   READ
   IF Empty( ZUSER )
      QUIT
   ENDIF
   ZUSER := Upper( ZUSER )

   MDS( "Senha" )
   IF Empty( cSENHA )
      cSENHA := PEGAPASS( 24, 10, 8,, "*", .F. )
      // PEGAPASS( PW_ROW, PW_COL, PW_LEN, PW_COR, ECHO_CHAR, p_upcase, p_echochar )
   ENDIF

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
      // ALERTX("HASH OK")
   ELSE
      IF cSENHA # XDECODE( OBTER( "MUSER",, ENCODE( ZUSER ), "SENHA" ) )
         ALERTX( "Senha nao Confere, retente ou comunique ao Supervisor" )
         QUIT
      ENDIF
   ENDIF


   WHILE .T.
      LOGOTIPO( "FOLHA DE PAGAMENTO" )
      NREMP := 0
      WHILE NREMP = 0
         NREMP := ESCOLHEXI( "FIRMA", "NREMP", "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN" )
         IF !netuse( "FIRMA" )
            LOOP
         ENDIF
         dbGoTop()
         IF dbSeek( NREMP )
            MSG2      := Trim( RAZAO )
            MSG2A     := Trim( COGNOME )
            ENDER1    := Trim( ENDERECO )
            BAI1      := Trim( BAIRRO )
            CID1      := CIDADE
            EST1      := ESTADO
            CEP1      := CEP
            MSG3      := SENHA
            MESHORA   := HORASMES
            CGC       := CGC
            CGC1      := CGC
            ATIV1     := ATIVIDADE
            RECOIRRF  := PAGAR
            zTELEFONE := TELEFONE
            zPESSOA   := PESSOA
            zCEI      := CEI
            ZCODMANA5 := CODMANA5
         ELSE
            FO_1()
            NREMP := 0
            LOOP
         ENDIF
      ENDDO
      dbCloseAll()


      ANOWORK := SubStr( StrZero( Year( DXDIA ), 4 ), 3, 2 )
      ANOUSO  := Year( DXDIA )

      // path
      IF !pegfolpat()
         LOOP
      ENDIF

      // senha
      NRSEN := pegfolsen()

      // Competencia
      OP      := PEGFOLMES()
      MES     := OP
      MESTRAB := MES
      MMES    := MMES( OP )
      EMP     := StrZero( NREMP, 4 )
      ARQMES  := StrZero( MES, 2 )
      IF NRSEN <> 'DiReT'
         PES := 'FO_PES'
         FOL := 'FP' + EMP + ARQMES
         F13 := 'FO_FP13'
         SEM := 'SS' + ARQMES
         RPA := 'RP' + ARQMES
      ELSE
         PES := 'FO_DIR'
         FOL := 'SO' + EMP + ARQMES
         F13 := 'FO_SO13'
         SEM := "ERRO SEM"
         RPA := "ERRO RPA"
      ENDIF
      @  7, 0 CLEAR
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
         IF !File( ZDIRE + "FOODIR.DBF" )
            filecopy( ZDIRE + "FO_DIR.DBF", ZDIRE + "FOODIR.DBF" )
            filecopy( ZDIRE + "FO_DIR.cdx", ZDIRE + "FOODIR.cdx" )
         ENDIF
         INFOR( ZDIRE + "FO_DIR", "NUMERO", ZDIRE + "FO_DIR", .T. )
      ENDIF
      IF File( ZDIRE + "FO_PES.DBF" )
         IF !File( ZDIRE + "FOOPES.DBF" )
            filecopy( ZDIRE + "FO_PES.DBF", ZDIRE + "FOOPES.DBF" )
            filecopy( ZDIRE + "FO_PES.cdx", ZDIRE + "FOOPES.cdx" )
         ENDIF
         INFOR( ZDIRE + "FO_PES", "NUMERO", ZDIRE + "FO_PES", .T. )
      ENDIF
      FOLMENU()
      IF !MDG( 'DESEJA CONTINUAR NA FOLHA ' )
         FIM( "" )
      ENDIF
      IF MDG( 'DESEJA MUDAR A EMPRESA  ??' )
         CONSEN := .T.
         NREMP  := 0
      ENDIF
   ENDDO

   RETURN .T.

// : FIM: FOLHA1.PRG

// + EOF: folha1.prg
// +
