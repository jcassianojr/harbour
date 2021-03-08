*:*****************************************************************************
*:
*:  FORES_B4.PRG : Listar F‚rias Cont bil
*:     Linguagem : Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:      Copyright (c) 1997,  SOFTEC  S/C Ltda.
*:  Atualizado em: 11/10/97
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF ! MDL('Listar F‚rias Cont bil',0)
   RETU .F.
ENDIF


DIARFE=DATE()
MDS('Qual a data de referencia')
@ 24,40 GET DIARFE
READCUR()

ANOFIM=YEAR(DIARFE)
MESFIM=MONTH(DIARFE)
DIAFIM=DAY(DIARFE)
DATAFIM=DIARFE

CODFPAS:=TOTENC:=FL:=0
lGRAVA:=MDG("Gravar Resultados- Apura‡„o Contabil")
lANAL:=MDG("Deseja Resumo Analitico")

VERSEHA("FIRMA",,NREMP,,,.F.,{{"FPAS","CODFPAS"}})
VERSEHA("CONFINSS",,VAL(CODFPAS),,,.F.,{{"EMPRESA+TOTAL+ACIDENTE+8","TOTENC"}})

MDS('Confirme o Percentual de Encargos ')
@ 24,40 GET TOTENC
IF ! READCUR()
   RETU .F.
ENDIF
TOTENC=TOTENC/100

aXCON:=ARRAY(15)
AFILL(aXCON,0)
aXCON:=PEGRELCTA("PROVFE")


IF lGRAVA
   IF ! netuse("PROVFE") 
      DBCLOSEALL()
      RETU .F.
   ENDIF
   nLASTREC:=LASTREC()
   MDS("Aguarde Preparando Arquivo Acumulado")
   zei_fort( nLASTREC,,,0)
   DBEval( {|| netrecdel()}, {|| ANO=MESFIM.AND.MES=MESFIM},{|| zei_fort(nLASTREC,,,1)})
   dbclosearea()
   netpack("PROVFE")
   if ! netuse("PROVFE")
      dbcloseall()
      retu .f.
   endif
ENDIF


IF ! NETUSE(FOL) //AREDE(FOL,FOL,1)
   DBCLOSEALL()
   RETU .F.
ENDIF

IF MDG("Incluir Demitidos Mes")
   FILTRO='(EMPTY(DEMITIDO).OR.(MONTH(DEMITIDO)>=MONTH(DIARFE).AND.YEAR(DEMITIDO)>=YEAR(DIARFE)))'
ELSE
   FILTRO='EMPTY(DEMITIDO)'
ENDIF



if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO=''
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO

IF ! NETUSE("FO_FER") 
   DBCLOSEALL()
   RETU
ENDIF

aTOTGER:={0,0,0,0,0,0}
CTLIN:=80
LISTARUE({|X| B4X(X)},{||B4XB()})


FUNC B4XB
CTLIN++
@ CTLIN,0 SAY "Total Geral"
CTLIN++
@ CTLIN,10 SAY "Total Avos"
@ CTLIN  ,40 SAY STR(aTOTGER[1],5)
CTLIN++
@ CTLIN,10 SAY "Total Ferias"
@ CTLIN  ,40 SAY aTOTGER[2] PICT "###,###,###,###.##"
CTLIN++
@ CTLIN,10 SAY "Total 1/3"
@ CTLIN  ,40 SAY aTOTGER[3] PICT "###,###,###,###.##"
CTLIN++
@ CTLIN,10 SAY "Total Encargos"
@ CTLIN  ,40 SAY aTOTGER[4] PICT "###,###,###,###.##"
CTLIN++
@ CTLIN,10 SAY "TOTAL"
@ CTLIN  ,40 SAY aTOTGER[5]    PICT "###,###,###,###.##"
IF aTOTGER[6]>0
   CTLIN++
   @ CTLIN,10 SAY "Valores Pagos"
   @ CTLIN  ,40 SAY aTOTGER[6] PICT "###,###,###,###.##"
