*:*****************************************************************************
*:
*:       FO7E.PRG: Cadastro Simples de Funcion rios
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     15:19
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function fo7e
PARA CC
IF ! MDL('Cadastro Simples Funcionarios',0)
   RETU
ENDIF

POS1=SPAC(40)
MDS('Digite Cabe‡ario Complementar')
@ 24,35 GET POS1
IF ! READCUR()
  RETU .F.
ENDIF

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO=''
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

IF ! NETUSE("DEPTO") 
   DBCLOSEALL()
   RETU .F.
ENDIF

DO CASE
CASE CC=1
   FILTRA='SETOR=0.AND.SECAO=0'
   COMPAR='DEP=DEPTO'
CASE CC=2
   FILTRA='SETOR#0.AND.SECAO=0'
   COMPAR='DEP=DEPTO.AND.SET=SETOR'
CASE CC=3
   FILTRA='SETOR#0.AND.SECAO#0'
   COMPAR='DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
ENDCASE
SET FILTER TO &FILTRA



CTLIN=80
DBSELECTAR("DEPTO")
DBGOTOP()
WHILE ! EOF()
   VIDEO()
   DEP=DEPTO
   SET=SETOR
   SEC=SECAO
   NOM=NOME
   @ 12, 0 SAY DEPTO
   @ 12,10 SAY SETOR
   @ 12,20 SAY SECAO
   @ 12,30 SAY NOME
   STORE 0 TO PULAR,QTFUN,FL,SALTOT
   IMPRESSORA()
   DBSELECTAR(PES)
   DBGOTOP()
   WHILE ! EOF()
      VIDEO()
      PETELA(8)
      IMPRESSORA()
      IF &COMPAR
         IF CTLIN > 50
            @ 1,  0 SAY IF(IM1 = 'A',IMPstr(Cimpcom),impstr(Cimpexp))
            @ 2, 10 SAY IMPCHR(cIMPTIT)+MSG2
            @ 3, 10 SAY IMPCHR(cIMPTIT)+'CADASTRO SIMPLES DE FUNCIONARIOS'
            @ 4,  0 SAY POS1
            @ 4,100 SAY TIME()
            @ 4,110 SAY DATE()
            @ 4,120 SAY 'FL. '+STRZERO(FL,4)
            @ 5,  0 SAY REPL('-',132)
            CTLIN=6
            PULAR=0
         ENDIF
         IF PULAR=0
            CTLIN++
            @ CTLIN,0 SAY REPL('=',132)
            CTLIN++
            @ CTLIN,2 SAY NOM
            CTLIN++
            @ CTLIN,0 SAY REPL('-',132)
            CTLIN++
            @ CTLIN,  1 SAY 'DEPTO'
            @ CTLIN,  7 SAY 'SETOR'
            @ CTLIN, 13 SAY 'SECAO'
            @ CTLIN, 19 SAY 'CHAPA'
            @ CTLIN, 25 SAY 'REGISTRO'
            @ CTLIN, 34 SAY 'NOME'
            @ CTLIN, 64 SAY 'ADMITIDO'
            @ CTLIN, 73 SAY 'TIPO'
            @ CTLIN, 80 SAY 'FUNCAO'
            @ CTLIN,107 SAY 'SALARIO'
            @ CTLIN,127 SAY 'AO MES '
            CTLIN++
            CCOL=14
            PULAR=1
            @ CTLIN,0 SAY REPL('-',132)
            CTLIN++
         ENDIF
         @ CTLIN, 2 SAY DEPTO
         @ CTLIN, 8 SAY SETOR
         @ CTLIN,14 SAY SECAO
         @ CTLIN,20 SAY CHAPA
         @ CTLIN,26 SAY NUMERO
         @ CTLIN,33 SAY NOME
         @ CTLIN,64 SAY ADMITIDO
         @ CTLIN,74 SAY TIPO
         @ CTLIN,76 SAY FUNCAO
         @ CTLIN,80 SAY '-'+OBTER("FUNCAO",,FUNCAO,"FNOME")
         DBSELECTAR(PES)
         STORE 0 TO SALH,SALM,VAR1
         SALHM()
         @ CTLIN,101 SAY VAR1 PICT '###,###,###.##'
         @ CTLIN,119 SAY SALM PICTURE '###,###,###.##'
         SALTOT=SALTOT+SALM
         QTFUN++
         CTLIN++
      ENDIF
      DBSKIP()
   ENDDO
   IF QTFUN#0
      CTLIN++
      @ CTLIN,20 SAY 'Quantidade de Funcionarios --> '
      @ CTLIN,53 SAY QTFUN PICTURE '###'
      @ CTLIN,99 SAY SALTOT PICT '#,###,###,###.##'
   ENDIF
   DBSELECTAR("DEPTO")
   DBSKIP()
ENDDO
IF CTLIN#80
   IMPFOL()
ENDIF
DBCLOSEALL()
VIDEO()
IMPEND()
DBCLOSEALL()
RETU

*: FIM: FO7E.PRG
