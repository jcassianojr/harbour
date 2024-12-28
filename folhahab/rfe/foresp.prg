// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foresp.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"

// !*****************************************************************************
// !
// !         Funcao: FORES_CY()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FORES_CY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FORES_CY

   PARA DATAI, DATAF, REFFIL, TITULO

   @ 12, 0 CLEA TO 16, 79
   @ 12, 0 TO 16, 79 DOUB
   @ 14, 3 SAY 'Acumulando Vari vel : ' + TITULO
   ANOI  := Year( DATAI )
   ANOF  := Year( DATAF )
   PATH1 := '\FOLHA\EMP' + ANOSTR( ANOI ) + StrZero( NREMP, 3 ) + '\' + SPAC( 20 )
   MDS( 'Confirme localizacao Arquivos de:' + ANOSTR( ANOI ) )
   @ 24, 45 GET PATH1
   READCUR()
   PATH1 := AllTrim( PATH1 )
   IF ANOI # ANOF
      PATH2 := '\FOLHA\EMP' + ANOSTR( ANOF ) + StrZero( NREMP, 3 ) + '\' + SPAC( 20 )
      MDS( 'Confirme localizacao Arquivos:' + ANOSTR( ANOF ) )
      @ 24, 45 GET PATH2
      READCUR()
      PATH2 := AllTrim( PATH2 )
      READCUR()
   ENDIF
   MESINI := Month( DATAI )
   MESFIM := 12
   PATHB  := PATH1
   ACUVAR( REFFIL, .T., .T. )
   IF ANOI # ANOF
      MESINI := 1
      MESFIM := Month( DATAF )
      PATHB  := PATH2
      ACUVAR( REFFIL, .T., .F. )
   ENDIF
   MESES := 12
   MDS( 'Qual o avos divisor da Media' )
   @ 24, 40 GET MESES
   READCUR()
   MDS( 'Aguarde Calculando a Media' )
   dbSelectAr( "FO_VAR" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "HORAS", HORAS / MESES ) }, {|| NUMERO = CTR }, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VALOR", VALOR / MESES ) }, {|| NUMERO = CTR }, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbSelectAr( "FO_VAR" )
   VALORVAR := VALVAR( REFFIL )
   RETU ( VALORVAR )

// !*****************************************************************************
// !
// !         Fun‡„o: MDL()
// !
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MDL( TITULO, nTIP )

   IF ValType( nTIP ) # "N"
      nTIP := 1
   ENDIF
   CABE2( TITULO )
   @ 18, 00 TO 21, 79 DOUB
   @ 19, 03 SAY 'LIGUE A IMPRESSORA !! ,Ajuste o papel'
   @ 20, 25 SAY 'IMPRESSORA DEFINIDA PARA FORMULARIO => '
   @ 20, 64 SAY IF( IM1 = 'A', '80', '132' ) + ' Colunas '

   RETURN CHECKIMP( nTIP )


// !*****************************************************************************
// !
// !         Fun‡„o: TABINSS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TABINSS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TABINSS( BUSCA )   // CARREGA TABELA INSS

   MDS( 'Carregando tabela INSS' )
   IF !netuse( "TABINSS" )
      RETU
   ENDIF
   dbGoto( BUSCA )
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
   dbCloseArea()
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: TABIRRF()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TABIRRF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION TABIRRF( BUSCA )   // CARREGA TABELA IRRF

   MDS( 'Carregando Tabela IRRF' )
   IF !NETUSE( "TABIRRF" )   // BREDE("TABIRRF",0)
      RETU
   ENDIF
   dbGoto( BUSCA )
   QTDEIRRF    := QTDEDEP
   VDEPENDE    := VALDEPENDE
   DESC_MINIMO := MINIMO
   IRRF1       := ATESAL1
   IRTX1       := TAXA1
   IRPA1       := PARCELA1
   IRRF2       := ATESAL2
   IRTX2       := TAXA2
   IRPA2       := PARCELA2
   IRRF3       := ATESAL3
   IRTX3       := TAXA3
   IRPA3       := PARCELA3
   IRRF4       := ATESAL4
   IRTX4       := TAXA4
   IRPA4       := PARCELA4
   IRRF5       := ATESAL5
   IRTX5       := TAXA5
   IRPA5       := PARCELA5
   IRRF6       := ATESAL6
   IRTX6       := TAXA6
   IRPA6       := PARCELA6
   IRRF7       := ATESAL7
   IRTX7       := TAXA7
   IRPA7       := PARCELA7
   ARREIRRF    := ARREDONDA
   DESPIRRF    := DESPRESA
   mFATORIRRF  := FATORIRRF
   mFATORIRR2  := FATORIRR2
   dbCloseArea()
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: CALCINSS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCINSS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CALCINSS( BASE )   // CALCULA INSS

   VALORINSS := VALORINSSI := 0
