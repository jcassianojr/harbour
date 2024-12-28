// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_a3.prg
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
// :
// :
// :  FOLIS_A3.PRG : Acumular Dados para Rais
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"

CABE2( 'Acumulando Dados Para Rais' )
IF !MDG( 'Deseja Realmente Acumular' )
RETU .F.
ENDIF

xrCODIBGE := OBTER( "FIRMA",, NREMP, "CODIBGE" )

aCTAHOR := Array( 10 )
aCTAFAT := Array( 10 )
AFill( aCTAHOR, 0 )
AFill( aCTAFAT, 1 )
// mCTAHOR01:=mCTAHOR02:=mCTAHOR03:=mCTAHOR04:=mCTAHOR05:=0
// mCTAHOR06:=mCTAHOR07:=mCTAHOR08:=mCTAHOR09:=mCTAHOR10:=0
// mCTAFAT01:=mCTAFAT02:=mCTAFAT03:=mCTAFAT04:=mCTAFAT05:=1
// mCTAFAT06:=mCTAFAT07:=mCTAFAT08:=mCTAFAT09:=mCTAFAT10:=1

CLSCOR()
CLSROW( 8 )
MESINI  := 1
MESFIM  := 12
DATAREF := DXDIA
@ 09, 00 CLEAR
@ 09, 00 SAY "Contas para Horas Trabalhadas"
@ 11, 00 SAY "Fatores"
@ 21, 00 SAY 'Qual o mes inicial'
@ 22, 00 SAY 'Qual o mes final'
@ 23, 00 SAY 'Qual a Data de Referencia'
@ 24, 00 SAY 'Cod Ibge do Municipio'
@ 10, 08 GET aCTAHOR[ 1 ]                      PICT "999"
@ 11, 08 GET aCTAFAT[ 1 ]                      PICT "99.999"
@ 10, 15 GET aCTAHOR[ 2 ]                      PICT "999"
@ 11, 15 GET aCTAFAT[ 2 ]                      PICT "99.999"
@ 10, 22 GET aCTAHOR[ 3 ]                      PICT "999"
@ 11, 22 GET aCTAFAT[ 3 ]                      PICT "99.999"
@ 10, 29 GET aCTAHOR[ 4 ]                      PICT "999"
@ 11, 29 GET aCTAFAT[ 4 ]                      PICT "99.999"
@ 10, 36 GET aCTAHOR[ 5 ]                      PICT "999"
@ 11, 36 GET aCTAFAT[ 5 ]                      PICT "99.999"
@ 10, 43 GET aCTAHOR[ 6 ]                      PICT "999"
@ 11, 43 GET aCTAFAT[ 6 ]                      PICT "99.999"
@ 10, 50 GET aCTAHOR[ 7 ]                      PICT "999"
@ 11, 50 GET aCTAFAT[ 7 ]                      PICT "99.999"
@ 10, 57 GET aCTAHOR[ 8 ]                      PICT "999"
@ 11, 57 GET aCTAFAT[ 8 ]                      PICT "99.999"
@ 10, 64 GET aCTAHOR[ 9 ]                      PICT "999"
@ 11, 64 GET aCTAFAT[ 9 ]                      PICT "99.999"
@ 10, 71 GET aCTAHOR[ 10 ]                     PICT "999"
@ 11, 71 GET aCTAFAT[ 10 ]                     PICT "99.999"
@ 21, 40 GET MESINI                          PICT '##'      RANGE 1, 12
@ 22, 40 GET MESFIM                          PICT '##'      RANGE MESINI, 12
@ 23, 40 GET DATAREF
@ 24, 40 GET xrCODIBGE                       PICT "9999999"
IF !READCUR()
RETU .F.
ENDIF
IF MESINI < 1
ALERTX( "Mes Inicial deve Ser maior que 1" )
RETU .F.
ENDIF
IF MESFIM > 13
ALERTX( "Mes Final deve Ser menor que 13" )
RETU .F.
ENDIF
IF MESFIM < MESINI
ALERTX( "Mes Final menor que o mes inicial" )
RETU .F.
ENDIF


ANOREF := Year( DATAREF )



IF !NETUSE( PES )
RETU
ENDIF
FILTRO := ''
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO
IF File( ZDIRE + "FO_FP13A.DBF" )
IF !NETUSE( "FO_FP13A" )
dbCloseAll()
RETU
ENDIF
ELSE
IF !NETUSE( F13 )  // competencias antigas
dbCloseAll()
RETU .F.
ENDIF
ENDIF
cSELE2 := Alias()


