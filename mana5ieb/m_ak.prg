*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_AK.PRG
*+
*+    Functions: Function fMAK()
*+               Function MAKK01()
*+               Function makk02()
*+               Function makk03()
*+               Function MAKK04()
*+               Function MAKSAY02()
*+               Function MAKSAY01()
*+
*+    Reformatted by Click! 2.03 on Apr-20-2005 at  1:50 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function M_ak
para nTIPO


xPISEMP := OBTER( "MANEMP", ZNUMERO, "PERPIS" )
xFINEMP := OBTER( "MANEMP", ZNUMERO, "PERFIN" )

CRIARVARS( "FI_CIAPI" )
CRIARVARS( "FI_CIAP" )
ARQWORK1 := "MK01"
ARQWORK2 := "MK02"
ARQWORK4 := "MK06"

if nTIPO = 2
   cVAR     := MESANO()
   ARQWORK1 := "K1" + cVAR
   ARQWORK2 := "K2" + cVAR
   ARQWORK4 := "K6" + cVAR
endif

if nTIPO = 3
   ARQWORK1 := "MK91"
   ARQWORK2 := "MK92"
   ARQWORK4 := "MK96"
endif

//Telas de Trabalho
aMAKTEL := TELAPEG( "ITMK01" )
aMAKGET := EDITPEG( "ITMK01" )
aMK2TEL := TELAPEG( "ITK201" )
aMK2GET := EDITPEG( "ITK201" )

priv wMAK
priv wpMAK
priv wcMAK

wMAK  := 0
wcMAK := 0
wPMAK := 1

//Modo de Trabalho no Video
MDI( " Э ",,, ARQWORK1 )

//Configura‡„o de Trabalho
priv lFIXA
priv nACHO
priv cVIDE
priv lPBUS
priv lPIND
priv mCBAR
priv mCBARM
priv cTIPG
priv aGETS
priv cCBAS
priv nIBUS
priv nIEXI
priv aIND
priv nREG

if !CONFARQ( ARQWORK1, "Nota    Emiss„o F Fornecedor" + spac( 9 ) + "S Ope P S Pag  Valor Total da NF" )
   retu .F.
endif
if !CONFIND( ARQWORK1 )
   retu .F.
endif

//Pegando Cores de Trabalho
CORMAK := CORARR( "MAK" )

//Variaveis de Trabalho
priv PCK    := .F.
priv mCHAVE
mESTADO := "  "
ZESTADO := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
mLISTA  := 0

CRIARVARS( "MD07" )
CRIARVARS( "ML01" )
CRIARVARS( ARQWORK1 )
CRIARVARS( ARQWORK2 )
CRIARVARS( ARQWORK4 )

//CRIANDO MATRIZES
aMAK1 := {}         //Matriz com os dizeres do Achoice
aMAK2 := {}         //Por NЈmero da Nota Fiscal e NЈmero do Fornecedor

//Incializando a ajuda on Line
priv HELPDBF := "MK01"

//Carregando Matriz
if cVIDE = "S" .and. wcMAK # 2
   nIND := if( lPIND, NUMIND( ARQWORK1 ), nIEXI )
   if !USEREDE( ARQWORK1, 1, nIND )
      retu .T.
   endif
   GRAF := lastrec()
   if GRAF > nACHO
      dbclosearea()
      ALERTX( "Muitos Arquivos para o Modo Video" )
      cVIDE := "N"
   else
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      dbgotop()
      while !eof()
         aadd( aMAK1, MAKSAY01() )
         aadd( aMAK2, str( NRNOTA, 8 ) + str( FORNECEDO, 5 ) )
         xPOS ++
         MARCAR1()
         dbskip()
      enddo
      dbclosearea()
      if xPOS = 1
         if !MDG( 'Nenhum Lan‡amento Neste Arquivo Deseja Incluir' )
            retu .F.
         endif
         nSBAR := 0
         if !fMAK( 1, 0 )
            retu .F.
         endif
      endif
   endif
endif

//Posi‡„o Inicial do Ponteiro
pMAK := 1

