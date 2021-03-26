*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BM7.PRG
*+
*+    Reformatted by Click! 2.03 on Oct-1-2003 at 12:39 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

nTIPO   := 1
mNRNOTA := 0
MDI( " þ INVOIC ELECTROLUX" )
MDS( "Digite NF Tipo 1-Fatura/MaoObra 2-RetornoMP 3-Embalagem" )
@ 24, 60 get mNRNOTA pict "99999999"
@ 24, 70 get nTIPO   pict "9"
if !READCUR()
   retu .F.
endif
if nTIPO < 0 .or. nTIPO > 3
   ALERTX( "Tipo Errado" )
   retu .F.
endif

CRIARVARS( "MA01" )
CRIARVARS( "MM01" )
CRIARVARS( "MM02" )

if !IGUALVARS( "MM01", mNRNOTA )
   retu .F.
endif
if !IGUALVARS( "MA01", mFORNECEDO )
   retu .F.
endif
tCGC := OBTER( "MANEMP", ZNUMERO, "CGC" )
if nTIPO = 1
   mELE03 := "1  "
else
   mELE03 := "2  "
endif
mELE06  := mDATA
mELE07  := mDATA
mELE12  := space( 13 )                  //Zerados Nao Necessarios
mELE13  := space( 13 )
mCODIGO := space( 13 )
//mELE12:=mCODIGO
//mELE13:=mCODIGO
mELE17 := tCGC
mELE18 := tCGC
mELE04 := 9
mELE26 := "FOB"
mELE20 := mELE21 := mELE22 := mELE23 := mELE24 := mELE25 := 0
cTIPO  := "F"
if nTIPO = 2
   cTIPO := "R"
endif
if nTIPO = 3
   cTIPO := "E"
endif
if empty( mCGCCOMP )
   mCGCCOMP := mCGC
endif


mCAMINHO := ProfileString( "MANA5.INI", "PATH", "INVOICE",HB_CWD()+"\ARQUIVO" ) + cTIPO + strzero( mNRNOTA, 7 ) + ".TXT" + space( 20 )
if nTIPO = 2 .and. !empty( mCFONEWB )
   mCFONEW := mCFONEWB
endif

TELASAY( "EIN001" )
EDITSAY( "EIN001" )
mCAMINHO := strtran( mCAMINHO, " ", "" )

set century on
nHANDLE := fcreate( alltrim( mCAMINHO ) )
if ferror() # 0
   ALERTX( "Erro na Cria‡„o do Arquivo" )
   retu
endif
fwrite( nHANDLE, "01" )
fwrite( nHANDLE, strzero( mNRNOTA, 6 ) )
fwrite( nHANDLE, padr( mELE03, 3 ) )
fwrite( nHANDLE, strzero( mELE04, 2 ) )
fwrite( nHANDLE, dtos( mDATA ) )
fwrite( nHANDLE, dtos( mELE06 ) )
fwrite( nHANDLE, dtos( mELE07 ) )
fwrite( nHANDLE, padr( mPEDIDO, 15 ) )
fwrite( nHANDLE, padr( mCFONEW, 4 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mCODIGO ) ), 13 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mCLICOMP ) ), 13 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mELE12 ) ), 13 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mELE13 ) ), 13 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mCLIENTR ) ), 13 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( tCGC ) ), 14 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mCGCCOMP ) ), 14 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mELE17 ) ), 14 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mELE18 ) ), 14 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mCGC3 ) ), 14 ) )
fwrite( nHANDLE, GRVVAL( mELE20, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mELE21, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mELE22, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mELE23, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mELE24, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mELE25, 15, 2 ) )
fwrite( nHANDLE, padr( mELE26, 3 ) )
fwrite( nHANDLE, strzero( val( TIRAOUT( mCGCTRANS ) ), 15 ) )                   //Layout 15 e nao 14 padraocgc
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )

aDATAS := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
            mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
aVALOR := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, ;
            mVAL06, mVAL07, mVAL08, mVAL09, mVAL10 }
aPER := array( 10 )
afill( aPER, 0 )

mBELE06 := 0
for X := 1 to 10
   if !empty( aDATAS[ X ] )
      mBELE06 ++
   endif
   if !empty( aVALOR[ X ] )
      aPER[ X ] := PER2( aVALOR[ X ], mTOTNF, 2 )
   endif
