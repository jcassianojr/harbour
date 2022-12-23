*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib.prg
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
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function REPORVARS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func REPORVARS(cARQ,eBUSCA)   // PARAMETRO ARQUIVO, E CHAVE DE BUSCA


RETORNO := .F.
if !USEREDE(cARQ,1,99)
   retu .F.
endif
dbgotop()
if dbseek(eBUSCA)
   KEY := 0
   while !dbrlock(recno()) .and. KEY # 27
      KEY := inkey(0.5)
   enddo
   if KEY # 27
      REPLVARS()  // Funcao da Develop.Lib
      RETORNO := .T.
   endif
endif
dbunlock()
dbcommit()
dbclosearea()
if !RETORNO
   ALERTX("N„o encontrei o registro")
endif
gravalog(eBUSCA,"ALT",cARQ)
retu RETORNO


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IGUALVARS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func IGUALVARS(cARQ,eBUSCA,nIND,lMES)   // PARAMETRO ARQUIVO, E CHAVE DE BUSCA


RETORNO := .F.
if valtype(nIND) # "N"
   nIND := 1
endif
if valtype(lMES) # "L"
   lMES := .T.
endif

if !USEREDE(cARQ,1,nIND)
   retu .F.
endif
dbgotop()
if dbseek(eBUSCA)
   EQUVARS()
   RETORNO := .T.
endif
dbunlock()
dbcommit()
dbclosearea()
if !RETORNO .AND. lMES
   ALERTX("N„o encontrei o registro")
endif
retu RETORNO


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NUMIND()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func NUMIND(cARQ,nPOS)


local nIND    := 1
local aNUMIND := {}
local mDBF    := alias()
set color to
if valtype(nPOS) # "N"
   nPOS := 1
endif
nPOS := if(nPOS = 0,1,nPOS)
if !USEREDE(zARQ1,1,1)
   retu 1
endif
dbseek(padr(cARQ,8)+str(1,2))
while ARQUIVO = padr(cARQ,8) .and. !eof()
   aadd(aNUMIND,DESC)
   dbskip()
enddo
dbclosearea()
if len(aNUMIND) = 0
   retu 1
endif
nPOS := if(nPOS > len(aNUMIND),1,nPOS)
nIND := ESCARR(aNUMIND,4,5,24 - 3,63,nPOS,"Escolha a Ordem Desejada")
nIND := if(nIND > 0,nIND,1)
if !empty(mDBF)
   dbselectar(mDBF)
endif
retu nIND


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NUMFIL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func NUMFIL(nPOS)


local nFIL := 1
aNUMFIL := {"1 - Filtro Padr„o ","2 - Condicional Fixo ",;
 "3 - Filtro Busca ","4 - Condicional Filtro",;
 "5 - Condicional Localizar"}
if valtype(nPOS) # "N"
   nPOS := 1
endif
nPOS := if(nPOS = 0 .or. nPOS > 4,1,nPOS)
nPOS := if(nPOS > len(aNUMFIL),1,nPOS)
nFIL := ESCARR(aNUMFIL,4,5,24 - 3,63,nPOS,"Escolha o Filtro Desejado")
nFIL := if(nFIL > 0,nFIL,1)
retu nFIL


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function RFILTRO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func RFILTRO(FILTRO,DEFA)


local pCOR  := setcolor()
local pTELA := savescreen(8,0,24,79)
setcolor('N/W,'+zCOR002)
HB_dispbox(8,45,10,75,B_DOUBLE,'W')
@  9,48 say "Escolha o grupo de dados"         
HB_dispbox(12,45,22,75,B_DOUBLE,'W')
@ 13,46 say " Ande com as setas. Quando a"         
@ 14,46 say " op‡„o  desejada estiver  em"         
@ 15,46 say " destaque tecle         .   "         
@ 16,46 say " Forne‡a o grupo  de  dados "         
@ 17,46 say " dando os limites iniciais e"         
@ 18,46 say " finais do grupo.           "         
@ 20,46 say " Tecle     para encerrar.   "         
setcolor("R/W")
@ 15,63 say "<Enter>"         
@ 20,53 say "ESC"             
setcolor('N/W,'+zCOR002)
if pcount() = 0
   FILTRO := ''
   defa   := 1
elseif pcount() = 1
   defa := 1
