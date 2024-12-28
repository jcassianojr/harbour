// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aox.prg
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


MDI( " Ý Remanejamento de Ordem de Fabricacao" )

cCODIGO   := Space( 24 )
cTIPO     := "F"
cCONTINUA := "N"
cUNID     := " "
aOFTMP    := {}
aOFOK     := {}
mGERAOF   := ""

TELASAY( "MAOX01" )
EDITSAY( "MAOX01" )

IF cCONTINUA = "N"
RETU
ENDIF

cCODIGO := AllTrim( cCODIGO )
DO CASE
CASE cTIPO = "X" .AND. cCODIGO = "TODOS"
dDATMAX := ZDATA
MDS( "Data Limite" )
@ 24, 40 GET dDATMAX
IF !READCUR()
RETU .F.
ENDIF
APGPR2(, .F. )
IF !USEREDE( "MO02", 1, 1 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
IF ENTREGA <= dDATMAX .AND. QTDESAL > 0
AAdd( aOFTMP, { OS, ENTREGA } )
ENDIF
dbSkip()
ENDDO
dbCloseArea()
CASE cTIPO = "X"
MAOX01( "MO02", cCODIGO, 3 )
CASE cTIPO = "F"
MAOX01( "OF01", cCODIGO )
// CASE cTIPO="S" ; MAOX01("OR01",cCODIGO)
OTHERWISE
MAOX01( TIPORR( cTIPO, 1 ), cCODIGO )
ENDCASE

IF Empty( aOFTMP )
RETU
ENDIF


TEMPDBF := TMPFILE( "DBF" )
TEMPDBF := SubStr( TEMPDBF, 1, At( ".", TEMPDBF ) - 1 )
aESTRU  := { { "OF", "N", 12, 2 }, { "DLIMITE", "D", 8, 0 }, { "CLIENTE", "N", 8, 0 }, { "COGNOME", "C", 12, 0 } }
dbCreate( TEMPDBF, aESTRU )

IF !USECHK( TEMPDBF,, .F. )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "of" )
ordSetFocus( "temp" )
FOR W := 1 TO Len( aOFTMP )
dbGoTop()
IF !dbSeek( aOFTMP[ W, 1 ] )
netrecapp()
FIELD->OF      := aOFTMP[ W, 1 ]
FIELD->DLIMITE := aOFTMP[ W, 2 ]
AAdd( aOFOK, OF )
ENDIF
NEXT W
dbCloseArea()


CRIARVARS( "OF01" )
CRIARVARS( "OF02" )
CRIARVARS( "OR01" )


IF cTIPO = "X" .AND. cCODIGO = "TODOS"
ZAPARQ( { { "OF03", .T., .F. }, { "OR01BX", .T., .F. }, { "OR02BX", .T., .F. }, ;
         { "OR03BX", .T., .F. }, { "OR04BX", .T., .F. }, { "OR05BX", .T., .F. }, ;
         { "OR06BX", .T., .F. }, { "OR07BX", .T., .F. }, { "OR08BX", .T., .F. }, ;
         { "OR09BX", .T., .F. }, { "OR10BX", .T., .F. }, { "OR11BX", .T., .F. }, ;
         { "OR17BX", .T., .F. }, { "OR18BX", .T., .F. }, ;
         { "OR12BX", .T., .F. }, { "OR15BX", .T., .F. }, { "OR16BX", .T., .F. } } )
ZAPARQ( { { "OF01", .F., .T. }, { "OF02", .F., .T. }, { "OR01", .F., .T. }, { "OR02", .F., .T. }, ;
         { "OR03", .F., .T. }, { "OR04", .F., .T. }, { "OR05", .F., .T. }, ;
         { "OR06", .F., .T. }, { "OR07", .F., .T. }, { "OR08", .F., .T. }, ;
         { "OR09", .F., .T. }, { "OR10", .F., .T. }, { "OR11", .F., .T. }, ;
         { "OR17", .F., .T. }, { "OR18", .F., .T. }, ;
         { "OR12", .F., .T. }, { "OR15", .F., .T. }, { "OR16", .F., .T. } } )
