*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aope.prg
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


priv xPEDIDO

MAOPECHK()

PADRAX(0,,0,{"PE","PE01"},"Pedido Fornecedor"+spac(14)+"T MP/Componente",;
 "' '+STR(mPEDIDO,  5)+' '+STR(mFORNECEDO,  8)+' '+mCOGNOME+' '+mTIPPED+' '+mCODIGO","IPE001","IPE001",,;
 {|| PADDEL("PE01",xCHAVE,"PEDIDO","xCHAVE")},{|| MAOPREP()} ;
 ,{|| ULTIMOREG("PE","PEDIDO","mPEDIDO")},"IPE00")
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPREP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPREP


xPEDIDO    := mPEDIDO
xTIPPED    := mTIPPED
xCODIGO    := mCODIGO
xNOME      := mNOME
xNOM2      := mNOM2
xFORNECEDO := mFORNECEDO
xCOGNOME   := mCOGNOME
xUNIDADE   := mUNID
PADRAO(1,1,0,"PE01","Pedido   Codigo     Inicial   Anterior  Saldo",;
 "' '+STR(mPEDIDO,5)+' '+STR(mITEM,2)+' '+mCODIGO+' '+STR(mTOTKGINI,9,2)+' '+STR(mTOTKGANT,9,2)+' '+STR(mTOTKGEST,9,2)+' '+DTOC(mDATAFAT)",;
 "IPEI",,,{|| PE01INC()},{|| PADARR("PE01",str(xPEDIDO,5),"PEDIDO","XPEDIDO")} ;
 ,,{|| MAOPR01()},,,{|| MAOPR02("PE01")},,,,.F.)


//     para wPAD, wpPAD, wcPAD, wARQ, wCAB, wSRO, wACOR, wBTEL, wBGET,;
//          wBINS, wBMON, wBKEY, wBIGU,wBSAY, lPADCRI, bPOSREP,;
//          ePAD3, bDEL, pPAD, lpINS


retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PE01INC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PE01INC


mITEM2  := 0
mPEDIDO := xPEDIDO
ULTIMOITEM("PE01",str(xPEDIDO,5),"PEDIDO","XPEDIDO","ITEM","mITEM",.F.)
ULTIMOITEM("PE01BX",str(xPEDIDO,5),"PEDIDO","XPEDIDO","ITEM","mITEM2",.F.)
if mITEM2 > mITEM
   mITEM := mITEM2
endif
mITEM ++
MDS("Digite o ITEM")
@ 24,20 GET mITEM VALID mITEM > 0 .AND. mITEM < 99        
READCUR()
mCHAVE := STR(xPEDIDO,5)+STR(mITEM,2)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPR01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPR01


mPEDIDO    := xPEDIDO
mTIPPED    := xTIPPED
mCODIGO    := xCODIGO
mNOME      := xNOME
mNOM2      := xNOM2
mTIPOCLI   := "F"
mCLIENTE   := xFORNECEDO
mCOGNOME   := xCOGNOME
mNRNOTAINI := val(str(mPEDIDO,5)+"."+str(mITEM,2))
mUNIDADE   := xUNIDADE
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPR02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPR02(cARQ)


if cARQ <> "PE01" .or. len(cARQ) > 4  //NÆo Processa Baixados
   retu .T.
endif
if !empty(mDATASAI) .and. !empty(mTOTKGANT) .and. !empty(mTOTKGSAI)
   if !empty(mNRNOTASAI)
      mTIPO    := mTIPPED
      mUNRNOTA := mNRNOTASAI
      mUFORNE  := mCLIENTE
      mUQTDE   := mTOTKGSAI
      mUDATA   := mDATASAI
      mTIPO    := padr(mTIPO,1)
      mCODIGO  := padr(mCODIGO,24)
      if VERSEHA("PECRT",mTIPO+mCODIGO+str(mCLIENTE,8))
         REPORVARS("PECRT",mTIPO+mCODIGO+str(mCLIENTE,8))
      else
         NOVOREG("PECRT",mTIPO+mCODIGO+str(mCLIENTE,8))
      endif
   endif
   BAIXAREM("PE01","PE01BX",str(mPEDIDO,5)+str(mITEM,2))
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPE01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPE01


para cARQPE
PADRAO(0,1,0,cARQPE,"Pedido   Codigo     Inicial   Anterior  Saldo",;
 "' '+STR(mPEDIDO,5)+' '+STR(mITEM,2)+' '+mCODIGO+' '+STR(mTOTKGINI,9,2)+' '+STR(mTOTKGANT,9,2)+' '+STR(mTOTKGEST,9,2)+' '+DTOC(mDATAFAT)",;
 "IPEI",,,,,,,,,{|| MAOPR02(cARQPE)})
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPECHK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOPECHK(cFILTER)

