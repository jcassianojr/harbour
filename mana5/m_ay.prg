// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ay.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_AY   .PRG :
// :   Linguagem   : harbour
// :        Sistema: D:UI
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_ay()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_ay

   PARA cARQ, nINDPRO

   IF ValType( cARQ ) = "C"
      ARQWORK := cARQ
   ENDIF
   IF ValType( nINDPRO ) # "N"
      nINDPRO := 1
   ENDIF



   PRIV mFORNECEDO := 0
   PRIV xCODIGO, yCODIGO, xTIPO1, xTIPO2, mTIPOENT, mNRNOTA, mOLDQTDDE



   PADRAX( 0,, 0, { ARQWORK, "OR01" }, "N£mero    Data     M T ORI Doc/OS   C¢digo" + spac( 15 ) + "Qtdde Un RetPor", ;
      "' '+STR(mNUMERO,  8)+' '+DTOC(mDATA)+' '+mTIPO1+' '+mTIPO2+' '+mTIPO3+' '+STR(mOS, 9, 2)+' '+padr(mCODIGO,15)+' '+STR(mQTDE, 10, 3)+' '+mUNID+' '+str(mTECNICO,4)", "MAY001", "MAY001", ;
      , {|| MAYDEL() }, {|| MAYPOS() }, {|| mNUMERO := ULTIMOREG( ARQWORK, "NUMERO", "mNUMERO" ) } ;
      , "MAY", {|| MAYIGU() } )





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAYDEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAYDEL

   wQTDE      := mQTDE
   wCODIGO    := mCODIGO
   yCODIGO    := mCODIGO
   mTIPOENT   := mTIPO2
   mFORNECEDO := mNUMMB01
   IF "MY01" = ARQWORK .OR. "MY04" = ARQWORK
      IF xTIPO1 = "S"
         mOLDQTDDE := MAM2K06( ARQWORK + mTIPO1 )
         MAM2K05( "E", ARQWORK + mTIPO1 )
      ELSE
         mOLDQTDDE := MAK2K06( ARQWORK + mTIPO1 )
         MAK2K05( "E", ARQWORK + mTIPO1 )
      ENDIF
      IF MDG( "Retornar Estoque de Processo" )
         IF mTIPO1 = "E"
            MAY05( "ESTQSAI-wQTDE" )
         ENDIF
         IF mTIPO1 = "S"
            MAY05( "ESTQSAI+wQTDE" )
         ENDIF
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAYIGU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAYIGU

// Vari veis de Referencias
   xCODIGO  := mCODIGO
   yCODIGO  := mCODIGO
   xTIPO1   := mTIPO1
   xTIPO2   := mTIPO2
   mTIPOENT := mTIPO2
   IF Empty( mNRNOTA )
      mNRNOTA := mNUMERO
   ENDIF
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAYPOS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAYPOS()

   IF mTIPO3 = "NFS"
      ALERTX( "Requisicao Nota Fiscal Saida-Nao Corrige Estoque" )
      RETU .F.
   ENDIF
   IF mTIPO3 = "RIF"
      ALERTX( "Requisicao Registro Inspe‡ao Final-Nao Corrige Estoque" )
      RETU .F.
   ENDIF
   IF mTIPO3 = "CRM"
      ALERTX( "Requisicao CRM - Nao Corrige Estoque" )
      RETU .F.
   ENDIF
   IF mTIPO3 = "AJU"
      ALERTX( "Requisicao Ajuste Qtde Entregue Pedido - Nao Corrige Estoque" )
      RETU .F.
   ENDIF
   IF ARQWORK <> "MY01" .AND. ARQWORK <> "MY04"
      ALERTX( "Mes fechado nao grava altera‡oes estoque" )
      RETU .F.
   ENDIF
   PRIV W
   mTIPOENT   := mTIPO2
   wQTDE      := mQTDE
   wCODIGO    := mCODIGO
   mFORNECEDO := mNUMMB01
   IF ( mTIPOENT $ "PMC123EHTROS" ) .AND. mTIPO1 = "E" .AND. ( "MY01" = ARQWORK .OR. "MY04" = ARQWORK )
      // Aumentando o Estoque na Entrada
      IF INCLUI
         yCODIGO   := mCODIGO  // Fixa o Codigo de Inclus„o
         mOLDQTDDE := 0
         MAK2K05( "I", ARQWORK + mTIPO1 )
      ELSE
         IF yCODIGO = mCODIGO  // N„o Houve Mudan‡a de Codigo
            // Verificando se Alterou Quantidade
            mOLDQTDDE := MAK2K06( ARQWORK + mTIPO1 )
            IF mOLDQTDDE # mQTDE
               IF mOLDQTDDE > mQTDE
                  MAK2K05( "R", ARQWORK + mTIPO1 )
               ENDIF
               IF mOLDQTDDE < mQTDE
                  MAK2K05( "A", ARQWORK + mTIPO1 )
               ENDIF
            ENDIF
         ELSE  // Mudou o Codigo
            mOLDQTDDE := MAK2K06( ARQWORK + mTIPO1 )
            MAK2K05( "E", ARQWORK + mTIPO1 )  // Exclui o Anterior
            yCODIGO := mCODIGO
            MAK2K05( "I", ARQWORK + mTIPO1 )  // Inclui o Atual
         ENDIF
      ENDIF
   ENDIF

