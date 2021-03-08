*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aop.prg
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
*+    Function M_aop()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function M_aop

PARA cARQOP,cARQOP2
if valtype(cARQOP) # "C"
   cARQOP  := "OP01"
   cARQOP2 := "OP02"
endif


//OP01
//QATR Atraso
//QSEM 1 Semana
//QSE2 2 Semana
//QSAI Estoque
//QIN2 ATR+1   (QATR+QSEM)
//QINI ATR+1+2 (QATR+QSEM+QSE2)
//QSA2 - Saldo Atraso (QATR-QSAI)
//QSAS - Saldo 1      (QATR-QSAI*)
//QSAA - Saldo 2      (QATR-QSAI*)
//QSAI* considerando Semanas Anteriores
//QSAL - Inicial - Estoque Saldo (QINI-QSAI)

priv xOP
priv xQINI

//M_DB("ARQUIVO='"+cARQOP+"'.OR.ARQUIVO='"+cARQOP2+"'")

MAOPCHKSEQ(cARQOP,cARQOP2)

PADRAX(0,,0,{cARQOP,cARQOP2},"OP      Produto"+spac(18)+"Semanas             Total Estoque Produzir",;
 "' '+STR(mOP,6)+' '+mCODIGO+' '+STR(mQATR,6)+' '+STR(mQSEM,6)+' '+STR(mQSE2,6)+' '+STR(mQINI,6)+' '+STR(mQSAI,6)+' '+STR(mQSAL,6)","MAOP01","MAOP01",;
 ,{|| PADDEL("OP02",str(xCHAVE,8,2),"OP","xCHAVE")},{|| MAOP01()},{|| ULTIMOREG("OP01","OP","mOP")},"MAOP")

//Consolida Resultado
MAOP03(,cARQOP,cARQOP2)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOP04()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOP04


mCODMP01  := CODMP01
mCODMP02  := CODMP02
mCODMP02B := CODMP02B
mCODMP02C := CODMP02C
mCODMP02D := CODMP02D
mCODMP03  := CODMP03
mQTTIME   := if(PCHORA > 0,1 / PCHORA,0)
mQTTIM2   := if(PCHOR2 > 0,1 / PCHOR2,0)
mQTTIMM   := if(PCHORMED > 0,1 / PCHORMED,0)
mQTTIMD   := if(PCHORAMD > 0,1 / PCHORAMD,0)
if empty(mQTTIM2)
   mQTTIM2 := mQTTIME
endif
if empty(mQTTIMM)
   mQTTIMM := mQTTIME
endif
if empty(mQTTIMD)
   mQTTIMD := mQTTIME
endif
mDESCRI  := DESCRI
mPULREQ  := PULREQ
mTIPFEC  := TIPFEC
mLIMTIME := LIMTIME
mNOMER   := NOMER
mSETOROP := SETOROP
mFILIAL  := FILIAL
mLEADESP := LEADESP
mFATOR   := FATOR
mCODINT  := CODINT
//if FATOR # 0
//   mQTTIME *= FATOR
//endif
//if FATOR # 0
//   mQTTIM2 *= FATOR
//endif
//if FATOR # 0
//   mQTTIMM *= FATOR
//endif
//if FATOR # 0
//   mQTTIMD *= FATOR
//endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOP03()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOP03(lPER,cARQ,cARQ2)


if valtype(lPER) # "L" .or. lPER = .T.
   if !MDG("Recalcular Saldos")
      retu .F.
   endif
endif
if valtype(cARQ) # "C"
   cARQ  := "OP01"
   cARQ2 := "OP02"
endif
MDS("Aguarde Atualizando Saldos")

if !USEMULT({{cARQ,1,1},{caRQ2,1,1},{"MS06",1,1}})
   retu .F.
endif
dbselectar(cARQ)
INITVARS()
CLRVARS()
dbselectar(cARQ2)
INITVARS()
CLRVARS()

//recalcula saldo OP01
dbselectar(carq)
dbgotop()
while !eof()
   EQUVARS()  //Guarda os Valores
   MAOP02()   //Recalcula Saldos
   netreclock()
   REPLVARS()
   dbunlock()
   dbskip()
enddo



