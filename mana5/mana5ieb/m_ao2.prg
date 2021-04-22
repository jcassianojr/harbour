*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\ITAESBRA\M_AO2.PRG
*+
*+    Functions: Function tMAO2()
*+               Function gMAO2()
*+               Function MO02K()
*+               Function LISTAP()
*+               Function MAOPED()
*+               Function MAOHOR()
*+               Function MAOHOR2()
*+               Function MAOHOR3()
*+               Function MAO203()
*+               Function MAO204()
*+
*+    Reformatted by Click! 2.03 on Feb-20-2006 at 11:13 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
#INCLUDE "BOX.CH"

//Variaveis de Trabalho
priv PCK           := .F.
priv mCHAVE
priv INCLUI
public xyFORNECEDO
mESTOQUE := 0.00
mPESUNI  := 0.000
INCLUI   := .F.
mITEM    := 1
mCHAVE   := str( mPEDIDO, 8, 2 ) + str( mITEM, 2 )


if ! IGUALVARS( cAMO2, mCHAVE,1,.F. ) //Nao achou inclui
   // CRIARVARS( "MO02" )
   mPEDIDO   := xPEDIDO
   mITEM     := 1
   mCHAVE    := str( mPEDIDO, 8, 2 ) + str( mITEM, 2 )
   mTIPOSERV := "1"
   mPESOUNI  := 0
   mCONSUMO  := "N"
   mGERAOF   := "N"
   mPEDMEN   := "N"
   //if USEREDE( "OSCRT", 1, 1 )
//      dbgotop()
//      if dbseek( int( mPEDIDO ) )
//         mCODIGO := CODIGO
//      endif
//      dbclosearea()
//   endif
   if !NOVOREG( cAMO2, mCHAVE )
      retu .F.
   endif
   INCLUI := .T.
endif
if mFATURA = "S"
   ALERTX( "OS Sendo Faturada - Altera_ o Bloqueada" )
   retu
endif
mFORNECEDO := xFORNECEDO
mCOGNOME   := xCOGNOME
mPEDIDO    := xPEDIDO
mOS        := xOS
mVENDEDOR  := xVENDEDOR
mCOMISSAO  := xCOMISSAO
mZONA      := xZONA
mDATA      := xDATA
mICM       := xICM
if mBAIXAM = "S" .and. empty( mDATAIMP )
   mDATAIMP := ZDATA
endif

//Guarda Variaveis de Referencia
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
        .or. PEGACAMPO( "MRMS", "mCODIGO+STR(0,8)", { "CODMR01", "PCEMB" }, { "mCODMR01", "mPCEMB" } ) )

CALCVAR( "mPCEMBQ", CEILING( ( CONVUN( mQTDEPRE, mUNID ) - 1 ) / mPCEMB ), 24, 0, "9999999999" )

REPORVARS( cAMO2, mCHAVE )

if INCLUI           //Criando ordem Fabricacao
   mOF   := mOS
   cUNID := mUNID
   if mGERAOF = "S"
      if cVIDE = "T"
         MAOF03(, .F., .F. )
      else
         MAOF03(, .T., .F. )
      endif
      mCLIENTE := xFORNECEDO
      mCOGNOME := xCOGNOME
      NOVOREG( "OF01", str( mOF, 8, 2 ) + str( mITEM, 3 ) )
   endif
endif

