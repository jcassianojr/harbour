// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a76.prg
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
// +    Source Module => J:\ITAESBRA\M_A76.PRG
// +
// +    Functions: Function MAMGRVREM()
// +               Function GRVREMESSA()
// +               Function GRVREMAVU()
// +
// +    Reformatted by Click! 2.03 on Sep-1-2004 at 10:51 am
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

MDI( " Э Nota Fiscal Datilografada" )
cTRABALHO := "NFDATILO"

xPISEMP := OBTER( "MANEMP", ZNUMERO, "PERPIS" )
xFINEMP := OBTER( "MANEMP", ZNUMERO, "PERFIN" )


CRIARVARS( "MS04" )
CRIARVARS( "MN01" )
CRIARVARS( "MA01" )
CRIARVARS( "MM01" )
CRIARVARS( "MM02" )
CRIARVARS( "MM06" )
mCLA1    := mCLA2 := mCLA3 := ' '
ARQWORK1 := "MM01"
ARQWORK2 := "MM02"
ARQWORK4 := "MM06"
ARQWORK5 := "MN01"
INCLUI   := .T.

mESTADO    := "  "
mIESTADUAL := ""
mLISTA     := 0
nREF       := 2   // Aceitar Codigos de Saida
ZESTADO    := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
mGERACOB   := "S"
mIMPDUP    := "N"

// Telas de Trabalho
aMAMTEL := TELAPEG( "ITMM01" )
aMAMGET := EDITPEG( "ITMM01" )
aMDETEL := TELAPEG( "MMDE01" )
aMDEGET := EDITPEG( "MMDE01" )

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
mOSTR := 0
IF !CONFARQ( "MM01", "Nota    Emiss„o F Fornecedor" + spac( 9 ) + "S Ope P S Pag  Valor Total da NF" )
RETU .F.
ENDIF
IF !CONFIND( "MM01" )
RETU .F.
ENDIF

// Pegando Cores de Trabalho UTILIZADAS CHAMADAS fMAM()
CORMAM := CORARR( "MAM" )

cVIDE := 'N'
WHILE .T.
mNUMERO := ULTIMOREG( "MM01", "NUMERO" )
mNUMERO++
MDS( 'N§ Nota Fiscal : ' + Space( 30 ) + "N§ Rem.Trat:" )
@ 24, 16 GET mNUMERO PICT "99999999"
@ 24, 60 GET mOSTR
IF !READCUR()
RELEASE ALL LIKE m *
RETU .F.
ENDIF
yNRNOTA := mNUMERO
mCHAVE  := mNUMERO   // Usada Interna achoice nao apagar
IF !VERSEHA( "MM01", yNRNOTA )
EXIT
ELSE
ALERTX( "Nota Ja Faturada" )
ENDIF
ENDDO

mTIPOCLI   := 'C'
mOPERACAO  := ""
mCFONEW    := "5101"
mTIPOENT   := 'P'
mSITUACAO  := '1'
mDATA      := ZDATA
mEMBALAGEM := "GRANEL"
mTIPONF    := "S"
mCANCELADA := "N"
mCONTSIM   := "S"
mSERIE     := "UN"
mESPECIE   := "NF"
mMODELO    := "01"
IF mOSTR > 0
mAPURA    := "N"
mCFONEW   := "5901"
mTIPOSERV := "T"
mTIPOCLI  := "F"
mGERAAE   := "N"
PEGACAMPO( "MOSB01", "mOSTR", { "FORNECEDO", "COGNOME" }, { "mFORNECEDO", "mCOGNOME" } )
ENDIF
PADRAX( 3, mTRANSPORT, 0, { "MG01", "MG02" }, "NЈmero  Nome" + spac( 38 ) + "Cognome" + spac( 6 ) + "DDD  Telefone", ;
      "' '+mNUMERO+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE", "MAG001", "MAG001", ;
      {|| MAGEN2() },, {|| MAGREP() } )