dbselectar(cARQ2)
dbgotop()
while !eof()
   @ 24,00 SAY RECNO()         
   EQUVARS()
   dbselectar(cARQ)
   dbgotop()
   if dbseek(mOP)
      mCODIGO := CODIGO
      @ 24,10 SAY CODIGO         
   endif
   dbselectar("MS06")
   dbgotop()
   if dbseek(mCODIGO+str(mSEQ,3)+str(mSSQ,3))
      MAOP04()
   endif
   dbselectar(cARQ2)
   netreclock()
   REPLVARS()
   dbunlock()
   dbskip()
enddo


dbselectar(cARQ2)
dbgobottom()  //Ultimo Registro
while !bof()
   @ 24,00 SAY RECNO()         
   //   @ 24,10 SAY CODIGO
   xOP    := OP
   lTEMOP := .T.
   nRECNO := recno()
   nSALDO := 0
   //   nFATOR := 1
   nCONJT := 0
   lCONJT := .F.
   nFATJT := 1
   dbselectar(cARQ)
   dbgotop()
   if !dbseek(xOP)
      lTEMOP := .F.
   else
      EQUVARS()   //Guarda os Valores
      MAOP02()  //Recalcula Saldos
      netreclock()
      REPLVARS()
      dbunlock()
   endif
   dbselectar(cARQ2)
   if lTEMOP
      while xOP = OP .and. !bof()
         if SSQ = 99 .and. lCONJT
            nSALDO := nCONJT
            nFATJT := 1
         endif
         netreclock()
         if SSQ <> 99   //
            nSALDO += QPSAI
         endif
         if TIPFEC = "9" .or. TIPFEC = "8"
            nCONJT := nSALDO
            lCONJT := .T.
         endif
         field->QPREF := mQINI
         field->QPINI := mQSAL  //Saldo de Todas Semanas
         //Estoque QPSAI Digitado
         IF FATOR > 0 .AND. TIPFEC = "7"
            nSALDO := QPSAI+(nCONJT * FATOR)
            nFATJT := FATOR
         ENDIF
         field->QPSAL := if(QPINI > QPSAI,QPINI - QPSAI,0)  //Basico
         //         IF nFATJT>0
         //            FIELD->QSA2:=mQSA2*nFATJT
         //            FIELD->QSAS:=mQSAS*nFATJT
         //            FIELD->QSAA:=mQSAA*nFATJT
         //         ENDIF
         field->QPANT := nSALDO   //*nFATOR
         field->QPIN2 := mQSA2 * nFATJT   //Atraso
         field->QPINS := mQSAS * nFATJT   //1o Semana
         field->QPINA := mQSAA * nFATJT   //2o Semana
         nANT         := QPANT
         if QPIN2 > nANT  //Atraso
            field->QPAA2 := QPIN2 - nANT
            nANT         := 0
         else
            field->QPAA2 := 0
            nANT         -= QPIN2
         endif
         if QPINS > nANT  //1a. Semana
            field->QPAAS := QPINS - nANT
            nANT         := 0
         else
            field->QPAAS := 0
            nANT         -= QPINS
         endif
         if QPINA > nANT  //1a. Semana
            field->QPAAA := QPINA - nANT
            nANT         := 0
         else
            field->QPAAA := 0
            nANT         -= QPINA
         endif
         //         IF FATOR>0
         //            nFATOR:=FATOR
         //         ENDIF
         dbunlock()
         dbskip(- 1)
      enddo
   else
      while xOP = OP .and. !bof()
         DELEREG(,,.F.,.F.)
         dbskip(- 1)
      enddo
   endif
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOP02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOP02


local nBASE
if mATIVO = "N"
   mQATR := 0
   mQSEM := 0
   mQSE2 := 0
   mQSAI := 0
endif
mQINI := mQATR+mQSEM+mQSE2
mQIN2 := mQATR+mQSEM
mQSAL := if(mQINI > mQSAI,mQINI - mQSAI,0)  //Total
nBASE := mQSAI

if mQATR > nBASE  //Atraso
   mQSA2 := mQATR - nBASE
   nBASE := 0
else
   mQSA2 := 0
   nBASE -= mQATR
endif

if mQSEM > nBASE  //1a.Semana
   mQSAS := mQSEM - nBASE
   nBASE := 0
else
   mQSAS := 0
   nBASE -= mQSEM
endif

if mQSE2 > nBASE  //2a.Semana
   mQSAA := mQSE2 - nBASE
   nBASE := 0