MDS("Aguarde Checando Pedidos")
if !USEMULT({{"MW02",1,99},{"PE",1,99},{"PE01",1,99},{"MS03",1,99},{"MB01",1,1},{"PECRT",1,99}})
   retu .F.
endif
dbselectar("MW02")
dbgotop()
while !eof()
   netgrvcam("PRGENT",0)
   dbskip()
enddo
dbselectar("MS03")
dbsetorder(3)   //Codcomp
dbselectar("PE")
IF VALTYPE(cFILTER) = "C"
   SET FILTER TO &FILTER
ENDIF
dbgotop()
while !eof()
   cCHAVE := str(COMPRAS,8)+str(COMITEM,3)
   @ 24,40 SAY PEDIDO         
   mPEDIDO    := PEDIDO
   mCODCOMP   := CODIGO
   mFORNECEDO := FORNECEDO
   mNOME      := NOME
   mNOM2      := NOM2
   lFALTA     := .F.
   dbselectar("MW02")
   dbgotop()
   if !dbseek(Cchave)
      ALERTX("Falta Pedido: "+Cchave+" Programa: "+str(mPEDIDO))
      lFALTA := .T.
   else
      IF BLQITEM = "S"
         ALERTX("Item do Pedido Bloqueado:"+Cchave+" Programa: "+str(mPEDIDO))
         lFALTA := .T.
      ENDIF
      if OBTER("MW01",mPEDIDO,"CONTRATO") = "N"
         ALERTX("Pedido NÆo ‚ Contrato:"+Cchave+" Programa: "+str(mPEDIDO))
         lFALTA := .T.
      else
         netgrvcam("prgent",mPEDIDO)
         mNOME := LEFT(ITENOM,50)
         mNOM2 := SUBSTR(ITENOM,51)
      endif
   endif
   dbselectar("MB01")
   mDDDPCP    := ""
   mTELPCP    := ""
   mRAMPCP    := ""
   mCONPCP    := ""
   mDDDFAXPCP := ""
   mTELFAXPCP := ""
   mEMAILPCP  := ""
   mNOMEFOR   := ""
   dbselectar("MB01")
   dbgotop()
   if dbseek(mFORNECEDO)
      mDDDPCP    := DDDPCP
      mTELPCP    := TELPCP
      mRAMPCP    := RAMPCP
      mCONPCP    := CONPCP
      mDDDFAXPCP := DDDFAXPCP
      mTELFAXPCP := TELFAXPCP
      mEMAILPCP  := EMAILPCP
      mNOMEFOR   := NOME
   ENDIF
   dbselectar("PE")
   netreclock()
   if lFALTA
      field->COMPRAS   := 0
      field->COMITEM   := 0
      field->fornecedo := 0
      field->cognome   := ""
      field->NOME      := ""
      field->NOM2      := ""
   else
      field->NOME := mNOME
      field->NOM2 := mNOM2
   endif
   field->DDDPCP    := mDDDPCP
   field->TELPCP    := mTELPCP
   field->RAMPCP    := mRAMPCP
   field->CONPCP    := mCONPCP
   field->DDDFAXPCP := mDDDFAXPCP
   field->TELFAXPCP := mTELFAXPCP
   field->EMAILPCP  := mEMAILPCP
   field->NOMEFOR   := mNOMEFOR
   dbunlock()
   dbselectar("PE01")
   dbgotop()
   dbseek(str(mPEDIDO,5))
   while mPEDIDO = PEDIDO .and. !eof()
      netreclock()
      if lFALTA
         field->NOME := ""
         field->NOM2 := ""
      else
         field->NOME := mNOME
         field->NOM2 := mNOM2
      endif
      dbunlock()
      dbskip()
   enddo
   dbselectar("MS03")
   dbgotop()
   dbseek(mCODCOMP)
   while ALLTRIM(mCODCOMP) = ALLTRIM(CODCOMP) .AND. !EOF()
      gravacampo("PE","mPEDIDO")
      dbskip()
   enddo
   dbselectar("PE")
   dbskip()
enddo
dbselectar("PE")
dbsetorder(2)   //Tipo Fornecedor Codigo
dbselectar("PECRT")
dbgotop()
while !eof()
   lTEM       := .T.
   mCODIGO    := CODIGO
   mFORNECEDO := UFORNE
   mTIPO      := TIPO
   dbselectar("PE")
   dbgotop()
   IF !DBSEEK(mTIPO+mCODIGO+STR(mFORNECEDO,8))
      lTEM := .F.
   ENDIF
   dbselectar("PECRT")
   IF !lTEM
      DELEREG()
   ENDIF
   dbskip()
enddo
dbcloseall()