//Processando o M‚todo Escolhido
if cVIDE = 'S'
   NOBREAK()
   priv nSBAR
   priv aSBAR
   nSBAR := len( aMAK1 )
   aSBAR := ScrollBarNew( 03, 79, 23,, pMAK )
   ScrollBarDisplay( aSBAR )
   ScrollBarUpdate( aSBAR, pMAK, nSBAR, .T. )
   while .T.
      setcolor( CORMAK[ 1 ] )
      hb_dispbox( 2, 0, 23, 79, B_DOUBLE)
      @  3,  1 say cCBAS
      @  4,  0 say '+' + replicate( '-', 78 ) + 'Э'
      MDS( 'Busca: ' )
      ScrollBarUpdate( aSBAR, pMAK, nSBAR, .T. )
      ScrollBarDisplay( aSBAR )
      pMAK2 := achoice( 05, 01, 22, 78, aMAK1,, "ACHRETB", pMAK )
      pMAK  := if( pMAK2 # 0, pMAK2, pMAK )
      pMAK2 := pMAK
      do case
      case LASTKEY() = K_ESC
         if MDG( 'Encerrar Consulta' )
            exit
         endif
         loop
      case LASTKEY() = K_ALT_F10
         MDS( 'Imprimindo' )
         MANLISTA()
      case LASTKEY() = K_INS
         MDS( 'Incluindo ' )
         fMAK( 1, pMAK )
      case LASTKEY() = K_ENTER .and. wMAK # 3
         MDS( 'Alterando ' )
         fMAK( 2, pMAK )
      case LASTKEY() = K_ENTER .and. wMAK = 3
         MDS( 'Escolhendo' )
         fMAK( 6, pMAK )
         retu
      case LASTKEY() = K_DEL
         MDS( 'Excluindo ' )
         fMAK( 3, pMAK )
      case LASTKEY() = K_CTRL_ENTER
         nIBUS   := if( lPBUS, NUMIND( ARQWORK1 ), nIBUS )
         mCHABUS := PEGBUS( ARQWORK1, nIBUS )
         if nIBUS # 1
            nREG := REGBUS( ARQWORK1, nIBUS, mCHABUS )
         endif
         pMAK := ascan( aMAK2, mCHAVE )
         if pMAK = 0
            ALERTX( 'Nao localizei o Registro Correspondente ....' )
            pMAK := pMAK2
            loop
         endif
      otherwise
         loop
      endcase
   enddo
endif

if wMAK = 0
   //LIBERA VARIAVEIS
   release all like m *                 //LIMPAVARS(ARQWORK1)
endif

//EFETUA O PACK SE NECESSARIO
if PCK .and. lFIXA
   FIXAR( ARQWORK1 )
   FIXAR( ARQWORK2 )
   FIXAR( ARQWORK4 )
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function fMAK()
*+
*+    Called from ( m_ak.prg     )   5 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func fMAK( OPRMAK, POSMAK )

INCLUI := .F.
lPAGAR := .F.
lLOTE  := .F.
//Pegar a Chave de Busca
if OPRMAK # 1
   if cVIDE = 'S'
      mCHAVE := aMAK2[ POSMAK ]
   endif
   if cVIDE = 'N'
      PEGBUS()
   endif
endif

//Opera‡„o de Inclus„o
if OPRMAK = 1
   lACHEI:=.F.
   CRIARVARS( "MK01" )
   CRIARVARS( "MK02" )
   mTIPOCLI := 'F'
   MDS( "NF (F)orn(C)liente" )
   @ 24, 30 get mNRNOTA
   @ 24, 40 get mTIPOCLI
   @ 24, 42 get mFORNECEDO
   READCUR()
   if !VERSEHA( if( mTIPOCLI = "C", "MA01", "MB01" ), mFORNECEDO )
      ALERTX( "Fornecedor/Cliente NЖo Cadastrado" )
      retu .F.
   endif
   mCHAVE    := str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 )
   mCOMPRAS  := 0
   mDATA     := ZDATA
   mITEM     := 1
   mESTADO   := OBTER( if( mTIPOCLI = "C", "MA01", "MB01" ), mFORNECEDO, "ESTADO" )
   mTIPOSERV := "1"
   mSOMANF   := "S"
   mCONSUMO  := "N"
   MDS( "CFO Novo:" )
   @ 24, 40 get mCFONEW pict "@R 9.999" valid CHECKCFO( mCFONEW, 1, mESTADO, zESTADO, 17, 35,,,, "mOPERACAO",, 2 )
   READCUR()
   mFORBUS := mFORNECEDO
   MDS( "Fornecedor Para Busca" )
   @ 24, 40 get mFORBUS
   READCUR()
   if !VERSEHA( if( mTIPOCLI = "C", "MA01", "MB01" ), mFORBUS )
      ALERTX( "Fornecedor/Cliente NЖo Cadastrado" )
      retu .F.
   endif
   PDIPI( mCFONEW, "mCODICM", "mDIPIPI", "mDIPICM",,, 2 )
   //   xICM := OBTER("MD05",mESTADO,"ALIQUOTA")
   xICM := 0
   mICM := xICM
   if mDIPICM = "O" .or. mDIPICM = "I"
      mICM := 0
      xICM := 0
   endif
   INCLUI := .T.
   lPAGAR := .T.
   lLOTE  := .T.
   lCRM   := .T.
   for y = 1 to 2
      if USEREDE( if( y = 1, "CRM", "CRMDEV" ), 1, 99 )     //Entradas CRM
         for X = 1 to 2
            dbsetorder( if( X = 1, 4, 5 ) )
            dbgotop()
            dbseek( str( mNRNOTA, 8 ) + str( mFORBUS, 8 ) )
            while mNRNOTA = if( X = 1, NRNOTA, NRNOTB ) .and. CLIFOR = mFORBUS .and. !eof()
               lACHEI:=.T.
               //            if empty( PEREQ )
               mAUT := AUT
               if mAUT > 0
                  cLIBFISCAL := OBTER( "AUT", mAUT, "LIBFISCAL",,,,,, "N" )
                  if cLIBFISCAL = "N"
                     dbclosearea()
                     APAGAREG( ARQWORK1, mCHAVE, .F. )
                     PADDEL( ARQWORK2, str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 ), "str(mNRNOTA,8)+str(mFORNECEDO,5)", "str( NRNOTA,8) + str(FORNECEDO,5)" )
                     ALERTX( "Autorizacao Nao Liberada Fiscal" + str( mAUT ) )
                     retu .F.
                  endif
               endif
               if TRIANGULAR = "S"
                  ALERTX( "Operacao Triangular Ainda Nao Verificada CRM" )
                  retu .F.
               endif
               mICM     := xICM
               mREDICM  := 0
               mENTREGA := ENTREGA
               mTIPOENT := TIPOE
               mNOME    := DESCRI
               mQTDE    := if( X = 1, QTDEA, QTDEB )
               mPESOCRM := if( X = 1, PESONFA, PESONFB )
               mENTRCRM := if( X = 1, ENTREGA, ENTREG2 )
               mPEDCCRM := PEDCLI
               mUNID    := UNID
               mCODIGO  := if( mTIPOENT = "T", PRODUTO, cBUSCA )
               mCOMPRAS := 0
               mCOMITEM := 0
               mCRM     := CRM
               mPRCCRM  := PRECO
               lCRM     := .F.
               if !empty( PEPED )
                  mCOMPRAS := PEPED
                  mCOMITEM := PEITE
               endif
               if empty( mCOMPRAS )
                  PEGACAMPO( "PE", "mTIPOENT+PADR(mCODIGO,10)+STR(mFORBUS,8)", { "PEDIDO", "COMPRAS", "COMITEM" }, { "mCOMPE", "mCOMPRAS", "mCOMITEM" }, 2 )
               endif
               xCODIGO := ""
               NFCOD()
               makk02()
               mPRCMW02 := mPRECO
               if mAUT > 0
                  mPRECO := mPRCCRM
               endif
               IF mPISCON="S"
