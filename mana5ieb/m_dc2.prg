*:*****************************************************************************
*:
*:     M_DC2.PRG : Imprimir etiquetas para lote de pe‡as
*:     Linguagem : Clipper 5.x
*:        Sistema: Mana5 - ITAESBRA
*:      Copyright (c) 1996, Disk Soft S/C Ltda.
*:
*:*****************************************************************************

#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

MDI(" Ý Impress„o de Etiquetas para Lotes de Pe‡as ")

WHILE .T.
   CODI  := SPACE(30)
   QTDE  := 0
   COPIA := 0
   @ 11,16 SAY 'C¢digo da Pe‡a : ' GET CODI
   @ 13,16 SAY 'Quantidade     : ' GET QTDE
   @ 15,16 SAY 'Quantas C¢pias : ' GET COPIA PICT '###'
   @ 16,16 SAY "<ESC> P/ Sair "
   IF ! READCUR()
      EXIT
   ENDIF
   IF COPIA=0
      EXIT
   ENDIF
   WHILE ! CHECKIMP()
   ENDDO
   MDS("Imprimindo...")
   IMPRESSORA()
   FOR X=1 TO COPIA
      IF ! ISPRINTER()
         VIDEO()
         ALERTX("Erro Impressora")
         IMPEND()
         RETU .F.
      ENDIF
      @ PROW()+1,00 SAY TRIM(CODI)
      @ PROW()  ,33 SAY TRIM(CODI)
      @ PROW()  ,66 SAY TRIM(CODI)
      @ PROW()  ,99 SAY TRIM(CODI)
      @ PROW()+2,00 SAY 'Qtde : '+STR(QTDE,5)
      @ PROW()  ,33 SAY 'Qtde : '+STR(QTDE,5)
      @ PROW()  ,66 SAY 'Qtde : '+STR(QTDE,5)
      @ PROW()  ,99 SAY 'Qtde : '+STR(QTDE,5)
      @ PROW()+2,00 SAY 'Itaesbra Ind.Mecanica Ltda'
      @ PROW()  ,33 SAY 'Itaesbra Ind.Mecanica Ltda'
      @ PROW()  ,66 SAY 'Itaesbra Ind.Mecanica Ltda'
      @ PROW()  ,99 SAY 'Itaesbra Ind.Mecanica Ltda'
      @ PROW()+4,00 SAY ""
   NEXT X
   VIDEO()
ENDDO
IMPEND()

FUNC M_DC4
mCODIGO:=SPACE(24)
mQTDUNI:=mQTDEMB:=0
mPESUNI:=mPESEMB:=0
mTOTAL:=0
mCONTINUA:="S"
TELASAY("MDC401")
EDITSAY("MDC401")
RETU .T.
