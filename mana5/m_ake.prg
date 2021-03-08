*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ake.prg
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

MDI("Importando Dados Folha")
CRIARVARS("MK04")
cVAR     := MESANO()
ARQWORK  := "K4"+cVAR
mANO     := VAL(LEFT(cVAR,2))
mMES     := VAL(RIGHT(cVAR,2))
mDATA    := ZDATA
mTIPOCLI := "M"
mCOGNOME := "FOLHA"
IF !mdg("Importar os dados da Folha para "+cVAR)
   RETU .F.
ENDIF
MDS("Checando Plano de Conta Folha")
aCTA := {}
aCON := {}
aCEN := {}
aFOL := {}
IF !USECHK("\FOLHA\CONTAS",,.T.)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   IF !EMPTY(CO_COD) .OR. !EMPTY(CO_CODD)
      AADD(aCTA,CODIGO)
      AADD(aCON,{CO_COD,CO_CODD})
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEAREA()
MDS("Checando Centro Custo Manager")
IF !USEREDE("MI03",1,1)
   RETU .F.
ENDIF
WHILE !EOF()
   IF !EMPTY(CFOLHA)
      AADD(aFOL,CFOLHA)
      AADD(aCEN,{CENTRO,GASTO})
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEAREA()
MDS("Gravando Dados")
IF !USEREDE(ARQWORK,1,99)
   RETU .F.
ENDIF
DBGOBOTTOM()
mNRNOTA := NRNOTA
mNRNOTA ++
IF !USECHK("\FOLHA\APIDEPTO",,.T.)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   IF EMPTY(SECAO) .AND. EMPTY(SETOR)
      mVALORMES := VALOR
      xCONTA    := CONTA
      mDEPTO    := DEPTO
      nPOS      := ASCAN(aCTA,xCONTA)
      IF nPOS > 0
         cCREDITO := aCON[nPOS,1]
         cDEBITO  := aCON[nPOS,2]
         wPOS     := ASCAN(aFOL,mDEPTO)
         IF wPOS > 0
            mCENTRO := aCEN[wPOS,1]
            mGASTO  := aCEN[wPOS,2]
            DBSELECTAR(ARQWORK)
            IF !EMPTY(cCREDITO)
               mCONTA := cCREDITO
               NOVOOPA()
               mNRNOTA ++
            ENDIF
            IF !EMPTY(cDEBITO)
               mCONTA := cDEBITO
               NOVOOPA()
               mNRNOTA ++
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   DBSELECTAR("APUDEPTO")
   DBSKIP()
ENDDO
