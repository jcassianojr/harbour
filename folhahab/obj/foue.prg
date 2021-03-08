//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

function foue


PADRAO("FO_EXP","FO_EXP","STR(mNUMERO)+' '+mNOME+' '+DTOC(mADMITIDO)+' '+DTOC(mDATAFIM1)+' '+DTOC(mDATAFIM2)","mNUMERO","N§      NOME"+SPACE(36)+"Admitido 1§Vencto 2§Vencto",;
       {|| PEGCHAVE("mNUMERO",ULTIMOREG("FO_EXP","NUMERO",.T.),"Numero")},{|| tFOUE()},{|| gFOUE()},{|| lFOUE() })
RETU .T.


FUNC tFOUE
@ 11,00 SAY "Ý"+SPAC(78)+"Ý"
@ 12,00 SAY "Ý Admitido :            N§ Dias :      -> Termino"+SPAC(30)+"Ý"
@ 13,00 SAY "Ý"+SPAC(78)+"Ý"
@ 14,00 SAY "Ý              Prorroga‡„o Dias :      -> Termino"+SPAC(30)+"Ý"
@ 15,00 SAY "Ý"+SPAC(78)+"Ý"
@ 16,00 SAY "Ý Obs:"+SPAC(73)+"Ý"
@ 17,00 SAY "Ý"+SPAC(78)+"Ý"
@ 18,00 SAY "Ý"+SPAC(78)+"Ý"
@ 19,00 SAY "Ý"+SPAC(78)+"Ý"
@ 20,00 SAY "Ý"+SPAC(78)+"Ý"
RETU .T.


FUNC gFOUE
IF netuse(pes) 
   DBGOTOP()
   if DBSEEK(mNUMERO)
      PETELA(5)
      mDEPto=DEPTO
      mSETOR=SETOR
      mSECAO=SECAO
      mNOMe=NOME
      mCHAPA=CHAPA
      mADMITIDO=ADMITIDO
   endif  
   DBCLOSEAREA()
ENDIF   
vFOUE()
@ 12,34 GET mDIAS1 VALID vFOUE()
@ 14,34 GET mDIAS2 VALID vFOUE() 
@ 16,13 GET mOBS1
@ 17,13 GET mOBS2
@ 18,13 GET mOBS3
@ 19,13 GET mOBS4
@ 20,13 GET mOBS5
READCUR()
RETU .T.

FUNC vFOUE
mDATAFIM1:=MADMITIDO+mDIAS1-1
IF MDIAS2#0
   mDATAFIM2:=mDATAFIM1+mDIAS2
ELSE
   mDATAFIM2:=mDATAFIM1
ENDIF
@ 12,13 SAY mADMITIDO
@ 12,50 SAY mDATAFIM1
@ 14,50 SAY mDATAFIM2
RETU .T.

func lFOUE
@ 24,00 SAY "(L)Listagem (C)ontrato "
@ 24,30 GET cTIPO PICT "!" VALID cTIPO $ "LC"
readcur()
if cTIPO="C"
   FOUEF()
ELSE
   FOUEC()
ENDIF