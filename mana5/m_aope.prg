// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aope.prg
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



PRIV xPEDIDO

MAOPECHK()

PADRAX( 0,, 0, { "PE", "PE01" }, "Pedido Fornecedor" + spac( 14 ) + "T MP/Componente", ;
      "' '+STR(mPEDIDO,  5)+' '+STR(mFORNECEDO,  8)+' '+mCOGNOME+' '+mTIPPED+' '+mCODIGO", "IPE001", "IPE001",, ;
      {|| PADDEL( "PE01", xCHAVE, "PEDIDO", "xCHAVE" ) }, {|| MAOPREP() } ;
      , {|| ULTIMOREG( "PE", "PEDIDO", "mPEDIDO" ) }, "IPE00" )
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPREP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAOPREP

   xPEDIDO    := mPEDIDO
   xTIPPED    := mTIPPED
   xCODIGO    := mCODIGO
   xNOME      := mNOME
   xNOM2      := mNOM2
   xFORNECEDO := mFORNECEDO
   xCOGNOME   := mCOGNOME
   xUNIDADE   := mUNID
   PADRAO( 1, 1, 0, "PE01", "Pedido   Codigo     Inicial   Anterior  Saldo", ;
      "' '+STR(mPEDIDO,5)+' '+STR(mITEM,2)+' '+mCODIGO+' '+STR(mTOTKGINI,9,2)+' '+STR(mTOTKGANT,9,2)+' '+STR(mTOTKGEST,9,2)+' '+DTOC(mDATAFAT)", ;
      "IPEI",,, {|| PE01INC() }, {|| PADARR( "PE01", Str( xPEDIDO, 5 ), "PEDIDO", "XPEDIDO" ) } ;
      ,, {|| MAOPR01() },,, {|| MAOPR02( "PE01" ) },,,, .F. )


