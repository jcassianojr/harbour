*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ay3.prg
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
*+    Function M_ay3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function M_ay3

para nTIPO
ARQWORK := "MY03"
ARQWOR2 := "MY03A"
if nTIPO = 2
   cVAR    := MESANO()
   ARQWORK := "Y3"+cVAR
   ARQWOR2 := "YA"+cVAR
endif
if nTIPO = 3
   ARQWORK := "Y399"
   ARQWOR2 := "YA99"
endif

zxCODIGO := ""
priv mTOTAL

lMAY301 := SENHAX("MAY301")

PADRAX(0,,0,{ARQWORK,"OR01",ARQWOR2},"Numero   Data     Codigo"+spac(19)+"Seq SSQ Qtdde",;
 "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+PADR(TRIM(mCODIGO)+'/'+TRIM(mCODIG2),30)+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+STR(mQTDDE,12,3)","MAY301","MAY301",;
 ,,{|| MAY3POS()},{|| mNUMERO := ULTIMOREG(ARQWORK,"NUMERO","mNUMERO")} ;
 ,"MAY3")


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY3POS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY3POS(nUSO)

if valtype(nUSO) # "N"
   nUSO := 1
endif
zxCODIGO := mCODIGO
if ARQWORK # "MY03"
   ALERTX("Mes Fechado NÆo Grava Altera‡oes Estoque")
ELSE
   MAY304()
   if !empty(mCODIG2)
      zxCODIGO := mCODIG2
      MAY304()
   endif
ENDIF
if nUSO = 1
   if mCODMAQ <> "TER" .AND. MDG("Lan‡ar Paradas")
      xNUMERO := mNUMERO
      PADRAO(1,1,0,ARQWOR2,"Req"+spac(6)+"Par Co Ini   Fim   Tempo",;
       "' '+STR(mNUMERO,8)+' '+STR(mITEM,3)+' '+mCODPAR+' '+STR(mPINI,5,2)+' '+STR(mPFIM,5,2)+' '+STR(mTEMPO,5,2)","MAY3A","MAY3A1","MAY3A1",;
       {|| MAY3IINC()},{|| PADARR(ARQWOR2,str(xNUMERO,8),"NUMERO","XNUMERO")},,,;
       ,,,"mTEMPO")
      HB_KEYCLEAR()
	  hb_keyPut( 88 ) //KEYINS(88)
      if cVIDE # "T"
         GRAVAMVAR(ARQWORK,xNUMERO,"PARADA","mTOTAL")
      else
         mPARADA := mTOTAL
      endif
      if cVIDE = "T"
         dbselectar(ARQWORK)
      endif
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY3IINC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY3IINC


mNUMERO := xNUMERO
ULTIMOITEM(ARQWOR2,str(xNUMERO,8),"NUMERO","XNUMERO","ITEM","mITEM",.T.)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY302()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY302


if cVIDE # 'T'  //Sub Rotinas Fecham arquivo
   while !USEREDE(ARQWORK,1,2)
   enddo
else
   dbselectar(ARQWORK)
   dbsetorder(2)
endif
dbgotop()
dbseek(mCODIGO+str(mSEQ,3)+str(mSSQ,3)+mCODMAQ)
if mCODIGO = CODIGO .and. mSEQ = SEQ .and. mSSQ = SSQ .and. mCODMAQ = CODMAQ .and. !eof()
   mANTREF := VALREF
endif
if cVIDE # 'T'
   dbclosearea()
else
   dbsetorder(1)
   dbgotop()
   dbseek(mNUMERO)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY303()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY303


zMEDIA := OBTER("MANEMP",ZNUMERO,"MEDIA")
priv mTOTAL
mOS     := 0
INCLUI  := .T.  //Marca Para Processar
CORPAX  := CORARR("MAY3")
ARQWORK := "MY03"
CRIARVARS("MY03")
mBXMY03 := "S"
TELASAY("MAY301")
EDITSAY("MAY302")
MAY3POS(2)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY304()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY304


