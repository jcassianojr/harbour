*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\ITAMAM01.PRG
*+
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

MDI( "Transferir DSTA" )
set century on
xrCGC := OBTER( "MANEMP", ZNUMERO, "CGC" )
mNOME := TIRACE( OBTER( "MANEMP", ZNUMERO, "NOME" ) ) + space( 10 )
ARQ   := "C:\TEMP\DSTA" + space( 40 )
mTRI  := "1"
mANO  := strzero( year( ZDATA ), 4 )
mREG  := "2"
mIND  := "0"
mSIT  := "0"
nREG  := 1
cPRE  := "N"
cUNI01:="41" //Outros
cUNI02:="06" //Cento
cUNI03:="24" //Milheiro
cUNI04:="38" //Unidade //30=PeCA
@ 09, 00 say "Consulte Manual DSTA"
@ 10, 00 say "CGC:"
@ 11, 00 say "Nome:"
@ 12, 00 say "Trimestre:"
@ 13, 00 say "Ano:"
@ 14, 00 say "Regime:"
@ 15, 00 SAY "Indicador"
@ 16, 00 say "Situa‡Жo:"
@ 17, 00 say "Arquivo:"
@ 18,00  say "Converter Pre‡o*100"
@ 19,00  SAY "Codigos Unidades"
@ 19,17  SAY "Out  CT  ML  UN"
@ 10, 20 get xrCGC
@ 11, 20 get mNOME
@ 12, 20 get mTRI
@ 13, 20 get mANO
@ 14, 20 get mREG
@ 15, 20 get mIND
@ 16, 20 get mSIT
@ 17, 20 get ARQ
@ 18, 30 GET cPRE PICT "!" VALID cPRE $ "SN"
@ 19, 20 GET cUNI01
@ 19, 24 GET cUNI02
@ 19, 28 GET cUNI03
@ 19, 32 GET cUNI04
if !READCUR()
   retu .F.
endif

aRETU  := PERFEC( { "MM02", "MM01" }, { "M2", "M1" }, { "MM92", "MM91" }, { "PADRAO", "PADRAO" } )
cARQ   := aRETU[ 5, 1 ]
cARQ2  := aRETU[ 5, 2 ]
mCGC   := substr( xrCGC, 1, 2 ) + substr( xrCGC, 4, 3 ) + substr( xrCGC, 8, 3 ) + substr( xrCGC, 12, 4 ) + substr( xrCGC, 17, 2 )
FILTRO := ""
FILTRO := RFILORD( cARQ, .F. )
USO    := fcreate( alltrim( ARQ ) )
if ferror() # 0
   ALERTX( "Erro na Cria‡„o do Arquivo" )
   retu
endif

fwrite( USO, "0" )
fwrite( USO, mCGC )
fwrite( USO, padr( mNOME, 55 ) )
fwrite( USO, mTRI )
fwrite( USO, mANO )
fwrite( USO, mREG )
fwrite( USO, mIND )
fwrite( USO, mSIT )
fwrite( USO, chr( 13 ) + chr( 10 ) )
nREG ++
if !USEMULT( { { cARQ, 1, 0 }, { "MS01", 1, 2 }, { "MD03", 1, 1 }, { "MA01", 1, 1 }, { "MB01", 1, 1 }, { cARQ2, 1, 1 } } )
   retu .F.
endif
dbselectar( cARQ )
INITVARS()
CLRVARS()
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","str( numero ) + codigo")
ordSetFocus("temp")
if !empty( FILTRO )
   set filter to &FILTRO.
endif
dbgotop()
while !eof()
   @ 24, 10 say recno()
   ZNRNOTA := NUMERO
   ZTOT:=0
   ZTOTIPI := 0
   ZUNID   := "PC"
   aLIN:={}
   while ZNRNOTA = numero .and. !eof()
      zCODIGO := alltrim( CODIGO )
      zQTDE   := 0
      zITEM   := 0
      while ZNRNOTA = NUMERO .and. zCODIGO = alltrim( CODIGO ) .and. !eof()
         if IPI = 0
            ZQTDE += QTDE
            ZITEM += VALORTOT
            ZUNID := UNID
            EQUVARS()
         endif
         dbselectar( cARQ )
         dbskip()
      enddo
      if ZQTDE > 0
         IF cPRE="S"
            mPRECO=mPRECO*100
            ZQTDE=ZQTDE/100
         ENDIF
         mQTDE := strzero( ZQTDE, 11, 3 )
         mQTDE := strtran( mQTDE, ".", "" )
         mPRECO     := round( mPRECO, 2 )
         mPRECO     := strzero( mPRECO, 19, 6 )
         mPRECO     := strtran( mPRECO, ".", "" )
         mIPI       := strzero( mIPI, 6, 2 )
         mIPI       := strtran( mIPI, ".", "" )
         mCGCCLI    := space( 14 )
         mTIPOCLI   := " "
         mFORNECEDO := 0
         lESPECIE   := .T.
         mSERIE     :="UN "
         mCFO       :="   "
