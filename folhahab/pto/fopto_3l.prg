*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_3l.prg Geracao AFDT
*+
*+
*+
*+     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "adordd.ch"
#include "try.ch"

function fopto_3l()
CABE2('FOPTO_3L - Geracao AFDT '+ANOMESW)
PARA lPER,lDESC

SET CENTURY ON

aCTALOGIX := {0,"",112,113,146,148,149,152,193,541}
aCTALOGIC := {0,"",116,117,178,180,182,0,195,0}

PEGPTOHOR("XX",.T.,.F.)   //Verifica indices

IF VALTYPE(lPER) # "L"
   lPER := .T.
ENDIF
IF VALTYPE(lDESC) # "L"
   lDESC := .F.
ENDIF

lCPN := .F.
aCPN := {}

PRIV X,Y
aTOTJEF := {}

nMESSEQ := MESTRAB+1
nANOSEQ := ANOUSO
IF nMESSEQ = 13
   nMESSEQ := 1
   nANOSEQ ++
ENDIF

DCORTE  := zdataini
DCORTF  := zdatafim
cPREALM := IF(ZCTRALMOCO = 'S',"N","S")   //se controla almoco pre prenchido e nao
IF lPER
   MDS('Digite o periodo: '+space(21)+"Pre-Almoço")
   @ 24,20 get DCORTE                              
   @ 24,30 get DCORTF                              
   @ 24,51 geT cPREALM VALID cPREALM $ "SN"        
   if !READCUR()
      retu .F.
   endif
endif

if mdg("Verificar informacoes Folha Logix")
   ImpHorLogix(DCORTE,DCORTF)
endif

cPD := "PD"+ANOMESW
cPN := "PN"+ANOMESW
cPM := "PM"+ANOMESW
cPE := "PE"+ANOMESW
cPT := "PT"+ANOMESW

aREL := {}
aREP := {}
if netuse("FOPTOEQP")
   WHILE !EOF()
      AADD(aREL,NUMERO)
      AADD(aREP,VAL(REP))
      DBSKIP()
   ENDDO
   dbcloseall()
ELSE
   retu
endif

if !NETUSE("AFDTERR")
   dbcloseall()
   retu
endif
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| data >= dcorte .and. data <= dcortf .and. empty(motoco)},{|| zei_fort(nLASTREC,,,1)})
dbcloseall()
netpack("AFDTERR")


IF lDESC
   if !NETUSE(cPD)
      dbcloseall()
      retu
   endif
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEVAL({|| netgrvcam("TIPOM"," ")},{|| TIPOM = "D"},{|| zei_fort(nLASTREC,,,1)})
   dbcloseall()
ENDIF


IF !NETUSE(PES)
   DBCLOSEALL()
   RETU
ENDIF

if !netuse(cPD)
   dbcloseall()
   retu
endif

if !netuse(cPN)
   dbcloseall()
   retu
endif

if !netuse(cPT)
   dbcloseall()
   retu
endif

if !netuse(cPM)
   dbcloseall()
   retu
endif

if !NETUSE(cPE)
   dbcloseall()
   retu
endif

if !NETUSE("FO_RELHR")
   dbcloseall()
   retu
endif

if !NETUSE("FOPTOHRE")
   dbcloseall()
   retu
endif

if !NETUSE("ESCALPAD")
   dbcloseall()
   retu
endif

if !NETUSE("HTTTROCA")
   dbcloseall()
   retu
endif

if !NETUSE("FOPTOHOR")
   dbcloseall()
   retu
endif

if !NETUSE("FOPTOPIS")
   dbcloseall()
   return
endif

if !NETUSE("AFDTERR")
   dbcloseall()
   retu
endif

if !NETUSE("logixvalores")
   dbcloseall()
   retu
endif


nSEQ  := 1
nSJEF := 1
// SET CENTURY ON
cARQERR := "ERRT"+strzero(nREMP,2)+ANOMESW+".TXT"
nHANERR := FCREATE(cARQERR)

nHANGRV := FCREATE("AFDT"+strzero(nREMP,2)+ANOMESW+".TXT")
nHANJEF := FCREATE("ACFJEF"+strzero(nREMP,2)+ANOMESW+".TXT")

FOR nREG := 1 TO 2
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),IF(nreg = 1,STRZERO(nSEQ,9),STRZERO(nSJEF,9)))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),"1")
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),IF(zPESSOA = "J","1",""))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),TIRAOUT(ZCGC))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),REPL("0",12))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),PADR(ZEMPRESA,150))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),STRTRAN(DTOC(DCORTE),"/",""))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),STRTRAN(DTOC(DCORTF),"/",""))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),STRTRAN(DTOC(DATE()),"/",""))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),LEFT(STRTRAN(TIME(),":",""),4))
   FWRITE(IF(NREG = 1,nHANGRV,nHANJEF),HB_OsNewLine())
