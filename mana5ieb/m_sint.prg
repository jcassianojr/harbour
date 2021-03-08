*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_SINT.PRG
*+
*+    Functions: Function M_BM701()
*+
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

MDI( " Э Acumular Sintegra" )
aRETU := PERFEC( { "MK06", "MM06", "MK01", "MM01", "MK02", "MM02" }, ;
                   { "K6", "M6", "K1", "M1", "K2", "M2" }, ;
                   { "MK96", "MM96", "MK91", "MM91", "MK92", "MM92" } )
nANO := ARETU[ 2 ]
if nANO < 2003
   ALERTX( "Cfo Antigo " + str( nano ) )
endif
cARQENT := aRETU[ 5, 1 ]
cARQSAI := aRETU[ 5, 2 ]
cARQNFE := aRETU[ 5, 3 ]
cARQNFS := aRETU[ 5, 4 ]
cARQITE := aRETU[ 5, 5 ]
cARQITS := aRETU[ 5, 6 ]

lAPA50  := MDG( "Apurar 50-ICMS" )
lAPA51  := MDG( "Apurar 51-IPI" )
lAPA54  := MDG( "Apurar 54-Produto" )
//usados CT antigos deixados como false apura CT agora com 70
lAPA53  := .F.
lAPA53B := .F.
if lAPA53
   lAPA53B := MDG( "Gerar Reg 50 do 53-CT" )
endif
lAPA70  := MDG( "Apurar 70 CT" )
if lAPA54
   if MDG( "Checar Classifica‡ao Fiscal - Saida" )
      M_AK2A( "S", cARQITS, cARQSAI )
   endif
   if MDG( "Checar Classifica‡ao Entrada" )
      M_AK2A( "E", cARQITE, cARQENT )
   endif
endif

if !USEMULT( { { "MA01", 1, 1 }, { "MB01", 1, 1 }, { cARQSAI, 1, 1 }, { cARQENT, 1, 1 }, ;
               { cARQNFS, 1, 1 }, { cARQNFE, 1, 1 }, { "SINT50", 0, 99 }, { "SINT51", 0, 99 }, ;
               { cARQITS, 1, 1 }, { cARQITE, 1, 1 }, { "SINT54", 0, 99 }, { "SINT75", 0, 99 }, ;
               { "SINT53", 0, 99 },{ "SINT70", 0, 99 } } )
   retu .F.
endif


dbselectar( "SINT50" )
if lAPA50
   zap
endif
dbselectar( "SINT51" )
if lAPA51
   zap
endif
dbselectar( "SINT54" )
if lAPA54
   zap
endif
dbselectar( "SINT75" )
if lAPA54
   zap
endif
dbselectar( "SINT53" )
if lAPA53
   zap
endif
dbselectar( "SINT70" )
if lAPA70
   zap
endif

MDS( "" )
if lAPA50
   if MDG( "Apurar Saida ICMS" )
      M_BM701( cARQSAI, cARQNFS, cARQITS, "S", "ICM" )
   endif
   if MDG( "Apurar Entrada ICMS" )
      M_BM701( cARQENT, cARQNFE, cARQITE, "E", "ICM" )
   endif
endif
if lAPA51
   if MDG( "Apurar Saida IPI" )
      M_BM701( cARQSAI, cARQNFS, cARQITS, "S", "IPI" )
   endif
   if MDG( "Apurar Entrada IPI" )
      M_BM701( cARQENT, cARQNFE, cARQITE, "E", "IPI" )
   endif
endif
if lAPA70
   if MDG( "Apurar Entrada CT" )
      M_BM701( cARQENT, cARQNFE, cARQITE, "E", "CT" )
   endif
