*+--------------------------------------------------------------------
*+
*+    Programa  : mlib29.prg
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2021, Jorge Cassiano
*+
*+    Documentado em 13/03/2021
*+
*+--------------------------------------------------------------------
*+


//Teclas Operacionais
#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+    Function USEREDE(cARQ,nMOD,nIND,cARE,lMES,nTIME)  //Arquivo,Modo //0-Exclusivo 1-Compartilhado,Indices,Area,mensagem,tempo
*+
*+--------------------------------------------------------------------
*+
funcTION USEREDE(cARQ,nMOD,nIND,cARE,lMES,nTIME)  //Arquivo,Modo,Indices,Area,mensagem,tempo
local cARQDIR := ""
local aARQIND := {}
private X
IF VALTYPE(lMES) # "L"
   lMES := .T.
ENDIF
if valtype(cARQ) # "C"
   @ 24,00
   @ 24,00 say "Arquivo"                     
   @ 24,10 say cARQ                          
   @ 24,50 say "Tipo:"+valtype(cARQ)         
   ALERTX("Funcao USEREDE, Nome do Arquivo nao e Caracter")
   return .F.
endif
cARQ:=UPPER(CARQ)
cARQ:=STRTRAN(cARQ,".DBF","")
if valtype(nMOD) # "N"
   ALERTX("Funcao USEREDE, Modo de Abertura nao e Numerico")
   return .F.
endif
if nMOD < 0 .or. nMOD > 1   //0-Exclusivo 1-Compartilhado
   ALERTX("Funcao USEREDE, Modo de Abertura fora de parametro")
   return .F.
endif
if valtype(nIND) # "N"  //0-Nenhum n-Especifico 99-Todos
   ALERTX("Funcao USEREDE, Indices nao e Numerico")
   return .F.
endif
if pcount() = 4
   if valtype(cARE) # "C"
      ALERTX("Funcao USEREDE, Area nao e Caracter")
      return .F.
   endif
endif
//Abrindo o Arquivo de Configura‡„o do Arquivo
if ! USECHK(ZDIRC+ZARQ,ZDIRC+ZARQ,.T.)
   return .F.
endif
dbgotop()
if ! dbseek(cARQ)
   dbclosearea()
   IF lMES
      ALERTX("Falta configuracao do Arquivo de Dados "+cARQ)
   ENDIF
   return .F.
endif

//Carrega o Diret¢rio do Arquivo
cARQDIR := LOCALARQ(PADRAO,CAMINHO)

//Carrega o Driver
cDRIVER := DRIVER
dbclosearea()
if empty(cDRIVER)
   cDRIVER := "DBFCDX"
endif
//Verifica a existencia do Arquivo
if ! file(cARQDIR+cARQ+".DBF")
   IF lMES
       ALERTX("O Sistema nAo Encontrou o Arquivo "+cARQ)
   ENDIF    
   retuRN .F.
endif
//Carrega Indices
if nIND > 0
   if cDRIVER = "DBFCDX"  //somente um elemento aARQIND com o mesmo nome do arquivo
      aadd(aARQIND,cARQ)  //Mesmo Nome do Arquivo
   else //ntx pega e adiciona na aarqind
      //Abrindo o Arquivo de Configura‡„o de Indexacao
      if ! USECHK(ZDIRC+ZARQ1,ZDIRC+ZARQ1,.T.)
         retuRN .F.
      endif
      dbgotop()
      if nIND = 99
         if ! dbseek(padr(cARQ,8)+str(1,2))
            dbclosearea()
            ALERTX("Falta configuracao Indexacao "+cARQ+str(1,2))
            return .F.
         endif
         while padr(cARQ,8) = ARQUIVO .and. !eof()
            aadd(aARQIND,INDICE)
            dbskip()
         enddo
      else
         if ! dbseek(padr(cARQ,8)+str(nIND,2))
            dbclosearea()
            ALERTX("Falta configuracao Indexacao "+cARQ+str(nIND,2))
            return .F.
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
         return .F.
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
   return .T.
endif
for X := 1 to len(aARQIND)
   while .T.
      if cDRIVER = "DBFCDX"
         ordlistadd(cARQDIR+aARQIND[X])
      else
         dbsetindex(cARQDIR+aARQIND[X])
      endif
      if ! neterr()
         exit
      endif
      KEY := inkey(.5)
      if KEY = K_ESC
         dbclosearea()
         return .F.
      endif
      MDS("Nao Estou Conseguindo Abrir indice "+aARQIND[X])
   enddo
next X
if cDRIVER = "DBFCDX" .and. nIND # 99
   dbsetorder(nIND)
endif
return .T.


*+--------------------------------------------------------------------
*+
*+    Function USECHK()
*+
*+--------------------------------------------------------------------
*+
function USECHK(cARQ,cIND,lSHA,cDRIVER,lNEW,nTIME,lMES)
IF VALTYPE(lMES)<>"L"
   lMES:=.T.
ENDIF
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
   return .F.
endif
while .t.
   //  DBUSEAREA( [<lNewArea>], [<cDriver>], <cName>, [<xcAlias>],[<lShared>], [<lReadonly>])
   //dbusearea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )

   dbusearea(lNEW,cDRIVER,cARQ,,lSHA,.F.)
   if ! neterr()
      exit
   endif
   IF nTIME > 0
      nTIME := nTIME - 1
   ENDIF
   IF nTIME = 0
      RETUrn .F.
   ENDIF
   //-1 nao faz nada
   IF nTIME = - 2
      if !MDG("Deseja Retentar")
         return .f.
      endif
   ENDIF
   MDS("Nao Estou Conseguindo Abrir aquivo "+cARQ)
   KEY := inkey(1)
   if KEY = K_ESC
      return .F.
   endif
enddo
if valtype(cIND) = "C"
   if cDRIVER = "DBFCDX"
      ordlistadd(cIND)
   else
      dbsetindex(cIND)
   endif
endif
return .T.


*+--------------------------------------------------------------------
*+
*+    Function LOCALARQ()
*+
*+--------------------------------------------------------------------
*+
FUNCtion LOCALARQ(cPADRAO,cCAMINHO)
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
return cARQDIR
