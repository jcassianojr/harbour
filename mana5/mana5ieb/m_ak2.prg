// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ak2.prg
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

// ****************************************************************************
// :
// :   M_AK2 .PRG  : Entrada de Notas Fiscais e Despesas (NFCompras) - ITENS
// :   Linguagem   : harbour
// :        Sistema: Mana5 - ITAESBRA
// :          Autor: Equipe Disk
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :
// :*****************************************************************************

#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_ak2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_ak2

// Recebendo Parametro de Trabalho
   PARA wMAK2, wpMAK2, wcMAK2, wMAK3
   wMAK3 := 0

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N„o Cria e Carrega as Matrizes
2 - N„o Cria e N„o Carrega as Matrizes
*/
   IF ValType( wCMAK2 ) # "N"
      wcMAK2 := 0
   ENDIF


// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
   MDI( " Ý ",,, ARQWORK2 )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( ARQWORK2, " T     Qtde   C¢digo      Nome                    Pre‡o Un.     Total Mercad." )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK2 )
      RETU .F.
   ENDIF


// Pegando Cores de Trabalho
   CORMK2 := CORARR( "MAK2" )

// Variaveis de Trabalho
   PRIV PCK       := .F.
   PRIV mCHAVE
   PRIV mOLDQTDDE


// ESCOLHA:=0

   IF wMAK2 = 0
      CRIARVARS( ARQWORK2 )
   ENDIF

