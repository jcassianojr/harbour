*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\MLIBNF.PRG
*+
*+    Functions: Function NFCOD()
*+               Function PEGLOTE()
*+               Function NFBAS()
*+               Function NFBICM()
*+               Function NFBIPI()
*+               Function NFIPI()
*+               Function NFVIPI()
*+               Function NFVICM()
*+
*+    Reformatted by Click! 2.03 on Nov-25-2003 at  5:05 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// * Traz dados Basicos Conforme Codigo
// *
// *
// *

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFCOD()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFCOD( lPEGLIS )
local cDBF := alias()
IF mTIPOENT = "X" //Nada Faz Quando X
   RETU .T.
ENDIF
if valtype( lPEGLIS ) # "L"
   lPEGLIS:=.F.
   IF nREF=2
      lPEGLIS := .T.
   ENDIF
endif
priv cNOME   := ""
priv cCODIGO := alltrim( mCODIGO )
priv GETLIST := {}
if xCODIGO # mCODIGO
   nLENNOME := len( mNOME )             //Tamanho do Arquivo
   do case
   case mTIPOENT = "I"
       PEGACAMPO( "ME04", "cCODIGO", { "PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)" }, { "cNOME"} )
   case mTIPOENT = "F"
      PEGACAMPO( "FERRAM", "cCODIGO", { "NOME" }, { "cNOME" } )
   case mTIPOENT = "O" .or. mTIPOENT = "R"
      PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "cCODIGO", { "NOME", "UNIDADE", "REDICM", "CODIPI", "CLASSIPI", "IPI" }, ;
              { "cNOME", "mUNID", "mREDICM", "mCODIPI", "mCLASSIPI", "mIPI" } )
   case mTIPOENT = "T"
      PEGACAMPO( "MP03", "cCODIGO", { "REDICM", "SPACE(45)", "CODIPI", "CLASSIPI", "IPI" }, ;
                                      { "mREDICM", "mNOME", "mCODIPI", "mCLASSIPI", "mIPI" } )
      MMTRA("mNOME")
      mNOME:=PADR("Pedido:"+mNOME,45)
      cCODIGO := alltrim( OBTER( "MP03", cCODIGO, "SUBPROD",,,,,, "" ) )
      if !empty( cCODIGO )              //Sub Produto
         PEGACAMPO( "MQ01", "cCODIGO", { "NOME", "UNIDADE", "PESLIQ", "PRECUST" }, { "cNOME", "mUNID", "mPESO", "mPRECO" } )
         lPEGLIS:=.F.
      else
         cCODIGO := alltrim( mCODIGO )
         cCODIGO := alltrim( OBTER( "MP03", cCODIGO, "SUBAPL",,,,,, "" ) )
         if empty( cCODIGO )
            cCODIGO := alltrim( mCODIGO )
            cCODIGO := alltrim( OBTER( "MP03", cCODIGO, "APLICACAO",,,,,, "" ) )
         endif
         if empty( cCODIGO )
            cCODIGO := alltrim( mCODIGO )
         endif
         while !PEGACAMPO( "MS01", "cCODIGO", { "NOME", "UNID", "PESOUNI" }, { "cNOME", "mUNID", "mPESO" }, 2 )
            cCODIGO := padr( cCODIGO, 24 )
            ALERTX( "Aplicao Produto NЦo Encontrado" )
            @ 24, 00 get cCODIGO
            READCUR()
            cCODIGO := alltrim( cCODIGO )
         enddo
      endif
      cNOME += mNOME
      //Verifica se tem Reducao Especial de ICMS
      mREDICM  := OBTER( "MM08", mTIPOENT + padr( mCODIGO, 24 ) + str( mFORNECEDO, 8 ), "REDICM",,,,,, mREDICM )
      mCODITAB := cCODIGO
      if empty( mPISCON ) .or. INCLUI
         mPISCON := OBTER("MP03", mCODIGO, "PISCON" )
      endif
   case mTIPOENT = "D"
      cNOME := OBTER( "MI01", cCODIGO, "NOME" )
   case mTIPOENT = "M" .or. mTIPOENT = "C" .or. mTIPOENT = "S" .or. mTIPOENT = "B"
      if empty( mPRECO ) .or. INCLUI .and. mTIPOENT = "S" .and. mTIPOENT = "B"
         mPRECO := OBTER( ESTQARQ( mTIPOENT, 1 ), cCODIGO, "PRECUST" )
      endif
      if empty( mPRECO ) .or. INCLUI .and. mTIPOENT = "M" .and. mTIPOENT = "C"
         mPRECO := OBTER( ESTQARQ( mTIPOENT, 1 ), cCODIGO, "ULTPRC" )
      endif
      if empty( mPISCON ) .or. INCLUI
         mPISCON := OBTER( ESTQARQ( mTIPOENT, 1 ), cCODIGO, "PISCON" )
      endif
      if mTIPOENT = "B" .and. ( empty( mPESO ) .or. INCLUI )
         mPESO := OBTER( "MR01", cCODIGO, "PESLIQ" )
      endif
      if mTIPOENT = "S" .and. ( empty( mPESO ) .or. INCLUI )
         mPESO := OBTER( "MQ01", cCODIGO, "PESLIQ" )
      endif
      PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "cCODIGO", { "ALLTRIM(NOME)+' '+ALLTRIM(NOM2)", "CODIPI", "UNIDADE", "CLASSIPI" }, { "cNOME", "mCODIPI", "mUNID", "mCLASSIPI" } )
      if mTIPOSERV = "R"
         mPRECO := round( mPRECO * .52, 4 )
      endif
   case mTIPOENT = "P"
      mINDICE := ""
      PEGACAMPO( "MS01", "cCODIGO", { "NOME", "CODIPI", "UNID", "INDICE" }, { "cNOME", "mCODIPI", "mUNID", "mINDICE" }, 2 )
      if empty( mPESO ) .or. INCLUI
         mPESO := OBTER( "MS01", cCODIGO, "PESOUNI", 2 )
      endif
   endcase
   if mTIPOENT = "P" .or. mTIPOENT = "T"
      cUNID:=mUNID
      if empty( mPRECO ) .or. (INCLUI.AND.lPEGLIS)
         if empty( mLISTA ) .and. mFORNECEDO > 0
            mLISTA := OBTER( "MA01", mFORNECEDO, "MO02LISTA" )
         endif
         IF mTIPOENT="P"
            aPRC := MS02PRC( cCODIGO, mLISTA, .T., "mUNID", "mCODIPI" )
         ELSE
            aPRC := MS02PRC( cCODIGO, mLISTA, .T.,"cUNID",,,.F.)
         ENDIF
         if lPEGLIS
            mLISTANR:=mLISTA
            cCODIGO:=PADR(cCODIGO,24)
            while .T.
               MDS( "Digite NЇ da Lista de Preo" )
               @ 24, 40 get mLISTANR PICT "9999999"
               IF mTIPOENT="T"
                  @ 24,50 GET cCODIGO
               ENDIF
               READCUR()
               IF EMPTY(mLISTANR)
                  EXIT
               ENDIF
               IF mTIPOENT="P"
                  aPRC := MS02PRC( cCODIGO, mLISTANR, .T., "mUNID", "mCODIPI" )
                  mUNID:=cUNID
               ELSE
                  aPRC := MS02PRC( cCODIGO, mLISTANR, .T.,"cUNID")
               ENDIF
               if aPRC[ 1 ] > 0
                  exit
               endif
            enddo
         endif
         IF aPRC[1]>0
            if empty( mINDICE )
               mPRECO := aPRC[ 1 ]
            else
               mVALIND := aPRC[ 1 ]
            endif
            mDATABASE := aPRC[ 3 ]
         ENDIF
      endif
      if mTIPOSERV = "R" .or. mTIPOSERV = "V" .or. mTIPOSERV = "T"
         DO CASE
            CASE mTIPOSERV = "R"
                mPRECO := round( mPRECO * .38, 4 )
            CASE mTIPOSERV = "V"
                 mPRECO := round( mPRECO * .52, 4 )
            CASE mTIPOSERV = "T"
                mPRECO := round( mPRECO * .3, 4 )
         endCASE
         if cUNID = "CT"
            mUNID  := "PC"
            mPRECO := round( mPRECO / 100, 4 )
         endif
         if cUNID = "ML"
            mUNID  := "PC"
            mPRECO := round( mPRECO / 1000, 4 )
         endif
         mPRECO:=ROUND(mPRECO,2)
      endif
   endif
   cNOME := alltrim( cNOME )
   mNOME := substr( cNOME, 1, nLENNOME )
   if len( cNOME ) > nLENNOME
      mLINADD01 := substr( cNOME, nLENNOME + 1, 45 )
      if len( cNOME ) > nLENNOME + 45
         mLINADD02 := substr( cNOME, nLENNOME + 46, 45 )
         if len( cNOME ) > nLENNOME + 90
            mLINADD03 := substr( cNOME, nLENNOME + 91, 45 )
            if len( cNOME ) > nLENNOME + 135
               mLINADD04 := substr( cNOME, nLENNOME + 136, 45 )
            endif
         endif
      endif
   endif
   if mTIPOENT = "T"
      mIPI := 0
   else
      if !empty( mCODIPI )
         mIPI := OBTER( "MD03", mCODIPI, "ALIQUOTA" )
      endif
   endif
   if !empty( mCODIPI )
      CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM", mCFONEW, 2  ,"mDIPIPI","mDIPICM")
   endif
   xCODIGO := mCODIGO
