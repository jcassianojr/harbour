// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : adoerror.prg
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


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ShowAdoError()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ShowAdoError( oERR, oCon, cMESSAGE, lMES )

   LOCAL nAdoErrors := 0
   LOCAL oAdoErr
   LOCAL cERRO

   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF

   cERRO      := NNETWHOAMI() + hb_osNewLine()
   nAdoErrors := oCon:Errors:Count()
   IF nAdoErrors > 0
      oAdoErr := oCon:Errors( nAdoErrors - 1 )
      cERRO   += oAdoErr:Description + hb_osNewLine() + oAdoErr:Source
      cERRO   += oCon:ConnectionString + hb_osNewLine()
      cERRO   += hb_ValToExp( oCon:Provider ) + hb_osNewLine()
      cERRO   += hb_ValToExp( oCon:State ) + hb_osNewLine()
   ELSE
      cERRO += 'Outros Erros' + hb_osNewLine()
   ENDIF
   IF ValType( cMESSAGE ) = "C"
      cERRO += hb_osNewLine() + cMESSAGE
      hb_MemoWrit( "showadoercmd" + ArqLogDataHora( "log" ), cMESSAGE )
   ENDIF
   cERRO += hb_osNewLine() + oErr:Operation + " " + oErr:Description
   hb_MemoWrit( "showadoerror" + ArqLogDataHora( "log" ), cERRO )
   IF lMES
      ALERTX( cERRO )
   ENDIF

   RETURN NIL

// + EOF: adoerror.prg
// +
