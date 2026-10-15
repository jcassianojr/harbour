*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_2b.prg
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

#include "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_2b()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto_2b()


CABE2('FOPTO_2B - Apagar Movimento Ponto')
IF MDG("Deseja funcionario por funcionario")
   FOPTO2B01()
ELSE
   FOPTO2B02()
ENDIF

RETURN

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO2B01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO2B01


WHILE .T.
   SET KEY K_F11 TO TECLAF11
   mNUMERO := 0
   MDS("Digite o Numero")
   @ 24,40 GET mNUMERO         
   IF !READCUR() .OR. mNUMERO = 0
      SET KEY K_F11
      RETU
   ENDIF
   SET KEY K_F11
   FOPTO2B02("NUMERO="+AllTrim(Str(mNUMERO)))
ENDDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO2B02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO2B02(cFILTRO)


cPN := "PN"+ANOMESW
IF !NETUSE(cPN)
   dbCloseAll()
   RETURN
ENDIF
IF ValType(cFILTRO) # "C"
   FILTRO := ''
   FI     := Trim(FILTRO)
   FILTRO := FILTRO(FI)
ELSE
   FILTRO := cFILTRO
ENDIF
SET FILTER TO &FILTRO
GRAPP := 1
GRAPT := LastRec()
GRAPT('Aguarde Estou Apagando Dados')
dbGoTop()
WHILE !Eof()
   netrecdel()
   dbSkip()
ENDDO
dbCloseAll()



*+ EOF: fopto_2b.prg
*+
