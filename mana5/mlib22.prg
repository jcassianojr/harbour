// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib22.prg
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



// *****************
// lGET - Se exibe ou se efetua o get
// COR1 - Cor da Descri‡„o Campo
// COR2 - Cor do Get Campo
// COR3 - Cor do Say Campo
// COR4 - Cor do Say Campo Em Destaque
//

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function EDITGET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC EDITGET( lGET, cCOR1, cCOR2, cCOR3, cCOR4 )

   LOCAL nPAG
   LOCAL nELE
   LOCAL X
   LOCAL Y
   LOCAL nCOL := 0
   LOCAL nPOS
   LOCAL aCOR

   IF ValType( lGET ) # "L"
      lGET := .T.
   ENDIF
   IF ValType( cCOR1 ) = "A"
      aCOR  := cCOR1
      cCOR1 := aCOR[ 1 ]
      cCOR2 := aCOR[ 2 ]
      cCOR3 := aCOR[ 3 ]
      cCOR4 := aCOR[ 4 ]
   ENDIF
   IF ValType( cCOR1 ) # "C"
      cCOR1 := "W/N,N/W,N,N,W/N"
   ENDIF
   IF ValType( cCOR2 ) # "C"
      cCOR2 := "W/N,N/W,N,N,W/N"
   ENDIF
   IF ValType( cCOR3 ) # "C"
      cCOR3 := "W/N,N/W,N,N,W/N"
   ENDIF
   IF ValType( cCOR4 ) # "C"
      cCOR4 := "W/N,N/W,N,N,W/N"
   ENDIF
   nPAG := Int( Len( aGETS ) / 20 ) + 1
   nELE := Len( aGETS )
   nDIM := Len( aGETS[ 1 ] )
   FOR X := 1 TO nELE
      IF Len( Trim( aGETS[ X, 1 ] ) ) > nCOL
         nCOL := Len( Trim( aGETS[ X, 1 ] ) )
      ENDIF
   NEXT
   nCOL += 3
// Se for exibir mostra somente uma pagina
   IF !lGET
      nPAG := 1
   ENDIF
   FOR X := 1 TO nPAG
      hb_DispBox( 2, 0, 24 - 1, 79, B_DOUBLE )
      FOR Y := 1 TO 20
         nPOS := Y + ( ( X - 1 ) * 20 )
         IF nPOS <= nELE
            cVARGET := Trim( aGETS[ nPOS, 2 ] )
            cLEN    := &cVARGET.
            SetColor( cCOR1 )
            @ Y + 2, 02 SAY aGETS[ nPOS, 1 ]
            IF !lGET
               SetColor( cCOR3 )
               IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                  @ Y + 2, nCOL SAY Left( &cVARGET., 35 )
               ELSE
                  @ Y + 2, nCOL SAY &cVARGET.
               ENDIF
            ELSE
               SetColor( cCOR2 )
               DO CASE
               CASE nDIM = 4
                  cVARCOND := Trim( aGETS[ nPOS, 3 ] )
                  cVARWHEN := Trim( aGETS[ nPOS, 4 ] )
                  DO CASE
                  CASE Empty( cVARCOND ) .AND. Empty( cVARWHEN )
                     IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                        @ Y + 2, nCOL GET &cVARGET. PICT "@S35"
                     ELSE
                        @ Y + 2, nCOL GET &cVARGET.
                     ENDIF
                  CASE Empty( cVARCOND ) .AND. !Empty( cVARWHEN )
                     IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                        @ Y + 2, nCOL GET &cVARGET. PICT "@S35" WHEN &cVARWHEN.
                     ELSE
                        @ Y + 2, nCOL GET &cVARGET. WHEN &cVARWHEN.
                     ENDIF
                  CASE !Empty( cVARCOND ) .AND. Empty( cVARWHEN )
                     IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                        @ Y + 2, nCOL GET &cVARGET. PICT "@S35" VALID &cVARCOND.
                     ELSE
                        @ Y + 2, nCOL GET &cVARGET. VALID &cVARCOND.
                     ENDIF
                  CASE !Empty( cVARCOND ) .AND. !Empty( cVARWHEN )
                     IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                        @ Y + 2, nCOL GET &cVARGET. PICT "@S35" VALID &cVARCOND. WHEN &cVARWHEN.
                     ELSE
                        @ Y + 2, nCOL GET &cVARGET. VALID &cVARCOND. WHEN &cVARWHEN.
                     ENDIF
                  ENDCASE
               CASE nDIM = 3
                  cVARCOND := Trim( aGETS[ nPOS, 3 ] )
                  IF Empty( cVARCOND )
                     IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                        @ Y + 2, nCOL GET &cVARGET. PICT "@S35"
                     ELSE
                        @ Y + 2, nCOL GET &cVARGET.
                     ENDIF
                  ELSE
                     IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                        @ Y + 2, nCOL GET &cVARGET. PICT "@S35" VALID &cVARCOND.
                     ELSE
                        @ Y + 2, nCOL GET &cVARGET. VALID &cVARCOND.
                     ENDIF
                  ENDIF
               OTHERWISE
                  IF ValType( cLEN ) = "C" .AND. Len( cLEN ) > 35
                     @ Y + 2, nCOL GET &cVARGET. PICT "@S35"
                  ELSE
                     @ Y + 2, nCOL GET &cVARGET.
                  ENDIF
               ENDCASE
            ENDIF
         ENDIF
      NEXT Y
      READCUR()
   NEXT X
   RETU .T.


// + EOF: mlib22.prg
// +
