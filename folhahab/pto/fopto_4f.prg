// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4f.prg Alterar Cadastro De Turno
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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

#include "INKEY.CH"
#include "BOX.CH"


FUNCTION fopto_4f()

   PADRAO( "TABTURNO", "TABTURNO", "mCODIGO+' '+mNOME", "mCODIGO", "FOPTO_4F - Cadastro de Turnos", "Codigo Descri‡„o", ;
      {|| PEGCHAVE( "mCODIGO", Space( 2 ), "Codigo:" ) }, {|| tFOPTO4F() }, {|| gFOPTO4F() }, {|| FO_RELL( "PONTOCAD08" ) },, 2,,, "X" )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4F()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4F

   @  6, 4  SAY mCODIGO
   @  6, 10 GET mNOME      WHEN INCLUI
   @  7, 10 GET mNOM2      WHEN INCLUI
   @  9, 10 GET mDESCRICAO
   @ 12, 5  GET mAPURA
   @ 12, 10 GET mFORMULA
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4F()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4F

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Codigo  Descri‡„o para Etiqueta"
   @  8, 10 SAY "Descri‡„o/Obs"
   @ 11, 3  SAY "Apura  Formula de Apura‡„o"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function trocahtt()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC trocahtt( nTIPO )

   CABE2( 'FOPTO_4G - Trocar Turno Descritivo' )
   mANT    := "  "
   mHTT    := "  "
   mHT     := ""
   mNUMERO := 0
   mDATA   := Date()
   IF nTIPO = 1
      @ 23, 00 SAY "Funcionario:          Horario Antigo:          Novo:    Data:"
   ELSE
      @ 23, 00 SAY "                      Horario Antigo:          Novo:    Data:"
   ENDIF
   SET KEY K_F11 TO TECLAF11
   @ 23, 12 GET mNUMERO WHEN nTIPO = 1                                                    PICT "99999999"
   @ 23, 38 GET mANT    WHEN nTIPO = 2                                                    VALID VERSEHA( "TABTURNO",, mANT, "NOME", "'Horario Nao Cadastrado'" )
   @ 23, 53 GET mHTT    VALID VERSEHA( "TABTURNO",, mHTT, "NOME", "'Horario Nao Cadastrado'" )
   @ 23, 63 GET mDATA
   IF !READCUR()
      RETU .F.
   ENDIF
   SET KEY K_F11

   IF nTIPO = 2
      IF !MDG( "Trocar " + mANT + "->" + mHTT )
         RETU .F.
      ENDIF
   ENDIF

   mHT := OBTER( "TABTURNO",, mHTT, "NOME" )

   IF !NETUSE( "HTTTROCA" )
      dbCloseAll()
   ENDIF

   IF !NETUSE( "FO_PES" )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbGoTop()
   IF nTIPO = 1
      mANT := HT
      IF dbSeek( mNUMERO )
         netreclock()
         mANT       := HTT   // pega o codigo Atual
         FIELD->HTT := mHTT  // grava o novo
         field->HT  := mHT   // grava o descritivo
         dbUnlock()
      ENDIF
      dbSelectAr( "HTTTROCA" )
      dbAppend()
      replvars()
   ENDIF
   IF nTIPO = 2
      WHILE !Eof()
         petela( 9 )
         mNUMERO := NUMERO
         IF HTT = mANT .AND. Empty( DEMITIDO )
            netreclock()
            FIELD->HTT := mHTT
            FIELD->HT  := mHT
            dbUnlock()
            dbSelectAr( "HTTTROCA" )
            dbAppend()
            replvars()
            dbSelectAr( "FO_PES" )
         ENDIF
         dbSkip()
      ENDDO
   ENDIF
   dbCloseAll()
   RETU .T.

// : FIM: FOPTO_4F.PRG

// + EOF: fopto_4f.prg
// +