// CRIANDO MATRIZES
   IF wcMAK2 = 0
      aMAK21 := {}   // Matriz com os dizeres do Achoice
      aMAK22 := {}   // Por N£mero da Nota Fiscal e N£mero do Fornecedor
      aMAK25 := {}   // Valor Total da Mercadoria
      aMAK26 := {}   // Valor Total do IPI
      aMAK27 := {}   // Valor Total da Nota Fiscal
      aMAK28 := {}   // Valor Total do ICMS
      aMAK29 := {}   // Valor Total da Base de Calculo do IPI
      aMAK30 := {}   // Valor Total da Base de Calculo do ICM
      aMAK31 := {}   // INSENTA ICM
      aMAK32 := {}   // OUTRA ICM
      aMAK33 := {}   // ISENTA IPI
      aMAK34 := {}   // OUTRA IPI
      aMAK35 := {}   // Valor pis
      aMAK36 := {}   // Valor cofins
      aMAK37 := {}   // tipoent codigo
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := "MK02"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAK2 # 2
      nIND := IF( lPIND, NUMIND( ARQWORK2 ), nIEXI )
      IF !USEREDE( ARQWORK2, 1, 1, "2" )
         RETU
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
         dbSeek( Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) )
         WHILE mNRNOTA = NRNOTA .AND. mFORNECEDO = FORNECEDO .AND. !Eof()
            IF !Empty( mCBAR )
               AAdd( aMAK21, &mCBAR. )
            ELSE
               AAdd( aMAK21, ' ' + Str( ITEM, 2 ) + ' ' + TIPOENT + ' ' + Str( QTDE, 10, 4 ) + ' ' + PadR( CODIGO, 20 ) + ' ' + Left( NOME, 15 ) + ' ' + Str( PRECO, 9, 4 ) + ' ' + Str( VALORMER, 9, 2 ) )
            ENDIF
            AAdd( aMAK22, Str( NRNOTA, 8 ) + Str( FORNECEDO, 5 ) + CODIGO + Str( ITEM, 2 ) )
            AAdd( aMAK25, VALORMER )
            AAdd( aMAK26, VALORIPI )
            AAdd( aMAK27, VALORTOT )
            AAdd( aMAK28, VALORICM )
            AAdd( aMAK29, BASEIPI )
            AAdd( aMAK30, BASEICM )
            AAdd( aMAK31, ISENTAICM )
            AAdd( aMAK32, OUTRAICM )
            AAdd( aMAK33, ISENTAIPI )
            AAdd( aMAK34, OUTRAIPI )
            AAdd( aMAK35, VAIPIS )
            AAdd( aMAK36, VAIFIN )
            AAdd( aMAK37, TIPOENT + CODIGO )
            xPOS++
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            nSBAR := 0
            IF !fMAK2( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMAK2 := 1
   ELSE
      pMAK2 := AScan( aMAK22, wpMAK2 )
      pMAK2 := IF( pMAK2 = 0, 1, pMAK2 )
   ENDIF

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMAK21 )
      aSBAR := ScrollBarNew( 03, 79, 23,, pMAK2 )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAK2, nSBAR, .T. )
      WHILE .T.
         mTOTMER    := 0.00
         mTOTIPI    := 0.00
         mTOTNF     := 0.00
         mTOTICM    := 0.00
         mTOTBIPI   := 0.00
         mTOTBICM   := 0.00
         mTOTISEICM := 0.00
         mTOTOUTICM := 0.00
         mTOTISEIPI := 0.00
         mTOTOUTIPI := 0.00
         mVALPIS    := 0.00
         mVALFIN    := 0.00
         mTOTFRETE  := 0.00
         FOR X := 1 TO Len( aMAK27 )
            mTOTMER    += aMAK25[ X ]
            mTOTIPI    += aMAK26[ X ]
            mTOTNF     += aMAK27[ X ]
            mTOTICM    += aMAK28[ X ]
            mTOTBIPI   += aMAK29[ X ]
            mTOTBICM   += aMAK30[ X ]
            mTOTISEICM += aMAK31[ X ]
            mTOTOUTICM += aMAK32[ X ]
            mTOTISEIPI += aMAK33[ X ]
            mTOTOUTIPI += aMAK34[ X ]
            mvalpis    += aMAK35[ X ]
            mVALFIN    += aMAK36[ X ]
            IF aMAK37[ X ] = "XFRETE"
               mTOTFRETE += aMAK25[ X ]
            ENDIF
         NEXT X
         SetColor( CORMK2[ 1 ] )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         @  3, 1 SAY cCBAS
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Ý'
         MDS( 'Busca: ' )
         ScrollBarUpdate( aSBAR, pMAK2, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pMAK22 := AChoice( 05, 01, 22, 78, aMAK21,, "ACHRETB", pMAK2 )
         pMAK2  := IF( pMAK22 # 0, pMAK22, pMAK2 )
         pMAK22 := pMAK2
         DO CASE
         CASE LastKey() = K_ESC
            EXIT
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMAK2( 1, pMAK2 )
         CASE LastKey() = K_ENTER .AND. wMAK2 # 3
            MDS( 'Alterando ' )
            fMAK2( 2, pMAK2 )
         CASE LastKey() = K_ENTER .AND. wMAK2 = 3
            MDS( 'Escolhendo' )
            fMAK2( 6, pMAK2 )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAK2( 3, pMAK2 )
         CASE LastKey() = K_CTRL_ENTER .OR. LastKey() = K_CTRL_F2  // CTRL+ENTER USO O aMAK21
            IF LastKey() = K_CTRL_ENTER
               PEGBUS()
            ELSE
               nIBUS   := IF( lPBUS, NUMIND( ARQWORK2 ), nIBUS )
               mCHABUS := PEGBUS( ARQWORK2, nIBUS )
               nREG    := REGBUS( ARQWORK2, nIBUS, mCHABUS )
            ENDIF
            pMAK2 := AScan( aMAK22, Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 ) )
            IF pMAK2 = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAK2 := pMAK22
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF


   RETU .T.

// ****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAK2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAK2( OPRMAK2, POSMAK2 )   // INC = 1// MUD=2//EXC=3 // POSICAO MATRIZ

// ****************************************************************************
   INCLUI := .F.
// Pegar a Chave de Busca
   IF OPRMAK2 # 1
      IF cVIDE = 'S'
         mCHAVE := aMAK22[ POSMAK2 ]
      ENDIF
      IF cVIDE = 'N'
         PEGBUS()
      ENDIF
   ENDIF


// Opera‡„o de Exclus„o
   IF OPRMAK2 = 3
      IF APAGAREG( ARQWORK2, mCHAVE )
         IF cVIDE = "S"
            aMAK21[ POSMAK2 ] = ' ' + Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PCK := .T.
         // mOLDQTDDE := MAK2K06()
         // MAK2K05("E")
         aMAK25[ POSMAK2 ] = 0
         aMAK26[ POSMAK2 ] = 0
         aMAK27[ POSMAK2 ] = 0
         aMAK28[ POSMAK2 ] = 0
         aMAK29[ POSMAK2 ] = 0
         aMAK30[ POSMAK2 ] = 0
         aMAK31[ POSMAK2 ] = 0
         aMAK32[ POSMAK2 ] = 0
         aMAK33[ POSMAK2 ] = 0
         aMAK34[ POSMAK2 ] = 0
         aMAK35[ POSMAK2 ] = 0
         aMAK36[ POSMAK2 ] = 0
         aMAK37[ POSMAK2 ] = ""
      ENDIF
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMAK2 = 1
      mNRNOTA    := yNUMERO
      mFORNECEDO := yFORNECEDO
      mTIPOSERV  := "1"
      mVALFRE    := 0
      mIPI       := 0
      mCODIPI    := ""
      mCLASSIPI  := ""
      mICM       := 0
      mCOMPRAS   := 0
      mCOMITEM   := 0
      mCRM       := 0
      mPRECO     := 0
      mITEM      := Len( aMAK22 )
      mITEM++
      mSOMANF  := "S"
      mCONSUMO := "N"
      mPESOCRM := 0
      mENTRCRM := CToD( Space( 8 ) )
      mPEDCCRM := " "
      mPRCCRM  := 0
      PDIPI( yCFONEW, "mCODICM", "mDIPIPI", "mDIPICM",,, 2 )
      PEGBUS()
      IF !NOVOREG( ARQWORK2, mCHAVE )
         RETU .F.
      ENDIF
      INCLUI := .T.
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( ARQWORK2, mCHAVE )
      RETU .F.
   ENDIF
   xCODIPI    := mCODIPI
   mNUMERO    := yNUMERO
   mDATA      := yDATA
   mFORNECEDO := yFORNECEDO
   mOPERACAO  := yOPERACAO
   mCFONEW    := yCFONEW
   mCFONEWB   := yCFONEWB
   mSUBOPER   := ySUBOPER
   mAPURA     := yAPURA
   xVALORMER  := mVALORMER
   xBASEICM   := mBASEICM
   xBASEIPI   := mBASEIPI
   xIPI       := mIPI
   mCOGFOR    := mCOGNOME

// Vari veis de Referencias
   xCODIGO := mCODIGO
   yCODIGO := mCODIGO

// Funcoes de Ajustes
   NFBAS( mVALFRE, mREDICM )
   MAM201()
   IF Empty( mCODDEP )   // Codigo Despesas Tenta Pedidos
      IF !Empty( mCOMPRAS )
         IF !PEGACAMPO( "MW02", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "CODDEP" }, { "mCODDEP" } )
            PEGACAMPO( "MW02BX", "STR(mCOMPRAS,8)+STR(mCOMITEM,3)", { "CODDEP" }, { "mCODDEP" } )
         ENDIF
      ENDIF
   ENDIF
   IF Empty( mCODDEP )   // Codigo Despesas Pega Cabecario
      mCODDEP := mCOD
   ENDIF
   IF Empty( mCODPGMW )  // Condicao Pagamento Pedido
      IF !Empty( mCOMPRAS )
         IF !PEGACAMPO( "MW01", "mCOMPRAS", { "COMCPAG" }, { "mCODPGMW" } )
            PEGACAMPO( "MW01BX", "mCOMPRAS", { "COMCPAG" }, { "mCODPGMW" } )
         ENDIF
      ENDIF
   ENDIF



