*:*****************************************************************************
*:
*:       FOCG.PRG: Resumo para Compra de Vale Transporte
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 28/06/98
*:
*:*****************************************************************************
////#INCLUDE "COMANDO.CH"


IF ! MDL('Resumo para Compra de Vale Transporte',0)
   RETU
ENDIF
if ! netuse("VTCONTA")
   retu .f.
endif
if ! netuse("vtfolha")
   dbclosearea()
   retu .f.
endif

CTLIN=1
IMPRESSORA()
@ PROW()  , 0 SAY IMPSTR(cIMPEXP)
@ PROW()  ,00 SAY IMPCHR(cIMPTIT)+'Resumo para Compra Vale Transporte'
@ PROW()+2,60 SAY TIME()
@ PROW()  ,70 SAY DXDIA
@ PROW()+1, 0 SAY REPL('-',80)
@ PROW()+1, 0 SAY 'COD.'
@ PROW()  , 5 SAY 'DESCR'
@ PROW()  ,50 SAY 'VALOR'
@ PROW()  ,60 SAY 'QUANTIDADE'
@ PROW()+1, 0 SAY REPL('-',80)

DBSELECTAR("VTCONTA")
DBGOTOP()
WHILE ! EOF()
   SOMA=0
   CTX=CODIGO
   FILTRO='CONTA=CTX'
   DBSELECTAR("VTFOLHA")
   SET FILTER TO &FILTRO
   DBGOTOP()
   WHILE ! EOF()
      SOMA+=HORAS
      DBSKIP()
   ENDDO
   SET FILTER TO
   SOMA=IF(SOMA#0,(INT((SOMA+20)/20)*20),0)
   DBSELECTAR("VTCONTA")
   IF SOMA#0
      @ PROW()+1, 0 SAY CODIGO
      @ PROW()  , 5 SAY DESCR
      @ PROW()  ,50 SAY VALOR PICT "#,###,###.##"
      @ PROW()  ,60 SAY SOMA PICT "########"
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU .T.