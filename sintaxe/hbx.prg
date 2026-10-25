*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : hbx.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 25-Out-2026 as  1:55 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "fileio.ch"

REQUEST DBFCDX
REQUEST HB_CODEPAGE_PTISO



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function main()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function main()


Set(_SET_CODEPAGE,"PTISO")
SetMode(25,80)
CLS
HB_IDLESTATE()
rddsetdefault("DBFCDX")
Set(_SET_OPTIMIZE,.t.)
Set(_SET_DELETED,.t.)
Set(_SET_SOFTSEEK,.t.)
__SetCentury(.t.)
Set(_SET_EPOCH,year(date()) - 60)
Set(_SET_DATEFORMAT,"dd/mm/yyyy")

cARQUIVO := "LIN"
dbusearea(.T.,"DBFCDX",cARQUIVO,,.f.)
ordlistadd(cARQUIVO)
dbsetorder(1)   //


//use lin excl
//index on comando to temp

//DELETE ALL FOR TIPO<>"F" .AND. ! EMPTY(TIPO)


//ler os hbx
dbselectar("lin")
IF FILE("harbour.hbx")
   FAZ01("harbour.hbx")   //padrao
ENDIF

IF FILE("RuntimeFunctions.csv")
   FAZ02("RuntimeFunctions.csv")  //xsharp doc
ENDIF


mDIRETORIO := ''
mArquivo   := '*.HBX'
mListaArq  := Directory(mDiretorio+mArquivo,"D")
nFIM       := Len(mListaArq)
For i := 1 to nFIM
   cARQUIVO := UPPER(mListaArq[i,1])
   faz01(cARQUIVO)
NEXT i

mDIRETORIO := ''
mArquivo   := '*.md'
mListaArq  := Directory(mDiretorio+mArquivo,"D")
nFIM       := Len(mListaArq)
For i := 1 to nFIM
   cARQUIVO := UPPER(mListaArq[i,1])
   faz04(cARQUIVO)
NEXT i


IF FILE("Harbour.acp")
   faz03("Harbour.acp")
ENDIF

mDIRETORIO := ''
mArquivo   := '*.TXT'   //Doc format harbour nas subpastas doc\en
mListaArq  := Directory(mDiretorio+mArquivo,"D")
nFIM       := Len(mListaArq)
For i := 1 to nFIM
   cARQUIVO := UPPER(mListaArq[i,1])
   faz05(cARQUIVO)
NEXT i



limpadup()

//gera o harbour.def
nGRV := FCREATE("harbour.def")  //pspad context diretorio _complementos(copia reserva e instalacao)
nGR2 := FCREATE("harbour.ini")  //pspad syntax diretorio  _complementos(copia reserva e instalacao)
nGR3 := FCREATE("fnc.ini")  //usado no click

//gravando harini
cUSO := MEMOREAD("harini.ini")
fwrite(nGR2,cUSO)

dbselectar("lin")
dbgotop()
while !eof()
   @ 24,00 say LIN->comando         
   //IF AT(" |F ",LIN->LINHA)>0
   //   aVALOR=HB_ATOKENS(ALLTRIM(LIN->LINHA),"|")
   //   LIN->TIPO:="F"
   //   IF LEN(aVALOR)>=3
   //      LIN->DESCRICAO:=aVALOR[3]
   //   ENDIF
   //   LIN->LINHA:=ALLTRIM(SUBSTR(aVALOR[2],3))
   //ENDIF
   if LIN->TIPO = "F"   //! empty(LIN->linha) .AND.
      //[Bin2w |F Bin2w(cIntSemSinal)|Converte um inteiro com sinal de 16 bits para um valor numerico]
      //[AAdd |F AAdd(<aTarget>, <expValue>) -> Value ]
      //AAdd(<aTarget>, <expValue>) -> Value
      cLINHA := "["
      cLINHA += ALLTRIM(TOKENUPPER(LOWER(LIN->COMANDO)))
      cLINHA += " |F "
      cLINHA += ALLTRIM(LIN->RETORNO)
      IF !EMPTY(LIN->DESCRICAO)
         cLINHA += "|"
         cLINHA += ALLTRIM(LIN->DESCRICAO)
      endif
      cLINHA += " ]"
      cLINHA += HB_OSNEWLINE()
      fwrite(ngrv,cLINHA)
      fwrite(ngrv,alltrim(LIN->retorno)+hb_osnewline())
      fwrite(ngrv,+hb_osnewline())
   endif
   fwrite(ngr2,alltrim(comando)+"="+hb_osnewline())
   if !empty(hbx)
      fwrite(ngr3,lower(alltrim(comando))+"="+strtran(upper(alltrim(hbx)),".HBX",".LIB")+hb_osnewline())
   endif
   dbskip()
