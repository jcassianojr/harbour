*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib24.prg
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
*+    Function GRAVAMVAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func GRAVAMVAR(cARQ,cBUS,aCAM,aVAR,nIND,lMES)   // P ARQUIVO, E CHAVE DE BUSCA

local lRETU   := .F.
local DBF_USO := alias()
local aLAY
local X
if valtype(lMES) # "L"
   lMES := .T.
endif
if valtype(aVAR) = "C" .and. valtype(aCAM) = "C"  //Transforma Matriz
   aCAM := {aCAM}
   aVAR := {aVAR}
endif
aLAY  := {}
aLAY  := {aCAM,aVAR}
lRETU := GRAVALAY(aLAY,cARQ,nIND,.T.,cBUS,.F.)
if !lRETU .and. lMES
   ALERTX("Gravamvar: N„o encontrei o registro: "+cARQ+" "+STRVAL(cBUS))
endif
retu lRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEGLAY()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEGLAY(cARQ,cCODIGO)


aLAY1 := {}
aLAY2 := {}
if !USEREDE(cARQ,1,1)
   retu {aLAY1,aLAY2}
endif
dbgotop()
dbseek(cCODIGO)
while CODIGO = cCODIGO .and. !eof()
   aadd(aLAY1,alltrim(VARDES))
   aaDd(aLAY2,alltrim(VARDRI))
   dbskip()
enddo
dbcloseare()
retu {aLAY1,aLAY2}


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVALAY()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func GRAVALAY(aLAY,cARQ,nIND,lOPE,cBUS,lAPE,lLOG)

local DBF_USO := alias()
local W

if valtype(lLOG) # "L"
   lLOG := .F.
endif

//Alay Bidimensional {{campos,..},{variaveis,..}}
if valtype(aLAY) # "A"
   ALERTX("GRAVALAY variavel aLAY, Nao ‚ uma Matriz")
   retu .F.
endif
if len(aLAY) = 0
   ALERTX("GRAVALAY Matriz aLAY Vazia")
   retu .F.
endif
if valtype(lOPE) # "L"
   lOPE := .F.
endif
if lOPE
   if !USEREDE(cARQ,1,99)
      retu .F.
   endif
endif
if valtype(cARQ) = "C" .and. !lOPE
   dbselectar(cARQ)
endif
if valtype(nIND) = "N"
   dbsetorder(nIND)
endif
if valtype(lAPE) # "L"
   lAPE := .F.
endif
if valtype(cBUS) # "U"
   dbgotop()
   if !dbseek(cBUS)
      if !lAPE
         if lOPE
            dbclosearea()
         endif
         if !empty(DBF_USO)
            sele &DBF_USO
         endif
         retu .F.
      else
         netrecapp()
      endif
   endif
else
   if lAPE
      netrecapp()
   endif
endif
netreclock()
GRAVACAMPO(aLAY[1],aLAY[2])
dbunlock()
dbcommit()
if lOPE
   dbclosearea()
endif
if !empty(DBF_USO)
   dbselectar(DBF_USO)
endif
retu .T.

