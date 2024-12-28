// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib23.prg
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
// +    Function PEGACAMPO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PEGACAMPO( cARQUIVO, cBUSCA, cVARBUSCA, cVARGRAVA, nIND, lVAZIO, lOPEN, aPAD )

   LOCAL lRET   := .T.
   LOCAL X
   LOCAL dbfuso := Alias()

   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF Empty( cARQUIVO )  // Fixas buscar de referencia manter
      gravavars( cVARGRAVA, aPAD )
      RETU .F.
   ENDIF
   IF ValType( lOPEN ) # "L"
      lOPEN := .T.
   ENDIF
   IF ValType( lVAZIO ) = "L"
      IF lVAZIO
         IF Empty( &cBUSCA )
            gravavars( cVARGRAVA, aPAD )
            RETU .T.
         ENDIF
      ENDIF
   ENDIF
   IF lOPEN
      IF !USEREDE( cARQUIVO, 1, nIND )
         gravavars( cVARGRAVA, aPAD )
         RETU .F.
      ENDIF
   ELSE
      dbSelectAr( cARQUIVO )
   ENDIF
   dbGoTop()
   IF dbSeek( &cBUSCA. )
      IF ValType( cVARGRAVA ) = "C" .AND. ValType( cVARBUSCA ) = "C"
         &cVARGRAVA. := &cVARBUSCA.
      ELSE
         gravavars( cVARGRAVA, cvarbusca )
      ENDIF
   ELSE
      gravavars( cVARGRAVA, aPAD )
      lRET := .F.
   ENDIF
   IF lOPEN
      dbCloseArea()
   ENDIF
   IF !Empty( dbfuso )
      dbSelectAr( dbfuso )
   ENDIF

   RETURN lRET



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVAVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC GRAVAVARS( aCam, Aval )

   LOCAL x
   LOCAL campo
   LOCAL valor

   IF ValType( aCAM ) = "A" .AND. ValType( aVal ) = "A"
      FOR X := 1 TO Len( aCAM )
         campo   := aCAM[ X ]
         valor   := aVAL[ X ]
         &campo. := &valor.
      NEXT X
   ENDIF




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVAVAR2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRAVAVAR2( aDAD )

   GRAVAVARS( aDAD[ 1 ], aDAD[ 2 ] )


// + EOF: mlib23.prg
// +
