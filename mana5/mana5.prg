// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mana5.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
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

   PARA ZUSER, cSENHA, cDEBUG

   MVINFOConfTela( "MANA5" )

   netregosok()
   hb_idleState()
   hb_langSelect( 'PT' )

   IF ValType( cDEBUG ) # "C"
      cDEBUG := "NAO"
   ENDIF

   IF cDEBUG = "SIM"
      Inkey( 0 )
   ENDIF

   deletaarq( "TEMP*.*" )
   deletaarq( "*.tmp" )
   deletaarq( "*.LOG" )

   IF ValType( ZUSER ) = "C"
      ZUSER := Upper( ZUSER )
   ENDIF
   IF ValType( cSENHA ) = "C"
      cSENHA := Upper( cSENHA )
   ENDIF


   hb_idleState()
   Set( _SET_CODEPAGE, "PTISO" )
   rddSetDefault( "DBFCDX" )
   Set( _SET_OPTIMIZE, .T. )
   Set( _SET_DELETED, .T. )
   Set( _SET_SOFTSEEK, .T. )
   __SetCentury( .T. )
   Set( _SET_EPOCH, Year( Date() ) - 60 )
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
   Set( _SET_TYPEAHEAD, 50 )
   Set( _SET_WRAP, .T. )
   Set( _SET_EXACT, .F. )
   SetCursor( .T. )

   cRDDEXT := "CDX"

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
   SetKey( K_F10, {|| MUDADATA() } )
// SetKey( K_F8, {|| hb_run("calc") } )

// Inicializa o Mouse Clipper 5.3c
   Set( _SET_EVENTMASK, HB_INKEY_ALL )
   lMOUSE       := MPresent()
   MOUSE_X      := 0
   MOUSE_Y      := 0
   MOUSE_B      := 0
   aMENUPROMPTS := {}
   IF lMOUSE
      CLEAR
      MSetBounds()
      MSetCursor( .T. )
   ENDIF

// Variavel Para Copy/Cut/Paste no READCUR()
   READVAR := ""
// Zera a Variavel help Inicial
   HELPARQ := ""
// Zera Variaveis de Trabalho
   ZDDD    := ""
   ZCEP    := ""
   ZCEPFIM := ""
   ZRUA    := ""
   ZKM     := 0
   LASTCOR := ""
   ZERRO   := ""
   zNERRO  := 0

// Variveis de Spool
   cARQSPO   := ""
   nTIPSPO   := 0
   cIMPCOM   := Chr( 15 )
   cIMPEXP   := Chr( 18 )
   cIMPTIT   := Chr( 14 )
   cIMPNEG   := Chr( 27 ) + Chr( 69 )
   cIMPNER   := Chr( 27 ) + Chr( 70 )
   cIMPORI   := ""
   lIMPEMAIL := .F.


// Variavel Uso para Pausa telas de edicao
   ZCONTINUA := " "

   IF !hb_FileExists( "CONFIGU.DBF" )
      ALERTX( "Falta Arquivo de Configura‡„o CONFIGU.DBF" )
      QUIT
   ENDIF

   IF ZUSER = "/C"
      M_CD( .F. )
      ALERTX( "Reinicie O Sistema" )
      CLS
      QUIT
   ENDIF

// Pegando Configura‡”es do Sistema
   PRIV ZARQHIS, ZARQMAN
   PRIV ZARQ, ZARQ1, ZDIRC, ZDIRI, ZDIRP, ZDIRA, ZDIRB, ZDIREx
   PRIV ZMOEDA01, ZMOEDA02, ZMOEDA03, ZMOEDA04, ZMOEDA05, ZMOEDA06, zMULTIEMP
   PRIV zARQFON, zIMPPAD, ZIMA, ZIMB
   IF !MCD01()
      ALERTX( "Erro Abrindo Arquivos de Configura‡ao" )
      QUIT
   ENDIF

