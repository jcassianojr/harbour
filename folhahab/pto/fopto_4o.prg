// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4o.prg Plano de Acessos
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"


FUNCTION fopto_4o()

   IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC"  // So troca Senha
      ALERTX( "Acesso Permitido Somente Para o Supervisor" )
      RETURN .F.
   ENDIF

   PRIV mACEITE := "S", USUARIO := Space( 10 ), mCONTROLE := ""
   MDS( "Digite o Usuario" )
   @ 24, 40 GET USUARIO
   IF !READCUR()
      RETURN .F.
   ENDIF

   IF Empty( USUARIO ) .OR. !VERSEHA( "MUSER",, ENCODE( USUARIO ) )
      ALERTX( "Usuario Nao Cadastrado" )
      RETURN .F.
   ENDIF

   PADRAO( "FOLOPT", "FOLOPT", "' '+mITEMENU+' '+STR(mPOSICAO,  2)+' '+mDESCP+' '+mDESCM", "mITEMENU+STR(mPOSICAO,2)", "FOPTO_40 - Plano de Acessos", "I PO Item" + spac( 22 ) + "Mensagem", ;
      {|| iFOPTO4O() }, {|| tFOPTO4O() }, {|| gFOPTO4O() },,, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4O()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iFOPTO4O

   MDS( "Digite o Menu e a Posicao" )
   @  5, 3  GET mITEMENU PICTURE "!"  VALID mITEMENU $ "ABCD"
   @  5, 10 GET mPOSICAO PICTURE "99" RANGE 1, 33
   mCHAVE := mITEMENU + Str( mPOSICAO, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4O()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO4O

   hb_DispBox( 3, 0, 23, 79, B_DOUBLE + " " )
   @  4, 3 SAY "Item   Posicao"
   @  7, 3 SAY "Descricao para o Item do Menu"
   @ 10, 3 SAY "Mensagem para o Item do Menu"
   @ 13, 3 SAY "Linha Coluna Tecla"
   @ 16, 3 SAY "Executar"
   @ 18, 3 SAY "Acessa"

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4O()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO4O

   mACEITE := IF( VERSEHA( "MUSERM",, USERMCRI( USUARIO, mITEMENU, mPOSICAO ) ), "S", "N" )
   @  5, 3  SAY mITEMENU
   @  5, 10 SAY mPOSICAO
   @  8, 3  GET mDESCP
   @ 11, 3  GET mDESCM
   @ 14, 3  GET mLINHA    PICTURE '99'
   @ 14, 11 GET mCOLUNA   PICTURE '99'
   @ 14, 17 GET mTECLA    PICTURE '999'
   @ 17, 3  GET mEXECUTAR
   @ 19, 3  GET mACEITE
   READCUR()
   IF mACEITE = "N"
      APAGAREG( "MUSERM", "MUSERM", USERMCRI( USUARIO, mITEMENU, mPOSICAO ), .F., .F. )
   ELSE
      mCONTROLE := USERMCRI( USUARIO, mITEMENU, mPOSICAO )
      NOVOREG( "MUSERM", "MUSERM", mCONTROLE )
   ENDIF

   RETURN .T.

// + EOF: fopto_4o.prg
// +
