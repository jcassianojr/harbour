// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3e.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto_3e()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_3e

   PARA cTIPO

   IF !MDL( 'FOPTO_3E - Passagens de Funcion rios ' )
      RETU
   ENDIF

   ntipo := PEGRELOGIO()

   CTLIN := 80
   PAG   := 1
   DIAX  := Date()

   cARQ := TARQREL( nTIPO, .T., cTIPO )

   IF cTIPO # "D"
      IF !NETUSE( cARQ,,,,, .F., )
         RETU
      ENDIF
   ELSE
      IF !NETUSE( carq )
         RETU
      ENDIF
      dbSetOrder( 2 )
   ENDIF


   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO

   IMPRESSORA()
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 50
         CABEC( "Passagens", "" )
         CTLIN := 8
      ENDIF
      @ CTLIN, 00 SAY NUMERO
      @ CTLIN, 09 SAY HORA
      @ CTLIN, 17 SAY DATA
      dbSkip()   // 3 Colunas Diferentes Razao Skip
      IF !Eof()
         @ CTLIN, 26 SAY NUMERO
         @ CTLIN, 35 SAY HORA
         @ CTLIN, 43 SAY DATA
      ENDIF
      dbSkip()
      IF !Eof()
         @ CTLIN, 52 SAY NUMERO
         @ CTLIN, 61 SAY HORA
         @ CTLIN, 69 SAY DATA
      ENDIF
      CTLIN++
      dbSkip()
   ENDDO
   IMPFOL()
   dbCloseAll()
   IMPEND()

// + EOF: fopto_3e.prg
// +
