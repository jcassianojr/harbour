// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_13.prg
// +
// +
// +
// +     Sistema:
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


CABE2( 'FOPTO_13 - Ver/Imprimir Arquivo do Rel¢gio-TXT' )
ntipo := PEGRELOGIO()
DADO  := pegarqcon( nTIPO, "TXT" )
FOPTO13( DADO )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO13()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO13( DADO )

   IF MDG( "Visualizar" )
      VERTXT( DADO,,, { 4, 0, 24, 79 }, .F. )
   ENDIF
   IF MDG( "Imprimir" )
      IMPARQ( DADO )
   ENDIF
   RETU



// + EOF: fopto_13.prg
// +
