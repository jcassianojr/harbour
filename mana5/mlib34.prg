// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib34.prg
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



#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKESP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKESP( cVAR, nTIP, nARQ )

   LOCAL lRETU := .F.

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF nARQ = 1
      IF !USEREDE( "FI_SER", 1, 1 )
         RETU .F.
      ENDIF
   ELSE
      IF !USEREDE( "FI_ESP", 1, 1 )
         RETU .F.
      ENDIF
   ENDIF
   dbGoTop()
   IF dbSeek( cVAR )
      DO CASE
      CASE TIPSER = "T"
         lRETU := .T.
      CASE TIPSER = "1" .AND. nTIP = 1
         lRETU := .T.
      CASE TIPSER = "2" .AND. nTIP = 2
         lRETU := .T.
      CASE TIPSER = "3" .AND. nTIP = 3
         lRETU := .T.
      CASE TIPSER = "A" .AND. nTIP = 1
         lRETU := .T.
      CASE TIPSER = "A" .AND. nTIP = 2
         lRETU := .T.
      CASE TIPSER = "B" .AND. nTIP = 1
         lRETU := .T.
      CASE TIPSER = "B" .AND. nTIP = 3
         lRETU := .T.
      CASE TIPSER = "C" .AND. nTIP = 2
         lRETU := .T.
      CASE TIPSER = "C" .AND. nTIP = 3
         lRETU := .T.
      ENDCASE
   ENDIF
   dbCloseArea()
   IF !lRETU
      IF nARQ = 1
         ALERTX( "S‚rie n„o Cadastrada, ou incosistente para o movimento" )
      ELSE
         ALERTX( "Esp‚cie n„o Cadastrada, ou incosistente para o movimento" )
      ENDIF
   ENDIF
   RETU lRETU

// *********************************************************
// cCFO - codigo de operacao
// nTIP - 1 Entrada 2- Saida
// cUFREF - Estado a checar
// cUFEMP - Estado do Sistema
// nROW - Linha de Exibicao
// nCOL - Coluna de Exibicao
// mDIGA - Dizeres a Exibir (Macro)
// mVARICM - Variavel a Receber valor ICM
// mVARDIPAM - Variavel Recevber Dipam
// *********************************************************



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCFO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CHECKCFO( cCFO, nTIP, cUFREF, cUFEMP, nROW, nCOL, mDIGA, mVARICM, mVARDIPAM, mVARCFO, mVARCFO2, nBUSCA, lREP )

   LOCAL cCONF := "1"

   IF ValType( lREP ) # "L"
      lREP := .F.
   ENDIF
   IF Empty( cCFO )
      MDS( "CFO nÆo preenchido" )
      RETU .F.
   ENDIF
   IF ValType( nBUSCA ) # "N"
      nBUSCA := 3  // Cfo Velho
   ENDIF
   IF ValType( cUFEMP ) # "C"
      cUFEMP := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
   ENDIF
   IF ValType( nROW ) # "N"
      nROW := 24
   ENDIF
   IF ValType( nCOL ) # "N"
      nCOL := 0
   ENDIF
   IF ValType( mDIGA ) # "C"
      mDIGA := "LEFT(DESCRICAO,40)"
   ENDIF
   DO CASE
   CASE cUFREF = cUFEMP .AND. nTIP = 1
      cCONF := "1"
   CASE cUFREF # cUFEMP .AND. cUFREF <> 'XX' .AND. nTIP = 1
      cCONF := "2"
   CASE cUFREF = 'XX' .AND. nTIP = 1
      cCONF := "3"
   CASE cUFREF = cUFEMP .AND. nTIP = 2
      cCONF := "5"
   CASE cUFREF # cUFEMP .AND. cUFREF <> 'XX' .AND. nTIP = 2
      cCONF := "6"
   CASE cUFREF = 'XX' .AND. nTIP = 2
      cCONF := "7"
   ENDCASE
   IF SubStr( cCFO, 1, 1 ) # cCONF
      DO CASE
      CASE cCONF = "1"
         ALERTX( 'C¢digo Fiscal de opera‡„o DENTRO do Estado deve come‡ar com 1' )
      CASE cCONF = "2"
         ALERTX( 'C¢digo Fiscal de opera‡„o FORA do Estado deve come‡ar com 2' )
      CASE cCONF = "3"
         ALERTX( 'C¢digo Fiscal de opera‡„o EXTERIOR deve come‡ar com 3' )
      CASE cCONF = "5"
         ALERTX( 'C¢digo Fiscal de opera‡„o DENTRO do Estado deve come‡ar com 5' )
      CASE cCONF = "6"
         ALERTX( 'C¢digo Fiscal de opera‡„o FORA do Estado deve come‡ar com 6' )
      CASE cCONF = "7"
         ALERTX( 'C¢digo Fiscal de opera‡„o EXTERIOR deve come‡ar com 7' )
      ENDCASE
      RETU .F.
   ENDIF
   IF ValType( mVARICM ) = "C"
      &mVARICM. := OBTER( "MD05", mUFREF, "ALIQUOTA" )
   ENDIF
   IF Empty( cCFO )
      RETU MDG( 'Aceitar C¢digo Fiscal de opera‡„o Nulo' )
   ENDIF
   IF nBUSCA = 3
      cCFO3 := Left( cCFO, 3 )
   ELSE
      cCFO3 := cCFO
   ENDIF
   IF !VERSEHA( "MD04", cCFO3, mDIGA, "'C¢digo CFO N„o Cadastrado'", .T., nBUSCA, nROW, nCOL )
      RETU MDG( "C¢digo Fiscal de Opera‡„o n„o Cadastrado Aceitar" )
   ENDIF
   IF ValType( mVARDIPAM ) = "C"
      IF Empty( &mVARDIPAM. )
         &mVARDIPAM. := OBTER( "MD04", cCFO3, "DIPAM", nBUSCA )
      ENDIF
   ENDIF
   IF nBUSCA = 1
      IF ValType( mVARCFO ) = "C" .OR. lREP
         IF Empty( &mVARCFO. )
            &mVARCFO. := OBTER( "MD04", cCFO3, "CFONEW", nBUSCA )
         ENDIF
      ENDIF
      IF ValType( mVARCFO2 ) = "C" .AND. !Empty( SubStr( cCFO, 5 ) )
         IF Empty( &mVARCFO2. )
            &mVARCFO2. := OBTER( "MD04", SubStr( cCFO, 5 ), "CFONEW", nBUSCA )
         ENDIF
      ENDIF
   ELSE
      IF ValType( mVARCFO ) = "C"
         IF Empty( &mVARCFO. ) .OR. lREP
            &mVARCFO. := OBTER( "MD04", cCFO3, "CFO", nBUSCA )
         ENDIF
      ENDIF
   ENDIF
   RETU .T.




// + EOF: mlib34.prg
// +
