// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_al.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   M_AL .PRG   : Contas a Pagar e Pagas
// :   Linguagem   : Clipper 5.X
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :      Atualizado: 02/09/97
// :
// :*****************************************************************************

// Teclas Operacionais
// #INCLUDE "TECLASM.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Recebendo Parametro de Trabalho


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_al()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_al

   PARA ARQWORK

   wMAL  := 0
   wpMAL := 1
   wcMAL := 0

// Modo de Trabalho no Video
   MDI( " Ý ",,, ARQWORK )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG


   IF !CONFARQ( ARQWORK, "Fatura     Vencera Cliente" + spac( 13 ) + "Valor Receber" + spac( 6 ) + "DDD+Telefone   DIAS" ;
         , "' '+STR(mNRNOTA,  8)+' '+mTIPFAT+' '+DTOC(mVENCIMENT)+' '+STR(mCLIENTE,  5)+' '+mCOGNOME+' '+STR(mVALOR,18,2)+' '+mDDD+' '+mTELEFONE+' '+STR(mDIAS,3)" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAL := CORARR( "MAL" )

// Variaveis de Trabalho
   xTAXA := 0
   IF ARQWORK == "ML01"
      MDS( "Confirme a Taxa de Juros Dia" )
      @ 24, 40 GET xTAXA PICT "99.9999"
      READCUR()
   ENDIF

   PRIV PCK    := .F.
   PRIV mCHAVE

   CRIARVARS( ARQWORK )

// CRIANDO MATRIZES
   aMAL1 := {}   // Matri com os di eres do Achoice
   aMAL2 := {}   // N£mero da Nota + Data de Vencimento


// Inic. a ajuda on Line
   PRIV HELPDBF := "ML01"

// Telas de Trabalho
   aMALTEL := TELAPEG( "MAL001" )


// Carregando Matri
   IF cVIDE = "S" .AND. wcMAL # 2
      // Filtro da Listagem
      FILTRO := ''
      FILTRO := RFILORD( "ML01", .F. )
      nIND   := IF( lPIND, NUMIND( ARQWORK ), nIEXI )
      IF !USEREDE( ARQWORK, 1, nIND )
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
         IF !Empty( FILTRO )
            SET FILTER TO &FILTRO
         ENDIF
         dbGoTop()
         zATRAZO := zVENCER := zHOJE := 0.00
         WHILE !Eof()
            IF ARQWORK = "ML01"
               //
               // Ajustes Atrasos
               //
               EQUVARS()
               IF xTAXA > 0
                  mTAXA := xTAXA
               ENDIF
               MAL01( .F. )
               netreclock()
               FIELD->JUROS     := mJUROS
               FIELD->DIAS      := mDIAS
               FIELD->DIFERENCA := mDIFERENCA
               FIELD->VALATUAL  := mVALATUAL
               FIELD->PREVATR   := mPREVATR
               dbUnlock()
            ENDIF
            IF !Empty( mCBAR )
               AAdd( aMAL1, &mCBAR. )
            ELSE
               AAdd( aMAL1, ' ' + Str( NRNOTA, 8 ) + ' ' + TIPFAT + ' ' + DToC( VENCIMENT ) + ' ' + Str( CLIENTE, 5 ) + ' ' + COGNOME + ' ' + Str( VALOR, 18, 2 ) + ' ' + DDD + ' ' + TELEFONE + ' ' + Str( DIAS, 3 ) )
            ENDIF
            AAdd( aMAL2, DToS( VENCIMENT ) + Str( NRNOTA, 8 ) + TIPFAT )
            xPOS++
            IF FLUXO # 'N'
               zATRAZO += IF( Date() > VENCIMENT, VALOR, 0 )
               zVENCER += IF( Date() < VENCIMENT, VALOR, 0 )
               zHOJE   += IF( Date() = VENCIMENT, VALOR, 0 )
            ENDIF
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            IF !mdg( 'Nenhum Lan‡amento Neste Arquivo Deseja Incluir' )
               RETU .F.
            ENDIF
            nSBAR := 0
            IF !fMAL( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   pMAL := 1

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMAL1 )
      aSBAR := ScrollBarNew( 04, 79, 22, SubStr( CORMAL[ 1 ], RAt( ",", CORMAL[ 1 ] ) + 1 ), pMAL )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAL, nSBAR, .T. )
      WHILE .T.
         CABVID( CORMAL[ 1 ], pMAL )
         nKEY := 0
         KEYBOARD Chr( 255 )
         bELE := {| X | aMAL1[ X ] }
         cCOR := CORMAL[ 1 ]
         @ 23, 0
         @ 23, 02 SAY 'Vencido: ' + LTrim( TRANS( zATRAZO, '@E 999,999,999.99' ) )
         @ 23, 24 SAY 'Hoje: ' + LTrim( TRANS( zHOJE, '@E 999,999,999.99' ) )
         @ 23, 45 SAY 'Pagar: ' + LTrim( TRANS( zVENCER, '@E 999,999,999.99' ) )
         @ 23, 67 SAY 'T=' + LTrim( TRANS( zATRAZO + zHOJE + zVENCER, '@E 999,999,999.99' ) )
         @ 22, 00 SAY "+" + REPL( "-", 78 )
         pMAL2 := AChoice( 5, 1, 21, 78, aMAL1,, "ACHMOU", pMAL )
         pMAL  := IF( pMAL2 # 0, pMAL2, pMAL )
         pMAL2 := pMAL
         DO CASE
         CASE LastKey() = K_ESC
            IF mdg( 'Encerrar Consulta' )
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMAL( 1, pMAL )
         CASE LastKey() = K_ENTER .AND. wMAL # 3
            MDS( 'Alterando ' )
            fMAL( 2, pMAL )
         CASE LastKey() = K_ENTER .AND. wMAL = 3
            MDS( 'Escolhendo' )
            fMAL( 6, pMAL )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAL( 3, pMAL )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := IF( lPBUS, NUMIND( ARQWORK ), nIBUS )
            mCHABUS := PEGBUS( ARQWORK, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( ARQWORK, nIBUS, mCHABUS )
            ENDIF
            pMAL := AScan( aMAL2, mCHAVE )
            IF pMAL = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAL := pMAL2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = 'N'
      METNVI( ARQWORK, {|| fMAL( 1, 0 ) }, {|| fMAL( 3, 0 ) }, {|| fMAL( 2, 0 ) }, ;
         {|| fMAL( 6, 0 ) }, {|| fMAL( 2, - 1 ) }, CORMAL[ 1 ], wMAL )
   ENDIF
   IF cVIDE = 'P'
      METPAG( ARQWORK, CORMAL, "DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT", wMAL, ;
         {|| TELASAY( aMALTEL ) }, {|| fMAL( 1, 0 ) }, {|| fMAL( 3, 0 ) }, {|| fMAL( 2, 0 ) }, ;
         {|| fMAL( 6, 0 ) } )
   ENDIF

   IF cVIDE = 'I'
      METINT( ARQWORK,, {|| fMAL( 2, - 1 ) } )
   ENDIF


// LIBERA VARIAVEIS
   RELEASE ALL LIKE m *  // LIMPAVARS(ARQWORK)


// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQWORK )
   ENDIF
   RETU .T.

// ******************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAL( OPRMAL, POSMAL )  // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
// Pegar a Chave de Busca
   IF OPRMAL # 1
      IF cVIDE = 'S'
         mCHAVE := aMAL2[ POSMAL ]
      ENDIF
      IF cVIDE = 'N' .AND. POSMAL # -1
         PEGBUS( ARQWORK, 1 )
      ENDIF
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMAL = 3
      IF APAGAREG( ARQWORK, mCHAVE )
         IF cVIDE = "S"
            aMAL1[ POSMAL ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + DToC( mVENCIMENT ) + ' ' + mTIPFAT + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PCK := .T.
         IF mFLUXO # 'N'
            zATRAZO -= IF( Date() > mVENCIMENT, mVALOR, 0 )
            zVENCER -= IF( Date() < mVENCIMENT, mVALOR, 0 )
            zHOJE   -= IF( Date() = mVENCIMENT, mVALOR, 0 )
         ENDIF
      ENDIF
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMAL = 1
      mTIPOCLI := 'F'
      PEGBUS( ARQWORK, 1 )
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
   IF xTAXA > 0
      mTAXA := xTAXA
   ENDIF
   TIPCAD( mTIPOCLI, "ARQUSO", 3, 24 )

// Metodo de Edi‡„o
   IF cTIPG = "1"
      // Desenha a Tela
      TELASAY( aMALTEL )
      // Get nas Menvars
      gMAL()
   ELSE
      EDITGET( .T., CORMAL )
   ENDIF

// Atualiza as Matri se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAL # 1
      IF !Empty( mCBARM )
         aMAL1[ POSMAL ] = &mCBARM.
      ELSE
         aMAL1[ POSMAL ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' ' + Str( mCLIENTE, 5 ) + ' ' + mCOGNOME + ' ' + Str( mVALOR, 18, 2 ) + ' ' + mDDD + ' ' + mTELEFONE + ' ' + Str( mDIAS, 3 )
      ENDIF
      aMAL2[ POSMAL ] = DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMAL = 1
      MAL03()
   ENDIF

   IF ARQWORK == "ML01PG" .AND. Empty( mDATAPG ) .AND. Empty( mVALORPG )
      IF mdg( "Retornar ao Contas a Pagar" )
         NOVOREG( "ML01", mCHAVE )
         APAGAREG( "ML01PG", mCHAVE, .F. )
         IF cVIDE = "S"
            aMAL1[ POSMAL ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' - Transferido Contas a Pagar'
         ENDIF
         RETU .T.
      ENDIF
   ENDIF

   IF !Empty( mDATAPG ) .AND. !Empty( mVALORPG ) .AND. "ML01" = ARQWORK
      mOBS := "Baixa Manual"
      NOVOREG( "ML01PG", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
      APAGAREG( ARQWORK, mCHAVE, .F. )
      IF cVIDE = "S"
         aMAL1[ POSMAL ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + DToC( mVENCIMENT ) + ' - Transferido Contas a Pagar'
      ENDIF
      IF mFLUXO # 'N'
         zATRAZO -= IF( Date() > mVENCIMENT, mVALOR, 0 )
         zVENCER -= IF( Date() < mVENCIMENT, mVALOR, 0 )
         zHOJE   -= IF( Date() = mVENCIMENT, mVALOR, 0 )
      ENDIF
      IF Round( mDIFERENCA, 2 ) < Round( 0, 2 )
         mVALOR   := mDIFERENCA
         mVALORPG := 0
         mDATAPG  := CToD( "  /  /  " )
         mAVISO   := "S"
         IF cVIDE = "S"
            I       := 0
            mTIPFAT := Chr( 64 + I )
            WHILE AScan( aMAL2, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT ) # 0
               I++
               mTIPFAT := Chr( 64 + I )
            ENDDO
            MAL03()
         ELSE
            WHILE .T.
               MDS( "Digite o tipo da Fatura" )
               @ 24, 40 GET mTIPFAT VALID !VERSEHA( "ML01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
               IF READCUR()
                  EXIT
               ENDIF
            ENDDO
         ENDIF
         NOVOREG( "ML01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
      ENDIF
      PCK := .T.
   ELSE
      REPORVARS( ARQWORK, mCHAVE )
   ENDIF
   RETU .T.




// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAL

   SET KEY K_F11 TO TECLAF11
   WHILE .T.
      SetColor( CORMAL[ 2 ] )
      TIPCAD( mTIPOCLI, "ARQUSO", 3, 24 )
      xVALOR     := mVALOR
      xVENCIMENT := mVENCIMENT
      @  4, 2  GET mNRNOTA                       PICT '99999999'
      @  4, 12 GET mTIPFAT
      @  4, 14 GET mDATA
      @  4, 24 GET mTIPOCLI                      PICT "!"                                                                                                                         VALID TIPCAD( mTIPOCLI, "ARQUSO", 3, 24 )
      @  4, 26 GET mCLIENTE                      PICT '99999'                                                                                                                     VALID MALDEP()
      @  4, 32 GET mCOGNOME
      @  4, 46 GET mDDD
      @  4, 51 GET mTELEFONE // PICT '####-####'
      @  4, 63 GET mVENDEDOR
      @  4, 70 GET mPEDIDO                       PICT '99999999'
      @  6, 25 GET mTOTFAT                       PICT '999,999,999,999.99'
      @  7, 8  GET mBCODEP                       PICT '999'                                                                                                                       VALID CHECKEXI( "MF01", "STRZERO(mBCODEP,3)", "STRVAL(NUMERO)+' '+NOME", "NUMERO", "BANCO", .T. )
      @  7, 19 GET mAGCDEP
      @  7, 32 GET mCTADEP
      @  8, 25 GET mDOCABATE                     PICT '99999999'
      @  9, 25 GET mABATER                       PICT '999,999,999,999.99'                                                                                                        VALID MAL01()
      @ 10, 19 GET mHISTORICO                    VALID CHECKEXI( IF( Empty( ZARQHIS ), "MI02", ZARQHIS ), "MHISTORICO", "CODIGO+' '+DESCRICAO+' '+TIPO", "CODIGO", "HISTO", .T., 0, "TIPO='D'" )
      @ 11, 19 GET mTIPCOB                       VALID CHECKTAB( "TIPPAG", "mTIPCOB", "ETCOB",, "LEFT(CODIGO1,2)" )
      @ 12, 19 GET mSITPAG                       VALID CHECKTAB( "SITPAG", "mSITPAG", "SITPAG",, "LEFT(CODIGO1,2)" )
      @ 12, 30 GET mBANCO                        PICT '999'                                                                                                                       VALID CHECKEXI( "MF01", "STRZERO(mBANCO,3)", "STRVAL(NUMERO)+' '+NOME", "NUMERO", "BANCO", .F. )
      @ 13, 30 GET mNOMEBCO
      @ 14, 30 GET mDOCBOL                       PICT '999999999999999'
      @ 15, 30 GET mDOCDUP                       PICT '999999999999999'
      @ 18, 3  GET mOBS1                         PICT "@S40"
      @ 19, 3  GET mOBS2                         PICT "@S40"
      @ 20, 3  GET mOBS3                         PICT "@S40"
      @ 21, 3  GET mOBS4                         PICT "@S40"
      @  6, 58 GET mVENCIMENT                    VALID MAL01()
      IF "ML01" = ARQWORK
         @  6, 73 GET mFLUXO PICTURE "!" VALID mFLUXO $ 'SN'
      ENDIF
      @  8, 60 GET mVALOR  PICT '999,999,999,999.99' VALID MAL01()
      @ 13, 67 GET mJURVAL VALID MAL01()
      IF "ML01" = ARQWORK
         @ 14, 62 GET mPREVATR PICTURE '999'
      ENDIF
      @ 15, 74 GET mTAXA    PICT "99.99"              VALID MAL01()
      @ 17, 64 GET mDATAPG
      @ 19, 59 GET mVALORPG PICT '999,999,999,999.99' VALID MAL01()
      @ 22, 18 GET mBCOPAG  PICT '999'                VALID CHECKEXI( "MF01", "STRZERO(mBCOPAG,3)", "STRVAL(NUMERO)+' '+NOME", "NUMERO", "BANCO", .T. )
      @ 22, 29 GET mAGCPAG
      @ 22, 42 GET mCTAPAG
      @ 22, 56 GET mCHEPAG
      READCUR()
      IF mFLUXO # 'N'
         IF mVALOR # xVALOR
            zATRAZO += IF( Date() > xVENCIMENT, mVALOR - xVALOR, 0 )
            zVENCER += IF( Date() < xVENCIMENT, mVALOR - xVALOR, 0 )
            zHOJE   += IF( Date() = xVENCIMENT, mVALOR - xVALOR, 0 )
         ENDIF
         IF mVENCIMENT # xVENCIMENT
            zATRAZO -= IF( Date() > xVENCIMENT, xVALOR, 0 )
            zVENCER -= IF( Date() < xVENCIMENT, xVALOR, 0 )
            zHOJE   -= IF( Date() = xVENCIMENT, xVALOR, 0 )
            zATRAZO += IF( Date() > mVENCIMENT, mVALOR, 0 )
            zVENCER += IF( Date() < mVENCIMENT, mVALOR, 0 )
            zHOJE   += IF( Date() = mVENCIMENT, mVALOR, 0 )
         ENDIF
      ENDIF
      IF !MAL02()
         NOBREAK()
         KEYBOARD REPL( Chr( 13 ), 23 )
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO
   SET KEY K_F11 TO
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAL01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAL01( pDIS )

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
   mVALATUAL := mVALOR - mABATER + mJURVAL
   IF !Empty( mVALORPG )
      mDIFERENCA := mVALORPG - mVALATUAL
   ENDIF
   IF mDIAS > 999 .OR. mDIAS < 0
      ALERTX( "Cheque data Vencimento: " + Str( mNRNOTA ) + " " + mTIPFAT + " " + DToC( mVENCIMENT ) )
      mDIAS := 0
   ENDIF
   IF mDIAS > 0
      IF mPREVATR < mDIAS
         mPREVATR := mDIAS
      ENDIF
   ENDIF
   IF mPREVATR > 999 .OR. mPREVATR < 0
      mPREVATR := 0
   ENDIF
   IF pDIS
      @ 10, 60 SAY mJUROS + mJURVAL PICT '@E 999,999,999,999.99'
      @ 15, 54 SAY mDIAS          PICT '999'
      @ 21, 59 SAY mDIFERENCA     PICT '@E 999,999,999,999.99'
      @ 11, 60 SAY mVALATUAL      PICT '@E 999,999,999,999.99'
      @ 24, 46 SAY mOBS
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAL02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAL02

   IF !Empty( mDATAPG )
      IF Empty( mVALORPG )
         ALERTX( "Vocˆ n„o digitou o Valor do Pagamento" )
         RETU .F.
      ENDIF
   ENDIF
   IF !Empty( mVALORPG )
      IF Empty( mDATAPG )
         ALERTX( "Vocˆ n„o digitou a Data de Pagamento" )
         RETU .F.
      ENDIF
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAL03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAL03

   nSBAR++
   AAdd( aMAL1, NIL )
   AAdd( aMAL2, NIL )
   POSMAL := Len( aMAL1 )
   POSW   := 1
   IF POSMAL > 1
      FOR X := 1 TO POSMAL - 1
         mDARE := aMAL2[ X ]
         IF mCHAVE <= mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AIns( aMAL1, POSW )
   AIns( aMAL2, POSW )
   IF !Empty( mCBARM )
      aMAL1[ POSW ] = &mCBARM.
   ELSE
      aMAL1[ POSW ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' ' + Str( mCLIENTE, 5 ) + ' ' + mCOGNOME + ' ' + Str( mVALOR, 18, 2 ) + ' ' + mDDD + ' ' + mTELEFONE + ' ' + Str( mDIAS, 3 )
   ENDIF
   aMAL2[ POSW ] = DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT
   pMAL := POSW
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MALDEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MALDEP

   ALLTRUE( PEGACAMPO( ARQUSO, "mCLIENTE", { "COGNOME", "DDD", "TELEFONE" }, { "mCOGNOME", "mDDD", "mTELEFONE" } ) )
   IF ARQUSO == "MB01"
      PEGACAMPO( ARQUSO, "mCLIENTE", { "BANCO", "AGENCIA", "CONTA" }, { "mBCODEP", "mAGCDEP", "mCTADEP" } )
   ENDIF
   RETU .T.

// + EOF: m_al.prg
// +
