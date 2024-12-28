// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdig.prg
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
// +    Source Module => J:\ITAESBRA\M_BDIG.PRG
// +
// +    Functions: Function MBDG01()
// +               Function MBDG02()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdig()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdig

   PARA nTIPO

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   IF nTIPO = 1
      MDI( " Э LIVRO DE APURAЂЋO IPI" )
   ELSE
      MDI( " Э LIVRO DE APURAЂЋO ICMS" )
   ENDIF

   cPERIODO := "1o. Decendio" + Space( 10 )
   cTIPOCAN := "T"

   aRETU        := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
   nMES         := aRETU[ 1 ]
   nANO         := aRETU[ 2 ]
   mCOMPETENCIA := aRETU[ 7 ]
   cAPUNEW      := "S"


   @ 21, 00 SAY "Mes Ano"
   @ 22, 00 SAY "Complemento"
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 21, 20 GET nMES                                          PICT "99"
   @ 21, 30 GET nANO                                          PICT "9999"
   @ 22, 30 GET cPERIODO
   @ 23, 50 GET cTIPOCAN                                      PICT "!"    VALID cTIPOCAN $ "TCN"
   @ 24, 40 GET cAPUNEW                                       PICT "!"    VALID cAPUNEW $ "SN"
   IF !READCUR()
      RETU .F.
   ENDIF

   PRIV wNOME, wINSCR, wCGC, wJUCESPC, wJUCESPD
   PRIV wIMUNICI, wENDERECO, wCIDADE, wESTADO, wCEP, wBAIRRO
   pegempmbdi()


   IF !USEREDE( "APUCFO", 0, 99 )
      RETU .F.
   ENDIF
   ZAP
   IF cAPUNEW = "S"
      dbSetOrder( 2 )
   ENDIF

   IF !MBDG02( aRETU[ 5, 1 ], "Entrada" )
      RETU .F.
   ENDIF
   IF !MBDG02( aRETU[ 5, 2 ], "Saida" )
      RETU .F.
   ENDIF

   ZFOL    := ZLIM := ZLIV := 0
   ZULT    := ZDATA
   CTLIN   := 80
   l200    := l300 := l500 := l600 := l700 := .T.
   aTOTSUB := Array( 6 )
   aTOTGER := Array( 6 )
   AFill( aTOTSUB, 0 )
   AFill( aTOTGER, 0 )

   IF nTIPO = 1
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGIPI", "FILIMIPI", "FILIVIPI", "FILAIPI" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   ELSE
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGICM", "FILIMICM", "FILIVICM", "FILAICM" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   ENDIF

   IF !USEREDE( "MD04", 1, IF( cAPUNEW = "S", 2, 3 ) )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( "APUCFO" )
   dbGoTop()
   WHILE !Eof()
      cCFO := IF( cAPUNEW = "S", CFONEW, CFO )
      cDES := ""
      dbSelectAr( "MD04" )
      dbGoTop()
      IF dbSeek( cCFO )
         cDES := Left( DESCRICAO, 45 )
      ENDIF
      dbSelectAr( "APUCFO" )
      IF !Empty( cDES )
         field->DESCRICAO := cDES
      ENDIF
      dbSkip()
   ENDDO
   dbSelectAr( "MD04" )
   dbCloseArea()

   IMPRESSORA()
   dbSelectAr( "APUCFO" )
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 54
         ZFOL++
         IF ZFOL = ZLIM
            M_BDIN( if( nTIPO = 2, 6, 8 ) )
            ZLIV++
            ZFOL := 1
            M_BDIN( if( nTIPO = 2, 5, 7 ) )
            ZFOL := 2
         ENDIF
         @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
         @  1, 82  SAY Left( MMES( nMES ), 3 ) + "/" + Str( nANO, 4 )
         @  1, 97  SAY ZDATA
         @  1, 113 SAY Left( Time(), 5 )
         @  1, 128 SAY Str( ZFOL, 4 )
         @  2, 0   SAY repl( "-", 132 )
         IF nTIPO = 1
            @  3, 0 SAY "R E G I S T R O  D E  A P U R A C A O  D O  I P I"
         ELSE
            @  3, 0 SAY "R E G I S T R O  D E  A P U R A C A O  D O  I C M S"
         ENDIF
         @  4, 0   SAY "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
         @  4, 7   SAY wNOME
         @  4, 71  SAY AllTrim( cPERIODO ) + " " + mCOMPETENCIA
         @  5, 0   SAY "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 12 ) + "INSC. Municipal:"
         @  5, 11  SAY wINSCR
         @  5, 32  SAY wCGC
         @  5, 59  SAY wJUCESPC
         @  5, 78  SAY wJUCESPD
         @  5, 106 SAY wIMUNICI
         @  6, 0   SAY "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
         @  6, 10  SAY wENDERECO
         @  6, 59  SAY wCIDADE
         @  6, 103 SAY wESTADO
         @  6, 111 SAY wCEP
         @  7, 0   SAY repl( "-", 132 )
         @  8, 0   SAY "CFO DESCRICAO" + spac( 40 ) + "VALOR          BASE DE      IMPOSTO    ISENTAS OU     O U T R A S   OBSERVACAO"
         @  9, 53  SAY "CONTABIL       CALCULO     CREDITADO  N/TRIBUTADAS"
         @ 10, 0   SAY repl( "=", 132 )
         CTLIN := 11
      ENDIF
      cCFO := AllTrim( IF( cAPUNEW = "S", CFONEW, CFO ) )
      nCFO := Val( cCFO )
      IF l200 .AND. nCFO >= if( cAPUNEW = "N", 200, 2000 )
         MBDG01( "Sub-Total", aTOTSUB,, .F. )
         l200 := .F.
         AFill( aTOTSUB, 0 )
      ENDIF
      IF l300 .AND. nCFO >= if( cAPUNEW = "N", 300, 3000 )
         MBDG01( "Sub-Total", aTOTSUB,, .F. )
         l300 := .F.
         AFill( aTOTSUB, 0 )
      ENDIF
      IF l500 .AND. nCFO >= if( cAPUNEW = "N", 500, 5000 )
         MBDG01( "Sub-Total", aTOTSUB,, .F. )
         MBDG01( "T O T A L", aTOTGER, "=" )
         l500 := .F.
         AFill( aTOTSUB, 0 )
         AFill( aTOTGER, 0 )
      ENDIF
      IF l600 .AND. nCFO >= if( cAPUNEW = "N", 600, 6000 )
         MBDG01( "Sub-Total", aTOTSUB,, .F. )
         l600 := .F.
         AFill( aTOTSUB, 0 )
      ENDIF
      IF l700 .AND. nCFO >= if( cAPUNEW = "N", 700, 7000 )
         MBDG01( "Sub-Total", aTOTSUB,, .F. )
         l700 := .F.
         AFill( aTOTSUB, 0 )
      ENDIF
      aVAL := { CONTABIL, BASE, VALOR, ISENTA, OUTRA, OBS }
      // IF CONTABIL+BASE+VALOR+ISENTA+OUTRA+OBS>0
      // Imprimir Sempre
      IF cAPUNEW = "S"
         @ CTLIN, 0 SAY CFONEW
      ELSE
         @ CTLIN, 0 SAY CFO
         @ CTLIN, 5 SAY SUBCFO
      ENDIF
      MBDG01( ACENTO( Left( DESCRICAO, 45 ) ), aVAL,, .F. )
      // ENDIF
      FOR X := 1 TO 6
         aTOTSUB[ X ] += aVAL[ X ]
         aTOTGER[ X ] += aVAL[ X ]
      NEXT X
      dbSkip()
   ENDDO
   MBDG01( "Sub-Total", aTOTSUB,, .F. )
   MBDG01( "T O T A L", aTOTGER, "=" )
   IMPFOL()
   VIDEO()

   IF MDG( "Gravar N§ Folha" )
      IF nTIPO = 1
         GRAVAMVAR( "FI_MES", Str( ZNUMERO, 5 ) + StrZero( nANO, 4 ) + StrZero( nMES, 2 ), "FIPAXIPI", "ZFOL" )
      ELSE
         GRAVAMVAR( "FI_MES", Str( ZNUMERO, 5 ) + StrZero( nANO, 4 ) + StrZero( nMES, 2 ), "FIPAXICM", "ZFOL" )
      ENDIF
   ENDIF

   IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDG01()