next X

if nTIPO = 1
   for x := 1 to 10
      if !empty( aVALOR[ X ] )
         mBELE02 := "3  "
         mBELE03 := "5  "
         mBELE04 := "1  "
         mBELE05 := "CD "
         mBELE07 := aPER[ X ]
         mBELE08 := aDATAS[ X ]
         mBELE09 := aVALOR[ X ]
         TELASAY( "EIN002" )
         EDITSAY( "EIN002" )
         fwrite( nHANDLE, "02" )
         fwrite( nHANDLE, padr( mBELE02, 3 ) )
         fwrite( nHANDLE, padr( mBELE03, 3 ) )
         fwrite( nHANDLE, padr( mBELE04, 3 ) )
         fwrite( nHANDLE, padr( mBELE05, 3 ) )
         fwrite( nHANDLE, strzero( mBELE06, 3 ) )
         fwrite( nHANDLE, GRVVAL( mBELE07, 5, 2 ) )
         fwrite( Nhandle, dtos( mBELE08 ) )
         fwrite( nHANDLE, GRVVAL( mBELE09, 15, 2 ) )
         fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
      endif
   next x
endif
if !USEREDE( "MM02", 1, 1 )
   dbcloseall()
   retu .F.
endif
if !USEREDE( "OSCRT", 1, 1 )
   dbcloseall()
   retu .F.
endif

mDELE02 := 0
mDELE03 := 0
mVALRET := 0

mSEQREM := 0
dbselectar( "MM02" )
dbgotop()
dbseek( str( mNRNOTA, 8 ) )
while NUMERO = mNRNOTA .and. !eof()
   nVEZES := 1
   if nTIPO = 2
      nVEZES := 2
   endif
   EQUVARS()
   for X := 1 to nVEZES
      lGRAVA  := .T.
      mOS     := int( OS )
      mCELE06 := space( 15 )
      mCELE07 := space( 15 )
      mCELE04 := space( 15 )
      mCELE09 := "A  "
      mCELE13 := mVALORMER
      mCELE15 := mPRECO
      IF mTIPOSERV="3"
         mCODIGO:=PADR(ALLTRIM(mCODIGO)+"*OP901",24)
      ENDIF
      if nTIPO = 1
         dbselectar( "oscrt" )
         dbgotop()
         if dbseek( mOS )
            mCELE06 := CODEAN
            mCELE07 := CODCLI
            mCELE04 := PEDIDOCLI
         endif
      endif
      dbselectar( "MM02" )
      if empty( mCELE04 ) .and. nTIPO = 1
         mCELE04 := PEDIDOCLI
      endif
      if empty( mCELE07 ) .and. nTIPO = 1
         mCELE07 := mCODIGO
      endif
      if mCFONEW = "5124" .or. mCFONEW = "6124" .or. mCFONEW = "5902" .or. mCFONEW = "6902" ;
                 .or. mCFONEW = "5920" .or. mCFONEW = "6920" .or. mCFONEW = "5921" .or. mCFONEW = "6921"
         mIPI      := 0
         mVALORIPI := 0
         mBASEIPI  := 0
         mICM      := 0
         mVALORICM := 0
         mBASEICM  := 0
      endif
      if nTIPO = 2 .or. nTIPO = 3
         mCELE04 := "999999" + space( 9 )
         mCELE09 := "E  "
         mCELE07 := "62093507" + space( 7 )
      endif
      if nTIPO = 2
//         mCODIGO := "62093507" + space( 7 )
//         mCELE08 := "99900172" + space( 7 )
         mCODIGO := "99900172" + space( 7 )
         if X = 1   //1devolucao
//            mCODIGO   := mCODDEV
            mCELE07   := mCODDEV
            mQTDE     := mQTDEDEV
            mUNID     := UNIDEV
            mVALORMER := mDEV
            mPRECO    := mPRCDEV
         else       //2 devolucao