// Desenha a Tela
   TELASAY( aMK2TEL )
// Get nas Menvars
   EDITSAY( aMK2GET )



// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAK2 # 1
      aMAK21[ POSMAK2 ] = ' ' + Str( mITEM, 2 ) + ' ' + mTIPOENT + ' ' + Str( mQTDE, 10, 4 ) + ' ' + PadR( mCODIGO, 20 ) + ' ' + Left( mNOME, 15 ) + ' ' + Str( mPRECO, 9, 4 ) + ' ' + Str( mVALORMER, 9, 2 )
      aMAK22[ POSMAK2 ] = Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 )
      aMAK25[ POSMAK2 ] = mVALORMER
      aMAK26[ POSMAK2 ] = mVALORIPI
      aMAK27[ POSMAK2 ] = mVALORTOT
      aMAK28[ POSMAK2 ] = mVALORICM
      aMAK29[ POSMAK2 ] = mBASEIPI
      aMAK30[ POSMAK2 ] = mBASEICM
      aMAK31[ POSMAK2 ] = mISENTAIPI
      aMAK32[ POSMAK2 ] = mOUTRAICM
      aMAK33[ POSMAK2 ] = mISENTAIPI
      aMAK34[ POSMAK2 ] = mOUTRAIPI
      aMAK35[ POSMAK2 ] = mVAIPIS
      aMAK36[ POSMAK2 ] = mVAIFIN
      aMAK37[ POSMAK2 ] = mTIPOENT + mCODIGO
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMAK2 = 1
      nSBAR++
      AAdd( aMAK21, NIL )
      AAdd( aMAK22, NIL )
      AAdd( aMAK25, NIL )
      AAdd( aMAK26, NIL )
      AAdd( aMAK27, NIL )
      AAdd( aMAK28, NIL )
      AAdd( aMAK29, NIL )
      AAdd( aMAK30, NIL )
      AAdd( aMAK31, NIL )
      AAdd( aMAK32, NIL )
      AAdd( aMAK33, NIL )
      AAdd( aMAK34, NIL )
      AAdd( aMAK35, NIL )
      AAdd( aMAK36, NIL )
      AAdd( aMAK37, NIL )
      POSMAK2 := Len( aMAK21 )
      POSW    := 1
      IF POSMAK2 > 1
         FOR X := 1 TO POSMAK2 - 1
            mDARE := aMAK22[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMAK21, POSW )
      AIns( aMAK22, POSW )
      AIns( aMAK25, POSW )
      AIns( aMAK26, POSW )
      AIns( aMAK27, POSW )
      AIns( aMAK28, POSW )
      AIns( aMAK29, POSW )
      AIns( aMAK30, POSW )
      AIns( aMAK31, POSW )
      AIns( aMAK32, POSW )
      AIns( aMAK33, POSW )
      AIns( aMAK34, POSW )
      AIns( aMAK35, POSW )
      AIns( aMAK36, POSW )
      AIns( aMAK37, POSW )
      aMAK21[ POSW ] = ' ' + mTIPOENT + ' ' + Str( mQTDE, 10, 4 ) + ' ' + mCODIGO + ' ' + Left( mNOME, 20 ) + ' ' + Str( mPRECO, 16, 4 ) + ' ' + Str( mVALORMER, 16, 2 )
      aMAK22[ POSW ] = Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + mCODIGO + Str( mITEM, 2 )
      aMAK25[ POSW ] = mVALORMER
      aMAK26[ POSW ] = mVALORIPI
      aMAK27[ POSW ] = mVALORTOT
      aMAK28[ POSW ] = mVALORICM
      aMAK29[ POSW ] = mBASEIPI
      aMAK30[ POSW ] = mBASEICM
      aMAK31[ POSW ] = mISENTAICM
      aMAK32[ POSW ] = mOUTRAICM
      aMAK33[ POSW ] = mISENTAIPI
      aMAK34[ POSW ] = mOUTRAIPI
      aMAK35[ POSW ] = mVAIPIS
      aMAK36[ POSW ] = mVAIFIN
      aMAK37[ POSW ] = mTIPOENT + mCODIGO
      pMAK2 := POSW
   ENDIF

   REPORVARS( ARQWORK2, mCHAVE )


