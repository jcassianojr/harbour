*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_c1.prg
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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :  FORES_C1.PRG : Calculando Ferias
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 25/08/97
// :
// :*****************************************************************************



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fores_c1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fores_c1

PARA CC
CABE2('Calculando Ferias')
CONTACRE := IF(CC = 1,80,88)
CONTATER := IF(CC = 1,81,89)
CONTALIQ := IF(CC = 1,580,581)
CONTABO  := IF(CC = 1,82,176)
CONTABT  := IF(CC = 1,83,177)
XA       := XB := XC := XD := XE := XF := CTR := DIASC := DIASP := 0
DADATAX  := DATE()
IN1      := TX1 := IN2 := TX2 := IN3 := TX3 := IN4 := TX4 := 0
IN5      := TX5 := IN6 := TX6 := IN7 := TX7 := TETOINPS := VALORINSS := 0
TXI1     := TXI2 := TXI3 := TXI4 := TXI5 := TXI6 := TXI7 := TETOINPSI := VALORINSSI := 0
TX       := TXI := 0
lDESABO  := .F.
IF CC = 1
   APAGA := "S"
ELSE
   APAGA := "N"
ENDIF

QTDEIRRF   := VDEPENDE := IRRF1 := IRTX1 := IRPA1 := DESC_MINIMO := 0
TETOFAMI1  := TETOFAMIL := SALFAMIL1 := SALFAMILIA := INSSDESC := 0
IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
ARREIRRF   := DESPIRRF := 'N'
mFATORIRRF := mFATORIRR2 := 0
DESC1      := DESCF := DESCA := 0

@ 22,00 CLEA TO 24,00
@ 22,00 SAY 'Digite o numero do funcionario'                      
@ 22,40 GET CTR                              PICT '######'        
@ 23,00 SAY 'Digite o P‚riodo Aquisitivo'                         
@ 23,40 GET DADATAX                                               
IF CC = 1
   @ 24,00 SAY 'Apagar Calculo da Competencia Anterior'                            
   @ 24,40 GET APAGA                                    VALID APAGA $ "SN "        
ENDIF
IF !READCUR()
   RETU .F.
ENDIF

IF !NETUSE(PES)   //AREDE(PES,PES,0)
   RETU
ENDIF
DBGOTOP()
IF !DBSEEK(CTR)
   DBCLOSEALL()
   RETU
ENDIF
mSITUACAO := SITUACAO

CTRA := (((((CTR * 10000)+YEAR(DADATAX)) * 100)+MONTH(DADATAX)) * 100)+DAY(DADATAX)
IF !NETUSE("FO_FER")  //AREDE("FO_FER","FO_FER",0)
   RETU
ENDIF
DBGOTOP()
IF !DBSEEK(CTRA)
   MDT('Periodo Aquisitivo n„o encontrado')
   DBCLOSEALL()
   RETU
ENDIF


IF !NETUSE("FO_PFE")
   RETU
ENDIF
IF APAGA = "S"
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEVAL({|| NETRECDEL()},{|| NUMERO = CTR},{|| zei_fort(nLASTREC,,,1)})
ENDIF
IF !NETUSE("CONTAS")
   RETU
ENDIF
IF !NETUSE("FO_VAR")
   RETU
