// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo7.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BO7.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bo7()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bo7

   PARA nTIPO

   IF nTIPO = 1
      MDI( " Э DESADV - MGO - GMB " )
   ELSE
      MDI( " Э DESADV - ELECTROLUX " )
   ENDIF
   tCGC     := OBTER( "MANEMP", ZNUMERO, "CGC" )
   mCGC     := SubStr( tCGC, 1, 2 ) + SubStr( tCGC, 4, 3 ) + SubStr( tCGC, 8, 3 ) + SubStr( tCGC, 12, 4 ) + SubStr( tCGC, 17, 2 )
   mCOMEMP  := "QNO"
   mCOMCLI  := "BFT"
   mDOC     := Space( 5 )
   mFABRICA := Space( 5 )
   mCLIENTE := mNRNOTA := mPESBRU := mITENS := 0
   mSERIE   := "0  "
   mDATANF  := mDATAEM := SubStr( DToS( ZDATA ), 3, 8 )
// mETAPA   := "12" //Entrega
   mETAPA  := "25"   // Retira
   mHORAEM := mHORANF := Left( StrTran( Time(), ":", "" ), 4 )
   IF nTIPO = 1
      mCAMINHO := ProfileString( "MANA5.INI", "PATH", "DESADVGM", hb_cwd() + "\EDIWISE\MANA5\" )  // "p:\novell\EDIWISE\MANA5\"
   ELSE
      mCAMINHO := ProfileString( "MANA5.INI", "PATH", "DESADVELE", hb_cwd() + "\ARQUIVO\" )   // "p:\novell\ITAESBRA\ARQUIVO\"
   ENDIF
   mREPOR  := "N"
   mGERAAE := " "

   cARQ1 := "MM01"
   cARQ2 := "MM02"


   mNRNOTA := ESCOLHEXI( cARQ1, mNRNOTA, "' '+STR(NUMERO,8)+' '+DTOC(DATA)+' '+HORAEMI", "NUMERO", "GERAAE=IF(nTIPO=1,'S','E')" )
   IF ValType( mNRNOTA ) # "N"
      mNRNOTA := 0
   ENDIF

   MDS( "Qual Nota Fiscal" )
   @ 24, 40 GET mNRNOTA PICT "99999999"
   IF !READCUR()
      RETU .F.
   ENDIF
   mCAMINHO := AllTrim( mCAMINHO ) + "N" + StrZero( mNRNOTA, 7 ) + ".TXT" + Space( 20 )

   mELE02 := mELE03 := mELE03 := mELE04 := mELE05 := mELE06 := ""
   mELE07 := mELE08 := mELE09 := mELE10 := mELE11 := mELE12 := mELE13 := ""


   WHILE .T.
      IF !PEGACAMPO( cARQ1, "mNRNOTA", { "FORNECEDO", "DATA", "TOTALBRU", "GERAAE" }, ;
            { "mCLIENTE", "mDATANF", "mPESBRU", "mGERAAE" } )
         ALERTX( "Nao achei Nota Fiscal" )
         IF MDG( "Tentar Mes Fechado" )
            cVAR  := MESANO()
            cARQ1 := "M1" + cVAR
            CARQ2 := "M2" + cVAR
            LOOP
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO

   IF mGERAAE = "G"
      IF !MDG( "Aviso Ja Gerado - Gerar Novamente" )
         RETU .F.
      ENDIF
   ENDIF
   IF mGERAAE <> "S" .AND. mGERAAE <> "E"
      IF !MDG( "Nota Nao Marcada para Aviso - Gerar " )
         RETU .F.
      ENDIF
   ENDIF

   mPESBRU := StrZero( Int( mPESBRU ), 10 )
   PEGACAMPO( "MA01", "mCLIENTE", { "DOCA", "SISCO", "CLICOMP", "CLIENTR", "CODIGO", "CGCCOMP", "CGC3" }, ;
      { "mDOC", "mFABRICA", "mELE07", "mELE08", "mELE09", "mELE10", "mELE11" } )


   mELE02 := mNRNOTA
   mELE03 := mDATANF
   mELE04 := mDATANF
   mELE05 := mDATANF
   mELE06 := mDATANF
   mELE12 := tCGC
   mELE13 := "FOB"
   IF nTIPO = 1
      mDATANF := SubStr( DToS( mDATANF ), 3, 8 )
   ENDIF



   IF !USEREDE( cARQ2, 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
// Contando Itens
   dbGoTop()
   dbSeek( Str( mNRNOTA, 8 ) )
   WHILE NUMERO = mNRNOTA .AND. !Eof()
      mITENS++
      // 24/04/2006 removida conforme solicitacao
      // IF mFABRICA="72474".OR.mFABRICA="72475"
      // IF CODIGO="93.336.186".OR.CODIGO="93.336.187".OR.CODIGO="93.361.545"
      // mDOC:="S01"
      // ENDIF
      // ENDIF
      dbSkip()
   ENDDO

   IF nTIPO = 2
      IF !USEREDE( "OSCRT", 1, 1 )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF

   mDOC   := PadR( mDOC, 5 )
   mITENS := StrZero( Int( mITENS ), 18 )

   IF mFABRICA = "72668" .OR. mFABRICA = "72667" .OR. mFABRICA = "72474"
      mCOMCLI := "MZ7"
   ENDIF

   IF nTIPO = 1
      IF !MBO701()
         RETU
      ENDIF
   ELSE
      IF !MBO702()
         RETU
      ENDIF
   ENDIF

   IF File( mCAMINHO ) .AND. filesize( Mcaminho ) > 0
      GRAVAMVAR( "MM01", mNRNOTA, { "GERAAE", "HORAAE" }, { "'G'", "LEFT(TIME(),5)" } )
      gravalog( mCAMINHO, "AE", StrZero( mNRNOTA, 8 ) )
      gravalog( mFABRICA, "AE", StrZero( mNRNOTA, 8 ) )
   ELSE
      ALERTX( "Erro gravando TXT tente novamente" )
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBO701()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBO701()

   TELASAY( "AGM001" )
   EDITSAY( "AGM001" )
   mCAMINHO := StrTran( mCAMINHO, " ", "" )

   nHANDLE := FCreate( AllTrim( mCAMINHO ) )
   IF FError() # 0
      ALERTX( "Erro na Cria‡„o do Arquivo" )
      RETU .F.
   ENDIF

   FWrite( nHANDLE, "AV" )
   IF mREPOR = "S"
      FWrite( nHANDLE, mCGC )
   ELSE
      FWrite( nHANDLE, mCOMEMP )
   ENDIF
   FWrite( nHANDLE, mCOMCLI )
   FWrite( nHANDLE, StrZero( mNRNOTA, 6 ) )
   FWrite( nHANDLE, mSERIE )
   FWrite( nHANDLE, mDATANF )
   FWrite( nHANDLE, mHORANF )
   FWrite( nHANDLE, mDATAEM )
   FWrite( nHANDLE, mHORAEM )
   FWrite( nHANDLE, mPESBRU )
   FWrite( nHANDLE, mITENS )
   FWrite( nHANDLE, mFABRICA )
   FWrite( nHANDLE, mDOC )
   FWrite( nHANDLE, mETAPA )
   IF mREPOR = "S"
      FWrite( nHANDLE, Space( 2 ) )
   ELSE
      FWrite( nHANDLE, Space( 13 ) )
   ENDIF
   FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )

   dbSelectAr( cARQ2 )
   dbGoTop()
   dbSeek( Str( mNRNOTA, 8 ) )
   WHILE NUMERO = mNRNOTA .AND. !Eof()
      nQTDDE   := CONVUN( QTDE, UNID )
      mCODIGO  := PadR( StrTran( CODIGO, ".", "" ), 30 )
      mANO     := StrZero( Year( ZDATA ), 4 )
      mPEDIDO  := PadR( PEDIDOCLI, 12 )
      mQTDE01  := StrZero( nQTDDE, 10 )
      mQTDE02  := StrZero( nQTDDE, 10 )
      mUNIDADE := "EA "
      TELASAY( "AGM201" )
      EDITSAY( "AGM201" )
      FWrite( nHANDLE, "IT" )
      FWrite( nHANDLE, mCODIGO )
      FWrite( nHANDLE, mANO )
      FWrite( nHANDLE, mPEDIDO )
      FWrite( nHANDLE, mQTDE01 )
      FWrite( nHANDLE, mQTDE02 )
      FWrite( nHANDLE, mUNIDADE )
      FWrite( nHANDLE, Space( 18 ) )
      FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
      dbSelectAr( cARQ2 )
      dbSkip()
   ENDDO
   FWrite( nHANDLE, Chr( 26 ) )
   FClose( nHANDLE )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBO702()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBO702()   // Electrolux

   TELASAY( "AEL001" )
   EDITSAY( "AEL001" )
   mCAMINHO := StrTran( mCAMINHO, " ", "" )
   nHANDLE  := FCreate( AllTrim( mCAMINHO ) )
   IF FError() # 0
      ALERTX( "Erro na Cria‡„o do Arquivo" )
      RETU .F.
   ENDIF
   FWrite( nHANDLE, "01" )
   FWrite( nHANDLE, StrZero( mELE02, 15 ) )
   FWrite( nHANDLE, DToS( mELE03 ) )
   FWrite( nHANDLE, DToS( mELE04 ) )
   FWrite( nHANDLE, DToS( mELE05 ) )
   FWrite( nHANDLE, DToS( mELE06 ) )
   FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE07 ) ), 13 ) )
   FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE08 ) ), 13 ) )
   FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE09 ) ), 13 ) )
   FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE10 ) ), 14 ) )
   FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE11 ) ), 14 ) )
   FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE12 ) ), 14 ) )
   FWrite( nHANDLE, mELE13 )
   FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )

   dbSelectAr( cARQ2 )
   dbGoTop()
   dbSeek( Str( mNRNOTA, 8 ) )
   WHILE NUMERO = mNRNOTA .AND. !Eof()
      mOS     := Int( OS )
      mITEM03 := Space( 13 )
      mITEM04 := Space( 13 )
      IF TIPOSERV <> "3"
         mITEM05 := CODIGO
      ELSE
         mITEM05 := PadR( AllTrim( CODIGO ) + "*OP901", 24 )
      ENDIF
      mITEM06 := CONVUN( QTDE, UNID )
      mITEM07 := CONVUN( QTDE, UNID )
      mITEM08 := Space( 15 )
      mITEM10 := Space( 15 )
      dbSelectAr( "oscrt" )
      dbGoTop()
      IF dbSeek( mOS )
         mITEM03 := CODEAN
         mITEM04 := CODCLI
         mITEM08 := PEDIDOCLI
         mITEM10 := CONTRATO
      ENDIF
      dbSelectAr( cARQ2 )
      IF Empty( mITEM04 )
         mITEM04 := mITEM05  // Codigo
      ENDIF
      IF Empty( mITEM08 )
         mITEM08 := PEDIDOCLI
      ENDIF
      TELASAY( "AEL201" )
      EDITSAY( "AEL201" )
      dbSelectAr( cARQ2 )
      FWrite( nHANDLE, "02" )
      FWrite( nHANDLE, StrZero( SEQ, 6 ) )
      FWrite( nHANDLE, StrZero( Val( TIRAOUT( mITEM03 ) ), 13 ) )  // 03
      FWrite( nHANDLE, PadR( TIRAOUT( mITEM04 ), 15 ) )  // 04
      FWrite( nHANDLE, PadR( TIRAOUT( mITEM05 ), 15 ) )  // 05
      FWrite( nHANDLE, GRVVAL( mITEM06, 9, 2 ) )  // 06
      FWrite( nHANDLE, GRVVAL( mITEM07, 9, 2 ) )  // 07
      FWrite( nHANDLE, PadR( TIRAOUT( mITEM08 ), 15 ) )  // 08
      FWrite( nHANDLE, StrZero( mOS, 15 ) )  // 09
      FWrite( nHANDLE, PadR( TIRAOUT( mITEM10 ), 15 ) )  // 10
      FWrite( nHANDLE, StrZero( mNRNOTA, 6 ) )
      FWrite( nHANDLE, "1  " )
      FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
      dbSkip()
   ENDDO
   FWrite( nHANDLE, Chr( 26 ) )
   FClose( nHANDLE )
   RETU .T.

// + EOF: M_BO7.PRG

// + EOF: m_bo7.prg
// +