IF !USECHK( TEMPDBF,, .F. )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "DLIMITE" )
ordSetFocus( "temp" )
ELSE
PRIV aCOMP := {}
PRIV aCHAV := {}
IF !USEMULT( { { "OF01", 1, 99 }, { "OF02", 1, 99 }, { "MO01", 1, 1 } } )
RETU .F.
ENDIF
IF !USECHK( TEMPDBF,, .F. )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "DLIMITE" )
ordSetFocus( "temp" )
dbSelectAr( TEMPDBF )
dbGoTop()
WHILE !Eof()
@ 22, 2 SAY "Aguarde Apagando ordem de Fabricacao ->" + Str( OF, 8, 2 )
mOS      := OF
mOF      := OF
mCOGNOME := Space( 20 )
mCLIENTE := 0
mITEM    := 1
dbSelectAr( "MO01" )
dbGoTop()
IF dbSeek( mOS )
mCOGNOME := COGNOME
mCLIENTE := FORNECEDO
ENDIF
dbSelectAr( TEMPDBF )
IF !Empty( mCLIENTE )
FIELD->COGNOME := mCOGNOME
FIELD->CLIENTE := mCLIENTE
ENDIF
dbSelectAr( "OF01" )
dbGoTop()
IF dbSeek( Str( mOS, 8, 2 ) + Str( mITEM, 3 ) )
mCODIGO := CODIGO
DELEREG(,,, .F. )
TEMPCO := mCODIGO  // Salvando Variaveis
TEMPOS := mOF
TEMPIT := mITEM
MDS( "Apagando Composicao da Ordem de Fabricacao" )
dbSelectAr( "OF02" )
dbGoTop()
dbSeek( Str( mOF, 8, 2 ) + Str( mITEM, 3 ) )
WHILE TEMPOS = OF .AND. TEMPIT = ITEM .AND. !Eof()
IF TIPCOMP $ "PMCEHTOS"
nPOS := AScan( aCHAV, TIPCOMP + CODCOMP )
IF nPOS = 0
AAdd( aCOMP, { CODCOMP, TIPCOMP } )   // Guardando Composicao para apagar reserva
AAdd( aCHAV, TIPCOMP + CODCOMP )
ENDIF
ENDIF
DELEREG(,, .T., .F. )
ENDDO
nPOS := AScan( aCHAV, "S" + TEMPCO )
IF nPOS = 0
AAdd( aCOMP, { TEMPCO, "S" } )  // Guardando Composicao para apagar reserva
AAdd( aCHAV, "S" + TEMPCO )
ENDIF
ENDIF
dbSelectAr( TEMPDBF )
dbSkip()
ENDDO
dbSelectAr( "OF01" )
dbCloseArea()
dbSelectAr( "OF02" )
dbCloseArea()
dbSelectAr( "MO01" )
dbCloseArea()



FOR W := 1 TO Len( aCOMP )
zTCOD := aCOMP[ W, 1 ]
MAOFDELX( TIPORR( aCOMP[ W, 2 ], 1 ) )  // Reserva
MAOFDELX( TIPORR( aCOMP[ W, 2 ], 1 ) + "BX" )   // Reserva Baixada
MAOFDELX( TIPORR( aCOMP[ W, 2 ], 2 ) )  // Necessidade
MAOFDELX( TIPORR( aCOMP[ W, 2 ], 2 ) + "BX" )   // Necessidade Baixada
NEXT W
ENDIF


IF !USEMULT( { { "MO02", 1, 99 }, { "OF01", 1, 99 }, { "OF02", 1, 99 }, ;
         { "OR01", 1, 99 }, { "OR02", 1, 99 }, { "OR03", 1, 99 }, ;
         { "OR04", 1, 99 }, { "OR05", 1, 99 }, { "OR06", 1, 99 }, ;
         { "MS03", 1, 99 }, { "MS01", 1, 99 }, { "OR07", 1, 99 }, ;
         { "OR08", 1, 99 }, { "OR09", 1, 99 }, { "OR10", 1, 99 }, ;
         { "OR11", 1, 99 }, { "OR12", 1, 99 }, { "OR15", 1, 99 }, ;
         { "OR16", 1, 99 }, { "MO01", 1, 99 } } )
RETU .F.
ENDIF

