*:*****************************************************************************
*:
*:      FO42D.PRG: Nome do Programa
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     14:55
*:
*:*****************************************************************************

IMPHP()


PARA CC
IF ! MDL('Listar Projecao Salarial',0)
   RETU
ENDIF
POS1=SPAC(40)
MDS('Digite Cabe‡ario Complementar')
@ 24,35 GET POS1
IF ! READCUR()
   RETU .F.
ENDIF

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

IF ! netuse("FO_PSL") 
   DBCLOSEALL()
   RETU
ENDIF

LISTARUE({|X| FO42K(X)})

dbcloseall()

*!*****************************************************************************
*!
*!         Fun‡„o: FO42K()
*!
*!*****************************************************************************
FUNC FO42K
PARA COMPARE
STORE 0 TO SALTOT1,SALTOT2,SALTOT3,QTFUN
CTLIN=80
dbselectar(pes)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      mNUMERO:=NUMERO
      dbselectar("fo_psl")
      DBGOTOP()
      IF DBSEEK(mNUMERO)
          IF CTLIN > 55
            FL++
            @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(Cimpcom),IMPstr(Cimpexp))
            @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
            @ 3, 18 SAY IMPCHR(cIMPTIT)+'PROJECAO SALARIAL '+NOMSETOR
            @ 5,  0 SAY POS1
            @ 5,100 SAY TIME()
            @ 5,110 SAY DATE()
            @ 5,120 SAY 'FL. '+STRZERO(FL,4)
            @ 6,  0 SAY REPL('-',132)
            @ 7,  0 SAY 'NUM'
            @ 7,  7 SAY 'NOME'
            @ 7, 38 SAY 'ADMISSAO'
            @ 7, 49 SAY 'FUNCAO'
            @ 7, 70 SAY "SALARIO INICIAL"+SPAC(9)+"SALARIO MES 1"+SPAC(10)+"SALARIO MES2"
            @ 8,  0 SAY REPL('-',132)
            CTLIN=9
         ENDIF
         @ CTLIN,  0 SAY NUMERO
         @ CTLIN,  7 SAY NOME
         @ CTLIN, 40 SAY ADMITIDO
         @ CTLIN, 49 SAY FUNCAO
         @ CTLIN, 70 SAY SALANT PICT '###,###,###.##'
         @ CTLIN, 87 SAY TAXA1  PICT '##.##%'
         @ CTLIN, 94 SAY SALATU PICT '###,###,###.##'
         @ CTLIN,110 SAY TAXA2  PICT '##.##%'
         @ CTLIN,117 SAY SALPRO PICT '###,###,###.##'
         SALTOT1+=SALTOT1
         SALTOT2+=SALTOT2
         SALTOT3+=SALTOT3
         QTFUN++
         CTLIN++
      ENDIF
   ENDIF
   dbselectar(pes)
   DBSKIP()
ENDDO
IF QTFUN>0
    @ PROW()+1, 0 SAY REPL('-',132)
    @ PROW()+1,20 SAY 'Quantidade de Funcionarios --> '
    @ PROW()  ,53 SAY QTFUN PICTURE '###'
    @ PROW()+1,20 SAY 'Total Mes Incial'
    @ PROW()  ,70 SAY SALTOT1 PICT '#,###,###,###.##'
    @ PROW()+1,20 SAY 'Total 1o. Mes'
    @ PROW()  ,70 SAY SALTOT2 PICT '#,###,###,###.##'
    @ PROW()+1,20 SAY 'Total 2o. Mes'
    @ PROW()  ,70 SAY SALTOT3 PICT '#,###,###,###.##'
    IMPFOL()
ENDIF

*: FIM: FO42D.PRG