local cERRO
cERRO := str(mNUMERO)+" "+alltrim(zxCODIGO)+" Opr:"+str(mSEQ,3)+"/"+str(mSSQ,3)
if !INCLUI
   ALERTX("Altera‡„o N„o Grava Estoques")
   GRAVALOG(cERRO,"VER",ARQWORK)
   retu .F.
endif
if mBXMY03 = "N"
   ALERTX("Requisicao Marcada Nao Baixar Estoque")
   GRAVALOG(cERRO,"BXM",ARQWORK)
   retu .F.
endif
if OBTER("MS06",zxCODIGO+str(mSEQ,3)+str(mSSQ,3),"PULREQ") = "S"  //Opera‡”es Nulas
   ALERTX("Opera‡ao Marcada Pular NÆo Grava Estoque")
   GRAVALOG(cERRO,"PUL",ARQWORK)
   retu .F.
endif
if (mSEQ > 0 .or. mSSQ > 0) .and. !VERSEHA("MS06",zxCODIGO+str(mSEQ,3)+str(mSSQ,3))
   ALERTX("Opera‡ao Nao Cadastrada NÆo Grava Estoque")
   GRAVALOG(cERRO,"OPE",ARQWORK)
   retu .F.
endif

GRAVALOG(cERRO,"INI",ARQWORK)

MDS("Abrindo Sequencia Operacao")
while !userede("MS06REQ",1,99)
enddo
aREQOUT := {}
dbselectar("MS06REQ")
dbsetorder(2)   //Produto Sequencia
dbgotop()
dbseek(zxCODIGO+str(mSEQ,3)+str(mSSQ,3))
while alltrim(CODIGO) = alltrim(zxCODIGO) .and. seq = mSEQ .AND. SSQ = mSSQ .and. !eof()
   AADD(aREQOUT,{BXCOD,BXSEQ,BXSSQ,BXFAT})
   //   ALERTX(BXCOD+STR(BXSEQ)+STR(BXSSQ))
   dbskip()
enddo
dbclosearea()


