// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3j.prg Resumo Final em minutos sexadecimal
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


FUNCTION fopto_3j()

   cPN := "PN" + ANOMESW
   cPT := "PT" + ANOMESW

   lMIN := MDG( "Resumo Final em minutos sexadecimal" )

   IF !netuse( "FIRMA" )
      RETU
   ENDIF
   dbGoTop()
   dbSeek( NREMP )
   mRAZ := RAZAO
   mCGC := CGC
   mEND := ENDERECO
   mBAI := BAIRRO
   mCID := CIDADE
   mEST := ESTADO
   dbCloseAll()

   IF !NETUSE( "CONTAS" )
      RETU
   ENDIF

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
      RETU
   ENDIF

   IF !NETUSE( cPT )
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( "TABTURNO" )
      dbCloseAll()
      RETU
   ENDIF


   IF !NETUSE( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
      dbCloseAll()
      RETU
   ENDIF
   cSELE6 := Alias()

   IF !MDL( 'FOPTO-3J - Listagem Apontamento e Totais Banco Horas' )
      RETU
   ENDIF
   IF MDG( "Espacar Entrelinha" )
      IMPRESSORA()
      QQOut( Chr( 27 ) + "3" + "72" )
      VIDEO()
   ENDIF

   LISTARUE( {| X | FOPTO3J( X ) } )

   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO3J()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO3J

   PARA COMPARE

   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         dbSelectAr( "CONTAS" )
         @ PRow() + 1, 0 SAY IMPSTR( cIMPEXP ) + repl( '=', 80 )
         @ PRow() + 1, 0 SAY "FOLHA DE PONTO - " + mRAZ
         @ PRow(), 56   SAY "CGC:" + mCGC
         @ PRow() + 1, 0 SAY "End: " + mEND + " - " + mBAI + " - " + mCID + " - " + mEST
         IF !Empty( NOMSETOR )
            @ PRow() + 1, 0 SAY NOMSETOR
         ENDIF
         dbSelectAr( PES )
         TSA    := TIPO
         NUM    := NUMERO
         ANO    := Str( Year( DXDIA ), 4 )
         DIAINI := CToD( "  /  /  " )
         DIAFIM := CToD( "  /  /  " )
         dbSelectAr( cPN )
         dbGoTop()
         dbSeek( Str( NUM, 8 ) )
         WHILE NUM = NUMERO .AND. !Eof()
            IF Empty( DIAINI )
               DIAINI := DATA
            ENDIF
            DIAFIM := DATA
            dbSkip()
         ENDDO
         dbSelectAr( PES )
         @ PRow() + 1, 0 SAY "Funcionario:" + Str( NUM, 8 ) + "-" + NOME + " PERIODO:" + DToC( DIAINI ) + "-" + DToC( DIAFIM )
         @ PRow() + 1, 0 SAY "Depto: " + STRVAL( DEPTO, 4 ) + "/" + STRVAL( SETOR, 3 ) + "/" + STRVAL( SECAO, 3 ) + " Horario: "
         cHT  := HT
         cHTT := HTT
         dADM := ADMITIDO
         dbSelectAr( "TABTURNO" )
         dbGoTop()
         IF dbSeek( cHTT )
            @ PRow(), 30   SAY NOME
            @ PRow() + 1, 0 SAY "Admitido: " + DToC( dADM )
            IF !Empty( NOM2 )
               @ PRow(), 30 SAY NOM2
            ENDIF
         ELSE
            @ PRow(), 30   SAY "Descritivo de Horario nao Cadastrado"
            @ PRow() + 1, 0 SAY "Admitido: " + DToC( dADM )
         ENDIF
         @ PRow() + 1, 0 SAY repl( '-', 80 )
         @ PRow() + 1, 0 SAY "DIA "
         @ PRow(), 18   SAY "Reducao"
         @ PRow(), 28   SAY "Banco"
         @ PRow(), 38   SAY "Horas"
         @ PRow() + 1, 0 SAY repl( '-', 80 )

         // saldo anterior
         dbSelectAr( cSELE6 )
         nSALDO := pegsaldobco( NUM, nANOANT, nMESANT )
         IF nSALDO <> 0.00
            @ PRow() + 1, 0 SAY "Saldo Banco Horas=" + StrZero( nMESANT, 2 ) + "/" + StrZero( nANOANT, 4 )
            @ PRow(), 38   SAY if( lMIN, BHOR( nSALDO ), nSALDO )                                   PICT "9999.99"
         ENDIF

         // Movimento do mes
         dbSelectAr( cPN )
         dbGoTop()
         dbSeek( Str( NUM, 8 ) )
         WHILE NUM = NUMERO .AND. !Eof()
            X := Day( DATA )
            @ PRow() + 1, 0 SAY StrZero( X, 2 )
            @ PRow(), 3   SAY COD
            IF !Empty( ENT ) .OR. !Empty( SAI )
               @ PRow(), 06 SAY ENT PICT '##.##'
               @ PRow(), 12 SAY SAI PICT '##.##'
            ENDIF
            @ PRow(), 18 SAY REDSN
            @ PRow(), 30 SAY BCOSN
            @ PRow(), 38 SAY BCOHRS
            dbSkip()
         ENDDO
         @ PRow() + 2, 0 SAY repl( '=', 80 )

         // Total
         nTOTBCOHRS := 0
         dbSelectAr( cPT )
         dbGoTop()
         IF dbSeek( NUM )
            @ PRow() + 1, 0 SAY "Atual"
            @ PRow(), 38   SAY if( lMIN, BHOR( BCOHRS ), BCOHRS ) PICT "9999.99"
            nTOTBCOHRS := BCOHRS
         ENDIF

         // saldo
         IF nSALDO + nTOTBCOHRS <> 0.00
            @ PRow() + 1, 0 SAY "Saldo"
            @ PRow(), 38   SAY if( lMIN, BHOR( nSALDO + nTOTBCOHRS ), nSALDO + nTOTBCOHRS ) PICT "9999.99"
         ENDIF

         @ PRow() + 1, 0 SAY repl( '=', 80 )

         IMPFOL()
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO


// + EOF: fopto_3j.prg
// +