else
   mQSAA := 0
   nBASE -= mQSE2
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOP01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOP01


if mATIVO = "N"
   ALERTX("OP Nao Ativa")
   PADDEL("OP02",str(xCHAVE,8,2),"OP","xCHAVE")
   retu .F.
endif
if MDG("Revisar Sequencia")
   MAOP02()   //Certifica dos Calculos
   xOP := mOP
   if !USEMULT({{"MS06",1,1},{"OP02",1,99}})
      retu .T.
   endif
   dbselectar("MS06")
   dbgotop()
   dbseek(mCODIGO)
   while mCODIGO = CODIGO .and. !eof()
      mOP  := xOP
      mSEQ := SEQ
      mSSQ := SSQ
      MAOP04()
      if !NOVOOPE("OP02",str(xOP,8,2)+str(mSEQ,3)+str(mSSQ,3))
         netreclock()
         mQPSAI := QPSAI  //Salva o Saldo pois sofrera rplvars
      else
         mQPSAI := 0
      endif
      REPLVARS()
      dbunlock()
      dbselectar("MS06")
      dbskip()
   enddo
   dbcloseall()
   PADRAO(1,1,0,"OP02","OP"+spac(7)+"Seq Ssq Inicial"+spac(6)+"Produzida    a Produzir",;
    "' '+STR(mOP,8,2)+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+STR(mQPINI,12,2)+' '+STR(mQPSAI,12,2)+' '+STR(mQPSAL,12,2)",;
    "MAOP2",,,{|| mOP := xOP},{|| PADARR("OP02",str(xOP,8,2),"OP","xOP")})
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_AOP4()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func m_AOP4()


MDS("Aguarde Calculando Saldos Necessidade Horas")
if !USEMULT({{"OP01",1,1},{"OP02",1,2},{"OP03",0,99},{"MP01",1,1},;
                    {"MP02",1,1},{"OP03B",0,99}})   //OP02-2 Index OP
   retu .F.
endif
dbselectar("OP03")
INITVARS()
CLRVARS()
zap
dbselectar("OP03B")
zap
dbselectar("OP01")
INITVARS()
CLRVARS()
dbgotop()
while !eof()
   @ 24,00 say CODIGO         
   EQUVARS()
   dbselectar("OP02")
   dbgotop()
   dbseek(mOP)
   while mOP = OP .and. !eof()
      if SSQ # 99
         m_AOP4GRV(CODMP01,"E")
         m_AOP4GRV(CODMP02,"H")
         m_AOP4GRV(CODMP02B,"H")
         m_AOP4GRV(CODMP02C,"H")
         m_AOP4GRV(CODMP02D,"H")
      endif
      dbselectar("OP02")
      dbskip()
   enddo
   dbselectar("OP01")
   dbskip()
enddo
dbcloseall()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_AOP4GRV()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func m_AOP4GRV(cCOD,cTIPO)


if !empty(cCOD)
   mCODMP01 := cCOD
   mQTTIME  := QTTIME
   mQTTIM2  := QTTIM2
   mQTTIMM  := QTTIMM
   mQTTIMD  := QTTIMD
   mSEQ     := SEQ
   mSSQ     := SSQ
   mCOGMP01 := ""
   mFILIAL  := FILIAL
   mQPRO    := QPAA2+QPAAS+QPAAA
   dbselectar(if(cTIPO = "E","MP01","MP02"))
   dbgotop()
   if dbseek(cCOD)
      mCOGMP01 := COGNOME
   endif
   NOVOOPA(if(cTIPO = "E","OP03","OP03B"))  //Grava Sempre Soma via Relatorio
endif
dbselectar("OP02")
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPCALSET()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPCALSET


