// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_c3.prg
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

// ****************************************************************************
// :
// :  FORES_C3.PRG : Calculando Rescis„o Contratual
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 25/98/97
// :
// :*****************************************************************************



CABE2( 'Calculando Rescis„o Contratual' )
PARA CC
IF CC = 2
MDT( 'M¢dulo em desenvolvimento Confirme os resultados' )
ENDIF
XA         := XB := XC := XD := XE := XF := CTR := DESCIRRF := 0
QTDEIRRF   := VDEPENDE := DESC_MINIMO := IRRF1 := IRTX1 := IRPA1 := TX := FGTSXX := 0
FGTS13     := DES := VEN := INDEXP := ARREDOR := VALXX := 0
TETOFAMI1  := TETOFAMIL := SALFAMIL1 := SALFAMILIA := INSSDESC := 0
BASEINSD   := 0
IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
IN1        := TX1 := IN2 := TX2 := IN3 := TX3 := IN4 := TX4 := 0
IN5        := TX5 := IN6 := TX6 := IN7 := TX7 := TETOINPS := VALORINSS := 0
TXI1       := TXI2 := TXI3 := TXI4 := TXI5 := TXI6 := TXI7 := TETOINPSI := VALORINSSI := 0
FGTSX13    := TX := TXI := SALMOLD := SALHOLD := 0
ARREIRRF   := DESPIRRF := 'N'
DIASFV     := SALVAP := SALV13 := SALVFP := SALVFV := 0
FFGTS      := VINSL := VPERI := ALMOCO := 0
mFATORIRRF := mFATORIRR2 := 0


MDS( 'Carregando Tabela Assistˆncia M‚dica' )
VAASSMED := PEGVALTAB( "ASSMED" )

MDS( 'Carregando Tabela Assistˆncia Odont¢gica' )
VAASSODO := PEGVALTAB( "ASSODO" )


// MDS('Carregando Tabela Assistˆncia M‚dica')
// BREDE("ASSMED",1)
// DBGOTO(MESTRAB)
// VAASSMED=DESCT
// DBCLOSEALL()

// MDS('Carregando Tabela Assistˆncia Odont¢gica')
// BREDE("ASSODO",1)
// DBGOTO(MESTRAB)
// VAASSODO=DESCT
// DBCLOSEALL()

MDS( 'Carregando Tabela de Refei‡„o' )
IF !NETUSE( "FIRMA" )   // AREDE("FIRMA","FIRMA",0)
RETU
ENDIF
dbGoTop()
IF dbSeek( NREMP )
XSAL   := 'SAL' + SubStr( MMES( MESTRAB ), 1, 3 )
ALMOCO := &XSAL.
ENDIF
dbCloseAll()

// Caso queira Separar o Variavel do Fixo
// 01 - Variavel Ferias Vencidas
// 02 - Variavel Ferias Proporcionais
// 03 - Variavel 13§ Salario
// 04 - Variavel Aviso Previo
aXCON := PEGRELCTA( "XVARRES" )


IF !NETUSE( "PES" )   // AREDE(PES,PES,0)
RETU
ENDIF
MDS( 'Digite o numero do funcionario' )
@ 24, 40 GET CTR PICT '######'
READCUR()
IF !dbSeek( CTR )
MDT( 'Funcion rio n„o encontrado' )
dbCloseAll()
RETU
ENDIF

FGTSC01 := 151
FGTSC02 := 152
FGTSC03 := 153
IF MDG( "Guia GRFP em Separado" )
FGTSC01 := 446
FGTSC02 := 447
FGTSC03 := 448
ENDIF



IF !NETUSE( "FO_RSS" )  // AREDE("FO_RSS","FO_RSS",0)
RETU
ENDIF

IF !NETUSE( "CONTAS" )  // AREDE("CONTAS","CONTAS",0)
RETU
ENDIF
dbGoTop()
IF dbSeek( 426 )
FFGTS := FATOR
ENDIF
dbGoTop()
IF dbSeek( 110 )
VINSL := VALOR
ENDIF
dbGoTop()
IF dbSeek( 114 )
FPERI := FATOR
ENDIF


IF !NETUSE( "FO_FER" )
RETU
ENDIF
FOLA := 'FP' + EMP + StrZero( MES - 1, 2 )
INFOR( FOLA, "CONTROLE", ZDIRE + FOLA, .T. )

IF !NETUSE( "FO_EXP" )
RETU
ENDIF

IF !NETUSE( "FO_VAR" )
RETU
ENDIF

IF !netuse( "SINDICAT" )
RETU
ENDIF



dbSelectAr( PES )
PETELA( 8 )
IF MDG( 'Deseja Arredondar' )
MDS( 'Digite o Arredondamento' )
@ 24, 30 GET ARREDOR
READCUR()
ENDIF

