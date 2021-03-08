MDI(" þ Controle de Credito de ICMS Do Ativo Permanente")
CRIARVARS("FI_CIAPI")
CRIARVARS("FI_CIAP")
CRIARVARS("MK01")
CRIARVARS("MK02")
paDRAO(0,1,0,"FI_CIAP", "Ciap     Fornece. Nota       Entrega  Ativo      ICMS",;
      "' '+STR(mCIAP,8)+' '+STR(mFORNECEDO,8)+' '+STR(mNRNOTA,8)+' '+STR(mNRITEM,2)+' '+DTOC(mNRENTREGA)+' '+mATIVO+' '+STR(mVALORICM,10,2)",;
      "CIAP", "CIAP01", "CIAP01",;
     {|| CIAPINS()},,,,,,{|| CIAPPOS()},;
     ,{ || PADDEL( "FI_CIAPI", str( MCHAVE, 8 ), "CIAP", "MCHAVE" ) })




FUNC CIAPPOS()
mVALOR:=truncar(mVALORICM/48)
nVALDIF:=mVALORICM-(mVALOR*48)
mMES:=MONTH(mDTINICIO)
mANO:=YEAR(mDTINICIO)
mATIVO:=.T.
FOR X=1 TO 48
    IF X=48
       mVALOR=mVALOR+nVALDIF
    ENDIF
    mITEM:=X
    MDS("Verificando "+str(x)+" "+strZERO(mMES,2)+"/"+STRZERO(mANO,4))
    IF INCLUI
       NOVOREG("FI_CIAPI",STR(mCIAP,8)+STR(mITEM,2))
    ELSE
       IF ! EMPTY(mDTSAIDA)
          IF YEAR(mDTSAIDA)=mANO
             IF mMES>=MONTH(mDTSAIDA)
                GRAVAMVAR("FI_CIAPI",STR(mCIAP,8)+STR(mITEM,2), "SOMAR", "'N'" )
             ENDIF
          ENDIF
          IF mANO>YEAR(mDTSAIDA)
             GRAVAMVAR("FI_CIAPI",STR(mCIAP,8)+STR(mITEM,2), "SOMAR", "'N'" )
          ENDIF
       ENDIF
    ENDIF
    mMES++
    IF mMES=13
       mMES=1
       mANO++
    ENDIF
NEXT X
RETU .T.


FUNC CIAPINS()
LOCAL lRETU:=.F.
LOCAL lTEM:=.F.
cARQ1="MK01"
cARQ2="MK02"
mNRITEM:=1
IF MDG("Mes Fechado")
   cVAR     := MESANO()
   cARQ1 := "K1" + cVAR
   cARQ2 := "K2" + cVAR
ENDIF
@ 24,00 SAY "N§ da Nota /Fornecedor /Item"
@ 24,30 GET mNRNOTA
@ 24,40 GET mFORNECEDO
@ 24,50 GET mNRITEM
READCUR()
lTEM:=IGUALVARS(cARQ1, STR(mNRNOTA,8)+STR(mFORNECEDO,5) )
IF ! lTEM
   lTEM:=MDG("Nota Nao Encontrada Continuar Assim Mesmo")
ENDIF
IF lTEM
   IF mCFONEW="1551".OR.mCFONEW="2551"
   ELSE
      IF ! MDG("Aceitar CFO:" + mCFONEW+"/"+mCFONEWB)
         RETU .F.
      ENDIF
   ENDIF
   mNRENTREGA:=mENTREGA
   mDTINICIO:=mENTREGA
   mFORNOME:=OBTER("MB01",mFORNECEDO,"NOME")
   IF USEREDE(cARQ2,1,99)
      DBGOTOP()
      DBSEEK(STR(mNRNOTA,8)+STR(mFORNECEDO,5))
      WHILE mNRNOTA=NRNOTA.AND.mFORNECEDO=FORNECEDO.AND.! EOF()
          IF ITEM=mNRITEM
             mNOME:=NOME
             mVALORICM:=VALORICM
             lRETU:=.T.
          ENDIF
          DBSKIP()
      ENDDO
      DBCLOSEAREA()
  endif
  IF mVALORICM=0
     //ALERTX("ICM=0")
     MDS("Valor Icms/Data Entrada/Inicio")
     @ 24,40 GET mVALORICM
     @ 24,60 GET mNRENTREGA
     @ 24,70 GET mDTINICIO
     IF ! READCUR()
        lRETU=.F.
     ENDIF
     IF mVALORICM=0
        lRETU:=.F.
     ELSE
        lRETU:=.T.
     ENDIF
  ENDIF
  mCIAP=ULTIMOREG("FI_CIAP","CIAP")
  mCIAP++
endif
RETU lRETU