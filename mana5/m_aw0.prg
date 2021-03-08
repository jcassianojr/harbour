*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aw0.prg
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
*+    Function M_AW3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AW3


para ARQWORK
PADRAO(0,1,0,ARQWORK,"Pedido   Itp Ite Entregar Fornecedor"+spac(12)+"Codigo"+spac(7)+"Saldo",;
 "' '+STR(mCOMPED,8)+' '+STR(mITEM,3)+' '+STR(mITEENT,  3)+' '+DTOC(mDATENT)+' '+STR(mCOMFOR,8)+' '+mCOMCOG+' '+mITECOD+' '+STR(mQTDSAL,12,3)",;
 "MAW3")
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AWX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AWX


mPEDIDO := 0
mDATA01 := ZDATA
MDS("Pedido No. e Data")
@ 24,30 get mPEDIDO pict "9999999"        
@ 24,40 get mDATA01                       
if !READCUR()
   retu .F.
endif
M_AWX1(mPEDIDO,mDATA01,ZUSER+": Baixa Manual")
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AWX1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AWX1


para mPEDIDO,mDATA01,mOBS
if valtype(mOBS) # "C"
   mOBS := ""
endif
CRIARVARS("MW01")
CRIARVARS("MW02")
CRIARVARS("MW03")
if !IGUALVARS("MW01",mPEDIDO)
   retu .F.
endif
mCOMDFEC  := mDATA01
mBAIXAOBS := mOBS
if NOVOREG("MW01BX",mPEDIDO)
   BXITEM("MW02","MW02BX",str(mPEDIDO,8),"mPEDIDO","COMPED")
   BXITEM("MW03","MW03BX",str(mPEDIDO,8),"mPEDIDO","COMPED")
   APAGAREG("MW01",mPEDIDO,.F.,.F.)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AW4()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AW4


para ARQWORK,nUSOTIP
ZSETOR := padr(OBTER("MUSER",ENCODE(ZUSER),"SETOR"),7)
do case
   case nUSOTIP = 2 .or. nUSOTIP = 1
      PADRAO(0,1,0,ARQWORK,"No"+spac(7)+"Data     Ue"+spac(6)+"T Codigo"+spac(7)+"Saldo      L C GRU",;
       "' '+STR(mRECCOM,  8)+' '+DTOC(mRECDAT)+' '+mRECUE+' '+mRECTIP+' '+mRECCOD+' '+STR(mRELQTDS,12,2)+' '+mLIRER+' '+mLICER+' '+mRECGRU",;
       "MAW4",,,{|| MAW402()},{|| PADARR(ARQWORK,ZSETOR,"ALLTRIM(RECUE)","ALLTRIM(ZSETOR)",2)},,,,,,,{|| !ALLTRUE(ALERTX("Somente Baixa Permitida"))})
   case nUSOTIP = 0
      PADRAO(0,1,0,ARQWORK,"No"+spac(7)+"Data     Ue"+spac(6)+"T Codigo"+spac(7)+"Saldo      L C GRU",;
       "' '+STR(mRECCOM,  8)+' '+DTOC(mRECDAT)+' '+mRECUE+' '+mRECTIP+' '+mRECCOD+' '+STR(mRELQTDS,12,2)+' '+mLIRER+' '+mLICER+' '+mRECGRU",;
       "MAW4",,,{|| MAW402()},{|| PADARR(ARQWORK,ZSETOR,"ALLTRIM(RECUE)","ALLTRIM(ZSETOR)",3)},,,,,,,{|| !ALLTRUE(ALERTX("Somente Baixa Permitida"))})
   otherwise
      PADRAO(0,1,0,ARQWORK,"No"+spac(7)+"Data     Ue"+spac(6)+"T Codigo"+spac(7)+"Saldo      L C GRU",;
       "' '+STR(mRECCOM,  8)+' '+DTOC(mRECDAT)+' '+mRECUE+' '+mRECTIP+' '+mRECCOD+' '+STR(mRELQTDS,12,2)+' '+mLIRER+' '+mLICER+' '+mRECGRU",;
       "MAW4",,,{|| MAW402()},,,,,,,,{|| !ALLTRUE(ALERTX("Somente Baixa Permitida"))})
endcase
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW402()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW402


