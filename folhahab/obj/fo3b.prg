#INCLUDE "BOX.CH"
PADRAO("FO_FAI","FO_FAI","' '+mFAIXA+' '+mDESCRICAO+' '+STR(mVALOR, 12, 2)+' '+STR(mINDICE,  8, 3)","mFAIXA","Cadastro de Faixas Salarias","Ni Descri‡„o"+spac(42)+"Valor"+spac(8)+"Indice",;
       {|| PEGCHAVE("mFAIXA",SPACE(2),"Codigo:")},{|| tFO3B()},{||gFO3B()},{|| FO_FOR("GRUPO='FUNCAO'")})
RETU .T.

FUNC gFO3B
@  5, 1 SAY mFAIXA
@  5, 4 GET mDESCRICAO
@  5,55 GET mVALOR      PICTURE '999999999.99'
@  5,68 GET mINDICE     PICTURE '9999.999'
READCUR()
RETU .T.

FUNC tFO3B
HB_DISPBOX( 3, 0,23,79,B_DOUBLE+" ")
@  4,  1 SAY "Ni Descri‡„o"+spac(42)+"Valor"+spac(8)+"Indice"
RETU .T.


