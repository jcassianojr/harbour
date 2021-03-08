*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlibnf.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFCOD()
*+    Traz dados Basicos Conforme Codigo
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFCOD(lPEGLIS)

LOCAL cDBF := ALIAS()
IF VALTYPE(lPEGLIS) # "L"
   lPEGLIS := .F.
ENDIF
PRIV cNOME   := "",cCODIGO := ALLTRIM(mCODIGO)
PRIV GETLIST := {}
IF xCODIGO # mCODIGO
   nLENNOME := LEN(mNOME)   //Tamanho do Arquivo
   DO CASE
      CASE mTIPOENT = "F"
         PEGACAMPO("FERRAM","cCODIGO",{"NOME"},{"cNOME"})
      CASE mTIPOENT = "O" .OR. mTIPOENT = "R"
         PEGACAMPO(ESTQARQ(mTIPOENT,1),"cCODIGO",{"NOME","UNIDADE","REDICM","CODIPI","CLASSIPI","IPI"},;
          {"cNOME","mUNID","mREDICM","mCODIPI","mCLASSIPI","mIPI"})
      CASE mTIPOENT = "T"
         PEGACAMPO("MP03","cCODIGO",{"REDICM","padr(NORMA,45)","CODIPI","CLASSIPI","IPI"},;
          {"mREDICM","mNOME","mCODIPI","mCLASSIPI","mIPI"})
         cCODIGO := ALLTRIM(OBTER("MP03",cCODIGO,"SUBPROD",,,,,,""))
         IF !EMPTY(cCODIGO)   //Sub Produto
            PEGACAMPO("MQ01","cCODIGO",{"NOME","UNIDADE","PESLIQ","PRECUST"},{"cNOME","mUNID","mPESO","mPRECO"})
         ELSE
            cCODIGO := ALLTRIM(mCODIGO)
            cCODIGO := ALLTRIM(OBTER("MP03",cCODIGO,"SUBAPL",,,,,,""))
            IF EMPTY(cCODIGO)
               cCODIGO := ALLTRIM(mCODIGO)
               cCODIGO := ALLTRIM(OBTER("MP03",cCODIGO,"APLICACAO",,,,,,""))
            ENDIF
            IF EMPTY(cCODIGO)
               cCODIGO := ALLTRIM(mCODIGO)
            ENDIF
            WHILE !PEGACAMPO("MS01","cCODIGO",{"NOME","UNID","PESOUNI"},{"cNOME","mUNID","mPESO"},2)
               cCODIGO := PADR(cCODIGO,24)
               ALERTX("Aplicacao Produto Nao Encontrado")
               @ 24,00 GET cCODIGO         
               READCUR()
               cCODIGO := ALLTRIM(cCODIGO)
            ENDDO
         ENDIF
         cNOME += mNOME
         //Verifica se tem Reducao Especial de ICMS
         mREDICM  := OBTER("MM08",mTIPOENT+PADR(mCODIGO,24)+STR(mFORNECEDO,8),"REDICM",,,,,,mREDICM)
         mCODITAB := cCODIGO
      CASE mTIPOENT = "D"
         cNOME := OBTER("MI01",cCODIGO,"NOME")
      CASE mTIPOENT = "M" .OR. mTIPOENT = "C" .OR. mTIPOENT = "S" .OR. mTIPOENT = "B"
         IF EMPTY(mPRECO) .OR. INCLUI .AND. mTIPOENT = "S" .AND. mTIPOENT = "B"
            mPRECO := OBTER(ESTQARQ(mTIPOENT,1),cCODIGO,"PRECUST")
         ENDIF
         IF EMPTY(mPRECO) .OR. INCLUI .AND. mTIPOENT = "M" .AND. mTIPOENT = "C"
            mPRECO := OBTER(ESTQARQ(mTIPOENT,1),cCODIGO,"ULTPRC")
         ENDIF
         IF EMPTY(mPISCON) .OR. INCLUI
            mPISCON := OBTER(ESTQARQ(mTIPOENT,1),cCODIGO,"PISCON")
         ENDIF
         IF mTIPOENT = "B" .AND. (EMPTY(mPESO) .OR. INCLUI)
            mPESO := OBTER("MR01",cCODIGO,"PESLIQ")
         ENDIF
         PEGACAMPO(ESTQARQ(mTIPOENT,1),"cCODIGO",{"ALLTRIM(NOME)+' '+ALLTRIM(NOM2)","CODIPI","UNIDADE","CLASSIPI"},{"cNOME","mCODIPI","mUNID","mCLASSIPI"})
         IF mTIPOSERV = "R"
            mPRECO := round(mPRECO * .52,4)
         ENDIF
      CASE mTIPOENT = "P"
         mINDICE := ""
         PEGACAMPO("MS01","cCODIGO",{"NOME","CODIPI","UNID","INDICE"},{"cNOME","mCODIPI","mUNID","mINDICE"},2)
         IF EMPTY(mPESO) .OR. INCLUI
            mPESO := OBTER("MS01",cCODIGO,"PESOUNI",2)
         ENDIF
         IF EMPTY(mPRECO) .OR. INCLUI
            IF EMPTY(mLISTA) .AND. mFORNECEDO > 0
               mLISTA := OBTER("MA01",mFORNECEDO,"MO02LISTA")
            ENDIF
            aPRC := MS02PRC(mCODIGO,mLISTA,.T.,"mUNID","mCODIPI")
            IF lPEGLIS
               WHILE .T.
                  IF !MDG("Digitar Lista de Pre‡o")
                     EXIT
                  ENDIF
                  mLISTANR := mlISTA
                  MDS("Digite Numero da Lista de Pre‡o")
                  @ 24,50 get mLISTANR         
                  READCUR()
                  aPRC := MS02PRC(mCODIGO,mLISTANR,.T.,"mUNID","mCODIPI")
                  if aPRC[1] > 0
                     EXIT
                  ENDIF
               ENDDO
            ENDIF
            IF EMPTY(mINDICE)
               mPRECO := aPRC[1]
            ELSE
               mVALIND := aPRC[1]
            ENDIF
            mDATABASE := aPRC[3]
         ENDIF
         IF mTIPOSERV = "R" .OR. mTIPOSERV = "V"
            IF mTIPOSERV = "R"
               mPRECO := round(mPRECO * .38,4)
            ELSE
               mPRECO := round(mPRECO * .52,4)
            ENDIF
            if mUNID = "CT"
               mUNID  := "PC"
               mPRECO := round(mPRECO / 100,4)
            ENDIF
            if mUNID = "ML"
               mUNID  := "PC"
               mPRECO := round(mPRECO / 1000,4)
            ENDIF
         ENDIF
   ENDCASE
   cNOME := ALLTRIM(cNOME)
   mNOME := SUBSTR(cNOME,1,nLENNOME)
   IF LEN(cNOME) > nLENNOME
      mLINADD01 := SUBSTR(cNOME,nLENNOME+1,45)
      IF LEN(cNOME) > nLENNOME+45
         mLINADD02 := SUBSTR(cNOME,nLENNOME+46,45)
         IF LEN(cNOME) > nLENNOME+90
            mLINADD03 := SUBSTR(cNOME,nLENNOME+91,45)
            IF LEN(cNOME) > nLENNOME+135
               mLINADD04 := SUBSTR(cNOME,nLENNOME+136,45)
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   if mTIPOENT = "T"
      mIPI := 0
   ELSE
      IF !EMPTY(mCODIPI)
         mIPI := OBTER("MD03",mCODIPI,"ALIQUOTA")
      ENDIF
   ENDIF
   IF !EMPTY(mCODIPI)
      CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI","mICM",mCFONEW,2)
   ENDIF
   xCODIGO := mCODIGO
