*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib29.prg
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
*+    Function USEREDE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func USEREDE(cARQ,nMOD,nIND,cARE,lMES,nTIME)  //Arquivo,Modo,Indices,Area


local cARQDIR := ""
local aARQIND := {}
priv X
IF VALTYPE(lMES) # "L"
   lMES := .T.
ENDIF
if valtype(cARQ) # "C"
   @ 24,00
   @ 24,00 say "Arquivo"                     
   @ 24,10 say cARQ                          
   @ 24,50 say "Tipo:"+valtype(cARQ)         
   ALERTX("Fun‡„o USEREDE, Nome do Arquivo n„o ‚ Caracter")
   retu .F.
endif
if valtype(nMOD) # "N"
   ALERTX("Fun‡„o USEREDE, Modo de Abertura n„o ‚ Num‚rico")
   retu .F.
endif
if nMOD < 0 .or. nMOD > 1   //0-Exclusivo 1-Compartilhado
   ALERTX("Fun‡„o USEREDE, Modo de Abertura fora de parametro")
   retu .F.
endif
if valtype(nIND) # "N"  //0-Nenhum n-Especifico 99-Todos
   ALERTX("Fun‡„o USEREDE, Indices n„o ‚ Num‚rico")
   retu .F.
endif
if pcount() = 4
   if valtype(cARE) # "C"
      ALERTX("Fun‡„o USEREDE, Area n„o ‚ Caracter")
      retu .F.
   endif
endif
//Abrindo o Arquivo de Configura‡„o do Arquivo
if !USECHK(ZDIRC+ZARQ,ZDIRC+ZARQ,.T.)
   retu .F.
endif
dbgotop()
if !dbseek(cARQ)
   dbclosearea()
   IF lMES
      ALERTX("Falta configura‡„o do Arquivo de Dados "+cARQ)
   ENDIF
   retu .F.
endif

//Carrega o Diret¢rio do Arquivo
cARQDIR := LOCALARQ(PADRAO,CAMINHO)

//Carrega o Driver
cDRIVER := DRIVER
dbclosearea()
if empty(cDRIVER)
   cDRIVER := "DBFNTX"
endif
//Verifica a existencia do Arquivo
if ! file(cARQDIR+cARQ+".DBF")
   ALERTX("O Sistema n„o Encontrou o Arquivo "+cARQ)
   retu .F.
endif
//Carrega Indices
if nIND > 0
   if cDRIVER = "DBFCDX"
      aadd(aARQIND,cARQ)  //Mesmo Nome do Arquivo
   else
      //Abrindo o Arquivo de Configura‡„o de Indexacao
      if !USECHK(ZDIRC+ZARQ1,ZDIRC+ZARQ1,.T.)
         retu .F.
      endif
      dbgotop()
      if nIND = 99
         if !dbseek(padr(cARQ,8)+str(1,2))
            dbclosearea()
            ALERTX("Falta configura‡„o Indexacao "+cARQ+str(1,2))
            retu .F.
         endif
         while padr(cARQ,8) = ARQUIVO .and. !eof()
            aadd(aARQIND,INDICE)
            dbskip()
         enddo
      else
         if !dbseek(padr(cARQ,8)+str(nIND,2))
            dbclosearea()
            ALERTX("Falta configura‡„o Indexacao "+cARQ+str(nIND,2))
            retu .F.
         endif
         aadd(aARQIND,INDICE)
      endif
      dbclosearea()
   endif
endif
//Verifica a Existencia dos Indices
if nIND > 0
   for X := 1 to len(aARQIND)
      if ! file(cARQDIR+aARQIND[X]+if(cDRIVER = "DBFCDX",".CDX",".NTX"))
         ALERTX("Falta arquivo de Indice: "+aARQIND[X]+" de "+cARQ)
         IF MDG("Indexar "+cARQ)
            M_DB("ARQUIVO='"+cARQ+"'")
         ENDIF
         retu .F.
      endif
   next X
endif
//Inicia Abertura dos Arquivos
if select (cARQ) # 0  //Evita Reabertura
   dbselectar(cARQ)
   dbclosearea()
endif
while .T.
   lNEW := .T.
   if valtype(cARE) = "C"
      sele (cARE)
      lNEW := .F.
   endif
   lSHARE := if(nMOD = 1,.T.,.F.)
   if useCHK(cARQDIR+cARQ,,lSHARE,cDRIVER,lNEW,nTIME)
      exit
   endif
enddo
if nIND = 0
   retu .T.
endif
for X := 1 to len(aARQIND)
   while .T.
      if cDRIVER = "DBFCDX"
         ordlistadd(cARQDIR+aARQIND[X])
      else
         dbsetindex(cARQDIR+aARQIND[X])
      endif
      if !neterr()
         exit
      endif
      KEY := inkey(.5)
      if KEY = K_ESC
         dbclosearea()
         retu .F.
      endif
      MDS("N„o Estou Conseguindo Abrir indice "+aARQIND[X])
   enddo
next X
if cDRIVER = "DBFCDX" .and. nIND # 99
   dbsetorder(nIND)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function USECHK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func USECHK(cARQ,cIND,lSHA,cDRIVER,lNEW,nTIME)


if valtype(cDRIVER) # "C" .or. empty(cDRIVER)
   cDRIVER := IF(cRDDEXT = "CDX","DBFCDX","DBFNTX")
else
   cDRIVER := ALLTRIm(cDRIVER)
endif
if valtype(lNEW) # "L"
   lNEW := .T.
endif
if valtype(nTIME) # "N"
   nTIME := - 1
ENDIF
if ! file(cARQ+".DBF")
   ALERTX("Falta Arquivo: "+Carq)
   retu .F.
endif
while .t.
   //  DBUSEAREA( [<lNewArea>], [<cDriver>], <cName>, [<xcAlias>],[<lShared>], [<lReadonly>])
   //dbusearea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )

   dbusearea(lNEW,cDRIVER,cARQ,,lSHA,.F.)
   if !neterr()
      exit
   endif
   IF nTIME > 0
      nTIME := nTIME - 1
   ENDIF
   IF nTIME = 0
      RETU .F.
   ENDIF
   //-1 nao faz nada
   IF nTIME = - 2
      if !MDG("Deseja Retentar")
         retu .f.
      endif
   ENDIF
   MDS("N„o Estou Conseguindo Abrir aquivo "+cARQ)
   KEY := inkey(1)
   if KEY = K_ESC
      retu .F.
   endif
enddo
if valtype(cIND) = "C"
   if cDRIVER = "DBFCDX"
      ordlistadd(cIND)
   else
      dbsetindex(cIND)
   endif
endif

retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function LOCALARQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC LOCALARQ(cPADRAO,cCAMINHO)

cARQDIR := ZDIRP
do case
   case cPADRAO = 'S'
      cARQDIR := ZDIRE
   case cPADRAO = 'N'
      cARQDIR := ZDIRP
   case cPADRAO = 'C'
      cARQDIR := ZDIRC
   case cPADRAO = 'I'
      cARQDIR := ZDIRI
   case cPADRAO = 'A'
      cARQDIR := ZDIRA
   case cPADRAO = 'B'
      cARQDIR := ZDIRB
   case cPADRAO = "X"
      cARQDIR := alltrim(cCAMINHO)
   otherwise
      cARQDIR := ZDIRP
endcase
retu cARQDIR