endif
if lAPA54
   dbselectar( "SINT50" )
   dbsetorder( 2 )
   if MDG( "Apurar Produto Saida" )
      M_BM701( cARQSAI, cARQNFS, cARQITS, "S", "PRO" )
   endif
   if MDG( "Apurar Produto Entrada" )
      M_BM701( cARQENT, cARQNFE, cARQITE, "E", "PRO" )
   endif
   MDS( "Gerando Reg 75" )
   dbselectar( "SINT54" )
   dbsetorder( 3 )
   dbgotop()
   while !eof()
      @ 24, 20 say TIPOENT + CODIGO
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
      if mTIPOENT <> "X" .and. mTIPOENT <> "F"
         if mTIPOENT = "P"
            if PEGACAMPO( "MS01", "mCODIGO", { "NOME", "CODIPI", "UNID" }, { "mNOME", "mCODIPI", "mUNID" }, 2 )
               CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
            else
               ALERTX( "Verifique NF" + str( NUMERO ) + "Cod.Produto" )
            endif
            if empty( mCODIGO )
               ALERTX( "Verifique NF" + str( NUMERO ) + "Sem Cod.Produto " )
            endif
         endif
         if mTIPOENT $ "T"
            mNORMA := ""
            PEGACAMPO( "MP03", "mCODIGO", { "NOME", "UNIDADE", "REDICM", "NORMA" }, { "mNOME", "mUNID", "mREDICM", "mNORMA" } )
            if mREDICM > 0
               mREDICM := 100 - mREDICM
            endif
            if !empty( mNORMA )
               mNOME := OBTER( "ETI", alltrim( mNORMA ), "NOME" )
            endif
         endif
         if mTIPOENT = "I"
            PEGACAMPO( "ME04", "mCODIGO", { "PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)" }, { "mNOME" } )
         endif
         if mTIPOENT $ "MCORSB"
            PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "mCODIGO", { "NOME+NOM2", "UNIDADE", "CODIPI", "IPI", "CLASSIPI" }, { "mNOME", "mUNID", "mCODIPI", "mIPI", "mCLASSIPI" } )
         endif
         if empty( mIPI ) .and. !empty( mCODIPI )
            CHECKCIPI( mCODIPI, "mIPI" )
         endif
         if empty( mCLASSIPI ) .and. !empty( mCODIPI )
            CHECKCIPI( mCODIPI,, "mCLASSIPI" )
         endif
      endif
      if empty( mUNID )
         mUNID := "PC"
      endif
      dbselectar( "SINT75" )
      netrecapp()
      field->TIPO      := "75"
      field->CODIGORED := mCODIGORED
      field->CLASSIPI  := mCLASSIPI
      field->DESCRICAO := alltrim( TIRACE( mNOME ) )
      field->UNID      := mUNID
      field->IPI       := mIPI
      field->ICM       := mICM
      field->REDICM    := mREDICM
      field->TIPOENT   := mTIPOENT
      field->SITUACAO  := mSITUACAO
      if mTIPOENT = "F"                 //Ferramental
         field->DESCRICAO := "FERRAMENTAL"
      endif
      if mTIPOENT = "X"                 //Outras
         field->DESCRICAO := "OUTRAS"
      endif
      if empty( DESCRICAO ) .and. mTIPOENT $ "TORMC"
         field->DESCRICAO := "OUTRAS"
      endif
      dbselectar( "SINT54" )
      while mTIPOENT = TIPOENT .and. mCODIGORED = CODIGORED .and. !eof()
         dbskip()
      enddo
   enddo
   MDS( "Checagem Seq" )
   dbselectar( "SINT54" )
   dbsetorder( 1 )
   dbgotop()
   while !eof()
      @ 24, 20 say CGC
      @ 24, 40 say NUMERO
      cCGC       := alltrim( CGC )
      nNUMERO    := NUMERO
      nFORNECEDO := FORNECEDO
      nSEQ       := 0
      while cCGC = alltrim( CGC ) .and. nNUMERO = NUMERO .and. !eof()
         nSEQ ++
         field->ITEM := nSEQ
         // 991 - identifica o registro do frete
         // 992 - identifica o registro do seguro
         // 993 - PIS/COFINS
         // 997 - complemento de valor de Nota Fiscal e/ou ICMS
         // 998 - servi‡os nЖo tributados
         // 999 - identifica o registro de outras despesas acessўrias.
         IF TIPOENT="X".AND.CODIGO="FRETE"
            field->ITEM := 991
         endif
         IF TIPOENT="X".AND.CODIGO="SEGURO"
            field->ITEM := 992
         endif
         IF TIPOENT="X".AND.CODIGO="PISCONFINS"
            field->ITEM := 993
         endif
         IF TIPOENT="X".AND.CODIGO="COMPLEMENTO"
            field->ITEM := 997
         endif
         IF TIPOENT="X".AND.CODIGO="NAOTRIBUTADO"
            field->ITEM := 998
         endif
         IF TIPOENT="X".AND.CODIGO="ACESSORIAS"
            field->ITEM := 999
         endif
         if ITEM>900
            field->codigo:=""
            field->codigoRED:=""
            field->desconto:=valormer
            field->valormer:=0
         ENDIF
         dbskip()
      enddo
   enddo
