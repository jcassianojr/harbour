// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_19.prg
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
// +    Function fopto_19()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_19

   PARA lPER, cOPER, nTIPO, nEQUIP, cARQIMP

// cOPER
// A=OPTIMIZAR B=BAKCUP C=CONVERTER D=AFDT T=IMPORTAR R=REP
// cOPER='D' pega nEQUIP relogio
// cARQIMP  nome do arquivo txt
// lOPER perguntas
// nTIPO
// Exemplos
// FOPTO_19(.f.,"D",1,aAFD[Z])  gerar afd equipamento


   CABE2( 'FOPTO_19 - Importando/Exportando ' )


   IF ValType( lPER ) # "L"
      lPER := .T.
   ENDIF
   IF ValType( cOPER ) # "C"
      cOPER := "T"
   ENDIF
   IF cOPER = "R"
      ntipo := 6
   ENDIF
   IF ValType( ntipo ) # "N"
      nTIPO := PEGRELOGIO()
   ENDIF

   nMODELO := 0
   IF !NETUSE( "foptorel" )
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( ntipo )
      dbCloseAll()
      ALERTX( "falta configuracao relogio " + Str( ntipo ) )
      RETU .F.
   ENDIF
   cCAMINHO := AllTrim( caminho )
   Carq     := AllTrim( arquivo )
   nMODELO  := MODELO
   dbCloseAll()



   IF !NETUSE( "relogios" )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( nMODELO )
      dbCloseAll()
      ALERTX( "falta configuracao modelo " + Str( nMODELO ) )
      RETU .F.
   ENDIF
   mNUMINI := NUMINI
   mNUMFIM := NUMFIM
   mDIAINI := DIAINI
   mDIAFIM := DIAFIM
   mMESINI := MESINI
   mMESFIM := MESFIM
   mANOINI := ANOINI
   mANOFIM := ANOFIM
   mHORINI := HORINI
   mHORFIM := HORFIM
   mMININI := MININI
   mMINFIM := MINFIM
   mRELINI := NUMRELINI
   mRELFIM := NUMRELFIM
   mPISINI := NUMPISINI
   mPISFIM := NUMPISFIM
   mEMPINI := NUMEMPINI
   mEMPFIM := NUMEMPFIM
   mSEGINI := SEGINI
   mSEGFIM := SEGFIM
   mAFDT   := AFDT
   dbCloseAll()


   nCASAS   := mNUMFIM - mNUMINI + 1
   nCASREL  := mRELFIM - mRELINI + 1
   nCASANO  := mANOFIM - mANOINI + 1
   nCASAPIS := mPISFIM - mPISINI + 1
   nCASAEMP := mEMPFIM - mEMPINI + 1

   lTXT   := .T.
   lTIPOS := cOPER = "B" .OR. cOPER = "C"
   IF lTIPOS
      lTXT := MDG( "SIM=TXT NAO=IMPORTADO" )
   ENDIF
   IF cOPER = "D"
      IF cOPER = "D" .AND. !lPER
         lORI := .T.
      ELSE
         lORI := MDG( "SIM=IMPORTADOS PONTO NAO=IMPORTADOS REP" )
      ENDIF
      lTXT := .F.
   ENDIF

   IF ( ValType( cARQIMP ) <> "C" .OR. Empty( cARQIMP ) ) .AND. lTXT .AND. cOPER <> "D"
      copio := PadR( ccaminho + carq, 80 )
      MDS( "Confirme Arquivo" )
      @ 24, 20 GET COPIO PICT "@S40"
      IF !READCUR()
         RETU .F.
      ENDIF
      COPIO := AllTrim( COPIO )
      IF Empty( cARQ )
         cFILETMP := ""
         cEXTTMP  := ""
         hb_FNameSplit( copio,, @cFILETMP, @cEXTTMP )
         cARQ := cFILETMP + cEXTTMP
         ALERTX( Carq )
      ENDIF
      COPID := hb_cwd() + CARQ
      IF !hb_FileExists( COPIO )
         MDT( 'Nao encontrei o arquivo ' + COPIO )
         RETU
      ELSE
         FILECOPY( COPIO, COPID )
      ENDIF
   ELSE
      CARQ  := cARQIMP
      COPIO := CARQIMP
   ENDIF

   DCORTE := zdataini
   DCORTF := zdatafim

   IF cOPER = "D" .AND. !lPER
   ELSE
      MDS( 'Digite o periodo ' )
      @ 24, 40 GET DCORTE
      @ 24, 60 GET DCORTF
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF

   IF cOPER = "D"
      IF ValType( nEQUIP ) # "N"
         nEQUIP := pegequip( "ATIVO<>'N' .AND. GRUPOREL=" + Str( nTIPO ) )
      ENDIF
      cREP := OBTER( "FOPTOEQP",, nEQUIP, "REP" )
   ENDIF


   IF cOPER = "C" .OR. ( cOPER = "B" .AND. !lTXT )
      cMASCARA := ESCOLHEXI( "RELOGIOS", 0, "NOME+' '+EXEMPLO", "EXEMPLO" )
   ENDIF


   IF ( lTIPOS .AND. !lTXT ) .OR. cOPER = "T" .OR. ( cOPER = "D" .AND. lORI )
      cPD := PARQDIO( nTIPO )
      CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
      IF !netuse( cPD )
         dbCloseAll()
         RETURN
      ENDIF
   ENDIF

   IF ( cOPER = "D" .AND. !lORI )
      cPD := "REP" + cREP
      IF !netuse( cPD )
         dbCloseAll()
         RETURN
      ENDIF
   ENDIF

   IF !NETUSE( PES )
      dbCloseAll()
      RETURN
   ENDIF

   IF mAFDT = "S"
      FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
      SET FILTER TO &FILTRO
      dbSetOrder( 4 )
   ENDIF


   IF cOPER = "R"
      dbSetOrder( 4 )  // pis
   ENDIF

   IF !NETUSE( "FOPTOPIS" )
      dbCloseAll()
      RETURN .T.
   ENDIF


   IF cOPER = "B"
      nHANGRV := FCreate( "MV" + StrZero( NREMP, 2 ) + ANOMESW + ".TXT" )
   ENDIF
   IF cOPER = "A"
      nHANGRV := FCreate( "AP" + StrZero( NREMP, 2 ) + ANOMESW + ".TXT" )
   ENDIF
   IF cOPER = "C"
      nHANGRV := FCreate( "CV" + StrZero( NREMP, 2 ) + ANOMESW + ".TXT" )
   ENDIF

   lREPTEM := .F.
   IF cOPER = "D"
      SET CENTURY ON
      nHANGRV := FCreate( "AFD_" + cREP + "_" + ANOMESW + ".TXT" )   // strzero( nEQUIP, 2 )
      FWrite( nHANGRV, REPL( "0", 9 ) )
      FWrite( nHANGRV, "1" )
      FWrite( nHANGRV, IF( zPESSOA = "J", "1", "" ) )
      FWrite( nHANGRV, TIRAOUT( ZCGC ) )
      FWrite( nHANGRV, REPL( "0", 12 ) )
      FWrite( nHANGRV, PadR( ZEMPRESA, 150 ) )
      FWrite( nHANGRV, StrZero( Val( cREP ), 17, 0 ) )
      FWrite( nHANGRV, StrTran( DToC( DCORTE ), "/", "" ) )
      FWrite( nHANGRV, StrTran( DToC( DCORTF ), "/", "" ) )
      FWrite( nHANGRV, StrTran( DToC( Date() ), "/", "" ) )
      FWrite( nHANGRV, Left( StrTran( Time(), ":", "" ), 4 ) )
      FWrite( nHANGRV, Chr( 13 ) + Chr( 10 ) )
      // DCORTE .and. mDATA <= DCORTF
      nSEQ    := 1
      nREG3   := 0
      nREG5   := 0
      cREPDBF := "REP" + cREP
      IF lORI
         IF File( cREPDBF + ".DBF" )
            lREPTEM := netuse( cREPDBF )
            IF lREPTEM
               dbSetOrder( 2 )   // Pis data hora
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF lTXT
      nHANDLE := hb_fopen( cARQ )
      IF nHANDLE <= 0
         ALERTX( "Nao Consegui abrir o Arquivo: " + cARQ )
         FClose( Nhangrv )
         dbCloseAll()
         RETU .F.
      ENDIF
      LINHA1 := FREADLINE( nHANDLE )   // Linha01
      IF mAFDT = "S" .OR. cOPER = "R"
         cREP     := SubStr( LINHA1, 188, 17 )
         nRELOGIO := OBTER( "FOPTOEQP",, cREP, "NUMERO", 2,,,,, "NC" )
         LINHA1   := FREADLINE( nHANDLE )  // linha02
         LINHA1   := FREADLINE( nHANDLE )  // linha03 primeira linha de dados
      ENDIF
      LINHA := AllTrim( LINHA1 )
      IF cOPER = "R"
         cREPDBF := "REP" + cREP
         IF !File( cREPDBF + ".DBF" )
            aFOLHA := { { "PIS", "C", 12, 0 }, { "DATA", "D", 8, 0 }, ;
               { "HORA", "N", 7, 2 }, { "NUMERO", "N", 8, 0 }, { "EMP", "N", 5, 0 } }  // Emp guarda o numero da empresa processada pelo ponto
            dbCreate( cREPDBF, aFOLHA )
            INFOR( cREPDBF, { "STR(NUMERO,8) + dtos( data ) + str( HORA, 5, 2 )", "pis + dtos( data ) + str( HORA, 5, 2 )" }, { cREPDBF, cREPDBF }, .F., { "REP01", "REP02" }, .T. )
         ENDIF
         IF !netuse( cREPDBF )
            dbCloseAll()
            RETU .F.
         ENDIF
         dbSetOrder( 2 )   // pis data hora
      ENDIF
   ELSE
      LINHA  := "_"
      LINHA1 := "-"
      dbSelectAr( cPD )
      dbGoTop()
   ENDIF

   @ 05, 02 SAY "Numero   :"
   @ 06, 02 SAY "Data/hora:"
   @ 07, 02 SAY "Relogio  :"
   @ 08, 02 SAY "Periodo  :" + DToC( DCORTE ) + " - " + DToC( DCORTF )
   @ 09, 02 SAY "Pis      :"
   @ 10, 02 SAY "Linha    :"
   IF cOPER = "D"
      @ 11, 02 SAY "REP:" + cREP + " " + IF( lREPTEM, "X", "" )
   ENDIF

   nLINHA := 0
   WHILE .T.
      IF !lTXT
         LINHA := Str( NUMero, 8 ) + DToS( data ) + Str( HORA, 5, 2 ) + RELOGIO
      ENDIF
      @ 23, 00 SAY linha
      mEMPRESA := NREMP
      mNUMERO  := 0
      mPIS     := ""
      tREL     := "0"
      tSEG     := "00"
      IF !Empty( LINHA )
         IF lTXT
            IF mAFDT <> "S" .AND. cOPER <> "R"
               mNUMERO := Val( SubStr( linha, mnumINI, nCASAS ) )
               IF mPISINI > 0
                  mPIS := StrZero( Val( SubStr( linha, mPISINI, nCASAPIS ) ), 11 )
                  dbSelectAr( PES )
                  dbSetOrder( 4 )
                  dbGoTop()
                  IF dbSeek( mPIS )  // transferencias readmissoes
                     mNUMERO := NUMERO
                     WHILE mPIS = PIS .AND. !Eof()
                        IF NUMERO > mNUMERO
                           mNUMERO := NUMERO
                        ENDIF
                        dbSkip()
                     ENDDO
                  ELSE
                     mNUMERO := 0
                  ENDIF
                  dbSetOrder( 1 )
               ELSE
                  dbSelectAr( PES )
                  dbSetOrder( 1 )
                  dbGoTop()
                  IF dbSeek( mNUMERO )
                     mPIS := PIS
                  ENDIF
               ENDIF
            ENDIF
            IF mEMPINI > 0
               mEMPRESA := Val( SubStr( linha, mEMPINI, nCASAEMP ) )
            ENDIF
            tDIA := SubStr( linha, mDIAINI, 2 )
            tMES := SubStr( linha, mMESINI, 2 )
            tANO := SubStr( linha, mANOINI, nCASANO )
            tHOR := SubStr( linha, mHORINI, 2 )
            tMIN := SubStr( linha, mMININI, 2 )
            IF mRELINI > 0   // alguns Relogios e catracas que nao registram codigo relogio
               tREL := SubStr( linha, mRELINI, nCASREL )
            ENDIF
            IF mAFDT = "S"
               tREL := StrZero( nRELOGIO, 4 )
            ENDIF
            IF mSEGINI > 0   // alguns Relogios e catracas que nao registram segundos
               tSEG := SubStr( linha, mSEGINI, 2 )
            ENDIF
            mHORA := Val( tHOR + "." + tMIN )
            mDATA := CToD( tDIA + "/" + tMES + "/" + tANO )
            IF cOPER = 'R'
               IF SubStr( LINHA, 10, 1 ) = "3"   // Registro tipo 3
                  mPIS := StrZero( Val( SubStr( linha, mPISINI, nCASAPIS ) ), 11 )
                  dbSelectAr( PES )
                  dbGoTop()
                  dbSeek( mPIS )
                  WHILE mPIS = PIS .AND. !Eof()
                     IF Empty( DEMITIDO )
                        mNUMERO := NUMERO
                     ELSE
                        mADMITIDO := if( Empty( DATTRANSF ), ADMITIDO, DATATRANSF )
                        IF mDATA >= mADMITIDO .AND. mDATA <= DEMITIDO
                           mNUMERO := NUMERO
                        ENDIF
                     ENDIF
                     dbSkip()
                  ENDDO
               ENDIF
            ENDIF
            BUSCA := Str( mNUMero, 8 ) + DToS( Mdata ) + Str( mHORA, 5, 2 )
            IF mAFDT <> "S" .OR. mNUMERO > 0
               @ 05, 15 SAY mNUMERO
               @ 06, 15 SAY tDIA + "/" + tMES + "/" + tANO + " - " + tHOR + ":" + tMIN + ":" + tSEG
               @ 07, 15 SAY tREL
            ENDIF
         ELSE
            IF cOPER = "D" .AND. !lORI
               mPIS := PIS
            ENDIF
            mNUMERO := NUMERO
            mDATA   := DATA
            mHORA   := HORA
            tREL    := AllTrim( RELOGIO )
            cHORA   := StrZero( HORA, 5, 2 )
            tHOR    := SubStr( cHORA, 1, 2 )
            tMIN    := SubStr( cHORA, 4, 2 )
            tDIA    := StrZero( Day( mDATA ), 2 )
            tMES    := StrZero( Month( mDATA ), 2 )
            tANO    := StrZero( Year( mDATA ), 4 )
            tSEG    := "00"
            @ 05, 15 SAY mNUMERO
            @ 06, 15 SAY DToC( mDATA ) + " - " + cHORA
            @ 07, 15 SAY tREL
         ENDIF
         IF cOPER = "R" .AND. SubStr( LINHA, 10, 1 ) = "3"
            BUSCA := PadR( mpis, 12 ) + DToS( Mdata ) + Str( mHORA, 5, 2 )
            dbSelectAr( cREPDBF )
            dbGoTop()
            IF !dbSeek( BUSCA )
               netrecapp()
               field->pis       := mPIS
               field->DATA      := mDATA
               field->hora      := mHORA
               field->sequencia := SubStr( linha, 1, 9 )
               field->numero    := mNUMERO
               dbUnlock()
            ELSE
               IF Empty( NUMERO ) .AND. !Empty( mNUMERO )
                  netreclock()
                  field->numero := mNUMERO
                  dbUnlock()
               ENDIF
            ENDIF
         ENDIF
         IF !Empty( mDATA ) .AND. !Empty( mNUMero ) .AND. !Empty( mHORa ) .AND. cOPER <> "R"
            IF mDATA >= DCORTE .AND. mDATA <= DCORTF
               IF cOPER = "T"
                  dbSelectAr( cPD )
                  dbGoTop()
                  IF !dbSeek( BUSCA )
                     netrecapp()
                     field->NUMERO  := mNUMERO
                     FIELD->DATA    := mDATA
                     FIELD->HORA    := mHORA
                     FIELD->RELOGIO := AllTrim( tREL )
                     FIELD->TIPOR   := "O"
                     field->pis     := mPIS
                  ELSE
                     IF Empty( pis ) .AND. !Empty( mPIS )
                        netreclock()
                        field->pis := mPIS
                     ENDIF
                  ENDIF
               ENDIF
               // pega o pis caso for exportar competencias antes da portaria nao tinham pis
               IF Empty( mPIS ) .AND. !Empty( PIS )  // 1o. pis da importacao
                  mPIS := PIS
               ENDIF
               IF Empty( mPIS )  // 2. pis conforme cadastro
                  dbSelectAr( pes )
                  dbGoTop()
                  IF dbSeek( mNUMERO )
                     mPIS := PIS
                  ENDIF
               ENDIF
               IF Empty( mPIS )  // 3. pis historico
                  dbSelectAr( "FOPTOPIS" )
                  dbGoTop()
                  IF dbSeek( mNUMERO )
                     mPIS := PIS
                  ENDIF
               ENDIF
               IF cOPER = "A" .OR. ( cOPER = "B" .AND. lTXT )
                  FWrite( nHANGRV, LINHA + Chr( 13 ) + Chr( 10 ) )
               ENDIF
               IF cOPER = "C" .OR. ( cOPER = "B" .AND. !lTXT )
                  cLINCNV := cMASCARA
                  // Exemplo mascara "CCCCCCCCCCCCCCCddmmaaHHMMSSnnnnnRR"
                  // C-Cracha Numero do Funcionario
                  // R-Relogio
                  // P-Pis
                  // E-Empresa
                  cLINCNV := StrTran( cLINCNV, "dd", StrZero( Day( mDATA ), 2 ) )
                  cLINCNV := StrTran( cLINCNV, "mm", StrZero( Month( mDATA ), 2 ) )
                  cLINCNV := StrTran( cLINCNV, "aaaa", StrZero( Year( mDATA ), 4 ) )
                  cLINCNV := StrTran( cLINCNV, "aa", Right( StrZero( Year( mDATA ), 4 ), 2 ) )
                  cLINCNV := StrTran( cLINCNV, "HH", tHOR )
                  cLINCNV := StrTran( cLINCNV, "MM", tMIN )
                  cLINCNV := StrTran( cLINCNV, "SS", tSEG )
                  cLINCNV := StrTran( cLINCNV, "n", "0" )
                  nLENCCC := NUMAT( "C", cLINCNV )
                  cLINCNV := StrTran( cLINCNV, REPL( "C", nLENCCC ), StrZero( mNUMERO, nLENCCC ) )   //
                  nLENCCC := NUMAT( "P", cLINCNV )
                  IF ValType( mPIS ) = "C"
                     MPIS := Val( mPIS )
                  ENDIF
                  cLINCNV := StrTran( cLINCNV, REPL( "P", nLENCCC ), StrZero( mPIS, nLENCCC ) )  //
                  nLENCCC := NUMAT( "E", cLINCNV )
                  cLINCNV := StrTran( cLINCNV, REPL( "E", nLENCCC ), StrZero( mEMPRESA, nLENCCC ) )  //
                  nLENCCC := NUMAT( "R", cLINCNV )
                  IF nLENCCC > 0
                     cLINCNV := StrTran( cLINCNV, REPL( "R", nLENCCC ), StrZero( Val( tREL ), nLENCCC ) )
                  ENDIF
                  FWrite( nHANGRV, cLINCNV + Chr( 13 ) + Chr( 10 ) )
               ENDIF
               IF cOPER = "D" .AND. nequip = Val( trel )
                  IF !Empty( mPIS )
                     FWrite( nHANGRV, StrZero( Nseq, 9, 0 ) )
                     FWrite( nHANGRV, "3" )
                     FWrite( nHANGRV, tDIA + tMES + IF( Len( tANO ) = 2, "20" + tANO, tano ) )
                     FWrite( nHANGRV, tHOR + tMIN )
                     FWrite( nHANGRV, StrZero( Val( mPIS ), 12 ) )
                     FWrite( nHANGRV, Chr( 13 ) + Chr( 10 ) )
                     nSEQ++
                     nREG3++
                     IF lREPTEM
                     /*
                       BUSCA := PADR(mpis,12) + dtos( Mdata ) + str( mHORA, 5, 2 )
                       dbselectar(cREPDBF)
                       dbgotop()
                       if dbseek( BUSCA )
                          //IF (EMPTY((cREPDBF)->NUMERO).OR.EMPTY((cREPDBF)->EMP)) // mNUMERO>0
                             netreclock()
                             @ 22,00 SAY "GRV: "+BUSCA
                             (cREPDBF)->numero:=mNUMERO
                             (cREPDBF)->emp   :=mEMPRESA
                             dbunlocK()
                          //ENDIF
                       endif
                       */
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF !lTXT
         dbSelectAr( cPD )
         dbSkip()
         IF Eof()
            LINHA := "__FINAL__"
         ENDIF
      ELSE
         LINHA := AllTrim( FREADLINE( nHANDLE ) )
         nLINHA++
         @ 10, 15 SAY nLINHA
      ENDIF
      IF LINHA = "__FINAL__"
         EXIT
      ENDIF
   ENDDO
   IF lTXT
      FClose( nHANDLE )
   ENDIF


   IF cOPER = "D" .AND. nreg3 > 0
      dbSelectAr( pes )
      dbGoTop()
      WHILE !Eof()
         PETELA( 12 )
         IF Year( admitido ) = anouso .AND. Month( admitido ) = mestrab
            FWrite( nHANGRV, StrZero( Nseq, 9, 0 ) )
            FWrite( nHANGRV, "5" )
            FWrite( nHANGRV, DToS( admitido ) )
            FWrite( nHANGRV, "0800" )
            FWrite( nHANGRV, "I" )
            FWrite( nHANGRV, StrZero( Val( PIS ), 12 ) )
            FWrite( nHANGRV, PadR( NOME, 52 ) )
            FWrite( nHANGRV, Chr( 13 ) + Chr( 10 ) )
            nSEQ++
            nREG5++
         ENDIF
         IF Year( demitido ) = anouso .AND. Month( demitido ) = mestrab
            FWrite( nHANGRV, StrZero( Nseq, 9, 0 ) )
            FWrite( nHANGRV, "5" )
            FWrite( nHANGRV, DToS( demitido ) )
            FWrite( nHANGRV, "1700" )
            FWrite( nHANGRV, "E" )
            FWrite( nHANGRV, StrZero( Val( PIS ), 12 ) )
            FWrite( nHANGRV, PadR( NOME, 52 ) )
            FWrite( nHANGRV, Chr( 13 ) + Chr( 10 ) )
            nSEQ++
            nREG5++
         ENDIF
         dbSkip()
      ENDDO
      FWrite( nHANGRV, REPL( "9", 9 ) )
      FWrite( nHANGRV, StrZero( 0, 9, 0 ) )
      FWrite( nHANGRV, StrZero( nREG3, 9, 0 ) )
      FWrite( nHANGRV, StrZero( 0, 9, 0 ) )
      FWrite( nHANGRV, StrZero( nREG5, 9, 0 ) )
      FWrite( nHANGRV, "9" )
      FWrite( nHANGRV, Chr( 13 ) + Chr( 10 ) )
   ENDIF

