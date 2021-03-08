*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib26.prg
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
*+    Function CONFARQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CONFARQ(cARQ,eCAB,eEXI)

while .T.
   IF useCHK(ZDIRC+ZARQ,ZDIRC+ZARQ,.T.)
      exit
   ELSE
      RETU .F.
   endif
enddo
dbgotop()
IF !dbseek(cARQ)
   dbclosearea()
   ALERTX("Falta configura‡„o do Arquivo de Dados "+cARQ)
   lFIXA := .T.
   // nACHO := 999999 //4096 harbour sem limiete array
   cVIDE := 'N'
   lPBUS := .F.
   lPIND := .F.
   mCBAR := ""
   cTIPG := "1"
   cCBAS := ""
   nIBUS := 1
   nIEXI := 1
   retu .F.
endif
lFIXA := if(FIXAR = 'S',.T.,.F.)
//nACHO := LACHI
//IF nACHO=0
//   nACHO:=  999999 //4096 harbour sem limiete array
//ENDIF
nACHO := 999999   //4096 harbour sem limiete array
cVIDE := VIDEO
lPBUS := if(PBUS = 'S',.T.,.F.)
lPIND := if(PIND = 'S',.T.,.F.)
mCBAR := cBAR
cTIPG := TIPG
cCBAS := CBAS
nIBUS := if(!lPBUS .and. IBUS > 0,IBUS,1)
nIEXI := if(!lPIND .and. IEXI > 0,IEXI,1)
dbclosearea()
if empty(cCBAS) .and. valtype(eCAB) = "C"
   cCBAS := eCAB
endif
if empty(mCBAR) .and. valtype(eEXI) = "C"
   mCBAR := eEXI
endif
mCBARM := mCBAR
mCBAR  := strtran(mCBAR,"m","")
if cTIPG = "3"
   PEGAGET(cARQ)
endif
retu .T.

