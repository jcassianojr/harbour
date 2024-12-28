// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : netdbf.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
// +
// +    Function netregosok() verifica registros XP/W98
// +    FUNCTION netgrvcam(cCAMPO,eVAL)   grava campo com lock unlock
// +    Function netgrvd()  grava se houver diferenca e o valor passado nao for em branco (nao zerara o campo)
// +    Function netgrvz()  grava se o banco estiver vazio e o valor nao for igual
// +    FUNCTION dbskipex(nSKIP)    salta n registros
// +    FUNCTION netrecapp()          inclui um registro
// +    FUNCTION netrecdel()          deteta um registro
// +    FUNCTION netreclock()         trava um registro
// +    FUNCTION netrecunlcom()        destrava um registro e comita
// +    FUNCTION netpack(cARQ,lPCK)      pack em um arquivo
// +    FUNCTION netzap(cARQ,lINDEX)     zap em um arquivo
// +    Function netregcount(cARQ)       conta registro de um arquivo
// +    FUNCTION netuse(cARQ,cDRIVER,lSHA,lREAD,lNEW,lINDEX,nTIME)
// +    FUNCTION zei_fort(nLASTREC,lSAYREC,nPOS,nINC)
// +    funcoes para trabalhar linha como dbf aDBF=estrutura posicao [5]posicao na linha [6]tipo de conversao
// +    FUNCTION sdvpegpos(pSTRING,aCampos,pnCAMPO,lCONV,eCONV)
// +    FUNCTION sdvarrpos(aDBF,lESP)     Retorna novo dbf com [X][5] com posicoes do campo com ou sem espacamentos
// +    FUNCTION sdvarrcam(cLINHA,aCAMPOS,lCONV)
// +
// +ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
// +


