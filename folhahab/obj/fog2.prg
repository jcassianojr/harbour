*:*****************************************************************************
*:
*:       FOG2.PRG: Listar Planilha de apontamento de dados
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/07/98
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function fog2
PARA CC
IF ! MDL('Listar Planilha de apontamento de dados',0)
   RETU
ENDIF
nARQ:=1
IF MDG("Folha RPA")
   nARQ=8
ENDIF

REP1=IF(CC=0,3,2)
REP2=IF(CC=0,9,18)
POS1=SPAC(40)
MDS('Digite Cabe‡ario Complementar')
@ 24,35 GET POS1
READCUR()

DECLARE CON[18]
PLAN=SPAC(6)
MDS('Digite Planilha de entrada')
@ 24,35  GET PLAN
READCUR()

IF ! NETUSE("FO_PLENT") 
   DBCLOSEALL()
   RETU
ENDIF
DBGOTOP()
DBSEEK(PLAN)
IF FOUND()
   FOR X= 1 TO 18
      MACRO='C'+STRZERO(X,2)
      CON[X]=&MACRO
   NEXT X
ELSE
   AFILL(CON,0)
ENDIF
DBCLOSEALL()

IF CC=1
   DECLARE DES[18]
   IF ! ARQCTA(nARQ)
      RETU
   ENDIF
   FOR X= 1 TO 18
      BUSCA=CON[X]
      DBGOTOP()
      IF DBSEEK(BUSCA)
         DES[X]=DESCR
      ELSE
         DES[X]=""
      ENDIF
   NEXT X
   DBCLOSEALL()
ENDIF

IF ! ARQPES(nARQ,1,0)
   RETU .F.
ENDIF
cSELE1:=ALIAS()
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

IF ! NETUSE("FUNCAO") 
   DBCLOSEALL()
   RETU .F.
ENDIF

FL=0
IMPRESSORA()
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE ! EOF()
   FL++
   @ 1, 1 SAY impstr(Cimpexp)
   @ 2, 0 SAY IMPCHR(cIMPTIT)+MSG2
   @ 3, 0 SAY ' PLANILHA DE ENTRADA DE DADOS: '+MMES+'/'+STRZERO(ANO,4)
   @ 5, 0 SAY POS1
   @ 5,50 SAY TIME()
   @ 5,60 SAY DXDIA
   @ 5,70 SAY 'FL. '+STRZERO(FL,4)
   FOR X=1 TO REP1
      @ PROW()+1, 0 SAY REPL('=',80)
      @ PROW()+1, 0 SAY "DEP  SET SEC CHA Numero Nome"+SPAC(27)+"Admissao Funcao"
      @ PROW()+1, 0 SAY DEPTO
      @ PROW()  , 5 SAY SETOR
      @ PROW()  , 9 SAY SECAO
      @ PROW()  ,13 SAY CHAPA
      @ PROW()  ,17 SAY NUMERO
      @ PROW()  ,24 SAY NOME
      @ PROW()  ,55 SAY ADMITIDO
      @ PROW(), 64 SAY OBTER("FUNCAO",,FUNCAO,"FNOME")
      IF nARQ=1
          DBSELECTAR(cSELE1)
          @ PROW()+1, 0 SAY "Tipo   - Sal.Mes Anterior:"+SPAC(20)+"Sal.Mes Atual:"
          @ PROW()  , 5 SAY TIPO
          IF MES>1
             XSAL='SAL'+SUBSTR(MMES(MES-1),1,3)
             SALANT=&XSAL
             @ PROW(), 27 SAY SALANT
          ENDIF
          STORE 0 TO VAR1,SALH,SALM
          SALHM()
          @ PROW()  ,61 SAY VAR1
      ENDIF
      @ PROW()+1,0 SAY REPL('=',80)
      IF CC=0
         @ PROW()+1,0 SAY "| Conta | H o r a s | Valor"+SPAC(13)+"| Conta | H o r a s | Valor"+SPAC(12)+"|"
      ELSE
         @ PROW()+1,0 SAY "| Conta | Descricao"+SPAC(14)+"| H o r a s | Valor"+SPAC(12)+"| Obs:"+SPAC(9)+"|"
      ENDIF
      @ PROW()+1, 0 SAY REPL('-',80)
      FOR W=1 TO REP2
         IF CC=0
            @ PROW()+1, 0 SAY "|       |___________|___________________|       |___________|__________________|"
            IF CON[W*2-1]#0
               @ PROW()  , 3 SAY CON[W*2-1]
            ENDIF
            IF CON[W*2]#0
               @ PROW()  ,43 SAY CON[W*2]
            ENDIF
         ELSE
            @ PROW()+1, 0 SAY "|       | "+SPAC(22)+" |___________|__________________|______________|"
            IF CON[W]#0
               @ PROW()  , 3 SAY CON[W]
               @ PROW()  ,10 SAY impstr(Cimpcom)+(DES[W])+impstr(Cimpexp)
            ENDIF
         ENDIF
      NEXT W
      DBSKIP()
      IF EOF()
         EXIT
      ENDIF
   NEXT X
   @ PROW()+1,0 SAY REPL('-',80)
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
FERASE(mTEMP)
RETU

*: FIM: FOG2.PRG
