// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib28.prg
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
// +    Function ULTIMOREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC ULTIMOREG( ARQWORK, FIEWORK, eVAR, lSOMA, nIND, lOPEN )

   IF ValType( lOPEN ) # "L"
      lOPEN := .T.
   ENDIF
   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( lSOMA ) # "L"
      lSOMA := .T.
   ENDIF
   IF Type( "cVIDE" ) = "C"
      IF cVIDE = "T"
         lOPEN := .F.
      ENDIF
   ENDIF
   IF lOPEN
      IF !USEREDE( ARQWORK, 1, nIND )
         RETU 0
      ENDIF
   ENDIF
   dbGoBottom()
   RETORNO := &FIEWORK.
   IF lOPEN
      dbCloseArea()
   ENDIF
   IF ValType( eVAR ) = "C"
      &eVAR. := if( lSOMA, RETORNO := RETORNO + 1, RETORNO )
   ENDIF
   RETU RETORNO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ULTIMOITEM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ULTIMOITEM( cARQ, eKEY, mCOMP1, mCOMP2, eCAM, eVAR, lSOMA )

   LOCAL nRETU := 0

   IF !USEREDE( cARQ, 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   dbSeek( eKEY )
   WHILE &mCOMP1. = &mCOMP2. .AND. !Eof()
      nRETU := &eCAM.
      dbSkip()
   ENDDO
   dbCloseArea()
   IF ValType( eVAR ) = "C"
      IF ValType( lSOMA ) # "L"
         lSOMA := .T.
      ENDIF
      &eVAR. := if( lSOMA, nRETU := nRETU + 1, nRETU )
   ENDIF
   RETU nRETU


// + EOF: mlib28.prg
// +
