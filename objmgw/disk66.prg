// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk66.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    DISK66.PRG
// +
// +    Functions: Function TECLAS()
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function TECLAS()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TECLAS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TECLAS( cPRO, nLIN, cVAR )   // ajuda nas teclas

   LOCAL I      := 0
   PRIV HELPDBF := "TECLAS"

   WHILE .T.
      cPRO := ProcName( I )
      cPRO := if( cPRO = "HOTINKEY", "INKEY", cPRO )
      DO CASE
      CASE Empty( cPRO )
         EXIT
      CASE cPRO = "ACHOICE"
         EXIT
      CASE cPRO = "__MENUTO"
         EXIT
      CASE cPRO = "READCUR"
         EXIT
      CASE cPRO = "MDG"
         EXIT
      CASE cPRO = "ALERTX"
         EXIT
      CASE cPRO = "INKEY"
         EXIT
      CASE cPRO = "MENU"
         EXIT
      CASE cPRO = "MSGYESNO"
         EXIT
      CASE cPRO = "MSGEXCLAMATION"
         EXIT
      CASE cPRO = "MSGWARNING"
         EXIT
      CASE cPRO = "MSGSTOP"
         EXIT
      CASE cPRO = "ALERT"
         EXIT
      ENDCASE
      I++
   ENDDO
   HELP( "TECLAS", 0, cPRO )
   RETU .T.



// + EOF: DISK66.PRG

// + EOF: disk66.prg
// +