// VALOR INSS DE DESCONTO
   IF BASE >= TETOINPS
      VALORINSS := Round( ( TETOINPS * TX ), 2 )
   ELSE
      DO CASE
      CASE BASE <= IN1
         VALORINSS := Round( ( BASE * TX1 ), 2 )
      CASE BASE <= IN2
         VALORINSS := Round( ( BASE * TX2 ), 2 )
      CASE BASE <= IN3
         VALORINSS := Round( ( BASE * TX3 ), 2 )
      CASE BASE <= IN4
         VALORINSS := Round( ( BASE * TX4 ), 2 )
      CASE BASE <= IN5
         VALORINSS := Round( ( BASE * TX5 ), 2 )
      CASE BASE <= IN6
         VALORINSS := Round( ( BASE * TX6 ), 2 )
      CASE BASE <= IN7
         VALORINSS := Round( ( BASE * TX7 ), 2 )
      ENDCASE
   ENDIF
// VALOR INSS DE DEDUCAO IRRF
   IF BASE >= TETOINPSI
      VALORINSSI := Round( ( TETOINPSI * TXI ), 2 )
   ELSE
      DO CASE
      CASE BASE <= IN1
         VALORINSSI := Round( ( BASE * TXI1 ), 2 )
      CASE BASE <= IN2
         VALORINSSI := Round( ( BASE * TXI2 ), 2 )
      CASE BASE <= IN3
         VALORINSSI := Round( ( BASE * TXI3 ), 2 )
      CASE BASE <= IN4
         VALORINSSI := Round( ( BASE * TXI4 ), 2 )
      CASE BASE <= IN5
         VALORINSSI := Round( ( BASE * TXI5 ), 2 )
      CASE BASE <= IN6
         VALORINSSI := Round( ( BASE * TXI6 ), 2 )
      CASE BASE <= IN7
         VALORINSSI := Round( ( BASE * TXI7 ), 2 )
      ENDCASE
   ENDIF
   RETU ( VALORINSS )

// !*****************************************************************************
// !
// !       CALCDEPE
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCDEPE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CALCDEPE   // CALCULA VALOR DEPENDENTES

   VAL4 := IF( DEP > QTDEIRRF, ( QTDEIRRF * VDEPENDE ), ( DEP * VDEPENDE ) )
   IF mFATORIRRF # 0
      VAL4 := Round( VAL4 / mFATORIRRF, 2 )
   ENDIF
   RETU VAL4

