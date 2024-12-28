*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_23.prg
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
*+    Documentado em 27-Dez-2024 as  9:32 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


//empresa 89 testes de calculos semanais


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_23()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fopto_23

para cFILTRO


CABE2('FOPTO_23 - Totalizar o Ponto')
aVI    := PEGCX("I")
aFS    := PEGCX("F")
nMES   := MESTRAB
nANO   := ANOUSO
aEMP89 := {}


if !netuse("foptoval")
   retu .F.
endif
if !dbseek(nremp)
   dbgotop()
endif
aVAL := {FVAL01,FVAL02,FVAL03,FVAL04,FVAL05,FVAL06,FVAL07,FVAL08,;
 FVAL09,FVAL10,FVAL11,FVAL12,FVAL13,FVAL14,FVAL15,FVAL16,;
 FVAL17,FVAL18,FVAL19,FVAL20,FVAL21,FVAL22,FVAL23,FVAL24}
aFIN := {FFIN01,FFIN02,FFIN03,FFIN04,FFIN05,FFIN06,FFIN07,FFIN08,;
 FFIN09,FFIN10,FFIN11,FFIN12,FFIN13,FFIN14,FFIN15,FFIN16,;
 FFIN17,FFIN18,FFIN19,FFIN20,FFIN21,FFIN22,FFIN23,FFIN24}

dbcloseall()

if !NETUSE("FOPTOBCO",,,,,.F.,)
   retu .F.
endif
cBCOTT := BCOTT
cBCOFT := BCOFT
dbcloseall()

cPN := "PN"+ANOMESW
cPT := "PT"+ANOMESW
cPD := "PD"+ANOMESW
cPS := "PS"+ANOMESW
cPO := "PO"+ANOMESW

if !netuse(pes)
   retu
endif
INITVARS()
CLRVARS()

if valtype(cFILTRO) = "C"
   FILTRO := cFILTRO
else
   FILTRO := ""
   FI     := trim(FILTRO)
   FILTRO := FILTRO(FI)
endif
set filter to &FILTRO

if !netuse(cPN)
   dbcloseall()
   return
endif

if !NETUSE(cPT)
   dbcloseall()
   retu
endif

if !NETUSE(cPS)
   dbcloseall()
   retu
endif

if !NETUSE(cPO)
   dbcloseall()
   return
endif


if !netuse("fo_ptt")
   dbcloseall()
   return
endif
initvars()
clrvars()

if !netuse(if(lSECBCO,"BCOBAK","BCOHRS"))
   dbcloseALL()
   retu
endif
cALIAS6 := ALIAS()


mMES := MESTRAB
mANO := ANOUSO

aTOT := array(24)
aSEM := array(24)
aUSO := ARRAY(24)

