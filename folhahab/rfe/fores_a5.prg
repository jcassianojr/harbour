*:*****************************************************************************
*:
*:  FORES_A5.PRG : Baixar Periodo de F‚rias
*:     Linguagem : Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/26/94      8:59
*:
*:  Procs & Fncts: FORES_A5()
*:               : FOREA5()
*:
*:          Chama: CABE2()            (fun‡„o    em FORESP.PRG)
*:               : FOREA5()           (fun‡„o    em FORES_A5.PRG)
*:
*:    Arq. Dados : FO_FER - Remanejamento de Ferias
*:
*:       Indices : FER        CODIGO DO FUNCIONARIO
*:                            CONTROLE
*:     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
*:*****************************************************************************
#INCLUDE "BOX.CH"


CABE2('Baixar Periodo de F‚rias')
WHILE .T.
   @ 08,00 CLEA
   SETCOLOR("+N/BG")
   HB_dispbox( 4, 0, 16, 64,B_DOUBLE)   
   @ 10,2 PROM "  1 - Todos dados os periodos Aquisitivos de um Funcion rio "
   @ 12,2 PROM "  2 - Apenas um Per¡odo aquisitivo de Um funcion rio"+SPAC(8)
   @ 14,2 PROM "  3 - Um per¡odo de data para Todos os Funcion rios"+SPAC(9)
   MENU TO KEY
   SETCOLOR("W/N,N/W")
   IF KEY=0
      RETU
   ENDIF
   FOREA5(KEY)
ENDDO

*!*****************************************************************************
*!
*!         Fun‡„o: FOREA5()
*!
*!    Chamado por: FORES_A5.PRG
*!
*!          Chama: PETELA()           (fun‡„o    em FORESP.PRG)
*!
*!*****************************************************************************
FUNC FOREA5(OPR)
@ 08,00 CLEA
IF ! NETUSE(PES) //AREDE(PES,PES,0)
   RETU
ENDIF
IF ! NETUSE("FO_FER") //AREDE("FO_FER","FO_FER",0)
   RETU
ENDIF
CTR=0
DATAINI:=DATAFIM:=DATE()
IF OPR=3
   MDS('Digite a Data Inicial e Final')
   @ 24,40 GET DATAINI
   @ 24,50 GET DATAFIM
   READCUR()
   DBSELECTAR("FO_FER")
   WHILE ! EOF()
      IF DATFERIAS>=DATAINI.AND.DATFERIAS<=DATAFIM
         NETRECLOCK()
         FO_FER->BAIXADO:='S'
         DBUNLOCK()
      ENDIF
      DBSKIP()
   ENDDO
   DBCLOSEALL()
   RETU
ENDIF
IF OP#3
   MDS('Digite o n£mero do Funion rio')
   @ 24,40 GET CTR PICT '######'
   READCUR()
   DBSELECTAR(PES)
   DBGOTOP()
   IF ! DBSEEK(CTR)
      MDT('Funcion rio n„o cadastrado')
      DBCLOSEALL()
      RETU
   ENDIF
   PETELA(8)
   IF OPR=1
      DBSELECTAR("FO_FER")
      WHILE ! EOF()
         IF NUMERO=CTR
            NETRECLOCK()
            FO_FER->BAIXADO:='S'
            DBUNLOCK()
         ENDIF
         DBSKIP()
      ENDDO
   ELSE
      MDS('Digite o Per¡odo aquisitivo')
      @ 24,40 GET DATAINI
      READCUR()
      CTRA=(((((CTR*10000)+YEAR(DATAINI))*100)+MONTH(DATAINI))*100)+DAY(DATAINI)
      DBSELECTAR("FO_FER")
      DBGOTOP()
      IF ! DBSEEK(CTRA)
         MDT ('Periodo Aquisitivo n„o encontrado')
      ELSE
         NETRECLOCK()
         FO_FER->BAIXADO:='S'
         DBUNLOCK()
      ENDIF
   ENDIF
ENDIF
DBCLOSEALL()
RETU
*: FIM: FORES_A5.PRG