if wQTDEPED # mQTDEPED .and. mGERAOF = "S"
   MDS( "Aguarde Reprocessando ordem de Fabricacao" )
   mOF := mOS
   APAGAREG( "OF01", str( mOS, 8, 2 ) + str( mITEM, 3 ), .F., .F.,, .F. )
   MAOFDEL()
   cUNID := mUNID
   MAOF03(, .T., .F. )
   mCLIENTE := xFORNECEDO
   mCOGNOME := xCOGNOME
   NOVOREG( "OF01", str( mOF, 8, 2 ) + str( mITEM, 3 ) )
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tMAO2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func tMAO2          //Tela de Dados
HB_dispbox( 2, 0, 23, 79, " -   -   " )
@  5,  0 say ' '
@  5, 79 say ' '
@  3,  2 say "Pedido   Cliente" + spac( 12 ) + "Item C_digo" + spac( 19 ) + "Entregar Hora  Pt"
@  5,  1 say replicate( '-', 78 )
@  6,  2 say "Tipo   1-Prod  3-MO.Prod Un Comprador L.Pre_o DataBase Indice" + spac( 7 ) + "Consumo"
@  7,  9 say "2-Ferr  4-MO.Ferr" + spac( 46 ) + "(S/N)"
@  8,  2 say "Nome" + spac( 37 ) + "Peso" + spac( 6 ) + "IPI"
@ 11, 16 say "Qtde" + spac( 36 ) + "Horas:"
@ 12,  7 say "Pedido:" + spac( 33 ) + "Pedido:"
@ 13,  5 say "Entregue:" + spac( 31 ) + "Entregue:"
@ 14,  8 say "Saldo:" + spac( 34 ) + "Saldo:"
@ 15,  5 say "Fabricar:"
@ 17,  2 say "Pre_o Unit.:" + spac( 30 ) + "Gera OF:"
@ 18,  2 say "Total Merc.:" + spac( 30 ) + "Pedido Mensal:"
@ 19,  2 say "Valor IPI  :" + spac( 30 ) + "Data Imp/Lcto:"
@ 20,  2 say "Total Item :"
@ 22,  2 say "Obs:"
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function gMAO2()
*+
*+    Called from ( m_ao2.prg    )   1 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func gMAO2          // Get nas Menvars
@  3,  2 say "Pedido     Cliente"
@  4,  2 say mPEDIDO
@  4, 11 say mFORNECEDO           pict "99999"
@  4, 17 say mCOGNOME
@  4, 35 get mCODIGO              valid MO02K()
@  4, 60 get mENTREGA
@  4, 69 get mHORAPRG
@  4, 75 get mPLANTA
@  6,  7 get mTIPOSERV            valid CHECKTAB( "TIPSERV", "mTIPOSERV", "TIPSER",, "LEFT(CODIGO1,1)" ) .and. MMDEV()
@  7, 27 get mUNID                pict '@!'                                                                            valid CHECKEXI( "MD07", "mUNID", "UNIDADE+' '+UNIDDES", "UNIDADE", "UNIDADE" )
@  7, 30 get mCOMPRA
@  7, 40 get mLISTA               valid MO02K()                                                                        when ALLTRUE( if( empty( mLISTA ), mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" ), .T. ) ) pict "99999"
@  7, 48 get mDATABASE
@  7, 57 get mINDICE              pict "@!"                                                                            valid empty( mINDICE ) .or. VERSEHA( "MD01", mINDICE, "mNOME", "'XTABIND'", .T., 1, 24, 00 )
@  7, 70 get mCONSUMO             pict "!"                                                                             valid mCONSUMO $ 'SN' .and. MO02K()
@  9,  2 get mNOME
@  9, 43 get mPESOUNI             pict "999.999"
@  9, 53 get mCODIPI              valid CKEMPTY( mCODIPI ) .or. CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM" )      when MAO204()
@  9, 56 get mIPI                 when empty( mCODIPI )                                                                valid CKEMPTY( mIPI )
@  9, 59 get mCLASSIPI            when empty( mCODIPI )                                                                valid CHECKIPI( mCLASSIPI )
READCUR()
do case
case mUNID = 'CT'
   @ 12, 14 get mQTDEPED  pict "99999.99" valid MAOPED() .and. MAO203()
   @ 13, 14 get mQTDEENT  pict "99999.99" valid MAOPED()
   @ 15, 14 get mFABRICAR pict "99999.99"
case mUNID = 'ML'
   @ 12, 14 get mQTDEPED  pict "99999.999" valid MAOPED() .and. MAO203()
   @ 13, 14 get mQTDEENT  pict "99999.999" valid MAOPED()
   @ 15, 14 get mFABRICAR pict "99999.999"
case mUNID = 'HR'
   @ 12, 54 get mHORAPED pict "99999.999" valid MAOHOR()
   @ 13, 54 get mHORAENT pict "99999.999" valid MAOHOR2()
   @ 14, 54 get mHORASAL pict "99999.999" valid MAOHOR3()
otherwise
   @ 12, 14 get mQTDEPED  pict "999999" valid MAOPED() .and. MAO203()
   @ 13, 14 get mQTDEENT  pict "999999" valid MAOPED()
   @ 15, 14 get mFABRICAR pict "999999"
endcase
if sMAO201
   if empty( mINDICE )
      @ 17, 15 get mVALOR pict "999,999.9999" valid LISTAP()
   else
      @ 17, 15 get mVALIND pict "999,999.9999" valid PREIND( mINDICE, ZDATA,, { | nTEMPVAL | mVALOR := round( mVALIND * nTEMPVAL, 4 ) } ) .and. LISTAP()
   endif
endif
@ 17, 53 get mGERAOF    pict "!" valid mGERAOF $ "SN " when ALLTRUE( if( empty( mGERAOF ), mGERAOF := "N", ) ) .and. INCLUI
@ 18, 59 get mPEDMEN    pict "!" valid mPEDMEN $ "SN"
@ 19, 59 say mDATAIMP
@ 22,  7 get mOBSERVACA
READCUR()
if mCOGNOME = "AUTOLATINA"
   HB_dispbox( 7, 0, 23, 79, " -   -   " )
   @  8,  3 say "Dados Complementares para a AUTOLATINA"
   @ 10,  3 say "Numero da OS     :"
   @ 12,  3 say "Setor" + spac( 12 ) + ":"
   @ 14,  3 say "Tipo de Material :"
   @ 16,  3 say "Detalhe" + spac( 10 ) + ":"
   @ 10, 23 get mALOS
   @ 12, 23 get mALSE
   @ 14, 23 get mALMA
   @ 16, 23 get mALDE
   READCUR()
endif
if mCOGNOME = "MERCEDES"
   HB_dispbox( 6, 15, 15, 57, " -   -   " )
   @  7, 18 say "Mercedes Bens:"
   @  9, 18 say "N_mero    :"
   @ 11, 18 say "Protocolo :"
   @  9, 30 say mMBBN
   @ 11, 30 say mMBBP
   READCUR()
endif
retu .T.

// ****************************************************************************

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MO02K()
*+
*+    Called from ( m_ao2.prg    )   3 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MO02K

// ****************************************************************************
if empty( mCODIGO )
   ALERTX( "Codigo Produto em Branco" )
   retu .F.
endif
if !PEGACAMPO( "MS01", "mCODIGO", { "NOME", "CODIPI", "UNID", "PESOUNI", "PLT" }, ;
               { "mNOME", "mCODIPI", "mUNID", "mPESOUNI", "mPLANTA" }, 2 )
   ALERTX( "Produto N o Encontrado" )
   retu .F.
endif
if empty( mLISTA )
   mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" )
endif
aPRC      := MS02PRC( mCODIGO, mLISTA, .T., "mUNID", "mCODIPI" )
mVALOR    := aPRC[ 1 ]
mDATABASE := aPRC[ 3 ]
CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
if mUNID = "HR"
   mVALORMER := mHORASAL * mVALOR
else
   mVALORMER := mQTDESAL * mVALOR
endif
mVALORIPI := PER2( mVALORMER, mIPI )
mVALORTOT := mVALORMER + mVALORIPI
if mCONSUMO = 'S'
   mVALORICM := PER2( mVALORTOT, mICM )
   mBASEICM  := mVALORTOT
else
   mVALORICM := PER2( mVALORMER, mICM )
   mBASEICM  := mVALORMER
endif
MAOPED()
mBASEIPI := mVALORMER
if empty( mPLANTA )
   PEGACAMPO( "MA01", "mFORNECEDO", { "PLANTA" }, { "mPLANTA" } )
endif
retu .T.

// ****************************************************************************

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function LISTAP()
*+
*+    Called from ( m_ao2.prg    )   2 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func LISTAP         //Pega peso, valor... da Lista Preco pela DataBase

// ****************************************************************************
xyDATABASE := xBASE                     //VARIAVEIS DO M_AO1.PRG
if xCODIGO # mCODIGO .or. empty( xCODIGO ) .or. empty( mNOME )
   cUNIDE := mUNID
   lRETU  := .F.
   while !USEREDE( "MS01", 1, 2 )
   enddo
   dbgotop()
   xyFORNECEDO := mFORNECEDO            // Salvando variaveis
   mFORNECEDO  := mLISTA
   xCHAVE      := mCODIGO
   if !dbseek( xCHAVE )
      dbclosearea()
      MDE( "PRODU", "", "" )
      mFORNECEDO := xyFORNECEDO
      if mUNID = "HR"
         mVALORMER := mHORASAL * mVALOR
      else
         mVALORMER := mQTDESAL * mVALOR
      endif
      mVALORIPI := PER2( mVALORMER, mIPI )
      mVALORTOT := mVALORMER + mVALORIPI
      if mCONSUMO = 'S'
         mVALORICM := PER2( mVALORTOT, mICM )
         mBASEICM  := mVALORTOT
      else
         mVALORICM := PER2( mVALORMER, mICM )
         mBASEICM  := mVALORMER
      endif
      MAOPED()
      mBASEIPI := mVALORMER
      retu .T.
   endif
   mNOME    := NOME
   mUNID    := UNID
   mCODIPI  := alltrim( CODIPI )
   mPESOUNI := PESOUNI
   mPLANTA  := PLT
   cUNIDE   := mUNID
   dbclosearea()
   while !USEREDE( "MS02", 1, 5 )       //cODIGO LISTA DATA
   enddo
   dbgotop()
   if dbseek( mCODIGO + str( mFORNECEDO ) + dtos( xyDATABASE ) )
      lRETU := .T.
      if empty( mINDICE )
         mVALOR := VALOR
      else
         mVALIND := VALOR
      endif
      mDATABASE := DATA
      cUNIDE    := UNIDE
   endif
   mFORNECEDO := xyFORNECEDO            // Voltando variaveis salvas acima
   dbclosearea()
   if !empty( cUNIDE )
      mUNID := cUNIDE
   endif
   CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
endif
if mUNID = "HR"
   mVALORMER := mHORASAL * mVALOR
else
   mVALORMER := mQTDESAL * mVALOR
endif
mVALORIPI := PER2( mVALORMER, mIPI )
mVALORTOT := mVALORMER + mVALORIPI
if mCONSUMO = 'S'
   mVALORICM := PER2( mVALORTOT, mICM )
   mBASEICM  := mVALORTOT
else
   mVALORICM := PER2( mVALORMER, mICM )
   mBASEICM  := mVALORMER
endif
if empty( mPLANTA )
   PEGACAMPO( "MS01", "mCODIGO", { "PLT" }, { "mPLANTA" }, 2 )
endif
if empty( mPLANTA )
   PEGACAMPO( "MA01", "mFORNECEDO", { "PLANTA" }, { "mPLANTA" } )
endif
MAOPED()
mBASEIPI := mVALORMER
retu .T.

// ****************************************************************************

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAOPED()
*+
*+    Called from ( m_ao2.prg    )   1 -
*+                                   6 - function gmao2()
*+                                   1 - function mo02k()
*+                                   2 - function listap()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAOPED

// ****************************************************************************
mQTDESAL := mQTDEPED - mQTDEENT
do case
case mUNID = 'CT'
   @ 14, 14 say mQTDESAL pict "99999.99"
case mUNID = 'ML'
   @ 14, 14 say mQTDESAL pict "99999.999"
case mUNID = 'HR'
   @ 14, 54 say mHORASAL pict "99999.999"
otherwise
   @ 14, 14 say mQTDESAL pict "999999"
endcase
if sMAO201
   @ 18, 15 say mVALORMER pict "999,999.99"
   @ 19, 15 say mVALORIPI pict "999,999.99"
   @ 20, 15 say mVALORTOT pict "999,999.99"
   if empty( mINDICE )
      @ 17, 15 say mVALOR pict "999,999.9999"
   else
      @ 17, 15 say mVALIND pict "999,999.9999"
   endif
endif
retu .T.

// ****************************************************************************

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAOHOR()
*+
*+    Called from ( m_ao2.prg    )   1 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAOHOR         //Se Saldo em Horas for vazio Joga pedidos hora nele.

// ****************************************************************************
if empty( mHORASAL ) .and. empty( mHORAENT )
   mHORASAL := mHORAPED
endif
@ 14, 54 say mHORASAL pict "99999.999"
retu .T.

// ****************************************************************************

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAOHOR2()
*+
*+    Called from ( m_ao2.prg    )   1 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAOHOR2        //ACHA SALDO

// ****************************************************************************
mHORASAL := mHORAPED - mHORAENT
retu .T.

// ****************************************************************************

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAOHOR3()
*+
*+    Called from ( m_ao2.prg    )   1 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAOHOR3        //Calcula o Saldo atrav_s da Qtde.em Horas do Pedido.

// ****************************************************************************
if !empty( mHORAPED ) .and. !empty( mHORASAL )
   mHORAENT := mHORAPED - mHORASAL
endif
@ 12, 54 say mHORAPED pict "99999.999"
@ 13, 54 say mHORAENT pict "99999.999"
@ 14, 54 say mHORASAL pict "99999.999"
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAO203()
*+
*+    Called from ( m_ao2.prg    )   3 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAO203

local nMINIMO := 0
mMINIMO := CONVUN( mQTDEPED, mUNID )
if OBTER( "MS01", mCODIGO, "LMINIMO", 2 ) < nMINIMO
   if !MDG( "Pedido Inferior ao Lote Minimo Aceitar" )
      retu .F.
   endif
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAO204()
*+
*+    Called from ( m_ao2.prg    )   1 - function gmao2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAO204

if empty( mCODIPI )
   PEGACAMPO( "MS01", "mCODIGO", { "CODIPI" }, { "mCODIPI" }, 2 )
endif
retu .T.

*+ EOF: M_AO2.PRG
