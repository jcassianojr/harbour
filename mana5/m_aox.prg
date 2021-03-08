*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aox.prg
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

MDI(" Ý Remanejamento de Ordem de Fabricacao")

cCODIGO   := SPACE(24)
cTIPO     := "F"
cCONTINUA := "N"
cUNID     := " "
aOFTMP    := {}
aOFOK     := {}
mGERAOF   := ""

TELASAY("MAOX01")
EDITSAY("MAOX01")

IF cCONTINUA = "N"
   RETU
ENDIF

cCODIGO := ALLTRIM(cCODIGO)
DO CASE
   CASE cTIPO = "X" .AND. cCODIGO = "TODOS"
      dDATMAX := ZDATA
      MDS("Data Limite")
      @ 24,40 GET dDATMAX         
      IF !READCUR()
         RETU .F.
      ENDIF
      APGPR2(,.F.)
      IF !USEREDE("MO02",1,1)
         RETU .F.
      ENDIF
      DBGOTOP()
      WHILE !EOF()
         IF ENTREGA <= dDATMAX .AND. QTDESAL > 0
            AADD(aOFTMP,{OS,ENTREGA})
         ENDIF
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
   CASE cTIPO = "X" 
      MAOX01("MO02",cCODIGO,3)
   CASE cTIPO = "F" 
      MAOX01("OF01",cCODIGO)
      //   CASE cTIPO="S" ; MAOX01("OR01",cCODIGO)
   OTHERWISE
      MAOX01(TIPORR(cTIPO,1),cCODIGO)
ENDCASE

IF EMPTY(aOFTMP)
   RETU
ENDIF


TEMPDBF := TMPFILE("DBF")
TEMPDBF := SUBSTR(TEMPDBF,1,AT(".",TEMPDBF) - 1)
aESTRU  := {{"OF","N",12,2},{"DLIMITE","D",8,0},{"CLIENTE","N",8,0},{"COGNOME","C",12,0}}
DBCREATE(TEMPDBF,aESTRU)

IF !USECHK(TEMPDBF,,.F.)
   DBCLOSEALL()
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","of")
ordSetFocus("temp")
FOR W := 1 TO LEN(aOFTMP)
   DBGOTOP()
   IF !DBSEEK(aOFTMP[W ,  1])
      netrecapp()
      FIELD->OF      := aOFTMP[W,1]
      FIELD->DLIMITE := aOFTMP[W,2]
      AADD(aOFOK,OF)
   ENDIF
NEXT W
DBCLOSEAREA()


CRIARVARS("OF01")
CRIARVARS("OF02")
CRIARVARS("OR01")


IF cTIPO = "X" .AND. cCODIGO = "TODOS"
   ZAPARQ({{"OF03",.T.,.F.},{"OR01BX",.T.,.F.},{"OR02BX",.T.,.F.},;
    {"OR03BX",.T.,.F.},{"OR04BX",.T.,.F.},{"OR05BX",.T.,.F.},;
    {"OR06BX",.T.,.F.},{"OR07BX",.T.,.F.},{"OR08BX",.T.,.F.},;
    {"OR09BX",.T.,.F.},{"OR10BX",.T.,.F.},{"OR11BX",.T.,.F.},;
    {"OR17BX",.T.,.F.},{"OR18BX",.T.,.F.},;
    {"OR12BX",.T.,.F.},{"OR15BX",.T.,.F.},{"OR16BX",.T.,.F.}})
   ZAPARQ({{"OF01",.F.,.T.},{"OF02",.F.,.T.},{"OR01",.F.,.T.},{"OR02",.F.,.T.},;
    {"OR03",.F.,.T.},{"OR04",.F.,.T.},{"OR05",.F.,.T.},;
    {"OR06",.F.,.T.},{"OR07",.F.,.T.},{"OR08",.F.,.T.},;
    {"OR09",.F.,.T.},{"OR10",.F.,.T.},{"OR11",.F.,.T.},;
    {"OR17",.F.,.T.},{"OR18",.F.,.T.},;
    {"OR12",.F.,.T.},{"OR15",.F.,.T.},{"OR16",.F.,.T.}})
   IF !USECHK(TEMPDBF,,.F.)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","DLIMITE")
   ordSetFocus("temp")
