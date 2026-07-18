// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod2des.prg
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

// :
// :    FOD2DES.PRG: CALCULAR OS DESCONTAS DA FOLHA DE PAGAMENTO
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1999,  jcassiano  S/C Ltda.
// :  Atualizado em: 29/04/99
// :

// FOD2C {CALCULAR OS DESCONTOS DA FOLHA DE PAGAMENTO}

CABEX( '* CALCULAR A FOLHA DO MES *' )

// Pegando Indices Ocorrencias Acd.Trabalho
aOCO  := {}
aOCOI := {}
IF !netuse( "fo_tab" )
RETU
ENDIF
dbGoTop()
dbSeek( "FOCO" )
WHILE AllTrim( TABELA ) = "FOCO" .AND. !Eof()
AAdd( aOCO, CODIGO )
AAdd( aOCOI, VALOR / 100 )  // %
dbSkip()
ENDDO
dbCloseArea()

IF !NETUSE( PES )   // AREDE( PES, PES, 1 )
RETU
ENDIF
SET FILTER TO &FILTRO

IF nFOLTIP = 1
IF !NETUSE( FOL )  // AREDE( FOL, FOL, 0 )
dbCloseAll()
RETU
ENDIF
ELSE
IF !NETUSE( "FO_COMP" )  // AREDE( "FO_COMP", "FO_COMP", 0 )
dbCloseAll()
RETU
ENDIF
ENDIF
cSELE2 := Alias()

dbGoTop()
REG  := RecNo()
aCOD := {}
aDAD := {}

IF !NETUSE( "CONTAS" )
dbCloseAll()
RETU
ENDIF
dbGoTop()
IF dbSeek( 426 )
FFGTS := FATOR
ENDIF
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY CODIGO
AAdd( aCOD, CODIGO )
AAdd( aDAD, { TRIB_FGTS, TRIBUTINPS, BASEREDI, IPER, TRIBUTIRR, BASERIR } )
dbSkip()
ENDDO


dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
CTR       := NUMERO
mSITUACAO := SITUACAO
mOCOFGTS  := OCOFGTS
PETELA( 7 )
mCAT     := CATEGORIA
SALH     := SALM := VALE := VALORINSS := QTFIL := VALORINSSP := VALORINSSI := 0
INSSFE   := VALEX := VALDSR := VALDESC := BASE1 := VLSAF := VEN := DES := 0
BASEIRRF := BASEINSS := BASEFGTS := VALE1 := VALE2 := 0
BASEINSD := BINSSIPE := VINSSIPE := 0
CONTA73  := .F.
SALHM()
IF mSITUACAO = 'S' .OR. mSITUACAO = 'E' .OR. mSITUACAO = '01' .OR. mSITUACAO = '12'
MDS( 'Verificando Afastamentos' )
BASEFGTS := SALM  // Joga com base o Valor do Salario
VALE     := if( mTRUNCAR = "S", TRUNCAR( BASEFGTS * FFGTS ), BASEFGTS * FFGTS )
dbSelectAr( cSELE2 )
GRAVA2( 426 )
VALE := BASEFGTS
dbSelectAr( cSELE2 )
GRAVA2( 425 )
ENDIF
dbSelectAr( cSELE2 )
dbGoTop()
dbSeek( CTR * 10000 )
IF NUMERO # CTR .OR. Eof()
dbSelectAr( PES )
dbSkip()
LOOP
ENDIF
REG := RecNo()
MDS( 'Acumulando Bases de Calculos' )
WHILE NUMERO = CTR .AND. !Eof()
nPOS := AScan( aCOD, CONTA )
IF nPOS > 0
BASEFGTS += if( aDAD[ NPOS, 1 ] = 0, VALOR, 0 )
BASEFGTS -= if( aDAD[ NPOS, 1 ] = 2, VALOR, 0 )

// Base IRRF
mBASETMP := VALOR
IF aDAD[ NPOS,  6 ] > 0   // %Redu‡ao IRFF
mBASETMP := VALOR - ( Valor * aDAD[ NPOS, 6 ] / 100 )
ENDIF
BASEIRRF += if( aDAD[ NPOS, 5 ] = 0, mBASETMP, 0 )
BASEIRRF -= if( aDAD[ NPOS, 5 ] = 2, mBASETMP, 0 )