// para wPAD, wpPAD, wcPAD, wARQ, wCAB, wSRO, wACOR, wBTEL, wBGET,;
// wBINS, wBMON, wBKEY, wBIGU,wBSAY, lPADCRI, bPOSREP,;
// ePAD3, bDEL, pPAD, lpINS


   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PE01INC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PE01INC

   mITEM2  := 0
   mPEDIDO := xPEDIDO
   ULTIMOITEM( "PE01", Str( xPEDIDO, 5 ), "PEDIDO", "XPEDIDO", "ITEM", "mITEM", .F. )
   ULTIMOITEM( "PE01BX", Str( xPEDIDO, 5 ), "PEDIDO", "XPEDIDO", "ITEM", "mITEM2", .F. )
   IF mITEM2 > mITEM
      mITEM := mITEM2
   ENDIF
   mITEM++
   MDS( "Digite o ITEM" )
   @ 24, 20 GET mITEM VALID mITEM > 0 .AND. mITEM < 99
   READCUR()
   mCHAVE := Str( xPEDIDO, 5 ) + Str( mITEM, 2 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPR01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPR01

   mPEDIDO    := xPEDIDO
   mTIPPED    := xTIPPED
   mCODIGO    := xCODIGO
   mNOME      := xNOME
   mNOM2      := xNOM2
   mTIPOCLI   := "F"
   mCLIENTE   := xFORNECEDO
   mCOGNOME   := xCOGNOME
   mNRNOTAINI := Val( Str( mPEDIDO, 5 ) + "." + Str( mITEM, 2 ) )
   mUNIDADE   := xUNIDADE
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPR02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPR02( cARQ )

   IF cARQ <> "PE01" .OR. Len( cARQ ) > 4  // NÆo Processa Baixados
      RETU .T.
   ENDIF
   IF !Empty( mDATASAI ) .AND. !Empty( mTOTKGANT ) .AND. !Empty( mTOTKGSAI )
      IF !Empty( mNRNOTASAI )
         mTIPO    := mTIPPED
         mUNRNOTA := mNRNOTASAI
         mUFORNE  := mCLIENTE
         mUQTDE   := mTOTKGSAI
         mUDATA   := mDATASAI
         mTIPO    := PadR( mTIPO, 1 )
         mCODIGO  := PadR( mCODIGO, 24 )
         IF VERSEHA( "PECRT", mTIPO + mCODIGO + Str( mCLIENTE, 8 ) )
            REPORVARS( "PECRT", mTIPO + mCODIGO + Str( mCLIENTE, 8 ) )
         ELSE
            NOVOREG( "PECRT", mTIPO + mCODIGO + Str( mCLIENTE, 8 ) )
         ENDIF
      ENDIF
      BAIXAREM( "PE01", "PE01BX", Str( mPEDIDO, 5 ) + Str( mITEM, 2 ) )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPE01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPE01

   PARA cARQPE

   PADRAO( 0, 1, 0, cARQPE, "Pedido   Codigo     Inicial   Anterior  Saldo", ;
      "' '+STR(mPEDIDO,5)+' '+STR(mITEM,2)+' '+mCODIGO+' '+STR(mTOTKGINI,9,2)+' '+STR(mTOTKGANT,9,2)+' '+STR(mTOTKGEST,9,2)+' '+DTOC(mDATAFAT)", ;
      "IPEI",,,,,,,,, {|| MAOPR02( cARQPE ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPECHK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPECHK( cFILTER )

   MDS( "Aguarde Checando Pedidos" )
   IF !USEMULT( { { "MW02", 1, 99 }, { "PE", 1, 99 }, { "PE01", 1, 99 }, { "MS03", 1, 99 }, { "MB01", 1, 1 }, { "PECRT", 1, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MW02" )
   dbGoTop()
   WHILE !Eof()
      netgrvcam( "PRGENT", 0 )
      dbSkip()
   ENDDO
   dbSelectAr( "MS03" )
   dbSetOrder( 3 )   // Codcomp
   dbSelectAr( "PE" )
   IF ValType( cFILTER ) = "C"
      SET FILTER TO &FILTER
   ENDIF
   dbGoTop()
   WHILE !Eof()
      cCHAVE := Str( COMPRAS, 8 ) + Str( COMITEM, 3 )
      @ 24, 40 SAY PEDIDO
      mPEDIDO    := PEDIDO
      mCODCOMP   := CODIGO
      mFORNECEDO := FORNECEDO
      mNOME      := NOME
      mNOM2      := NOM2
      lFALTA     := .F.
      dbSelectAr( "MW02" )
      dbGoTop()
      IF !dbSeek( Cchave )
         ALERTX( "Falta Pedido: " + Cchave + " Programa: " + Str( mPEDIDO ) )
         lFALTA := .T.
      ELSE
         IF BLQITEM = "S"
            ALERTX( "Item do Pedido Bloqueado:" + Cchave + " Programa: " + Str( mPEDIDO ) )
            lFALTA := .T.
         ENDIF
         IF OBTER( "MW01", mPEDIDO, "CONTRATO" ) = "N"
            ALERTX( "Pedido NÆo ‚ Contrato:" + Cchave + " Programa: " + Str( mPEDIDO ) )
            lFALTA := .T.
         ELSE
            netgrvcam( "prgent", mPEDIDO )
            mNOME := Left( ITENOM, 50 )
            mNOM2 := SubStr( ITENOM, 51 )
         ENDIF
      ENDIF
      dbSelectAr( "MB01" )
      mDDDPCP    := ""
      mTELPCP    := ""
      mRAMPCP    := ""
      mCONPCP    := ""
      mDDDFAXPCP := ""
      mTELFAXPCP := ""
      mEMAILPCP  := ""
      mNOMEFOR   := ""
      dbSelectAr( "MB01" )
      dbGoTop()
      IF dbSeek( mFORNECEDO )
         mDDDPCP    := DDDPCP
         mTELPCP    := TELPCP
         mRAMPCP    := RAMPCP
         mCONPCP    := CONPCP
         mDDDFAXPCP := DDDFAXPCP
         mTELFAXPCP := TELFAXPCP
         mEMAILPCP  := EMAILPCP
         mNOMEFOR   := NOME
      ENDIF
      dbSelectAr( "PE" )
      netreclock()
      IF lFALTA
         field->COMPRAS   := 0
         field->COMITEM   := 0
         field->fornecedo := 0
         field->cognome   := ""
         field->NOME      := ""
         field->NOM2      := ""
      ELSE
         field->NOME := mNOME
         field->NOM2 := mNOM2
      ENDIF
      field->DDDPCP    := mDDDPCP
      field->TELPCP    := mTELPCP
      field->RAMPCP    := mRAMPCP
      field->CONPCP    := mCONPCP
      field->DDDFAXPCP := mDDDFAXPCP
      field->TELFAXPCP := mTELFAXPCP
      field->EMAILPCP  := mEMAILPCP
      field->NOMEFOR   := mNOMEFOR
      dbUnlock()
      dbSelectAr( "PE01" )
      dbGoTop()
      dbSeek( Str( mPEDIDO, 5 ) )
      WHILE mPEDIDO = PEDIDO .AND. !Eof()
         netreclock()
         IF lFALTA
            field->NOME := ""
            field->NOM2 := ""
         ELSE
            field->NOME := mNOME
            field->NOM2 := mNOM2
         ENDIF
         dbUnlock()
         dbSkip()
      ENDDO
      dbSelectAr( "MS03" )
      dbGoTop()
      dbSeek( mCODCOMP )
      WHILE AllTrim( mCODCOMP ) = AllTrim( CODCOMP ) .AND. !Eof()
         gravacampo( "PE", "mPEDIDO" )
         dbSkip()
      ENDDO
      dbSelectAr( "PE" )
      dbSkip()
   ENDDO
   dbSelectAr( "PE" )
   dbSetOrder( 2 )   // Tipo Fornecedor Codigo
   dbSelectAr( "PECRT" )
   dbGoTop()
   WHILE !Eof()
      lTEM       := .T.
      mCODIGO    := CODIGO
      mFORNECEDO := UFORNE
      mTIPO      := TIPO
      dbSelectAr( "PE" )
      dbGoTop()
      IF !dbSeek( mTIPO + mCODIGO + Str( mFORNECEDO, 8 ) )
         lTEM := .F.
      ENDIF
      dbSelectAr( "PECRT" )
      IF !lTEM
         DELEREG()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()




// + EOF: m_aope.prg
// +
