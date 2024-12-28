// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foaa8.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foaa8()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foaa8

   PARA NN

   DO CASE
   CASE NN = 1
      CC1A := PES
      CC1B := PES
      CC2A := "CONTAS"
      CC2B := "CONTAS"
      CC3  := SEM
   CASE NN = 2
      CC1A := "MG01"
      CC1B := "MG01"
      CC2A := "CTARPA"
      CC2B := "CTARPA"
      CC3  := RPA
   ENDCASE
   CABEX( 'Entrada de dados folha Individualizado' )
   hb_DispBox( 6, 0, 23, 79, B_DOUBLE + " " )
   @  8, 3 SAY "Funcion rio :"
   @ 10, 3 SAY "Conta" + spac( 7 ) + ":"
   @ 12, 3 SAY "Semana" + spac( 6 ) + ":"
   @ 17, 3 SAY "<ESC>  Encerra"
   mNUMERO := 0
   mCONTA  := 0
   mSEMANA := 1
   mTIPO   := ""
   WHILE .T.
      mVALOR := 0
      mHORAS := 0
      SET KEY K_F11 TO TECLAF11
      @  8, 17 GET mNUMERO PICT "99999" VALID VERSEHA( CC1A,, mNUMERO, "NOME", '"Funcion rio N„o Cadastrado"' )
      @ 10, 17 GET mCONTA  PICT "999"   VALID VERSEHA( CC2A,, mCONTA, "DESCR", '"Conta n„o cadastrada"' )
      @ 12, 17 GET mSEMANA PICT "9"
      IF !READCUR() .OR. Empty( mNUMERO ) .OR. Empty( mCONTA )
         SET KEY K_F11 TO
         EXIT
      ENDIF
      SET KEY K_F11 TO
      mTIPO := OBTER( CC2A,, mCONTA, "TIPO" )
      IF netuse( cc3 )
         dbGoTop()
         IF !dbSeek( mNUMERO * 10000 + mSEMANA * 1000 + mCONTA )
            netrecapp()
            FIELD->NUMERO := mNUMERO
            FIELD->CONTA  := mCONTA
            FIELD->SEMANA := mSEMANA
         ELSE
            mVALOR := VALOR
            mHORAS := HORAS
         ENDIF
      ENDIF
      dbCloseArea()
      @ 14, 01 CLEA TO 14, 78
      IF mTIPO = 1 .OR. mTIPO = 3 .OR. mTIPO = 4
         @ 14, 03 SAY "Quantidade de Horas"
         @ 14, 25 GET mHORAS                PICT '###.##'
         READCUR()
      ELSE
         @ 14, 03 SAY "Valor"
         @ 14, 25 GET mVALOR  PICT '###,###,###.##'
         READCUR()
      ENDIF
      IF netuse( cc3 )   // AREDE(CC3,CC3,0)
         dbGoTop()
         IF dbSeek( mNUMERO * 10000 + mSEMANA * 1000 + mCONTA )
            netreclock()
            IF mTIPO = 1 .OR. mTIPO = 3 .OR. mTIPO = 4
               FIELD->HORAS := mHORAS
            ELSE
               FIELD->VALOR := mVALOR
            ENDIF
            dbUnlock()
         ENDIF
      ENDIF
      dbCloseArea()
   ENDDO
   IF netuse( cc3 )  // AREDE(CC3,CC3,0)
      FODZER()
      dbCloseArea()
   ENDIF

// + EOF: foaa8.prg
// +
