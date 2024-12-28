// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm7.prg
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

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_BM7.PRG
// +
// +    Reformatted by Click! 2.03 on Oct-1-2003 at 12:39 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

nTIPO   := 1
mNRNOTA := 0
MDI( " þ INVOIC ELECTROLUX" )
MDS( "Digite NF Tipo 1-Fatura/MaoObra 2-RetornoMP 3-Embalagem" )
@ 24, 60 GET mNRNOTA PICT "99999999"
@ 24, 70 GET nTIPO   PICT "9"
IF !READCUR()
RETU .F.
ENDIF
IF nTIPO < 0 .OR. nTIPO > 3
ALERTX( "Tipo Errado" )
RETU .F.
ENDIF

CRIARVARS( "MA01" )
CRIARVARS( "MM01" )
CRIARVARS( "MM02" )

IF !IGUALVARS( "MM01", mNRNOTA )
RETU .F.
ENDIF
IF !IGUALVARS( "MA01", mFORNECEDO )
RETU .F.
ENDIF
tCGC := OBTER( "MANEMP", ZNUMERO, "CGC" )
IF nTIPO = 1
mELE03 := "1  "
ELSE
mELE03 := "2  "
ENDIF
mELE06  := mDATA
mELE07  := mDATA
mELE12  := Space( 13 )  // Zerados Nao Necessarios
mELE13  := Space( 13 )
mCODIGO := Space( 13 )
// mELE12:=mCODIGO
// mELE13:=mCODIGO
mELE17 := tCGC
mELE18 := tCGC
mELE04 := 9
mELE26 := "FOB"
mELE20 := mELE21 := mELE22 := mELE23 := mELE24 := mELE25 := 0
cTIPO  := "F"
IF nTIPO = 2
cTIPO := "R"
ENDIF
IF nTIPO = 3
cTIPO := "E"
ENDIF
IF Empty( mCGCCOMP )
mCGCCOMP := mCGC
ENDIF


mCAMINHO := ProfileString( "MANA5.INI", "PATH", "INVOICE", hb_cwd() + "\ARQUIVO" ) + cTIPO + StrZero( mNRNOTA, 7 ) + ".TXT" + Space( 20 )
IF nTIPO = 2 .AND. !Empty( mCFONEWB )
mCFONEW := mCFONEWB
ENDIF

TELASAY( "EIN001" )
EDITSAY( "EIN001" )
mCAMINHO := StrTran( mCAMINHO, " ", "" )

SET CENTURY ON
nHANDLE := FCreate( AllTrim( mCAMINHO ) )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF
FWrite( nHANDLE, "01" )
FWrite( nHANDLE, StrZero( mNRNOTA, 6 ) )
FWrite( nHANDLE, PadR( mELE03, 3 ) )
FWrite( nHANDLE, StrZero( mELE04, 2 ) )
FWrite( nHANDLE, DToS( mDATA ) )
FWrite( nHANDLE, DToS( mELE06 ) )
FWrite( nHANDLE, DToS( mELE07 ) )
FWrite( nHANDLE, PadR( mPEDIDO, 15 ) )
FWrite( nHANDLE, PadR( mCFONEW, 4 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCODIGO ) ), 13 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCLICOMP ) ), 13 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE12 ) ), 13 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE13 ) ), 13 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCLIENTR ) ), 13 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( tCGC ) ), 14 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCGCCOMP ) ), 14 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE17 ) ), 14 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mELE18 ) ), 14 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCGC3 ) ), 14 ) )
FWrite( nHANDLE, GRVVAL( mELE20, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mELE21, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mELE22, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mELE23, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mELE24, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mELE25, 15, 2 ) )
FWrite( nHANDLE, PadR( mELE26, 3 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCGCTRANS ) ), 15 ) )   // Layout 15 e nao 14 padraocgc
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )

aDATAS := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
      mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
aVALOR := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, ;
      mVAL06, mVAL07, mVAL08, mVAL09, mVAL10 }
aPER := Array( 10 )
AFill( aPER, 0 )

