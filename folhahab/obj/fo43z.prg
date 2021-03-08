*:*****************************************************************************
*:
*:      FO43Z.PRG: Listar Evolucao Salarial
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:21
*:
*:*****************************************************************************



DECLARE PO[5]
AFILL(PO,0)
SETCOLOR("+N/GR")
FOR X=1 TO 5
   @ X+11,59 SAY CHR(26)
NEXT X
SETCOLOR("+W/R")
@ 08,03 SAY SPAC(19)+"Digite os percentuais de Referˆncias"+SPAC(21)
@ 12,62 GET PO[1] PICT '###.##'
@ 13,62 GET PO[2] PICT '###.##'
@ 14,62 GET PO[3] PICT '###.##'
@ 15,62 GET PO[4] PICT '###.##'
@ 16,62 GET PO[5] PICT '###.##'
READCUR()

IF ! MDL('Listar Evolu‡„o Sal rio com percentuais',0)
   RETU
ENDIF

POS1=SPAC(40)
MDS('Digite Cabe‡ rio Complementar')
@ 24,35 GET POS1
READCUR()

CONV=IF(MDG('Converter Salarios Horas em Mensal'),.T.,.F.)
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

IF ! netuse("FUNCAO")
   RETU
ENDIF

DECLARE TOT[5],FUN[5],PER[5],SAL[5]
AFILL(TOT,0)
AFILL(FUN,0)
CTLIN=80
FL=0

LISTARUE({|X| FO43ZZ(X)},{|X| FO43ZZR(X)})