ELSE
   PRIV aCOMP := {}
   PRIV aCHAV := {}
   IF !USEMULT({{"OF01",1,99},{"OF02",1,99},{"MO01",1,1}})
      RETU .F.
   ENDIF
   IF !USECHK(TEMPDBF,,.F.)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","DLIMITE")
   ordSetFocus("temp")   
   DBSELECTAR(TEMPDBF)
   DBGOTOP()
   WHILE !EOF()
      @ 22,2 SAY "Aguarde Apagando ordem de Fabricacao ->"+STR(OF,8,2)         
      mOS      := OF
      mOF      := OF
      mCOGNOME := SPACE(20)
      mCLIENTE := 0
      mITEM    := 1
      DBSELECTAR("MO01")
      DBGOTOP()
      IF DBSEEK(mOS)
         mCOGNOME := COGNOME
         mCLIENTE := FORNECEDO
      ENDIF
      DBSELECTAR(TEMPDBF)
      IF !EMPTY(mCLIENTE)
         FIELD->COGNOME := mCOGNOME
         FIELD->CLIENTE := mCLIENTE
      ENDIF
      DBSELECTAR("OF01")
      DBGOTOP()
      IF DBSEEK(STR(mOS,8,2)+STR(mITEM,3))
         mCODIGO := CODIGO
         DELEREG(,,,.F.)
         TEMPCO := mCODIGO  //Salvando Variaveis
         TEMPOS := mOF
         TEMPIT := mITEM
         MDS("Apagando Composicao da Ordem de Fabricacao")
         DBSELECTAR("OF02")
         DBGOTOP()
         DBSEEK(STR(mOF,8,2)+STR(mITEM,3))
         WHILE TEMPOS = OF .AND. TEMPIT = ITEM .AND. !EOF()
            IF TIPCOMP $ "PMCEHTOS"
               nPOS := ASCAN(aCHAV,TIPCOMP+CODCOMP)
               IF nPOS = 0
                  AADD(aCOMP,{CODCOMP,TIPCOMP})   //Guardando Composicao para apagar reserva
                  AADD(aCHAV,TIPCOMP+CODCOMP)
               ENDIF
            ENDIF
            DELEREG(,,.T.,.F.)
         ENDDO
         nPOS := ASCAN(aCHAV,"S"+TEMPCO)
         IF nPOS = 0
            AADD(aCOMP,{TEMPCO,"S"})  //Guardando Composicao para apagar reserva
            AADD(aCHAV,"S"+TEMPCO)
         ENDIF
      ENDIF
      DBSELECTAR(TEMPDBF)
      DBSKIP()
   ENDDO
   DBSELECTAR("OF01")
   DBCLOSEAREA()
   DBSELECTAR("OF02")
   DBCLOSEAREA()
   DBSELECTAR("MO01")
   DBCLOSEAREA()



   FOR W := 1 TO LEN(aCOMP)
      zTCOD := aCOMP[W,1]
      MAOFDELX(TIPORR(aCOMP[W ,  2],1))   //Reserva
      MAOFDELX(TIPORR(aCOMP[W ,  2],1)+"BX")  //Reserva Baixada
      MAOFDELX(TIPORR(aCOMP[W ,  2],2))   //Necessidade
      MAOFDELX(TIPORR(aCOMP[W ,  2],2)+"BX")  //Necessidade Baixada
   NEXT W
ENDIF


IF !USEMULT({{"MO02",1,99},{"OF01",1,99},{"OF02",1,99},;
                    {"OR01",1,99},{"OR02",1,99},{"OR03",1,99},;
                    {"OR04",1,99},{"OR05",1,99},{"OR06",1,99},;
                    {"MS03",1,99},{"MS01",1,99},{"OR07",1,99},;
                    {"OR08",1,99},{"OR09",1,99},{"OR10",1,99},;
                    {"OR11",1,99},{"OR12",1,99},{"OR15",1,99},;
                    {"OR16",1,99},{"MO01",1,99}})
   RETU .F.
ENDIF

DBSELECTAR(TEMPDBF)
DBGOTOP()
WHILE !EOF()
   @ 22,2 SAY "Aguarde Reprocessando ordem de Fabricacao ->"+STR(OF,8,2)+" "+DTOS(DLIMITE)         
   mOS      := OF
   mOF      := OF
   mITEM    := 1
   mCLIENTE := CLIENTE
   mCOGNOME := COGNOME
   mCODIGO  := ""
   mQPEDIDO := 0
   DBSELECTAR("MO02")
   DBGOTOP()
   IF DBSEEK(STR(mOF,8,2)+STR(mITEM,2))
      mCODIGO  := CODIGO
      mQPEDIDO := CONVUN(QTDESAL,UNID)
   ENDIF
   IF mQPEDIDO > 0
      MAOF03(,.F.,.T.)
   ENDIF
   DBSELECTAR(TEMPDBF)
   DBSKIP()
ENDDO
DBCLOSEALL()
DELETEFILE(TEMPDBF+".DBF")
FERASE(TEMPDBF+"."+cRDDEXT)



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOX01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOX01(cARQ,cCODIGO,nIND)