//                  ALERTX(STRVAL(XPISEMP))
//                  ALERTX(STRVAL(XFINEMP))
//                  ALERTX(STRVAL(mQTDE*mPRECO))
                  mVAIPIS:=ROUND(mQTDE*mPRECO*XPISEMP/100,2)
                  mVAIFIN:=ROUND(mQTDE*mPRECO*XFINEMP/100,2)
//                  ALERTX(STRVAL(mVAIPIS))
//                  ALERTX(STRVAL(mVAIFIN))
               ELSE
                  mPISCON:="N"
                  mVAIPIS:=0
                  mVAIFIN:=0
               ENDIF
               NOVOREG( ARQWORK2, str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 ) + mCODIGO + str( mITEM, 2 ) )
               mITEM ++
               //          endif
               dbselectar( "CRM" )
               dbskip()
            enddo
         next X
         dbclosearea()
      endif
   next y

   for X := 1 to 3
      nMESANT := month( ZDATA )
      nANOANT := year( ZDATA )
      nMESANT --
      if nMESANT = 0
         nMESANT := 12
         nANOANT --
      endif
      do case
      case X = 1
         cARQREQ := "MY04"
      case X = 2
         cARQREQ := "Y4" + substr( strzero( nANOANT, 4 ), 3, 2 ) + strzero( nMESANT, 2 )
      case X = 3
         cARQREQ := "Y4" + substr( strzero( year( ZDATA ), 4 ), 3, 2 ) + strzero( month( ZDATA ), 2 )
      endcase
      if lCRM
         if USEREDE( cARQREQ, 1, 3,, .F. )                  //Entradas Requisi‡ao
            dbgotop()
            dbseek( str( mNRNOTA, 8 ) + str( mFORBUS, 8 ) )
            while mNRNOTA = NRNOTA .and. NUMMB01 = mFORBUS .and. !eof()
               lACHEI:=.T.
               mENTREGA := DATA
               mTIPOENT := TIPO2
               mQTDE    := QTDE
               mUNID    := UNID
               mCODIGO  := CODIGO
               mCOMPRAS := OS
               mCOMITEM := ITEM
               mNUMMY04 := NUMERO
               mPRCMY04 := PRCMY04
               mPRCMW02 := PRCMW02
               mCODDEP  := CODDEP
               mAUT     := AUT
               xCODIGO  := ""
               lCRM     := .F.
               mICM     := xICM
               mREDICM  := 0
               NFCOD()
               if !empty( mCOMPRAS )
                  if !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEIPI", "REDICM" }, { "mIPI", "mREDICMMW" } )
                     PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEIPI", "REDICM" }, { "mIPI", "mREDICMMW" } )
                  endif
                  if mTIPOENT = "X"
                     if !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITENOM" }, { "mNOME" } )
                        PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITENOM" }, { "mNOME" } )
                     endif
                  endif
                  IF EMPTY(mCODDEP)
                     if !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "CODDEP" }, { "mCODDEP" } )
                        PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "CODDEP" }, { "mCODDEP" } )
                     endif
                  ENDIF
               endif
               if valtype( mIPI ) # "N"
                  mIPI := 0
               endif
               mPRECO := mPRCMW02
               if mAUT > 0
                  mPRECO := mPRCMY04
               endif
               MAKK04()
               xVALORMER := 0           //Forcar o Calculo
               NFBAS()
               NOVOREG( ARQWORK2, str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 ) + mCODIGO + str( mITEM, 2 ) )
               mITEM ++
               dbselectar( cARQREQ )
               dbskip()
            enddo
            dbclosearea()
            if !empty( mCOMPRAS )
               IF EMPTY(mCOD)
                  if !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG", "COMCTA" }, { "mCONDPAG", "mCOD" } )
                     PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG", "COMCTA" }, { "mCONDPAG", "mCOD" } )
                  endif
               ELSE
                 if !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG" }, { "mCONDPAG" } )
                     PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG" }, { "mCONDPAG" } )
                  endif


               ENDIF
            endif
         endif
      endif
   next x
   if (mCFONEW = "1120" .or. mCFONEW = "2120".or.mCFONEW = "1122" .or. mCFONEW = "2122");
      .and. ARQWORK2 = "MM02"
      ALERTX( "Opera‡ao 1120/2120/1122/2122 Requer Nota Origem" )
      yNUMERO    := mNRNOTA
      yFORNECEDO := mFORNECEDO
      nNOTAORI   := 0
      nFORNORI   := 0
      MDS( "Digite Fornecedor Nota/Origem" )
      @ 24, 40 get nFORNORI
      @ 24, 60 get nNOTAORI
      READCUR()
      lTEM := .F.
      while !lTEM
         if USEREDE( ARQWORK2, 1, 99 )
            dbgotop()
            dbseek( str( nNOTAORI, 8 ) + str( nFORNORI, 5 ) )
            while nNOTAORI = NRNOTA .and. nFORNORI = FORNECEDO .and. !eof()
               nREG := recno()
               EQUVARS()
               mNRNOTA    := yNUMERO
               mFORNECEDO := yFORNECEDO
               NOVOOPA()
               dbgoto( nREG )
               dbskip()
               lTEM := .T.
               lACHEI:=.T.
            enddo
            dbclosearea()
         endif
         if !lTEM
            ALERTX( "Nao Encontrado Mes Atual" )
            if !MDG( "Mes Fechado" )
               lTEM := .T.
            else
               cARQ := "M2" + MESANO()
               if USEMULT( { { caRQ, 1, 99 }, { ARQWORK2, 1, 99 } } )
                  dbselectar( caRQ )
                  dbgotop()
                  dbseek( str( nNOTAORI, 8 ) + str( nFORNORI, 5 ) )
                  while nNOTAORI = NRNOTA .and. nFORNORI = FORNECEDO .and. !eof()
                     EQUVARS()
                     mNRNOTA    := yNUMERO
                     mFORNECEDO := yFORNECEDO
                     dbselectar( ARQWORK2 )
                     NOVOOPA()
                     dbselectar( cARQ )
                     dbskip()
                     lTEM := .T.
                     lACHEI:=.T.
                  enddo
                  dbclosearea()
               endif
            endif
         endif
      enddo
   endif
   IF lACHEI.OR.MDG("Pedido Nao Encontrado Incluir")
      if ! NOVOREG( ARQWORK1, mCHAVE )
         retu .F.
      endif
   ENDIF
