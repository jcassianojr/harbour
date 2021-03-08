#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

*!*****************************************************************************
*!
*!         Funcao: FORES_CY()
*!
*!*****************************************************************************
FUNCTION FORES_CY
PARA DATAI,DATAF,REFFIL,TITULO
@ 12,0 CLEA TO 16,79
@ 12,0 TO 16,79 DOUB
@ 14,3 SAY 'Acumulando Vari vel : '+TITULO
ANOI=YEAR(DATAI)
ANOF=YEAR(DATAF)
PATH1='\FOLHA\EMP'+ANOSTR(ANOI)+STRZERO(NREMP,3)+'\'+SPAC(20)
MDS('Confirme localizacao Arquivos de:'+ANOSTR(ANOI))
@ 24,45 GET PATH1
READCUR()
PATH1=ALLTRIM(PATH1)
IF ANOI#ANOF
   PATH2='\FOLHA\EMP'+ANOSTR(ANOF)+STRZERO(NREMP,3)+'\'+SPAC(20)
   MDS('Confirme localizacao Arquivos:'+ANOSTR(ANOF))
   @ 24,45 GET PATH2
   READCUR()
   PATH2=ALLTRIM(PATH2)
   READCUR()
ENDIF
MESINI=MONTH(DATAI)
MESFIM=12
PATHB=PATH1
ACUVAR(REFFIL,.T.,.T.)
IF ANOI#ANOF
   MESINI=1
   MESFIM=MONTH(DATAF)
   PATHB=PATH2
   ACUVAR(REFFIL,.T.,.F.)
ENDIF
MESES=12
MDS('Qual o avos divisor da Media')
@ 24,40 GET MESES
READCUR()
MDS('Aguarde Calculando a Media')
DBSELECTAR("FO_VAR")
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("HORAS",HORAS/MESES) },{||NUMERO=CTR}, {|| zei_fort(nLASTREC,,,1)})
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("VALOR",VALOR/MESES) },{||NUMERO=CTR}, {|| zei_fort(nLASTREC,,,1)})
DBSELECTAR("FO_VAR")
VALORVAR=VALVAR(REFFIL)
RETU(VALORVAR)

*!*****************************************************************************
*!
*!         Fun‡„o: MDL()
*!
*!
*!*****************************************************************************
FUNCtion MDL(TITULO,nTIP)
IF VALTYPE(nTIP)#"N"
   nTIP:=1
ENDIF
CABE2(TITULO)
@ 18,00 TO 21,79 DOUB
@ 19,03 SAY 'LIGUE A IMPRESSORA !! ,Ajuste o papel'
@ 20,25 SAY 'IMPRESSORA DEFINIDA PARA FORMULARIO => '
@ 20,64 SAY IF(IM1='A','80','132')+' Colunas '
RETURN CHECKIMP(nTIP)


*!*****************************************************************************
*!
*!         Fun‡„o: TABINSS()
*!
*!*****************************************************************************
FUNCTION TABINSS(BUSCA)                                      &&CARREGA TABELA INSS
MDS('Carregando tabela INSS')
IF ! netuse("TABINSS")
   RETU
ENDIF
DBGOTO(BUSCA)
IN1=ATESAL1
IN2=ATESAL2
IN3=ATESAL3
IN4=ATESAL4
IN5=ATESAL5
IN6=ATESAL6
IN7=ATESAL7
TX1=(TAXA1/100)
TX2=(TAXA2/100)
TX3=(TAXA3/100)
TX4=(TAXA4/100)
TX5=(TAXA5/100)
TX6=(TAXA6/100)
TX7=(TAXA7/100)
TXI1=(TAXAI1/100)
TXI2=(TAXAI2/100)
TXI3=(TAXAI3/100)
TXI4=(TAXAI4/100)
TXI5=(TAXAI5/100)
TXI6=(TAXAI6/100)
TXI7=(TAXAI7/100)
DO CASE
CASE TX7 <> 0.00 ; TX=TX7 ; TXI=TXI7
CASE TX6 <> 0.00 ; TX=TX6 ; TXI=TXI6
CASE TX5 <> 0.00 ; TX=TX5 ; TXI=TXI5
CASE TX4 <> 0.00 ; TX=TX4 ; TXI=TXI4
CASE TX3 <> 0.00 ; TX=TX3 ; TXI=TXI3
CASE TX2 <> 0.00 ; TX=TX2 ; TXI=TXI2
CASE TX1 <> 0.00 ; TX=TX1 ; TXI=TXI1
ENDCASE
TETOINPS=TETOMAXIMO
TETOINPSI=TETOIRRF
SALFAMILIA=FAMILIA
SALFAMIL1=FAMILIA1
TETOFAMIL=TETOSALFA
TETOFAMI1=TETOSALF1
INSSDESC:=DESCONTO
DBCLOSEAREA()
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: TABIRRF()
*!
*!*****************************************************************************
FUNCTION TABIRRF(BUSCA)                                      &&CARREGA TABELA IRRF
MDS('Carregando Tabela IRRF')
IF ! NETUSE("TABIRRF") //BREDE("TABIRRF",0)
   RETU
