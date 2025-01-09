// +--------------------------------------------------------------------
// +
// +    Programa  : flib04hab.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function INFOR(mARQUIVO, aCHAVE, aINDICE, lCHECA, aTAG, lAPA)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION INFOR  

   PARA mARQUIVO, aCHAVE, aINDICE, lCHECA, aTAG, lAPA
   LOCAL nERRO, X
   LOCAL cFileAttr, nFileSize
   LOCAL dCreateDate, nCreateTime
   LOCAL dChangeDate, nChangeTime

   IF ValType( lCHECA ) # "L"
      lCHECA := .F.
   ENDIF
   IF ValType( aTAG ) = "U"  // Nao Passada tag
      aTAG := ""
   ENDIF
   IF ValType( lAPA ) # "L"
      lAPA := .T.
   ENDIF
   IF ValType( aCHAVE ) = "C"  // Caracter Vira Array
      aCHAVE  := { aCHAVE }
      aINDICE := { aINDICE }
      aTAG    := { aTAG }
   ENDIF
   FOR X := 1 TO Len( aINDICE )
      mINDICE := aINDICE[ X ]
      IF lCHECA  // Se Tiver o Indice nao Indexa
         IF REDEFILE( mINDICE, ordBagExt(), .F. )
            RETU .T.
         ENDIF
      ENDIF
      IF lAPA
         IF File( mINDICE + ordBagExt() )
            FErase( mINDICE + ordBagExt() )  // Apaga o Indice
         ENDIF
         IF File( ZDIRE + mINDICE + ordBagExt() )
            FErase( ZDIRE + mINDICE + ordBagExt() )  // Apaga o Indice empresa
         ENDIF
         IF File( ZDIRN + mINDICE + ordBagExt() )
            FErase( ZDIRN + mINDICE + ordBagExt() )  // Apaga o Indice ANUAL
         ENDIF
      ENDIF
   NEXT X

   IF !netuse( mARQUIVO,, .F., .F., .T., .F., 30 )
      // netuse(cARQ,cDRIVER,lSHA,lREAD,lNEW,lINDEX,nTIME )
      RETURN .F.
   ENDIF
   hb_DispBox( 6, 0, 23, 78, B_DOUBLE + " " )
   @  7, 3 SAY spac( 21 ) + "Quadro Informativo do Arquivo" + spac( 26 )
   @ 08, 4 SAY "Nome" + spac( 12 ) + Chr( 16 )
   @ 09, 4 SAY "Chave" + spac( 11 ) + Chr( 16 )
   @ 10, 4 SAY "Indice" + spac( 10 ) + Chr( 16 )
   @ 11, 4 SAY "TAG   " + spac( 10 ) + Chr( 16 )
   @ 12, 4 SAY "Registros" + spac( 7 ) + Chr( 16 )
   @ 13, 4 SAY "Movimentacao    " + Chr( 16 )


   @ 24, 00 SAY Chr( 16 ) + "  Aguarde Reorganizando  " + Chr( 17 )
   @ 08, 23 SAY Alias()
   @ 12, 23 SAY Str( LastRec(), 7 )
   @ 13, 23 SAY DToC( LUpdate() )
   PACK
   FOR X := 1 TO Len( aINDICE )
      mCHAVE  := aCHAVE[ X ]
      mINDICE := aINDICE[ X ]
      mTAG    := aTAG[ X ]
      IF Empty( mTAG ) .AND. Upper( ordBagExt() ) = ".CDX"
         mTAG := mINDICE
      ENDIF
      @ 09, 23 SAY AllTrim( mCHAVE )
      @ 10, 23 SAY AllTrim( mINDICE )
      @ 11, 23 SAY AllTrim( mTAG )

      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )


    IF Empty( mTAG )
         ordCondSet(,,,, {|| ZEI_FORT( nLASTREC,,, 1 )},, RecNo(),,,,,,,,,,,,, ) 
         ordCreate( mINDICE,, mCHAVE, {|| &mCHAVE}, )
      ELSE
         ordCondSet(,,,, {|| ZEI_FORT( nLASTREC,,, 1 )},, RecNo(),,,,,,,,,,,,, ) 
         ordCreate(, mTAG, mCHAVE, {|| &mCHAVE}, )
      ENDIF

      //IF Empty( mTAG )
      //   INDEX ON &mCHAVE TO &mINDICE EVAL ZEI_FORT( nLASTREC,,, 1 )
      //ELSE
      //   INDEX ON &mCHAVE TAG &mTAG. EVAL ZEI_FORT( nLASTREC,,, 1 )
      //ENDIF
   NEXT X
   dbCloseArea()
   SetColor( "W/N,N/W" )
   @ 06, 00 CLEAR
   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function REDEFILE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION REDEFILE( cARQ, cEXT, lMES )

   IF ValType( Lmes ) # "L"
      lMES := .T.
   ENDIF
   IF At( ".", cEXT ) = 0
      cEXT := "." + cEXT
   ENDIF
   IF !hb_FileExists( cARQ + cEXT )
      IF !hb_FileExists( ZDIRE + cARQ + cEXT )
         IF !hb_FileExists( ZDIRN + cARQ + cEXT )
            IF lMES
               ALERTX( 'REDEFILE Arquivo: ' + cARQ + cEXT + " NÆo Encontrado" )
            ENDIF
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
   RETU .T.


// + EOF: flib04hab.prg
// +
