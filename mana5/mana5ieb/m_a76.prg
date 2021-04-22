*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_A76.PRG
*+
*+    Functions: Function MAMGRVREM()
*+               Function GRVREMESSA()
*+               Function GRVREMAVU()
*+
*+    Reformatted by Click! 2.03 on Sep-1-2004 at 10:51 am
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

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
nREF       := 2     //Aceitar Codigos de Saida
ZESTADO    := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
mGERACOB   := "S"
mIMPDUP    := "N"

//Telas de Trabalho
aMAMTEL := TELAPEG( "ITMM01" )
aMAMGET := EDITPEG( "ITMM01" )
aMDETEL := TELAPEG( "MMDE01" )
aMDEGET := EDITPEG( "MMDE01" )

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
mOSTR := 0
if !CONFARQ( "MM01", "Nota    Emiss„o F Fornecedor" + spac( 9 ) + "S Ope P S Pag  Valor Total da NF" )
   retu .F.
endif
if !CONFIND( "MM01" )
   retu .F.
endif

//Pegando Cores de Trabalho UTILIZADAS CHAMADAS fMAM()
CORMAM := CORARR( "MAM" )

cVIDE := 'N'
while .T.
   mNUMERO := ULTIMOREG( "MM01", "NUMERO" )
   mNUMERO ++
   MDS( 'N§ Nota Fiscal : ' + space( 30 ) + "N§ Rem.Trat:" )
   @ 24, 16 get mNUMERO PICT "99999999"
   @ 24, 60 get mOSTR
   if !READCUR()
      release all like m *
      retu .F.
   endif
   yNRNOTA := mNUMERO
   mCHAVE  := mNUMERO //Usada Interna achoice nao apagar
   if !VERSEHA( "MM01", yNRNOTA )
      exit
   else
      ALERTX( "Nota Ja Faturada" )
   endif
enddo

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
if mOSTR > 0
   mAPURA    := "N"
   mCFONEW   := "5901"
   mTIPOSERV := "T"
   mTIPOCLI  := "F"
   mGERAAE   := "N"
   PEGACAMPO( "MOSB01", "mOSTR", { "FORNECEDO", "COGNOME" }, { "mFORNECEDO", "mCOGNOME" } )
endif
PADRAX( 3, mTRANSPORT, 0, { "MG01", "MG02" }, "NЈmero  Nome" + spac( 38 ) + "Cognome" + spac( 6 ) + "DDD  Telefone", ;
        "' '+mNUMERO+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE", "MAG001", "MAG001", ;
        { || MAGEN2() },, { || MAGREP() } )
