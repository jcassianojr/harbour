MDI(" Ý Ajustar Lan‡amentos DIPI NF Vendas")

nREF:=2 //Tipo 1 Nf Entrada 2 Nf Saida

aRETU:=PEGMES({"M1","M2","M6"},.T.,{"MM01","MM02","MM06"})
nMES:=aRETU[1]
nANO:=aRETU[2]
ARQWORK1=aRETU[5][1]
ARQWORK2=aRETU[5][2]
ARQWORK4=aRETU[5][3]



dCANCEL:=CTOD("01/"+STRZERO(nMES,2)+"/"+STRZERO(nANO,4))
CRIARVARS("MM01")
CRIARVARS("MM02")
CRIARVARS("MM06")

MDS("Checando")
IF ! USEMULT({{ARQWORK1,1,99},{ARQWORK2,1,1},{ARQWORK4,1,99},{"MD04",1,2}})
   RETU .F.
ENDIF

DBSELECTAR(ARQWORK1)
DBGOTOP()
WHILE ! EOF()
   @ 24,40 SAY NUMERO
   IF EMPTY(ORDEM).AND.ALLTRIM(ESPECIE)#"NFE"
      NETGRVCAM("ORDEM",NUMERO)
      EQUVARS()
      xNUMERO   :=mNUMERO
      xDATAREF  :=mDATA
      mDATAREF  :=mDATA
      xDATA     :=mDATA
      xTIPOFOR  :=mTIPOCLI
      xFORNECEDO:=mFORNECEDO
      xCOGNOME  :=mCOGNOME
      mOBS      :=""
      IF ESPECIE="NFC"
         mOBS:="Nota Fiscal Complementar"
      ENDIF
      m_ADIC(2,.F.,.T.)
      MDT01(.T.)
   ENDIF
   DBSELECTAR(ARQWORK1)
   DBSKIP()
ENDDO
DBCLOSEALL()

xLOTE:=1
xDATA:=ZDATA
nREFNUM:=0
MDS("Ajustando Lotes")
IF ! USEMULT({{ARQWORK1,1,1},{ARQWORK4,1,99}})
   RETU .F.
ENDIF
dbselectar(ARQWORK4)
CLRVARS()
DBGOTOP()
WHILE ! EOF()
   IF MONTH(DATAREF)=nMES.AND.YEAR(DATAREF)=nANO
      lCANCELA:=.F.
      IF nREFNUM>0
         IF nREFNUM+1<>NUMERO
            lCANCELA:=.T.
         ENDIF
         IF (nREFNUM+1)>=9700.AND.(nREFNUM+1)<=10000 //Nota Fiscal Saida loop temporario
            lCANCELA:=.F.
         ENDIF
      ENDIF
      IF lCANCELA
         nREG:=RECNO()
         FOR X=nREFNUM+1 TO NUMERO-1
             mORDEM  :=X
             mNUMERO :=X
             mITEM   :=1
             mLOTE   :=xLOTE
             mDCANCEL:=dCANCEL
             DBSELECTAR(ARQWORK1)
             DBGOTOP()
             DBSEEK(mNUMERO)
             lTEM:=FOUND()
             DBSELECTAR(ARQWORK4)
             IF ! lTEM
                DBGOTOP()
                IF ! DBSEEK(STR(mORDEM,8)+STR(mNUMERO,6)+STR(mITEM,2))
                   mOBS    :="Nota Fiscal Cancelada"
                   NOVOOPA(,.F.,.T.)
                ELSE
                   IF LOTE<>xLOTE
                      NETGRVCAM("LOTE",xLOTE)
                   ENDIF
                ENDIF
                xLOTE++
             ENDIF
         NEXT X
         DBGOTO(nREG)
      ENDIF
      @ 24,40 SAY NUMERO
      xORDEM  :=ORDEM
      xDIPI   :=DIPI
      xDCFONEW  :=DCFONEW
      xCHKIPI :=CHKIPI
      xICM    :=DICM
      WHILE xORDEM=ORDEM.AND.xICM=DICM.AND.xDIPI=DIPI.AND.xDCFONEW=DCFONEW.AND.xCHKIPI=CHKIPI.AND.! EOF()
         NETGRVCAM("LOTE",xLOTE)
         nREFNUM:=NUMERO
         DBSKIP()
      ENDDO
      xLOTE++
      IF ! EMPTY(DATAREF) //Verifica se n„o ‚ Cancelada
         xDATA:=DATAREF
      ENDIF
   ELSE
      nREFNUM:=NUMERO
      DBSKIP()
   ENDIF
ENDDO
DBCLOSEALL()

GRAVAMVAR("FI_MES",STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2),{"FISEQS","FILANS"},{"XLOTE","XDATA"})


FUNC MDT01(lOPEN)
IF mCFONEWB="5902".OR.mCFONEWB="5925".OR.mCFONEWB="6902".OR.mCFONEWB="6925"
   // Limpando vari veis no momento de inclus„o de dados.
   mITEM++         //Adcionando um item 14/10/97
   mDBASEICM  := 0.00
   mDICM      := 00
   mDVALICM   := 0.00
   mOUTRAICM  := 0.00
   mDBASEIPI  := 0.00
   mDIPI      := 00
   mDVALIPI   := 0.00
   mOUTRAIPI  := 0.00
   mDCLASSIPI := SPACE(15)
   mUNIDADE   := SPACE(2)
   mQUANT     := 0.000
   mDCFONEW   := mCFONEWB
   mDEV       :=0
   mDIPAM:=""
   mDOPER:=""
   DBSELECTAR("MD04")
   DBGOTOP()
   IF DBSEEK(mDCFONEW)
      mDIPAM:=DIPAM
      mDOPER:=CFO
   ENDIF
   //Soma Devolu‡”es
   DBSELECTAR(ARQWORK2)
   DBGOTOP()
   DBSEEK(STR(mNUMERO,8))
   WHILE mNUMERO=NUMERO .AND.! EOF()
      mDEV    +=DEV
      mDEV    +=DE2
      mQUANT  +=QTDEDEV
      mQUANT  +=QTDEDE2
      IF EMPTY(mUNIDADE)
         mUNIDADE:=UNIDEV
      ENDIF
      DBSKIP()
   ENDDO
   mDVALORNF  := mISENTAIPI := mISENTAICM := mDEV
   IF mVALREM>0.AND.EMPTY(mDEV)
      mDVALORNF  := mISENTAIPI := mISENTAICM := mVALREM
   ENDIF
   IF mDVALORNF>0
      NOVOOPA(ARQWORK4,.T.)
   ENDIF
ENDIF
RETU .T.
