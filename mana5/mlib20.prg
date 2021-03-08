*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib20.prg
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
*+    Function ENDCID()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ENDCID(cESTADO,cCIDADE,eENDCID,eENDCEP,eENDNUM)

LOCAL nCORSIT
cARQCEP := space(8)
cENDCID := &eENDCID.
cEND    := &eENDCID.
cCEP    := &eENDCEP.
cNUM    := &eENDNUM.
cCIDADE := upper(TIRACE(cCIDADE))
nCORSIT := OBTER("MD10",cESTADO+cCIDADE,"CORSIT")
IF nCORSIT = 1
   cARQCEP := "C"+STRZERO(OBTER("MD10",cESTADO+cCIDADE,"CEPNUSEQ"),6)
ENDIF
if empty(cARQCEP)
   retu .T.
endif
if empty(cENDCID)
   ENDCIDP(cARQCEP)
   &eENDCID. := cEND
   &eENDCEP. := cCEP
else
   if !CHECKCEP(cARQCEP,cEND,cNUM)
      ENDCIDP(cARQCEP)
      &eENDCID. := cEND
      &eENDCEP. := cCEP
   else
      &eENDCEP. := cCEP
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ENDCIDP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ENDCIDP(cARQ)


local xTELA := savescreen(00,00,24,79)
cCOR := "W/N,N/W,N,N,W/N"
priv GETLIST := {}
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
priv PCK     := .F.
priv mCHAVE
priv mRUA    := space(49)
priv mCEP    := space(8)
priv mLADO   := " "
priv mNINI   := 0
priv mNFIM   := 0
PRIV mWCHA   := "mRUA"
PRIV mCHA    := "RUA"

if !CONFARQ(cARQCEP,"RUA"+space(40)+"CEP     L NoIni NoFin")
   retu .F.
endif
if !CONFIND(cARQCEP)
   retu .F.
endif
METBRO(cARQ,{{"RUA","mRUA"}},{cCOR,cCOR,cCOR,cCOR,cCOR},;
 {|| RUA+' '+CEP},{|| ALLTRUE()},;
 {|| ALLTRUE()},,,3,,,{|| eENDCID()},cEND)
restscreen(00,00,24,79,xTELA)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function eENDCID()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func eENDCID


cEND := RUA
cCEP := CEP
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKCEP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKCEP(cARQ,cEND,cNUM)


local cLADO
local nNUM
local lRETU := .F.
if !USEREDE(cARQ,1,1)
   retu .F.
endif
dbgotop()
IF dbseek(cEND)
   cCEP := CEP
endif
dbclosearea()
retu lRETU