NEXT nREG
nSEQ ++
nSJEF ++

DBSELECTAR("FOPTOHOR")
DBGOTOP()
WHILE !EOF()
   IF !EMPTY(ENT)
      FWRITE(nHANJEF,STRZERO(nSJEF,9))
      FWRITE(nHANJEF,"2")
      FWRITE(nHANJEF,STRZERO(NUMERO,4))
      FWRITE(nHANJEF,STRTRAN(STRZERO(ENT,5,2),".",""))
      FWRITE(nHANJEF,STRTRAN(STRZERO(ALMI,5,2),".",""))
      FWRITE(nHANJEF,STRTRAN(STRZERO(ALMF,5,2),".",""))
      FWRITE(nHANJEF,STRTRAN(STRZERO(SAI,5,2),".",""))
      FWRITE(nHANJEF,HB_OsNewLine())
      nSJEF ++
   ENDIF
   DBSKIP()
ENDDO

DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   PETELA(12)
   mNUMERO   := NUMERO
   mPIS      := PIS
   mADMITIDO := ADMITIDO
   if !EMPTY(DATTRANSF)   //Inicia a partir da data transferencia
      if mADMITIDO < DATTRANSF
         mADMITIDO := DATTRANSF
      endif
   endif
   mDEMITIDO := DEMITIDO
   lTEM      := .F.

   mGRUPO := "  "
   mTURNO := " "
   peghorfix(mNUMERO)

   if !empty(mPIS)
      dbselectar("foptopis")
      dbgotop()
      If !dbseek(mNUMERO)
         netrecapp()
         field->numero := mNUMERO
         field->pis    := mPIS
      ENDIF
   endif



   dbselectaR(cPD)
   dbgotop()
   DBSEEK(STR(mNUMERO,8))
   IF NUMERO = mNUMERO
      lTEM := .T.
   ENDIF
   IF !ltem
      dbselectaR(cPn)
      dbgotop()
      DBSEEK(STR(mNUMERO,8))
      IF NUMERO = mNUMERO
         lTEM := .T.
      ENDIF
   endif
   IF lTEM
      aTOT := {}
      AFILL(aTOT,0)
      dbselectaR(cPT)
      dbgotop()
      IF DBSEEK(mNUMERO)
         aTOT := {CTA01,CTA02,CTA03,CTA04,CTA05,CTA06,CTA07,CTA08,CTA09,CTA10,CTA11,CTA12,CTA13,CTA14,CTA15,CTA16,CTA17,CTA18,CTA19,CTA20,CTA21,CTA22,CTA23,CTA24}
      ENDIF
      nHOR50  := 0
      nHOR100 := 0
      FOR X := IF(DCORTE >= mADMITIDO,DCORTE,mADMITIDO) TO DCORTF   //inicia na admissao
         aHORAS := {}
         aTIPOM := {}
         aTIPOR := {}
         aRELOG := {}
         aMOT   := {}
         mCOD   := " "
         mSOD   := " "

         dbselectaR(cPD)
         dbgotop()
         dbseek(str(Mnumero,8)+DTOS(X))
         WHILE mNUMERO = NUMERO .AND. DATA = X .AND. !EOF()
            IF EMPTY(PIS) .OR. PIS = mPIS   //competencia antigas nao tinha pis
               aadd(aHORAS,HORA)
               aadd(aTIPOM,TIPOM)
               aadd(aTIPOR,IF(EMPTY(TIPOR),"O",TIPOR))  //Competencia antigas relogios ainda nao rep
               aadd(aRELOG,VAL(RELOGIO))
               aadd(aMOT,"")
            ENDIF
            dbskip()
         ENDDO
         lALMOCO := .F.
         nALS    := 0
         nALE    := 0
         dbselectaR(cPN)
         dbgotop()
         IF dbseek(str(Mnumero,8)+DTOS(X))
            aRETU := PEGPTOHOR(HORARIO,.F.,.F.)
            IF aRETU[6]
               nALS    := aRETU[2]
               nALE    := aRETU[3]
               lALMOCO := IF(ZCTRALMOCO = "S",.F.,.T.)  //se controla almoco nao gera pre preenchido almoco
            ENDIF
            mHORARIO := HORARIO
            mCOD     := COD
            mSOD     := SOD
            for y := 1 to len(aHORAS)
               if Ahoras[y] = ENT .AND. ASCAN(aTIPOM,"E") = 0
                  aTIPOM[Y] = "E"
               endif
               if ent > sai
                  nRECNO := RECNO()
                  dbgotop()
                  IF dbseek(str(Mnumero,8)+DTOS(X - 1))
                     if ahoras[Y] = SAI
                        aTIPOM[Y] = "S"
                     ENDIF
                  endif
                  dbgoto(nrecno)
               else
                  if ahoras[Y] = SAI .AND. ASCAN(aTIPOM,"S") = 0
                     aTIPOM[Y] = "S"
                  ENDIF
               endif
            next y
            IF !EMPTY(ALLTRIM(MUDENT+MUDALE+MUDALS+MUDSAI))
               dbselectar(cPM)
               dbgotop()
               if dbseek(str(mNUMERO,8)+dtos(X))
                  IF !EMPTY(HOROCO)
                     nPOS := ASCAN(HOROCO)
                     IF nPOS = 0
                        Aadd(aHORAS,HOROCO)
                        aadd(aTIPOM,"E")
                        Aadd(aTIPOR,"I")
                        aadd(aRELOG,0)
                        aadd(aMOT,MOTOCO)
                     ELSE
                        IF EMPTY(aTIPOR)
                           Aadd(aHORAS,HOROCO)
                           aadd(aTIPOM,"E")
                           Aadd(aTIPOR,"I")
                           aadd(aRELOG,0)
                           aadd(aMOT,MOTOCO)
                        ENDIF
                     ENDIF
                  ENDIF
                  IF !EMPTY(HOROC4)
                     nPOS := ASCAN(HOROC4)
                     IF nPOS = 0
                        aadd(aHORAS,HOROC4)
                        aadd(aTIPOM,"S")
                        aadd(aTIPOR,"I")
                        aadd(aRELOG,0)
                        aadd(aMOT,MOTOCO)
                     ELSE
                        IF EMPTY(aTIPOR)
                           Aadd(aHORAS,HOROCO)
                           aadd(aTIPOM,"S")
                           Aadd(aTIPOR,"I")
                           aadd(aRELOG,0)
                           aadd(aMOT,MOTOCO)
                        ENDIF
                     ENDIF
                  ENDIF
                  IF TYPE("ZERHOR") = "C"
                     IF ZERHOR = "S"
                        for y := 1 to len(aHORAS)
                           IF aTIPOM[Y] = "E" .AND. (TIPOCO = "E" .OR. TIPOCO = "T")
                              aTIPOM[Y] = "D"
                              aMOT[Y] = MOTOCO
                           ENDIF
                           IF aTIPOM[Y] = "S" .AND. (TIPOCO = "S" .OR. TIPOCO = "T" .OR. TIPOCO = "N")
                              aTIPOM[Y] = "D"
                              aMOT[Y] = MOTOCO
                           ENDIF
                        next y
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            dbselectaR(cPN)
            nHOR01  := 0
            nHOR02  := 0
            nHOR03  := 0
            nHOR04  := 0
            nATRASO := IF(aTOT[11] < .25,0,CTA11)+CTA12
            IF ENT > 0 .OR. HORARIO > 0 .OR. (CTA06+CTA19+CTA05+CTA08+CTA09+CTA07+CTA10+nATRASO > 0)
               CENT  := CHOR(ENT)   //Hora entrada em decimal de hora
               CSAI  := CHOR(SAI)   //Hora saida em decimal de hora
               HTAB  := CSAI - CENT
               HTABN := 0
               if !empty(SAI) .and. !empty(ENT)   //Horas Trabalhadas Vigias
                  if SAI < ENT
                     HTAB  := 0
                     HTABN := (24 - CENT)+CSAI
                  endif
               endif
               //Abate extraordinarias
               HTAB -= CTA01
               HTAB -= CTA02
               //Abate extraordinarias
               HTABN -= CTA03
               HTABN -= CTA04

               aRETU := PEGPTOHOR(HORARIO,.F.,.F.)
               IF aRETU[6]
                  RALE := CHOR(aRETU[2])
                  RALS := CHOR(aRETU[3])
                  RALM := RALS - RALE
                  IF RALM > 0
                     HTAB  -= RALM
                     HTABN -= RALM
                  ENDIF
               ENDif




               IF HTAB < 0
                  HTAB := 0
               ENDIF
               IF HTABN < 0
                  HTABN := 0
               ENDIF



               aHOREXT := {}
               IF CTA06 > 0   //noturna 100 % 112 ponto 06
                  AADD(aHOREXT,{CTA06,"0100","N"})
               ENDIF
               IF CTA19 > 0   //noturna 150 % 113 ponto 19
                  AADD(aHOREXT,{CTA19,"0150","N"})
               ENDIF
               IF CTA05 > 0   //diurna 50% ponto
                  AADD(aHOREXT,{CTA05,"0050","D"})
               ENDIF
               IF CTA08 > 0   //diurna 75% ponto
                  AADD(aHOREXT,{CTA08,"0075","D"})
               ENDIF
               IF CTA09 > 0   //diurna 100% ponto
                  AADD(aHOREXT,{CTA09,"0100","D"})
               ENDIF
               IF CTA07 > 0   //diurna 130% ponto
                  AADD(aHOREXT,{CTA07,"0130","D"})
               ENDIF
               IF CTA10 > 0   //diurna 150% ponto
                  AADD(aHOREXT,{CTA10,"0150","D"})
               ENDIF
               WHILE Len(aHOREXT) < 4
                  AADD(aHOREXT,{0,"0000","D"})
               enddo

               IF CTA06+CTA19+CTA05+CTA08+CTA09+CTA07+CTA10+nATRASO > 0
                  aadd(aTOTJEF,{NUMERO,DTOC(X),CTA06,CTA19,CTA05,CTA08,CTA09,CTA07,CTA10,nATRASO})
               ENDIF


               //usado bhor pois no layout e hhmm
               FWRITE(nHANJEF,STRZERO(nSJEF,9))
               FWRITE(nHANJEF,"3")
               FWRITE(nHANJEF,STRZERO(VAL(mPIS),12))
               FWRITE(nHANJEF,STRTRAN(DTOC(X),"/",""))
               FWRITE(nHANJEF,STRTRAN(STRZERO(ENT,5,2),"."))
               FWRITE(nHANJEF,STRZERO(HORARIO,4,0))
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(HTAB),5,2),"."))   //Horas diurnas nao extraordinarias
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(HTABN),5,2),"."))  //horas noturnas nao estraordinarias
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(aHOREXT[1,1]),5,2),"."))   //1 modalidade hora extra
               FWRITE(nHANJEF,aHOREXT[1,2])
               FWRITE(nHANJEF,aHOREXT[1,3])
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(aHOREXT[2,1]),5,2),"."))   //2 modalidade hora extra
               FWRITE(nHANJEF,aHOREXT[2,2])
               FWRITE(nHANJEF,aHOREXT[2,3])
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(aHOREXT[3,1]),5,2),"."))   //3 modalidade hora extra
               FWRITE(nHANJEF,aHOREXT[3,2])
               FWRITE(nHANJEF,aHOREXT[3,3])
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(aHOREXT[4,1]),5,2),"."))   //4 modalidade hora extra
               FWRITE(nHANJEF,aHOREXT[4,2])
               FWRITE(nHANJEF,aHOREXT[4,3])
               FWRITE(nHANJEF,STRTRAN(STRZERO(bhor(nATRASO),5,2),"."))  //Faltas e atrasos
               FWRITE(nHANJEF,"0")  //1 compensacao positirva 2 compensacao negativa
               FWRITE(nHANJEF,"0000")
               FWRITE(nHANJEF,HB_OsNewLine())
               nSJEF ++
               IF LEN(aHOREXT) > 4
                  FWRITE(nHANERR,STR(mNUMERO,8)+"+ 4 tipos extras no dia "+DTOC(X)+HB_OsNewLine())
               ENDIF
            ENDIF

         ELSE   //nao encontrou cPN
            IF X >= mADMITIDO .AND. X <= mDEMITIDO
               dbselectar(cPN)
               netrecapp()
               field->numero := mNUMERO
               field->data   := X
               lCPN          := .T.
               IF ASCAN(aCPN,mNUMERO) = 0
                  Aadd(Acpn,mNUMERO)
               ENDIF
            ENDIF
         ENDIF
         dbselectar(cPN)
         FOR Y := 1 to len(aHORAS)
            nHOR := CHOR(aHORAS[Y])
            IF EMPTY(aTIPOM[Y])
               FOR Z := 1 to len(aHORAS)
                  IF Z <> Y
                     IF abs(nHOR - CHOR(aHORAS[Z])) <= 0.09
                        aTIPOM[Y] = "D"
                        aMOT[Y] = "Marcacao sucessiva"
                     ENDIF
                  ENDIF
               NEXT Z
            ENDIF
            //
            IF EMPTY(aTIPOM[Y])
               IF ASCAN(aTIPOM,"S") = 0 .AND. !EMPTY(SAIREV)
                  IF ABS(nHOR - CHOR(SAIREV)) <= 0.09
                     aTIPOM[Y] = "S"
                  ENDIF
               ENDIF
            ENDIF
            IF EMPTY(aTIPOM[Y])
               IF ASCAN(aTIPOM,"E") = 0 .AND. !EMPTY(ENTREV)
                  IF ABS(nHOR - CHOR(ENTREV)) <= 0.09
                     aTIPOM[Y] = "E"
                  ENDIF
               ENDIF
            ENDIF

            IF EMPTY(aTIPOM[Y])
               mRENT := 0
               mRSAI := 0
               if !empty(mGRUPO) .and. mTURNO = "S"   //Reveza e tem escala
                  IF X < CTOD("01/08/2010")
                     DO CASE
                     CASE mGRUPO = "MA"
                        mGRUPO := "EA"
                     CASE mGRUPO = "TA"
                        mGRUPO := "EB"
                     CASE mGRUPO = "NO"
                        mGRUPO := "EN"
                     ENDCASE
                  ENDIF
                  fopto3lesc(mGRUPO+dtos(X),cPE)
                  IF EMPTY(mRENT) .OR. EMPTY(mRSAI)
                     fopto3lesc(mGRUPO,"ESCALPAD")
                  ENDIF
                  IF EMPTY(mRENT) .OR. EMPTY(mRSAI) .AND. !EMPTY(mHORARIO)
                     aRETU := PEGPTOHOR(mHORARIO,.F.,.F.)
                     IF aRETU[6]
                        mRENT := aRETU[1]
                        mRSAI := aRETU[4]
                     ENDif
                  ENDIF
                  IF EMPTY(mRENT) .OR. EMPTY(mRSAI) .AND. PEGFOLGA(mCOD)
                     fopto3lesc(mGRUPO+dtos(x - 1),cPE)   //saida horario noturno
                  ENDIF
                  IF EMPTY(mRENT) .OR. EMPTY(mRSAI) .AND. PEGFOLGA(mCOD)  //duas FE/FO SA/DO
                     fopto3lesc(mGRUPO+dtos(x - 2),cPE)   //saida horario noturno
                  ENDIF

               endif
               dbselectar(cPN)
               IF !EMPTY(mRSAI) .AND. ASCAN(aTIPOM,"S") = 0
                  IF ABS(nHOR - mRSAI) <= .09
                     aTIPOM[Y] = "S"
                  ENDIF
               ENDIF
               IF EMPTY(aTIPOM[Y])
                  IF !EMPTY(mRENT) .AND. ASCAN(aTIPOM,"E") = 0
                     IF ABS(nHOR - mRENT) <= .09
                        aTIPOM[Y] = "E"
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         NEXT Y

         IF nALS > 0 .AND. nALE > 0
            FOR Y := 1 to len(aHORAS)   //checagem entrad/saida almoco ex entrada sem 12:05 saida sem almoco 12:11
               IF aHORAS[Y] >= nALS .AND. aHORAS[Y] <= nALE
                  lALMOCO := .F.
               ENDIF
            NEXT Y
         ENDIF

         dbselectar(cPN)
         cSEQ := "01"
         FOR Y := 1 to len(aHORAS)
            IF lALMOCO .AND. aTIPOM[Y] = "S" .AND. cPREALM = "S" .AND. nALS < aHORAS[Y]
               FWRITE(nHANGRV,STRZERO(nSEQ,9))
               FWRITE(nHANGRV,"2")
               FWRITE(nHANGRV,STRTRAN(DTOC(X),"/",""))
               FWRITE(nHANGRV,STRTRAN(STRZERO(nALS,5,2),".",""))
               FWRITE(nHANGRV,STRZERO(VAL(mPIS),12))
               FWRITE(nHANGRV,STRZERO(0,17))
               FWRITE(nHANGRV,"S")
               FWRITE(nHANGRV,cSEQ)
               FWRITE(nHANGRV,"P")
               FWRITE(nHANGRV,PADR(aMOT[Y],100))
               FWRITE(nHANGRV,HB_OsNewLine())
               nSEQ ++
               cSEQ := "02"
               FWRITE(nHANGRV,STRZERO(nSEQ,9))
               FWRITE(nHANGRV,"2")
               FWRITE(nHANGRV,STRTRAN(DTOC(X),"/",""))
               FWRITE(nHANGRV,STRTRAN(STRZERO(nALE,5,2),".",""))
               FWRITE(nHANGRV,STRZERO(VAL(mPIS),12))
               FWRITE(nHANGRV,STRZERO(0,17))
               FWRITE(nHANGRV,"E")
               FWRITE(nHANGRV,cSEQ)
               FWRITE(nHANGRV,"P")
               FWRITE(nHANGRV,PADR(aMOT[Y],100))
               FWRITE(nHANGRV,HB_OsNewLine())
               nSEQ ++
               lALMOCO := .F.
            ENDIF
            nREP := 0
            IF aRELOG[Y] > 0
               NPOS := ASCAN(aREL,aRELOG[Y])
               IF nPOS > 0
                  nREP := aREP[nPOS]
               ENDIF
            ENDIF
            FWRITE(nHANGRV,STRZERO(nSEQ,9))
            FWRITE(nHANGRV,"2")
            FWRITE(nHANGRV,STRTRAN(DTOC(X),"/",""))
            FWRITE(nHANGRV,STRTRAN(STRZERO(aHORAS[Y],5,2),".",""))
            FWRITE(nHANGRV,STRZERO(VAL(mPIS),12))
            FWRITE(nHANGRV,STRZERO(nREP,17))
            FWRITE(nHANGRV,aTIPOM[Y])
            IF aTIPOM[Y] = "D"
               FWRITE(nHANGRV,"00")
            ELSE
               FWRITE(nHANGRV,cSEQ)
            ENDIF
            FWRITE(nHANGRV,aTIPOR[Y])
            FWRITE(nHANGRV,PADR(aMOT[Y],100))
            FWRITE(nHANGRV,HB_OsNewLine())
            nSEQ ++
         NEXT Y
         //Saida Noturno
         IF ASCAN(aTIPOM," ") > 0 .AND. LEN(AHORAS) = 1
            dbselectaR(cPN)
            dbgotop()
            IF dbseek(str(Mnumero,8)+DTOS(X - 1))
               IF ENT > SAI   //horario anterior noite
                  IF aHORAS[1] = SAI
                     aTIPOM[1] = "S"
                  ELSE
                     IF ABS(CHOR(aHORAS[1]) - CHOR(SAI)) <= 0.09  //corrige ajuste manual
                        NETGRVCAM("SAI",aHORAS[1])  //errados
                        aTIPOM[1] = "S"
                        dbselectar(cPM)
                        dbgotop()
                        if dbseek(str(mNUMERO,8)+dtos(X - 1))
                           if !empty(horoc4)
                              IF ABS(CHOR(aHORAS[1]) - CHOR(horoc4)) <= 0.09  //corrige ajuste manual
                                 NETGRVCAM("horoc4",aHORAS[1])  //errados
                              endif
                           endif
                        endif
                     ENDIF
                  ENDIF
               ENDIF
            endif
         ENDIF
         IF ASCAN(aTIPOM," ") > 0
            FOR Y := 1 TO LEN(aHORAS)
               IF EMPTY(aTIPOM[Y])
                  eBUSCA := str(mNUMero,8)+dtos(x)+str(aHORAS[Y],5,2)
                  dbselectar("AFDTERR")
                  dbgotop()
                  if !dbseek(eBUSCA)
                     netrecapp()
                     field->numero := mNUMERO
                     field->data   := x
                     field->hora   := aHORAS[Y]
                  else
                     if !empty(MOTOCO)
                        aTIPOM[ Y ] := "D"
                        aMOT[ Y ]   := MOTOCO
                     endif
                  endif
               endif
            NEXT Y
         ENDIF
         IF ASCAN(aTIPOM," ") > 0
            IF X = zdataini .AND. LEN(aHORAS) = 2
               if aHORAS[2] > aHORAS[1] .AND. aTIPOM[2] = "E" .AND. aTIPOR[2] = "O"
                  dbselectar(cPD)
                  dbgotop()
                  cCHAVE := str(mNUMero,8)+dtos(x)+str(aHORAS[1],5,2)
                  if dbseek(cCHAVE)
                     netreclock()
                     field->TIPOM := "S"
                     FWRITE(nHANERR,STR(mNUMERO,8)+" "+DTOC(X)+" "+STR(aHORAS[1],5,2)+"-"+aTIPOM[1]+"/"+aTIPOR[1]+" Corrigido para Saida ")
                     dbunlock()
                  endif
               endif
            endif
            FWRITE(nHANERR,STR(mNUMERO,8))
            FWRITE(nHANERR," "+DTOC(X)+" "+mCOD+" "+mSOD+" ")
            FOR Y := 1 TO LEN(aHORAS)
               FWRITE(nHANERR,STR(aHORAS[Y],5,2)+"-"+aTIPOM[Y]+"/"+aTIPOR[Y]+" ")
            NEXT Y
            FWRITE(nHANERR,HB_OsNewLine())
         ENDIF
         //
         //
         //
      NEXT X
   ENDIF
   dbselectar(pes)
   dbskip()