IF VALTYPE(nIND) # "N"
   nIND := 3
ENDIF
WHILE !USEREDE(cARQ,1,nIND)
ENDDO
DBGOTOP()
DBSEEK(cCODIGO)
WHILE ALLTRIM(cCODIGO) = ALLTRIM(CODIGO) .AND. !EOF()
   DO CASE
      CASE cARQ = "MO02"
         AADD(aOFTMP,{OS,ENTREGA})
      CASE cARQ = "OR01" .OR. cARQ = "OF01"
         AADD(aOFTMP,{OF,DLIMITE})
      OTHERWISE
         AADD(aOFTMP,{OS,DLIMITE})
   ENDCASE
   DBSKIP()
ENDDO
DBCLOSEAREA()
RETU .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOFDELX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOFDELX(cARQDEL)

WHILE !USEREDE(cARQDEL,1,99)
ENDDO
DBGOTOP()
DBSEEK(PADR(zTCOD,24))
WHILE ALLTRIM(zTCOD) = ALLTRIM(CODIGO) .AND. !EOF()
   nPOS := ASCAN(aOFOK,OS)
   IF nPOS > 0
      @ 22,2 SAY "Apagando Componente -> "+STR(OS,8,2)+" "+CODIGO         
      DELEREG(,,,.F.)
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEAREA()
RETU .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function APGPR2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC APGPR2(nUSO,lEST)  //Saldo Processo

IF VALTYPE(nUSO) # "N"
   nUSO := 1
ENDIF
IF VALTYPE(lEST) # "L"
   lEST := .T.
ENDIF
IF nUSO = 1
   APGPRO("MT01")
   APGPRO("MU01")
ENDIF
APGPRO("MP01")
APGPRO("MP02")
APGPRO("MP03")


aPRO := {}
IF !USEREDE("MO02",1,1)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   nPOS := ASCAN(aPRO,CODIGO)
   IF nPOS = 0
      AADD(aPRO,CODIGO)
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEAREA()
IF !USEMULT({{"MS03",1,1},{"MS06",1,1}})
   DBCLOSEALL()
   RETU .F.
ENDIF
FOR X := 1 TO LEN(aPRO)
   mCODIGO := ALLTRIM(aPRO[X])
   MDS(mCODIGO)
   aGRU := {}
   DBSELECTAR("MS03")
   DBGOTOP()
   DBSEEK(mCODIGO)
   WHILE mCODIGO = ALLTRIM(CODIGO) .AND. !EOF()
      mBSEQ := BSEQ
      mBSSQ := BSSQ
      IF !EMPTY(MBSEQ) .AND. !EMPTY(MBSSQ)
         mTIP  := TIPOENT
         mCOM  := CODCOMP
         mFAT  := QTDDE
         nQTDE := 0
         lSOMA := .T.
         @ 24,30 SAY mBSEQ         
         @ 24,35 SAY mBSSQ         
         @ 24,40 SAY mCOM          
         DBSELECTAR("MS06")
         DBGOTOP()
         DBSEEK(PADR(mCODIGO,24)+STR(mBSEQ,3)+STR(mBSSQ,3))
         WHILE mCODIGO = ALLTRIM(CODIGO) .AND. !EOF()
            IF TIPFEC = "8" .OR. TIPFEC = "9"
               lSOMA := .T.
            ENDIF
            IF TIPFEC = "7" .OR. SSQ = 99
               lSOMA := .F.
            ENDIF
            IF lSOMA .AND. PULREQ # "S"
               nQTDE += ESTQSAL
            ENDIF
            DBSKIP()
         ENDDO
         IF nQTDE > 0
            IF mTIP <> "I"  //Nao E instrumento
               IF lEST
                  mESTQPRO := OBTER(ESTQARQ(mTIP,1),mCOM,"ESTQPRO")+ROUND(nQTDE * mFAT,3)
               ELSE
                  mESTQPRO := ROUND(nQTDE * mFAT,3)
               ENDIF
               GRAVAMVAR(ESTQARQ(mTIP,1),mCOM,"ESTQPRO","mESTQPRO",,.F.)
            ENDIF
         ENDIF
      ENDIF
      DBSELECTAR("MS03")
      DBSKIP()
   ENDDO
NEXT X
DBCLOSEALL()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function APGPRO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC APGPRO(cARQ)

MDS("Apagando Estoque de Processos "+caRQ)
IF !USEREDE(cARQ,1,99)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   netgrvcam("ESTQPRO",0)
   DBSKIP()
ENDDO
DBCLOSEAREA()
RETU .T.
