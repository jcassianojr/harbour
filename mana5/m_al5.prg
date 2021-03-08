*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_al5.prg
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_al5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_al5

PARA ARQWORK,bSAY,bGET
MDI(" Ý ",,,ARQWORK)
CLSCOR()
IF ARQWORK = "ML01"
   CORMAL  := CORARR("MAL")
   aMALTEL := TELAPEG("MAL001")
ENDIF
IF ARQWORK = "MN01"
   CORMAN  := CORARR("MAN")
   aMANTEL := TELAPEG("MAN001")
   aMANGET := EDITPEG("MAN001")
ENDIF
CRIARVARS(ARQWORK)
nIND := NUMIND(ARQWORK)
PRIV mCHAVE,mCHABUS,aIND
cVIDE := "N"
IF !CONFIND(ARQWORK)
   RETU .F.
ENDIF
WHILE .T.
   mCHABUS := PEGBUS(ARQWORK,nIND)
   IF pESC
      EXIT
   ENDIF
   IF IGUALVARS(ARQWORK,mCHABUS,nIND)
      IF ARQWORK = "ML01"
         TIPCAD(mTIPOCLI,"ARQUSO",3,24)
      ENDIF
      FORMULA  := aIND[1,4]
      VARIAVEL := aIND[1,1,3]
      mCHAVE   := IF(EMPTY(FORMULA),&VARIAVEL.,&FORMULA.)
      EVAL(bSAY)
      EVAL(bGET)
      IF !EMPTY(mDATAPG) .AND. !EMPTY(mVALORPG)
         mOBS := "Baixa Manual"
         NOVOREG(ARQWORK+"PG",mCHAVE)
         APAGAREG(ARQWORK,mCHAVE,.F.)
         IF ROUND(mDIFERENCA,2) < ROUND(0,2)
            mVALOR   := ABS(mDIFERENCA)
            mVALORPG := 0
            mDATAPG  := CTOD("  /  /  ")
            mAVISO   := "S"
            I        := 1
            mTIPFAT  := CHR(64+I)
            mCHAVE   := IF(EMPTY(FORMULA),&VARIAVEL.,&FORMULA.)
            WHILE VERSEHA(ARQWORK,mCHAVE)
               I ++
               mTIPFAT := CHR(64+I)
            ENDDO
            NOVOREG(ARQWORK,mCHAVE)
         ENDIF
      ENDIF
   ENDIF
ENDDO
