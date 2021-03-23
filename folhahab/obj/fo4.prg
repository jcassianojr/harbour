*:*****************************************************************************
*:
*:        FO4.PRG: Menu do Cadastro de Sal rios
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:18
*:
*:*****************************************************************************

#include "box.ch" 

Set( _SET_MESSAGE, 23 , .T. )
WHILE .T.
   HELPDBF="FO7"
   CABEX("Menu do Cadastro de Sal rios")
   MD()
   hb_DISPBOX(8,0,16,15,B_DOUBLE+" ")
   @ 10, 1 PROM " 1 - Reajuste " MESS "Calcula Reajuste de Salarios"
   @ 12, 1 PROM " 2 - Proje‡„o " MESS "Faz Estudo de Impacto de Reajuste"
   @ 14, 1 PROM " 3 - Listas   " MESS "Lista ou Exibe a Varia‡„o Salarial"
   @ 15, 1 PROM " 4 - Checagem " MESS "Checar Salarios Funcion rios"
   MENU TO KEY
   DO CASE
   CASE KEY=1 ; HELPDBF="FO41" ; FO41()
   CASE KEY=2 ; FO42()
   CASE KEY=3 ; FO43()
   CASE KEY=4 ; FO43D()
   OTHER      ; RETU
   ENDCASE
ENDDO

*!*****************************************************************************
*!
*!      Procedure: FO41
*!
*!*****************************************************************************
PROC FO41
WHILE .T.
   CABEX('Calculo de Reajuste Salarial')
   MD()
   HB_DISPBOX(8,16,15,33,B_DOUBLE+" ")
   @ 10,17 PROM " A - No Ano     " MESS 'Calcula novos sal rios entre meses'
   @ 11,17 PROM " B - Entre Anos " MESS 'Calcula sal rios entre dois anos'
   @ 12,17 PROM " C - Indexado   " MESS 'Calcula sal rios por media indexada'
   @ 13,17 PROM " D - Faixas I   " MESS 'Calcula sal rios pelo valor Faixas '
   @ 14,17 PROM " E - Faixas II  " MESS 'Calcula sal rios pelo Indice Faixas'
   MENU TO KEY2
   DO CASE
      CASE KEY2=1 ; FO41A(0)
      CASE KEY2=2 ; FO41A(1)
      CASE KEY2=3 ; FO41B()
      CASE KEY2=4 ; FO41C(0)
      CASE KEY2=5 ; FO41C(1)
      OTHERWISE   ; RETU
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!      Procedure: FO42
*!
*!*****************************************************************************
PROC FO42
WHILE .T.
   CABEX('Estudo de Reajuste Salarial')
   MD()
   HB_DISPBOX(8,16,21,34,B_DOUBLE+" ")
   @  9,17 PROM " A - Inciar      " MESS 'Apaga o estudo anterior e cria uma nova planila'
   @ 11,17 PROM " B - Alterar     " MESS 'Altera dados de proje‡„o de um funcion rio'
   @ 13,17 PROM " C - Consultar   " MESS 'Exibe no video o estudo de proje‡„o'
   @ 14,17 PROM " D - Imprimir    " MESS 'Lista o estudo de proje‡„o salarial'
   @ 16,17 PROM " E - Recalcular  " MESS 'Refaz os calculos da proje‡„o'
   @ 17,17 PROM " F - Taxa 1§ mˆs " MESS 'Altera taxas de proje‡„o do mes 1'
   @ 18,17 PROM " G - Taxa 2§ mˆs " MESS 'Altera taxas de proje‡„o do mes 2'
   MENU TO KEY2
   DO CASE
       CASE KEY2=1 ; FO42A()
       CASE KEY2=2 ; FO42B()
       CASE KEY2=3 ; FO42C()
       CASE KEY2=4 ; FO42D()
       CASE KEY2=5 ; FO42E(0)
       CASE KEY2=6 ; FO42E(1)
       CASE KEY2=7 ; FO42E(2)
   OTHER       ; RETU
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!      Procedure: FO43
*!
*!*****************************************************************************
PROC FO43
IMPHP()
WHILE .T.
   CABEX('Listar  Evolu‡„o Salarial')
   MD()
   HB_DISPBOX(8,16,18,30,B_DOUBLE+" ")
   @ 10,17 PROM " A - Anual   " MESS " Lista os Salarios de Todo o Ano "
   @ 12,17 PROM " B - Parcial " MESS " Lista Salarios de Alguns Meses "
   @ 14,17 PROM " C - Indices " MESS " Lista Salarios e Indices de Aumento "
   MENU TO KEY2
   DO CASE
      CASE KEY2=1 ; FO43X(0)
      CASE KEY2=2 ; FOTMES()
      CASE KEY2=3 ; FOTMES()
   OTHER          ; RETU
   ENDCASE