mRECCOM := OBTER("MANEMP",ZNUMERO,"RECCOM")
mRECCOM ++
GRAVAMVAR("MANEMP",ZNUMERO,"RECCOM","mRECCOM")
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW401()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW401


local nITEM
do case
   case mRECTIP = "M"
      PEGACAMPO("MU01","mRECCOD",{"PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)","CTACONTB","UNIDADE","APLICACAO","ULTPRC","CCM"},{"mRECNOM","mRECCTA","mRECUND","mRECO01","mRECULT","mRECCCM"})
   case mRECTIP = "B"
      PEGACAMPO("MR01","mRECCOD",{"PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)","CTACONTB","UNIDADE","APLICACAO","ULTPRC","CCM"},{"mRECNOM","mRECCTA","mRECUND","mRECO01","mRECULT","mRECCCM"})
   case mRECTIP = "C"
      PEGACAMPO("MT01","mRECCOD",{"PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)","CTACONTB","UNIDADE","APLICACAO","ULTPRC","CCM"},{"mRECNOM","mRECCTA","mRECUND","mRECO01","mRECULT","mRECCCM"})
   case mRECTIP = "O"
      PEGACAMPO("MW05","mRECCOD",{"PADR(NOME,200)","CTACONTB","UNIDADE","MW05GRU","ESTQSAL","ULTPRC","CCM"},{"mRECNOM","mRECCTA","mRECUND","mRECGRU","mRECESQ","mRECULT","mRECCCM"})
   case mRECTIP = "R"
      PEGACAMPO("MW07","mRECCOD",{"PADR(NOME,200)","CTACONTB","UNIDADE","MW05GRU","ESTQSAL","ULTPRC","CCM"},{"mRECNOM","mRECCTA","mRECUND","mRECGRU","mRECESQ","mRECULT","mRECCCM"})
   case mRECTIP = "I"
      PEGACAMPO("ME04","mRECCOD",{"PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)","ULTPRC"},{"mRECNOM","mRECULT"})
   case mRECTIP = "T"
      PEGACAMPO("MP03","mRECCOD",{"PADR(NOM2,200)","APLICACAO","CCM","ULTPRC"},{"mRECNOM","mRECO01","mRECCCM","mRECULT"})
endcase
mCOMF01 := mCOMF02 := mCOMF03 := 0
mITEP01 := mITEP02 := mITEP03 := 0
mITEU01 := mITEU02 := mITEU03 := ""
mITED01 := mITED02 := mITED03 := ctod(space(8))
if mRECTIP # "X"
   if USEREDE("MW08",1,2)
      nITEM := 1
      dbgotop()
      dbseek(mRECTIP+padr(mRECCOD,24))
      while .T.
         if mRECTIP # ITETIP .or. alltrim(mRECCOD) # alltrim(ITECOD) .or. eof()
            exit
         else
            do case
               case nITEM = 1
                  mCOMF01 := COMFOR
                  mITEP01 := ITEPRC
                  mITEU01 := ITEUNI
                  mITED01 := DATA
               case nITEM = 2
                  mCOMF02 := COMFOR
                  mITEP02 := ITEPRC
                  mITEU02 := ITEUNI
                  mITED02 := DATA
               case nITEM = 3
                  mCOMF03 := COMFOR
                  mITEP03 := ITEPRC
                  mITEU03 := ITEUNI
                  mITED03 := DATA
            endcase
         endif
         dbskip()
         nITEM ++
         if nITEM = 4
            exit
         endif
      enddo
      dbclosearea()
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW403()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW403