endif

//IGUALAR mVARS
if !IGUALVARS( ARQWORK1, mCHAVE )
   retu .F.
endif

//if empty( mCOMPRAS ) .and. empty( mOBSPED )
//   @ 23, 00 clea
//   @ 23, 00 say "Sem Pedido/Compras Requer Motivo"
//   @ 24, 00 get mOBSPED                            valid !empty( mOBSPED )
//   READCUR()
//endif

xORDEM   := mORDEM
xDATAREF := mDATAREF
if empty( mDATAREF )
   mDATAREF := mDATA
   xDATAREF := mDATA
endif

//Opera‡„o de Exclus„o
if OPRMAK = 3
   xORDEM := mORDEM
   if APAGAREG( ARQWORK1, mCHAVE )
      if cVIDE = "S"
         aMAK1[ POSMAK ] = ' ' + str( mNRNOTA, 8 ) + ' ' + str( mFORNECEDO, 5 ) + ' - Registro Excluido / Apagado / Deletado'
      endif
      PADDEL( ARQWORK2, str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 ), "str(mNRNOTA,8)+str(mFORNECEDO,5)", "str( NRNOTA,8) + str(FORNECEDO,5)" )
      PADDEL( ARQWORK4, str( xORDEM, 8 ), "ORDEM", "xORDEM" )
      aDATAS := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
                  mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
      for W := 1 to 10
         if !empty( aDATAS[ W ] )
            mTIPFAT := chr( 64 + W )
            APAGAREG( "ML01", dtos( aDATAS[ W ] ) + str( mNRNOTA, 8 ) + mTIPFAT, .F., .F. )
         endif
      next
      PCK := .T.
   endif
   retu .T.