enddo

if file("click.dbf") .and. file("click.cdx")
   cARQUIVO := "click"
   dbusearea(.T.,"DBFCDX",cARQUIVO,,.f.)
   ordlistadd(cARQUIVO)
   dbselectar("click")
   dbsetorder(0)  //ordem 0 pois era fazer replace na chave
   dbgotop()
   while !eof()
      @ maxrow(),00 say click->fnct         
      //click prescisa achar ex: hb_fopen mas no /update criou _hb_fopen
      if left(click->fnct,4) = "_hb_"
         click->fnct := substr(click->fnct,2)
      endif
      dbskip()
   enddo
   dbselectar("click")
   dbsetorder(1)
   dbgotop()
   while .not. eof()
      @ maxrow(),00 say click->fnct         
      cCOMANDO := upper(alltrim(click->fnct))
      cBUSCA2  := STRTRAN(cCOMANDO,"HB_FUN_","")  //ex hb_func_restscreen -->restscreen
      cBUSCA2  := TRATANOME(cBUSCA2)
      if left(cCOMANDO,1) <> "_"  //nao busca commando interno comecam com _
         dbselectarea("lin")
         dbgotop()
         IF .NOT. DBSEEK(cCOMANDO)
            DBGOTOP()
            IF .NOT. DBSEEK(cBUSCA2)
               DBAPPEND()
               LIN->COMANDO := cCOMANDO
               LIN->HBX     := hb_FNameName(click->srce)
            ENDIF
         ENDIF
      endif
      dbselectar("click")
      dbskip()
   enddo
endif

//gravando harfim
cUSO := MEMOREAD("harfim.ini")
fwrite(nGR2,cUSO)

//fechando .ini
fclose(nGRV)
fclose(nGR2)
fclose(nGR3)
dbcloseall()

geraxmlnotepad()
dbcloseall()



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function faz02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function faz02(cARQIMP)

@ 24,65 SAY cARQIMP         

nLASTREC := FLINECOUNT(cARQIMP)
//zei_fort( nLASTREC,,,0)


cDELIM   := FDELIM(cARQIMP,1024)  //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
nFILEuso := FOPEN(cARQIMP)  //abre o arquivo


DO WHILE .T.

   cLINHA := FREADLINE(nFILEuso,1024,.T.,cDELIM)  //FREADLINE (handle, line_len,lremchrexp,cDELI)
   IF cLINHA = '__FINAL__'  //freadline retorna __FINAL__   quando nao e mais linhas
      EXIT
   ENDIF
   @ 24,00 SAY left(cLINHA,60)         
   cLINHA := TRATANOME(cLINHA)
   //   altd()
   aLINHA := HB_ATokens(cLINHA,",")
   IF LEN(ALINHA) > 0
      cCOMANDO   := UPPER(aLINHA[2])
      cHBX       := hb_FNameName(LOWER(aLINHA[1]))
      cDESCRICAO := ""
      IF LEN(ALINHA) > 2
         cDESCRICAO := ALLTRIM(aLINHA[3])+IF(LEN(ALINHA) > 3 .AND. aLINHA[3] <> aLINHA[4]," "+aLINHA[4],"")+IF(LEN(ALINHA) > 4," "+aLINHA[5],"")
      ENDIF
      // IF LEN(ALINHA)>3
      //    cDESCRICAO:=cDESCRICAO+" "+ALLTRIM(aLINHA[4])
      // ENDIF
      //IF LEN(ALINHA)>4
      //   cDESCRICAO:=cDESCRICAO+" "+ALLTRIM(aLINHA[5])
      //ENDIF
      dbgotop()
      if !dbseek(cCOMANDO)
         dbappend()
         field->comando := cCOMANDO
      endif
      IF EMPTY(FIELD->HBX)
         FIELD->HBX := CHBX
      ENDIF
      IF EMPTY(FIELD->DESCRICAO)
         FIELD->DESCRICAO := cDESCRICAO
      ELSE
         FIELD->DESCRICAO := alltrim(FIELD->DESCRICAO)+" - "+cDESCRICAO
      ENDIF
   ENDIF
