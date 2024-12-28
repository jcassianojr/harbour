// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aycrm.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_AYCRM.PRG
// +
// +    Reformatted by Click! 2.03 on Jul-2-2002 at  5:10 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

PRIV mFORNECEDO := 0
PRIV xCODIGO
PRIV yCODIGO
PRIV xTIPO1
PRIV xTIPO2
PRIV mTIPOENT
PRIV mNRNOTA
PRIV mOLDQTDDE
dDATA   := ZDATA
ARQWORK := "MY01"

MDS( "Digite a data da Entrega" )
@ 24, 40 GET dDATA
IF !READCUR()
RETU .F.
ENDIF
CRIARVARS( "MY01" )
IF !USEMULT( { { "CRM", 1, 2 }, { "MY01", 1, 99 } } )
dbCloseAll()
RETU .F.
ENDIF
dbSelectAr( "CRM" )
nLASTREC := LastRec()
nPOSREC  := 1
dbGoTop()
// dbseek( dDATA ) //Tem que ser pela data entrega
WHILE !Eof()  // dDATA = DATA .and. !eof()
IF TIPOE = "C" .OR. TIPOE = "M"
lGRAVOU := .F.
FOR X := 1 TO 2
dbSelectAr( "CRM" )
IF !Empty( if( X = 1, NRNOTA, NRNOTB ) ) .AND. dDATA = if( X = 1, ENTREGA, ENTREG2 )
mCODIGO  := PadR( CBUSCA, 24 )
mNRNOTA  := if( X = 1, NRNOTA, NRNOTB )
mDATA    := DATA
mQTDE    := if( X = 1, QTDEA, QTDEB )
mCRM     := CRM
xCRM     := CRM
mOS      := CRM
mTIPO1   := "E"
mTIPO2   := TIPOE
mNUMMB01 := CLIFOR
mUNID    := UNID
mDISTRI  := "S"
IF mQTDE > 0
DO CASE
CASE CRM->GRAVOUY = "S"
ALERTX( "Crm: " + Str( xCRM ) + " J  Gravado" )
CASE Empty( mCODIGO )
ALERTX( "Crm: " + Str( xCRM ) + " sem Codigo Produto" )
CASE Empty( mNRNOTA )
ALERTX( "Crm: " + Str( xCRM ) + " sem numero nota entrada" )
CASE Empty( mDATA )
ALERTX( "Crm: " + Str( xCRM ) + " sem data" )
CASE Empty( mQTDE )
ALERTX( "Crm: " + Str( xCRM ) + " sem quantidade" )
OTHERWISE
xCODIGO  := mCODIGO
yCODIGO  := mCODIGO
xTIPO1   := mTIPO1
xTIPO2   := mTIPO2
mTIPOENT := mTIPO2
mTIPO3   := "CRM"
lGRAVOU  := .T.
INCLUI   := .T.
dbSelectAr( "MY01" )
dbGoBottom()
mNUMERO := NUMERO + 1
NOVOOPA( "MY01" )
MAK2K05( "I", "MY01E" )
ENDCASE
ENDIF
ENDIF
NEXT X
IF lGRAVOU
dbSelectAr( "CRM" )
GRAVACAMPO( "GRAVOUY", "'S'" )
ENDIF
ENDIF
dbSelectAr( "CRM" )
ZEI_FORT( nLASTREC,, nPOSREC )
dbSkip()
nPOSREC++
ENDDO
dbCloseAll()

// + EOF: M_AYCRM.PRG

// + EOF: m_aycrm.prg
// +
