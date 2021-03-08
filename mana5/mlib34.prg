*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib34.prg
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


#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKESP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKESP(cVAR,nTIP,nARQ)


local lRETU := .F.
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if nARQ = 1
   if !USEREDE("FI_SER",1,1)
      retu .F.
   endif
else
   if !USEREDE("FI_ESP",1,1)
      retu .F.
   endif
endif
dbgotop()
IF dbseek(cVAR)
   do case
      case TIPSER = "T"
         lRETU := .T.
      case TIPSER = "1" .and. nTIP = 1
         lRETU := .T.
      case TIPSER = "2" .and. nTIP = 2
         lRETU := .T.
      case TIPSER = "3" .and. nTIP = 3
         lRETU := .T.
      case TIPSER = "A" .and. nTIP = 1
         lRETU := .T.
      case TIPSER = "A" .and. nTIP = 2
         lRETU := .T.
      case TIPSER = "B" .and. nTIP = 1
         lRETU := .T.
      case TIPSER = "B" .and. nTIP = 3
         lRETU := .T.
      case TIPSER = "C" .and. nTIP = 2
         lRETU := .T.
      case TIPSER = "C" .and. nTIP = 3
         lRETU := .T.
   endcase
endif
dbclosearea()
if !lRETU
   if nARQ = 1
      ALERTX("S‚rie n„o Cadastrada, ou incosistente para o movimento")
   else
      ALERTX("Esp‚cie n„o Cadastrada, ou incosistente para o movimento")
   endif
endif
retu lRETU

// *********************************************************
//  cCFO - codigo de operacao
//  nTIP - 1 Entrada 2- Saida
//  cUFREF - Estado a checar
//  cUFEMP - Estado do Sistema
//  nROW - Linha de Exibicao
//  nCOL - Coluna de Exibicao
//  mDIGA - Dizeres a Exibir (Macro)
//  mVARICM - Variavel a Receber valor ICM
//  mVARDIPAM - Variavel Recevber Dipam
// *********************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKCFO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKCFO(cCFO,nTIP,cUFREF,cUFEMP,nROW,nCOL,mDIGA,mVARICM,mVARDIPAM,mVARCFO,mVARCFO2,nBUSCA,lREP)


local cCONF := "1"
IF VALTYPE(lREP) # "L"
   lREP := .F.
ENDIF
IF EMPTY(cCFO)
   MDS("CFO nÆo preenchido")
   RETU .F.
ENDIF
IF valtype(nBUSCA) # "N"
   nBUSCA := 3  //Cfo Velho
ENDIF
if valtype(cUFEMP) # "C"
   cUFEMP := OBTER("MANEMP",ZNUMERO,"ESTADO")
endif
if valtype(nROW) # "N"
   nROW := 24
endif
if valtype(nCOL) # "N"
   nCOL := 0
endif
if valtype(mDIGA) # "C"
   mDIGA := "LEFT(DESCRICAO,40)"
endif
do case
   case cUFREF = cUFEMP .and. nTIP = 1
      cCONF := "1"
   case cUFREF # cUFEMP .and. cUFREF <> 'XX' .and. nTIP = 1
      cCONF := "2"
   case cUFREF = 'XX' .and. nTIP = 1
      cCONF := "3"
   case cUFREF = cUFEMP .and. nTIP = 2
      cCONF := "5"
   case cUFREF # cUFEMP .and. cUFREF <> 'XX' .and. nTIP = 2
      cCONF := "6"
   case cUFREF = 'XX' .and. nTIP = 2
      cCONF := "7"
endcase
if substr(cCFO,1,1) # cCONF
   do case
      case cCONF = "1"
         ALERTX('C¢digo Fiscal de opera‡„o DENTRO do Estado deve come‡ar com 1')
      case cCONF = "2"
         ALERTX('C¢digo Fiscal de opera‡„o FORA do Estado deve come‡ar com 2')
      case cCONF = "3"
         ALERTX('C¢digo Fiscal de opera‡„o EXTERIOR deve come‡ar com 3')
      case cCONF = "5"
         ALERTX('C¢digo Fiscal de opera‡„o DENTRO do Estado deve come‡ar com 5')
      case cCONF = "6"
         ALERTX('C¢digo Fiscal de opera‡„o FORA do Estado deve come‡ar com 6')
      case cCONF = "7"
         ALERTX('C¢digo Fiscal de opera‡„o EXTERIOR deve come‡ar com 7')
   endcase
   retu .F.
endif
if valtype(mVARICM) = "C"
   &mVARICM. := OBTER("MD05",mUFREF,"ALIQUOTA")
endif
if empty(cCFO)
   retu MDG('Aceitar C¢digo Fiscal de opera‡„o Nulo')
endif
IF nBUSCA = 3
   cCFO3 := left(cCFO,3)
ELSE
   cCFO3 := cCFO
ENDIF
if !VERSEHA("MD04",cCFO3,mDIGA,"'C¢digo CFO N„o Cadastrado'",.T.,nBUSCA,nROW,nCOL)
   retu MDG("C¢digo Fiscal de Opera‡„o n„o Cadastrado Aceitar")
endif
if valtype(mVARDIPAM) = "C"
   if empty(&mVARDIPAM.)
      &mVARDIPAM. := OBTER("MD04",cCFO3,"DIPAM",nBUSCA)
   endif
endif
IF nBUSCA = 1
   if valtype(mVARCFO) = "C" .OR. lREP
      if empty(&mVARCFO.)
         &mVARCFO. := OBTER("MD04",cCFO3,"CFONEW",nBUSCA)
      endif
   endif
   if valtype(mVARCFO2) = "C" .AND. !EMPTY(SUBSTR(cCFO,5))
      if empty(&mVARCFO2.)
         &mVARCFO2. := OBTER("MD04",SUBSTR(cCFO,5),"CFONEW",nBUSCA)
      endif
   endif
else
   if valtype(mVARCFO) = "C"
      if empty(&mVARCFO.) .OR. lREP
         &mVARCFO. := OBTER("MD04",cCFO3,"CFO",nBUSCA)
      endif
   endif
endif
retu .T.