// Abaixando o Estoque na Saida
   IF ( mTIPOENT $ "PMC123EHTORS" ) .AND. mTIPO1 = "S" .AND. ( "MY01" = ARQWORK .OR. "MY04" = ARQWORK )
      IF INCLUI
         yCODIGO   := mCODIGO  // Fixa o Codigo de Inclus„o
         mOLDQTDDE := 0
         MAM2K05( "I", ARQWORK + mTIPO1 )
      ELSE
         IF yCODIGO = mCODIGO  // N„o Houve Mudan‡a de Codigo
            // Verificando se Alterou Quantidade
            mOLDQTDDE := MAM2K06( ARQWORK + mTIPO1 )
            IF mOLDQTDDE # mQTDE
               IF mOLDQTDDE > mQTDE
                  MAM2K05( "R", ARQWORK + mTIPO1 )
               ENDIF
               IF mOLDQTDDE < mQTDE
                  MAM2K05( "A", ARQWORK + mTIPO1 )
               ENDIF
            ENDIF
         ELSE  // Mudou o Codigo
            mOLDQTDDE := MAM2K06( ARQWORK + mTIPO1 )
            MAM2K05( "E", ARQWORK + mTIPO1 )  // Exclui o Anterior
            yCODIGO := mCODIGO
            MAM2K05( "I", ARQWORK + mTIPO1 )  // Inclui o Atual
         ENDIF
      ENDIF
   ENDIF


   IF "MY04" = ARQWORK
      IF INCLUI
         MAY04()
      ENDIF
      RETU .T.
   ENDIF

   IF mTIPOENT = "P" .AND. "MY01" = ARQWORK .AND. INCLUI
      IF mTIPO1 = "E"
         MAY05( "ESTQSAI+wQTDE" )
      ENDIF
      IF mTIPO1 = "S" .AND. MDG( "Retornar Estoque de Processo" )
         MAY05( "ESTQSAI-wQTDE" )
      ENDIF
   ENDIF


   IF mDISTRI = "C" .AND. mTIPOENT = "P" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      aCOMP := {}
      WHILE !USEREDE( "MS03", 1, 1 )
      ENDDO
      dbGoTop()
      dbSeek( wCODIGO )
      WHILE wCODIGO = CODIGO .AND. !Eof()
         IF TIPOENT $ "PMCEHTROS" .AND. BAIXAC # "N"   // Componente Prima Sub Produto Hora Maq Opr Tra
            AAdd( aCOMP, { TIPOENT, CODCOMP, mQTDDE * QTDDE, mOS, BAIXAC } )  // Quantidade OS*Quantidade componete
         ENDIF
      ENDDO
      dbCloseArea()
      OLDTIPOENT := mTIPOENT
      FOR W := 1 TO Len( aCOMP )   // Baixando o Estoque Componentes
         mOLDQTDDE := 0
         mCODIGO   := aCOMP[ W, 2 ]
         yCODIGO   := mCODIGO
         mQTDE     := aCOMP[ W, 3 ]
         mTIPOENT  := aCOMP[ W, 1 ]
         mTIPENT   := aCOMP[ W, 1 ]
         mBAIXAC   := aCOMP[ W, 5 ]
         MAM2K05( "I", ARQWORK + mTIPO1 + "C" )
      NEXT W
      mTIPOENT := OLDTIPOENT
      RETU .T.
   ENDIF



// Se nao distruibuir retorna
   IF mDISTRI = "N"
      RETU .T.
   ENDIF