ENDIF
DBSELECTAR("FO_FER")
FORESRT()
FORESRS()
FORESRG()
DIASC := IF(MONTH(GOZOU1DE) # MONTH(COMPDATAI),DAY(COMPDATAF),0)
DIASP := DIASPAGO - DIASC
IF MONTH(ABONO1DE) # MONTH(ABONO1ATE)
   DABOC := DAY(COMPABOF)
   DABOP := DIASPAGO2 - DABOC
ELSE
   IF MONTH(ABONO1DE) > MONTH(GOZOU1DE)   //Grava Mes Sequinte
      DABOC := DIASPAGO2
      DABOP := 0
   ELSE
      DABOC := 0
      DABOP := DIASPAGO2
   ENDIF
ENDIF
MESG1 := MONTH(GOZOU1DE)
MESG2 := IF(MONTH(GOZOU1DE) # MONTH(COMPDATAI),MONTH(COMPDATAI),0)
MESGA := MONTH(ABONO1DE)
MESGB := MONTH(COMPABOI)
IF CC = 2
   MESG1 := MONTH(COMPDATAI)
   MESG2 := 0
   MESGA := MONTH(COMPABOI)
   MESGB := 0
ENDIF
DATAI   := DATFERIAS
DATAF   := DATFERIASF
SALVFER := SALVAR
SALVFEC := SALVARC

IF CC = 1
   IF DIASPAGO = 0
      MDT('Remanejamento sem data de periodo de gozo')
      DBCLOSEALL()
      RETU
   ENDIF
   DIAS  := DIASPAGO
   DIASA := DIASPAGO2
   MEF   := MONTH(GOZOU1DE)
ENDIF
IF CC = 2
   IF EMPTY(COMPDATAI) .AND. EMPTY(COMPABOI)
      MDT('Remanejamento sem periodo de complemento')
      DBCLOSEALL()
      RETU
   ENDIF
   DIAS := DAY(COMPDATAF) - DAY(COMPDATAI)+1
   IF !EMPTY(COMPABOI)
      DIASA := DAY(COMPABOF) - DAY(COMPABOI)+1
   ELSE
      DIASA := 0
   ENDIF
   IF !EMPTY(COMPDATAI)
      MEF  := MONTH(COMPDATAI)
      MEFI := MONTH(GOZOU1DE)
      IF MEF = MEFI
         MEFI --
      ENDIF
   ELSE
      MEF  := MONTH(COMPABOI)
      MEFI := MONTH(ABONO1DE)
   ENDIF
ENDIF
IF CC = 1
   DIAST := DIASPAGO+DIASPAGO2
   DATRI := IF(GOZOU1DE < ABONO1DE .OR. EMPTY(ABONO1DE),GOZOU1DE,ABONO1DE)
   DATRF := IF(GOZOU1ATE > ABONO1ATE .OR. EMPTY(ABONO1ATE),GOZOU1ATE,ABONO1ATE)
   MEIR1 := MONTH(DATRI)
   MEIR2 := MONTH(DATRF)
   DIAIR := IF(MONTH(DATRF) # MONTH(DATRI),DIAST - DAY(DATRF),DIAST)
   DIAIP := DIAST - DIAIR
ENDIF
VARFER  := VARFERT := VARABO := VARABOT := FERIAS80 := FERIAS81 := ABONO82 := ABONO83 := 0
BASINSS := BASIRRF := SALM := SALH := VAR1 := VAL5 := CRE1 := CRE2 := DEB1 := DEB2 := 0
MESIRRF := MEF
MDS('Confirme tabela de utilizacao IRRF MES:')
@ 24,50 GET MESIRRF         
READCUR()
TABINSS(MEF)
TABIRRF(MESIRRF)
DBSELECTAR(PES)
SALHM(MEF)
IF CC = 2
   SALA := SALM
   SALHM(MEFI)
   SALM := SALA - SALM
ENDIF
DBSELECTAR("FO_PFE")
xSAL := VALCTA(CTR,473)+VALCTA(CTR,474)
IF xSAL # 0
   SALM := xSAL
   MDT('Salario Alterado Conforme informativo')
ENDIF
IF CC = 1
   IF MDG('Deseja Acumular Sal rio Variavel')
      MDS('Confirme Periodo de Acumula‡„o')
      @ 24,40 GET DATAI         
      @ 24,50 GET DATAF         
      READCUR()
      SALVFER := FORES_CY(DATAI,DATAF,'FERIAS=0','Ferias')
   ENDIF
   MDS('Digite o Valor da M‚dia de Sal. Variavel')
   @ 24,50 GET SALVFER PICT '###,###,###,###.##'        
   READCUR()
   DBSELECTAR("FO_FER")
   FO_FER->SALVAR := SALVFER
ENDIF
IF CC = 2
   IF MDG('Deseja Acumular Sal rio Variavel')
      MDS('Confirme Periodo de Acumula‡„o')
      @ 24,40 GET DATAI         
      @ 24,50 GET DATAF         
      READCUR()
      SALVFEC := FORES_CY(DATAI,DATAF,'FERIAS=0','Ferias')
   ENDIF
   MDS('Digite o Valor da M‚dia de Sal. Variavel')
   @ 24,50 GET SALVFEC PICT '###,###,###,###.##'        
   READCUR()
   DBSELECTAR("FO_FER")
   FO_FER->SALVARC := SALVFEC
   SALM            += SALVFEC - SALVFER
ENDIF
MDS("Confirme os Dias e Dias de Abono")
@ 24,40 GET DIAS  PICT "##.##"        
@ 24,50 GET DIASA PICT "##.##"        
READCUR()

DBSELECTAR("FO_PFE")
FERIAS80 := ROUND(SALM * DIAS / 30,2)
FERIAS81 := ROUND(FERIAS80 / 3,2)
ABONO82  := ROUND(SALM * DIASA / 30,2)
ABONO83  := ROUND(ABONO82 / 3,2)
IF CC = 1
   VARFER  := ROUND(SALVFER * DIAS / 30,2)
   VARFERT := ROUND(VARFER / 3,2)
   VARABO  := ROUND(SALVFER * DIASA / 30,2)
   VARABOT := ROUND(VARABO / 3,2)
ENDIF

GRAVA3(CONTACRE,FERIAS80)
GRAVA3(CONTATER,FERIAS81)

IF CC = 1
   GRAVA3(172,VARFER)
   GRAVA3(173,VARFERT)
   GRAVAA(174,VARABO)
   GRAVAA(175,VARABOT)
   GRAVAA(CONTABO,ABONO82)
   GRAVAA(CONTABT,ABONO83)
ENDIF
IF CC = 2
   GRAVA3(CONTABO,ABONO82)
   GRAVA3(CONTABT,ABONO83)
ENDIF

MDS('Calculando IAPAS')
DBSELECTAR("FO_PFE")
BASEINNA := 0
BASEINSS := FERIAS80+FERIAS81+VARFER+VARFERT
BASEINSS += VALCTA(CTR,239)+VALCTA(CTR,241)
lDESABO  := MDG("Descontar INSS Abono Pecuniario")
lABAINS  := MDG("Abater desconto INSS IRRF")
IF lDESABO
   BASEINNA := ABONO82+ABONO83+VARABO+VARABOT
   BASEINSS := BASEINSS+ABONO82+ABONO83+VARABO+VARABOT
ENDIF
IF CC = 2
   DBSELECTAR("FO_PFE")
   BASEINSS += VALCTA(CTR,80)+VALCTA(CTR,81)
   BASEINSS += VALCTA(CTR,172)+VALCTA(CTR,173)
   IF lDESABO
      BASEINSS += VALCTA(CTR,82)+VALCTA(CTR,83)
      BASEINSS += VALCTA(CTR,174)+VALCTA(CTR,175)
      BASEINNA += VALCTA(CTR,82)+VALCTA(CTR,83)
      BASEINNA += VALCTA(CTR,174)+VALCTA(CTR,175)
   ENDIF
ENDIF
BASEINSD := BASEINSS - INSSDESC
IF BASEINSD < 0
   BASEINSD := 0
ENDIF
DESCA := CALCINSS(BASEINNA)
DESC1 := CALCINSS(BASEINSD)
IF CC = 2
   DBSELECTAR("FO_PFE")
   DESC1 -= VALCTA(CTR,479)
   DESC1 := IF(DESC1 > 0,DESC1,0)
ENDIF
IF BASEINNA+BASEINSS >= TETOINPS
   DESCF := DESC1
   DESCA := 0
ELSE
   DESCF := DESC1 - DESCA
ENDIF

IF mSITUACAO = "P"  //Aposentado nao paga INNS
   DESC1 := 0
   DESCA := 0
   DESCF := 0
ENDIF

IF !lDESABO
   GRAVA3(508,DESC1)
   GRAVA3(991,0)
   GRAVAA(992,0)
ELSE
   GRAVA3(508,0)
   GRAVA3(991,DESCF)
   GRAVAA(992,DESCA)
ENDIF

GRAVA3(420,BASEINSS)
GRAVA3(485,BASEINSS)
IF CC = 1
   GRAVA3(479,DESC1)
ELSE
   GRAVA3(478,DESC1)
ENDIF

MDS('Calculando IRRF')
DBSELECTAR("FO_PFE")
VAL5 := VALCTA(CTR,IF(CC = 1,513,514))  //Pens„o Alimenticia
GRAVA3(IF(CC = 1,513,514),VAL5)

DEP := FOSFAMQTDE(CTR)

DBSELECTAR(PES)
VAL4 := 0
CALCDEPE()

BASE := FERIAS80+FERIAS81+VARFER+VARFERT
BASE += ABONO82+ABONO83+VARABO+VARABOT
DBSELECTAR("FO_PFE")
BASE += VALCTA(CTR,239)+VALCTA(CTR,241)
DBSELECTAR("FO_PFE")
GRAVA2(404,BASE,DADATAX)
IF CC = 1
   FO_PFE->VALORMES1 := VALOR
   FO_PFE->MES1      := MESIRRF
ELSE
   FO_PFE->VALORMES2 := VALOR
   FO_PFE->MES2      := MESIRRF
ENDIF
BASE  := BASE - VAL4 - IF(lABAINS,VALORINSSI,0) - VAL5
DESC2 := CALCIRRF(BASE)
IF CC = 1
   DBSELECTAR("FO_PFE")
   GRAVA2(502,DESC2,DADATAX)
   FO_PFE->VALORMES1 := VALOR * DIAIR / DIAST
   FO_PFE->VALORMES2 := VALOR * DIAIP / DIAST
   FO_PFE->MES1      := MEIR1
   FO_PFE->MES2      := MEIR2
   SOMAMES()
ELSE
   GRAVA3(511,DESC2)
ENDIF
DBSELECTAR("FO_PFE")
GRAVA2(424,DESC2,DADATAX)
IF CC = 1
   FO_PFE->VALORMES1 := VALOR
   FO_PFE->MES1      := MESIRRF
ELSE
   FO_PFE->VALORMES2 := VALOR
   FO_PFE->MES2      := MESIRRF
ENDIF
DBSELECTAR("FO_PFE")
GRAVA2(423,VAL4+IF(lABAINS,VALORINSSI,0)+VAL5,DADATAX)  //Dedu‡oes
GRAVA2(451,VAL4,DADATAX)  //dependentes
GRAVA2(452,IF(lABAINS,VALORINSSI,0),DADATAX)  //inss
IF CC = 1
   FO_PFE->VALORMES1 := VALOR
   FO_PFE->MES1      := MESIRRF
ELSE
   FO_PFE->VALORMES2 := VALOR
   FO_PFE->MES2      := MESIRRF
ENDIF



MDS('Gravando total Cr‚ditos/Descontos/L¡quidos')
DBSELECTAR("FO_PFE")
GRAVA2(399,FERIAS80+FERIAS81+ABONO82+ABONO83+VARFER+VARFERT+VARABO+VARABOT,DADATAX)
FO_PFE->VALORMES1 := CRE1
FO_PFE->VALORMES2 := DEB1
FO_PFE->MES1      := MESG1
FO_PFE->MES2      := IF(MESG2 # 0,MESG2,MESGA)
IF lDESABO
   GRAVA2(999,DESCF+DESCA+DESC2+VAL5,DADATAX)
ELSE
   GRAVA2(999,DESC1+DESC2+VAL5,DADATAX)
ENDIF
FO_PFE->VALORMES1 := DEB1
FO_PFE->VALORMES2 := DEB2
FO_PFE->MES1      := MESG1
FO_PFE->MES2      := IF(MESG2 # 0,MESG2,MESGA)
DBSELECTAR("FO_PFE")
PREMIOS := VALCTA(CTR,237)+VALCTA(CTR,238)+VALCTA(CTR,239)+VALCTA(CTR,241)
VALLIQ  := VALCTA(CTR,399) - VALCTA(CTR,999)+PREMIOS
GRAVA2(CONTALIQ,VALLIQ,DADATAX)
FO_PFE->VALORMES1 := (CRE1 - DEB1)+PREMIOS
FO_PFE->VALORMES2 := (CRE2 - DEB2)
FO_PFE->MES1      := MESG1
FO_PFE->MES2      := IF(MESG2 # 0,MESG2,IF(EMPTY(MESGB),MESGA,MESGB))
DBSELECTAR("FO_PFE")
FODZER()
DBCLOSEALL()
RETU


// !*****************************************************************************
// !
// !         Fun‡„o: GRAVA3()
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVA3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC GRAVA3

PARA XXX1,XXX2
DBSELECTAR("FO_PFE")
GRAVA2(XXX1,XXX2,DADATAX)
IF CC = 1
   IF lDESABO .AND. (XXX1 = 508 .OR. XXX1 = 420)
      FO_PFE->VALORMES1 := VALOR * (DIASP+DABOP) / (DIAS+DIASA)
      FO_PFE->VALORMES2 := VALOR * (DIASC+DABOC) / (DIAS+DIASA)
   ELSE
      FO_PFE->VALORMES1 := VALOR * DIASP / DIAS
      FO_PFE->VALORMES2 := VALOR * DIASC / DIAS
   ENDIF
   WHILE VALORMES1+VALORMES2 > VALOR
      IF VALORMES1 > VALORMES2
         FO_PFE->VALORMES1 := VALORMES1 - .01
      ELSE
         FO_PFE->VALORMES2 := VALORMES2 - .01
      ENDIF
   ENDDO
   WHILE VALORMES1+VALORMES2 < VALOR
      IF VALORMES1 > VALORMES2
         FO_PFE->VALORMES1 := VALORMES1+.01
      ELSE
         FO_PFE->VALORMES2 := VALORMES2+.01
      ENDIF
   ENDDO
ELSE
   FO_PFE->VALORMES1 := VALOR
   FO_PFE->VALORMES2 := VALOR
ENDIF
FO_PFE->MES1 := MESG1
FO_PFE->MES2 := MESG2
SOMAMES()
RETU (.T.)

// !*****************************************************************************
// !
// !         Fun‡„o: GRAVAA()
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVAA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC GRAVAA

IF DIASA = 0
   RETU (.T.)
ENDIF
PARA XXX1,XXX2
DBSELECTAR("FO_PFE")
GRAVA2(XXX1,XXX2,DADATAX)
FO_PFE->VALORMES1 := VALOR * DABOP / DIASA
FO_PFE->VALORMES2 := VALOR * DABOC / DIASA
WHILE VALORMES1+VALORMES2 > VALOR
   IF VALORMES1 > VALORMES2
      FO_PFE->VALORMES1 := VALORMES1 - .01
   ELSE
      FO_PFE->VALORMES2 := VALORMES2 - .01
   ENDIF
ENDDO
WHILE VALORMES1+VALORMES2 < VALOR
   IF VALORMES1 > VALORMES2
      FO_PFE->VALORMES1 := VALORMES1+.01
   ELSE
      FO_PFE->VALORMES2 := VALORMES2+.01
   ENDIF
ENDDO
FO_PFE->MES1 := MESGA
FO_PFE->MES2 := MESGB
SOMAMES()
RETU (.T.)

// !*****************************************************************************
// !
// !         Fun‡„o: SOMAMES()
// !
// !    Chamado por: FORES_C1.PRG
// !               : GRAVA3()           (fun‡„o    em FORES_C1.PRG)
// !               : GRAVAA()           (fun‡„o    em FORES_C1.PRG)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function SOMAMES()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC SOMAMES

IF CONTA < 399
   CRE1 += VALORMES1
   CRE2 += VALORMES2
ENDIF
IF CONTA > 501
   DEB1 += VALORMES1
   DEB2 += VALORMES2
ENDIF
RETU (.T.)
// : FIM: FORES_C1.PRG

*+ EOF: fores_c1.prg
*+
