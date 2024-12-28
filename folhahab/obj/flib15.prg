*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib15.prg
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

#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TELAPEG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION TELAPEG(cCOD,cARQ)

LOCAL aRETU := {},cDBF := ALIAS()
IF VALTYPE(cARQ) # "C"
   cARQ := "FOLTEL"
ENDIF
IF !NetUse(cARQ)
   RETU aRETU
ENDIF
DBGOTOP()
DBSEEK(cCOD)
WHILE CODIGO = cCOD .AND. !EOF()
   AADD(aRETU,{TIP,LININI,COLINI,LINFIM,COLFIM,DIZER,ESTILO})
   DBSKIP()
ENDDO
DBCLOSEAREA()
IF !EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
RETU aRETU



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TELASAY()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION TELASAY(aTEL)

LOCAL i,cTIP,nLININI,nCOLINI,nLINFIM,nCOLFIM,cESTILO
PRIV cDIZ := ""
IF VALTYPE(aTEL) = "C" .AND. VALTYPE(aTEL) <> 'A'   //Recebeu o Codigo do layout e nao a matriz
   aTEL := TELAPEG(aTEL)  //Pega o relatorio
ENDIF
IF EMPTY(aTEL)
   ALERTX("Layout de Tela Vazio")
   RETU .F.
ENDIF
FOR i := 1 TO LEN(aTEL)
   cTIP    := aTEL[I,1]
   nLININI := aTEL[I,2]
   nCOLINI := aTEL[I,3]
   nLINFIM := aTEL[I,4]
   nCOLFIM := aTEL[I,5]
   cDIZ    := ALLTRIM(aTEL[I,6])
   cESTILO := ALLTRIM(aTEL[I,7])
   DO CASE
   CASE EMPTY(cTIP)   //Say Simples
      IF EMPTY(cESTILO)   //Sem ou Com Picture
         @ nLININI,nCOLINI SAY &cDIZ.         
      ELSE
         @ nLININI,nCOLINI SAY &cDIZ. PICT &cESTILO.        
      ENDIF
   CASE cTIP = "B"  //Box
      HB_SCROLL(nLININI,nCOLINI,nLINFIM,nCOLFIM)
      DO CASE
      CASE LEFT(cDIZ,2) = "SD" .OR. cDIZ = "B_SINGLE_DOUBLE"
         HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_SINGLE_DOUBLE+" ")
      CASE LEFT(cDIZ,2) = "DS" .OR. cDIZ = "B_DOUBLE_SINGLE"
         HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_DOUBLE_SINGLE+" ")
      CASE LEFT(cDIZ,1) = "D" .OR. cDIZ = "B_DOUBLE"
         HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_DOUBLE+" ")
      CASE LEFT(cDIZ,1) = "S" .OR. cDIZ = "B_SINGLE"
         HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_SINGLE+" ")
      OTHERWISE
         HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,&cDIZ.)
      ENDCASE
   CASE cTIP = "C"  //cor
      SETCOLOR(&cDIZ)
   ENDCASE
NEXT i
RETU .T.


*+ EOF: flib15.prg
*+