// ////////////////Grava Precos CRM e Requisicao
   IF mCRM > 0
      GRAVAMVAR( "CRM", mCRM, "PRECONF", "mPRECO" )
   ENDIF
// if mNUMMY04>0
// GRAVAMVAR( "MY04", mNUMMY04, "PRCMK02", "mPRECO" )
// ENDIF
// ////////////////

   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAK2A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAK2A

   IF mTIPOSERV = "3" .OR. mTIPOSERV = "4" .OR. mTIPOSERV = "6"
      PRIV GETLIST := {}
      TELAOLD := SaveScreen( 06, 12, 11, 66 )
      hb_DispBox( 6, 12, 11, 66, B_DOUBLE )
      @  7, 31 SAY "Devolu‡”es"
      @  8, 18 SAY "Nota" + spac( 6 ) + "Data" + spac( 6 ) + "Qtdde    Valor"
      @  9, 14 SAY "1¦"
      @ 10, 14 SAY "2¦"
      @  9, 18 GET mNOTA_DEV
      @  9, 28 GET mDATA_DEV
      @  9, 38 GET mQTDE_DEV
      @  9, 47 GET mVALD_DEV
      @ 10, 18 GET mNOTA_DEV2
      @ 10, 28 GET mDATA_DEV2
      @ 10, 38 GET mQTDE_DEV2
      @ 10, 47 GET mVALD_DEV2
      READCUR()
      RestScreen( 06, 12, 11, 66, TELAOLD )
      SetCursor( IF( ReadInsert(), 1, 2 ) )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAK299()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAK299

   LOCAL cOPER := Left( mOPERACAO, 3 )

   IF ( cOPER = "111" .OR. cOPER = "131" .OR. cOPER = "231" .OR. cOPER = "211" ) .AND. Empty( mCLASSIPI )
      ALERTX( "Classificacao Fiscal em Branco" )
   ENDIF
   RETU .T.

// + EOF: m_ak2.prg
// +
