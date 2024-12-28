// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bfor.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_BFOR.PRG
// +
// +    Reformatted by Click! 2.03 on Jun-10-2002 at  3:07 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

MDI( " н Apurando Business Plan Fornecedor" )

dINI := dFIM := ZDATA
nANO := Year( ZDATA )
MDS( "Digite o Periodo" )
@ 24, 20 GET dINI
@ 24, 30 GET dFIM
@ 24, 40 GET nANO PICT "9999"
READCUR()

IF MDG( "Apurar CRM" )
IF !USEMULT( { { "BPFORC", 0, 99 }, { "CRM", 1, 2 } } )   // Data
RETU .F.
ENDIF
dbSelectAr( "BPFORC" )
ZAP
dbSelectAr( "CRM" )
dbGoTop()
dbSeek( dINI )
WHILE DATA <= dFIM .AND. !Eof()
@ 24, 00 SAY CRM
@ 24, 10 SAY CLIFOR
mFORNECEDO := CLIFOR
mTIPO      := TIPCAD
IF mTIPO = "F"
dbSelectAr( "BPFORC" )
dbGoTop()
IF !dbSeek( mFORNECEDO )
netrecapp()
field->FORNECEDO := mFORNECEDO
ENDIF
ENDIF
dbSelectAr( "CRM" )
dbSkip()
ENDDO
dbCloseAll()
ENDIF

IF MDG( "Apurar NFC" )
IF !USEMULT( { { "BPFORC", 1, 1 }, { "BPFORR", 0, 99 }, { "MB01", 1, 1 } } )
RETU .F.
ENDIF
dbSelectAr( "BPFORR" )
ZAP
MDS( "" )
FOR X := 1 TO 12
@ 24, 00 SAY X
cARQUIVO := "K1" + Right( StrZero( nANO, 4 ), 2 ) + StrZero( X, 2 )
IF USEREDE( cARQUIVO, 1, 2 )  // Fornecedo
dbSelectAr( "BPFORC" )
dbGoTop()
WHILE !Eof()
mFORNECEDO := FORNECEDO
@ 24, 10 SAY mFORNECEDO
mVALOR   := 0
mCOGNOME := ""
mGRUPO   := ""
dbSelectAr( cARQUIVO )
dbGoTop()
dbSeek( mFORNECEDO )
WHILE mFORNECEDO = FORNECEDO .AND. !Eof()
mVALOR += TOTNF
dbSkip()
ENDDO
IF mVALOR > 0
dbSelectAr( "MB01" )
dbGoTop()
IF dbSeek( mFORNECEDO )
mCOGNOME := COGNOME
mGRUPO   := CODMAT
ENDIF
dbSelectAr( "BPFORR" )
netrecapp()
field->COGNOME   := mCOGNOME
field->GRUPO     := mGRUPO
field->FORNECEDO := mFORNECEDO
field->VALOR     := mVALOR
field->ANO       := nANO
field->MES       := X
ENDIF
dbSelectAr( "BPFORC" )
dbSkip()
ENDDO
dbSelectAr( cARQUIVO )
dbCloseArea()
ENDIF
NEXT X
dbSelectAr( "BPFORC" )
dbCloseAll()
ENDIF
IF MDG( "Calcular Percentual" )
mds( "" )
IF USEREDE( "BPFORR", 1, 99 )
dbSelectAr( "BPFORR" )
FOR X := 1 TO 12
@ 24, 00 SAY X
nTOTAL := 0
dbGoTop()
dbSeek( Str( nANO, 4 ) + Str( X, 2 ) )
WHILE nANO = ANO .AND. MES = X .AND. !Eof()
@ 24, 10 SAY FORNECEDO
nTOTAL += VALOR
dbSkip()
ENDDO
dbGoTop()
dbSeek( Str( nANO, 4 ) + Str( X, 2 ) )
WHILE nANO = ANO .AND. MES = X .AND. !Eof()
@ 24, 20 SAY FORNECEDO
netgrvcam( "PERC", PERC( VALOR, nTOTAL ) )
dbSkip()
ENDDO
NEXT X
dbCloseAll()
ENDIF
ENDIF

// + EOF: M_BFOR.PRG

// + EOF: m_bfor.prg
// +
