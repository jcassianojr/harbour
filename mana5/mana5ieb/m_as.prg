// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_as.prg
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

// :*****************************************************************************
// :
// :       M_AS.PRG: Cadastro de Produtos
// :      Linguagem: Clipper 5.x
// :        Sistema: Mana5 - ITAESBRA
// :      Copyright (c) 1994 by Disk Softwares S/C Ltda.
// :
// :*****************************************************************************


sMAS004 := SENHAX( "MAS004" )
sMAS005 := SENHAX( "MAS005" )


PADRAX( 0,, 0, { "MS01", "MS02", "MS01P" }, "C½digo " + " Cliente" + "Compras" + " Nome" + spac( 37 ) + "Unid" + spac( 2 ) + "IPI", ;
      "' '+mCODIGO+' '+STR(mFORNECEDO)+' '+mCOMPRA+' '+LEFT(mNOME,30)+' '+mUNID+' '+mCODIPI", ;
      "IMS101", "IMS101",, {|| MASDEL() }, ;
      {|| MASPOSREP() },, "MAS",,,,,, )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MASDEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MASDEL()

   IF MDG( "Apagar Lista de Pre+o Tamb'm" )
      PADDEL( "MS02", mCODIGO, "CODIGO", "mCODIGO" )
   ENDIF
   IF MDG( "Apagar Pre+o Planilha" )
      PADDEL( "MS01P", mCODIGO, "CODIGO", "mCODIGO" )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MASPOSREP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MASPOSREP()

   xCODIGO    := mCODIGO
   xFORNECEDO := mFORNECEDO
   xCOMPRA    := mCOMPRA
   IF sMAS004
      IF MDG( "Alterar Lista de Pre+o" )
         PADRAO( 1, 1, 0, "MS02", "  Data   Tipo    Valor Compra  Cliente     UN CF A", ;
            "' '+DTOC(mDATA)+' '+mTIPO+' '+STR(mVALOR, 10, 4)+' '+mCOMPRA+' '+STR(mFORNECEDO)+' '+mUNIDE+' '+mCOIDE+' '+mATUAL", ;
            "MAS2", "IMS201", "IMS201", ;
            {|| mCODIGO := xCODIGO }, ;
            {|| PADARR( "MS02", xCODIGO, "CODIGO", "XCODIGO" ) } )
      ENDIF
      IF MDG( "Alterar Pre+o Planilha-Pre+os Diferenciados Cliente" )
         PADRAO( 1, 1, 0, "MS01P", "Codigo Cliente", ;
            "' '+mCODIGO+' '+STR(mFORNECEDO)+' '+STR(mPPLAN)", ;
            "MASP",,, {|| mCODIGO := xCODIGO }, {|| PADARR( "MS01P", xCODIGO, "CODIGO", "XCODIGO" ) } )
      ENDIF
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MASCALINV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MASCALINV

   MDI( "Calculando Valor Inventario" )
   nFATOR := 0.7000
   nFATO2 := 0.5600
   MDS( "Digite o Fator/Fator Processo" )
   @ 24, 40 GET nFATOR
   @ 24, 60 GET nFATO2
   IF !READCUR()
      RETU .F.
   ENDIF
   IF !USEMULT( { { "MS01", 1, 1 }, { "MS02", 1, 1 }, { "MS06", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MS01" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY CODIGO
      cCODIGO := CODIGO
      nPRECO  := 0
      nPREC2  := 0
      cUNID   := UNID
      cUNI2   := UNID
      dDATA   := CToD( Space( 8 ) )
      dDAT2   := CToD( Space( 8 ) )
      dbSelectAr( "MS02" )
      dbGoTop()
      dbSeek( cCODIGO )
      WHILE cCODIGO = CODIGO .AND. !Eof()
         IF ATUAL # "N"
            IF Empty( COMPRA )   // Preferencialmente nao exportado
               nPRECO := VALOR
               IF !Empty( UNIDE )
                  cUNID := UNIDE
               ENDIF
               dDATA := DATA
            ELSE
               IF Empty( nPREC2 )
                  nPREC2 := VALOR
                  IF !Empty( UNIDE )
                     cUNI2 := UNIDE
                  ENDIF
                  dDAT2 := DATA
               ENDIF
            ENDIF
            IF !Empty( nPRECO )
               EXIT
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      IF Empty( nPRECO ) .AND. !Empty( nPREC2 )
         nPRECO := nPREC2
         cUNID  := cUNI2
         dDATA  := dDAT2
      ENDIF
      IF cUNID = "CT"
         nPRECO := Round( nPRECO / 100, 4 )
      ENDIF
      IF cUNID = "ML"
         nPRECO := Round( nPRECO / 1000, 4 )
      ENDIF
      IF nPRECO > 0
         dbSelectAr( "MS06" )
         dbGoTop()
         dbSeek( cCODIGO )
         WHILE cCODIGO = CODIGO .AND. !Eof()
            netreclock()
            FIELD->ULTPRC := nPRECO
            IF Empty( VALIII )
               FIELD->VALINV := nPRECO * nFATO2
            ELSE
               FIELD->VALINV := ( nPRECO * VALIII / 100 ) * nFATO2
            ENDIF
            dbUnlock()
            dbSkip()
         ENDDO
         dbSelectAr( "MS01" )
         netreclock()
         FIELD->ULTPRC  := nPRECO
         FIELD->VALINV  := nPRECO * nFATOR
         FIELD->ULTUND  := cUNID
         FIELD->ULTDATA := dDATA
         dbUnlock()
      ENDIF
      dbSelectAr( "MS01" )
      dbSkip()
   ENDDO
   dbCloseAll()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSTROCALIS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSTROCALIS()

   MDI( " Trocar Lista Produto" )
   nORIGEM  := 0
   nDESTINO := 0
   @ 23, 00 SAY "Origem Destino"
   @ 24, 00 GET nORIGEM          PICT "99999"
   @ 24, 10 GET nDESTINO         PICT "99999"
   IF !readcur()
      RETU .F.
   ENDIF
   IF userede( "MS02", 0, 99 )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netgrvcam( "FORNECEDO", nDESTINO ) }, {|| FORNECEDO = nORIGEM }, {|| zei_fort( nLASTREC,,, 1 ) } )
      dbCloseArea()
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSTROCACOD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSTROCACOD( nTIPO )

   IF ValType( nTIPO ) # "N"
      nTIPO := 1
   ENDIF
   MDI( " Trocar Codigo Produto" )
   cORI  := Space( 24 )
   cDES  := Space( 24 )
   cTIPO := Space( 1 )
   @ 22, 00 SAY "Origem"
   @ 23, 00 SAY "Destino"
   IF nTIPO = 4
      @ 21, 00 SAY "Tipo"
      @ 21, 10 GET cTIPO
   ENDIF
   @ 22, 10 GET cORI
   @ 23, 10 GET cDES
   IF !READCUR()
      RETU .F.
   ENDIF
   cORI := AllTrim( cORI )
   cDES := AllTrim( cDES )
   IF Len( CORI ) = 0 .OR. Len( cDES ) = 0
      ALERTX( "Necessario Preencher Origem/Destino" )
      RETU .F.
   ENDIF
   IF !MDG( "Mudar " + cORI + " para " + CDES )
      RETU .F.
   ENDIF
   IF !MDG( "Realmente Mudar " + CORI + " para " + CDES )
      RETU .F.
   ENDIF
   IF nTIPO = 1  // Fiscal
      IF !USEMULT( { { "MS01", 0, 99 }, { "MS02", 1, 99 } } )
         RETU .F.
      ENDIF
      mds( "Trocando MS01" )
      dbSelectAr( "MS01" )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netgrvcam( "CODIGO", cDES ) }, {|| CODIGO = cORI }, {|| zei_fort( nLASTREC,,, 1 ) } )
      dbCloseArea()
      mds( "Trocando MS02" )
      dbSelectAr( "MS02" )
      dbSetOrder( 3 )  // Produto
      MUDCODMS()
      dbCloseAll()
   ENDIF
   IF Ntipo = 2  // pcp
      IF !USEMULT( { { "OSCRT", 1, 99 }, { "MS03", 1, 99 }, { "MS06", 1, 99 } } )
         RETU .F.
      ENDIF
      mds( "Trocando OSCRT" )
      dbSelectAr( "OSCRT" )
      dbSetOrder( 4 )
      MUDCODMS()
      dbCloseArea()
      dbSelectAr( "MS03" )
      dbSetOrder( 4 )
      MUDCODMS()
      dbCloseArea()
      dbSelectAr( "MS06" )
      dbSetOrder( 2 )
      MUDCODMS()
      dbCloseAll()
   ENDIF
   IF nTIPO = 3  // NFS
      cARQ := "MM02"
      IF MDG( "Mes Fechado" )
         cARQ := "M2" + MESANO()
      ENDIF
      IF USEREDE( caRQ, 1, 99 )
         dbSetOrder( 5 )   // Codigo
         MUDCODMS()
         dbCloseArea()
      ENDIF
   ENDIF
   IF nTIPO = 4  // NFE
      cARQ := "MK02"
      IF MDG( "Mes Fechado" )
         cARQ := "K2" + MESANO()
      ENDIF
      IF USEREDE( caRQ, 1, 99 )
         dbSetOrder( 5 )   // Tipo + Codigo
         MUDCODMS( cTIPO + cORI )
         dbCloseArea()
      ENDIF
   ENDIF
   IF nTIPO = 5  // mo02
      IF USEREDE( "MO02", 1, 99 )
         dbSetOrder( 3 )   // Codigo
         MUDCODMS( cORI )
         dbCloseArea()
      ENDIF
   ENDIF

   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MUDCODMS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MUDCODMS( cBUSCA )

   IF ValType( cBUSCA ) # "C"
      cBUSCA := cORI
   ENDIF
   WHILE .T.
      dbGoTop()
      dbSeek( cBUSCA )
      IF cORI = AllTrim( CODIGO )
         netreclock()
         FIELD->CODIGO := cDES
         dbUnlock()
      ELSE
         EXIT
      ENDIF
   ENDDO
   RETU

// + EOF: m_as.prg
// +