MAOP03()
nDIAPRZ  := 2
nHORAS   := 15.58
cTEMPO   := "I"
cSEMANA  := "S"
xURGEN02 := "S"
xURGEN03 := "S"
MDI("Calcular Lead-Time Setor")
@ 10,00 say "Dias Pre Desconto"                                                           
@ 11,00 say "Horas Dias Referencia"                                                       
@ 12,00 say "Calculo Tempo (P)adr∆o (M)edia (I)nte"                                       
@ 13,00 say "Urgencia 1ß Sem 2ß Sem"                                                      
@ 14,00 say "Estrategia (S)emanal (A)Vig+1¶Sem"                                           
@ 15,00 say "(T)Vig+1¶+2¶ (B)Vig 1ß+2ß"                                                   
@ 10,40 get nDIAPRZ                                                                       
@ 11,40 get nHORAS                                                                        
@ 12,40 get cTEMPO                                  pict "!" valid cTEMPO $ "PMI"         
@ 13,40 get xURGEN02                                pict "!" valid xURGEN02 $ " SN"       
@ 13,44 get xURGEN03                                pict "!" valid xURGEN03 $ " SN"       
@ 14,40 get cSEMANA                                 pict "!" valid cSEMANA $ "SATB"       
if !READCUR()
   retu .F.
endif
FILTRO := ''
FILTRO := RFILORD("OP02",.F.)

if !USEMULT({{"OP01",1,1},{"OP02",1,1},{"OP02SET",0,99},{"OP02SEX",0,99},;
                    {"MS06",1,1},{"MS03",1,2},{"MP01",1,1},{"ETI",1,1},{"FERRAM",1,1}})
   retu .F.
endif
dbselectar("OP01")
INITVARS()
CLRVARS()
dbselectar("OP02")
INITVARS()
CLRVARS()
if !empty(FILTRO)
   set filter to &FILTRO.
endif
dbselectar("OP02SET")
zap
INITVARS()
CLRVARS()
dbselectar("OP02SEX")
zap
INITVARS()
CLRVARS()
dbselectar("OP02")
dbgotop()
while !eof()
   @ 23,00 say "Calculando Horas"         
   @ 24,00 say mCODIGO                    
   EQUVARS()
   if mSSQ <> 99
      mLIMTIME  := 1
      mPCHORMEQ := 0
      mPCHORINT := 0
      mPCHORA   := 0
      mCODMP03  := ""
      mNUMFERR  := 0
      dbselectar("MS06")
      dbgotop()
      if dbseek(mCODIGO+str(mSEQ,3)+str(mSSQ,3))
         mLIMTIME  := LIMTIME
         mPCHORMEQ := PCHORMEQ
         mPCHORINT := PCHORAMD
         mPCHORA   := PCHORA
         mCODMP03  := CODMP03
         mSETOROP  := SETOROP
         mNOMER    := NOMER
         mFILIAL   := FILIAL
         mLEADESP  := LEADESP
         mFERRAMEN := ALLTRIM(FERRAMEN)
         IF !EMPTY(mFERRAMEN)
            DBSELECTAR("FERRAM")
            DBGOTOP()
            IF DBSEEK(mFERRAMEN)
               mNUMFERR := NUMERO
            ENDIF
         ENDIF
      endif
      dbselectar("MS03")
      dbgotop()
      if dbseek(mCODIGO+str(mSEQ,3)+str(mSSQ,3))
         netreclock()
         field->QPAA2 := mQPAA2
         field->QPAAS := mQPAAS
         field->QPAAA := mQPAAA
         dbunlock()
      endif
      dbselectar("MP01")
      dbgotop()
      if dbseek(mCODMP01)
         mCOGMP01 := COGNOME
      endif
      dbselectar("OP01")
      dbgotop()
      if dbseek(mOP)
         EQUVARS()
         dbselectar("OP02SET")
         for X := 1 to 3
            mSEMANA := str(X,1)
            do case
               case X = 1 .and. cSEMANA = "S"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2
                  mQTDEUSO := mQPAA2
               case X = 2 .and. cSEMANA = "S"
                  mDATAINI := mDATAS
                  mQTDEINI := mQPAAS
                  mQTDEUSO := mQPAAS
               case X = 3 .and. cSEMANA = "S"
                  mDATAINI := mDATA2
                  mQTDEINI := mQPAAA
                  mQTDEUSO := mQPAAA
               case X = 1 .and. cSEMANA = "B"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2
                  mQTDEUSO := mQPAA2
               case X = 2 .and. cSEMANA = "B"
                  mDATAINI := mDATAS
                  mQTDEINI := mQPAAS+mQPAAA
                  mQTDEUSO := mQPAAS+mQPAAA
               case X = 1 .and. cSEMANA = "A"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2+mQPAAS
                  mQTDEUSO := mQPAA2+mQPAAS
               case X = 2 .and. (cSEMANA = "A" .or. cSEMANA = "T")
                  mDATAINI := ctod(space(8))
                  mQTDEINI := 0
                  mQTDEUSO := 0
               case X = 3 .and. (cSEMANA = "A" .or. cSEMANA = "T" .or. cSEMANA = "B")
                  mDATAINI := ctod(space(8))
                  mQTDEINI := 0
                  mQTDEUSO := 0
               case X = 1 .and. cSEMANA = "T"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2+mQPAAS+mQPAAA
                  mQTDEUSO := mQPAA2+mQPAAS+mQPAAA
            endcase
            if mQTDEINI > 0
               mDESCRI   := TIRACE(mDESCRI)
               mDATAPRZ  := mDATAINI - nDIAPRZ
               mPCHORNEC := 0
               if cTEMPO = "I" .and. mPCHORINT > 0
                  mPCHORMEQ := 1 / mPCHORINT
               endif
               if (cTEMPO = "P" .or. mPCHORMEQ = 0) .and. mPCHORA > 0
                  mPCHORMEQ := 1 / mPCHORA
               endif
               mPCHORNEC := mPCHORMEQ * mQTDEUSO
               mPRELEAD  := round((mPCHORNEC / nHORAS)+.5,0)
               if mPRELEAD = 0
                  mPRELEAD := 1
               endif
               if mSETOROP = "X"  //Nao Distribuir
                  mPRELEAD := 0
               endif
               if mSETOROP = "F"
                  mPRELEAD := 1   //Contar Embalar
               endif
               if mLEADESP > 0  //Lead Time Especificado + Pre Lead
                  mPRELEAD := mLEADESP+mPRELEAD
               endif
               if !empty(mCODMP03)
                  dbselectar("ETI")
                  dbgotop()
                  if dbseek(mCODMP03)
                     if LEADTIME > 0
                        mPRELEAD := LEADTIME
                     endif
                     mCOGMP01 := COGNOME
                  endif
               endif
               dbselectar("OP02SET")
               netrecapp()
               REPLVARS()
            endif
         next X
      endif
   endif
   dbselectar("OP02")
   dbskip()
