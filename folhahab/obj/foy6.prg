*:*****************************************************************************
*:
*:        FOY.PRG: Recompor Contas
*:      Linguagem: clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1997,  SOFTEC  S/C Ltda.
*:  Atualizado em: 11/11/97     13:38
*:
*:*****************************************************************************

CABEX('Recomposicao de Conta')
STORE 0 TO CTA1,CTA2,CTA3,CTA4,CTADES
STORE 0 TO XA,XB,XC,XD,XE,XF
@ 10,20 SAY '1 CONTA      : ' GET CTA1 PICT '###'
@ 11,20 SAY '2 CONTA      : ' GET CTA2 PICT '###'
@ 12,20 SAY '3 CONTA      : ' GET CTA3 PICT '###'
@ 13,20 SAY '4 CONTA      : ' GET CTA4 PICT '###'
@ 14,20 SAY '___________________'
@ 15,20 SAY 'Conta Destino: ' GET CTADES PICT '###'
IF ! READCUR()
   RETU .F.
ENDIF
IF EMPTY(CTADES)
   ALERTX("Vocˆ n„o Preencheu conta Destino")
   RETU .F.
ENDIF
IF ! MDG("Deseja Processeguir")
   RETU .F.
ENDIF
aCONTA:={CTA1,CTA2,CTA3,CTA4,CTADES}

IF ! netuse("CONTAS") //AREDE("CONTAS","CONTAS",1)
   RETU
ENDIF
FOR X=1 TO 3
   DBGOTOP()
   DBSEEK(aCONTA[X])
   IF ! EMPTY(aCONTA[X])
       IF ! FOUND()
          DBCLOSEALL()
          ALERTX("Conta n„o Cadastrada: "+STR(aCONTA[X]))
          RETU .F.
       ENDIF
       IF ACEITE="S".AND.ZUSER#"SUPERVISOR"
          DBCLOSEALL()
          ALERTX("Conta: "+STR(aCONTA[X])+" Acesso Limitado ao Supervisor")
          RETU .F.
       ENDIF
   ENDIF
NEXT X
//N„o Fechar Grava2() usa este Arquivo
aCONTA:={CTA1,CTA2,CTA3,CTA4}

IF ! NETUSE(PES) //AREDE(PES,PES,1)
   DBCLOSEALL()
   RETU
ENDIF
FILTRO='EMPTY(DEMITIDO)'
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO


IF ! ARQUSAR()
   DBCLOSEALL()
   RETU .F.
ENDIF 
cSELE2:=ALIAS()


DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   PETELA(8)
   CTR :=NUMERO
   VALE:=0
   DBSELECTAR(cPES)
   FOR X=1 TO 4
       IF ! EMPTY(aCONTA[X])
          VALE+=VALCTA(CTR,aCONTA[X])
       ENDIF
   NEXT X
   IF VALE>0
      DBSELECTAR(cSELE2)
      GRAVA2(CTADES)
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()
RETU

*: FIM: FOY6.PRG
