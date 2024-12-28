// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : itamam01.prg
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
// +    Source Module => J:\ITAESBRA\ITAMAM01.PRG
// +
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

MDI( "Transferir DSTA" )
SET CENTURY ON
xrCGC  := OBTER( "MANEMP", ZNUMERO, "CGC" )
mNOME  := TIRACE( OBTER( "MANEMP", ZNUMERO, "NOME" ) ) + Space( 10 )
ARQ    := "C:\TEMP\DSTA" + Space( 40 )
mTRI   := "1"
mANO   := StrZero( Year( ZDATA ), 4 )
mREG   := "2"
mIND   := "0"
mSIT   := "0"
nREG   := 1
cPRE   := "N"
cUNI01 := "41"  // Outros
cUNI02 := "06"  // Cento
cUNI03 := "24"  // Milheiro
cUNI04 := "38"  // Unidade //30=PeCA
@ 09, 00 SAY "Consulte Manual DSTA"
@ 10, 00 SAY "CGC:"
@ 11, 00 SAY "Nome:"
@ 12, 00 SAY "Trimestre:"
@ 13, 00 SAY "Ano:"
@ 14, 00 SAY "Regime:"
@ 15, 00 SAY "Indicador"
@ 16, 00 SAY "Situa‡Жo:"
@ 17, 00 SAY "Arquivo:"
@ 18, 00 SAY "Converter Pre‡o*100"
@ 19, 00 SAY "Codigos Unidades"
@ 19, 17 SAY "Out  CT  ML  UN"
@ 10, 20 GET xrCGC
@ 11, 20 GET mNOME
@ 12, 20 GET mTRI
@ 13, 20 GET mANO
@ 14, 20 GET mREG
@ 15, 20 GET mIND
@ 16, 20 GET mSIT
@ 17, 20 GET ARQ
@ 18, 30 GET cPRE                   PICT "!" VALID cPRE $ "SN"
@ 19, 20 GET cUNI01
@ 19, 24 GET cUNI02
@ 19, 28 GET cUNI03
@ 19, 32 GET cUNI04
IF !READCUR()
RETU .F.
ENDIF

aRETU  := PERFEC( { "MM02", "MM01" }, { "M2", "M1" }, { "MM92", "MM91" }, { "PADRAO", "PADRAO" } )
cARQ   := aRETU[ 5, 1 ]
cARQ2  := aRETU[ 5, 2 ]
mCGC   := SubStr( xrCGC, 1, 2 ) + SubStr( xrCGC, 4, 3 ) + SubStr( xrCGC, 8, 3 ) + SubStr( xrCGC, 12, 4 ) + SubStr( xrCGC, 17, 2 )
FILTRO := ""
FILTRO := RFILORD( cARQ, .F. )
USO    := FCreate( AllTrim( ARQ ) )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF

