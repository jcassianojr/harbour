// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_sint.prg
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
// +    Source Module => J:\ITAESBRA\M_SINT.PRG
// +
// +    Functions: Function M_BM701()
// +
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

MDI( " Э Acumular Sintegra" )
aRETU := PERFEC( { "MK06", "MM06", "MK01", "MM01", "MK02", "MM02" }, ;
      { "K6", "M6", "K1", "M1", "K2", "M2" }, ;
      { "MK96", "MM96", "MK91", "MM91", "MK92", "MM92" } )
nANO := ARETU[ 2 ]
IF nANO < 2003
ALERTX( "Cfo Antigo " + Str( nano ) )
ENDIF
cARQENT := aRETU[ 5, 1 ]
cARQSAI := aRETU[ 5, 2 ]
cARQNFE := aRETU[ 5, 3 ]
cARQNFS := aRETU[ 5, 4 ]
cARQITE := aRETU[ 5, 5 ]
cARQITS := aRETU[ 5, 6 ]

lAPA50 := MDG( "Apurar 50-ICMS" )
lAPA51 := MDG( "Apurar 51-IPI" )
lAPA54 := MDG( "Apurar 54-Produto" )
// usados CT antigos deixados como false apura CT agora com 70
lAPA53  := .F.
lAPA53B := .F.
IF lAPA53
lAPA53B := MDG( "Gerar Reg 50 do 53-CT" )
ENDIF
lAPA70 := MDG( "Apurar 70 CT" )
IF lAPA54
IF MDG( "Checar Classifica‡ao Fiscal - Saida" )
M_AK2A( "S", cARQITS, cARQSAI )
ENDIF
IF MDG( "Checar Classifica‡ao Entrada" )
M_AK2A( "E", cARQITE, cARQENT )
ENDIF
ENDIF

IF !USEMULT( { { "MA01", 1, 1 }, { "MB01", 1, 1 }, { cARQSAI, 1, 1 }, { cARQENT, 1, 1 }, ;
         { cARQNFS, 1, 1 }, { cARQNFE, 1, 1 }, { "SINT50", 0, 99 }, { "SINT51", 0, 99 }, ;
         { cARQITS, 1, 1 }, { cARQITE, 1, 1 }, { "SINT54", 0, 99 }, { "SINT75", 0, 99 }, ;
         { "SINT53", 0, 99 }, { "SINT70", 0, 99 } } )
RETU .F.
ENDIF


dbSelectAr( "SINT50" )
IF lAPA50
ZAP
ENDIF
dbSelectAr( "SINT51" )
IF lAPA51
ZAP
ENDIF
dbSelectAr( "SINT54" )
IF lAPA54
ZAP
ENDIF
dbSelectAr( "SINT75" )
IF lAPA54
ZAP
ENDIF
dbSelectAr( "SINT53" )
IF lAPA53
ZAP
ENDIF
dbSelectAr( "SINT70" )
IF lAPA70
ZAP
ENDIF

