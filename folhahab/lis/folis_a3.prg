*:*****************************************************************************
*:
*:
*:  FOLIS_A3.PRG : Acumular Dados para Rais
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************


#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

CABE2('Acumulando Dados Para Rais')
IF ! MDG('Deseja Realmente Acumular')
   RETU .F.
ENDIF

xrCODIBGE:=OBTER("FIRMA",,NREMP,"CODIBGE")

aCTAHOR:=ARRAY(10)
aCTAFAT:=ARRAY(10)
aFILL(aCTAHOR,0)
aFILL(aCTAFAT,1)
//mCTAHOR01:=mCTAHOR02:=mCTAHOR03:=mCTAHOR04:=mCTAHOR05:=0
//mCTAHOR06:=mCTAHOR07:=mCTAHOR08:=mCTAHOR09:=mCTAHOR10:=0
//mCTAFAT01:=mCTAFAT02:=mCTAFAT03:=mCTAFAT04:=mCTAFAT05:=1
//mCTAFAT06:=mCTAFAT07:=mCTAFAT08:=mCTAFAT09:=mCTAFAT10:=1

CLSCOR()
CLSROW(8)
MESINI:=1
MESFIM:=12
DATAREF=DXDIA
@ 09,00 CLEAR
@ 09,00 SAY "Contas para Horas Trabalhadas"
@ 11,00 SAY "Fatores"
@ 21,00 SAY 'Qual o mes inicial'
@ 22,00 SAY 'Qual o mes final'
@ 23,00 SAY 'Qual a Data de Referencia'
@ 24,00 SAY 'Cod Ibge do Municipio'
@ 10,08 GET aCTAHOR[1] PICT "999"
@ 11,08 GET aCTAFAT[1] PICT "99.999"
@ 10,15 GET aCTAHOR[2] PICT "999"
@ 11,15 GET aCTAFAT[2] PICT "99.999"
@ 10,22 GET aCTAHOR[3] PICT "999"
@ 11,22 GET aCTAFAT[3] PICT "99.999"
@ 10,29 GET aCTAHOR[4] PICT "999"
@ 11,29 GET aCTAFAT[4] PICT "99.999"
@ 10,36 GET aCTAHOR[5] PICT "999"
@ 11,36 GET aCTAFAT[5] PICT "99.999"
@ 10,43 GET aCTAHOR[6] PICT "999"
@ 11,43 GET aCTAFAT[6] PICT "99.999"
@ 10,50 GET aCTAHOR[7] PICT "999"
@ 11,50 GET aCTAFAT[7] PICT "99.999"
@ 10,57 GET aCTAHOR[8] PICT "999"
@ 11,57 GET aCTAFAT[8] PICT "99.999"
@ 10,64 GET aCTAHOR[9] PICT "999"
@ 11,64 GET aCTAFAT[9] PICT "99.999"
@ 10,71 GET aCTAHOR[10] PICT "999"
@ 11,71 GET aCTAFAT[10] PICT "99.999"
@ 21,40 GET MESINI PICT '##' RANGE 1,12
@ 22,40 GET MESFIM PICT '##' RANGE MESINI,12
@ 23,40 GET DATAREF
@ 24,40 GET xrCODIBGE pict "9999999"
IF ! READCUR()
   RETU .F.
ENDIF
IF MESINI<1
   ALERTX("Mes Inicial deve Ser maior que 1")
   RETU .F.
ENDIF
IF MESFIM>13
   ALERTX("Mes Final deve Ser menor que 13")
   RETU .F.
ENDIF
IF MESFIM<MESINI
   ALERTX("Mes Final menor que o mes inicial")
   RETU .F.
ENDIF


ANOREF=YEAR(DATAREF)



IF ! NETUSE(PES) 
   RETU
ENDIF
FILTRO=''
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO
IF file(ZDIRE+"FO_FP13A.DBF")
   IF ! NETUSE("FO_FP13A") 
      DBCLOSEALL()
      RETU
   ENDIF
ELSE
   IF ! NETUSE(F13)   //competencias antigas
      DBCLOSEALL()
      RETU .F.
   ENDIF
ENDIF
cSELE2:=ALIAS()


IF ! NETUSE("FORAIS") 
   DBCLOSEALL()
   RETU .F.
ENDIF

//IF MESINI=1.AND.MESFIM=12 /nao mais da o zap
   //NETZAP("FORAIS") //pois tera as informacoes de vinculo e demissao
