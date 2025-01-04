// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_16.prg Visualizando Arquivo'
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"

FUNCTION fopto_16()

   CABE2( 'FOPTO_16 - Visualizando Arquivo' )

   PARA cTIPO

   ntipo := PEGRELOGIO()

   cARQ := TARQREL( nTIPO, .T., cTIPO )


   PADRAO( cARQ, cARQ, "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORA,5,2)+' '+mRELOGIO", "STR(mNUMERO,8)+DTOS(mDATA)+STR(mHORA,5,2)", "Importacao Relatorio", "Numero Data Hora Relogio", ;
      {|| ALLTRUE( ALERTX( "Inclusao por importacao" ) ) }, "FO_DIO", "FO_DIO", {|| FO_FOR( "GRUPO='FO_DIO'" ) }, ;
      ,,,, "V" )

   RETURN



// + EOF: fopto_16.prg
// +
