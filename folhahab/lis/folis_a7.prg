*:*****************************************************************************
*:
*:
*:   FOLIS_A7.PRG: Preparar Arquivo DIRF
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************


CABE2('Criar Arquivo para DIRF ')
IF ! MDG('Voce ja conferiu o Cadastro Funcionarios, estao OK.')
   FOLIS_D1()
   RETU
ENDIF
IF ! MDG('Vocˆ j  acumulou Informe, e Depois DIRF')
   RETU
ENDIF
IF ! MDG('Vocˆ j  conferiu o Acumulo DIRF, est„o OK.')
   RETU
ENDIF

nACU:=IRRESC()

GRAVA1:="S"
mrXTEL:=mrXDDD:=mrXFAX:=""
xrCGC:=xrNOME:=""
xrDDD:=xrTEL:=xrPESSOA:=""
xrRESN:=xrRESC:=xrFAX:=xrRAMAL:=mNOME:=mNRCLIEN:=""
mEMAIL :=CPFCNPJ:=""
xNUMEROANT:=SPACE(12)
ANO:="2012"
ANOREF:="2011"
ARQ="C:\FOLHA\DIRF2012.TXT"+SPACE(30)
ARQDET:="C:\FOLHA\DETA2012.TXT"+SPACE(30)
OPER:="O"
CODRET:="0561"
SITU:="1"
NATUR:="0"
IDEN:="0"


IF ! DIRFEMPDAD()
   RETU .F.
ENDIF

IF ! DIRFPEGDAD()
   RETU .F.
ENDIF


IF ! EMPTY(ARQDET)
   IF ! MDG("Voce ao imprimir Informe Gravou Arquivo de Detalhes")
      RETU .F.
   ENDIF
ENDIF

ARQ:=ALLTRIM(ARQ)

mCGC=SUBSTR(xrCGC,1,2)+SUBSTR(xrCGC,4,3)+SUBSTR(xrCGC,8,3)
mEST=SUBSTR(xrCGC,12,4)+SUBSTR(xrCGC,17,2)
mrCPF=SUBSTR(xrRESC,1,3)+SUBSTR(xrRESC,5,3)+SUBSTR(xrRESC,9,3)+SUBSTR(xrRESC,13,2)
mCPFCNPJ:=SUBSTR(CPFCNPJ,1,3)+SUBSTR(CPFCNPJ,5,3)+SUBSTR(CPFCNPJ,9,3)+SUBSTR(CPFCNPJ,13,2)


SEQ:=1
aTOTREN:=ARRAY(13)
aTOTDED:=ARRAY(13)
aTOTIRR:=ARRAY(13)
AFILL(aTOTREN,0)
AFILL(aTOTDED,0)
AFILL(ATOTIRR,0)
nREG02:=0


IF ! ARQIRR(nACU,1,3) //shared PES
   RETU .F.
ENDIF

ordDestroy("temp")
ordcreate(,"temp","cpf")
ordSetFocus("temp")



cSELE1:=ALIAS()

IF ! ARQIRR(nACU,1,1) //SHARED ajudir
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2:=ALIAS()


//Criando o Arquivo
USO:=FCREATE(ARQ)
IF FERROR()#0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF
IF GRAVA1="S"
   //Gravando Registro 01
   DIRFREG01()
ENDIF

dbselectar(cSELE1)
WHILE ! EOF()
   PETELA(8)
   aREND:=ARRAY(13) //1
   aDEDU:=ARRAY(13) //2
   aIRRF:=ARRAY(13) //3
   aPREV:=ARRAY(13) //4
   aDEPE:=ARRAY(13) //5
   aPENS:=ARRAY(13) //6
   aPRIV:=ARRAY(13) //7

   
   AFILL(aREND,0)
   AFILL(aDEDU,0)
   AFILL(aIRRF,0)
   AFILL(aPREV,0)
   AFILL(aDEPE,0)
   AFILL(aPENS,0)
   AFILL(aPRIV,0)
   
   
   mNOME  =NOME
   mNUMERO=NUMERO
   mCPF=SUBSTR(CPF,1,3)+SUBSTR(CPF,5,3)+SUBSTR(CPF,9,3)+SUBSTR(CPF,13,2)
   cCPF:=CPF
   GRAVA=.F.
   dbselectar(cSELE2)
   FOR X= 1 TO 13
      BUSCA=cCPF+STR(X,2)
      DBGOTOP()
      IF DBSEEK(BUSCA)
         GRAVA=.T.
         aREND[X]=VALUF1
         aDEDU[X]=VALUF2
         aIRRF[X]=VALUF3
         aPREV[X]=VALUF4
         aDEPE[X]=VALUF5
         aPENS[X]=VALUF6
         aPRIV[X]=VALUF7
      ENDIF
   NEXT X
   IF GRAVA
      mPESSOA:="F"
      USOCGC:="000"+mCPF
      DIRFREG02("0")
      DIRFREG02("1")
      DIRFREG02("2")
   ENDIF
   dbselectar(cSELE1)
   DBSKIP()
