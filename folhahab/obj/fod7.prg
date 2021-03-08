*:*****************************************************************************
*:
*:       FOD7.PRG: INICIAR O MES
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:51
*:
*:  Procs & Fncts: FOD7()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : PETELA()           (fun‡„o    em FOLPROC.PRG)
*:               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
*:               : FODZER             (processo  em FOLPROC.PRG)
*:
*:     Arq. Dados: CONTAS
*:
*:        Indices: CONTA      Por ordem de c¢digo
*:                            CODIGO
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************

CABEX('INICIAR O MES ')
IF ! MDG ('DESEJA INICIAR')
   RETU
ENDIF

MESA=MES-1
ARQMESA=STRZERO(MESA,2)
FOLA = IF(NRSEN <> 'DiReT','FP','SO')+EMP+ARQMESA
INFOR(FOLA,"CONTROLE",ZDIRE+FOLA,.T.)

IF ! netuse(pes) //AREDE(PES,PES,0)
   RETU
ENDIF
FILTRO='((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
SET FILTER TO &FILTRO

IF ! netuse(fol) //AREDE(FOL,FOL,0)
   RETU
ENDIF

IF ! netuse("CONTAS") //AREDE("CONTAS","CONTAS",0)
   RETU
ENDIF


IF ! netuse(fola) //AREDE(FOLA,FOLA,0)
   RETU
ENDIF

DECLARE O[11]
DECLARE D[11]
O[1]=398
O[2]=401
O[3]=410
O[4]=411
O[5]=413
O[6]=419
O[7]=503
O[8]=437
O[9]=515
O[10]=507
O[11]=503
D[1]=998
D[2]=402
D[3]=410
D[4]=411
D[5]=416
D[6]=419
D[7]=492
D[8]=493
D[9]=415
D[10]=493
D[11]=494

STORE 1 TO XA,XB,XC,XD,XE,XF
MDS('Aguarde estou fazendo as transferencias')
dbselectar(pes)
DBGOTOP()
WHILE ! EOF()
   PETELA(7)
   CTR=NUMERO
   FOR X=1 TO 11
      BUSCA=(CTR*10000)+O[X]
      dbselectar(fola)
      DBGOTOP()
      if DBSEEK(BUSCA)
         netreclock()
         VALE=VALOR
         dbunlock()
         dbselectar(fol)
         GRAVA2(D[X])
      ENDIF
   NEXT X
   dbselectar(pes)
   DBSKIP()
ENDDO
dbselectar(fol)
FODZER()
DBCLOSEALL()
RETU
*: FIM: FOD7.PRG
