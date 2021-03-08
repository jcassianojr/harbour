*:*****************************************************************************
*:
*:       FOAX.PRG: Excluindo Lancamentos da Folha
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:35
*:
*:*****************************************************************************
#INCLUDE "BOX.CH"

function foax
PARA CC,CY
LOCAL lPACK
lPACK:=.F.

CABEX ( 'Excluindo Lancamentos da Folha')
CTR = 0

IF ! ARQUSAR(CC)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1:=ALIAS()


IF CY=1
   MDS('NUMERO DA CONTA .....->')
   @ 24,35 GET CTR PICT "###"
   IF ! READCUR()
      RETU .F.
   ENDIF
   IF ! ARQCTA(CC)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   cSELE2:=ALIAS()
   DBGOTOP()
   IF DBSEEK(CTR)
      IF CC=6.OR.ACEITE#"S".OR.ZUSER="SUPERVISOR"
          HB_dispbox( 9,16, 13, 62,B_DOUBLE+" ")          
          @ 09,24 SAY "-"
          @ 13,24 SAY "-"
          @ 10,18 SAY "Conta Ý Descrimina‡„o"
          @ 11,16 SAY 'Ç'+REPL('-',7)+"+"+REPL('-',37)+'¶'
          @ 12,24 SAY "Ý"
          @ 12,19 SAY CTR PICT '###'
          @ 12,26 SAY DESCR
          SET COLOR TO +R/GR
          HB_dispbox(15, 0, 21, 79,B_DOUBLE+" ")          
          @ 17,14 SAY "Aten‡„o !!!!"
          @ 18,14 SAY "Vocˆ ira retirar todos os lan‡amentos da conta mencionada"
          @ 19,14 SAY "que existirem no arquivo da folha deste mˆs OK !!!!"
          SET COLO TO
          IF MDG ('Deseja Apagar (S/N)=>')
             DBSELECTAR(cSELE1)
             nLASTREC:=LASTREC()
             zei_fort( nLASTREC,,,0)
             DBEval( {|| netrecDel()}, {|| CONTA = CTR},{|| zei_fort(nLASTREC,,,1)})
             lPACK:=.T.
          ENDIF
      ELSE
         ALERTX("Exclus„o desta Conta Permitida Somente para o Supervisor")
      ENDIF
   ENDIF
ENDIF
IF CY=0
   MDS('NUMERO DO FUNCIONARIO->')
   @ 24,35 GET CTR PICT '#####'
   IF !  READCUR()
      RETU .F.
   ENDIF
   IF ! ARQPES(CC,1,1)
       DBCLOSEALL()
       RETU .F.
   ENDIF
   cSELE3:=ALIAS()
   DBGOTOP()
   IF DBSEEK(CTR)
      PETELA(10)
      SET COLOR TO +R/GR
      HB_dispbox(15, 0, 21, 79,B_DOUBLE+" ")
      @ 17,14 SAY "Atencao !!!!"
      @ 18,14 SAY "Vocˆ ira retirar todos os lan‡amentos deste funcion rio"
      @ 19,14 SAY "que existirem no arquivo da folha deste mˆs OK !!!!"
      SET COLO TO
      IF MDG ('Deseja apagar (S/N)=>')
         DBSELECTAR(cSELE1)
         DBEval( {|| netrecdel()}, {|| NUMERO = CTR},,,, .F. )
         lPACK:=.T.
      ENDIF
   ENDIF
ENDIF
IF CY=2
   SET COLOR TO +R/GR
   HB_dispbox(15, 0, 21, 79,B_DOUBLE+" ")
   @ 17,11 SAY "Atencao !!!!"
   @ 18,11 SAY "Vocˆ ira retirar todos os lan‡amentos - (Apagar todos os dados)"
   @ 19,11 SAY "que existirem no arquivo da folha deste mˆs OK !!!!"
   SET COLO TO
   IF MDG('Vocˆ tem certeza')
      IF MDG('Vocˆ realmente tem certeza')
         DBSELECTAR(cSELE1)
         ZAP
      ENDIF
   ENDIF
ENDIF
IF lPACK
   PACK
ENDIF
DBCLOSEALL()
RETU
*: FIM: FOAX.PRG
