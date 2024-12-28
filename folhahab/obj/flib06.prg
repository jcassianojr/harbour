// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib06.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OBTER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION OBTER( cARQ, eSemUso, KEYINDEX, cCAMPO, nIND, nROW, nCOL, cMES, cMES2, cDEF )

   LOCAL cDBF   := Alias()
   LOCAL FECHAR := .F.
   LOCAL cRETU  := ""

   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( cDEF ) # "U"
      cRETU := cDEF
   ENDIF
   IF SELECT ( cARQ ) = 0
      IF !netuse( cARQ )
         RETURN cRETU
      ENDIF
      FECHAR := .T.
   ELSE
      dbSelectAr( cARQ )
   ENDIF
   IF nIND > 1
      dbSetOrder( nIND )
   ENDIF
   dbGoTop()
   IF dbSeek( keyindex )
      cRETU := &cCAMPO.
   ELSE
      IF ValType( cDEF ) = "U"
         cRETU := MAKE_EMPTY( cCAMPO )
      ENDIF
   ENDIF
   IF ValType( nROW ) = "N"
      IF !Empty( cRETU )
         @ nROW, nCOL SAY &cMES.
      ELSE
         @ nROW, nCOL SAY &cMES2.
      ENDIF
   ENDIF
   IF FECHAR
      dbCloseArea()
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF

   RETURN cRETU

// + EOF: flib06.prg
// +
