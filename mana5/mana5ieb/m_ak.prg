// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ak.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_AK.PRG
// +
// +    Functions: Function fMAK()
// +               Function MAKK01()
// +               Function makk02()
// +               Function makk03()
// +               Function MAKK04()
// +               Function MAKSAY02()
// +               Function MAKSAY01()
// +
// +    Reformatted by Click! 2.03 on Apr-20-2005 at  1:50 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_ak()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_ak

   PARA nTIPO

   xPISEMP := OBTER( "MANEMP", ZNUMERO, "PERPIS" )
   xFINEMP := OBTER( "MANEMP", ZNUMERO, "PERFIN" )

   CRIARVARS( "FI_CIAPI" )
   CRIARVARS( "FI_CIAP" )
   ARQWORK1 := "MK01"
   ARQWORK2 := "MK02"
   ARQWORK4 := "MK06"

   IF nTIPO = 2
      cVAR     := MESANO()
      ARQWORK1 := "K1" + cVAR
      ARQWORK2 := "K2" + cVAR
      ARQWORK4 := "K6" + cVAR
   ENDIF

   IF nTIPO = 3
      ARQWORK1 := "MK91"
      ARQWORK2 := "MK92"
      ARQWORK4 := "MK96"
   ENDIF

// Telas de Trabalho
   aMAKTEL := TELAPEG( "ITMK01" )
   aMAKGET := EDITPEG( "ITMK01" )
   aMK2TEL := TELAPEG( "ITK201" )
   aMK2GET := EDITPEG( "ITK201" )

   PRIV wMAK
   PRIV wpMAK
   PRIV wcMAK

   wMAK  := 0
   wcMAK := 0
   wPMAK := 1

// Modo de Trabalho no Video
   MDI( " Э ",,, ARQWORK1 )

