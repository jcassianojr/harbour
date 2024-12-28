*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fod2des.prg
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

// :
// :    FOD2DES.PRG: CALCULAR OS DESCONTAS DA FOLHA DE PAGAMENTO
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 29/04/99
// :

//  FOD2C {CALCULAR OS DESCONTOS DA FOLHA DE PAGAMENTO}

CABEX('* CALCULAR A FOLHA DO MES *')

// Pegando Indices Ocorrencias Acd.Trabalho
aOCO  := {}
aOCOI := {}
if !netuse("fo_tab")
   retu
endif
dbgotop()
dbseek("FOCO")
while alltrim(TABELA) = "FOCO" .and. !eof()
   aadd(aOCO,CODIGO)
   aadd(aOCOI,VALOR / 100)  // %
   dbskip()
enddo
dbclosearea()

if !NETUSE(PES)   //AREDE( PES, PES, 1 )
   retu
endif
set filter to &FILTRO

if nFOLTIP = 1
   if !NETUSE(FOL)  //AREDE( FOL, FOL, 0 )
      dbcloseall()
      retu
   endif
else
   if !NETUSE("FO_COMP")  //AREDE( "FO_COMP", "FO_COMP", 0 )
      dbcloseall()
      retu
   endif
endif
cSELE2 := ALIAS()

dbgotop()
REG  := recno()
aCOD := {}
aDAD := {}

if !NETUSE("CONTAS")
   dbcloseall()
   retu
endif
dbgotop()
IF dbseek(426)
   FFGTS := FATOR
endif
dbgotop()
WHILE !EOF()
   @ 24,00 SAY CODIGO         
   AADD(aCOD,CODIGO)
   AADD(aDAD,{TRIB_FGTS,TRIBUTINPS,BASEREDI,IPER,TRIBUTIRR,BASERIR})
   DBSKIP()
ENDDO


