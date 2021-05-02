*:*****************************************************************************
*:
*:      FO43D.PRG: Revisar Evolucao Salarial
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     15:03
*:
*:*****************************************************************************
#INCLUDE "BOX.CH"


CTR=0
PCK=.F.

if ! NETUSE("fo_sal") 
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

DBGOTOP()
WHILE .T.
   FO43DT()
   FO43DS()
   MD()
   @ 23,20 PROM 'P>roximo'
   @ 23,30 PROM 'R>etorna'
   @ 23,40 PROM 'A>ltera '
   @ 23,60 PROM 'B>usca  '
   @ 23,70 PROM 'S>aida  '
   MENU TO OPCAO
   DO CASE
   CASE OPCAO=1 ; NEXTREC()
   CASE OPCAO=2 ; PREVREC()
   CASE OPCAO=3 ; FO43DG()
   CASE OPCAO=4
      REG=RECNO()
      MDS('Digite o numero')
      @ 24,30 GET CTR
      READCUR()
      //IF ! NETUSE(PES) 
       //  RETU
      //ENDIF
      DBGOTOP()
      IF ! DBSEEK(str(CTR,8)+str(anouso,4))
         MDT('Funcionario/Ano nao encontrado')
      ELSE
         IF NUMERO<>CTR       
            REG=RECNO()
            DBGOTO(REG)
         ENDIF   
      ENDIF
//      DBCLOSEAREA()
//      DBSELECTAR(PES)
//      DBGOTO(REG)
   OTHERWISE
      DBCLOSEALL()      
      RETU
   ENDCASE
ENDDO


*!*****************************************************************************
*!
*!       FO43DT
*!
*!*****************************************************************************
FUNCTION FO43DT
PETELA(8)
HB_dispbox(11, 0, 21, 79,B_DOUBLE+" ")
@ 13, 2 SAY "Jan "+CHR(16)+SPAC(20)+"Mai "+CHR(16)+SPAC(20)+"Set "+CHR(16)
@ 14,36 SAY "-"+SPAC(24)+"-"
@ 15, 2 SAY "Fev "+CHR(16)+SPAC(20)+"Jun "+CHR(16)+SPAC(20)+"Out "+CHR(16)
@ 16,11 SAY "-"+SPAC(24)+"-"+SPAC(24)+"-"
@ 17, 2 SAY "Mar "+CHR(16)+SPAC(20)+"Jul "+CHR(16)+SPAC(20)+"Nov "+CHR(16)
@ 18,11 SAY "-"+SPAC(24)+"-"+SPAC(24)+"-"
@ 19, 2 SAY "Abr "+CHR(16)+SPAC(20)+"Ago "+CHR(16)+SPAC(20)+"Dez "+CHR(16)
@ 20,11 SAY "-"+SPAC(24)+"-"+SPAC(24)+"-"
RETU

*!*****************************************************************************
*!
*!      FO43DS
*!
*!*****************************************************************************
FUNCTION FO43DS
@ 16,13 SAY IF(SALJAN#0.AND.SALFEV#0,((SALFEV/SALJAN)-1)*100,0) PICT "###.##%"
@ 18,13 SAY IF(SALFEV#0.AND.SALMAR#0,((SALMAR/SALFEV)-1)*100,0) PICT "###.##%"
@ 20,13 SAY IF(SALMAR#0.AND.SALABR#0,((SALABR/SALMAR)-1)*100,0) PICT "###.##%"
@ 14,38 SAY IF(SALABR#0.AND.SALMAI#0,((SALMAI/SALABR)-1)*100,0) PICT "###.##%"
@ 16,38 SAY IF(SALMAI#0.AND.SALJUN#0,((SALJUN/SALMAI)-1)*100,0) PICT "###.##%"
@ 18,38 SAY IF(SALJUN#0.AND.SALJUL#0,((SALJUL/SALJUN)-1)*100,0) PICT "###.##%"
@ 20,38 SAY IF(SALJUL#0.AND.SALAGO#0,((SALAGO/SALJUL)-1)*100,0) PICT "###.##%"
@ 14,63 SAY IF(SALAGO#0.AND.SALSET#0,((SALSET/SALAGO)-1)*100,0) PICT "###.##%"
@ 16,63 SAY IF(SALSET#0.AND.SALOUT#0,((SALOUT/SALSET)-1)*100,0) PICT "###.##%"
@ 18,63 SAY IF(SALOUT#0.AND.SALNOV#0,((SALNOV/SALOUT)-1)*100,0) PICT "###.##%"
@ 20,63 SAY IF(SALNOV#0.AND.SALDEZ#0,((SALDEZ/SALNOV)-1)*100,0) PICT "###.##%"
@ 13, 8 SAY SALJAN
@ 14, 8 SAY MOT1
@ 15, 8 SAY SALFEV
@ 16, 8 SAY MOT2
@ 17, 8 SAY SALMAR
@ 18, 8 SAY MOT3
@ 19, 8 SAY SALABR
@ 20, 8 SAY MOT4
@ 13,33 SAY SALMAI
@ 14,33 SAY MOT5
@ 15,33 SAY SALJUN
@ 16,33 SAY MOT6
@ 17,33 SAY SALJUL
@ 18,33 SAY MOT7
@ 19,33 SAY SALAGO
@ 20,33 SAY MOT8
@ 13,58 SAY SALSET
@ 14,58 SAY MOT9
@ 15,58 SAY SALOUT
@ 16,58 SAY MOT10
@ 17,58 SAY SALNOV
@ 18,58 SAY MOT11
@ 19,58 SAY SALDEZ
@ 20,58 SAY MOT12
RETU

*!*****************************************************************************
*!
*!       FO43DG
*!
*!*****************************************************************************
FUNCTION FO43DG
netreclock()
@ 13, 8 GET SALJAN
@ 14, 8 GET MOT1
@ 15, 8 GET SALFEV
@ 16, 8 GET MOT2
@ 17, 8 GET SALMAR
@ 18, 8 GET MOT3
@ 19, 8 GET SALABR
@ 20, 8 GET MOT4
READCUR()
@ 13,33 GET SALMAI
@ 14,33 GET MOT5
@ 15,33 GET SALJUN
@ 16,33 GET MOT6
@ 17,33 GET SALJUL
@ 18,33 GET MOT7
@ 19,33 GET SALAGO
@ 20,33 GET MOT8
READCUR()
@ 13,58 GET SALSET
@ 14,58 GET MOT9
@ 15,58 GET SALOUT
@ 16,58 GET MOT10
@ 17,58 GET SALNOV
@ 18,58 GET MOT11
@ 19,58 GET SALDEZ
@ 20,58 GET MOT12
READCUR()
dbunlock()
RETU

*: FIM: FO43D.PRG
