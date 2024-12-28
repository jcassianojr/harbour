// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib02.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TECLAF11()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC TECLAF11

   PARA cPRO, nLIN, cVAR
   LOCAL lACHEI  := .F.
   PRIV eEXECUTE

   IF Type( "HELPDBF" ) = "C"
      IF PEGACAMPO( "MF11", "PADR(cVAR,10)+PADR(HELPDBF,10)", "EXECUTE", "eEXECUTE" )
         &cVAR. := &eEXECUTE.
         lACHEI := .T.
      ELSE
         IF PEGACAMPO( "MF11", "ALLTRIM(cVAR)", "EXECUTE", "eEXECUTE" )
            &cVAR. := &eEXECUTE.
            lACHEI := .T.
         ENDIF
      ENDIF
   ELSE
      IF PEGACAMPO( "MF11", "ALLTRIM(cVAR)", "EXECUTE", "eEXECUTE" )
         &cVAR. := &eEXECUTE.
         lACHEI := .T.
      ENDIF
   ENDIF
   IF !lACHEI
      IF Type( cVAR ) = "D"
         // CALEND()
         IF ValType( READVAR ) = "D"
            IF MDG( "USAR " + STRVAL( READVAR ) )
               &cVAR. := READVAR
            ENDIF
         ENDIF
      ENDIF
      IF Type( cVAR ) = "N"
         // CALC()
         IF ValType( READVAR ) = "N"
            IF MDG( "USAR " + STRVAL( READVAR ) )
               READVAR := READVAR
            ENDIF
            &cVAR. := READVAR
         ENDIF
      ENDIF
   ENDIF
   RETU .T.


// + EOF: mlib02.prg
// +