ENDDO
DBCLOSEALL()


//Fechando o arquivo
FWRITE(USO,CHR(26))
FCLOSE(USO)

IF MDG("Deseja Ver o Arquivo dirf")
   VERTXT(ARQ)
ENDIF
IF MDG("Deseja imprimir o Arquivo dirf")
   imparq(ARQ,,,,,,,730,)
ENDIF

ALERTX("N„o Esque‡a de Utilizar o Validador")

IF  EMPTY(ARQDET)
   RETU .F.
ENDIF
nSEQ:=1
IF ! netuse("IRRF") //AREDE("IRRF","IRRF",1)
   DBCLOSEALL()
   RETU .F.
ENDIF
//Criando o Arquivo Detalhes
USO:=FCREATE(ARQDET)
IF FERROR()#0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF
DBGOTOP()
WHILE ! EOF()
  mCPF=SUBSTR(CPF,1,3)+SUBSTR(CPF,5,3)+SUBSTR(CPF,9,3)+SUBSTR(CPF,13,2)
  FWRITE(USO,mCPF)
  FWRITE(USO,GRVVAL(V402,15,2)) //Prev Oficial
  FWRITE(USO,GRVVAL(V403,15,2)) //Prev Privada
  FWRITE(USO,GRVVAL(V404,15,2)) //Pensao
  FWRITE(USO,GRVVAL(V502,15,2)) //Aposentadoria
  FWRITE(USO,GRVVAL(V503,15,2)) //Diarias
  FWRITE(USO,GRVVAL(V504,15,2)) //invalidez
  FWRITE(USO,GRVVAL(V505,15,2)) //lucro
  FWRITE(USO,GRVVAL(V506,15,2)) //titulares
  FWRITE(USO,GRVVAL(V507,15,2)) //Indenizacoes
  FWRITE(USO,ACEPAD(OBS02,60)) //Descricao Outros
  nVAL:=V611-(V612+V617+V614) //Saldo Outras
  IF nVAL>0
     FWRITE(USO,GRVVAL(nVAL,15,2))
  ELSE
     FWRITE(USO,GRVVAL(0,15,2))
  ENDIF
  FWRITE(USO,ACEPAD(alltrim(OBS03)+" "+ALLTRIM(OBS04)+" "+OBS05,200)) //Inf.Complementares
  FWRITE(USO,CHR(13)+CHR(10))
  nSEQ++
  DBSKIP()
ENDDO
DBCLOSEAREA()
FWRITE(USO,CHR(26))
FCLOSE(USO)
IF MDG("Deseja Ver o Arquivo Detalhes")
   VERTXT(ARQDET)
ENDIF
IF MDG("Deseja imprimir o Arquivo Detalhes")
   imparq(ARQDET,,,,,,,421,)
ENDIF
RETU .T.



FUNC DIRFEMPDAD()
IF ! NETUSE("FIRMA") 
   RETU .F.
ENDIF
DBGOTOP()
IF ! DBSEEK(NREMP)
   DBCLOSEALL()
   ALERTX("Falta Cadastro Empresa")
   RETU .F.
ENDIF
xrCGC:=CGC
xrNOME:=ACEPAD(RAZAO,60)
xrDDD:=DDD
xrTEL:=TELEFONE
xrPESSOA:=PESSOA
xrRESN=ACEPAD(RESPONSAV,60)
xrRESC:=CPFRESP
CPFCNPJ:=CPFRESP
xrFAX :=FAX
xrRAMAL:=ACEPAD(RAMAL,6)
mNRCLIEN:= NRCLIEN
mEMAIL  := ACEPAD(EMAIL,50)
DBCLOSEALL()
mrXTEL:=STRTRAN(xrTEL,"-","")
mrXTEL:=STRTRAN(mrXTEL," ","0")
mrXTEL:=STRZERO(VAL(mrxTEL),8)
mrXFAX:=STRTRAN(xrFAX,"-","")
mrXFAX:=STRTRAN(mrXFAX," ","0")
mrXFAX:=STRZERO(VAL(mrxFAX),8)
mrXDDD:=STRZERO(VAL(XRDDD),4)
RETU .T.
