// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_b1.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :*****************************************************************************
// :
// :
// :   FOLIS_B1.PRG: CALCULA 13 SALARIO
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function folis_b1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION folis_b1

   PARA CC

   MEN := 'Calcular 13§ Salario '
   IF CC = 1
      MEN   := MEN + '1a. Parcela'
      INI   := 121
      FIM   := 129
      TOT   := 460
      BIRRF := 463
      BINSS := 464
      BFGTS := 465
   ENDIF
   IF CC = 2
      MEN   := MEN + '2a. Parcela'
      INI   := 131
      FIM   := 139
      TOT   := 461
      BIRRF := 467
      BINSS := 468
      BFGTS := 469
   ENDIF
   IF CC = 3
      MEN   := MEN + 'Complemento'
      INI   := 141
      FIM   := 149
      TOT   := 462
      BIRRF := 473
      BINSS := 474
      BFGTS := 475
   ENDIF

   CABE2( MEN )
   IF !CERTEZA()
      RETU
   ENDIF
   lLIMPA := .F.
   IF MDG( "Deseja Apagar Todo Calculo Anterior" )
      IF MDG( "Voce Tem Certeza de Apagar Todo Calculo Anterior" )
         lLIMPA := .T.
      ENDIF
   ENDIF

   @ 08, 00 CLEA
   CIRRF := Array( 9 )
   CINSS := Array( 9 )
   CFGTS := Array( 9 )
   CFATO := Array( 9 )

   XA        := XB := XC := XD := XE := XF := CTR := MESFIM := ARREDOR := 0
   TX3A      := TX5A := TX10A := TX15A := TX20A := TX := 0
   IN1       := TX1 := IN2 := TX2 := IN3 := TX3 := IN4 := TX4 := 0
   IN5       := TX5 := IN6 := TX6 := IN7 := TX7 := TETOINPS := VALORINSS := 0
   TXI1      := TXI2 := TXI3 := TXI4 := TXI5 := TXI6 := TXI7 := TETOINPSI := VALORINSSI := 0
   TX        := TXI := 0
   IN1       := TX1 := TX1A := IN2 := TX2 := TX2A := IN3 := TX3 := TX3A := IN4 := TX4 := TX4A := 0
   IN5       := TX5 := TX5A := IN6 := TX6 := TX6A := IN7 := TX7 := TX7A := TETOINPS := 0
   QTDEIRRF  := VDEPENDE := DESC_MINIMO := IRRF1 := IRTX1 := IRPA1 := 0
   TETOFAMI1 := TETOFAMIL := SALFAMIL1 := SALFAMILIA := INSSDESC := 0

   IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
   IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
   ARREIRRF   := DESPIRRF := "N"
   mFATORIRRF := mFATORIRR2 := 0


   MDS( 'Carregando tabela IAPAS' )
   TABINSS()
   MDS( 'Carregando tabela IRRF' )
   TABIRRF()

   IF MDG( 'Deseja Arredondar' )
      MDS( 'Digite o Arredondamento' )
      @ 24, 30 GET ARREDOR
      READCUR()
   ENDIF

   DIARFE   := Date()
   AVOSDIV  := 12
   AVOSDVV  := 12
   nREDIRRF := 0
   @ 19, 00
   @ 19, 00 SAY 'Qual a data de referencia'
   @ 20, 00 SAY 'Qual o avos divisor Salario Fixo'
   @ 21, 00 SAY 'Qual o avos divisor Salario Variavel'
   @ 22, 00 SAY 'Redutor Base IRRF'
   @ 19, 40 GET DIARFE
   @ 20, 40 GET AVOSDIV                                PICT '##' RANGE 1, 12
   @ 21, 40 GET AVOSDVV                                PICT '##' RANGE 1, 12
   @ 22, 40 GET nREDIRRF
   IF !READCUR()
      RETU .F.
   ENDIF


   ANOUSO  := .T.
   ACUIRRF := .T.
   ACUINSS := .T.
   IF CC = 3
      ANOUSO  := MDG( "Calcular com o sal rio do ano atual" )
      ACUIRRF := MDG( "Somar Base IRRF 2a. Parcela+Complemento" )
      ACUINSS := MDG( "Somar Base INSS 2a. Parcela+Complemento" )
   ENDIF



   IF CC # 3 .OR. ANOUSO
      IF !netuse( pes )
         RETU
      ENDIF
   ELSE
      PATHN := hb_cwd() + 'EMP' + StrZero( NREMP, 5 ) + "\"
      IF !netuse( PATHN + PES )
         RETU
      ENDIF
   ENDIF
   cSELE1 := Alias()
   FILTRO := 'EMPTY(DEMITIDO)'
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO


   IF !File( ZDIRE + "FO_FP13A.DBF" )
      DES := { "FO_FP13A", "FO_FP13B", "FO_FP13C" }
      ORI := { "FO_FP13", "FO_FP13", "FO_FP13" }
      FOR X := 1 TO 3
         CRIAR := ZDIRE + DES[ X ] + ".DBF"
         ORIGE := ZDIRE + ORI[ X ] + ".DBF"
         IF File( ORIGE )
            MDS( 'Copiando ' + Orige + ' Para ' + Criar )
            FILEcopy( ORIGE, CRIAR )
            netzap( criar )
         ENDIF
      NEXT X
   ENDIF


   c13 := PEG13( CC )
   IF lLIMPA
      NETZAP( c13 )
   ENDIF
   IF !netuse( c13,, .F.,,,, )
      dbCloseAll()
      RETU
   ENDIF
   IF CC = 2
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netrecdel() }, {|| CONTA < 130 }, {|| zei_fort( nLASTREC,,, 1 ) } )
      PACK
   ENDIF
   IF CC = 3
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netrecdel() }, {|| CONTA < 140 }, {|| zei_fort( nLASTREC,,, 1 ) } )
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netrecdel() }, {|| CONTA > 500 }, {|| zei_fort( nLASTREC,,, 1 ) } )
      PACK
   ENDIF

   IF !NETUSE( "CONTAS" )
      dbCloseAll()
      RETU
   ENDIF
   FFGTS := 0
   dbGoTop()
   dbSeek( 426 )
   IF Found()
      FFGTS := FATOR
   ENDIF
   FOR X := 1 TO 9
      CTX := INI + X - 1
      dbGoTop()
      IF dbSeek( CTX )
         CIRRF[ X ] = IRRF13
         CINSS[ X ] = INSS13
         CFGTS[ X ] = FGTS13
         CFATO[ X ] = FATOR
      ELSE
         CIRRF[ X ] = 1
         CINSS[ X ] = 1
         CFGTS[ X ] = 1
         CFATO[ X ] = IF( CC = 1, .5, 1 )
      ENDIF
   NEXT X
   FILTRA := 'SAL_13=0'


   IF !NETUSE( "FO_VAR" )
      dbCloseAll()
      RETU
   ENDIF
   IF CC = 3
      IF !NETUSE( "FO_VBR" )
         dbCloseAll()
         RETU
      ENDIF
   ENDIF

   IF !NETUSE( "FO_OCO" )
      dbCloseAll()
      RETU
   ENDIF


   IF CC = 2
      IF !NETUSE( "FO_FP13A" )
         dbCloseAll()
         RETU
      ENDIF
      cSELE7 := "FO_FP13A"
   ENDIF

   IF CC = 3
      IF !NETUSE( "FO_FP13B" )
         dbCloseAll()
         RETU
      ENDIF
      cSELE7 := "FO_FP13B"
   ENDIF


   ANOFIM := Year( DIARFE )
   MESFIM := Month( DIARFE )
   VN     := Array( 10 )

   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      CTR       := NUMERO
      mSITUACAO := SITUACAO
      PETELA( 8 )
      SALH := SALM := VAR1 := AVOS := DES := VEN := 0
      AFill( VN, 0 )
      SAL132P := SAL131P := BASEFGTS := BASEINSS := BASEIRRF := BASEINSD := 0
      SALHM()
      DEP := FOSFAMQTDE( CTR )
      IF Year( ADMITIDO ) < ANOFIM
         AVOS := MESFIM
      ENDIF
      IF Year( ADMITIDO ) = ANOFIM
         AVOS := MESFIM - Month( ADMITIDO )
         // *FUNCIONARIOS COM QUINZE DIAS NO MES
         // *13 PORQUE DATAS SOMA-SE +1 INVERTIDO PASSA-SE 13
         IF Day( eom( ADMITIDO ) ) - Day( ADMITIDO ) > 13
            AVOS++
         ENDIF
      ENDIF
      IF CC # 3
         VN[ 1 ] = SALM
      ENDIF
      dbSelectAr( "CONTAS" )
      SET FILTER TO &FILTRA
      dbGoTop()
      WHILE !Eof()
         NIV   := NIVEL_13
         BUSCA := ( CTR * 10000 ) + CODIGO
         MESSM := 'Acumulando: ' + Str( CODIGO ) + '-' + DESCR
         TIP   := TIPO
         FAT   := FATOR
         VAL   := VALOR
         dbSelectAr( "FO_VAR" )
         VALE1 := VALVAR()
         VALE2 := 0
         IF CC = 3
            dbSelectAr( "FO_VBR" )
            VALE2 := VALVAR()
         ENDIF
         VALE1 := VALE1 - VALE2
         IF NIV > 0 .AND. NIV < 10
            VN[ NIV ] = VN[ NIV ] + VALE1
         ENDIF
         dbSelectAr( "CONTAS" )
         dbSkip()
      ENDDO
      dbSelectAr( "CONTAS" )
      SET FILTER TO
      FOR X := 1 TO 9
         VN[ X ] = VN[ X ] * AVOS / IF( X = 1, AVOSDIV, AVOSDVV )
         IF CFATO[ X ] # 0
            VN[ X ] = VN[ X ] * CFATO[ X ]
         ENDIF
         VN[ X ] = Round( VN[ X ], 2 )
         CTX := INI + X - 1
         dbSelectAr( c13 )
         GRAVA2( CTX, VN[ X ] )
      NEXT X
      dbSelectAr( c13 )
      GRAVA2( 490, AVOS )
      FIELD->HORAS := AVOS
      VEN          := VN[ 1 ] + VN[ 2 ] + VN[ 3 ] + VN[ 4 ] + VN[ 5 ] + VN[ 6 ] + VN[ 7 ] + VN[ 8 ] + VN[ 9 ]
      FOR X := 1 TO 9
         BASEIRRF += IF( CIRRF[ X ] = 0, VN[ X ], 0 )
         BASEINSS += IF( CINSS[ X ] = 0, VN[ X ], 0 )
         BASEFGTS += IF( CFGTS[ X ] = 0, VN[ X ], 0 )
      NEXT X
      IF CC = 1
         dbSelectAr( "FO_OCO" )
         dbGoTop()
         LOCATE FOR NUMERO = CTR .AND. CODIGO = "0P" .AND. Year( DATASAIDA ) = ANO
         IF Found()
            IF Empty( VALPG )
               SAL131P := SALM / 2
            ELSE
               SAL131P := VALPG
            ENDIF
            IF ABTFGTS = "S"
               BASEFGTS -= SAL131P
            ENDIF
            dbSelectAr( c13 )
            GRAVA2( 913, SAL131P )
            DES += SAL131P
         ENDIF
      ENDIF
      IF CC = 2
         dbSelectAr( cSELE7 )
         PARC := VALCTA( CTR, 460 )
         dbSelectAr( c13 )
         GRAVA2( 910, PARC )
         DES += PARC
         dbSelectAr( cSELE7 )
         BASEIRRF -= VALCTA( CTR, 463 )
         BASEINSS -= VALCTA( CTR, 464 )
         BASEFGTS -= VALCTA( CTR, 465 )
         dbSelectAr( "FO_OCO" )
         dbGoTop()
         LOCATE FOR NUMERO = CTR .AND. CODIGO = "1P" .AND. Year( DATASAIDA ) = ANO
         IF Found()
            IF Empty( VALPG )
               SAL131P := SALM / 2
            ELSE
               SAL131P := VALPG
            ENDIF
            IF ABTFGTS = "S"
               BASEFGTS -= SAL131P
            ENDIF
            dbSelectAr( c13 )
            GRAVA2( 913, SAL131P )
            DES += SAL131P
         ENDIF
         // Abate do Calculo o FGTS Pago Antecipado
         dbSelectAr( "FO_OCO" )
         dbGoTop()
         LOCATE FOR NUMERO = CTR .AND. CODIGO = "0P" .AND. Year( DATASAIDA ) = ANO
         IF Found()
            IF Empty( VALPG )
               SAL132P := SALM / 2
            ELSE
               SAL132P := VALPG
            ENDIF
            IF ABTFGTS = "S"
               BASEFGTS -= SAL132P
            ENDIF
         ENDIF
      ENDIF
      IF CC = 3
         dbSelectAr( cSELE7 )
         BASEIRRF += IF( VEN > 0 .AND. ACUIRRF, VALCTA( CTR, 467 ), 0 )
         BASEINSS += IF( VEN > 0 .AND. ACUINSS, VALCTA( CTR, 468 ), 0 )
         DESCIRRF := IF( VEN > 0 .AND. ACUIRRF, VALCTA( CTR, 470 ), 0 )
         DESCINSS := IF( VEN > 0 .AND. ACUINSS, VALCTA( CTR, 471 ), 0 )
      ELSE
         DESCIRRF := 0
         DESCINSS := 0
      ENDIF
      BASEINSD := BASEINSS - INSSDESC
      IF BASEINSD < 0
         BASEINSD := 0
      ENDIF
      dbSelectAr( c13 )
      GRAVA2( BIRRF, BASEIRRF )
      GRAVA2( BINSS, BASEINSS )
      GRAVA2( 485, BASEINSD )
      GRAVA2( BFGTS, BASEFGTS )
      GRAVA2( 426, ( BASEFGTS * FFGTS ) )

      // VALOR INSS DE DESCONTO
      VALORINSSP := VALORINSSI := 0
      IF BASEINSD >= TETOINPS
         VALORINSS := Round( ( TETOINPS * TX ), 2 )
      ELSE
         DO CASE
         CASE BASEINSD <= IN1
            VALORINSS := Round( ( BASEINSD * TX1 ), 2 )
         CASE BASEINSD <= IN2
            VALORINSS := Round( ( BASEINSD * TX2 ), 2 )
         CASE BASEINSD <= IN3
            VALORINSS := Round( ( BASEINSD * TX3 ), 2 )
         CASE BASEINSD <= IN4
            VALORINSS := Round( ( BASEINSD * TX4 ), 2 )
         CASE BASEINSD <= IN5
            VALORINSS := Round( ( BASEINSD * TX5 ), 2 )
         CASE BASEINSD <= IN6
            VALORINSS := Round( ( BASEINSD * TX6 ), 2 )
         CASE BASEINSD <= IN7
            VALORINSS := Round( ( BASEINSD * TX7 ), 2 )
         ENDCASE
      ENDIF
      // VALOR INSS DE DEDUCAO IRRF
      IF BASEINSD >= TETOINPSI
         VALORINSSI := Round( ( TETOINPSI * TXI ), 2 )
      ELSE
         DO CASE
         CASE BASEINSD <= IN1
            VALORINSSI := Round( ( BASEINSD * TXI1 ), 2 )
         CASE BASEINSD <= IN2
            VALORINSSI := Round( ( BASEINSD * TXI2 ), 2 )
         CASE BASEINSD <= IN3
            VALORINSSI := Round( ( BASEINSD * TXI3 ), 2 )
         CASE BASEINSD <= IN4
            VALORINSSI := Round( ( BASEINSD * TXI4 ), 2 )
         CASE BASEINSD <= IN5
            VALORINSSI := Round( ( BASEINSD * TXI5 ), 2 )
         CASE BASEINSD <= IN6
            VALORINSSI := Round( ( BASEINSD * TXI6 ), 2 )
         CASE BASEINSD <= IN7
            VALORINSSI := Round( ( BASEINSD * TXI7 ), 2 )
         ENDCASE
      ENDIF

      IF mSITUACAO = "P"
         VALORINSS  := 0
         VALORINSSI := 0
      ENDIF

      VALDESCIN := VALORINSS - DESCINSS
      VALDESCIN := IF( VALDESCIN > 0, VALDESCIN, 0 )
      dbSelectAr( c13 )
      GRAVA2( 911, VALDESCIN )
      GRAVA2( 414, CALCDEPE() )
      GRAVA2( 437, VALORINSSI )
      IF nREDIRRF > 0
         GRAVA2( 486, nREDIRRF )
      ENDIF
      BASE      := BASEIRRF - CALCDEPE() - VALORINSSI - IF( CC # 1, VALCTA( CTR, 466 ), VALCTA( CTR, 515 ) ) - nREDIRRF
      VALDESCIR := CALCIRRF( BASE ) - DESCIRRF
      VALDESCIR := IF( VALDESCIR > 0, VALDESCIR, 0 )
      GRAVA2( 505, VALDESCIR )
      DES := DES + VALDESCIR + VALDESCIN + VALCTA( CTR, 515 )
      GRAVA2( 999, DES )
      IF CC = 2
         GRAVA2( 470, VALDESCIR )
         GRAVA2( 471, VALDESCIN )
         GRAVA2( 472, BASEFGTS * FFGTS )
      ENDIF
      IF ARREDOR <> 0 .OR. DES > VEN
         MDS( 'Arredondando o 13o. Salario' )
         IF VEN > DES
            SALDO  := VEN - DES
            SALDO1 := Int( SALDO / ARREDOR )
            SALDO2 := SALDO1 * ARREDOR
            SALDO3 := SALDO2 + ARREDOR
            SALDO4 := SALDO3 - SALDO
         ELSE
            SALDO4 := DES - VEN
         ENDIF
         IF SALDO4 = ARREDOR
            SALDO4 := 0
         ENDIF
         GRAVA2( 398, SALDO4 )
         VEN += SALDO4
      ENDIF

      GRAVA2( 399, VEN )
      GRAVA2( TOT, VEN )
      GRAVA2( 440, VEN - DES )

      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbSelectAr( c13 )
   FODZER()
   dbCloseAll()
   RETU


// !*****************************************************************************
// !
// !         Funcao: VALVAR()
// !
// !    Chamado por: FOLIS_B1.PRG
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

FUNC VALVAR

   VALEVAR := 0
   dbGoTop()
   IF dbSeek( BUSCA )
      MDS( MESSM )
      DO CASE
      CASE TIP = 0
         VALEVAR := VALOR
      CASE TIP = 1
         VALEVAR := HORAS * SALH
      CASE TIP = 2
         VALEVAR := VAL
      CASE TIP = 3
         VALEVAR := VAL * HORAS
      CASE TIP = 4
         VALEVAR := Round( SALM * HORAS / 30, 2 )
      ENDCASE
      VALEVAR := IF( FAT # 0.00, VALEVAR * FAT, VALEVAR )
   ENDIF
   RETU ( VALEVAR )
// : FIM: FOLIS_B1.PRG

// + EOF: folis_b1.prg
// +