ENDDO


FWRITE(nHANGRV,STRZERO(nSEQ,9))
FWRITE(nHANGRV,"9")
FWRITE(nHANGRV,HB_OsNewLine())

FWRITE(nHANJEF,STRZERO(nSJEF,9))
FWRITE(nHANJEF,"9")
FWRITE(nHANJEF,HB_OsNewLine())
FCLOSE(nHANJEF)
FCLOSE(nHANGRV)



cARQHOR := "HORA"+strzero(nREMP,2)+ANOMESW+".TXT"
nHANHOR := FCREATE(cARQHOR)
nFIM    := LEN(aTOTJEF)
aTOTFUN := {"","",0,0,0,0,0,0,0,0}
aTOTGER := {"","",0,0,0,0,0,0,0,0}
mNUMERO := aTOTJEF[1,1]
lDIA    := MDG("Dia a Dia Funcionario")

FWRITE(nHANHOR,"                     100%N   150%N   50%    75%   100%   130%   150% Fal/At"+HB_OSNEWLINE())
//         aadd(aTOTJEF,{NUMERO,DTOC(X),CTA06,CTA19,CTA05,CTA08,CTA09,CTA07,CTA10,nATRASO})
dbselectar("logixvalores")
FOR X := 1 TO Nfim
   IF mNUMERO <> aTOTJEF[X ,  1]
      FWRITE(nHANHOR,STR(mNUMERO)+"            ")
      FOR Z := 3 TO 10
         FWRITE(nHANHOR,STRZERO(aTOTfun[Z],6,2)+" ")
         nhoras := 0
         cCHAVE := STR(NREMP,2)+STR(mNUMERO,8)+STR(ANOUSO,4)+STR(MESTRAB,2)+STR(aCTALOGIX[Z],4)
         dbgotop()
         if dbseek(cCHAVE)
            nhoras := horas
         endif
         if ROund(nHORAS,2) <> round(aTOTfun[Z],2)
            cCHAVE := STR(NREMP,2)+STR(mNUMERO,8)+STR(nANOSEQ,4)+STR(nMESSEQ,2)+STR(aCTALOGIC[Z],4)
            dbgotop()
            if dbseek(cCHAVE)
               nhoras := horas
            endif
            if ROund(nHORAS,2) <> round(aTOTfun[Z],2)
               fwrite(nhanerr,STR(NREMP,2)+" "+STR(mNUMERO)+" "+STR(ANOUSO,4)+" "+STR(MESTRAB,2)+" "+STR(aCTALOGIX[Z],4)+" ")
               fwrite(nhanerr,"Ponto: "+str(aTOTfun[Z],6,2)+"<> Logix:"+str(NHORAS,6,2))
               fwrite(nhanerr,HB_OSNEWLINE())
            else
               fwrite(nhanerr,STR(NREMP,2)+" "+STR(mNUMERO)+" "+STR(ANOUSO,4)+" "+STR(MESTRAB,2)+" "+STR(aCTALOGIX[Z],4)+" ")
               fwrite(nhanerr,"Ponto: "+str(aTOTfun[Z],6,2)+" Logix:"+str(NHORAS,6,2)+" Pgto Conta Complementar "+STR(aCTALOGIC[Z],4))
               fwrite(nhanerr,HB_OSNEWLINE())
            endif
         endif
      NEXT Z
      FWRITE(nHANHOR,HB_OSNEWLINE())
      aTOTFUN := {"","",0,0,0,0,0,0,0,0}
      mNUMERO := aTOTJEF[X,1]
   ENDIF
   IF lDIA
      FWRITE(nHANHOR,STR(aTOTJEF[X ,  1])+" "+aTOTJEF[X ,  2]+" ")
   ENDIF
   FOR Z := 3 TO 10
      IF lDIA
         FWRITE(nHANHOR,STRZERO(aTOTJEF[X ,  Z],6,2)+" ")
      ENDIF
      aTOTFUN[Z] += aTOTJEF[X ,  Z]
      aTOTGER[Z] += aTOTJEF[X ,  Z]
   NEXT Z
   IF lDIA
      FWRITE(nHANHOR,HB_OSNEWLINE())
   ENDIF
