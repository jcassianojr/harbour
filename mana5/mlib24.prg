// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib24.prg
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
// +    Function GRAVAMVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC GRAVAMVAR( cARQ, cBUS, aCAM, aVAR, nIND, lMES )   // P ARQUIVO, E CHAVE DE BUSCA

   LOCAL lRETU   := .F.
   LOCAL DBF_USO := Alias()
   LOCAL aLAY
   LOCAL X

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF ValType( aVAR ) = "C" .AND. ValType( aCAM ) = "C"  // Transforma Matriz
      aCAM := { aCAM }
      aVAR := { aVAR }
   ENDIF
   aLAY  := {}
   aLAY  := { aCAM, aVAR }
   lRETU := GRAVALAY( aLAY, cARQ, nIND, .T., cBUS, .F. )
   IF !lRETU .AND. lMES
      ALERTX( "Gravamvar: N„o encontrei o registro: " + cARQ + " " + STRVAL( cBUS ) )
   ENDIF
   RETU lRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGLAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGLAY( cARQ, cCODIGO )

   aLAY1 := {}
   aLAY2 := {}
   IF !USEREDE( cARQ, 1, 1 )
      RETU { aLAY1, aLAY2 }
   ENDIF
   dbGoTop()
   dbSeek( cCODIGO )
   WHILE CODIGO = cCODIGO .AND. !Eof()
      AAdd( aLAY1, AllTrim( VARDES ) )
      AAdd( aLAY2, AllTrim( VARDRI ) )
      dbSkip()
   ENDDO
   dbCloseAre()
   RETU { aLAY1, aLAY2 }



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVALAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRAVALAY( aLAY, cARQ, nIND, lOPE, cBUS, lAPE, lLOG )

   LOCAL DBF_USO := Alias()
   LOCAL W

   IF ValType( lLOG ) # "L"
      lLOG := .F.
   ENDIF

// Alay Bidimensional {{campos,..},{variaveis,..}}
   IF ValType( aLAY ) # "A"
      ALERTX( "GRAVALAY variavel aLAY, Nao ‚ uma Matriz" )
      RETU .F.
   ENDIF
   IF Len( aLAY ) = 0
      ALERTX( "GRAVALAY Matriz aLAY Vazia" )
      RETU .F.
   ENDIF
   IF ValType( lOPE ) # "L"
      lOPE := .F.
   ENDIF
   IF lOPE
      IF !USEREDE( cARQ, 1, 99 )
         RETU .F.
      ENDIF
   ENDIF
   IF ValType( cARQ ) = "C" .AND. !lOPE
      dbSelectAr( cARQ )
   ENDIF
   IF ValType( nIND ) = "N"
      dbSetOrder( nIND )
   ENDIF
   IF ValType( lAPE ) # "L"
      lAPE := .F.
   ENDIF
   IF ValType( cBUS ) # "U"
      dbGoTop()
      IF !dbSeek( cBUS )
         IF !lAPE
            IF lOPE
               dbCloseArea()
            ENDIF
            IF !Empty( DBF_USO )
               SELE &DBF_USO
            ENDIF
            RETU .F.
         ELSE
            netrecapp()
         ENDIF
      ENDIF
   ELSE
      IF lAPE
         netrecapp()
      ENDIF
   ENDIF
   netreclock()
   GRAVACAMPO( aLAY[ 1 ], aLAY[ 2 ] )
   dbUnlock()
   dbCommit()
   IF lOPE
      dbCloseArea()
   ENDIF
   IF !Empty( DBF_USO )
      dbSelectAr( DBF_USO )
   ENDIF
   RETU .T.


// + EOF: mlib24.prg
// +