FWrite( USO, "0" )
FWrite( USO, mCGC )
FWrite( USO, PadR( mNOME, 55 ) )
FWrite( USO, mTRI )
FWrite( USO, mANO )
FWrite( USO, mREG )
FWrite( USO, mIND )
FWrite( USO, mSIT )
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
nREG++
IF !USEMULT( { { cARQ, 1, 0 }, { "MS01", 1, 2 }, { "MD03", 1, 1 }, { "MA01", 1, 1 }, { "MB01", 1, 1 }, { cARQ2, 1, 1 } } )
RETU .F.
ENDIF
dbSelectAr( cARQ )
INITVARS()
CLRVARS()
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "str( numero ) + codigo" )
ordSetFocus( "temp" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO.
ENDIF
dbGoTop()
WHILE !Eof()
@ 24, 10 SAY RecNo()
ZNRNOTA := NUMERO
ZTOT    := 0
ZTOTIPI := 0
ZUNID   := "PC"
aLIN    := {}
WHILE ZNRNOTA = numero .AND. !Eof()
zCODIGO := AllTrim( CODIGO )
zQTDE   := 0
zITEM   := 0
WHILE ZNRNOTA = NUMERO .AND. zCODIGO = AllTrim( CODIGO ) .AND. !Eof()
IF IPI = 0
ZQTDE += QTDE
ZITEM += VALORTOT
ZUNID := UNID
EQUVARS()
ENDIF
dbSelectAr( cARQ )
dbSkip()
ENDDO
IF ZQTDE > 0
IF cPRE = "S"
mPRECO := mPRECO * 100
ZQTDE  := ZQTDE / 100
ENDIF
mQTDE      := StrZero( ZQTDE, 11, 3 )
mQTDE      := StrTran( mQTDE, ".", "" )
mPRECO     := Round( mPRECO, 2 )
mPRECO     := StrZero( mPRECO, 19, 6 )
mPRECO     := StrTran( mPRECO, ".", "" )
mIPI       := StrZero( mIPI, 6, 2 )
mIPI       := StrTran( mIPI, ".", "" )
mCGCCLI    := Space( 14 )
mTIPOCLI   := " "
mFORNECEDO := 0
lESPECIE   := .T.
mSERIE     := "UN "
mCFO       := "   "
// mCFO2      :="   "
dbSelectAr( cARQ2 )
dbGoTop()
IF dbSeek( ZNRNOTA )
mTIPOCLI   := TIPOCLI
mFORNECEDO := FORNECEDO
IF ESPECIE = "NFC"
lESPECIE := .F.
ENDIF
mSERIE := Left( SERIE, 3 )
mCFO   := Left( OPERACAO, 3 )
// mCFO2 :=SUBSTR(OPERACAO,5,3)
ZTOT := TOTNF
ENDIF
IF !Empty( mFORNECEDO ) .AND. ( mTIPOCLI = "C" .OR. mTIPOCLI = "F" )
dbSelectAr( if( mTIPOCLI = "C", "MA01", "MB01" ) )
dbGoTop()
IF dbSeek( mFORNECEDO )
mCGCCLI := CGC
mCGCCLI := SubStr( mCGCCLI, 1, 2 ) + SubStr( mCGCCLI, 4, 3 ) + SubStr( mCGCCLI, 8, 3 ) + SubStr( mCGCCLI, 12, 4 ) + SubStr( mCGCCLI, 17, 2 )
ENDIF
ENDIF
mCODIPI := "  "
mAIPI   := 0
mVIPI   := 0
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( mCODIGO )
mCODIPI := CODIPI
ENDIF
dbSelectAr( "MD03" )
dbGoTop()
IF dbSeek( mCODIPI )
IF DSTA # "N"
mAIPI := ALIQUOTA
ENDIF
ENDIF
IF mAIPI > 0
ZTOTIPI += Round( ZITEM * mAIPI / 100, 2 )
ENDIF
mIPIS := StrZero( mAIPI, 6, 2 )
mIPIS := StrTran( mIPIS, ".", "" )
dbSelectAr( cARQ )
IF !Empty( mCGCCLI ) .AND. !Empty( mCLASSIPI ) .AND. mAPURA # "N" .AND. mAIPI > 0 .AND. lESPECIE
cLINHA := "2"
cLINHA += mCGCCLI
cLINHA += StrZero( mNUMERO, 6 )
cLINHA += mSERIE
cLINHA += mCFO
cLINHA += StrTran( DToC( mDATA ), "/", "" )
cLINHA += StrTran( DToC( mDATA ), "/", "" )
// Complementar
cLINHA += "0"
cLINHA += REPL( "0", 6 )   // NoTA
cLINHA += "   "   // Serie
cLINHA += REPL( "0", 8 )   // Data
//
cLINHA += PadR( AllTrim( TIRACE( mNOME ) ), 40 )
cLINHA += PadR( AllTrim( mCODIGO ), 20 )
cLINHA += Left( StrTran( mCLASSIPI, ".", "" ), 8 ) + "  "
// cLINHA+=mCFO2
cLINHA += mCFO


DO CASE
CASE cPRE = "S"
cLINHA += cUNI01
CASE ZUNID = "CT"
cLINHA += cUNI02
CASE ZUNID = "ML"
cLINHA += cUNI03
OTHERWISE
cLINHA += cUNI04
ENDCASE

cLINHA += mQTDE
cLINHA += mPRECO
cLINHA += mIPIS
AAdd( aLIN, cLINHA )
ENDIF
ENDIF
ENDDO
mVALOR := StrZero( ZTOT, 15, 2 )
mVALOR := StrTran( mVALOR, ".", "" )
mVIPI  := StrZero( ZTOTIPI, 15, 2 )
mVIPI  := StrTran( mVIPI, ".", "" )
FOR X := 1 TO Len( aLIN )
FWrite( USO, aLIN[ X ] )
FWrite( USO, Space( 11 ) + "000" )   // 20
FWrite( USO, Space( 11 ) + "000" )   // 21
FWrite( USO, Space( 11 ) + "000" )   // 22
FWrite( USO, mVIPI )   // 23
FWrite( USO, mVALOR )  // 24
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
nREG++
NEXT X
dbSelectAr( cARQ )
ENDDO
FWrite( USO, "9" )
FWrite( USO, StrZero( nREG, 6 ) )
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
FWrite( USO, Chr( 26 ) )
dbCloseAll()

// + EOF: ITAMAM01.PRG

// + EOF: itamam01.prg
// +