enddo
dbselectar("MS06")
dbclosearea()
dbselectar("OP02")
dbclosearea()
dbselectar("MP01")
dbclosearea()
dbselectar("OP02SET")
dbsetorder(5)
dbgotop()
while !eof()
   @ 23,00 say "Calculando Dias"         
   @ 24,00 say CODIGO                    
   mCODIGO  := CODIGO
   mSEMANA  := SEMANA
   dDATAINI := DATAINI - nDIAPRZ
   while alltrim(mCODIGO) = alltrim(CODIGO) .and. mSEMANA = SEMANA .and. !eof()
      netreclock()
      field->DATAPRZ := dDATAINI
      field->DATA    := DATAPRZ - PRELEAD
      field->LIMTIME := PRELEAD
      dbunlock()
      dDATAINI := DATA
      dbskip()
   enddo
enddo
dbselectar("OP02SET")
dbgotop()
while !eof()
   @ 23,00 say "Verificando Urgencias"         
   @ 24,00 say CODIGO                          
   @ 24,30 say SEQ                             
   @ 24,40 say SSQ                             
   EQUVARS()
   dbselectar("OP01")
   dbgotop()
   if dbseek(mOP)
      mDATAI01 := DATAA
      mDATAI02 := DATAS
      mDATAI03 := DATA2
   endif
   dbselectar("OP02SEX")
   dbgotop()
   if !dbseek(mCODIGO+str(mSEQ,3)+str(mSSQ,3))
      netrecapp()
      REPLVARS()
   endif
   dbselectar("OP02SEX")
   if dow(mDATA) = 1  //Se cai no Domingo
      mDATA --  //inicia no sabado
   endif
   if mSEMANA = "1"
      field->URGEN01 := "S"
      field->PRAZO01 := mDATAPRZ
      field->INICI01 := mDATA
      field->QTDDE01 := mQTDEINI
      field->TEMPO01 := mLIMTIME
      field->HORA01  := mPCHORNEC
      //      FIELD->DATAI01:=mDATAINI
   endif
   if mSEMANA = "2"
      field->URGEN02 := "N"
      field->INICI02 := mDATA
      field->PRAZO02 := mDATAPRZ
      field->QTDDE02 := mQTDEINI
      field->TEMPO02 := mLIMTIME
      field->HORA02  := mPCHORNEC
      //      FIELD->DATAI02:=mDATAINI
   endif
   if mSEMANA = "3"
      field->URGEN03 := "N"
      field->INICI03 := mDATA
      field->PRAZO03 := mDATAPRZ
      field->QTDDE03 := mQTDEINI
      field->TEMPO03 := mLIMTIME
      field->HORA03  := mPCHORNEC
      //      FIELD->DATAI03:=mDATAINI
   endif
   dbselectar("OP02SET")
   dbskip()
