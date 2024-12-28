// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib25.prg
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



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGAGET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PEGAGET( cARQ )

   aGETS := {}
   IF !USEREDE( HELPARQ, 1, 2 )
      RETU .F.
   ENDIF
   dbGoTop()
   dbSeek( PadR( cARQ, 8 ) + Str( 0, 3 ) )
   IF Found()
      WHILE DBF = cARQ .AND. !Eof()
         IF !Empty( SEQ )
            DO CASE
            CASE Type( "CONDICAO" ) = "C" .AND. Type( "PRECOND" ) = "C"
               AAdd( aGETS, { DADO, CAMPO, CONDICAO, PRECOND } )
            CASE Type( "CONDICAO" ) = "C"
               AAdd( aGETS, { DADO, CAMPO, CONDICAO } )
            OTHERWISE
               AAdd( aGETS, { DADO, CAMPO } )
            ENDCASE
         ENDIF
         dbSkip()
      ENDDO
   ELSE
      dbCloseArea()
      ALERTX( "Falta Configura‡„o dos Campos para o Edit" )
      RETU .F.
   ENDIF
   dbCloseArea()
   IF Len( aGETS ) = 0
      ALERTX( "Falta Configura‡„o para o modo Edit" )
      RETU .F.
   ENDIF
   RETU .T.


// + EOF: mlib25.prg
// +
