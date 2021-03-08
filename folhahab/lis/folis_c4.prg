*:*****************************************************************************
*:
*:   FOLIS_C4.PRG: Lan‡amento de uma Conta
*:       Liguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF ! MDL('Listar Lan‡amento de uma Conta',0)
   RETU
ENDIF

//Variaveis de Trabalho
FL:=CTA:=0
cPLANILHA:=SPACE(8)
aCON :={}
CTLIN:=80
dINI:=dFIM:=ZDATA
@ 23,00 CLEA
@ 23,00 SAY "Digite o Periodo"
@ 24,00 SAY "Digite o Nome da Planilha ou a conta"
@ 23,20 GET dINI
@ 23,30 GET dFIM
@ 24,40 GET cPLANILHA
@ 24,50 GET CTA
IF ! READCUR()
   RETU .F.
ENDIF



aXCON:={CTA}

IF ! EMPTY(cPLANILHA)
   aXCON:=PEGRELCTA(cPLANILHA)
ENDIF


IF ! NETUSE("CONTAS") 
   DBCLOSEALL()
   RETU .F.
ENDIF
FOR W=1 TO LEN(aXCON)
    CTA:=aXCON[W]
    IF ! EMPTY(CTA)
       DBGOTOP()
       DBSEEK(CTA)
       IF ! FOUND()
          DBCLOSEALL()
          ALERTX('Conta n„o Cadastrada: '+STR(CTA))
          RETU
       ELSE
          AADD(aCON,{CTA,DESCR,TIPO})
       ENDIF
    ENDIF
NEXT W
DBCLOSEALL()

IF LEN(aCON)=0
   ALERTX('Nenhuma conta Selecionada')
   RETU .F.
ENDIF




ARQ:={}
nINIANO:=YEAR(dINI)
nFIMANO:=YEAR(dFIM)
FOR J=nINIANO TO nFIMANO
    PATH1='\FOLHA\EMP'+ANOSTR(J)+STRZERO(NREMP,3)+'\'+SPAC(20)
    MDS('Confirme localiza‡„o Arquivos de:'+STR(J,4))
    @ 24,45 GET PATH1
    IF ! READCUR()
       RETU .F.
    ENDIF
    PATH1=ALLTRIM(PATH1)
    DO CASE
       CASE nINIANO=nFIMANO
            nMESINI=MONTH(dINI)
            nMESFIM=MONTH(dFIM)
       CASE nINIANO=J
            nMESINI=MONTH(dINI)
            nMESFIM=12
       CASE nFIMANO=J
            nMESINI=1
            nMESFIM=MONTH(dFIM)
    ENDCASE
    FOR W=nMESINI TO nMESFIM
        cARQ:=PATH1+if(NRSEN="DiReT","SO","FP")+EMP+STRZERO(W,2)
        INFOR(cARQ,"CONTROLE",cARQ,.T.)
        AADD(ARQ,{cARQ,J,W})
    NEXT W
NEXT J

lTABULAR:=MDG("Deseja Tabular")

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
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


IMPRESSORA()
IF lTABULAR
   FOLISC41()
   RETU
ENDIF

DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   NUM=NUMERO
   NOM=NOME
   CTLIN:=80 //Salta Cada Funcionario
   FOR W=1 TO LEN(aCON)
       aVAL:={0,0}
       lCON:=.T.
       lLIS:=.F.
       nCOL:=0
       BUSCA=(NUM*10000)+aCON[W][1]
       FOR X=1 TO LEN(ARQ)
          ARQUIVO=ARQ[X][1]
          VIDEO()
          IF ! NETUSE(ARQUIVO) //AREDE(ARQUIVO,ARQUIVO,1)
             DBCLOSEALL()
             RETU .F.
          ENDIF
          IMPRESSORA()
          DBGOTOP()
          IF DBSEEK(BUSCA)
             aVAL[1]+=HORAS
             aVAL[2]+=VALOR
             lLIS:=.T.
             IF CTLIN>50.AND.nCOL=0
                IF CTLIN#80
                   IMPFOL()
                ENDIF
                FL++
                @ 0,00 SAY IMPCHR(cIMPTIT)+MSG2
                @ 1,50 SAY TIME()
                @ 1,60 SAY DATE()
                @ 1,70 SAY 'FL. '+STRZERO(FL,4)
                @ 2,00 SAY REPL('-',80)
                @ 3,00 SAY IMPCHR(cIMPTIT)
                @ 3,00 SAY NUM
                @ 3,07 SAY ACENTO(NOM)
                @ 4,01 SAY "Horas"
                @ 4,17 SAY "Valor"
                @ 4,26 SAY "Competencia"
                @ 4,41 SAY "Horas"
                @ 4,57 SAY "Valor"
                @ 4,66 SAY "Competencia"
                @ 5,00 SAY REPL('-',80)
                CTLIN:=5
                lCON:=.T.
             ENDIF
             IF lCON
                CTLIN++
                @ CTLIN   ,00 SAY ACENTO(IMPSTR(cIMPCOM)+IMPCHR(cIMPTIT)+'Lan‡amentos da Conta: '+STR(aCON[W][1],3)+' - '+aCON[W][2]+IMPSTR(cIMPEXP))
                CTLIN++
                @ CTLIN  ,00 SAY "Periodo: "+DTOC(dINI)+" a "+DTOC(dFIM)
                CTLIN++
                @ CTLIN ,00 SAY REPL('-',80)
                lCON=.F.
             ENDIF
             IF nCOL=0
                CTLIN++
                IF HORAS>0
                   @ CTLIN  , 0 SAY HORAS PICT "###.##"
                ENDIF
                @ CTLIN  , 8 SAY VALOR PICT "###,###,###.##"
                @ CTLIN  ,23 SAY ACENTO(MMES(ARQ[X][3]))
                @ CTLIN  ,33 SAY STR(ARQ[X][2],4)
                nCOL=40
             ELSE
                IF HORAS>0
                   @ CTLIN,  40 SAY HORAS PICT "###.##"
                ENDIF
                @ CTLIN,  48 SAY VALOR PICT "###,###,###.##"
                @ CTLIN,  63 SAY ACENTO(MMES(ARQ[X][3]))
                @ CTLIN,  73 SAY STR(ARQ[X][2],4)
                nCOL=0
             ENDIF
          ENDIF
          DBCLOSEAREA()
       NEXT X
       IF lLIS
          CTLIN++
          @ CTLIN, 00 SAY "Totais"
          IF aVAL[1]>0
             @ CTLIN, 10 SAY "Hora"
             @ CTLIN, 20 SAY aVAL[1] PICT "@E 99,999,999.99"
          ENDIF
          @ CTLIN, 40 SAY "Valor"
          @ CTLIN, 50 SAY aVAL[2] PICT "@E 99,999,999.99"
          CTLIN++
          @ CTLIN ,00 SAY REPL('=',80)
       ENDIF
   NEXT W
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()

