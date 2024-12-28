// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_an.prg
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

// :***************************************************************************
// :
// :   M_AN1.PRG   : Contas a Receber
// :   Linguagem   : Clipper 5.x
// :        Sistema: ITAESBRA
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "TECLAS.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_an()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_an

   PARA ARQWORK

// Recebendo Parametro de Trabalho
   wMAN  := 0
   wpMAN := 1
   wcMAN := 0


// Modo de Trabalho no Video
   MDI( " › ",,, ARQWORK )

// ConfiguraáÑo de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( ARQWORK, "Fatura     Vencera Cliente" + spac( 13 ) + "Valor Receber" + spac( 6 ) + "DDD+Telefone   DIAS" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAN := CORARR( "MAN" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE

   CRIARVARS( ARQWORK )

// CRIANDO MATRIZES
   aMAN1 := {}   // Matriz com os dizeres do Achoice
   aMAN2 := {}   // N£mero da Nota + Data de Vencimento


// Incializando a ajuda on Line
   PRIV HELPDBF := ARQWORK

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAN # 2
      nIND := IF( lPIND, NUMIND( ARQWORK ), nIEXI )
      IF !USEREDE( ARQWORK, 1, nIND )
         RETU
      ENDIF
      GRAF := LastRec()
      IF GRAF > nACHO
         dbCloseArea()
         ALERTX( "Muitos Arquivos para o Modo V°deo" )
         cVIDE := "N"
      ELSE
         xGRAF := 0
         xPOS  := 1
         MARCAR()
         dbGoTop()
         WHILE !Eof()
            EQUVARS()
            MAN01( .F. )
            NETRECLOCK()
            FIELD->JUROS     := mJUROS
            FIELD->DIAS      := mDIAS
            FIELD->DIFERENCA := mDIFERENCA
            FIELD->VALATUAL  := mVALATUAL
            FIELD->PREVATR   := mPREVATR
            dbUnlock()
            IF !Empty( mCBAR )
               AAdd( aMAN1, &mCBAR. )
            ELSE
               AAdd( aMAN1, ' ' + Str( NUMERO, 8 ) + ' ' + TIPFAT + ' ' + DToC( VENCIMENT ) + ' ' + Str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + Str( VALATUAL, 15, 2 ) + ' ' + DDD + ' ' + TELEFONE + ' ' + Str( DIAS, 3 ) + ' ' + Str( BANCO, 3 ) )
            ENDIF
            AAdd( aMAN2, DToS( VENCIMENT ) + Str( NUMERO, 8 ) + TIPFAT )
            xPOS++
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            IF !MDG( 'Nenhum Lanáamento Neste Arquivo. Deseja Incluir ?' )
               RETU .F.
            ENDIF
            nSBAR := 0
            IF !fMAN( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// PosiáÑo Inicial do Ponteiro
   pMAN := 1

// Processando o MÇtodo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMAN1 )
      aSBAR := ScrollBarNew( 03, 79, 23,, pMAN )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAN, nSBAR, .T. )
      WHILE .T.
         SetColor( CORMAN[ 1 ] )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         @  3, 1 SAY cCBAS
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + '›'
         MDS( 'Busca: ' )
         ScrollBarUpdate( aSBAR, pMAN, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pMAN2 := AChoice( 05, 01, 22, 78, aMAN1,, "ACHRETB", pMAN )
         pMAN  := IF( pMAN2 # 0, pMAN2, pMAN )
         pMAN2 := pMAN
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
            fMAN( 1, pMAN )
         CASE LastKey() = K_ENTER .AND. wMAN # 3
            MDS( 'Alterando ' )
            fMAN( 2, pMAN )
         CASE LastKey() = K_ENTER .AND. wMAN = 3
            MDS( 'Escolhendo' )
            fMAN( 6, pMAN )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAN( 3, pMAN )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := IF( lPBUS, NUMIND( ARQWORK ), nIBUS )
            mCHABUS := PEGBUS( ARQWORK, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( ARQWORK, nIBUS, mCHABUS )
            ENDIF
            pMAN := AScan( aMAN2, mCHAVE )
            IF pMAN = 0
               MDE( "NLOCAL", "", "" )
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAN := pMAN2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = 'N'
      METNVI( ARQWORK, {|| fMAN( 1, 0 ) }, {|| fMAN( 3, 0 ) }, {|| fMAN( 2, 0 ) }, ;
         {|| fMAN( 6, 0 ) }, {|| fMAN( 2, - 1 ) }, CORMAN[ 1 ], wMAN )
   ENDIF

   IF cVIDE = 'P'
      METPAG( ARQWORK, CORMAN, "DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT", wMAL, ;
         {|| tMAL() }, {|| fMAL( 1, 0 ) }, {|| fMAL( 3, 0 ) }, {|| fMAL( 2, 0 ) }, ;
         {|| fMAL( 6, 0 ) } )
   ENDIF

   IF cVIDE = 'I'
      METINT( ARQWORK,, {|| fMAN( 2, - 1 ) } )
   ENDIF



// LIBERA VARIAVEIS
   RELEASE ALL LIKE m *


// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQWORK )
   ENDIF
   RETU .T.

// ***************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAN( OPRMAN, POSMAN )  // INC = 1// MUD=2//EXC=3 // POSICAO MATRIZ

// ***************************************************************************
// Pegar a Chave de Busca
   IF OPRMAN # 1
      IF cVIDE = 'S'
         mCHAVE := aMAN2[ POSMAN ]
      ENDIF
      IF cVIDE = 'N' .AND. POSMAN # -1
         PEGBUS()
      ENDIF
   ENDIF

// OperaáÑo de ExclusÑo
   IF OPRMAN = 3
      IF APAGAREG( ARQWORK, mCHAVE )
         IF cVIDE = "S"
            aMAN1[ POSMAN ] = ' ' + Str( mNUMERO, 8 ) + ' ' + DToS( mVENCIMENT ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

// OperaáÑo de InclusÑo
   IF OPRMAN = 1
      CRIARVARS( ARQWORK )
      PEGBUS()
      IF !NOVOREG( ARQWORK, mCHAVE )
         RETU .F.
      ENDIF
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( ARQWORK, mCHAVE )
      RETU .F.
   ENDIF
   yDATAPG  := mDATAPG
   yVALORPG := mVALORPG


// Desenha a Tela
   tMAN()
// Get nas Menvars
   gMAN()



// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAN # 1
      IF !Empty( mCBARM )
         aMAN1[ POSMAN ] = &mCBARM.
      ELSE
         aMAN1[ POSMAN ] = ' ' + Str( mNUMERO, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + Str( mVALATUAL, 15, 2 ) + ' ' + mDDD + ' ' + mTELEFONE + ' ' + Str( mDIAS, 3 ) + ' ' + Str( mBANCO, 3 )
      ENDIF
      aMAN2[ POSMAN ] = DToS( mVENCIMENT ) + Str( mNUMERO, 8 ) + mTIPFAT
   ENDIF

   IF cVIDE = 'S' .AND. OPRMAN = 1
      MAN03()
   ENDIF

   IF ARQWORK == "MN01PG" .AND. Empty( mDATAPG ) .AND. Empty( mVALORPG )
      IF MDG( "Retornar ao Contas a Receber" )
         NOVOREG( "MN01", mCHAVE )
         APAGAREG( "MN01PG", mCHAVE, .F. )
         IF cVIDE = "S"
            aMAN1[ POSMAN ] = ' ' + Str( mNUMERO, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' - Transferido Contas a Receber'
         ENDIF
         RETU .T.
      ENDIF
   ENDIF


// Se Baixou Transfere
   IF !Empty( mDATAPG ) .AND. !Empty( mVALORPG ) .AND. "MN01" = ARQWORK
      mOBS := "Baixa Manual"
      NOVOREG( "MN01PG", mCHAVE )
      MAN01()
      APAGAREG( ARQWORK, mCHAVE, .F. )
      IF cVIDE = "S"
         aMAN1[ POSMAN ] = ' ' + Str( mNUMERO, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' - Transferido Recebidas'
      ENDIF
      IF Round( mDIFERENCA, 2 ) > Round( 0, 2 )
         IF cVIDE = "S"
            mVALOR   := mDIFERENCA
            mVALORPG := 0
            mDATAPG  := CToD( "  /  /  " )
            mAVISO   := "S"
            I        := 0
            IF Empty( mTIPFAT )
               mTIPFAT := Chr( 65 )
            ENDIF
            WHILE AScan( aMAN2, DToS( mVENCIMENT ) + Str( mNUMERO, 8 ) + mTIPFAT ) # 0
               I++
               mTIPFAT := Chr( 65 + I )
            ENDDO
            MAN03()
         ELSE
            WHILE .T.
               MDS( "Digite o tipo da Fatura" )
               @ 24, 40 GET mTIPFAT VALID !VERSEHA( "MN01", DToS( mVENCIMENT ) + Str( mNUMERO, 8 ) + mTIPFAT )
               IF READCUR()
                  EXIT
               ENDIF
            ENDDO
         ENDIF
         NOVOREG( "MN01", DToS( mVENCIMENT ) + Str( mNUMERO, 8 ) + mTIPFAT )
      ENDIF
      PCK := .T.
   ELSE
      REPORVARS( ARQWORK, mCHAVE )
   ENDIF




   RETU .T.


// Tela de Dados
// ***************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tMAN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tMAN

// ***************************************************************************
   SetColor( CORMAN[ 5 ] )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @  2, 13 SAY "—" + Replicate( '-', 9 ) + "—" + Replicate( '-', 19 ) + "—" + Replicate( '-', 15 ) + "—" + Replicate( '-', 9 ) + "—"
   @  5, 0  SAY '+'
   @  5, 79 SAY '›'
   @ 13, 79 SAY '›'
   @ 16, 0  SAY '+'
   @ 16, 79 SAY '›'
   @ 23, 45 SAY "œ"
   @  3, 2  SAY "Nota Fiscal› EmissÑo› Cliente" + spac( 12 ) + "›DDD  Telefone  ›Vendedor ›Pedido"
   @  4, 13 SAY "›" + spac( 9 ) + "›" + spac( 18 ) + "›" + spac( 16 ) + "›" + spac( 9 ) + "›"
   @  5, 1  SAY Replicate( '-', 12 ) + "-" + Replicate( '-', 9 ) + "-" + Replicate( '-', 19 ) + "---" + Replicate( '-', 13 ) + "-" + Replicate( '-', 9 ) + "-" + Replicate( '-', 9 )
   @  6, 2  SAY "Valor Total Negociado" + spac( 22 ) + "›    Vencer† em"
   @  7, 45 SAY "›"
   @  7, 2  SAY "Abater:              Documento:            ›Valor T°tulo"
   @  8, 2  SAY "Desconto PIS:            CONFINS:          ›"
   @ 10, 2  SAY "Imprimir :   (S/N) Gera Eletronica:   (S/N)›Valor Juros"
   @ 11, 1  SAY "Bco:" + Str( mBCODEP ) + "  Agc: " + mAGCDEP + " Cta: " + mCTADEP
   @ 12, 2  SAY "T°tulo Colocado em :" + spac( 23 ) + "›Banco :" + spac( 16 ) + "›Valor Atual"
   @ 13, 2  SAY "00=Cobranáa Simples›Agencia" + spac( 16 ) + "+" + Replicate( '-', 33 )
   @ 14, 2  SAY "98=Vinculada" + spac( 7 ) + "›DocBol:" + spac( 16 ) + "› Val.Atr:"
   @ 15, 2  SAY "99-Descontada" + spac( 6 ) + "›DocDup:" + spac( 16 ) + "›Atraso:     dias. Taxa Dia:"
   @ 16, 1  SAY Replicate( '-', 20 ) + "-" + Replicate( '-', 23 ) + "+" + Replicate( '-', 33 )
   @ 17, 3  SAY "Observaáîes Gerais de Cobranáa :" + spac( 10 ) + "› T°tulo Pago em:"
   @ 18, 45 SAY "› Valor Pago"
   @ 19, 45 SAY "› Contabil"
   @ 20, 45 SAY "› "
   @ 21, 45 SAY "› Diferenáa"
   @ 22, 45 SAY "›"
   SetColor( CORMAN[ 3 ] )
   @  4, 2  SAY mNUMERO
   @  4, 12 SAY mTIPFAT
   @  4, 14 SAY mDATA
   @  4, 23 SAY mTIPOCLI
   @  4, 25 SAY mFORNECEDO
   @  4, 31 SAY mCOGNOME
   @  4, 44 SAY mDDD
   @  4, 49 SAY mTELEFONE
   @  4, 62 SAY mVENDEDOR
   @  4, 70 SAY mPEDIDO
   @  6, 25 SAY mTOTNF
   @  6, 61 SAY mVENCIMENT
   @  8, 60 SAY mVALOR
   @  7, 10 SAY mABATER
   @  7, 35 SAY mDOCABATE
   @  8, 15 SAY mVALPIS
   @  8, 30 SAY mVALFIN
   @ 10, 13 SAY mIMPDUP
   @ 10, 60 SAY mJUROS
   @ 12, 30 SAY mBANCO
   @ 13, 30 SAY mNOMEBCO
   @ 14, 30 SAY mDOCBOL
   @ 14, 55 SAY mJURVAL
   @ 15, 30 SAY mDOCDUP
   @ 15, 54 SAY mDIAS
   @ 15, 74 SAY mTAXA          PICT "99.99"
   @ 17, 64 SAY mDATAPG
   @ 18, 3  SAY Left( mOBS1, 40 )
   @ 19, 3  SAY Left( mOBS2, 40 )
   @ 19, 59 SAY mVALORPG
   @ 20, 3  SAY Left( mOBS3, 40 )
   @ 21, 3  SAY Left( mOBS4, 40 )
   @ 21, 59 SAY mDIFERENCA
   @ 22, 46 SAY mOBS
   MAN01()
   RETU .T.

// Get Nas Mvars
// ***************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAN

// ***************************************************************************
   WHILE .T.
      SetColor( CORMAN[ 2 ] )
      @  4, 2 GET mNUMERO PICT '99999999'
      READCUR()
      IF LastKey() <> 3  // tecla PgDn
         @  4, 12 GET mTIPFAT
         @  4, 14 GET mDATA
         @  4, 23 GET mTIPOCLI   VALID TIPCAD( mTIPOCLI, "ARQUSO", 3, 23 )
         @  4, 25 GET mFORNECEDO PICT '99999'                         VALID PEGACAMPO( ARQUSO, "mFORNECEDO", { "COGNOME", "DDD", "TELEFONE", "VENDEDOR" }, { "mCOGNOME", "mDDD", "mTELEFONE", "mVENDEDOR" } ) WHEN TIPCAD( mTIPOCLI, "ARQUSO", 3, 23 )
         @  4, 31 GET mCOGNOME
         @  4, 44 GET mDDD
         @  4, 49 GET mTELEFONE
         @  4, 62 GET mVENDEDOR
         @  4, 70 GET mPEDIDO    PICT '99999999'
         READCUR()
      ENDIF
      @  6, 25 GET mTOTNF    PICT '9,999,999.99'
      @  7, 10 GET mABATER   PICT '999,999.99'   VALID MAN01()
      @  7, 35 GET mDOCABATE PICT '9999999999'
      @  8, 15 GET mVALPIS   PICT '999,999.99'   VALID MAN01()
      @  8, 30 GET mVALFIN   PICT '999,999.99'   VALID MAN01()
      READCUR()
      @ 10, 13 GET mIMPDUP  VALID mIMPDUP $ 'SN'  WHEN mIMPDUP <> "I"
      @ 10, 37 GET mGERACOB VALID mGERACOB $ 'SN' WHEN mGERACOB <> "G"
      @ 11, 6  GET mBCODEP
      @ 11, 14 GET mAGCDEP
      @ 11, 25 GET mCTADEP
      @ 12, 30 GET mBANCO   PICT '999'
      @ 13, 30 GET mNOMEBCO
      @ 14, 30 GET mDOCBOL  PICT '@!'
      @ 15, 30 GET mDOCDUP  PICT '@!'
      @ 18, 3  GET mOBS1    PICT "@S40"
      @ 19, 3  GET mOBS2    PICT "@S40"
      @ 20, 3  GET mOBS3    PICT "@S40"
      @ 21, 3  GET mOBS4    PICT "@S40"
      READCUR()
      @  6, 61 GET mVENCIMENT VALID MAN01()
      @  8, 60 GET mVALOR     PICT '9,999,999.99' VALID MAN01()
      @ 14, 60 GET mJURVAL    VALID MAN01()
      @ 15, 74 GET mTAXA      PICT "99.99"        VALID MAN01()
      READCUR()
      @ 17, 64 GET mDATAPG
      @ 18, 59 GET mVALORPG PICT '9,999,999.99'                                                 VALID MAN01() WHEN ALLTRUE( IF( !Empty( mDATAPG ) .AND. Empty( mVALORPG ), mVALORPG := mVALATUAL, "" ) )
      @ 19, 59 GET mCONTA   VALID CHECKEXI( "MF06", "mCONTA", "Conta+' '+Nome", "CONTA", "MF06", .T. )
      READCUR()
      IF !MAN02()
         NOBREAK()
         KEYBOARD REPL( Chr( 13 ), 23 )
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO
   MAN01()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAN01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAN01( pDIS )

   IF ValType( pDIS ) # "L"
      pDIS := .T.
   ENDIF
   mDIAS  := 0
   mJUROS := 0
   IF zDATA > mVENCIMENT .AND. Empty( mVALORPG ) .AND. !Empty( mVENCIMENT )
      mDIAS  := zDATA - mVENCIMENT
      mJUROS := Round( ( ( ( mVALOR * mTAXA ) * mDIAS ) / 100 ), 2 )
   ENDIF
   IF !Empty( mDATAPG ) .AND. !Empty( mVENCIMENT )
      mDIAS  := mDATAPG - mVENCIMENT
      mJUROS := Round( ( ( ( mVALOR * mTAXA ) * mDIAS ) / 100 ), 2 )
   ENDIF
   mVALATUAL := mVALOR + mJUROS - mABATER + mJURVAL - mVALPIS - mVALFIN
   IF !Empty( mVALORPG )
      mDIFERENCA := mVALATUAL - mVALORPG
   ENDIF
   IF mDIAS > 999 .OR. mDIAS < 0
      ALERTX( "Cheque data Vencimento: " + Str( mNUMERO ) + " " + mTIPFAT + " " + DToC( mVENCIMENT ) )
      mDIAS := 0
   ENDIF
   IF mDIAS > 0
      IF mPREVATR < mDIAS
         mPREVATR := mDIAS
      ENDIF
   ENDIF
   IF mDIAS < 0
      mDIAS := 0
   ENDIF
   IF pDIS
      @ 10, 60 SAY mJUROS + mJURVAL PICT '@E 9,999,999.99'
      @ 15, 54 SAY mDIAS          PICT '999'
      @ 21, 59 SAY mDIFERENCA     PICT '@E 9,999,999.99'
      @ 12, 60 SAY mVALATUAL      PICT '@E 9,999,999.99'
      @ 21, 59 SAY mOBS
   ENDIF
   RETU .T.


// ***************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAN02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAN02

// ***************************************************************************
   IF !Empty( mDATAPG )
      IF Empty( mVALORPG )
         MDE( "VALPG", "", "" )
         // ALERTX("Vocà nÑo digitou o Valor do Pagamento")
         RETU .F.
      ENDIF
   ENDIF
   IF !Empty( mVALORPG )
      IF Empty( mDATAPG )
         MDE( "DATPG", "", "" )
         // ALERTX("Vocà nÑo digitou a Data de Pagamento")
         RETU .F.
      ENDIF
   ENDIF
   RETU .T.

// ***************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAN03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAN03()  // Posiciona o Novo Elemento na Matriz

// ***************************************************************************
   nSBAR++
   AAdd( aMAN1, NIL )
   AAdd( aMAN2, NIL )
   POSMAN := Len( aMAN1 )
   POSW   := 1
   IF POSMAN > 1
      FOR X := 1 TO POSMAN - 1
         mDARE := aMAN2[ X ]
         IF mCHAVE <= mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AIns( aMAN1, POSW )
   AIns( aMAN2, POSW )
   IF !Empty( mCBARM )
      aMAN1[ POSW ] = &mCBARM.
   ELSE
      aMAN1[ POSW ] = ' ' + Str( mNUMERO, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + Str( mVALATUAL, 15, 2 ) + ' ' + mDDD + ' ' + mTELEFONE + ' ' + Str( mDIAS, 3 ) + ' ' + Str( mBANCO, 3 )
   ENDIF
   aMAN2[ POSW ] = DToS( mVENCIMENT ) + Str( mNUMERO, 8 ) + mTIPFAT
   pMAN := POSW
   RETU .T.

// + EOF: m_an.prg
// +
