*:*****************************************************************************
*:
*:  FOLIS_C2.PRG : Listar Sal rio Vari vel
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************
////#INCLUDE "COMANDO.CH"

function folis_c2
PARA CC
IF ! MDL('Listar Sal rio Vari vel',0)
   RETU
ENDIF

if ! NETUSE(carq) 
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

IF CC=0
   IF ! NETUSE("FO_VAR") 
      RETU
   ENDIF
ENDIF
IF CC=1
   IF ! NETUSE("FO_VBR") 
      RETU
   ENDIF
ENDIF
cSELE2:=ALIAS()
FILTRA='NUMERO=NUM'
FL=0
SET DEVI TO PRIN
CABVAR()
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   NUM=NUMERO
   NOM=NOME
   TOT=0
   DBSELECTAR(cSELE2)
   SET FILTER TO &FILTRA
   DBGOTOP()
   WHILE ! EOF()
      IF PROW()>56
         IMPFOL()
         CABVAR()
      ENDIF
      @ PROW()+1,00 SAY NUM
      @ PROW(),11 SAY SUBSTR(NOM,1,25)
      @ PROW(),38 SAY CONTA
      @ PROW(),45 SAY TIPO
      @ PROW(),50 SAY NIV13S
      @ PROW(),54 SAY HORAS PICT "###.##"
      @ PROW(),62 SAY VALOR PICT "###,###,###,###.##"
      TOT+=VALOR
      DBSELECTAR(cSELE2)
      DBSKIP()
   ENDDO
   IF TOT>0
      @ PROW()+1,62 SAY TOT PICT "###,###,###,###.##"
      @ PROW()+1,00 SAY REPL('-',80)
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()
@ PROW()+1,00 SAY REPL('-',80)
IMPFOL()
VIDEO()
IMPEND()
RETU

*!*****************************************************************************
*!
*!      Procedure: CABVAR
*!
*!    Chamado por: FOLIS_C2.PRG
*!
*!*****************************************************************************
PROC CABVAR
FL++
@ PROW()  ,00 SAY IMPCHR(cIMPTIT)+MSG2
@ PROW()+1,50 SAY TIME()
@ PROW()  ,60 SAY DATE()
@ PROW()  ,70 SAY 'FL. '+STRZERO(FL,4)
@ PROW()+1,00 SAY REPL('-',80)
@ PROW()+1,00 SAY IMPCHR(cIMPTIT)+ACENTO('Sal rio Vari vel')
@ PROW()+1,00 SAY REPL ('-',80)
@ PROW()+1,00 SAY ACENTO("N£mero     Nome"+SPAC(22)+"Conta Tipo N¡vel Horas   Valor")
@ PROW()+1,00 SAY REPL ('-',80)
RETU
*: FIM: FOLIS_C2.PRG
