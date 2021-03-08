*:*****************************************************************************
*:
*:       FOID.PRG: APURA€ŽO GERAL PARA CONTABILIDADE
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:16
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************
////#INCLUDE "COMANDO.CH"

function foid
PARA CC
IF ! MDL('APURA€ŽO GERAL PARA CONTABILIDADE',0)
   RETU
ENDIF
aCON:={}
aVAL:={}

nrMES:=MESTRAB
nrANO:=ANO
MDS("Confirme a Competencia")
@ 24,40 get nrMES PICT "99"
@ 24,60 GET nrANO PICT "9999"
READCUR()

IF ! ARQUSAR(CC,1)
   RETU .F.
ENDIF
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CONTA")
ordSetFocus("temp")

cSELE1:=ALIAS()

IF ! ARQCTA(CC,1,1)
   DBCLOSEALL()
   RETU
ENDIF
cSELE2:=ALIAS()

lCCOR:=netuse("CCOR") //AREDE("CCCOR","CCCOR",1)
IF lCCOR
   lARQTXT:=MDG("Criar Arquivo")
   IF lARQTXT
      cARQTXT:="A"+STRZERO(nrANO,4)+STRZERO(nrMES,2)+".TXT"
      nHANDLE:=FCREATE(cARQTXT)
      IF FERROR()#0
         ALERTX("Erro na Cria‡„o do Arquivo")
         RETU
      ENDIF
   ENDIF
ENDIF


DEB:=VEN:=FL:=TOT:=0
CTLIN=80
DESC:=HIST:=CODC:=CODD:=""

IMPRESSORA()
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE ! EOF()
   IF CTLIN > 55
      IF CTLIN#80
         @ PROW()+1,0 SAY REPL('-',132)
      ENDIF
      FL++
      @ 1,1 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
      @ 2, 25 SAY IMPCHR(cIMPTIT)+MSG2
      @ 3,100 SAY TIME()
      @ 3,110 SAY DXDIA
      @ 3,120 SAY 'FL. '+STRZERO(FL,4)
      @ 4,  0 SAY REPL('-',132)
      @ 5, 20 SAY IMPCHR(cIMPTIT)+'Apuracao Geral Contabilidade '+MMES+'/'+STRZERO(ANO,4)
      @ 6,  0 SAY REPL ('-',132)
      @ 7,  1 SAY 'CONTA'
      @ 7,  7 SAY 'DESCRIMINACAO DA CONTA'
      @ 7, 45 SAY 'VALOR'
      @ 7, 68 SAY 'N.Lancto.'
      @ 7, 78 SAY 'Conta Contabil'
      @ 7,125 SAY 'Hist.'
      @ 8,  0 SAY REPL('-',132)
      CTLIN = 9
   ENDIF
   CTA=CONTA
   TOT=0
   WHILE CTA=CONTA.AND.!EOF()
      TOT+=VALOR
      DBSKIP()
   ENDDO
   IMP = .T.
   DBSELECTAR(cSELE2) //Verifica se Imprime
   DBGOTOP()
   IF DBSEEK(CTA)
     IF LISCON="N"
        IMP:=.F.
     ENDIF
   ENDIF
   IF CC#4.AND.CC#6 //Contas Reservadas 13o. Salario
      IF CTA>120.AND.CTA<150
         IMP=.F.
      ENDIF
      IF CTA=910.OR.CTA=911.OR.CTA=505.OR.CTA=506
         IMP=.F.
      ENDIF
   ENDIF
   IF IMP
      FOID04()
      FOID05()
   ENDIF
   DBSELECTAR(cSELE1)
