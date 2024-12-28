// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ak2a.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( " Ý Checar Classifica‡Æo Nota Fiscal" )
PARA cTIPO, cARQ, cARQ2
IF ValType( cTIPO ) # "C"
cTIPO := "E"
ENDIF
IF ValType( cARQ ) # "C"
IF cTIPO = "E"
aRETU := PEGMES( { "K2", "K6" }, .T., { "MK02", "MK06" } )
ELSE
aRETU := PEGMES( { "M2", "M6" }, .T., { "MM02", "MK06" } )
ENDIF
cARQ  := aRETU[ 5, 1 ]
cARQ2 := aRETU[ 5, 2 ]
ENDIF
IF !USEMULT( { { cARQ, 1, 0 }, { cARQ2, 1, 0 } } )
RETU .F.
ENDIF
dbSelectAr( cARQ )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF cTIPO = "E"
ordDestroy( "temp" )
ordCreate(, "temp", "str(NRNOTA,8)+str(FORNECEDO,5)+str(ITEM,5)" )
ordSetFocus( "temp" )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", "str(NUMERO,8)+str(FORNECEDO,5)+str(SEQ,5)" )
ordSetFocus( "temp" )
ENDIF
dbSelectAr( cARQ )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
IF TIPOENT $ "MCORBS" .AND. ( Empty( CLASSIPI ) .OR. IF( cTIPO = "S", .F., Empty( CODDEP ) ) )
mCODIGO   := AllTrim( CODIGO )
mTIPOENT  := TIPOENT
mIPI      := 0
mCODIPI   := ""
mCLASSIPI := ""
mCODDEP   := ""
@ 24, 10 SAY mCODIGO
PEGACAMPO( ESTQARQ( mTIPOENT, 1 ), "mCODIGO", { "CODIPI", "IPI", "CLASSIPI", "CTACONTB" }, { "mCODIPI", "mIPI", "mCLASSIPI", "mCODDEP" } )
IF !Empty( mCODIPI )
CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
ENDIF
IF !Empty( mCLASSIPI ) .AND. Empty( CLASSIPI )
netgrvcam( "CLASSIPI", mCLASSIPI )
ENDIF
IF !Empty( mCODDEP ) .AND. IF( cTIPO = "S", .F., Empty( CODDEP ) )
netgrvcam( "CODDEP", mCODDEP )
ENDIF
ENDIF
dbSelectAr( cARQ )
dbSkip()
ENDDO
dbSelectAr( cARQ2 )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
mDCLASSIPI := ""
IF Empty( DCLASSIPI )
mCHAVE    := Str( NUMERO, 8 ) + Str( FORNECEDO, 5 ) + Str( ITEM, 5 )
nDVALORNF := DVALORNF
dbSelectAr( cARQ )
dbGoTop()
IF dbSeek( mCHAVE )
IF nDVALORNF = VALORTOT  // Checa Troca de Itens pelo valor
mDCLASSIPI := CLASSIPI
ENDIF
ENDIF
ENDIF
dbSelectAr( cARQ2 )
IF !Empty( mDCLASSIPI )
NETGRVCAM( "DCLASSIPI", mDCLASSIPI )
ENDIF
dbSkip()
ENDDO
dbSelectAr( cARQ )
dbCloseArea()
dbSelectAr( cARQ2 )
dbCloseArea()


// + EOF: m_ak2a.prg
// +
