*+--------------------------------------------------------------------
*+
*+    Programa  : m_cb2.prg  Arquivo de Configuracaoo de Indexacao
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+--------------------------------------------------------------------
*+

#INCLUDE "INKEY.CH"

PADRAO(1,1,0,ZARQ1,"Arquivo  I. Indice   Descri‡„o",;
 "' '+mARQUIVO+' '+STR(mITEM,2)+' '+mINDICE+' '+mDESC",;
 "MCB2","MCB201","MCB201",{|| MCB2INS()} ;
 ,{|| PADARR(ZARQ1,mARQUIVO,"ARQUIVO","mARQUIVO")},;
 {| nKEY,nPOS | MCB2TEC(nKEY,nPOS)},,,.F.)


*+--------------------------------------------------------------------
*+
*+    Function MCB2TEC()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MCB2TEC(nKEY,nPOS)

IF nKEY = K_ALT_ENTER
   mITEM := VAL(SUBSTR(aPAD2[nPOS],9,2))
   M_DB("ARQUIVO=mARQUIVO.AND.ITEM=mITEM")
ENDIF
RETURN .T.


*+--------------------------------------------------------------------
*+
*+    Function MCB2INS()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MCB2INS

mITEM := LEN(aPAD1)
mITEM ++
RETURN .T.
