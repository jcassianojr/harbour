*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_16.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 15-Out-2026 as 10:21 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_16()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto_16()


CABE2('FOPTO_16 - Visualizando Arquivo')

PARA cTIPO

ntipo := PEGRELOGIO()

cARQ := TARQREL(nTIPO,.T.,cTIPO)


PADRAO(cARQ,cARQ,"' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORA,5,2)+' '+mRELOGIO","STR(mNUMERO,8)+DTOS(mDATA)+STR(mHORA,5,2)","Importacao Relatorio","Numero Data Hora Relogio",;
 {|| ALLTRUE(ALERTX("Inclusao por importacao"))},"FO_DIO","FO_DIO",{|| FO_FOR("GRUPO='FO_DIO'")},;
 ,,,,"V")

RETURN




*+ EOF: fopto_16.prg
*+