ENDDO
DBCLOSEALL()
DBSELECTAR(cSELE1)
VIDEO()
IF NETUSE("GINSSE")
   lCCOR:=.F. //Contas Especias j  e por Empresa
   IF ! NETUSE("CCESP") 
      DBCLOSEALL()
      RETU .F.
   ENDIF
   IF ! NETUSE("PROV13") 
      DBCLOSEALL()
      RETU .F.
   ENDIF
   MDS("Aguarde Preparando Provisao 13S")
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","STRZERO(ANO,4)+STRZERO(MES,2)")
   ordSetFocus("temp")
   
      
   IF ! NETUSE("PROVFE") 
      DBCLOSEALL()
      RETU .F.
   ENDIF
   MDS("Aguarde Preparando Provisao FER")
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)   
   ordDestroy("temp")
   ordcreate(,"temp","STRZERO(ANO,4)+STRZERO(MES,2)")
   ordSetFocus("temp")
   
      
   IMPRESSORA()
   DBSELECTAR("CCESP")
   WHILE ! EOF()
      CTA:=CODIGO
      cCAMPO:=CAMPO
      DESC=DESCR
      HIST=STRZERO(CO_HIS,3)
      CODC='C-'+CO_COD +'/'+STR(CO_CODR ,6)
      CODD='D-'+CO_CODD+'/'+STR(CO_CODRD,6)
      IF TIPO="I".AND.NREMP=NUMEMP
         DBSELECTAR("GINSSE")
         DBGOTOP()
         IF DBSEEK(STRZERO(NREMP,5)+STRZERO(nrANO,4)+STRZERO(nrMES,2))
            TOT:=&cCAMPO.
            DBSELECTAR("CCESP")
            FOID05()
         ENDIF
      ENDIF
      DBSELECTAR("CCESP")
      IF TIPO="1".AND.NREMP=NUMEMP
         TOT:=FOID06("PROV13",cCAMPO)
         DBSELECTAR("CCESP")
         FOID05()
      ENDIF
      DBSELECTAR("CCESP")
      IF TIPO="F".AND.NREMP=NUMEMP
         TOT:=FOID06("PROVFE",cCAMPO)
         DBSELECTAR("CCESP")
         FOID05()
      ENDIF
      DBSELECTAR("CCESP")
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF
IMPRESSORA()
FOID02(30,30)
FOID01(.F.)
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
RETU .T.


FUNC FOID01(lMES)
CTLIN:=80
DEB:=VEN:=0
FOR W=1 TO LEN(aCON)
    IF CTLIN>50
       @ 1,1 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
       @ 2, 25 SAY IMPCHR(cIMPTIT)+MSG2
       @ 3,100 SAY TIME()
       @ 3,110 SAY DXDIA
       @ 3,120 SAY 'FL. '+STRZERO(FL,4)
       @ 4,  0 SAY REPL('-',132)
       @ 5, 20 SAY IMPCHR(cIMPTIT)+'Apuracao Geral Contabilidade '+MMES+'/'+STRZERO(ANO,4)
       @ 6,  0 SAY REPL ('-',132)
       @ 7,  1 SAY 'CONTA'
       @ 7, 45 SAY 'Credito'
       @ 7, 65 SAY 'Debito'
       @ 8,  0 SAY REPL('-',132)
       CTLIN = 9
       IF lMES
          FOI2B01()
       ENDIF
    ENDIF
    @ CTLIN,  2 SAY aCON[W]
    @ CTLIN, 45 SAY aVAL[W][1] PICT '###,###,###,###.##'
    @ CTLIN, 65 SAY aVAL[W][2] PICT '###,###,###,###.##'
    IF lARQTXT
       FWRITE(nHANDLE,STRTRAN(PADR(STRTRAN(aCON[W],".",""),13)," ","0"))
       FWRITE(nHANDLE,STRTRAN(STRZERO(aVAL[W][1],13,2),".",""))
       FWRITE(nHANDLE,STRTRAN(STRZERO(aVAL[W][2],13,2),".",""))
       IF lMES
          DO CASE
             CASE CC=1 ; FWRITE(nHANDLE,STRZERO(DEP,4)+"000000")
             CASE CC=2 ; FWRITE(nHANDLE,STRZERO(DEP,4)+STRZERO(SET,3)+"000")
             CASE CC=3 ; FWRITE(nHANDLE,STRZERO(DEP,4)+STRZERO(SET,3)+STRZERO(SEC,3))
          ENDCASE
       ENDIF
       FWRITE(nHANDLE,CHR(13)+CHR(10))
    ENDIF
    CTLIN++
    VEN+=aVAL[W][1]
    DEB+=aVAL[W][2]
