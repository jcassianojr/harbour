// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib48.prg
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
// +    Function CHECKEXI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKEXI( cARQ, eBUSCA, cSTR1, cSTR2, cMES, lVAZIO, nPERT, lCOND, nIND, nIND2 )

   LOCAL cBUSCA
   LOCAL cDBF    := Alias()
   LOCAL nINDEXI

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF ValType( nIND ) # "N"  // Indice Busca
      nIND := 1
   ENDIF
   IF ValType( nIND2 ) # "N"   // Indice Escolha
      nINDEXI := nIND
   ENDIF
   IF ValType( eBUSCA ) = "A"
      cBUSCA := eBUSCA[ 1 ]
      cBUSCA := &cBUSCA.
   ELSE
      cBUSCA := &eBUSCA.
   ENDIF
   IF ValType( lVAZIO ) = "L"
      IF lVAZIO
         IF Empty( cBUSCA )
            RETU .T.
         ENDIF
      ENDIF
   ENDIF
   IF ValType( nPERT ) # "N"
      nPERT := 0
   ENDIF
   IF !VERSEHA( cARQ, cBUSCA, cSTR1,, .F., nIND )
      IF ValType( cMES ) = "C"
         MDE( cMES, " : " + STRVAL( cBUSCA ) + " " )
      ENDIF
      DO CASE
      CASE nPERT = 0
         IF ValType( eBUSCA ) = "A"
            cBUSCA   := eBUSCA[ 2 ]
            &cBUSCA. := ESCOLHEXI( cARQ, &cBUSCA., cSTR1, cSTR2, lCOND, nINDEXI )
         ELSE
            &eBUSCA. := ESCOLHEXI( cARQ, &eBUSCA., cSTR1, cSTR2, lCOND, nINDEXI )
         ENDIF
      ENDCASE
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESCOLHEXI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ESCOLHEXI( cARQ, cNOME, cSTR1, cSTR2, lCOND, nIND )

   LOCAL aTABA := {}
   LOCAL aTABB := {}
   LOCAL nPOS

   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   MDS( "Aguarde Pesquisando Tabela" )
   IF !USEREDE( cARQ, 1, nIND )
      RETU cNOME
   ENDIF
   dbGoTop()
   WHILE !Eof()
      IF ValType( lCOND ) # "C"
         AAdd( aTABA, &cSTR1. )
         AAdd( aTABB, &cSTR2. )
      ELSE
         IF &lCOND.
            AAdd( aTABA, &cSTR1. )
            AAdd( aTABB, &cSTR2. )
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !Empty( aTABA )
      nPOS := AScan( aTABB, cNOME )
      nPOS := if( nPOS > 1, nPOS, 1 )
      nPOS := ESCARR( aTABA, 4, 5, 24 - 3, 63, nPOS, "Escolha o Item" )
      nPOS := if( nPOS > 1, nPOS, 1 )
      IF LastKey() = K_ENTER
         cNOME := aTABB[ nPOS ]
      ENDIF
   ENDIF
   RETU cNOME


// + EOF: mlib48.prg
// +
