// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib18.prg
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



// #INCLUDE "COMANDO.CH"




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function REGBUS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC REGBUS( cARQ, nIND, cKEYINDEX, lABRE )

   LOCAL nREGRET := 0
   LOCAL cIND
   LOCAL ACHADO  := .F.
   LOCAL cCOND   := ""
   LOCAL nREC    := 0
   LOCAL cTXT    := ''
   LOCAL aBUS    := {}
   LOCAL aBUS1   := {}

   IF ValType( nREG ) # "N"
      nREG := 1
   ENDIF
   IF ValType( cKEYINDEX ) = "C"
      cKEYINDEX := Trim( cKEYINDEX )
   ENDIF
   IF ValType( lABRE ) # "L"
      lABRE := .T.
   ENDIF
   IF lABRE
      IF !USEREDE( cARQ, 1, nIND )
         ALERTX( "N„o Consegui Abrir o Arquivo" )
         RETU nREG
      ENDIF
   ENDIF
// dbgoto( nREG ) //posicionava no atual so fazia pesquisa progressiva
   dbGoTop()
   IF dbSeek( cKEYINDEX )
      EQUVARS()
      nREGRET  := RecNo()
      FORMULA  := aIND[ 1, 4 ]
      VARIAVEL := aIND[ 1, 1, 3 ]
      mCHAVE   := if( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
      ACHADO   := .T.
   ENDIF
   IF ValType( cKEYINDEX ) = "N"   // Simula Soft Seek
      IF !Eof()
         EQUVARS()
         nREGRET  := RecNo()
         FORMULA  := aIND[ 1, 4 ]
         VARIAVEL := aIND[ 1, 1, 3 ]
         mCHAVE   := if( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
      ENDIF
   ENDIF
   IF lABRE
      dbCloseArea()
   ENDIF
   IF !ACHADO .AND. ValType( cKEYINDEX ) = "C"
      IF mdg( "Fazer Pesquisa Avan‡ada ? ", 1 )
         IF lABRE
            IF !USEREDE( cARQ, 1, nIND )
               ALERTX( "N„o Consegui Abrir o Arquivo" )
               RETU nREG
            ENDIF
         ENDIF
         cIND := Trim( IndexKey( 0 ) )
         IF !Empty( cIND )
            cCOND := '"' + Upper( cKEYINDEX ) + '"' + "$" + cIND
            LOCATE FOR &cCOND.
            MDS( PadC( "Aguarde, localizando ...", 80 ) )
            nACHEI := 0
            nREC   := RecNo()
            WHILE !Eof()
               AAdd( aBUS, &cIND. )
               AAdd( aBUS1, RecNo() )
               IF nACHEI = 0
                  cTXT := 'Achei: ' + Trim( PadR( &cIND, 50 ) ) + ', continua?'
                  IF !MDG( cTXT, 1 )
                     EXIT
                  ENDIF
                  nACHEI := 1
               ENDIF
               CONTINUE
               MDS( PadC( "Aguarde, localizando ...", 80 ) )
            ENDDO
            CLSROW( 24 )
            IF Len( aBUS ) = 1
               EQUVARS()
               nREGRET := RecNo()
               IF lABRE
                  dbCloseArea()
               ENDIF
               FORMULA  := aIND[ 1, 4 ]
               VARIAVEL := aIND[ 1, 1, 3 ]
               mCHAVE   := if( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
               RETU nREGRET
            ENDIF
            IF lABRE
               dbCloseArea()
            ENDIF
            IF Len( aBUS ) = 0
               ALERTX( "N„o Encontrado" )
               RETU nREG
            ENDIF
            nFIL := ESCARR( aBUS, 4, 5, 24 - 3, 63,, "Escolha a Pesquisa Desejada" )
            nFIL := if( nFIL > 0, nFIL, 1 )
            IF lABRE
               IF !USEREDE( cARQ, 1, nIND )
                  ALERTX( "N„o Consegui Abrir o Arquivo" )
                  RETU nREG
               ENDIF
            ENDIF
            dbGoto( aBUS1[ nFIL ] )
            EQUVARS()
            nREGRET := RecNo()
            IF lABRE
               dbCloseArea()
            ENDIF
            FORMULA  := aIND[ 1, 4 ]
            VARIAVEL := aIND[ 1, 1, 3 ]
            mCHAVE   := if( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
         ELSE
            IF lABRE
               dbCloseArea()
            ENDIF
            RETU nREG
         ENDIF
         IF lABRE
            dbCloseArea()
         ENDIF
      ENDIF
   ENDIF
   IF !ACHADO
      ALERTX( "N„o Encontrado" )
      RETU nREG
   ENDIF
   RETU nREGRET


// + EOF: mlib18.prg
// +