local cNORMA
aMAW403 := PEGLAY("MEXPOR1","MAW403")
aMAW413 := PEGLAY("MEXPOR1","MAW413")
CRIARVARS("MW08")
CRIARVARS("MW04")
CRIARVARS("MY04")
CRIARVARS("MW02")
while .T.
   cVAR2  := 0
   cVIDE  := ""
   cOBSFO := space(50)
   cOBSNF := space(50)
   cOBSPR := 0
   cESTQ  := "N"
   MDI(" Ý Baixa Requisi‡Æo")
   @ 06,00 say "Requisi‡Æo :"                                
   @ 07,00 say "Fornecedor :"                                
   @ 08,00 say "Nota Fiscal:"                                
   @ 09,00 say "Pre‡o      :"                                
   @ 10,00 say "Grava Estq :"                                
   @ 06,15 get cVAR2                                         
   @ 07,15 get mNUMMB01                                      
   @ 07,25 get cOBSFO                                        
   @ 08,15 get mNRNOTA                                       
   @ 08,25 get cOBSNF                                        
   @ 09,15 get cOBSPR         pict "999999999.999999"        
   @ 10,15 get cESTQ          valid cESTQ $ "SN"             
   if !READCUR()
      exit
   endif
   if empty(cVAR2)
      exit
   endif
   if MDG("Baixar Requisi‡„o - "+str(cVAR2))
      if IGUALVARS("MW04",cVAR2)
         mOBSFO := cOBSFO
         mOBSNF := cOBSNF
         mOBSPR := cOBSPR
         if NOVOREG("MW04PG",cVAR2)
            APAGAREG("MW04",cVAR2)
            if cESTQ = "S"
               GRAVAVAR2(aMAW403)
               mTIPOENT   := mTIPO2
               mFORNECEDO := mNUMMB01
               ULTIMOREG("MY04","NUMERO","mNUMERO")
               if NOVOREG("MY04",mNUMERO)
                  yCODIGO   := mCODIGO
                  mOLDQTDDE := 0
                  MAK2K05("I","MY04E")
               endif
            endif
            GRAVAVAR2(aMAW413)
            if mITETIP $ "MCOITRB"
               if mITEPRC > 0
                  MAWULTPRC(ESTQARQ(mITETIP,1),mITECOD,{mITEPRC,mITEUNI,ZDATA})
                  if mITETIP = "T"
                     cNORMA := alltrim(OBTER("MP03",mITECOD,"NORMA"))
                     if !empty(cNORMA)
                        MAWULTPRC("ETI",cNORMA,{mITEPRC,mITEUNI,ZDATA})
                     endif
                  endif
                  NOVOREG("MW08",mITETIP+mITECOD+str(mCOMFOR,8)+dtos(mDATA),.F.,.F.)
               endif
            endif
         endif
      endif
   endif
enddo


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW6A()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW6A


aPER   := PEDPER(.T.)
mMESES := aPER[7]
if !aPER[5]
   retu .F.
endif
if !USEREDE("MW06",1,99)
   dbcloseall()
   retu .F.
endif
dbgotop()
while !eof()
   mTIPO   := TIPO
   mCODIGO := alltrim(CODIGO)
   mUSO    := 0
   @ 24,00 say mTIPO+" "+mCODIGO+" "+strzero(recno())         
   while mTIPO = TIPO .and. mCODIGO = trim(CODIGO) .and. !eof()
      CALCPER(aPER,ANO,MES,{|| mUSO := mUSO+USO})
      dbskip()
   enddo
   if mUSO > 0
      mUSO /= mMESES
      if mTIPO $ "MCOTR"
         GRAVAMVAR(ESTQARQ(mTIPO,1),mCODIGO,"CCM","mUSO",,.F.)
      endif
   endif
   dbselectar("MW06")
enddo
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW6()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW6


local aRETU
aRETU   := PEGMES({"Y4"})
cARQ    := aRETU[5,1]
mMES    := aRETU[1]
mANO    := aRETU[2]
if MDG("Acumular Media Consumiveis")
   if !USEREDE(cARQ,1,0)
      retu .F.
   endif
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","TIPO2+CODIGO")
   ordSetFocus("temp")
   if !USEREDE("MW06",1,99)
      dbcloseall()
      retu .F.
   endif
   dbselectar(cARQ)
   dbgotop()
   while !eof()
      mTIPO   := TIPO2
      mCODIGO := CODIGO
      mUSO    := 0
      @ 24,20 say mTIPO+" "+mCODIGO         
      while mTIPO = TIPO2 .and. mCODIGO = CODIGO .and. !eof()
         @ 24,60 say recno()         
         if TIPO1 = "S" .and. NAOMEDIO <> "S"
            mUSO += QTDE
         endif
         dbskip()
      enddo
      MAW601()
      dbselectar(cARQ)
   enddo
   dbcloseall()
endif
if MDG("Acumular Media Materia Prima CRM")
   MAW602("M")
endif
if MDG("Acumular Media Componentes CRM")
   MAW602("C")
