*:*****************************************************************************
*:
*:      FOE2A.PRG: Exibir Mapa de Distribuicao de Cedulas
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 30/06/98
*:
*:*****************************************************************************
#INCLUDE "BOX.CH"

function foe2a
PARA PP
IF PP=6
   FOCG()
   RETU
ENDIF

lVALE:=.F.
CC=399
CD=999
IF PP=10
   CC=445
   CD=527
ENDIF
IF PP=9
   CC=41
   CD=501
   lVALE:=.T.
ENDIF


IF PP=9.OR.PP=10 //Abre Arquivo Folha
   PP=1
ENDIF

MDS("Confirme Contas Credito Debito")
@ 24,40 GET CC PICT "999"
@ 24,50 GET CD PICT "999"
IF ! READCUR()
   RETU .F.
ENDIF



IF ! ARQUSAR(PP,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1:=ALIAS()


IF ! ARQPES(PP,1,1)
   DBCLOSEALL()
   RETU
ENDIF
cSELE2:=ALIAS()

FILTRO='((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO

DECLARE NOTAS[12],QTDE[12]
IF ! netuse("TABTROCO") //BREDE("TABTROCO",1)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
FOR X=1 TO 12
    NOTAS[X]=DESCT
    DBSKIP()
NEXT X
AFILL(QTDE,0)
HB_DISPBOX(04,00,24,79,B_DOUBLE+" ")
@ 04,09 SAY "-"+REPL('-',51)+"-"
@ 5, 2 SAY "N£mero Ý Nome do Funcionario"+SPAC(31)+"Ý  Valor a Pagar"
@ 6,00 SAY 'Ç'+REPL('-',8)+"+"+REPL('-',51)+"+"+REPL('-',17)+'¶'
FOR X=7 TO 18
    @ X,09 SAY "Ý"+SPAC(51)+"Ý"
NEXT X
@ 19,00 SAY 'Ç'+REPL('-',8)+"-"+REPL('-',2)+"-"+REPL('-',10)+"-"+REPL('-',10)+"-"+REPL('-',10)+"-"+REPL('-',10)+"-"+REPL('-',4)+"-"+REPL('-',5)+"-"+REPL('-',11)+'¶'
@ 20,12 SAY "Ý"+SPAC(10)+"Ý"+SPAC(10)+"Ý"+SPAC(10)+"Ý"+SPAC(10)+"Ý"+SPAC(10)+"Ý"
@ 21,02 SAY "x"+SPAC(9)+"Ýx"+SPAC(9)+"Ýx"+SPAC(9)+"Ýx"+SPAC(9)+"Ýx"+SPAC(9)+"Ýx"+SPAC(9)+"Ýx"
@ 22,00 SAY 'Ç'+REPL('-',11)+"-"+REPL('-',9)+"--"+REPL('-',10)+"-"+REPL('-',2)+"-"+REPL('-',7)+"-"+REPL('-',10)+"-"+REPL('-',4)+"-"+REPL('-',5)+"-"+REPL('-',11)+'¶'
@ 23,02 SAY "Funcionarios :"+SPAC(6)+"Ý Continua :   Ý Resto :"+SPAC(15)+"Ý"
@ 24,22 SAY "-"+REPL('-',14)+"-"+REPL('-',23)+"-"
FOR X=1 TO 7
    COL=(X*11)-9
    @ 20,COL SAY NOTAS[X] PICT '######.##'
NEXT X

LIN=6
QFTUN:=TOTAL:=RESTO:=0
CONT='S'
QTFUN=0
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   NUM=NUMERO
   CRE:=DEB:=LIQ:=0
   IF LIN>17
      INKEY(0)
      IF LASTKEY()=27
         DBCLOSEALL()
         RETU
      ENDIF
      LIN=6
      @ 07,00 CLEA TO 18,79
      FOR X = 7 TO 18
          @ X,00 SAY 'Ý'+REPL(' ',8)+"+"+REPL(' ',51)+"+"+REPL(' ',17)+'Ý'
      NEXT X
   ENDIF
   LIN++
   QTFUN++
   @ LIN,02 SAY NUMERO PICTURE "######"
   @ LIN,11 SAY NOME
   DBSELECTAR(cSELE1)
   CRE=VALCTA(NUM,CC)+IF(lVALE,VALCTA(NUM,997),0)
   DEB=VALCTA(NUM,CD)+IF(lVALE,VALCTA(NUM,442),0)
   LIQ=CRE-DEB
   TOTAL+=LIQ
   @ LIN,64 SAY LIQ PICT "###,###,###.##"
   FOR X= 1 TO 12
       COL=(X*11)-3
       IF NOTAS[X]#0
          IF LIQ>NOTAS[X].OR.LIQ=NOTAS[X]
             QTNOTA:=0
             WHILE LIQ>=NOTAS[X]
                QTNOTA++
                LIQ-=NOTAS[X]
             ENDDO
             QTDE[X]+= QTNOTA
          ENDIF
       ENDIF
       IF X<8
          @ 21,COL SAY QTDE[X] PICTURE '####'
       ENDIF
   NEXT X
   RESTO+=LIQ
   @ 23,17 SAY QFTUN PICTURE "####"
   @ 23,48 SAY RESTO PICTURE "###,###,###.##"
   @ 23,64 SAY TOTAL PICTURE "###,###,###.##"
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
INKEY(0)
SOMA=0
HB_DISPBOX(04,00,24,79,B_DOUBLE+" ")
FOR X=1 TO 12
    @ X+5,2  SAY QTDE[X] PICT "#####"
    @ X+5,10 SAY NOTAS[X] PICT "###,###,###,###.##"
    @ X+5,50 SAY QTDE[X]*NOTAS[X] PICT "###,###,###,###.##"
NEXT X
INKEY(0)
DBCLOSEALL()
RETU

*: FIM: FOE2A.PRG