mNUMERO := yNRNOTA
ARQUSO  := "MB01"
MAMK01()
NOVOREG( "MM01", yNRNOTA )
if mOSTR > 0
   l5901 := .F.
   l5920 := .F.
   mICM  := 0
   mTOTMER:=0
   mTOTNF:=0
   mTOTALPES:=0
   if USEREDE( "MOSB02", 1, 99 )
      dbsetorder(2) //str(numero,8)+tipoent (Ordenar Tipo -->Necessario
                   //Para gerar ordem correta dipi depois
      dbgotop()
      dbseek( str( mOSTR, 8 ) )
      while NUMERO = mOSTR .and. !eof()
         mCODIGO   := CODIGO
         mSEQ      := SEQ
         mUNID     := UNID
         mQTDE     := QTDE
         mPESO     := PESO
         mTIPOENT  := TIPOENT
         mNOME     := NOME
         mPRECO    := PRECO
         mRASTRO   := CHECKRASTRO(RASTRO)
         mRASTR2   := CHECKRASTRO(RASTR2)
         mLISTA    := LISTA
         mCODIPI   := CODIPI
         mPISCON   := PISCON
         mREDICM   := REDICM
         //mOBS      := OBS
         mINDICE   := INDICE
         mLINADD01 := space( 45 )
         mLINADD02 := space( 45 )
         mLINADD03 := space( 45 )
         mLINADD04 := space( 45 )
         mLINADD05 := space( 45 )
         mLINADD06 := OBS
         if mTIPOENT = "B"
            l5920 := .T.
            mTIPOSERV:="6"
         endif
         if mTIPOENT = "T"
            l5901 := .T.
         endif
         if mTIPOENT = "B"
            mDIPICM   := "I"
            mDIPIPI   := "I"
            mCODICM   := "040"
            mTIPOSERV := "6"
         else
            mDIPICM   := "O"
            mDIPIPI   := "O"
            mCODICM   := "050"
            mTIPOSERV := "T"
         endif
         mSOMANF   := "S"
         mCONSUMO  := "N"
         xCODIGO   := repl( "Z", 24 )   //Forcar Busca
         xCODIPI   := "__"
         yCODIGO   := repl( "Z", 24 )   //Forcar Busca
         xVALORMER := 0                 //Zero Para Recalcular
         xBASEICM  := 0
         xBASEIPI  := 0
         xIPI      := mIPI
         MAM203()   //PESO
         NFCOD( .F. )
         mPRECO := PRECO                //Pegar Sempre o Da Os
         mUNID  := UNID
         //Para os calculos
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
         //Ajustar
         mICM      := 0
         MBASEICM  := 0
         mVALORICM := 0
         mIPI      := 0
         mBASEIPI  := 0
         mVALORIPI := 0
         IF mQTDE>0
            IF mPESO>0
               if mPRECO>0
                  NOVOREG( "MM02", str( yNRNOTA, 8 ) + str( mSEQ, 2 ) )
               ELSE
                  ALERTX("Item com Preco Zerado "+mCODIGO)
               ENDIF
            ELSE
               ALERTX("Item com Peso Zerado "+mCODIGO)
            ENDIF
         ELSE
            ALERTX("Item com Qtde Zerada "+mCODIGO)
         ENDIF
         mTOTMER+=mVALORMER
         mTOTNF+=mVALORTOT
         mTOTALPES+=mPESO
         dbselectar( "MOSB02" )
         dbskip()
      enddo
   endif
   if l5901 .and. l5920
      mCFONEW  := "5901"
      mCFONEWB := "5920"
      GRAVAMVAR( "MM01", yNRNOTA, "CFONEW", "'5901'" )
      GRAVAMVAR( "MM01", yNRNOTA, "CFONEWB", "'5920'" )
   else
      if l5901
         mCFONEW := "5901"
         GRAVAMVAR( "MM01", yNRNOTA, "CFONEW", "'5901'" )
      endif
      if l5920
         mCFONEW := "5920"
         GRAVAMVAR( "MM01", yNRNOTA, "CFONEW", "'5920'" )
      endif
   endif
   mOPERACAO := OBTER( "MD04", mCFONEW, "CFO", 2 ) + if( empty( mCFONEWB ), "    ", + "/" + OBTER( "MD04", mCFONEWB, "CFO", 2 ) )
   GRAVAMVAR( "MM01", yNRNOTA, "OPERACAO", "mOPERACAO" )
   GRAVAMVAR( "MM01", yNRNOTA, "TOTMER", "mTOTMER" )
   GRAVAMVAR( "MM01", yNRNOTA, "TOTNF", "mTOTNF" )
   GRAVAMVAR( "MM01", yNRNOTA, "TOTALPES", "mTOTALPES" )
   IF USEREDE("MM02",1,99)
      DBGOTOP()
      DBSEEK(STR(yNRNOTA,8))
      WHILE yNRNOTA=NUMERO.AND.! EOF()
         netreclock()
         FIELD->OPERACAO:=mOPERACAO
         FIELD->CFONEW:=mCFONEW
         FIELD->CFONEWB:=mCFONEWB
         DBUNLOCK()
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
   ENDIF
endif

aMAM1 := { MAMSAY02() }
cVIDE := "N"
fMAM( 2, - 1, .T. )
while MDG( "Deseja Revisar Dados" )
   aMAM1 := { MAMSAY02() }
   cVIDE := "N"
   fMAM( 2, - 1,, .T. )
enddo
if !MDG( "Deseja Imprimir Nota Fiscal" )
   cVIDE := "N"
   fMAM( 3, - 1,, .T. )
endif
mDESCFO := OBTER( "MD04", mCFONEW, "NOMENOTA", 2 )
TIPCAD( mTIPOCLI, "ARQUSO" )

mCFTNEW  := alltrim( mCFONEW )
mCFTNEWB := alltrim( mCFONEWB )

if mCFTNEW ="5949".and.mTIPOSERV="6".AND.mTIPOENT="T" //Caso especial
   MAMGRVREM( yNRNOTA, mFORNECEDO, mTIPOCLI, .T. )
endif

if mCFTNEW = "5920" .or. mCFTNEW = "5901" .or. mCFTNEW = "5915" .or. ;
           mCFTNEW = "6920" .or. mCFTNEW = "6901" .or. mCFTNEW = "6915" .or. ;
           mCFTNEWB = "5920" .or. mCFTNEWB = "5901" .or. mCFTNEWB = "5915" .or. ;
           mCFTNEWB = "6920" .or. mCFTNEWB = "6901" .or. mCFTNEWB = "6915"
   MAMGRVREM( yNRNOTA, mFORNECEDO, mTIPOCLI, .T. )
else
   GRAVALOG( str( yNRNOTA, 8 ) + "NCF", "REM", "MM02" )
endif

M_A7I( yNRNOTA, .T., .T. )

retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MAMGRVREM()
*+
*+    Called from ( m_a76.prg    )   1 -
*+                                   1 - function grvremavu()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MAMGRVREM

para mNUMERO, mFORNECEDO, mTIPOCLI, lPERG, cARQ
if valtype( lPERG ) # "L"
   lPERG := .F.
endif
if valtype( cARQ ) # "C"
   cARQ := "MM02"
endif

