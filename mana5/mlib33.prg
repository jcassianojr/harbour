// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib33.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKIPI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKIPI( cIPI )

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF Empty( cIPI )
      RETU MDG( "Aceitar sem Classifica‡Æo" )
   ENDIF
   cIPI := StrTran( cIPI, ".", "" )
   cIPI := StrTran( cIPI, "-", "" )
   cIPI := StrTran( cIPI, " ", "" )
   IF !VERSEHA( "FI_NBM", cIPI, "DESCRI", "'XERRIPI'", .T. )
      RETU .F.
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCIPI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CHECKCIPI( cCODIPI, mVARALQ, mVARCLA, mVARICM, mOPER, nBUSCA, eDIPI, eDICM )

   LOCAL DBF   := Alias()
   LOCAL lRETU := .F.

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF Empty( cCODIPI )
      MDS( "Codigo Simplificado de IPI n„o preenchido" )
      RETU .T.
   ENDIF
   IF ValType( nBUSCA ) # "N"
      nBUSCA := 3  // CFO Antigo //2Novo
   ENDIF
   IF !USEREDE( "MD03", 1, 1 )
      RETU lRETU
   ENDIF
   dbGoTop()
   IF dbSeek( cCODIPI )
      lRETU := .T.
      IF ValType( mVARALQ ) = "C"
         &mVARALQ. := ALIQUOTA
      ENDIF
      IF ValType( mVARCLA ) = "C"
         &mVARCLA. := CLASSIFIC
      ENDIF
      IF !Empty( ALIQUOTAI ) .AND. ValType( mVARICM ) = "C"
         &mVARICM. := ALIQUOTAI
      ENDIF
      IF ValType( eDIPI ) = "C" .AND. !Empty( DIPIPI )
         &eDIPI. := DIPIPI
      ENDIF
      IF ValType( eDICM ) = "C" .AND. !Empty( DIPICM )
         &eDICM. := DIPICM
      ENDIF
   ENDIF
   dbCloseArea()
   IF !lRETU
      ALERTX( "Codigo Simplificado de IPI n„o Cadastrado" )
   ENDIF
   IF ValType( mOPER ) = "C" .AND. ValType( mVARALQ ) = "C"
      IF nBUSCA = 3
         mOPER := Left( mOPER, 3 )
      ENDIF
      IF OBTER( "MD04", mOPER, "ZERAIPI" ) = "S"
         &mVARALQ. := 0
      ENDIF
   ENDIF
   IF !Empty( DBF )
      SELE &DBF.
   ENDIF
   RETU lRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKUN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CHECKUN( cUNI )

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF VERSEHA( "MD07", cUNI, "'Unidade : '+UNIDDES", '"Unidade Medida N„o Cadastrada"', .T. )
      RETU .T.
   ENDIF
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PDIPI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PDIPI( eOPE, eVARA, eVARB, eVARC, eVARD, lOPE, nBUSCA )

// Operacao,CodIcm,DIPIPI,DIPICM,DIPAM,open,Indice 2CfoNovo/3CfoVelho
   LOCAL cDBF := Alias()
   IF ValType( nBUSCA ) # "N"
      nBUSCA := 3  // CFO Velho
   ENDIF
   IF ValType( lOPE ) # "L"
      lOPE := .T.
   ENDIF
   IF ValType( eOPE ) = "N"
      eOPE := Str( eOPE, 3 )
   ENDIF
   IF nBUSCA = 3   // Cfo Velho
      eOPE := Left( eOPE, 3 )
   ENDIF
   IF lOPE
      IF !USEREDE( "MD04", 1, nBUSCA )
         RETU .F.
      ENDIF
   ENDIF
   dbSelectAr( "MD04" )
   dbGoTop()
   IF dbSeek( eOPE )
      IF ValType( eVARA ) = "C"
         IF !Empty( CODICM )
            &eVARA. := CODICM
         ENDIF
         IF Empty( &eVARA. )
            &eVARA. := "000"
         ENDIF
      ENDIF
      IF ValType( eVARB ) = "C" .AND. !Empty( DIPIPI )
         &eVARB. := DIPIPI
      ENDIF
      IF ValType( eVARC ) = "C" .AND. !Empty( DIPICM )
         &eVARC. := DIPICM
      ENDIF
      IF ValType( eVARD ) = "C" .AND. !Empty( DIPAM )
         &eVARD. := DIPAM
      ENDIF
   ENDIF
   IF lOPE
      dbCloseArea()
   ENDIF
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU .T.


// + EOF: mlib33.prg
// +
