*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib38.prg
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
//#INCLUDE "COMANDO.CH"



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FIXAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FIXAR(P01,lINDEX)


local cDBF := alias()
if valtype(lINDEX) # "L"
   lINDEX := .T.
endif
while .T.
   if USEREDE(P01,0,if(lINDEX,99,0))
      MDS("Reorganizando arquivo, por favor aguarde..."+P01)
      pack
      dbgotop()
      dbclosearea()
      RES := .T.
      exit
   else
      RES := .F.
      MDS("Tentando reorganizar arquivo ... (F2 desiste)")
      KEY := inkey(2)
      if KEY = K_F2 .or. KEY = K_ESC
         GRAVALOG("Funcao Fixar - Usado Esc")
         exit
      endif
   endif
enddo
dbclosearea()
if !empty(cDBF)
   dbselectar(cDBF)
endif
retu RES


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVALOG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func GRAVALOG


para cERRO,cOPR,cARQ
local cDBF := alias()
if valtype(cERRO) = "U"
   cERRO := ""
endif
if valtype(cOPR) = "U"
   cOPR := ""
endif
if valtype(cARQ) = "U"
   cARQ := alias()
endif
if cARQ = "MANARQ" .or. cARQ = "MANARQ1" .or. cARQ = ZARQERR .or. left(cARQ,5) = "MUSER"
   retu .T.
endif
cARQ  := alltrim(cARQ)
cARQ  := strtran(cARQ," ","")
cERRO := alltrim(STRVAL(cERRO))
cERRO := strtran(cERRO," ","")
GRAVALAY({{"USUARIO","DATA","HORA","ERRO","ARQUIVO","OPR"},{"ZUSER","DATE()","LEFT(TIME(),5)","cERRO","cARQ","cOPR"}},ZARQERR,,.T.,,.T.,)
if !empty(cDBF)
   dbselectar(cDBF)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function pegdiaerro()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func pegdiaerro

mDATA := ZDATA
@ 24,00 GET mDATA         
READCUR()
retu "ER"+strzero(day(mDATA),2)+strzero(month(mDATA),2)+substr(strzero(year(mDATA),4),3,2)