NEXT X
FWRITE(nHANHOR,"                     100%N   150%N   50%    75%   100%   130%   150% Fal/At"+HB_OSNEWLINE())
FWRITE(nHANHOR," TotaL Geral        ")
FOR Z := 3 TO 10
   FWRITE(nHANHOR,STRZERO(aTOTGER[Z],6,2)+" ")
NEXT Z
FCLOSE(nHANHOR)
FCLOSE(nHANERR)
DBCLOSEALL()

IF FILESIZE(cARQERR) > 0
   IF MDG("Visualizar Analise-Passagens")
      VERTXT(cARQERR)
   ENDIF
   IF MDG("Imprimir Analise-Passagens")
      IMPARQ(cARQERR)
   ENDIF
ENDIF

IF lCPN
   FOR X := 1 TO LEN(aCPN)
      cFILTRO := "NUMERO="+STR(aCPN[X])
      //ALERTX(cFILTRO)
      FOPTO_12(DCORTE,DCORTF,cFILTRO)
   NEXT X
ENDIF
return


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto3lesc()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto3lesc(eBUSCA,cARQ)

dbselectar(cARQ)
dbgotop()
if dbseek(eBUSCA)
   mRENT := CHOR(ENTREV)
   mRSAI := CHOR(SAIREV)
