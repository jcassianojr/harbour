// +--------------------------------------------------------------------
// +
// +    Programa  : netdbf.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024-2026,  jcassiano
// + 1. DbGetRec() — Lê o registro atual para um Array
// + 2. DbPutRec( aRegistro ) — Grava um Array de volta no Registro
// + 3.HB_RecToStr() Converte o registro todo para string
// +
// +--------------------------------------------------------------------

#include "INKEY.CH"
#include "try.ch"
#include "fileio.ch"
#include "dbstruct.ch"
#include "dbinfo.ch"

// +--------------------------------------------------------------------
// +    Function netregosok()
// +--------------------------------------------------------------------
FUNCTION netregosok()

   IF !WIN_OSNETREGOK()  // Precisa direitos ADM
      IF !WIN_OSNETREGOK( .T., .T. )  // primeiro .t. para ajustar XP/W98..., o segundo ajusta no vista.
         // ALERTX('Registro do windows não ajustado !')
      ELSE
         // ALERTX('Registro windows ajustado')
      ENDIF
   ELSE
      // ALERTX('Ja Ajustado')
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netgrvcam(cCAMPO, eVAL, lLOCK )
// +--------------------------------------------------------------------
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

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netgrvd(cCAMPO, eVAL, lLOCK )
// +    grava se houver diferenca e o valor passado nao for em branco (nao zerara o campo)
// +--------------------------------------------------------------------
FUNCTION netgrvd( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF !Empty( eVAL ) .AND. eVAL <> &cCAMPO.
      IF lLOCK
         netreclock()
      ENDIF
      field->&cCAMPO. := eVAL
      IF lLOCK
         dbUnlock()
      ENDIF
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netgrvz(cCAMPO, eVAL, lLOCK )
// +    grava se o banco estiver vazio e o valor nao
// +--------------------------------------------------------------------
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

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function dbSkipEx(nSKIP)
// +--------------------------------------------------------------------
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


// +--------------------------------------------------------------------
// +    Function netrecapp()
// +--------------------------------------------------------------------
FUNCTION netrecapp()

   LOCAL nkey := 0

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


// +--------------------------------------------------------------------
// +    Function netrecdel() [Protegido contra loop infinito]
// +--------------------------------------------------------------------
FUNCTION netrecdel()

   LOCAL nKey := 0
   LOCAL nTentativas := 0

   WHILE !dbRLock( RecNo() )
      WaitPeriod( 100 )
      nKey := Inkey( 1 )
      IF nKey = K_ESC
         RETURN .F.
      ENDIF
      nTentativas++
      IF nTentativas > 50  // Aproximadamente 5 segundos tentando
         MDS( "Não foi possível travar o registro para exclusão." )
         RETURN .F.
      ENDIF
   ENDDO
   dbDelete()
   dbUnlock()

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netreclock() [Protegido contra loop infinito]
// +--------------------------------------------------------------------
FUNCTION netreclock()

   LOCAL nKey := 0
   LOCAL nTentativas := 0

   WHILE !dbRLock( RecNo() )
      WaitPeriod( 100 )
      nKey := Inkey( 1 )
      IF nKey = K_ESC
         RETURN .F.
      ENDIF
      nTentativas++
      IF nTentativas > 50  // Aproximadamente 5 segundos tentando
         MDS( "Não foi possível travar o registro." )
         RETURN .F.
      ENDIF
   ENDDO

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netrecunlcom()
// +--------------------------------------------------------------------
FUNCTION netrecunlcom()

   dbUnlock()
   dbCommit()

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netpack(cARQ,lPCK)
// +--------------------------------------------------------------------
FUNCTION netpack( cARQ, lPCK )

   IF ValType( lPCK ) # "L"
      lPCK := .T.
   ENDIF
   IF lPCK
      IF !netuse( cARQ,, .F.,,,, )  // .F. nao compartilhado
         RETURN .F.
      ENDIF
      PACK
      dbCloseArea()
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netzap(cARQ, lINDEX)
// +--------------------------------------------------------------------
FUNCTION netzap( cARQ, lINDEX )

   IF ValType( lINDEX ) # "L"
      lINDEX := .T.
   ENDIF
   IF !netuse( cARQ,, .F.,,, lINDEX, )   // .F. nao compartilhado
      RETURN .F.
   ENDIF
   ZAP
   dbCloseArea()

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function NetRegCount(cARQ)
// +--------------------------------------------------------------------
FUNCTION NetRegCount( cARQ )

   LOCAL nREG
   LOCAL cALIAS := Alias()

   nREG := 0
   IF !netuse( cARQ,,,,, .F., )   // abre sem index
      IF !Empty( cALIAS )
         dbSelectAr( cALIAS )
      ENDIF
      RETURN nREG
   ENDIF
   nREG := LastRec()
   dbCloseArea()
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN nREG


// +--------------------------------------------------------------------
// +    Function netuse(cARQ, cDRIVER, lSHA, lREAD, lNEW, lINDEX, nTIME )
// +--------------------------------------------------------------------
FUNCTION netuse( cARQ, cDRIVER, lSHA, lREAD, lNEW, lINDEX, nTIME )

   LOCAL cEXT
   LOCAL cIND
   LOCAL nKEY
   LOCAL cTableExt, cMemoExt, cOrdExt
   LOCAL cDbfFile

   // Obtem as extensoes dinamicamente via hb_rddInfo, aplicando valores padrao se vazio
   cTableExt := hb_rddInfo( RDDI_TABLEEXT )
   IF Empty( cTableExt )
      cTableExt := "dbf"
   ENDIF

   cMemoExt := hb_rddInfo( RDDI_MEMOEXT )
   IF Empty( cMemoExt )
      cMemoExt := "fpt"
   ENDIF

   cOrdExt := hb_rddInfo( RDDI_ORDBAGEXT )
   IF Empty( cOrdExt )
      cOrdExt := "cdx"
   ENDIF

   cEXT := StrTran( Upper( cOrdExt ), ".", "" )

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
      nTIME := -1   // tenta abrir indeterminadamente
   ENDIF
   IF ValType( lREAD ) # "L"
      lREAD := .F.   // Le e grava
   ENDIF
   IF ValType( lINDEX ) # "L"
      lINDEX := .T.  // Abre indices
   ENDIF

   cDbfFile := cARQ + "." + cTableExt
   IF !File( cDbfFile ) .AND. !File( cARQ )   
      ALERTX( "Netuse: Falta Arquivo: " + cARQ )
      RETURN .F.
   ENDIF

   WHILE .T.
      dbUseArea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )
      IF !NetErr()
         EXIT
      ENDIF
      IF nTIME > 0
         nTIME := nTIME - 1
      ENDIF
      IF nTIME = 0
         RETURN .F.
      ENDIF
      IF nTIME = -2
         IF !MDG( "Deseja Retentar" )
            RETURN .F.
         ENDIF
      ENDIF
      MDS( "Nao Estou Conseguindo Abrir arquivo " + cARQ )
      WaitPeriod( 100 )
      nKEY := Inkey( 1 )
      IF nKEY = K_ESC
         RETURN .F.
      ENDIF
   ENDDO

   IF lINDEX
      cIND := cARQ + "." + cOrdExt
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

   IF cDRIVER = "DBFCDX"
      rddInfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 )
   ENDIF
   IF cDRIVER = "DBFNTX"
      rddInfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 )
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function zei_fort(nLASTREC,lSAYREC,nPOS,nINC )
// +--------------------------------------------------------------------
FUNCTION zei_fort( nLASTREC, lSAYREC, nPOS, nINC )

   STATIC LD_CHA   := "|"
   STATIC nPOSZEI
   LOCAL cComplete

   IF ValType( nLASTREC ) # "N"
      nLASTREC := LastRec()
   ENDIF
   IF ValType( lSAYREC ) # "L"
      lSAYREC := .T.
   ENDIF
   IF ValType( nINC ) = "N"
      IF nINC = 0
         nPOSZEI := 0
      ELSE
         nPOSZEI += nINC
      ENDIF
      nPOS := nPOSZEI
   ENDIF
   IF nLASTREC = 0   // evita divisao por zero
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


