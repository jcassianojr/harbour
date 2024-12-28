// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ao2.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => C:\DEVELOP\ITAESBRA\M_AO2.PRG
// +
// +    Functions: Function tMAO2()
// +               Function gMAO2()
// +               Function MO02K()
// +               Function LISTAP()
// +               Function MAOPED()
// +               Function MAOHOR()
// +               Function MAOHOR2()
// +               Function MAOHOR3()
// +               Function MAO203()
// +               Function MAO204()
// +
// +    Reformatted by Click! 2.03 on Feb-20-2006 at 11:13 am
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
#include "BOX.CH"

// Variaveis de Trabalho
PRIV PCK           := .F.
PRIV mCHAVE
PRIV INCLUI
PUBLIC xyFORNECEDO
mESTOQUE := 0.00
mPESUNI  := 0.000
INCLUI   := .F.
mITEM    := 1
mCHAVE   := Str( mPEDIDO, 8, 2 ) + Str( mITEM, 2 )


IF !IGUALVARS( cAMO2, mCHAVE, 1, .F. )   // Nao achou inclui
// CRIARVARS( "MO02" )
mPEDIDO   := xPEDIDO
mITEM     := 1
mCHAVE    := Str( mPEDIDO, 8, 2 ) + Str( mITEM, 2 )
mTIPOSERV := "1"
mPESOUNI  := 0
mCONSUMO  := "N"
mGERAOF   := "N"
mPEDMEN   := "N"
// if USEREDE( "OSCRT", 1, 1 )
// dbgotop()
// if dbseek( int( mPEDIDO ) )
// mCODIGO := CODIGO
// endif
// dbclosearea()
// endif
IF !NOVOREG( cAMO2, mCHAVE )
RETU .F.
ENDIF
INCLUI := .T.
ENDIF
IF mFATURA = "S"
ALERTX( "OS Sendo Faturada - Altera_ o Bloqueada" )
RETU
ENDIF
mFORNECEDO := xFORNECEDO
mCOGNOME   := xCOGNOME
mPEDIDO    := xPEDIDO
mOS        := xOS
mVENDEDOR  := xVENDEDOR
mCOMISSAO  := xCOMISSAO
mZONA      := xZONA
mDATA      := xDATA
mICM       := xICM
IF mBAIXAM = "S" .AND. Empty( mDATAIMP )
mDATAIMP := ZDATA
ENDIF

// Guarda Variaveis de Referencia
xCODIGO  := mCODIGO
yCODIGO  := mCODIGO
wQTDEPED := mQTDEPED
xQTDESAL := mQTDESAL
MAOPED()

// Desenha a Tela
tMAO2()
// Get nas Menvars
gMAO2()

ALLTRUE( PEGACAMPO( "MRMS", "mCODIGO+STR(mFORNECEDO,8)", { "CODMR01", "PCEMB" }, { "mCODMR01", "mPCEMB" } ) ;
      .OR. PEGACAMPO( "MRMS", "mCODIGO+STR(0,8)", { "CODMR01", "PCEMB" }, { "mCODMR01", "mPCEMB" } ) )

CALCVAR( "mPCEMBQ", CEILING( ( CONVUN( mQTDEPRE, mUNID ) - 1 ) / mPCEMB ), 24, 0, "9999999999" )

REPORVARS( cAMO2, mCHAVE )

IF INCLUI   // Criando ordem Fabricacao
mOF   := mOS
cUNID := mUNID
IF mGERAOF = "S"
IF cVIDE = "T"
MAOF03(, .F., .F. )
ELSE
MAOF03(, .T., .F. )
ENDIF
mCLIENTE := xFORNECEDO
mCOGNOME := xCOGNOME
NOVOREG( "OF01", Str( mOF, 8, 2 ) + Str( mITEM, 3 ) )
ENDIF
ENDIF

