// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cs.prg
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


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


IF !ZSUPER
ALERTX( "Acesso Permitido Somente Para o Supervisor" )
RETU .F.
ENDIF

MDI( "Planos de Acessos de Usuarios" )

PRIV mACEITE := "S", USUARIO := Space( 10 ), mCONTROLE := ""
MDS( "Digite o Usuario" )
@ 24, 40 GET USUARIO
IF !READCUR()
RETU .F.
ENDIF

IF Empty( USUARIO ) .OR. !VERSEHA( "MUSER", ENCODE( USUARIO ) )
ALERTX( "Usuario NAo Cadastrado" )
RETU .F.
ENDIF

IF MDG( "Configurar Acesso Menus - Mana5" )
PADRAO( 0, 1, 0, "MANOPT", "I PO Item" + spac( 17 ) + "Mensagem", ;
         "' '+USUARIO+' '+mITEMENU+' '+STR(mPOSICAO,2)+' '+mDESCP+' '" ;
         , "MCS", {|| MDS( "Liberar" ) }, {|| MSC101() } )
ENDIF
IF MDG( "Configurar Acesso Sub-Menus - Mana5" )
PADRAO( 0, 1, 0, "MANSUB", "I PO Item" + spac( 17 ) + "Mensagem", ;
         "' '+USUARIO+' '+mITEMENU+' '+STR(mPOSICAO,3)+' '+mDESCP+' '" ;
         , "MCS", {|| MDS( "Liberar" ) }, {|| MSC102() } )
ENDIF
IF MDG( "Configurar Acesso Menus - ManaW" )
PADRAO( 0, 1, 0, "WINOPT", "I PO Item" + spac( 17 ) + "Mensagem", ;
         "' '+USUARIO+' '+mITEMENU+' '+STR(mPOSICAO,3)+' '+mDESCP+' '" ;
         , "MCS", {|| MDS( "Liberar" ) }, {|| MSC203( "W" ) } )
ENDIF
IF MDG( "Configurar Acesso Sistema - SysW" )
PADRAO( 0, 1, 0, "SYSOPT", "I PO Item" + spac( 17 ) + "Mensagem", ;
         "' '+USUARIO+' '+mITEMENU+' '+STR(mPOSICAO,3)+' '+mDESCP+' '" ;
         , "MCS", {|| MDS( "Liberar" ) }, {|| MSC203( "B" ) } )
ENDIF

IF MDG( "Configurar Relatorios Gerador" )
PADRAO( 0, 1, 0, "MANREL", "C¢digo   Relat¢rio", ;
         "' '+mCODIGO+' '+mNOME" ;
         , "MCS", {|| MDS( "Liberar" ) }, {|| MSC201( "M" ) } )
ENDIF
IF MDG( "Configurar Relatorios Gerador Padrao" )
PADRAO( 0, 1, 0, "PADREL", "C¢digo   Relat¢rio", ;
         "' '+mCODIGO+' '+mNOME", ;
         "MCS", {|| MDS( "Liberar" ) }, {|| MSC201( "P" ) } )
ENDIF
IF MDG( "Configurar Acesso a Fechar" )
PADRAO( 0, 1, 0, "MANFEC", "Origem Destino", ;
         "' '+mARQORI+' '+mSTRDES+' '+OBTER('MANARQ',mARQORI,'DESCRICAO')", ;
         "MCS", {|| MDS( "Liberar" ) }, {|| MSC204() } )
ENDIF
IF MDG( "Configurar Acessos Especiais" )
PADRAO( 0, 1, 0, "MACESS", "C¢digo Descri‡„o", ;
         "' '+mCODIGO+' '+mDESCRICAO", ;
         "MCH", {|| MDS( "Liberar" ) }, {|| MSC205() } )
ENDIF
IF MDG( "Configurar Inclus„o Exclusao" )
CRIARVARS( ZARQ )
PADRAO( 1, 1, 0, ZARQ, "Arquivo  Descri‡„o", ;
         "' '+mARQUIVO+' '+mDESCRICAO", ;
         "MCS", {|| MDS( "Liberar" ) }, {|| MSC206() } )
