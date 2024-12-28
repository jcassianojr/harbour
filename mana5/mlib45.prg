// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib45.prg
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



#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ZAPARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ZAPARQ( aARQ )

   LOCAL W

   IF ValType( aARQ ) # "A"
      ALERTX( "Parametro ZAPARQ n„o ‚ Matriz" )
      RETURN .F.
   ENDIF
   FOR W := 1 TO Len( aARQ )
      MDS( "Zerando Arquivo: " + aARQ[ W, 1 ] )
      WHILE !USEREDE( aARQ[ W, 1 ], 0, 99 )
      ENDDO
      ZAP
      dbSetOrder( 1 )
      IF aARQ[ W, 2 ]
         dbCloseArea()
      ENDIF
      IF aARQ[ W, 3 ]
         INITVARS()
         CLRVARS()
      ENDIF
   NEXT W



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NOVOREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION NOVOREG( cARQ, eCHAVE, lMES, lLOG, nIND )

   LOCAL RETORNO := .F.

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF ValType( lLOG ) # "L"
      lLOG := .T.
   ENDIF
   IF !USEREDE( cARQ, 1, 99 )
      RETURN .F.
   ENDIF
   IF ValType( nIND ) = "N"
      dbSetOrder( nIND )
   ENDIF
   dbGoTop()
   IF !dbSeek( eCHAVE )
      netrecapp()
      REPLVARS()
      RETORNO := .T.
   ENDIF
   dbUnlock()
   dbCommit()
   dbCloseArea()
   IF !RETORNO .AND. lMES
      ALERTX( "Registro ja cadastrado com esta chave" )
   ENDIF
   IF lLOG
      gravalog( eCHAVE, "INS", cARQ )
   ENDIF

   RETURN RETORNO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function USEMULT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION USEMULT( aARQ )

   LOCAL W

   IF ValType( aARQ ) # "A"
      ALERTX( "Parametro USEMULT nAo E Matriz" )
      RETURN .F.
   ENDIF
   FOR W := 1 TO Len( aARQ )
      IF !USEREDE( aARQ[ W, 1 ], aARQ[ W, 2 ], aARQ[ W, 3 ] )
         dbCloseAll()
         RETURN .F.
      ENDIF
      IF aARQ[ W, 3 ] = 99
         dbSetOrder( 1 )
      ENDIF
   NEXT W

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NOVOOPE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NOVOOPE( cARQ, eCHAVE )

   IF ValType( cARQ ) = "C"
      dbSelectAr( cARQ )
   ENDIF
   dbGoTop()
   IF !dbSeek( eCHAVE )
      netrecapp()
      REPLVARS()
   ELSE
      MDS( "Registro ja Cadastrado: " + STRVAL( cARQ ) + STRVAL( eCHAVE ) )
      RETURN .F.
   ENDIF

   RETURN .T.

// Arquivo,Lock


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NOVOOPA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NOVOOPA( cARQ, lUNL, lREP, lCHECK )

   IF ValType( lUNL ) # "L"
      lUNL := .T.
   ENDIF
   IF ValType( lREP ) # "L"
      lREP := .T.
   ENDIF
   IF ValType( lCHECK ) # "L"
      lCHECK := .T.
   ENDIF
   IF ValType( cARQ ) = "C"
      dbSelectAr( cARQ )
   ENDIF
   netrecapp()
   IF lREP
      REPLVARS( lCHECK )
   ENDIF
   IF lUNL
      dbUnlock()
   ENDIF

   RETURN .T.

// function ntxtmp
// local carq
// cARQ := TMPFILE(cRDDEXT)
// caRQ := substr(cARQ,1,at(".",cARQ) - 1)
// return carq




// + EOF: mlib45.prg
// +
