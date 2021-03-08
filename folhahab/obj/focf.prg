*:*****************************************************************************
*:
*:       FOCF.PRG: Relatorio de Dados da Folha
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 05/13/94     13:10
*:
*:*****************************************************************************


////#INCLUDE "COMANDO.CH"

function focf
PARA CC,CX,CW
IF CC=9.OR.CC=10
   MDT('Use a op‡„o Rela‡„o')
   RETU
ENDIF
nVALPOS:=0
ATUALIZA:=1.000000


IF ! MDL('Relatorio de Dados da Folha',0)
   RETU
ENDIF

POS1:=SPAC(40)
MDS('Digite o cabe‡ rio da lista ')
@ 24,40 GET POS1
READCUR()


REP:=IF(CX=0,5,11)
SAL:=IF(CX=0,16,7)
TOT:=ARRAY(REP)
DES:=ARRAY(REP)


CON:=PEGRELCTA("")


IF ! ARQUSAR(CC,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1:=ALIAS()

DO CASE
   CASE CC=1 ; MASS='FOLHA DE PAGAMENTO'
   CASE CC=2 ; MASS='FOLHA DE FERIAS'
   CASE CC=3 ; MASS='FOLHA DE RESCISAO'
   CASE CC=4 ; MASS='FOLHA 13o.Ssalario'
   CASE CC=5 ; MASS='Folha Complementar'
   CASE CC=6 ; MASS='Folha Vale Transporte'
   CASE CC=7 ; MASS='Folha Semanal'
   CASE CC=8 ; MASS='Folha RPA'
ENDCASE
IF CC=2.OR.CC=3.OR.CC=5
   @ 24,00 SAY "Posicao (0) Normal  (1) 1§ Mes  (2) 2§ Mes"
   @ 24,60 GET nVALPOS
   READCUR()
ENDIF


IF ! ARQPES(CC,1,0)
   DBCLOSEALL()
   RETU
ENDIF
cSELE2:=ALIAS()
FILTRO='((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
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


IF ! ARQCTA(CC,1,1)
   DBCLOSEALL()
   RETU
ENDIF
cSELE3:=ALIAS()

IF ! NETUSE("FUNCAO") //AREDE("FUNCAO","FUNCAO",1)
   RETU
ENDIF


DBSELECTAR(cSELE3)
FOR X=1 TO REP
   DBGOTOP()
   IF DBSEEK(CON[X])
      DES[X]=DESCR
   ELSE
      DES[X]=""
   ENDIF
NEXT  X


IF CW>1
   DBSELECTAR(cSELE3)
   IF ! netuse("DEPTO") //AREDE("DEPTO","DEPTO",1)
      RETU
   ENDIF
   DO CASE
   CASE CW=2
      FILTRA='SETOR=0.AND.SECAO=0'
      COMPAR='DEP=DEPTO'
   CASE CW=3
      FILTRA='SETOR#0.AND.SECAO=0'
      COMPAR='DEP=DEPTO.AND.SET=SETOR'
   CASE CW=4
      FILTRA='SETOR#0.AND.SECAO#0'
      COMPAR='DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
   ENDCASE
   SET FILTER TO &FILTRA
ENDIF

IMPRESSORA()
FL = 0
IF CW=1
   NOMSETOR=""
   FOCFX(".T.")
ELSE
   DBSELECTAR(cSELE3)
   DBGOTOP()
   WHILE ! EOF()
      NOMSETOR=NOMEC
      DEP=DEPTO
      SET=SETOR
      SEC=SECAO
      FOCFX(COMPAR)
      DBSELECTAR(cSELE3)
      DBSKIP()
   ENDDO
ENDIF
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: FOCFX()
*!
*!    Chamado por: FOCF.PRG
*!
*!*****************************************************************************
FUNC FOCFX
PARA COMPARE
CTLIN=80
TOTALIZA=.F.
AFILL(TOT,0)
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      IF CTLIN>55
         IF CTLIN#80
            @ PROW()+1,0 SAY REPL('-',132)
         ENDIF
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3, 00 SAY IMPCHR(cIMPTIT)+ACENTO('LAN€AMENTO DE VALORES ')+MMES+'\'+STRZERO(ANO,4)+' '+NOMSETOR
         @ 5,  0 SAY POS1
         @ 5, 50 SAY MASS
         @ 5,100 SAY TIME()
         @ 5,110 SAY DXDIA
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',132)
         @ 7,  0 SAY "Dep  Set Sec Num   Nome"
         COL=50
         FOR X=1 TO REP
            @ 7,COL+IF(CX=0,12,03) SAY CON[X] PICT '###'
            COL+=SAL
         NEXT X
         @ 8,0 SAY REPL('-',132)
         CTLIN = 9
      ENDIF
      CTR=NUMERO
      aVAL:=ARRAY(11)
      aHOR:=ARRAY(11)
      AFILL(aVAL,0)
      AFILL(aHOR,0)
      lTEM:=.F.
      DBSELECTAR(cSELE1)
      COL=50
      FOR X=1 TO REP
         DBSELECTAR(cSELE1)
         DBGOTOP()
         IF DBSEEK(CTR*10000+CON[X])
            aVAL[X]:=FOCD01()
            aHOR[X]:=HORAS
            lTEM:=.T.
         ENDIF
      NEXT X
      IF lTEM
         DBSELECTAR(cSELE2)
         @ CTLIN, 0 SAY DEPTO
         @ CTLIN, 5 SAY SETOR
         @ CTLIN,09 SAY SECAO
         @ CTLIN,13 SAY NUMERO
         @ CTLIN,19 SAY NOME
         FOR X=1 TO REP
             VAL:=aVAL[X]
             HOR:=aHOR[X]
             IF CX=0
                IF VAL#0
                   @ CTLIN,COL SAY VAL PICT '@E 9999,999,999.99'
                   TOT[X]+=VAL
                ENDIF
             ELSE
                IF HOR#0
                   @ CTLIN,COL SAY HOR PICT '###.##'
                   TOT[X]+=HOR
                ENDIF
             ENDIF
             COL+=SAL
         NEXT X
         CTLIN++
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
nTOTAL:=0
IF TOTALIZA
   @ PROW()+1,0 SAY REPL('-',132)
   IF PROW()>50
      IMPFOL()
      @ PROW()+1,0 SAY REPL('-',132)
   ENDIF
   @ PROW()+1,0 SAY 'TOTAL GERAL DAS CONTAS '
   FOR X=1 TO REP
      IF ! EMPTY(TOT[X])
         @ PROW()+1, 0 SAY CON[X]
         @ PROW()  , 6 SAY DES[X]
         @ PROW()  ,50 SAY TOT[X] PICT '@E 9999,999,999.99'
         nTOTAL+=TOT[X]
      ENDIF
   NEXT X
   @ PROW()+1,0 SAY REPL('-',132)
   IF CX=0
      @ PROW()+1,  0 SAY "Total"
      @ PROW()   ,50 SAY nTOTAL PICT '@E 9999,999,999.99'
   ENDIF
   @ PROW()+1,0 SAY REPL('-',132)
ENDIF
RETU .T.
*: FIM: FOCF.PRG
