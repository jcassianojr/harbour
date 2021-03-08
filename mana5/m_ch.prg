*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ch.prg
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


PADRAO(0,1,0,"MACESS","C¢digo Descri‡„o","' '+mCODIGO+' '+mDESCRICAO","MCH")


// ** Libera‡„o de Senhas Especiais

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function SENHAX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC SENHAX(cCHAVE,cTITULO,lMES,cSENHA,nLEN)

LOCAL lRETU := .F.
IF VALTYPE(nLEN) # "N"
   nLEN := 5
ENDIF
IF VALTYPE(cTITULO) # "C"
   cTITULO := "Checando Acesso"
ENDIF
IF VALTYPE(lMES) # "L"
   lMES := .T.
ENDIF
MDS(cTITULO)
lRETU := PEGACS("A",cCHAVE+ZUSER,.T.)
IF !lRETU .AND. lMES
   ALERTX("Acesso Bloqueado - "+cCHAVE)
ENDIF
RETU lRETU


