*:*****************************************************************************
*:
*:
*:     FOLISP.PRG: Nome do Programa
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************



#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

*!*****************************************************************************
*!
*!      Fun‡„o: TABINSS
*!
*!*****************************************************************************
FUNC TABINSS
IF ! NETUSE("TABINSS") //BREDE("TABINSS",0)
   RETU
ENDIF
DBGOTO(MESTRAB)
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
TX =0
TXI=0
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
RETU .T.

*!*****************************************************************************
*!
*!      Procedure: TABIRRF
*!
*!*****************************************************************************
FUNC TABIRRF
IF ! netuse("TABIRRF") //BREDE("TABIRRF",0)
   RETU
ENDIF
DBGOTO(MESTRAB)
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
IRTX7       := TAXA7
IRPA7       := PARCELA7
ARREIRRF    := ARREDONDA
DESPIRRF    := DESPRESA
mFATORIRRF  := FATORIRRF
mFATORIRR2  := FATORIRR2
DBCLOSEAREA()
RETU


*!*****************************************************************************
*!
*!         Fun‡„o: CALCDEPE()
*!
*!*****************************************************************************
FUNC CALCDEPE
VALDEPE=0
VALDEPE=IF(DEP>QTDEIRRF,QTDEIRRF*VDEPENDE,DEP*VDEPENDE)
IF mFATORIRRF#0
   VALDEPE:= ROUND(VALDEPE/mFATORIRRF,2)
ENDIF
RETU(VALDEPE)

*!*****************************************************************************
*!
*!         Fun‡„o: CALCIRRF()
*!
*!*****************************************************************************
FUNC CALCIRRF(BASE)                                               &&CALCULA IR
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
*!         Fun‡„o: GRAVA2()
*!
*!*****************************************************************************
FUNC GRAVA2(CTR1,VALE)
LOCAL cALIAS
cALIAS:=ALIAS()
DBSELECTAR("CONTAS")
DBGOTOP()
IF DBSEEK(CTR1)
   VAR4:=DESCR
   XA:=FATOR
   XB:=TIPO
   TIPCTA:=TIPO
   XC:=TRIBUTINPS
   XD:=TRIBUTIRR
   XE:=TRIB_FGTS
   XF:=VALOR
ENDIF
CTA=(CTR*10000)+CTR1
DBSELECTAR(cALIAS)
DBGOTOP()
IF ! DBSEEK(CTA)
   NETRECAPP()
   FIELD->NUMERO:=CTR
   FIELD->CONTA:=CTR1
   FIELD->CONTROLE:=(NUMERO*10000)+CONTA
ELSE
   NETRECLOCK()  
ENDIF
FIELD->VALOR:=VALE
FIELD->FATOR:=XA
FIELD->TIPO:=XB
FIELD->TRIBUTINPS:=XC
FIELD->TRIBUTIRR:=XD
FIELD->TRIB_FGTS:=XE
FIELD->VALORBASE:=XF
DBUNLOCK()
RETU .T.

*!*****************************************************************************
*!
*!      Procedure: FODZER
*!
*!*****************************************************************************
PROC FODZER
MDS('AGUARDE  EXCLUINDO VALORES = 0.00')
PCK=.F.
DBGOTOP()
DO WHILE ! EOF()
   IF HORAS = 0.00.AND.VALOR = 0.00
      NETRECDEL()
      PCK=.T.
   ENDIF
   DBSKIP()
ENDDO
IF PCK
   flock()
   PACK
ENDIF
RETU


*!*****************************************************************************
*!
*!         Fun‡„o: CABE2()
*!
*!*****************************************************************************
FUNC CABE2
PARA TITULO
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
FUNC CABE3
PARA TITULO,QT,QT2
SETCOLOR("W/N,N/W")
@ 03,01 CLEA TO 03,78
@ 04,01 CLEA TO 04,78
@ 05,00 CLEA
SETCOLOR("+N/W")
@ 03,04 CLEA TO 03,74
@ 03,04 SAY TITULO
SETCOLOR("+GR/BG")
@ 05,00 CLEA TO QT,QT2
HB_dispbox( 5, 0, QT,QT2,B_DOUBLE)
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: CERTEZA()
*!
*!*****************************************************************************
FUNC CERTEZA
IF MDG('Vocˆ tˆm certeza')
   RETU(.T.)
ENDIF
RETU(.F.)


*!*****************************************************************************
*!
*!         Fun‡„o: MDL()
*!
*!*****************************************************************************
FUNC MDL(TITULO,nTIPO)
IF VALTYPE(nTIPO)#"N"
   nTIPO:=1
ENDIF
CABE2(TITULO)
@ 18,00 TO 21,79 DOUB
@ 19,03 SAY 'LIGUE A IMPRESSORA !! ,Ajuste o papel'
@ 20,03 SAY 'IMPRESSORA DEFINIDA PARA FORMULARIO => '
IF IM1 = 'A'
   @ 20,50 SAY '80 Colunas '
ELSE
   @ 20,50 SAY '132 Colunas'
ENDIF
RETU CHECKIMP(nTIPO)


*!*****************************************************************************
*!
*!         Fun‡„o: VALCTA()
*!
*!*****************************************************************************
FUNC VALCTA
PARA NFUNC,NCONT
BUSCA=(NFUNC*10000)+NCONT
DBGOTOP()
IF ! DBSEEK(BUSCA)
   RETU(0)
ENDIF
RETU(VALOR)


********************Chamada por flib02
FUNC CABEX(cMES)
CABE3(cMES)
RETU .T.


*: FIM: FOLISP.PRG
