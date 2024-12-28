// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib05.prg
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
// +    Function MDE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MDE( cCODIGO, cMESS, cCOR )

   LOCAL cDESC := ""

   IF ValType( cCOR ) # "C"
      cCOR := "W/N,N/W,N,N,N/W"
   ENDIF
   IF ValType( cMESS ) # "C"
      cMESS := ""
   ENDIF
   IF USEREDE( "MMES", 1, 1 )
      dbGoTop()
      dbSeek( cCODIGO )
      IF Found()
         cMESS := AllTrim( MENSAGEM ) + cMESS
         cDESC := DESCRICAO
      ELSE
         cMESS := "N„o Cadastrada Mensagem " + cCODIGO
         cDESC := cMESS
      ENDIF
      dbCloseArea()
   ELSE
      RETU .T.
   ENDIF
   SetColor( cCOR )
   nKEY := ALERTX( cMESS, { "   OK    ", "  Ajuda  " } )
// Pediu Ajuda
   IF nKEY = 2
      MEMOVIEW( cDESC, 8, 9, 15, 74,, "Ajuda de Erro" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCVAR( mVAR, nRES, nROW, nCOL, cEST )

   &mVAR. := nRES
   IF ValType( cEST ) = "C"
      @ nROW, nCOL SAY &mVAR. PICT cEST
   ELSE
      @ nROW, nCOL SAY &mVAR.
   ENDIF
   RETU .T.


// + EOF: mlib05.prg
// +