CABEP( SPAC( 17 ) + "Digite os Dados Iniciais Para o C lculo" + SPAC( 20 ) )
SetColor( "+N/GR" )
@ 10, 54 SAY "->MOTIVO   RAIS:"
@ 11, 3  SAY "Admiss„o :"
@ 13, 3  SAY "Aviso    :"
@ 14, 3  SAY "Data da Comunica‡„o Dispensa ou Pedido"
@ 15, 3  SAY "Demitido :"
@ 17, 3  SAY "Motivo para RE FGTS :"
@ 18, 3  SAY "Pago FGTS Rescis„o  :"
@ 19, 3  SAY "Codigo p/ Cad. Adm/dem :"
MDS( "Preencha a Data do Aviso, ou Data do Pedido Demiss„o= AVISO=Data Comunica‡„o" )
// Get nas Menvars
@ 11, 14 GET ADMITIDO
@ 10, 51 GET MOTIVO    VALID VERSEHA( "FO_RCAU",, MOTIVO, "NOME", '"Codigo Nao Cadastrado"' ) .AND. CHECKMOTDEM() // CHECKTAB("RCAU"+MOTIVO +"0  ",24,0,"Motivo n„o Cadastrado")
@ 10, 62 GET RAISDEM   VALID CHECKTAB( "RDEM" + RAISDEM + "   ", 24, 0, "Motivo n„o Cadastrado" )
@ 13, 14 GET AVISOPREV VALID !Empty( AVISOPREV )
@ 15, 14 GET DEMITIDO
@ 17, 25 GET FGTSMOT   VALID CHECKTAB( "FDEM" + PadR( FGTSMOT, 5 ), 24, 0, "Motivo n„o Cadastrado" )
@ 18, 25 GET PGFGTS    VALID PGFGTS $ " SN"                                                                                                                                PICT "!"
@ 19, 28 GET MOTIVODEM PICTURE '99'                                                                                                                                        VALID VERSEHA( "CAGED",, MOTIVODEM, "DESCRICAO", '"Codigo Caged Nao Cadastrado"' )
READCUR()
mPGFGTS := PGFGTS
IF Empty( DEMITIDO )
MDT( 'Falta data de demiss„o' )
dbCloseAll()
RETU
ENDIF
IF CC = 1
ANO := Year( DEMITIDO )
MEF := Month( DEMITIDO )
ELSE
SALH := SALM := VAR1 := 0
SALHM( Month( DEMITIDO ) )
SALMOLD := SALM
SALHOLD := SALH
mDATCOM := Date()
MDS( 'Qual a data do complemento' )
@ 24, 40 GET mDATCOM
READCUR()
ANO := Year( mDATCOM )
MEF := Month( mDATCOM )
ENDIF

ANA := Year( ADMITIDO )
MIR := MEF
MDS( 'Confirme o Mˆs da Tabela de IRRF' )
@ 24, 40 GET MIR
READCUR()
TABINSS( MEF )
TABIRRF( MIR )
QTFIL := FOSFAMQTDE( mNUMERO, "S" )  // qtde salario familia
dbSelectAr( PES )

DIASS := Day( DEMITIDO )
DIASS := DIASS - IF( MEF = Month( ADMITIDO ) .AND. ANA = ANO, Day( ADMITIDO ), 0 )
DIASS := DIASS + IF( DoW( DEMITIDO ) = 6, 2, 0 )
DEP   := FOSFAMQTDE( CTR )