enddo
dbselectar("OP02SEX")
dbgotop()
while !eof()
   @ 23,00 say "Checando datas Urgencia"         
   @ 24,00 say CODIGO                            

   mDATAREF := INICI01
   if empty(mDATAREF)
      mDATAREF := INICI02
   endif
   if empty(mDATAREF)
      mDATAREF := INICI03
   endif
   field->DATAREF := mDATAREF
   if PRAZO02 <= DATAI01
      field->URGEN02 := "S"
   endif
   if PRAZO03 <= DATAI01
      field->URGEN03 := "S"
   endif
   if empty(URGEN01) .or. QTDDE01 = 0
      field->URGEN01 := "N"
   endif
   if empty(URGEN02) .or. QTDDE02 = 0
      field->URGEN02 := "N"
   endif
   if empty(URGEN03) .or. QTDDE03 = 0
      field->URGEN03 := "N"
   endif
   if !empty(xURGEN02) .and. QTDDE02 > 0
      field->URGEN02 := xURGEN02
   endif
   if !empty(xURGEN03) .and. QTDDE03 > 0
      field->URGEN03 := xURGEN03
   endif
   dbskip()
enddo

dbselectar("OP02SEX")
dbgotop()
while !eof()
   @ 23,00 say "Verificando Data Base-Produto"         
   @ 24,00 say padr(CODIGO,24)                         
   mCODIGO  := CODIGO
   mDATABAS := DATAREF
   mDATABA2 := ctod(space(8))
   mDATABA3 := ctod(space(8))
   mTEM01   := "N"
   nREG     := recno()
   while alltrim(mCODIGO) = alltrim(CODIGO) .and. !eof()
      if QTDDE01 > 0
         mTEM01 := "S"
      endif
      if DATAREF <= mDATABAS
         mDATABAS := DATAREF
      endif
      if !empty(INICI01)
         if INICI01 <= mDATABA2 .or. empty(mDATABA2)
            mDATABA2 := INICI01
         endif
      endif
      if !empty(INICI02)
         if INICI02 <= mDATABA3 .or. empty(mDATABA3)
            mDATABA3 := INICI02
         endif
      endif
      if !empty(INICI03)
         if INICI03 <= mDATABA3 .or. empty(mDATABA3)
            mDATABA3 := INICI03
         endif
      endif
      dbskip()
   enddo
   dbgoto(nREG)
   while alltrim(mCODIGO) = alltrim(CODIGO) .and. !eof()
      field->DATABAS := mDATABAS
      field->DATABA2 := mDATABA2
      field->DATABA3 := mDATABA3
      field->TEM01   := mTEM01
      dbskip()
   enddo
enddo

dbselectar("OP02SEX")
dbsetorder(2)   //SetorOP Codigo
dbgotop()
while !eof()
   @ 23,00 say "Verificando Data Base-Produto-Setor"         
   @ 24,00 say padr(CODIGO,24)                               
   mCODIGO  := CODIGO
   mSETOROP := SETOROP
   mDATABA4 := ctod(space(8))
   nREG     := recno()
   while SETOROP = mSETOROP .and. alltrim(mCODIGO) = alltrim(CODIGO) .and. !eof()
      if !empty(INICI01)
         if INICI01 <= mDATABA4 .or. empty(mDATABA4)
            mDATABA4 := INICI01
         endif
      endif
      if !empty(INICI02)
         if INICI02 <= mDATABA4 .or. empty(mDATABA4)
            mDATABA4 := INICI02
         endif
      endif
      if !empty(INICI03)
         if INICI03 <= mDATABA4 .or. empty(mDATABA4)
            mDATABA4 := INICI03
         endif
      endif
      dbskip()
   enddo
   dbgoto(nREG)
   while SETOROP = mSETOROP .and. alltrim(mCODIGO) = alltrim(CODIGO) .and. !eof()
      field->DATABA4 := mDATABA4
      dbskip()
   enddo
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OPSEXMK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func OPSEXMK


