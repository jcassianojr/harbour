*:*****************************************************************************
*:
*:     FOID0.PRG : Acumular apura‡„o Folha
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 17/07/98
*:
*:*****************************************************************************

function foid0
PARA CC
CABEX('Acumular apura‡„o Folha')
IF MDG('Deseja Apagar Acumulo Anterior')
   netZAP("FO_APU")
ENDIF

IF ! ARQUSAR(CC,1,0)
   RETU .F.
ENDIF
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","conta")
ordSetFocus("temp")

cSELE1:=ALIAS()

IF ! ARQCTA(CC,1,1)
   RETU
ENDIF
cSELE2:=ALIAS()

IF ! NETUSE("FO_APU") //AREDE("FO_APU","FO_APU",0)
   RETU
ENDIF

DBSELECTAR(cSELE1)
DBGOTOP()
WHILE ! EOF()
   CTA=CONTA
   TOT:=TOT1:=0
   WHILE CTA=CONTA.AND.!EOF()
      TOT +=VALOR
      TOT1+=HORAS
      DBSKIP()
   ENDDO
   IMP = .T.
   IF CC#4.AND.CC#6
      IF CTA>120.AND.CTA<150
         IMP=.F.
      ENDIF
      IF CTA=910.OR.CTA=911.OR.CTA=505.OR.CTA=506
         IMP=.F.
      ENDIF
   ENDIF
   IF IMP
      DBSELECTAR(cSELE2)
      DBGOTOP()
      NOM=IF(DBSEEK(CTA),DESCR,'Conta nao Cadastrada')
      POS=64
      IF CC#6
          DO CASE
             CASE CTA > 40 .AND. CTA < 50 ;  POS=86
             CASE CTA > 501               ;  POS=86
             CASE CTA >399 .AND. CTA <502 ;  POS=108
          ENDCASE
      ENDIF
      DBSELECTAR("FO_APU")
      DBGOTOP()
      IF ! DBSEEK(CTA)
         netrecapp()
         FIELD -> CONTA := CTA
      else
         netreclock()   
      ENDIF
      FIELD -> HORAS := HORAS+TOT1
      FIELD -> VALOR := VALOR+TOT
      FIELD -> NOME  := NOM
      FIELD -> COL   := POS
   ENDIF
   DBSELECTAR(cSELE1)
ENDDO
DBCLOSEALL()
RETU
*: FIM: FOID0.PRG