enddo
fclose(nFILEuso)  //fecha o arquivo
//ferase(cARQIMP)
return .t.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function faz01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function faz01(cARQIMP)

@ 24,65 SAY cARQIMP         

nLASTREC := FLINECOUNT(cARQIMP)
//zei_fort( nLASTREC,,,0)


cDELIM   := FDELIM(cARQIMP,1024)  //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
nFILEuso := FOPEN(cARQIMP)  //abre o arquivo


DO WHILE .T.

   cLINHA := FREADLINE(nFILEuso,1024,.T.,cDELIM)  //FREADLINE (handle, line_len,lremchrexp,cDELI)
   IF cLINHA = '__FINAL__'  //freadline retorna __FINAL__   quando nao e mais linhas
      EXIT
   ENDIF

   @ 24,00 SAY left(cLINHA,60)         
   if left(cLINHA,7) = "DYNAMIC"
      cLINHA := ALLTRIM(UPPER(SUBSTR(cLINHA,9)))
      cLINHA := TRATANOME(cLINHA)
      IF LEFT(cLINHA,1) <> "_"
         dbgotop()
         if !dbseek(cLINHA)
            dbappend()
            field->comando := UPPER(cLINHA)
         endif
         IF EMPTY(HBX)
            FIELD->HBX := hb_FNameName(lower(cARQIMP))

         ENDIF
         // IF EMPTY(COMPAD) //quando necessario usar ALLTRIM(TOKENUPPER(LOWER(LIN->COMANDO)))
         //   FIELD->COMPAD:=TOKENUPPER(LOWER(cLINHA))
         //ENDIF
      endif
   ENDIF
   // zei_fort(nLASTREC,,,1)
enddo
fclose(nFILEuso)  //fecha o arquivo
ferase(cARQIMP)
return .t.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function limpadup()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function limpadup()

dbgotop()
while !eof()
   cCOMANDO       := alltrim(LIN->COMANDO)
   FIELD->COMANDO := TRATANOME(cCOMANDO)
   IF AT (".",FIELD->HBX) > 0
      FIELD->HBX := HB_FNAMENAME(FIELD->HBX)
   ENDIF
   @ 24,00 SAY cCOMANDO         
   DBSKIP()
   WHILE alltrim(cCOMANDO) == alltrim(lIN->COMANDO) .AND. !EOF()
      IF alltrim(cCOMANDO) == alltrim(lIN->COMANDO)
         dbdelete()
      ENDIF
      DBSKIP()
   ENDDO
enddo
pack
return .t.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function faz04()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function faz04(cARQIMP)

@ 24,65 SAY cARQIMP         

nLASTREC := FLINECOUNT(cARQIMP)
//zei_fort( nLASTREC,,,0)


cDELIM   := FDELIM(cARQIMP,1024)  //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
nFILEuso := FOPEN(cARQIMP)  //abre o arquivo