IF wQTDEPED # mQTDEPED .AND. mGERAOF = "S"
MDS( "Aguarde Reprocessando ordem de Fabricacao" )
mOF := mOS
APAGAREG( "OF01", Str( mOS, 8, 2 ) + Str( mITEM, 3 ), .F., .F.,, .F. )
MAOFDEL()
cUNID := mUNID
MAOF03(, .T., .F. )
mCLIENTE := xFORNECEDO
mCOGNOME := xCOGNOME
NOVOREG( "OF01", Str( mOF, 8, 2 ) + Str( mITEM, 3 ) )
ENDIF
RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function tMAO2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tMAO2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC tMAO2  // Tela de Dados

   hb_DispBox( 2, 0, 23, 79, " -   -   " )
   @  5, 0  SAY ' '
   @  5, 79 SAY ' '
   @  3, 2  SAY "Pedido   Cliente" + spac( 12 ) + "Item C_digo" + spac( 19 ) + "Entregar Hora  Pt"
   @  5, 1  SAY Replicate( '-', 78 )
   @  6, 2  SAY "Tipo   1-Prod  3-MO.Prod Un Comprador L.Pre_o DataBase Indice" + spac( 7 ) + "Consumo"
   @  7, 9  SAY "2-Ferr  4-MO.Ferr" + spac( 46 ) + "(S/N)"
   @  8, 2  SAY "Nome" + spac( 37 ) + "Peso" + spac( 6 ) + "IPI"
   @ 11, 16 SAY "Qtde" + spac( 36 ) + "Horas:"
   @ 12, 7  SAY "Pedido:" + spac( 33 ) + "Pedido:"
   @ 13, 5  SAY "Entregue:" + spac( 31 ) + "Entregue:"
   @ 14, 8  SAY "Saldo:" + spac( 34 ) + "Saldo:"
   @ 15, 5  SAY "Fabricar:"
   @ 17, 2  SAY "Pre_o Unit.:" + spac( 30 ) + "Gera OF:"
   @ 18, 2  SAY "Total Merc.:" + spac( 30 ) + "Pedido Mensal:"
   @ 19, 2  SAY "Valor IPI  :" + spac( 30 ) + "Data Imp/Lcto:"
   @ 20, 2  SAY "Total Item :"
   @ 22, 2  SAY "Obs:"
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function gMAO2()
// +
// +    Called from ( m_ao2.prg    )   1 -
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAO2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAO2  // Get nas Menvars

   @  3, 2  SAY "Pedido     Cliente"
   @  4, 2  SAY mPEDIDO
   @  4, 11 SAY mFORNECEDO           PICT "99999"
   @  4, 17 SAY mCOGNOME
   @  4, 35 GET mCODIGO              VALID MO02K()
   @  4, 60 GET mENTREGA
   @  4, 69 GET mHORAPRG
   @  4, 75 GET mPLANTA
   @  6, 7  GET mTIPOSERV            VALID CHECKTAB( "TIPSERV", "mTIPOSERV", "TIPSER",, "LEFT(CODIGO1,1)" ) .AND. MMDEV()
   @  7, 27 GET mUNID                PICT '@!'                                                                       VALID CHECKEXI( "MD07", "mUNID", "UNIDADE+' '+UNIDDES", "UNIDADE", "UNIDADE" )
   @  7, 30 GET mCOMPRA
   @  7, 40 GET mLISTA               VALID MO02K()                                                                   WHEN ALLTRUE( if( Empty( mLISTA ), mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" ), .T. ) ) PICT "99999"
   @  7, 48 GET mDATABASE
   @  7, 57 GET mINDICE              PICT "@!"                                                                       VALID Empty( mINDICE ) .OR. VERSEHA( "MD01", mINDICE, "mNOME", "'XTABIND'", .T., 1, 24, 00 )
   @  7, 70 GET mCONSUMO             PICT "!"                                                                        VALID mCONSUMO $ 'SN' .AND. MO02K()
   @  9, 2  GET mNOME
   @  9, 43 GET mPESOUNI             PICT "999.999"
   @  9, 53 GET mCODIPI              VALID CKEMPTY( mCODIPI ) .OR. CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM" )        WHEN MAO204()
   @  9, 56 GET mIPI                 WHEN Empty( mCODIPI )                                                             VALID CKEMPTY( mIPI )
   @  9, 59 GET mCLASSIPI            WHEN Empty( mCODIPI )                                                             VALID CHECKIPI( mCLASSIPI )
   READCUR()
   DO CASE
   CASE mUNID = 'CT'
      @ 12, 14 GET mQTDEPED  PICT "99999.99" VALID MAOPED() .AND. MAO203()
      @ 13, 14 GET mQTDEENT  PICT "99999.99" VALID MAOPED()
      @ 15, 14 GET mFABRICAR PICT "99999.99"
   CASE mUNID = 'ML'
      @ 12, 14 GET mQTDEPED  PICT "99999.999" VALID MAOPED() .AND. MAO203()
      @ 13, 14 GET mQTDEENT  PICT "99999.999" VALID MAOPED()
      @ 15, 14 GET mFABRICAR PICT "99999.999"
   CASE mUNID = 'HR'
      @ 12, 54 GET mHORAPED PICT "99999.999" VALID MAOHOR()
      @ 13, 54 GET mHORAENT PICT "99999.999" VALID MAOHOR2()
      @ 14, 54 GET mHORASAL PICT "99999.999" VALID MAOHOR3()
   OTHERWISE
      @ 12, 14 GET mQTDEPED  PICT "999999" VALID MAOPED() .AND. MAO203()
      @ 13, 14 GET mQTDEENT  PICT "999999" VALID MAOPED()
      @ 15, 14 GET mFABRICAR PICT "999999"
   ENDCASE
   IF sMAO201
      IF Empty( mINDICE )
         @ 17, 15 GET mVALOR PICT "999,999.9999" VALID LISTAP()
      ELSE
         @ 17, 15 GET mVALIND PICT "999,999.9999" VALID PREIND( mINDICE, ZDATA,, {| nTEMPVAL | mVALOR := Round( mVALIND * nTEMPVAL, 4 ) } ) .AND. LISTAP()
      ENDIF
   ENDIF
   @ 17, 53 GET mGERAOF    PICT "!" VALID mGERAOF $ "SN " WHEN ALLTRUE( if( Empty( mGERAOF ), mGERAOF := "N", ) ) .AND. INCLUI
   @ 18, 59 GET mPEDMEN    PICT "!" VALID mPEDMEN $ "SN"
   @ 19, 59 SAY mDATAIMP
   @ 22, 7  GET mOBSERVACA
   READCUR()
   IF mCOGNOME = "AUTOLATINA"
      hb_DispBox( 7, 0, 23, 79, " -   -   " )
      @  8, 3  SAY "Dados Complementares para a AUTOLATINA"
      @ 10, 3  SAY "Numero da OS     :"
      @ 12, 3  SAY "Setor" + spac( 12 ) + ":"
      @ 14, 3  SAY "Tipo de Material :"
      @ 16, 3  SAY "Detalhe" + spac( 10 ) + ":"
      @ 10, 23 GET mALOS
      @ 12, 23 GET mALSE
      @ 14, 23 GET mALMA
      @ 16, 23 GET mALDE
      READCUR()
   ENDIF
   IF mCOGNOME = "MERCEDES"
      hb_DispBox( 6, 15, 15, 57, " -   -   " )
      @  7, 18 SAY "Mercedes Bens:"
      @  9, 18 SAY "N_mero    :"
      @ 11, 18 SAY "Protocolo :"
      @  9, 30 SAY mMBBN
      @ 11, 30 SAY mMBBP
      READCUR()
   ENDIF
   RETU .T.

// ****************************************************************************

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MO02K()
// +
// +    Called from ( m_ao2.prg    )   3 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MO02K()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MO02K

// ****************************************************************************
   IF Empty( mCODIGO )
      ALERTX( "Codigo Produto em Branco" )
      RETU .F.
   ENDIF
   IF !PEGACAMPO( "MS01", "mCODIGO", { "NOME", "CODIPI", "UNID", "PESOUNI", "PLT" }, ;
         { "mNOME", "mCODIPI", "mUNID", "mPESOUNI", "mPLANTA" }, 2 )
      ALERTX( "Produto N o Encontrado" )
      RETU .F.
   ENDIF
   IF Empty( mLISTA )
      mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" )
   ENDIF
   aPRC      := MS02PRC( mCODIGO, mLISTA, .T., "mUNID", "mCODIPI" )
   mVALOR    := aPRC[ 1 ]
   mDATABASE := aPRC[ 3 ]
   CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
   IF mUNID = "HR"
      mVALORMER := mHORASAL * mVALOR
   ELSE
      mVALORMER := mQTDESAL * mVALOR
   ENDIF
   mVALORIPI := PER2( mVALORMER, mIPI )
   mVALORTOT := mVALORMER + mVALORIPI
   IF mCONSUMO = 'S'
      mVALORICM := PER2( mVALORTOT, mICM )
      mBASEICM  := mVALORTOT
   ELSE
      mVALORICM := PER2( mVALORMER, mICM )
      mBASEICM  := mVALORMER
   ENDIF
   MAOPED()
   mBASEIPI := mVALORMER
   IF Empty( mPLANTA )
      PEGACAMPO( "MA01", "mFORNECEDO", { "PLANTA" }, { "mPLANTA" } )
   ENDIF
   RETU .T.

// ****************************************************************************

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function LISTAP()
// +
// +    Called from ( m_ao2.prg    )   2 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTAP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC LISTAP   // Pega peso, valor... da Lista Preco pela DataBase

// ****************************************************************************
   xyDATABASE := xBASE   // VARIAVEIS DO M_AO1.PRG
   IF xCODIGO # mCODIGO .OR. Empty( xCODIGO ) .OR. Empty( mNOME )
      cUNIDE := mUNID
      lRETU  := .F.
      WHILE !USEREDE( "MS01", 1, 2 )
      ENDDO
      dbGoTop()
      xyFORNECEDO := mFORNECEDO  // Salvando variaveis
      mFORNECEDO  := mLISTA
      xCHAVE      := mCODIGO
      IF !dbSeek( xCHAVE )
         dbCloseArea()
         MDE( "PRODU", "", "" )
         mFORNECEDO := xyFORNECEDO
         IF mUNID = "HR"
            mVALORMER := mHORASAL * mVALOR
         ELSE
            mVALORMER := mQTDESAL * mVALOR
         ENDIF
         mVALORIPI := PER2( mVALORMER, mIPI )
         mVALORTOT := mVALORMER + mVALORIPI
         IF mCONSUMO = 'S'
            mVALORICM := PER2( mVALORTOT, mICM )
            mBASEICM  := mVALORTOT
         ELSE
            mVALORICM := PER2( mVALORMER, mICM )
            mBASEICM  := mVALORMER
         ENDIF
         MAOPED()
         mBASEIPI := mVALORMER
         RETU .T.
      ENDIF
      mNOME    := NOME
      mUNID    := UNID
      mCODIPI  := AllTrim( CODIPI )
      mPESOUNI := PESOUNI
      mPLANTA  := PLT
      cUNIDE   := mUNID
      dbCloseArea()
      WHILE !USEREDE( "MS02", 1, 5 )   // cODIGO LISTA DATA
      ENDDO
      dbGoTop()
      IF dbSeek( mCODIGO + Str( mFORNECEDO ) + DToS( xyDATABASE ) )
         lRETU := .T.
         IF Empty( mINDICE )
            mVALOR := VALOR
         ELSE
            mVALIND := VALOR
         ENDIF
         mDATABASE := DATA
         cUNIDE    := UNIDE
      ENDIF
      mFORNECEDO := xyFORNECEDO  // Voltando variaveis salvas acima
      dbCloseArea()
      IF !Empty( cUNIDE )
         mUNID := cUNIDE
      ENDIF
      CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
   ENDIF
   IF mUNID = "HR"
      mVALORMER := mHORASAL * mVALOR
   ELSE
      mVALORMER := mQTDESAL * mVALOR
   ENDIF
   mVALORIPI := PER2( mVALORMER, mIPI )
   mVALORTOT := mVALORMER + mVALORIPI
   IF mCONSUMO = 'S'
      mVALORICM := PER2( mVALORTOT, mICM )
      mBASEICM  := mVALORTOT
   ELSE
      mVALORICM := PER2( mVALORMER, mICM )
      mBASEICM  := mVALORMER
   ENDIF
   IF Empty( mPLANTA )
      PEGACAMPO( "MS01", "mCODIGO", { "PLT" }, { "mPLANTA" }, 2 )
   ENDIF
   IF Empty( mPLANTA )
      PEGACAMPO( "MA01", "mFORNECEDO", { "PLANTA" }, { "mPLANTA" } )
   ENDIF
   MAOPED()
   mBASEIPI := mVALORMER
   RETU .T.

// ****************************************************************************

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAOPED()
// +
// +    Called from ( m_ao2.prg    )   1 -
// +                                   6 - function gmao2()
// +                                   1 - function mo02k()
// +                                   2 - function listap()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPED()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPED

// ****************************************************************************
   mQTDESAL := mQTDEPED - mQTDEENT
   DO CASE
   CASE mUNID = 'CT'
      @ 14, 14 SAY mQTDESAL PICT "99999.99"
   CASE mUNID = 'ML'
      @ 14, 14 SAY mQTDESAL PICT "99999.999"
   CASE mUNID = 'HR'
      @ 14, 54 SAY mHORASAL PICT "99999.999"
   OTHERWISE
      @ 14, 14 SAY mQTDESAL PICT "999999"
   ENDCASE
   IF sMAO201
      @ 18, 15 SAY mVALORMER PICT "999,999.99"
      @ 19, 15 SAY mVALORIPI PICT "999,999.99"
      @ 20, 15 SAY mVALORTOT PICT "999,999.99"
      IF Empty( mINDICE )
         @ 17, 15 SAY mVALOR PICT "999,999.9999"
      ELSE
         @ 17, 15 SAY mVALIND PICT "999,999.9999"
      ENDIF
   ENDIF
   RETU .T.

// ****************************************************************************

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAOHOR()
// +
// +    Called from ( m_ao2.prg    )   1 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOHOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOHOR   // Se Saldo em Horas for vazio Joga pedidos hora nele.

// ****************************************************************************
   IF Empty( mHORASAL ) .AND. Empty( mHORAENT )
      mHORASAL := mHORAPED
   ENDIF
   @ 14, 54 SAY mHORASAL PICT "99999.999"
   RETU .T.

// ****************************************************************************

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAOHOR2()
// +
// +    Called from ( m_ao2.prg    )   1 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOHOR2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOHOR2  // ACHA SALDO

// ****************************************************************************
   mHORASAL := mHORAPED - mHORAENT
   RETU .T.

// ****************************************************************************

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAOHOR3()
// +
// +    Called from ( m_ao2.prg    )   1 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOHOR3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOHOR3  // Calcula o Saldo atrav_s da Qtde.em Horas do Pedido.

// ****************************************************************************
   IF !Empty( mHORAPED ) .AND. !Empty( mHORASAL )
      mHORAENT := mHORAPED - mHORASAL
   ENDIF
   @ 12, 54 SAY mHORAPED PICT "99999.999"
   @ 13, 54 SAY mHORAENT PICT "99999.999"
   @ 14, 54 SAY mHORASAL PICT "99999.999"
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAO203()
// +
// +    Called from ( m_ao2.prg    )   3 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAO203()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAO203

   LOCAL nMINIMO := 0

   mMINIMO := CONVUN( mQTDEPED, mUNID )
   IF OBTER( "MS01", mCODIGO, "LMINIMO", 2 ) < nMINIMO
      IF !MDG( "Pedido Inferior ao Lote Minimo Aceitar" )
         RETU .F.
      ENDIF
   ENDIF
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAO204()
// +
// +    Called from ( m_ao2.prg    )   1 - function gmao2()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAO204()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAO204

   IF Empty( mCODIPI )
      PEGACAMPO( "MS01", "mCODIGO", { "CODIPI" }, { "mCODIPI" }, 2 )
   ENDIF
   RETU .T.

// + EOF: M_AO2.PRG

// + EOF: m_ao2.prg
// +
