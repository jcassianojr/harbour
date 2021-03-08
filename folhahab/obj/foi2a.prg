*:*****************************************************************************
*:
*:      FOI2A.PRG: Listar Resumo de Apura‡„o por Centro de Custo
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:12
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function foi2a
PARA CC
IF ! MDL('Listar Resumo de Apura‡„o por Centro de Custo',0)
   RETU
ENDIF

DECLARE BUSCA[3]
POS1=SPAC(40)
MDS('Digite Cabecario Complementar')
@ 24,35 GET POS1
READCUR()

DECLARE TIP[7],TOTT[7]
FOR X=1 TO 7
   TIP[X]=CHECKTAB("TSA2"+STRZERO(X,1)+"    ",,,"Tipo naoCadastrado",2)
NEXT X

IF ! NETUSE("DEPTO") 
   RETU
ENDIF
IF ! NETUSE("APUDEPTO")
   RETU
ENDIF

DO CASE
CASE CC=1
   FILTRO='SETOR=0.AND.SECAO=0'
   TIPORES='Por Departamento '
   COMPAR='DEP=DEPTO'
CASE CC=2
   FILTRO='SETOR<>0.AND.SECAO=0'
   TIPORES='Por Setor '
   COMPAR='DEP=DEPTO.AND.SET=SETOR'
CASE CC=3
   FILTRO='SETOR<>0.AND.SECAO<>0'
   TIPORES='Por Secao '
   COMPAR='DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
ENDCASE
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO

IF ! NETUSE("CONTAS") //AREDE("CONTAS","CONTAS",0)
   RETU
ENDIF

IF ! NETUSE(PES) //AREDE(PES,PES,0)
   RETU
ENDIF
FILTRA='((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
SET FILTER TO &FILTRA

CTLIN=80
FL=0
IMPRESSORA()
DBSELECTAR("APUDEPTO")
DBGOTOP()
WHILE ! EOF()
   BRU:=LIQ:=DES:=CRE:=QTFUN:=0
   AFILL(TOTT,0)
   DEP=DEPTO
   SET=SETOR
   SEC=SECAO
   WHILE ! EOF().AND.&COMPAR
      IF CTLIN > 55
         IF CTLIN#80
            @ PROW()+1,0 SAY REPL('-',132)
         ENDIF
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3, 00 SAY IMPCHR(cIMPTIT)+'RESUMO PAGAMENTO '+TIPORES+MMES+'/'+STRZERO(ANO,4)
         @ 5,  0 SAY POS1
         @ 5,100 SAY TIME()
         @ 5,110 SAY DXDIA
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',132)
         BUSCA[1]=DEPTO*1000000
         BUSCA[2]=DEPTO*1000000+SETOR*1000
         BUSCA[3]=DEPTO*1000000+SETOR*1000+SECAO
         CTLIN=7
         FOR Q=1 TO CC
            DBSELECTAR("DEPTO")
            DBGOTOP()
            SEEK BUSCA[Q]
            NOMCC=IF(FOUND(),NOME,'N„o Cadastrado')
            @ CTLIN,1 SAY IMPCHR(cIMPTIT)
            DO CASE
            CASE Q=1
               @ CTLIN,2 SAY 'DEPTO: '+STR(DEP,5)+'-'+NOMCC
            CASE Q=2
               @ CTLIN,2 SAY 'SETOR: '+STR(SET,5)+'-'+NOMCC
            CASE Q=3
               @ CTLIN,2 SAY 'SECAO: '+STR(SEC,5)+'-'+NOMCC
            ENDCASE
            CTLIN++
         NEXT Q
         @ CTLIN,  0 SAY REPL('-',132)
         CTLIN++
         @ CTLIN,1 SAY 'CONTA'
         @ CTLIN,7 SAY 'DESCRIMINACAO DA CONTA'
         @ CTLIN,53 SAY 'HORAS'
         @ CTLIN,65 SAY '  VENCIMENTOS '
         @ CTLIN,80 SAY '   DESCONTOS  '
         @ CTLIN,94 SAY 'VALORES BASICOS DE CALCULO'
         @ CTLIN,94 SAY 'VALORES BASICOS DE CALCULO'
         CTLIN++
         @ CTLIN,  0 SAY REPL('-',132)
         CTLIN++
      ENDIF
      DBSELECTAR("APUDEPTO")
      CTA=CONTA
      @ CTLIN,5 SAY CTA PICT "###"
      DBSELECTAR("CONTAS")
      DBGOTOP()
      @ CTLIN,10 SAY IF(DBSEEK(CTA),DESCR,'Conta nao Cadastrada')
      DBSELECTAR("APUDEPTO")
      COL=64
      IF CTA>=40.AND.CTA<50
         COL=86
      ENDIF
      IF CTA>=400.AND.CTA<502
         COL=108
      ENDIF
      IF CTA>=502
         COL=86
      ENDIF
      IF HORAS#0
         @ CTLIN,46 SAY HORAS PICT '###,###.##'
      ENDIF
      @ CTLIN,COL SAY VALOR PICT '###,###,###,###.##'
      IF CTA=399
         BRU=VALOR
      ENDIF
      IF CTA=999
         DES=VALOR
      ENDIF
      CTLIN++
      DBSELECTAR("APUDEPTO")
      DBSKIP()
   ENDDO
   LIQ=BRU-DES
   @ CTLIN,10 SAY 'Total Liquido'
   @ CTLIN,64 SAY LIQ PICT '###,###,###.##'
   DBSELECTAR(PES)
   DBGOTOP()
   WHILE ! EOF()
      IF &COMPAR
         DO CASE
         CASE TIPO = '1' .OR. TIPO='M' ; TOTT[1]++
         CASE TIPO = '2' .OR. TIPO='Q' ; TOTT[2]++
         CASE TIPO = '3' .OR. TIPO='S' ; TOTT[3]++
         CASE TIPO = '4' .OR. TIPO='D' ; TOTT[4]++
         CASE TIPO = '5' .OR. TIPO='H' ; TOTT[5]++
         CASE TIPO = '6' .OR. TIPO='T' ; TOTT[6]++
         CASE TIPO = '7' .OR. TIPO='O' ; TOTT[7]++
         ENDCASE
         QTFUN++
      ENDIF
      DBSKIP()
   ENDDO
   CTLIN++
   @ CTLIN,10 SAY 'QUANTIDADE DE FUNCIONARIOS ATIVOS ==> '
   @ CTLIN,80 SAY QTFUN PICT '########'
   CTLIN++
   FOR X=1 TO 7
      IF TOTT[X]#0
         @ CTLIN,10 SAY TIP[X]
         @ CTLIN,60 SAY TOTT[X] PICT '########'
         CTLIN++
      ENDIF
   NEXT X
   CTLIN=61
   DBSELECTAR("APUDEPTO")
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU .F.
*: FIM: FOI2A.PRG