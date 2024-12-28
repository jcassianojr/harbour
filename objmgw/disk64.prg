// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk64.prg
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
// +    DISK64.PRG
// +
// +    Functions: Function VERTXT()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function VERTXT()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VERTXT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC VERTXT( cARQ, cCOR1, cCOR2, aPOS, lTELA )

   LOCAL nLINI := 0
   LOCAL nCOLI := 0
   LOCAL nLINF := 24
   LOCAL nCOLF := 79
   LOCAL aAMB

   IF ValType( lTELA ) # "L"
      lTELA := .T.
   ENDIF
   IF ValType( aPOS ) = "A"
      nLINI := aPOS[ 1 ]
      nCOLI := aPOS[ 2 ]
      nLINF := aPOS[ 3 ]
      nCOLF := aPOS[ 4 ]
   ENDIF
   aAMB := SALVAA()
   IF !File( cARQ )
      restaa( aAMB )
      ALERTX( 'Nao Encontrei Este Arquivo' )
      RETURN .F.
   ENDIF
   cls
   SetColor( if( ValType( cCOR1 ) # "C", "N/W", cCOR1 ) )
   @ nLINI, nCOLI CLEAR TO nLINF, nCOLF
   @ nLINF, nCOLI SAY '[Arq.:' + cARQ + ']'
   @ nLINI, nCOLI SAY "       " + spac( 6 ) + "           нн Mover: " + Chr( 24 ) + " " + Chr( 25 ) + " PGUP PGDN  HOME  END          н Sair: ESC "
   SetColor( if( ValType( cCOR2 ) # "C", "W/R", cCOR2 ) )
   FILEVIEWG( cARQ, nLINI + 1, nCOLI, nLINF - 1, nCOLF,, cARQ, )
   restaa( aAMB )

   RETURN

// + EOF: DISK64.PRG

// + EOF: disk64.prg
// +
