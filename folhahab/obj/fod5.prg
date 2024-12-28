// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod5.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fod5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fod5

   PARA NN

   CABEX( "Calculando Folha" )
   IF NN = 1
      CC1A := PES
      CC1B := PES
      CC2A := "CONTAS"
      CC2B := "CONTAS"
      CC3  := SEM
   ELSE
      CC1A := "MG01"
      CC1B := "MG01"
      CC2A := "CTARPA"
      CC2B := "CTARPA"
      CC3  := RPA
   ENDIF
   aCOD    := {}
   aDAD    := {}
   mSEMANA := PEGSEMANA()
   IF mSEMANA = 99
      RETU .F.
   ENDIF

   MDS( 'Aguarde Carregando Tabela de IRRF' )
   QTDEIRRF   := VDEPENDE := DESC_MINIMO := SALFAMILIA := IRRF1 := IRTX1 := IRPA1 := 0
   TETOFAMIL  := SALFAMIL1 := 0
   IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
   IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
   mFATORIRRF := mFATORIRR2 := 0
   ARREIRRF   := DESPIRRF := 'N'
   TABIRRF()

   MDS( 'Carregando tabela IAPAS ' )
   IF !netuse( "TABINSS" )   // BREDE( "TABINSS", 1 )
      RETU .F.
   ENDIF
   dbGoto( MESTRAB )
   IN1  := ATESAL1
   IN2  := ATESAL2
   IN3  := ATESAL3
   IN4  := ATESAL4
   IN5  := ATESAL5
   IN6  := ATESAL6
   IN7  := ATESAL7
   TX1  := ( TAXA1 / 100 )
   TX2  := ( TAXA2 / 100 )
   TX3  := ( TAXA3 / 100 )
   TX4  := ( TAXA4 / 100 )
   TX5  := ( TAXA5 / 100 )
   TX6  := ( TAXA6 / 100 )
   TX7  := ( TAXA7 / 100 )
   TXI1 := ( TAXAI1 / 100 )
   TXI2 := ( TAXAI2 / 100 )
   TXI3 := ( TAXAI3 / 100 )
   TXI4 := ( TAXAI4 / 100 )
   TXI5 := ( TAXAI5 / 100 )
   TXI6 := ( TAXAI6 / 100 )
   TXI7 := ( TAXAI7 / 100 )
   TX   := 0
   TXI  := 0
   DO CASE
   CASE TX7 <> 0.00
      TX  := TX7
      TXI := TXI7
   CASE TX6 <> 0.00
      TX  := TX6
      TXI := TXI6
   CASE TX5 <> 0.00
      TX  := TX5
      TXI := TXI5
   CASE TX4 <> 0.00
      TX  := TX4
      TXI := TXI4
   CASE TX3 <> 0.00
      TX  := TX3
      TXI := TXI3
   CASE TX2 <> 0.00
      TX  := TX2
      TXI := TXI2
   CASE TX1 <> 0.00
      TX  := TX1
      TXI := TXI1
   ENDCASE
   TETOINPS   := TETOMAXIMO
   TETOINPSI  := TETOIRRF
   SALFAMILIA := FAMILIA
   SALFAMIL1  := FAMILIA1
   TETOFAMIL  := TETOSALFA
   TETOFAMI1  := TETOSALF1
   INSSDESC   := DESCONTO
   dbCloseAll()

   MDS( "Pegando Configura‡„o de Contas" )
   IF !netuse( cc2a )  // AREDE( CC2A, CC2B, 1 )
      RETU
   ENDIF
   WHILE !Eof()
      @ 24, 00 SAY CODIGO
      AAdd( aCOD, CODIGO )
      IF NN = 1
         AAdd( aDAD, { TIPO, FATOR, VALOR, TRIBUTINPS, TRIBUTIRR, 100, 100, 100 } )
      ELSE
         AAdd( aDAD, { TIPO, FATOR, VALOR, TRIBUTINPS, TRIBUTIRR, BASEREDI, BASERIR, IPER } )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()

   IF !netuse( cc1a )  // AREDE( CC1A, CC1B, 1 )
      RETU .F.
   ENDIF
   IF !netuse( cc3 )   // AREDE( CC3, CC3, 0 )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( CC1A )
   WHILE !Eof()
      PETELA( 8 )
      mNUMERO   := NUMERO
      mCREDITO  := mDEBITO := mBASEINSS := mVALORINSS := BASEINSD := 0
      mBASEIRRF := mVALORIRRF := mVALDEP := 0
      VINSSIPE  := 0
      mBINSSIPE := 0
      DEP       := FOSFAMQTDE( mNUMERO )
      mVALDEP   := CALCDEPE()
      SALH      := SALM := VEN := DES := VAL4 := 0
      SALHM()
      MDS( "Calculando Dados" )
      dbSelectAr( CC3 )
      dbGoTop()
      dbSeek( mNUMERO * 10000 )
      WHILE NUMERO = mNUMERO .AND. !Eof()
         IF SEMANA = mSEMANA
            nPOS := AScan( aCOD, CONTA )
            IF nPOS > 0
               VALE1     := 0
               TIPO      := aDAD[ nPOS, 1 ]
               FATOR     := aDAD[ nPOS, 2 ]
               VALORBASE := aDAD[ nPOS, 3 ]
               TRIBINSS  := aDAD[ nPOS, 4 ]
               TRIBIRRF  := aDAD[ nPOS, 5 ]
               REDUREDI  := aDAD[ nPOS, 6 ]
               REDURIR   := aDAD[ nPOS, 7 ]
               IPER      := aDAD[ nPOS, 8 ]
               DO CASE
               CASE TIPO = 1
                  VALE1 := ( HORAS * SALH )
                  VALE1 := if( FATOR # 0, Round( VALE1 * FATOR, 2 ), VALE1 )
               CASE TIPO = 2
                  VALE1 := ( VALORBASE )
               CASE TIPO = 3
                  VALE1 := ( HORAS * VALORBASE )
                  VALE1 := if( FATOR # 0, Round( VALE1 * FATOR, 2 ), VALE1 )
               CASE TIPO = 4
                  VALE1 := Round( SALM * HORAS / 30, 2 )
                  VALE1 := if( FATOR # 0, Round( VALE1 * FATOR, 2 ), VALE1 )
               ENDCASE
               IF VALE1 > 0
                  netreclock()
                  field->VALOR := VALE1
                  dbUnlock()
               ENDIF

               // Base IRRF
               mBASETMP := VALOR
               IF REDURIR > 0  // %Redu‡ao IRFF
                  mBASETMP := VALOR - ( Valor * REDURIR / 100 )
               ENDIF
               mBASEIRRF += if( TRIBIRRF = 0, mBASETMP, 0 )
               mBASEIRRF -= if( TRIBIRRF = 2, mBASETMP, 0 )

               // Base INSS
               mBASETMP := VALOR
               IF REDUREDI > 0   // %Redu‡ao INSS
                  mBASETMP := VALOR - ( Valor * REDUREDI / 100 )
               ENDIF
               IF IPER > 0   // %iNDICADO INSS
                  mBINSSIPE += if( TRIBINSS = 0, mBASETMP, 0 )
                  mBINSSIPE -= if( TRIBINSS = 2, mBASETMP, 0 )
                  VINSSIPE  += if( TRIBINSS = 0, mBASETMP * IPER / 100, 0 )
                  VINSSIPE  -= if( TRIBINSS = 2, mBASETMP * IPER / 100, 0 )
               ELSE
                  mBASEINSS += if( TRIBINSS = 0, mBASETMP, 0 )
                  mBASEINSS -= if( TRIBINSS = 2, mBASETMP, 0 )
               ENDIF

               IF CONTA < 399
                  mCREDITO += VALOR
               ENDIF
               IF CONTA > 500 .AND. CONTA # 508 .AND. CONTA # 503 .AND. CONTA # 999
                  mDEBITO += VALOR
               ENDIF
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      BASEINSD := mBASEINSS - INSSDESC
      IF BASEINSD < 0
         BASEINSD := 0
      ENDIF
      IF BASEINSD > 0
         MDS( 'Calculando IAPAS' )
         TXREF := 0  // VALOR INSS DE DESCONTO
         IF BASEINSD >= TETOINPS
            mVALORINSS := Round( ( TETOINPS * TX ), 2 )
         ELSE
            DO CASE
            CASE BASEINSD <= IN1
               mVALORINSS := Round( ( BASEINSD * TX1 ), 2 )
               TXREF      := TX1
            CASE BASEINSD <= IN2
               mVALORINSS := Round( ( BASEINSD * TX2 ), 2 )
               TXREF      := TX2
            CASE BASEINSD <= IN3
               mVALORINSS := Round( ( BASEINSD * TX3 ), 2 )
               TXREF      := TX3
            CASE BASEINSD <= IN4
               mVALORINSS := Round( ( BASEINSD * TX4 ), 2 )
               TXREF      := TX4
            CASE BASEINSD <= IN5
               mVALORINSS := Round( ( BASEINSD * TX5 ), 2 )
               TXREF      := TX5
            CASE BASEINSD <= IN6
               mVALORINSS := Round( ( BASEINSD * TX6 ), 2 )
               TXREF      := TX6
            CASE BASEINSD <= IN7
               mVALORINSS := Round( ( BASEINSD * TX7 ), 2 )
               TXREF      := TX7
            ENDCASE
         ENDIF
         TXREF *= 100
         // Soma Outras
         mVALORINSS += VINSSIPE
         mBASEINSS  += mBINSSIPE
         IF mVALORINSS > ( TETOINPS * TX )
            MVALORINSS := Round( ( TETOINPS * TX ), 2 )
         ENDIF
         mDEBITO += mVALORINSS
      ENDIF
      IF mBASEIRRF > 0
         BASE := mBASEIRRF - mVALORINSS - mVALDEP
         IR3  := DESCIR := VALDESCIR := 0
         CALCIRRF()
         mVALORIRRF := VALDESCIR
         mDEBITO    += mVALORIRRF
      ENDIF
      aDADOS := {}
      AAdd( aDADOS, { 508, mVALORINSS } )
      AAdd( aDADOS, { 420, mBASEINSS } )
      AAdd( aDADOS, { 399, mCREDITO } )
      AAdd( aDADOS, { 999, mDEBITO } )
      AAdd( aDADOS, { 503, mVALORIRRF } )
      AAdd( aDADOS, { 401, mBASEIRRF } )
      AAdd( aDADOS, { 431, mVALORINSS + mVALDEP } )
      AAdd( aDADOS, { 413, mVALDEP } )
      AAdd( aDADOS, { 440, mCREDITO - mDEBITO } )
      AAdd( aDADOS, { 485, BASEINSD } )
      FOR X := 1 TO Len( aDADOS )
         dbGoTop()
         IF !dbSeek( mNUMERO * 10000 + mSEMANA * 1000 + aDADOS[ X, 1 ] )
            netrecapp()
            field->NUMERO := mNUMERO
            field->CONTA  := aDADOS[ X, 1 ]
            field->SEMANA := mSEMANA
         ELSE
            netreclock()
         ENDIF
         field->VALOR := aDADOS[ X, 2 ]
      NEXT X
      dbSelectAr( CC1A )
      dbSkip()
   ENDDO
   dbSelectAr( CC3 )
   FODZER()
   dbCloseAll()


// + EOF: fod5.prg
// +