// Data do Sistema
   ZDATA := Date()

   ARQENT( "MANARQ", "MANARQ", "ARQUIVO" )
   ARQENT( "MANARQ1", "MANARQ1", "ARQUIVO+STR(ITEM,2)" )
   ARQENT( "MANOPT", "MANOPT", "ITEMENU+STR(POSICAO,2)" )
   ARQENT( "MUSER", "MUSER", "USUARIO" )
   ARQENT( "MUSERM", "MUSERM", "CONTROLE" )
   ARQENT( "MUSERN", "MUSERN", "USUARIO" )

   ZNUMERO := 1
   IF ZMULTIEMP = 'S'
      @ 24, 00 clear
      @ 24, 00 SAY "Digite o Codigo da Empresa"
      @ 24, 40 GET ZNUMERO
      READCUR()
   ENDIF

// Monta Temporariamento o DIRE E CODIGO EMPRESA
   ZDIRE := ZDIREx + StrZero( ZNUMERO, 5 ) + "\"

   ZDIA := Day( ZDATA )
   ZMES := Month( ZDATA )
   ZANO := Year( ZDATA )
   IF Empty( ZUSER ) .OR. ZUSER = "/C"
      ZUSER := PadR( NNETWHOAMI(), 10 )
   ENDIF
   ZROW := 24

// Pegando Configura‡”es de Cores
   PRIV ZCOR001
   PRIV ZCOR002
   PRIV ZCOR003
   PRIV ZCOR004
   PRIV ZCOR005
   PRIV ZCOR006
   PRIV ZCOR007
   PRIV ZCOR008
   PRIV ZCOR009
   PRIV ZCOR010
   CORARR( { "COR001", "COR002", "COR003", "COR004", "COR005", "COR006", "COR007", "COR008", "COR009", "COR010" }, ;
      { "ZCOR001", "ZCOR002", "ZCOR003", "ZCOR004", "ZCOR005", "ZCOR006", "ZCOR007", "ZCOR008", "ZCOR009", "ZCOR010" } )

