// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo41c.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// * Rejuste de Salarios por Faixa
// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fo41c()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fo41c

   PARA wFO41C

   CABEX( 'Calcular Reajuste Salarial' )
   MESD := MES
   @ 13, 02 SAY "Digite o Mˆs do Novo Sal rio ======> "
   @ 13, 44 GET MESD                                    PICT "##" RANGE 1, 12
   IF !READCUR()
      RETU .F.
   ENDIF
   IF !MDG( "Rejustar Sal rio do Mˆs de " + MMES( MESD ) )
      RETU .F.
   ENDIF
   MED    := 'SAL' + SubStr( MMES( MESD ), 1, 3 )
   zNORM  := OBTER( "FIRMA",, NREMP, "SALNOR" )
   FILTRO := "EMPTY(DEMITIDO)"
   FILTRO := FILTRO( FILTRO )

   IF !netuse( pes )
      RETU .F.
   ENDIF
   SET FILTER TO &FILTRO

   IF !netuse( "fo_fai" )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      mVALOR := 0
      mFAIXA := OBTER( "FUNCAO",, FUNCAO, "FAIXA" )
      mTIPO  := TIPO
      dbSelectAr( "fo_fai" )
      dbGoTop()
      IF dbSeek( mFAIXA )
         IF wFO41C = 0
            mVALOR := VALOR
         ELSE
            mVALOR := INDICE * zNORM
         ENDIF
      ENDIF
      dbSelectAr( pes )
      IF !Empty( mVALOR )
         // Corrige Mensalista
         mVALOR := IF( TIPO = "1" .OR. TIPO = 'M', mVALOR * MESHORA, mVALOR )
         netreclock()
         FIELD->&MED. := Round( mVALOR, 2 )
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()

// + EOF: fo41c.prg
// +