// Base INSS
mBASETMP := VALOR
IF aDAD[ NPOS,  3 ] > 0   // %Redu‡ao INSS
mBASETMP := VALOR - ( Valor * aDAD[ NPOS, 3 ] / 100 )
ENDIF
IF aDAD[ NPOS,  4 ] > 0   // %iNDICADO INSS
BINSSIPE += if( aDAD[ NPOS, 2 ] = 0, mBASETMP, 0 )
BINSSIPE -= if( aDAD[ NPOS, 2 ] = 2, mBASETMP, 0 )
VINSSIPE += if( aDAD[ NPOS, 2 ] = 0, mBASETMP * aDAD[ NPOS, 4 ] / 100, 0 )
VINSSIPE -= if( aDAD[ NPOS, 2 ] = 2, mBASETMP * aDAD[ NPOS, 4 ] / 100, 0 )
ELSE
BASEINSS += if( aDAD[ NPOS, 2 ] = 0, mBASETMP, 0 )
BASEINSS -= if( aDAD[ NPOS, 2 ] = 2, mBASETMP, 0 )
ENDIF
ENDIF
DO CASE
CASE CONTA = 41 .OR. CONTA = 445
VALE1 += VALOR
CASE CONTA = 413 .OR. CONTA = 515 .OR. CONTA = 516
VALE2 += VALOR
CASE CONTA = 73
CONTA73 := .T.
CASE CONTA = 491
QTFIL := VALOR
CASE CONTA = 436
VALORINSSP := VALOR
CASE CONTA = 479
INSSFE += VALOR
CASE CONTA = 478
INSSFE += VALOR
ENDCASE
IF CONTA = 398 .OR. CONTA = 399 .OR. CONTA = 70 .OR. CONTA = 74 .OR. CONTA = 999
netreclock()
field->VALOR := 0
field->HORAS := 0
dbUnlock()
ENDIF
dbSkip()
ENDDO

MDS( 'Calculando IAPAS' )
// VALOR INSS DE DESCONTO
BASEINSD := BASEINSS - INSSDESC
IF BASEINSD < 0
BASEINSD := 0
ENDIF
TXREF := 0
IF BASEINSD >= TETOINPS
VALORINSS  := Round( ( TETOINPS * TX ), 2 )
VALORINSSI := Round( ( TETOINPSI * TXI ), 2 )
ELSE
DO CASE
CASE BASEINSD <= IN1
VALORINSS  := Round( ( BASEINSD * TX1 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI1 ), 2 )
TXREF      := TX1
CASE BASEINSD <= IN2
VALORINSS  := Round( ( BASEINSD * TX2 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI2 ), 2 )
TXREF      := TX2
CASE BASEINSD <= IN3
VALORINSS  := Round( ( BASEINSD * TX3 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI3 ), 2 )
TXREF      := TX3
CASE BASEINSD <= IN4
VALORINSS  := Round( ( BASEINSD * TX4 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI4 ), 2 )
TXREF      := TX4
CASE BASEINSD <= IN5
VALORINSS  := Round( ( BASEINSD * TX5 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI5 ), 2 )
TXREF      := TX5
CASE BASEINSD <= IN6
VALORINSS  := Round( ( BASEINSD * TX6 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI6 ), 2 )
TXREF      := TX6
CASE BASEINSD <= IN7
VALORINSS  := Round( ( BASEINSD * TX7 ), 2 )
VALORINSSI := Round( ( BASEINSD * TXI7 ), 2 )
TXREF      := TX7
ENDCASE
ENDIF


VALORINSS  += VINSSIPE   // INSS % Indicado
VALORINSSI += VINSSIPE   // INSS % Indicado
IF VALORINSS > ( TETOINPS * TX )
VALORINSS := Round( ( TETOINPS * TX ), 2 )
ENDIF
IF VALORINSSI > ( TETOINPS * TXI )
VALORINSSI := Round( ( TETOINPS * TXI ), 2 )
ENDIF

VALORINSS := if( mTRUNCA2 = "S", TRUNCAR( VALORINSS ), VALORINSS )

IF mCAT = "05" .OR. mCAT = "11"
TXREF := 0
ENDIF