// Configura‡„o de Trabalho
   PRIV lFIXA
   PRIV nACHO
   PRIV cVIDE
   PRIV lPBUS
   PRIV lPIND
   PRIV mCBAR
   PRIV mCBARM
   PRIV cTIPG
   PRIV aGETS
   PRIV cCBAS
   PRIV nIBUS
   PRIV nIEXI
   PRIV aIND
   PRIV nREG

   IF !CONFARQ( ARQWORK1, "Nota    Emiss„o F Fornecedor" + spac( 9 ) + "S Ope P S Pag  Valor Total da NF" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK1 )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAK := CORARR( "MAK" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   mESTADO := "  "
   ZESTADO := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
   mLISTA  := 0

   CRIARVARS( "MD07" )
   CRIARVARS( "ML01" )
   CRIARVARS( ARQWORK1 )
   CRIARVARS( ARQWORK2 )
   CRIARVARS( ARQWORK4 )

// CRIANDO MATRIZES
   aMAK1 := {}   // Matriz com os dizeres do Achoice
   aMAK2 := {}   // Por NЈmero da Nota Fiscal e NЈmero do Fornecedor

// Incializando a ajuda on Line
   PRIV HELPDBF := "MK01"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAK # 2
      nIND := if( lPIND, NUMIND( ARQWORK1 ), nIEXI )
      IF !USEREDE( ARQWORK1, 1, nIND )
         RETU .T.
      ENDIF
      GRAF := LastRec()
      IF GRAF > nACHO
         dbCloseArea()
         ALERTX( "Muitos Arquivos para o Modo Video" )
         cVIDE := "N"
      ELSE
         xGRAF := 0
         xPOS  := 1
         MARCAR()
         dbGoTop()
         WHILE !Eof()
            AAdd( aMAK1, MAKSAY01() )
            AAdd( aMAK2, Str( NRNOTA, 8 ) + Str( FORNECEDO, 5 ) )
            xPOS++
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            IF !MDG( 'Nenhum Lan‡amento Neste Arquivo Deseja Incluir' )
               RETU .F.
            ENDIF
            nSBAR := 0
            IF !fMAK( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   pMAK := 1

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR
      PRIV aSBAR
      nSBAR := Len( aMAK1 )
      aSBAR := ScrollBarNew( 03, 79, 23,, pMAK )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAK, nSBAR, .T. )
      WHILE .T.
         SetColor( CORMAK[ 1 ] )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         @  3, 1 SAY cCBAS
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Э'
         MDS( 'Busca: ' )
         ScrollBarUpdate( aSBAR, pMAK, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pMAK2 := AChoice( 05, 01, 22, 78, aMAK1,, "ACHRETB", pMAK )
         pMAK  := if( pMAK2 # 0, pMAK2, pMAK )
         pMAK2 := pMAK
         DO CASE
         CASE LastKey() = K_ESC
            IF MDG( 'Encerrar Consulta' )
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMAK( 1, pMAK )
         CASE LastKey() = K_ENTER .AND. wMAK # 3
            MDS( 'Alterando ' )
            fMAK( 2, pMAK )
         CASE LastKey() = K_ENTER .AND. wMAK = 3
            MDS( 'Escolhendo' )
            fMAK( 6, pMAK )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAK( 3, pMAK )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := if( lPBUS, NUMIND( ARQWORK1 ), nIBUS )
            mCHABUS := PEGBUS( ARQWORK1, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( ARQWORK1, nIBUS, mCHABUS )
            ENDIF
            pMAK := AScan( aMAK2, mCHAVE )
            IF pMAK = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAK := pMAK2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF

   IF wMAK = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS(ARQWORK1)
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQWORK1 )
      FIXAR( ARQWORK2 )
      FIXAR( ARQWORK4 )
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function fMAK()
// +
// +    Called from ( m_ak.prg     )   5 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAK( OPRMAK, POSMAK )

   INCLUI := .F.
   lPAGAR := .F.
   lLOTE  := .F.
// Pegar a Chave de Busca
   IF OPRMAK # 1
      IF cVIDE = 'S'
         mCHAVE := aMAK2[ POSMAK ]
      ENDIF
      IF cVIDE = 'N'
         PEGBUS()
      ENDIF
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMAK = 1
      lACHEI := .F.
      CRIARVARS( "MK01" )
      CRIARVARS( "MK02" )
      mTIPOCLI := 'F'
      MDS( "NF (F)orn(C)liente" )
      @ 24, 30 GET mNRNOTA
      @ 24, 40 GET mTIPOCLI
      @ 24, 42 GET mFORNECEDO
      READCUR()
      IF !VERSEHA( if( mTIPOCLI = "C", "MA01", "MB01" ), mFORNECEDO )
         ALERTX( "Fornecedor/Cliente NЖo Cadastrado" )
         RETU .F.
      ENDIF
      mCHAVE    := Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 )
      mCOMPRAS  := 0
      mDATA     := ZDATA
      mITEM     := 1
      mESTADO   := OBTER( if( mTIPOCLI = "C", "MA01", "MB01" ), mFORNECEDO, "ESTADO" )
      mTIPOSERV := "1"
      mSOMANF   := "S"
      mCONSUMO  := "N"
      MDS( "CFO Novo:" )
      @ 24, 40 GET mCFONEW PICT "@R 9.999" VALID CHECKCFO( mCFONEW, 1, mESTADO, zESTADO, 17, 35,,,, "mOPERACAO",, 2 )
      READCUR()
      mFORBUS := mFORNECEDO
      MDS( "Fornecedor Para Busca" )
      @ 24, 40 GET mFORBUS
      READCUR()
      IF !VERSEHA( if( mTIPOCLI = "C", "MA01", "MB01" ), mFORBUS )
         ALERTX( "Fornecedor/Cliente NЖo Cadastrado" )
         RETU .F.
      ENDIF
      PDIPI( mCFONEW, "mCODICM", "mDIPIPI", "mDIPICM",,, 2 )
      // xICM := OBTER("MD05",mESTADO,"ALIQUOTA")
      xICM := 0
      mICM := xICM
      IF mDIPICM = "O" .OR. mDIPICM = "I"
         mICM := 0
         xICM := 0
      ENDIF
      INCLUI := .T.
      lPAGAR := .T.
      lLOTE  := .T.
      lCRM   := .T.
      FOR y := 1 TO 2
         IF USEREDE( if( y = 1, "CRM", "CRMDEV" ), 1, 99 )   // Entradas CRM
            FOR X := 1 TO 2
               dbSetOrder( if( X = 1, 4, 5 ) )
               dbGoTop()
               dbSeek( Str( mNRNOTA, 8 ) + Str( mFORBUS, 8 ) )
               WHILE mNRNOTA = if( X = 1, NRNOTA, NRNOTB ) .AND. CLIFOR = mFORBUS .AND. !Eof()
                  lACHEI := .T.
                  // if empty( PEREQ )
                  mAUT := AUT
                  IF mAUT > 0
                     cLIBFISCAL := OBTER( "AUT", mAUT, "LIBFISCAL",,,,,, "N" )
                     IF cLIBFISCAL = "N"
                        dbCloseArea()
                        APAGAREG( ARQWORK1, mCHAVE, .F. )
                        PADDEL( ARQWORK2, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ), "str(mNRNOTA,8)+str(mFORNECEDO,5)", "str( NRNOTA,8) + str(FORNECEDO,5)" )
                        ALERTX( "Autorizacao Nao Liberada Fiscal" + Str( mAUT ) )
                        RETU .F.
                     ENDIF
                  ENDIF
                  IF TRIANGULAR = "S"
                     ALERTX( "Operacao Triangular Ainda Nao Verificada CRM" )
                     RETU .F.
                  ENDIF
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
                  IF !Empty( PEPED )
                     mCOMPRAS := PEPED
                     mCOMITEM := PEITE
                  ENDIF
                  IF Empty( mCOMPRAS )
                     PEGACAMPO( "PE", "mTIPOENT+PADR(mCODIGO,10)+STR(mFORBUS,8)", { "PEDIDO", "COMPRAS", "COMITEM" }, { "mCOMPE", "mCOMPRAS", "mCOMITEM" }, 2 )
                  ENDIF
                  xCODIGO := ""
                  NFCOD()
                  makk02()
                  mPRCMW02 := mPRECO
                  IF mAUT > 0
                     mPRECO := mPRCCRM
                  ENDIF
                  IF mPISCON = "S"
                     // ALERTX(STRVAL(XPISEMP))
                     // ALERTX(STRVAL(XFINEMP))
                     // ALERTX(STRVAL(mQTDE*mPRECO))
                     mVAIPIS := Round( mQTDE * mPRECO * XPISEMP / 100, 2 )
                     mVAIFIN := Round( mQTDE * mPRECO * XFINEMP / 100, 2 )
                     // ALERTX(STRVAL(mVAIPIS))
                     // ALERTX(STRVAL(mVAIFIN))
                  ELSE
                     mPISCON := "N"
                     mVAIPIS := 0
                     mVAIFIN := 0
                  ENDIF
                  NOVOREG( ARQWORK2, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 ) )
                  mITEM++
                  // endif
                  dbSelectAr( "CRM" )
                  dbSkip()
               ENDDO
            NEXT X
            dbCloseArea()
         ENDIF
      NEXT y

      FOR X := 1 TO 3
         nMESANT := Month( ZDATA )
         nANOANT := Year( ZDATA )
         nMESANT--
         IF nMESANT = 0
            nMESANT := 12
            nANOANT--
         ENDIF
         DO CASE
         CASE X = 1
            cARQREQ := "MY04"
         CASE X = 2
            cARQREQ := "Y4" + SubStr( StrZero( nANOANT, 4 ), 3, 2 ) + StrZero( nMESANT, 2 )
         CASE X = 3
            cARQREQ := "Y4" + SubStr( StrZero( Year( ZDATA ), 4 ), 3, 2 ) + StrZero( Month( ZDATA ), 2 )
         ENDCASE
         IF lCRM
            IF USEREDE( cARQREQ, 1, 3,, .F. )   // Entradas Requisi‡ao
               dbGoTop()
               dbSeek( Str( mNRNOTA, 8 ) + Str( mFORBUS, 8 ) )
               WHILE mNRNOTA = NRNOTA .AND. NUMMB01 = mFORBUS .AND. !Eof()
                  lACHEI   := .T.
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
                  IF !Empty( mCOMPRAS )
                     IF !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEIPI", "REDICM" }, { "mIPI", "mREDICMMW" } )
                        PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEIPI", "REDICM" }, { "mIPI", "mREDICMMW" } )
                     ENDIF
                     IF mTIPOENT = "X"
                        IF !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITENOM" }, { "mNOME" } )
                           PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITENOM" }, { "mNOME" } )
                        ENDIF
                     ENDIF
                     IF Empty( mCODDEP )
                        IF !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "CODDEP" }, { "mCODDEP" } )
                           PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "CODDEP" }, { "mCODDEP" } )
                        ENDIF
                     ENDIF
                  ENDIF
                  IF ValType( mIPI ) # "N"
                     mIPI := 0
                  ENDIF
                  mPRECO := mPRCMW02
                  IF mAUT > 0
                     mPRECO := mPRCMY04
                  ENDIF
                  MAKK04()
                  xVALORMER := 0   // Forcar o Calculo
                  NFBAS()
                  NOVOREG( ARQWORK2, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 ) )
                  mITEM++
                  dbSelectAr( cARQREQ )
                  dbSkip()
               ENDDO
               dbCloseArea()
               IF !Empty( mCOMPRAS )
                  IF Empty( mCOD )
                     IF !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG", "COMCTA" }, { "mCONDPAG", "mCOD" } )
                        PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG", "COMCTA" }, { "mCONDPAG", "mCOD" } )
                     ENDIF
                  ELSE
                     IF !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG" }, { "mCONDPAG" } )
                        PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG" }, { "mCONDPAG" } )
                     ENDIF


                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      NEXT x
      IF ( mCFONEW = "1120" .OR. mCFONEW = "2120" .OR. mCFONEW = "1122" .OR. mCFONEW = "2122" ) ;
            .AND. ARQWORK2 = "MM02"
         ALERTX( "Opera‡ao 1120/2120/1122/2122 Requer Nota Origem" )
         yNUMERO    := mNRNOTA
         yFORNECEDO := mFORNECEDO
         nNOTAORI   := 0
         nFORNORI   := 0
         MDS( "Digite Fornecedor Nota/Origem" )
         @ 24, 40 GET nFORNORI
         @ 24, 60 GET nNOTAORI
         READCUR()
         lTEM := .F.
         WHILE !lTEM
            IF USEREDE( ARQWORK2, 1, 99 )
               dbGoTop()
               dbSeek( Str( nNOTAORI, 8 ) + Str( nFORNORI, 5 ) )
               WHILE nNOTAORI = NRNOTA .AND. nFORNORI = FORNECEDO .AND. !Eof()
                  nREG := RecNo()
                  EQUVARS()
                  mNRNOTA    := yNUMERO
                  mFORNECEDO := yFORNECEDO
                  NOVOOPA()
                  dbGoto( nREG )
                  dbSkip()
                  lTEM   := .T.
                  lACHEI := .T.
               ENDDO
               dbCloseArea()
            ENDIF
            IF !lTEM
               ALERTX( "Nao Encontrado Mes Atual" )
               IF !MDG( "Mes Fechado" )
                  lTEM := .T.
               ELSE
                  cARQ := "M2" + MESANO()
                  IF USEMULT( { { caRQ, 1, 99 }, { ARQWORK2, 1, 99 } } )
                     dbSelectAr( caRQ )
                     dbGoTop()
                     dbSeek( Str( nNOTAORI, 8 ) + Str( nFORNORI, 5 ) )
                     WHILE nNOTAORI = NRNOTA .AND. nFORNORI = FORNECEDO .AND. !Eof()
                        EQUVARS()
                        mNRNOTA    := yNUMERO
                        mFORNECEDO := yFORNECEDO
                        dbSelectAr( ARQWORK2 )
                        NOVOOPA()
                        dbSelectAr( cARQ )
                        dbSkip()
                        lTEM   := .T.
                        lACHEI := .T.
                     ENDDO
                     dbCloseArea()
                  ENDIF
               ENDIF
            ENDIF
         ENDDO
      ENDIF
      IF lACHEI .OR. MDG( "Pedido Nao Encontrado Incluir" )
         IF !NOVOREG( ARQWORK1, mCHAVE )
            RETU .F.
         ENDIF
      ENDIF
   ENDIF

