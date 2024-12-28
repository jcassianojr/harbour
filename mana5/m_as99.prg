// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_as99.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


//
// Movimenta‡„o da Pe‡a
//
//
aMAS99 := {}
IF !USEREDE( ARQWORK, 1, 2 )
RETU .F.
ENDIF
dbGoTop()
dbSeek( mCODIGO )
WHILE AllTrim( CODIGO ) == AllTrim( mCODIGO ) .AND. !Eof()
AAdd( aMAS99, ' ' + DToC( DATA ) + ' ' + MAS99( ARQUIVO ) + ' ' + Str( NUMERO, 8 ) + ' ' + OPERACAO + ' ' + Str( ESTQXXX, 11, 3 ) + ' ' + Str( QTDE, 11, 3 ) + IF( ESTQYYY > ESTQXXX, "+", "-" ) + ' ' + Str( ESTQYYY, 11, 3 ) + ' ' + USUARIO )
dbSkip()
ENDDO
dbCloseArea()
IF Len( aMAS99 ) = 0
ALERTX( "Sem Movimenta‡„o" )
RETU .F.
ENDIF
ESCARR( aMAS99, 2, 0, 23, 79,, "Data     Org Numero   O QTDE" )
RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAS99()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAS99( cARQUSO )

   LOCAL cARQ := "   "

   DO CASE
   CASE cARQUSO = "MY"
      cARQ := "REQ"
   CASE cARQUSO = "MK"
      cARQ := "NFE"
   CASE cARQUSO = "MM"
      cARQ := "NFV"
   ENDCASE
   RETU cARQ


// + EOF: m_as99.prg
// +
