// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_31.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO_31()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO_31

   PARA nTIP31

   IF !MDL( 'FOPTO_31 - Listagem do Ponto Mensal' )
      RETU
   ENDIF

   cPN := "PN" + ANOMESW   // Ponto
   cPD := "PD" + ANOMESW   // Passagens
   cPO := "PO" + ANOMESW   // Ocorrencias
   cPM := "PM" + ANOMESW   // Troca de Horarios
   cPH := "PH" + ANOMESW   // Correcao de Horarios
   cPT := "PT" + ANOMESW   // Totais

   IF nTIP31 = 2
      cPD := PARQDIO()
   ENDIF

   lMIN   := .F.
   CODCTA := PEGCX()
   DESCTA := Array( 24 )


   IF !NETUSE( "FIRMA" )
      RETU
   ENDIF
   dbGoTop()
   dbSeek( NREMP )

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
      ordCreate(, "temp", inx )   // ,{|| zei_fort(nLASTREC,,,1)})
      ordSetFocus( "temp" )
   ENDIF
   SET FILTER TO &FILTRO


   IF !netuse( Cpn )
      dbCloseAll()
      RETU
   ENDIF

   IF !netuse( CpD )
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( "TABFALTA" )
      dbCloseAll()
      RETU
   ENDIF

   IF !netuse( "tabturno" )
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( cPO )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( cPM )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( cPH )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( cPT )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( "CONTAS" )
      dbCloseAll()
      RETU .F.
   ENDIF


   LISTARUE( {| X | FOPTO31( X ) } )

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO31()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO31

   PARA COMPARE

   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE

         dbSelectAr( pes )
         NUM     := NUMERO
         mNUMERO := NUMERO
         aCH     := {}


         IF nTIP31 = 3
            lLISTA := .F.
            aUSO   := { cPO, cPM, cPH }
            FOR KW := 1 TO 3
               dbSelectAr( aUSO[ KW ] )
               dbGoTop()
               dbSeek( Str( NUM, 8 ) )
               IF NUM = NUMERO
                  lLISTA := .T.
               ENDIF
            NEXT KW
         ENDIF


         IF nTIP31 <> 3 .OR. lLISTA
            dbSelectAr( "firma" )
            @ PRow() + 1, 0 SAY repl( '=', 79 )
            @ PRow() + 1, 0 SAY "FOLHA DE PONTO - " + AllTrim( RAZAO )
            @ PRow(), 56   SAY "CGC:" + CGC
            @ PRow() + 1, 0 SAY "End: " + ENDERECO + " - " + BAIRRO + " - " + CIDADE + " - " + ESTADO
            IF !Empty( NOMSETOR )
               @ PRow() + 1, 0 SAY NOMSETOR
            ENDIF
            dbSelectAr( pes )
            cHT    := HT
            cHTT   := HTT
            dADM   := ADMITIDO
            cPIS   := PIS
            cEVINC := FIELD->EVINC
            ANO    := Str( Year( DXDIA ), 4 )
            @ PRow() + 1, 0 SAY "Funcionario:" + Str( NUM, 8 ) + "-" + NOME + " PIS: " + cPIS
            @ PRow() + 1, 0 SAY "Depto: " + STRVAL( DEPTO, 4 ) + "/" + STRVAL( SETOR, 3 ) + "/" + STRVAL( SECAO, 3 ) + " Horario: "
            dbSelectAr( "tabturno" )
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
            @ PRow() + 1, 0     SAY "Competencia: " + MMES( MESTRAB ) + "/" + ANO
            @ PRow(), PCol() + 1 SAY IMPSTR( cIMPCOM ) + " Legenda: #Alteracao de Horario Trabalho *Lancamento Manual (I)ncluido (D)esconsiderado"
            @ PRow() + 1, 0     SAY repl( '-', 132 )
            IF nTIP31 <> 3
               @ PRow() + 1, 0 SAY "DIA"
               @ PRow(), 10   SAY "CH  Jornada Realizada"
               @ PRow(), 35   SAY "Marcacoes Registradas no Ponto Eletronico"
            ENDIF
            IF nTIP31 = 1
               @ PRow(), 80 SAY "Correcoes"
            ENDIF

            IF !VALPIS( cPIS, .F., .F., cEVINC )
               @ PRow() + 1, 0 SAY ZERRO
               IMPFOL()
               dbSelectAr( PES )
               dbSkip()
               LOOP
            ENDIF


         ENDIF

         IF nTIP31 <> 3
            dbSelectArea( cPN )
            dbGoTop()
            dbSeek( Str( NUM, 8 ) )
            WHILE NUMERO = NUM .AND. !Eof()
               CODIG := COD
               SODIG := SOD
               ENTRA := ENT
               SAIDA := SAI
               Mdata := DATA

               IF Left( SODIG, 1 ) = "_"  // Codigos Indicativos Horario Flexivel _A _0
                  SODIG := ""
               ENDIF
               @ PRow() + 1, 0 SAY mDATA
               IF nTIP31 <> 1
                  @ PRow(), PCol() SAY MUDHOR
               ENDIF
               COL := 10
               IF nTIP31 = 1
                  IF horario > 0
                     @ PRow(), 10 SAY Str( horario, 3 )
                     IF AScan( aCH, HORARIO ) = 0
                        AAdd( aCH, HORARIO )
                     ENDIF
                  ENDIF
                  IF ENTRA # 0 .OR. SAIDA # 0
                     @ PRow(), 14     SAY ENTRA
                     @ PRow(), PCol() SAY MUDENT
                     IF Empty( ALS ) .AND. Empty( ALE )
                        // @ prow(), 19 say "AS"
                     ELSE
                        @ PRow(), 16     SAY ALS
                        @ PRow(), PCol() SAY MUDALS
                        @ PRow(), 22     SAY ALE
                        @ PRow(), PCol() SAY MUDALE
                     ENDIF
                     @ PRow(), 28     SAY SAIDA
                     @ PRow(), PCol() SAY MUDSAI
                     COL := 34
                  ENDIF
               ENDIF
               IF nTIP31 = 1 .OR. nTIP31 = 2
                  COL := IF( nTIP31 = 1, 35, 10 )
                  dbSelectAr( Cpd )
                  dbGoTop()
                  dbSeek( Str( NUM, 8 ) + DToS( mDATA ) )
                  WHILE DATA = mDATA .AND. NUMERO = NUM .AND. !Eof()
                     @ PRow(), COL SAY HORA
                     COL += 6
                     IF COL >= 82
                        @ PRow() + 1, 0 SAY ""
                        COL := IF( nTIP31 = 1, 35, 10 )
                     ENDIF
                     dbSkip()
                  ENDDO
               ENDIF



               dbSelectArea( cPN )
               cNOME := ""
               fopto31a( CODIG )
               fopto31a( SODIG )

               dbSelectArea( cPN )
               // mudanca de horario
               IF nTIP31 = 1
                  IF !Empty( MUDHOR )
                     @ PRow(), 80 SAY MUDHOR
                     @ PRow(), 82 SAY CODREV
                     @ PRow(), 86 SAY ENTREV
                     IF Empty( ALIREV ) .AND. Empty( ALSREV )
                     ELSE
                        @ PRow(), 92 SAY ALIREV
                        @ PRow(), 98 SAY ALSREV
                     ENDIF
                     @ PRow(), 104 SAY SAIREV
                  ENDIF
               ENDIF
               dbSelectAr( CPN )

               // Ajuste de horas
               IF nTIP31 = 1
                  IF !Empty( AllTrim( MUDENT + MUDALE + MUDALS + MUDSAI ) )
                     IF PCol() > 80
                        @ PRow() + 1, 0 SAY ""
                     ENDIF
                     dbSelectAr( cPM )
                     dbGoTop()
                     IF dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) )
                        cZERHOR := IF( Type( "ZERHOR" ) = "C", ZERHOR, " " )   // zerhor competencia antigas
                        DO CASE
                        CASE cZERHOR = "S"
                           cZERHOR := "D"
                        CASE Empty( cZERHOR )
                           cZERHOR := "I"
                        ENDCASE
                        @ PRow(), 80  SAY "*"
                        @ PRow(), 82  SAY cZERHOR
                        @ PRow(), 86  SAY IF( Empty( HOROCO ), "", HOROCO )
                        @ PRow(), 92  SAY IF( Empty( HOROC2 ), "", HOROC2 )
                        @ PRow(), 98  SAY IF( Empty( HOROC3 ), "", HOROC3 )
                        @ PRow(), 104 SAY IF( Empty( HOROC4 ), "", HOROC4 )
                        IF Len( AllTrim( MOTOCO ) ) > 20
                           @ PRow() + 1, 0 SAY ""
                           @ PRow(), 35   SAY MOTOCO
                        ELSE
                           @ PRow(), 110 SAY IF( Empty( MOTOCO ), "Preencher Motivo", Left( MOTOCO, 20 ) )
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               dbSelectAr( CPN )

               // Observacao ocorrencia
               IF nTIP31 = 1
                  IF Empty( CODIG ) .OR. CODIG = "FO" .OR. CODIG = "SA" .OR. CODIG = "DO" .OR. CODIG = "FE"
                  ELSE
                     IF PCol() > 80
                        @ PRow() + 1, 0 SAY ""
                     ENDIF
                     dbSelectAr( cPO )
                     dbGoTop()
                     IF dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) )
                        IF Empty( OCOFIM ) .AND. OCOINI = mDATA
                        ELSE
                           @ PRow(), 86 SAY OCOINI
                        ENDIF
                        @ PRow(), 96 SAY IF( Empty( OCOFIM ), "", OCOFIM )

                        IF Len( AllTrim( OCOMOT ) ) > 20
                           @ PRow() + 1, 0 SAY ""
                           @ PRow(), 35   SAY OCOMOT
                        ELSE
                           @ PRow(), 110 SAY IF( Empty( OCOMOT ), "Preencher Motivo", Left( OCOMOT, 20 ) )
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF


               dbSelectArea( cPN )
               dbSkip()
            ENDDO
         ENDIF

         IF nTIP31 = 3 .AND. lLISTA
            FOR KW := 1 TO 3
               dbSelectAr( aUSO[ KW ] )
               WHILE numero = NUM .AND. !Eof()
                  IF KW = 1  // Ocorrencias
                     @ PRow() + 1, 0     SAY "Ocorrencia      -> "
                     @ PRow(), PCol() + 1 SAY OCOINI
                     @ PRow(), PCol() + 1 SAY if( Empty( ocofim ), Space( 8 ), OCOFIM )
                     @ PRow(), PCol() + 1 SAY OCOCOD
                     @ PRow(), PCol() + 1 SAY OCOSUB
                     @ PRow(), PCol() + 1 SAY IF( Empty( OCOMOT ), "Preencher Motivo", Left( OCOMOT, 20 ) )
                  ENDIF
                  IF KW = 2  // passagens
                     @ PRow() + 1, 0     SAY "Marcacao        -> "
                     @ PRow(), PCol() + 1 SAY DATOCO
                     // @ PROW(),PCOL()+1 SAY CODOCO
                     @ PRow(), PCol() + 1 SAY HOROCO
                     @ PRow(), PCol() + 1 SAY HOROC2
                     @ PRow(), PCol() + 1 SAY HOROC3
                     @ PRow(), PCol() + 1 SAY HOROC4
                     @ PRow(), PCol() + 1 SAY IF( Empty( MOTOCO ), "Preencher Motivo", Left( MOTOCO, 20 ) )
                  ENDIF
                  IF KW = 3  // Horarios de trabalho
                     @ PRow() + 1, 0     SAY "Troca de Horario-> "
                     @ PRow(), PCol() + 1 SAY OCOINI
                     @ PRow(), PCol() + 1 SAY if( Empty( ocofim ), Space( 8 ), OCOFIM )
                     @ PRow(), PCol() + 1 SAY OCOCOD
                     @ PRow(), PCol() + 1 SAY IF( Empty( OCOMOT ), "Preencher Motivo", Left( OCOMOT, 20 ) )
                  ENDIF
                  dbSkip()
               ENDDO
            NEXT KW
         ENDIF

         IF nTIP31 = 1   // Horarios
            @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + "CH-Horarios Contratuais: " + repl( '=', 107 ) + IMPSTR( cIMPCOM )
            nCOL := 0
            FOR X := 1 TO Len( aCH )
               aTMP := PEGPTOHOR( aCH[ X ] )
               IF nCOL = 0
                  @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + Str( aCH[ X ], 3 )
               ELSE
                  @ PRow(), nCOL SAY IMPSTR( cIMPCOM ) + Str( aCH[ X ], 3 )
               ENDIF
               @ PRow(), PCol() + 3 SAY aTMP[ 1 ] PICT '99.99'
               @ PRow(), PCol() + 5 SAY aTMP[ 2 ] PICT '99.99'
               @ PRow(), PCol() + 5 SAY aTMP[ 3 ] PICT '99.99'
               @ PRow(), PCol() + 5 SAY aTMP[ 4 ] PICT '99.99'
               nCOL += 50
               IF nCOL = 100
                  nCOL := 0
               ENDIF
            NEXT X
         ENDIF
         IF nTIP31 = 1   // Totais do mes
            dbSelectAr( cPT )
            dbGoTop()
            IF dbSeek( mNUMERO )
               nTOTBCOHRS := BCOHRS
               @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + repl( '=', 132 ) + IMPSTR( cIMPCOM )
               aTOTAL := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
                  CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
                  CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
               FOR X := 1 TO 8
                  nSALTO := 1
                  BUSCA  := CODCTA[ X ]  // Contas 0 a 8
                  BUSCA  := if( Empty( BUSCA ), 0, &BUSCA )  // usa macro tipsal alguns nao pode ser para todos empregados
                  dbSelectAr( "CONTAS" )
                  dbGoTop()
                  dbSeek( BUSCA )
                  DESCTA[ X ] = if( Found(), DESCR, "" )
                  IF !Empty( aTOTAL[ X ] )
                     @ PRow() + 1, 0 SAY StrZero( X, 3 ) + " - " + DESCTA[ X ]
                     @ PRow(), 50   SAY if( lMIN, BHOR( aTOTAL[ X ] ), aTOTAL[ X ] ) PICT "9999.99"
                     nSALTO := 0
                  ENDIF
                  BUSCA := CODCTA[ X + 8 ]   // Contas 9 a 16
                  BUSCA := if( Empty( BUSCA ), 0, &BUSCA )   // usa macro tipsal alguns nao pode ser para todos empregados
                  dbSelectAr( "CONTAS" )
                  dbGoTop()
                  dbSeek( BUSCA )
                  DESCTA[ X + 8 ] = if( Found(), DESCR, "" )
                  IF !Empty( aTOTAL[ X + 8 ] )
                     @ PRow() + nSALTO, 60 SAY StrZero( X + 8, 3 ) + " - " + DESCTA[ X + 8 ]
                     @ PRow(), 110       SAY if( lMIN, BHOR( aTOTAL[ X + 8 ] ), aTOTAL[ X + 8 ] ) PICT "9999.99"
                  ENDIF
               NEXT X

            ENDIF
         ENDIF
         IF nTIP31 = 1   // nTIP31<>3.OR.lLISTA
            @ PRow() + 1, 0  SAY IMPSTR( cIMPCOM ) + repl( '=', 132 ) + IMPSTR( cIMPCOM )
            @ PRow() + 1, 0  SAY "Emitido Em:" + DToC( dxdia ) + " " + Time()
            @ PRow() + 3, 20 SAY IMPSTR( cIMPEXP ) + repl( '-', 30 ) + spac( 5 ) + repl( '-', 30 )
            @ PRow() + 1, 20 SAY "Assinatura do RH" + spac( 15 ) + "Assinatura do Funcionario"
            @ PRow() + 1, 0  SAY repl( '=', 79 )
            IMPFOL()
         ENDIF
      ENDIF
      dbSelectAr( pes )
      dbSkip()
   ENDDO

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto31a()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC fopto31a( cCOD )

   IF Empty( cCOD )
      RETURN ""
   ENDIF
   IF !Empty( cNOME )
      cNOME += " / "
   ENDIF
   dbSelectAr( "tabfalta" )
   dbGoTop()
   IF dbSeek( cCOD )
      cNOME := cCOD + "-" + AllTrim( NOME )
   ELSE
      cNOME := cCOD
   ENDIF
   IF COL + Len( cNOME ) > 80
      @ PRow() + 1, 0 SAY ""
      COL := IF( nTIP31 = 1, 35, 10 )
   ENDIF
   @ PRow(), COL SAY cNOME
   col := PCol() + 1

   RETURN ""




// + EOF: fopto_31.prg
// +
