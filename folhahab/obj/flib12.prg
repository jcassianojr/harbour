*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib12.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// !*****************************************************************************
// !
// !         Fun‡„o: VERSEHA()
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function VERSEHA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION VERSEHA  //ABRE UM ARQUIVO E VERIFICA SE EXISTE A CHAVE

PARA ARQWORK,nINDEX,BUSWORK,cMES1,cMES2,lMES,aVAR
LOCAL cDBF := ALIAS(),cMES := "",cVAR,cFIL,J
IF VALTYPE(lMES) # "L"
   lMES := .T.
ENDIF
IF !netuse(arqwork)
   RETU .F.
ENDIF
IF VALTYPE(nINDEX) = "N"
   DBSETORDER(nINDEX)
ENDIF
DBGOTOP()
DBSEEK(BUSWORK)
RETORNO := IF(FOUND(),.T.,.F.)
IF RETORNO .AND. VALTYPE(cMES1) = "C"
   cMES := &cMES1.
ENDIF
IF !RETORNO .AND. VALTYPE(cMES2) = "C"
   cMES := &cMES2.
ENDIF
IF VALTYPE(aVAR) = "A"  //preencher variaveis com o valor do campo
   FOR J := 1 TO LEN(aVAR)  // {{campo,variavel},{campo2,variavel2}}
      cFIL  := aVAR[J,1]
      cVAR  := aVAR[J,2]
      &cVAR := &cFIL
   NEXT J
ENDIF
DBCLOSEAREA()
IF RETORNO .AND. !EMPTY(cMES)
   MDS(cMES)
ENDIF
IF !RETORNO .AND. !EMPTY(cMES)
   IF lMES
      ALERTX(cMES)
   ELSE
      MDS(cMES)
   ENDIF
ENDIF
IF !EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
RETURN RETORNO

*+ EOF: flib12.prg
*+