DO WHILE .T.

   cLINHA := FREADLINE(nFILEuso,1024,.T.,cDELIM)  //FREADLINE (handle, line_len,lremchrexp,cDELI)
   IF cLINHA = '__FINAL__'  //freadline retorna __FINAL__   quando nao e mais linhas
      EXIT
   ENDIF
   @ 24,00 SAY left(cLINHA,60)         
   IF LEFT(cLINHA,3) = "| `"
      cLINHA := STRTRAN(cLINHA,"`","")
      cLINHA := STRTRAN(cLINHA,"`","")


      cLINHA := STRTRAN(cLINHA,"PHB_ITEM","")
      cLINHA := STRTRAN(cLINHA,"HB_SIZE *","")
      cLINHA := STRTRAN(cLINHA,"HB_USHORT","")
      cLINHA := STRTRAN(cLINHA,"char *","")
      cLINHA := STRTRAN(cLINHA,"static","")
      cLINHA := STRTRAN(cLINHA,"void *","")
      cLINHA := STRTRAN(cLINHA,"void*","")
      cLINHA := STRTRAN(cLINHA,"long *","")
      cLINHA := STRTRAN(cLINHA,"* pcode","")
      cLINHA := STRTRAN(cLINHA,"* pbuffer","")
      cLINHA := STRTRAN(cLINHA,"* plocalpostable","")
      cLINHA := STRTRAN(cLINHA,"* array","")
      cLINHA := STRTRAN(cLINHA,"* chunks","")
      cLINHA := STRTRAN(cLINHA,"* sizes","")
      cLINHA := STRTRAN(cLINHA,"*handler","")
      cLINHA := STRTRAN(cLINHA,"* puipos","")
      cLINHA := STRTRAN(cLINHA,"* plstptr","")
      cLINHA := STRTRAN(cLINHA,"* presult","")
      cLINHA := STRTRAN(cLINHA,"* pfvalue","")
      cLINHA := STRTRAN(cLINHA,"* pfuncs","")
      clINHA := STRTRAN(cLINHA,"* pfunc","")
      //cLINHA:=STRTRAN(cLINHA,"* plstptr","")
      //cLINHA:=STRTRAN(cLINHA,"* pfuncs","")


      //cLINHA:=STRTRAN(cLINHA," * s ","")

      cLINHA   := STRTRAN(cLINHA,"  ","")
      aVALORES := HB_ATokens(cLINHA,'|')
      // '| Function Name | Signature | Parameters | Description | Return Value |
      // alert(aVALORES[1])
      // alert()
      //
      // altd()
      cCOMANDO   := alltrim(aVALORES[2])
      cDESCRICAO := alLtrim(aVALORES[5])
      cRETORNO   := alltrim(aVALORES[3])+"->"+alltrim(aVALORES[6])
      //altd()


      cCOMANDO := TRATANOME(cCOMANDO)
      dbgotop()
      if !dbseek(cCOMANDO)
         dbappend()
         field->comando := UPPER(cCOMANDO)
      endif
      IF EMPTY(FIELD->HBX)
         FIELD->HBX := lower(cARQIMP)
      ENDIF
      IF EMPTY(FIELD->DESCRICAO)
         FIELD->DESCRICAO := lower(cDESCRICAO)
      ENDIF
      IF EMPTY(FIELD->RETORNO)
         FIELD->RETORNO := lower(cRETORNO)
      ENDIF


   ENDIF
enddo
fclose(nFILEuso)  //fecha o arquivo
ferase(cARQIMP)
return .t.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TRATANOME()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION TRATANOME(cVALOR)

cVALOR := RANGEREPL(Chr(0),Chr(31),cVALOR,"")
cVALOR := RANGEREPL(Chr(127),Chr(255),cVALOR,"")
cVALOR := AllTrim(cVALOR)
RETURN cVALOR




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function faz05()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function faz05(cARQIMP)

@ 24,65 SAY cARQIMP         

nLASTREC := FLINECOUNT(cARQIMP)
//zei_fort( nLASTREC,,,0)


cDELIM   := FDELIM(cARQIMP,1024)  //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
nFILEuso := FOPEN(cARQIMP)  //abre o arquivo

cCOMANDO   := ""
cRETORNO   := ""
cDESCRICAO := ""

/*
 $NAME$
      AdsBlob2File()
   $CATEGORY$
      Advantage Database RDD
   $ONELINER$
      Write a Binary (memo) field's contents to a file
   $SYNTAX$
      AdsBlob2File( <cFileName>, <cFieldName> ) --> lSuccess
*/

