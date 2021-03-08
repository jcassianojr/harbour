*:*****************************************************************************
*:
*:       FOA1.PRG: Entrada de dados folha Individualizado
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:26
*:
*:  Procs & Fncts: FOA1()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : PETELA()           (fun‡„o    em FOLPROC.PRG)
*:               : SALHM()            (fun‡„o    em FOLPROC.PRG)
*:               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
*:               : FODZER             (processo  em FOLPROC.PRG)
*:
*:    Arq. Dados : FO_PFE - Folha de F‚rias
*:                 FO_RSS - Folha de Rescis„o
*:                 FO_COMP - Folha Complementar
*:                 CONTAS - Cadastro de Vencimento e Descontos
*:
*:       Indices : RSS        Codigo de Trabalho
*:                            CONTROLE
*:                 CONTA      Por ordem de c¢digo
*:                            CODIGO
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************
#INCLUDE "BOX.CH"

function foa1
PARA CC
CABEX('Entrada de dados folha Individualizado')
CTR:=CTR1:=XA:=XB:=XC:=XD:=XE:=XF:=0

IF ! NETUSE(PES) //AREDE(PES,PES,1)
   DBCLOSEALL()
   RETU
ENDIF
cSELE1:=ALIAS()

IF ! ARQUSAR(CC)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2:=ALIAS()


IF ! NETUSE("CONTAS") //AREDE("CONTAS","CONTAS",1)
   DBCLOSEALL()
   RETU
ENDIF

WHILE .T.
   @ 10,00 CLEA
   HB_dispbox(10, 12, 12, 66,B_DOUBLE+" ")   
   @ 11,14 SAY "Numero do Funcionario     "+REPL('-',6)+CHR(16)
   HB_dispbox(13, 12, 15, 66,B_DOUBLE+" ")   
   @ 14,14 SAY "Numero da Conta"+SPAC(11)+REPL('-',6)+CHR(16)
   @ 11,55 GET ctr PICTURE "######"
   @ 14,58 GET CTR1 PICTURE "###"
   READCUR()
   IF CTR1=41
      ALERTX('Conta do Adiantamento, nao pode ser alterada')
      LOOP
   ENDIF
   DBSELECTAR(cSELE1)
   IF DBSEEK(CTR)
      PETELA(7)
      VAR1:=SALH:=SALM:=0
      SALHM()
      IF ! EMPTY(DEMITIDO)
         MDT('Funcionario Demitido')
      ENDIF
      DBSELECTAR("CONTAS")
      DBGOTOP()
      IF DBSEEK(CTR1)
         IF ACEITE#"S".OR.ZUSER="SUPERVISOR"
            XB=TIPO
            mFATOR=FATOR
            HB_dispbox( 12, 8, 16, 71,B_DOUBLE+" ")
            @ 12,16 SAY "-"+REPL('-',37)+"-"
            @ 16,16 SAY "-"+REPL('-',37)+"-"
            @ 13,10 SAY "Conta Ý Descrimina‡„o"+SPAC(23)+"Ý Valor/Horas"
            @ 14,08 SAY 'Ç'+REPL('-',7)+"+"+REPL('-',37)+"+"+REPL('-',16)+'¶'
            @ 15,16 SAY "Ý"+SPAC(37)+"Ý"
            @ 15,11 SAY CODIGO PICTURE "###"
            @ 15,18 SAY DESCR
            HORA:=VALE:=0
            BUSCA=(CTR*10000)+CTR1
            DBSELECTAR(cSELE2)
            DBGOTOP()
            IF DBSEEK(BUSCA)
               HORA=HORAS
               VALE=VALOR
            ENDIF
            IF XB = 1 .OR. XB = 3 .OR. XB = 4
               @ 15,56 GET HORA PICT '###.##'
               READCUR()
            ELSE
               @ 15,56 GET VALE PICT '###,###,###.##'
               READCUR()
            ENDIF
            GRAVA2(CTR1)
            IF XB=1 .OR. XB=3 .OR. XB = 4
               FIELD-> HORAS := HORA
            ENDIF
            IF CC=2.OR.CC=3
               IF XB=1 .OR. XB=3
                  FIELD->VALOR:=HORA*SALH*mFATOR
               ENDIF
               IF XB = 4
                  FIELD->VALOR:=ROUND(HORA*SALM/30,2)
               ENDIF
               FIELD-> FATOR     := mFATOR
               FIELD-> TIPO      := XB
               IF MDG("Primeiro Mes")
                  FIELD-> VALORMES1 := VALOR
                  FIELD-> MES1      := MES
               ELSE
                  FIELD-> VALORMES2 := VALOR
                  FIELD-> MES2      := MES
               ENDIF
            ENDIF
         ELSE
            ALERTX("Inclus„o desta Conta Permitida Somente para o Supervisor")
         ENDIF
      ELSE
         ALERTX('Conta n„o encontrada')
      ENDIF
   ELSE
      ALERTX('Funcion rio n„o encontrado')
   ENDIF
   MDS('Deseja Continuar')
   @ 24,57 PROM 'SIM'
   @ 24,67 PROM 'NAO'
   MENU TO OPC
   IF OPC=2
      EXIT
   ENDIF
ENDDO
DBSELECTAR(cSELE2)
FODZER()
DBCLOSEALL()
RETU

*: FIM: FOA1.PRG
