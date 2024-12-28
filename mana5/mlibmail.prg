// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlibmail.prg
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
// +    Function EMAILINT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC EMAILINT( cERRO, cTEXTO )

   LOCAL cDBF := Alias()

   cDIGA := cTEXTO
   cDIZ  := ""
   IF ValType( cDIGA ) = "A"
      FOR X := 1 TO Len( cDIGA )
         cDIZ += cDIGA[ X ] + Chr( 13 ) + Chr( 10 )
      NEXT X
   ELSE
      cDIZ := cTEXTO
   ENDIF
   WHILE !USEMULT( { { "MAIL", 1, 0 }, { "MAILERRO", 1, 1 }, { "MAILPARA", 1, 1 } } )
   ENDDO
   dbSelectAr( "MAILERRO" )
   dbGoTop()
   IF dbSeek( cERRO )
      cASSUNTO := ASSUNTO
      dbSelectAr( "MAILPARA" )
      dbGoTop()
      dbSeek( cERRO )
      WHILE ERRO = cERRO .AND. !Eof()
         cDESTINO := DESTINO
         dbSelectAr( "MAIL" )
         netrecapp()
         FIELD->NUMERO  := RecNo()
         FIELD->DATA    := Date()
         FIELD->HORA    := Time()
         FIELD->DE      := ZUSER
         FIELD->ERRO    := cERRO
         FIELD->DESTINO := cDESTINO
         FIELD->ASSUNTO := cASSUNTO
         FIELD->TEXTO   := cDIZ
         dbSelectAr( "MAILPARA" )
         dbSkip()
      ENDDO
   ENDIF
   dbSelectAr( "MAIL" )
   dbCloseArea()
   dbSelectAr( "MAILERRO" )
   dbCloseArea()
   dbSelectAr( "MAILPARA" )
   dbCloseArea()
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU .T.

// + EOF: mlibmail.prg
// +