dbselectar(pes)
dbgotop()
while !eof()
   dbselectar(pes)
   PETELA(8)
   IF ((EMPTY(DEMITIDO)) .OR. (MONTH(DEMITIDO) >= nMES .AND. YEAR(DEMITIDO) >= nANO))
      VALPIS(PIS,.T.,.F.,FIELD->EVINC)
   ENDIF
   TSA := TIPO
   AFILL(aTOT,0)
   AFILL(aSEM,0)
   for X := 1 to 24
      cVAR := aVI[X]
      if !empty(cVAR)
         aTOT[X] = &CVAR.
      endif
   next X
   nBCOHRS := 0
   lTEM    := .F.
   EQUVARS()
   NUM     := NUMERO
   NOM     := NOME
   BUSCA   := str(NUM,8)
   nHORBCO := 0
   nDIABCO := 0
   nRECNO  := 0

   dbselectar(cALIAS6)
   nHORBCO := pegsaldobco(NUM,nANOANT,nMESANT,.F.)

   dbselectar("fo_ptt")
   aTOTANO := PEGTOTANO(NUM,.F.)


   TA01 := aTOTANO[1]   //inicia totais anuais
   TA02 := aTOTANO[2]
   TA03 := aTOTANO[3]
   TA04 := aTOTANO[4]
   TA05 := aTOTANO[5]
   TA06 := aTOTANO[6]
   TA07 := aTOTANO[7]
   TA08 := aTOTANO[8]
   TA09 := aTOTANO[9]
   TA10 := aTOTANO[10]
   TA11 := aTOTANO[11]
   TA12 := aTOTANO[12]
   TA13 := aTOTANO[13]
   TA14 := aTOTANO[14]
   TA15 := aTOTANO[15]
   TA16 := aTOTANO[16]
   TA17 := aTOTANO[17]
   TA18 := aTOTANO[18]
   TA19 := aTOTANO[19]
   TA20 := aTOTANO[20]
   TA21 := aTOTANO[21]
   TA22 := aTOTANO[22]
   TA23 := aTOTANO[23]
   TA24 := aTOTANO[24]

   // 50 %  100%FE/FO 100%N FE/FO 50%N
   TANO59 := aTOTANO[5]+aTOTANO[9]+aTOTANO[6]+aTOTANO[17]
   lANO59 := tANO59 >= 286

   T01 := T02 := T03 := T04 := T05 := T06 := T07 := T08 := 0
   T09 := T10 := T11 := T12 := T13 := T14 := T15 := T16 := 0
   T17 := T18 := T19 := T20 := T21 := T22 := T23 := T24 := 0


   dbselectar(cPN)
   dbgotop()
   dbseek(BUSCA)
   while NUMERO = NUM .and. !eof()
      lTEM := .T.
      for x := 1 to 24
         cVAR   := "T"+strzero(X,2)
         &cVAR. := aTOT[X]
      next x
      aFILL(aUSO,0)
      for X := 1 to 24
         IF AT("ITAESBRA",ZEMPRESA) > 0 .OR. AT("IMBRIZI",ZEMPRESA) > 0   //Calculos especiais Clientes
            nDIFHN := 0
            netreclock()
            IF X = 4 .AND. CTA04 > 0  // 100% 150% (Noturna)
               IF aTOT[4]+CTA04 <= 8
                  FIELD->CTA06 := CTA04
               ELSE
                  IF aTOT[4] > 8
                     FIELD->CTA19 := CTA04
                  ELSE
                     nDIFHN       := 8 - aTOT[4]
                     FIELD->CTA06 := nDIFHN
                     FIELD->CTA19 := CTA04 - nDIFHN
                  ENDIF
               ENDIF
            ENDIF
            IF X = 2 .AND. CTA02 > 0  // 100% 150%
               IF aTOT[2]+CTA02 <= 8
                  if lANO59
                     FIELD->CTA07 := nDIFHN   //130 %
                     FIELD->CTA09 := 0
                  else
                     FIELD->CTA09 := CTA02  //100 %
                  endif
               ELSE
                  IF aTOT[2] > 8
                     FIELD->CTA10 := CTA02  // 150 %
                  ELSE
                     nDIFHN := 8 - aTOT[2]
                     if lANO59
                        FIELD->CTA07 := nDIFHN  //130 %
                        FIELD->CTA09 := 0
                     ELSE
                        FIELD->CTA09 := nDIFHN  //100 %
                     ENDIF
                     FIELD->CTA10 := CTA02 - nDIFHN   // 150 %
                  ENDIF
               ENDIF
            ENDIF
            IF X = 1 .AND. CTA01 > 0  // 50% 75%
               IF aTOT[1]+CTA01 <= 30
                  if lANO59
                     FIELD->CTA08 := CTA01  // 75%
                     FIELD->CTA05 := 0
                  else
                     FIELD->CTA05 := CTA01  // 50%
                  endif
               ELSE
                  IF aTOT[1] > 30
                     FIELD->CTA08 := CTA01  // 75%
                  ELSE
                     nDIFHN := 30 - aTOT[1]
                     if lANO59
                        FIELD->CTA08 := CTA01   //nDIFHN    // 75%
                        FIELD->CTA05 := 0
                     else
                        FIELD->CTA05 := nDIFHN  // 50%
                        FIELD->CTA08 := CTA01 - nDIFHN  // 75%
                     endif
                  ENDIF
               ENDIF
            ENDIF
            dbunlock()
         ENDIF

         cVAR   := aFS[X]
         cVARTA := "TA"+strzero(X,2)
         if !empty(cVAR)
            aTOT[X] = &CVAR.
            aUSO[ X ] := &CVAR.
            &cVARTA.  := aTOTANO[X]+&CVAR.  //Soma com o incial para evitar soma acumulativa
         else
            cVAR := "CTA"+strzero(X,2)
            aTOT[X] += &cVAR.
            aUSO[ X ] := &CVAR.
            &cVARTA.  := aTOTANO[X]+&CVAR.  //Soma com o incial para evitar soma acumulativa
         endif
         cVAR   := "T"+STRZERO(X,2)
         &cVAR. := aTOT[X]

      next X


      if BCOSN = "S" .OR. BCOHRS <> 0.00
         nBCOHRS := if(empty(cBCOTT),nBCOHRS+BCOHRS,&cBCOTT)
      endif
      FOR X := 1 TO 24
         aSEM[X] += aUSO[X]
      NEXT X
      mDATA := DATA

      dbselectar(cPN)
      dbskip()


      IF DOW(mDATA) = 1   //.OR. NUMERO <> NUM .OR. Eof() //Total da Semana //1=domingo ou ultima semana
         mSEMINI := mDATA
         WHILE DOW(mSEMINI) <> 2
            mSEMINI --
         ENDDO
         if mSEMINI < zdataini
            mSEMINI := zdataini
         endif
         dbselectar(cPS)
         DBGOTOP()
         IF !DBSEEK(STR(NUM,8)+DTOS(mDATA))
            netrecapp()
            FIELD->NUMERO := NUM
            FIELD->SEMFIM := mDATA
            FIELD->SEMINI := mDATA - 6
            field->NOME   := NOM
            FIELD->MES    := nMES
            FIELD->ANO    := nANO
         ELSE
            netreclock()
         ENDIF
         FOR X := 1 TO 24
            cVAR          := "CTA"+strzero(X,2)
            FIELD->&cVAR. := aSEM[X]
         NEXT X
         IF NREMP = 89 .and. DOW(mDATA) = 1
            FIELD->CTA04 := INT(CTA03 / 60)+(MOD(CTA03,60) / 100)
            FIELD->CTA05 := CTA03 - 2190  //IF(NUMERO=99995,1590,2190) 1590 minutos 26h30min 2190 minutos 36h30min agora todos 36:30'
            FIELD->CTA06 := INT(ABS(CTA05) / 60)+(MOD(ABS(CTA05),60) / 100)
            AADD(aEMP89,{NUM,mDATA,CTA03,CTA04,CTA05,CTA06})
         ENDIF
         DBUNLOCK()
         AFILL(aSEM,0)
      ENDIF

      dbselectar(cPN)
   enddo
   if lTEM
      //Fechando os Valores
      for W := 1 to 24
         cVAL := aFIN[W]
         if !empty(cVAL)
            aTOT[ W ] := &cVAL.
         endif
      next W
      dbselectar(cPT)
      dbgotop()
      if !dbseek(NUM)
         netrecapp()
         field->NUMERO := NUM
         field->NOME   := NOM
         FIELD->MES    := nMES
         FIELD->ANO    := nANO
      else
         netreclock()
      endif
      //Calculando as Horas
      for X := 1 to 24
         cVAR         := "CTA"+strzero(X,2)
         field->&cVAR := aTOT[X]
      next X
      field->BCOHRS := if(empty(cBCOFT),nBCOHRS,&cBCOFT)
      //field->BCOHRS := nBCOHRS
      //Calculando os Valores
      for W := 1 to 24
         if !empty(aVAL[W])
            cVAL          := aVAL[W]
            fVAL          := "VAL"+strzero(W,2)
            field->&fVAL. := &cVAL.
         endif
      next W
      dbunlock()
      equvars()
      dbselectar("fo_ptt")
      dbgotop()
      if !dbseek(str(mNUMERO,8)+str(mANO,4)+str(mMES,2))
         netrecapp()
      else
         netreclock()
      endif
      replvars()
   endif
   dbselectar(pes)
   dbskip()
enddo
IF LEN(aEMP89) > 0
   FOR X := 1 TO LEN(aEMP89)
      dbselectar(cPN)
      dbgotop()
      if dbseek(str(Aemp89[x ,  1],8)+dtos(Aemp89[x ,  2]))
         netreclock()
         field->CTA13 := aEMP89[X,3]
         field->CTA14 := aEMP89[X,4]
         field->CTA15 := aEMP89[X,5]
         field->CTA16 := aEMP89[X,6]
         dbunlock()
      endif
   NEXT X
ENDIF
dbcloseall()
return


*+ EOF: fopto_23.prg
*+
