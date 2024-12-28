// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aocrm.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_AOCRM.PRG
// +
// +    Reformatted by Click! 2.03 on Jul-5-2002 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

dDATA := ZDATA
MDS( "Qual Data" )
@ 24, 40 GET dDATA
IF !READCUR()
RETU .F.
ENDIF
CRIARVARS( "PE01BX" )

IF !USEREDE( "CRM", 1, 2 )
dbCloseAll()
RETU .F.
ENDIF
dbSelectAr( "CRM" )
dbGoTop()
dbSeek( dDATA )
WHILE dDATA = DATA .AND. !Eof()
IF TIPOE = "M" .OR. TIPOE = "C"
lGRAVOU := .F.
FOR X := 1 TO 2
xTIPOE     := TIPOE
xCODIGO    := PadR( CBUSCA, 24 )
xNRNOTASAI := if( X = 1, MNRNOTA, NRNOTB )
xDATASAI   := DATA
xTOTKGSAI  := if( X = 1, QTDEA, QTDEB )
xCRM       := CRM
xPEDIDO    := PRPED
xITEM      := PRITE
xCLIFOR    := CLIFOR
DO CASE
CASE CRM->GRAVAUP = "S"
ALERTX( "Crm: " + Str( xCRM ) + " Ja Gravado" )
CASE Empty( xCODIGO )
ALERTX( "Crm: " + Str( xCRM ) + " sem Codigo Produto" )
CASE Empty( xDATASAI )
ALERTX( "Crm: " + Str( xCRM ) + " sem data" )
CASE Empty( xTOTKGSAI )
ALERTX( "Crm: " + Str( xCRM ) + " sem quantidade" )
CASE Empty( xPEDIDO ) .OR. Empty( xITEM )
ALERTX( "Crm: " + Str( xCRM ) + " sem Programa Recebimento " )
OTHERWISE
IF IGUALVARS( "PE01", Str( xPEDIDO, 5 ) + Str( xITEM, 2 ) )
mDATASAI   := xDATASAI
mNRNOTASAI := xNRNOTASAI
mTOTKGSAI  := xTOTKGSAI
mTOTKGEST  := mTOTKGANT - mTOTKGSAI
mCRM       := xCRM
mPEDIDO    := xPEDIDO
mITEM      := xITEM
BAIXAREM( "PE01", "PE01BX", Str( mPEDIDO, 5 ) + Str( mITEM, 2 ) )
lGRAVOU := .T.
mTIPO   := xTIPOE
mCODIGO := xCODIGO
mUNROTA := xNRNOTASAI
mUDATA  := xDATASAI
mUFORNE := xCLIFOR
mUQTDE  := xTOTKGSAI
xCODIGO := PadR( xCODIGO, 24 )
IF VERSEHA( "PECRT", xTIPOE + xCODIGO + Str( xCLIFOR, 8 ) )
REPORVARS( "PECRT", xTIPOE + xCODIGO + Str( xCLIFOR, 8 ) )
ELSE
APAGAREG( "PECRT", xTIPOE + xCODIGO + Str( xCLIFOR, 8 ), .F., .F. )
ENDIF
ELSE
ALERTX( "N„o Encontrei Programa Recebimento: " + Str( xPEDIDO ) + "." + Str( xITEM ) )
ENDIF
ENDCASE
NEXT X
IF lGRAVOU
dbSelectAr( "CRM" )
netgrvcam( "GRAVAUP", "S" )
dbUnlock()
ENDIF
ENDIF
dbSelectAr( "CRM" )
dbSkip()
ENDDO
dbCloseAll()

// + EOF: M_AOCRM.PRG

// + EOF: m_aocrm.prg
// +