ENDIF
DBGOTO(BUSCA)
QTDEIRRF=QTDEDEP
VDEPENDE=VALDEPENDE
DESC_MINIMO=MINIMO
IRRF1=ATESAL1
IRTX1=TAXA1
IRPA1=PARCELA1
IRRF2=ATESAL2
IRTX2=TAXA2
IRPA2=PARCELA2
IRRF3=ATESAL3
IRTX3=TAXA3
IRPA3=PARCELA3
IRRF4=ATESAL4
IRTX4=TAXA4
IRPA4=PARCELA4
IRRF5=ATESAL5
IRTX5=TAXA5
IRPA5=PARCELA5
IRRF6=ATESAL6
IRTX6=TAXA6
IRPA6=PARCELA6
IRRF7=ATESAL7
IRTX7=TAXA7
IRPA7=PARCELA7
ARREIRRF=ARREDONDA
DESPIRRF=DESPRESA
mFATORIRRF  := FATORIRRF
mFATORIRR2  := FATORIRR2
DBCLOSEAREA()
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: CALCINSS()
*!
*!*****************************************************************************
FUNCTION CALCINSS(BASE)                                             &&CALCULA INSS
VALORINSS:=VALORINSSI:=0
//VALOR INSS DE DESCONTO
IF BASE >= TETOINPS
   VALORINSS=ROUND((TETOINPS * TX),2)
ELSE
   DO CASE
   CASE BASE <= IN1 ; VALORINSS=ROUND((BASE * TX1),2)
   CASE BASE <= IN2 ; VALORINSS=ROUND((BASE * TX2),2)
   CASE BASE <= IN3 ; VALORINSS=ROUND((BASE * TX3),2)
   CASE BASE <= IN4 ; VALORINSS=ROUND((BASE * TX4),2)
   CASE BASE <= IN5 ; VALORINSS=ROUND((BASE * TX5),2)
   CASE BASE <= IN6 ; VALORINSS=ROUND((BASE * TX6),2)
   CASE BASE <= IN7 ; VALORINSS=ROUND((BASE * TX7),2)
   ENDCASE
ENDIF
//VALOR INSS DE DEDUCAO IRRF
IF BASE >= TETOINPSI
   VALORINSSI=ROUND((TETOINPSI * TXI),2)
ELSE
   DO CASE
   CASE BASE <= IN1 ; VALORINSSI=ROUND((BASE*TXI1),2)
   CASE BASE <= IN2 ; VALORINSSI=ROUND((BASE*TXI2),2)
   CASE BASE <= IN3 ; VALORINSSI=ROUND((BASE*TXI3),2)
   CASE BASE <= IN4 ; VALORINSSI=ROUND((BASE*TXI4),2)
   CASE BASE <= IN5 ; VALORINSSI=ROUND((BASE*TXI5),2)
   CASE BASE <= IN6 ; VALORINSSI=ROUND((BASE*TXI6),2)
   CASE BASE <= IN7 ; VALORINSSI=ROUND((BASE*TXI7),2)
   ENDCASE
ENDIF
RETU(VALORINSS)

*!*****************************************************************************
*!
*!      Procedure: CALCDEPE
*!
*!*****************************************************************************
PROC CALCDEPE                                       &&CALCULA VALOR DEPENDENTES
VAL4=IF(DEP>QTDEIRRF,(QTDEIRRF * VDEPENDE),(DEP * VDEPENDE))
IF mFATORIRRF#0
   VAL4:= ROUND(VAL4/mFATORIRRF,2)
ENDIF
RETU VAL4