ENDIF



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ImpHorLogix()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function ImpHorLogix(dDATINI,dDATFIM)

local cConn    := "Provider=MSDASQL.1;Persist Security Info=False;Data Source=ol_logix"
local cCOMANDO := ""
private oConn,oErr,oREGISTRO

if !NETUSE("logixvalores")
   retu
endif


try
oConn := CreateObject("ADODB.Connection")
with object oConn
:ConnectionString := cConn
:Open()
end

cCOMANDO := "SET ISOLATION TO DIRTY READ"
oComm    := CreateObject("ADODB.Command")
with object oComm
:CommandText      := cCOMANDO
:CommandType      := adCmdText
:ActiveConnection := oConn
:Execute()
end

catch oErr
ShowAdoError(oERR,oCoNn,cCOMANDO)
end

oRegistro                := CreateObject('ADODB.RecordSet')
oRegistro:CursorLocation := 3

FOR X := 1 TO 2
   IF X = 1
      cSQL := "SELECT cod_empresa,num_matricula,dat_referencia,cod_evento,qtd_horas FROM hist_movto"
      CSQL += " WHERE cod_evento IN (112,113,146,148,149,193,152,541,116,117,178,180,182,195)"
      CSQL += " AND dat_referencia>='"+STRzero(ANOUSO,4)+"-"+STR(MESTRAB,2)+"'"
   ELSE

      cSQL := " SELECT cod_empresa,num_matricula,dat_referencia,cod_evento,qtd_horas FROM movto_demitidos"
      CSQL += " WHERE cod_evento IN (112,113,146,148,149,193,152,541,116,117,178,180,182,195)"
      cSQL += "    and dat_referencia>='"+dTOC(BOM(dDATFIM))+"'"
      cSQL += "    and dat_referencia<='"+DTOC(EOM(dDATFIM))+"'"
   ENDIF
   TRY
   oRegistro:Open(cSQL,oConN,adOpenForwardOnly,adLockReadOnly)
   catch oErr
   ShowAdoError(oERR,oConn,cSQL)
