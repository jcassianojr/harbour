*:*****************************************************************************
*:
*:      FOCA2.PRG: Apura‡„o geral da folha
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:*****************************************************************************
////#INCLUDE "COMANDO.CH"

function foca2
PARA CC
IF ! MDL('APURA€ŽO GERAL DA FOLHA',0)
   RETU
ENDIF
IF CC=9.OR.CC=10
   ALERTX("N„o disponivel")
   RETU
ENDIF

ATUALIZA:=1.000000
MDS('Qual o Fator de Atualiza‡„o')
@ 24,40 GET ATUALIZA PICT "99999999999.999999"
READCUR()

VENC:=DESC:=FL:=QTFUN:=0
CTLIN=80
FILTRO:=""

IF ! ARQPES(CC,1,1)
   DBCLOSEALL()
   RETU
ENDIF
DBGOTOP()
WHILE ! EOF()
   IF ((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))
      IF YEAR(ADMITIDO)<ANO.OR.(YEAR(ADMITIDO)=ANO.AND.MONTH(ADMITIDO)<=MES)
         QTFUN++
      ENDIF
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()

mTEMP=tmpfile(cRDDEXT)

nVALPOS:=0
IF CC=2.OR.CC=3.OR.CC=5
   MDS("Posicao (0) Normal  (1) 1§ Mes  (2) 2§ Mes")
   @ 24,60 GET nVALPOS
   READCUR()
ENDIF


DBSELECTAR(cSELE1)
IF ! ARQUSAR(CC,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","conta")
ordSetFocus("temp")
FILTRO:=FILTRO("")
SET FILTER TO &FILTRO


cSELE1:=ALIAS()

IF ! ARQCTA(CC,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2:=ALIAS()


CRE:=DEB:=0
IMPRESSORA()
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE ! EOF()
   IF CTLIN > 60
      FL++
      @ 1,  1 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
      @ 2, 25 SAY IMPCHR(cIMPTIT)+MSG2
      @ 3,100 SAY TIME()
      @ 3,110 SAY DXDIA
      @ 3,120 SAY 'FL. '+STRZERO(FL,4)
      @ 4,  0 SAY REPL('-',132)
      @ 5,  0 SAY IMPCHR(cIMPTIT)+ACENTO('Apura‡„o Geral da Folha de ')+IF(NRSEN='DiReT','PRO LABORE ','')+Mmes+'/'+STRZERO(YEAR(DXDIA),4)
      @ 6,  0 SAY REPL ('-',132)
      @ 7,  1 SAY 'CONTA'
      @ 7,  7 SAY ACENTO('Descrimina‡„o da Conta')
      @ 7, 53 SAY 'HORAS'
      @ 7, 64 SAY 'VENCIMENTOS '
      @ 7, 86 SAY 'DESCONTOS  '
      @ 7,108 SAY ACENTO('VALORES BSICOS')
      @ 8,  0 SAY REPL('-',132)
      CTLIN = 9
   ENDIF
   CTA=CONTA
   TOT:=TOT1:=0.00
   WHILE CTA=CONTA.AND.!EOF()
      DO CASE
         CASE nVALPOS=1 ; TOT +=VALORMES1
         CASE nVALPOS=2 ; TOT +=VALORMES2
         OTHERWISE      ; TOT +=VALOR
      ENDCASE
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
   IF IMP.AND.TOT>0
      @ CTLIN,2 SAY CTA PICT "###"
      DBSELECTAR(cSELE2)
      DBGOTOP()
      DBSEEK(CTA)
      @ CTLIN,6 SAY IF(FOUND(),DESCR,ACENTO("Conta n„o Cadastrada"))
      DBSELECTAR(cSELE1)
      IF TOT1#0
         @ CTLIN,46 SAY TOT1 PICT '###,###,###.##'
      ENDIF
      COL=64
      IF CC#6 //VT
         DO CASE
            CASE CTA > 40 .AND. CTA < 50 ;  COL=86
            CASE CTA > 501               ;  COL=86
            CASE CTA >399 .AND. CTA <502 ;  COL=108
            OTHERWISE                    ;  COL=64
         ENDCASE
      ENDIF
      IF CC=6
         CRE+=IF(ATUALIZA#1,ROUND(TOT*ATUALIZA,2),TOT)
      ELSE
         DO CASE
            CASE CTA > 40 .AND. CTA < 50 ;  DEB+=IF(ATUALIZA#1,ROUND(TOT*ATUALIZA,2),TOT)
            CASE CTA > 501.AND. CTA<999  ;  DEB+=IF(ATUALIZA#1,ROUND(TOT*ATUALIZA,2),TOT)
            CASE CTA < 40                ;  CRE+=IF(ATUALIZA#1,ROUND(TOT*ATUALIZA,2),TOT)
            CASE CTA >50.AND.CTA<399     ;  CRE+=IF(ATUALIZA#1,ROUND(TOT*ATUALIZA,2),TOT)
         ENDCASE
      ENDIF
      TOT=IF(ATUALIZA#1,ROUND(TOT*ATUALIZA,2),TOT)
      @ CTLIN,COL SAY TOT PICT '###,###,###,###.##'
      CTLIN++
      IF CC#6
         DO CASE
            CASE CTA = 399 ;  VENC=TOT
            CASE CTA = 999 ;  DESC=TOT
         ENDCASE
      ELSE
         VENC+=TOT
      ENDIF
   ENDIF
ENDDO
@ PROW()+1, 0 SAY REPL('-',132)
@ PROW()+1, 6 SAY ACENTO('...........................L¡quido ..===> ')
@ PROW()  ,64 SAY VENC-DESC PICT '###,###,###,###.##'
IF ROUND(CRE,2)#ROUND(VENC,2)
   @ PROW()+1, 6  SAY ACENTO("Erro na Totaliza‡„o Cr‚dito")
   @ PROW()  ,50 SAY VENC     PICT '###,###,###.##'
   @ PROW()  ,64 SAY CRE      PICT '###,###,###.##'
   @ PROW()  ,78 SAY VENC-CRE PICT '###,###,###.##'
ENDIF
IF ROUND(DEB,2)#ROUND(DESC,2)
   @ PROW()+1, 6 SAY ACENTO("Erro na Totaliza‡„o D‚bito")
   @ PROW()  ,50 SAY DESC     PICT '###,###,###.##'
   @ PROW()  ,64 SAY DEB      PICT '###,###,###.##'
   @ PROW()  ,78 SAY DESC-DEB PICT '###,###,###.##'
ENDIF
@ PROW()+1, 6 SAY ACENTO('.Quantidade de Funcion rios do mˆs ..===> ')
@ PROW()  ,64 SAY QTFUN PICT '###,###'
@ PROW()+1, 0 SAY REPL('-',132)
IMPFOL()
VIDEO()
DBCLOSEALL()
IMPEND()
RETU

*: FIM: FOCA2.PRG
