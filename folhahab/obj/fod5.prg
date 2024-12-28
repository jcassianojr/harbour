*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fod5.prg
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
*+    Documentado em 27-Dez-2024 as  9:45 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fod5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fod5

para NN
CABEX("Calculando Folha")
if NN = 1
   CC1A := PES
   CC1B := PES
   CC2A := "CONTAS"
   CC2B := "CONTAS"
   CC3  := SEM
else
   CC1A := "MG01"
   CC1B := "MG01"
   CC2A := "CTARPA"
   CC2B := "CTARPA"
   CC3  := RPA
endif
aCOD    := {}
aDAD    := {}
mSEMANA := PEGSEMANA()
if mSEMANA = 99
   retu .F.
endif

MDS('Aguarde Carregando Tabela de IRRF')
QTDEIRRF   := VDEPENDE := DESC_MINIMO := SALFAMILIA := IRRF1 := IRTX1 := IRPA1 := 0
TETOFAMIL  := SALFAMIL1 := 0
IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
mFATORIRRF := mFATORIRR2 := 0
ARREIRRF   := DESPIRRF := 'N'
TABIRRF()

MDS('Carregando tabela IAPAS ')
if !netuse("TABINSS")   //BREDE( "TABINSS", 1 )
   retu .f.
endif
dbgoto(MESTRAB)
IN1  := ATESAL1
IN2  := ATESAL2
IN3  := ATESAL3
IN4  := ATESAL4
IN5  := ATESAL5
IN6  := ATESAL6
IN7  := ATESAL7
TX1  := (TAXA1 / 100)
TX2  := (TAXA2 / 100)
TX3  := (TAXA3 / 100)
TX4  := (TAXA4 / 100)
TX5  := (TAXA5 / 100)
TX6  := (TAXA6 / 100)
TX7  := (TAXA7 / 100)
TXI1 := (TAXAI1 / 100)
TXI2 := (TAXAI2 / 100)
TXI3 := (TAXAI3 / 100)
TXI4 := (TAXAI4 / 100)
TXI5 := (TAXAI5 / 100)
TXI6 := (TAXAI6 / 100)
TXI7 := (TAXAI7 / 100)
TX   := 0
TXI  := 0
do case
case TX7 <> 0.00
   TX  := TX7
   TXI := TXI7
case TX6 <> 0.00
   TX  := TX6
   TXI := TXI6
case TX5 <> 0.00
   TX  := TX5
   TXI := TXI5
case TX4 <> 0.00
   TX  := TX4
   TXI := TXI4
case TX3 <> 0.00
   TX  := TX3
   TXI := TXI3
case TX2 <> 0.00
   TX  := TX2
   TXI := TXI2
case TX1 <> 0.00
   TX  := TX1
   TXI := TXI1
endcase
TETOINPS   := TETOMAXIMO
TETOINPSI  := TETOIRRF
SALFAMILIA := FAMILIA
SALFAMIL1  := FAMILIA1
TETOFAMIL  := TETOSALFA
TETOFAMI1  := TETOSALF1
INSSDESC   := DESCONTO
dbcloseall()

MDS("Pegando Configura‡„o de Contas")
if !netuse(cc2a)  //AREDE( CC2A, CC2B, 1 )
   retu
endif
while !eof()
   @ 24,00 say CODIGO         
   aadd(aCOD,CODIGO)
   if NN = 1
      aadd(aDAD,{TIPO,FATOR,VALOR,TRIBUTINPS,TRIBUTIRR,100,100,100})
   else
      aadd(aDAD,{TIPO,FATOR,VALOR,TRIBUTINPS,TRIBUTIRR,BASEREDI,BASERIR,IPER})
   endif
   dbskip()
enddo
dbcloseall()

if !netuse(cc1a)  //AREDE( CC1A, CC1B, 1 )
   retu .F.
endif
if !netuse(cc3)   //AREDE( CC3, CC3, 0 )
   dbcloseall()
   retu .F.