//ENDIF


MDS("Apagando Acumulo Anterior")
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   PETELA(8)
   mNUMERO=NUMERO
   mNOME:=NOME
   mDEMITIDO:=DEMITIDO
   AVOS:=MES1:=MES2:=0
   //Verificando Avos e Meses Pagamento 13o.Salario
   DO CASE
      //N„o Demitido Admitido Antes data ref.
   CASE EMPTY(DEMITIDO).AND.ANOREF>YEAR(ADMITIDO)
      AVOS=12
      MES1=11
      MES2=12
      //N„o Demitido Admitido no Ano
   CASE EMPTY(DEMITIDO).AND.ANOREF=YEAR(ADMITIDO)
      AVOS=12-MONTH(ADMITIDO)
      IF DAY(eom(ADMITIDO))-DAY(ADMITIDO)>13
         AVOS++
      ENDIF
      MES2=12
      DO CASE
      CASE MONTH(ADMITIDO)=11
         dbselectar(cSELE2)
         MES1=IF(VALCTA(mNUMERO,460)>0,11,0)
         DBSELECTAR(PES)
      CASE MONTH(ADMITIDO)=12 ; MES1=0
      OTHERWISE               ; MES1=11
      ENDCASE
      //Demitido Admitido Antes data ref.
   CASE ! EMPTY(DEMITIDO).AND.ANOREF>YEAR(ADMITIDO)
      AVOS=MONTH(DEMITIDO)-1
      IF DAY(DEMITIDO)>14
         AVOS++
      ENDIF
      MES2=MONTH(DEMITIDO)
      IF MONTH(DEMITIDO)=12
         dbselectar(cSELE2)
         MES1=IF(VALCTA(mNUMERO,460)>0,11,0)
         DBSELECTAR(PES)
      ELSE
         MES1=0
      ENDIF
      //Admitido e Demitido Ano Referencia
   CASE ! EMPTY(DEMITIDO).AND.ANOREF=YEAR(ADMITIDO)
      IF MONTH(ADMITIDO)#MONTH(DEMITIDO)
         AVOS=MONTH(ADMITIDO)-MONTH(DEMITIDO)-1
         IF DAY(DEMITIDO)>14
            AVOS++
         ENDIF
         IF DAY(eom(ADMITIDO))-DAY(ADMITIDO)>13
            AVOS++
         ENDIF
      ELSE
         AVOS=IF(DAY(ADMITIDO)-DAY(DEMITIDO)>14,1,0)
      ENDIF
      IF MONTH(DEMITIDO)=12
         dbselectar(cSELE2)
         MES1=IF(VALCTA(mNUMERO,460)>0,11,0)
         DBSELECTAR(PES)
      ELSE
         MES1=0
         MES2=MONTH(DEMITIDO)
      ENDIF
   ENDCASE
   DBSELECTAR(PES)
   //Grava os Avos
   NETRECLOCK()
   FIELD->AVOSM := IF(AVOS>0.AND.AVOS<13,AVOS,0)
   DBUNLOCK()

   DBSELECTAR("FORAIS")
   DBGOTOP()
   IF ! DBSEEK(str(anouso,4)+str(mNUMERO,8))
      NETRECAPP()
      FIELD->NUMERO:=mNUMERO
      FIELD->ANO   :=ANOUSO
   ELSE
      NETRECLOCK()   
   ENDIF
   FIELD->NOME:=mNOME
   FIELD->IBGECOD:=xrCODIBGE   
   FIELD->MES_1 := MES1
   FIELD->MES_2 := MES2
   //Zera os Acumulos Mensais
   FOR X=MESINI TO MESFIM
      MESA='RAIZ'+SUBSTR(MMES(X),1,3)
      FIELD->&MESA:=0
      //Zera Acumulos 13o. Salario Se o acumulo for no mes
      IF MES_1=X
         FIELD->SAL13_1:=0
      ENDIF
      IF MES_2=X
         FIELD->SAL13_2:=0
      ENDIF
      //Zera Aviso
      IF ! EMPTY(MDEMITIDO).AND.X>=MONTH(MDEMITIDO)
         FIELD->RAIZAVI:=0
         FIELD->RAIZMUL:=0
         FIELD->RAIZFER:=0
         field->RAIZACR:=0
         FIELD->RAIZGRA:=0
         FIELD->MESACR:=0
         FIELD->MESGRA:=0

      ENDIF
   NEXT X
   //Zera os Acumulos 13o. Sem Meses de Referencia
   IF MES_1=0
      FIELD->SAL13_1:=0
   ENDIF
   IF MES_2=0
      FIELD->SAL13_2:=0
   ENDIF
   DBUNLOCK()
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
dbselectar(cSELE2)
DBCLOSEAREA()