// IGUALAR mVARS
   IF !IGUALVARS( ARQWORK1, mCHAVE )
      RETU .F.
   ENDIF

// if empty( mCOMPRAS ) .and. empty( mOBSPED )
// @ 23, 00 clea
// @ 23, 00 say "Sem Pedido/Compras Requer Motivo"
// @ 24, 00 get mOBSPED                            valid !empty( mOBSPED )
// READCUR()
// endif

   xORDEM   := mORDEM
   xDATAREF := mDATAREF
   IF Empty( mDATAREF )
      mDATAREF := mDATA
      xDATAREF := mDATA
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMAK = 3
      xORDEM := mORDEM
      IF APAGAREG( ARQWORK1, mCHAVE )
         IF cVIDE = "S"
            aMAK1[ POSMAK ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + Str( mFORNECEDO, 5 ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PADDEL( ARQWORK2, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ), "str(mNRNOTA,8)+str(mFORNECEDO,5)", "str( NRNOTA,8) + str(FORNECEDO,5)" )
         PADDEL( ARQWORK4, Str( xORDEM, 8 ), "ORDEM", "xORDEM" )
         aDATAS := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
            mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
         FOR W := 1 TO 10
            IF !Empty( aDATAS[ W ] )
               mTIPFAT := Chr( 64 + W )
               APAGAREG( "ML01", DToS( aDATAS[ W ] ) + Str( mNRNOTA, 8 ) + mTIPFAT, .F., .F. )
            ENDIF
         NEXT
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

   aDATOLD := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }

   IF ( Empty( mCOD ) .OR. Empty( mCONDPAG ) ) .AND. ARQWORK1 = "MK01"
      IF USEREDE( "MK02", 1, 1 )
         mVALREF := 0
         mTMPCOD := "   "
         dbGoTop()
         dbSeek( Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) )
         WHILE mNRNOTA = NRNOTA .AND. Mfornecedo = fornecedo .AND. !Eof()
            IF Empty( mCONDPAG ) .AND. !Empty( CODPGMW )
               mCONDPAG := CODPGMW
            ENDIF
            IF VALORTOT > mVALREF .OR. Empty( mTMPCOD )  // Pega o codigo do Maior
               mVALREF := VALORTOT
               IF !Empty( CODDEP )
                  mTMPCOD := CODDEP
               ENDIF
            ENDIF
            IF Empty( mENTREGA )
               mENTREGA := ENTRCRM
            ENDIF
            dbSkip()
         ENDDO
         IF Empty( mCOD )
            mCOD := mTMPCOD
         ENDIF
      ENDIF
   ENDIF

