// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib12.prg
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

// !*****************************************************************************
// !
// !         Fun‡„o: VERSEHA()
// !
// !*****************************************************************************

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
FUNCTION VERSEHA  // ABRE UM ARQUIVO E VERIFICA SE EXISTE A CHAVE

   PARA ARQWORK, nINDEX, BUSWORK, cMES1, cMES2, lMES, aVAR
   LOCAL cDBF := Alias(), cMES := "", cVAR, cFIL, J

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF !netuse( arqwork )
      RETU .F.
   ENDIF
   IF ValType( nINDEX ) = "N"
      dbSetOrder( nINDEX )
   ENDIF
   dbGoTop()
   dbSeek( BUSWORK )
   RETORNO := IF( Found(), .T., .F. )
   IF RETORNO .AND. ValType( cMES1 ) = "C"
      cMES := &cMES1.
   ENDIF
   IF !RETORNO .AND. ValType( cMES2 ) = "C"
      cMES := &cMES2.
   ENDIF
   IF ValType( aVAR ) = "A"  // preencher variaveis com o valor do campo
      FOR J := 1 TO Len( aVAR )  // {{campo,variavel},{campo2,variavel2}}
         cFIL  := aVAR[ J, 1 ]
         cVAR  := aVAR[ J, 2 ]
         &cVAR := &cFIL
      NEXT J
   ENDIF
   dbCloseArea()
   IF RETORNO .AND. !Empty( cMES )
      MDS( cMES )
   ENDIF
   IF !RETORNO .AND. !Empty( cMES )
      IF lMES
         ALERTX( cMES )
      ELSE
         MDS( cMES )
      ENDIF
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF

   RETURN RETORNO

// + EOF: flib12.prg
// +