// +
// +    Called from ( m_bdig.prg   )   9 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDG01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDG01( cTITULO, aVAL, cTR, lSAL, lLIN )

// if aVAL[ 1 ] = 0 Sempre Imprimir
// retu .T.
// endif
   IF ValType( cTR ) # "C"
      cTR := "-"
   ENDIF
   IF ValType( lSAL ) # "L"
      lSAL := .T.
   ENDIF
   IF ValType( lLIN ) # "L"
      lLIN := .T.
   ENDIF
   @ CTLIN, 7 SAY Left( TIRACE( cTITULO ), 40 )
   FOR Y := 1 TO 6
      @ CTLIN, 34 + ( Y * 14 ) SAY aVAL[ Y ] PICT '@E 999999,999.99'
   NEXT Y
   IF lSAL
      CTLIN++
      @ CTLIN, 0 SAY repl( cTR, 132 )
   ENDIF
   IF lLIN
      CTLIN++
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDG02()
// +
// +    Called from ( m_bdig.prg   )   2 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDG02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDG02( cARQ, cTITULO )

   IF MDG( "Apurar " + cTITULO )
      MDS( "Aguarde Apurando " + cTITULO )
      FILTRO := ''
      FILTRO := RFILORD( cARQ, .F. )
      IF !USEREDE( Carq, 1, 0 )
         dbCloseAll()
         RETU .F.
      ENDIF
      IF !Empty( FILTRO )
         SET FILTER TO &FILTRO.
      ENDIF
      dbGoTop()
      WHILE !Eof()
         @ 24, 40 SAY NUMERO
         cCFONEW := DCFONEW
         cCFO    := DOPER
         cSUBCFO := SUBDOPER
         IF cAPUNEW = "N"
            mCHAVE := cCFO + cSUBCFO
         ELSE
            mCHAVE := DCFONEW
         ENDIF
         IF somacancel()
            IF nTIPO = 1
               aVAL := { DVALORNF, DBASEIPI, DVALIPI, ISENTAIPI, OUTRAIPI, OBSIPI }
            ELSE
               aVAL := { DVALORNF, DBASEICM, DVALICM, ISENTAICM, OUTRAICM, OBSICM }
            ENDIF
            dbSelectAr( "APUCFO" )
            dbGoTop()
            IF !dbSeek( mCHAVE )
               netrecapp()
               field->CFO    := cCFO
               field->SUBCFO := cSUBCFO
               field->CFONEW := cCFONEW
            ENDIF
            dbSelectAr( "APUCFO" )
            field->CONTABIL += aVAL[ 1 ]
            field->BASE     += aVAL[ 2 ]
            field->VALOR    += aVAL[ 3 ]
            field->ISENTA   += aVAL[ 4 ]
            field->OUTRA    += aVAL[ 5 ]
            field->OBS      += aVAL[ 6 ]
         ENDIF
         dbSelectAr( CArq )
         dbSkip()
      ENDDO
      dbCloseArea()
   ENDIF
   RETU .T.

// + EOF: M_BDIG.PRG

// + EOF: m_bdig.prg
// +
