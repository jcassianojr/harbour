*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_al2c.prg
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

//#INCLUDE "COMANDO.CH"
dDATAINI := dDATAFIM := ZDATA
yNRNOTA  := 0
yFATURA  := 0.00
MDI(" þ ",,,"ML02")
MDS("Digite o Periodo e Faturamento")
@ 24,30 GET dDATAINI         
@ 24,40 GET dDATAFIM         
@ 24,50 GET yFATURA          
IF !READCUR()
   RETU .F.
ENDIF

CRIARVARS("ML01")
CRIARVARS("ML02")

CORPAD := CORARR("MAL2")
PAD001 := CORPAD[1]
PAD002 := CORPAD[2]
PAD005 := CORPAD[3]
PAD006 := CORPAD[4]
PAD007 := CORPAD[5]



TELASAY("MAL201")
EDITSAY("MAL201")

mFORNECEDO := CLIENTE
mDATA      := ZDATA

IF !USEREDE("ML01",1,99)
   RETU .F.
ENDIF

IF EMPTY(mNRNOTA)
   mNRNOTA := yNRNOTA
   yNRNOTA ++
ENDIF
IF !EMPTY(mFATPER)
   mVALOR  := ROUND(yFATURA * mFATPER / 100,2)
   mTOTFAT := ROUND(yFATURA * mFATPER / 100,2)
ENDIF
dREF := dDATAINI
WHILE dREF <= dDATAFIM
   //Entrega Semanal
   IF mVENTIP = "S"
      //O dia da semana Coincide com o da Entrega
      IF DOW(dREF) = mDATENT
         mVENCIMENT := dREF
         NOVOOPE(,DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)
      ENDIF
   ENDIF
   //Entrega Mensal
   IF mVENTIP = "M"
      //O dia do mes Coincide com o da Entrega
      IF DAY(dREF) = mDATENT
         mVENCIMENT := dREF
         NOVOOPE(,DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)
      ENDIF
   ENDIF
   dREF ++
ENDDO
DBCLOSEALL()
