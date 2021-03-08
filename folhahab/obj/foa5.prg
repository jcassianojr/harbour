*:*****************************************************************************
*:
*:       FOA5.PRG: Entrada de Dados Vale Transporte
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/12/98     11:29
*:
*:*****************************************************************************


CABEX('Progama‡„o de Vale Transporte')
mNUMERO:=mCONTA:=mCTACOM:=mHORAS:=0
PCK=.F.

IF ! NETUSE(PES) //AREDE(PES,PES,1)
   RETU
ENDIF

IF ! NETUSE("VTFIXO") //AREDE("VTFIXO","VTFIXO",0)
   RETU
ENDIF

IF ! NETUSE("VTCONTA") //AREDE("VTCONTA","VTCONTA",1)
   RETU
ENDIF

IF ! NETUSE("VTCOMP") //AREDE("VTCOMP","VTCOMP",1)
   RETU
ENDIF

WHILE .T.
   @ 17,00 CLEA
   @ 17,00 SAY "ESC ou funcionario em Branco Encerra"
   @ 18,00 SAY "Digite o Codigo do Funcionario"
   @ 19,00 SAY "Digite a Codigo do VT"
   @ 20,00 SAY "Digite o Codigo Composto"
   @ 21,00 SAY "Quantos Vale Transporte"
   @ 18,40 GET mNUMERO PICT "9999999"
   @ 19,40 GET mCONTA  PICT "9999"
   @ 20,40 GET mCTACOM PICT "9999"
   @ 21,40 GET mHORAS  PICT "999"
   IF ! READCUR()
      EXIT
   ENDIF
   IF EMPTY(mNUMERO)
      EXIT
   ENDIF
   IF EMPTY(mCONTA).AND.EMPTY(mCTACOM)
      ALERTX("Preencha o codigo VT ou Codigo Composto")
      LOOP
   ENDIF
   IF ! EMPTY(mCONTA).AND.! EMPTY(mCTACOM)
      ALERTX("Preencha apenas o codigo VT ou Codigo Composto")
      LOOP
   ENDIF
   DBSELECTAR(PES)
   DBGOTOP()
   IF ! DBSEEK(mNUMERO)
      ALERTX('Funcion rio N„o encontrado')
      LOOP
   ENDIF
   PETELA(10)
   IF ! EMPTY(mCONTA)
      DBSELECTAR("VTCONTA")
      DBGOTOP()
      IF ! DBSEEK(mCONTA)
         ALERTX('Conta VT n„o encontrada')
         LOOP
      ENDIF
   ENDIF
   IF ! EMPTY(mCTACOM)
      DBSELECTAR("VTCOMP")
      DBGOTOP()
      IF ! DBSEEK(mCTACOM)
         ALERTX('Composi‡„o de Passagem n„o encontrada')
         LOOP
      ENDIF
   ENDIF
   DBSELECTAR("VTFIXO")
   DBGOTOP()
   IF ! DBSEEK(STR(mNUMERO,8)+STR(mCONTA,4)+STR(mCTACOM,4))
      netrecapp()
      FIELD->NUMERO:=mNUMERO
      FIELD->CONTA :=mCONTA
      FIELD->CTACOM:=mCTACOM
   else
      netreclock()
   ENDIF
   FIELD->HORAS :=mHORAS
   dbunlock()
ENDDO
DBSELECTAR("VTFIXO")
FODZER()
DBCLOSEALL()
RETU
*: FIM: FOA5.PRG