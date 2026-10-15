*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_13.prg
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_13()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto_13()


CABE2('FOPTO_13 - Ver/Imprimir Arquivo do Rel¢gio-TXT')
ntipo := PEGRELOGIO()
DADO  := pegarqcon(nTIPO,"TXT")
FOPTO13(DADO)

RETURN

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
FUNC FOPTO13(DADO)


IF MDG("Visualizar")
   VERTXT(DADO,,,{4,0,24,79},.F.)
ENDIF
IF MDG("Imprimir")
   IMPARQ(DADO)
ENDIF
RETU




*+ EOF: fopto_13.prg
*+