MDS("Carregando Configura‡„o do Plano de Contas")
//Preenchendo Matriz com as Contas que acumulam
aCTA01={} &&Numero da Conta
aCTA02={} &&Descricao da Conta
aCTA03={} &&Codigo Para Rais
IF ! NETUSE("CONTAS") 
   dbcloseall()
   RETU .F.
ENDIF
DBGOTOP()
WHILE ! EOF()
   IF RAIZ#1
      AADD(aCTA01,CODIGO)
      AADD(aCTA02,DESCR)
      AADD(aCTA03,RAIZ)
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEAREA()

//Verifica Configura‡„o
nCTA=LEN(aCTA01)
IF nCTA=0
   MDT("Nenhuma Conta esta sendo acumulada")
   DBCLOSEALL()
   RETU .F.
ENDIF


IF ! NETUSE("SINDICAT") 
   DBCLOSEALL()
   RETU .F.
ENDIF

//Acumulando o Periodo
MDS("Acumulando Dados")
FOR X=MESINI TO MESFIM
   ARQTRAB=STRZERO(X,2)
   FOT =IF(NRSEN <> 'DiReT' ,'FP'+EMP+ARQTRAB,'SO'+EMP+ARQTRAB)
   INFOR(FOT,"CONTROLE",ZDIRE+FOT,.T.)
   CLSROW(8)
   HB_DISPBOX(19,00,21,79,B_DOUBLE)
   @ 20,03 SAY 'MES: '+MMES(X)
   IF ! NETUSE(FOT) 
      RETU
   ENDIF
   DBSELECTAR(PES)
   DBGOTOP()
   WHILE ! EOF()
      mNUMERO=NUMERO
      mSINDICATO:=SINDICATO
      mCGCSIN:=REPL("0",14)
      mCTASIND:=630
      mCTAASSI:=620
      mCTACONF:=621
      mCTAMENS:=610
      mVALSOC1:=0
      mVALSOC2:=0
      mVALSIN:=0
      mVALASS:=0
      mVALCON:=0
      DBSELECTAR("SINDICAT")
      DBGOTOP()
      IF DBSEEK(mSINDICATO)
         mCGCSIN:=TIRAOUT(CGC)
         mCTAASSI:=IF(EMPTY(CTAASSI),620,CTAASSI)
         mCTACONF:=IF(EMPTY(CTACONF),621,CTACONF)
         mCTAMENS:=IF(EMPTY(CTASIND),610,CTASIND)
      ENDIF
      DBSELECTAR(PES)
      VALMES:=VALMES1:=VALMES2:=VALAVI:=0
      VALFER:=VALGRA:=VALACR:=VALMUL:=0
      VALHOR:=0
      PETELA(8)
      //Procurando Valores
      FOR W=1 TO nCTA
         mCONTROLE=(mNUMERO*10000)+aCTA01[W]
         DBSELECTAR(FOT)
         DBGOTOP()
         IF DBSEEK(mCONTROLE)
            MDS(aCTA02[W])
            //Analisando Codigos de Acumulo
            DO CASE
            CASE aCTA03[W]=0 ;  VALMES  += VALOR
            CASE aCTA03[W]=2 ;  VALMES  -= VALOR
            CASE aCTA03[W]=3 ;  VALMES1 += VALOR
            CASE aCTA03[W]=4 ;  VALMES2 += VALOR
            CASE aCTA03[W]=5 ;  VALAVI  += VALOR
            CASE aCTA03[W]=6 ;  VALFER  += VALOR
            CASE aCTA03[W]=7 ;  VALACR  += VALOR
            CASE aCTA03[W]=8 ;  VALGRA  += VALOR
            CASE aCTA03[W]=9 ;  VALMUL  += VALOR
            ENDCASE
         ELSE
            MD()
         ENDIF
      NEXT W
      FOR W=1 TO 10
         mCONTROLE=(mNUMERO*10000)+aCTAHOR[W]
         DBSELECTAR(FOT)
         DBGOTOP()
         IF DBSEEK(mCONTROLE)
            MDS(aCTAHOR[W])
            VALHOR  += HORAS*aCTAFAT[W]
         ELSE
            MD()
         ENDIF
      NEXT W

      FOR W=2 TO 4
          DO CASE
             case  W=1
                 mCONTROLE=(mNUMERO*10000)+0
             case  W=2
                 mCONTROLE=(mNUMERO*10000)+mCTASIND
             case  W=3
                mCONTROLE=(mNUMERO*10000)+mCTAASSI
             case  W=4
                mCONTROLE=(mNUMERO*10000)+mCTACONF
         ENDCASE
         DBSELECTAR(FOT)
         DBGOTOP()
         IF DBSEEK(mCONTROLE)
            //Analisando Codigos de Acumulo
            DO CASE
               case W=1
                 IF mVALSOC1=0
                    mVALSOC1 += VALOR
                 ELSE
                    mVALSOC1 += VALOR
                 ENDIF
               case W=2
                  mVALSIN += VALOR
               case W=3
                   mVALASS += VALOR
               case W=4
                   mVALCON += VALOR
            ENDCASE
         ENDIF
      NEXT W
      DBSELECTAR("FORAIS")
      dbgotop()
      if dbseek(STR(ANOUSO,4)+STR(mNUMERO,8))
         NETRECLOCK()
         //Gravando Acumulados
         IF VALMES>0
            MESA='RAIZ'+SUBSTR(MMES(X),1,3)
            FIELD->&MESA.:=VALMES
         ENDIF
         IF VALHOR>0
            MESA='HOR'+SUBSTR(MMES(X),1,3)
            FIELD->&MESA.:=VALHOR
         ENDIF
         IF VALMES1>0
            FIELD->SAL13_1:=SAL13_1+VALMES1
         ENDIF
         IF VALMES2>0
            FIELD->SAL13_2:=SAL13_2+VALMES2
         ENDIF
         IF VALAVI>0
            FIELD->RAIZAVI:=RAIZAVI+VALAVI
         ENDIF
         IF VALfer>0
            FIELD->RAIZfer:=RAIZfer+VALfer
         ENDIF
         IF VALacr>0
            FIELD->RAIZacr:=RAIZacr+VALacr
            FIELD->MESACR:=MESACR+1
         ENDIF
         IF VALgra>0
            FIELD->RAIZgra:=RAIZgra+VALgra
            FIELD->MESGRA:=MESGRA+1
         ENDIF
         IF VALmul>0
            FIELD->RAIZmul:=RAIZmul+VALmul
         ENDIF
         IF mVALSOC1>0
            FIELD->VALSOC1:=VALSOC1+mVALSOC1
            FIELD->CGCSOC1:=mCGCSIN
         ENDIF
         IF mVALSOC2>0
            FIELD->VALSOC2:=VALSOC2+mVALSOC2
            FIELD->CGCSOC2:=mCGCSIN
         ENDIF
         IF mVALSIN>0
            FIELD->VALSIN:=VALSIN+mVALSIN
            FIELD->CGCSIN:=mCGCSIN
         ENDIF
         IF mVALASS>0
            FIELD->VALASS:=VALASS+mVALASS
            FIELD->CGCASS:=mCGCSIN
         ENDIF
         IF mVALCON>0
            FIELD->VALCON:=VALCON+mVALCON
            FIELD->CGCCON:=mCGCSIN
         ENDIF
         DBUNLOCK()
      ENDIF
      DBSELECTAR(PES)
      DBSKIP()
   ENDDO
   DBSELECTAR(FOT)
   DBCLOSEAREA()
NEXT X
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   PETELA(8)
   mNUMERO:=NUMERO
   mDEMITIDO:=DEMITIDO
   DBSELECTAR("FORAIS")
   DBGOTOP()
   IF DBSEEK(STR(ANOUSO,4)+STR(mNUMERO,8))
      NETRECLOCK()
      IF EMPTY(mDEMITIDO)
         FIELD->RAIZAVI:=0
         FIELD->RAIZMUL:=0
         FIELD->RAIZFER:=0
         field->RAIZACR:=0
         FIELD->RAIZGRA:=0
         FIELD->MESACR:=0
         FIELD->MESGRA:=0
      ENDIF
      IF EMPTY(SAL13_1)
         FIELD->MES_1=0
      ENDIF
      IF EMPTY(SAL13_2)
         FIELD->MES_2=0
      ENDIF
      DBUNLOCK()
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()

*: FIM: FOLIS_A3.PRG
