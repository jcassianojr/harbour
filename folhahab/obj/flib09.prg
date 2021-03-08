////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

FUNC PEG13(nREF)
LOCAL cARQ:="FO_FP13",cTELA
IF VALTYPE(nREF)#"N"
   cTELA:=SAVESCREEN( 6,26,16,58)
   CLSBOX(6,26,16,58)
   WHILE .T.
     HB_DISPBOX( 6,26,16,58,B_DOUBLE+" ")
     oPCAO(  8,28 , " &A - 1a. Parcela      ",65)
     oPCAO( 10,28 , " &B - 2a. Parcela      ",66)
     oPCAO( 12,28 , " &C - Complemento      ",67)
     oPCAO( 14,28 , " &D - Arquivos Antigos ",68)
     nREF:=MENU(,0)
     IF nREF>0.AND.nREF<5
        EXIT
     ENDIF
  ENDDO
  RESTSCREEN( 6,26,16,58,cTELA)
ENDIF
IF NRSEN <> 'DiReT'
   DO CASE
      CASE nREF=1 ; cARQ:="FO_FP13A"
      CASE nREF=2 ; cARQ:="FO_FP13B"
      CASE nREF=3 ; cARQ:="FO_FP13C"
      OTHERWISE   ; cARQ:="FO_FP13"
   ENDCASE
ELSE
   DO CASE
      CASE nREF=1 ; cARQ:="FO_SO13A"
      CASE nREF=2 ; cARQ:="FO_SO13B"
      CASE nREF=3 ; cARQ:="FO_SO13C"
      OTHERWISE   ; cARQ:="FO_SO13"
   ENDCASE
ENDIF
RETU cARQ