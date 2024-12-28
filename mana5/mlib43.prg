// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib43.prg
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
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PADDEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PADDEL( cARQ, eBUSCA, eCOMP1, eCOMP2, nIND )

   LOCAL cDBF := Alias()

   WHILE !USEREDE( cARQ, 1, 99 )
   ENDDO
   IF ValType( nIND ) = "N"
      dbSetOrder( nIND )
   ENDIF
   dbSeek( eBUSCA )
   WHILE &eCOMP1. = &eCOMP2. .AND. !Eof()
      DELEREG(,, .T., .F. )
   ENDDO
   dbCloseArea()
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function BXITEM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC BXITEM( cARQ, cARQBX, eBUSCA, eCOMP1, eCOMP2 )

   WHILE !USEREDE( cARQ, 1, 99 )
   ENDDO
   WHILE !USEREDE( cARQBX, 1, 99 )
   ENDDO
   dbSelectAr( cARQ )
   dbGoTop()
   dbSeek( eBUSCA )
   WHILE &eCOMP1. = &eCOMP2. .AND. !Eof()
      EQUVARS()
      NOVOOPA( cARQBX, .T., .T. )
      DELEREG( cARQ,, .T., .F. )
   ENDDO
   dbCloseAll()
   RETU .T.


// + EOF: mlib43.prg
// +
