*:*****************************************************************************
*:
*:   FOLIS_A8.PRG: Preparar Arquivo DIRF Juridica
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************


CABE2('Gera IRRF Avulsa Juridica')



ALERTX("So ‚ Gerado um codigo reten‡„o por arquivo")
ALERTX("Sera necess rio gerar um arquivo para cada codigo e importar um a um")

GRAVA1:="S"
mrXTEL:=mrXDDD:=mrXFAX:=""
xrCGC:=xrNOME:=""
xrDDD:=xrTEL:=xrPESSOA:=""
xrRESN:=xrRESC:=xrFAX:=xrRAMAL:=mNOME:=mNRCLIEN:=""
mEMAIL:=CPFCNPJ:=""
ANO:="2005"
ANOREF:="2006"
ARQ="C:\FOLHA\DIRF2006        "
ARQDET:="C:\FOLHA\DETA2006        "
xNUMEROANT:=SPACE(12)
OPER:="O"
CODRET:="0561"
xNUMEROANT:=SPACE(12)
SITU:="1"
NATUR:="0"
IDEN:="0"



IF ! DIRFEMPDAD()
   RETU .F.
ENDIF


IF ! DIRFPEGDAD()
   RETU .F.
ENDIF


ARQ:=ALLTRIM(ARQ)


mCGC=SUBSTR(xrCGC,1,2)+SUBSTR(xrCGC,4,3)+SUBSTR(xrCGC,8,3)
mEST=SUBSTR(xrCGC,12,4)+SUBSTR(xrCGC,17,2)
mrCPF=SUBSTR(xrRESC,1,3)+SUBSTR(xrRESC,5,3)+SUBSTR(xrRESC,9,3)+SUBSTR(xrRESC,13,2)
mCPFCNPJ:=SUBSTR(CPFCNPJ,1,3)+SUBSTR(CPFCNPJ,5,3)+SUBSTR(CPFCNPJ,9,3)+SUBSTR(CPFCNPJ,13,2)

SEQ:=1
BEN:=0
aTOTREN:=ARRAY(13)
aTOTDED:=ARRAY(13)
aTOTIRR:=ARRAY(13)
AFILL(aTOTREN,0)
AFILL(aTOTDED,0)
AFILL(ATOTIRR,0)
nREG02:=0


IF ! netuse("IRRF01") // AREDE("IRRF01","IRRF01",1) //Shared Brede PES
   RETU .F.
ENDIF

nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","cgc")
ordSetFocus("temp")


IF ! NETUSE("IRRF02")  //AREDE("IRRF02","IRRF02",1) //SHARED Arede ajudir
   DBCLOSEALL()
   RETU .F.
ENDIF


//Criando o Arquivo
USO:=FCREATE(ARQ)
IF FERROR()#0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF
IF GRAVA1="S"
   //Gravano o Header Empresa Tipo 1
   DIRFREG01()
ENDIF

DBSELECTAR("IRRF01")
DBGOTOP()
WHILE ! EOF()
   @ 24,00 SAY NOME
   aREND:=ARRAY(13)
   aDEDU:=ARRAY(13)
   aIRRF:=ARRAY(13)
   AFILL(aREND,0)
   AFILL(aDEDU,0)
   AFILL(aIRRF,0)
   mNOME  =NOME
   mNUMERO=NUMERO
   mPESSOA:=PESSOA
   IF PESSOA="J"
      USOCGC:=SUBSTR(CGC,1,2)+SUBSTR(CGC,4,3)+SUBSTR(CGC,8,3)
      USOCGC+=SUBSTR(CGC,12,4)+SUBSTR(CGC,17,2)
   ELSE
      USOCGC=SUBSTR(CGC,1,3)+SUBSTR(CGC,5,3)+SUBSTR(CGC,9,3)+SUBSTR(CGC,13,2)
      USOCGC="000"+USOCGC
   ENDIF
   GRAVA=.F.
   DBSELECTAR("IRRF02")
   DBGOTOP()
   DBSEEK(STR(mNUMERO,8))
   WHILE mNUMERO=NUMERO.AND. !EOF()
      IF MES>0.AND.MES<13.AND.DARF=CODRET
         GRAVA=.T.
         aREND[MES]+=RENDA
         aDEDU[MES]+=0
         aIRRF[MES]+=IRRF
      ENDIF
      DBSKIP()
   ENDDO
   DBSELECTAR("IRRF01")
   IF GRAVA
      DIRFREG02()
   ENDIF
   DBSELECTAR("IRRF01")
   DBSKIP()
ENDDO
DBCLOSEALL()


FWRITE(USO,CHR(26))
FCLOSE(USO)
RETU .T.
