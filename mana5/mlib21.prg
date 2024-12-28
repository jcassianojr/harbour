// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib21.prg
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





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TIPCAD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC TIPCAD( cTIP, cVAR, nROW, nCOL, cVA2 )

   LOCAL cARQ  := "MA01"
   LOCAL cTIT  := ""
   LOCAL lRETU := .T.

   IF !cTIP $ "CFVTPM"
      cTIP := ESCOLHETAB( "TIPCAD", cTIP,, 1 )
   ENDIF
   DO CASE
   CASE cTIP = "C"
      cARQ := "MA01"
      cTIT := "CLIENTE       "
   CASE cTIP = "F"
      cARQ := "MB01"
      cTIT := "FORNECEDOR    "
   CASE cTIP = "V"
      cARQ := "MC01"
      cTIT := "VENDEDOR      "
   CASE cTIP = "T"
      cARQ := "MG01"
      cTIT := "TRANSPORTADORA"
   CASE cTIP = "P"
      cARQ := "M301"
      cTIT := "PORTO         "
   CASE cTIP = "M"
      cARQ := "MP03"
      cTIT := "MAO DE OBRA   "
   OTHERWISE
      lRETU := .F.
   ENDCASE
   IF ValType( nROW ) = "N" .AND. ValType( nCOL ) = "N"
      @ nROW, nCOL SAY cTIT
   ENDIF
   IF ValType( cVAR ) = "C"
      &cVAR. := cARQ
   ENDIF
   IF ValType( cVA2 ) = "C"
      &cVA2. := cTIP
   ENDIF
   RETU lRETU


// + EOF: mlib21.prg
// +
