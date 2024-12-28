// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_au.prg
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



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Criar Vars Sub Arquivos
CRIARVARS( "MA01" )
CRIARVARS( ARQWORK )
CRIARVARS( ARQ2 )
CRIARVARS( ARQ3 )
CRIARVARS( ARQ4 )
CRIARVARS( ARQI )

// Variaveis Auxiliares
xEMPFRETE  := OBTER( "MANEMP", ZNUMERO, "CUSFRETE" )
xCODIPI    := xCOTIN1 := xCOTIN2 := xNOME := xUNIDADE := ""
mTOTCUSTO  := XESTQINI := xCOTVAL := xCOTCO1 := xCOTCO2 := 0
xDATABALAN := xCOTDA1 := xCOTDA2 := CToD( Space( 8 ) )
zNOME      := ""
zNOMEOLD   := ""


mOBSERVA := mMATERIAL := mNOMEMAT := ""
ZNOME    := ""

// Senhas de Acesso
sMAU001 := SENHAX( cSEN + "001",, .F. )
sMAU002 := SENHAX( cSEN + "002",, .F. )
sMAU003 := SENHAX( cSEN + "003",, .F. )
sMAU005 := SENHAX( cSEN + "005",, .F. )
sMAU006 := SENHAX( cSEN + "006",, .F. )
PRIV mVALIPI
PRIV mVALFRE

aTELMAU := TELAPEG( "MAU001" )

