*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib07.prg
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

#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKTAB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC CHECKTAB(eCHAVE,nLIN,nCOL,cMES,nRETU)

LOCAL lRETU := .F.,cDESC := "",cDBF := ALIAS()
IF LASTKEY() = K_UP .OR. LASTKEY() = K_DOWN
   RETU .T.
ENDIF
IF VALTYPE(nRETU) # "N"
   nRETU := 1
ENDIF
IF !netuse("FO_TAB")
   ALERTX("Nao Consegui Abrir Arquivo de Tabelas")
   IF !EMPTY(cDBF)
      DBSELECTAR(cDBF)
   ENDIF
   RETU IF(nRETU = 1,.F.,cDESC)
ENDIF
DBGOTOP()
IF DBSEEK(eCHAVE)
   lRETU := .T.
   cDESC := DESCRI
ENDIF
DBCLOSEAREA()
IF !lRETU .AND. nRETU = 1
   ALERTX(cMES)
ENDIF
IF VALTYPE(nLIN) = "N" .AND. VALTYPE(nCOL) = "N"
   @ nLIN,nCOL SAY cDESC         
ENDIF
IF !EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
RETU IF(nRETU = 1,lRETU,cDESC)

*+ EOF: flib07.prg
*+