PADRAO(0,1,0,"OP01","OP Codigo     Cliente      Saldos","STR(mOP,3)+' '+mCODIGO+' '+STR(mCLIENTE,8)+' '+mCOGNOME+' '+STR(QATR,8)+' '+STR(QSEM,8)+' '+STR(QSE2,8)","OP",;
 ,,,,,{|| OPSEXMKPOS()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OPSEXMKPOS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func OPSEXMKPOS


mURGEN02 := "S"
mURGEN03 := "S"
MDS("Digite o Codigo")
@ 24,50 say "1ß Sem"                                      
@ 24,60 say "2ß Sem"                                      
@ 24,20 say mCODIGO                                       
@ 24,58 get mURGEN02 pict "!" valid mURGEN02 $ "SN"       
@ 24,68 get mURGEN03 pict "!" valid mURGEN03 $ "SN"       
if !READCUR()
   retu .T.   //True Encerrar Block
endif
if !USEREDE("OP02SEX",1,99)
   retu .T.   //True Encerrar Block
endif
dbgotop()
dbseek(alltrim(mCODIGO))
while alltrim(mCODIGO) = alltrim(CODIGO) .and. !eof()
   netreclock()
   if QTDDE02 > 0 .and. mURGEN02 = "S"
      field->URGEN02 := "S"
   endif
   if QTDDE03 > 0 .and. mURGEN03 = "S"
      field->URGEN03 := "S"
   endif
   if QTDDE02 = 0 .or. mURGEN02 = "N"
      field->URGEN02 := "N"
   endif
   if QTDDE03 = 0 .or. mURGEN03 = "N"
      field->URGEN03 := "N"
   endif
   dbunlock()
   dbskip()
enddo
dbcloseall()
retu .T.  //True Encerrar Block


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPX


cORI := "PCP\OP01.DBF"
cDES := "PCP\OP01X.DBF"
fileCOPY( cORI,cDES)
cORI := "PCP\OP02.DBF"
cDES := "PCP\OP02X.DBF"
filecopy(cORI,cDES)
//Reindexa pois hove copia somentes do dbf
M_DB("ARQUIVO='OP01X'.OR.ARQUIVO='OP02X'")

M_AOP3("OP01X","OP02X",.F.)

MAOP2CAL(.T.,.F.,.T.,"OP01X","OP02X",.F.)   //Estoque,Data,Est.proc FILTRO

if !USEMULT({{"OP02X",1,1},{"MS03",1,2}})
   retu .F.
endif
dbselectar("OP02X")
dbgotop()
while !eof()
   mCODIGO := CODIGO
   mSEQ    := SEQ
   mSSQ    := SSQ
   mQPAA2  := QPAA2
   mQPAAS  := QPAAS
   mQPAAA  := QPAAA
   dbselectar("MS03")
   dbgotop()
   if dbseek(mCODIGO+str(mSEQ,3)+str(mSSQ,3))
      netreclock()
      field->XPAA2 := mQPAA2
      field->XPAAS := mQPAAS
      field->XPAAA := mQPAAA
      dbunlock()
   endif
   dbselectar("OP02X")
   dbskip()
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPVMES01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPVMES01


if !USEREDE("OP01",0,99)
   retu .F.
endif

nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netGRVCAM("VPRG",QATR+QSEM+QSE2)},,{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("VQUI",QSEM+QSE2)},,{|| zei_fort(nLASTREC,,,1)})
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AOP5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func M_AOP5()


MDS("Aguarde Calculando Cargas Execessivas")

aRETU := PERFEC({"PE01BX"},{"PE"},{"PE99"},{"PADRAO"})
cARQ  := aRETU[5,1]
if !USEMULT({{CARQ,1,0},{"PE01AP",0,99}})
   retu .F.
endif
dbselectar("PE01AP")
zap
dbselectar(CARQ)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","str(pedido,8)+str(item,3)+dtos(datasai)")
ordSetFocus("temp")