endif
while .T.
   DFILTRO(FILTRO)
   defa := RCAMPO(DEFA)
   if defa = 0
      exit
   endif
   XCTR1 := XCTR2 := MAKEVAR(aESTRU[DEFA,2],aESTRU[DEFA,3],aESTRU[DEFA,4])
   XCTR3 := "E"
   XCTR5 := ">="
   TELAG := savescreen(08,16,24,79)
   @ 08,16 clea to 24,79
   HB_dispbox(08,17,23,79,B_DOUBLE)
   @ 09,20 say "Forne‡a os Limites inicial e Final do(a)"         
   @ 10,20 say dESTRU[DEFA]                                       
   @ 11,17 say '+'+repl('-',61)+'Ý'                               
   @ 12,20 say 'Do '                                              
   @ 13,17 say '+'+repl('-',61)+'Ý'                               
   @ 14,20 say 'Ao '                                              
   @ 15,17 say '+'+repl('-',61)+'Ý'                               
   @ 16,20 say '(E) (O)u (B)ranco (M)anual'                       
   @ 17,20 say "Opera‡ao: >= <= <> > <"                           
   set key K_ESC to NOBREAK
   @ 12,23 get XCTR1                                                                                        
   @ 14,23 get XCTR2                                                                                        
   @ 16,50 get XCTR3 valid XCTR3 $ "EOBM"                                                                   
   @ 17,50 get XCTR5 valid trim(XCTR5) $ "<>=" .or. XCTR5 = ">=" .or. XCTR5 = "<=" .or. xCTR5 = "<>"        
   READCUR()
   if XCTR3 = "M"
      FILTRO += space(80)
      @ 24,00 get FILTRO pict "@S78"        
      READCUR()
      FILTRO := alltrim(FILTRO)
   endif
   set key K_ESC to
   restscreen(08,16,24,79,TELAG)
   do case
      case aESTRU[DEFA,2] = "C"
         XCTR1A := '"'+alltrim(XCTR1)+'"'
         XCTR2A := '"'+alltrim(XCTR2)+'"'
      case aESTRU[DEFA,2] = "D"
         XCTR1A := 'CTOD('+'"'+dtoc(XCTR1)+'"'+')'
         XCTR2A := 'CTOD('+'"'+dtoc(XCTR2)+'"'+')'
      case aESTRU[DEFA,2] = "N"
         XCTR1A := alltrim(str(XCTR1,aESTRU[DEFA,3],aESTRU[DEFA,4]))
         XCTR2A := alltrim(str(XCTR2,aESTRU[DEFA,3],aESTRU[DEFA,4]))
   endcase
   if !empty(XCTR1) .or. !empty(XCTR2) .or. XCTR3 = "B"
      XCTR4 := ".AND."
      if XCTR3 = "O"
         XCTR4 := ".OR."
      endif
      if !empty(XCTR2)
         XCTR6 := "<="
         if XCTR5 = "> "
            XCTR6 := "<"
         endif
         FILTRO += if(empty(FILTRO),"",XCTR4)+"("+alltrim(aESTRU[DEFA,1])+XCTR5+XCTR1A+'.AND.'+alltrim(aESTRU[DEFA,1])+XCTR6+XCTR2A+")"
      else
         FILTRO += if(empty(FILTRO),"",XCTR4)+"("+alltrim(aESTRU[DEFA,1])+XCTR5+XCTR1A+")"
      endif
   endif
enddo
restscreen(8,0,24,79,pTELA)
set key K_ALT_F to
set key K_ALT_G to
setcolor(pCOR)
retu FILTRO


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function RFILORD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func RFILORD


para ARQWORK,lTIPO,FILTRO,nDEFA
priv pCOR   := setcolor()
priv FECHAR := .F.
priv DBF    := alias()
if valtype(lTIPO) # "L"
   lTIPO := .T.
endif
if valtype(FILTRO) # "C"
   FILTRO := ""
endif
if valtype(nDEFA) # "N"
   nDEFA := 1
endif
//Pegando a Estrutura
if select (ARQWORK) = 0
   if !USEREDE(ARQWORK,1,0)
      retu FILTRO
   endif
   FECHAR := .T.
else
   dbselectar(ARQWORK)
endif
aESTRU := dbstruct()
if FECHAR
   dbclosearea()
endif
pESTRU := len(aESTRU)
dESTRU := array(pESTRU)
//Pegando os Coment rios
if !USEREDE(HELPARQ,1,1)
   retu FILTRO