RELEASE ALL LIKE m *   // LIMPAVARS(wARQ)
ENDIF




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC206()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MSC206   // Opera‡ao Inclusao Exclusao

   mARQUIVO := AllTrim( mARQUIVO )
   mINCLUIR := PEGMCS( "O", "I" + mARQUIVO + USUARIO, .T. )
   mEXCLUIR := PEGMCS( "O", "E" + mARQUIVO + USUARIO, .T. )
   MDS( "Incluir Excluir" )
   @ 24, 40 GET mINCLUIR
   @ 24, 42 GET mEXCLUIR
   IF !READCUR()
      RETU .F.
   ENDIF
   GRVMCS( mINCLUIR = "N", "O", "I" + mARQUIVO + USUARIO, .T. )
   GRVMCS( mEXCLUIR = "N", "O", "E" + mARQUIVO + USUARIO, .T. )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC204()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSC204   // Fechamento

   mARQORI  := AllTrim( mARQORI )
   mATUAL   := PEGMCS( "F", "1" + mARQORI + USUARIO, .T. )
   mBAIXA   := PEGMCS( "F", "2" + mARQORI + USUARIO, .T. )
   mMESFEC  := PEGMCS( "F", "3" + mARQORI + USUARIO, .T. )
   mFECHAR  := PEGMCS( "F", "4" + mARQORI + USUARIO, .T. )
   mACUMULO := PEGMCS( "F", "5" + mARQORI + USUARIO, .T. )
   mACUMULA := PEGMCS( "F", "6" + mARQORI + USUARIO, .T. )
   mRETORNA := PEGMCS( "F", "7" + mARQORI + USUARIO, .T. )
   MDS( "Atual Baixado Fechado Fechar Acumulado Acumular VoltaBaixa" )
   @ 24, 60 GET mATUAL
   @ 24, 62 GET mBAIXA
   @ 24, 64 GET mMESFEC
   @ 24, 66 GET mFECHAR
   @ 24, 68 GET mACUMULO
   @ 24, 70 GET mACUMULA
   @ 24, 72 GET mRETORNA
   IF !READCUR()
      RETU .F.
   ENDIF
   GRVMCS( mATUAL = "N", "F", "1" + mARQORI + USUARIO, .T. )
   GRVMCS( mBAIXA = "N", "F", "2" + mARQORI + USUARIO, .T. )
   GRVMCS( mMESFEC = "N", "F", "3" + mARQORI + USUARIO, .T. )
   GRVMCS( mFECHAR = "N", "F", "4" + mARQORI + USUARIO, .T. )
   GRVMCS( mACUMULO = "N", "F", "5" + mARQORI + USUARIO, .T. )
   GRVMCS( mACUMULA = "N", "F", "6" + mARQORI + USUARIO, .T. )
   GRVMCS( mRETORNA = "N", "F", "7" + mARQORI + USUARIO, .T. )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC101()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSC101()   // Menus

   mACEITE := PEGMCS( "M", USERMCRI( USUARIO, mITEMENU, mPOSICAO ) )
   @ 24, 30 GET mACEITE
   IF !READCUR()
      RETU .T.
   ENDIF
   GRVMCS( mACEITE = "N", "M", USERMCRI( USUARIO, mITEMENU, mPOSICAO ) )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC102()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSC102()   // SubMenus

   mCONTROLE := ENCODE( mITEMENU + StrZero( mPOSICAO, 3 ) + USUARIO )
   mACEITE   := PEGMCS( "S", mCONTROLE )
   @ 24, 30 GET mACEITE
   IF !READCUR()
      RETU .T.
   ENDIF
   GRVMCS( mACEITE = "N", "S", mCONTROLE )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC201()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSC201( cTIPO )  // Relatorios

   mCONTROLE := ENCODE( cTIPO + mCODIGO + USUARIO )
   mACEITE   := PEGMCS( "R", mCONTROLE )
   @ 24, 30 GET mACEITE
   IF !READCUR()
      RETURN .T.
   ENDIF
   GRVMCS( mACEITE = "N", "R", mCONTROLE )

   RETURN .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC203()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MSC203( cVAR )   // Windows WINOPT(MUSERW)cVAR="W" SYSOPT(MUSERB)cVAR="B"

   mCONTROLE := ENCODE( mITEMENU + StrZero( mPOSICAO, 3 ) + USUARIO )
   mACEITE   := PEGMCS( cVAR, mCONTROLE )
   mPOSTELA  := zUSERCHV
   @ 24, 30 GET mACEITE
   IF !READCUR()
      RETURN .T.
   ENDIF
   GRVMCS( mACEITE = "N", cVAR, mCONTROLE )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSC205()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MSC205()   // Acessos Especiais

   mCONTROLE := ENCODE( mCODIGO + USUARIO )
   mACEITE   := PEGMCS( "A", mCONTROLE )
   @ 24, 30 GET mACEITE
   IF !READCUR()
      RETU .T.
   ENDIF
   GRVMCS( mACEITE = "N", "A", mCONTROLE )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRVMCS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION GRVMCS( lCOND, cARQ, eVAR, lENC )

   IF ValType( lENC ) # "L"
      lENC := .F.
   ENDIF
   IF lENC
      eVAR := ENCODE( eVAR )
   ENDIF
   IF lCOND
      APAGAREG( "MUSER" + cARQ, eVAR, .F., .F. )
   ELSE
      mCONTROLE := eVAR
      NOVOREG( "MUSER" + cARQ, eVAR )
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGMCS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGMCS( cARQ, eBUSCA, lENC )

   IF ValType( lENC ) # "L"
      lENC := .F.
   ENDIF
   IF lENC
      eBUSCA := ENCODE( AllTrim( eBUSCA ) )
   ENDIF
   RETU IF( VERSEHA( "MUSER" + cARQ, eBUSCA ), "S", "N" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGACS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGACS( cARQ, eBUSCA, lENC, cMES )

   LOCAL lRETU := .F.

   IF ValType( lENC ) # "L"
      lENC := .F.
   ENDIF
   IF lENC
      eBUSCA := ENCODE( AllTrim( eBUSCA ) )
   ENDIF
   IF !ZSUPER
      lRETU := VERSEHA( "MUSER" + cARQ, eBUSCA )
   ELSE
      lRETU := .T.
   ENDIF
   IF ValType( cMES ) = "C" .AND. !lRETU
      ALERTX( cMES )
   ENDIF
   RETU lRETU




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function USERMCRI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC USERMCRI( cUSER, cITEM, nPOS )

   RETU ENCODE( StrZero( nPOS, 2 ) + Left( cUSER, 2 ) + cITEM + SubStr( cUSER, 3 ) )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function USERMDEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC USERMDEC( cUSER, cITEM, nPOS )

   RETU DECODE( StrZero( nPOS, 2 ) + Left( cUSER, 2 ) + cITEM + SubStr( cUSER, 3 ) )


// + EOF: m_cs.prg
// +