//            mCODIGO   := mCODDE2
            mCELE07   := mCODDE2
            mQTDE     := mQTDEDE2
            mUNID     := UNIDE2
            mVALORMER := mDE2
            mPRECO    := mPRCDE2
         endif
         if mQTDE > 0.AND.EMPTY(mPRECO)
            mPRECO := round( mVALORMER / mQTDE, 5 )
         endif
         mCLASSIPI := ""
         mCELE13   := mVALORMER
         mCELE15   := mPRECO
         if empty( mQTDE )
            lGRAVA := .F.
         endif
      endif
      if nTIPO = 3
//         mCODIGO := padr( "FE", 24 )
          DO CASE
             CASE mCODIGO="CM"
                mCODIGO := padr( "80800054", 24 )
             CASE mCODIGO="1012"
                mCODIGO := padr( "80800106", 24 )
             CASE mCODIGO="CG"
                mCODIGO := padr( "80800055", 24 )
             otherwise
                mCODIGO := padr( "80800097", 24 )
          END CASE
      endif
      if lGRAVA
         mSEQREM++
         TELASAY( "EIN003" )
         EDITSAY( "EIN003" )
         if nTIPO = 2
            mVALRET += mVALORMER
         endif
         fwrite( nHANDLE, "03" )
         IF nTIPO<>2
            fwrite( nHANDLE, strzero( mSEQ, 6 ) )
         ELSE
            fwrite( nHANDLE, strzero( mSEQREM, 6 ) )
         ENDIF
         fwrite( nHANDLE, strzero( mPEDCLIITE, 6 ) )
         fwrite( nHANDLE, padr( TIRAOUT( mCELE04 ), 15 ) )
         fwrite( nHANDLE, strzero( val( TIRAOUT( mCLASSIPI ) ), 11 ) )
         fwrite( nHANDLE, padr( TIRAOUT( mCELE06 ), 14 ) )
         fwrite( nHANDLE, padr( TIRAOUT( mCELE07 ), 15 ) )
         fwrite( nHANDLE, padr( TIRAOUT( mCODIGO ), 15 ) )
         fwrite( nHANDLE, padr( mCELE09, 3 ) )
         fwrite( nHANDLE, GRVVAL( mQTDE, 11, 3 ) )
         fwrite( nHANDLE, padr( mUNID, 3 ) )
         fwrite( nHANDLE, GRVVAL( mVALORMER, 17, 5 ) )
         fwrite( nHANDLE, GRVVAL( mCELE13, 17, 5 ) )
         fwrite( nHANDLE, GRVVAL( mPRECO, 17, 5 ) )
         fwrite( nHANDLE, GRVVAL( mCELE15, 17, 5 ) )
         fwrite( nHANDLE, GRVVAL( mIPI, 4, 2 ) )
         fwrite( nHANDLE, GRVVAL( mVALORIPI, 15, 2 ) )
         fwrite( nHANDLE, GRVVAL( mBASEIPI, 15, 2 ) )
         fwrite( nHANDLE, GRVVAL( mICM, 4, 2 ) )
         fwrite( nHANDLE, GRVVAL( mVALORICM, 15, 2 ) )
         fwrite( nHANDLE, GRVVAL( mBASEICM, 15, 2 ) )
         fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
         mDELE02 ++
         mDELE03 += CONVUN( mQTDE, mUNID )
      endif
      dbselectar( "MM02" )
   next X
   dbskip()
enddo
dbcloseall()
mDELE05 := mTOTMER
mDELE06 := 0
mDELE07 := 0
if nTIPO = 2 .or. nTIPO = 3
   mTOTIPI  := 0
   mTOTICM  := 0
   mTOTBICM := 0
   mICM     := 0
endif
if nTIPO = 2
   mTOTMER := mVALRET
   mDELE05 := mVALRET
endif
TELASAY( "EIN009" )
EDITSAY( "EIN009" )
fwrite( nHANDLE, "09" )
fwrite( nHANDLE, strzero( mDELE02, 5 ) )
fwrite( nHANDLE, GRVVAL( mDELE03, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mTOTMER, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mDELE05, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mDELE06, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mDELE07, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mTOTIPI, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mTOTICM, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mTOTBICM, 15, 2 ) )
fwrite( nHANDLE, GRVVAL( mICM, 5, 2 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
fwrite( nHANDLE, chr( 26 ) )
fclose( nHANDLE )
set century OFF

*+ EOF: M_BM7.PRG