mBELE06 := 0
FOR X := 1 TO 10
IF !Empty( aDATAS[ X ] )
mBELE06++
ENDIF
IF !Empty( aVALOR[ X ] )
aPER[ X ] := PER2( aVALOR[ X ], mTOTNF, 2 )
ENDIF
NEXT X

IF nTIPO = 1
FOR x := 1 TO 10
IF !Empty( aVALOR[ X ] )
mBELE02 := "3  "
mBELE03 := "5  "
mBELE04 := "1  "
mBELE05 := "CD "
mBELE07 := aPER[ X ]
mBELE08 := aDATAS[ X ]
mBELE09 := aVALOR[ X ]
TELASAY( "EIN002" )
EDITSAY( "EIN002" )
FWrite( nHANDLE, "02" )
FWrite( nHANDLE, PadR( mBELE02, 3 ) )
FWrite( nHANDLE, PadR( mBELE03, 3 ) )
FWrite( nHANDLE, PadR( mBELE04, 3 ) )
FWrite( nHANDLE, PadR( mBELE05, 3 ) )
FWrite( nHANDLE, StrZero( mBELE06, 3 ) )
FWrite( nHANDLE, GRVVAL( mBELE07, 5, 2 ) )
FWrite( Nhandle, DToS( mBELE08 ) )
FWrite( nHANDLE, GRVVAL( mBELE09, 15, 2 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
ENDIF
NEXT x
ENDIF
IF !USEREDE( "MM02", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !USEREDE( "OSCRT", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF

mDELE02 := 0
mDELE03 := 0
mVALRET := 0

mSEQREM := 0
dbSelectAr( "MM02" )
dbGoTop()
dbSeek( Str( mNRNOTA, 8 ) )
WHILE NUMERO = mNRNOTA .AND. !Eof()
nVEZES := 1
IF nTIPO = 2
nVEZES := 2
ENDIF
EQUVARS()
FOR X := 1 TO nVEZES
lGRAVA  := .T.
mOS     := Int( OS )
mCELE06 := Space( 15 )
mCELE07 := Space( 15 )
mCELE04 := Space( 15 )
mCELE09 := "A  "
mCELE13 := mVALORMER
mCELE15 := mPRECO
IF mTIPOSERV = "3"
mCODIGO := PadR( AllTrim( mCODIGO ) + "*OP901", 24 )
ENDIF
IF nTIPO = 1
dbSelectAr( "oscrt" )
dbGoTop()
IF dbSeek( mOS )
mCELE06 := CODEAN
mCELE07 := CODCLI
mCELE04 := PEDIDOCLI
ENDIF
ENDIF
dbSelectAr( "MM02" )
IF Empty( mCELE04 ) .AND. nTIPO = 1
mCELE04 := PEDIDOCLI
ENDIF
IF Empty( mCELE07 ) .AND. nTIPO = 1
mCELE07 := mCODIGO
ENDIF
IF mCFONEW = "5124" .OR. mCFONEW = "6124" .OR. mCFONEW = "5902" .OR. mCFONEW = "6902" ;
               .OR. mCFONEW = "5920" .OR. mCFONEW = "6920" .OR. mCFONEW = "5921" .OR. mCFONEW = "6921"
mIPI      := 0
mVALORIPI := 0
mBASEIPI  := 0
mICM      := 0
mVALORICM := 0
mBASEICM  := 0
ENDIF
IF nTIPO = 2 .OR. nTIPO = 3
mCELE04 := "999999" + Space( 9 )
mCELE09 := "E  "
mCELE07 := "62093507" + Space( 7 )
ENDIF
IF nTIPO = 2
// mCODIGO := "62093507" + space( 7 )
// mCELE08 := "99900172" + space( 7 )
mCODIGO := "99900172" + Space( 7 )
IF X = 1   // 1devolucao
// mCODIGO   := mCODDEV
mCELE07   := mCODDEV
mQTDE     := mQTDEDEV
mUNID     := UNIDEV
mVALORMER := mDEV
mPRECO    := mPRCDEV
ELSE   // 2 devolucao
// mCODIGO   := mCODDE2
mCELE07   := mCODDE2
mQTDE     := mQTDEDE2
mUNID     := UNIDE2
mVALORMER := mDE2
mPRECO    := mPRCDE2
ENDIF
IF mQTDE > 0 .AND. Empty( mPRECO )
mPRECO := Round( mVALORMER / mQTDE, 5 )
ENDIF
mCLASSIPI := ""
mCELE13   := mVALORMER
mCELE15   := mPRECO
IF Empty( mQTDE )
lGRAVA := .F.
ENDIF
ENDIF
IF nTIPO = 3
// mCODIGO := padr( "FE", 24 )
DO CASE
CASE mCODIGO = "CM"
mCODIGO := PadR( "80800054", 24 )
CASE mCODIGO = "1012"
mCODIGO := PadR( "80800106", 24 )
CASE mCODIGO = "CG"
mCODIGO := PadR( "80800055", 24 )
OTHERWISE
mCODIGO := PadR( "80800097", 24 )
END CASE
ENDIF
IF lGRAVA
mSEQREM++
TELASAY( "EIN003" )
EDITSAY( "EIN003" )
IF nTIPO = 2
mVALRET += mVALORMER
ENDIF
FWrite( nHANDLE, "03" )
IF nTIPO <> 2
FWrite( nHANDLE, StrZero( mSEQ, 6 ) )
ELSE
FWrite( nHANDLE, StrZero( mSEQREM, 6 ) )
ENDIF
FWrite( nHANDLE, StrZero( mPEDCLIITE, 6 ) )
FWrite( nHANDLE, PadR( TIRAOUT( mCELE04 ), 15 ) )
FWrite( nHANDLE, StrZero( Val( TIRAOUT( mCLASSIPI ) ), 11 ) )
FWrite( nHANDLE, PadR( TIRAOUT( mCELE06 ), 14 ) )
FWrite( nHANDLE, PadR( TIRAOUT( mCELE07 ), 15 ) )
FWrite( nHANDLE, PadR( TIRAOUT( mCODIGO ), 15 ) )
FWrite( nHANDLE, PadR( mCELE09, 3 ) )
FWrite( nHANDLE, GRVVAL( mQTDE, 11, 3 ) )
FWrite( nHANDLE, PadR( mUNID, 3 ) )
FWrite( nHANDLE, GRVVAL( mVALORMER, 17, 5 ) )
FWrite( nHANDLE, GRVVAL( mCELE13, 17, 5 ) )
FWrite( nHANDLE, GRVVAL( mPRECO, 17, 5 ) )
FWrite( nHANDLE, GRVVAL( mCELE15, 17, 5 ) )
FWrite( nHANDLE, GRVVAL( mIPI, 4, 2 ) )
FWrite( nHANDLE, GRVVAL( mVALORIPI, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mBASEIPI, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mICM, 4, 2 ) )
FWrite( nHANDLE, GRVVAL( mVALORICM, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mBASEICM, 15, 2 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
mDELE02++
mDELE03 += CONVUN( mQTDE, mUNID )
ENDIF
dbSelectAr( "MM02" )
NEXT X
dbSkip()
ENDDO
dbCloseAll()
mDELE05 := mTOTMER
mDELE06 := 0
mDELE07 := 0
IF nTIPO = 2 .OR. nTIPO = 3
mTOTIPI  := 0
mTOTICM  := 0
mTOTBICM := 0
mICM     := 0
ENDIF
IF nTIPO = 2
mTOTMER := mVALRET
mDELE05 := mVALRET
ENDIF
TELASAY( "EIN009" )
EDITSAY( "EIN009" )
FWrite( nHANDLE, "09" )
FWrite( nHANDLE, StrZero( mDELE02, 5 ) )
FWrite( nHANDLE, GRVVAL( mDELE03, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mTOTMER, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mDELE05, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mDELE06, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mDELE07, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mTOTIPI, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mTOTICM, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mTOTBICM, 15, 2 ) )
FWrite( nHANDLE, GRVVAL( mICM, 5, 2 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
FWrite( nHANDLE, Chr( 26 ) )
FClose( nHANDLE )
SET CENTURY OFF

// + EOF: M_BM7.PRG

// + EOF: m_bm7.prg
// +
