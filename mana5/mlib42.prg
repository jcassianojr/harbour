*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib42.prg
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
// #INCLUDE "MEMOGET.CH"
// #INCLUDE "FILEGET.CH"
#include "box.ch"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function EDITPEG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
funcTION EDITPEG(cCOD,cARQ)

local Ltem  := .F.
local aRETU := {}
if valtype(cARQ) # "C"
   cARQ := "MANGET"
endif
if !USEREDE(cARQ,1,1)
   retu aRETU
endif
dbgotop()
dbseek(cCOD)
while CODIGO = cCOD .and. !eof()
   aadd(aRETU,{TIP,LININI,COLINI,LINFIM,COLFIM,alltrim(CAMPO),alltrim(ESTILO),alltrim(MENSAGEM),alltrim(CONDICAO),alltrim(PRECOND)})
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
*+    Function EDITSAY()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func EDITSAY(aGET,nMES)


local i
local cTIP
local nLININI
local nCOLINI
local nLINFIM
local nCOLFIM
local cESTILO
priv cDIZ     := ""
PRIV  v_pic:="@S18"
if valtype(aGET) = "C"  //Recebeu o Codigo do layout e nao a matriz
   aGET := EDITPEG(aGET)  //Pega o relatorio
endif
if valtype(nMES) # "N"
   set mess to 24 CENTER
else
   set mess to &nMES
endif
if empty(aGET)
   ALERTX("Layout de Edi��o Vazio")
   retu .F.
endif
@ 24,0 clea
for i := 1 to len(aGET)
   cTIP    := aGET[I,1]
   nLININI := aGET[I,2]
   nCOLINI := aGET[I,3]
   nLINFIM := aGET[I,4]
   nCOLFIM := aGET[I,5]
   if nLININI == 97
      nLININI := nROW
   endif
   if nLINFIM == 97
      nLINFIM := nROW
   endif
   if nLININI == 98
      nLININI := row()
   endif
   if nLINFIM == 98
      nLINFIM := row()
   endif
   if nLININI == 99
      nLININI := 24
   endif
   if nLINFIM == 99
      nLINFIM := 24
   endif
   cDIZ      := aGET[I,6]
   cESTILO   := aGET[I,7]
   cMENSAGEM := aGET[I,8]
   cVALIDAR  := aGET[I,9]
   cPREVAL   := aGET[I,10]
   do case
      case cTIP = "T"
         TELASAY(alltrim(cDIZ))
//      case cTIP = "M"
//         @ nLININI,nCOLINI get &cDIZ. MEMO COORD {9,2,16,77}         
      case cTIP = "R"
         READCUR()
      case cTIP = "2"
         cDIZ2 := cDIZ
         if ZLANC = 0
            @ nLININI,nCOLINI get &cDIZ. pict ZPICCC valid CHECKCC(cDIZ2)       
         else
            @ nLININI,nCOLINI get &cDIZ. valid CHECKCC(cDIZ2)        
         endif
      case cTIP = "1"
 //      @ nLININI,nCOLINI GET mCGC PICT (v_pic) WHEN { |oGet| CNPJCPFPICT(oGet,mPESSOA,nLININI,nCOLINI) }  VALID CNPJCPFVAL(mCGC,mPESSOA)
         do case
            case mPESSOA = "J"
               @ nLININI,nCOLINI get &cDIZ. valid VALCGC(&cDIZ.) pict "99.999.999/9999-99"       
            case mPESSOA = "F"
               @ nLININI,nCOLINI get &cDIZ. valid VALCPF(&cDIZ.) pict "999.999.999-99"       
            case mPESSOA = "C"    //CEI //CNO
               @ nLININI,nCOLINI get &cDIZ. valid VALCEI(&cDIZ.) 
            otherwise
               @ nLININI,nCOLINI get &cDIZ.         
         endcase
      case cTIP = "S"   //Say Simples
         if empty(cESTILO)  //Sem ou Com Picture
            @ nLININI,nCOLINI say &cDIZ.         
         else
            @ nLININI,nCOLINI say &cDIZ. pict &cESTILO.        
         endif
      case empty(cTIP)  //GET
         if empty(cESTILO)  //Sem Picture
            do case
               case empty(cVALIDAR) .and. empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ.         
               case !empty(cVALIDAR) .and. !empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. valid &cVALIDAR when &cPREVAL       
               case !empty(cVALIDAR) .and. empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. valid &cVALIDAR        
               case empty(cVALIDAR) .and. !empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. when &cPREVAL        
            endcase
         else   //Com Picture
            do case
               case empty(cVALIDAR) .and. empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. pict &cESTILO.        
               case !empty(cVALIDAR) .and. !empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. valid &cVALIDAR when &cPREVAL pict &cESTILO.      
               case !empty(cVALIDAR) .and. empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. valid &cVALIDAR pict &cESTILO.       
               case empty(cVALIDAR) .and. !empty(cPREVAL)
                  @ nLININI,nCOLINI get &cDIZ. when &cPREVAL pict &cESTILO.       
            endcase
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
READCUR()
retu .T.