DO WHILE .T.

   cLINHA := FREADLINE(nFILEuso,1024,.T.,cDELIM)  //FREADLINE (handle, line_len,lremchrexp,cDELI)
   IF cLINHA = '__FINAL__'  //freadline retorna __FINAL__   quando nao e mais linhas
      EXIT
   ENDIF

   @ 24,00 SAY left(cLINHA,60)         
   cLINHA := ALLTRIM(cLINHA)
   IF cLINHA = "$NAME$"
      cLINHA     := FREADLINE(nFILEuso,1024,.T.,cDELIM)
      cCOMANDO   := ALLTRIM(UPPER(cLINHA))
      cCOMANDO   := STRTRAN(cCOMANDO,"(","")
      cCOMANDO   := STRTRAN(cCOMANDO,")","")
      cCOMANDO   := STRTRAN(cCOMANDO,"*","")
      cRETORNO   := ""
      cDESCRICAO := ""

   ENDIF
   IF cLINHA = "$ONELINER$"
      cLINHA     := FREADLINE(nFILEuso,1024,.T.,cDELIM)
      cDESCRICAO := ALLTRIM(cLINHA)
   ENDIF
   IF cLINHA = "$SYNTAX$"
      cLINHA   := FREADLINE(nFILEuso,1024,.T.,cDELIM)
      cRETORNO := ALLTRIM(cLINHA)
      dbgotop()
      if !dbseek(cCOMANDO)
         dbappend()
         field->comando := cCOMANDO
      endif
      if empty(field->DESCRICAO)
         field->DESCRICAO := cDESCRICAO
      endif
      if empty(field->RETORNO)
         field->RETORNO := cRETORNO
      endif
      cCOMANDO   := ""
      cRETORNO   := ""
      cDESCRICAO := ""
   ENDIF
enddo
fclose(nFILEuso)  //fecha o arquivo
ferase(cARQIMP)
return .t.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function faz03()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function faz03(cARQIMP)

@ 24,65 SAY cARQIMP         

nLASTREC := FLINECOUNT(cARQIMP)


cDELIM   := FDELIM(cARQIMP,1024)  //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
nFILEuso := FOPEN(cARQIMP)  //abre o arquivo

cCOMANDO   := ""
cRETORNO   := ""
cDESCRICAO := ""

