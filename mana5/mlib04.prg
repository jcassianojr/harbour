// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib04.prg
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
// +    Function CHECKCID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKCID( cSIGLA, cNOME )

   LOCAL lRETU := .F.
   LOCAL aLAT  := { "", "", "", "", "", "" }

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   ZDDD    := ""
   ZCEP    := ""
   ZCEPFIM := ""
   ZKM     := 0
   ZRUA    := ""
   IF cSIGLA = "XX" .OR. cSIGLA = "EX" .OR. cSIGLA = "??"
      MDS( "Exterior nao ser  checada cidade" )
      RETU .T.
   ENDIF
   IF !VERSEHA( "MD10", cSIGLA + AllTrim( Upper( TIRACE( &cNOME. ) ) ),,, .F., 1 )
      MDE( "MADA01", " : " + &cNOME. + " " )
      &cNOME. := ESCOLHECID( cSIGLA, &cNOME. )
   ENDIF
   IF !USEREDE( "MD10", 1, 1 )
      RETU lRETU
   ENDIF
   dbGoTop()
   IF dbSeek( cSIGLA + Upper( TIRACE( &cNOME. ) ) )
      lRETU   := .T.
      ZDDD    := DDD
      ZCEP    := INICEP
      ZCEPFIM := FIMCEP
      // ZKM     := KM
      aLAT[ 1 ] := LATITUDE
      aLAT[ 2 ] := LONGITUDE
      aLAT[ 3 ] := HEMISFERIO
      ZRUA      := "C" + cCODIBGE
   ENDIF
   IF dbSeek( zESTADO + zCIDADE )
      aLAT[ 4 ] := LATITUDE
      aLAT[ 5 ] := LONGITUDE
      aLAT[ 6 ] := HEMISFERIO
   ENDIF
   dbCloseArea()
   zKM := calcgeokm( geotodec( aLAT[ 1 ], aLAT[ 3 ] ), geotodec( aLAT[ 2 ], aLAT[ 3 ] ), geotodec( aLAT[ 4 ], aLAT[ 6 ] ), geotodec( aLAT[ 5 ], aLAT[ 6 ] ) )
   RETU lRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESCOLHECID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ESCOLHECID( cSIGLA, cCIDADE )

   LOCAL aCID := {}
   LOCAL nPOS

   IF ValType( cSIGLA ) # "C"
      cSIGLA := "SP"
   ENDIF
   IF ValType( cCIDADE ) # "C"
      cCIDADE := Space( 35 )
   ENDIF
   MDS( "Aguarde Pesquisando Cidades do Estado" )
   IF !USEREDE( "MD10", 1, 1 )
      RETU cCIDADE
   ENDIF
   dbGoTop()
   dbSeek( cSIGLA )
   WHILE UF = cSIGLA .AND. !Eof()
      AAdd( aCID, NOME )
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !Empty( aCID )
      nPOS    := AScan( aCID, cCIDADE )
      nPOS    := if( nPOS > 1, nPOS, 1 )
      nPOS    := ESCARR( aCID, 4, 5, 24 - 3, 63, nPOS, "Escolha o Cidade Desejado" )
      nPOS    := if( nPOS > 1, nPOS, 1 )
      cCIDADE := aCID[ nPOS ]
   ENDIF
   RETU cCIDADE


// + EOF: mlib04.prg
// +