endif
if !empty( cDBF )
   sele &cDBF.
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PEGLOTE()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func PEGLOTE( nTIP, dDATA, cVAR )

local cCHAVE
cCHAVE := str( ZNUMERO, 5 )
cCHAVE += strzero( year( dDATA ), 4 )
cCHAVE += strzero( month( dDATA ), 2 )
if !USEREDE( "FI_MES", 1, 1 )
   retu
endif
dbgotop()
if dbseek( cCHAVE )
   netreclock()
   if nTIP = 1
      &cVAR.        := FISEQE + 1
      field->FISEQE := FISEQE + 1
      field->FILANE := dDATA
   endif
   if nTIP = 5
      &cVAR.          := FISEQISE + 1
      field->FISEQISE := FISEQISE + 1
      field->FILANISE := dDATA
   endif
   if nTIP = 6
      &cVAR.          := FISEQISS + 1
      field->FISEQISS := FISEQISS + 1
      field->FILANISS := dDATA
   endif
   dbunlock()
endif
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFBAS()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFBAS( nVALFRE, nREDICM, cTIP )

local nPERICM := 100
if valtype( cTIP ) # "C"
   cTIP := "S"
endif
if valtype( nVALFRE ) # "N"
   nVALFRE := 0
endif
if valtype( nREDICM ) # "N"
   nREDICM := 0
