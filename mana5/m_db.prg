*+--------------------------------------------------------------------
*+
*+    Programa  : m_db.prg Indexar arquivos
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Copyright (c) 2023, Jcassiano
*+
*+--------------------------------------------------------------------
*+


function m_db

para wFILTRO

MDI(" Indexar Arquivos ")

//Variaveis de Trabalho
lPULAFEC  := .F.
lPULACEP  := .F.
lPULACNPJ := .F.
aARQ      := {}
aARQD     := {}

if valtype(wFILTRO) # "C"
   lPULAFEC  := MDG("Pular Arquivos Fechados")
   lPULACEP  := MDG("Pular Arquivos CEPS")
   lPULACNPJ := MDG("Pular Arquivos CNPJ/IE")
   lMESARQ   := MDG("Exibir Mensagem arquivo nao encontrado")
   FILTRO    := RFILORD(zARQ,.F.)
else
   lMESARQ   :=.T.
   FILTRO := wFILTRO
endif

if !useCHK(ZDIRC+"MANARQ",ZDIRC+"MANARQ",.T.)
   dbcloseall()
   retu .F.
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
set filter to &FILTRO
dbgotop()
while !eof()
   lINCLUI := .T.
   @ 24,00 say padr(ARQUIVO,8)         
   if (!empty(arqANO) .and. lPULAFEC) .or. ARQUIVO = "MANARQ" .or. ARQUIVO = "MANARQ1"
      //Nao Inclui Na Lista Fechados
      lINCLUI := .F.
   ENDIF
   if PADRAO = "A" .and. lPULACEP   //E cep e foi solicitado pular
      lINCLUI := .F.
   ENDIF
   IF lPULACNPJ .AND. (AT("CNPJIE",ARQUIVO) > 0 .OR. AT("BAIXA",ARQUIVO) > 0)
      lINCLUI := .F.
   ENDIF
   IF lINCLUI
      aadd(aARQ,alltrim(ARQUIVO))
      aadd(aARQD,{PADRAO,alltrim(CAMINHO),if(empty(DRIVER),"DBFCDX",DRIVER)})
   endif
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo
dbclosearea()

//LOCALARQ(PADRAO,CAMINHO)

if !useCHK(ZDIRC+"MANARQ1",ZDIRC+"MANARQ1",.T.)
   dbcloseall()
   retu .F.
endif
nLASTREC:=len(aARQ)
zei_fort( nLASTREC,,,0)
for X := 1 to len(aARQ)
   cARQ := aARQ[X]
   @ 24,00 say padr(cARQ,8)         
   //Carrega o Diret¢rio do Arquivo
   mDIR := LOCALARQ(aARQD[X,1],aARQD[X,2])
   //Carrega os Indices
   aIND := {}
   dbgotop()
   dbseek(cARQ)
   while cARQ = alltrim(ARQUIVO) .and. !eof()
      aadd(aIND,{alltrim(INDICE),alltrim(INDEXP)})
      dbskip()
   enddo
   //Apagando Indices
   if aARQD[X,3] = "DBFCDX"
      if file(mDIR+cARQ+".CDX")
         ferase(mDIR+cARQ+".CDX")
      endif
   else
      for W := 1 to len(aIND)
         if file(mDIR+aIND[W,1]+".NTX")
            ferase(mDIR+aIND[W,1]+".NTX")
         endif
      next W
   endif
   if USECHK(mDIR+cARQ,,.F.,aARQD[X,3],.T.,300,lMESARQ)    // USECHK(cARQ,cIND,lSHA,cDRIVER,lNEW,nTIME,lMES)
      PACK
      nLASTREC := LASTREC()
      zei_fort(nLASTREC,,,0)
      for W := 1 to len(aIND)
         @ 24,10 say padr(aIND[W,1],8)         
         if aARQD[X,3] = "DBFCDX"
            mDIRIND := mDIR+cARQ
            cTAG    := aIND[W,1]
         else
            mDIRIND := mDIR+aIND[W,1]
         endif
         mINDEXP := aIND[W,2]
         if left(mINDEXP,1) # "<"
            if aARQD[X,3] = "DBFCDX"
               index on &mINDEXP tag &cTAG. EVAL ZEI_FORT(nLASTREC,,,1)
            else
               index on &mINDEXP to &mDIRIND EVAL ZEI_FORT(nLASTREC,,,1)
            endif
         else
            mINDEXP := substr(mINDEXP,2)
            if aARQD[X,3] = "DBFCDX"
               index on &mINDEXP tag &cTAG. DESCEN EVAL ZEI_FORT(nLASTREC,,,1)
            else
               index on &mINDEXP to &mDIRIND DESCEN EVAL ZEI_FORT(nLASTREC,,,1)
            endif
         endif
      next W
      dbclosearea()
   endif
   dbselectar("MANARQ1")
   zei_fort(nLASTREC,,,1)
next X

if !useCHK(ZDIRC+"MANARQ",ZDIRC+"MANARQ",.T.)
   dbcloseall()
   retu .F.
endif
dbselectar("MANARQ1")
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
dbgotop()
while ! eof()
    lTEM:=.T.
    cARQUIVO:=ALLTRIm(ARQUIVO)
    dbselectar("manarq")
    dbgotop()
    if ! dbseek(cARQUIVO)
       ltem:= .f.
    endif
    dbselectar("MANARQ1")
    while cARQUIVO =ALLTRIm(ARQUIVO) .AND. ! EOF()
        if ! ltem
           netrecdel()
        endif
        dbskip()
        zei_fort(nLASTREC,,,1)
    enddo
enddo

dbcloseall()
FIXAR("MANARQ1")



*+--------------------------------------------------------------------
*+
*+    Function MDT()
*+
*+--------------------------------------------------------------------
*+
function MDT(cMSG)  //EXIBE MENSAGEM POR UM TEMPO
hb_Alert(cMSG, , , 1 ) 
return .t.


*+--------------------------------------------------------------------
*+
*+    Function MD()
*+
*+--------------------------------------------------------------------
*+
function MD   //TELA PARA AS MENSAGENS
@ 24,00
return .T.