dbSelectAr( TEMPDBF )
dbGoTop()
WHILE !Eof()
@ 22, 2 SAY "Aguarde Reprocessando ordem de Fabricacao ->" + Str( OF, 8, 2 ) + " " + DToS( DLIMITE )
mOS      := OF
mOF      := OF
mITEM    := 1
mCLIENTE := CLIENTE
mCOGNOME := COGNOME
mCODIGO  := ""
mQPEDIDO := 0
dbSelectAr( "MO02" )
dbGoTop()
IF dbSeek( Str( mOF, 8, 2 ) + Str( mITEM, 2 ) )
mCODIGO  := CODIGO
mQPEDIDO := CONVUN( QTDESAL, UNID )
ENDIF
IF mQPEDIDO > 0
MAOF03(, .F., .T. )
ENDIF
dbSelectAr( TEMPDBF )
dbSkip()
ENDDO
dbCloseAll()
DELETEFILE( TEMPDBF + ".DBF" )
FErase( TEMPDBF + "." + cRDDEXT )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOX01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAOX01( cARQ, cCODIGO, nIND )

   IF ValType( nIND ) # "N"
      nIND := 3
   ENDIF
   WHILE !USEREDE( cARQ, 1, nIND )
   ENDDO
   dbGoTop()
   dbSeek( cCODIGO )
   WHILE AllTrim( cCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
      DO CASE
      CASE cARQ = "MO02"
         AAdd( aOFTMP, { OS, ENTREGA } )
      CASE cARQ = "OR01" .OR. cARQ = "OF01"
         AAdd( aOFTMP, { OF, DLIMITE } )
      OTHERWISE
         AAdd( aOFTMP, { OS, DLIMITE } )
      ENDCASE
      dbSkip()
   ENDDO
   dbCloseArea()
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOFDELX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOFDELX( cARQDEL )

   WHILE !USEREDE( cARQDEL, 1, 99 )
   ENDDO
   dbGoTop()
   dbSeek( PadR( zTCOD, 24 ) )
   WHILE AllTrim( zTCOD ) = AllTrim( CODIGO ) .AND. !Eof()
      nPOS := AScan( aOFOK, OS )
      IF nPOS > 0
         @ 22, 2 SAY "Apagando Componente -> " + Str( OS, 8, 2 ) + " " + CODIGO
         DELEREG(,,, .F. )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function APGPR2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC APGPR2( nUSO, lEST )  // Saldo Processo

   IF ValType( nUSO ) # "N"
      nUSO := 1
   ENDIF
   IF ValType( lEST ) # "L"
      lEST := .T.
   ENDIF
   IF nUSO = 1
      APGPRO( "MT01" )
      APGPRO( "MU01" )
   ENDIF
   APGPRO( "MP01" )
   APGPRO( "MP02" )
   APGPRO( "MP03" )


   aPRO := {}
   IF !USEREDE( "MO02", 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      nPOS := AScan( aPRO, CODIGO )
      IF nPOS = 0
         AAdd( aPRO, CODIGO )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !USEMULT( { { "MS03", 1, 1 }, { "MS06", 1, 1 } } )
      dbCloseAll()
      RETU .F.
   ENDIF
   FOR X := 1 TO Len( aPRO )
      mCODIGO := AllTrim( aPRO[ X ] )
      MDS( mCODIGO )
      aGRU := {}
      dbSelectAr( "MS03" )
      dbGoTop()
      dbSeek( mCODIGO )
      WHILE mCODIGO = AllTrim( CODIGO ) .AND. !Eof()
         mBSEQ := BSEQ
         mBSSQ := BSSQ
         IF !Empty( MBSEQ ) .AND. !Empty( MBSSQ )
            mTIP  := TIPOENT
            mCOM  := CODCOMP
            mFAT  := QTDDE
            nQTDE := 0
            lSOMA := .T.
            @ 24, 30 SAY mBSEQ
            @ 24, 35 SAY mBSSQ
            @ 24, 40 SAY mCOM
            dbSelectAr( "MS06" )
            dbGoTop()
            dbSeek( PadR( mCODIGO, 24 ) + Str( mBSEQ, 3 ) + Str( mBSSQ, 3 ) )
            WHILE mCODIGO = AllTrim( CODIGO ) .AND. !Eof()
               IF TIPFEC = "8" .OR. TIPFEC = "9"
                  lSOMA := .T.
               ENDIF
               IF TIPFEC = "7" .OR. SSQ = 99
                  lSOMA := .F.
               ENDIF
               IF lSOMA .AND. PULREQ # "S"
                  nQTDE += ESTQSAL
               ENDIF
               dbSkip()
            ENDDO
            IF nQTDE > 0
               IF mTIP <> "I"  // Nao E instrumento
                  IF lEST
                     mESTQPRO := OBTER( ESTQARQ( mTIP, 1 ), mCOM, "ESTQPRO" ) + Round( nQTDE * mFAT, 3 )
                  ELSE
                     mESTQPRO := Round( nQTDE * mFAT, 3 )
                  ENDIF
                  GRAVAMVAR( ESTQARQ( mTIP, 1 ), mCOM, "ESTQPRO", "mESTQPRO",, .F. )
               ENDIF
            ENDIF
         ENDIF
         dbSelectAr( "MS03" )
         dbSkip()
      ENDDO
   NEXT X
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function APGPRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC APGPRO( cARQ )

   MDS( "Apagando Estoque de Processos " + caRQ )
   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      netgrvcam( "ESTQPRO", 0 )
      dbSkip()
   ENDDO
   dbCloseArea()
   RETU .T.

// + EOF: m_aox.prg
// +