ENDIF
IMPFOL()
RETU .T.

FUNC B4XA(lCAB)
FL++
@ 0,  1 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
@ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
@ 3,100 SAY TIME()
@ 3,110 SAY DATE()
@ 3,120 SAY 'FL: '+STRZERO(FL,4)
@ 4,  0 SAY REPL('-',132)
IF ! lCAB
   @ 5,  0 SAY IMPCHR(cIMPTIT)+'PROVISAO DE FERIAS CONTABEIS '+DTOC(DIARFE)
ELSE
   DO CASE
      CASE KEY=2
           @ 5,  0 SAY IMPCHR(cIMPTIT)+'PROVISAO DE FERIAS CONTABEIS '+DTOC(DIARFE)+" "+STR(DEP)+' '+NOMSETOR
      CASE KEY=3
      CASE KEY=4
      OTHERWISE
           @ 5,  0 SAY IMPCHR(cIMPTIT)+'PROVISAO DE FERIAS CONTABEIS '+DTOC(DIARFE)+" "+NOMSETOR
   ENDCASE
ENDIF
@ 6,  0 SAY REPL ('-',132)
IF ! lCAB
   CTLIN:=7
   RETU .T.
ENDIF
@ 7,  0 SAY 'NUM'
@ 7,  6 SAY 'NOME'
@ 7, 40 SAY 'SALARIO'
@ 7, 55 SAY 'PERIODO'
@ 7, 64 SAY 'TP AVOS DIAS'
@ 7, 80 SAY 'VALOR'
@ 7, 95 SAY '1/3'
@ 7,107 SAY 'ENCARGOS'
@ 7,121 SAY 'TOTAL'
@ 8, 40 SAY '+VARIAVEIS'
@ 9,  0 SAY REPL ('-',132)
CTLIN=10
RETU .T.


FUNC B4X
PARA COMPARE
TOTALIZA=.F.
IF lANAL
   CTLIN=80
