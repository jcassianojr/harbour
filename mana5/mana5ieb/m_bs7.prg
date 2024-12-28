// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bs7.prg
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
// +    Source Module => J:\ITAESBRA\M_BS7.PRG
// +
// +    Functions: Function MBS0701()
// +               Function MBS0702()
// +
// +       Tables: use &cARQ. NEW
// +               use &cARQ. NEW
// +
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

MDI( " н Resumos Anuais" )

IF MDG( "Acumular Empresa Anual/G1" )
SOMAANO( "APU5EMP", "A1", "PADRAO",,,,,,, {| cARQ | MBS0703( cARQ ) } )
ENDIF

IF MDG( "Acumular 2 Maiores Clientes" )
IF !USEREDE( "APU5EMP", 1, 2 )
RETU .F.
ENDIF
ZAPARQ( { { "APU5EM2", .F., .T. } } )
dbSelectAr( "APU5EMP" )
dbGoTop()
WHILE !Eof()
mMES     := MES
mANO     := ANO
mCLI1    := 0
mCOGCLI1 := ""
mPRECLI1 := 0
mCLI2    := 0
mCOGCLI2 := ""
mPERCLI2 := 0
WHILE mMES = MES .AND. mANO = ANO .AND. !Eof()
IF Empty( mCLI1 ) .AND. Empty( TGRUPO )
mCLI1    := CLIENTE
mCOGCLI1 := COGCLI
mPERCLI1 := PERCLI
ELSE
IF Empty( mCLI2 ) .AND. Empty( TGRUPO )
mCLI2    := CLIENTE
mCOGCLI2 := COGCLI
mPERCLI2 := PERCLI
ENDIF
ENDIF
dbSelectAr( "APU5EMP" )
dbSkip()
ENDDO
mJUNTO := StrZero( mMES, 2 ) + "/" + StrZero( mANO, 4 ) + "  " + PadR( mCOGCLI1, 7 ) + " " + PadR( mCOGCLI2, 7 )
NOVOOPA( "APU5EM2" )
dbSelectAr( "APU5EMP" )
ENDDO
dbCloseAll()
ENDIF

IF MDG( "Relatorio Receita" )
IMPREL( "MA", "MA_00013", "MANREL", "MANRE1" )
ENDIF

IF MDG( "Relatorio Melhores Clientes" )
IMPREL( "MA", "MA_00014", "MANREL", "MANRE1" )
ENDIF

IF MDG( "Acumular Produtos" )
SOMAANO( "APU5G", "A", "PADRAO",,,,,,, {| cARQ | MBS0703( cARQ ) } )
ENDIF


IF MDG( "Acumular Graficos G4" )
SOMAANO( "APU5G4", "A4", "PADRAO",,,,,,, {| cARQ | MBS0703( cARQ ) } )
ENDIF


IF MDG( "Apurar Produtos A4" )
SOMAANO( "APU5CD2", "A4", "PADRAO", {| nMES, nANO, cARQ, cARQREF | MBS0702( nMES, nANO, cARQ, cARQREF ) },,,,,, )
ENDIF

IF MDG( "Apurar Resumo Linha" )
// IF USEREDE("APU5LIN",0,99)
// ZAP
// DBCLOSEALL()
// ENDIF
SOMAANO( "APU5LIN", "A1", "PADRAO", {| nMES, nANO, cARQ, cARQREF | MBS0704( nMES, nANO, cARQ, cARQREF ) },,,,,, )
IF USEREDE( "APU5LIN", 0, 99 )
dbGoTop()
WHILE !Eof()
mANO    := ANO
mTOTAL  := 0
nREGINI := RecNo()
WHILE mANO = ANO .AND. !Eof()
mTOTAL += VALORTOT
dbSkip()
ENDDO
nREGDEP := RecNo()
dbGoto( nREGINI )
WHILE mANO = ANO .AND. !Eof()
FIELD->PERFAT := perc( VALORTOT, mTOTAL )
dbSkip()
ENDDO
dbGoto( nREGDEP )
ENDDO
dbCloseArea()
ENDIF
ENDIF


IF MDG( "Relatorio Melhores Itens" )
IMPREL( "MA", "MA_00015", "MANREL", "MANRE1" )
ENDIF


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MBS0702()
// +
// +    Called from ( m_bs7.prg    )   1 - function mbs601()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBS0702()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBS0702( nMES, nANO, cARQ, cARQREF )

   cARQA := cARQ
   cARQ  := "GRAFICOS\" + cARQ
   IF !useCHK( cARQ,, .T. )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "100-PERLUC" )
   ordSetFocus( "temp" )
// index on PERLUC to GRAFICOS\TEMP DESCE  eval zei_fort(nLASTREC,,,1)

   dbGoTop()
   mANO    := nANO
   mMES    := nMES
   mJUNTO  := StrZero( mMES, 2 ) + "/" + Right( StrZero( mANO, 4 ), 2 ) + " " + Left( JUNTO, 25 )
   mJUNTOA := Left( JUNTO, 25 )
   mPERCOM := PERLUC
   mINTCOM := PERLUC * 1000
   dbSkip()
   mJUNTO   += Left( JUNTO, 25 )
   mJUNTOB  := Left( JUNTO, 25 )
   mPERCOM2 := PERLUC
   mINTCOM2 := PERLUC * 1000
   dbSkip()
   mJUNTO   += Left( JUNTO, 25 )
   mJUNTOC  := Left( JUNTO, 25 )
   mPERCOM3 := PERLUC
   mINTCOM3 := PERLUC * 1000
   dbCloseArea()
   NOVOOPA( cARQREF )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBS0703()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBS0703( cARQ )

   RETU usechk( "GRAFICOS\" + cARQ,, .T. )


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MBS0704()
// +
// +    Called from ( m_bs7.prg    )   1 - function mbs601()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBS0704()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBS0704( nMES, nANO, cARQ, cARQREF )

   cARQA := cARQ
   cARQ  := "GRAFICOS\" + cARQ
   mANO  := nANO

   IF nMES = 1   // Janeiro Reacumula Apaga Anual
      dbSelectAr( "APU5LIN" )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netrecdel() }, {|| ANO = nANO }, {|| zei_fort( nLASTREC,,, 1 ) } )
   ENDIF

   IF !userede( "MA01", 1, 1 )
      RETU .F.
   ENDIF
   IF !usechk( cARQ,, .T. )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      mSUBGER := SUBGER
      IF Empty( SUBGER )
         mCLIENTE := CLIENTE
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( mCLIENTE )
            mSUBGER := SUBGER
            IF Empty( SUBGER )
               ALERTX( "Cliente Sem Grupo" + Str( mCLIENTE, 8 ) )
            ENDIF
         ELSE
            IF mCLIENTE < 99990000
               ALERTX( "Cliente NЦo Cadastrado" + Str( mCLIENTE, 8 ) )
            ENDIF
         ENDIF
         dbSelectAr( cARQA )
         IF !Empty( mSUBGER )
            NETGRVCAM( "SUBGER", mSUBGER )
         ENDIF
      ENDIF
      dbSelectAr( cARQA )
      mVALORTOT := VALORTOT
      IF CLIENTE < 99990000
         IF !NOVOOPE( "APU5LIN", Str( mANO, 4 ) + mSUBGER )
            FIELD->VALORTOT := VALORTOT + mVALORTOT
         ENDIF
      ENDIF
      dbSelectAr( cARQA )
      dbSkip()
   ENDDO
   dbCloseArea()
   dbSelectAr( "MA01" )
   dbCloseArea()
   RETU .T.

// + EOF: M_BS7.PRG

// + EOF: m_bs7.prg
// +