// +--------------------------------------------------------------------
// +    Function sdvpegpos(Pstring,aCAMPOS, PnCampo,lCONV,eCONV)
// +--------------------------------------------------------------------
FUNCTION sdvpegpos( Pstring, aCAMPOS, PnCampo, lCONV, eCONV )

   LOCAL eRETU

   eRetu := SubStr( Pstring, aCAMPOS[ PnCampo, 5 ], aCAMPOS[ PnCampo, 3 ] )
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
            eRETU := StrLogic( eRETU )
         CASE aCAMPOS[ PnCampo,  2 ] = "N"
            eRETU := Val( eRETU )
            IF aCAMPOS[ PnCampo,  4 ] > 0
               eRETU := eRETU / ( 10 ^ aCAMPOS[ PnCampo, 4 ] )
            ENDIF
         ENDCASE
      ENDIF
   ENDIF

   RETURN eRETU


// +--------------------------------------------------------------------
// +    Function sdvarrpos(aDBF,lESP)
// +--------------------------------------------------------------------
FUNCTION sdvarrpos( aDBF, lESP )

   LOCAL nFIELDS, nPOS, aRETU, X

   nFIELDS := Len( aDBF )
   IF ValType( lESP ) # "L"
      lESP := .F.
   ENDIF
   aRETU := {}
   nPOS  := 1
   FOR X := 1 TO nFIELDS
      AAdd( aRETU, { aDBF[ X,  1 ], aDBF[ X,  2 ], aDBF[ X,  3 ], ADBF[ X,  4 ], nPOS, "" } )
      nPOS += aDBF[ X, 3 ] + IF( lESP, 1, 0 )
   NEXT X

   RETURN aRETU


// +--------------------------------------------------------------------
// +    Function sdvarrcam(LINHA,aDBF,lCONV)
// +--------------------------------------------------------------------
FUNCTION sdvarrcam( cLINHA, aDBF, lCONV )

   LOCAL X, aRETU, nFIELDS

   nFIELDS := Len( aDBF )
   aRETU   := {}
   FOR X := 1 TO nFIELDS
      AAdd( aRETU, sdvpegpos( cLINHA, aDBF, X, lCONV ) )
   NEXT X

   RETURN aRETU
   