ENDDO
RETU



*!*****************************************************************************
*!
*!      Procedure: FOTMES
*!
*!*****************************************************************************
PROC FOTMES
DECLARE NO[5],ME[5]
MES01:=MES02:=MES03:=MES04:=MES05:=1
SETCOLOR("+N/GR")
HB_DISPBOX(08,00,20,78,B_DOUBLE+" ")
@ 12,21 SAY "Primeiro mˆs:"+SPAC(10)+CHR(26)
@ 13,21 SAY "Segundo  mˆs:"+SPAC(10)+CHR(26)
@ 14,21 SAY "Terceiro mˆs:"+SPAC(10)+CHR(26)
@ 15,21 SAY "Quarto   mˆs:"+SPAC(10)+CHR(26)
@ 16,21 SAY "Quinto   mˆs:"+SPAC(10)+CHR(26)
SETCOLOR("+N/W")
@ 08,00 SAY " - "
SETCOLOR("+W/R")
@ 08,03 SAY SPAC(22)+"Digite os meses para listagem"+SPAC(25)
HB_SCROLL(09,79,21,79)
@ 21,01 SAY SPAC(78)
@ 12,36 GET MES01 PICT "##" RANG 0,12
@ 13,36 GET MES02 PICT "##" RANG 0,12
@ 14,36 GET MES03 PICT "##" RANG 0,12
@ 15,36 GET MES04 PICT "##" RANG 0,12
@ 16,36 GET MES05 PICT "##" RANG 0,12
READCUR()
NO[1]=MES01
NO[2]=MES02
NO[3]=MES03
NO[4]=MES04
NO[5]=MES05
FOR X=1 TO 5
   @ 11+X,47 SAY IF(NO[X]#0,MMES(NO[X]),"")
   ME[X]=IF(NO[X]#0,'SAL'+SUBSTR(MMES(NO[X]),1,3),"")
NEXT X
SETCOLOR("W/N")
IF ! MDG('Tudo Ok podemos Listar')
   RETU
ENDIF
DO CASE
  CASE KEY2=2 ; FO43X(1)
  CASE KEY2=3 ; FO43Z()
ENDCASE
RETU


FUNC gFUNC(cFILTRO)
LOCAL aDESC,aFILT,nFIL,cTELA
IF VALTYPE(cFILTRO)#"C"
   cFILTRO:=""
ENDIF
aDESC:={' Ativos    ',' Todos     ',' Admit.mˆs ',' Demit.mˆs ',' Demitidos '}
aFILT:={'((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))',;
        '',;
        'MONTH(ADMITIDO)=MES.AND.YEAR(ADMITIDO)=ANO',;
        'MONTH(DEMITIDO)=MES.AND.YEAR(DEMITIDO)=ANO',;
        'DAY(DEMITIDO)#0'}
cTELA:=SAVESCREEN(07,32,13,45)
HB_DISPBOX(07,32,13,45,B_DOUBLE+" ")
NFIL=ACHOICE(08,33,12,44,aDESC)
RESTSCREEN(07,32,13,35,cTELA)
NFIL=IF(NFIL#0,NFIL,1)
cFILTRO=aFILT[NFIL]
RETU cFILTRO

*: FIM: FO4.PRG