IF !NETUSE( "FORAIS" )
dbCloseAll()
RETU .F.
ENDIF

// IF MESINI=1.AND.MESFIM=12 /nao mais da o zap
// NETZAP("FORAIS") //pois tera as informacoes de vinculo e demissao
// ENDIF


MDS( "Apagando Acumulo Anterior" )
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
mNUMERO   := NUMERO
mNOME     := NOME
mDEMITIDO := DEMITIDO
AVOS      := MES1 := MES2 := 0
// Verificando Avos e Meses Pagamento 13o.Salario
DO CASE
// N„o Demitido Admitido Antes data ref.
CASE Empty( DEMITIDO ) .AND. ANOREF > Year( ADMITIDO )
AVOS := 12
MES1 := 11
MES2 := 12
// N„o Demitido Admitido no Ano
CASE Empty( DEMITIDO ) .AND. ANOREF = Year( ADMITIDO )
AVOS := 12 - Month( ADMITIDO )
IF Day( eom( ADMITIDO ) ) - Day( ADMITIDO ) > 13
AVOS++
ENDIF
MES2 := 12
DO CASE
CASE Month( ADMITIDO ) = 11
dbSelectAr( cSELE2 )
MES1 := IF( VALCTA( mNUMERO, 460 ) > 0, 11, 0 )
dbSelectAr( PES )
CASE Month( ADMITIDO ) = 12
MES1 := 0
OTHERWISE
MES1 := 11
ENDCASE
// Demitido Admitido Antes data ref.
CASE !Empty( DEMITIDO ) .AND. ANOREF > Year( ADMITIDO )
AVOS := Month( DEMITIDO ) - 1
IF Day( DEMITIDO ) > 14
AVOS++
ENDIF
MES2 := Month( DEMITIDO )
IF Month( DEMITIDO ) = 12
dbSelectAr( cSELE2 )
MES1 := IF( VALCTA( mNUMERO, 460 ) > 0, 11, 0 )
dbSelectAr( PES )
ELSE
MES1 := 0
ENDIF
// Admitido e Demitido Ano Referencia
CASE !Empty( DEMITIDO ) .AND. ANOREF = Year( ADMITIDO )
IF Month( ADMITIDO ) # Month( DEMITIDO )
AVOS := Month( ADMITIDO ) - Month( DEMITIDO ) - 1
IF Day( DEMITIDO ) > 14
AVOS++
ENDIF
IF Day( eom( ADMITIDO ) ) - Day( ADMITIDO ) > 13
AVOS++
ENDIF
ELSE
AVOS := IF( Day( ADMITIDO ) - Day( DEMITIDO ) > 14, 1, 0 )
ENDIF
IF Month( DEMITIDO ) = 12
dbSelectAr( cSELE2 )
MES1 := IF( VALCTA( mNUMERO, 460 ) > 0, 11, 0 )
dbSelectAr( PES )
ELSE
MES1 := 0
MES2 := Month( DEMITIDO )
ENDIF
ENDCASE
dbSelectAr( PES )
// Grava os Avos
NETRECLOCK()
FIELD->AVOSM := IF( AVOS > 0 .AND. AVOS < 13, AVOS, 0 )
dbUnlock()

dbSelectAr( "FORAIS" )
dbGoTop()
IF !dbSeek( Str( anouso, 4 ) + Str( mNUMERO, 8 ) )
NETRECAPP()
FIELD->NUMERO := mNUMERO
FIELD->ANO    := ANOUSO
ELSE
NETRECLOCK()
ENDIF
FIELD->NOME    := mNOME
FIELD->IBGECOD := xrCODIBGE
FIELD->MES_1   := MES1
FIELD->MES_2   := MES2
// Zera os Acumulos Mensais
FOR X := MESINI TO MESFIM
MESA         := 'RAIZ' + SubStr( MMES( X ), 1, 3 )
FIELD->&MESA := 0
// Zera Acumulos 13o. Salario Se o acumulo for no mes
IF MES_1 = X
FIELD->SAL13_1 := 0
ENDIF
IF MES_2 = X
FIELD->SAL13_2 := 0
ENDIF
// Zera Aviso
IF !Empty( MDEMITIDO ) .AND. X >= Month( MDEMITIDO )
FIELD->RAIZAVI := 0
FIELD->RAIZMUL := 0
FIELD->RAIZFER := 0
field->RAIZACR := 0
FIELD->RAIZGRA := 0
FIELD->MESACR  := 0
FIELD->MESGRA  := 0