ENDIF
TOTALDES:=TOTALAVO:=TOTALVAL:=TOTALTER:=TOTALENC:=TOTALE:=0
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      SALH:=SALM:=VAR1:=0
      SALHM(MESFIM)
      CTR=NUMERO
      DAT=ADMITIDO
      mNUMERO:=NUMERO
      mDEPTO :=DEPTO
      mSETOR :=SETOR
      mSECAO :=SECAO
      mDEMITIDO:=DEMITIDO
      DBSELECTAR("FO_FER")
      DBGOTOP()
      DBSEEK(CTR*100000000)
      IF CTR=NUMERO
         WHILE NUMERO=CTR.AND.BAIXADO='S'.AND.! EOF()
            DBSKIP()
         ENDDO
         WHILE NUMERO=CTR.AND.! EOF()
            IF BAIXADO#'S'
               IF DATFERIAS<DATAFIM
                  IF CTLIN > 55.AND.lANAL
                     B4XA(.T.)
                  ENDIF
                  AVOSV:=AVOSP:=VALORV:=VALORP:=VALORVT:=VALORPT:=0
                  ANOFER=YEAR(DATFERIAS)
                  MESFER=MONTH(DATFERIAS)
                  DAYFER=DAY(DATFERIAS)
                  IF ANOFER=ANOFIM-2
                     AVOSV=12
                  ENDIF
                  IF ANOFER=ANOFIM-1
                     IF MESFER<=MESFIM
                        AVOSV=12
                     ENDIF
                     IF MESFER>MESFIM
                        AVOSP=12-MESFER
                        AVOSP+=MESFIM
                        IF DIAFIM-DAYFER+1>14
                           AVOSP++
                        ENDIF
                     ENDIF
                  ENDIF
                  IF ANOFER=ANOFIM
                     IF MESFER<=MESFIM
                        AVOSP=MESFIM-MESFER
                        IF DIAFIM-DAYFER+1>14
                           AVOSP++
                        ENDIF
                     ENDIF
                  ENDIF
                  mSALM:=SALM
                  mSALVAR:=SALVAR
                  SALM=SALM+SALVAR
                  VALORV=SALM*DIASGOZA3/30
                  VALORP=VALORV*AVOSP/12
                  IF DIASGOZA3=0
                     VALORV=SALM*DIASJUS/30
                     VALORP=VALORV*AVOSP/12
                  ENDIF
                  VALORVT=VALORV/3
                  VALORPT=VALORP/3
                  IF lANAL
                     CTLIN++
                     @ CTLIN, 0 SAY NUMERO
                     @ CTLIN, 6 SAY SUBSTR(NOME,1,25)
                     @ CTLIN,32 SAY SALM PICT '###,###,###.##'
                     @ CTLIN,47 SAY DATFERIAS
                  ENDIF
                  IF AVOSV=12
                     TOTALE=(VALORV+VALORVT)*TOTENC
                     TOTAL=TOTALE+VALORV+VALORVT
                     mAVOS:=12
                     mDIAS:=DIASGOZA3
                     mCOMP:=DATFERIASF
                     mVALOR:=VALORV
                     mVALTER:=VALORVT
                     mVALENC:=TOTALE
                     mVALTOT:=TOTAL
                     IF lANAL
                        @ CTLIN, 56 SAY DATFERIASF
                        @ CTLIN, 65 SAY 'FV'
                        @ CTLIN, 68 SAY '12'
                        @ CTLIN, 71 SAY DIASGOZA3
                        @ CTLIN, 74 SAY VALORV PICT '###,###,###.##'
                        @ CTLIN, 88 SAY VALORVT PICT '###,###,###.##'
                        @ CTLIN,103 SAY TOTALE PICT '###,###,###.##'
                        @ CTLIN,118 SAY TOTAL PICT '###,###,###.##'
                     ENDIF
                     TOTALAVO+=12
                     TOTALVAL+=VALORV
                     TOTALTER+=VALORVT
                     TOTALENC+=TOTALE
                  ELSE
                     TOTALE :=(VALORP+VALORPT)*TOTENC
                     TOTAL  :=TOTALE+VALORP+VALORPT
                     mAVOS  :=AVOSP
                     mDIAS  :=INT(DIASGOZA3*AVOSP/12)
                     mCOMP  :=DATAFIM
                     mVALOR :=VALORP
                     mVALTER:=VALORPT
                     mVALENC:=TOTALE
                     mVALTOT:=TOTAL
                     IF lANAL
                        @ CTLIN, 56 SAY DATAFIM
                        @ CTLIN, 65 SAY 'FP'
                        @ CTLIN, 68 SAY STR(AVOSP,2)
                        @ CTLIN, 71 SAY STR(INT(DIASGOZA3*AVOSP/12),2)
                        @ CTLIN, 74 SAY VALORP PICT '###,###,###.##'
                        @ CTLIN, 88 SAY VALORPT PICT '###,###,###.##'
                        @ CTLIN,103 SAY TOTALE PICT '###,###,###.##'
                        @ CTLIN,118 SAY TOTAL PICT '###,###,###.##'
                     ENDIF
                     TOTALAVO+=AVOSP
                     TOTALVAL+=VALORP
                     TOTALTER+=VALORPT
                     TOTALENC+=TOTALE
                  ENDIF
                  IF lGRAVA
                     mCONTROLE:=STRZERO(mNUMERO,8)+DTOS(mCOMP)+STRZERO(ANOFIM,4)+STRZERO(MESFIM,2)
                     DBSELECTAR("PROVFE")
                     DBGOTOP()
                     IF ! DBSEEK(mCONTROLE)
                        NETRECapp()
                     ELSE
                        NETRECLOCK()
                     ENDIF      
                     FIELD->CONTROLE:=mCONTROLE
                     FIELD->NUMERO   :=mNUMERO
                     FIELD->SALARIO  :=mSALM
                     FIELD->SALVAR   :=mSALVAR
                     FIELD->AVOS     :=mAVOS
                     FIELD->DIAS     :=mDIAS
                     FIELD->DEPTO    :=mDEPTO
                     FIELD->SETOR    :=mSETOR
                     FIELD->SECAO    :=mSECAO
                     FIELD->MES      :=MESFIM
                     FIELD->ANO      :=ANOFIM
                     FIELD->VALOR    :=mVALOR
                     FIELD->VALTER   :=mVALTER
                     FIELD->VALENC   :=mVALENC
                     FIELD->VALTOT   :=mVALTOT
                     FIELD->COMP     :=mCOMP
                     DBUNLOCK()
                 ENDIF
               ENDIF
            ENDIF
            DBSELECTAR("FO_FER")
            DBSKIP()
         ENDDO
      ENDIF


      DBSELECTAR(FOL)
      nDESCONTA:=0
      FOR W=1 TO 15
          IF ! EMPTY(aXCON[W])
             DBGOTOP()
             DBSEEK(mNUMERO*10000+aXCON[W])
             IF FOUND()
                nDESCONTA+=VALOR
             ENDIF
          ENDIF
      NEXT W
      IF nDESCONTA>0
         IF lANAL
            CTLIN++
            @ CTLIN,  6 SAY "Pago"
            IF ! EMPTY(mDEMITIDO)
               @ CTLIN,15 SAY "Demitido:"+DTOC(mDEMITIDO)
            ENDIF
            @ CTLIN,118 SAY nDESCONTA PICT '@E 999,999,999.99'
         ENDIF
         TOTALDES+=nDESCONTA
      ENDIF
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IF TOTALIZA
   IF lANAL
      CTLIN++
      @ CTLIN,0 SAY REPL('-',132)
   ENDIF
   IF CTLIN>50
      B4XA(.F.)
   ENDIF
   TOTAL=TOTALVAL+TOTALTER+TOTALENC
   IF lANAL
      CTLIN++
      @ CTLIN, 0 SAY IMPCHR(cIMPTIT)+"RESUMO"
       CTLIN++
      @ CTLIN, 0 SAY REPL('-',132)
   ELSE
      CTLIN++
      DO CASE
         CASE KEY=2
              @ CTLIN, 0 SAY IMPCHR(cIMPTIT)+"RESUMO: "+STR(DEP)+' '+NOMSETOR
         CASE KEY=3
         CASE KEY=4
         OTHERWISE
              @ CTLIN, 0 SAY IMPCHR(cIMPTIT)+"RESUMO: "+NOMSETOR
      ENDCASE
   ENDIF
   CTLIN++
   @ CTLIN,10 SAY "Total avos"
   @ CTLIN  ,40 SAY STR(TOTALAVO,5)
   CTLIN++
   @ CTLIN,10 SAY "Total Ferias"
   @ CTLIN  ,40 SAY TOTALVAL PICT "###,###,###,###.##"
   CTLIN++
   @ CTLIN,10 SAY "Total 1/3"
   @ CTLIN  ,40 SAY TOTALTER PICT "###,###,###,###.##"
   CTLIN++
   @ CTLIN,10 SAY "Total Encargos"
   @ CTLIN  ,40 SAY TOTALENC PICT "###,###,###,###.##"
   CTLIN++
   @ CTLIN,10 SAY "TOTAL"
   @ CTLIN  ,40 SAY TOTAL    PICT "###,###,###,###.##"
   IF TOTALDES>0
      CTLIN++
      @ CTLIN,10 SAY "Valores Pagos"
      @ CTLIN  ,40 SAY TOTALDES PICT "###,###,###,###.##"
   ENDIF
   CTLIN++
   @ CTLIN, 0 SAY REPL('-',132)
   IF lANAL
      IMPFOL()
   ENDIF
   aTOTGER[1]+=TOTALAVO
   aTOTGER[2]+=TOTALVAL
   aTOTGER[3]+=TOTALTER
   aTOTGER[4]+=TOTALENC
   aTOTGER[5]+=TOTAL
   aTOTGER[5]+=TOTALDES
ENDIF
RETU .T.

*: FIM: FORES_B4.PRG