CONTA13 := IF( MOTIVO = '02', 101, 100 )
CONTASS := IF( MOTIVO = '02', 3, 260 )
GOZOAP  := IF( DEMITIDO # AVISOPREV, 29 - ( DEMITIDO - AVISOPREV ), 30 )
MOTIVOX := MOTIVO


MDS( 'Calculando o sal rio Mensal' )
AVOSFV  := VAL4 := SALH := SALM := VAR1 := 0
TIPOSAL := TIPO
SALHM( MEF )
AAVISO  := IF( AVISOPREV = DEMITIDO .AND. MOTIVOX # "04", 1, 0 )
DATAEND := DEMITIDO

lEXP := .F.
IF DEMITIDO - ADMITIDO < 90
MDS( 'Verificando Experiˆncia' )
dbSelectAr( "FO_EXP" )
dbGoTop()
IF dbSeek( CTR )
IF DATAEND <= DATAFIM1
INDEXP := DATAFIM1 - DATAEND
lEXP   := .T.
ENDIF
IF DATAEND > DATAFIM1
IF DATAEND <= DATAFIM2
INDEXP := DATAFIM2 - DATAEND
lEXP   := .T.
ENDIF
ENDIF
IF INDEXP > 0 .OR. DATAEND = DATAFIM1 .OR. DATAEND = DATAFIM2
AAVISO := 0
ENDIF
ELSE
ALERTX( 'Funcionario com menos de 90 sem controle de experiencia' )
ENDIF
dbSelectAr( PES )
ENDIF

MDS( 'Calculando Avos 13§ Sal rio/F‚rias' )
FIM13    := FIMFP := FIMAP := DEMITIDO
CONTINUA := IF( ANA < ANO, .T., .F. )
AVOS13   := IF( CONTINUA, MEF, ( MEF - Month( ADMITIDO ) + IF( Day( ADMITIDO ) < 16, 1, 0 ) ) )
AVOS13   := AVOS13 - IF( Day( DEMITIDO ) < 15, 1, 0 )
AVOSFP   := IF( CONTINUA, 0, AVOS13 )
INIFP    := IF( CONTINUA, Date(), ADMITIDO )
INI13    := IF( CONTINUA, CToD( '01/01/' + StrZero( ANO, 4 ) ), ADMITIDO )
INIAP    := IF( ADMITIDO < DEMITIDO - 364, DEMITIDO - 364, ADMITIDO )
INIFV    := IF( CONTINUA, Date(), CToD( '00/00/00' ) )
FIMFV    := IF( CONTINUA, Date(), CToD( '00/00/00' ) )

IF CONTINUA
dbSelectAr( "FO_FER" )
FILTRA := "NUMERO=CTR.AND.BAIXADO#'S'"
SET FILTER TO &FILTRA
dbGoTop()
WHILE !Eof()
IF DATFERIAS > DATAEND
EXIT
ENDIF
ANOFER := Year( DATFERIASF )
MESFER := Month( DATFERIASF )
IF ANOFER < ANO
AVOSFV := 12
DIASFV := DIASGOZA3
ENDIF
IF ANOFER = ANO
IF MEF < MESFER
AVOSFP := 12 - MESFER
AVOSFP += MEF
ENDIF
IF MEF = MESFER
AVOSFV := 12
DIASFV := DIASGOZA3
ENDIF
IF MEF > MESFER
AVOSFV := 12
DIASFV := DIASGOZA3
AVOSFP := MEF - MESFER
ENDIF
IF Day( DATFERIASF ) < 16
AVOSFP++
ENDIF
ENDIF
IF AVOSFP > 12
AVOSFV := 12
DIASFV := DIASGOZA3
AVOSFP -= 12
ENDIF
IF AVOSFV = 12
INIFV := DATFERIAS
FIMFV := DATFERIASF
ELSE
INIFP := DATFERIAS
FIMFP := DATFERIASF
ENDIF
dbSelectAr( "FO_FER" )
dbSkip()
ENDDO
ENDIF

AVOS13 += AAVISO
AVOSFP += AAVISO
DIASS  := IF( TIPOSAL = '5' .OR. TIPO = "H", DIASS * 7.3333, DIASS )

dbSelectAr( "FO_RSS" )
AVOSFV := IF( VALCTA( CTR, 90 ) > 0, HORAS, AVOSFV )
AVOSFP := IF( VALCTA( CTR, 91 ) > 0, HORAS, AVOSFP )
AVOS13 := IF( VALCTA( CTR, 100 ) > 0, HORAS, AVOS13 )
AVOS13 := IF( VALCTA( CTR, 101 ) > 0, HORAS, AVOS13 )
DIASS  := IF( VALCTA( CTR, 3 ) > 0, HORAS, DIASS )
DIASS  := IF( VALCTA( CTR, 260 ) > 0, HORAS, DIASS )



ACU13 := ACUFP := ACUFV := ACUAP := 'N'
RESTELA( SPAC( 19 ) + "Confirme os Avos e Saldo de Sal rio" + SPAC( 22 ) )
@ 10, 51 GET DIASS  PICT "999.99"
@ 11, 49 GET AVOS13 PICT "99"
@ 11, 70 GET ACU13
@ 12, 49 GET INI13
@ 12, 60 GET FIM13
@ 14, 49 GET AVOSFP PICT "99"
@ 14, 70 GET ACUFP
@ 15, 49 GET INIFP
@ 15, 60 GET FIMFP
@ 17, 49 GET AVOSFV PICT "99"
@ 17, 52 GET DIASFV PICT "99.99"
@ 17, 73 GET ACUFV
@ 18, 49 GET INIFV
@ 18, 60 GET FIMFV
@ 20, 70 GET ACUAP
@ 21, 49 GET INIAP
@ 21, 60 GET FIMAP
READCUR()

SetColor( "W/N,N/W" )
@ 08, 00 CLEA
PETELA( 8 )

MDS( 'Aguarde Acumula‡„o dos Dados' )
IF ACU13 = 'S'
FORES_CX()
GRAVA4( 456, SALV13 )
ELSE
dbSelectAr( "FO_RSS" )
SALV13 := VALCTA( CTR, 456 )
ENDIF

IF ACUFP = 'S'
SALVFP := FORES_CY( INIFP, FIMFP, 'FERIAS=0', 'Ferias Proporcionais' )
ELSE
dbSelectAr( "FO_RSS" )
SALVFP := VALCTA( CTR, 457 )
ENDIF

IF ACUFV = 'S'
SALVFV := FORES_CY( INIFV, FIMFV, 'FERIAS=0', 'Ferias Vencidas' )
ELSE
dbSelectAr( "FO_RSS" )
SALVFV := VALCTA( CTR, 458 )
ENDIF

IF ACUAP = 'S'
SALVAP := FORES_CY( INIAP, FIMAP, 'DEMISSAO=0', 'Aviso Previo' )
ELSE
dbSelectAr( "FO_RSS" )
SALVAP := VALCTA( CTR, 455 )
ENDIF

IF !NETUSE( FOLA )  // AREDE(FOLA,FOLA,0)
RETU
ENDIF

IF !NETUSE( FOL )   // AREDE(FOL,FOL,0)
RETU
ENDIF

RESTELA( SPAC( 18 ) + "Confirme os Valores Sal rio Vari vel" + SPAC( 22 ) )
@ 13, 49 GET SALV13 PICT '###,###,###.##'
@ 16, 49 GET SALVFP PICT '###,###,###.##'
@ 19, 49 GET SALVFV PICT '###,###,###.##'
@ 22, 49 GET SALVAP PICT '###,###,###.##'
READCUR()

dbSelectAr( "FO_RSS" )
GRAVA4( 456, SALV13 )
GRAVA4( 457, SALVFP )
GRAVA4( 458, SALVFV )
GRAVA4( 455, SALVAP )

dbSelectAr( PES )
SetColor( "W/N,N/W" )
@ 08, 00 CLEA
PETELA( 8 )
IF MOTIVOX = '04'
IF MDG( 'Deseja descontar Aviso previo' )
IF MDG( "Incluir 1/12 avos no 13o.SAL referente ao aviso" )
AVOS13++
ENDIF
IF MDG( "Incluir 1/12 avos em f‚rias referente ao aviso" )
AVOSFP++
ENDIF
GRAVA4( 901, SALM * GOZOAP / 30 )
ENDIF
IF lEXP
IF MDG( 'Deseja descontar indeniza‡„o de experiˆncia' )
GRAVA4( 905, SALM * INDEXP / 2 )
ENDIF
ENDIF
ENDIF
GRAVA4( 413, CALCDEPE(), 0 )


IF AAVISO = 1 .AND. MOTIVOX = '02'
MDS( 'Calculando Aviso Previo' )
IF aXCON[ 4 ] > 0
GRAVA4( 107, SALM )
GRAVA4( aXCON[ 4 ], SALVAP )
ELSE
GRAVA4( 107, SALM + SALVAP )
ENDIF
ENDIF

IF MOTIVOX = '02' .AND. lEXP .AND. INDEXP > 0
MDS( 'Calculando indeniza‡„o de experiencia' )
GRAVA4( 109, SALM * INDEXP / 60 )
ENDIF


MDS( 'Calculando Saldo de Salario' )
IF DIASS > 0
IF CC = 1
VALE := IF( TIPOSAL = '1' .OR. TIPO = "M", SALM * DIASS / 30, SALH * DIASS )
GRAVA4( CONTASS, VALE, DIASS )
ELSE
VALE  := VALCTA( CTR, CONTASS )
VALE2 := IF( TIPOSAL = '1' .OR. TIPO = "M", ( SALM - SALMOLD ) * DIASS / 30, ( SALH - SALHOLD ) * DIASS )
GRAVA4( CONTASS, VALE + VALE2 )
ENDIF
ELSE
IF CC = 1
GRAVA4( CONTASS, 0, 0 )
ENDIF
ENDIF

dbSelectAr( PES )
IF PERICULO = 'S'
MDS( 'Creditando Periculosidade' )
VALE := ( IF( TIPOSAL = '1' .OR. TIPO = "M", SALM * DIASS / 30, VAR1 * DIASS ) ) * FPERI
GRAVA4( 114, VALE )
dbSelectAr( PES )
ENDIF

IF INSALUBRI = 'S'
MDS( 'Creditando Insalubridade' )
VALE := IF( TIPOSAL = '1' .OR. TIPO = "M", VINSL * DIASS / 30, VINSL * DIASS / 220 )
GRAVA4( 110, VALE )
dbSelectAr( PES )
ENDIF

IF ASSM = 'S' .AND. CC = 1
MDS( 'Descontando Assistencia M‚dica' )
GRAVA4( 615, PEGVALTIP( ASSM, VAASSMED ) )
dbSelectAr( PES )
ENDIF

IF ASSO = 'S' .AND. CC = 1
MDS( 'Descontando Assistencia Odontologica' )
GRAVA4( 616, PEGVALTIP( ASSO, VAASSODO ) )
dbSelectAr( PES )
ENDIF

SINDLOGI := .F.
CONTASS  := .F.
MDS( 'Verificando Sindicato do Funcion rio' )
BUSCA := SINDICATO
dbSelectAr( "SINDICAT" )
IF dbSeek( BUSCA )
XSAL     := 'SAL' + SubStr( MMES( MEF ), 1, 3 )
VALESIND := &XSAL.
VALTAXA  := ( TAXAASS / 100 )
VALTETO  := TETOASS
SINDLOGI := .T.
IF Month( DATASS1 ) = MES .OR. Month( DATASS2 ) = MES
CONTASS := .T.
ENDIF
ELSE
VALTAXA := VALTETO := VALESIND := 0
ENDIF
dbSelectAr( PES )
IF SINDLOGI
IF SOCIOSIND = 'S'
MDS( 'Descontando Mensalidade do Sindicato' )
GRAVA4( 610, VALESIND )
dbSelectAr( PES )
ENDIF
IF CONTASS
MDS( 'Descontando Contribui‡„o Assistencial' )
VALE := SALM * VALTAXA
GRAVA4( 620, IF( VALE > VALTETO, VALTETO, VALE ) )
dbSelectAr( PES )
ENDIF
ENDIF
IF MES > 2
IF Empty( DATCONTSIN ) .OR. ( Month( DATCONTSIN ) = MES )
MDS( 'Descontando Contribui‡„o Sindical' )
netreclock()
FIELD->DATCONTSIN := DXDIA
dbUnlock()
VALE := SALM / 30
dbSelectAr( "FO_RSS" )
VALE += VALCTA( CTR, 435 )   // CTA 435 VARIAVEL SINDICAL INDICADO
GRAVA4( 630, VALE )
dbSelectAr( PES )
ENDIF
ENDIF

IF CC = 1
dbSelectAr( "FO_RSS" )
VALE := VALCTA( CTR, 520 )
IF HORAS > 0
MDS( 'Calculando AlmoCo' )
netreclock()
FIELD->VALOR := HORAS * ALMOCO
dbUnlock()
ENDIF
ENDIF


BASEIR := 0
IF AVOSFV # 0
MDS( 'Calculando F‚rias Vencidas' )
nVAL1  := Round( SALM * AVOSFV * DIASFV / 360, 2 )  // 12meses*30dias Salario
nVAL2  := Round( SALVFV * AVOSFV * DIASFV / 360, 2 )  // 12meses*30dias Variavel
BASEIR := nVAL1 + nVAL2
IF aXCON[ 1 ] > 0
GRAVA4( 90, nVAL1, AVOSFV )
GRAVA4( aXCON[ 1 ], nVAL2, AVOSFV )
ELSE
GRAVA4( 90, nVAL1 + nVAL2, AVOSFV )
ENDIF
VALE := ( nVAL1 + nVAL2 ) / 3
GRAVA4( 92, VALE )
BASEIR += VALE
ELSE
GRAVA4( 90, 0, 0 )
GRAVA4( 92, 0, 0 )
IF aXCON[ 1 ] > 0
GRAVA4( aXCON[ 1 ], 0, 0 )
ENDIF
ENDIF

IF AVOSFP # 0
MDS( 'Calculando F‚rias Proporcionais' )
nVAL1  := Round( AVOSFP * SALM / 12, 2 )
nVAL2  := Round( AVOSFP * SALVFP / 12, 2 )
BASEIR := BASEIR + nVAL1 + nVAL2
IF aXCON[ 2 ] > 0
GRAVA4( 91, nVAL1, AVOSFP )
GRAVA4( aXCON[ 2 ], nVAL2, AVOSFP )
ELSE
GRAVA4( 91, nVAL1 + nVAL2, AVOSFP )
ENDIF
VALE   := ( nVAL1 + nVAL2 ) / 3
BASEIR += VALE
GRAVA4( 93, VALE )
ELSE
GRAVA4( 91, 0, 0 )
GRAVA4( 93, 0, 0 )
IF aXCON[ 2 ] > 0
GRAVA4( aXCON[ 2 ], 0, 0 )
ENDIF
ENDIF

IF AVOSFV # 0 .OR. AVOSFP # 0
MDS( 'Calculando IRRF Sobre F‚rias.' )
dbSelectAr( "FO_RSS" )
PENSAO := VALCTA( CTR, 513 )
VALE   := 0
CALCDEPE()
VALDESCIR := CALCIRRF( BASEIR - VAL4 - PENSAO )
GRAVA5( 502, VALDESCIR )
GRAVA5( 404, BASEIR )
GRAVA5( 424, VALDESCIR )
GRAVA5( 423, VAL4 + PENSAO )
ENDIF

IF MEF = 12 .OR. MEF = 11
IF File( ZDIRE + "FO_FP13A.DBF" )
IF !NETUSE( "FO_FP13A" )  // AREDE("FO_FP13A","FO_FP13A",0)
RETU
ENDIF
// Pega o Fgts Creditado 13a.
FGTSXX := VALCTA( CTR, 465 )
PAGO13 := VALCTA( CTR, 460 )
dbCloseArea()
IF !NETUSE( "FO_FP13B" )  // AREDE("FO_FP13B","FO_FP13B",0)
RETU
ENDIF
FGTSXX += VALCTA( CTR, 469 )
PAGO13 += VALCTA( CTR, 461 )
dbCloseArea()

GRAVA4( 914, PAGO13 )
ELSE
IF !NETUSE( "FO_FP13" )   // AREDE("FO_FP13","FO_FP13",0)
RETU
ENDIF
// Pega o Fgts Creditado 13a.
FGTSXX := VALCTA( CTR, 465 )
FGTSXX += VALCTA( CTR, 469 )
PAGO13 := VALCTA( CTR, 460 )
PAGO13 += VALCTA( CTR, 461 )
dbCloseArea()

GRAVA4( 914, PAGO13 )
ENDIF
ENDIF

// Verifica se  recebeu 1a.Parcela 13o. Sal rio nas F‚rias
VAL131P := 0
IF CC = 1
// DBSELECTAR("SINDICAT")
IF !NETUSE( "FO_OCO" )   // BREDE("FO_OCO",0)
RETU
ENDIF
dbGoTop()
LOCATE FOR NUMERO = CTR .AND. CODIGO = "1P" .AND. Year( DATASAIDA ) = ANO
IF Found()
IF Empty( VALPG )
VAL131P := SALM / 2
ELSE
VAL131P := VALPG
ENDIF
ENDIF
dbCloseArea()

IF VAL131P > 0
GRAVA4( 902, VAL131P )
ENDIF
ENDIF
IF AVOS13 # 0
MDS( 'Calculando o 13§ Sal rio' )
dbSelectAr( "FO_RSS" )
PENSAO := VALCTA( CTR, 512 )
nVAL1  := Round( AVOS13 * SALM / 12, 2 )
nVAL2  := Round( AVOS13 * SALV13 / 12, 2 )
BASEIN := nVAL1 + nVAL2
FGTS13 := nVAL1 + nVAL2
IF aXCON[ 3 ] > 0
GRAVA4( CONTA13, nVAL1, AVOS13 )
GRAVA4( aXCON[ 3 ], nVAL2, AVOS13 )
ELSE
GRAVA4( CONTA13, nVAL1 + nVAL2, AVOS13 )
ENDIF
GRAVA4( 434, nVAL1 + nVAL2 )
GRAVA4( 450, nVAL1 + nVAL2 )
MDS( 'Calculando IAPAS sobre o 13§ Sal rio' )
DESX := CALCINSS( BASEIN )
GRAVA4( 518, DESX )
MDS( 'Calculando IRRF sobre o 13§ Sal rio' )
VALE := 0
CALCDEPE()
VALDESCIR := CALCIRRF( BASEIN - VALORINSSI - VAL4 - PENSAO )
GRAVA5( 522, VALDESCIR )
GRAVA5( 406, BASEIN )
GRAVA5( 414, VAL4 )
FGTSX13 := Round( FGTS13 * FFGTS, 2 )
GRAVA4( 438, FGTSX13 )
ELSE
GRAVA4( CONTA13, 0, 0 )
GRAVA4( 450, 0, 0 )
IF aXCON[ 3 ]
GRAVA4( aXCON[ 3 ], 0, 0 )
ENDIF
ENDIF

MDS( 'Acumulando Bases de Calculos' )
BASEIR := BASEIN := BASEFG := 0
dbSelectAr( "FO_RSS" )
FILTRO := 'NUMERO=CTR'
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
IF CONTA = 399 .OR. CONTA = 70 .OR. CONTA = 74 .OR. CONTA = 999 .OR. CONTA = 900
FO_RSS->VALOR := 0
FO_RSS->HORAS := 0
ELSE
BASEIR += IF( TRIBUTIRR = 0, VALOR, 0 )
BASEIN += IF( TRIBUTINPS = 0, VALOR, 0 )
BASEFG += IF( TRIB_FGTS = 0, VALOR, 0 )
BASEIR -= IF( TRIBUTIRR = 2, VALOR, 0 )
BASEIN -= IF( TRIBUTINPS = 2, VALOR, 0 )
BASEFG -= IF( TRIB_FGTS = 2, VALOR, 0 )
ENDIF
IF CC = 1
FO_RSS->MES1 := MEF
ENDIF
IF CC = 2
FO_RSS->MES2 := MEF
ENDIF
dbSkip()
ENDDO
dbSelectAr( "FO_RSS" )
SET FILTER TO

IF BASEFG = 0
IF MDG( 'Saldo de Sal rio J  pagos em Folha de pagamento' )
dbSelectAr( FOL )
BASEFG := VALCTA( CTR, 425 )
ENDIF
ENDIF
BASEFG += IF( MEF > 10, FGTSXX, 0 )   // FGTS13-IF(MEF>10,FGTSXX,0)

MDS( 'Calculando FGTS' )
GRAVA4( 426, ( BASEFG * FFGTS ) - FGTSX13 )
GRAVA4( 425, BASEFG )



MDS( 'Calculando IAPAS' )
BASEINSD := BASEIN - INSSDESC
IF BASEINSD < 0
BASEINSD := 0
ENDIF
VALORINSS := CALCINSS( BASEINSD )
GRAVA4( 509, VALORINSS )
GRAVA4( 422, BASEIN )
GRAVA4( 485, BASEINSD )



MDS( 'Calculando IRRF' )
dbSelectAr( "FO_RSS" )
PENSAO := VALCTA( CTR, 515 )
BASEIR := BASEIR
GRAVA5( 405, BASEIR )
BASEIR -= VALORINSSI
IF RECOIRRF # 'S'
dbSelectAr( FOL )
VALXX  := VALCTA( CTR, 493 )
VALE   := VALCTA( CTR, 41 ) + VALCTA( CTR, 997 )
BASEIR += VALCTA( CTR, 402 )
IF VALE = 0
DESCIRRF := VALCTA( CTR, 492 )
ELSE
DESCIRRF := VALCTA( CTR, 494 )
GRAVA4( 898, VALE )
ENDIF
dbSelectAr( "FO_RSS" )
ELSE
dbSelectAr( FOL )
VALE := VALCTA( CTR, 41 ) + VALCTA( CTR, 997 )
IF VALE > 0
GRAVA4( 898, VALE )
ENDIF
dbSelectAr( "FO_RSS" )
ENDIF
VALE := 0
CALCDEPE()
VALDESCIR := CALCIRRF( BASEIR - VAL4 - VALXX - PENSAO )
VALDESCIR -= DESCIRRF
VALDESCIR := IF( VALDESCIR > 0, VALDESCIR, 0 )
GRAVA5( 504, VALDESCIR )

IF QTFIL # 0 .AND. CC = 1
MDS( 'Calculando Sal rio Fam¡lia' )
GRAVA4( 491, QTFIL )
DO CASE
CASE BASEIN <= TETOFAMIL
VALE := IF( TIPOSAL = "5" .OR. TIPO = "H", QTFIL * SALFAMILIA * DIASS / 220, QTFIL * SALFAMILIA * DIASS / 30 )
IF VALE > 0
GRAVA4( 70, VALE, QTFIL )
ENDIF
CASE BASEIN <= TETOFAMI1
VALE := IF( TIPOSAL = "5" .OR. TIPO = "H", QTFIL * SALFAMIL1 * DIASS / 220, QTFIL * SALFAMIL1 * DIASS / 30 )
IF VALE > 0
GRAVA4( 74, VALE, QTFIL )
ENDIF
ENDCASE
ENDIF

IF MOTIVOX = '02'
VALE1 := BASEFG * .08
GRAVA4( FGTSC02, VALE1 )
dbSelectAr( FOLA )
VALE2 := VALCTA( CTR, 426 )
IF VALE2 # 0
GRAVA4( IF( mPGFGTS = "S", 459, FGTSC01 ), VALE2 )
ENDIF
GRAVA4( FGTSC03, ( VALE1 + VALE2 ) * .4 )
ENDIF

dbSelectAr( FOLA )
VALE := VALCTA( CTR, 398 )
GRAVA4( 998, VALE )


MDS( 'Acumulando Vencimentos/Descontos' )
mVALADIC := 0.00
dbSelectAr( "FO_RSS" )
FILTRO := 'NUMERO=CTR'
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
netreclock()
IF TIPO = 1 .OR. TIPO = 3
FIELD->VALOR := HORAS * SALH * FATOR
ENDIF
IF TIPO = 4
FIELD->VALOR := Round( HORAS * SALM / 30, 2 )
ENDIF
IF TIPO = 1 .OR. TIPO = 3 .OR. TIPO = 4
IF CC = 1
FO_RSS->MES1      := MEF
FO_RSS->VALORMES1 := VALOR
FO_RSS->VALORMES2 := 0
ELSE
IF VALOR - VALORMES1 > 0
FO_RSS->MES2      := MEF
FO_RSS->VALORMES2 := VALOR - VALORMES1
ENDIF
ENDIF
ENDIF
IF CC = 2
IF VALOR = VALORMES1 .AND. VALOR = VALORMES2
FIELD->VALORMES2 := 0.00
ENDIF
ENDIF
IF CC = 2 .AND. CONTA = 152
mVALDIC := VALORMES2
ENDIF
IF CC = 2 .AND. CONTA = 153
FIELD->VALORMES2 := Round( mVALADIC * .4, 2 )
ENDIF
DES += IF( CONTA > 501, IF( CC = 1, VALOR, VALORMES2 ), 0 )
VEN += IF( CONTA < 399, IF( CC = 1, VALOR, VALORMES2 ), 0 )
dbUnlock()
dbSkip()
ENDDO
dbSelectAr( "FO_RSS" )
SET FILTER TO


IF ARREDOR <> 0
MDS( 'Arredondando o pagamento' )
IF VEN > DES
SALDO  := VEN - DES
SALDO1 := Int( SALDO / ARREDOR )
SALDO2 := SALDO1 * ARREDOR
SALDO3 := SALDO2 + ARREDOR
SALDO4 := SALDO3 - SALDO
ELSE
SALDO4 := DES - VEN
ENDIF
SALDO4 := IF( SALDO4 = ARREDOR, 0, SALDO4 )
GRAVA4( 398, SALDO4 )
VEN += SALDO4
ENDIF
GRAVA6( 399, VEN )
GRAVA6( 999, VEN )
GRAVA6( 900, VEN - DES )
dbSelectAr( "FO_RSS" )
FODZER()
dbCloseAll()
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: GRAVA4()
// !
// !    Chamado por: FORES_C3.PRG
// !
// !          Chama: GRAVA2()           (fun‡„o    em FORESP.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC GRAVA4

   PARA XXX1, XXX2, XXX3

   dbSelectAr( "FO_RSS" )
   GRAVA2( XXX1, XXX2 )
   IF CC = 1
      FO_RSS->MES1      := MEF
      FO_RSS->VALORMES1 := XXX2
      FO_RSS->VALORMES2 := 0
   ELSE
      IF VALOR - VALORMES1 > 0
         FO_RSS->MES2      := MEF
         FO_RSS->VALORMES2 := VALOR - VALORMES1
      ENDIF
   ENDIF
   IF ValType( XXX3 ) = "N"
      FO_RSS->HORAS := XXX3
   ENDIF
   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: GRAVA5()
// !
// !    Chamado por: FORES_C3.PRG
// !
// !          Chama: GRAVA2()           (fun‡„o    em FORESP.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRAVA5

   PARA XXX1, XXX2

   dbSelectAr( "FO_RSS" )
   GRAVA2( XXX1, XXX2 )
   IF CC = 1
      FO_RSS->MES1      := MIR
      FO_RSS->VALORMES1 := XXX2
      FO_RSS->VALORMES2 := 0
   ELSE
      IF VALOR - VALORMES1 > 0
         FO_RSS->MES2      := MIR
         FO_RSS->VALORMES2 := VALOR - VALORMES1
      ENDIF
   ENDIF
   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: GRAVA6()
// !
// !    Chamado por: FORES_C3.PRG
// !
// !          Chama: GRAVA2()           (fun‡„o    em FORESP.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRAVA6

   PARA XXX1, XXX2

   dbSelectAr( "FO_RSS" )
   GRAVA2( XXX1, XXX2 )
   IF CC = 1
      FO_RSS->MES1      := MEF
      FO_RSS->VALORMES1 := XXX2
      FO_RSS->VALORMES2 := 0
   ELSE
      FO_RSS->MES2      := MEF
      FO_RSS->VALORMES2 := XXX2
   ENDIF
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: RESTELA()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RESTELA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC RESTELA

   PARA TITULO

   CABEP( TITULO )
   dbSelectAr( PES )
   SetColor( "+N/GR" )
   @ 10, 3  SAY "Admiss„o :" + SPAC( 22 ) + "Saldo Sal rio :"
   @ 11, 35 SAY "13§ Sal rio :        Acumula (S/N)"
   @ 12, 3  SAY "Aviso    :" + SPAC( 26 ) + "Per¡odo :" + SPAC( 10 ) + "…"
   @ 13, 39 SAY "Valor   :"
   @ 14, 3  SAY "Demitido :" + SPAC( 22 ) + "F.Proporcio :        Acumula (S/N)"
   @ 15, 39 SAY "Per¡odo :" + SPAC( 10 ) + "…"
   @ 16, 3  SAY "Motivo para RE FGTS :" + SPAC( 15 ) + "Valor   :"
   @ 17, 35 SAY "F.Vencidas  :  /        Acumula (S/N)"
   @ 18, 3  SAY "Codigo Cad. Adm/dem :" + SPAC( 15 ) + "Per¡odo :" + SPAC( 10 ) + "…"
   @ 19, 39 SAY "Valor   :"
   @ 20, 3  SAY "Causa:" + SPAC( 26 ) + "Aviso Previo:        Acumula (S/N)"
   @ 21, 39 SAY "Per¡odo :" + SPAC( 10 ) + "…"
   @ 22, 39 SAY "Valor   :"
   @ 10, 14 SAY ADMITIDO
   @ 12, 14 SAY AVISOPREV
   @ 14, 14 SAY DEMITIDO
   @ 16, 25 SAY FGTSMOT
   @ 18, 25 SAY MOTIVODEM
   @ 20, 10 SAY MOTIVO
   @ 21, 3  SAY OBTER( "FO_RCAU",, MOTIVO, "NOME" ) // CHECKTAB("RCAU"+MOTIVO +"0  ",,,"Motivo n„o Cadastrado",2)
   @ 10, 51 SAY DIASS                                                                                        PICT "999.99"
   @ 11, 49 SAY AVOS13                                                                                       PICT "99"
   @ 11, 70 SAY ACU13
   @ 12, 49 SAY INI13
   @ 12, 60 SAY FIM13
   @ 13, 49 SAY SALV13                                                                                       PICT '###,###,###.##'
   @ 14, 49 SAY AVOSFP                                                                                       PICT "99"
   @ 14, 70 SAY ACUFP
   @ 15, 49 SAY INIFP
   @ 15, 60 SAY FIMFP
   @ 16, 49 SAY SALVFP                                                                                       PICT '###,###,###.##'
   @ 17, 49 SAY AVOSFV                                                                                       PICT "99"
   @ 17, 52 SAY DIASFV                                                                                       PICT "99.99"
   @ 17, 73 SAY ACUFV
   @ 18, 49 SAY INIFV
   @ 18, 60 SAY FIMFV
   @ 19, 49 SAY SALVFV                                                                                       PICT '###,###,###.##'
   @ 20, 70 SAY ACUAP
   @ 21, 49 SAY INIAP
   @ 21, 60 SAY FIMAP
   @ 22, 49 SAY SALVAP                                                                                       PICT '###,###,###.##'
   RETU ( .T. )
// : FIM: FORES_C3.PRG

// + EOF: fores_c3.prg
// +
