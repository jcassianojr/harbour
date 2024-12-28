// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_25.prg
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
// +    Function FOPTO_25()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO_25

   PARA nTIPO  // 1 Ponto->Folha             //2 Ponto->Arquivo.txt

// 3 Refeicao->Arquivo.txt    //4 Refeicao->Folha
// 5 SaldoBanco->Arquivo.txt  //6 SaldoBanco->Folha
// 7 Ver Imprimir folha       //8 Ver imprimir Refeicao

   DO CASE
   CASE nTIPO = 1
      CABE2( 'FOPTO_25 - Transferir Totais Para      Folha' )
   CASE nTIPO = 2
      CABE2( 'FOPTO_25 - Exportar   Totais para      Folha' )
   CASE nTIPO = 3
      CABE2( 'FOPTO_25 - Exportar   Refeicos        Folha' )
   CASE nTIPO = 4
      CABE2( 'FOPTO_25 - Transferir Refeicos        Folha' )
   CASE nTIPO = 5
      CABE2( 'FOPTO_25 - Exportar   Saldo Banco Hora Folha' )
   CASE nTIPO = 6
      CABE2( 'FOPTO_25 - Transferir Saldo Banco Hora Folha' )
   CASE nTIPO = 7
      CABE2( 'FOPTO_25 - Ver Arq. Totais Exportados  Folha' )
   CASE nTIPO = 8
      CABE2( 'FOPTO_25 - Ver Arq .Exportados     Refeicos' )

   ENDCASE

   cMIG := StrZero( nremp, 2 )
   IF !NETUSE( "FIRMA" )
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( NREMP )
      IF !Empty( CODEMPMIG )
         cMIG := CODEMPMIG
      ENDIF
   ENDIF
   dbCloseAll()

   IF nTIPO = 1 .OR. nTIPO = 2
      aCODCTA := PEGCX()
      aTR     := PEGCX( "T" )
      FOR X := 1 TO 24
         cCTA   := "mCTA" + StrZero( X, 2 )
         &CCTA. := aTR[ X ]
      NEXT
      @  9, 7  SAY "Cta01   Cta02   Cta03   Cta04   Cta05   Cta06   Cta07   Cta08"
      @ 12, 7  SAY "Cta09   Cta10   Cta11   Cta12   Cta13   Cta14   Cta15   Cta16"
      @ 15, 7  SAY "Cta17   Cta18   Cta19   Cta20   Cta21   Cta22   Cta23   Cta24"
      @ 10, 7  GET mCTA01                                                          VALID mCTA01 $ "SN "
      @ 10, 15 GET mCTA02                                                          VALID mCTA02 $ "SN "
      @ 10, 23 GET mCTA03                                                          VALID mCTA03 $ "SN "
      @ 10, 31 GET mCTA04                                                          VALID mCTA04 $ "SN "
      @ 10, 39 GET mCTA05                                                          VALID mCTA05 $ "SN "
      @ 10, 47 GET mCTA06                                                          VALID mCTA06 $ "SN "
      @ 10, 55 GET mCTA07                                                          VALID mCTA07 $ "SN "
      @ 10, 63 GET mCTA08                                                          VALID mCTA08 $ "SN "
      @ 13, 7  GET mCTA09                                                          VALID mCTA09 $ "SN "
      @ 13, 15 GET mCTA10                                                          VALID mCTA10 $ "SN "
      @ 13, 23 GET mCTA11                                                          VALID mCTA11 $ "SN "
      @ 13, 31 GET mCTA12                                                          VALID mCTA12 $ "SN "
      @ 13, 39 GET mCTA13                                                          VALID mCTA13 $ "SN "
      @ 13, 47 GET mCTA14                                                          VALID mCTA14 $ "SN "
      @ 13, 55 GET mCTA15                                                          VALID mCTA15 $ "SN "
      @ 13, 63 GET mCTA16                                                          VALID mCTA16 $ "SN "
      @ 16, 7  GET mCTA17                                                          VALID mCTA17 $ "SN "
      @ 16, 15 GET mCTA18                                                          VALID mCTA18 $ "SN "
      @ 16, 23 GET mCTA19                                                          VALID mCTA19 $ "SN "
      @ 16, 31 GET mCTA20                                                          VALID mCTA20 $ "SN "
      @ 16, 39 GET mCTA21                                                          VALID mCTA21 $ "SN "
      @ 16, 47 GET mCTA22                                                          VALID mCTA22 $ "SN "
      @ 16, 55 GET mCTA23                                                          VALID mCTA23 $ "SN "
      @ 16, 63 GET mCTA23                                                          VALID mCTA24 $ "SN "
      READCUR()

      FOR X := 1 TO 24
         cCTA     := "mCTA" + StrZero( X, 2 )
         aTR[ X ] := &CCTA.
      NEXT
   ENDIF

   IF nTIPO <> 7 .AND. nTIPO <> 8
      IF !MDG( 'Voce tem certeza' )
         RETU .F.
      ENDIF
   ENDIF
   CX  := HX := VX := Array( 24 )
   LF  := Chr( 13 ) + Chr( 10 )
   XA  := XB := XC := XD := XE := XF := VALE := 0
   cPT := "PT" + ANOMESW

   IF nTIPO = 2 .OR. nTIPO = 3 .OR. nTIPO = 5 .OR. nTIPO = 7 .OR. nTIPO = 8
      IF !NETUSE( "FOPTOCON" )
         RETU .F.
      ENDIF
      IF !dbSeek( nremp )
         dbGoTop()
      ENDIF
      IF nTIPO = 2 .OR. nTIPO = 7
         cARQUIVO := PadR( AllTrim( CAMINEX ) + "H" + cMIG + ANOMESW + ".TXT", 80 )
         eFORMULA := AllTrim( EXPORTA )
      ENDIF
      IF nTIPO = 3 .OR. nTIPO = 8
         cARQUIVO := PadR( AllTrim( CAMINEX ) + "R" + cMIG + ANOMESW + ".TXT", 80 )
         eFORMULA := AllTrim( CAMINER )
         mCTA01   := CONTAREF
      ENDIF
      IF nTIPO = 5
         cARQUIVO := PadR( AllTrim( CAMINEX ) + "B" + cMIG + ANOMESW + ".TXT", 80 )
         eFORMULA := AllTrim( EXPORTA )
         mCTA01   := 0
      ENDIF
      dbCloseAll()
      IF Empty( eFORMULA )
         ALERTX( "Formula Nao Preenchida" )
         RETU .F.
      ENDIF
      // cCAMUSO:=SPACE(80)
      // cARQUSO:=SPACE(80)
      cARQUIVO := WIN_GETSAVEFILENAME(, "Exportar", hb_cwd(), "txt", "*.txt", 1,, cARQUIVO )
      // @ 23,00 SAY "confirme o caminho"
      // @ 24,00 get cARQUIVO
      // IF ! READCUR()
      // RETU .F.
      // ENDIF
      // cARQUIVO:=ALLTRIM(CARQUIVO)
      IF nTIPO <> 7 .AND. nTIPO <> 8
         nHANDLE := FCreate( cARQUIVO )
         IF FError() # 0
            ALERTX( "Erro na Criacao do Arquivo" )
            RETU
         ENDIF
      ENDIF
   ENDIF

   IF nTIPO = 7 .OR. nTIPO = 8
      FOPTO13( cARQUIVO )
      RETURN .T.
   ENDIF


   IF nTIPO = 3 .OR. nTIPO = 4
      dINI := zdataini
      dFIM := zdatafim
      MDS( 'Digite o Periodo ' )
      @ 24, 40 GET dINI
      @ 24, 50 GET dFIM
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF

   IF nTIPO = 5 .OR. nTIPO = 6
      nANO := Year( Date() )
      nMES := Month( Date() )
      @ 24, 00
      @ 24, 00 SAY "ANO"
      @ 24, 20 SAY "Mes"
      @ 24, 10 GET nANO
      @ 24, 30 GET nMES
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF

   IF nTIPO = 3 .OR. nTIPO = 4 .OR. nTIPO = 5 .OR. nTIPO = 6
      @ 24, 00
      @  9, 7  SAY "Conta   "
      @ 24, 40 GET mCTA01     VALID mCTA01 > 0
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF


   IF !netuse( pes )
      RETU
   ENDIF
   INITVARS()
   CLRVARS()
   FILTRO := "EMPTY(DEMITIDO)"
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO

   IF !netuse( fol )
      dbCloseAll()
      RETU
   ENDIF
   IF !netuse( "contas" )
      dbCloseAll()
      RETU
   ENDIF
   IF nTIPO = 1 .OR. nTIPO = 2
      IF !netuse( cPT )
         dbCloseAll()
         RETU
      ENDIF
   ENDIF
   IF nTIPO = 3 .OR. nTIPO = 4
      IF !NETUSE( cPA )
         dbCloseAll()
         RETU
      ENDIF
   ENDIF
   IF nTIPO = 5 .OR. nTIPO = 6
      carq := IF( lSECBCO, "BCOBAK", "BCOHRS" )
      IF !netuse( CArq )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF



   nFIM := 24
   IF nTIPO = 3 .OR. nTIPO = 4 .OR. nTIPO = 5 .OR. nTIPO = 6
      nFIM := 1
   ENDIF
   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      PETELA( 8 )
      CTR  := NUMERO
      cNUM := StrZero( NUMERO, 8 )
      cNU6 := StrZero( NUMERO, 6 )
      TSA  := TIPO
      EQUVARS()
      IF nTIPO = 1 .OR. nTIPO = 2
         // Analise feita com arquivo pes pois checar tipo horista/mensalista entre outros na macro
         AFill( CX, 0 )
         FOR X := 1 TO 24
            cVAR := aCODCTA[ X ]
            IF !Empty( cVAR )
               CX[ X ] = &CVAR.
            ENDIF
         NEXT X
      ENDIF
      IF nTIPO = 3 .OR. nTIPO = 4 .OR. nTIPO = 5 .OR. nTIPO = 6
         CX[ 1 ] := mCTA01
         aTR     := { "S" }
      ENDIF

      lGRAVA := .F.

      IF nTIPO = 1 .OR. nTIPO = 2
         dbSelectAr( cPT )
         dbGoTop()
         IF dbSeek( CTR )
            HX := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
               CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
               CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
            VX := { VAL01, VAL02, VAL03, VAL04, VAL05, VAL06, VAL07, VAL08, ;
               VAL09, VAL10, VAL11, VAL12, VAL13, VAL14, VAL15, VAL16, ;
               VAL17, VAL18, VAL19, VAL20, VAL21, VAL22, VAL23, VAL24 }
            nBANCO := BCOHRS
            lGRAVA := .T.
         ENDIF
      ENDIF

      IF nTIPO = 3 .OR. nTIPO = 4
         HX := { 0 }
         dbSelectAr( cPA )
         dbGoTop()
         dbSeek( Str( mNUMERO, 8 ) )
         WHILE NUMERO = mNUMERO .AND. !Eof()
            mDATA := DATA
            IF DATA >= Dini .AND. DATA <= Dfim
               HX[ 1 ]++
               WHILE NUMERO = mNUMERO .AND. mDATA = DATA .AND. !Eof()  // Somar uma vez no dia
                  dbSkip()
               ENDDO
            ELSE
               dbSkip()
            ENDIF
         ENDDO
         IF HX[ 1 ] > 0
            lGRAVA := .T.
         ENDIF
      ENDIF
      IF nTIPO = 5 .OR. nTIPO = 6
         dbSelectAr( cARQ )
         HX := { PegSaldoBco( mNUMERO, nANO, nMES, .F. ) }
         dbSelectAr( pes )
         IF HX[ 1 ] > 0
            lGRAVA := .T.
         ENDIF
      ENDIF
      IF lGRAVA
         FOR X := 1 TO nFIM
            IF HX[ X ] > 0 .AND. CX[ X ] # 0 .AND. aTR[ X ] # "N"
               cCTA := StrZero( CX[ X ], 3 )
               cHOR := GRVVAL( HX[ X ], 6, 2 )
               cVAL := GRVVAL( VX[ X ], 12, 2 )
               IF nTIPO = 2 .OR. nTIPO = 3 .OR. nTIPO = 5
                  FWrite( nHANDLE, &eFORMULA )
               ENDIF
               IF nTIPO = 1 .OR. nTIPO = 4 .OR. nTIPO = 6
                  netreclock()
                  GRAVA2( CX[ X ] )
                  &FOL.->HORAS := HX[ X ]
                  dbUnlock()
               ENDIF
            ENDIF
         NEXT X
      ENDIF

      dbSelectAr( pes )
      dbSkip()
   ENDDO
   dbCloseAll()

   IF nTIPO = 2 .OR. nTIPO = 3
      FWrite( nHANDLE, Chr( 26 ) )
      FClose( nHANDLE )
      IF MDG( "Deseja Imprimir o arquivo Gerado" )
         IMPARQ( cARQUIVO )
      ENDIF
   ENDIF
   RETU


// + EOF: fopto_25.prg
// +