endif

aDATOLD := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }

if (empty( mCOD ) .or. empty( mCONDPAG )) .and. ARQWORK1 = "MK01"
   if USEREDE( "MK02", 1, 1 )
      mVALREF := 0
      mTMPCOD := "   "
      dbgotop()
      dbseek( STR(mNRNOTA,8)+STR(mFORNECEDO,5))
      while mNRNOTA = NRNOTA .and.Mfornecedo=fornecedo.and. !eof()
         if empty( mCONDPAG ) .and. !empty( CODPGMW )
            mCONDPAG := CODPGMW
         endif
         if VALORTOT > mVALREF .or. empty( mTMPCOD ) //Pega o codigo do Maior
            mVALREF := VALORTOT
            IF ! EMPTY(CODDEP)
               mTMPCOD := CODDEP
            ENDIF
         endif
         IF EMPTY(mENTREGA)
            mENTREGA := ENTRCRM
         ENDIF
         dbskip()
      enddo
      if empty( mCOD )
         mCOD := mTMPCOD
      endif
   endif
endif

// Desenha a Tela
TELASAY( aMAKTEL )
// Get nas Menvars
EDITSAY( aMAKGET )

//Ajusta Referencia
if empty( mDATAREF )
   mDATAREF := mDATA
   xDATAREF := mDATA
endif

//Guarda a Ordem Anterior
xORDEM     := mORDEM
yNUMERO    := mNRNOTA
yDATA      := mDATA
yFORNECEDO := mFORNECEDO
yOPERACAO  := mOPERACAO
ySUBOPER   := mSUBOPER
yAPURA     := mAPURA
yESPECIE   := mESPECIE
yCFONEW    := mCFONEW
yCFONEWB   := mCFONEWB

