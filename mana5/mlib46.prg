// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib46.prg
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
// +    Function APAGAREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC APAGAREG( cARq, eBUSCA, lPERG, lMOVE, nIND, lLOG )  // ABRE UM ARQUIVO E MARCA DELECAO

// *****************************        &&PARA ARQUIVO,INDICE,CHAVE DE BUSCA
   IF ValType( lPERG ) # "L"
      lPERG := .T.
   ENDIF
   IF ValType( lMOVE ) # "L"
      lMOVE := .T.
   ENDIF
   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( lLOG ) # "L"
      lLOG := .T.
   ENDIF
   IF lPERG
      IF !mdg( 'Vocˆ Deseja Realmente Apagar? (S/n)', 'S' )
         RETU .F.
      ENDIF
   ENDIF
   IF !USEREDE( cARq, 1, 99 )
      RETU .F.
   ENDIF
   dbSetOrder( nIND )
   DELEREG(, eBUSCA,, lLOG )
// Ajusta Registro Paginado
   IF lMOVE
      IF Type( "cVIDE" ) = "C"
         IF cVIDE = "P"
            IF ValType( nREG ) = "N"
               SET ORDER TO nIND
               dbSkip()
               EQUVARS()
               nREG := RecNo()
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   dbCloseArea()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DELEREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC DELEREG( cARQ, eBUSCA, lSAL, lLOG, lTOP )

   IF ValType( lSAL ) # "L"
      lSAL := .F.
   ENDIF
   IF ValType( lLOG ) # "L"
      lLOG := .T.
   ENDIF
   IF ValType( lTOP ) # "L"
      lTOP := .F.
   ENDIF
   IF ValType( cARQ ) = "C"
      dbSelectAr( cARQ )
   ENDIF
   IF lTOP
      dbGoTop()
   ENDIF
   IF ValType( eBUSCA ) # "U"
      dbGoTop()
      IF !dbSeek( eBUSCA )
         RETU .F.
      ENDIF
   ENDIF
   netrecdel()
   IF lSAL
      dbSkip()
   ENDIF
   IF lLOG
      gravalog( eBUSCA, "DEL", cARQ )
   ENDIF
   RETU .T.


// + EOF: mlib46.prg
// +
