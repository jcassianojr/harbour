*:*****************************************************************************
*:
*:
*: FOLIS_B6.PRG  : 13o. Salario Acumulado
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     13:40
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF ! MDL('Listar Ferias Provisao Acumulada',0)
   RETU
ENDIF

lANAL:=MDG("Deseja Analitico")
aXCON:=PEGRELCTA("PROVFE")


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

IF ! netuse("PROVFE") 
   DBCLOSEALL()
   RETU .F.
ENDIF

LISTARUE({|X| FORESB6(X)})


FUNC FORESB6A
FL++
@ 1,  1 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
@ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
@ 3, 90 SAY TIME()
@ 3,100 SAY 'DATA '+DTOC(DXDIA)
@ 3,120 SAY 'FL. '+STRZERO(FL,4)
@ 4, 00 SAY IMPCHR(cIMPTIT)+ACENTO('PROVISŽO DE FERIAS: '+ALLTRIM(NOMSETOR))
@ 5, 0 SAY "MES"
@ 5, 4 SAY "ANO"
@ 5, 7 SAY "AVO"
@ 5,11 SAY "DIA"
@ 5,15 SAY "Comp"
@ 5,23 SAY "Salario+Var."
@ 5,41 SAY "VALOR"
@ 5,55 SAY "1/3"
@ 5,69 SAY "ENCAR."
@ 5,83 SAY "TOTAL"
@ 5,97 SAY "PAGO"
@ 6,  0 SAY REPL('-',132)
CTLIN:=7
RETU .T.

FUNCtion FORESB6
PARA COMPARE
aCOM:={}
aVAL:={}
aFUN:={}
TOTALIZA:=.F.
CTLIN=80
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      IF CTLIN > 55.AND.lANAL
         FORESB6A()
      ENDIF
      IF lANAL
         @ CTLIN,0 SAY REPL ('-',132)
         CTLIN++
         @ CTLIN,  0 SAY NUMERO
         @ CTLIN,  6 SAY NOME
         @ CTLIN, 36 SAY ADMITIDO
         CTLIN++
      ENDIF
      mNUMERO:=NUMERO
      AADD(aFUN,mNUMERO)
      DBSELECTAR("PROVFE")
      DBGOTOP()
      DBSEEK(STRZERO(mNUMERO,8))
      WHILE mNUMERO=NUMERO.AND. ! EOF()
         IF lANAL
            @ CTLIN, 0 SAY MES
            @ CTLIN, 3 SAY ANO
            @ CTLIN, 8 SAY AVOS
            @ CTLIN,11 SAY DIAS
            @ CTLIN,14 SAY COMP
            @ CTLIN,23 SAY SALARIO+SALVAR PICT '@E 99,999,999.99'
            @ CTLIN,37 SAY VALOR  PICT '@E 99,999,999.99'
            @ CTLIN,51 SAY VALTER PICT '@E 99,999,999.99'
            @ CTLIN,65 SAY VALENC PICT '@E 99,999,999.99'
            @ CTLIN,79 SAY VALTOT PICT '@E 99,999,999.99'
            CTLIN++
         ENDIF
         nPOS:=ASCAN(aCOM,STRZERO(ANO,4)+STRZERO(MES,2))
         IF nPOS>0
            aVAL[nPOS][1]+=VALOR
            aVAL[nPOS][2]+=VALTER
            aVAL[nPOS][3]+=VALENC
            aVAL[nPOS][4]+=VALTOT
         ELSE
            AADD(aCOM,STRZERO(ANO,4)+STRZERO(MES,2))
            AADD(aVAL,{VALOR,VALTER,VALENC,VALTOT})
         ENDIF
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IF TOTALIZA
   aANT:={0,0,0,0,0}
   CTLIN:=80
   FOR W=1 TO LEN(aCOM)
       VIDEO()
       nDESCONTA:=0
       cARQUSO:='FP'+EMP+RIGHT(aCOM[W],2)
       IF ! NETUSE(ARQUSO) //AREDE(cARQUSO,cARQUSO,1)
          DBCLOSEALL()
          RETU .F.
       ENDIF
       FOR Z=1 TO LEN(aFUN)
         FOR J=1 TO 15
            IF ! EMPTY(aXCON[W])
               DBGOTOP()
               IF DBSEEK(aFUN[Z]*10000+aXCON[J])
                  nDESCONTA+=VALOR
               ENDIF
             ENDIF
         NEXT W
       NEXT Z
       DBCLOSEAREA()
       IMPRESSORA()
       IF CTLIN>50
         FORESB6A()
       ENDIF
       @ CTLIN, 0 SAY RIGHT(aCOM[W],2)
       @ CTLIN, 4 SAY LEFT(aCOM[W],4)
       @ CTLIN,37 SAY aVAL[W][1] PICT '@E 99,999,999.99'
       @ CTLIN,51 SAY aVAL[W][2] PICT '@E 99,999,999.99'
       @ CTLIN,65 SAY aVAL[W][3] PICT '@E 99,999,999.99'
       @ CTLIN,79 SAY aVAL[W][4] PICT '@E 99,999,999.99'
       @ CTLIN,93 SAY nDESCONTA  PICT '@E 99,999,999.99'
       CTLIN++
       IF W#1
          @ CTLIN,0 SAY "Diferen‡a"
          @ CTLIN,37 SAY aVAL[W][1]-aANT[1] PICT '@E 99,999,999.99'
          @ CTLIN,51 SAY aVAL[W][2]-aANT[2] PICT '@E 99,999,999.99'
          @ CTLIN,65 SAY aVAL[W][3]-aANT[3] PICT '@E 99,999,999.99'
          @ CTLIN,79 SAY aVAL[W][4]-aANT[4] PICT '@E 99,999,999.99'
          CTLIN++
       ENDIF
       aANT[1]:=aVAL[W][1]
       aANT[2]:=aVAL[W][2]
       aANT[3]:=aVAL[W][3]
       aANT[4]:=aVAL[W][4]
   NEXT W
   IMPFOL()
ENDIF
RETURN

*: FIM: FOLIS_B6.PRG