endif
if MDG("Acumular Media Terceiros/Tratamentos CRM")
   MAW602("T")
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW602()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW602(cTIPO)


if !USEREDE("CRM",1,0)
   retu .F.
endif
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","TIPOE+CBUSCA")
ordSetFocus("temp")


if !USEREDE("MW06",1,99)
   dbcloseall()
   retu .F.
endif
mTIPO := cTIPO  //Somente Materia Prima
dbselectar("CRM")
dbgotop()
dbseek(cTIPO)
while TIPOE = cTIPO .and. !eof()
   mCODIGO := alltrim(CBUSCA)
   mUSO    := 0
   @ 24,20 say mTIPO+" "+mCODIGO         
   while mCODIGO = alltrim(CBUSCA) .and. !eof()
      @ 24,60 say recno()         
      if month(DATA) = mMES .and. year(DATA) = mANO
         mUSO += QTDE
      endif
      dbskip()
   enddo
   MAW601()
   dbselectar("CRM")
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW601()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW601


if mUSO > 0
   dbselectar("MW06")
   dbgotop()
   if dbseek(mTIPO+padr(mCODIGO,15)+str(mANO,4)+str(mMES,2))
      netgrvcam("USO",mUSO)
   else
      NOVOOPA()
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW7()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW7


mOS     := 0
mITEM   := 0
wQTDE   := 0
mNUMERO := 0
mNRNOTA := 0
mDATA   := ZDATA
MDS("Pedido Item Qtde")
@ 24,30 get mOS   pict "9999999"        
@ 24,40 get mITEM pict "999"            
if !READCUR()
   retu .F.
endif
wQTDE := OBTER("MW02",str(mOS,8)+str(mITEM,3),"ITESAL")
@ 24,45 get wQTDE pict "99999.999"        
if !READCUR()
   retu .F.
endif
if MDG("Baixar Residuo")
   MAY04("R")
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW8()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW8(aARQ)


if valtype(aARQ) # "A"
   aRETU := PERFEC({"MW01BX","MW02BX","MY04"},{"W1","W2","Y4"},{"XXXX","XXXX","XXXX"},{"PADRAO","PADRAO","PADRAO"})
   cARQ  := aRETU[5,1]
   cARQ2 := aRETU[5,2]
   cREQ  := aRETU[5,3]
else
   cARQ  := aARQ[1]
   cARQ2 := aARQ[2]
   cREQ  := aARQ[3]
endif
if !USEMULT({{cARQ,1,99},{cARQ2,1,99},{cREQ,1,99}})
   retu
endif
dbselectar(cREQ)
dbgotop()
while !eof()
   if !empty(os) .and. !empty(item)
      aDAD := {str(OS,8)+str(ITEM,3),NUMERO,NRNOTA,DATA,OS}
      dbselectar(cARQ2)
      dbgotop()
      if dbseek(aDAD[1])
         netreclock()
         if empty(RECNUM) .or. RECNUM <> aDAD[2]
            field->RECNUM := aDAD[2]
         endif
         if empty(RECNOT) .or. RECNOT <> aDAD[3]
            field->RECNOT := aDAD[3]
         endif
         if empty(REQDAT) .or. REQDAT <> aDAD[4]
            field->REQDAT := aDAD[4]
         endif
         dbunlock()
      endif
      dbselectar(cARQ)
      dbgotop()
      if dbseek(aDAD[5])
         if empty(COMDFEC)
            netgrvcam("COMDFEC",aDAD[4])
         endif
      endif
   endif
   dbselectar(cREQ)
   dbskip()
   @ 24,00 say NUMERO         
enddo
retu .t.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AWREA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AWREA


MDI("Calcular Reajuste")
cTIPO     := " "
cGRUPO    := "   "
mFORINI   := 0
mFORFIM   := 0
mVIGENCIA := ZDATA
mVERIFICA := ZDATA+365
mPERC     := 000.0000
@ 10,10 say "Tipo:"                    
@ 10,30 say "Grupo:"                   
@ 12,10 say "Do Fornecedor:"           
@ 12,30 say "Ao Fornecedor:"           
@ 14,10 say "Vigencia:"                
@ 16,10 say "Verificar Preco:"         
@ 18,10 say "Percentual:"              
@ 10,20 get cTIPO                      
@ 10,40 get cGRUPO                     
@ 12,20 get mFORINI                    
@ 12,40 get mFORFIM                    
@ 14,20 get mVIGENCIA                  
@ 16,20 get mVERIFICA                  
@ 18,20 get mPERC                      
if !READCUR()
   retu .F.
