// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk57.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "hbclass.ch"
#include "inkey.ch"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function editarq()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION editarq( cfile )

// Verificando tamanho do arquivo
   IF Filesize( cfile ) > 64000
      ALERTX( 'Arquivo Muito Grande para ediao' )
      RETURN .F.
   ENDIF

//
   PRIV GETLIST := {}

// Criando Arquivo Back inicial
   IF File( cfile )
      pospto := At( ".", cfile )
      bak    := SubStr( cfile, 1, pospto - 1 ) + '.bak'
      fileCOPY( cfile, bak )
   ENDIF

   IF ( Empty( cfile ) )
      cfile := "semnome"
   ELSEIF ( RAt( ".", cfile ) <= RAt( "\", cfile ) )
      cfile += ".TXT"
   END

   oEditor := HBEditor():New( MemoRead( cFILE ), 0, 0, MaxRow(), MaxCol(), .T. )



// oEditor:SetColor( "W/B,N/BG" )
   oEditor:Display()

   WHILE ( nKey := Inkey( 0 ) ) != K_ESC
      oEditor:Edit( nKey )
      oEditor:Display()
   END

   RETURN NIL

// + EOF: disk57.prg
// +
