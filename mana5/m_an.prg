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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_AN.PRG    :
// :   Linguagem   : harbour
// :        Sistema: SEPAG
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Documentado em: Julho 28, 1994 as 17:39:37                DISK!  vers„o 5.01
// :*****************************************************************************

// Teclas Operacionais
// #INCLUDE "TECLASM.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_an()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_an

   PARA ARQWORK

// Recebendo Parametro de Trabalho
   wMAN  := 0
   wpMAN := 1
   wcMAN := 0

// Modo de Trabalho no Video
   MDI( " Ý ",,, ARQWORK )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( ARQWORK, "Fatura     Vencera Cliente" + spac( 13 ) + "Valor Receber" + spac( 6 ) + "DDD+Telefone   DIAS" ;
         , "' '+STR(mNRNOTA,8)+' '+mTIPFAT+' '+DTOC(mVENCIMENT)+' '+STR(mCLIENTE,  5)+' '+mCOGNOME+' '+STR(IF(ARQWORK='MN01PG',mVALORPG,mVALOR), 18, 2)+' '+mDDD+' '+mTELEFONE+' '+STR(mDIAS,  3)" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAN := CORARR( "MAN" )

// Variaveis de Trabalho
   xTAXA := 0
   IF ARQWORK == "MN01" .OR. ARQWORK == "MN01PD"
      MDS( "Confirme a Taxa de Juros Dia" )
      @ 24, 40 GET xTAXA PICT "99.9999"
      READCUR()
   ENDIF

   PRIV PCK    := .F.
   PRIV mCHAVE


// Telas de Trabalho
   aMANTEL := TELAPEG( "MAN001" )
   aMANGET := EDITPEG( "MAN001" )

// Sempre Criando Variaveis
   CRIARVARS( ARQWORK )

// CRIANDO MATRIZES
   aMAN1 := {}   // Matriz com os dizeres do Achoice
   aMAN2 := {}   // N£mero da Nota + Data de Vencimento
   aMAN3 := {}   // Referencia Arquivo


// Incializando a ajuda on Line
   PRIV HELPDBF := "MN01"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAN # 2
      // Filtro da Listagem
      FILTRO := ''
      FILTRO := RFILORD( "MN01", .F. )
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
            IF ARQWORK == "MN01" .OR. ARQWORK == "MN01PD"
               //
               // Ajustes Atrasos
               //
               EQUVARS()
               IF xTAXA > 0
                  mTAXA := xTAXA
               ENDIF
               MAN01( .T. )
               netreclock()
               FIELD->JUROS     := mJUROS
               FIELD->DIAS      := mDIAS
               FIELD->DIFERENCA := mDIFERENCA
               FIELD->VALATUAL  := mVALATUAL
               FIELD->PREVATR   := mPREVATR
               dbUnlock()
            ENDIF
            IF !Empty( mCBAR )
               AAdd( aMAN1, &mCBAR. )
            ELSE
               AAdd( aMAN1, ' ' + Str( NRNOTA, 8 ) + ' ' + TIPFAT + ' ' + DToC( VENCIMENT ) + ' ' + Str( CLIENTE, 5 ) + ' ' + COGNOME + ' ' + Str( IF( ARQWORK = 'MN01PG', VALORPG, VALOR ), 18, 2 ) + ' ' + DDD + ' ' + TELEFONE + ' ' + Str( DIAS, 3 ) )
            ENDIF
            AAdd( aMAN2, DToS( VENCIMENT ) + Str( NRNOTA, 8 ) + TIPFAT )
            AAdd( aMAN3, ARQWORK )
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
            IF !fMAN( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF


// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAN # 2 .AND. ARQWORK = "MN01XX"
      // Filtro da Listagem
      FILTRO := ''
      FILTRO := RFILORD( "MN01", .F. )
      nIND   := IF( lPIND, NUMIND( ARQWORK ), nIEXI )
      IF !USEREDE( "MN01PG", 1, nIND )
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
            IF !Empty( mCBAR )
               AAdd( aMAN1, &mCBAR. )
            ELSE
               AAdd( aMAN1, ' ' + Str( NRNOTA, 8 ) + ' ' + TIPFAT + ' ' + DToC( VENCIMENT ) + ' ' + Str( CLIENTE, 5 ) + ' ' + COGNOME + ' ' + Str( IF( ARQWORK = 'MN01PG', VALORPG, VALOR ), 18, 2 ) + ' ' + DDD + ' ' + TELEFONE + ' ' + Str( DIAS, 3 ) )
            ENDIF
            AAdd( aMAN2, DToS( VENCIMENT ) + Str( NRNOTA, 8 ) + TIPFAT )
            AAdd( aMAN3, "MN01PG" )
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
            IF !fMAN( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   pMAN := 1

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMAN1 )
      aSBAR := ScrollBarNew( 04, 79, 22, SubStr( CORMAN[ 1 ], RAt( ",", CORMAN[ 1 ] ) + 1 ), pMAN )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAN, nSBAR, .T. )
      WHILE .T.
         CABVID( CORMAN[ 1 ], pMAN )
         nKEY := 0
         KEYBOARD Chr( 255 )
         bELE := {| X | aMAN1[ X ] }
         cCOR := CORMAN[ 1 ]
         @ 23, 0
         @ 23, 02 SAY 'Vencido: ' + LTrim( TRANS( zATRAZO, '@E 999,999,999.99' ) )
         @ 23, 24 SAY 'Hoje: ' + LTrim( TRANS( zHOJE, '@E 999,999,999.99' ) )
         @ 23, 45 SAY 'A Rec: ' + LTrim( TRANS( zVENCER, '@E 999,999,999.99' ) )
         @ 23, 67 SAY 'T=' + LTrim( TRANS( zATRAZO + zHOJE + zVENCER, '@E 999,999,999.99' ) )
         @ 22, 00 SAY "+" + REPL( "-", 78 )
         pMAN2 := AChoice( 05, 01, 21, 78, aMAN1,, "ACHMOU", pMAN )
         pMAN  := IF( pMAN2 # 0, pMAN2, pMAN )
         pMAN2 := pMAN
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
      METPAG( ARQWORK, CORMAN, "DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT", wMAL, ;
         {|| TELASAY( aMANTEL ) }, {|| fMAN( 1, 0 ) }, {|| fMAN( 3, 0 ) }, {|| fMAN( 2, 0 ) }, ;
         {|| fMAN( 6, 0 ) } )
   ENDIF
   IF cVIDE = 'I'
      METINT( ARQWORK,, {|| fMAN( 2, - 1 ) } )
   ENDIF

   RELEASE ALL LIKE m *  // LIMPAVARS(ARQWORK)

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQWORK )
   ENDIF
   RETU .T.

// ************************


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

FUNC fMAN( OPRMAN, POSMAN )

   PRIV cARQREF := ARQWORK   // Referencia Fluxo Misto

// Pegar a Chave de Busca
   IF OPRMAN # 1
      IF cVIDE = 'S'
         mCHAVE := aMAN2[ POSMAN ]
         IF ARQWORK == "MN01XX"
            cARQREF := aMAN3[ POSMAN ]
         ENDIF
      ENDIF
      IF cVIDE = 'N' .AND. POSMAN # -1
         PEGBUS()
      ENDIF
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMAN = 3
      IF APAGAREG( cARQREF, mCHAVE )
         IF cVIDE = "S"
            aMAN1[ POSMAN ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + DToS( mVENCIMENT ) + ' - Registro Excluido / Apagado / Deletado'
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
   IF OPRMAN = 1
      PEGBUS()
      IF !NOVOREG( ARQWORK, mCHAVE )
         RETU .F.
      ENDIF
   ENDIF

// IGUALAR mVARS
   IF !IGUALVARS( cARQREF, mCHAVE )
      RETU .F.
   ENDIF
   yDATAPG  := mDATAPG
   yVALORPG := mVALORPG
   IF xTAXA > 0
      mTAXA := xTAXA
   ENDIF

// Metodo de Edi‡„o
   IF cTIPG = "1"
      // Desenha a Tela
      TELASAY( aMANTEL )
      // Get nas Menvars
      gMAN()
   ELSE
      EDITGET( .T., CORMAN )
   ENDIF

// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAN # 1
      IF !Empty( mCBARM )
         aMAN1[ POSMAN ] = &mCBARM.
      ELSE
         aMAN1[ POSMAN ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' ' + Str( mCLIENTE, 5 ) + ' ' + mCOGNOME + ' ' + Str( IF( ARQWORK = 'MN01PG', mVALORPG, mVALOR ), 18, 2 ) + ' ' + mDDD + ' ' + mTELEFONE + ' ' + Str( mDIAS, 3 )
      ENDIF
      aMAN2[ POSMAN ] = DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT
      aMAN3[ POSMAN ] = cARQREF
   ENDIF

   IF cVIDE = 'S' .AND. OPRMAN = 1
      MAN03()
   ENDIF

   IF cARQREF == "MN01PG" .AND. Empty( mDATAPG ) .AND. Empty( mVALORPG )
      IF mdg( "Retornar ao Contas a Receber" )
         NOVOREG( "MN01", mCHAVE )
         APAGAREG( "MN01PG", mCHAVE, .F. )
         IF cVIDE = "S"
            aMAN1[ POSMAN ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' - Transferido Contas a Receber'
         ENDIF
         RETU .T.
      ENDIF
   ENDIF

// Se Baixou Transfere
   IF !Empty( mDATAPG ) .AND. !Empty( mVALORPG ) .AND. ( "MN01" == cARQREF .OR. "MN01PD" == cARQREF )
      mOBS    := "Baixa Manual"
      mULTPAG := mVALORPG
      mULTDAT := mDATAPG
      NOVOREG( "MN01PG", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
      MAN01()
      IF cVIDE = "S"
         aMAN1[ POSMAN ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + DToS( mVENCIMENT ) + ' - Transferido Contas Recebida'
      ENDIF
      IF mFLUXO # 'N'
         zATRAZO -= IF( Date() > mVENCIMENT, mVALOR, 0 )
         zVENCER -= IF( Date() < mVENCIMENT, mVALOR, 0 )
         zHOJE   -= IF( Date() = mVENCIMENT, mVALOR, 0 )
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
            WHILE AScan( aMAN2, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT ) # 0
               I++
               mTIPFAT := Chr( 65 + I )
            ENDDO
            MAN03()
         ELSE
            WHILE .T.
               MDS( "Digite o tipo da Fatura" )
               @ 24, 40 GET mTIPFAT VALID !VERSEHA( "MN01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
               IF READCUR()
                  EXIT
               ENDIF
            ENDDO
         ENDIF
         NOVOREG( "MN01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
      ENDIF
      APAGAREG( cARQREF, mCHAVE, .F. )
      PCK := .T.
   ELSE
      REPORVARS( cARQREF, mCHAVE )
   ENDIF


// Get Nas Mvars


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

   WHILE .T.
      SET KEY K_F11 TO TECLAF11
      EDITSAY( aMANGET )
      SET KEY K_F11 TO
      xVALOR     := mVALOR
      xVENCIMENT := mVENCIMENT
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
      IF MAN02()
         EXIT
      ENDIF
   ENDDO

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
   mVALATUAL := mVALOR + mJUROS - mABATER
   IF !Empty( mVALORPG )
      mDIFERENCA := mVALATUAL - mVALORPG
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
      @ 10, 60 SAY mJUROS     PICT '@E 9999,999.99'
      @ 15, 54 SAY mDIAS      PICT '999'
      @ 21, 59 SAY mDIFERENCA PICT '@E 9999,999.99'
      @ 12, 60 SAY mVALATUAL  PICT '@E 9999,999.99'
      @ 21, 59 SAY mOBS
   ENDIF
   RETU .T.




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

   IF cARQREF == "MN01" .OR. cARQREF == "MN01PD"
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
   ENDIF
   RETU .T.



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

FUNC MAN03()

// Posiciona o Novo Elemento na Matriz
   nSBAR++
   AAdd( aMAN1, NIL )
   AAdd( aMAN2, NIL )
   AAdd( aMAN3, NIL )
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
   AIns( aMAN3, POSW )
   IF !Empty( mCBARM )
      aMAN1[ POSW ] = &mCBARM.
   ELSE
      aMAN1[ POSW ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + mTIPFAT + ' ' + DToC( mVENCIMENT ) + ' ' + Str( mCLIENTE, 5 ) + ' ' + mCOGNOME + ' ' + Str( IF( ARQWORK = 'MN01PG', mVALORPG, mVALOR ), 18, 2 ) + ' ' + mDDD + ' ' + mTELEFONE + ' ' + Str( mDIAS, 3 )
   ENDIF
   aMAN2[ POSW ] = DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT
   aMAN3[ POSW ] = cARQREF
   pMAN := POSW
   RETU .T.

// + EOF: m_an.prg
// +