mNUMERO := yNRNOTA
ARQUSO  := "MB01"
MAMK01()
NOVOREG( "MM01", yNRNOTA )
IF mOSTR > 0
l5901     := .F.
l5920     := .F.
mICM      := 0
mTOTMER   := 0
mTOTNF    := 0
mTOTALPES := 0
IF USEREDE( "MOSB02", 1, 99 )
dbSetOrder( 2 )   // str(numero,8)+tipoent (Ordenar Tipo -->Necessario
// Para gerar ordem correta dipi depois
dbGoTop()
dbSeek( Str( mOSTR, 8 ) )
WHILE NUMERO = mOSTR .AND. !Eof()
mCODIGO  := CODIGO
mSEQ     := SEQ
mUNID    := UNID
mQTDE    := QTDE
mPESO    := PESO
mTIPOENT := TIPOENT
mNOME    := NOME
mPRECO   := PRECO
mRASTRO  := CHECKRASTRO( RASTRO )
mRASTR2  := CHECKRASTRO( RASTR2 )
mLISTA   := LISTA
mCODIPI  := CODIPI
mPISCON  := PISCON
mREDICM  := REDICM
// mOBS      := OBS
mINDICE   := INDICE
mLINADD01 := Space( 45 )
mLINADD02 := Space( 45 )
mLINADD03 := Space( 45 )
mLINADD04 := Space( 45 )
mLINADD05 := Space( 45 )
mLINADD06 := OBS
IF mTIPOENT = "B"
l5920     := .T.
mTIPOSERV := "6"
ENDIF
IF mTIPOENT = "T"
l5901 := .T.
ENDIF
IF mTIPOENT = "B"
mDIPICM   := "I"
mDIPIPI   := "I"
mCODICM   := "040"
mTIPOSERV := "6"
ELSE
mDIPICM   := "O"
mDIPIPI   := "O"
mCODICM   := "050"
mTIPOSERV := "T"
ENDIF
mSOMANF   := "S"
mCONSUMO  := "N"
xCODIGO   := repl( "Z", 24 )  // Forcar Busca
xCODIPI   := "__"
yCODIGO   := repl( "Z", 24 )  // Forcar Busca
xVALORMER := 0   // Zero Para Recalcular
xBASEICM  := 0
xBASEIPI  := 0
xIPI      := mIPI
MAM203()   // PESO
NFCOD( .F. )
mPRECO := PRECO  // Pegar Sempre o Da Os
mUNID  := UNID
// Para os calculos
mICM      := 0
MBASEICM  := 0
mVALORICM := 0
mIPI      := 0
mBASEIPI  := 0
mVALORIPI := 0
NFBAS()
NFBIPI()
NFIPI()
NFVIPI()
NFBICM()
NFVICM()
// Ajustar
mICM      := 0
MBASEICM  := 0
mVALORICM := 0
mIPI      := 0
mBASEIPI  := 0
mVALORIPI := 0
IF mQTDE > 0
IF mPESO > 0
IF mPRECO > 0
NOVOREG( "MM02", Str( yNRNOTA, 8 ) + Str( mSEQ, 2 ) )
ELSE
ALERTX( "Item com Preco Zerado " + mCODIGO )
ENDIF
ELSE
ALERTX( "Item com Peso Zerado " + mCODIGO )
ENDIF
ELSE
ALERTX( "Item com Qtde Zerada " + mCODIGO )
ENDIF
mTOTMER   += mVALORMER
mTOTNF    += mVALORTOT
mTOTALPES += mPESO
dbSelectAr( "MOSB02" )
dbSkip()
ENDDO
ENDIF
IF l5901 .AND. l5920
mCFONEW  := "5901"
mCFONEWB := "5920"
GRAVAMVAR( "MM01", yNRNOTA, "CFONEW", "'5901'" )
GRAVAMVAR( "MM01", yNRNOTA, "CFONEWB", "'5920'" )
ELSE
IF l5901
mCFONEW := "5901"
GRAVAMVAR( "MM01", yNRNOTA, "CFONEW", "'5901'" )
ENDIF
IF l5920
mCFONEW := "5920"
GRAVAMVAR( "MM01", yNRNOTA, "CFONEW", "'5920'" )
ENDIF
ENDIF
mOPERACAO := OBTER( "MD04", mCFONEW, "CFO", 2 ) + if( Empty( mCFONEWB ), "    ", + "/" + OBTER( "MD04", mCFONEWB, "CFO", 2 ) )
GRAVAMVAR( "MM01", yNRNOTA, "OPERACAO", "mOPERACAO" )
GRAVAMVAR( "MM01", yNRNOTA, "TOTMER", "mTOTMER" )
GRAVAMVAR( "MM01", yNRNOTA, "TOTNF", "mTOTNF" )
GRAVAMVAR( "MM01", yNRNOTA, "TOTALPES", "mTOTALPES" )
IF USEREDE( "MM02", 1, 99 )
dbGoTop()
dbSeek( Str( yNRNOTA, 8 ) )
WHILE yNRNOTA = NUMERO .AND. !Eof()
netreclock()
FIELD->OPERACAO := mOPERACAO
FIELD->CFONEW   := mCFONEW
FIELD->CFONEWB  := mCFONEWB
dbUnlock()
dbSkip()
ENDDO
dbCloseArea()
ENDIF
ENDIF