PADRAO( 0, 1, 0, ARQWORK, "C¢digo        Nome" + spac( 37 ) + "Estoque", ;
      "' '+mCODIGO+' '+STR(mESTQSAL, 10, 3)+' '+mNOME+' '+mNOM2", ;
      "MAU", {|| TELASAY( aTELMAU ) }, {|| GMAU() },,, {| nKEY | MAUKEY( nKEY ) }, {|| MAUIGU() }, {|| MAUKEYROD() }, ;
      ,,, {|| MAUDEL() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUKEY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAUKEY( nKEY )

   DO CASE
   CASE nKEY = K_ALT_F1
      mCODIGO := aPAD2[ pPAD ]
      xCODIGO := mCODIGO
      PEGACAMPO( ARQWORK, "xCODIGO", { "NOME", "UNIDADE" }, { "xNOME", "xUNIDADE" } )
      PADRAO( 1, 1, 0, ARQ2, "C¢digo:  Descri‡„o:" + spac( 21 ) + "Unidade:", ;
         "' '+mCODIGO+' '+mNOME+' '+STR(mCOTFORN)+' '+mCOTCOGN", ;
         "MAU2",,, {|| IMAU3() }, {|| PADARR( ARQ2, xCODIGO, "CODIGO", "XCODIGO" ) },, ;
         {|| iMAU2() } )
   CASE nKEY = K_ALT_F2
      mCODIGO := aPAD2[ pPAD ]
      xCODIGO := mCODIGO
      PEGACAMPO( ARQWORK, "xCODIGO", { "NOME", "UNIDADE" }, { "xNOME", "xUNIDADE" } )
      PADRAO( 1, 1, 0, ARQ3, "C¢digo   T Cliente" + spac( 12 ) + "NF Ent.  Saldo", ;
         "' '+mCODIGO+' '+mTIPOCLI+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mNRNOTAINI,8)+' '+STR(mTOTKGEST,9,2)", "MAU3", "MAU301", "MAU301", ;
         {|| iMAU3() }, {|| PADARR( ARQ3, xCODIGO, "CODIGO", "XCODIGO" ) } ;
         ,,,,, {|| MAU301( ARQ3, ARQ3BX ) } )

   CASE nKEY = K_ALT_F4
      IF sMAU005
         xARQWORK := ARQWORK
         ARQWORK  := ARQ9
         mCODIGO  := aPAD2[ pPAD ]
         M_AS99( 0 )
         ARQWORK := xARQWORK
      ENDIF
   CASE nKEY = K_ALT_F5
      mCODIGO := aPAD2[ pPAD ]
      xCODIGO := mCODIGO
      M_AU4( ARQ4, STR4 )
   CASE nKEY = K_ALT_F6
      mCODIGO := aPAD2[ pPAD ]
      xCODIGO := mCODIGO
      PADRAO( 1, 1, 0, ARQWORK + "I", "Codigo" + spac( 19 ) + "Ite Tip Especificado", ;
         "' '+mCODIGO+' '+STR(mITEM,  3)+' '+mTIPA+' '+mESPE", ;
         "MSI",,, {|| mCODIGO := xCODIGO }, {|| PADARR( ARQWORK + "I", xCODIGO, "CODIGO", "xCODIGO" ) } )
   ENDCASE
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUIGU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAUIGU()

   IF INCLUI
      EMAILINT( "INC00001", mCHAVE )
      mFREPES    := 'S'
      mDATABALAN := ZDATA
      nDATMIN    := ZDATA
   ENDIF
   xESTQINI   := mESTQINI
   xCOTVAL    := mCOTVAL
   xCOTIN1    := mCOTIN1
   xCOTDA1    := mCOTDA1
   xCOTCO1    := mCOTCO1
   xCOTIN2    := mCOTIN2
   xCOTDA2    := mCOTDA2
   xCOTCO2    := mCOTCO2
   xCODIPI    := mCODIPI
   xDATABALAN := mDATABALAN
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUKEYROD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAUKEYROD()

   @ 23, 00 SAY "ALT+ F1=Pre‡o F2=Remes F4=Mov.Esqt. F5=Medio F6=Ensaio"
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUDEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAUDEL()

   EMAILINT( "DEL00001", mCHAVE )
   PADDEL( ARQ2, mCODIGO, "CODIGO", "mCODIGO" )
   PADDEL( ARQ4, mCODIGO, "CODIGO", "mCODIGO" )
   PADDEL( ARQI, mCODIGO, "CODIGO", "mCODIGO" )
   maupe( "DEL" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mAUPE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mAUPE( cTIPO )

   LOCAL cTEXTO

   cTEXTO := Chr( 13 ) + Chr( 10 ) + "Atual:" + AllTrim( ZNOME )
   cTEXTO += Chr( 13 ) + Chr( 10 ) + "Antigo:" + AllTrim( ZNOMEOLD )
   WHILE !USEMULT( { { "MW02", 1, 99 }, { "PE", 1, 99 }, { "PE01", 1, 99 } } )
   ENDDO
   dbSelectAr( "PE" )
   dbSetOrder( 3 )
   dbGoTop()
   dbSeek( AllTrim( mCODIGO ) )
   WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
      nPE := PEDIDO
      netreclock()
      field->COMPRAS   := 0
      field->COMITEM   := 0
      field->fornecedo := 0
      field->cognome   := ""
      field->NOME      := ""
      field->NOM2      := ""
      dbUnlock()
      dbSelectAr( "PE01" )
      dbGoTop()
      dbSeek( Str( nPE, 5 ) )
      WHILE nPE = PEDIDO .AND. !Eof()
         netreclock()
         field->NOME := ""
         field->NOM2 := ""
         dbUnlock()
         dbSkip()
      ENDDO
      dbSelectAr( "PE" )
      IF cTIPO = "DEL"
         EMAILINT( "DEL00002", "PE:" + Str( PEDIDO ) )
      ELSE
         EMAILINT( "MUD00002", "PE:" + Str( PEDIDO ) + cTEXTO )
      ENDIF
      dbSkip()
   ENDDO
   dbSelectAr( "MW02" )
   dbSetOrder( 3 )
   dbGoTop()
   dbSeek( AllTrim( mCODIGO ) )
   WHILE AllTrim( mCODIGO ) = AllTrim( ITECOD ) .AND. !Eof()
      netreclock()
      IF cTIPO = "DEL"
         FIELD->ITETIP := ""
      ENDIF
      field->ITECOD := "**" + ITECOD
      field->ITENOM := "**" + ITENOM
      dbUnlock()
      IF cTIPO = "DEL"
         EMAILINT( "DEL00003", "Pedido" + Str( COMPED, 8 ) + Str( ITEM, 3 ) )
      ELSE
         EMAILINT( "MUD00003", "Pedido" + Str( COMPED, 8 ) + Str( ITEM, 3 ) + cTEXTO )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAU

// Get nas Menvars
   zNOME    := PadR( mNOME + mNOM2, 100 )
   zNOMEOLD := PadR( mNOME + mNOM2, 100 )
   IF sMAU001
      @  2, 02 GET mCODIGO
      @  3, 02 GET zNOME   PICT "@S76"
   ELSE
      @  2, 02 SAY mCODIGO
      @  2, 25 SAY mNOME
      @  3, 25 SAY mNOM2
   ENDIF
   @  4, 15 GET mDIMX      PICT '999999.99'
   @  4, 33 GET mDIMY      PICT '999999.99'
   @  4, 54 GET mDIMZ      PICT '999999.99'
   @  4, 70 GET mPESLIQ
   @  5, 12 GET mAPLICACAO PICT "@S25"
   @  6, 12 GET mINSTRU    PICT "@S25"
   IF ZLANC = 0
      @  6, 39 GET mCTACONTB PICT ZPICCC VALID CHECKCC()
   ELSE
      @  6, 39 GET mCTACONTB VALID CHECKCC()
   ENDIF
   @  6, 55 GET mLOCACAO
   @  6, 70 GET mUNIDADE  VALID CHECKEXI( "MD07", "mUNIDADE", "UNIDADE+' '+UNIDDES", "UNIDADE", "UNIDADE" )
   @  6, 73 GET mCODIPI   VALID CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI" )
   @  7, 65 GET mCLASSIPI WHEN Empty( mCODIPI )                                                         VALID CHECKIPI( mCLASSIPI )
   READCUR()
   mNOME := SubStr( zNOME, 1, 50 )
   mNOM2 := SubStr( zNOME, 51 )

// Altera Pre‡o
   IF sMAU002
      @  9, 14 GET mCOTFORN PICT '99999'        VALID ALLTRUE( PEGACAMPO( "MB01", "mCOTFORN", "COGNOME", "mCOTCOGN" ) )
      @  9, 20 GET mCOTCOGN
      @  9, 41 GET mCOTDATA
      @  9, 58 GET mCOTCONT
      @ 12, 2  GET mCOTVAL  PICT "999999999.99" VALID MAUK01() .AND. ;
         CONVTAB( mCOTIN1,, mCOTDA1, "mCOTIV1", mCOTVAL, "mCOTCO1", 6, 12, 38, "@E 99999.999999", 12, 54, "@E 99999.999999" ) .AND. ;
         CONVTAB( mCOTIN2,, mCOTDA2, "mCOTIV2", mCOTVAL, "mCOTCO2", 6, 13, 38, "@E 99999.999999", 13, 54, "@E 99999.999999" )
      @ 12, 15 GET mCOTIN1 VALID CONVTAB( mCOTIN1,, mCOTDA1, "mCOTIV1", mCOTVAL, "mCOTCO1", 6, 12, 38, "@E 99999.999999", 12, 54, "@E 99999.999999" )
      @ 12, 28 GET mCOTDA1 VALID CONVTAB( mCOTIN1,, mCOTDA1, "mCOTIV1", mCOTVAL, "mCOTCO1", 6, 12, 38, "@E 99999.999999", 12, 54, "@E 99999.999999" )
      @ 13, 15 GET mCOTIN2 VALID CONVTAB( mCOTIN2,, mCOTDA2, "mCOTIV2", mCOTVAL, "mCOTCO2", 6, 13, 38, "@E 99999.999999", 13, 54, "@E 99999.999999" )
      @ 13, 28 GET mCOTDA2 VALID CONVTAB( mCOTIN2,, mCOTDA2, "mCOTIV2", mCOTVAL, "mCOTCO2", 6, 13, 38, "@E 99999.999999", 13, 54, "@E 99999.999999" )
      IF sMAU002
         @ 15, 7  GET mIPI    PICT "99.99"           VALID MAUK01()
         @ 15, 17 GET mVALIPI PICT "@E 9,999,999.99" VALID MAUK01()
         @ 15, 36 GET mFREPES PICT "!"               VALID mFREPES $ 'SN' .AND. MAUK01()
         @ 15, 40 GET mVALFRE PICT "@E 9,999,999.99" VALID MAUK01()
      ENDIF
   ENDIF
   READCUR()

// Altera Estoque
   IF sMAU003
      @ 17, 22 GET mCONSIG    PICT "!"            VALID mCONSIG $ "SN"
      @ 18, 12 GET mESTQINI   PICT '99999999.999' VALID MAUK02()
      @ 19, 12 GET mESTQENT   PICT '99999999.999' VALID MAUK02()
      @ 20, 12 GET mESTQSAI   PICT '99999999.999' VALID MAUK02()
      @ 18, 28 GET mDATABALAN
      @ 19, 28 GET mVALINV
      @ 19, 65 GET mDIASENT   PICT '99999999'
      @ 20, 65 GET mDIASEST   PICT '99999999'
      @ 22, 12 GET mESTQMIN   PICT '99999999.999'
      @ 22, 27 GET mCCM       PICT '9999,999.999'
      @ 22, 41 GET mMINDI     PICT '9999,999.999'
      @ 22, 54 GET mMININD    PICT '9999,999.999'
      @ 22, 67 GET mCAUTO     PICT '9999,999.999'
      READCUR()
   ENDIF
   IF zNOME # zNOMEOLD
      maupe( "MUD" )
      ALERTX( "Troca de Nome" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAUK01

   mVALIPI  := Round( mCOTVAL * mIPI / 100, 2 )
   mVALFRE  := if( mFREPES = 'S', Round( mPESLIQ * xEMPFRETE, 2 ), 0.00 )
   mPRECUST := mCOTVAL + mVALIPI + mVALFRE
   IF sMAU002
      @ 15, 58 SAY mPRECUST PICT "@E 9,999,999.99"
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUK02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAUK02( cPICT )

   IF ValType( cPICT ) # "C"
      cPICT := '@E 99,999,999.999'
   ENDIF
   IF xESTQINI # mESTQINI
      GRAVALOG( mCHAVE + "_" + Str( xESTQINI ), "ETQ", "ESTQINI" )
      GRAVALOG( mCHAVE + "_" + Str( mESTQENT ), "ETQ", "ESTQENT" )
      GRAVALOG( mCHAVE + "_" + Str( mESTQSAI ), "ETQ", "ESTQSAI" )
      mESTQENT := 0
      mESTQSAI := 0
      GRAVALOG( mCHAVE + "_" + Str( mESTQINI ), "ETQ", "ESTQINI" )
      xESTQINI := mESTQINI
   ENDIF
   IF xDATABALAN # mDATABALAN
      mDATMIN := mDATABALAN
      mSAIMIN := 0.00
   ENDIF
   mESTQSAL := mESTQINI + mESTQENT - mESTQSAI
   @ 19, 12 SAY mESTQENT PICT cPICT
   @ 20, 12 SAY mESTQSAI PICT cPICT
   @ 21, 12 SAY mESTQSAL PICT cPICT
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCINV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCINV( cTIPO )

   MDI( "Calculando Valor Inventario" )
   nFATOR := 0.8200
   MDS( "Digite o Fator" )
   @ 24, 20 GET nFATOR
   IF !READCUR()
      RETU .F.
   ENDIF
   IF !USEREDE( ESTQARQ( cTIPO, 1 ), 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY CODIGO
      netreclock()
      IF ULTPRC > 0
         FIELD->VALINV := ULTPRC * nFATOR
      ELSE
         IF PRECUST > 0
            FIELD->VALINV := ULTPRC * nFATOR
         ENDIF
      ENDIF
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseArea()


// + EOF: m_au.prg
// +