endif
if empty(cGRUPO)
   ALERTX("Grupo NÆo Preenchido")
   retu .F.
endif
cARQ    := ESTQARQ(cTIPO,1)
mINDICE := 1+(mPERC / 100)

if !USEMULT({{"MW01",1,1},{"MW02",1,1},{cARQ,1,1}})
   retu .F.
endif
dbselectar("MW02")
dbgotop()
while !eof()
   lAUMENTA := .F.
   if ITETIP = cTIPO
      mPEDIDO := COMPED
      cCODIGO := alltrim(ITECOD)
      dbselectar("MW01")
      dbgotop()
      if dbseek(mPEDIDO)
         if COMFOR >= mFORINI .and. COMFOR <= mFORFIM
            dbselectar(cARQ)
            dbgotop()
            if dbseek(cCODIGO)
               if cGRUPO = CODMW
                  lAUMENTA := .T.
               endif
            endif
         endif
      endif
   endif
   dbselectar("MW02")
   if lAUMENTA
      netreclock()
      field->ITEPRC   := round(ITEPRC * mINDICE,5)
      field->VIGENCIA := mVIGENCIA
      field->VERIFICA := mVERIFICA
      dbunlock()
   endif
   dbskip()
enddo
dbcloseall()
if MDG("Checar Ultimos Pre‡os")
   MW08CHK()
endif


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MW08CHK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MW08CHK


MDI("Checando Pedidos/Ultimos Pre‡os")
if !USEMULT({{"MW02",1,99},{"MW01",1,99},{"MW08",1,99}})
   retu .F.
endif
dbselectar("MW08")
INITVARS()
CLRVARS()

dbgotop()
while !eof()
   @ 24,00 say recno()         
   zei_fort()
   netgrvcam("PEDATIVO","N")
   dbskip()
enddo
dbselectar("MW02")
INITVARS()
CLRVARS()

dbgotop()
while !eof()
   if ITETIP <> "X"
      if empty(CODMW) .and. ITETIP = "M"
         netreclock()
         field->CODMW := OBTER("MU01",ITECOD,"CODMW",,,,,,"")
         dbunlock()
      endif
      dbselectar("MW02")
      EQUVARS()
      dbselectar("MW01")
      dbgotop()
      if dbseek(mCOMPED)
         mCOMFOR := COMFOR
         MW08CHK01(.F.)
      endif
   endif
   dbselectar("MW02")
   dbskip()
   @ 24,00 say recno()         
   @ 24,40 say mCOMPED         
enddo
dbcloseall()
retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MW08CHK01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MW08CHK01(lOPEN,dDATACHK)


if valtype(lOPEN) # "L"
   lOPEN := .T.
endif
if mITETIP $ "MCOITRB"
   if empty(mVIGENCIA)
      mVIGENCIA := ZDATA
   endif
   if mITEPRC > 0
      MAWULTPRC(ESTQARQ(mITETIP,1),mITECOD,{mITEPRC,mITEUNI,mVIGENCIA})
   endif
   if !empty(mCOMFOR) .and. !empty(mITEPRC)
      mDATA := ZDATA
      if empty(mVIGENCIA)
         mDATAINI := mDATA
      else
         mDATAINI := mVIGENCIA
      endif
      lMW08 := .T.
      if lOPEN
         while !USEREDE("MW08",1,99)
         enddo
      else
         dbselectar("MW08")
      endif
      dbgotop()
      dbseek(mITETIP+padr(mITECOD,24)+str(mCOMFOR,8))
      while ITETIP = mITETIP .and. alltrim(ITECOD) = alltrim(mITECOD) .and. COMFOR = mCOMFOR .and. !eof()
         if ITEPRC = mITEPRC
            lMW08 := .F.
            if DATAINI <> mVIGENCIA .and. mITETIP $ "MCT"
               GRAVACAMPO({"PEDATIVO","CODMW","DATA","COMPED","ITEM","DATAINI"},{"'S'","mCODMW","mDATA","mCOMPED","mITEM","mVIGENCIA"})
            else
               GRAVACAMPO({"PEDATIVO","CODMW","DATA","COMPED","ITEM"},{"'S'","mCODMW","mDATA","mCOMPED","mITEM"})
            endif
         endif
         dbskip()
      enddo
      if lMW08  //Grava se Nao tiver o Mesmo Preco
         mPEDATIVO := "S"
         netrecapp()
         REPLVARS()
      endif
      if lOPEN
         dbclosearea()
      endif
   endif
