// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib41.prg
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
// +    Function VERSEHA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC VERSEHA( ARQWORK, BUSWORK, cMES1, cMES2, lMES, nIND, nLIN, nCOL, lVAZIO )

   LOCAL RETORNO
   LOCAL cMESS   := ""
   LOCAL cDBF    := Alias()

   IF ValType( lMES ) # "L"
      lMES := .F.
   ENDIF
   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( lVAZIO ) = "L"
      IF lVAZIO
         IF Empty( BUSWORK )
            RETU .T.
         ENDIF
      ENDIF
   ENDIF
   IF !USEREDE( ARQWORK, 1, nIND )
      RETU .F.
   ENDIF
   dbGoTop()
   RETORNO := dbSeek( BUSWORK )
   IF ValType( cMES1 ) = "C" .AND. RETORNO
      cMESS := &cMES1.
   ENDIF
   IF ValType( cMES2 ) = "C" .AND. !RETORNO
      cMESS := &cMES2.
   ENDIF
   dbCloseArea()
   IF !Empty( cMESS )
      IF !RETORNO .AND. lMES
         IF Left( cMESS, 1 ) # "X"  // Quando comeca com x troca para MDE
            ALERTX( cMESS )
         ELSE
            MDE( SubStr( cMESS, 2 ) )
         ENDIF
      ENDIF
      IF ValType( nLIN ) = "N"
         @ nLIN, nCOL SAY cMESS
      ELSE
         MDS( cMESS )
      ENDIF
   ENDIF
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU RETORNO


// + EOF: mlib41.prg
// +
