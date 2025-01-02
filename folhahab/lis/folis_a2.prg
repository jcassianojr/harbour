// +--------------------------------------------------------------------
// +
// +    Programa  : folis_a2.prg Acumulando Salario Variavel 13o. Salario
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"

function folis_a2()
CABE2( 'Acumulando Salario Variavel 13§ Salario' )
IF !MDG( 'Deseja Realmente Acumular' )
RETU
ENDIF

CLSCOR()
CLSROW( 8 )

MESINI  := MESFIM := 0
DOMINGO := 0.000
DXDIA   := Date()
@ 20, 00 SAY 'Qual o mes inicial'
@ 21, 00 SAY 'Qual o mes final'
@ 22, 00 SAY 'Qual a Data de Referencia'
@ 23, 00 SAY "Qual a media de DSR do Periodo"
@ 20, 40 GET MESINI                           PICT '##'    RANGE 1, 12
@ 21, 40 GET MESFIM                           PICT '##'    RANGE MESINI, 12
@ 22, 40 GET DXDIA
@ 23, 40 GET DOMINGO                          PICT "9.999"
IF !READCUR()
RETU .F.
ENDIF

IF !MDG( 'Vocˆ est  acumulando para Complemento de 13§ Sal rio' )
cORI := ZDIRE + "FO_VAR.DBF"
cDES := ZDIRE + "FO_VBR.DBF"
FILEcopy( cORI, CDES )
cORI := ZDIRE + "FO_VAR." + cRDDEXT
cDES := ZDIRE + "FO_VBR." + cRDDEXT
FILEcopy( cORI, CDES )
ENDIF

lAPAGA := MDG( "Apagar Acumulo Anterior" )

IF !NETUSE( PES )
RETU
ENDIF
FILTRO := 'EMPTY(DEMITIDO)'
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO

IF !NETUSE( "CONTAS" )
RETU
ENDIF
FILTRA := 'SAL_13=0'
SET FILTER TO &FILTRA


IF lAPAGA
MDS( "Apagando Acumulo anteriores" )
NETZAP( "FO_VAR" )
ELSE
MDS( "Apagando Acumulo anteriores - Apenas Selecionados" )
IF !NETUSE( "FO_VAR" )
RETU
ENDIF
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
mNUMERO := NUMERO
dbSelectAr( "FO_VAR" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| NUMERO = mNUMERO }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbSelectAr( PES )
dbSkip()
ENDDO
dbSelectAr( FO_VAR )
dbCloseArea()
NETPACK( "FO_VAR" )
ENDIF



IF !NETUSE( "FO_VAR" )
RETU
ENDIF



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
mNUMERO := NUMERO
SALH    := SALM := VAR1 := 0
SALHM()
PETELA( 8 )
dbSelectAr( "CONTAS" )
dbGoTop()
WHILE !Eof()
MESSM      := 'Conta: ' + Str( CODIGO ) + '-' + DESCR
mVAR13S    := SAL_13
mNIV13S    := NIVEL_13
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
DO CASE
CASE mTIPO = 1 .OR. mTIPO = 3
mHORAS := HORAS
CASE mTIPO = 0
mVALOR := IF( mFATMES = 0, VALOR, VALOR * mFATMES )
ENDCASE
dbSelectAr( "FO_VAR" )
dbGoTop()
IF !dbSeek( mCONTROLE )
netrecapp()
FIELD->NUMERO   := mNUMERO
FIELD->CONTA    := mCONTA
FIELD->TIPO     := mTIPO
FIELD->CONTROLE := mCONTROLE
FIELD->VAR13S   := mVAR13S
FIELD->NIV13S   := mNIV13S
ELSE
netreclock()
ENDIF
DO CASE
CASE mTIPO = 1 .OR. mTIPO = 3   // SOMA HORAS
FIELD->HORAS := ( HORAS + mHORAS )
CASE mTIPO = 0  // SOMA VALOR
FIELD->VALOR := ( VALOR + mVALOR )
FIELD->HORAS := 0
CASE mCONTA = 114   // PERICULOSIDADE
FIELD->VALOR := SALM
FIELD->HORAS := 0
ENDCASE
dbUnlock()
ENDIF
dbSelectAr( "CONTAS" )
dbSkip()
ENDDO
dbSelectAr( PES )
dbSkip()
ENDDO
NEXT X
MESES := MESFIM - MESINI + 1
MDS( 'Aguarde Calculando a Media' )
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
NUM      := NUMERO
ANOATUAL := .F.
IF ( Year( ADMITIDO ) = Year( DXDIA ) ) .AND. ( Month( ADMITIDO ) > MESINI )
ANOATUAL := .T.
MESESA   := MESFIM - Month( ADMITIDO )
// *FUNCIONARIOS COM QUINZE DIAS NO MES
// *13 PORQUE DATAS SOMA-SE +1 INVERTIDO PASSA-SE 13
@ 11, 00 SAY ADMITIDO
@ 11, 10 SAY EOM( ADMITIDO )
@ 11, 20 SAY Day( ADMITIDO )
@ 12, 30 SAY Day( EOM( ADMITIDO ) )
IF Day( eom( ADMITIDO ) ) - Day( ADMITIDO ) > 13
MESESA++
ENDIF
ENDIF
dbSelectAr( "FO_VAR" )
dbGoTop()
dbSeek( NUM * 10000 )
WHILE NUMERO = NUM .AND. !Eof()
NETRECLOCK()
IF ANOATUAL
FIELD->HORAS := HORAS / MESESA
FIELD->VALOR := VALOR / MESESA
ELSE
FIELD->HORAS := HORAS / MESES
FIELD->VALOR := VALOR / MESES
ENDIF
dbUnlock()
dbSkip()
ENDDO
dbSelectAr( PES )
dbSkip()
ENDDO