endif
dbcloseall()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function M_BM701()
*+
*+    Called from ( m_sint.prg   )   7 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func M_BM701( cARQ, cARQNF, cARQITE, cTIPONF, cIMP )

filtro := RFILORD( "MM06", .F., "" )
if cIMP = "PRO"
   dbselectar( cARQITE )
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   if cTIPONF = "E"
      ordDestroy("temp")
      ordcreate(,"temp","str( NRNOTA, 8 ) + str( FORNECEDO, 5 ) + str( ITEM, 5 )")
      ordSetFocus("temp")      
   else 
      ordDestroy("temp")
      ordcreate(,"temp","str( NUMERO, 8 ) + str( FORNECEDO, 5 ) + str( SEQ, 5 )")
      ordSetFocus("temp")      
   endif
endif

@ 24, 00 say cTIPONF + ":" + cIMP
dbselectar( cARQ )
INITVARS()
CLRVARS()
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if nANO < 2003
   if cIMP = "ICM"
      ordDestroy("temp")
      ordcreate(,"temp","str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DOPER + str( DICM, 5, 2 ) ")
      ordSetFocus("temp")      
   else
      ordDestroy("temp")
      ordcreate(,"temp","str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DOPER + str( DIPI, 5, 2 )")
      ordSetFocus("temp")
   endif
else
   if cIMP = "ICM"
      ordDestroy("temp")
      ordcreate(,"temp","str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DCFONEW + str( DICM, 5, 2 )")
      ordSetFocus("temp")      
   else
      ordDestroy("temp")
      ordcreate(,"temp","str( FORNECEDO, 8 ) + str( NUMERO, 8 ) + DCFONEW + str( DIPI, 5, 2 )")
      ordSetFocus("temp")
   endif
endif

if !empty( FILTRO )
   set filter to &FILTRO
endif