aMAM1 := { MAMSAY02() }
cVIDE := "N"
fMAM( 2, - 1, .T. )
WHILE MDG( "Deseja Revisar Dados" )
aMAM1 := { MAMSAY02() }
cVIDE := "N"
fMAM( 2, - 1,, .T. )
ENDDO
IF !MDG( "Deseja Imprimir Nota Fiscal" )
cVIDE := "N"
fMAM( 3, - 1,, .T. )
ENDIF
mDESCFO := OBTER( "MD04", mCFONEW, "NOMENOTA", 2 )
TIPCAD( mTIPOCLI, "ARQUSO" )

mCFTNEW  := AllTrim( mCFONEW )
mCFTNEWB := AllTrim( mCFONEWB )

IF mCFTNEW = "5949" .AND. mTIPOSERV = "6" .AND. mTIPOENT = "T"  // Caso especial
MAMGRVREM( yNRNOTA, mFORNECEDO, mTIPOCLI, .T. )
ENDIF

IF mCFTNEW = "5920" .OR. mCFTNEW = "5901" .OR. mCFTNEW = "5915" .OR. ;
         mCFTNEW = "6920" .OR. mCFTNEW = "6901" .OR. mCFTNEW = "6915" .OR. ;
         mCFTNEWB = "5920" .OR. mCFTNEWB = "5901" .OR. mCFTNEWB = "5915" .OR. ;
         mCFTNEWB = "6920" .OR. mCFTNEWB = "6901" .OR. mCFTNEWB = "6915"
MAMGRVREM( yNRNOTA, mFORNECEDO, mTIPOCLI, .T. )
ELSE
GRAVALOG( Str( yNRNOTA, 8 ) + "NCF", "REM", "MM02" )
ENDIF

M_A7I( yNRNOTA, .T., .T. )

RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MAMGRVREM()
// +
// +    Called from ( m_a76.prg    )   1 -
// +                                   1 - function grvremavu()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAMGRVREM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAMGRVREM

   PARA mNUMERO, mFORNECEDO, mTIPOCLI, lPERG, cARQ

   IF ValType( lPERG ) # "L"
      lPERG := .F.
   ENDIF
   IF ValType( cARQ ) # "C"
      cARQ := "MM02"
   ENDIF

   IF lPERG .OR. MDG( "Gravar Remessa Trat/Emb MF:" + Str( mNUMERO, 8 ) )
      mCLIENTE := mFORNECEDO
      WHILE !USEREDE( cARQ, 1, 1 )
      ENDDO
      dbSelectAr( cARQ )
      dbGoTop()
      dbSeek( Str( mNUMERO, 8 ) )
      WHILE mNUMERO = NUMERO .AND. !Eof()
         mCODIGO    := CODIGO
         mNOME      := NOME
         mUNIDADE   := UNID
         mNRNOTAINI := NUMERO
         mDATAFAT   := DATA
         mTOTKGINI  := QTDE
         mTOTKGANT  := QTDE
         mTOTKGEST  := QTDE
         mVALORINI  := VALORMER
         mTIPOENT   := TIPOENT
         mTIPOSERV  := TIPOSERV
         mPESOREF   := PESO * CONVUN( QTDE, UNID )
         mPRECO     := PRECO
         mCLASSIPI  := CLASSIPI
         mAVEMBQ    := AVEMBQ
         mAVEMBC    := AVEMBC
         mRASTRO    := RASTRO
         IF mTIPOENT = "B" .AND. mTIPOCLI = "C"
            GRVREMESSA( "MR03", PadR( mCODIGO, 10 ) + Str( mNRNOTAINI, 8 ) )
         ENDIF
         IF mTIPOENT = "T" .OR. mTIPOENT = "B" .AND. mTIPOCLI = "F"
            GRVREMESSA( "MS04", PadR( mCODIGO, 24 ) + Str( mNRNOTAINI, 8 ) )
         ENDIF
         IF mTIPOENT = "T" .AND. mTIPOCLI = "F"  // Controle Adcional So tratamento
            GRVREMESSA( "MS07", PadR( mCODIGO, 24 ) + Str( mNRNOTAINI, 8 ) )
         ENDIF
         IF mTIPOENT = "C" .AND. mTIPOSERV = "T" .AND. mTIPOCLI = "F"
            GRVREMESSA( "MS04", PadR( mCODIGO, 24 ) + Str( mNRNOTAINI, 8 ) )
         ENDIF
         IF mTIPOENT = "X"
            IF Empty( mCODIGO )
               GRVREMESSA( "MS04", Str( mSEQ, 24 ) + Str( mNRNOTAINI, 8 ) )
            ELSE
               GRVREMESSA( "MS04", PadR( mCODIGO, 24 ) + Str( mNRNOTAINI, 8 ) )
            ENDIF
         ENDIF
         IF !Empty( mAVEMBC ) .AND. mAVEMBQ > 0
            mCODIGO   := mAVEMBC
            mTOTKGINI := mAVEMBQ
            mTOTKGANT := mAVEMBQ
            mTOTKGEST := mAVEMBQ
            PEGACAMPO( "MR01", "mCODIGO", { "ALLTRIM(NOME)+' '+ALLTRIM(NOM2)", "CODIPI", "UNIDADE", "PESLIQ", "PRECUST" }, ;
               { "cNOME", "mCODIPI", "mUNID", "mPESO", "mPRECO" } )
            IF mTIPOCLI = "F"
               GRVREMESSA( "MR03", PadR( mCODIGO, 10 ) + Str( mNRNOTAINI, 8 ) )
            ELSE
               GRVREMESSA( "MS04", PadR( mCODIGO, 24 ) + Str( mNRNOTAINI, 8 ) )
            ENDIF
         ENDIF
         dbSelectAr( cARQ )
         dbSkip()
      ENDDO
   ELSE
      GRAVALOG( Str( mNUMERO, 8 ) + "NAO", "REM", caRQ )
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function GRVREMESSA()
// +
// +    Called from ( m_a76.prg    )   7 - function mamgrvrem()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRVREMESSA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRVREMESSA( cARQ, eCHAVE )

   mDIGCTR := " "
   WHILE !NOVOREG( cARQ, eCHAVE + mDIGCTR, .F., .F. )
      IF Empty( mDIGCTR )
         mDIGCTR := "A"
      ELSE
         nASC    := Asc( mDIGCTR )
         mDIGCTR := Chr( nASC + 1 )
      ENDIF
   ENDDO
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function GRVREMAVU()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRVREMAVU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRVREMAVU()

   MDI( " Э Relancar Nota Para Remessas" )
   mNUMERO    := 0
   mFORNECEDO := 0
   mTIPOCLI   := "C"
   mCOGNOME   := ""
   CRIARVARS( "MM02" )
   CRIARVARS( "MS04" )
   @ 24, 00 GET mNUMERO PICT "99999999"
   IF !READCUR()
      RETU .F.
   ENDIF
   aRETU := PERFEC( { "MM02", "MM01" }, { "M2", "M1" }, { "MM92", "MM91" } )
   cARQ  := aRETU[ 5, 1 ]
   cARQ2 := aRETU[ 5, 2 ]

   IF PEGACAMPO( cARQ2, "mNUMERO", { "FORNECEDO", "TIPOCLI", "COGNOME" }, { "mFORNECEDO", "mTIPOCLI", "mCOGNOME" } )
      MAMGRVREM( mNUMERO, mFORNECEDO, mTIPOCLI, .F., cARQ )
   ELSE
      ALERTX( "Nao achei a Nota" )
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKRASTRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CHECKRASTRO( cRASTRO )

   LOCAL cANO, cSUB, nLEN

// Ano Atual
   IF Empty( cRASTRO )
      RETU cRASTRO
   ENDIF
   nLEN := Len( cRASTRO )
   cANO := StrZero( Year( zdata ), 4 )
   cSUB := Right( cANO, 2 )
   IF At( "-" + cSUB, cRASTRO ) > 0
      cRASTRO := StrTran( cRASTRO, "-" + cSUB, "/" + cANO )
   ENDIF
   IF At( "/" + cSUB, cRASTRO ) > 0
      cRASTRO := StrTran( cRASTRO, "/" + cSUB, "/" + cANO )
   ENDIF
// Ano Anterior
   cANO := StrZero( Year( zdata ) - 1, 4 )
   cSUB := Right( cANO, 2 )
   IF At( "-" + cSUB, cRASTRO ) > 0
      cRASTRO := StrTran( cRASTRO, "-" + cSUB, "/" + cANO )
   ENDIF
   IF At( "/" + cSUB, cRASTRO ) > 0
      cRASTRO := StrTran( cRASTRO, "/" + cSUB, "/" + cANO )
   ENDIF
   RETU PadR( cRASTRO, nLEN )

// + EOF: M_A76.PRG

// + EOF: m_a76.prg
// +