INITVARS()
CLRVARS()
set filter to NRNOTASAI > 0
dbgotop()
while !eof()
   mPEDIDO  := PEDIDO
   mITEM    := ITEM
   nRECNO   := recno()
   lGRAVA   := .F.
   mDATASAI := DATASAI
   while mPEDIDO = PEDIDO .and. mITEM = ITEM .and. !eof()
      if mDATASAI <> DATASAI
         lGRAVA := .T.
      endif
      dbskip()
   enddo
   dbgoto(nRECNO)
   while mPEDIDO = PEDIDO .and. mITEM = ITEM .and. !eof()
      if lGRAVA
         EQUVARS()
         NOVOOPA("PE01AP")
      endif
      dbselectar(CARQ)
      dbskip()
   enddo
   dbselectar(CARQ)
enddo
dbcloseall()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPZERVOL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPZERVOL()


local cMES := cPRG := cQUI := cMED := cMEQ := "N"
MDI(" › Zerar Volumes")
@ 10,00 say "Zerar"                               
@ 11,00 say "Volume Manual"                       
@ 12,00 say "Programa"                            
@ 13,00 say "Programa Quinzena"                   
@ 14,00 say "Media Acumulada"                     
@ 15,00 say "Media Acum.Quinzena"                 
@ 11,30 get cMES                  pict "!"        
@ 12,30 get cPRG                  pict "!"        
@ 13,30 get cQUI                  pict "!"        
@ 14,30 get cMED                  pict "!"        
@ 15,30 get cMEQ                  pict "!"        
if !READCUR()
   retu .F.
endif
if !MDG("Zerar Lanáamentos")
   retu .F.
endif
if !USEREDE("OP01",1,99)
   retu .F.
endif
dbgotop()
while !eof()
   netreclock()
   if cMES = "S"
      field->VMES := 0
   endif
   if cPRG = "S"
      field->VPRG := 0
   endif
   if cQUI = "S"
      field->VQUI := 0
   endif
   if cMED = "S"
      field->VMED := 0
   endif
   if cMEQ = "S"
      field->VMEQ := 0
   endif
   dbunlock()
   dbskip()
enddo
dbcloseall()
m_AOP4()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPCHKSEQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOPCHKSEQ(cARQOP,cARQOP2)


if !USEREDE(cARQOP2,1,99)
   retu .F.
endif
dbgotop()
while !eof()
   @ 24,00 say recno()         
   mOP  := OP
   mSEQ := SEQ
   mSSQ := SSQ
   dbskip()
   if !eof()
      if mOP = OP .and. SEQ = mSEQ .and. SSQ = mSSQ
         DELEREG(,,,.F.,)
      endif
   endif
enddo
dbcloseall()
//M_DB("ARQUIVO='"+cARQOP+"'.OR.ARQUIVO='"+cARQOP2+"'")



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OP02MS06()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC OP02MS06

if !USEMULT({{"MS06",1,1},{"OP01",1,99},{"OP02",1,99}})
   retu .T.
endif
nHANDLE := FCREATE("OP02MS06.TXT")
cPECAS  := ""
dbselectar("MS06")
INITVARS()
CLRVARS()
dbselectar("OP01")
INITVARS()
CLRVARS()
dbselectar("OP02")
INITVARS()
CLRVARS()

DBSELECTAR("OP01")
DBGOTOP()
WHILE !EOF()
   EQUVARS()
   MAOP02()   //Certifica dos Calculos
   xOP := mOP
   dbselectar("MS06")
   dbgotop()
   dbseek(mCODIGO)
   IF ALLTRIM(mCODIGO) <> ALLTRIM(CODIGO)
      ALERTX("Importar Sequencia Produto"+mCODIGO)
      FWRITE(nHANDLE,mCODIGO+CHR(13)+CHR(10))
   ENDIF
   while mCODIGO = CODIGO .and. !eof()
      mOP  := xOP
      mSEQ := SEQ
      mSSQ := SSQ
      MAOP04()
      if !NOVOOPE("OP02",str(xOP,8,2)+str(mSEQ,3)+str(mSSQ,3))
         netreclock()
         mQPSAI := QPSAI  //Salva o Saldo pois sofrera rplvars
      else
         mQPSAI := 0
      endif
      REPLVARS()
      dbunlock()
      dbselectar("MS06")
      dbskip()
   enddo
   DBSELECTAR("OP01")
   dbskip()
enddo
dbcloseall()
FCLOSE(nHANDLE)