DO WHILE .T.

   cLINHA := FREADLINE(nFILEuso,1024,.T.,cDELIM)  //FREADLINE (handle, line_len,lremchrexp,cDELI)
   IF cLINHA = '__FINAL__'  //freadline retorna __FINAL__   quando nao e mais linhas
      EXIT
   ENDIF

   @ 24,00 SAY left(cLINHA,60)         
   lGRAVA     := .F.
   cTIPO      := ""
   cCOMANDO   := ""
   cDESCRICAO := ""
   cRETORNO   := ""
   aVALOR     := HB_ATOKENS(cLINHA,"|")

   DO CASE
   CASE AT ("Function",cLINHA) > 0  //Function AAdd( <aArray>[, <xValue>] ) --> Value | Dynamically add an element to an array
      cTIPO    := "F"
      cRETORNO := aVALOR[1]   //Function AAdd( <aArray>[, <xValue>] ) --> Value
      cRETORNO := STRTRAN(cRETORNO,"Function","")   //AAdd( <aArray>[, <xValue>] ) --> Value
      nPOS     := AT ("(",cRETORNO)
      IF nPOS > 0
         lGRAVA   := .T.
         cCOMANDO := SUBSTR(cRETORNO,1,nPOS - 1)  //AAdd
      ENDIF
      cDESCRICAO := aVALOR[2]
   CASE AT ("Procedure",cLINHA) > 0   //Procedure __Run( <cCommand> ) | Run an external program.
      //ALTD()
      cTIPO    := "P"
      cRETORNO := aVALOR[1]   //Procedure __Run( <cCommand> )
      cRETORNO := STRTRAN(cRETORNO,"Procedure","")  //__Run( <cCommand> )
      lGRAVA   := .T.
      cCOMANDO := cRETORNO
      nPOS     := AT ("(",cRETORNO)
      IF nPOS > 0
         cCOMANDO := SUBSTR(cRETORNO,1,nPOS - 1)  //__Run
      ENDIF
      cDESCRICAO := aVALOR[2]
   CASE AT ("Command",cLINHA) > 0   //Command AVERAGE        | Average numeric expressions in the current work area
      cTIPO      := "C"
      lGRAVA     := .T.
      cDESCRICAO := aVALOR[2]
      cCOMANDO   := aVALOR[1]
      cCOMANDO   := STRTRAN(cCOMANDO,"Command","")
   CASE AT ("Keyword",cLINHA) > 0   //Keyword static
      cTIPO    := "K"
      lGRAVA   := .T.
      cCOMANDO := aVALOR[1]
      cCOMANDO := STRTRAN(cCOMANDO,"Keyword","")
   CASE AT ("Preprocessor",cLINHA) > 0  //Preprocessor #define |define macrodefinition
      cTIPO      := "#"
      lGRAVA     := .T.
      cDESCRICAO := aVALOR[2]
      cCOMANDO   := aVALOR[1]
      cCOMANDO   := STRTRAN(cCOMANDO,"Preprocessor","")
   ENDCASE
   if lGRAVA
      cDESCRICAO := ALLTRIM(cDESCRICAO)
      cCOMANDO   := UPPER(ALLTRIM(CCOMANDO))
      cCOMANDO   := STRTRAN(cCOMANDO,"*","")
      cCOMANDO   := TRATANOME(cCOMANDO)
      dbgotop()
      if !dbseek(cCOMANDO)
         dbappend()
         field->comando := cCOMANDO
      endif
      IF empty(LIN->TIPO) .AND. !EMPTY(cTIPO)
         LIN->TIPO := cTIPO
      ENDIF
      IF empty(LIN->DESCRICAO) .AND. !EMPTY(cDESCRICAO)
         LIN->DESCRICAO := cDESCRICAO
      ENDIF
      IF empty(LIN->RETORNO) .AND. !EMPTY(cRETORNO)
         LIN->RETORNO := cRETORNO
      ENDIF
   ENDIF
enddo
fclose(nFILEuso)  //fecha o arquivo
ferase(cARQIMP)
return .t.


*+--------------------------------------------------------------------
*+
*+    Function geraxmlnotepad()
*+
*+--------------------------------------------------------------------
FUNCTION geraxmlnotepad()

LOCAL cUdlFile     := "userDefineLang_harbour.xml"
LOCAL cApiFile     := "harbour.xml"
LOCAL nHndUdl, nHndApi
LOCAL cFuncList    := ""
LOCAL aLista       := {}
LOCAL nI, i, nPosAbre, nPosFecha
LOCAL cFuncName, cFuncDesc, cFuncParams, cRetornoField, cParam, aParams
LOCAL cLastApiFunc := ""
LOCAL lInKeyword   := .F.
LOCAL hUniqueUdl   := {=>} // Controle exclusivo para evitar duplicatas no UDL

@ 24,00 SAY "A gerar Autocomplete para Notepad++ (harbour.xml)..."         