DBSELECTAR(PES)
dbgotop()
while !eof()
   CTR       := NUMERO
   mSITUACAO := SITUACAO
   mOCOFGTS  := OCOFGTS
   PETELA(7)
   mCAT     := CATEGORIA
   SALH     := SALM := VALE := VALORINSS := QTFIL := VALORINSSP := VALORINSSI := 0
   INSSFE   := VALEX := VALDSR := VALDESC := BASE1 := VLSAF := VEN := DES := 0
   BASEIRRF := BASEINSS := BASEFGTS := VALE1 := VALE2 := 0
   BASEINSD := BINSSIPE := VINSSIPE := 0
   CONTA73  := .F.
   SALHM()
   if mSITUACAO = 'S' .or. mSITUACAO = 'E' .or. mSITUACAO = '01' .or. mSITUACAO = '12'
      MDS('Verificando Afastamentos')
      BASEFGTS := SALM  //Joga com base o Valor do Salario
      VALE     := if(mTRUNCAR = "S",TRUNCAR(BASEFGTS * FFGTS),BASEFGTS * FFGTS)
      DBSELECTAR(cSELE2)
      GRAVA2(426)
      VALE := BASEFGTS
      DBSELECTAR(cSELE2)
      GRAVA2(425)
   endif
   DBSELECTAR(cSELE2)
   dbgotop()
   dbseek(CTR * 10000)
   if NUMERO # CTR .or. eof()
      DBSELECTAR(PES)
      dbskip()
      loop
   endif
   REG := recno()
   MDS('Acumulando Bases de Calculos')
   while NUMERO = CTR .and. !eof()
      nPOS := ASCAN(aCOD,CONTA)
      IF nPOS > 0
         BASEFGTS += if(aDAD[NPOS,1] = 0,VALOR,0)
         BASEFGTS -= if(aDAD[NPOS,1] = 2,VALOR,0)

         //Base IRRF
         mBASETMP := VALOR
         IF aDAD[NPOS ,  6] > 0   //%Redu‡ao IRFF
            mBASETMP := VALOR - (Valor * aDAD[NPOS,6] / 100)
         ENDIF
         BASEIRRF += if(aDAD[NPOS,5] = 0,mBASETMP,0)
         BASEIRRF -= if(aDAD[NPOS,5] = 2,mBASETMP,0)

         //Base INSS
         mBASETMP := VALOR
         IF aDAD[NPOS ,  3] > 0   //%Redu‡ao INSS
            mBASETMP := VALOR - (Valor * aDAD[NPOS,3] / 100)
         ENDIF
         IF aDAD[NPOS ,  4] > 0   //%iNDICADO INSS
            BINSSIPE += if(aDAD[NPOS,2] = 0,mBASETMP,0)
            BINSSIPE -= if(aDAD[NPOS,2] = 2,mBASETMP,0)
            VINSSIPE += if(aDAD[NPOS,2] = 0,mBASETMP * aDAD[NPOS,4] / 100,0)
            VINSSIPE -= if(aDAD[NPOS,2] = 2,mBASETMP * aDAD[NPOS,4] / 100,0)
         ELSE
            BASEINSS += if(aDAD[NPOS,2] = 0,mBASETMP,0)
            BASEINSS -= if(aDAD[NPOS,2] = 2,mBASETMP,0)
         ENDIF
      ENDIF
      do case
      case CONTA = 41 .or. CONTA = 445
         VALE1 += VALOR
      case CONTA = 413 .or. CONTA = 515 .or. CONTA = 516
         VALE2 += VALOR
      case CONTA = 73
         CONTA73 := .T.
      case CONTA = 491
         QTFIL := VALOR
      case CONTA = 436
         VALORINSSP := VALOR
      case CONTA = 479
         INSSFE += VALOR
      case CONTA = 478
         INSSFE += VALOR
      endcase
      if CONTA = 398 .or. CONTA = 399 .or. CONTA = 70 .or. CONTA = 74 .or. CONTA = 999
         netreclock()
         field->VALOR := 0
         field->HORAS := 0
         dbunlock()
      endif
      dbskip()
   enddo

   MDS('Calculando IAPAS')
   //VALOR INSS DE DESCONTO
   BASEINSD := BASEINSS - INSSDESC
   IF BASEINSD < 0
      BASEINSD := 0
   ENDIF
   TXREF := 0
   if BASEINSD >= TETOINPS
      VALORINSS  := round((TETOINPS * TX),2)
      VALORINSSI := round((TETOINPSI * TXI),2)
   else
      do case
      case BASEINSD <= IN1
         VALORINSS  := round((BASEINSD * TX1),2)
         VALORINSSI := round((BASEINSD * TXI1),2)
         TXREF      := TX1
      case BASEINSD <= IN2
         VALORINSS  := round((BASEINSD * TX2),2)
         VALORINSSI := round((BASEINSD * TXI2),2)
         TXREF      := TX2
      case BASEINSD <= IN3
         VALORINSS  := round((BASEINSD * TX3),2)
         VALORINSSI := round((BASEINSD * TXI3),2)
         TXREF      := TX3
      case BASEINSD <= IN4
         VALORINSS  := round((BASEINSD * TX4),2)
         VALORINSSI := round((BASEINSD * TXI4),2)
         TXREF      := TX4
      case BASEINSD <= IN5
         VALORINSS  := round((BASEINSD * TX5),2)
         VALORINSSI := round((BASEINSD * TXI5),2)
         TXREF      := TX5
      case BASEINSD <= IN6
         VALORINSS  := round((BASEINSD * TX6),2)
         VALORINSSI := round((BASEINSD * TXI6),2)
         TXREF      := TX6
      case BASEINSD <= IN7
         VALORINSS  := round((BASEINSD * TX7),2)
         VALORINSSI := round((BASEINSD * TXI7),2)
         TXREF      := TX7
      endcase
   endif


   VALORINSS  += VINSSIPE   //INSS % Indicado
   VALORINSSI += VINSSIPE   //INSS % Indicado
   IF VALORINSS > (TETOINPS * TX)
      VALORINSS := round((TETOINPS * TX),2)
   ENDIF
   IF VALORINSSI > (TETOINPS * TXI)
      VALORINSSI := round((TETOINPS * TXI),2)
   ENDIF

   VALORINSS := if(mTRUNCA2 = "S",TRUNCAR(VALORINSS),VALORINSS)

   IF mCAT = "05" .OR. mCAT = "11"
      TXREF := 0
   ENDIF

   DBSELECTAR(cSELE2)
   GRAVA2(508,if(mSITUACAO # "P",VALORINSS,0),TXREF * 100)

   VALE := BASEINSD+BINSSIPE  //INSS %Indicado
   DBSELECTAR(cSELE2)
   GRAVA2(485)

   VALE := BASEINSS+BINSSIPE  //INSS %Indicado
   DBSELECTAR(cSELE2)
   GRAVA2(420)


   nPOS := ascan(aOCO,mOCOFGTS)
   if nPOS > 0
      VALE := aOCOI[nPOS] * BASEINSS
      if VALE > 0
         DBSELECTAR(cSELE2)
         GRAVA2(427,VALE,aOCOI[nPOS])
      endif
   endif


   //Deduz o INSS ja deduzido para ferias
   VALORINSSI -= INSSFE
   VALE       := if(mSITUACAO # "P",VALORINSSI,0)
   DBSELECTAR(cSELE2)
   GRAVA2(437)

   MDS('Calculando IRFF')
   VALE := VALE2+VALORINSSI+VALORINSSP
   DBSELECTAR(cSELE2)
   GRAVA2(431)
   if RECOIRRF # 'S'
      BASEIRRF -= VALE1
   endif
   VALE := BASEIRRF
   DBSELECTAR(cSELE2)
   GRAVA2(401)
   BASE := BASEIRRF - VALE2 - VALORINSSI - VALORINSSP
   IR3  := DESCIR := VALDESCIR := 0
   CALCIRRF()
   VALE := VALDESCIR
   DBSELECTAR(cSELE2)
   GRAVA2(503)

   MDS('Calculando FGTS')
   VALE := if(mTRUNCAR = "S",TRUNCAR(BASEFGTS * FFGTS),BASEFGTS * FFGTS)
   DBSELECTAR(cSELE2)
   GRAVA2(426)
   VALE := BASEFGTS
   DBSELECTAR(cSELE2)
   GRAVA2(425)

   if !CONTA73 .and. (empty(mSITUACAO) .or. mSITUACAO = "P")
      if QTFIL > 0
         MDS('Calculando Salario Familia')
         DO CASE
         CASE BASEINSS <= TETOFAMIL
            VALE := QTFIL * SALFAMILIA
            if VALE > 0
               DBSELECTAR(cSELE2)
               GRAVA2(70)
               field->HORAS := QTFIL
            endif
         CASE BASEINSS <= TETOFAMI1
            VALE := QTFIL * SALFAMIL1
            if VALE > 0
               DBSELECTAR(cSELE2)
               GRAVA2(74)
               field->HORAS := QTFIL
            endif
         ENDCASE
      endif
   endif

   DBSELECTAR(cSELE2)
   dbgoto(REG)
   MDS('Acumulando Cr‚ditos e D‚bitos')
   while NUMERO = CTR .and. !eof()
      if (CONTA > 119 .and. CONTA < 150) .or. CONTA = 911 .or. CONTA = 505
         dbskip()
         loop
      endif
      if CONTA > 501 .or. (CONTA > 40 .and. CONTA < 50)
         DES += VALOR
      endif
      if CONTA < 40 .or. (CONTA > 50 .and. CONTA < 397)
         VEN += VALOR
      endif
      dbskip()
   enddo
   VALE := DES
   DBSELECTAR(cSELE2)
   GRAVA2(999)

   if ARREDOR # 0
      SALDO4 := VALARRE(ARREDOR)
      VALE   := SALDO4
      DBSELECTAR(cSELE2)
      GRAVA2(398)
      VEN += SALDO4
   endif

   VALE := VEN
   DBSELECTAR(cSELE2)
   GRAVA2(399)
   VALE := VEN - DES
   DBSELECTAR(cSELE2)
   GRAVA2(440)

   DBSELECTAR(PES)
   dbskip()
enddo

dbcloseall()
if nFOLTIP = 1
   IF NETUSE(FOL)   //AREDE( FOL, FOL, 0 )
      FODZER()
      dbcloseall()
   ENDIF
endif
retu


*+ EOF: fod2des.prg
*+
