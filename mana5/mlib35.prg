// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib35.prg
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
// +    Function COR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC COR( cCOR, lOPEN, lSET )

   LOCAL cCORRET := "W/N,N/W,N,N,N/W"

   IF ValType( lOPEN ) # "L"
      lOPEN := .T.
   ENDIF
   IF ValType( lSET ) # "L"
      lSET := .F.
   ENDIF
   IF lOPEN
      IF !USEREDE( "CORES", 1, 1 )
         IF lSET
            SetColor( cCORRET )
         ENDIF
         RETU cCORRET
      ENDIF
   ELSE
      dbSelectAr( "CORES" )
   ENDIF
   dbGoTop()
   IF dbSeek( cCOR )
      cCORRET := AllTrim( COR1 ) + ","
      cCORRET += AllTrim( COR2 ) + ","
      cCORRET += AllTrim( COR3 ) + ","
      cCORRET += AllTrim( COR4 ) + ","
      cCORRET += AllTrim( COR5 )
   ENDIF
   IF lOPEN
      dbCloseArea()
   ENDIF
   IF lSET
      SetColor( cCORRET )
   ENDIF
   RETU cCORRET



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CORARR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CORARR( aCOR, aVAR )

   LOCAL cSTR, cVAR, I
   LOCAL aRETU := {}
   LOCAL nFIM  := Len( aCOR )

   IF ValType( aCOR ) = "C"
      cSTR := aCOR
      nFIM := 7
      DO CASE
      CASE Len( aCOR ) = 3
         cSTR += "00"
      CASE Len( aCOR ) = 4
         cSTR += "0"
      ENDCASE
      ACOR := { cSTR + "1", cSTR + "2", cSTR + "5", cSTR + "6", cSTR + "7", cSTR + "3", cSTR + "4" }
   ENDIF
   IF !USEREDE( "CORES", 1, 1 )
      FOR i := 1 TO nFIM
         IF ValType( aVAR ) = "A"
            cVAR  := aVAR[ I ]
            &cVAR := "W/N,N/W,N,N,N/W"
         ELSE
            AAdd( aRETU, "W/N,N/W,N,N,N/W" )
         ENDIF
      NEXT i
   ELSE
      FOR i := 1 TO nFIM
         IF ValType( aVAR ) = "A"
            cVAR  := aVAR[ I ]
            &cVAR := COR( aCOR[ I ], .F. )
         ELSE
            AAdd( aRETU, COR( aCOR[ I ], .F. ) )
         ENDIF
      NEXT i
      dbCloseArea()
   ENDIF
   RETU aRETU


// + EOF: mlib35.prg
// +
