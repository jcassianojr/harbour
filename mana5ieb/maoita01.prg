//Modo de Trabalho no V¡deo
MDI(" Ý Atualiza‡„o de Pedidos")

IF ! MDG("Atualizar Pedidos")
   RETU .F.
ENDIF
IF MDG("Apagar Pedidos Em Branco")
   MAOITA02(1)
   MDI(" Ý Atualiza‡„o de Pedidos")
ENDIF

lDATA:=MDG("Corre‡ao de Datas de Pre‡os")
//lPEDCLI:=MDG("Atualizar Pedido de Cliente")

IF ! USEMULT({{"MO01",1,99},{"MD03",1,1},{"MO02",1,99},{"MA01",1,1},;
   {"MD05",1,1},{"MS02",1,5},{"MS01",1,2},{"MRMS",1,1},{"OSCRT",1,99}})
   RETU
ENDIF

DBSELECTAR("OSCRT")
DBSETORDER(2)


DBSELECTAR("MO02")
DBGOTOP()
WHILE ! EOF()
    @ 04,00 SAY PEDIDO
    @ 04,10 SAY CODIGO
    @ 04,35 SAY ENTREGA
    @ 04,45 SAY QTDESAL
   //Ajustando Itens do Pedido pelo Codigo da Pe‡a
   IF QTDESAL<>0.00 .AND. TIPOSERV<>"2"
      //Altera‡„o dos Dados.
      mICMS     :=0.00
      mFORNECEDO:=FORNECEDO
      mLISTA    :=LISTA
      mCODIGO   :=CODIGO
      mUF       :="  "
      mDATABASE :=DATABASE
      mINDICE   :=INDICE
      mPEDIDO   :=PEDIDO
      mCODMR01  :=""
      mPCEMB    :=0


      DBSELECTAR("MA01")
      DBGOTOP()
      IF DBSEEK(mFORNECEDO)
         mUF:=ESTADO
         IF EMPTY(mLISTA)
            mLISTA:=MO02LISTA
          ENDIF
      ENDIF

      DBSELECTAR("MD05")
      DBGOTOP()
      IF DBSEEK(mUF)
         mICMS:=ALIQUOTA
      ENDIF

      DBSELECTAR("MRMS")
      DBGOTOP()
      IF DBSEEK(mCODIGO+STR(mFORNECEDO,8))
         mCODMR01:=CODMR01
         mPCEMB  :=PCEMB
      ELSE
         DBGOTOP()
         IF DBSEEK(mCODIGO+STR(0,8))
            mCODMR01:=CODMR01
            mPCEMB  :=PCEMB
         ENDIF
      ENDIF


      Munid:=""
      mvalor:=0
      mpesouni:=0
      mCODIPI:=""
      DBSELECTAR("MS01")
      DBGOTOP()
      IF DBSEEK(mCODIGO)
         mUNID     := UNID
         mNOME     := NOME
         mCODIPI   := CODIPI
         mPESOUNI  := PESOUNI
      ENDIF

      IF lDATA
         aPRC:=MS02PRC(mCODIGO,mLISTA,.F.,"mUNID","mCODIPI")
         IF EMPTY(mINDICE)
            mVALOR:=aPRC[1]
         ELSE
            mVALIND:=aPRC[1]
         ENDIF
         mDATABASE :=aPRC[3]
      ELSE
          DBSELECTAR("MS02")
          DBGOTOP()
          IF DBSEEK(mCODIGO+STR(mLISTA,5)+DTOS(mDATABASE))
             IF EMPTY(mINDICE)
                mVALOR:=VALOR
             ELSE
                mVALIND:=VALOR
             ENDIF
             IF ! EMPTY(UNIDE)
                mUNID    :=UNIDE
             ENDIF
          ENDIF
      ENDIF


      DBSELECTAR("MO02")
      netreclock()
      FIELD -> UNID     := mUNID
      IF EMPTY(mINDICE)
         FIELD -> VALOR    := mVALOR
      ELSE
         FIELD -> VALIND   := mVALIND
      ENDIF
      FIELD -> DATABASE := mDATABASE
      IF UNID="HR"
         mHORAPED:=HORAPED
         mHORAENT:=HORAENT
         xVALMER:=(mHORAPED-mHORAENT)*mVALOR
         FIELD -> VALORMER := xVALMER
      ELSE
         mQTDEPED:=QTDEPED
         mQTDEENT:=QTDEENT
         xVALMER:=(mQTDEPED-mQTDEENT)*mVALOR
         FIELD -> VALORMER := xVALMER
      ENDIF

      FIELD -> PESOUNI := mPESOUNI
      FIELD -> CODIPI  := mCODIPI
      mVALORMER:=VALORMER
      mICMIPI:=mICMRED:=0.00

      DBSELECTAR("MD03")
      DBGOTOP()
      IF DBSEEK(mCODIPI)
         mIPI     := ALIQUOTA
         mCLASSIPI:= CLASSIFIC
         mICMRED  := ALIQUOTAR
         mICMIPI  := ALIQUOTAI
      ENDIF

      DBSELECTAR("MO02")
      FIELD -> IPI      := mIPI
      FIELD -> CLASSIPI := mCLASSIPI
      mVALORIPI:=ROUND((VALORMER*(mIPI/100)),2)
      mVALORTOT:=VALORMER+mVALORIPI
      IF CONSUMO="S"
         mBASEICM := mVALORMER+mVALORIPI
      ELSE
         mBASEICM := mVALORMER
      ENDIF
      IF mICMIPI<>0.00
         mICM:=mICMIPI
      ELSE
         mICM:=mICMS
      ENDIF
      IF mICMRED<>0.00
         mBASEICM:=(mBASEICM*(mICMRED/100))
      ENDIF
      mVALORICM := (mBASEICM*(mICM/100))
      FIELD -> VALORIPI := mVALORIPI
      FIELD -> VALORTOT := mVALORTOT
      FIELD -> VALORICM := mVALORICM
      FIELD -> ICM      := mICM
      FIELD -> BASEICM  := mBASEICM

      //Embalagem
      IF ! EMPTY(mCODMR01)
         FIELD -> CODMR01  := mCODMR01
         FIELD -> PCEMB    := mPCEMB
         IF mPCEMB>0
            IF ! EMPTY(QTDEPRE)
               FIELD->PCEMBQ  := CEILING(QTDEPRE/PCEMB)
            ELSE
               FIELD->PCEMBQ  := CEILING(QTDESAL/PCEMB)
            ENDIF
         ENDIF
      ENDIF

      mPEDCLINEW:=""
      mPEDITENEW:=0
      DBSELECTAR("OSCRT")
      DBGOTOP()
      IF DBSEEK(STR(mFORNECEDO,8)+mCODIGO)
         mPEDCLINEW:=ALLTRIM(PEDIDOCLI)
         mPEDITENEW:=PEDCLIITE
      ENDIF

      DBSELECTAR("MO01")
      DBGOTOP()
      IF DBSEEK(mPEDIDO)
         netreclock()
         FIELD -> ICM      := mICM
         FIELD -> TOTBICM  := mBASEICM
         FIELD -> TOTICM   := mVALORICM
         FIELD -> TOTIPI   := mVALORIPI
         FIELD -> TOTMER   := mVALORMER
         FIELD -> TOTNF    := mVALORTOT
         mPEDCLIOLD:=ALLTRIM(PEDIDOCLI)
         IF mPEDCLINEW<>mPEDCLIOLD.and.! empty(mPEDCLINEW)
