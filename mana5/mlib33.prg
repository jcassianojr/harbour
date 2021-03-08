*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib33.prg
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKIPI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKIPI(cIPI)

if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if empty(cIPI)
   retu MDG("Aceitar sem Classifica‡Æo")
endif
cIPI := strtran(cIPI,".","")
cIPI := strtran(cIPI,"-","")
cIPI := strtran(cIPI," ","")
if !VERSEHA("FI_NBM",cIPI,"DESCRI","'XERRIPI'",.T.)
   retu .F.
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKCIPI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKCIPI(cCODIPI,mVARALQ,mVARCLA,mVARICM,mOPER,nBUSCA,eDIPI,eDICM)


local DBF   := alias()
local lRETU := .F.
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if empty(cCODIPI)
   MDS("Codigo Simplificado de IPI n„o preenchido")
   retu .T.
endif
IF VALTYPE(nBUSCA) # "N"
   nBUSCA := 3  //CFO Antigo //2Novo
ENDIF
if !USEREDE("MD03",1,1)
   retu lRETU
endif
dbgotop()
if dbseek(cCODIPI)
   lRETU := .T.
   if valtype(mVARALQ) = "C"
      &mVARALQ. := ALIQUOTA
   endif
   if valtype(mVARCLA) = "C"
      &mVARCLA. := CLASSIFIC
   endif
   if !empty(ALIQUOTAI) .and. valtype(mVARICM) = "C"
      &mVARICM. := ALIQUOTAI
   endif
   if valtype(eDIPI) = "C" .and. !empty(DIPIPI)
      &eDIPI. := DIPIPI
   endif
   if valtype(eDICM) = "C" .and. !empty(DIPICM)
      &eDICM. := DIPICM
   endif
endif
dbclosearea()
if !lRETU
   ALERTX("Codigo Simplificado de IPI n„o Cadastrado")
endif
IF VALTYPE(mOPER) = "C" .AND. valtype(mVARALQ) = "C"
   IF nBUSCA = 3
      mOPER := LEFT(mOPER,3)
   ENDIF
   IF OBTER("MD04",mOPER,"ZERAIPI") = "S"
      &mVARALQ. := 0
   ENDIF
ENDIF
if !empty(DBF)
   sele &DBF.
endif
retu lRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKUN()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKUN(cUNI)

if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if VERSEHA("MD07",cUNI,"'Unidade : '+UNIDDES",'"Unidade Medida N„o Cadastrada"',.T.)
   retu .T.
endif
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PDIPI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PDIPI(eOPE,eVARA,eVARB,eVARC,eVARD,lOPE,nBUSCA)

//Operacao,CodIcm,DIPIPI,DIPICM,DIPAM,open,Indice 2CfoNovo/3CfoVelho
local cDBF := alias()
IF valtype(nBUSCA) # "N"
   nBUSCA := 3  //CFO Velho
ENDIF
if valtype(lOPE) # "L"
   lOPE := .T.
endif
if valtype(eOPE) = "N"
   eOPE := str(eOPE,3)
endif
if nBUSCA = 3   //Cfo Velho
   eOPE := left(eOPE,3)
ENDIF
if lOPE
   if !USEREDE("MD04",1,nBUSCA)
      RETU.F.
   endif
endif
dbselectar("MD04")
dbgotop()
if dbseek(eOPE)
   if valtype(eVARA) = "C"
      IF !empty(CODICM)
         &eVARA. := CODICM
      ENDIF
      IF EMPTY(&eVARA.)
         &eVARA. := "000"
      ENDIF
   endif
   if valtype(eVARB) = "C" .and. !empty(DIPIPI)
      &eVARB. := DIPIPI
   endif
   if valtype(eVARC) = "C" .and. !empty(DIPICM)
      &eVARC. := DIPICM
   endif
   if valtype(eVARD) = "C" .and. !empty(DIPAM)
      &eVARD. := DIPAM
   endif
endif
if lOPE
   dbclosearea()
endif
if !empty(cDBF)
   sele &cDBF.
endif
retu .T.

