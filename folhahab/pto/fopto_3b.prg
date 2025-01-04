// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3b.prg Listagem de Ocorrencias
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

FUNCTION fopto_3b()

   IF !MDL( "FOPTO_3B -Listagem de Ocorrencias" )
      RETU .F.
   ENDIF

   PAG  := 1
   DIAX := Date()
   cPN  := "PN" + ANOMESW

   IF !NETUSE( pes )
      dbCloseAll()
      RETU
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
   INX    := ""
   FILORD( .T. )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF ValType( INX ) = "N"
      dbSetOrder( INX )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", inx )
      ordSetFocus( "temp" )
   ENDIF
   SET FILTER TO &FILTRO

   IF !NETUSE( cPN )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( "TABFALTA" )
      dbCloseAll()
      RETU .F.
   ENDIF

   lSINT := MDG( "Deseja Resumo Sintetico" )
   lFUNC := MDG( "Deseja Resumo Por Funcionario" )

   LISTARUE( {| X | FOPTO3B( X ) } )

   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO3B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO3B

   PARA COMPARE

   aCOD := {}
   aQTE := {}
   aNOM := {}
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         VIDEO()
         PETELA( 4 )
         IMPRESSORA()
         mNUMERO := NUMERO
         mNOME   := NOME
         aCODF   := {}
         aQTEF   := {}
         aNOMF   := {}
         dbSelectAr( cPN )
         dbGoTop()
         dbSeek( Str( mNUMERO, 8 ) )
         WHILE mNUMERO = NUMERO .AND. !Eof()
            IF !Empty( COD )
               // Checagem Geral
               nPOS := AScan( aCOD, COD )
               IF nPOS = 0
                  AAdd( aCOD, COD )
                  AAdd( aQTE, { 1, 0 } )
                  cCOD := COD
                  dbSelectAr( "TABFALTA" )
                  dbGoTop()
                  dbSeek( cCOD )
                  AAdd( aNOM, if( Found(), { NOME, APURA, FORMULA }, { "", "N", "" } ) )
                  nPOS := Len( aNOM )
               ELSE
                  aQTE[ nPOS, 1 ]++
               ENDIF
               dbSelectAr( cPN )
               IF aNOM[ nPOS, 2 ] # "N" .AND. !Empty( aNOM[ nPOS, 3 ] )
                  eFORMULA := aNOM[ nPOS, 3 ]
                  aQTE[ nPOS, 2 ] += &eFORMULA.
               ENDIF
               // Checagem Total Funcionario
               nPOS := AScan( aCODF, COD )
               IF nPOS = 0
                  AAdd( aCODF, COD )
                  AAdd( aQTEF, { 1, 0 } )
                  cCOD := COD
                  dbSelectAr( "TABFALTA" )
                  dbGoTop()
                  dbSeek( cCOD )
                  AAdd( aNOMF, if( Found(), { NOME, APURA, FORMULA }, { "", "N", "" } ) )
                  nPOS := Len( aNOMF )
               ELSE
                  aQTEF[ nPOS, 1 ]++
               ENDIF
               dbSelectAr( cPN )
               IF aNOMF[ nPOS, 2 ] # "N" .AND. !Empty( aNOMF[ nPOS, 3 ] )
                  eFORMULA := aNOMF[ nPOS, 3 ]
                  aQTEF[ nPOS, 2 ] += &eFORMULA.
               ENDIF
            ENDIF
            dbSelectAr( cPN )
            dbSkip()
         ENDDO
         IF lFUNC
            IMPRESSORA()
            IF Len( aCODF ) > 0
               IF PRow() + Len( aCODF ) > 50 .OR. PAG = 1
                  IF PAG # 1
                     IMPFOL()
                  ENDIF
                  CABEC( "Resumo de Ocorrencias", "Ocorreu/Quantidade", 60, "Codigo", NOMSETOR )
                  @ PRow() + 1, 0 SAY mNUMERO
                  @ PRow(), 10   SAY mNOME
                  @ PRow() + 1, 0 SAY repl( "-", 80 )
               ELSE
                  @ PRow() + 1, 0 SAY repl( "=", 80 )
                  @ PRow() + 1, 0 SAY mNUMERO
                  @ PRow(), 10   SAY mNOME
                  @ PRow() + 1, 0 SAY repl( "-", 80 )
               ENDIF
               FOR X := 1 TO Len( aCODF )
                  @ PRow() + 1, 0 SAY aCODF[ X ]
                  @ PRow(), 3   SAY aNOMF[ X, 1 ]
                  @ PRow(), 54   SAY aQTEF[ X, 1 ] PICT "99999999"
                  IF !Empty( aQTEF[ X, 2 ] )
                     @ PRow(), 62 SAY aQTEF[ X, 2 ] PICT "@E 999,999,999.99"
                  ENDIF
               NEXT X
            ENDIF
            VIDEO()
         ENDIF
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO

   IF lSINT
      IMPRESSORA()
      IF lFUNC
         IMPFOL()
         CABEC( "Resumo de Ocorrencias", "Ocorreu/Quantidade", 60, "Codigo", NOMSETOR )
      ENDIF
      FOR X := 1 TO Len( aCOD )
         IF PRow() > 50 .OR. PAG = 1
            IMPFOL()
            CABEC( "Resumo de Ocorrencias", "Ocorreu/Quantidade", 60, "Codigo", NOMSETOR )
         ENDIF
         @ PRow() + 1, 0 SAY aCOD[ X ]
         @ PRow(), 3   SAY aNOM[ X, 1 ]
         @ PRow(), 54   SAY aQTE[ X, 1 ] PICT "99999999"
         IF !Empty( aQTE[ X, 2 ] )
            @ PRow(), 62 SAY aQTE[ X, 2 ] PICT "@E 999,999,999.99"
         ENDIF
      NEXT X
      IF Len( aCOD ) > 0
         IMPFOL()
      ENDIF
      VIDEO()
   ENDIF
   IMPEND()


// + EOF: fopto_3b.prg
// +