IMPFOL()
VIDEO()
IMPEND()

RETU


*!*****************************************************************************
*!
*!         Fun‡„o: ANOSTR()
*!
*!*****************************************************************************
FUNC ANOSTR(XANO)
RETU SUBSTR(STRZERO(XANO,4),3,2)

FUNC FOLISC41
nLIM:=IF(LEN(aCON)>5,5,LEN(aCON))
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   NUM=NUMERO
   NOM=NOME
   lLIS:=.F.
   lFUN:=.T.
//   CTLIN:=80 //Salta Cada Funcionario
   aVAL:=ARRAY(nLIM)
   AFILL(aVAL,0)
   FOR X=1 TO LEN(ARQ)
       ARQUIVO=ARQ[X][1]
       VIDEO()
       //SELE 2
       IF ! NETUSE(ARQUIVO) //AREDE(ARQUIVO,ARQUIVO,1)
           DBCLOSEALL()
           RETU .F.
       ENDIF
       IMPRESSORA()
       IF CTLIN>50
          IF CTLIN#80
             IMPFOL()
          ENDIF
          FL++
          @ 0,00 SAY IMPCHR(cIMPTIT)+MSG2
          @ 1,50 SAY TIME()
          @ 1,60 SAY DATE()
          @ 1,70 SAY 'FL. '+STRZERO(FL,4)
          @ 2,01 SAY "Comp."
          FOR W=1 TO nLIM
              @ 2,W*12+5 SAY aCON[W][1] PICT "999"
          NEXT W
          @ 3,00 SAY REPL('-',80)
          CTLIN:=4
       ENDIF
       aVALX:=ARRAY(nLIM)
       AFILL(aVALX,0)
       aHORX:=ARRAY(nLIM)
       AFILL(aHORX,0)
       lTEM :=.F.
       FOR W=1 TO nLIM
          DBGOTOP()
          DBSEEK((NUM*10000)+aCON[W][1])
          IF FOUND()
             lLIS:=.T.
             lTEM:=.T.
             aVALX[W]:=VALOR
             aHORX[W]:=HORAS
          ENDIF
       NEXT W
       IF lTEM
          IF lFUN
             @ CTLIN,00 SAY IMPCHR(cIMPTIT)
             @ CTLIN,00 SAY NUM
             @ CTLIN,07 SAY ACENTO(NOM)
             CTLIN++
             @ CTLIN,00 SAY REPL('-',80)
             CTLIN++
             lFUN:=.F.
          ENDIF
          @ CTLIN,  0 SAY LEFT(ACENTO(MMES(ARQ[X][3])),3)+"/"+STR(ARQ[X][2],4)
          FOR W=1 TO nLIM
              IF aCON[W][3]=0.OR.aCON[W][3]=2
                 @ CTLIN,W*12-4 SAY aVALX[W] PICT "@E 99999,999.99"
                 aVAL[W]+=aVALX[W]
              ELSE
                 @ CTLIN,W*12-3 SAY aHORX[W] PICT "@E 99999,999.99"
                 aVAL[W]+=aHORX[W]
              ENDIF
          NEXT W
          CTLIN++
       ENDIF
       DBCLOSEAREA()
   NEXT X
   IF lLIS
      @ CTLIN ,00 SAY REPL('=',80)
      CTLIN++
      @ CTLIN,0 SAY "Totais"
      CTLIN++
      FOR W=1 TO nLIM
          @ CTLIN, 0 SAY aCON[W][1] PICT "999"
          @ CTLIN, 5 SAY aCON[W][2]
          @ CTLIN,50 SAY aVAL[W] PICT "@E 99999,999.99"
          IF aCON[W][3]=0.OR.aCON[W][3]=2
             @ CTLIN, 70 SAY "Valor"
          ELSE
             @ CTLIN, 70 SAY "Hora"
          ENDIF
          CTLIN++
      NEXT W
      CTLIN++
      @ CTLIN ,00 SAY REPL('=',80)
      CTLIN++
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IMPFOL()
VIDEO()
DBCLOSEALL()
IMPEND()
RETU .T.

*: FIM: FOLIS_C4.PRG