// Reserva Materia Produto na inclusao
   IF mTIPOENT = "P" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      nINIDIV := mQTDE
      aOFDIV  := {}
      WHILE !USEREDE( "OF01", 1, 3 )
      ENDDO
      dbGoTop()
      dbSeek( mCODIGO )
      WHILE nINIDIV > 0 .AND. AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         IF QSALDO > 0
            mTEMPSAL := CONVUN( QSALDO, UNID )
            DO CASE
            CASE nINIDIV = mTEMPSAL
               AAdd( aOFDIV, { OF, mTEMPSAL, DLIMITE } )
               nINIDIV := 0
            CASE nINIDIV > mTEMPSAL
               AAdd( aOFDIV, { OF, mTEMPSAL, DLIMITE } )
               nINIDIV -= mTEMPSAL
            CASE nINIDIV < mTEMPSAL
               AAdd( aOFDIV, { OF, nINIDIV, DLIMITE } )
               nINIDIV := 0
            ENDCASE
         ENDIF
         dbSkip()
      ENDDO
      dbCloseArea()
      FOR J := 1 TO Len( aOFDIV )
         mCODIGO  := wCODIGO
         yCODIGO  := wCODIGO
         wNOTA    := 0
         mOF      := aOFDIV[ J, 1 ]
         wOS      := aOFDIV[ J, 1 ]
         mOS      := aOFDIV[ J, 1 ]
         wREQUISI := mNUMERO
         wSEQ     := 0
         mSEQ     := 0
         dDATA    := mDATA
         mQTDDE   := aOFDIV[ J, 2 ]
         mDLIMITE := aOFDIV[ J, 3 ]
         mREQUISI := mNUMERO
         mNRNOTA  := 0
         mBAIXA   := CToD( Space( 8 ) )
         mTIPO    := "E"
         IF !NOVOREG( "OR01", PadR( wCODIGO, 24 ) + Str( mOS, 8, 2 ) + Str( mREQUISI, 8 ) )   // Reservando Produto
            GRAVAMVAR( "OR01", "PADR(wCODIGO,24)+STR(mOS,8,2)+STR(mREQUISI,8)", "QTDDE", "QTDDE+mQTDDE",, .F. )
         ENDIF
         GRAVAMVAR( "OR12", "PADR(wCODIGO,24)+STR(mOS,8,2)+STR(mREQUISI,8)", "QTDDE", "QTDDE-mQTDDE",, .F. )
         mITEM := IF( mITEM == 0, 1, mITEM )
         WHILE !USEREDE( "OF01", 1, 99 )
         ENDDO
         dbGoTop()
         IF dbSeek( Str( mOF, 8, 2 ) + Str( mITEM, 3 ) )
            netreclock()
            FIELD->QFABRICAD := CONVUN( mQTDDE, UNID )
            FIELD->QSALDO    := QFABRICAR - QFABRICAD
            mQUSO            := QSALDO
            dbUnlock()
         ENDIF
         dbCloseArea()
         aCOMP := {}
         WHILE !USEREDE( "OF02", 1, 99 )   // Ajustando Quantidade dos Componentes
         ENDDO
         dbGoTop()
         dbSeek( Str( mOF, 8, 2 ) + Str( mITEM, 3 ) )
         WHILE mOF = OF .AND. mITEM = ITEM .AND. !Eof()
            netreclock()
            IF TIPCOMP $ "PMCEHTOS" .AND. BAIXAC # "N"   // Componente Prima Sub Produto Hora Maq Opr Tra
               AAdd( aCOMP, { TIPCOMP, CODCOMP, mQTDDE * QTCOMP, OF, BAIXAC } )   // Quantidade OS*Quantidade componete
            ENDIF
            FIELD->QUSO  := mQUSO
            FIELD->QTTOT := QUSO * QTCOMP
            dbUnlock()
            dbSkip()
         ENDDO
         dbCloseArea()
         WHILE !USEREDE( "MS03", 1, 1 )
         ENDDO
         OLDTIPOENT := mTIPOENT
         FOR W := 1 TO Len( aCOMP )  // Baixando o Estoque Componentes
            mOLDQTDDE := 0
            mCODIGO   := aCOMP[ W, 2 ]
            yCODIGO   := mCODIGO
            mQTDE     := aCOMP[ W, 3 ]
            mTIPOENT  := aCOMP[ W, 1 ]
            mTIPENT   := aCOMP[ W, 1 ]
            mBAIXAC   := aCOMP[ W, 5 ]
            IF mBAIXAC # "N"   // Verifica Novamente
               dbSelectAr( "MS03" )
               dbGoTop()
               dbSeek( wCODIGO + mTIPOENT + mCODIGO )
               IF Found()
                  mBAIXAC := BAIXAC
               ENDIF
            ENDIF
            MAM2K05( "I", ARQWORK + mTIPO1 + "C" )
            cARQTMP := TIPORR( mTIPENT, 1 )
            MAYG02( mQTDE, cARQTMP, cARQTMP + "BX", aCOMP[ W, 4 ] )
         NEXT W
         dbCloseArea()
         mTIPOENT := OLDTIPOENT
      NEXT J
   ENDIF