endif
dbselectar(CC1A)
while !eof()
   PETELA(8)
   mNUMERO   := NUMERO
   mCREDITO  := mDEBITO := mBASEINSS := mVALORINSS := BASEINSD := 0
   mBASEIRRF := mVALORIRRF := mVALDEP := 0
   VINSSIPE  := 0
   mBINSSIPE := 0
   DEP       := FOSFAMQTDE(mNUMERO)
   mVALDEP   := CALCDEPE()
   SALH      := SALM := VEN := DES := VAL4 := 0
   SALHM()
   MDS("Calculando Dados")
   dbselectar(CC3)
   dbgotop()
   dbseek(mNUMERO * 10000)
   while NUMERO = mNUMERO .and. !eof()
      if SEMANA = mSEMANA
         nPOS := ascan(aCOD,CONTA)
         if nPOS > 0
            VALE1     := 0
            TIPO      := aDAD[nPOS,1]
            FATOR     := aDAD[nPOS,2]
            VALORBASE := aDAD[nPOS,3]
            TRIBINSS  := aDAD[nPOS,4]
            TRIBIRRF  := aDAD[nPOS,5]
            REDUREDI  := aDAD[nPOS,6]
            REDURIR   := aDAD[nPOS,7]
            IPER      := aDAD[nPOS,8]
            do case
            case TIPO = 1
               VALE1 := (HORAS * SALH)
               VALE1 := if(FATOR # 0,round(VALE1 * FATOR,2),VALE1)
            case TIPO = 2
               VALE1 := (VALORBASE)
            case TIPO = 3
               VALE1 := (HORAS * VALORBASE)
               VALE1 := if(FATOR # 0,round(VALE1 * FATOR,2),VALE1)
            case TIPO = 4
               VALE1 := round(SALM * HORAS / 30,2)
               VALE1 := if(FATOR # 0,round(VALE1 * FATOR,2),VALE1)
            endcase
            if VALE1 > 0
               netreclock()
               field->VALOR := VALE1
               dbunlock()
            endif

            //Base IRRF
            mBASETMP := VALOR
            if REDURIR > 0  //%Redu‡ao IRFF
               mBASETMP := VALOR - (Valor * REDURIR / 100)
            endif
            mBASEIRRF += if(TRIBIRRF = 0,mBASETMP,0)
            mBASEIRRF -= if(TRIBIRRF = 2,mBASETMP,0)

            //Base INSS
            mBASETMP := VALOR
            if REDUREDI > 0   //%Redu‡ao INSS
               mBASETMP := VALOR - (Valor * REDUREDI / 100)
            endif
            if IPER > 0   //%iNDICADO INSS
               mBINSSIPE += if(TRIBINSS = 0,mBASETMP,0)
               mBINSSIPE -= if(TRIBINSS = 2,mBASETMP,0)
               VINSSIPE  += if(TRIBINSS = 0,mBASETMP * IPER / 100,0)
               VINSSIPE  -= if(TRIBINSS = 2,mBASETMP * IPER / 100,0)
            else
               mBASEINSS += if(TRIBINSS = 0,mBASETMP,0)
               mBASEINSS -= if(TRIBINSS = 2,mBASETMP,0)
            endif

            if CONTA < 399
               mCREDITO += VALOR
            endif
            if CONTA > 500 .and. CONTA # 508 .and. CONTA # 503 .and. CONTA # 999
               mDEBITO += VALOR
            endif
         endif
      endif
      dbskip()
   enddo
   BASEINSD := mBASEINSS - INSSDESC
   IF BASEINSD < 0
      BASEINSD := 0
   ENDIF
   if BASEINSD > 0
      MDS('Calculando IAPAS')
      TXREF := 0  //VALOR INSS DE DESCONTO
      if BASEINSD >= TETOINPS
         mVALORINSS := round((TETOINPS * TX),2)
      else
         do case
         case BASEINSD <= IN1
            mVALORINSS := round((BASEINSD * TX1),2)
            TXREF      := TX1
         case BASEINSD <= IN2
            mVALORINSS := round((BASEINSD * TX2),2)
            TXREF      := TX2
         case BASEINSD <= IN3
            mVALORINSS := round((BASEINSD * TX3),2)
            TXREF      := TX3
         case BASEINSD <= IN4
            mVALORINSS := round((BASEINSD * TX4),2)
            TXREF      := TX4
         case BASEINSD <= IN5
            mVALORINSS := round((BASEINSD * TX5),2)
            TXREF      := TX5
         case BASEINSD <= IN6
            mVALORINSS := round((BASEINSD * TX6),2)
            TXREF      := TX6
         case BASEINSD <= IN7
            mVALORINSS := round((BASEINSD * TX7),2)
            TXREF      := TX7
         endcase
      endif
      TXREF *= 100
      //Soma Outras
      mVALORINSS += VINSSIPE
      mBASEINSS  += mBINSSIPE
      if mVALORINSS > (TETOINPS * TX)
         MVALORINSS := round((TETOINPS * TX),2)
      endif
      mDEBITO += mVALORINSS
   endif
   if mBASEIRRF > 0
      BASE := mBASEIRRF - mVALORINSS - mVALDEP
      IR3  := DESCIR := VALDESCIR := 0
      CALCIRRF()
      mVALORIRRF := VALDESCIR
      mDEBITO    += mVALORIRRF
   endif
   aDADOS := {}
   aadd(aDADOS,{508,mVALORINSS})
   aadd(aDADOS,{420,mBASEINSS})
   aadd(aDADOS,{399,mCREDITO})
   aadd(aDADOS,{999,mDEBITO})
   aadd(aDADOS,{503,mVALORIRRF})
   aadd(aDADOS,{401,mBASEIRRF})
   aadd(aDADOS,{431,mVALORINSS+mVALDEP})
   aadd(aDADOS,{413,mVALDEP})
   aadd(aDADOS,{440,mCREDITO - mDEBITO})
   aadd(aDADOS,{485,BASEINSD})
   for X := 1 to len(aDADOS)
      dbgotop()
      if !dbseek(mNUMERO * 10000+mSEMANA * 1000+aDADOS[X,1])
         netrecapp()
         field->NUMERO := mNUMERO
         field->CONTA  := aDADOS[X,1]
         field->SEMANA := mSEMANA
      else
         netreclock()
      endif
      field->VALOR := aDADOS[X,2]
   next X
   dbselectar(CC1A)
   dbskip()
enddo
dbselectar(CC3)
FODZER()
dbcloseall()


*+ EOF: fod5.prg
*+
