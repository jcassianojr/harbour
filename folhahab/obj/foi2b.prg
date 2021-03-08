*:*****************************************************************************
*:
*:      FOI2B.PRG: Listar Resumo de Apura‡„o por Centro de Custo Contabil
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:13
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function foi2b
PARA CC
IF ! MDL('Listar Resumo de Apura‡„o por Centro de Custo Contabil',0)
   RETU
ENDIF



DECLARE BUSCA[3]
POS1=SPAC(40)
MDS('Digite Cabe‡ario Complementar')
@ 24,35 GET POS1
READCUR()


nrMES:=MESTRAB
nrANO:=ANO
MDS("Confirme a Competencia")
@ 24,40 get nrMES PICT "99"
@ 24,60 GET nrANO PICT "9999"
READCUR()


IF ! NETUSE("DEPTO") //AREDE("DEPTO","DEPTO",1)
   RETU
ENDIF

IF ! NETUSE("APUDEPTO") //AREDE("APUDEPTO","APUDEPTO",1)
   DBCLOSEALL()
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
   TIPORES=ACENTO('Por Se‡„o ')
   COMPAR='DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
ENDCASE
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO

IF ! NETUSE("CONTAS") //AREDE("CONTAS","CONTAS",1)
   DBCLOSEALL()
   RETU
ENDIF
lCCOR:=NETUSE("CCCOR") //AREDE("CCCOR","CCCOR",1)
IF lCCOR
   lARQTXT:=MDG("Criar Arquivo")
   IF lARQTXT
      cARQTXT:="AD"+STRZERO(nrANO,4)+STRZERO(nrMES,2)+".TXT"
      nHANDLE:=FCREATE(cARQTXT)
      IF FERROR()#0
         ALERTX("Erro na Cria‡„o do Arquivo")
         RETU
      ENDIF
   ENDIF
ENDIF


IF lCCOR
   IF ! NETUSE("GINSSD") //AREDE("GINSSD","GINSSD",1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   
   IF ! NETUSE("CCESP") //AREDE("CCESP","CCESP",1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   
   IF ! NETUSE("PROV13") //BREDE("PROV13",1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   MDS("Aguarde Preparando Provis„o 13S")
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","STRZERO(ANO,4)+STRZERO(MES,2)+STRZERO(DEPTO,4)+STRZERO(SETOR,3)+STRZERO(SECAO,3)")
   ordSetFocus("temp")
   
   
   IF ! NETUSE("PROVFE") 
      DBCLOSEALL()
      RETU .F.
   ENDIF
   MDS("Aguarde Preparando Provis„o FER")
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","STRZERO(ANO,4)+STRZERO(MES,2)+STRZERO(DEPTO,4)+STRZERO(SETOR,3)+STRZERO(SECAO,3)")
   ordSetFocus("temp")
  
   
   
ENDIF


DESC:=HIST:=CODC:=CODD:=""