// 1. Abre o banco de dados LIN
USE LIN.DBF ALIAS LIN SHARED NEW
IF !NetErr()

   // 2. Extrai os dados para a matriz (para ordenar) e para a string (UDL)
   LIN->(DBGoTop())
   WHILE !LIN->(EOF())
      cFuncName := AllTrim(LIN->COMANDO)

      IF !Empty(cFuncName)
         // Popula o UDL apenas com Funções, Procedures e Comandos únicos
         IF LIN->TIPO $ "F,P,C"
            IF !hb_HHasKey(hUniqueUdl, Upper(cFuncName))
               hb_HSet(hUniqueUdl, Upper(cFuncName), .T.)
               cFuncList += cFuncName + " "
            ENDIF
         ENDIF

         // Filtra Functions/Procedures para popular o AutoComplete
         IF LIN->TIPO == "F" .OR. LIN->TIPO == "P"
            AAdd(aLista, { cFuncName, AllTrim(LIN->DESCRICAO), AllTrim(LIN->RETORNO) })
         ENDIF
      ENDIF

      LIN->(DBSkip())
   ENDDO

   // 3. Ordena a matriz alfabeticamente para o harbour.xml
   ASort(aLista,,,{| x,y | Upper(x[1]) < Upper(y[1])})

   // =========================================================================
   // Geração do arquivo de Autocompletar (harbour.xml)
   // =========================================================================
   nHndApi := FCreate(cApiFile, FC_NORMAL)

   FWrite(nHndApi, '<?xml version="1.0" encoding="Windows-1252" ?>'+hb_eol())
   FWrite(nHndApi, '<NotepadPlus>'+hb_eol())
   FWrite(nHndApi, '    <AutoComplete language="Harbour">'+hb_eol())
   FWrite(nHndApi, '        <Environment ignoreCase="yes" startFunc="(" stopFunc=")" paramSeparator="," terminal="" additionalWordChar=""/>'+hb_eol())

   FOR nI := 1 TO Len(aLista)

      cFuncName     := aLista[nI, 1]
      cFuncDesc     := aLista[nI, 2]
      cRetornoField := aLista[nI, 3]

      // Tratamento de caracteres especiais no nome da função
      cFuncName := StrTran(cFuncName, "&", "&amp;")
      cFuncName := StrTran(cFuncName, "<", "&lt;")
      cFuncName := StrTran(cFuncName, ">", "&gt;")

      // Agrupa overloads dentro da mesma KeyWord se houver nomes repetidos
      IF Upper(cFuncName) != Upper(cLastApiFunc)
         IF lInKeyword
            FWrite(nHndApi, '        </KeyWord>'+hb_eol())
         ENDIF
         FWrite(nHndApi, '        <KeyWord name="'+cFuncName+'" func="yes">'+hb_eol())
         cLastApiFunc := cFuncName
         lInKeyword := .T.
      ENDIF

      // Limpeza e escape de caracteres na descrição
      cFuncDesc := StrTran(cFuncDesc, "&", "&amp;")
      cFuncDesc := StrTran(cFuncDesc, "<", "&lt;")
      cFuncDesc := StrTran(cFuncDesc, ">", "&gt;")
      cFuncDesc := StrTran(cFuncDesc, '"', "&quot;")
      cFuncDesc := StrTran(cFuncDesc, "'", "&apos;")

      // Converte quebras de linha reais para entidades XML no descr="..."
      cFuncDesc := StrTran(cFuncDesc, hb_eol(), "&#x000D;&#x000A;")
      cFuncDesc := StrTran(cFuncDesc, Chr(13)+Chr(10), "&#x000D;&#x000A;")
      cFuncDesc := StrTran(cFuncDesc, Chr(10), "&#x000A;")

      IF !Empty(cRetornoField)
         cRetornoField := StrTran(cRetornoField, "&", "&amp;")
         cRetornoField := StrTran(cRetornoField, "<", "&lt;")
         cRetornoField := StrTran(cRetornoField, ">", "&gt;")
         
         cFuncDesc := cRetornoField + "&#x000D;&#x000A;&#x000D;&#x000A;" + cFuncDesc
      ENDIF

      FWrite(nHndApi, '            <Overload retVal="" descr="'+cFuncDesc+'">'+hb_eol())

      // Extrai os parâmetros de dentro dos parênteses
      cFuncParams := ""
      nPosAbre    := At("(", cRetornoField)
      nPosFecha   := At(")", cRetornoField)

      IF nPosAbre > 0 .AND. nPosFecha > nPosAbre
         cFuncParams := SubStr(cRetornoField, nPosAbre + 1, nPosFecha - nPosAbre - 1)
      ENDIF

      IF !Empty(cFuncParams)
         cFuncParams := StrTran(cFuncParams, "[", "")
         cFuncParams := StrTran(cFuncParams, "]", "")

         aParams := hb_ATokens(cFuncParams, ",")
         FOR i := 1 TO Len(aParams)
            cParam := AllTrim(aParams[i])
            IF !Empty(cParam)
               cParam := StrTran(cParam, "&", "&amp;")
               cParam := StrTran(cParam, "<", "&lt;")
               cParam := StrTran(cParam, ">", "&gt;")
               cParam := StrTran(cParam, '"', "&quot;")
               FWrite(nHndApi, '                <Param name="'+cParam+'"/>'+hb_eol())
            ENDIF
         NEXT
      ENDIF

      FWrite(nHndApi, '            </Overload>'+hb_eol())
   NEXT

   // Fecha a última tag KeyWord aberta
   IF lInKeyword
      FWrite(nHndApi, '        </KeyWord>'+hb_eol())
   ENDIF

   FWrite(nHndApi, '    </AutoComplete>'+hb_eol())
   FWrite(nHndApi, '</NotepadPlus>'+hb_eol())
   FClose(nHndApi)

   // =========================================================================
   // Geração do arquivo User Defined Language (userDefineLang_harbour.xml)
   // =========================================================================
   nHndUdl := FCreate(cUdlFile, FC_NORMAL)

   FWrite(nHndUdl, '<?xml version="1.0" encoding="Windows-1252" ?>'+hb_eol())
   FWrite(nHndUdl, '<NotepadPlus>'+hb_eol())
   FWrite(nHndUdl, '    <UserLang name="Harbour" ext="prg ch">'+hb_eol())
   FWrite(nHndUdl, '        <Settings>'+hb_eol())
   FWrite(nHndUdl, '            <Global caseIgnored="yes" />'+hb_eol())
   FWrite(nHndUdl, '            <TreatAsSymbol comment="no" commentLine="no" />'+hb_eol())
   FWrite(nHndUdl, '            <Prefix words1="no" words2="no" words3="no" words4="no" />'+hb_eol())
   FWrite(nHndUdl, '        </Settings>'+hb_eol())
   FWrite(nHndUdl, '        <KeywordLists>'+hb_eol())
   FWrite(nHndUdl, '            <Keywords name="Words1">IF ELSE ENDIF FOR NEXT WHILE ENDDO FUNCTION PROCEDURE RETURN LOCAL PUBLIC PRIVATE</Keywords>'+hb_eol())
   FWrite(nHndUdl, '            <Keywords name="Words2">'+RTrim(cFuncList)+'</Keywords>'+hb_eol())
   FWrite(nHndUdl, '            <Keywords name="Words3">.T. .F. NIL</Keywords>'+hb_eol())
   FWrite(nHndUdl, '            <Keywords name="Words4"></Keywords>'+hb_eol())
   FWrite(nHndUdl, '        </KeywordLists>'+hb_eol())
   FWrite(nHndUdl, '        <Styles>'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="DEFAULT" styleID="11" fgColor="000000" bgColor="FFFFFF" fontName="" fontStyle="0" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="FOLDEROPEN" styleID="12" fgColor="0000FF" bgColor="FFFFFF" fontName="" fontStyle="0" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="FOLDERCLOSE" styleID="13" fgColor="0000FF" bgColor="FFFFFF" fontName="" fontStyle="0" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="KEYWORD1" styleID="5" fgColor="0000FF" bgColor="FFFFFF" fontName="" fontStyle="1" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="KEYWORD2" styleID="6" fgColor="800080" bgColor="FFFFFF" fontName="" fontStyle="0" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="KEYWORD3" styleID="7" fgColor="FF8000" bgColor="FFFFFF" fontName="" fontStyle="1" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '            <WordsStyle name="KEYWORD4" styleID="8" fgColor="000000" bgColor="FFFFFF" fontName="" fontStyle="0" fontSize="" />'+hb_eol())
   FWrite(nHndUdl, '        </Styles>'+hb_eol())
   FWrite(nHndUdl, '    </UserLang>'+hb_eol())
   FWrite(nHndUdl, '</NotepadPlus>'+hb_eol())

   FClose(nHndUdl)

   CLOSE LIN

   @ 24,00 SAY Space(80)                                                        
   @ 24,00 SAY "Arquivos gerados com sucesso: "+cUdlFile+" e "+cApiFile         
ELSE
   @ 24,00 SAY "Erro ao abrir LIN.DBF"         
ENDIF

RETU NIL
*+ EOF: hbx.prg
*+