aSUB := {}
while !USEREDE("MS06",1,99)
enddo
while !USEREDE("MS96",1,99)
enddo
dbselectar("MS06")
dbsetorder(1)
dbgotop()
if dbseek(zxCODIGO+str(mSEQ,3)+str(mSSQ,3))
   xESTQSAL := ESTQSAL
   GRAVALAY({{"ARQUIVO","USUARIO","QTDE","DATA","NUMERO","CODIGO","SEQ","SSQ","ESTQXXX"},;
    {"'MY03'","ZUSER","mQTDDE","IF(EMPTY(mDATA),ZDATA,mDATA)","mNUMERO","zxCODIGO","mSEQ","mSSQ","xESTQSAL"}},;
    "MS96",,.F.,,.T.)
   netreclock()
   field->ESTQENT := ESTQENT+mQTDDE
   field->ESTQSAL := ESTQINI+ESTQENT - ESTQSAI
   dbunlock()
   xESTQSAL := ESTQSAL
   GRAVALAY({{"ESTQYYY"},{"XESTQSAL"}},"MS96",,.F.,,.F.)
   if TIPBAI $ "SPCMOT"   //Incluindo Estoque Sub Outras
      mNRNOTA    := 0
      mQTDE      := mQTDDE
      mTIPOENT   := TIPBAI
      yCODIGO    := CODFEC
      mOLDQTDDE  := 0
      mFORNECEDO := 0
      MAY02(TIPORR(TIPBAI,2),TIPORR(TIPBAI,2)+"BX",TIPORR(TIPBAI,1),mQTDDE)   //Distribuindo o Estoque do Componente
      MAK2K05("I","MY03I")
      dbselectar("MS06")
   endif
   lSTOP := .F.
   dbskip(- 1)
   while alltrim(CODIGO) = alltrim(zxCODIGO) .and. !bof() .and. !lSTOP
      if TIPFEC = "7" .OR. TIPFEC = "P"
         lSTOP := .T.
      endif
      if PULREQ # "S" .and. !lSTOP
         xESTQSAL := ESTQSAL
         xSEQ     := SEQ
         xSSQ     := SSQ
         GRAVALAY({{"ARQUIVO","USUARIO","QTDE","DATA","NUMERO","CODIGO","SEQ","SSQ","ESTQXXX"},;
          {"'MY03'","ZUSER","mQTDDE","IF(EMPTY(mDATA),ZDATA,mDATA)","mNUMERO","zxCODIGO","XSEQ","XSSQ","xESTQSAL"}},;
          "MS96",,.F.,,.T.)
         netreclock()
         field->ESTQSAI := ESTQSAI+mQTDDE
         field->ESTQSAL := ESTQINI+ESTQENT - ESTQSAI
         dbunlock()
         xESTQSAL := ESTQSAL
         GRAVALAY({{"ESTQYYY"},{"XESTQSAL"}},"MS96",,.F.,,.F.)
         lSTOP := .T.
      endif
      dbskip(- 1)
   enddo
   if dbseek(zxCODIGO+str(mSEQ,3)+str(mSSQ,3))  //Retorna ao Registro
      if TIPFEC = "9" .or. TIPFEC = "8"   //Baixar spmt baixa conjunto (7)*fator
         dbskip(- 1)
         while alltrim(CODIGO) = alltrim(zxCODIGO) .and. !bof()
            if TIPFEC = "7"
               xESTQSAL := ESTQSAL
               xSEQ     := SEQ
               xSSQ     := SSQ
               GRAVALAY({{"ARQUIVO","USUARIO","QTDE","DATA","NUMERO","CODIGO","SEQ","SSQ","ESTQXXX"},;
                {"'MY03'","ZUSER","mQTDDE","IF(EMPTY(mDATA),ZDATA,mDATA)","mNUMERO","zxCODIGO","XSEQ","XSSQ","xESTQSAL"}},;
                "MS96",,.F.,,.T.)
               netreclock()
               field->ESTQSAI := ESTQSAI+(mQTDDE * FATOR)
               field->ESTQSAL := ESTQINI+ESTQENT - ESTQSAI
               dbunlock()
               xESTQSAL := ESTQSAL
               GRAVALAY({{"ESTQYYY"},{"XESTQSAL"}},"MS96",,.F.,,.F.)
               if TIPBAI $ "SPCMOT"   //Incluindo Baixando Estoque Outras
                  mNRNOTA    := 0
                  mQTDE      := (mQTDDE * FATOR)
                  mTIPOENT   := TIPBAI
                  yCODIGO    := CODFEC
                  mOLDQTDDE  := 0
                  mFORNECEDO := 0
                  MAY02(TIPORR(TIPBAI,2),TIPORR(TIPBAI,2)+"BX",TIPORR(TIPBAI,1),mQTDDE)   //Distribuindo o Estoque do Componente
                  MAM2K05("I","MY03I")
                  dbselectar("MS06")
               endif
            endif
            dbskip(- 1)
         enddo
      endif
   endif
ELSE
   GRAVALOG(cERRO,"OPX",ARQWORK)
endif
//Sub Baixas
nSUBBAI := LEN(aREQOUT)
for x := 1 to nSUBBAI
   dbselectar("MS06")
   dbsetorder(1)
   dbgotop()
   if dbseek(padr(aREQOUT[X ,  1],24)+str(aREQOUT[X ,  2],3)+str(aREQOUT[X ,  3],3))
      //      ALERTX("Baixando "+CODIGO+STR(SEQ)+STR(SSQ))
      nSUBQTDE := mQTDDE * aREQOUT[X,4]
      xESTQSAL := ESTQSAL
      GRAVALAY({{"ARQUIVO","USUARIO","QTDE","DATA","NUMERO","CODIGO","SEQ","SSQ","ESTQXXX"},;
       {"'MY03'","ZUSER","nSUBQTDE","IF(EMPTY(mDATA),ZDATA,mDATA)","mNUMERO","zxCODIGO","mSEQ","mSSQ","xESTQSAL"}},;
       "MS96",,.F.,,.T.)
      netreclock()
      field->ESTQSAI := ESTQSAI+nSUBQTDE
      field->ESTQSAL := ESTQINI+ESTQENT - ESTQSAI
      dbunlock()
      xESTQSAL := ESTQSAL
      GRAVALAY({{"ESTQYYY"},{"XESTQSAL"}},"MS96",,.F.,,.F.)
   endif
