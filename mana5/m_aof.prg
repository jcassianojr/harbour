// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aof.prg
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

PADRAX( 0,, 0, { "OF01", "OF02", "OR01" }, "Ord.Fab  Cliente" + spac( 12 ) + "Codigo" + spac( 19 ) + "Saldo" + spac( 6 ) + "Limite", ;
      "' '+STR(mOF,  8, 2)+' '+STR(mCLIENTE,  5)+' '+mCOGNOME+' '+mCODIGO+' '+STR(mQSALDO, 10, 3)+' '+DTOC(mDLIMITE)", "MAOF01", "MAOF01", ;
      , {|| MAOFDEL() }, {|| MAOF01() },, "MAOF",,,, {|| MAOF03( mOF ) },, )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOFDEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAOFDEL( lABRIR )

   IF ValType( lABRIR ) <> "L"
      lABRIR := .T.
   ENDIF
   TEMPCO := mCODIGO   // Salvando Variaveis
   TEMPOS := mOF
   TEMPIT := mITEM
   PRIV aCOMP := {}
   MDS( "Apagando Composicao da Ordem de Fabricacao" )
   IF lABRIR
      WHILE !USEREDE( "OF02", 1, 99 )
      ENDDO
   ELSE
      dbSelectAr( "OF02" )
   ENDIF
   dbGoTop()
   dbSeek( Str( mOF, 8, 2 ) + Str( mITEM, 3 ) )
   WHILE TEMPOS = OF .AND. TEMPIT = ITEM .AND. !Eof()
      IF TIPCOMP $ "PMCEHTOS"
         AAdd( aCOMP, { CODCOMP, TIPCOMP } )   // Guardando Composicao para apagar reserva
      ENDIF
      DELEREG(,, .T., .F. )
   ENDDO
   IF lABRIR
      dbCloseArea()
   ENDIF

   MDS( "Apagando Reserva e Necessidades" )
   FOR W := 1 TO Len( aCOMP )
      zTCOD := aCOMP[ W, 1 ]
      MAOFDELC( TIPORR( aCOMP[ W, 2 ], 1 ) )   // Reserva
      MAOFDELC( TIPORR( aCOMP[ W, 2 ], 1 ) + "BX" )  // Reserva Baixada
      MAOFDELC( TIPORR( aCOMP[ W, 2 ], 2 ) )   // Necessidade
      MAOFDELC( TIPORR( aCOMP[ W, 2 ], 2 ) + "BX" )  // Necessidade Baixada
   NEXT W


   MDS( "Apagando Reserva de Produto" )
   zTCOD := TEMPCO
   MAOFDELC( "OR01" )
   MAOFDELC( "OR01BX" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOFDELC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOFDELC( cARQDEL )

   IF cARQDEL = "XXXX"
      RETU .T.
   ENDIF
   WHILE !USEREDE( cARQDEL, 1, 99 )
   ENDDO
   dbGoTop()
   dbSeek( PadR( zTCOD, 24 ) + Str( TEMPOS, 8, 2 ) )
   WHILE AllTrim( zTCOD ) = AllTrim( CODIGO ) .AND. OS = TEMPOS .AND. !Eof()
      DELEREG(,, .T., .F. )
   ENDDO
   dbCloseArea()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOF01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOF01

   IF MDG( "Checar Composicao Ordem Fabricacao" )
      xOF     := mOF
      xITEM   := mITEM
      xCODIGO := mCODIGO
      xQUSO   := mQSALDO
      PADRAO( 1, 1, 0, "OF02", "Ordem Fabr.  Codigo" + spac( 19 ) + "Componente    Quantidade", ;
         "' '+STR(mOF,  8, 2)+' '+STR(mITEM,  3)+' '+mCODIGO+' '+mTIPCOMP+' '+mCODCOMP+' '+STR(mQTTOT, 12, 4)", ;
         "MF2", "MAOF21", "MAOF21", ;
         {|| MAOF04() }, {|| PADARR( "OF02", Str( xOF, 8, 2 ) + Str( xITEM, 3 ), "STR(OF,8,2)+STR(ITEM,3)", "STR(xOF,8,2)+STR(xITEM,3)" ) } )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOF02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOF02( lEXIBE )

   IF ValType( lEXIBE ) # "L"
      lEXIBE := .T.
   ENDIF
   mQFABRICAR := mQPEDIDO + mQTOLERA
   mQSALDO    := mQFABRICAR - mQFABRICAD
   IF lEXIBE
      @ 10, 16 SAY mQFABRICAR PICT "999999.999"
      @ 12, 16 SAY mQSALDO    PICT "999999.999"
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOF03A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOF03A( lOPEN )

   LOCAL lRETU := .T.

   IF Empty( mCLIENTE ) .OR. Empty( mCOGNOME )
      lRETU := PEGACAMPO( "MO01", "mOF", { "FORNECEDO", "COGNOME" }, { "mCLIENTE", "mCOGNOME" },,, lOPEN )
   ENDIF
   RETU lRETU




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOF03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOF03( nOS, lOPEN, lGRVOF01 )

   PRIV aCOMP := {}
   PRIV RCOD  := mCODIGO

   IF ValType( nOS ) = "N"
      mOS := nOS
   ENDIF
   IF ValType( lOPEN ) # "L"
      lOPEN := .F.
   ENDIF
   IF ValType( lGRVOF01 ) # "L"
      lGRVOF01 := .T.
   ENDIF

   MDS( "Pegando dados da Ordem de Servico" )
   IF MAOF03A( lOPEN )
      mITEM    := IF( mITEM = 0, 1, mITEM )
      cUNID    := " "
      dENTREGA := ZDATA
      IF PEGACAMPO( "MO02", "STR(mOF,8,2)+STR(mITEM,2)", ;
            { "ENTREGA", "CODIGO", "QTDESAL", "UNID", "GERAOF" }, ;
            { "dENTREGA", "mCODIGO", "mQPEDIDO", "cUNID", "mGERAOF" },,, lOPEN, ;
            { "CTOD(SPACE(8))", "''", "0", "SPACE(2)", "'N'" } )
         mDPEDI   := dENTREGA
         RCOD     := mCODIGO
         mQPEDIDO := CONVUN( mQPEDIDO, cUNID )  // Pedido Para Pe‡as
         IF mQPEDIDO > 0 .AND. mGERAOF # "N"
            MDS( "Pegando dados do Produto" )
            PEGACAMPO( "MS01", "mCODIGO", { "PERTOL", "DIASEST", "DIASENT", "ESTQSAL" }, ;
               { "mPERTO", "mDIAFAB", "mDIACOM", "mQRESERVA" },,, lOPEN, ;
               { "0", "0", "0", "0" } )
            IF mQRESERVA < 0.0001
               mQRESERVA := 0
            ENDIF

            IF mQRESERVA > 0
               IF lOPEN
                  WHILE !USEREDE( "OR01", 1, 1 )
                  ENDDO
               ELSE
                  dbSelectAr( "OR01" )
               ENDIF
               dbGoTop()
               dbSeek( mCODIGO )
               WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof() .AND. mQRESERVA > 0
                  mQRESERVA -= QTDDE
                  dbSkip()
               ENDDO
               IF lOPEN
                  dbCloseArea()
               ENDIF
            ENDIF

            IF mQRESERVA < 0.0001
               mQRESERVA := 0
            ENDIF

            mQTOLERA := Round( mQPEDIDO * mPERTO / 100, 3 )
            mDLIMITE := mDPEDI - mDIACOM
            mDLIMP   := mDPEDI - mDIAFAB
            IF mQRESERVA > mQPEDIDO + mQTOLERA
               mQRESERVA := mQPEDIDO + mQTOLERA
            ENDIF


            mQFABRICAR := mQPEDIDO + mQTOLERA
            mQFABRICAD := 0
            mQSALDO    := mQPEDIDO - mQRESERVA + mQTOLERA

            IF lGRVOF01
               NOVOOPE( "OF01", Str( mOS, 8, 2 ) + Str( mITEM, 3 ) )
            ENDIF

            MDS( "Gravando Composicao da Ordem de Fabricacao" )
            IF mQSALDO > 0.0001
               IF lOPEN
                  WHILE !USEREDE( "MS03", 1, 1 )
                  ENDDO
               ELSE
                  dbSelectAr( "MS03" )
               ENDIF
               dbGoTop()
               dbSeek( mCODIGO )
               WHILE mCODIGO = CODIGO .AND. !Eof()
                  mTIPCOMP  := TIPOENT
                  mCODCOMP  := CODCOMP
                  mNOMECOMP := NOMECOMP
                  mQUSO     := mQSALDO
                  mQTCOMP   := QTDDE
                  mQTTOT    := Round( mQTCOMP * mQUSO, 4 )
                  mDIASEST  := mDIASENT := mSALCOMP := 0
                  cARQEST   := ESTQARQ( mTIPCOMP, 1 )
                  mGERARN   := GERARN
                  IF mQTTOT > 0 .AND. ( mTIPCOMP $ "CMPSEHTOS" ) .AND. cARQEST <> "XXXX" .AND. mGERARN <> "N"
                     PEGACAMPO( cARQEST, "mCODCOMP", { "DIASEST", "DIASENT", "ESTQSAL+ESTQPRO" }, ;
                        { "mDIASEST", "mDIASENT", "mSALCOMP" },,,, ;
                        { "0", "0", "0" } )
                     AAdd( aCOMP, { mTIPCOMP, mCODCOMP, mQTTOT, mSALCOMP, 0, mDIASENT, mDIASEST } )
                     IF lOPEN
                        IF !NOVOREG( "OF02", Str( mOF, 8, 2 ) + Str( mITEM, 3 ) + mTIPCOMP + mCODCOMP, .F., .F. )
                           GRAVAMVAR( "OF02", Str( mOF, 8, 2 ) + Str( mITEM, 3 ) + mTIPCOMP + mCODCOMP, "QTTOT", "QTTOT+mQTTOT",, .F. )
                        ENDIF
                     ELSE
                        IF !NOVOOPE( "OF02", Str( mOF, 8, 2 ) + Str( mITEM, 3 ) + mTIPCOMP + mCODCOMP )
                           FIELD->QTCOMP := QTCOMP + mQTCOMP
                           FIELD->QTTOT  := QTTOT + mQTTOT
                        ENDIF
                     ENDIF
                  ENDIF
                  dbSelectAr( "MS03" )
                  dbSkip()
               ENDDO
               IF lOPEN
                  dbCloseArea()
               ENDIF
            ENDIF
            MDS( "Reserva//Necessidade Produto" )
            mREQUISI := 0
            mNRNOTA  := 0
            mSEQ     := 0
            mBAIXA   := CToD( Space( 8 ) )
            mTIPO    := "E"
            IF mQRESERVA > 0.0001
               mQTDDE := mQRESERVA
               IF lOPEN
                  NOVOREG( "OR01", PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ), .F., .F. )
               ELSE
                  NOVOOPE( "OR01", PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ) )
               ENDIF
            ENDIF

            IF mQSALDO > 0.0001
               mQTDDE := mQSALDO
               IF lOPEN
                  NOVOREG( "OR12", PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ), .F., .F. )
               ELSE
                  NOVOOPE( "OR12", PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ) )
               ENDIF
            ENDIF



            MDS( "Reservando Itens da Composi‡„o" )
            FOR W := 1 TO Len( aCOMP )
               mREQUISI  := 0
               mNRNOTA   := 0
               mSEQ      := 0
               mBAIXA    := CToD( Space( 8 ) )
               mTIPO     := "E"
               mCODIGO   := aCOMP[ W, 2 ]
               mQRESCOMP := aCOMP[ W, 4 ]   // Estoque co Componente
               mSALDO    := aCOMP[ W, 3 ]   // Saldo necessario para Fabricar
               cARQORR   := TIPORR( aCOMP[ W, 1 ], 1 )
               cARQOR2   := TIPORR( aCOMP[ W, 1 ], 2 )
               mDPEDI    := dENTREGA
               mDLIMITE  := dENTREGA - aCOMP[ W, 6 ]
               mDLIMP    := dENTREGA - aCOMP[ W, 7 ]
               IF cARQORR <> "XXXX"
                  IF lOPEN
                     WHILE !USEREDE( cARQORR, 1, 1 )   // Abatendo Reserva Anteriores
                     ENDDO
                  ELSE
                     dbSelectAr( cARQORR )   // Abatendo Reserva Anteriores
                  ENDIF
                  dbGoTop()
                  dbSeek( mCODIGO )
                  WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof() .AND. mQRESCOMP > 0
                     mQRESCOMP -= QTDDE
                     dbSkip()
                  ENDDO
                  IF lOPEN
                     dbCloseArea()
                  ENDIF
               ENDIF
               IF ValType( mQRESCOMP ) <> "N" .OR. mQRESCOMP < 0.0001
                  mQRESCOMP := 0
               ENDIF
               IF mQRESCOMP > mSALDO
                  mQRESCOMP := mSALDO
               ENDIF
               IF mQRESCOMP > 0  // Reservando a Composicao
                  mQTDDE := mQRESCOMP
                  IF cARQORR <> "XXXX"
                     IF lOPEN
                        IF !NOVOREG( cARQORR, PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ), .F., .F. )
                           GRAVAMVAR( cARQORR, PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ), "QTDDE", "QTDDE+mQTDDE",, .F. )
                        ENDIF
                     ELSE
                        IF !NOVOOPE( cARQORR, PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ) )
                           FIELD->QTDDE := QTDDE + mQTDDE
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               mQTDDE := mSALDO - mQRESCOMP
               IF mQTDDE > 0   // Ainda Falta Gera Compra
                  IF cARQOR2 <> "XXXX"
                     IF lOPEN
                        IF !NOVOREG( cARQOR2, PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ), .F., .F. )
                           GRAVAMVAR( cARQOR2, PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ), "QTDDE", "QTDDE+mQTDDE",, .F. )
                        ENDIF
                     ELSE
                        IF !NOVOOPE( cARQOR2, PadR( mCODIGO, 24 ) + Str( mOF, 8, 2 ) + Str( mREQUISI, 8 ) )
                           FIELD->QTDDE := QTDDE + mQTDDE
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT W
         ENDIF
      ENDIF
   ENDIF
   mCODIGO := RCOD
// mUNID  :=cUNID
   mUNID := "PC"
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOF04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOF04

   mOF   := xOF
   mITEM := xITEM
   mQUSO := xQUSO
   RETU .T.

// + EOF: m_aof.prg
// +
