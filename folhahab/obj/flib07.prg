// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib07.prg
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
// +    Function CHECKTAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKTAB( eCHAVE, nLIN, nCOL, cMES, nRETU )

   LOCAL lRETU := .F., cDESC := "", cDBF := Alias()

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF ValType( nRETU ) # "N"
      nRETU := 1
   ENDIF
   IF !netuse( "FO_TAB" )
      ALERTX( "Nao Consegui Abrir Arquivo de Tabelas" )
      IF !Empty( cDBF )
         dbSelectAr( cDBF )
      ENDIF
      RETU IF( nRETU = 1, .F., cDESC )
   ENDIF
   dbGoTop()
   IF dbSeek( eCHAVE )
      lRETU := .T.
      cDESC := DESCRI
   ENDIF
   dbCloseArea()
   IF !lRETU .AND. nRETU = 1
      ALERTX( cMES )
   ENDIF
   IF ValType( nLIN ) = "N" .AND. ValType( nCOL ) = "N"
      @ nLIN, nCOL SAY cDESC
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU IF( nRETU = 1, lRETU, cDESC )

// + EOF: flib07.prg
// +