endif
if nREDICM > 0
   nPERICM := 100 - nREDICM
endif
mVALORMER := round( mQTDE * mPRECO, 2 )
if xVALORMER # mVALORMER
   mBASEIPI  := mVALORMER + nVALFRE
   mVALORIPI := round( mBASEIPI * ( mIPI / 100 ), 2 )
   if mSOMANF = "S"
      mVALORTOT := mVALORMER + mVALORIPI + nVALFRE
   else
      mVALORTOT := mVALORMER + nVALFRE
   endif
   if nREDICM > 0
      if mCONSUMO = "S"
         mBASEICM := round( mVALORTOT * nPERICM / 100, 2 )
      else
         mBASEICM := round( ( mVALORMER + nVALFRE ) * nPERICM / 100, 2 )
      endif
   else
      if mCONSUMO = "S"
         mBASEICM := mVALORTOT
      else
         mBASEICM := mVALORMER + nVALFRE
      endif
   endif
   xBASEICM  := mBASEICM
   mVALORICM := round( mBASEICM * ( mICM / 100 ), 2 )
   xVALORMER := mVALORMER
endif
if empty( mVALORIPI ) .and. mIPI > 0
   mVALORIPI := round( mBASEIPI * ( mIPI / 100 ), 2 )
endif
if empty( mVALORICM ) .and. mICM > 0
   mVALORICM := round( mBASEICM * ( mICM / 100 ), 2 )
endif
if mSOMANF = "S"
   mVALORTOT := mVALORMER + mVALORIPI + nVALFRE
else
   mVALORTOT := mVALORMER + nVALFRE
endif
if cTIP = "S"
   @ 14, 15 say mVALORMER pict "@E 999,999,999,999.99"
   @ 18, 15 say mVALORTOT pict "@E 999,999,999,999.99"
else
   //   @ 12,15 SAY mVALORMER PICT "@E 999,999,999,999.99"
   //   @ 17,15 SAY mVALORTOT PICT "@E 999,999,999,999.99"
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFBICM()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFBICM

if xBASEICM # mBASEICM
   if mICM > 0
      mVALORICM := round( mBASEICM * ( mICM / 100 ), 2 )
   else
      mVALORICM := 0
   endif
   xBASEICM := mBASEICM
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFBIPI()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFBIPI

if xBASEIPI # mBASEIPI
   if mIPI > 0
      mVALORIPI := round( mBASEIPI * ( mIPI / 100 ), 2 )
   endif
   xBASEIPI := mBASEIPI
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFIPI()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFIPI()

if xIPI # mIPI
   if mIPI > 0
      mVALORIPI := round( mBASEIPI * ( mIPI / 100 ), 2 )
   endif
   xIPI := mIPI
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFVIPI()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFVIPI

if empty( mIPI ) .and. empty( mVALORIPI )
   mBASEIPI := 0
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function NFVICM()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func NFVICM

if empty( mICM ) .and. empty( mVALORICM )
   mBASEICM := 0
endif
retu .T.

*+ EOF: MLIBNF.PRG
