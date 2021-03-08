*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_al2b.prg
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
MDS("Digite o Periodo de programa‡„o e Nota Inicial")
@ 24,40 GET dDATAINI         
@ 24,50 GET dDATAFIM         
@ 24,60 GET yNRNOTA          
IF !READCUR()
   RETU .F.
ENDIF
MDS("Digite o Valor do Faturmanento")
@ 24,40 GET yFATURA         
IF !READCUR()
   RETU .F.
ENDIF

IF !USEMULT({{"ML01",1,99},{"ML02",1,1}})
   RETU .F.
ENDIF

DBSELECTAR("ML01")
INITVARS()
CLRVARS()
DBSELECTAR("ML02")
INITVARS()
CLRVARS()

MDS("Aguarde Transferencia")
DBSELECTAR("ML02")
DBGOTOP()
WHILE !EOF()
   EQUVARS()
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
      IF VENTIP = "S"
         //O dia da semana Coincide com o da Entrega
         IF DOW(dREF) = DATENT
            mVENCIMENT := dREF
            NOVOOPE("ML01",DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)
            DBSELECTAR("ML02")
         ENDIF
      ENDIF
      //Entrega Mensal
      IF VENTIP = "M"
         //O dia do mes Coincide com o da Entrega
         IF DAY(dREF) = DATENT
            mVENCIMENT := dREF
            NOVOOPE("ML01",DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)
            DBSELECTAR("ML02")
         ENDIF
      ENDIF
      dREF ++
   ENDDO
   DBSELECTAR("ML02")
   DBSKIP()
ENDDO
DBCLOSEALL()

RELEASE ALL LIKE M *




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AL2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M_AL2

PADRAO(0,1,0,"ML02","Fatura     Vencera  CLIENTE         Valor Receber      DDD+Telefone","' '+STR(mNRNOTA,8)+' '+mTIPFAT+' '+STR(mDATENT)+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mVALOR,18,2)+' '+mDDD+' '+mTELEFONE","MAL2")
RETU