// Desenha a Tela
   TELASAY( aMAKTEL )
// Get nas Menvars
   EDITSAY( aMAKGET )

// Ajusta Referencia
   IF Empty( mDATAREF )
      mDATAREF := mDATA
      xDATAREF := mDATA
   ENDIF

// Guarda a Ordem Anterior
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

// Itens da Nota Fiscal
   IF Empty( mESTADO )
      mESTADO := OBTER( ARQUSO, mFORNECEDO, "ESTADO" )
   ENDIF
   M_AK2( 1 )

// DIPI
   IF Empty( mORDEM ) .AND. mESPECIE # "NFS" .AND. ARQWORK1 = "MK01"   // Primeiro Movimento
      xDATAREF := mDATAREF
      PEGLOTE( 1, xDATAREF, "mLOTE" )
      M_ADIC( 1 )
   ENDIF
   xDATA      := mDATA
   xNUMERO    := mNRNOTA
   xTIPOFOR   := mTIPOCLI
   xFORNECEDO := mFORNECEDO
   xCOGNOME   := mCOGNOME
   xDATAREF   := mDATAREF

   IF mESPECIE # "NFS"
      M_ADI2( 1 )
   ENDIF

// Calculando Parcelas
   IF Empty( mVAL01 )
      MPAGAR( mCONDPAG, mTOTNF, mDATA, .T., mENTREGA )
   ENDIF