dbselectar( Carq )
dbgotop()
while !eof()
   @ 24, 10 say FORNECEDO
   xFORNECEDO := FORNECEDO
   xTIPOFOR   := TIPOFOR
   cCGC       := ""
   cIE        := ""
   cUF        := ""
   dbselectar( "MA01" )
   if xTIPOFOR = "F"
      dbselectar( "MB01" )
   endif
   dbgotop()
   if dbseek( xFORNECEDO )
      cCGC := CGC
      cUF  := ESTADO
      if xTIPOFOR = "F"
         cIE := IESTADUAL
      else
         cIE := INSCR
      endif
      if PESSOA = "F"                   //Pessoa Fisica
         cIE := "ISENTO"
      endif
   endif
   dbselectar( cARQ )
   while xFORNECEDO = FORNECEDO .and. !eof()
      xNUMERO := NUMERO
      xDOPER  := alltrim( DCFONEW )
      if nANO < 2003
         xDOPER := alltrim( DOPER )
      endif
      xDICM := DICM
      xDIPI := DIPI
      @ 24, 20 say NUMERO
      if nANO < 2003
         @ 24, 30 say DOPER
      else
         @ 24, 30 say DCFONEW
      endif
      @ 24, 35 say if( cIMP = "ICM", DICM, DIPI )
      aTOT    := { 0, 0, 0, 0, 0, 0 }
      cMODELO := 0
      cSERIE  := ""
      cSUB    := ""
      dbselectar( cARQNF )
      dbgotop()
      mCHAVE   := xNUMERO
      cESPECIE := ""
      if cTIPONF = "E"
         mCHAVE := str( xNUMERO, 8 ) + str( xFORNECEDO, 5 )
      endif
      if dbseek( mCHAVE )
         cMODELO  := val( MODELO )
         cESPECIE := ESPECIE
      endif
      dbselectar( cARQ )
      while xNUMERO = NUMERO .and. xDOPER = if( nANO < 2003, alltrim( DOPER ), alltrim( DCFONEW ) ) .and. if( cIMP = "ICM", xDICM = DICM, xDIPI = DIPI ) .and. xFORNECEDO = FORNECEDO .and. !eof()
         if PULASIN <> "S"
            EQUVARS()
            aTOT[ 1 ] += DVALORNF
            if cIMP = "ICM" .or. cIMP = "CT"
               aTOT[ 2 ] += DBASEICM
               aTOT[ 3 ] += DVALICM
               aTOT[ 4 ] += ISENTAICM
               aTOT[ 5 ] += OUTRAICM
            else
               aTOT[ 2 ] += DBASEIPI
               aTOT[ 3 ] += DVALIPI
               aTOT[ 4 ] += ISENTAIPI
               aTOT[ 5 ] += OUTRAIPI
            endif
            nDVALORNF := DVALORNF
            if cIMP = "PRO" .and. empty( mDCANCEL ).AND.cESPECIE<>"CT"
               mCODIGO   := ""
               mTIPOENT  := "X"
               mCODRED   := "X"
               mQTDE     := QUANT
               mSITUACAO := 0
               mDESCONTO := DESCSIN
               dbselectar( cARQITE )
               dbgotop()
               if dbseek( str( xNUMERO, 8 ) + str( XFORNECEDO, 5 ) + str( mITEM, 5 ) )
                  if nDVALORNF = VALORTOT                   //Confirma o Valor
                     if !empty( CODICM )
                        mSITUACAO := val( CODICM )
                     endif
                     mCODIGO  := CODIGO
                     mTIPOENT := TIPOENT
                     mCODRED  := "X"
                     mQTDE    := QTDE
                     if at( "FERRAMEN", upper( NOME ) ) > 0                     //Ferramental
                        mTIPOENT := "F"
                     endif
                     if mTIPOENT <> "X" .and. mTIPOENT <> "F"
                        mCODRED := mTIPOENT + strtran( TIRAOUT( mCODIGO ), " ", "" )
                     else
                        mCODRED := mTIPOENT
                     endif
                     if empty( mSITUACAO )
                        if mTIPOENT = "B"                   //Embalagem
                           mSITUACAO := 040
                        endif
                        if mTIPOENT = "T"                   //Tratamento
                           mSITUACAO := 050
                        endif
                        if mTIPOENT = "F"                   //Ferramental
                           mSITUACAO := 040
                        endif
                     endif
                  endif
               endif
               if MQTDE = 0
                  mQTDE := 1
               endif
               dbselectar( "SINT54" )
               netrecapp()
               field->TIPO   := "54"
               field->CGC    := cCGC
               field->MODELO := cMODELO
               field->SERIE  := cSERIE
               field->SUB    := cSUB
               if nANO < 2003
                  field->CFOP := "0" + xDOPER
               else
                  field->CFOP := xDOPER
               endif
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
            endif
         endif
         dbselectar( cARQ )
         dbskip()
      enddo
      if ( ( cIMP = "ICM" .or. cIMP = "IPI" ) .and. cESPECIE # "CT" ) ;
             .or. ( cESPECIE = "CT" .and. cIMP = "CT" ) ;
             .or. ( cESPECIE = "CT" .and. cIMP = "ICM" .and. cTIPONF = "E" .and. lAPA53B )
         do case
         case cIMP = "ICM"
            dbselectar( "SINT50" )
         case cIMP = "IPI"
            dbselectar( "SINT51" )
         case cIMP = "CT"
            dbselectar( "SINT70" )
         endcase
         netrecapp()
         do case
         case cIMP = "ICM"
            field->TIPO := "50"
         case cIMP = "IPI"
            field->TIPO := "51"
         case cIMP = "CT"
            field->TIPO := "70"
         endcase
         field->CGC    := cCGC
         field->IE     := cIE
         field->DATA   := mDATAREF
         field->UF     := cUF
         field->MODELO := cMODELO
         field->SERIE  := cSERIE
         field->SUB    := cSUB
         field->NUMERO := xNUMERO
         if nANO < 2003
            field->CFOP := "0" + xDOPER
         else
            field->CFOP := xDOPER
         endif
         field->VALORTOT := aTOT[ 1 ]
         field->BASE     := aTOT[ 2 ]
         field->VALOR    := aTOT[ 3 ]
         field->ISENTA   := aTOT[ 4 ]
         field->OUTRAS   := aTOT[ 5 ]
         field->ALIQUOTA := if( cIMP = "ICM", XDICM, XDIPI )
         field->SITUACAO := if( empty( mDCANCEL ), "N", "S" )
         field->TIPONF   := cTIPONF
         IF cIMP = "CT"
            field->FRETE := "2" //FOB
         ENDIF
      endif
      dbselectar( cARQ )
   enddo
   dbselectar( cARQ )
enddo

*+ EOF: M_SINT.PRG