dbSelectAr( cSELE2 )
GRAVA2( 508, if( mSITUACAO # "P", VALORINSS, 0 ), TXREF * 100 )

VALE := BASEINSD + BINSSIPE  // INSS %Indicado
dbSelectAr( cSELE2 )
GRAVA2( 485 )

VALE := BASEINSS + BINSSIPE  // INSS %Indicado
dbSelectAr( cSELE2 )
GRAVA2( 420 )


nPOS := AScan( aOCO, mOCOFGTS )
IF nPOS > 0
VALE := aOCOI[ nPOS ] * BASEINSS
IF VALE > 0
dbSelectAr( cSELE2 )
GRAVA2( 427, VALE, aOCOI[ nPOS ] )
ENDIF
ENDIF


// Deduz o INSS ja deduzido para ferias
VALORINSSI -= INSSFE
VALE       := if( mSITUACAO # "P", VALORINSSI, 0 )
dbSelectAr( cSELE2 )
GRAVA2( 437 )

MDS( 'Calculando IRFF' )
VALE := VALE2 + VALORINSSI + VALORINSSP
dbSelectAr( cSELE2 )
GRAVA2( 431 )
IF RECOIRRF # 'S'
BASEIRRF -= VALE1
ENDIF
VALE := BASEIRRF
dbSelectAr( cSELE2 )
GRAVA2( 401 )
BASE := BASEIRRF - VALE2 - VALORINSSI - VALORINSSP
IR3  := DESCIR := VALDESCIR := 0
CALCIRRF()
VALE := VALDESCIR
dbSelectAr( cSELE2 )
GRAVA2( 503 )

MDS( 'Calculando FGTS' )
VALE := if( mTRUNCAR = "S", TRUNCAR( BASEFGTS * FFGTS ), BASEFGTS * FFGTS )
dbSelectAr( cSELE2 )
GRAVA2( 426 )
VALE := BASEFGTS
dbSelectAr( cSELE2 )
GRAVA2( 425 )

IF !CONTA73 .AND. ( Empty( mSITUACAO ) .OR. mSITUACAO = "P" )
IF QTFIL > 0
MDS( 'Calculando Salario Familia' )
DO CASE
CASE BASEINSS <= TETOFAMIL
VALE := QTFIL * SALFAMILIA
IF VALE > 0
dbSelectAr( cSELE2 )
GRAVA2( 70 )
field->HORAS := QTFIL
ENDIF
CASE BASEINSS <= TETOFAMI1
VALE := QTFIL * SALFAMIL1
IF VALE > 0
dbSelectAr( cSELE2 )
GRAVA2( 74 )
field->HORAS := QTFIL
ENDIF
ENDCASE
ENDIF
ENDIF

dbSelectAr( cSELE2 )
dbGoto( REG )
MDS( 'Acumulando Cr‚ditos e D‚bitos' )
WHILE NUMERO = CTR .AND. !Eof()
IF ( CONTA > 119 .AND. CONTA < 150 ) .OR. CONTA = 911 .OR. CONTA = 505
dbSkip()
LOOP
ENDIF
IF CONTA > 501 .OR. ( CONTA > 40 .AND. CONTA < 50 )
DES += VALOR
ENDIF
IF CONTA < 40 .OR. ( CONTA > 50 .AND. CONTA < 397 )
VEN += VALOR
ENDIF
dbSkip()
ENDDO
VALE := DES
dbSelectAr( cSELE2 )
GRAVA2( 999 )

IF ARREDOR # 0
SALDO4 := VALARRE( ARREDOR )
VALE   := SALDO4
dbSelectAr( cSELE2 )
GRAVA2( 398 )
VEN += SALDO4
ENDIF

VALE := VEN
dbSelectAr( cSELE2 )
GRAVA2( 399 )
VALE := VEN - DES
dbSelectAr( cSELE2 )
GRAVA2( 440 )

dbSelectAr( PES )
dbSkip()
ENDDO

dbCloseAll()
IF nFOLTIP = 1
IF NETUSE( FOL )   // AREDE( FOL, FOL, 0 )
FODZER()
dbCloseAll()
ENDIF
ENDIF
RETU


// + EOF: fod2des.prg
// +