ENDIF
NEXT X
// Zera os Acumulos 13o. Sem Meses de Referencia
IF MES_1 = 0
FIELD->SAL13_1 := 0
ENDIF
IF MES_2 = 0
FIELD->SAL13_2 := 0
ENDIF
dbUnlock()
dbSelectAr( PES )
dbSkip()
ENDDO
dbSelectAr( cSELE2 )
dbCloseArea()

MDS( "Carregando Configura‡„o do Plano de Contas" )
// Preenchendo Matriz com as Contas que acumulam
aCTA01 := {}  // Numero da Conta
aCTA02 := {}  // Descricao da Conta
aCTA03 := {}  // Codigo Para Rais
IF !NETUSE( "CONTAS" )
dbCloseAll()
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
IF RAIZ # 1
AAdd( aCTA01, CODIGO )
AAdd( aCTA02, DESCR )
AAdd( aCTA03, RAIZ )
ENDIF
dbSkip()
ENDDO
dbCloseArea()

// Verifica Configura‡„o
nCTA := Len( aCTA01 )
IF nCTA = 0
MDT( "Nenhuma Conta esta sendo acumulada" )
dbCloseAll()
RETU .F.
ENDIF


IF !NETUSE( "SINDICAT" )
dbCloseAll()
RETU .F.
ENDIF

// Acumulando o Periodo
MDS( "Acumulando Dados" )
FOR X := MESINI TO MESFIM
ARQTRAB := StrZero( X, 2 )
FOT     := IF( NRSEN <> 'DiReT', 'FP' + EMP + ARQTRAB, 'SO' + EMP + ARQTRAB )
INFOR( FOT, "CONTROLE", ZDIRE + FOT, .T. )
CLSROW( 8 )
hb_DispBox( 19, 00, 21, 79, B_DOUBLE )
@ 20, 03 SAY 'MES: ' + MMES( X )
IF !NETUSE( FOT )
RETU
ENDIF
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
mNUMERO    := NUMERO
mSINDICATO := SINDICATO
mCGCSIN    := REPL( "0", 14 )
mCTASIND   := 630
mCTAASSI   := 620
mCTACONF   := 621
mCTAMENS   := 610
mVALSOC1   := 0
mVALSOC2   := 0
mVALSIN    := 0
mVALASS    := 0
mVALCON    := 0
dbSelectAr( "SINDICAT" )
dbGoTop()
IF dbSeek( mSINDICATO )
mCGCSIN  := TIRAOUT( CGC )
mCTAASSI := IF( Empty( CTAASSI ), 620, CTAASSI )
mCTACONF := IF( Empty( CTACONF ), 621, CTACONF )
mCTAMENS := IF( Empty( CTASIND ), 610, CTASIND )
ENDIF
dbSelectAr( PES )
VALMES := VALMES1 := VALMES2 := VALAVI := 0
VALFER := VALGRA := VALACR := VALMUL := 0
VALHOR := 0
PETELA( 8 )
// Procurando Valores
FOR W := 1 TO nCTA
mCONTROLE := ( mNUMERO * 10000 ) + aCTA01[ W ]
dbSelectAr( FOT )
dbGoTop()
IF dbSeek( mCONTROLE )
MDS( aCTA02[ W ] )
// Analisando Codigos de Acumulo
DO CASE
CASE aCTA03[ W ] = 0
VALMES += VALOR
CASE aCTA03[ W ] = 2
VALMES -= VALOR
CASE aCTA03[ W ] = 3
VALMES1 += VALOR
CASE aCTA03[ W ] = 4
VALMES2 += VALOR
CASE aCTA03[ W ] = 5
VALAVI += VALOR
CASE aCTA03[ W ] = 6
VALFER += VALOR
CASE aCTA03[ W ] = 7
VALACR += VALOR
CASE aCTA03[ W ] = 8
VALGRA += VALOR
CASE aCTA03[ W ] = 9
VALMUL += VALOR
ENDCASE
ELSE
MD()
ENDIF
NEXT W
FOR W := 1 TO 10
mCONTROLE := ( mNUMERO * 10000 ) + aCTAHOR[ W ]
dbSelectAr( FOT )
dbGoTop()
IF dbSeek( mCONTROLE )
MDS( aCTAHOR[ W ] )
VALHOR += HORAS * aCTAFAT[ W ]
ELSE
MD()
ENDIF
NEXT W

