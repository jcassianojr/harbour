*:*****************************************************************************
*:
*:       FOCC.PRG: Rela‡„o de L¡quidos a Pagar/Bancaria/Cheques
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Softec
*:      Copyright (c) 1997,  SOFTEC  S/C Ltda.
*:  Atualizado em: 02/10/97
*:
*:*****************************************************************************


////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function focc
PARA CC,CW,CX

IF (CX=3.OR.CX=4).AND.CC=6
   ALERTX("Opcao Nao Disponivel")
   RETU .F.
ENDIF

CTACRE=399
CTADEB=999
lVALE:=.F.
IF CC=9
   lVALE:=.T.
   CTACRE=41
   CTADEB=501
   CC=1 //Abrira Folha
ENDIF
IF CC=10
   CTACRE=445
   CTADEB=527
   SOMAVALE:=MDG("Somado com o Vale")
   CC=1 //Abrira Folha
ENDIF
IF CC=3
   CTACRE=900
   CTADEB=0
ENDIF

IF CC=6
   CTACRE=443
   CTADEB=530
   CC=1 //Abrira Folha
ENDIF


MDS("Confirme Contas Credito Debito")
@ 24,40 GET CTACRE PICT "999"
@ 24,50 GET CTADEB PICT "999"
IF ! READCUR()
   RETU .F.
ENDIF


DO CASE
   CASE CX=1
        IF ! MDL('Listar Relacao de Liquidos  a Pagar',0)
           RETU
        ENDIF
   CASE CX=2
        IF ! MDL('Listar Bancaria',0)
           RETU
        ENDIF
   CASE CX=3
        IF ! MDL('Emitir Cheques de Pagamento',0)
           RETU
        ENDIF
   CASE CX=4 ; CABEX('Gerar Arquivo Banespa')
   CASE CX=5 ; CABEX('Gerar Arquivo Itau')
ENDCASE

//Variaveis de Trabalho
SOMAVALE:=.F.
mDIA    :=DATE()
COPIA   :=1
ATUALIZA:=1.000000


IF CX#3.AND.CX#4.AND.CX#5
   MDS('Digite Cabe‡ario Complementar')
   @ 24,35 GET POS1
   READCUR()
   MDS('Digite o numero de copias')
   @ 24,40 GET COPIA PICT '##'
   READCUR()
ELSE
   MDS('Confirme a Data Emissao')
   @ 24,40 GET mDIA
   READCUR()
ENDIF


MDS('Qual o Fator de Atualiza‡„o')
@ 24,40 GET ATUALIZA PICT "99999999999.999999"
READCUR()