// !*****************************************************************************
// !
// !         Fun‡„o: CALCIRRF()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCIRRF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CALCIRRF( BASE )   // CALCULA IR

   nBASEIRRF := IF( mFATORIRRF # 0, Round( BASE * mFATORIRRF, 2 ), BASE )
   IR3       := DESCIR := VALDESCIR := 0
   DO CASE
   CASE nBASEIRRF <= IRRF1
      IR3    := IRTX1
      DESCIR := IRPA1
   CASE nBASEIRRF <= IRRF2
      IR3    := IRTX2
      DESCIR := IRPA2
   CASE nBASEIRRF <= IRRF3
      IR3    := IRTX3
      DESCIR := IRPA3
   CASE nBASEIRRF <= IRRF4
      IR3    := IRTX4
      DESCIR := IRPA4
   CASE nBASEIRRF <= IRRF5
      IR3    := IRTX5
      DESCIR := IRPA5
   CASE nBASEIRRF <= IRRF6
      IR3    := IRTX6
      DESCIR := IRPA6
   CASE nBASEIRRF > IRRF7
      IR3    := IRTX7
      DESCIR := IRPA7
   ENDCASE
   IF IR3 # 0
      IR3A      := ( IR3 / 100 )
      IR2       := ( nBASEIRRF * IR3A )
      VALDESCIR := ( IR2 - DESCIR )
      IF VALDESCIR <= DESC_MINIMO
         VALDESCIR := IR3 := 0
      ENDIF
   ELSE
      VALDESCIR := IR3 := 0
   ENDIF
   IF ARREIRRF = 'S'
      VALDESCIR := ( Int( ( VALDESCIR + .5 ) * 100 ) / 100 )
   ENDIF
   IF DESPIRRF = 'S'
      VALDESCIR := Int( VALDESCIR )
   ENDIF
   VALDESCIR := IF( mFATORIRR2 # 0, Round( VALDESCIR / mFATORIRR2, 2 ), VALDESCIR )
   RETU ( VALDESCIR )

// !*****************************************************************************
// !
// !         Fun‡„o: CABE2()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABE2( TITULO )  // CABECARIO DE MENUS

   SetColor( "N/W" )
   @ 06, 04 CLEA TO 06, 74
   @ 06, 06 SAY TITULO
   SetColor( "W/N,N/W" )
   @ 08, 00 CLEA
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: CABE3()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABE3( TITULO, QT )   // TELA AUXILIAR PARA MENUS

   SetColor( "W/N,N/W" )
   @ 04, 01 CLEA TO 04, 78
   @ 06, 01 CLEA TO 06, 78
   @ 08, 00 CLEA
   SetColor( "N/W" )
   @ 04, 04 CLEA TO 04, 74
   @ 04, 06 SAY TITULO
   SetColor( "+GR/BG" )
   hb_DispBox( 8, 0, qt, 79, B_DOUBLE )
   RETU ( .T. )


// !*****************************************************************************
// !
// !         Fun‡„o: CABEX()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABEX( cMES )

   CABE2( cMES )

   RETURN .T.


// !*****************************************************************************
// !
// !         Fun‡„o: GRAVA2()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA2   // USO GRAVACAO DADOS FOLHA

   PARA CTR1, VALE, dCDAT
   LOCAL cALIAS

   cALIAS := Alias()
   dbSelectAr( "CONTAS" )
   dbGoTop()
   IF dbSeek( CTR1 )
      XA := FATOR
      XB := TIPO
      XC := TRIBUTINPS
      XD := TRIBUTIRR
      XE := TRIB_FGTS
      XF := VALOR
   ENDIF
   CTA := ( CTR * 10000 ) + CTR1
   dbSelectAr( cALIAS )
   dbGoTop()
   IF !dbSeek( CTA )
      NETRECAPP()
      FIELD->NUMERO   := CTR
      FIELD->CONTA    := CTR1
      FIELD->CONTROLE := CTA
   ELSE
      NETRECLOCK()
   ENDIF
   FIELD->VALOR      := VALE
   FIELD->FATOR      := XA
   FIELD->TIPO       := XB
   FIELD->TRIBUTINPS := XC
   FIELD->TRIBUTIRR  := XD
   FIELD->TRIB_FGTS  := XE
   FIELD->VALORBASE  := XF
   IF ValType( dCDAT ) = "D"
      FIELD->DATACOMP := dCDAT
   ENDIF
   dbUnlock()
   RETU .T.


// !*****************************************************************************
// !
// !      FODZER
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FODZER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FODZER

   GRAPP := 1
   GRAPT := LastRec()
   GRAPT( 'AGUARDE  EXCLUINDO VALORES = 0.00' )
   PCK := .F.
   dbGoTop()
   WHILE !Eof()
      IF AllTrim( Alias() ) # "FO_COMP"
         IF HORAS = 0.00 .AND. VALOR = 0.00
            netrecdel()
            PCK := .T.
         ENDIF
      ELSE
         IF HORAS = 0.00 .AND. VALOR = 0.00 .AND. VALORMES1 = 0 .AND. VALORMES2 = 0
            netrecdel()
            PCK := .T.
         ENDIF
      ENDIF
      GRAPS()
      dbSkip()
   ENDDO
   IF PCK
      PACK
   ENDIF
   RETU



// !*****************************************************************************
// !
// !         Fun‡„o: ANOSTR()
// !
// !    Chamado por: FORES_CY()         (fun‡„o    em FORESP.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ANOSTR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION ANOSTR( XANO )   // USADO PARA CALCULO DE ANOS

   RETU SubStr( StrZero( XANO, 4 ), 3, 2 )

// !*****************************************************************************
// !
// !         Fun‡„o: VALCTA()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALCTA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION VALCTA( NFUNC, NCONT )  // RETORNA UM VALOR DE UMA CONTA

   BUSCA := ( NFUNC * 10000 ) + NCONT
   dbGoTop()
   IF !dbSeek( BUSCA )
      RETU ( 0 )
   ENDIF
   RETU ( VALOR )


// !*****************************************************************************
// !
// !         Fun‡„o: VALVAR()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION VALVAR

   PARA FILVAR

   DOMINGO := 0.000
   MDS( "Qual a media de dias DSR " )
   @ 24, 40 GET DOMINGO PICT "9.999"
   READCUR()
   MDS( 'Atualizando Variavel' )
   VALDSR := VALCTA6 := VALEVAR := 0
   dbSelectAr( "CONTAS" )
   SET FILTER TO &FILVAR
   dbGoTop()
   WHILE !Eof()
      BUSCA  := ( CTR * 10000 ) + CODIGO
      MESSM  := 'Calculando: ' + Str( CODIGO ) + '-' + DESCR
      mCONTA := CODIGO
      TIP    := TIPO
      FAT    := FATOR
      VAL    := VALOR
      dbSelectAr( "FO_VAR" )
      dbGoTop()
      IF dbSeek( BUSCA )
         MDS( MESSM )
         VALE1 := 0
         DO CASE
         CASE TIP = 0
            VALE1 := VALOR
         CASE TIP = 1
            VALE1 := HORAS * SALH
         CASE TIP = 2
            VALE1 := VAL
         CASE TIP = 3
            VALE1 := VAL * HORAS
         CASE mCONTA = 6
            VALCTA6 := VALOR
         ENDCASE
         VALE1 := IF( FAT # 0.00, VALE1 * FAT, VALE1 )
         NETRECLOCK()
         FIELD->VALOR := VALE1
         dbUnlock()
         IF ( mCONTA > 19 .AND. mCONTA < 40 ) .OR. ( mCONTA > 9 .AND. mCONTA < 17 )
            VALDSR += VALOR
         ENDIF
         VALEVAR += IF( mCONTA # 6, VALE1, 0 )
      ENDIF
      dbSelectAr( "CONTAS" )
      dbSkip()
   ENDDO
   IF DOMINGO # 0 .AND. VALDSR # 0
      VALCTA6 := ( ( VALDSR / ( 30 - DOMINGO ) ) * DOMINGO )
      dbSelectAr( "FO_VAR" )
      dbGoTop()
      IF dbSeek( CTR * 10000 + 6 )
         NETRECLOCK()
         FIELD->VALOR := VALCTA6
         dbUnlock()
      ENDIF
   ENDIF
   VALEVAR += VALCTA6
   dbSelectAr( "CONTAS" )
   SET FILTER TO
   RETU ( VALEVAR )
// !*****************************************************************************
// !
// !         Fun‡„o: CABEP()
// !
// !    Chamado por: FORES_C3.PRG
// !               : RESTELA()          (fun‡„o    em FORES_C3.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABEP( TITULO )

   SetColor( "+N/GR" )
   hb_DispBox( 8, 0, 23, 78, B_DOUBLE )
   SetColor( "+N/W" )
   @  8, 0 SAY " - "
   SetColor( "+W/R" )
   @  8, 3 SAY TITULO
   hb_Scroll( 9, 79, 24, 79 )
   @ 24, 1 SAY SPAC( 78 )
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: ACUVAR()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ACUVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION ACUVAR

   PARA FILTRA, LPATH, LIMPAR

   IF MESINI < 1 .OR. MESINI > 12
      ALERTX( "Erro Mes Inicial" + Str( MESINI ) )
      RETU .F.
   ENDIF
   IF MESFIM < 1 .OR. MESFIM > 12
      ALERTX( "Erro Mes Final" + Str( MESFIM ) )
      RETU .F.
   ENDIF
   MDS( 'Acumulando Sal rio Variavel' )
   dbSelectAr( "CONTAS" )
   SET FILTER TO &FILTRA
   dbSelectAr( "FO_VAR" )
   IF LIMPAR
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netrecdel() }, {|| NUMERO = CTR }, {|| zei_fort( nLASTREC,,, 1 ) } )
   ENDIF
// _PACK
   FOR X := MESINI TO MESFIM
      ARQTRAB := StrZero( X, 2 )
      FOT     := IF( NRSEN # 'DiReT', 'FP' + EMP + ARQTRAB, 'SO' + EMP + ARQTRAB )
      FOT     := IF( LPATH, PATHB + FOT, FOT )
      INFOR( FOT, "CONTROLE", FOT, .T. )
      IF !NETUSE( FOT )  // AREDE(FOT,FOT,0)
         RETU
      ENDIF
      mNUMERO := CTR
      dbSelectAr( "CONTAS" )
      dbGoTop()
      WHILE !Eof()
         MESSM      := 'Conta: ' + Str( CODIGO ) + '-' + DESCR
         mVAR13S    := SAL_13
         mNIV13S    := NIVEL_13
         mVARFER    := FERIAS
         mNIVFER    := NIVEL_FERI
         mVARRES    := DEMISSAO
         mNIVRES    := NIVEL_DEM
         mTIPO      := TIPO
         mCONTA     := CODIGO
         mCONTROLE  := ( mNUMERO * 10000 ) + mCONTA
         mmFATMES   := "FAT" + ARQTRAB
         mFATMES    := &mmFATMES.
         mVALORFIXO := VALOR
         dbSelectAr( FOT )
         dbGoTop()
         IF dbSeek( mCONTROLE )
            MDS( MESSM )
            mVALOR := 0
            mHORAS := 0
            IF mTIPO = 1 .OR. mTIPO = 3
               mHORAS := HORAS
            ELSE
               mVALOR := IF( mFATMES = 0, VALOR, VALOR * mFATMES )
            ENDIF
            dbSelectAr( "FO_VAR" )
            dbGoTop()
            IF !dbSeek( mCONTROLE )
               NETRECAPP()
               FO_VAR->NUMERO   := mNUMERO
               FO_VAR->CONTA    := mCONTA
               FO_VAR->TIPO     := mTIPO
               FO_VAR->CONTROLE := mCONTROLE
               FO_VAR->VAR13S   := mVAR13S
               FO_VAR->NIV13S   := mNIV13S
               FO_VAR->VARFER   := mVARFER
               FO_VAR->NIVFER   := mNIVFER
               FO_VAR->VARRES   := mVARRES
               FO_VAR->NIVRES   := mNIVRES
            ELSE
               NETRECLOCK()
            ENDIF
            DO CASE
            CASE mTIPO = 1 .OR. mTIPO = 3  // SOMA HORAS
               FIELD->HORAS := ( HORAS + mHORAS )
            CASE mTIPO = 0   // SOMA VALOR
               FIELD->VALOR := ( VALOR + mVALOR )
               FIELD->HORAS := 0
            CASE mCONTA = 114  // PERICULOSIDADE
               FIELD->VALOR := SALM
               FIELD->HORAS := 0
            ENDCASE
            dbUnlock()
         ENDIF
         dbSelectAr( "CONTAS" )
         dbSkip()
      ENDDO
      dbSelectAr( FOT )
      dbCloseArea()
   NEXT X
   dbSelectAr( "CONTAS" )
   SET FILTER TO
   RETU .T.



// + EOF: foresp.prg
// +
