*:*****************************************************************************
*:
*:       FOAB.PRG: Lan‡amento Automatico Pre Programado
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:32
*:
*:  Procs & Fncts: FOAB()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : PETELA()           (fun‡„o    em FOLPROC.PRG)
*:               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
*:
*:     Arq. Dados: FO_PFE - Folha de F‚rias
*:                 FO_RSS - Folha de Rescis„o
*:                 FO_COMP - Folha Complementar
*:                 CONTAS - Cadastro de Vencimentos e Descontos
*:
*:        Indices: RSS    Codigo de Trabalho
*:                        CONTROLE
*:                 CONTA  Por ordem de c¢digo
*:                        CODIGO
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************



CABEX("Lan‡amento Automatico Pre Programado")
PARA CC
XA:=XB:=XC:=XD:=XE:=XF:=0

IF ! NETUSE("FO_LAN") //BREDE("FO_LAN",0)
   retu .f.
endif

IF ! ARQUSAR(CC)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2:=ALIAS()


IF ! netuse("contas") //AREDE("CONTAS","CONTAS",0)
   DBCLOSEALL()
   RETU .F.
ENDIF

IF ! netuse(pes) //AREDE(PES,PES,0)
   DBCLOSEALL()
   RETU .F.
ENDIF


DBSELECTAR("FO_LAN")
DBGOTOP()
WHILE ! EOF()
   mCONTA=CONTA
   VALE  =VALOR
   mGRUPO=GRUPO
   MDS(' '+STR(CONTA,3)+' '+STR(VALOR,10,2)+' '+SUBSTR(GRUPO,1,60))
   DBSELECTAR(PES)
   DBGOTOP()
   WHILE ! EOF()
      IF EMPTY(DEMITIDO)
         PETELA(8)
         ANOADM=YEAR(ADMITIDO)
         MESADM=MONTH(ADMITIDO)
         ANOATU=YEAR(DXDIA)
         MESATU=MONTH(DXDIA)
         MESTRA=(12-MESADM)+MESATU
         ANOTRA=ANOATU-ANOADM-1+INT(MESTRA/12)
         CTR=NUMERO
         IF &mGRUPO
            GRAVA2(mCONTA)
            IF XB=1 .OR. XB=3               
               FIELD-> HORAS := VALOR
               FIELD-> VALOR := 0
            ENDIF
         ENDIF
      ENDIF
      DBSELECTAR(PES)
      DBSKIP()
   ENDDO
   DBSELECTAR("FO_LAN")
   DBSKIP()
ENDDO
DBCLOSEALL()
RETU
*: FIM: FOAB.PRG
