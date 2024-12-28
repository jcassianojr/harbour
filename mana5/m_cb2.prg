// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cb2.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"

PADRAO( 1, 1, 0, ZARQ1, "Arquivo  I. Indice   Descri‡„o", ;
      "' '+mARQUIVO+' '+STR(mITEM,2)+' '+mINDICE+' '+mDESC", ;
      "MCB2", "MCB201", "MCB201", {|| MCB2INS() } ;
      , {|| PADARR( ZARQ1, mARQUIVO, "ARQUIVO", "mARQUIVO" ) }, ;
      {| nKEY, nPOS | MCB2TEC( nKEY, nPOS ) },,, .F. )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCB2TEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MCB2TEC( nKEY, nPOS )

   IF nKEY = K_ALT_ENTER
      mITEM := Val( SubStr( aPAD2[ nPOS ], 9, 2 ) )
      M_DB( "ARQUIVO=mARQUIVO.AND.ITEM=mITEM" )
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCB2INS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MCB2INS

   mITEM := Len( aPAD1 )
   mITEM++

   RETURN .T.

// + EOF: m_cb2.prg
// +
