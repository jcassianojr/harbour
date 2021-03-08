*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib09.prg
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



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MESANO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MESANO(eMES,eANO)


local aDAD
priv GETLIST := {}
aDAD := PEGMES({""})
if valtype(eMES) = "C"
   &eMES. := aDAD[1]
endif
if valtype(eANO) = "C"
   &eANO. := aDAD[2]
endif
retu aDAD[4]+aDAD[3]


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEDPER()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEDPER(lPER,aPER)

local lRETU := .T.
local lACUM := .T.
if valtype(aPER) = "A"
   nINIANO := aPER[1]
   nFIMANO := aPER[2]
   nINIMES := aPER[3]
   nFIMMES := aPER[4]
   lACUM   := aPER[6]
else
   nINIANO := year(ZDATA)
   nFIMANO := year(ZDATA)
   nINIMES := month(ZDATA)
   nFIMMES := month(ZDATA)
endif
if lPER
   MDS("Digite o Periodo Mˆs e Ano")
   @ 24,30      say "Inicial"         
   @ 24,col()+1 get nINIMES           
   @ 24,col()+1 get nINIANO           
   @ 24,col()+1 say "Final"           
   @ 24,col()+1 get nFIMMES           
   @ 24,col()+1 get nFIMANO           
   if !READCUR()
      lRETU := .F.
   endif
   mds("")
endif
nMESES := 0
if nINIANO = nFIMANO
   nMESES := nFIMMES - nINIMES+1
else
   nMESES += 13 - nINIMES
   nMESES += nFIMMES
   if nFIMANO - nINIANO > 1
      nMESES += (nFIMANO - nINIANO - 1) * 12
   endif
endif
retu {nINIANO,nFIMANO,nINIMES,nFIMMES,lRETU,lACUM,nMESES}


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEGMES()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEGMES(aDAD,lPER,aBAS)


local cARQ
local mMES
local mANO
local cMESUSO
local cANOUSO
local X
local lFEC
local aRETU   := {0,0,"XX","XX",aDAD,0,"MM/YYYY",.F.}
lfec := .T.
if valtype(lper) # "L"
   lper := .f.
endif
mMES := month(ZDATA)
mANO := year(ZDATA)
MDS("Confirme a Competencia")
@ 24,50 get mMES PICT "99"          
@ 24,60 get mANO PICT "9999"        
if !READCUR()
   retu aRETU
endif
mds("")
if lper
   if !mdg("Mes fechado")
      lfec := .f.
   endif
endif
aRETU := {}
aadd(aRETU,mMES)  //1 mes
aadd(aRETU,mANO)  //2 ano
aadd(aRETU,strzero(mMES,2))   //3 mes string
aadd(aRETU,substr(strzero(mANO,4),3,2))   //4 ano string AA
for X := 1 to len(aDAD)
   if lfec
      cARQ := aDAD[X]+aRETU[4]+aRETU[3]
      aDAD[X] = cARQ
   else
      if valtype(aBAS) = "A"
         cARQ := aBAS[X]
         aDAD[X] = cARQ
      endif
   endif
next X
aadd(aRETU,aDAD)  //5 nomes do arquivos
aadd(aRETU,2)   //6 -- tipo 2 mes fechado
aadd(aRETU,MMES(aRETU[1])+"/"+strzero(mANO,4))  //7 Competencia
retu aRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PERFEC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PERFEC(aNOR,aSTR,aFEC,aDAT)  //aDAT nome do campo da data para o somano

//padrao funcao DATA "PADRAO" p/Competencia

local aRETU := {0,0,"XX","XX",aNOR,1,CMES(ZDATA)+"/"+strzero(year(ZDATA),4)}
local X
if MDG("Mes j  Fechado")
   aRETU := PEGMES(aSTR)
else
   if MDG("Deseja Acumulado")
      aPER := PEDPER(.T.)
      if MDG("Deseja Reacumular")
         for X := 1 to len(aFEC)
            IF VALTYPE(aDAT) = "A"
               SOMAANO(aFEC[X],aSTR[X],aDAT[X],,,,,,aPER)
            ELSE
               SOMAANO(aFEC[X],aSTR[X],,,,,,,aPER)
            ENDIF
         next X
      endif
      aRETU := {0,0,"XX","XX",aFEC,3,MMES(aPER[3])+"/"+strzero(aPER[1],4)+" - "+MMES(aPER[4])+"/"+strzero(aPER[2],4)}   //tipo 3 acumulado
   endif