/* melhorias necessarias na pis para incluir os periodos admissao demissao e transferencias
IF lREPTEM
   @ 24,00 SAY "Checando "+cREPDBF
   dbselectar(pes)
   dbsetorder(4) //pis
   dbselectar(cREPDBF)
   dbsetorder(2)
   dbgotop()
   while ! eof()
       mPIS:=AllTrim(PIS)
       mNUMERO:=0
       @ 24,20 SAY mPIS+StrZero(RecNo(),8)
       dbselectar(pes)
       dbGoTop()
       if dbseek(mPIS)
          mNUMERO:=NUMERO
          @ 24,30 say nome
       endif
       dbselectar(cREPDBF)
       while mPIS=AllTrim(PIS).AND.! EOF()
          lTEM:=.F.
          IF mNUMERO>0.AND.EMPTY(NUMERO).AND.DATA >= DCORTE .AND. DATA <= DCORTF
             BUSCA:=str( mNUMero, 8 ) + dtos( DATA) + str(  HORA,5, 2 )
             dbselectar(cPD)
             dbgotop()
             if dbseek(BUSCA)
                lTEM:=.T.
             endif
          endif
          dbselectar(cREPDBF)
          IF lTEM
             @ 22,00 SAY "GRV: "+BUSCA
             NETRECLOCK()
             FIELD->NUMERO:=mNUMERO
             FIELD->EMP:=NREMP
             dbUnlock()
          ENDIF
          dbskip()
       enddo
   enddo
ENDIF
*/

   dbCloseAll()


   IF cOPER <> "T" .AND. cOPER <> "R"
      FClose( nHANGRV )
   ENDIF

   IF cOPER = "A" .OR. lTIPOS
      RETURN .T.
   ENDIF

   IF ( nTIPO = 1 .OR. nTIPO = 4 .OR. nTIPO = 5 ) .AND. cOPER <> "D"
      trocapro( cpd, dcorte, dcortf )
      IF lPER
         IF MDG( "Deseja Transferir Dados Ponto do Mes" )
            FOPTO_12()
         ENDIF
      ELSE
         FOPTO_12( DCORTE, DCORTF )
      ENDIF
   ENDIF

// + EOF: fopto_19.prg
// +