endif
if mITETIP = "T"
   cNORMA := alltrim(OBTER("MP03",mITECOD,"NORMA"))
   if !empty(cNORMA)
      MAWULTPRC("ETI",cNORMA,{mITEPRC,mITEUNI,mVIGENCIA})
   endif
endif
retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AWRET()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AWRET


MDI("Retornar Pedido Baixado")
mPED  := 0
mITE  := 0
cARQ  := "MW01BX"
cARQ2 := "MW02BX"
MDS("Pedido")
@ 24,30 get mPED         
//@ 24,40 GET mITE
READCUR()
if MDG("Mes Fechado")
   cVAR  := MESANO()
   cARQ  := "W1"+cVAR
   cARQ2 := "W2"+cVAR
endif
if !USEMULT({{"MW01",1,99},{"MW02",1,99},{cARQ,1,99},{cARQ2,1,99}})
   retu .F.
endif
dbselectar("MW01")
INITVARS()
CLRVARS()
dbselectar("MW02")
INITVARS()
CLRVARS()
dbselectar(cARQ2)
dbgotop()
dbseek(str(mPED,8))
while COMPED = mPED .and. !eof()
   EQUVARS()
   //   mITEENT := 0 nao alterar dava erro
   //   mITERES := 0 mantinha o pedido em aberto
   //   se necessario sera feito via ajuste mawretqtd()
   mITESAL := mITEQTD
   NOVOOPA("MW02",str(mPED,8)+str(mITE,3))
   dbselectar(cARQ2)
   netrecdel()
   dbskip()
enddo
dbselectar(cARQ)
dbgotop()
if dbseek(mPED)
   EQUVARS()
   mTRAVAPED := ""
   NOVOOPA("MW01",mPED)
   dbselectar(cARQ)
   netrecdel()
endif
dbcloseall()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAWULT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAWULT


if MDG("Checar Componetes")
   MAWULT01("C")
endif
if MDG("Checar Tratamentos")
   MAWULT01("T")
endif
if MDG("Checar Consumiveis")
   MAWULT01("O")
endif
if MDG("Checar Itens Manuten‡Æo")
   MAWULT01("R")
endif
if MDG("Checar Materia Prima")
   MAWULT01("M")
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAWULT01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAWULT01


para cTIPO
cARQ := ESTQARQ(cTIPO,1)
if !USEMULT({{cARQ,1,1},{"MW08",1,2}})
   retu .F.
endif
dbselectar(cARQ)
dbgotop()
while !eof()
   @ 24,00 say CODIGO         
   mCODIGO := alltrim(CODIGO)
   mCODMW  := CODMW
   aVAL    := {0,"",ctod(space(8))}
   dbselectar("MW08")
   dbgotop()
   dbseek(cTIPO+mCODIGO)
   if cTIPO = ITETIP .and. alltrim(ITECOD) == mCODIGO
      aVAL := {ITEPRC,ITEUNI,DATA}
      netgrvcam("CODMW",mCODMW)
   endif
   dbselectar(cARQ)
   if aVAL[1] > 0
      netreclock()
      if aVAL[3] >= ULTDATA
         field->ULTPRC  := aVAL[1]
         field->ULTUND  := aVAL[2]
         field->ULTDATA := aVAL[3]
      endif
      dbunlock()
   endif
   dbskip()
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAWULTPRC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAWULTPRC(cARQ,eBUSCA,aDAD)


eBUSCA := alltrim(eBUSCA)
if !USEREDE(cARQ,1,99)
   retu .F.
endif
dbgotop()
if dbseek(eBUSCA)
   if aDAD[3] >= ULTDATA
      netreclock()
      field->ULTPRC  := aDAD[1]
      field->ULTUND  := aDAD[2]
      field->ULTDATA := aDAD[3]
      dbunlock()
   endif