// Checagem das Parcela
   CHECKPAR(, "3", "mNRNOTA",, "mDIFDUP" )

   cPAGA := "N"
   IF ARQWORK1 = "MK01"
      CPAGA := if( lPAGAR, OBTER( "MD04", mCFONEW, "CONTAS", 2,,,,, "S" ), "N" )
      @ 24, 00 clea
      @ 24, 05 SAY "Transfere Dados para o Contas a Pagar <S/N> ?  " GET CPAGA PICT '@!' VALID CPAGA $ 'SN'
      READCUR()
   ENDIF
   IF CPAGA = "S"
      xOBS := Space( 60 )
      @ 23, 00 CLEA TO 24, 00
      @ 23, 00 SAY "Observa‡„o"
      @ 24, 00 GET xOBS
      READCUR()
      IF !Empty( xOBS )
         mOBS1 := xOBS
      ENDIF
      xNRNOTA := mNRNOTA   // Salva vari veis NRNOTA e DATA do MK01.
      xDATA   := mDATA
      aDATAS  := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
      aVALOR  := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10 }
      mVALANT := mVAL01 + mVAL02 + mVAL03 + mVAL04 + mVAL05 + mVAL06 + mVAL07 + mVAL08 + mVAL09 + mVAL10
      IF MDG( "Checar os Valores e Datas Para Transferencia" )
         @  9, 0 CLEAR TO 24, 78
         @  9, 1  SAY "1-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 10, 1  SAY "2-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 11, 1  SAY "3-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 12, 1  SAY "4-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 13, 1  SAY "5-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @  9, 41 SAY "6-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 10, 41 SAY "7-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 11, 41 SAY "8-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 12, 41 SAY "9-" + spac( 10 ) + "Э" + spac( 19 ) + "Э"
         @ 13, 41 SAY "10-" + spac( 09 ) + "Э" + spac( 19 ) + "Э"
         @  9, 4  GET aDATAS[ 1 ]
         @  9, 14 GET aVALOR[ 1 ]                       PICT "999,999,999,999.99"
         @ 10, 4  GET aDATAS[ 2 ]
         @ 10, 14 GET aVALOR[ 2 ]                       PICT "999,999,999,999.99"
         @ 11, 4  GET aDATAS[ 3 ]
         @ 11, 14 GET aVALOR[ 3 ]                       PICT "999,999,999,999.99"
         @ 12, 4  GET aDATAS[ 4 ]
         @ 12, 14 GET aVALOR[ 4 ]                       PICT "999,999,999,999.99"
         @ 13, 4  GET aDATAS[ 5 ]
         @ 13, 14 GET aVALOR[ 5 ]                       PICT "999,999,999,999.99"
         @  9, 44 GET aDATAS[ 6 ]
         @  9, 54 GET aVALOR[ 6 ]                       PICT "999,999,999,999.99"
         @ 10, 44 GET aDATAS[ 7 ]
         @ 10, 54 GET aVALOR[ 7 ]                       PICT "999,999,999,999.99"
         @ 11, 44 GET aDATAS[ 8 ]
         @ 11, 54 GET aVALOR[ 8 ]                       PICT "999,999,999,999.99"
         @ 12, 44 GET aDATAS[ 9 ]
         @ 12, 54 GET aVALOR[ 9 ]                       PICT "999,999,999,999.99"
         @ 13, 44 GET aDATAS[ 10 ]
         @ 13, 54 GET aVALOR[ 10 ]                      PICT "999,999,999,999.99"
         READCUR()
      ENDIF
      mVALDEP := 0
      FOR X := 1 TO 10
         mVALDEP += aVALOR[ X ]
      NEXT X
      mDIFPG := mVALANT - mVALDEP
      MDS( "Aguarde Abrindo Contas a Pagar" )
      WHILE !USEREDE( "ML01", 1, 99 )
      ENDDO
      MDS( "Aguarde Transferindo Contas a Pagar" )
      FOR W := 1 TO 10
         @ 24, 50 SAY W
         mTIPFAT := Chr( 64 + W )  // Tipo do Faturamento (A,B,C...)
         IF W = 1 .AND. Empty( aDATAS[ 2 ] )   // Somente um vencimento
            mTIPFAT := " "
         ENDIF
         mVENCIMENT := aDATAS[ W ]
         mVALOR     := aVALOR[ W ]
         mVALATUAL  := aVALOR[ W ]
         yDATAV     := aDATOLD[ W ]
         DO CASE
            // Zerou o valor ou a data
            // Apaga o Lan‡amento Buscando Pela Data Anterior
         CASE mVALOR = 0 .OR. Empty( mVENCIMENT )
            dbGoTop()
            delereg(, DToS( yDATAV ) + Str( mNRNOTA, 8 ) + mTIPFAT, .F., .F. )
         CASE yDATAV = mVENCIMENT .AND. mVALOR > 0 .AND. !Empty( mVENCIMENT )
            IF !NOVOOPE(, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
               // Altera Lan‡amentos
               netreclock()
               REPLVARS()
               dbUnlock()
            ENDIF
            // Mudou a data Apaga o anterior Grava o novo
         CASE yDATAV <> mVENCIMENT .AND. mVALOR > 0
            // Apagando o Anterior
            dbGoTop()
            delereg(, DToS( yDATAV ) + Str( mNRNOTA, 8 ) + mTIPFAT, .F., .F. )
            NOVOOPE(, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
         ENDCASE
      NEXT
      dbCloseAll()
      mNRNOTA := xNRNOTA   // Retorna as vari veis que foram salvadas.
      mDATA   := xDATA
      @ 24, 00 clea
   ENDIF

// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAK # 1
      aMAK1[ POSMAK ] = maksay02()
      aMAK2[ POSMAK ] = Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 )
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMAK = 1
      nSBAR++
      AAdd( aMAK1, NIL )
      AAdd( aMAK2, NIL )
      POSMAK := Len( aMAK1 )
      POSW   := 1
      IF POSMAK > 1
         FOR X := 1 TO POSMAK - 1
            mDARE := aMAK2[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMAK1, POSW )
      AIns( aMAK2, POSW )
      aMAK1[ POSW ] = maksay02()
      aMAK2[ POSW ] = Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 )
      pMAK := POSW
   ENDIF

   REPORVARS( ARQWORK1, mCHAVE )

   IF INCLUI
      IF mCFONEW = "1551" .OR. mCFONEW = "2551" .OR. mCFONEWB = "1551" .OR. mCFONEWB = "2551"
         IF MDG( "Transferir CIAP" )
            mNRENTREGA := mENTREGA
            mFORNOME   := OBTER( "MB01", mFORNECEDO, "NOME" )
            IF USEREDE( ARQWORK2, 1, 99 )
               dbGoTop()
               dbSeek( Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) )
               WHILE mNRNOTA = NRNOTA .AND. mFORNECEDO = FORNECEDO .AND. !Eof()
                  mNRITEM   := ITEM
                  mNOME     := NOME
                  mVALORICM := VALORICM
                  mCIAP     := ULTIMOREG( "FI_CIAP", "CIAP" )
                  mCIAP++
                  NOVOREG( "FI_CIAP", mCIAP )
                  CIAPPOS()
                  dbSkip()
               ENDDO
               dbCloseArea()
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MAKK01()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAKK01

   PEGACAMPO( ARQUSO, "mFORNECEDO", { "ESTADO", "DDD", "TELEFONE", "COGNOME", "IF(ARQUSO='MB01',IESTADUAL,INSCR)" }, { "mESTADO", "mDDD", "mTELEFONE", "mCOGNOME", "mINSCR" } )
// mICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function makk02()
// +
// +    Called from ( m_ak.prg     )   1 - function fmak()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function makk02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC makk02()

   IF !Empty( mCOMPRAS )
      IF !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEPRC", "CODDEP", "REDICM" }, { "mPRECO", "mCODDEP", "mREDICMMW" } )
         PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "ITEPRC", "CODDEP", "REDICM" }, { "mPRECO", "mCODDEP", "mREDICMMW" } )
      ENDIF
      IF !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG" }, { "mCODPGMW" } )
         PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG" }, { "mCODPGMW" } )
      ENDIF
   ENDIF
   IF ValType( mPRECO ) # "N"  // Ajusta caso nao encontrou o preco
      mPRECO := 0
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function makk03()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function makk03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC makk03( cARQ1, cARQ2 )

   LOCAL lRETU := .F.

   IF USEREDE( cARQ1, 1, 1 )
      dbGoTop()
      IF dbSeek( mCOMPRAS )
         mCOD     := COMCTA
         mCONDPAG := COMCPAG
         lRETU    := .T.
      ENDIF
      dbCloseArea()
      IF USEREDE( cARQ2, 1, 1 )
         dbGoTop()
         dbSeek( Str( mCOMPRAS, 8 ) )
         WHILE mCOMPRAS = COMPED .AND. !Eof()
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
            NOVOREG( ARQWORK2, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 ) )
            dbSelectAr( cARQ2 )
            dbSkip()
         ENDDO
         dbCloseArea()
      ENDIF
   ENDIF
   RETU lRETU

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MAKK04()
// +
// +    Called from ( m_ak.prg     )   1 - function fmak()
// +                                   1 - function makk03()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKK04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAKK04

   IF mTIPOENT = "O" .OR. mTIPOENT = "R"   // Consumiveis
      PEGACAMPO( if( mTIPOENT = "O", "MW05", "MW07" ), "mCODIGO", { "REDICM" }, { "mREDICM" } )
      mPRECO   *= ( 1 + ( mIPI / 100 ) )
      mIPI     := 0
      mICM     := 0
      mCONSUMO := "S"
      mSOMANF  := "S"
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MAKSAY02()
// +
// +    Called from ( m_ak.prg     )   2 - function fmak()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKSAY02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAKSAY02

   LOCAL cRETU := ""

   IF Empty( mCFONEW )
      cRETU := ' ' + Str( mNRNOTA, 8 ) + ' ' + DToC( mDATA ) + ' ' + mTIPOCLI + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + mOPERACAO + '.' + mSUBOPER + ' ' + mCONDPAG + ' ' + Str( mTOTNF, 18, 2 )
   ELSE
      cRETU := ' ' + Str( mNRNOTA, 8 ) + ' ' + DToC( mDATA ) + ' ' + mTIPOCLI + ' ' ;
         +Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + Transform( mCFONEW, "@R 9.999" ) + if( Empty( mCFONEWB ), "     ", "/" + Transform( mCFONEWB, "@R 9.999" ) ) + ' ' + mCONDPAG + ' ' + Str( mTOTNF, 18, 2 )
   ENDIF
   RETU cRETU

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MAKSAY01()
// +
// +    Called from ( m_ak.prg     )   1 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKSAY01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAKSAY01

   IF Empty( CFONEW )
      cRETU := ' ' + Str( NRNOTA, 8 ) + ' ' + DToC( DATA ) + ' ' + TIPOCLI + ' ' + Str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + OPERACAO + '.' + SUBOPER + ' ' + CONDPAG + ' ' + Str( TOTNF, 18, 2 )
   ELSE
      cRETU := ' ' + Str( NRNOTA, 8 ) + ' ' + DToC( DATA ) + ' ' + TIPOCLI + ' ' + ;
         Str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + Transform( CFONEW, "@R 9.999" ) + if( Empty( CFONEWB ), "     ", "/" + Transform( CFONEWB, "@R 9.999" ) ) + ' ' + CONDPAG + ' ' + Str( TOTNF, 18, 2 )
   ENDIF
   RETU cRETU

// + EOF: M_AK.PRG

// + EOF: m_ak.prg
// +
