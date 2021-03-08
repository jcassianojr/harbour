*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aoac.prg
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

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

PRIV xAC


PADRAX(0,,0,{"AC","ACI"},"No.      T Codigo     Aplica‡„o",;
 "' '+STR(mAC,8)+' '+mTIPO+' '+mCODIGO+' '+mAPLICACAO","MOAC01","MOAC01",;
 ,,{|| MAOACPOS()},{|| mAC := ULTIMOREG("AC","AC","mAC")} ;
 ,"MOAC")

MDS("Aguarde Atualizando Saldos")
IF !USEMULT({{"AC",1,99},{"ACI",1,99}})
   RETU .F.
ENDIF
dbselectar("ACI")
dbsetorder(2)
dbselectar("AC")
DBGOTOP()
WHILE !EOF()
   mAC    := AC
   mPESO  := PESO
   nSALDO := 0
   dbselectar("ACI")
   dbgotop()
   dbseek(STR(MAC,8))
   WHILE mAC = AC .AND. !EOF()
      nSALDO := nSALDO+ENTKG - SAIKG
      netreclock()
      FIELD->SALKG := nSALDO
      FIELD->SALPC := ROUND(SALKG / mPESO,0)
      DBUNLOCK()
      dbskip()
   ENDDO
   dbselectar("AC")
   dbskip()
ENDDO ()
dbcloseall()



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOACPOS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOACPOS

xAC := mAC
PADRAO(1,1,0,"ACI","No.      Item Data    Pe‡as      Kilos      Pe‡as      Kilos",;
 "' '+STR(mAC,8)+' '+STR(mITEM,3)+' '+DTOC(mDATA)+' '+STR(mENTPC,10)+' '+STR(mENTKG,10,4)+' '+STR(mSAIPC,10)+' '+STR(mSAIKG,10,4)","MOAI",,,;
 {|| MOACIINS()},{|| PADARR("ACI",str(xAC,8),"AC","XAC")})
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MOACIINS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MOACIINS

mAC := xAC
ULTIMOITEM("ACI",str(xAC,8),"AC","XAC","ITEM","mITEM",.T.)
RETU .T.
