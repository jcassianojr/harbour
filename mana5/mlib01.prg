// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib01.prg
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
// +    Function CHECKTAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKTAB( cTAB, cNOME, cERRO, cSTR1, cSTR2, lVAZIO, nLEN )

   LOCAL cBUSCA
   LOCAL cDBF   := Alias()

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   cBUSCA := &cNOME.
   IF ValType( nLEN ) = "N"
      cBUSCA := StrZero( cBUSCA, nLEN )
   ENDIF
   IF ValType( lVAZIO ) = "L"
      IF lVAZIO
         IF Empty( cBUSCA )
            RETU .T.
         ENDIF
      ENDIF
   ENDIF
   IF !VERSEHA( "MD02", PadR( cTAB, 12 ) + PadR( cBUSCA, 12 ),,, .F. )
      MDE( cERRO, " : " + cBUSCA + " " )
      IF ValType( nLEN ) = "N"
         &cNOME. := Val( ESCOLHETAB( cTAB, cBUSCA, cSTR1, cSTR2, nLEN ) )
      ELSE
         &cNOME. := ESCOLHETAB( cTAB, CBUSCA, cSTR1, cSTR2, nLEN )
      ENDIF
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESCOLHETAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ESCOLHETAB( cTAB, cNOME, cSTR1, cSTR2, nLEN )

   LOCAL aTABA := {}
   LOCAL aTABB := {}
   LOCAL nPOS

   MDS( "Aguarde Pesquisando Tabela" )
   IF !USEREDE( "MD02", 1, 1 )
      RETU cNOME
   ENDIF
   dbGoTop()
   dbSeek( cTAB )
   WHILE CODIGO = cTAB .AND. !Eof()
      IF ValType( cSTR1 ) # "C"
         AAdd( aTABA, CODIGO1 + ' ' + DESCRICAO )
      ELSE
         AAdd( aTABA, &cSTR1. )
      ENDIF
      IF ValType( cSTR2 ) # "C"
         IF ValType( nLEN ) = "N"
            AAdd( aTABB, Left( CODIGO1, nLEN ) )
         ELSE
            AAdd( aTABB, CODIGO1 )
         ENDIF
      ELSE
         AAdd( aTABB, &cSTR2. )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !Empty( aTABA )
      nPOS  := AScan( aTABB, cNOME )
      nPOS  := if( nPOS > 1, nPOS, 1 )
      nPOS  := ESCARR( aTABA, 4, 5, 24 - 3, 63, nPOS, "Escolha o Item" )
      nPOS  := if( nPOS > 1, nPOS, 1 )
      cNOME := aTABB[ nPOS ]
   ENDIF
   RETU cNOME


// + EOF: mlib01.prg
// +