next x
dbselectar("MS06")
dbclosearea()
dbselectar("MS96")
dbclosearea()

GRAVALOG(cERRO,"FS1",ARQWORK)

MDS("Abrindo Composicao")
aCOMP := {}
while !USEREDE("MS03",1,2)
enddo
dbgotop()
dbseek(zxCODIGO)
while zxCODIGO = CODIGO .and. !eof()
   if BSEQ = mSEQ .and. BSSQ = mSSQ
      if BAIXAC = "S"
         aadd(aCOMP,{TIPOENT,CODCOMP,mQTDDE * QTDDE,mOS,BAIXAC})  //Quantidade OS*Quantidade componete
      endif
   endif
   dbskip()
enddo
dbclosearea()
MDS("Gravando Composicao")
OLDTIPOENT := " "
for W := 1 to len(aCOMP)  //Baixando o Estoque Componentes
   mFORNECEDO := 0
   mOLDQTDDE  := 0
   mCODIGO    := aCOMP[W,2]
   yCODIGO    := mCODIGO
   mQTDE      := aCOMP[W,3]
   mTIPOENT   := aCOMP[W,1]
   mTIPENT    := aCOMP[W,1]
   mBAIXAC    := aCOMP[W,5]
   MAM2K05("I",ARQWORK+"S"+mTIPOENT)
next W
mTIPOENT := OLDTIPOENT
GRAVALOG(cERRO,"FIM",ARQWORK)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY305()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY305()


priv nALMI := nALMF := 0
PEGACAMPO("FOPTOHOR","mTURNO",{"ALMI","ALMF"},{"nALMI","nALMF"})
if mINIOPR <= nALMI .and. mFIMOPR >= nALMF
   mALMINI := nALMI
   mALMFIM := nALMF
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY306()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY306()


priv nALMI := nALMF := 0
PEGACAMPO("FOPTOHOR",mTURNO,{"ALMI","ALMF"},{"nALMI","nALMF"})
if mPINI <= nALMI .and. mPFIM >= nALMF
   mPALI := nALMI
   mPALF := nALMF
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY307()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY307()


if cVIDE # "T"
   ALLTRUE(VERSEHA(ARQWORK,mCODMAQ+str(mSEQ,3)+str(mSSQ,3)+mCODIGO+dtos(mDATOPR),"'Similar o.'+STR(NUMERO)","''",.T.,4))
else
   dbselectar(ARQWORK)
   dbsetorder(4)
   if dbseek(mCODMAQ+str(mSEQ,3)+str(mSSQ,3)+mCODIGO+dtos(mDATOPR))
      MDS('Similar o.'+str(NUMERO))
   endif
   dbselectar(ARQWORK)
   dbsetorder(1)
   dbseek(mNUMERO)
endif


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAY3AVL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAY3AVL()


ARQWORK := "MY03"
ARQWOR2 := "MY03A"
CRIARVARS("MY03")
CRIARVARS("MY03A")
CRIARVARS("OR01")
zxCODIGO := ""
priv mTOTAL
lMAY301 := SENHAX("MAY301")
aMAYTEL := TELAPEG("MAY301")
aMAYGET := EDITPEG("MAY301")
cVIDE   := "X"
while .T.
   INCLUI := .T.
   CRIARVARS("MY03")
   // Desenha a Tela
   TELASAY(aMAYTEL)
   // Get nas Menvars
   EDITSAY(aMAYGET)
   while !USEREDE("MY03",1,99)
   enddo
   dbgobottom()
   mNUMERO := NUMERO
   mNUMERO ++
   netrecapp()
   //    mNUMERO:=RECNO()
   REPLVARS()
   dbcommit()
   dbcloseall()
   for X := 1 to 3000   //Delay Aguardando Grava‡ao
   next X
   MAY3POS()
   if !MDG("Outro Lan‡amento")
      exit
   endif
enddo
release all like m *