endif
dbclosearea()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAWRETQTD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAWRETQTD

//aMAW403 := PEGLAY( "MEXPOR1", "MAW403" )
//aMAW413 := PEGLAY( "MEXPOR1", "MAW413" )
//CRIARVARS( "MW08" )
//CRIARVARS( "MW04" )
CRIARVARS("MY04")
CRIARVARS("MW02")
MDI(" Ý Ajuste Quantidades Entregues Pedido")
cARQ1 := "MW01"
cARQ2 := "MW02"
if MDG("Baixados")
   cARQ1 := "MW01BX"
   cARQ2 := "MW02BX"
   if MDG("Mes Fechado")
      cVAR  := MESANO()
      cARQ1 := "W1"+cVAR
      cARQ2 := "W2"+cVAR
   endif
endif
mOS   := 0
mITEM := 0
@ 22,00 say "Pedido Item Qtde"                       
@ 22,30 get mOS                pict "9999999"        
@ 22,40 get mITEM              pict "999"            
if !READCUR()
   retu .F.
endif
if IGUALVARS(cARQ2,str(mOS,8)+str(mITEM,3))
   xITEENT := mITEENT
   @ 23,00 SAY "Qtde"             
   @ 23,20 SAY "Entregue"         
   @ 23,40 SAY "Residuo"          
   @ 23,60 SAY "Saldo"            
   @ 24,00 SAY mITEQTD            
   @ 24,60 SAY mITESAL            
   @ 24,20 GET mITEENT            
   @ 24,40 GET mITERES            
   IF READCUR()
      GRAVAMVAR(CARQ2,str(mOS,8)+str(mITEM,3),{"ITEENT","ITERES","ITESAL"},{"mITEENT","mITERES","mITEQTD-(mITEENT+mITERES)"})
      IF xITEENT <> mITEENT
         mTIPO3   := "AJU"
         mDATA    := ZDATA
         mTIPO2   := mITETIP
         mTIPOENT := mITETIP
         mCODIGO  := mITECOD
         mUNID    := mITEUNI
         mOS      := mCOMPED
         //mITEM=mITEM
         mNRNOTA    := mRECNOT
         mREQINT    := mRECNUM
         mPRCMW02   := mITEPRC
         mCODDEP    := mITECTA
         mTECNICO   := ZIDFOLHA
         mFORNECEDO := OBTER(cARQ1,mCOMPED,"COMFOR")
         mNUMMB01   := mFORNECEDO
         mOBS       := "Ajuste qtde entregue Pedido"
         ULTIMOREG("MY04","NUMERO","mNUMERO")
         mQTDE     := xITEENT - mITEENT
         yCODIGO   := mCODIGO
         mOLDQTDDE := 0
         IF mQTDE > 0   //tirar entrada
            mTIPO1 := "S"
            MAK2K05("E","MY04E")  //estoque entrada
         ELSE
            mTIPO1 := "E"   //incluir entrada
            mQTDE  := ABS(mQTDE)
            MAK2K05("I","MY04E")  //estoque entrada
         ENDIF
         NOVOREG("MY04",mNUMERO)
      ENDIF
   ENDIF
ENDIF


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAWMUDFOR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAWMUDFOR

nORI := 0
nDES := 0
MDI("Ý Trocar No Fornecedor")
MDS("Origem Destino")
@ 24,20 GET nORI PICT "99999"        
@ 24,30 GET nDES PICT "99999"        
IF !READCUR()
   RETU .F.
ENDIF
IF nORI = 0 .OR. nDES = 0
   ALERTX("Necessario Preencher N§ Fornecedor Origem/Destino")
   RETU .F.
ENDIF
IF !MDG("Mudar "+str(nORI)+" para "+str(nDES))
   RETU .F.
ENDIF
IF !MDG("Realmente Mudar "+str(nORI)+" para "+str(nDES))
   RETU .F.
ENDIF
IF USEREDE("MW01",0,99)
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEVAL({|| netgrvcam("COMFOR",nDES)},{|| COMFOR = nORI},{|| zei_fort(nLASTREC,,,1)})
   DBCLOSEALL()
ENDIF




