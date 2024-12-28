// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a2.prg
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_A2.PRG
// +
// +    Functions: Function MA26()
// +               Function Ma2lanhor()
// +               Function MA2MEDSEQ()
// +               Function MA2MEDSEQC()
// +               Function MA2CALLED()
// +               Function MA2MEDPRG()
// +               Function MA2CHKPRG()
// +               Function MAS2CHKARQ()
// +               Function MA2PLTINV()
// +               Function MA2PLT01()
// +
// +    Reformatted by Click! 2.03 on May-29-2003 at  3:16 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA26()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA26()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MA26

   dDATA := ZDATA
   MDS( "Qual Data" )
   @ 24, 40 GET dDATA
   IF !READCUR()
      RETU .F.
   ENDIF
   CRIARVARS( "MS04BX" )
   IF !USEREDE( "CRM", 1, 2 )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( "CRM" )
   dbGoTop()
   dbSeek( dDATA )
   WHILE dDATA = DATA .AND. !Eof()
      IF TIPOE = "T"
         lGRAVOU := .F.
         FOR X := 1 TO 2
            xCODIGO    := PadR( PRODUTO, 24 )
            xNRNOTAINI := Val( PEDIDO )
            xNRNOTASAI := if( X = 1, NRNOTA, NRNOTB )
            xDATASAI   := DATA
            xTOTKGSAI  := if( X = 1, QTDEA, QTDEB )
            xCRM       := CRM
            DO CASE
            CASE CRM->GRAVOU = "S"
               ALERTX( "Crm: " + Str( xCRM ) + " Ja Gravado" )
            CASE Empty( xCODIGO )
               ALERTX( "Crm: " + Str( xCRM ) + " sem Codigo Produto" )
            CASE Empty( xNRNOTASAI )
               ALERTX( "Crm: " + Str( xCRM ) + " sem numero nota entrada" )
            CASE Empty( xNRNOTAINI )
               ALERTX( "Crm: " + Str( xCRM ) + " sem numero nota(PEDIDO)" )
            CASE Empty( xDATASAI )
               ALERTX( "Crm: " + Str( xCRM ) + " sem data" )
            CASE Empty( xTOTKGSAI )
               ALERTX( "Crm: " + Str( xCRM ) + " sem quantidade" )
            OTHERWISE
               IF IGUALVARS( "MS04", xCODIGO + Str( xNRNOTAINI, 8 ) )
                  mDATASAI   := xDATASAI
                  mNRNOTAINI := xNRNOTAINI
                  mNRNOTASAI := xNRNOTASAI
                  mTOTKGSAI  := xTOTKGSAI
                  mTOTKGEST  := mTOTKGANT - mTOTKGSAI
                  mCRM       := xCRM
                  BAIXAREM( "MS04", "MS04BX", mCODIGO + Str( mNRNOTAINI ) )
                  lGRAVOU := .T.
               ELSE
                  ALERTX( "No Encontrei Nota: " + Str( xNRNOTAINI, 8 ) + " Codigo " + xCODIGO )
               ENDIF
            ENDCASE
         NEXT X
         IF lGRAVOU
            dbSelectAr( "CRM" )
            netgrvcam( "GRAVOU", "S" )
         ENDIF
      ENDIF
      dbSelectAr( "CRM" )
      dbSkip()
   ENDDO
   dbCloseAll()

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function Ma2lanhor()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Ma2lanhor()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC Ma2lanhor

   nHORAS := 0.00
   MDI( "Lanar Horas" )
   MDS( "Digite Quantidade Horas" )
   @ 24, 40 GET nHORAS
   IF !READCUR()
      RETU .F.
   ENDIF
   FILTRO := ''
   FILTRO := RFILORD( "MS01", .F. )
   IF !USEREDE( "MS01", 1, 0 )
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      netgrvcam( "PCPRGHOR", nHORAS )
      dbSkip()
   ENDDO
   dbCloseArea()

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2MEDSEQ()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2MEDSEQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2MEDSEQ

   MDI( " н Apurar Media Sequencia" )
   IF !MDG( "As ApuraЦo Desempenho EstЦo OK" )
      RETU .F.
   ENDIF
   cMEDIA := "M"
   @ 24, 00 SAY "(M)edia (1)Aux1 (2)Aux2 (I)nt"
   @ 24, 50 GET cMEDIA
   IF !READCUR()
      RETU .F.
   ENDIF
   aPER   := PEDPER( .T. )
   mMESES := aPER[ 7 ]
   IF !aPER[ 5 ]
      RETU .F.
   ENDIF
   IF !USEMULT( { { "RDT", 1, 1 }, { "MS06", 1, 1 } } )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( "MS06" )
   dbGoTop()
   WHILE !Eof()
      netreclock()
      DO CASE
      CASE cMEDIA = "M"
         field->PCHORMED := 0
      CASE cMEDIA = "I"
         field->PCHORAMD := 0
      CASE cMEDIA = "1"
         field->PCHORAX1 := 0
      CASE cMEDIA = "2"
         field->PCHORAX2 := 0
      ENDCASE
      dbUnlock()
      dbSkip()
   ENDDO

   dbSelectAr( "RDT" )
   dbGoTop()
   WHILE !Eof()
      mCODIGO := AllTrim( CODIGO )
      mSEQ    := SEQ
      mSSQ    := SSQ
      mQTD    := 0
      mHOR    := 0
      WHILE mSEQ = SEQ .AND. mSSQ = SSQ .AND. mCODIGO = Trim( CODIGO ) .AND. !Eof()
         @ 24, 00 SAY mCODIGO + " " + Str( SEQ ) + " " + Str( SSQ ) + " " + Str( MES ) + " " + Str( ANO ) + " " + StrZero( RecNo() )
         CALCPER( aPER, ANO, MES, {|| MA2MEDSEQC() } )
         dbSkip()
      ENDDO
      IF mQTD > 0 .AND. mHOR > 0
         dbSelectAr( "MS06" )
         dbGoTop()
         IF dbSeek( PadR( mCODIGO, 24 ) + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
            netreclock()
            DO CASE
            CASE cMEDIA = "M"
               field->PCHORMED := mQTD / mHOR
            CASE cMEDIA = "I"
               field->PCHORAMD := mQTD / mHOR
            CASE cMEDIA = "1"
               field->PCHORAX1 := mQTD / mHOR
            CASE cMEDIA = "2"
               field->PCHORAX2 := mQTD / mHOR
            ENDCASE
            IF PCHORMED > 0
               field->PCHORMEQ := 1 / PCHORMED
            ENDIF
            dbUnlock()
         ENDIF
      ENDIF
      dbSelectAr( "RDT" )
   ENDDO
   dbCloseAll()

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2MEDSEQC()
// +
// +    Called from ( m_a2.prg     )   1 - function ma2medseq()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2MEDSEQC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2MEDSEQC

   mQTD += PQTDDE
   mHOR += PHORAS
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2CALLED()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2CALLED()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2CALLED

   MDI( "Calculando Leading-Time" )
   IF !USEMULT( { { "MS01", 1, 1 }, { "MS06", 1, 1 } } )
      RETU .F.
   ENDIF
   FILTRO := ''
   FILTRO := RFILORD( "MS01", .F. )
   IF !USEREDE( "MS01", 1, 0 )
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      mCODIGO := AllTrim( CODIGO )
      @ 24, 00 SAY mCODIGO
      IF PCPRGMED > 0 .AND. PCPRGHOR > 0
         mPCPRGMED := PCPRGMED
         mPCPRGHOR := PCPRGHOR
         dbSelectAr( "MS06" )
         dbSeek( mCODIGO )
         WHILE mCODIGO = AllTrim( CODIGO ) .AND. !Eof()
            netreclock()
            IF PCHORMEQ > 0
               field->PCHORDIA := ( 1 / mPCPRGHOR ) * PCHORMEQ
               field->LEADCALC := mPCPRGMED * PCHORDIA
               field->PCHORNEC := mPCPRGMED * PCHORMEQ
               field->LEADARRE := Round( LEADCALC + .5, 0 )
            ELSE
               field->PCHORDIA := 0
               field->LEADCALC := 0
            ENDIF
            dbUnlock()
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( "MS01" )
      dbSkip()
   ENDDO
   IF !MDG( "Calcular Prz-Dias" )
      dbCloseAll()
      RETU .T.
   ENDIF
   dbSelectAr( "MS01" )
   dbGoTop()
   WHILE !Eof()
      mCODIGO := CODIGO
      @ 24, 00 SAY mCODIGO
      nTOTAL := 0
      // nRECNO:=0
      dbSelectAr( "MS06" )
      dbGoTop()
      dbSeek( mCODIGO )
      WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         nTOTAL += LEADARRE
         nRECNO := RecNo()
         dbSkip()
      ENDDO
      dbGoTop()
      dbSeek( mCODIGO )
      WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         netreclock()
         field->LIMTIME := nTOTAL
         dbUnlock()
         nTOTAL -= LEADARRE
         IF nTOTAL <= 0
            nTOTAL := 1
         ENDIF
         dbSkip()
      ENDDO
      dbSelectAr( "MS01" )
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2MEDPRG()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2MEDPRG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2MEDPRG( nTIPO )

   IF !MDG( "As ApuraЦo Entrega EstЦo OK" )
      RETU .F.
   ENDIF
   aPER := PEDPER( .T. )
   IF !aPER[ 5 ]
      RETU .F.
   ENDIF
   IF nTIPO = 1
      IF !USEMULT( { { "BS5", 1, 2 }, { "MS01", 1, 2 } } )
         dbCloseAll()
         RETU .F.
      ENDIF
   ELSE
      IF !USEMULT( { { "BS5", 1, 2 }, { "OP01", 1, 2 } } )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF
   IF nTIPO = 1
      dbSelectAr( "MS01" )
      dbGoTop()
      WHILE !Eof()
         netgrvcam( "PCPRGMED", 0 )
         dbSkip()
      ENDDO
   ELSE
      dbSelectAr( "OP01" )
      dbGoTop()
      WHILE !Eof()
         netreclock()
         field->VMED := 0
         field->VMEQ := 0
         dbUnlock()
         dbSkip()
      ENDDO
   ENDIF
   dbSelectAr( "BS5" )
   dbGoTop()
   WHILE !Eof()
      mCODIGO := AllTrim( CODIGO )
      mQTD    := 0
      WHILE mCODIGO = Trim( CODIGO ) .AND. !Eof()
         @ 24, 00 SAY mCODIGO + " " + Str( MES ) + " " + Str( ANO ) + " " + StrZero( RecNo() )
         CALCPER( aPER, ANO, MES, {|| mQTD := mQTD + QTDDE } )
         dbSkip()
      ENDDO
      IF mQTD > 0
         IF nTIPO = 1
            dbSelectAr( "MS01" )
            dbGoTop()
            IF dbSeek( mCODIGO )
               netgrvcam( "PCPRGMED", mQTD / aPER[ 7 ] )
            ENDIF
         ELSE
            dbSelectAr( "OP01" )
            dbGoTop()
            IF dbSeek( mCODIGO )
               netreclock()
               field->VMED := mQTD / aPER[ 7 ]   // QTDE/N Meses
               field->VMEQ := VMED / 2   // Quinzenal
               dbUnlock()
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( "BS5" )
   ENDDO
   dbCloseAll()

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2CHKPRG()
// +
// +    Called from ( m_a2.prg     )   1 - function ma2pltinv()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2CHKPRG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2CHKPRG( lSOOP )

   IF ValType( lSOOP ) # "L"
      lSOOP := .F.
   ENDIF

   MDI( "Checando Produto ComposiЦo Sequencia" )
   IF !USEMULT( { { "MA01", 1, 1 }, { "MS01", 1, 2 }, { "MS01X", 1, 1 }, { "OP01", 1, 0 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MS01" )
   WHILE !Eof()
      netreclock()
      IF Empty( PCPRGMED ) .AND. Empty( ESTQSAL ) .AND. ( Empty( ULTIMOFA ) .OR. ( ZDATA - ULTIMOFA ) > 180 )
         field->ATIVO := "N"
      ELSE
         field->ATIVO := "S"
      ENDIF
      IF Empty( CLIPCP )
         field->CLIPCP := FORNECEDO
      ENDIF
      dbUnlock()
      dbSkip()
   ENDDO
   dbSelectAr( "op01" )
   dbGoTop()
   WHILE !Eof()
      mCODIGO    := CODIGO
      mATIVO     := ATIVO
      mCODIGOINT := ""
      mNOME      := ""
      mCLIENTE   := CLIENTE
      mCOGNOME   := COGNOME
      MDS( mCODIGO )
      dbSelectAr( "ms01" )
      dbGoTop()
      IF dbSeek( Mcodigo )
         IF Empty( ATIVO )
            GRAVACAMPO( { "ATIVO" }, { "'S'" } )
         ENDIF
         mCODIGOINT := CODIGOINT
         mNOME      := NOME
         mCLIENTE   := FORNECEDO
      ENDIF
      IF Empty( mCODIGOINT ) .OR. Empty( mCLIENTE ) .OR. Empty( mNOME )
         dbSelectAr( "ms01X" )
         dbGoTop()
         IF dbSeek( Mcodigo )
            IF Empty( mCODIGOINT )
               mCODIGOINT := CODIGOINT
            ENDIF
            IF Empty( mNOME )
               mNOME := NOME
            ENDIF
            IF Empty( MCLIENTE )
               mCLIENTE := FORNECEDO
            ENDIF
         ENDIF
      ENDIF
      IF Empty( mCOGNOME )
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( MCLIENTE )
            mCOGNOME := COGNOME
         ENDIF
      ENDIF
      dbSelectAr( "op01" )
      IF Empty( CODIGOINT ) .AND. !Empty( mCODIGOINT )
         GRAVACAMPO( { "CODIGOINT" }, { "mCODIGOINT" } )
      ENDIF
      IF Empty( NOME ) .AND. !Empty( mNOME )
         GRAVACAMPO( { "NOME" }, { "mNOME" } )
      ENDIF
      IF Empty( COGNOME ) .AND. !Empty( mCOGNOME )
         GRAVACAMPO( { "COGNOME" }, { "mCOGNOME" } )
      ENDIF
      IF Empty( CLIENTE ) .AND. !Empty( mCLIENTE )
         GRAVACAMPO( { "CLIENTE" }, { "mCLIENTE" } )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   IF lSOOP
      RETU
   ENDIF
   IF MDG( "Excluir Composicao Produtos Inativos" )
      MAS2CHKARQ( "MS03" )
   ENDIF
   IF MDG( "Excluir Operacoes Produtos Inativos" )
      MAS2CHKARQ( "MS06" )
   ENDIF

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAS2CHKARQ()
// +
// +    Called from ( m_a2.prg     )   2 - function ma2chkprg()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAS2CHKARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAS2CHKARQ( cARQ )

   IF cARQ = "MS06"
      IF !USEMULT( { { "MS01", 1, 2 }, { cARQ, 1, 99 }, { "MS06BX", 1, 99 } } )
         RETU .F.
      ENDIF
   ELSE
      IF !USEMULT( { { "MS01", 1, 2 }, { cARQ, 1, 99 } } )
         RETU .F.
      ENDIF
   ENDIF
   dbSelectAr( cARQ )
   INITVARS()
   CLRVARS()
   dbGoTop()
   WHILE !Eof()
      mCODIGO := AllTrim( CODIGO )
      MDS( mCODIGO )
      lTEM := .F.
      dbSelectAr( "MS01" )
      dbGoTop()
      IF dbSeek( mCODIGO )
         IF ATIVO <> "N"
            lTEM := .T.
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      WHILE mCODIGO = AllTrim( CODIGO ) .AND. !Eof()
         IF !lTEM
            IF cARQ = "MS06"
               EQUVARS()
               NOVOOPA( "MS06BX",,, .F. )
            ENDIF
            dbSelectAr( cARQ )
            netrecdel()
         ENDIF
         dbSkip()
      ENDDO
   ENDDO
   dbCloseAll()
   IF userede( Carq, 0, 99 )
      dbSelectAr( cARQ )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netrecdel() }, {|| Empty( CODIGO ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
      IF cARQ = "MS03"
         zei_fort( nLASTREC,,, 0 )
         dbEval( {|| netrecdel() }, {|| Empty( CODCOMP ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
      ENDIF
      PACK
      dbCloseAll()
   ENDIF

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2PLTINV()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2PLTINV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2PLTINV

// Checa Itens Ativos sequencia composiao
   IF MDG( "Checar Composiao Sequencia" )
      MA2CHKPRG()
   ENDIF

   IF MDG( "Calcular Preo Inventario MatPrima" )
      CALCINV( "M" )
   ENDIF

   IF MDG( "Calcular Preo Inventario Componentes" )
      CALCINV( "C" )
   ENDIF

   IF MDG( "Calcular Preo Inventario Produtos" )
      MASCALINV()
   ENDIF


   IF !USEMULT( { { "MS01", 1, 99 }, { "MS06", 1, 99 }, { "MT01", 1, 99 }, { "MU01", 1, 99 }, { "MS03", 1, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MS01" )
   MDS()
   dbGoTop()
   WHILE !Eof()
      cCODIGO := AllTrim( CODIGO )
      IF Empty( PLTINV )
         netgrvcam( "PLTINV", PLTINV )
      ENDIF
      mPLANTA := PLTINV
      IF mPLANTA > 0
         @ 24, 00 SAY CODIGO
         dbSelectAr( "MS06" )
         dbGoTop()
         dbSeek( cCODIGO )
         WHILE cCODIGO = AllTrim( CODIGO ) .AND. !Eof()
            @ 24, 40 SAY SEQ
            @ 24, 44 SAY SSQ
            IF PLTINV <> mPLANTA
               netgrvcam( "PLTINV", mPLANTA )
            ENDIF
            dbSkip()
         ENDDO
         dbSelectAr( "MS03" )
         dbGoTop()
         dbSeek( cCODIGO )
         WHILE cCODIGO = AllTrim( CODIGO ) .AND. !Eof()
            IF TIPOENT = "C" .OR. TIPOENT = "M"
               @ 24, 40 SAY CODCOMP
               cSUBCOD := AllTrim( CODCOMP )
               dbSelectAr( if( TIPOENT = "C", "MT01", "MU01" ) )
               dbGoTop()
               IF dbSeek( cSUBCOD )
                  IF PLTINV <> mPLANTA
                     netgrvcam( "PLTINV", mPLANTA )
                  ENDIF
               ENDIF
            ENDIF
            dbSelectAr( "MS03" )
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( "MS01" )
      netgrvcam( "VALFATINV", 0 )
      dbSkip()
   ENDDO
   MA2PLT01( "MT01" )
   MA2PLT01( "MU01" )
   MA2PLT01( "MS01" )
   MA2PLT01( "MS06" )
   dbCloseAll()

   IF MDG( "Calcular Faturamento Mes" )
      ma2pltfat()
   ENDIF
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ma2pltfat()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ma2pltfat()

   aDAD := PEGMES( { "M2" } )
   nMES := aDAD[ 1 ]
   nANO := aDAD[ 2 ]
   cARQ := aDAD[ 5, 1 ]


   IF !USEMULT( { { "MS01", 1, 99 }, { caRQ, 1, 0 } } )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "TIPOENT+CODIGO" )
   ordSetFocus( "temp" )


   dbSelectAr( cARQ )
   dbGoTop()
   dbSeek( "P" )   // Acha o Primeiro Produto
   WHILE TIPOENT = "P" .AND. !Eof()
      @ 24, 00 SAY RecNo()
      mCODIGO := CODIGO
      mVAL    := 0
      WHILE mCODIGO = CODIGO .AND. TIPOENT = "P" .AND. !Eof()
         mVAL += VALORMER
         dbSelectAr( cARQ )
         dbSkip()
      ENDDO
      IF mVAL > 0
         dbSelectAr( "MS01" )
         dbGoTop()
         IF dbSeek( mCODIGO )
            netgrvcam( "VALFATINV", mVAL )
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
   ENDDO
   dbCloseAll()


   MA2PLT02( "MS01", "FAT" )
   MA2PLT02( "MS01" )
   MA2PLT02( "MS06" )
   MA2PLT02( "MT01" )
   MA2PLT02( "MU01" )


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2PLT02()
// +
// +    Called from ( m_a2.prg     )   2 - function ma2pltinv()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2PLT02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2PLT02( cARQ, cVAL )

   IF ValType( cVAL ) # "C"
      cVAL := "EST"
   ENDIF
   IF !USEMULT( { { cARQ, 1, 0 }, { "MSINV", 1, 99 }, { "MA01", 1, 1 } } )
      RETU .F.
   ENDIF
   IF cARQ = "MS01" .AND. cVAL = "FAT"   // Apaga Competencia
      dbSelectAr( "MSINV" )
      dbGoTop()
      WHILE !Eof()
         @ 24, 00 SAY RecNo()
         IF MES = nMES .AND. ANO = nANO
            netrecdel()
         ENDIF
         dbSelectAr( "MSINV" )
         dbSkip()
      ENDDO
   ENDIF
   MDS( cARQ )
   dbSelectAr( cARQ )

   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "PLTINV" )
   ordSetFocus( "temp" )


   dbGoTop()
   WHILE !Eof()
      @ 24, 10 SAY CODIGO
      mVAL    := 0
      mPLTINV := PLTINV
      WHILE mPLTINV = PLTINV .AND. !Eof()
         IF cVAL = "FAT"
            mVAL += VALFATINV
         ELSE
            IF PLTINV > 0 .AND. ESTQSAL > 0  // Menos 1 Inativo
               mVAL += ESTQSAL * VALINV
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      IF mVAL > 0
         mCOGNOME := ""
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( mPLTINV )
            mCOGNOME := COGNOME
         ENDIF
         dbSelectAr( "MSINV" )
         dbGoTop()
         IF !dbSeek( Str( mPLTINV, 8 ) + Str( nANO, 4 ) + Str( nMES, 2 ) )
            netrecapp()
            FIELD->CLIENTE := mPLTINV
            FIELD->COGNOME := mCOGNOME
            FIELD->MES     := nMES
            FIELD->ANO     := nANO
         ELSE
            netreclock()
         ENDIF
         DO CASE
         CASE cARQ = "MT01"
            FIELD->MAT := mVAL
         CASE cARQ = "MU01"
            FIELD->COM := mVAL
         CASE cARQ = "MS01" .AND. cVAL = "FAT"
            FIELD->FAT := mVAL
         CASE cARQ = "MS01"
            FIELD->EST := mVAL
         CASE cARQ = "MS06"
            FIELD->PRO := mVAL
         ENDCASE
         FIELD->MATCOM  := MAT + COM
         FIELD->ESP     := EST + PRO
         FIELD->TOT     := MAT + COM + PRO + EST
         FIELD->MATP    := PERC( MAT, FAT )
         FIELD->COMP    := PERC( COM, FAT )
         FIELD->MATCOMP := PERC( MATCOM, FAT )
         FIELD->ESTP    := PERC( EST, FAT )
         FIELD->PROP    := PERC( PRO, FAT )
         FIELD->ESPP    := PERC( ESP, FAT )
         FIELD->TOTP    := PERC( TOT, FAT )
         dbUnlock()
      ENDIF
      dbSelectAr( cARQ )
   ENDDO
   dbCloseAll()

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MA2PLT01()
// +
// +    Called from ( m_a2.prg     )   2 - function ma2pltinv()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2PLT01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2PLT01( cARQ )

   MDS( cARQ )
   dbSelectAr( cARQ )
   dbGoTop()
   WHILE !Eof()
      @ 24, 10 SAY CODIGO
      IF Empty( PLTINV )
         GRAVACAMPO( { "PLTINV" }, { "-1" } )   // Menos 1 Inativo
      ENDIF
      dbSkip()
   ENDDO


// + EOF: M_A2.PRG

// + EOF: m_a2.prg
// +