CTLIN=80
FL=0
IMPRESSORA()
DBSELECTAR("APUDEPTO")
DBGOTOP()
WHILE ! EOF()
   DEP=DEPTO
   SET=SETOR
   SEC=SECAO
   VEN=0
   DEB=0
   aCON:={}
   aVAL:={}
   WHILE ! EOF().AND.&COMPAR
      IF CTLIN > 55
         IF CTLIN#80
            @ PROW()+1,0 SAY REPL('-',132)
         ENDIF
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3, 00 SAY IMPCHR(cIMPTIT)+ACENTO('APURA€ŽO CONTABIL ')+TIPORES+MMES+'/'+STRZERO(ANO,4)
         @ 5,  0 SAY POS1
         @ 5,100 SAY TIME()
         @ 5,110 SAY DXDIA
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',132)
         BUSCA[1]=DEPTO*1000000
         BUSCA[2]=DEPTO*1000000+SETOR*1000
         BUSCA[3]=DEPTO*1000000+SETOR*1000+SECAO
         CTLIN=7
         FOI2B01()
         @ CTLIN,  1 SAY 'CONTA'
         @ CTLIN,  7 SAY ACENTO('Descrimina‡„o da conta')
         @ CTLIN, 45 SAY 'VALOR'
         @ CTLIN, 68 SAY ACENTO('N.Lan‡to')
         @ CTLIN, 78 SAY ACENTO('Conta Cont bil')
         @ CTLIN,125 SAY 'Hist.'
         CTLIN++
         @ CTLIN,  0 SAY REPL('-',132)
         CTLIN++
      ENDIF
      DBSELECTAR("APUDEPTO")
      CTA=CONTA
      TOT=VALOR
      IMP = .T.
      DBSELECTAR("CONTAS") //Verifica se Imprime
      DBGOTOP()
      IF DBSEEK(CTA)
         IF LISCON="N"
            IMP:=.F.
         ENDIF
      ENDIF
      IF IMP
         FOID04()
         @ CTLIN,  2 SAY CTA PICT "###"
         @ CTLIN,  6 SAY DESC
         @ CTLIN, 45 SAY TOT PICT '###,###,###,###.##'
         @ CTLIN, 69 SAY '________'
         @ CTLIN, 79 SAY CODD
         @ CTLIN,102 SAY CODC
         @ CTLIN,125 SAY HIST
         CTLIN++
         FOID03()
      ENDIF
      DBSELECTAR("APUDEPTO")
      DBSKIP()
   ENDDO
   lOLDC:=lCCOR //Salva Status Anterior
   lCCOR:=.F.   //Contas Especias j  e por Empresa
   DBSELECTAR("CCESP")
   DBGOTOP()
   WHILE ! EOF()
      CTA:=CODIGO
      cCAMPO:=CAMPO
      DESC=DESCR
      HIST=STRZERO(CO_HIS,3)
      CODC='C-'+CO_COD +'/'+STR(CO_CODR ,6)
      CODD='D-'+CO_CODD+'/'+STR(CO_CODRD,6)
      IF TIPO="I".AND.NREMP=NUMEMP
         DBSELECTAR("GINSSD")
         DBGOTOP()
         IF DBSEEK(STRZERO(DEP,4)+STRZERO(SET,3)+STRZERO(SEC,3)+STRZERO(nrANO,4)+STRZERO(nrMES,2))
            TOT:=&cCAMPO.
            DBSELECTAR("CCESP")
            FOID05()
         ENDIF
      ENDIF
      DBSELECTAR("CCESP")
      IF TIPO="1".AND.NREMP=NUMEMP
         TOT:=FOI2B02("PROV13",cCAMPO)
         DBSELECTAR("CCESP")
         FOID05()
      ENDIF
      DBSELECTAR("CCESP")
      IF TIPO="F".AND.NREMP=NUMEMP
         TOT:=FOI2B02("PROVFE",cCAMPO)
         DBSELECTAR("CCESP")
         FOID05()
      ENDIF
      DBSELECTAR("CCESP")
      DBSKIP()
   ENDDO
   FOID02(30,30)
   FOID01(.T.)
   lCCOR:=lOLDC //Falta Configura‡„o Anterior
   CTLIN=61
   DBSELECTAR("APUDEPTO")
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
IF lARQTXT
   FWRITE(nHANDLE,CHR(26))
   FCLOSE(nHANDLE)
   IF MDG("Visualizar Arquivo Remessa")
      VERTXT(cARQTXT)
   ENDIF
   IF MDG("Imprimir Arquivo Remessa")
      IMPARQ(cARQTXT)
   ENDIF
ENDIF
RETU

FUNC FOI2B01
FOR Q=1 TO CC
   DBSELECTAR("DEPTO")
   DBGOTOP()
   NOMCC=IF(DBSEEK(BUSCA[Q]),NOME,ACENTO('N„o Cadastrado'))
   @ CTLIN,1 SAY IMPCHR(cIMPTIT)
   DO CASE
      CASE Q=1 ; @ CTLIN,2 SAY 'DEPTO: '+STR(DEP,5)+'-'+NOMCC
      CASE Q=2 ; @ CTLIN,2 SAY 'SETOR: '+STR(SET,5)+'-'+NOMCC
      CASE Q=3 ; @ CTLIN,2 SAY ACENTO('SE€ŽO: ')+STR(SEC,5)+'-'+NOMCC
   ENDCASE
   CTLIN++
NEXT Q
@ CTLIN,  0 SAY REPL('-',132)
CTLIN++
RETU .T.


FUNC FOI2B02(cARQ,cCAMPO)
LOCAL nRETU:=0,mCHAVE:=STRZERO(nrANO,4)+STRZERO(nrMES,2)
VIDEO()
DO CASE
   CASE CC=1 ; mCHAVE+=STRZERO(DEP,4)
   CASE CC=2 ; mCHAVE+=STRZERO(DEP,4)+STRZERO(SET,3)
   CASE CC=3 ; mCHAVE+=STRZERO(DEP,4)+STRZERO(SET,3)+STRZERO(SEC,3)
ENDCASE
MDS("Acumulando Provis„o: "+cARQ+" "+cCAMPO)
DBSELECTAR(cARQ)
DBGOTOP()
DBSEEK(mCHAVE)
WHILE nrANO=ANO.AND.nrMES=MES.AND.&COMPAR..AND.! EOF()
   nRETU+=&cCAMPO
   DBSKIP()
ENDDO
IMPRESSORA()
RETU nRETU


*: FIM: FOI2B.PRG
