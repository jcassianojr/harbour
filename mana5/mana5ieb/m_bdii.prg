// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdii.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BDII.PRG
// +
// +    Functions: Function MBDII()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdii()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdii

   PARA cIMPOSTO

   IF cIMPOSTO = "IPI"
      MDI( " Э Resumo por UF IPI" )
   ELSE
      MDI( " Э Resumo por UF ICM" )
   ENDIF



   aUF      := {}
   aVAL     := {}
   ZFOL     := 1
   cTIPOCAN := "T"

   @ 22, 00 SAY "Confirme o numero da Folha"
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
   @ 22, 40 GET ZFOL
   @ 23, 45 GET cTIPOCAN                                      PICT "!" VALID cTIPOCAN $ "TCN"
   IF !READCUR()
      RETU .F.
   ENDIF



   aRETU        := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
   ARQENT       := aRETU[ 5, 1 ]
   ARQSAI       := aRETU[ 5, 2 ]
   mCOMPETENCIA := aRETU[ 7 ]


   PRIV wNOME, wINSCR, wCGC, wJUCESPC, wJUCESPD
   PRIV wIMUNICI, wENDERECO, wCIDADE, wESTADO, wCEP, wBAIRRO
   pegempmbdi()


   IF MDG( "Apurar Entrada" )
      MDS( "Aguarde Apurando Entrada" )
      MBDII01( ARQENT )
   ENDIF

   IF MDG( "Apurar Saida" )
      MDS( "Aguarde Apurando Saida" )
      MBDII01( ARQSAI )
   ENDIF

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   MBDII()


// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDII()
// +
// +    Called from ( m_bdie.prg   )   1 -
// +                ( m_bdii.prg   )   1 - function mbdih()
// +                ( m_bdil.prg   )   1 - function mbdik01()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDII()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDII( lCAB )

   IF ValType( lCAB ) # "L"
      lCAB := .T.
   ENDIF
   IMPRESSORA()
   IF lCAB .OR. CTLIN > 40
      @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
      @  1, 83  SAY mCOMPETENCIA
      @  1, 97  SAY ZDATA
      @  1, 113 SAY Left( Time(), 5 )
      @  1, 128 SAY Str( ZFOL, 4 )
      @  2, 0   SAY repl( "-", 132 )
      @  3, 0   SAY "RESUMO MENSAL DE OPERACOES E/OU PRESTACOES POR UNIDADE DA FEDERACAO"
      @  4, 0   SAY "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
      @  4, 7   SAY wNOME
      @  4, 71  SAY mCOMPETENCIA
      @  5, 0   SAY "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
      @  5, 11  SAY wINSCR
      @  5, 32  SAY wCGC
      @  5, 59  SAY wJUCESPC
      @  5, 78  SAY wJUCESPD
      @  5, 105 SAY wIMUNICI
      @  6, 0   SAY "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
      @  6, 10  SAY wENDERECO
      @  6, 59  SAY wCIDADE
      @  6, 103 SAY wESTADO
      @  6, 111 SAY wCEP
      @  7, 0   SAY repl( "-", 132 )
      @  8, 27  SAY "UNI.FED.            VALOR CONTABIL           BASE DE CALCULO"
      @  9, 0   SAY repl( "=", 132 )
      CTLIN := 10
   ELSE
      @ CTLIN, 0 SAY repl( "=", 132 )
      CTLIN++
      @ CTLIN, 0 SAY "RESUMO MENSAL DE OPERACOES E/OU PRESTACOES POR UNIDADE DA FEDERACAO    "
      CTLIN++
      @ CTLIN, 0 SAY repl( "-", 132 )
      CTLIN++
      @ CTLIN, 27 SAY "UNI.FED.            VALOR CONTABIL           BASE DE CALCULO"
      CTLIN++
      @ CTLIN, 0 SAY repl( "=", 132 )
      CTLIN++
   ENDIF
   FOR X := 1 TO Len( aUF )
      cUF := if( aUF[ X ] == "XX", "EX", aUF[ X ] )
      @ CTLIN, 30 SAY cUF
      @ CTLIN, 47 SAY aVAL[ X, 1 ] PICT "@E 999,999,999.99"
      @ CTLIN, 73 SAY aVAL[ X, 2 ] PICT "@E 999,999,999.99"
      CTLIN++
   NEXT X
   IMPFOL()
   VIDEO()
   IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDII01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDII01( cARQ )

   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF !USEMULT( { { "MA01", 1, 1 }, { "MB01", 1, 1 }, { cARQ, 1, 0 } } )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 40 SAY NUMERO
      IF SOMACANCEL()
         mTIPOFOR   := TIPOFOR
         mESTADO    := "  "
         mFORNECEDO := FORNECEDO
         dbSelectAr( if( mTIPOFOR = "C", "MA01", "MB01" ) )
         dbGoTop()
         IF dbSeek( mFORNECEDO )
            mESTADO := ESTADO
         ENDIF
         dbSelectAr( cARQ )
         nPOS := AScan( aUF, mESTADO )
         IF nPOS > 0
            IF cIMPOSTO = "IPI"
               aVAL[ nPOS, 1 ] += DVALORNF
               aVAL[ nPOS, 2 ] += DBASEIPI
            ELSE
               aVAL[ nPOS, 1 ] += DVALORNF
               aVAL[ nPOS, 2 ] += DBASEICM
            ENDIF
         ELSE
            AAdd( aUF, mESTADO )
            IF cIMPOSTO = "IPI"
               AAdd( aVAL, { DVALORNF, DBASEIPI } )
            ELSE
               AAdd( aVAL, { DVALORNF, DBASEICM } )
            ENDIF
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU

// + EOF: M_BDII.PRG

// + EOF: m_bdii.prg
// +
