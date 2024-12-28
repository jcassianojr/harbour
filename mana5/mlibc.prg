// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlibc.prg
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
// +    Function CONVUN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CONVUN( nQTDE, cUNI )

   DO CASE
   CASE cUNI == "CT"
      nQTDE := nQTDE * 100
   CASE cUNI == "ML"
      nQTDE := nQTDE * 1000
   ENDCASE
   RETU nQTDE




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PERC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PERC( nBAS, nDIV )

   LOCAL nPER := 0

   IF ValType( nBAS ) # "N"
      ALERTX( "PERC nBAS NÆo E Numerico" )
      RETU 0
   ENDIF
   IF ValType( nDIV ) # "N"
      ALERTX( "PERC nDIV NÆo E Numerico" )
      RETU 0
   ENDIF
   IF nBAS > 0 .AND. nDIV > 0
      IF nBAS = nDIV
         nPER := 100
      ELSE
         nPER := Round( nBAS / nDIV * 100, 2 )
      ENDIF
   ENDIF
   RETU nPER




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PER2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PER2( nBAS, nDIV, nARR )

   LOCAL nPER := 0

   IF nBAS > 0 .AND. nDIV > 0
      IF nBAS = nDIV
         nPER := 100
      ELSE
         nPER := nBAS * nDIV / 100
      ENDIF
   ENDIF
   IF ValType( nARR ) = "N"
      nPER := Round( nPER, nARR )
   ENDIF
   RETU nPER



// + EOF: mlibc.prg
// +
