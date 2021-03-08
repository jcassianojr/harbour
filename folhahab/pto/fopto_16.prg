*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_16.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:15 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"

CABE2( 'FOPTO_16 - Visualizando Arquivo' )

para cTIPO

ntipo := PEGRELOGIO()

cARQ := TARQREL( nTIPO, .T., cTIPO )


PADRAO(cARQ,cARQ,"' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORA,5,2)+' '+mRELOGIO","STR(mNUMERO,8)+DTOS(mDATA)+STR(mHORA,5,2)","Importacao Relatorio","Numero Data Hora Relogio", ;
       {|| ALLTRUE(ALERTX("Inclusao por importacao"))},"FO_DIO","FO_DIO",{|| FO_FOR("GRUPO='FO_DIO'")}, ;
              ,,,,"V")




*+ EOF: FOPTO_16.PRG