*!*****************************************************************************
*!
*!         Fun‡„o: CALCIRRF()
*!
*!*****************************************************************************
FUNCTION CALCIRRF(BASE)                                               &&CALCULA IR
nBASEIRRF:= IF(mFATORIRRF#0,ROUND(BASE*mFATORIRRF,2),BASE)
IR3:=DESCIR:=VALDESCIR:=0
DO CASE
CASE nBASEIRRF <= IRRF1 ; IR3=IRTX1 ; DESCIR=IRPA1
CASE nBASEIRRF <= IRRF2 ; IR3=IRTX2 ; DESCIR=IRPA2
CASE nBASEIRRF <= IRRF3 ; IR3=IRTX3 ; DESCIR=IRPA3
CASE nBASEIRRF <= IRRF4 ; IR3=IRTX4 ; DESCIR=IRPA4
CASE nBASEIRRF <= IRRF5 ; IR3=IRTX5 ; DESCIR=IRPA5
CASE nBASEIRRF <= IRRF6 ; IR3=IRTX6 ; DESCIR=IRPA6
CASE nBASEIRRF >  IRRF7 ; IR3=IRTX7 ; DESCIR=IRPA7
ENDCASE
IF IR3 # 0
   IR3A=(IR3/100)
   IR2=(nBASEIRRF * IR3A)
   VALDESCIR=(IR2 - DESCIR)
   IF VALDESCIR <= DESC_MINIMO
      VALDESCIR:=IR3:=0
   ENDIF
ELSE
   VALDESCIR:=IR3:=0
ENDIF
IF ARREIRRF='S'
   VALDESCIR=(INT((VALDESCIR+.5)*100)/100)
ENDIF
IF DESPIRRF='S'
   VALDESCIR=INT(VALDESCIR)
ENDIF
VALDESCIR:= IF(mFATORIRR2#0,ROUND(VALDESCIR/mFATORIRR2,2),VALDESCIR)
RETU(VALDESCIR)

*!*****************************************************************************
*!
*!         Fun‡„o: CABE2()
*!
*!*****************************************************************************
FUNCTION CABE2(TITULO)                                        &&CABECARIO DE MENUS
SETCOLOR("N/W")
@ 06,04 CLEA TO 06,74
@ 06,06 SAY TITULO
SETCOLOR("W/N,N/W")
@ 08,00 CLEA
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: CABE3()
*!
*!*****************************************************************************
FUNCTION CABE3(TITULO,QT)                               &&TELA AUXILIAR PARA MENUS
SETCOLOR("W/N,N/W")
@ 04,01 CLEA TO 04,78
@ 06,01 CLEA TO 06,78
@ 08,00 CLEA
SETCOLOR("N/W")
@ 04,04 CLEA TO 04,74
@ 04,06 SAY TITULO
SETCOLOR("+GR/BG")
HB_dispbox( 8, 0, qt, 79,B_DOUBLE)
RETU(.T.)


*!*****************************************************************************
*!
*!         Fun‡„o: CABEX()
*!
*!*****************************************************************************
FUNCTION CABEX(cMES)
CABE2(cMES)
RETURN .T.


*!*****************************************************************************
*!
*!         Fun‡„o: GRAVA2()
*!
*!*****************************************************************************
FUNCTION GRAVA2                                         &&USO GRAVACAO DADOS FOLHA
PARA CTR1,VALE,dCDAT
LOCAL cALIAS
cALIAS:=ALIAS()
DBSELECTAR("CONTAS")
DBGOTOP()
IF DBSEEK(CTR1)
    XA=FATOR
    XB=TIPO
    XC=TRIBUTINPS
    XD=TRIBUTIRR
    XE=TRIB_FGTS
    XF=VALOR
ENDIF
CTA=(CTR*10000)+CTR1
DBSELECTAR(cALIAS)
DBGOTOP()
IF ! DBSEEK(CTA)
    NETRECAPP()
    FIELD -> NUMERO   := CTR
    FIELD -> CONTA    := CTR1
    FIELD -> CONTROLE := CTA
ELSE 
    NETRECLOCK()    
ENDIF
FIELD -> VALOR      := VALE
FIELD -> FATOR      := XA
FIELD -> TIPO       := XB
FIELD -> TRIBUTINPS := XC
FIELD -> TRIBUTIRR  := XD
FIELD -> TRIB_FGTS  := XE
FIELD -> VALORBASE  := XF
IF VALTYPE(dCDAT)="D"
   FIELD->DATACOMP:=dCDAT
ENDIF
DBUNLOCK()
RETU .T.


*!*****************************************************************************
*!
*!      Procedure: FODZER
*!
*!*****************************************************************************
PROC FODZER
GRAPP=1
GRAPT=LASTREC()
GRAPT('AGUARDE  EXCLUINDO VALORES = 0.00')
PCK=.F.
DBGOTOP()
WHILE ! EOF()
   IF ALLTRIM(ALIAS())#"FO_COMP"
      IF HORAS = 0.00.AND.VALOR = 0.00
         netrecdel()
         PCK=.T.
      ENDIF
   ELSE
      IF HORAS = 0.00.AND.VALOR = 0.00.AND.VALORMES1=0.AND.VALORMES2=0
         netrecdel()
         PCK=.T.
      ENDIF
   ENDIF
   GRAPS()
   DBSKIP()
ENDDO
IF PCK
   PACK
ENDIF
RETU



*!*****************************************************************************
*!
*!         Fun‡„o: ANOSTR()
*!
*!    Chamado por: FORES_CY()         (fun‡„o    em FORESP.PRG)
*!
*!*****************************************************************************
FUNCTION ANOSTR(XANO)                                 &&USADO PARA CALCULO DE ANOS
RETU SUBSTR(STRZERO(XANO,4),3,2)

*!*****************************************************************************
*!
*!         Fun‡„o: VALCTA()
*!
*!*****************************************************************************
FUNCTION VALCTA(NFUNC,NCONT)                      &&RETORNA UM VALOR DE UMA CONTA
BUSCA=(NFUNC*10000)+NCONT
DBGOTOP()
IF ! DBSEEK(BUSCA)
   RETU(0)
ENDIF
RETU(VALOR)


*!*****************************************************************************
*!
*!         Fun‡„o: VALVAR()
*!
*!*****************************************************************************
FUNCTION VALVAR
PARA FILVAR
DOMINGO:=0.000
MDS("Qual a media de dias DSR ")
@ 24,40 GET DOMINGO PICT "9.999"
READCUR()
MDS('Atualizando Variavel')
VALDSR:=VALCTA6:=VALEVAR:=0
DBSELECTAR("CONTAS")
SET FILTER TO &FILVAR
DBGOTOP()
WHILE ! EOF()
   BUSCA=(CTR*10000)+CODIGO
   MESSM='Calculando: '+STR(CODIGO)+'-'+DESCR
   mCONTA=CODIGO
   TIP=TIPO
   FAT=FATOR
   VAL=VALOR
   DBSELECTAR("FO_VAR")
   DBGOTOP()
   IF DBSEEK(BUSCA)
      MDS(MESSM)
      VALE1=0
      DO CASE
      CASE TIP    =   0 ; VALE1=VALOR
      CASE TIP    =   1 ; VALE1=HORAS*SALH
      CASE TIP    =   2 ; VALE1=VAL
      CASE TIP    =   3 ; VALE1=VAL*HORAS
      CASE mCONTA =   6 ; VALCTA6:=VALOR
      ENDCASE
      VALE1=IF(FAT # 0.00,VALE1*FAT,VALE1)
      NETRECLOCK()
      FIELD->VALOR:=VALE1
      DBUNLOCK()
      IF (mCONTA>19.AND.mCONTA<40).OR.(mCONTA>9.AND.mCONTA<17)
         VALDSR+=VALOR
      ENDIF
      VALEVAR+=IF(mCONTA#6,VALE1,0)
   ENDIF
   DBSELECTAR("CONTAS")
   DBSKIP()
ENDDO
IF DOMINGO#0.AND.VALDSR#0
   VALCTA6=((VALDSR/(30-DOMINGO))*DOMINGO)
   DBSELECTAR("FO_VAR")
   DBGOTOP()
   IF DBSEEK(CTR*10000+6)
      NETRECLOCK()
      FIELD->VALOR:=VALCTA6
      DBUNLOCK()
   ENDIF
ENDIF
VALEVAR+=VALCTA6
DBSELECTAR("CONTAS")
SET FILTER TO
RETU(VALEVAR)
*!*****************************************************************************
*!
*!         Fun‡„o: CABEP()
*!
*!    Chamado por: FORES_C3.PRG
*!               : RESTELA()          (fun‡„o    em FORES_C3.PRG)
*!
*!*****************************************************************************
FUNCTION CABEP(TITULO)
SETCOLOR("+N/GR")
HB_dispbox( 8, 0, 23, 78,B_DOUBLE)
SETCOLOR("+N/W")
@ 8,0 SAY " - "
SETCOLOR("+W/R")
@ 8,3 SAY TITULO
hb_scroll(9,79,24,79)
@ 24,1 SAY SPAC(78)
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: ACUVAR()
*!
*!*****************************************************************************
FUNCTION ACUVAR
PARA FILTRA,LPATH,LIMPAR
IF MESINI<1.OR.MESINI>12
   ALERTX("Erro Mes Inicial"+STR(MESINI))
   RETU .F.
ENDIF
IF MESFIM<1.OR.MESFIM>12
   ALERTX("Erro Mes Final"+STR(MESFIM))
   RETU .F.
ENDIF
MDS('Acumulando Sal rio Variavel')
DBSELECTAR("CONTAS")
SET FILTER TO &FILTRA
DBSELECTAR("FO_VAR")
IF LIMPAR
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({||netrecdel()},{||NUMERO=CTR}, {|| zei_fort(nLASTREC,,,1)})
ENDIF
//_PACK
FOR X=MESINI TO MESFIM
   ARQTRAB=STRZERO(X,2)
   FOT =IF(NRSEN #  'DiReT','FP'+EMP+ARQTRAB,'SO'+EMP+ARQTRAB)
   FOT=IF(LPATH,PATHB+FOT,FOT)
   INFOR(FOT,"CONTROLE",FOT,.T.)
   IF ! NETUSE(FOT) //AREDE(FOT,FOT,0)
      RETU
   ENDIF
   mNUMERO=CTR
   DBSELECTAR("CONTAS")
   DBGOTOP()
   WHILE ! EOF()
      MESSM='Conta: '+STR(CODIGO)+'-'+DESCR
      mVAR13S=SAL_13
      mNIV13S=NIVEL_13
      mVARFER=FERIAS
      mNIVFER=NIVEL_FERI
      mVARRES=DEMISSAO
      mNIVRES=NIVEL_DEM
      mTIPO=TIPO
      mCONTA=CODIGO
      mCONTROLE=(mNUMERO*10000)+mCONTA
      mmFATMES="FAT"+ARQTRAB
      mFATMES=&mmFATMES.
      mVALORFIXO=VALOR
      DBSELECTAR(FOT)
      DBGOTOP()
      IF DBSEEK(mCONTROLE)
         MDS(MESSM)
         mVALOR=0
         mHORAS=0
         IF mTIPO=1.OR.mTIPO=3
            mHORAS=HORAS
         ELSE
            mVALOR=IF(mFATMES=0,VALOR,VALOR*mFATMES)
         ENDIF
         DBSELECTAR("FO_VAR")
         DBGOTOP()
         IF ! DBSEEK(mCONTROLE)
            NETRECAPP()
            FO_VAR-> NUMERO   := mNUMERO
            FO_VAR-> CONTA    := mCONTA
            FO_VAR-> TIPO     := mTIPO
            FO_VAR-> CONTROLE := mCONTROLE
            FO_VAR-> VAR13S   := mVAR13S
            FO_VAR-> NIV13S   := mNIV13S
            FO_VAR-> VARFER   := mVARFER
            FO_VAR-> NIVFER   := mNIVFER
            FO_VAR-> VARRES   := mVARRES
            FO_VAR-> NIVRES   := mNIVRES
         ELSE
            NETRECLOCK()   
         ENDIF
         DO CASE
         CASE mTIPO=1.OR.mTIPO=3               &&SOMA HORAS
            FIELD->HORAS:=(HORAS+mHORAS)
         CASE mTIPO=0                          &&SOMA VALOR
            FIELD->VALOR:=(VALOR+mVALOR)
            FIELD->HORAS:=0
         CASE mCONTA=114                       &&PERICULOSIDADE
            FIELD->VALOR:=SALM
            FIELD->HORAS:=0
         ENDCASE
         DBUNLOCK()
      ENDIF
      DBSELECTAR("CONTAS")
      DBSKIP()
   ENDDO
   DBSELECTAR(FOT)
   DBCLOSEAREA()
NEXT X
DBSELECTAR("CONTAS")
SET FILTER TO
RETU .T.


