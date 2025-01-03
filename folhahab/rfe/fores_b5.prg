// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_b5.prg lanilha Funcion rios em F‚rias
// +
// +
// +
// +     Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

FUNCTION fores_b5()

   IF !MDL( 'Planilha Funcion rios em F‚rias', 0 )
      RETU
   ENDIF

   DATAINI := DATAFIM := Date()
   MDS( 'Digite as Datas Iniciais e Finais' )
   @ 24, 40 GET DATAINI
   @ 24, 50 GET DATAFIM
   READCUR()

   POS1 := SPAC( 40 )
   MDS( 'Digite Cabe‡ rio Complementar' )
   @ 24, 35 GET POS1
   READCUR()

   IF !NETUSE( "FO_FER" )  // AREDE("FO_FER","FO_FER",1)
      RETU
   ENDIF
   CTLIN := 80
   QTFUN := FL := 0
   IMPRESSORA()
   dbGoTop()
   WHILE !Eof()
      IF ( GOZOU1DE >= DATAINI .AND. GOZOU1DE <= DATAFIM ) .OR. ;
            ( GOZOU2DE >= DATAINI .AND. GOZOU2DE <= DATAFIM ) .OR. ;
            ( GOZOU1ATE >= DATAINI .AND. GOZOU1ATE <= DATAFIM .AND. !Empty( GOZOU1ATE ) ) .OR. ;
            ( GOZOU2ATE >= DATAINI .AND. GOZOU2ATE <= DATAFIM .AND. !Empty( GOZOU2ATE ) )
         IF CTLIN > 55
            FL++
            @  1, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
            @  2, 00  SAY IMPCHR( cIMPTIT ) + MSG2
            @  3, 00  SAY IMPCHR( cIMPTIT ) + ACENTO( 'Planilha de Funcion rios em F‚rias: de ' ) + DToC( DATAINI ) + " a " + DToC( DATAFIM )
            @  5, 0   SAY POS1
            @  5, 100 SAY Time()
            @  5, 110 SAY Date()
            @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
            @  6, 0   SAY REPL( '-', 132 )
            @  7, 1   SAY 'DEPTO'
            @  7, 7   SAY 'SETOR'
            @  7, 13  SAY ACENTO( 'SECAO' )
            @  7, 19  SAY 'CHAPA'
            @  7, 25  SAY 'REGISTRO'
            @  7, 34  SAY 'NOME'
            @  7, 64  SAY 'Per.Aquisitivo'
            @  7, 84  SAY 'Periodo Gozo'
            @  8, 0   SAY REPL( '-', 132 )
            CTLIN := 9
         ENDIF
         dbSelectAr( FO_FER )
         @ CTLIN, 2  SAY DEPTO
         @ CTLIN, 8  SAY SETOR
         @ CTLIN, 14 SAY SECAO
         @ CTLIN, 20 SAY CHAPA
         @ CTLIN, 26 SAY NUMERO
         @ CTLIN, 33 SAY NOME
         @ CTLIN, 64 SAY DATFERIAS
         @ CTLIN, 74 SAY DATFERIASF
         lLISTA := .F.
         IF ( GOZOU1DE >= DATAINI .AND. GOZOU1DE <= DATAFIM ) .OR. ;
               ( GOZOU1ATE >= DATAINI .AND. GOZOU1ATE <= DATAFIM .AND. !Empty( GOZOU1ATE ) )
            @ CTLIN, 84 SAY GOZOU1DE
            @ CTLIN, 94 SAY GOZOU1ATE
            lLISTA := .T.
         ENDIF
         IF ( GOZOU2DE >= DATAINI .AND. GOZOU2DE <= DATAFIM ) .OR. ;
               ( GOZOU2ATE >= DATAINI .AND. GOZOU2ATE <= DATAFIM .AND. !Empty( GOZOU2ATE ) )
            IF lLISTA
               CTLIN++
            ENDIF
            @ CTLIN, 84 SAY GOZOU2DE
            @ CTLIN, 94 SAY GOZOU2ATE
         ENDIF
         QTFUN++
         CTLIN++
      ENDIF
      dbSkip()
   ENDDO
   IF QTFUN > 0
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
      @ PRow() + 1, 20 SAY ACENTO( 'Quantidade de Funcion rios --> ' )
      @ PRow(), 53    SAY QTFUN                                     PICT '###'
      IMPFOL()
   ENDIF
   VIDEO()
   dbCloseAll()
   IMPEND()

   RETURN


// + EOF: fores_b5.prg
// +