MDS( "" )
IF lAPA50
IF MDG( "Apurar Saida ICMS" )
M_BM701( cARQSAI, cARQNFS, cARQITS, "S", "ICM" )
ENDIF
IF MDG( "Apurar Entrada ICMS" )
M_BM701( cARQENT, cARQNFE, cARQITE, "E", "ICM" )
ENDIF
ENDIF
IF lAPA51
IF MDG( "Apurar Saida IPI" )
M_BM701( cARQSAI, cARQNFS, cARQITS, "S", "IPI" )
ENDIF
IF MDG( "Apurar Entrada IPI" )
M_BM701( cARQENT, cARQNFE, cARQITE, "E", "IPI" )
ENDIF
ENDIF
IF lAPA70
IF MDG( "Apurar Entrada CT" )
M_BM701( cARQENT, cARQNFE, cARQITE, "E", "CT" )
ENDIF
ENDIF
IF lAPA54
dbSelectAr( "SINT50" )
dbSetOrder( 2 )
IF MDG( "Apurar Produto Saida" )
M_BM701( cARQSAI, cARQNFS, cARQITS, "S", "PRO" )
ENDIF
IF MDG( "Apurar Produto Entrada" )
M_BM701( cARQENT, cARQNFE, cARQITE, "E", "PRO" )
ENDIF
MDS( "Gerando Reg 75" )
dbSelectAr( "SINT54" )
dbSetOrder( 3 )
dbGoTop()
WHILE !Eof()
@ 24, 20 SAY TIPOENT + CODIGO
mTIPOENT   := TIPOENT
mCODIGO    := CODIGO
mCODIGORED := CODIGORED
mUNID      := ""
mCLASSIPI  := ""
mNOME      := ""
mIPI       := 0
mICM       := ICM
mCODIPI    := ""
mREDICM    := 0
mSITUACAO  := SITUACAO
IF mTIPOENT <> "X" .AND. mTIPOENT <> "F"
IF mTIPOENT = "P"
IF PEGACAMPO( "MS01", "mCODIGO", { "NOME", "CODIPI", "UNID" }, { "mNOME", "mCODIPI", "mUNID" }, 2 )
CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
ELSE
ALERTX( "Verifique NF" + Str( NUMERO ) + "Cod.Produto" )
ENDIF
IF Empty( mCODIGO )
ALERTX( "Verifique NF" + Str( NUMERO ) + "Sem Cod.Produto " )
ENDIF
ENDIF
IF mTIPOENT $ "T"
mNORMA := ""
PEGACAMPO( "MP03", "mCODIGO", { "NOME", "UNIDADE", "REDICM", "NORMA" }, { "mNOME", "mUNID", "mREDICM", "mNORMA" } )
IF mREDICM > 0
mREDICM := 100 - mREDICM
ENDIF
IF !Empty( mNORMA )
mNOME := OBTER( "ETI", AllTrim( mNORMA ), "NOME" )
ENDIF
ENDIF
IF mTIPOENT = "I"
PEGACAMPO( "ME04", "mCODIGO", { "PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)" }, { "mNOME" } )
ENDIF
IF mTIPOENT $ "MCORSB"
PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "mCODIGO", { "NOME+NOM2", "UNIDADE", "CODIPI", "IPI", "CLASSIPI" }, { "mNOME", "mUNID", "mCODIPI", "mIPI", "mCLASSIPI" } )
ENDIF
IF Empty( mIPI ) .AND. !Empty( mCODIPI )
CHECKCIPI( mCODIPI, "mIPI" )
ENDIF
IF Empty( mCLASSIPI ) .AND. !Empty( mCODIPI )
CHECKCIPI( mCODIPI,, "mCLASSIPI" )
ENDIF
ENDIF
IF Empty( mUNID )
mUNID := "PC"
ENDIF
dbSelectAr( "SINT75" )
netrecapp()
field->TIPO      := "75"
field->CODIGORED := mCODIGORED
field->CLASSIPI  := mCLASSIPI
field->DESCRICAO := AllTrim( TIRACE( mNOME ) )
field->UNID      := mUNID
field->IPI       := mIPI
field->ICM       := mICM
field->REDICM    := mREDICM
field->TIPOENT   := mTIPOENT
field->SITUACAO  := mSITUACAO
IF mTIPOENT = "F"   // Ferramental
field->DESCRICAO := "FERRAMENTAL"
ENDIF
IF mTIPOENT = "X"   // Outras
field->DESCRICAO := "OUTRAS"
ENDIF
IF Empty( DESCRICAO ) .AND. mTIPOENT $ "TORMC"
field->DESCRICAO := "OUTRAS"
ENDIF
dbSelectAr( "SINT54" )
WHILE mTIPOENT = TIPOENT .AND. mCODIGORED = CODIGORED .AND. !Eof()
dbSkip()
ENDDO
ENDDO
MDS( "Checagem Seq" )
dbSelectAr( "SINT54" )
dbSetOrder( 1 )
dbGoTop()
WHILE !Eof()
@ 24, 20 SAY CGC
@ 24, 40 SAY NUMERO
cCGC       := AllTrim( CGC )
nNUMERO    := NUMERO
nFORNECEDO := FORNECEDO
nSEQ       := 0
WHILE cCGC = AllTrim( CGC ) .AND. nNUMERO = NUMERO .AND. !Eof()
nSEQ++
field->ITEM := nSEQ
// 991 - identifica o registro do frete
// 992 - identifica o registro do seguro
// 993 - PIS/COFINS
// 997 - complemento de valor de Nota Fiscal e/ou ICMS
// 998 - servi‡os nЖo tributados
// 999 - identifica o registro de outras despesas acessўrias.
IF TIPOENT = "X" .AND. CODIGO = "FRETE"
field->ITEM := 991
ENDIF
IF TIPOENT = "X" .AND. CODIGO = "SEGURO"
field->ITEM := 992
ENDIF
IF TIPOENT = "X" .AND. CODIGO = "PISCONFINS"
field->ITEM := 993
ENDIF
IF TIPOENT = "X" .AND. CODIGO = "COMPLEMENTO"
field->ITEM := 997
ENDIF
IF TIPOENT = "X" .AND. CODIGO = "NAOTRIBUTADO"
field->ITEM := 998
ENDIF
IF TIPOENT = "X" .AND. CODIGO = "ACESSORIAS"
field->ITEM := 999
ENDIF
IF ITEM > 900
field->codigo    := ""
field->codigoRED := ""
field->desconto  := valormer
field->valormer  := 0
ENDIF
dbSkip()
ENDDO
ENDDO
ENDIF
dbCloseAll()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function M_BM701()
// +
// +    Called from ( m_sint.prg   )   7 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BM701()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_BM701( cARQ, cARQNF, cARQITE, cTIPONF, cIMP )

   filtro := RFILORD( "MM06", .F., "" )
   IF cIMP = "PRO"
      dbSelectAr( cARQITE )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      IF cTIPONF = "E"
         ordDestroy( "temp" )
         ordCreate(, "temp", "str( NRNOTA, 8 ) + str( FORNECEDO, 5 ) + str( ITEM, 5 )" )
         ordSetFocus( "temp" )
      ELSE
         ordDestroy( "temp" )
         ordCreate(, "temp", "str( NUMERO, 8 ) + str( FORNECEDO, 5 ) + str( SEQ, 5 )" )
         ordSetFocus( "temp" )
      ENDIF
   ENDIF

   @ 24, 00 SAY cTIPONF + ":" + cIMP
   dbSelectAr( cARQ )
   INITVARS()
   CLRVARS()
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF nANO < 2003
      IF cIMP = "ICM"
         ordDestroy( "temp" )
         ordCreate(, "temp", "str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DOPER + str( DICM, 5, 2 ) " )
         ordSetFocus( "temp" )
      ELSE
         ordDestroy( "temp" )
         ordCreate(, "temp", "str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DOPER + str( DIPI, 5, 2 )" )
         ordSetFocus( "temp" )
      ENDIF
   ELSE
      IF cIMP = "ICM"
         ordDestroy( "temp" )
         ordCreate(, "temp", "str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DCFONEW + str( DICM, 5, 2 )" )
         ordSetFocus( "temp" )
      ELSE
         ordDestroy( "temp" )
         ordCreate(, "temp", "str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DCFONEW + str( DIPI, 5, 2 )" )
         ordSetFocus( "temp" )
      ENDIF
   ENDIF

   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF

   dbSelectAr( Carq )
   dbGoTop()
   WHILE !Eof()
      @ 24, 10 SAY FORNECEDO
      xFORNECEDO := FORNECEDO
      xTIPOFOR   := TIPOFOR
      cCGC       := ""
      cIE        := ""
      cUF        := ""
      dbSelectAr( "MA01" )
      IF xTIPOFOR = "F"
         dbSelectAr( "MB01" )
      ENDIF
      dbGoTop()
      IF dbSeek( xFORNECEDO )
         cCGC := CGC
         cUF  := ESTADO
         IF xTIPOFOR = "F"
            cIE := IESTADUAL
         ELSE
            cIE := INSCR
         ENDIF
         IF PESSOA = "F"   // Pessoa Fisica
            cIE := "ISENTO"
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      WHILE xFORNECEDO = FORNECEDO .AND. !Eof()
         xNUMERO := NUMERO
         xDOPER  := AllTrim( DCFONEW )
         IF nANO < 2003
            xDOPER := AllTrim( DOPER )
         ENDIF
         xDICM := DICM
         xDIPI := DIPI
         @ 24, 20 SAY NUMERO
         IF nANO < 2003
            @ 24, 30 SAY DOPER
         ELSE
            @ 24, 30 SAY DCFONEW
         ENDIF
         @ 24, 35 SAY if( cIMP = "ICM", DICM, DIPI )
         aTOT    := { 0, 0, 0, 0, 0, 0 }
         cMODELO := 0
         cSERIE  := ""
         cSUB    := ""
         dbSelectAr( cARQNF )
         dbGoTop()
         mCHAVE   := xNUMERO
         cESPECIE := ""
         IF cTIPONF = "E"
            mCHAVE := Str( xNUMERO, 8 ) + Str( xFORNECEDO, 5 )
         ENDIF
         IF dbSeek( mCHAVE )
            cMODELO  := Val( MODELO )
            cESPECIE := ESPECIE
         ENDIF
         dbSelectAr( cARQ )
         WHILE xNUMERO = NUMERO .AND. xDOPER = if( nANO < 2003, AllTrim( DOPER ), AllTrim( DCFONEW ) ) .AND. if( cIMP = "ICM", xDICM = DICM, xDIPI = DIPI ) .AND. xFORNECEDO = FORNECEDO .AND. !Eof()
            IF PULASIN <> "S"
               EQUVARS()
               aTOT[ 1 ] += DVALORNF
               IF cIMP = "ICM" .OR. cIMP = "CT"
                  aTOT[ 2 ] += DBASEICM
                  aTOT[ 3 ] += DVALICM
                  aTOT[ 4 ] += ISENTAICM
                  aTOT[ 5 ] += OUTRAICM
               ELSE
                  aTOT[ 2 ] += DBASEIPI
                  aTOT[ 3 ] += DVALIPI
                  aTOT[ 4 ] += ISENTAIPI
                  aTOT[ 5 ] += OUTRAIPI
               ENDIF
               nDVALORNF := DVALORNF
               IF cIMP = "PRO" .AND. Empty( mDCANCEL ) .AND. cESPECIE <> "CT"
                  mCODIGO   := ""
                  mTIPOENT  := "X"
                  mCODRED   := "X"
                  mQTDE     := QUANT
                  mSITUACAO := 0
                  mDESCONTO := DESCSIN
                  dbSelectAr( cARQITE )
                  dbGoTop()
                  IF dbSeek( Str( xNUMERO, 8 ) + Str( XFORNECEDO, 5 ) + Str( mITEM, 5 ) )
                     IF nDVALORNF = VALORTOT   // Confirma o Valor
                        IF !Empty( CODICM )
                           mSITUACAO := Val( CODICM )
                        ENDIF
                        mCODIGO  := CODIGO
                        mTIPOENT := TIPOENT
                        mCODRED  := "X"
                        mQTDE    := QTDE
                        IF At( "FERRAMEN", Upper( NOME ) ) > 0  // Ferramental
                           mTIPOENT := "F"
                        ENDIF
                        IF mTIPOENT <> "X" .AND. mTIPOENT <> "F"
                           mCODRED := mTIPOENT + StrTran( TIRAOUT( mCODIGO ), " ", "" )
                        ELSE
                           mCODRED := mTIPOENT
                        ENDIF
                        IF Empty( mSITUACAO )
                           IF mTIPOENT = "B"   // Embalagem
                              mSITUACAO := 040
                           ENDIF
                           IF mTIPOENT = "T"   // Tratamento
                              mSITUACAO := 050
                           ENDIF
                           IF mTIPOENT = "F"   // Ferramental
                              mSITUACAO := 040
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
                  IF MQTDE = 0
                     mQTDE := 1
                  ENDIF
                  dbSelectAr( "SINT54" )
                  netrecapp()
                  field->TIPO   := "54"
                  field->CGC    := cCGC
                  field->MODELO := cMODELO
                  field->SERIE  := cSERIE
                  field->SUB    := cSUB
                  IF nANO < 2003
                     field->CFOP := "0" + xDOPER
                  ELSE
                     field->CFOP := xDOPER
                  ENDIF
                  field->NUMERO    := xNUMERO
                  field->ITEM      := mITEM
                  field->BASEICM   := mDBASEICM
                  field->VALORMER  := nDVALORNF
                  field->VALORIPI  := mDVALIPI
                  field->ICM       := mDICM
                  field->TIPONF    := cTIPONF
                  field->UF        := cUF
                  field->TIPOCLI   := xTIPOFOR
                  field->FORNECEDO := xFORNECEDO
                  field->CODIGO    := mCODIGO
                  field->TIPOENT   := mTIPOENT
                  field->CODIGORED := mCODRED
                  field->QTDE      := mQTDE
                  field->SITUACAO  := mSITUACAO
                  field->desconto  := mDESCONTO
               ENDIF
            ENDIF
            dbSelectAr( cARQ )
            dbSkip()
         ENDDO
         IF ( ( cIMP = "ICM" .OR. cIMP = "IPI" ) .AND. cESPECIE # "CT" ) ;
               .OR. ( cESPECIE = "CT" .AND. cIMP = "CT" ) ;
               .OR. ( cESPECIE = "CT" .AND. cIMP = "ICM" .AND. cTIPONF = "E" .AND. lAPA53B )
            DO CASE
            CASE cIMP = "ICM"
               dbSelectAr( "SINT50" )
            CASE cIMP = "IPI"
               dbSelectAr( "SINT51" )
            CASE cIMP = "CT"
               dbSelectAr( "SINT70" )
            ENDCASE
            netrecapp()
            DO CASE
            CASE cIMP = "ICM"
               field->TIPO := "50"
            CASE cIMP = "IPI"
               field->TIPO := "51"
            CASE cIMP = "CT"
               field->TIPO := "70"
            ENDCASE
            field->CGC    := cCGC
            field->IE     := cIE
            field->DATA   := mDATAREF
            field->UF     := cUF
            field->MODELO := cMODELO
            field->SERIE  := cSERIE
            field->SUB    := cSUB
            field->NUMERO := xNUMERO
            IF nANO < 2003
               field->CFOP := "0" + xDOPER
            ELSE
               field->CFOP := xDOPER
            ENDIF
            field->VALORTOT := aTOT[ 1 ]
            field->BASE     := aTOT[ 2 ]
            field->VALOR    := aTOT[ 3 ]
            field->ISENTA   := aTOT[ 4 ]
            field->OUTRAS   := aTOT[ 5 ]
            field->ALIQUOTA := if( cIMP = "ICM", XDICM, XDIPI )
            field->SITUACAO := if( Empty( mDCANCEL ), "N", "S" )
            field->TIPONF   := cTIPONF
            IF cIMP = "CT"
               field->FRETE := "2"   // FOB
            ENDIF
         ENDIF
         dbSelectAr( cARQ )
      ENDDO
      dbSelectAr( cARQ )
   ENDDO

// + EOF: M_SINT.PRG

// + EOF: m_sint.prg
// +
