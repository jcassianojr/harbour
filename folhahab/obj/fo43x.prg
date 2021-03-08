*:*****************************************************************************
*:
*:      FO43X.PRG: Listar EvoluáÑo Salarial Anual
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:
*:*****************************************************************************


function fo43x
PARA CX
IF ! MDL('Listar EvoluáÑo Salarial Anual',0)
   RETU
ENDIF

IF IM1 = 'A'.AND.CX=0
   @ 14,10 SAY 'ATENCAO !!!'
   @ 15,10 SAY 'Sua Impressora nÑo permite o preenchimento completo.'
   @ 16,10 SAY 'Sendo Assim solicite a OpáÑo  -   EvoluáÑo Parcial  '
   @ 17,10 SAY 'Caso esteja com formul†rio 132 - Continue normalmente'
   IF ! MDG ('Deseja continuar mesmo assim')
      RETU
   ENDIF
ENDIF

CONV=IF(MDG('Converter Sal†rios Horas em Mensal'),.T.,.F.)
FILTRO:=gFUNC("")

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
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

DECLARE TOT[12]
DECLARE FUN[12]
FL=0

IF CX=0
   LISTARUE({|X| FO43XX(X)})
ELSE
   LISTARUE({|X| FO43YY(X)})
ENDIF


*!*****************************************************************************
*!
*!         FunáÑo: FO43XX()
*!
*!*****************************************************************************
FUNC FO43XX
PARA COMPARE
AFILL(TOT,0)
AFILL(FUN,0)
TOTALIZA=.F.
CTLIN=80
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      IF CTLIN > 55
         FL++
         @ 1,  1 SAY IMPSTR(cIMPEXP)
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3, 10 SAY IMPCHR(cIMPTIT)+ACENTO('EVOLUÄéO DE SALèRIOS ( ANUAL ) '+NOMSETOR)
         @ 4, 30 SAY IMPCHR(cIMPTIT)+ACENTO(MMES)+'/'+STRZERO(ANO,4)
         @ 5,  0 SAY IMPSTR(cIMPCOM)
         @ 5,200 SAY TIME()
         @ 5,210 SAY DXDIA
         @ 5,220 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',230)
         @ 7,  1 SAY ACENTO('N.Reg  Nome Funcion†rio   Data de AdmissÑo')
         COL=55
         FOR X=1 TO 12
            @ 7,COL SAY ACENTO(MMES(X))
            COL+=15
         NEXT X
         @ 8,0 SAY REPL('-',230)
         CTLIN=9
      ENDIF
      DBSELECTAR(PES)
      @ CTLIN, 0 SAY NUMERO PICT '######'
      @ CTLIN, 7 SAY NOME
      @ CTLIN,38 SAY ADMITIDO
      COL=48
      FOR X=1 TO 12
         XSAL='SAL'+SUBSTR(MMES(X),1,3)
         XMOT='MOT'+IF(X>9,STR(X,2),STR(X,1))
         VAR1=&XSAL
         DO CASE
         CASE TIPO = '1' .OR. TIPO='M'
            SALM=VAR1
         CASE TIPO = '5' .OR. TIPO='H'
            SALM=VAR1*MESHORA
         ENDCASE
         IF SALM#0
            @ CTLIN,COL SAY IF(CONV,SALM,VAR1) PICT '########.##'
            @ CTLIN,COL+11 SAY '-'+&XMOT
            TOT[X]+=SALM
            FUN[X]++
         ENDIF
         COL+=15
      NEXT X
      CTLIN++
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
FO43XROD(45,15,230,12)
RETU(.T.)

*!*****************************************************************************
*!
*!         FunáÑo: FO43YY()
*!
*!*****************************************************************************
FUNC FO43YY
PARA COMPARE
CTLIN=80
AFILL(TOT,0)
AFILL(FUN,0)
TOTALIZA=.F.
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      IF CTLIN > 55
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3, 18 SAY IMPCHR(cIMPTIT)+ACENTO('EVOLUÄéO DE SALèRIOS (PARCIAL)'+NOMSETOR)
         @ 5,  0 SAY ACENTO(POS1)
         @ 5,100 SAY TIME()
         @ 5,110 SAY DXDIA
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  1 SAY REPL('-',132)
         @ 7,  0 SAY "DEP  SET SEC N.Reg Nome"
         COL=50
         FOR X=1 TO 5
            @ 7,COL SAY IF(NO[X]#0,ACENTO(MMES(NO[X])),"")
            COL+=16
         NEXT X
         CTLIN=8
      ENDIF
      @ CTLIN, 0 SAY DEPTO
      @ CTLIN, 5 SAY SETOR
      @ CTLIN, 9 SAY SECAO
      @ CTLIN,13 SAY NUMERO
      @ CTLIN,19 SAY NOME
      COL=50
      FOR X=1 TO 5
         IF NO[X]#0
            MESREF=ME[X]
            VAR1=&MESREF
            DO CASE
            CASE TIPO = '1'.OR. TIPO='M'
               SALM=VAR1
            CASE TIPO = '5'.OR. TIPO='H'
               SALM=VAR1*MESHORA
            ENDCASE
            IF SALM#0
               @ CTLIN,COL SAY IF(CONV,SALM,VAR1) PICT '########.##'
               TOT[X]+=SALM
               FUN[X]++
            ENDIF
         ENDIF
         COL+=16
      NEXT X
      CTLIN++
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
FO43XROD(50,16,132,5)
RETU(.T.)

*!*****************************************************************************
*!
*!         FunáÑo: FO43XROD()
*!
*!*****************************************************************************
FUNC FO43XROD
PARA COL1,COL2,REP1,REP2
IF ! TOTALIZA
   RETU(.T.)
ENDIF
@ PROW()+1,0 SAY REPL('-',REP1)
@ PROW()+1,0 SAY ACENTO('Total de Sal†rios')
COL=COL1
FOR X=1 TO REP2
   @ PROW(),COL SAY TOT[X] PICT '###########.##'
   COL+=COL2
NEXT X
@ PROW()+1,0 SAY ACENTO('Funcion†rios')
COL=COL1
FOR X=1 TO REP2
   @ PROW(),COL SAY FUN[X]
   COL+=COL2
NEXT X
@ PROW()+1,0 SAY REPL('-',REP1)
RETU(.T.)

*: FIM: FO43X.PRG