ENDIF
if !empty(cDBF)
   sele &cDBF.
endif
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEGLOTE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC PEGLOTE(nTIP,dDATA,cVAR)

local cCHAVE
cCHAVE := STR(ZNUMERO,5)
cCHAVE += STRZERO(YEAR(dDATA),4)
cCHAVE += STRZERO(MONTH(dDATA),2)
IF !USEREDE("FI_MES",1,1)
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(cCHAVE)
   netreclock()
   IF nTIP = 1
      &cVAR.        := FISEQE+1
      FIELD->FISEQE := FISEQE+1
      FIELD->FILANE := dDATA
   ENDIF
   IF nTIP = 5
      &cVAR.          := FISEQISE+1
      FIELD->FISEQISE := FISEQISE+1
      FIELD->FILANISE := dDATA
   Endif
   IF nTIP = 6
      &cVAR.          := FISEQISS+1
      FIELD->FISEQISS := FISEQISS+1
      FIELD->FILANISS := dDATA
   Endif
   DBUNLOCK()
ENDIF
RETU



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFBAS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFBAS(nVALFRE,nREDICM,cTIP)

LOCAL nPERICM := 100
IF VALTYPE(cTIP) # "C"
   cTIP := "S"
ENDIF
IF VALTYPE(nVALFRE) # "N"
   nVALFRE := 0
