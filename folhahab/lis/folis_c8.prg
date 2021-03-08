*:*****************************************************************************
*:
*:   FOLIS_C8.PRG: DIRF
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

IF ! MDL('  D.  I.   R.   F.    ',0)
   RETU
ENDIF
IF ! MDG('Vocˆ j  acumulou')
   FOLIS_A5()
   RETU
ENDIF

UFIR=IF(MDG('Deseja em ufir'),.T.,.F.)
CENT=IF(MDG('Deseja cortar os Centavos'),.T.,.F.)

FL=0
MDS('Carregando dados da Empresa')
IF ! NETUSE("FIRMA") 
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(NREMP)   
   ENDER:=ENDERECO
   CIDAD:=CIDADE
   ESTAD:=ESTADO
   NRCGC:=CGC
   MSG2A:=COGNOME
ENDIF
DBCLOSEALL()

DECLARE MESES[13]
FOR X=1 TO 12
    MESES[X]=MMES(X)
NEXT X
MESES[13]='13o. Salario'


STORE SPAC(30) TO RESP
STORE SPAC(18) TO RESPCPF
STORE SPAC(10) TO RESPFONE
STORE SPAC(20) TO RESPLOCA
STORE DXDIA TO RESPDAT
@ 08,00 CLEA
SETCOLOR("+N/GR")
HB_dispbox( 8, 0, 23, 78,B_DOUBLE)
@ 11,04 SAY "Respons vel :"
@ 13,04 SAY "C.P.F."+SPAC(6)+":"
@ 15,04 SAY "Telefone    :"
@ 17,04 SAY "Local"+SPAC(7)+":"
@ 19,04 SAY "Emiss„o     :"
SETCOLOR("+N/W")
@ 08,00 SAY " - "
SETCOLOR("+W/R")
@ 08,03 SAY SPAC(17)+"Digite Dados Complementares Para a Dirf"+SPAC(20)
HB_SCROLL( 9, 79, 24, 79)
@ 24,01 SAY SPAC(78)
SETCOLOR("+N/GR")
@ 11,19 GET RESP
@ 13,19 GET RESPCPF
@ 15,19 GET RESPFONE
@ 17,19 GET RESPLOCA
@ 19,19 GET RESPDAT
READCUR()
SETCOLOR("W/N,N/W")


nACU:=IRRESC()
IF ! ARQIRR(nACU,1,3) //Shared Arede PES
   RETU .F.
ENDIF
cSELE1:=alias()


IF ! ARQIRR(nACU,1,1) //SHARED Arede ajudir
   DBCLOSEALL()
   RETU .F.
ENDIF
FILTRO=''
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO
cSELE2:=ALIAS()


TTVAL1:=TTVAL2:=TTVAL3:=0
QTDEFUN:=0
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   mCPF=CPF
   QTDEFUN++
   WHILE mCPF=CPF.AND. ! EOF()
      TTVAL1=TTVAL1+IF(UFIR,VALUF1,VALOR1)
      TTVAL2=TTVAL2+IF(UFIR,VALUF2,VALOR2)
      TTVAL3=TTVAL3+IF(UFIR,VALUF3,VALOR3)
      TTVAL1=IF(CENT,INT(TTVAL1),TTVAL1)
      TTVAL2=IF(CENT,INT(TTVAL2),TTVAL2)
      TTVAL3=IF(CENT,INT(TTVAL3),TTVAL3)
      DBSKIP()
   ENDDO