IF ! ARQUSAR(CC,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1:=ALIAS()

IF ! ARQPES(CC,1,0)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2:=ALIAS()
INX=""
FILTRO='((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
FILORD()
IF CX=2 //Rela‡ao Bancaria Chave Quebra Banco+chave
   DO CASE
      CASE TYPE(INX)="N" ; INX:="STR("+INX+")"
      CASE TYPE(INX)="D" ; INX:="DTOC("+INX+")"
   ENDCASE
   INX:="BANCO+"+INX
ENDIF
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","inx")
ordSetFocus("temp")
SET FILTER TO &FILTRO

IF CW>1
   IF ! NETUSE("DEPTO") //AREDE("DEPTO","DEPTO",1)
      DBCLOSEALL()
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


IF CX#4.AND.CX#5
   IMPRESSORA()
ENDIF
FOR W=1 TO COPIA
    FL=0
    IF CW=1
       NOMSETOR=""
       DO CASE
          CASE CX=1 ; FOCCX(".T.")
          CASE CX=2 ; FOCBX(".T.")
          CASE CX=3 ; FOCIX(".T.")
          CASE CX=4 ; FOCHX(".T.")
          CASE CX=5 ; FOCITAU(".T.")
       ENDCASE
    ELSE
       DBSELECTAR("DEPTO")
       DBGOTOP()
       WHILE ! EOF()
          NOMSETOR=NOMEC
          DEP=DEPTO
          SET=SETOR
          SEC=SECAO
          DO CASE
             CASE CX=1 ; FOCCX(COMPAR)
             CASE CX=2 ; FOCBX(COMPAR)
             CASE CX=3 ; FOCIX(COMPAR)
             CASE CX=4 ; FOCHX(COMPAR)
             CASE CX=5 ; FOCITAU(COMPAR)
          ENDCASE
          DBSELECTAR("DEPTO")
          DBSKIP()
       ENDDO
    ENDIF
    IF CX#4.AND.CX#5
       IMPFOL()
    ENDIF
NEXT W
VIDEO()
DBCLOSEALL()
IF CX#4.AND.CX#5
   IMPEND()
ENDIF
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: FOCCX()
*!
*!    Chamado por: FOCC.PRG
*!
*!          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNC FOCCX
PARA COMPARE
TOTAL=0
CTLIN=80
TOTALIZA=.F.
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      IF CTLIN > 55
         IF CTLIN#80
            IF TOTALIZA.AND.TOTAL>0
               @ PROW()+1,0 SAY REPL('-',132)
               @ PROW()+1,21 SAY 'VALOR A SER PAGO (PAGAMENTO LIQUIDO)--> '
               @ PROW()  ,64 SAY TOTAL PICTURE '@E 999,999,999,999.99'
               @ PROW()+1, 0 SAY REPL('-',132)
            ENDIF
         ENDIF
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3,  5 SAY IMPCHR(cIMPTIT)+'PAGAMENTO EXECUTADO SIMPLES'
         @ 4,  0 SAY IMPCHR(cIMPTIT)+NOMSETOR
         @ 5,  0 SAY POS1
         @ 5,100 SAY TIME()
         @ 5,110 SAY DXDIA
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',132)
         @ 7,  1 SAY 'DEPTO'
         @ 7,  7 SAY 'SETOR'
         @ 7, 13 SAY ACENTO('SE€ŽO')
         @ 7, 19 SAY 'CHAPA'
         @ 7, 25 SAY 'REGISTRO'
         @ 7, 34 SAY 'NOME'
         @ 7, 65 SAY 'VALOR A PAGAR'
         @ 8,  0 SAY REPL('-',132)
         CTLIN=9
      ENDIF
      NUM=NUMERO
      DBSELECTAR(cSELE1)
      LIQ=VALCTA(NUM,CTACRE)-VALCTA(NUM,CTADEB)
      LIQ=LIQ+IF(lVALE,VALCTA(NUM,997)-VALCTA(NUM,442),0)
      LIQ=IF(ATUALIZA#1,ROUND(LIQ*ATUALIZA,2),LIQ)
      DBSELECTAR(cSELE2)
      IF LIQ#0
         @ CTLIN, 2 SAY DEPTO
         @ CTLIN, 8 SAY SETOR
         @ CTLIN,14 SAY SECAO
         @ CTLIN,20 SAY CHAPA
         @ CTLIN,26 SAY NUMERO
         @ CTLIN,33 SAY NOME
         @ CTLIN,64 SAY LIQ PICT '@E 999,999,999,999.99'
         TOTAL+=LIQ
         CTLIN++
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
IF TOTALIZA.AND.TOTAL>0
   @ PROW()+1, 0 SAY REPL('-',132)
   @ PROW()+1,21 SAY 'VALOR A SER PAGO (PAGAMENTO LIQUIDO)--> '
   @ PROW()  ,64 SAY TOTAL PICTURE '@E 999,999,999,999.99'
   @ PROW()+1, 0 SAY REPL('-',132)
ENDIF
RETU(.T.)


*!*****************************************************************************
*!
*!         Fun‡„o: FOCBX()
*!
*!    Chamado por: FOCC.PRG
*!
*!          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNC FOCBX
PARA COMPARE
CTLIN=80
TOTAL=0
TOTALIZA=.F.
DBSELECTAR(cSELE2)
DBGOTOP()
xBANCO:=BANCO
WHILE ! EOF()
   IF EMPTY(BANCO)
      DBSKIP()
      LOOP
   ENDIF
   IF &COMPARE
      IF BANCO#xBANCO
         CTLIN:=99
         xBANCO:=BANCO
      ENDIF
      TOTALIZA=.T.
      IF CTLIN>60.OR.CTLIN=99
         IF CTLIN#80
            IF TOTALIZA.AND.TOTAL>0
               @ PROW()+1, 0 SAY REPL('-',132)
               @ PROW()+1,31 SAY 'VALOR A SER DEBITADO EM NOSSA CONTA CORRENTE--> '
               @ PROW()  ,93 SAY TOTAL PICTURE '@E 999,999,999,999.99'
               @ PROW()+1, 0 SAY REPL('-',132)
               IF CTLIN=99
                  TOTAL   :=0
             //     TOTALIZA:=.F.
                  FL      :=0
               ENDIF
            ENDIF
         ENDIF
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3,  5 SAY IMPCHR(cIMPTIT)+ACENTO('RELA€ŽO PARA DEP•SITOS EM CONTA CORRENTE ')
         @ 4,  0 SAY IMPCHR(cIMPTIT)+NOMSETOR
         @ 5,  0 SAY POS1
         @ 5,100 SAY TIME()
         @ 5,110 SAY DXDIA
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',132)
         @ 7,  1 SAY 'DEPTO'
         @ 7,  7 SAY 'SETOR'
         @ 7, 13 SAY ACENTO('SE€ŽO')
         @ 7, 19 SAY 'CHAPA'
         @ 7, 25 SAY 'REGISTRO'
         @ 7, 34 SAY 'NOME'
         @ 7, 65 SAY 'BCO'
         @ 7, 69 SAY 'AGENCIA'
         @ 7, 77 SAY ACENTO('N—MERO CONTA')
         @ 7, 91 SAY 'VALOR DEPOSITADO'
         @ 8,  0 SAY REPL('-',132)
         CTLIN=9
      ENDIF
      NUM=NUMERO
      DBSELECTAR(cSELE1)
      LIQ =VALCTA(NUM,CTACRE)-VALCTA(NUM,CTADEB)
      LIQ+=IF(lVALE.OR.SOMAVALE,VALCTA(NUM,997)-VALCTA(NUM,442),0)
      IF SOMAVALE
         LIQ+=VALCTA(NUM,41)-VALCTA(NUM,501)
      ENDIF
      LIQ=IF(ATUALIZA#1,ROUND(LIQ*ATUALIZA,2),LIQ)
      DBSELECTAR(cSELE2)
      IF LIQ>0
         @ CTLIN,2 SAY DEPTO
         @ CTLIN,8 SAY SETOR
         @ CTLIN,14 SAY SECAO
         @ CTLIN,20 SAY CHAPA
         @ CTLIN,26 SAY NUMERO
         @ CTLIN,33 SAY NOME
         @ CTLIN,65 SAY BANCO
         @ CTLIN,69 SAY AGENCIA
         @ CTLIN,78 SAY CONTA
         @ CTLIN,93 SAY LIQ PICT '@E 999,999,999,999.99'
         CTLIN++
         TOTAL+=LIQ
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
IF TOTALIZA.AND.TOTAL>0
   @ PROW()+1, 0 SAY REPL('-',132)
   @ PROW()+1,31 SAY 'VALOR A SER DEBITADO EM NOSSA CONTA CORRENTE--> '
   @ PROW()  ,93 SAY TOTAL PICTURE '@E 999,999,999,999.99'
   @ PROW()+1, 0 SAY REPL('-',132)
ENDIF
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: FOCIX()
*!
*!    Chamado por: FOCC.PRG
*!
*!          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNC FOCIX
PARA COMPARE
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      NUM=NUMERO
      DBSELECTAR(cSELE1)
      LIQ=VALCTA(NUM,CTACRE)-VALCTA(NUM,CTADEB)
      LIQ=LIQ+IF(lVALE,VALCTA(NUM,997)-VALCTA(NUM,442),0)
      LIQ=IF(ATUALIZA#1,ROUND(LIQ*ATUALIZA,2),LIQ)
      DBSELECTAR(cSELE2)
      IF LIQ>0
         @ PROW()   ,50 SAY LIQ PICT "@E 9,999,999,999.99"
         @ PROW() +2,14 SAY EXT(LIQ,1,55,65,0)
         @ PROW() +1, 2 SAY EXT(LIQ,2,55,65,0)
         @ PROW() +2, 4 SAY NOME
         @ PROW() +2,26 SAY TRIM(CID1)+", "+STR(DAY(mDIA),2)
         @ PROW()   ,48 SAY MMES(MONTH(mDIA))
         @ PROW()   ,65 SAY SUBSTR(STRZERO(YEAR(mDIA),4),3,4)
         @ PROW()+11, 0 SAY ""
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: FOCHX()
*!
*!    Chamado por: FOCC.PRG
*!
*!          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNC FOCHX
PARA COMPARE
cARQNOME := "BANESPA.TXT"+SPACE(20)
cCODEMP  := SPACE(4)
cNOMEMP  := TIRACX(MSG2,30)
cLITER   := PADR("CREDITOS EM C/C",14)
cNOMEBCO := PADR("BANESPA S/A",15)
cDENSID  := 1600
cCODLAN  := SPACE(25)
cCODSER  := "001"
cREFEXT  := "021"
cSINAL   := "C"
cCGC     := CGC1
dLANC    := mDIA

HB_DISPBOX( 5, 0,23,79,B_DOUBLE+" ")
@  6,  2 SAY "Arquivo"+spac(12)+":"
@  7,  2 SAY "Codigo da Empresa  :"
@  8,  2 SAY "Nome da Emprea     :"
@  9,  2 SAY "Literal Servi‡o    :"
@ 10,  2 SAY "Nome do Banco"+spac(6)+":"
@ 11,  2 SAY "Data Grava‡„o"+spac(6)+":"
@ 12,  2 SAY "Data Lan‡amento    :"
@ 13,  2 SAY "Densidade"+spac(10)+":"
@ 14,  2 SAY "Identidade Empresa :"
@ 15,  2 SAY "Codigo do Servico  :"
@ 16,  2 SAY "Referencia Extrato :"
@ 17,  2 SAY "Identidade Sinal   :     (C/D)"
@ 18,  2 SAY "CGC Empresa"+spac(8)+":"
@  6, 23 GET cARQNOME
@  7, 23 GET cCODEMP
@  8, 23 GET cNOMEMP
@  9, 23 GET cLITER
@ 10, 23 GET cNOMEBCO
@ 11, 23 GET mDIA
@ 12, 23 GET dLANC
@ 13, 23 GET cDENSID PICT "99999"
@ 14, 23 GET cCODLAN
@ 15, 23 GET cCODSER
@ 16, 23 GET cREFEXT
@ 17, 23 GET cSINAL
@ 18, 23 GET cCGC
READCUR()


cDENSID  := STRZERO(cDENSID,5)
mDIA     := DTOC(mDIA)
mDIA     := STRTRAN(mDIA,"/","")
dLANC    := DTOC(dLANC)
dLANC    := STRTRAN(dLANC,"/","")
cCGC     := TIRACX(cCGC,,,"")
SEQ      := 1
CRE      := 0
nHANDLE  := FCREATE(ALLTRIM(cARQNOME))
IF FERROR()#0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF

//Gravando Header de Arquivo
FWRITE(nHANDLE,"0")
FWRITE(nHANDLE,"1")
FWRITE(nHANDLE,"REMESSA")
FWRITE(nHANDLE,"03")
FWRITE(nHANDLE,cLITER)
FWRITE(nHANDLE,cCODEMP)
FWRITE(nHANDLE,SPACE(17))
FWRITE(nHANDLE,cNOMEMP)
FWRITE(nHANDLE,"033")
FWRITE(nHANDLE,cNOMEBCO)
FWRITE(nHANDLE,mDIA)
FWRITE(nHANDLE,cDENSID)
FWRITE(nHANDLE,"BPI")
FWRITE(nHANDLE,"01")
FWRITE(nHANDLE,SPACE(84))
FWRITE(nHANDLE,STRZERO(SEQ,6))
FWRITE(nHANDLE,hb_osnewline())
SEQ++
CRE++
CTLIN=80
TOTAL=0
TOTALIZA=.F.
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   PETELA(08)
   IF BANCO#"033"   //Checar Codigo Banco
      DBSKIP()
      LOOP
   ENDIF
   IF ! VALCPF(CPF) //Checar CPF
      DBSKIP()
      LOOP
   ENDIF
   IF ! CHECKCTA(BANCO,AGENCIA,CONTA)  //Checar Conta
      DBSKIP()
      LOOP
   ENDIF
   IF &COMPARE
      NUM      := NUMERO
      cNOME    := TIRACX(NOME,40)
      cCONTA   := TIRACX(CONTA,,,"")
      cAGENCIA := TIRACX(AGENCIA,,,"")
      cAGENCIA := RIGHT(cAGENCIA,3)
      cAGENCTA := cAGENCIA+cCONTA
      DBSELECTAR(cSELE1)
      LIQ =VALCTA(NUM,CTACRE)-VALCTA(NUM,CTADEB)
      LIQ+=IF(lVALE.OR.SOMAVALE,VALCTA(NUM,997)-VALCTA(NUM,442),0)
      IF SOMAVALE
         LIQ+=VALCTA(NUM,41)-VALCTA(NUM,501)
      ENDIF
      LIQ=IF(ATUALIZA#1,ROUND(LIQ*ATUALIZA,2),LIQ)
      DBSELECTAR(cSELE2)
      IF LIQ>0
         cLIQ:=STRZERO(LIQ,14,2)
         cLIQ:=STRTRAN(cLIQ,".","")
         //Gravando Registro
         FWRITE(nHANDLE,"1")
         FWRITE(nHANDLE,"02")
         FWRITE(nHANDLE,PADR(cCGC,14))
         FWRITE(nHANDLE,cCODEMP)
         FWRITE(nHANDLE,SPACE(16))
         FWRITE(nHANDLE,PADR(cCODLAN,25))
         FWRITE(nHANDLE,cAGENCTA)
         FWRITE(nHANDLE,SPACE(8))
         FWRITE(nHANDLE,cNOME)
         FWRITE(nHANDLE,dLANC)
         FWRITE(nHANDLE,cLIQ)
         FWRITE(nHANDLE,cCODSER)
         FWRITE(nHANDLE,cREFEXT)
         FWRITE(nHANDLE,SPACE(3))
         FWRITE(nHANDLE,cSINAL)
         FWRITE(nHANDLE,SPACE(3))
         FWRITE(nHANDLE,STRZERO(NUM,14))
         FWRITE(nHANDLE,SPACE(26))
         FWRITE(nHANDLE,STRZERO(SEQ,6))
         FWRITE(nHANDLE,hb_osnewline())
         SEQ++
         CRE++
         TOTAL+=LIQ
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
TOTAL:=STRZERO(TOTAL,16,2)
TOTAL:=STRTRAN(TOTAL,".","")
//Gravando trailler
FWRITE(nHANDLE,"9")
FWRITE(nHANDLE,SPACE(149))
FWRITE(nHANDLE,STRZERO(0,6))
FWRITE(nHANDLE,STRZERO(0,15))
FWRITE(nHANDLE,STRZERO(CRE,6))
FWRITE(nHANDLE,TOTAL)
FWRITE(nHANDLE,SPACE(2))
FWRITE(nHANDLE,STRZERO(SEQ,6))
FWRITE(nHANDLE,hb_osnewline())
FWRITE(nHANDLE,CHR(26))
FCLOSE(nHANDLE)



IF MDG("Deseja Ver o Arquivo")
   VERTXT(cARQNOME)
ENDIF
IF MDG("Deseja imprimir o Arquivo")
   imparq(cARQNOME,,,,,,,200,)
ENDIF


RETU(.T.)



FUNC FOCITAU
PARA COMPARE
cARQNOME := "ITAU.TXT"+SPACE(20)
cCGC     := TIRACX(CGC1,14,,"")
cNOMEMP  := TIRACX(MSG2,30)
cPESSOA  := ZPESSOA
SET CENTURY ON
cDATA    := TIRACX(DATE(),8,,"")
mDATAPG   := TIRACX(DATE(),8,,"")
SET CENTURY OFF
cTIME    := TIRACX(TIME(),6,,"")
nAGENCIA := 0
nCONTA   := 0
nDAC     :=0
mCEP      := strtran( CEP1, "-", "" )
mCIDADE   := TIRACX( CID1, 20,,"" )
mESTADO   := EST1


IF ! NETUSE("BCOFGTS") 
   RETU .F.
ENDIF
DBGOTOP()
IF ! DBSEEK(NREMP)
   DBCLOSEALL()
   ALERTX("Falta Cadastro Detalhes Empresa")
   RETU
ENDIF
mEND:=TIRACX(ENDERECO,30,,"")
mNUM:=STRZERO(VAL(NUMEROEMP),5)
mCOM:=TIRACX(COMPLEMEN,15,,"")
DBCLOSEAREA()


HB_DISPBOX( 5, 0,23,79,B_DOUBLE+" ")
@  6,  2 SAY "Arquivo           :"
@  7,  2 SAY "CGC Empresa       :"
@  8,  2 SAY "Agencia Conta     :"
@  9,  2 SAY "Nome da Empresa   :"
@ 10,  2 SAY "Data Hora Gera‡Æo :"
@ 11,  2 SAY "Endereco N§ Comp  :"
@ 12,  2 SAY "UF Cidade  CEP    :"
@ 13,  2 SAY "Data Prv. Pagmto. :"
@  6, 23 GET cARQNOME
@  7, 23 GET cPESSOA
@  7, 25 GET cCGC
@  8, 23 GET nAGENCIA PICT "99999"
@  8, 30 GET nCONTA PICT "999999999999"
@  8, 45 GET nDAC PICT "9"
@  9, 23 GET cNOMEMP
@ 10, 23 GET cDATA
@ 10, 33 GET cTIME
@ 11, 23 get mEND
@ 11, 54 GET mNUM
@ 11, 60 GET mCOM
@ 12, 23 GET mESTADO PICTURE "!!" VALID CHECKTAB(PADR("UF",4)+PADR(mESTADO,5),24,0,"Estado N„o Cadastrado")
@ 12, 26 GET mCIDADE VALID CHECKCID(mESTADO,mCIDADE,.T.)
@ 12, 47 GET mCEP    VALID CHKUFCEP(mCEP,mESTADO)
@ 13, 23 GET mDATAPG
READCUR()
nHANDLE  := FCREATE(ALLTRIM(cARQNOME))
IF FERROR()#0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF


//Header Arquivo
FWRITE(nHANDLE,"341")
FWRITE(nHANDLE,"0000")
FWRITE(nHANDLE,"0")
FWRITE(nHANDLE,SPACE(6))
FWRITE(nHANDLE,"040")
FWRITE(nHANDLE,IF(cPESSOA="J","2","1"))
FWRITE(nHANDLE,cCGC)
FWRITE(nHANDLE,SPACE(20))
FWRITE(nHANDLE,STRZERO(nAGENCIA,5))
FWRITE(nHANDLE," ")
FWRITE(nHANDLE,STRZERO(nCONTA,12))
FWRITE(nHANDLE," ")
FWRITE(nHANDLE,STRZERO(nDAC,1))
FWRITE(nHANDLE,cNOMEMP)
FWRITE(nHANDLE,PADR("BCO ITAU SA",30))
FWRITE(nHANDLE,SPACE(10))
FWRITE(nHANDLE,"1") //Remessa
FWRITE(nHANDLE,cDATA)
FWRITE(nHANDLE,cTIME)
FWRITE(nHANDLE,REPL("0",9))
FWRITE(nHANDLE,REPL("0",5))
FWRITE(nHANDLE,SPACE(69))
FWRITE(nHANDLE,hb_osnewline())

//Header Lote
FWRITE(nHANDLE,"341")
FWRITE(nHANDLE,"0001") //Lote
FWRITE(nHANDLE,"1")
FWRITE(nHANDLE,"C")
FWRITE(nHANDLE,"30")
FWRITE(nHANDLE,"01") //Credito
FWRITE(nHANDLE,"030")
FWRITE(nHANDLE," ")
FWRITE(nHANDLE,IF(cPESSOA="J","2","1"))
FWRITE(nHANDLE,cCGC)
FWRITE(nHANDLE,SPACE(20))
FWRITE(nHANDLE,STRZERO(nAGENCIA,5))
FWRITE(nHANDLE," ")
FWRITE(nHANDLE,STRZERO(nCONTA,12))
FWRITE(nHANDLE," ")
FWRITE(nHANDLE,STRZERO(nDAC,1))
FWRITE(nHANDLE,cNOMEMP)
FWRITE(nHANDLE,SPACE(30))
FWRITE(nHANDLE,SPACE(10))
FWRITE(nHANDLE,mEND)
FWRITE(nHANDLE,mNUM)
FWRITE(nHANDLE,mCOM)
FWRITE(nHANDLE,mCIDADE)
FWRITE(nHANDLE,mCEP)
FWRITE(nHANDLE,mESTADO)
FWRITE(nHANDLE,SPACE(8))
FWRITE(nHANDLE,SPACE(10))
FWRITE(nHANDLE,hb_osnewline())

nSEQ:=0
nVAL:=0
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   PETELA(08)
   IF BANCO#"341"   //Checar Codigo Banco
      DBSKIP()
      LOOP
   ENDIF
//   IF ! VALCPF(CPF) //Checar CPF
//      DBSKIP()
//      LOOP
//   ENDIF
   IF ! CHECKCTA(BANCO,AGENCIA,CONTA)  //Checar Conta
      DBSKIP()
      LOOP
   ENDIF
   IF &COMPARE
      NUM      := NUMERO
      cNOME    := TIRACX(NOME,30)
      cCONTA :="0"
      cDAC   :="0"
      nPOS:= AT("-",CONTA)
      IF nPOS>0
         cCONTA   :=LEFT(CONTA,nPOS-1)
         cDAC     :=substr(CONTA,nPOS+1,1)
      ENDIF
      DBSELECTAR(cSELE1)
      LIQ =VALCTA(NUM,CTACRE)-VALCTA(NUM,CTADEB)
      LIQ+=IF(lVALE.OR.SOMAVALE,VALCTA(NUM,997)-VALCTA(NUM,442),0)
      IF SOMAVALE
         LIQ+=VALCTA(NUM,41)-VALCTA(NUM,501)
      ENDIF
      LIQ=IF(ATUALIZA#1,ROUND(LIQ*ATUALIZA,2),LIQ)
      DBSELECTAR(cSELE2)
      IF LIQ>0.AND.VAL(cCONTA)#0
         nSEQ++
         nVAL+=LIQ
         cLIQ:=STRZERO(LIQ,16,2) //15+2+1"."
         cLIQ=STRTRAN(cLIQ,".","")
         FWRITE(nHANDLE,"341")
         FWRITE(nHANDLE,"0001") //Lote
         FWRITE(nHANDLE,"3")
         FWRITE(nHANDLE,STRZERO(nSEQ,5))
         FWRITE(nHANDLE,"A")
         FWRITE(nHANDLE,"000") //iNCLUSAO
         FWRITE(nHANDLE,"000")
         FWRITE(nHANDLE,"341")
         FWRITE(nHANDLE,STRZERO(VAL(AGENCIA),5))
         FWRITE(nHANDLE," ")
         FWRITE(nHANDLE,STRZERO(VAL(cCONTA),12))
         FWRITE(nHANDLE," ")
         FWRITE(nHANDLE,cDAC)
         FWRITE(nHANDLE,cNOME)
         FWRITE(nHANDLE,SPACE(20))
         FWRITE(nHANDLE,mDATAPG)
         FWRITE(nHANDLE,"009")   //Real
         FWRITE(nHANDLE,REPL("0",15))
         FWRITE(nHANDLE,cLIQ)
         FWRITE(nHANDLE,SPACE(15))
         FWRITE(nHANDLE,SPACE(5))
         FWRITE(nHANDLE,REPL("0",8))
         FWRITE(nHANDLE,REPL("0",15))
         FWRITE(nHANDLE,SPACE(18))
         FWRITE(nHANDLE,SPACE(2))
         FWRITE(nHANDLE,REPL("0",6))
         FWRITE(nHANDLE,REPL("0",14))
         FWRITE(nHANDLE,SPACE(12))
         FWRITE(nHANDLE,"0") //Nao Emite Aviso
         FWRITE(nHANDLE,SPACE(10))
         FWRITE(nHANDLE,hb_osnewline())
      ENDIF
    ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO





//Header Lote
cVAL:=STRZERO(nVAL,19,2) //16+2+1"."=19
cVAL:=STRTRAN(cVAL,".","")
FWRITE(nHANDLE,"341")
FWRITE(nHANDLE,"0001") //Lote
FWRITE(nHANDLE,"5")
FWRITE(nHANDLE,SPACE(9))
FWRITE(nHANDLE,STRZERO(nSEQ+2,6))
FWRITE(nHANDLE,cVAL)
FWRITE(nHANDLE,REPL("0",18))
FWRITE(nHANDLE,SPACE(171))
FWRITE(nHANDLE,SPACE(10))
FWRITE(nHANDLE,hb_osnewline())

//Header Arquivo
FWRITE(nHANDLE,"341")
FWRITE(nHANDLE,"9999") //Lote
FWRITE(nHANDLE,"9")
FWRITE(nHANDLE,SPACE(9))
FWRITE(nHANDLE,"000001") //Lote
FWRITE(nHANDLE,STRZERO(nSEQ+4,6))
FWRITE(nHANDLE,SPACE(211))
FWRITE(nHANDLE,hb_osnewline())

FWRITE(nHANDLE,CHR(26))
FCLOSE(nHANDLE)


IF MDG("Deseja Ver o Arquivo")
   VERTXT(cARQNOME)
ENDIF
IF MDG("Deseja imprimir o Arquivo")
   imparq(cARQNOME,,,,,,,240,)
ENDIF

RETU .T.


*: FIM: FOCC.PRG