ENDIF
IF VALTYPE(nREDICM) # "N"
   nREDICM := 0
ENDIF
IF nREDICM > 0
   nPERICM := 100 - nREDICM
ENDIF
mVALORMER := ROUND(mQTDE * mPRECO,2)
IF xVALORMER # mVALORMER
   mBASEIPI  := mVALORMER+nVALFRE
   mVALORIPI := ROUND(mBASEIPI * (mIPI / 100),2)
   IF mSOMANF = "S"
      mVALORTOT := mVALORMER+mVALORIPI+nVALFRE
   ELSE
      mVALORTOT := mVALORMER+nVALFRE
   ENDIF
   IF nREDICM > 0
      IF mCONSUMO = "S"
         mBASEICM := ROUND(mVALORTOT * nPERICM / 100,2)
      ELSE
         mBASEICM := ROUND((mVALORMER+nVALFRE) * nPERICM / 100,2)
      ENDIF
   ELSE
      IF mCONSUMO = "S"
         mBASEICM := mVALORTOT
      ELSE
         mBASEICM := mVALORMER+nVALFRE
      ENDIF
   ENDIF
   xBASEICM  := mBASEICM
   mVALORICM := ROUND(mBASEICM * (mICM / 100),2)
   xVALORMER := mVALORMER
ENDIF
IF EMPTY(mVALORIPI) .AND. mIPI > 0
   mVALORIPI := ROUND(mBASEIPI * (mIPI / 100),2)
ENDIF
IF EMPTY(mVALORICM) .AND. mICM > 0
   mVALORICM := ROUND(mBASEICM * (mICM / 100),2)
ENDIF
IF mSOMANF = "S"
   mVALORTOT := mVALORMER+mVALORIPI+nVALFRE
ELSE
   mVALORTOT := mVALORMER+nVALFRE
ENDIF
IF cTIP = "S"
   @ 14,15 SAY mVALORMER PICT "@E 999,999,999,999.99"        
   @ 18,15 SAY mVALORTOT PICT "@E 999,999,999,999.99"        
ELSE
   //   @ 12,15 SAY mVALORMER PICT "@E 999,999,999,999.99"
   //   @ 17,15 SAY mVALORTOT PICT "@E 999,999,999,999.99"
ENDIF
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFBICM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFBICM

IF xBASEICM # mBASEICM
   IF mICM > 0
      mVALORICM := ROUND(mBASEICM * (mICM / 100),2)
   ELSE
      mVALORICM := 0
   ENDIF
   xBASEICM := mBASEICM
ENDIF
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFBIPI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFBIPI

IF xBASEIPI # mBASEIPI
   IF mIPI > 0
      mVALORIPI := ROUND(mBASEIPI * (mIPI / 100),2)
   ENDIF
   xBASEIPI := mBASEIPI
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFIPI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFIPI()

IF xIPI # mIPI
   IF mIPI > 0
      mVALORIPI := ROUND(mBASEIPI * (mIPI / 100),2)
   ENDIF
   xIPI := mIPI
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFVIPI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFVIPI

IF EMPTY(mIPI) .AND. EMPTY(mVALORIPI)
   mBASEIPI := 0
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NFVICM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NFVICM

IF EMPTY(mICM) .AND. EMPTY(mVALORICM)
   mBASEICM := 0
ENDIF
RETU .T.