endif
for X := 1 to pESTRU
   dbgotop()
   if dbseek(padr(ARQWORK,8)+"M"+padr(aESTRU[X,1],9))
      if !empty(DADO)
         dESTRU[X] = DADO
      else
         dESTRU[X] = padr(aESTRU[X,1],10)
      endif
   else
      dESTRU[X] = padr(aESTRU[X,1],10)
   endif
next X
dbclosearea()
if lTIPO
   //Escolhendo Ordem
   ORD_SCR := savescreen(5,0,24,79)
   setcolor('N/W,'+zCOR002)
   HB_dispbox(5,45,10,76,B_DOUBLE,'W')
   @ 09,46 say "Escolha a ordem da Listagem"         
   HB_dispbox(12,45,22,76,B_DOUBLE,'W')
   @ 13,46 say " Ande com as setas:"              
   @ 15,46 say " Quando a op‡„o desejada"         
   @ 16,46 say " estiver  em  destaque"           
   @ 17,46 say " tecle         ."                 
   setcolor("R/W")
   @ 17,54 say "<Enter>"         
   setcolor('N/W,'+zCOR002)
   set key K_ESC to NOBREAK
   defa := RCAMPO(DEFA,nDEFA)
   set key K_ESC to
   INX := if(DEFA # 0,aESTRU[DEFA,1],aESTRU[1,1])
   restscreen(5,0,24,79,ORD_SCR)
endif
//Escolhendo o Filtro
FILTRO := RFILTRO(FILTRO,nDEFA)
setcolor(pCOR)
if !empty(DBF)
   dbselectar(DBF)
endif
retu FILTRO


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function RCAMPO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func RCAMPO(nINIPOS)


if valtype(nINIPOS) # "N"
   nINIPOS := 1
endif
retu ESCARR(dESTRU,8,0,min(pESTRU+11,24 - 1),43,nINIPOS)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function DFILTRO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func DFILTRO(TFILTRO)


TFILTRO := strtran(TFILTRO,".AND."," E ")
TFILTRO := strtran(TFILTRO,".OR."," OU ")
TFILTRO := strtran(TFILTRO,"MONTH","MES")
TFILTRO := strtran(TFILTRO,"YEAR","ANO")
TFILTRO := strtran(TFILTRO,"EMPTY","SEM")
TFILTRO := strtran(TFILTRO,"DTOC","DIA")
TFILTRO := strtran(TFILTRO,"!"," NAO ")
MDS(TFILTRO)
retu TFILTRO


*+--------------------------------------------------------------------
*+
*+    Function OBTER() estq funcao e diferente da obter dos modulos folha
*+
*+--------------------------------------------------------------------
*+
func OBTER(cARQ,KEYINDEX,cCAMPO,nIND,nROW,nCOL,cMES,cMES2,cDEF)   //SEEK MAIS RETORNO CAMPO


local cDBF   := alias()
local FECHAR := .F.
local cRETU  := ""
if valtype(nIND) # "N"
   nIND := 1
endif
if valtype(cDEF) # "U"
   cRETU := cDEF
endif
if select (cARQ) = 0
   if !USEREDE(cARQ,1,nIND)
      retu cRETU
   endif
   FECHAR := .T.
else
   dbselectar(cARQ)
   if nIND > 1
      dbsetorder(nIND)
   endif
endif
dbgotop()
if dbseek(keyindex)
   cRETU := &cCAMPO.
else
   if valtype(cDEF) = "U"
      cRETU := MAKE_EMPTY(cCAMPO)
   endif
endif
if valtype(nROW) = "N"
   if !empty(cRETU)
      @ nROW,nCOL say &cMES.         
   else
      @ nROW,nCOL say &cMES2.         
   endif
endif
if FECHAR
   dbclosearea()
endif
if !empty(cDBF)
   dbselectar(cDBF)
endif
retu cRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MUDADATA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MUDADATA(cPRG,nLIN,cVAR)


priv GETLIST := {}
if type("ZDATA") # 'D'
   ZDATA := DXDIA
endif
MDS("Digite a Data Operacional")
@ 24,40 get ZDATA         
READCUR()
ZDIA := day(ZDATA)
ZMES := month(ZDATA)
ZANO := year(ZDATA)
if cPRG = "READCUR"
   setcursor(if(readinsert(),1,2))
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CONFIND()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CONFIND(cARQ)


aIND := {}
if !USEREDE(zARQ1,1,1)
   ALERTX("N„o Consegui Pegar Configura‡„o de Busca")
   retu .F.
endif
dbgotop()
if !dbseek(padr(cARQ,8)+str(1,2))
   dbclosearea()
   ALERTX("N„o Encontrei Configura‡„o de Busca")
   retu .F.
endif
while padr(cARQ,8) = ARQUIVO .and. !eof()
   aadd(aIND,{{LIN1,COL1,VAR1,DES1},{LIN2,COL2,VAR2,DES2},{LIN3,COL3,VAR3,DES3},FORMULA})
   dbskip()
enddo
dbclosearea()
if len(aIND) = 0
   ALERTX("Falta Configura‡„o de Busca")
   retu .F.
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MONTATAB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MONTATAB(cNOMETAB,cNOMEARR1,cNOMEARR2,cSTR1,cSTR2)


aUM := {}
aDO := {}
if !USEREDE("MD02",1,1)
   retu .T.
endif
GRAF  := lastrec()
xGRAF := 0
xPOS  := 1
MARCAR()
dbgotop()
dbseek(padr(cNOMETAB,12))
while CODIGO = cNOMETAB .and. !eof()
   if valtype(cSTR1) # "C"
      aadd(aUM,CODIGO1+' '+DESCRICAO)
   else
      aadd(aUM,&cSTR1.)
   endif
   if valtype(cSTR2) # "C"
      aadd(aDO,CODIGO1)
   else
      aadd(aDO,&cSTR2.)
   endif
   xPOS ++
   MARCAR1()
   dbskip()
enddo
dbclosearea()
&cNOMEARR1. := aclone(aUM)
&cNOMEARR2. := aclone(aDO)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IMP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func IMP(cCOD,cIMP)


local cCODRET := ""
local DBF_USO := alias()
if valtype(cIMP) # "C"
   cIMP := ZIMPPAD
endif
if !USEREDE("CODIMP",1,1)
   if !empty(DBF_USO)
      sele &DBF_USO
   endif
   retu ""
endif
dbgotop()
if dbseek(padr(cCOD,6)+cIMP)
   cCODRET := CONTEUDO
endif
dbclosearea()
if !empty(DBF_USO)
   sele &DBF_USO
endif
if !empty(cCODRET)
   cCODRET := &cCODRET.
   if type("nTIPSPO") # "U" .and. (nTIPSPO = 1 .or. nTIPSPO > 5)
      cCODRET := RANGEREPL(chr(0),chr(31),cCODRET,"")
   endif
   if at("CHR(",cCODRET) > 0
      if nTIPSPO = 1 .or. nTIPSPO > 5   //video txt txtwin rtf html pdf
         cCODRET := ""
      endif
   endif
   cCODRET := alltrim(cCODRET)
endif
retu cCODRET


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKCC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKCC(cEXP,cARQ,cVAR,lVAZIO)


local lRETU  := .F.
local nBUSCA
priv lCONVCC := .F.
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.
endif
if valtype(lVAZIO) # "L"
   lVAZIO := .T.
endif
if valtype(cARQ) # "C"
   cARQ := "MI01"
endif
if valtype(cEXP) # "C"
   cEXP := "mCTACONTB"
endif
nBUSCA := &cEXP.
if empty(nBUSCA)
   MDS("Conta n„o Digitada")
   retu .T.
endif
if ZLANC = 1
   if valtype(nBUSCA) = "C"
      nBUSCA  := val(nBUSCA)
      lCONVCC := .T.
   endif
else
   nBUSCA := alltrim(strtran(nBUSCA,".",""))
endif
lRETU := CHECKEXI(cARQ,cEXP,"CONTA+' '+NOME","IF(ZLANC=0,CONTA,IF(lCONVCC,PADR(ALLTRIM(STR(NUMERO)),12),NUMERO))","MAI001",lVAZIO,,,if(ZLANC = 0,1,2))
if lRETU .and. ZLANC = 1 .and. valtype(cVAR) = "C"  //Reduzida Traz Conta
   &cVAR. := OBTER(cARQ,nBUSCA,"CONTA",2)
endif
if lRETU .and. ZLANC = 0 .and. valtype(cVAR) = "C"  //Normal Tras Reduzida
   &cVAR. := OBTER(cARQ,nBUSCA,"NUMERO",1)
endif
retu lRETU