endif
retu aRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function SOMAANO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func SOMAANO(cARQSOM,cSTRREF,cVARSOM,bSOMA,cATU,eDAT,cBAI,eDA2,aPER,bUSE)

local lAC01 := lAC02 := lAC03 := .F.
CRIARVARS(cARQSOM)
if valtype(aPER) # "A"
   aPER := PEDPER(.F.)
endif
if (empty(cATU) .and. empty(cBAI)) .or. MDG("Reacumular o Periodo")
   aPER  := PEDPER(.T.,aPER)
   lAC01 := .T.
endif
if !empty(cBAI) .and. MDG("Incluir Baixados")
   lAC02 := .T.
endif
if !empty(cATU) .and. MDG("Incluir Ativos")
   lAC03 := .T.
endif
ZAPARQ({{cARQSOM,.F.,.T.}})
if lAC01
   do case
      case aPER[1] = aPER[2]
         for X := aPER[3] to aPER[4]
            SOMAARQ(X,aPER[1],cSTRREF,cARQSOM,cVARSOM,bSOMA,bUSE)
         next X
      case aPER[1]+1 = aPER[2]
         for X := aPER[3] to 12
            SOMAARQ(X,aPER[1],cSTRREF,cARQSOM,cVARSOM,bSOMA,bUSE)
         next X
         for X := 1 to aPER[4]
            SOMAARQ(X,aPER[2],cSTRREF,cARQSOM,cVARSOM,bSOMA,bUSE)
         next X
      otherwise
         for X := aPER[3] to 12
            SOMAARQ(X,aPER[1],cSTRREF,cARQSOM,cVARSOM,bSOMA,bUSE)
         next X
         for Y := aPER[1]+1 to aPER[2] - 1
            for X := 1 to 12
               SOMAARQ(X,Y,cSTRREF,cARQSOM,cVARSOM,bSOMA,bUSE)
            next X
         next Y
         for X := 1 to aPER[4]
            SOMAARQ(X,aPER[2],cSTRREF,cARQSOM,cVARSOM,bSOMA,bUSE)
         next X
   endcase
endif
if lAC02
   SOMAARQ(,,alltrim(cBAI),cARQSOM,eDA2)
endif
if lAC03
   SOMAARQ(,,alltrim(cATU),cARQSOM,eDAT)
endif
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function SOMAARQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC SOMAARQ(nMES,nANO,cREF,cARQREF,cVARSOM,bBLOCO,bUSE)

LOCAL cANO,cMES,cARQ
IF VALTYPE(nANO) = "N" .AND. VALTYPE(nMES) = "N"
   cANO := SUBSTR(STRZERO(nANO,4),3,2)
   cMES := STRZERO(nMES,2)
   cARQ := cREF+cANO+cMES
ELSE
   cARQ := cREF
ENDIF
IF VALTYPE(bBLOCO) = "B"
   EVAL(bBLOCO,nMES,nANO,cARQ,cARQREF)
   RETU .F.
ENDIF
MDS("Aguarde Apurando "+cARQ)
IF VALTYPE(bUSE) = "B"
   EVAL(bUSE,cARQ)
ELSE
   IF !USEREDE(cARQ,1,0)
      RETU .F.
   ENDIF
ENDIF
IF VALTYPE("DATA") = "U" .AND. VALTYPE("cVARSOM") = "U"   //Verifica se o arquivo tem o campo data
   cVARSOM := "PADRAO"
ENDIF
DBGOTOP()
WHILE !EOF()
   EQUVARS()
   IF VALTYPE(cVARSOM) = "C"
      IF cVARSOM = "PADRAO"
         mMES := nMES
         mANO := nANO
      ELSE
         mMES := MONTH(&cVARSOM.)
         mANO := YEAR(&cVARSOM.)
      ENDIF
   ELSE
      mMES := MONTH(DATA)
      mANO := YEAR(DATA)
   ENDIF
   NOVOOPA(cARQREF,,,.F.)
   DBSELECTAR(cARQ)
   DBSKIP()
ENDDO
DBCLOSEAREA()
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CALCPER()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC CALCPER(aPER,nANO,nMES,eCALC)

if nANO = aPER[1] .and. aPER[1] # aPER[2]
   if nMES >= aPER[3]
      eVAL(eCALC)
   endif
endif
if nANO = aPER[2]
   IF aPER[1] = aPER[2]
      if nMES >= aPER[3] .and. nMES <= aPER[4]
         eVAL(eCALC)
      endif
   else
      if nMES <= aPER[4]
         eVAL(eCALC)
      endif
   endif
endif
RETU .T.