//Itens da Nota Fiscal
if empty( mESTADO )
   mESTADO := OBTER( ARQUSO, mFORNECEDO, "ESTADO" )
endif
M_AK2( 1 )

//DIPI
if empty( mORDEM ) .and. mESPECIE # "NFS" .and. ARQWORK1 = "MK01"               //Primeiro Movimento
   xDATAREF := mDATAREF
   PEGLOTE( 1, xDATAREF, "mLOTE" )
   M_ADIC( 1 )
endif
xDATA      := mDATA
xNUMERO    := mNRNOTA
xTIPOFOR   := mTIPOCLI
xFORNECEDO := mFORNECEDO
xCOGNOME   := mCOGNOME
xDATAREF   := mDATAREF

if mESPECIE # "NFS"
   M_ADI2( 1 )
endif

//Calculando Parcelas
if empty( mVAL01 )
   MPAGAR( mCONDPAG, mTOTNF, mDATA, .T., mENTREGA )
endif

//Checagem das Parcela
CHECKPAR(, "3", "mNRNOTA",, "mDIFDUP" )

cPAGA := "N"
if ARQWORK1 = "MK01"
   CPAGA := if( lPAGAR, OBTER( "MD04", mCFONEW, "CONTAS", 2,,,,, "S" ), "N" )
   @ 24, 00 clea
   @ 24, 05 say "Transfere Dados para o Contas a Pagar <S/N> ?  " get CPAGA pict '@!' valid CPAGA $ 'SN'
   READCUR()
endif
if CPAGA = "S"
   xOBS := space( 60 )
   @ 23, 00 clea to 24, 00
   @ 23, 00 say "Observa‡„o"
   @ 24, 00 get xOBS
   READCUR()
   if !empty( xOBS )
      mOBS1 := xOBS
   endif
   xNRNOTA := mNRNOTA                   //Salva vari veis NRNOTA e DATA do MK01.
   xDATA   := mDATA
   aDATAS  := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
   aVALOR  := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10 }
   mVALANT := mVAL01 + mVAL02 + mVAL03 + mVAL04 + mVAL05 + mVAL06 + mVAL07 + mVAL08 + mVAL09 + mVAL10
   if MDG( "Checar os Valores e Datas Para Transferencia" )
      @  9,  0 clear to 24, 78
      @  9,  1 say "1-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 10,  1 say "2-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 11,  1 say "3-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 12,  1 say "4-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 13,  1 say "5-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @  9, 41 say "6-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 10, 41 say "7-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 11, 41 say "8-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 12, 41 say "9-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
      @ 13, 41 say "10-" + spac( 09 ) + "Э" + spac( 19 ) + "Э"
      @  9,  4 get aDATAS[ 1 ]
      @  9, 14 get aVALOR[ 1 ]                                 pict "999,999,999,999.99"
      @ 10,  4 get aDATAS[ 2 ]
      @ 10, 14 get aVALOR[ 2 ]                                 pict "999,999,999,999.99"
      @ 11,  4 get aDATAS[ 3 ]
      @ 11, 14 get aVALOR[ 3 ]                                 pict "999,999,999,999.99"
      @ 12,  4 get aDATAS[ 4 ]
      @ 12, 14 get aVALOR[ 4 ]                                 pict "999,999,999,999.99"
      @ 13,  4 get aDATAS[ 5 ]
      @ 13, 14 get aVALOR[ 5 ]                                 pict "999,999,999,999.99"
      @  9, 44 get aDATAS[ 6 ]
      @  9, 54 get aVALOR[ 6 ]                                 pict "999,999,999,999.99"
      @ 10, 44 get aDATAS[ 7 ]
      @ 10, 54 get aVALOR[ 7 ]                                 pict "999,999,999,999.99"
      @ 11, 44 get aDATAS[ 8 ]
      @ 11, 54 get aVALOR[ 8 ]                                 pict "999,999,999,999.99"
      @ 12, 44 get aDATAS[ 9 ]
      @ 12, 54 get aVALOR[ 9 ]                                 pict "999,999,999,999.99"
      @ 13, 44 get aDATAS[ 10 ]
      @ 13, 54 get aVALOR[ 10 ]                                pict "999,999,999,999.99"
      READCUR()
   endif
   mVALDEP := 0
   for X := 1 to 10
      mVALDEP += aVALOR[ X ]
   next X
   mDIFPG := mVALANT - mVALDEP
   MDS( "Aguarde Abrindo Contas a Pagar" )
   while !USEREDE( "ML01", 1, 99 )
   enddo
   MDS( "Aguarde Transferindo Contas a Pagar" )
   for W := 1 to 10
      @ 24, 50 say W
      mTIPFAT := chr( 64 + W )          //Tipo do Faturamento (A,B,C...)
      if W = 1 .and. empty( aDATAS[ 2 ] )                   //Somente um vencimento
         mTIPFAT := " "
      endif
      mVENCIMENT := aDATAS[ W ]
      mVALOR     := aVALOR[ W ]
      mVALATUAL  := aVALOR[ W ]
      yDATAV     := aDATOLD[ W ]
      do case
         // Zerou o valor ou a data
         // Apaga o Lan‡amento Buscando Pela Data Anterior
      case mVALOR = 0 .or. empty( mVENCIMENT )
         dbgotop()
         delereg(, dtos( yDATAV ) + str( mNRNOTA, 8 ) + mTIPFAT, .F., .F. )
      case yDATAV = mVENCIMENT .and. mVALOR > 0 .and. !empty( mVENCIMENT )
         if !NOVOOPE(, dtos( mVENCIMENT ) + str( mNRNOTA, 8 ) + mTIPFAT )
            //Altera Lan‡amentos
            netreclock()
            REPLVARS()
            dbunlock()
         endif
         //Mudou a data Apaga o anterior Grava o novo
      case yDATAV <> mVENCIMENT .and. mVALOR > 0
         //Apagando o Anterior
         dbgotop()
         delereg(, dtos( yDATAV ) + str( mNRNOTA, 8 ) + mTIPFAT, .F., .F. )
         NOVOOPE(, dtos( mVENCIMENT ) + str( mNRNOTA, 8 ) + mTIPFAT )
      endcase
   next
   dbcloseall()
   mNRNOTA := xNRNOTA                   //Retorna as vari veis que foram salvadas.
   mDATA   := xDATA
   @ 24, 00 clea