NEXT W
FOID02(45,65)
RETU .T.


FUNC FOID02(nCOL1,nCOL2)
@ PROW()+1,    0 SAY REPL('-',132)
@ PROW()+1,    0 SAY 'Resumo Geral'
@ PROW()+1,    0 SAY 'Total Creditos'
@ PROW()  ,nCOL1 SAY VEN PICT '###,###,###,###.##'
@ PROW()+1,    0 SAY 'Total Debitos'
@ PROW()  ,nCOL2 SAY DEB PICT '###,###,###,###.##'
@ PROW()+1,    0 SAY REPL('-',132)
RETU


FUNC FOID03
IF ! EMPTY(CO_COD).OR. ! EMPTY(CO_CODR)
    VEN+=TOT
    nPOS:=ASCAN(aCON,CO_COD)
    IF nPOS>0
       aVAL[nPOS][1]+=TOT
    ELSE
       AADD(aCON,CO_COD)
       AADD(aVAL,{TOT,0})
    ENDIF
ENDIF
IF ! EMPTY(CO_CODD).OR. ! EMPTY(CO_CODRD)
   DEB+=TOT
   nPOS:=ASCAN(aCON,CO_CODD)
   IF nPOS>0
      aVAL[nPOS][2]+=TOT
   ELSE
      AADD(aCON,CO_CODD)
      AADD(aVAL,{0,TOT})
   ENDIF
ENDIF
RETU


FUNC FOID04(cCONTA)
LOCAL lIND:=.F.
IF VALTYPE(cCONTA)#"C"
   cCONTA:="CONTAS"
ENDIF
DESC:='Conta nao Cadastrada'
HIST:="   "
CODC:=SPACE(20)
CODD:=SPACE(20)
IF lCCOR
   DBSELECTAR("CCCOR")
   DBGOTOP()
   IF DBSEEK(STR(CTA,4)+STR(NREMP,5))
      HIST=STRZERO(CO_HIS,3)
      CODC='C-'+CO_COD +'/'+STR(CO_CODR ,6)
      CODD='D-'+CO_CODD+'/'+STR(CO_CODRD,6)
      lIND:=.T.
   ENDIF
ENDIF
DBSELECTAR(cCONTA)
DBGOTOP()
IF DBSEEK(CTA)
   DESC=DESCR
   IF lIND    //Dados Individuais Retorna
      RETU .T.
   ENDIF
   HIST=STRZERO(CO_HIS,3)
   CODC='C-'+CO_COD +'/'+STR(CO_CODR ,6)
   CODD='D-'+CO_CODD+'/'+STR(CO_CODRD,6)
ENDIF
RETU .T.

FUNC FOID05()
@ CTLIN,  2 SAY CTA PICT "###"
@ CTLIN,  6 SAY DESC
@ CTLIN, 45 SAY TOT PICT '###,###,###,###.##'
@ CTLIN, 69 SAY '________'
@ CTLIN, 79 SAY CODD
@ CTLIN,102 SAY CODC
@ CTLIN,125 SAY HIST
CTLIN++
FOID03()
RETU .T.

FUNC FOID06(cARQ,cCAMPO)
LOCAL nRETU:=0
VIDEO()
MDS("Acumulando Provis„o: "+cARQ+" "+cCAMPO)
DBSELECTAR(cARQ)
DBGOTOP()
DBSEEK(STRZERO(nrANO,4)+STRZERO(nrMES,2))
WHILE nrANO=ANO.AND.nrMES=MES.AND. ! EOF()
   nRETU+=&cCAMPO
   DBSKIP()
ENDDO
IMPRESSORA()
RETU nRETU
*: FIM: FOID.PRG
