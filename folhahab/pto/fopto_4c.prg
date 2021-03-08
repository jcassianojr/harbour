//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function fopto_4c
PARA cTABELA,cREL


PADRAO(cTABELA,cTABELA,"' '+STR(mMES,  2)+' '+STR(mANO,  4)+' '+STR(mDESCT, 10, 2)+' '+STR(mDESCTB, 10, 2)+' '+STR(mDESCTC, 10, 2)+' '+STR(mDESCTD, 10, 2)+' '+STR(mDESCTE, 10, 2)","STR(mANO,4)+STR(mMES,2)","Tabela:"+cTABELA,"Mes/ANO Tabela  A"+spac(10)+"B"+spac(12)+"C"+spac(10)+"D"+spac(10)+"E",;
       {|| iFOPTO4C()},{|| tFOPTO4C()},{|| gFOPTO4C()},{|| FO_RELL(cREL) },,2)
RETU .T.

FUNC iFOPTO4C
MDS("Digite Mes e Ano")
@ 24,20 GET mMES  PICT '99'
@ 24,30 GET mANO  PICT '9999'
IF ! READCUR()
   RETU .F.
ENDIF
mCHAVE:= STR(mANO,4)+STR(mMES,2)
RETU .T.

FUNC tFOPTO4C
// Desenha a Tela
HB_DISPBOX( 4, 0,23,79,B_DOUBLE+" ")
@  6,  1 SAY "Mes/ANO Tabela  A"+spac(10)+"B"+spac(12)+"C"+spac(10)+"D"+spac(10)+"E"
RETU .T.


FUNC gFOPTO4C
@  7, 1 SAY mMES
@  7, 4 SAY mANO
@  7, 9 GET mDESCT      PICT '9999999.99'
@  7,20 GET mDESCTB     PICT '9999999.99'
@  7,31 GET mDESCTC     PICT '9999999.99'
@  7,44 GET mDESCTD     PICT '9999999.99'
@  7,55 GET mDESCTE     PICT '9999999.99'
READCUR()
RETU .T.