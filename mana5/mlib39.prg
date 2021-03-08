*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib39.prg
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
#include "box.ch"


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
function TELAPEG(cCOD,cARQ)

LOCAL lTEM  := .F.
local aRETU := {}
if valtype(cARQ) # "C"
   cARQ := "MANTEL"
endif
if !USEREDE(cARQ,1,1)
   retu aRETU
endif
dbgotop()
dbseek(cCOD)
while CODIGO = cCOD .and. !eof()
   aadd(aRETU,{TIP,LININI,COLINI,LINFIM,COLFIM,DIZER,ESTILO})
   dbskip()
   lTEM := .T.
enddo
dbclosearea()
IF !lTEM
   //   ALERTX("Nao Encontrei layout Tela: "+cCOD)
ENDIF
retu aRETU


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
function TELASAY(aTEL)
local i
local cTIP
local nLININI
local nCOLINI
local nLINFIM
local nCOLFIM
local cESTILO
priv cDIZ     := ""
if valtype(aTEL) = "C"  //Recebeu o Codigo do layout e nao a matriz
   aTEL := TELAPEG(aTEL)  //Pega o relatorio
endif
if empty(aTEL)
   ALERTX("Layout de Tela Vazio")
   retu .F.
endif
for i := 1 to len(aTEL)
   cTIP    := aTEL[I,1]
   nLININI := aTEL[I,2]
   nCOLINI := aTEL[I,3]
   IF nCOLINI=-1
      nCOLINI=COL()+1
   ENDIF
   nLINFIM := aTEL[I,4]
   nCOLFIM := aTEL[I,5]
   cDIZ    := alltrim(aTEL[I,6])
   cESTILO := alltrim(aTEL[I,7])
   do case
      case empty(cTIP)  //Say Simples
         if empty(cESTILO)  //Sem ou Com Picture
            @ nLININI,nCOLINI say &cDIZ.         
         else
            @ nLININI,nCOLINI say &cDIZ. pict &cESTILO.        
         endif
      case cTIP = "B"   //Box
           DO CASE
               CASE LEFT(cDIZ,2)="SD".OR.cDIZ="B_SINGLE_DOUBLE"                           
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_SINGLE_DOUBLE)   
               CASE LEFT(cDIZ,2)="DS".OR.cDIZ="B_DOUBLE_SINGLE"                           
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_DOUBLE_SINGLE)                  
               CASE LEFT(cDIZ,1)="D".OR.cDIZ="B_DOUBLE"
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_DOUBLE)
               CASE LEFT(cDIZ,1)="S".OR.cDIZ="B_SINGLE"                           
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_SINGLE)                     
               OTHERWISE
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,&cDIZ.)
            ENDCASE
      case cTIP = "C"   //cor
         setcolor(&cDIZ)
   endcase
next i
return .T.

