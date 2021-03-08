*:*****************************************************************************
*:
*:  FORES_B2.PRG : Listar Planilha de F‚rias Completa
*:     Linguagem : Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/26/94      9:02
*:
*:  Procs & Fncts: FORES_B2()
*:               : CABB2
*:               : CABB22
*:
*:          Chama: MDL()              (fun‡„o    em FORESP.PRG)
*:               : CABB2              (processo  em FORES_B2.PRG)
*:               : CABB22             (processo  em FORES_B2.PRG)
*:
*:    Arq. Dados : FO_FER - Remanejamento de Ferias
*:
*:        Indices: &MTEMP
*:                 FER        CODIGO DO FUNCIONARIO
*:                            CONTROLE
*:
*:     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF ! MDL('Listar Planilha de Ferias Completa',0)
   RETU
ENDIF
FILTRA=IF(MDG('Deseja Excluir Periodos ja  baixados'),"NUMERO=VAR3.AND.BAIXADO#'S'","NUMERO=VAR3")

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

IF ! NETUSE("FO_FER") 
   RETU
ENDIF


CTLIN=80
FL = 0


SALTO=0
IMPRESSORA()
DBSELECTAR(PES)
DBGOTOP()
CABB2()
WHILE ! EOF()
   IF PROW()> 60
      CABB2()
   ENDIF
   CABB22()
   VAR3=NUMERO
   DBSELECTAR("FO_FER")
   SET FILTER TO &FILTRA
   DBGOTOP()
   WHILE ! EOF()
      IF PROW()>60
         IMPFOL()
         CABB2()
         CABB22()
         DBSELECTAR("FO_FER")
      ENDIF
      @ PROW()+SALTO,0 SAY '|'
      SALTO=1
      @ PROW(),47 SAY DATFERIAS
      @ PROW(),56 SAY DATFERIASF
      @ PROW(),64 SAY '|'
      @ PROW(),66 SAY '30'
      @ PROW(),69 SAY '|'
      @ PROW(),72 SAY FALTAS
      @ PROW(),76 SAY '|'
      @ PROW(),79 SAY DIASJUS
      @ PROW(),82 SAY '|'
      @ PROW(),85 SAY BAIXADO
      @ PROW(),87 SAY '|'
      @ PROW(),89 SAY DIASPAGO3
      @ PROW(),92 SAY '|'
      @ PROW(),94 SAY DIASGOZA3
      @ PROW(),97 SAY '|'
      @ PROW(),98 SAY GOZOU1DE
      @ PROW(),107 SAY GOZOU1ATE
      @ PROW(),115 SAY '|'
      @ PROW(),116 SAY ABONO1DE
      @ PROW(),125 SAY ABONO1ATE
      @ PROW(),133 SAY '|'
      @ PROW(),134 SAY GOZOU2DE
      @ PROW(),143 SAY GOZOU2ATE
      @ PROW(),151 SAY '|'
      @ PROW(),152 SAY PROGRAMA
      @ PROW(),161 SAY PROGRAMA1
      @ PROW(),169 SAY '|'
      @ PROW(),170 SAY REPL('_',48)
      @ PROW(),219 SAY '|'
      DBSKIP()
   ENDDO
   @ PROW()+1,0 SAY REPL('-',219)
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IMPFOL()
VIDEO()
DBCLOSEALL()
IMPEND()
RETU

*!*****************************************************************************
*!
*!      Procedure: CABB2
*!
*!    Chamado por: FORES_B2.PRG
*!
*!*****************************************************************************
PROC CABB2
FL = FL + 1
@ PROW()  ,  1 SAY IMPSTR(cIMPEXP)
@ PROW()+1, 20 SAY IMPCHR(cIMPTIT)+MSG2
@ PROW()+1,100 SAY TIME()
@ PROW()  ,110 SAY 'DATA => '+DTOC(DXDIA)
@ PROW()  ,120 SAY 'FL. '+STRZERO(FL,4)
@ PROW()+1,  0 SAY REPL('-',132)
@ PROW()+1, 20 SAY IMPCHR(cIMPTIT)+'FICHA COMPLETA DE FERIAS'
@ PROW()+1,  0 SAY REPL ('-',131)+IMPSTR(cIMPCOM)
@ PROW()+1,  0 SAY '|NRo. |NOME'
@ PROW()  , 37 SAY '|ADMITIDO|PERIODO AQUISICAO|DIAS|FALTAS| JUS | OK |PAGO|GOZA'
@ PROW()  , 97 SAY '|1. FERIAS GOZADAS|ABONO  PECUNIARIO|2. FERIAS GOZADAS|'
@ PROW()  ,152 SAY 'PROGRAMA  FERIAS |OBSERVACOES'
@ PROW()  ,219 SAY '|'
@ PROW()+1,0 SAY REPL ('-',219)
RETU

*!*****************************************************************************
*!
*!      Procedure: CABB22
*!
*!    Chamado por: FORES_B2.PRG
*!
*!*****************************************************************************
PROC CABB22
DBSELECTAR(PES)
@ PROW()+1, 0 SAY '|'+STR(NUMERO,5)+'|'+NOME
@ PROW()  ,37 SAY '|'+DTOC(ADMITIDO)+'|'
SALTO=0
RETU
*: FIM: FORES_B2.PRG