MDS( "Aguarde Atualizando o Variavel" )
dbSelectAr( "FO_VAR" )
dbGoTop()
WHILE !Eof()
VALTOT := VALCTA6 := VALEVAR := VALDSR := SALM := SALH := VAR1 := 0
CTR    := NUMERO
dbSelectAr( PES )
dbGoTop()
IF dbSeek( CTR )
PETELA( 8 )
SALHM()
dbSelectAr( "FO_VAR" )
MDS( "Calculando dados fornecidos " )
WHILE NUMERO = CTR
mCONTA := CONTA
dbSelectAr( "CONTAS" )
dbGoTop()
IF dbSeek( mCONTA )
mTIPO  := TIPO
mFATOR := FATOR
mFIXO  := VALOR
dbSelectAr( "FO_VAR" )
DO CASE
CASE mTIPO = 0
VALEVAR := VALOR
CASE mTIPO = 1
VALEVAR := HORAS * SALH
CASE mTIPO = 2
VALEVAR := mFIXO
CASE mTIPO = 3
VALEVAR := mFIXO * HORAS
CASE mTIPO = 4
VALEVAR := Round( SALM * HORAS / 30, 2 )
CASE mCONTA = 6
VALCTA6 := VALOR
ENDCASE
VALEVAR := IF( mFATOR # 0, VALEVAR * mFATOR, VALEVAR )
netreclock()
FIELD->VALOR := VALEVAR
dbUnlock()
IF ( CONTA > 19 .AND. CONTA < 40 ) .OR. ( CONTA > 9 .AND. CONTA < 17 )
VALDSR += VALOR
ENDIF
ENDIF
VALTOT += IF( mCONTA # 6, VALOR, 0 )
dbSelectAr( "FO_VAR" )
dbSkip()
ENDDO
IF DOMINGO # 0 .AND. VALDSR # 0
VALCTA6 := ( ( VALDSR / ( 30 - DOMINGO ) ) * DOMINGO )
dbSelectAr( "FO_VAR" )
dbGoTop()
IF dbSeek( CTR * 10000 + 6 )
netreclock()
FIELD->VALOR := VALCTA6
dbUnlock()
ENDIF
ENDIF
dbSelectAr( PES )
netreclock()
FIELD->SALVAR13S := VALTOT + VALCTA6
dbUnlock()
ENDIF
dbSelectAr( "FO_VAR" )
WHILE NUMERO = CTR .AND. !Eof()
dbSkip()
ENDDO
ENDDO
dbCloseAll()
RETU


// + EOF: folis_a2.prg
// +