#include "INKEY.CH"
#include "dbinfo.ch"

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netregosok()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netregosok()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netregosok()

   IF !WIN_OSNETREGOK()  // Precisa direitos ADM
      IF !WIN_OSNETREGOK( .T., .T. )  // primeiro .t. ‚ para ajustar XP/W98..., o segundo ajusta no vista.
         // ALERTX('Registro do windows nЖo ajustado !')
      ELSE
         // ALERTX('Registro windows ajustado')
      ENDIF
   ELSE
      // ALERTX('Ja Ajustado')
   ENDIF

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netgrvcam()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netgrvcam()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netgrvcam( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF lLOCK
      netreclock()
   ENDIF
   field->&cCAMPO. := eVAL
   IF lLOCK
      dbUnlock()
   ENDIF


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netgrvd() //grava se houver diferenca e o valor passado nao for em branco (nao zerara o campo)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netgrvd()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION netgrvd( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF !Empty( EVAL ) .AND. eVAL <> &cCAMPO.
      IF lLOCK
         netreclock()
      ENDIF
      field->&cCAMPO. := eVAL
      IF lLOCK
         dbUnlock()
      ENDIF
   ENDIF

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netgrvz()   //grava se o banco estiver vazio e o valor nao
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netgrvz()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION netgrvz( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF !Empty( eVAL ) .AND. Empty( &cCAMPO. )
      IF lLOCK
         netreclock()
      ENDIF
      field->&cCAMPO. := eVAL
      IF lLOCK
         dbUnlock()
      ENDIF
   ENDIF

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function dbSkipEx()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function dbSkipEx()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION dbSkipEx( nSKIP )

   IF ValType( nSKIP ) # "N"
      nSKIP := 1
   ENDIF
   dbSkip( nSKIP )
   IF Bof()
      dbGoTop()
   ENDIF
   IF Eof()
      dbGoBottom()
   ENDIF

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netrecapp()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netrecapp()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netrecapp()

   LOCAL nkey := 0

   nKEY := 0
   dbAppend()
   WHILE NetErr()
      dbAppend()
      WaitPeriod( 100 )
      nKEY := Inkey( 1 )
      IF nKEY = K_ESC
         RETURN .F.
      ENDIF
      MDS( "Tentando Incluir Registro: " + Alias() )
   ENDDO

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netrecdel()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netrecdel()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netrecdel()

   WHILE !dbRLock( RecNo() )
   ENDDO
   dbDelete()
   dbUnlock()

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netreclock()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netreclock()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netreclock()

   WHILE !dbRLock( RecNo() )
   ENDDO

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netrecunlcom()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netrecunlcom()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netrecunlcom()

   dbUnlock()
   dbCommit()

   RETURN .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netpack(cARQ,lPCK) lPCK usado rotinas internas
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netpack()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION netpack( cARQ, lPCK )

   IF ValType( lPCK ) # "L"
      lPCK := .T.
   ENDIF
   IF lPCK
      IF !netuse( cARQ,, .F.,,,, )  // .F. nao compartilhado
         RETU .F.
      ENDIF
      PACK
      dbCloseArea()
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netzap(cARQ)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netzap()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION netzap( cARQ, lINDEX )

   IF ValType( lINDEX ) # "L"
      lINDEX := .T.
   ENDIF
   IF !netuse( cARQ,, .F.,,, lINDEX, )   // .F. nao compartilhado
      RETU .F.
   ENDIF
   ZAP
   dbCloseArea()
   RETU .T.


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netregcount(cARQ)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NetRegCount()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION NetRegCount( cARQ )

   LOCAL nREG
   LOCAL cALIAS := Alias()

   nREG := 0
   IF !netuse( cARQ,,,,, .F., )   // abre sem index pois as vezes
      RETU nREG  // e copia de outro dbf sem o index
   ENDIF
   nREG := LastRec()
   dbCloseArea()
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF
   RETU nREG


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function netuse()
// +    NETUSE(cARQ,,,,,.F.,)    //BREDE(ARQUSO,1) abre sem index compartilhado
// +    netuse(cARQ,,.F.,,,.F.,) //BREDE(ARQUSO,0) abre sem index exclusivo
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function netuse()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION netuse( cARQ, cDRIVER, lSHA, lREAD, lNEW, lINDEX, nTIME )

   LOCAL cEXT
   LOCAL cIND
   LOCAL nKEY

   cEXT := StrTran( Upper( ordBagExt() ), ".", "" )
   IF ValType( cDRIVER ) # "C" .OR. Empty( cDRIVER )
      cDRIVER := IF( cEXT = "CDX", "DBFCDX", "DBFNTX" )
   ELSE
      cDRIVER := AllTrim( cDRIVER )
   ENDIF
   IF ValType( lNEW ) # "L"
      lNEW := .T.  // abrir nova area
   ENDIF
   IF ValType( lSHA ) # "L"
      lSHA := .T.  // abrir compartilhado
   ENDIF
   IF ValType( nTIME ) # "N"
      nTIME := -1   // tenta abrir indeterminadamente (sem limite tempo)
   ENDIF
   IF ValType( lREAD ) # "L"
      lREAD := .F.   // Le e grava
   ENDIF
   IF ValType( lINDEX ) # "L"
      lINDEX := .T.  // Abre indices
   ENDIF
   IF !File( cARQ + ".DBF" ) .AND. !File( cARQ )   // evitar erro caso o arquivo ja tenha .dbf
      ALERTX( "Netuse: Falta Arquivo: " + Carq )
      RETU .F.
   ENDIF
   WHILE .T.
      // DBUSEAREA( [<lNewArea>], [<cDriver>], <cName>, [<xcAlias>],[<lShared>], [<lReadonly>])
      dbUseArea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )
      IF !NetErr()
         EXIT  // sai do loop tenta novamente
      ENDIF
      IF nTIME > 0
         nTIME := nTIME - 1
      ENDIF
      IF nTIME = 0
         RETU .F.
      ENDIF
      // -1 nao faz nada
      IF nTIME = -2
         IF !MDG( "Deseja Retentar" )
            RETU .F.
         ENDIF
      ENDIF
      MDS( "Nao Estou Conseguindo Abrir aquivo " + cARQ )
      WaitPeriod( 100 )
      nKEY := Inkey( 1 )
      IF nKEY = K_ESC
         RETU .F.
      ENDIF
   ENDDO
   IF lINDEX
      cIND := cARQ + "." + cEXT
      IF File( cIND )
         IF cDRIVER = "DBFCDX"
            ordListAdd( cIND )
         ELSE
            dbSetIndex( cIND )
         ENDIF
      ELSE
         ALERTX( "Arquivo Indice nao encontrado : " + cIND )
      ENDIF
   ENDIF
// #define DBFLOCK_DEFAULT 0
// #define DBFLOCK_CLIP 1
// #define DBFLOCK_CL53 2
// #define DBFLOCK_VFP 3
// #define DBFLOCK_CL53EXT 4
// #define DBFLOCK_XHB64 5
   IF cDRIVER = "DBFCDX"
      rddInfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 )   // DB_DBFLOCK_VFP)
   ENDIF
   IF cDRIVER = "DBFNTX"
      rddInfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 )   // DB_DBFLOCK_CL53)
   ENDIF
   RETU .T.


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function zei_fort(nLASTREC,lSAYREC,nPOS,nINC )
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function zei_fort()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION zei_fort( nLASTREC, lSAYREC, nPOS, nINC )

   STATIC LD_CHA   := "|"
   STATIC nPOSZEI
   LOCAL cComplete

   IF ValType( nLASTREC ) # "N"
      nLASTREC := LastRec()
   ENDIF
   IF ValType( lSAYREC ) # "L"
      lSAYREC := lSAYREC := .T.
   ENDIF
   IF ValType( nINC ) = "N"
      IF nINC = 0
         nPOSZEI := 0
      ELSE
         nPOSZEI += nINC
      ENDIF
      nPOS := nPOSZEI
   ENDIF
   IF nLASTREC = 0   // evita divisao por zeo
      nLASTREC := 100
   ENDIF
   IF ValType( nPOS ) = "N"
      cComplete := Int( ( nPOS / nLASTREC ) * 100 )
   ELSE
      cComplete := Int( ( RecNo() / nLASTREC ) * 100 )
   ENDIF
   IF ld_cha = '|'
      ld_cha := '/'
   ELSEIF ld_cha = '/'
      ld_cha := '\'
   ELSEIF ld_cha = '\'
      ld_cha := '-'
   ELSEIF ld_cha = '-'
      ld_cha := '|'
   ENDIF
   IF lSAYREC
      IF ValType( nPOS ) = "N"
         @ MaxRow(), 38 SAY Str( nPOS, 8 ) + "/" + Str( nLASTREC, 8 )
      ELSE
         @ MaxRow(), 38 SAY Str( RecNo(), 8 ) + "/" + Str( nLASTREC, 8 )
      ENDIF
   ENDIF
   @ MaxRow(), 57                     SAY "["
   @ MaxRow(), 69                     SAY "]"
   @ MaxRow(), 58 + Int( cCOMPLETE / 10 ) SAY "#" + ld_cha
   @ MaxRow(), 71                     SAY Transform( cComplete, '999' )

   RETURN .T.


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function sdvpegpos( Pstring,aCAMPOS, PnCampo,lCONV,eCONV )
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sdvpegpos()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sdvpegpos( Pstring, aCAMPOS, PnCampo, lCONV, eCONV )

   LOCAL eRETU

   eRetu := SubStr( Pstring, aCAMPOS[ PnCampo, 5 ], aCAMPOS[ PnCampo, 3 ] )  // Posicao + Tamanho do Campo
   IF ValType( lCONV ) # "L"
      lCONV := .F.
   ENDIF
   IF ValType( eCONV ) # "C"
      eCONV := aCAMPOS[ PnCampo, 6 ]
   ENDIF
   IF lCONV
      IF !Empty( eCONV )
         DO CASE
         CASE eCONV = "DMY/2" .OR. eCONV = "DMY/4"
            eRETU := SubStr( eRETU, 1, 2 ) + "/" + SubStr( eRETU, 3, 2 ) + "/" + SubStr( eRETU, 5 )
         ENDCASE
      ELSE
         DO CASE
         CASE aCAMPOS[ PnCampo,  2 ] = "SD"
            eRETU := SToD( eRETU )
         CASE aCAMPOS[ PnCampo,  2 ] = "D"
            eRETU := CToD( eRETU )
         CASE aCAMPOS[ PnCampo,  2 ] = "L"
            eRETU := StrLogic( eRETU )   // IF(eRETU="S",.T.,.F.)
         CASE aCAMPOS[ PnCampo,  2 ] = "N"
            eRETU := Val( eRETU )
            IF aCAMPOS[ PnCampo,  4 ] > 0
               eRETU := eRETU / ( 10 ^ aCAMPOS[ PnCampo, 4 ] )
            ENDIF
         ENDCASE
      ENDIF
   ENDIF

   RETURN eRETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function sdvarrpos(aDBF,lESP)  //Retorna novo dbf com [X][5] com posicoes do campo com ou sem espacamentos
// +                                   //Ja cria com [X][6] para o tipo
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sdvarrpos()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sdvarrpos( aDBF, lESP )

   LOCAL nFIELDS, nPOS, aRETU, X

   nFIELDS := Len( aDBF )
   IF ValType( LESP ) # "L"
      lESP := .F.
   ENDIF
   aRETU := {}
   nPOS  := 1
   FOR X := 1 TO nFIELDS
      AAdd( aRETU, { aDBF[ X,  1 ], aDBF[ X,  2 ], aDBF[ X,  3 ], ADBF[ X,  4 ], nPOS, "" } )
      nPOS += aDBF[ X, 3 ] + IF( lESP, 1, 0 )
   NEXT X

   RETURN aRETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function sdvarrcam(cLINHA,aDBF,lCONV)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sdvarrcam()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sdvarrcam( cLINHA, aDBF, lCONV )

   LOCAL X, aRETU, nFIELDS

   nFIELDS := Len( aDBF )
   aRETU   := {}
   FOR X := 1 TO nFIELDS
      AAdd( aRETU, sdvpegpos( cLINha, aDBF, X, lCONV ) )
   NEXT X

   RETURN aRETU

// + EOF: netdbf.prg
// +
