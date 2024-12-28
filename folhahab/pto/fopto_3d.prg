// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3d.prg
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
// +    Function fopto_3d()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_3d

   PARA nTIPO

   IF !MDL( 'FOPTO_3D - Passagens de Funcion rios n„o encontrados' )
      RETU
   ENDIF

   CTLIN := 80
   cPD   := PARQDIO()
   PAG   := 1
   DIAX  := Date()


   IF !NETUSE( cPD )
      RETU
   ENDIF
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO


   IF !NETUSE( PES )
      dbCloseAll()
      RETU
   ENDIF

   dbSelectAr( cPD )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY NUMERO
      @ 24, 10 SAY HORA
      @ 24, 20 SAY DATA
      mNUMERO := NUMERO
      dbSelectAr( PES )
      dbGoTop()
      IF !dbSeek( mNUMERO )
         IMPRESSORA()
         IF CTLIN > 50
            CABEC( "Passagens de Funcion rios n„o encontrados", "" )
            CTLIN := 8
         ENDIF
         dbSelectAr( cPD )
         @ CTLIN, 00 SAY NUMERO
         @ CTLIN, 10 SAY HORA
         @ CTLIN, 20 SAY DATA
         CTLIN++
         VIDEO()
      ENDIF
      dbSelectAr( cPD )
      dbSkip()
   ENDDO
   IMPRESSORA()
   IMPFOL()
   dbCloseAll()
   IMPEND()


// + EOF: fopto_3d.prg
// +
