// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlibita.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// !*****************************************************************************
// !
// !         Fun‡„o: FECFOL()  Final de Folha de Impress„o
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FECFOL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FECFOL( nCOL, lSALTA )

   LOCAL LIN := 57 - CTLIN, TRA

   IF ValType( nCOL ) # "N"
      nCOL := 132
   ENDIF
   IF ValType( lSALTA ) # "L"
      lSALTA := .T.
   ENDIF
   TRA := Int( ( nCOL - LIN ) / 2 )
   @ CTLIN, 0 SAY REPL( "-", TRA )
   FOR X := 1 TO LIN
      @ CTLIN, TRA + X SAY "-"
      CTLIN++
   NEXT X
   @ CTLIN, nCOL - TRA SAY REPL( "-", TRA )
   IF lSALTA
      EJECT
   ENDIF
   RETU .T.

// + EOF: mlibita.prg
// +