if lPERG .or. MDG( "Gravar Remessa Trat/Emb MF:" + str( mNUMERO, 8 ) )
   mCLIENTE := mFORNECEDO
   while !USEREDE( cARQ, 1, 1 )
   enddo
   dbselectar( cARQ )
   dbgotop()
   dbseek( str( mNUMERO, 8 ) )
   while mNUMERO = NUMERO .and. !eof()
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
      if mTIPOENT = "B" .and. mTIPOCLI = "C"
         GRVREMESSA( "MR03", padr( mCODIGO, 10 ) + str( mNRNOTAINI, 8 ) )
      endif
      if mTIPOENT = "T" .or. mTIPOENT = "B" .and. mTIPOCLI = "F"
         GRVREMESSA( "MS04", padr( mCODIGO, 24 ) + str( mNRNOTAINI, 8 ) )
      endif
      if mTIPOENT = "T"  .and. mTIPOCLI = "F" //Controle Adcional So tratamento
         GRVREMESSA( "MS07", padr( mCODIGO, 24 ) + str( mNRNOTAINI, 8 ) )
      endif
      if mTIPOENT = "C" .and. mTIPOSERV = "T" .and. mTIPOCLI = "F"
         GRVREMESSA( "MS04", padr( mCODIGO, 24 ) + str( mNRNOTAINI, 8 ) )
      endif
      if mTIPOENT = "X"
         if empty( mCODIGO )
            GRVREMESSA( "MS04", str( mSEQ, 24 ) + str( mNRNOTAINI, 8 ) )
         else
            GRVREMESSA( "MS04", padr( mCODIGO, 24 ) + str( mNRNOTAINI, 8 ) )
         endif
      endif
      if !empty( mAVEMBC ) .and. mAVEMBQ > 0
         mCODIGO   := mAVEMBC
         mTOTKGINI := mAVEMBQ
         mTOTKGANT := mAVEMBQ
         mTOTKGEST := mAVEMBQ
         PEGACAMPO( "MR01", "mCODIGO", { "ALLTRIM(NOME)+' '+ALLTRIM(NOM2)", "CODIPI", "UNIDADE", "PESLIQ", "PRECUST" }, ;
                                         { "cNOME", "mCODIPI", "mUNID", "mPESO", "mPRECO" } )
         if mTIPOCLI = "F"
            GRVREMESSA( "MR03", padr( mCODIGO, 10 ) + str( mNRNOTAINI, 8 ) )
         else
            GRVREMESSA( "MS04", padr( mCODIGO, 24 ) + str( mNRNOTAINI, 8 ) )
         endif
      endif
      dbselectar( cARQ )
      dbskip()
   enddo
else
   GRAVALOG( str( mNUMERO, 8 ) + "NAO", "REM", caRQ )
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function GRVREMESSA()
*+
*+    Called from ( m_a76.prg    )   7 - function mamgrvrem()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func GRVREMESSA( cARQ, eCHAVE )

mDIGCTR := " "
while !NOVOREG( cARQ, eCHAVE + mDIGCTR, .F., .F. )
   if empty( mDIGCTR )
      mDIGCTR := "A"
   else
      nASC    := asc( mDIGCTR )
      mDIGCTR := chr( nASC + 1 )
   endif
enddo
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function GRVREMAVU()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func GRVREMAVU()

MDI( " Э Relancar Nota Para Remessas" )
mNUMERO    := 0
mFORNECEDO := 0
mTIPOCLI   := "C"
mCOGNOME   := ""
CRIARVARS("MM02")
CRIARVARS( "MS04" )
@ 24, 00 get mNUMERO pict "99999999"
if !READCUR()
   retu .F.
endif
aRETU := PERFEC( { "MM02", "MM01" }, { "M2", "M1" }, { "MM92", "MM91" } )
cARQ  := aRETU[ 5, 1 ]
cARQ2 := aRETU[ 5, 2 ]

if PEGACAMPO( cARQ2, "mNUMERO", { "FORNECEDO", "TIPOCLI", "COGNOME" }, { "mFORNECEDO", "mTIPOCLI", "mCOGNOME" } )
   MAMGRVREM( mNUMERO, mFORNECEDO, mTIPOCLI, .F., cARQ )
else
   ALERTX( "Nao achei a Nota" )
endif


FUNC CHECKRASTRO(cRASTRO)
LOCAL cANO,cSUB,nLEN
//Ano Atual
IF EMPTY(cRASTRO)
   RETU cRASTRO
ENDIF
nLEN:=LEN(cRASTRO)
cANO:=StrZero(Year(zdata),4)
cSUB:=Right(cANO,2)
IF At("-"+cSUB,cRASTRO)>0
   cRASTRO:=StrTran(cRASTRO,"-"+cSUB,"/"+cANO)
ENDIF
IF At("/"+cSUB,cRASTRO)>0
   cRASTRO:=StrTran(cRASTRO,"/"+cSUB,"/"+cANO)
ENDIF
//Ano Anterior
cANO:=StrZero(Year(zdata)-1,4)
cSUB:=Right(cANO,2)
IF At("-"+cSUB,cRASTRO)>0
   cRASTRO:=StrTran(cRASTRO,"-"+cSUB,"/"+cANO)
ENDIF
IF At("/"+cSUB,cRASTRO)>0
   cRASTRO:=StrTran(cRASTRO,"/"+cSUB,"/"+cANO)
ENDIF
RETU PADR(cRASTRO,nLEN)

*+ EOF: M_A76.PRG


