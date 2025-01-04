// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3g.prg Total de Passagens Diaria por funcion rios
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


FUNCTION fopto_3g()

   IF !MDL( "FOPTO_3G - Total de Passagens Diaria por funcion rios" )
      RETU
   ENDIF
   CTLIN := 80
   cPA   := PARQDIO()

   IF !NETUSE( "FIRMA" )
      RETU
   ENDIF
   dbGoTop()
   dbSeek( NREMP )


   IF !NETUSE( cPA )
      dbCloseAll()
      RETU
   ENDIF
   FILTRO   := FILTRO( "" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "DATA" )
   ordSetFocus( "temp" )
   SET FILTER TO &FILTRO

   IMPRESSORA()
   dbSelectAr( cPA )
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 55
         IF CTLIN # 80
            IMPFOL()
         ENDIF
         dbSelectAr( "FIRMA" )
         @  0, 0  SAY repl( '=', 79 )
         @  1, 0  SAY "FOLHA DE PONTO - " + AllTrim( RAZAO )
         @  1, 56 SAY "CGC:" + CGC
         @  2, 0  SAY "End: " + ENDERECO + " - " + BAIRRO + " - " + CIDADE + " - " + ESTADO
         @  3, 0  SAY "Data"
         @  3, 50 SAY ACENTO( "No. Passagens" )
         @  4, 0  SAY repl( '-', 79 )
         CTLIN := 5
      ENDIF
      REF := 0
      dbSelectAr( cPA )
      mDATA := DATA
      WHILE mDATA = DATA .AND. !Eof()
         REF++
         dbSkip()
      ENDDO
      IF REF > 0
         @ CTLIN, 0  SAY mDATA
         @ CTLIN, 50 SAY Str( REF )
         CTLIN++
      ENDIF
   ENDDO
   IF CTLIN # 80
      IMPFOL()
   ENDIF
   dbCloseAll()
   IMPEND()

   RETURN


// + EOF: fopto_3g.prg
// +