//         mCFO2      :="   "
         dbselectar( cARQ2 )
         dbgotop()
         if dbseek(ZNRNOTA)
            mTIPOCLI   := TIPOCLI
            mFORNECEDO := FORNECEDO
            if ESPECIE = "NFC"
               lESPECIE := .F.
            endif
            mSERIE:=LEFT(SERIE,3)
            mCFO  :=LEFT(OPERACAO,3)
//            mCFO2 :=SUBSTR(OPERACAO,5,3)
            ZTOT  :=TOTNF
         endif
         if !empty( mFORNECEDO ) .and. ( mTIPOCLI = "C" .or. mTIPOCLI = "F" )
            dbselectar( if( mTIPOCLI = "C", "MA01", "MB01" ) )
            dbgotop()
            if dbseek( mFORNECEDO )
               mCGCCLI := CGC
               mCGCCLI := substr( mCGCCLI, 1, 2 ) + substr( mCGCCLI, 4, 3 ) + substr( mCGCCLI, 8, 3 ) + substr( mCGCCLI, 12, 4 ) + substr( mCGCCLI, 17, 2 )
            endif
         endif
         mCODIPI := "  "
         mAIPI   := 0
         mVIPI   := 0
         dbselectar( "MS01" )
         dbgotop()
         if dbseek( mCODIGO )
            mCODIPI := CODIPI
         endif
         dbselectar( "MD03" )
         dbgotop()
         if dbseek( mCODIPI )
            if DSTA # "N"
               mAIPI := ALIQUOTA
            endif
         endif
         if mAIPI > 0
            ZTOTIPI += round( ZITEM * mAIPI / 100, 2 )
         endif
         mIPIS := strzero( mAIPI, 6, 2 )
         mIPIS := strtran( mIPIS, ".", "" )
         dbselectar( cARQ )
         if !empty( mCGCCLI ) .and. !empty( mCLASSIPI ) .and. mAPURA # "N" .and. mAIPI > 0 .and. lESPECIE
            cLINHA:="2"
            cLINHA+=mCGCCLI
            cLINHA+=strzero( mNUMERO, 6 )
            cLINHA+=mSERIE
            cLINHA+=mCFO
            cLINHA+=strtran( dtoc( mDATA ), "/", "" )
            cLINHA+=strtran( dtoc( mDATA ), "/", "" )
            //Complementar
            cLINHA+="0"
            cLINHA+=REPL("0",6) //NoTA
            cLINHA+="   " //Serie
            cLINHA+=REPL("0",8) //Data
            //
            cLINHA+=padr( alltrim(TIRACE( mNOME )), 40 )
            cLINHA+=padr( alltrim( mCODIGO ) , 20 )
            cLINHA+=left( strtran( mCLASSIPI, ".", "" ), 8 ) + "  "
//            cLINHA+=mCFO2
            cLINHA+=mCFO


            DO CASE
               CASE cPRE="S"
                    cLINHA+=cUNI01
               CASE ZUNID="CT"
                    cLINHA+=cUNI02
               CASE ZUNID="ML"
                    cLINHA+=cUNI03
               OTHERWISE
                    cLINHA+=cUNI04
            ENDCASE

            cLINHA+=mQTDE
            cLINHA+=mPRECO
            cLINHA+=mIPIS
            AADD(aLIN,cLINHA)
         endif
      endif
   enddo
   mVALOR     := strzero( ZTOT, 15, 2 )
   mVALOR     := strtran( mVALOR, ".", "" )
   mVIPI := strzero( ZTOTIPI, 15, 2 )
   mVIPI := strtran( mVIPI, ".", "" )
   FOR X=1 TO LEN(aLIN)
      FWRITE(USO,aLIN[X])
      fwrite( USO, space( 11 ) + "000" )     //20
      fwrite( USO, space( 11 ) + "000" )     //21
      fwrite( USO, space( 11 ) + "000" )     //22
      fwrite( USO, mVIPI )        //23
      fwrite( USO, mVALOR )       //24
      fwrite( USO, chr( 13 ) + chr( 10 ) )
      nREG ++
   NEXT X
   dbselectar( cARQ )
enddo
fwrite( USO, "9" )
fwrite( USO, strzero( nREG, 6 ) )
fwrite( USO, chr( 13 ) + chr( 10 ) )
fwrite( USO, chr( 26 ) )
dbcloseall()

*+ EOF: ITAMAM01.PRG