endif

//Atualiza as Matrizes se nao for inclusao
if cVIDE = 'S' .and. OPRMAK # 1
   aMAK1[ POSMAK ] = maksay02()
   aMAK2[ POSMAK ] = str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 )
endif

//Posiciona o Novo Elemento na Matriz
if cVIDE = 'S' .and. OPRMAK = 1
   nSBAR ++
   aadd( aMAK1, NIL )
   aadd( aMAK2, NIL )
   POSMAK := len( aMAK1 )
   POSW   := 1
   if POSMAK > 1
      for X := 1 to POSMAK - 1
         mDARE := aMAK2[ X ]
         if mCHAVE <= mDARE
            exit
         endif
      next
      POSW := X
   endif
   ains( aMAK1, POSW )
   ains( aMAK2, POSW )
   aMAK1[ POSW ] = maksay02()
   aMAK2[ POSW ] = str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 )
   pMAK := POSW
endif

REPORVARS( ARQWORK1, mCHAVE )

if INCLUI
   if mCFONEW = "1551" .or. mCFONEW = "2551" .or. mCFONEWB = "1551" .or. mCFONEWB = "2551"
      if MDG( "Transferir CIAP" )
         mNRENTREGA := mENTREGA
         mFORNOME   := OBTER( "MB01", mFORNECEDO, "NOME" )
         if USEREDE( ARQWORK2, 1, 99 )
            dbgotop()
            dbseek( str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 ) )
            while mNRNOTA = NRNOTA .and. mFORNECEDO = FORNECEDO .and. !eof()
               mNRITEM   := ITEM
               mNOME     := NOME
               mVALORICM := VALORICM
               mCIAP     := ULTIMOREG( "FI_CIAP", "CIAP" )
               mCIAP ++
               NOVOREG( "FI_CIAP", mCIAP )
               CIAPPOS()
               dbskip()
            enddo
            dbclosearea()
         endif
      endif
   endif
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MAKK01()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MAKK01

PEGACAMPO( ARQUSO, "mFORNECEDO", { "ESTADO", "DDD", "TELEFONE", "COGNOME", "IF(ARQUSO='MB01',IESTADUAL,INSCR)" }, { "mESTADO", "mDDD", "mTELEFONE", "mCOGNOME", "mINSCR" } )
//mICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function makk02()
*+
*+    Called from ( m_ak.prg     )   1 - function fmak()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func makk02()