FOR W := 2 TO 4
DO CASE
CASE W = 1
mCONTROLE := ( mNUMERO * 10000 ) + 0
CASE W = 2
mCONTROLE := ( mNUMERO * 10000 ) + mCTASIND
CASE W = 3
mCONTROLE := ( mNUMERO * 10000 ) + mCTAASSI
CASE W = 4
mCONTROLE := ( mNUMERO * 10000 ) + mCTACONF
ENDCASE
dbSelectAr( FOT )
dbGoTop()
IF dbSeek( mCONTROLE )
// Analisando Codigos de Acumulo
DO CASE
CASE W = 1
IF mVALSOC1 = 0
mVALSOC1 += VALOR
ELSE
mVALSOC1 += VALOR
ENDIF
CASE W = 2
mVALSIN += VALOR
CASE W = 3
mVALASS += VALOR
CASE W = 4
mVALCON += VALOR
ENDCASE
ENDIF
NEXT W
dbSelectAr( "FORAIS" )
dbGoTop()
IF dbSeek( Str( ANOUSO, 4 ) + Str( mNUMERO, 8 ) )
NETRECLOCK()
// Gravando Acumulados
IF VALMES > 0
MESA          := 'RAIZ' + SubStr( MMES( X ), 1, 3 )
FIELD->&MESA. := VALMES
ENDIF
IF VALHOR > 0
MESA          := 'HOR' + SubStr( MMES( X ), 1, 3 )
FIELD->&MESA. := VALHOR
ENDIF
IF VALMES1 > 0
FIELD->SAL13_1 := SAL13_1 + VALMES1
ENDIF
IF VALMES2 > 0
FIELD->SAL13_2 := SAL13_2 + VALMES2
ENDIF
IF VALAVI > 0
FIELD->RAIZAVI := RAIZAVI + VALAVI
ENDIF
IF VALfer > 0
FIELD->RAIZfer := RAIZfer + VALfer
ENDIF
IF VALacr > 0
FIELD->RAIZacr := RAIZacr + VALacr
FIELD->MESACR  := MESACR + 1
ENDIF
IF VALgra > 0
FIELD->RAIZgra := RAIZgra + VALgra
FIELD->MESGRA  := MESGRA + 1
ENDIF
IF VALmul > 0
FIELD->RAIZmul := RAIZmul + VALmul
ENDIF
IF mVALSOC1 > 0
FIELD->VALSOC1 := VALSOC1 + mVALSOC1
FIELD->CGCSOC1 := mCGCSIN
ENDIF
IF mVALSOC2 > 0
FIELD->VALSOC2 := VALSOC2 + mVALSOC2
FIELD->CGCSOC2 := mCGCSIN
ENDIF
IF mVALSIN > 0
FIELD->VALSIN := VALSIN + mVALSIN
FIELD->CGCSIN := mCGCSIN
ENDIF
IF mVALASS > 0
FIELD->VALASS := VALASS + mVALASS
FIELD->CGCASS := mCGCSIN
ENDIF
IF mVALCON > 0
FIELD->VALCON := VALCON + mVALCON
FIELD->CGCCON := mCGCSIN
ENDIF
dbUnlock()
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbSelectAr( FOT )
dbCloseArea()
NEXT X
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
mNUMERO   := NUMERO
mDEMITIDO := DEMITIDO
dbSelectAr( "FORAIS" )
dbGoTop()
IF dbSeek( Str( ANOUSO, 4 ) + Str( mNUMERO, 8 ) )
NETRECLOCK()
IF Empty( mDEMITIDO )
FIELD->RAIZAVI := 0
FIELD->RAIZMUL := 0
FIELD->RAIZFER := 0
field->RAIZACR := 0
FIELD->RAIZGRA := 0
FIELD->MESACR  := 0
FIELD->MESGRA  := 0
ENDIF
IF Empty( SAL13_1 )
FIELD->MES_1 := 0
ENDIF
IF Empty( SAL13_2 )
FIELD->MES_2 := 0
ENDIF
dbUnlock()
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()

// : FIM: FOLIS_A3.PRG

// + EOF: folis_a3.prg
// +