//            IF lPEDCLI
            IF MDG("Pedido Cliente:"+mPEDCLIOLD+"->"+mPEDCLINEW)
               FIELD->PEDIDOCLI:=mPEDCLINEW
               FIELD->PEDCLIITE:=mPEDITENEW
            ENDIF
//            ENDIF
         ENDIF
         DBUNLOCK()
      ENDIF
      DBSELECTAR("MO02")
      DBUNLOCK()
   ENDIF
   DBSELECTAR("MO02")
   DBSKIP()
ENDDO
dbselectar("MO02")
dbsetorder(5)
dbgotop()
while ! eof()
   Mfornecedo:=fornecedo
   mCODIGO:=codigo
   mENTREGA:=entrega
   mHORAPRG:=horaprg
   mpedido:=pedido    
   dbskip()
   if ! eof()
      if Mfornecedo=fornecedo.and.mCODIGO=codigo.and.ENTREGA=entrega.and.mHORAPRG=horaprg.and.mpedido=pedido    
         ALERTX("Os Mesma Data Entrega" + str(mpedido)+"="+str(pedido))
      endif   
   endif
enddo
DBCLOSEALL()
RETU


FUNC MS02PRC(cCODIGO,cLISTA,lOPEN,eUNID,eCOID,ePRECO,lMES)
LOCAL aRETU:={0,"  ",CTOD(SPACE(8)),"  "} //Valor,Unidade,DataBase,CODIPI
LOCAL cDBF:=ALIAS()
cCODIGO:=PADR(cCODIGO,24)
IF VALTYPE(lMES)#"L"
   lMES:=.T.
ENDIF
IF lOPEN
   WHILE ! USEREDE("MS02",1,5)
   ENDDO
ENDIF
DBSELECTAR("MS02")
DBGOTOP()
DBSEEK(cCODIGO+STR(cLISTA,5))
WHILE cCODIGO=CODIGO.AND.cLISTA=FORNECEDO.AND.! EOF()
   IF ATUAL#"N"
      aRETU[1]:=VALOR
      aRETU[3]:=DATA
      IF VALTYPE(ePRECO)="C"
         &ePRECO.:=VALOR
      ENDIF
      IF ! EMPTY(UNIDE)
         aRETU[2]:=UNIDE
         IF VALTYPE(eUNID)="C"
            &eUNID.:=UNIDE
         ENDIF
      ENDIF
      IF ! EMPTY(COIDE)
         aRETU[4]:=COIDE
         IF VALTYPE(eCOID)="C"
            &eCOID.:=COIDE
         ENDIF
      ENDIF
   ENDIF
   DBSKIP()
ENDDO
IF aRETU[1]=0.AND.lMES
   ALERTX("Sem Lista de Preco "+strval(cCODIGO)+":"+STRVAL(cLISTA))
   EMAILINT("MOC00004","Sem Lista de Preco "+strval(cCODIGO)+":"+STRVAL(cLISTA))
ENDIF
IF lOPEN
   DBCLOSEAREA()
ENDIF
IF ! EMPTY(cDBF)
   SELE &cDBF.
ENDIF
RETU aRETU