if !empty( mCOMPRAS )
   if !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEPRC", "CODDEP", "REDICM" }, { "mPRECO", "mCODDEP", "mREDICMMW" } )
      PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEPRC", "CODDEP", "REDICM" }, { "mPRECO", "mCODDEP", "mREDICMMW" } )
   endif
   if !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG" }, { "mCODPGMW" } )
      PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG" }, { "mCODPGMW" } )
   endif
endif
if valtype( mPRECO ) # "N"              //Ajusta caso nao encontrou o preco
   mPRECO := 0
endif
retu .t.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function makk03()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func makk03( cARQ1, cARQ2 )

local lRETU := .F.
if USEREDE( cARQ1, 1, 1 )
   dbgotop()
   if dbseek( mCOMPRAS )
      mCOD     := COMCTA
      mCONDPAG := COMCPAG
      lRETU    := .T.
   endif
   dbclosearea()
   if USEREDE( cARQ2, 1, 1 )
      dbgotop()
      dbseek( str( mCOMPRAS, 8 ) )
      while mCOMPRAS = COMPED .and. !eof()
         mTIPOENT := ITETIP
         mQTDE    := ITEQTD
         mCODIGO  := ITECOD
         xCODIGO  := ""
         mUNID    := ITEUNI
         mNOME    := ITENOM
         mCODDEP  := CODDEP
         mPRECO   := ITEPRC
         mIPI     := ITEIPI
         mITEM    := ITEM
         NFCOD()
         MAKK04()
         NOVOREG( ARQWORK2, str( mNRNOTA, 8 ) + str( mFORNECEDO, 5 ) + mCODIGO + str( mITEM, 2 ) )
         dbselectar( cARQ2 )
         dbskip()
      enddo
      dbclosearea()
   endif
endif
retu lRETU

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MAKK04()
*+
*+    Called from ( m_ak.prg     )   1 - function fmak()
*+                                   1 - function makk03()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MAKK04

if mTIPOENT = "O" .or. mTIPOENT = "R"   //Consumiveis
   PEGACAMPO( if( mTIPOENT = "O", "MW05", "MW07" ), "mCODIGO", { "REDICM" }, { "mREDICM" } )
   mPRECO   *= ( 1 + ( mIPI / 100 ) )
   mIPI     := 0
   mICM     := 0
   mCONSUMO := "S"
   mSOMANF  := "S"
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MAKSAY02()
*+
*+    Called from ( m_ak.prg     )   2 - function fmak()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MAKSAY02

local cRETU := ""
if empty( mCFONEW )
   cRETU := ' ' + str( mNRNOTA, 8 ) + ' ' + dtoc( mDATA ) + ' ' + mTIPOCLI + ' ' + str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + mOPERACAO + '.' + mSUBOPER + ' ' + mCONDPAG + ' ' + str( mTOTNF, 18, 2 )
else
   cRETU := ' ' + str( mNRNOTA, 8 ) + ' ' + dtoc( mDATA ) + ' ' + mTIPOCLI + ' ' ;
            + str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + transform( mCFONEW, "@R 9.999" ) + if( empty( mCFONEWB ), "     ", "/" + transform( mCFONEWB, "@R 9.999" ) ) + ' ' + mCONDPAG + ' ' + str( mTOTNF, 18, 2 )
endif
retu cRETU

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MAKSAY01()
*+
*+    Called from ( m_ak.prg     )   1 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MAKSAY01

if empty( CFONEW )
   cRETU := ' ' + str( NRNOTA, 8 ) + ' ' + dtoc( DATA ) + ' ' + TIPOCLI + ' ' + str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + OPERACAO + '.' + SUBOPER + ' ' + CONDPAG + ' ' + str( TOTNF, 18, 2 )
else
   cRETU := ' ' + str( NRNOTA, 8 ) + ' ' + dtoc( DATA ) + ' ' + TIPOCLI + ' ' + ;
         str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + transform( CFONEW, "@R 9.999" ) + if( empty( CFONEWB ), "     ", "/" + transform( CFONEWB, "@R 9.999" ) ) + ' ' + CONDPAG + ' ' + str( TOTNF, 18, 2 )
endif
retu cRETU

*+ EOF: M_AK.PRG