FUNC FO43ZZR
@ 1,  0 SAY IMPSTR(cIMPEXP)
@ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
@ 4, 18 SAY IMPCHR(cIMPTIT)+'RESUMO FINAL DA EVOLUCAO DE SALARIOS'
@ 6,  0 SAY POS1
@ 6,100 SAY TIME()
@ 6,110 SAY DATE()
@ 6,120 SAY 'FL. '+STRZERO(FL+1,4)
@ 8,  1 SAY REPL('-',129)
COL=40
CTLIN=9
@ CTLIN,39 SAY '|'
FOR X=1 TO 5
   @ CTLIN,COL SAY IF(NO[X]#0,MMES(NO[X]),"")
   COL+=17
   @ CTLIN,COL SAY '|'
   COL++
NEXT X
CTLIN++
@ CTLIN,39 SAY '|'
COL=44
FOR X= 1 TO 5
   @ CTLIN,COL SAY PO[X] PICT '###.##%'
   COL+=13
   @ CTLIN,COL SAY '|'
   COL+=5
NEXT X
CTLIN++
@ CTLIN,1 SAY REPL('-',129)
CTLIN++
@ CTLIN,0 SAY '|'
@ CTLIN,2 SAY 'Total de Salarios ->'
@ CTLIN,39 SAY '|'
COL=40
FOR X=1 TO 5
   @ CTLIN,COL SAY TOT[X] PICT '##,###,###,###.##'
   COL+=17
   @ CTLIN,COL SAY '|'
   COL++
NEXT X
CTLIN++
@ CTLIN,0 SAY '|'
@ CTLIN,2 SAY 'Funcionarios Ativos ->'
@ CTLIN,39 SAY '|'
COL=44
FOR X=1 TO 5
   @ CTLIN,COL SAY FUN[X] PICT '##,###'
   COL+=13
   @ CTLIN,COL SAY '|'
   COL+=5
NEXT X
CTLIN++
@ CTLIN,0 SAY '|'
@ CTLIN,2 SAY 'Porcentagens -> '
@ CTLIN,39 SAY '|'
@ CTLIN,57 SAY '|'
COL=61
FOR X=2 TO 5
   IF TOT[X] # 0 .AND. TOT[X-1] # 0
      DIF = (((TOT[X]/TOT[X-1])-1)*100)
      @ CTLIN,COL SAY DIF PICT '###.##'
      COL+=13
      @ CTLIN,COL SAY '|'
      COL+=5
   ENDIF
NEXT X
CTLIN++
@ CTLIN,1 SAY REPL('-',129)
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: FO43ZZ()
*!
*!    Chamado por: FO43Z.PRG
*!
*!*****************************************************************************
FUNC FO43ZZ
PARA COMPARE
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      DBSELECTAR(PES)
      IF CTLIN > 55
         FL++
         @ 1,  0 SAY IMPSTR(cIMPEXP)
         @ 2,  0 SAY IMPCHR(cIMPTIT)+MSG2
         @ 2, 38 SAY IMPCHR(cIMPTIT)+NOMSETOR
         @ 4, 15 SAY IMPCHR(cIMPTIT)+ACENTO("EVOLU€ŽO DE SALRIOS BSICOS")
         @ 5,  0 SAY POS1
         @ 5,100 SAY TIME()
         @ 5,110 SAY DATE()
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  1 SAY REPL('-',131)
         @ 7,  0 SAY '|'
         @ 7,  1 SAY 'NRo.'
         @ 7,  5 SAY '|'
         @ 7,  6 SAY 'NOME'
         @ 7, 30 SAY '|'
         @ 7, 31 SAY ACENTO(' FUN€ŽO OCUPADA')
         @ 7, 47 SAY '|'
         @ 7, 48 SAY '  ADMITIDO '
         @ 7, 61 SAY '|'
         COL=66
         FOR X= 1 TO 5
            @ 7,COL SAY PO[X] PICT '###.##%'
            COL+=9
            @ 7,COL SAY '|'
            COL+=5
         NEXT X
         COL=62
         @ 8,  0 SAY '|'
         @ 8,  5 SAY '|'
         @ 8, 30 SAY '|'
         @ 8, 47 SAY '|'
         @ 8, 61 SAY '|'
         FOR X=1 TO 5
            @ 8,COL SAY IF(NO[X]#0,MMES(NO[X]),"")
            COL+=13
            @ 8,COL SAY '|'
            COL++
         NEXT X
         CTLIN=8
      ENDIF
      DBSELECTAR(PES)
      CTLIN++
      @ CTLIN,0 SAY REPL('-',131)
      CTLIN++
      @ CTLIN, 0 SAY '|'
      @ CTLIN, 1 SAY NUMERO PICT '####'
      @ CTLIN, 5 SAY '|'
      @ CTLIN, 6 SAY SUBSTR(NOME,1,23)
      @ CTLIN,30 SAY '|'
      @ CTLIN,31 SAY SUBSTR(OBTER("FUNCAO",,FUNCAO,"FNOME"),1,15)
      @ CTLIN,47 SAY '|'
      AFILL(PER,0)
      AFILL(SAL,0)
      COL=62
      SALA=0
      FOR X=1 TO 5
         IF NO[X]#0
            MESREF=ME[X]
            VAR1=&MESREF
            DO CASE
            CASE TIPO = '1' .OR. TIPO='M'; SALM=VAR1
            CASE TIPO = '5' .OR. TIPO='H'; SALM=VAR1*MESHORA
            ENDCASE
            IF SALM#0
               IF CONV
                  @ CTLIN,COL SAY SALM PICT '######,###.##'
               ELSE
                  @ CTLIN,COL SAY VAR1 PICT '######,###.##'
               ENDIF
               IF SALA#0.AND.X#1
                  PER[X]=((SALM/SALA )-1)*100
               ENDIF
               TOT[X]+=SALM
               FUN[X]++
            ENDIF
            SAL[X]=INT(SALM/1000)
            SALA=SALM
         ENDIF
         COL+=13
         @ CTLIN,COL SAY '|'
         COL++
      NEXT X
      CTLIN++
      @ CTLIN, 0 SAY '|'
      @ CTLIN,30 SAY '|'
      @ CTLIN,47 SAY '|'
      @ CTLIN,61 SAY '|'
      @ CTLIN,47 SAY '|'
      @ CTLIN,48 SAY ADMITIDO
      @ CTLIN,61 SAY '|'
      @ CTLIN,69 SAY SAL[1] PICT '##,###'
      @ CTLIN,75 SAY '|'
      COL=76
      FOR X=2 TO 5
         IF PER[X]#0
            DIF=PER[X]-PO[X]
            IF DIF>=1
               @ CTLIN,COL SAY DIF PICT '###.##'
            ENDIF
         ENDIF
         COL+=7
         IF TIPO <> '1' .OR. TIPO='M'
            @ CTLIN,COL SAY SAL[X] PICT '##,###'
         ENDIF
         COL+=6
         @ CTLIN,COL SAY '|'
         COL++
      NEXT X
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
RETU(.T.)
*: FIM: FO43Z.PRG