// Distruibuir Materia Prima para as necessidades de Compra
   IF mTIPOENT = "M" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      MAY02( "OR04", "OR04BX", "OR02", wQTDE )
   ENDIF

// Distruibuir Componentes para as necessidades
   IF mTIPOENT = "C" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      MAY02( "OR05", "OR05BX", "OR03", wQTDE )
   ENDIF

// Distruibuir Horas Maquinas Para as necessidades
   IF mTIPOENT = "E" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      MAY02( "OR09", "OR09BX", "OR06", wQTDE )
   ENDIF

// Distruibuir Horas Operadores Para as necessidades
   IF mTIPOENT = "H" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      MAY02( "OR10", "OR10BX", "OR07", wQTDE )
   ENDIF

// Distruibuir Horas Tratamentos Para as necessidades
   IF mTIPOENT = "T" .AND. mTIPO1 = "E" .AND. "MY01" = ARQWORK .AND. INCLUI
      MAY02( "OR11", "OR11BX", "OR08", wQTDE )
   ENDIF

   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY01

   DO CASE
      // Indexacao Dirferenciada produto
   CASE mTIPO2 = "P"
      OBTER( "MS01", mCODIGO, "NOME", nINDPRO, 10, 29, "NOME", "'N„o Cadastrado'" )
   OTHERWISE
      OBTER( ESTQARQ( mTIPO2, 1 ), AllTrim( mCODIGO ), "NOME", 1, 10, 29, "NOME", "'N„o Cadastrado'" )
   ENDCASE
   IF Empty( mUNID )
      DO CASE
      CASE mTIPO2 $ "123EHT"
         mUNID := "HR"
      CASE mTIPO2 $ "MCOSR"
         mUNID := OBTER( ESTQARQ( mTIPO2, 1 ), AllTrim( mCODIGO ), "UNIDADE" )
      CASE mTIPO2 $ "P"
         mUNID := OBTER( ESTQARQ( mTIPO2, 1 ), AllTrim( mCODIGO ), "UNID" )
      ENDCASE
   ENDIF
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY02( cARQ, cARQ2, cARQ3, nSTART )

   wOS      := mOS
   wREQUISI := mNUMERO
   wNOTA    := 0
   wSEQ     := 0
   dDATA    := mDATA
   WHILE !USEREDE( cARQ, 1, 99 )
   ENDDO
   dbSetOrder( 3 )   // Codigo + Data Limite
   WHILE !USEREDE( cARQ2, 1, 99 )
   ENDDO
   dbSetOrder( 1 )
   WHILE !USEREDE( cARQ3, 1, 99 )
   ENDDO
   dbSetOrder( 1 )
   dbSelectAr( cARQ )
   dbGoTop()
   dbSeek( yCODIGO )
   WHILE AllTrim( yCODIGO ) = AllTrim( CODIGO ) .AND. nSTART > 0 .AND. !Eof()
      mQTDEINI := QTDDE
      DO CASE
      CASE nSTART = mQTDEINI
         netreclock()
         wOS     := OS
         wLIMITE := DLIMITE
         wDLIMP  := DLIMP
         wDPEDI  := DPEDI
         DELEREG(,, .F., .F. )
         MAYG01( nSTART, cARQ2, "E", wLIMITE )
         MAYG01( nSTART, cARQ3, "E", wLIMITE )
         nSTART := 0
      CASE nSTART > mQTDEINI
         netreclock()
         wOS     := OS
         wLIMITE := DLIMITE
         wDLIMP  := DLIMP
         wDPEDI  := DPEDI
         DELEREG(,, .F., .F. )
         MAYG01( mQTDEINI, cARQ2, "E", wLIMITE )
         MAYG01( mQTDEINI, cARQ3, "E", wLIMITE )
         nSTART -= mQTDEINI
      CASE nSTART < mQTDEINI
         netreclock()
         wOS          := OS
         wLIMITE      := DLIMITE
         wDLIMP       := DLIMP
         wDPEDI       := DPEDI
         FIELD->QTDDE := QTDDE - nSTART
         dbUnlock()
         MAYG01( nSTART, cARQ2, "E", wLIMITE )
         MAYG01( nSTART, cARQ3, "E", wLIMITE )
         nSTART := 0
      ENDCASE
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbSelectAr( cARQ )
   dbCloseArea()
   dbSelectAr( cARQ2 )
   dbCloseArea()
   dbSelectAr( cARQ3 )
   dbCloseArea()





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY03()

   PRIV mQTEM1, mQTEM2

   IF Left( ARQWORK, 4 ) <> "MY04" .OR. Empty( mOS ) .OR. Empty( mITEM ) .OR. !INCLUI
      RETU .T.
   ENDIF
   PEGACAMPO( "MW02", "STR(mOS,8)+STR(mITEM,3)", { "ITEQTD", "ITEUNI", "ITETIP", "ITECOD", "ITEENT" }, { "mQTEM1", "mUNID", "mTIPO2", "mCODIGO", "mQTEM2" } )
   mQTDEINI := mQTEM1
   mQTDESAL := mQTEM1 - mQTEM2
   mQTDE    := mQTDESAL
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY04( cOBS )

   LOCAL lAPAGA := .F.

   IF ValType( cOBS ) # "C"
      cOBS := " "
   ENDIF
   IF Empty( mOS ) .OR. Empty( mITEM )
      RETU .F.
   ENDIF
   WHILE !USEREDE( "MW02", 1, 99 )
   ENDDO
   dbGoTop()
   IF dbSeek( Str( mOS, 8 ) + Str( mITEM, 3 ) )
      lAPAGA := .T.
      netreclock()
      IF cOBS = "R"
         FIELD->RESIDUO := "S"
         FIELD->ITERES  := ITERES + wQTDE
      ELSE
         FIELD->ITEENT := ITEENT + wQTDE
         FIELD->RECNUM := mNUMERO
         FIELD->RECNOT := mNRNOTA
         FIELD->REQDAT := mDATA
      ENDIF
      dbUnlock()
      dbGoTop()
      dbSeek( Str( mOS, 8 ) )
      WHILE mOS = COMPED .AND. !Eof()
         netreclock()
         FIELD->ITESAL := ITEQTD - ( ITEENT + ITERES )
         IF ITESAL > 0
            lAPAGA := .F.
         ENDIF
         dbSkip()
      ENDDO
   ENDIF
   dbCloseArea()
   IF lAPAGA
      M_AWX1( mOS, ZDATA )
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY05()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY05

   PARA eVAR

   WHILE !USEREDE( "MS06", 1, 4 )  // Codigo Tipo Fechamento
   ENDDO
   GRAVALAY( { { "ESTQSAI", "ESTQSAL" }, { eVAR, "ESTQINI+ESTQENT-ESTQSAI" } }, "MS06",, .F., PadR( wCODIGO, 24 ) + "0", .F. )
   GRAVALAY( { { "ESTQSAI", "ESTQSAL" }, { eVAR, "ESTQINI+ESTQENT-ESTQSAI" } }, "MS06",, .F., PadR( wCODIGO, 24 ) + "8", .F. )
   dbCloseArea()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAY99()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAY99( cARQ )

   IF cARQ = "MS96" .OR. Left( cARQ, 2 ) = "M6"
      PADRAO( 0, 1, 0, cARQ, "C¢digo             Data   Documento Qtde ", ;
         "LEFT(mCODIGO,15)+' '+STR(mSEQ,3,0)+' '+STR(mSSQ,3,0)+' '+DTOC(mDATA)+' '+MAS99(mARQUIVO)+' '+STR(mNUMERO,8)+' '+STR(mESTQXXX,6)+' '+STR(mQTDE,6)+IF(mESTQYYY>mESTQXXX,'+','-')+' '+STR(mESTQYYY,6)+' '+mUSUARIO", ;
         "MAY", {|| MDS( "N„o Editavel" ) }, {|| MDS( "N„o Editavel" ) },,,,,,,,,,,, .T. )
   ELSE
      PADRAO( 0, 1, 0, cARQ, "C¢digo             Data   Documento Qtde ", ;
         "' '+LEFT(mCODIGO,15)+' '+DTOC(mDATA)+' '+MAS99(mARQUIVO)+' '+STR(mNUMERO,8)+' '+mOPERACAO+' '+STR(mESTQXXX,11,3)+' '+STR(mQTDE,11,3)+IF(mESTQYYY>mESTQXXX,'+','-')+' '+STR(mESTQYYY,11,3)+' '+mUSUARIO", ;
         "MAY", {|| MDS( "N„o Editavel" ) }, {|| MDS( "N„o Editavel" ) } )
   ENDIF
   RETU .T.


// + EOF: m_ay.prg
// +