// Dados do Cadastro da Empresa
   ZREDUZ   := " "
   ZPOSI    := 0
   ZNIV     := { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
   ZEMPRESA := Space( 40 )
   ZBATE    := 0
   ZLANC    := 0
   ZMEDIA   := 0
   ZCIDADE  := ""
   ZUF      := ""
   IF USEREDE( "MANEMP", 1, 1 )
      dbGoTop()
      IF dbSeek( ZNUMERO )
         ZREDUZ   := REDUZIDO
         ZPOSI    := POSI
         ZNIV     := { NIVEL1, NIVEL2, NIVEL3, NIVEL4, NIVEL5, NIVEL6, NIVEL7, NIVEL8, NIVEL9 }
         ZEMPRESA := NOME
         ZBATE    := BATE
         ZLANC    := LANC
         ZMEDIA   := if( MEDIA > 0, MEDIA, 30 )
         ZCIDADE  := AllTrim( CIDADE )
         ZESTADO  := ESTADO
      ENDIF
      dbCloseArea()
   ENDIF
   IF Empty( ZREDUZ )
      MDE( "EMP001" )
   ENDIF
   IF ZNIV[ 1 ] = 0
      ZPICCC := "XXXXXXXXXXX"
      ZTAMCC := 11
   ELSE
      ZPICCC := "@R "
      FOR X := 1 TO 9
         IF ZNIV[ X ] > 0
            IF X # 1
               ZPICCC += "."
            ENDIF
            ZPICCC += repl( "9", ZNIV[ X ] )
         ENDIF
      NEXT X
      ZTAMCC := Len( ZPICCC ) - 3
   ENDIF

// Verifica Arquivo de Log
   ZARQERRO := ""  // apenas cria a gravalog ira tratar ZARQERR ZTIPERR
   zTIPERRO := ""


   gravalog( "acessou", "abr", "menup" )

// ZARQERR := "ER"+strzero(day(ZDATA),2)+strzero(month(ZDATA),2)+substr(strzero(year(ZDATA),4),3,2)
// CHECKARQ("MANERR",ZARQERR,,,ZDIRP+"LOG\",year(ZDATA),month(ZDATA))

// Chama o Menu Principal
   CLEAR

   IF At( "__$", ZUSER ) > 0 .AND. At( "%__", ZUSER ) > 0
      // ALERTX(ZUSER)
      ZUSER := SubStr( ZUSER, 4 )
      ZUSER := Left( ZUSER, Len( ZUSER ) - 3 )
      // ALERTX(ZUSER)
      cSENHA := XDECODE( OBTER( "MUSER", ENCODE( ZUSER ), "SENHA" ) )
   ENDIF

   IF Empty( cSENHA )
      MDS( 'Seu nome, por favor: ' )
      @ 24, 40 GET ZUSER
      IF !READCUR()
         QUIT
      ENDIF
   ENDIF

   ZUSER  := Upper( ZUSER )
   ZSUPER := .F.

   MDS( "Senha" )
   IF Empty( cSENHA )
      cSENHA := PEGAPASS( 24, 10, 8,, "*", .T. )
   ENDIF


   IF ZUSER = "ADMLOG" .OR. ZUSER = "ADMINISTRADOR" .OR. ZUSER = "ADMIN"
      cUSUARIO := "SUPERVISOR"
   END IF

   IF ZUSER = "SUPERVISOR" .AND. ZUSER = "SOFTEC"
      ZSUPER := .T.
   ENDIF
   IF XDECODE( OBTER( "MUSER", ENCODE( ZUSER ), "EQUIVALE" ) ) = "SUPERVIS"
      IF cDEBUG = "NAO"
         MDT( "Acesso Equivalente Supervisor" )
      ENDIF
      ZSUPER := .T.
   ENDIF
   IF !ZSUPER
      IF !VERSEHA( "MUSER", ENCODE( ZUSER ) )
         ALERTX( "Usuario Nao Cadastrado" )
         QUIT
      ENDIF
      IF XDECDAT( OBTER( "MUSER", ENCODE( ZUSER ), "VALIDADE" ) ) < ZDATA
         ALERTX( "Se acesso expirou comunique ao Supervisor" )
         QUIT
      ENDIF
   ENDIF


// 23/12/2022 checagem hash ou senha
   cCHAVE := StrToHex( hb_SHA256( AllTrim( Upper( zuser ) ) + AllTrim( Upper( cSENHA ) ), .T. ) )
// alertX(CCHAVE)

   IF cCHAVE = OBTER( "MUSER", ENCODE( ZUSER ), "CHAVEH" ) .OR. ;
         cCHAVE = OBTER( "MUSER", ENCODE( ZUSER ), "CHAVEWW" ) .OR. ;
         cCHAVE = OBTER( "MUSER", ENCODE( ZUSER ), "CHAVEWC" ) .OR. ;
         cCHAVE = OBTER( "MUSER", ENCODE( ZUSER ), "CHAVEWS" )

      // ALERTX("HASH OK")
   ELSE
      IF cSENHA # XDECODE( OBTER( "MUSER", ENCODE( ZUSER ), "SENHA" ) )
         ALERTX( "Senha nao Confere, retente ou comunique ao Supervisor" )
         QUIT
      ENDIF
   ENDIF


   IF Len( AllTrim( cSENHA ) ) < 8
      ALERTX( "Senha com menos de 8 digitos - Troque a Senha" )
      M_CI( 1 )
   ENDIF
   IF ZDATA > OBTER( "MUSER", ENCODE( ZUSER ), "DATATRO" )
      ALERTX( "Senha Expirada - Troque a Senha" )
      M_CI( 1 )
   ENDIF

   mUSUARIO := AllTrim( ZUSER )
   mID      := AllTrim( NNETSTAID() )  // criado voltar 1 ate achar compativel harbour
   IF cDEBUG = "NAO" .AND. mID # REPL( "0", 12 )
      IF !NOVOREG( "MUSERN", mUSUARIO, .F. )
         IF !ZSUPER
            IF OBTER( "MUSERN", mUSUARIO, "ID" ) # mID .AND. OBTER( "MUSERN", mUSUARIO, "ID" ) # REPL( "0", 12 )
               ALERTX( "Voce esta com o sistema aberto em outro terminal" )
               QUIT
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   ZIDFOLHA := OBTER( "MUSER", ENCODE( ZUSER ), "FOLHANO" )

   IF Day( OBTER( "MP04", ZIDFOLHA, "DEMITIDO",,,,,, CToD( Space( 8 ) ) ) ) > 0
      ALERTX( "Funcionario: " + Str( zidfolha ) + " Demitido" )
      QUIT
   ENDIF

   zUSERCHV := ""
   ZUSERENC := ENCODE( ZUSER )
   FOR X := 1 TO Len( ZUSERENC )
      nCHAR := Asc( SubStr( ZUSERENC, x, 1 ) )
      IF NCHAR > 0
         zUSERCHV += StrZero( nCHAR, 3 )
      ENDIF
   NEXT
// alert(zUSERCHV)


   IF At( "ITAESBR2", Upper( CurDir() ) ) > 0
      ALERTX( "Voce esta na Firma II Filial" )
   ENDIF
   IF cDEBUG = "NAO"
      MAIL( "MAIL" )
   ENDIF
   MMENU()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ARQENT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION ARQENT( cARQ, cNTX, cEXP, lMES, cDRIVER )

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF cRDDEXT = "CDX"
      mTAG := cNTX
   ENDIF
   cARQ := ZDIRC + cARQ
   cNTX := ZDIRC + cNTX
   IF !File( cARQ + ".DBF" )
      IF lMES
         ALERTX( "Falta Arquivo Configucao " + cARQ )
         QUIT
      ELSE
         RETU .F.
      ENDIF
   ENDIF
   IF !File( cNTX + ".NTX" ) .AND. !File( cNTX + ".CDX" )
      IF !USECHK( cARQ,, .F. )
         // USECHK( cARQ, cIND, lSHA, cDRIVER, lNEW,nTIME )
         ALERTX( "Erro ao criar Indice do " + cARQ )
         QUIT
      ENDIF
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      IF cRDDEXT = "CDX"
         INDEX ON &cEXP. TAG &mTAG. EVAL ZEI_FORT( nLASTREC,,, 1 )
      ELSE
         INDEX ON &cEXP. TO &cNTX. EVAL ZEI_FORT( nLASTREC,,, 1 )
      ENDIF
      dbCloseArea()
   ENDIF
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NNETSTAID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION NNETSTAID()

   RETURN "1"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGCAMINI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGCAMINI( cARQ, cCAM )

   IF ValType( cCAM ) # "C"
      cCAM := ProfileString( "MANA5.INI", cARQ + ".DBF", "CAMINHO", ZDIRE )
   ENDIF
   CCAM := StrTran( CCAM, "[AA]", Right( StrZero( ANOUSO, 4 ), 2 ) )
   CCAM := StrTran( CCAM, "[AAAA]", StrZero( ANOUSO, 4 ) )
   CCAM := StrTran( CCAM, "[MM]", StrZero( MESTRAB, 2 ) )
   CCAM := StrTran( CCAM, "[ZZZ]", StrZero( NREMP, 3 ) )
   CCAM := StrTran( CCAM, "[ZZ]", StrZero( NREMP, 2 ) )
   CCAM := StrTran( CCAM, "[Z]", StrZero( NREMP, 1 ) )
   CCAM := StrTran( CCAM, "[III]", StrZero( ZCODMANA5, 3 ) )
   CCAM := StrTran( CCAM, "[II]", StrZero( ZCODMANA5, 2 ) )
   CCAM := StrTran( CCAM, "[I]", StrZero( ZCODMANA5, 1 ) )
   RETU cCAM

// + EOF: mana5.prg
// +