END
while .not. oregistro:eof
   mEMPRESA   := VAL(oregistro:fields("cod_empresa") :value)
   mMATRICULA := oregistro:fields("num_matricula") :value
   mCODEVENTO := oregistro:fields("cod_evento") :value
   mQTDHORAS  := oregistro:fields("qtd_horas") :value
   dDATAREF   := oregistro:fields("dat_referencia") :value
   mANOEVE    := YEAR(dDATAREF)
   mMESEVE    := MONTH(dDATAREF)
   cCHAVE     := STR(mEMPRESA,2)+STR(mMATRICULA,8)+STR(mANOEVE,4)+STR(mMESEVE,2)+STR(mCODEVENTO,4)
   logixvalores->(dbgotop())
   if !logixvalores->(dbseek(cCHAVE))
      netrecapp()
      logixvalores->EMPRESA := mEMPRESA
      logixvalores->NUMERO  := mMATRICULA
      logixvalores->ANO     := mANOEVE
      logixvalores->MES     := mMESEVE
      logixvalores->EVENTO  := mCODEVENTO
      logixvalores->HORAS   := mQTDHORAS
      dbunlock()
   endif
   oregistro:movenext()
enddo
oregistro:close()
NEXT X
dbcloseall()
oConn:close()





/*

SELECT cod_empresa,num_matricula,dat_referencia,cod_evento,qtd_horas FROM hist_movto
WHERE cod_evento IN (112,113,146,148,149,193,152,541)
AND dat_referencia>="2012-11"


SELECT cod_empresa,num_matricula,dat_referencia,cod_evento,qtd_horas FROM movto_demitidos
WHERE cod_evento IN (112,113,146,148,149,193,152,541)
AND dat_referencia>="01/11/2012"


*/

*+ EOF: fopto_3l.prg
*+