ENDDO
IMPRESSORA()
DBSELECTAR(cSELE2)
DBGOTOP()
WHILE ! EOF()
   FL++
   @ PROW(),20 SAY ' DIRF - Declaracao de Imposto Retido na Fonte'
   @ PROW(),20 SAY ' DIRF - Declaracao de Imposto Retido na Fonte'
   @ PROW()+1,60 SAY 'DATA =>'
   @ PROW(),68 SAY DXDIA
   @ PROW()+1,60 SAY '  fl =>'
   @ PROW(),68 SAY FL PICT '###'
   @ PROW()+1,1 SAY IMPCHR(cIMPTIT)
   @ PROW(),2 SAY MSG2A
   @ PROW()+1,1 SAY REPL('-',78)
   @ PROW()+1,0 SAY "Qtde Func.->"
   @ PROW(),13 SAY QTDEFUN PICT '##'
   @ PROW(),20 SAY "12=>"
   @ PROW(),23 SAY TTVAL1 PICT '###,###,###.##'
   @ PROW(),40 SAY "13=>"
   @ PROW(),43 SAY TTVAL2 PICT '###,###,###.##'
   @ PROW(),60 SAY "14=>"
   @ PROW(),63 SAY TTVAL3 PICT '###,###,###.##'
   @ PROW(),79 SAY '|'
   DBSELECTAR(cSELE2)
   CONTAR = 0
   WHILE ! EOF()
      CONTAR++
      IF CONTAR = 2
         CONTAR=0
         IMPFOL()
      ENDIF
      TVAL1:=TVAL2:=TVAL3:=0
      CTR:=NUMERO
      mCPF:=CPF
      DBSELECTAR(cSELE1)
      DBGOTOP()
      IF DBSEEK(CTR)
         @ PROW()+1,0 SAY '|'
         @ PROW(),1 SAY 'nro. do cpf:'
         @ PROW(),14 SAY CPF
         @ PROW(),14 SAY CPF
         @ PROW(),30 SAY 'nome =>'
         @ PROW(),36 SAY NOME
         @ PROW(),36 SAY NOME
         @ PROW(),79 SAY '|'
         @ PROW()+1,0 SAY REPL('=',80)
         @ PROW()+1,0 SAY '|'
         @ PROW(),20 SAY 'Rendimento Bruto'
         @ PROW(),45 SAY 'Deducoes'
         @ PROW(),56 SAY 'Imposto Retido  Fonte'
         DBSELECTAR(cSELE2)
         FOR X=1 TO 13
             @ PROW()+1,0 SAY '|'
             @ PROW(),1 SAY MESES[X]
             IF CPF = mCPF
                IF MES = X
                   IF UFIR
                      @ PROW(),20 SAY IF(CENT,INT(VALUF1),VALUF1) PICT '###,###,###.##'
                      @ PROW(),40 SAY IF(CENT,INT(VALUF2),VALUF2) PICT '###,###,###.##'
                      @ PROW(),60 SAY IF(CENT,INT(VALUF3),VALUF3) PICT '###,###,###.##'
                   ELSE
                      @ PROW(),20 SAY IF(CENT,INT(VALOR1),VALOR1) PICT '###,###,###.##'
                      @ PROW(),40 SAY IF(CENT,INT(VALOR2),VALOR2) PICT '###,###,###.##'
                      @ PROW(),60 SAY IF(CENT,INT(VALOR3),VALOR3) PICT '###,###,###.##'
                   ENDIF
                   TVAL1=TVAL1+IF(UFIR,VALUF1,VALOR1)
                   TVAL2=TVAL2+IF(UFIR,VALUF2,VALOR2)
                   TVAL3=TVAL3+IF(UFIR,VALUF3,VALOR3)
                   TVAL1=IF(CENT,INT(TVAL1),TVAL1)
                   TVAL2=IF(CENT,INT(TVAL2),TVAL2)
                   TVAL3=IF(CENT,INT(TVAL3),TVAL3)
                   DBSKIP()
                ENDIF
             ENDIF
             @ PROW(),79 SAY '|'
         NEXT
         @ PROW()+1,0 SAY REPL('=',80)
         @ PROW()+1,0 SAY '|'
         @ PROW(),1 SAY 'TOTAL ........'
         @ PROW(),20 SAY TVAL1 PICT '###,###,###.##'
         @ PROW(),40 SAY TVAL2 PICT '###,###,###.##'
         @ PROW(),60 SAY TVAL3 PICT '###,###,###.##'
         @ PROW(),79 SAY '|'
         @ PROW()+1,0 SAY REPL('=',80)
         IF CONTAR = 1
            @ PROW()+1,1 SAY "Responsavel pelo Preenchimento"
            @ PROW()+1,0 SAY REPL('-',80)
            @ PROW()+1,0 SAY '|'
            @ PROW(),5 SAY RESP+' '+'cpf:'+respcpf+' '+respfone
            @ PROW(),79 SAY '|'
            @ PROW()+1,0 SAY '|'
            @ PROW(),5 SAY RESPLOCA
            @ PROW(),30 SAY 'data:'
            @ PROW(),38 SAY respdat
            @ PROW(),79 SAY '|'
            @ PROW()+1,0 SAY REPL('=',80)
         ENDIF
         IF ! EOF()
            IF CPF = mCPF
               DBSKIP()
            ENDIF
            IF CONTAR > 3
               EXIT
            ENDIF
         ENDIF
      ENDIF
   ENDDO
ENDDO
IMPFOL()
VIDEO()
DBCLOSEALL()
IMPEND()
RETU

*: FIM: FOLIS_C8.PRG
