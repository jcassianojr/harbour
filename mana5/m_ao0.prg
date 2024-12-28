// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ao0.prg
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





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOFP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAOFP

   PADRAO( 0, 1, 0, "MOFP", "No." + spac( 6 ) + "Produto" + spac( 18 ) + "SEQ SSQ MAQ  Data     Inicial  Baixada", ;
      "' '+STR(mFP,8)+' '+mCODIGO+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+mME01COD+' '+DTOC(mDATA)+' '+STR(mQTDEPF,8)+' '+STR(mQTDEBX,8)", ;
      "MOFP",,, {|| ULTIMOREG( "MOFP", "FP", "mFP" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function maofo3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC maofo3

   PADRAO( 0, 1, 0, "OF03", "OF" + spac( 11 ) + "Seq SSQ Codigo" + spac( 19 ) + "Limite   Fabricar     Falta", ;
      "' '+STR(mOF,8,2)+' '+STR(mITEM,3)+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+mCODIGO+' '+DTOC(mDLIMP)+' '+STR(mQTFAB,10,3)+' '+STR(mQTFAL,10,3)", ;
      "MAOF3", "MAOF31", "MAOF31" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOCDA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOCDA

   MDI( " Ý Importar Padrao RND " )
   cVAR     := Space( 128 )
   cCODIGO  := Space( 24 )
   cPLANTA  := Space( 10 )
   cSISCO   := Space( 5 )
   cPONTO   := "S"
   nHANDLE  := 0
   dINI     := dFIM := dPRG := ZDATA
   cTIPO    := "S"
   cARQ     := ""
   cARQUIVO := ""
   cAUTPED  := "N"
   cSOMAPR  := "S"
   cCHKPRG  := "S"
   nLINHA   := 0
   cPLINI   := Space( 10 )
   cPLFIM   := repl( "Z", 10 )
   TELASAY( "RND001" )
   EDITSAY( "RND001" )
   DO CASE
   CASE cTIPO = "S"
      cTIPO    := "PE"
      cARQ     := "OSPRG"
      cARQUIVO := "\EDIWISE\EXPORT\GMB     .TXT"
   CASE cTIPO = "D"
      cTIPO    := "PD"
      cARQ     := "OSPR2"
      cARQUIVO := "\EDIWISE\EXPORT2\GMB     .TXT"
   CASE cTIPO = "A"
      cTIPO    := "DA"
      cARQ     := "OSPR2"
      cARQUIVO := "\EDIWISE\EXPORT2\DIA     .TXT"
   CASE cTIPO = "B"
      cTIPO    := "SA"
      cARQ     := "OSPRG"
      cARQUIVO := "\EDIWISE\EXPORT\SEM     .TXT"
   ENDCASE
   cPLINI   := AllTrim( cPLINI )
   cPLFIM   := AllTrim( cPLFIM )
   cPLREF   := Space( 5 )
   cPLPAD   := "NAO"
   cTIRAP   := "NAO"
   cARQUIVO := PadR( cARQUIVO, 70 )
   MDI( " Ý Importar Padrao RND " )
   @ 21, 00 SAY "Arquivo"
   @ 21, 10 GET cARQUIVO
   @ 22, 00 SAY "Planta Referencia"
   @ 22, 30 GET cPLREF
   @ 22, 40 GET cPLPAD              PICT "!!!" VALID cPLPAD = "NAO" .OR. cPLPAD = "SIM"
   @ 23, 00 SAY "Remover Pontos"
   @ 23, 30 GET cTIRAP              PICT "!!!" VALID cTIRAP = "NAO" .OR. cTIRAP = "SIM"
   IF !READCUR()
      RETU .F.
   ENDIF
   cARQUIVO := AllTrim( cARQUIVO )
   cARQUIVO := StrTran( cARQUIVO, " ", "" )
   IF !File( cARQUIVO )
      ALERTX( "N„o Encontrei o Arquivo" )
      RETU .F.
   ENDIF
   dIMP := FILEDATE( cARQUIVO )
   IF !MDG( "Importar:" + cARQUIVO + " de " + DToC( dIMP ) )
      RETU .F.
   ENDIF
   lAPAGA := MDG( "Zerar todos lan‡amentos Anteriores" )
   IF !USEREDE( cARQ, 0, 99 )
      RETU .F.
   ENDIF
   IF lAPAGA
      ZAP
   ENDIF
   dbGoBottom()
   nREG := NUMERO
   nREG++
   dbSetOrder( 3 )   // Produto Planta Programa
   nHANDLE := hb_fopen( cARQUIVO )
   IF nHANDLE <= 0
      dbCloseAll()
      ALERTX( "Erro Abrindo " + Carquivo )
      RETU .F.
   ENDIF
   lITP     := .F.
   lPRI     := .F.
   cLINHA01 := ""
   cHORA    := ""
   IF nHANDLE = 0
      ALERTX( "Arquivo n„o Pode ser Aberto" )
      dbCloseAll()
      RETU .F.
   ENDIF
   MDI( " Ý Importar Padrao RND " )
   WHILE .T.
      cVAR := FREADLINE( nHANDLE )
      IF Empty( cLINHA01 )
         cLINHA01 := cVAR
      ELSE
         lPRI := .T.
      ENDIF
      cREFTIP := " "
      nLINHA++
      @ 23, 00 SAY "Linha " + Str( nLINHA, 8 )
      @ 24, 00 SAY Left( cVAR, 3 )
      DO CASE
      CASE cLINHA01 = cVAR .AND. lPRI
         ALERTX( "Retornou ao primeiro Registro" )
         IF MDG( "Encerrar Importacao-Recomendavel" )
            EXIT
         ENDIF
      CASE Left( cVAR, 3 ) = "   "
         ALERTX( "Linha em Branco" )
         IF MDG( "Encerrar Importacao-Recomendavel" )
            EXIT
         ENDIF
      CASE cTIPO = "DA" .OR. cTIPO = "SA"
         cSISCO  := AllTrim( SubStr( cVAR, 25, 10 ) )
         cPLANTA := cSISCO
         cCODIGO := AllTrim( SubStr( cVAR, 1, 24 ) )
         IF cPONTO = "S"
            cCODIGO := SubStr( cCODIGO, 1, 2 ) + "." + SubStr( cCODIGO, 3, 3 ) + "." + SubStr( cCODIGO, 6, 3 )
         ENDIF
         cDATA    := DToC( SToD( SubStr( cVAR, 35, 8 ) ) )
         cQTDE    := SubStr( cVAR, 43, 8 )
         dDATAPRG := SToD( SubStr( cVAR, 51, 8 ) )
         IF dDATAPRG = dPRG .OR. cCHKPRG = "N"
            MAOCDAGRV()
         ENDIF
      CASE !lITP .AND. Left( cVAR, 3 ) = "ITP"
         lITP := .T.
      CASE lITP .AND. Left( cVAR, 3 ) = "ITP"
         ALERTX( "Retornou ao primeiro Registro" )
         IF MDG( "Encerrar Importacao-Recomendavel" )
            EXIT
         ENDIF
      CASE Left( cVAR, 3 ) = "PE1"
         cSISCO  := AllTrim( SubStr( cVAR, 109, 5 ) )  // 109 113
         cPLANTA := cSISCO
         cCODIGO := AllTrim( SubStr( cVAR, 37, 30 ) )
         IF cPONTO = "S"
            cCODIGO := SubStr( cCODIGO, 1, 2 ) + "." + SubStr( cCODIGO, 3, 3 ) + "." + SubStr( cCODIGO, 6, 3 )
         ENDIF
      CASE Left( cVAR, 3 ) = "PD1"
         cSISCO  := AllTrim( SubStr( cVAR, 65, 5 ) )   // 109 113
         cPLANTA := cSISCO
         cCODIGO := AllTrim( SubStr( cVAR, 4, 11 ) )
         IF cPONTO = "S"
            cCODIGO := SubStr( cCODIGO, 1, 2 ) + "." + SubStr( cCODIGO, 3, 3 ) + "." + SubStr( cCODIGO, 6, 3 )
         ENDIF
         cREFTIP := SubStr( cVAR, 177, 1 )
      CASE Left( cVAR, 3 ) = "FTP"  // nLIDO<=0
         EXIT
      ENDCASE
      IF Left( cVAR, 3 ) = "PE3" .AND. cTIPO <> "DA"
         FOR X := 1 TO 7
            cPRO  := SubStr( cVAR, ( X * 17 ) - 13, 17 )
            cDATA := SubStr( cPRO, 5, 2 ) + "/" + SubStr( cPRO, 3, 2 ) + "/" + SubStr( cPRO, 1, 2 )
            cQTDE := SubStr( cPRO, 9, 9 )
            MAOCDAGRV()
         NEXT X
      ENDIF
      IF Left( cVAR, 3 ) = "PD2" .AND. cTIPO <> "DA"
         FOR X := 1 TO 6
            cPRO  := SubStr( cVAR, ( X * 19 ) - 15, 19 )
            cDATA := SubStr( cPRO, 5, 2 ) + "/" + SubStr( cPRO, 3, 2 ) + "/" + SubStr( cPRO, 1, 2 )
            cHORA := SubStr( cPRO, 7, 4 )
            // ALERTX(cHORA)
            // QUIT
            cQTDE := SubStr( cPRO, 11, 9 )
            MAOCDAGRV()
         NEXT X
      ENDIF
   ENDDO
   FClose( nHANDLE )
// Apagando Duplicidades
   dbSelectAr( cARQ )
   dbSetOrder( 3 )
   dbGoTop()
   WHILE !Eof()
      mCHAVE := PRODUTO + PLANTA + DToS( PROGRAMA ) + Str( QTDE, 8 )
      dbSkip()
      IF !Eof() .AND. mCHAVE = PRODUTO + PLANTA + DToS( PROGRAMA ) + Str( QTDE, 8 )
         DELEREG(,, .F., .F. )
      ENDIF
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOCDAGRV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOCDAGRV

   IF Empty( cPLANTA ) .OR. cPLPAD = "SIM"
      cPLANTA := cPLREF
   ENDIF
   IF cTIRAP = "SIM"
      cCODIGO := TIRAOUT( cCODIGO )
   ENDIF
   dDATA := CToD( cDATA )
   nQTDE := Val( cQTDE )
   IF dDATA < dINI .OR. dDATA > dFIM
      IF cAUTPED = "N"
         RETU
      ENDIF
      cOPCAO := "N"
      @ 10, 10 SAY "Programa Fora do Periodo"
      @ 11, 10 SAY "Produto: " + cCODIGO
      @ 12, 10 SAY "Planta:  " + cPLANTA
      @ 13, 10 SAY "Programa:" + DToC( dDATA )
      @ 14, 10 SAY "Qtde:" + cQTDE
      @ 15, 10 SAY "Op‡ao:"
      @ 16, 10 SAY "Gravar (S)im (N)ao"
      @ 15, 20 GET cOPCAO                     VALID cOPCAO $ "SN" PICT "!"
      Readcur()
      IF cOPCAO = "N"
         RETU .F.
      ENDIF
   ENDIF
   IF AllTrim( cPLANTA ) >= cPLINI .AND. AllTrim( cPLANTA ) <= cPLFIM
   ELSE
      RETU .F.
   ENDIF
   IF DoW( dDATA ) = 0 .OR. DoW( dDATA ) = 7
      cOPCAO := "N"
      cOPCA2 := "1"
      @ 10, 10 SAY "Programa Final de Semana"
      @ 11, 10 SAY "Produto: " + cCODIGO
      @ 12, 10 SAY "Planta:  " + cPLANTA
      @ 13, 10 SAY "Programa:" + DToC( dDATA ) + " " + Cdia( ddata )
      @ 14, 10 SAY "Qtde:" + cQTDE
      @ 15, 10 SAY "Op‡ao:"
      @ 16, 10 SAY "Gravar (S)im (N)ao"
      @ 17, 10 SAY "Op‡ao:"
      @ 18, 10 SAY "1(Segunda)2(Sexta)3(Sabado)4(Domingo)"
      @ 15, 20 GET cOPCAO                                  VALID cOPCAO $ "SN"   PICT "!"
      @ 17, 20 GET cOPCA2                                  VALID cOPCA2 $ "1234" PICT "!"
      Readcur()
      IF cOPCAO = "N"
         RETU .F.
      ENDIF
      DO CASE
      CASE DoW( dDATA ) = 0 .AND. cOPCA2 = "1"   // Domingo Segunda
         dDATA++
      CASE DoW( dDATA ) = 0 .AND. cOPCA2 = "3"   // Domingo Sabado
         dDATA--
      CASE DoW( dDATA ) = 0 .AND. cOPCA2 = "2"   // Domingo Sexta
         dDATA -= 2
      CASE DoW( dDATA ) = 7 .AND. cOPCA2 = "4"   // Sabado Domingo
         dDATA++
      CASE DoW( dDATA ) = 7 .AND. cOPCA2 = "2"   // Sabado Sexta
         dDATA--
      CASE DoW( dDATA ) = 7 .AND. cOPCA2 = "1"   // Sabado Segunda
         dDATA += 2
      ENDCASE
   ENDIF

   IF nQTDE > 0 .AND. !Empty( dDATA )
      cOPCAO := "S"
      dbSelectAr( cARQ )
      dbGoTop()
      IF !dbSeek( PadR( cCODIGO, 24 ) + PadR( cPLANTA, 10 ) + DToS( dDATA ) )
         netrecapp()
         field->NUMERO   := nREG
         field->PRODUTO  := cCODIGO
         field->PLANTA   := cPLANTA
         field->PROGRAMA := dDATA
         field->DATAIMP  := dIMP
         field->HORAPRG  := Val( cHORA ) / 100
         nREG++
      ELSE
         DO CASE
         CASE cSOMAPR = "S"
            @ 09, 10 SAY "Arquivo TXT com Duplicidade Programa"
            @ 10, 10 SAY "Produto: " + cCODIGO
            @ 11, 10 SAY "Planta:  " + cPLANTA
            @ 12, 10 SAY "Programa:" + DToC( dDATA ) + " " + Cdia( ddata )
            @ 13, 10 SAY "Data Ori:" + cDATA + " " + Cdia( CToD( Cdata ) )
            @ 14, 10 SAY "Qtde:" + cQTDE
            @ 15, 10 SAY "Anterior:" + Str( QTDE )
            IF cREFTIP = "4"
               @ 16, 10 SAY "Atualiza‡Æo"
            ENDIF
            IF cREFTIP = "5"
               @ 16, 10 SAY "Substitui‡ao"
            ENDIF
            @ 17, 10 SAY "Op‡ao:"
            @ 18, 10 SAY "(S)oma (M)anter (A)tualiza"
            @ 17, 20 GET cOPCAO                       VALID cOPCAO $ "SMA" PICT "!"
            Readcur()
         CASE cSOMAPR = "D"
            IF Int( QTDE ) = Int( nQTDE )
               cOPCAO := "M"
            ENDIF
         OTHERWISE
            cOPCAO := "S"
         ENDCASE
         netreclock()
      ENDIF
      DO CASE  // Op‡ao M Mantem Valor
      CASE cOPCAO = "S"
         field->QTDE := QTDE + nQTDE
      CASE cOPCAO = "A"
         field->QTDE := nQTDE
      ENDCASE
      dbUnlock()
   ENDIF

   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function prgtrcplt()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC prgtrcplt()

   mdi( " Ý Trocar Planta de Programa Recebido" )
   cTIPO  := "S"
   cPLORI := Space( 10 )
   cPLDES := Space( 10 )
   @ 21, 00 SAY "Planta "
   @ 22, 00 SAY "Prg(S)emanal Prg(D)iaria Electrolux->D(E)lfor (O)rders"
   @ 21, 20 GET cPLORI
   @ 21, 35 GET cPLDES
   @ 22, 78 GET cTIPO
   IF !READCUR()
      RETU .F.
   ENDIF
   cPLORI := AllTrim( cPLORI )
   cPLDES := AllTrim( cPLDES )
   DO CASE
   CASE cTIPO = "S"
      cARQ := "OSPRG"
   CASE cTIPO = "D"
      cARQ := "OSPR2"
   CASE cTIPO = "E"
      cARQ := "OSPRE"
   CASE cTIPO = "O"
      cARQ := "OSPR3"
   ENDCASE
   IF USEREDE( cARQ, 0, 99 )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netgrvcam( "PLANTA", &cPLDES. ) }, {|| PLANTA = &cPLORI. }, {|| zei_fort( nLASTREC,,, 1 ) } )
      dbCloseAll()
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OSPRG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC OSPRG

   MDI( " Ý Importa‡Æo Programa‡ao Para Pedidos" )
   IF !MDG( "Os Progamas Antigos Foram Excluidos" )
      RETU .F.
   ENDIF
   dINI   := dFIM := ZDATA
   cTIPO  := "S"
   cARQ   := ""
   cPLINI := Space( 10 )
   cPLFIM := repl( "Z", 10 )
   @ 20, 00 SAY "Periodo "
   @ 21, 00 SAY "Planta "
   @ 22, 00 SAY "Prg(S)emanal Prg(D)iaria Electrolux->D(E)lfor (O)rders"
   @ 20, 20 GET dINI
   @ 20, 30 GET dFIM
   @ 21, 20 GET cPLINI
   @ 21, 35 GET cPLFIM
   @ 22, 78 GET cTIPO
   IF !READCUR()
      RETU .F.
   ENDIF
   cPLINI := AllTrim( cPLINI )
   cPLFIM := AllTrim( cPLFIM )

   DO CASE
   CASE cTIPO = "S"
      cARQ := "OSPRG"
   CASE cTIPO = "D"
      cARQ := "OSPR2"
   CASE cTIPO = "E"
      cARQ := "OSPRE"
   CASE cTIPO = "O"
      cARQ := "OSPR3"
   ENDCASE
   IF !USEMULT( { { "MO01", 1, 99 }, { "MO02", 1, 99 }, { "MA01", 1, 6 }, { cARQ, 1, 99 }, { "OSCRT", 1, 2 }, { "MS01", 1, 2 }, { "MS02", 1, 5 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MO01" )
   INITVARS()
   CLRVARS()
   dbSelectAr( "MO02" )
   INITVARS()
   CLRVARS()
   mDATA := ZDATA
   MDS( "" )

// Primeira Etapa Checar os
   lCONTINUA := .T.
   dbSelectAr( carq )
   dbGoTop()
   WHILE !Eof()
      cPLANTA := AllTrim( PLANTA )
      IF AllTrim( cPLANTA ) >= cPLINI .AND. AllTrim( cPLANTA ) <= cPLFIM
         mCODIGO := AllTrim( PRODUTO )
         @ 24, 00 SAY RecNo()
         @ 24, 10 SAY cPLANTA
         @ 24, 20 SAY mCODIGO
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( cPLANTA )
            mFORNECEDO := NUMERO
            dbGoTop()
            dbSelectAr( "OSCRT" )
            IF !dbSeek( Str( mFORNECEDO, 8 ) + mCODIGO )
               cERRO := "Produto:" + mCODIGO + " Cliente:" + Str( mFORNECEDO, 8 )
               ALERTX( "Falta Os" + cERRO )
               EMAILINT( "MOC00001", cERRO )
               lCONTINUA := .F.
               IF Empty( PEDIDOCLI )
                  cERRO := "Produto:" + mCODIGO + " Cliente:" + Str( mFORNECEDO, 8 ) + " OS:" + Str( OS )
                  ALERTX( "N§ Pedido Cliente Em Branco" + cERRO )
                  EMAILINT( "MOC00001", cERRO )
                  lCONTINUA := .F.
                  IF !MDG( "Continuar" )
                     EXIT
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            cERRO := "Planta:" + cPLANTA
            ALERTX( "Planta NÆo Associada ao Cadastro Cliente" + cERRO )
            EMAILINT( "MOC00002", cERRO )
            lCONTINUA := .F.
            IF !MDG( "Continuar" )
               EXIT
            ENDIF
         ENDIF
         dbSelectAr( cARQ )
      ENDIF
      dbSkip()
   ENDDO
   IF !lCONTINUA
      dbCloseAll()
      ALERTX( "Prg Nao Importada Corriga os Erros" )
      RETU
   ENDIF

   dbSelectAr( cARQ )
   dbGoTop()
   WHILE !Eof()
      cPLANTA := AllTrim( PLANTA )
      @ 24, 00 SAY RecNo()
      IF AllTrim( cPLANTA ) >= cPLINI .AND. AllTrim( cPLANTA ) <= cPLFIM
         IF PROGRAMA >= dINI .AND. PROGRAMA <= dFIM
            cPLANTA := AllTrim( PLANTA )
            mCODIGO := AllTrim( PRODUTO )
            @ 24, 10 SAY cPLANTA
            @ 24, 20 SAY mCODIGO
            mENTREGA   := PROGRAMA
            mDATABASE  := PROGRAMA
            mQTDEPED   := QTDE
            mDATAIMP   := DATAIMP
            nOS        := 0
            mUNID      := "PC"
            mPEDIDOCLI := ""
            IF cTIPO = "O" .OR. cTIPO = "E"
               mPEDCLIITE := SEQCLIPRG
            ELSE
               mPEDCLIITE := 0
            ENDIF
            mFORNECEDO := 0
            nPEDIDO    := 0
            mLISTA     := 0
            mHORAPRG   := HORAPRG
            dbSelectAr( "MA01" )
            dbGoTop()
            IF dbSeek( cPLANTA )
               mFORNECEDO := NUMERO
               mCOGNOME   := COGNOME
               mESTADO    := ESTADO
               mCONDPAG   := CONDPAG
               mVENDEDOR  := VENDEDOR
               mZONA      := ZONA
               mICM       := OBTER( "MD05", mESTADO, "ALIQUOTA" )
               mLISTA     := MO02LISTA
               // mLISTA:=NUMERO
               // IF ! EMPTY(MO02LISTA)
               // mLISTA:=MO02LISTA
               // ENDIF
            ENDIF
            dbSelectAr( "MS01" )
            dbGoTop()
            IF dbSeek( mCODIGO )
               mUNID := UNID
               mNOME := NOME
               dbSelectAr( "MS02" )
               dbGoTop()
               dbSeek( PadR( mCODIGO, 24 ) + Str( mLISTA, 5 ) )
               WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. mLISTA = FORNECEDO .AND. !Eof()
                  IF ATUAL # "N"
                     IF !Empty( UNIDE )
                        mUNID := UNIDE
                     ENDIF
                  ENDIF
                  dbSkip()
               ENDDO
               IF mUNID = "CT"
                  mQTDEPED /= 100
               ENDIF
               IF mUNID = "ML"
                  mQTDEPED /= 1000
               ENDIF
            ENDIF
            mQTDESAL := mQTDEPED
            dbSelectAr( "OSCRT" )
            dbGoTop()
            IF dbSeek( Str( mFORNECEDO, 8 ) + mCODIGO )
               mPEDIDOCLI := AllTrim( PEDIDOCLI )
               // IF cTIPO<>"O".and
               // mPEDCLIITE := PEDCLIITE
               // ENDIF
               mDATABASE := DATA
               nOS       := OS
               netreclock()
               field->DATAIMP := mDATAIMP
               dbUnlock()
            ELSE
               cERRO := "Produto:" + mCODIGO + " Cliente:" + Str( mFORNECEDO, 8 )
               ALERTX( "Falta Os" + cERRO )
               EMAILINT( "MOC00001", cERRO )
            ENDIF
            IF nOS > 0
               dbSelectAr( "MO02" )
               dbSetOrder( 5 )
               dbGoTop()
               IF dbSeek( Str( Mfornecedo, 5 ) + PadR( mCODIGO, 24 ) + DToS( mENTREGA ) + Str( mHORAPRG, 5, 2 ) )
                  cOPCAO := "A"
                  @ 09, 10 SAY "Os Ja Cadastrada Produto/Cliente/Entrega"
                  @ 10, 10 SAY "OS:" + Str( OS )
                  @ 11, 10 SAY "Produto: " + CODIGO
                  @ 12, 10 SAY "Cliente:  " + Str( FORNECEDO )
                  @ 13, 10 SAY "Entrega:" + DToC( ENTREGA ) + " " + Str( HORAPRG, 5, 2 )
                  @ 14, 10 SAY "Qtde:" + Str( mQTDEPED )
                  @ 15, 10 SAY "Anterior:" + Str( QTDEPED )
                  @ 17, 10 SAY "Op‡ao:"
                  @ 18, 10 SAY "(S)oma (M)anter (A)tualiza"
                  @ 17, 20 GET cOPCAO                                        VALID cOPCAO $ "SMA" PICT "!"
                  Readcur()
                  netreclock()
                  IF cOPCAO = "A"
                     field->QTDEENT := 0
                     field->QTDEPED := mQTDEPED
                     field->HORAPRG := mHORAPRG
                  ENDIF
                  IF cOPCAO = "S"
                     field->QTDEPED := QTDEPED + mQTDEPED
                  ENDIF
                  field->QTDESAL := QTDEPED - QTDEENT
                  dbUnlock()
               ELSE
                  mPEDIDO := Int( nOS )
                  dbSelectAr( "MO01" )
                  dbSetOrder( 1 )
                  dbGoTop()
                  IF dbSeek( mPEDIDO + .99 )
                     WHILE dbSeek( mPEDIDO )
                        mPEDIDO += .01
                     ENDDO
                  ELSE
                     dbSeek( mPEDIDO )
                     WHILE Int( nOS ) = Int( PEDIDO ) .AND. !Eof()
                        mPEDIDO := PEDIDO
                        dbSkip()
                     ENDDO
                     mPEDIDO += .01
                  ENDIF
                  mOS       := mPEDIDO
                  mTIPOPRG  := cTIPO
                  mBAIXAM   := "N"
                  mITEM     := 1
                  mCONSUMO  := "N"
                  mTIPOSERV := "1"
                  mPEDMEN   := "N"
                  mGERAOF   := "N"
                  NOVOOPA( "MO01", .T., .T. )
                  NOVOOPA( "MO02", .T., .T. )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbCloseAll()
   RELEASE ALL LIKE M *
   IF MDG( "Atualizar Pedidos-Recomendavel" )
      MAOITA01()
   ELSE
      MAOFIXAR()
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOFIXAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOFIXAR()

   MDS( " Aguarde. Fechando os arquivos de dados ..." )
   IF !USEMULT( { { "MO01", 1, 99 }, { "MO02", 1, 99 }, { "OF01", 1, 99 }, { "OF02", 1, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MO02" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY PEDIDO
      mPEDIDO := PEDIDO
      IF PEDIDO = 0
         DELEREG(,, .F., .F. )
      ENDIF
      dbSelectAr( "MO01" )
      dbGoTop()
      lTEM := dbSeek( mPEDIDO )
      dbGoTop()
      dbSelectAr( "MO02" )
      IF !lTEM
         mOF     := PEDIDO
         mITEM   := ITEM
         mCODIGO := CODIGO
         DELEREG(,, .F., .F. )
         DELEREG( "OF01", Str( mPEDIDO, 8, 2 ) + Str( mITEM, 3 ), .F., .F., .T. )
         MAOFDEL( .F. )
         dbSelectAr( "MO02" )
      ENDIF
      dbSkip()
   ENDDO

   dbSelectAr( "mo02" )
   dbSetOrder( 4 )   // Pedido
   dbSelectAr( "mo01" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY PEDIDO
      mPEDIDO := PEDIDO
      IF PEDIDO = 0
         DELEREG(,, .F., .F. )
      ENDIF
      dbSelectAr( "MO02" )
      dbGoTop()
      lTEM := dbSeek( mPEDIDO )
      dbSelectAr( "mo01" )
      IF !lTEM
         DELEREG(,, .F., .F. )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()

   FIXAR( "MO01" )
   FIXAR( "MO02" )
   FIXAR( "OF01" )
   FIXAR( "OF02" )
   FOR X := 1 TO 18
      IF X < 13 .AND. x > 14   // 13 e catorze nao usam mais
         cARQ := "OR" + StrZero( X, 2 )
         FIXAR( cARQ )
      ENDIF
   NEXT X
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OFZER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC OFZER()

   ZAPARQ( { { "OF01", .F., .F. }, { "OF02", .T., .F. }, { "OR01", .T., .F. }, { "OR02", .T., .F. }, ;
      { "OR03", .T., .F. }, { "OR04", .T., .F. }, { "OR05", .T., .F. }, ;
      { "OR06", .T., .F. }, { "OR07", .T., .F. }, { "OR08", .T., .F. }, ;
      { "OR09", .T., .F. }, { "OR10", .T., .F. }, { "OR11", .T., .F. }, ;
      { "OR17", .T., .F. }, { "OR18", .T., .F. }, ;
      { "OR12", .T., .F. }, { "OR15", .T., .F. }, { "OR16", .T., .F. } } )
   ZAPARQ( { { "OF03", .T., .F. }, { "OR01BX", .T., .F. }, { "OR02BX", .T., .F. }, ;
      { "OR03BX", .T., .F. }, { "OR04BX", .T., .F. }, { "OR05BX", .T., .F. }, ;
      { "OR06BX", .T., .F. }, { "OR07BX", .T., .F. }, { "OR08BX", .T., .F. }, ;
      { "OR09BX", .T., .F. }, { "OR10BX", .T., .F. }, { "OR11BX", .T., .F. }, ;
      { "OR17BX", .T., .F. }, { "OR18BX", .T., .F. }, ;
      { "OR12BX", .T., .F. }, { "OR15BX", .T., .F. }, { "OR16BX", .T., .F. } } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mAORENUM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mAORENUM()

   MDI( "Renumerar Numero de Pedido" )
   nORI := 0
   nDES := 0
   MDS( "Digite Pedido Origem/Destino" )
   @ 24, 40 GET nORI PICT "9999.99"
   @ 24, 60 GET nDES PICT "9999.99"
   READCUR()
   IF VERSEHA( "MO01", nDES )
      ALERTX( "Pedido Destino Ja existente" )
      RETU .F.
   ENDIF
   IF !VERSEHA( "MO01", nORI )
      ALERTX( "Pedido Origem nao Existente" )
      RETU .F.
   ENDIF
   IF !USEMULT( { { "MO01", 0, 99 }, { "MO02", 0, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MO01" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "PEDIDO", nDES ) }, {|| PEDIDO = nORI }, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbSelectAr( "MO02" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "PEDIDO", nDES ) }, {|| PEDIDO = nORI }, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbSelectAr( "MO01" )
   dbGoTop()
   IF dbSeek( nDES )
      field->OS := nDES
   ENDIF
   dbSelectAr( "MO02" )
   dbGoTop()
   IF dbSeek( nDES )
      field->OS := nDES
   ENDIF
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAORECLI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAORECLI()

   cORIGEM := cDESTINO := Space( 20 )
   MDI( "Renumerar Pedido Cliente" )
   @ 22, 00 SAY "Origem"
   @ 23, 00 SAY "Destino"
   @ 22, 10 GET cORIGEM
   @ 23, 10 GET cDESTINO
   IF !READCUR()
      RETU .F.
   ENDIF
   cORIGEM := AllTrim( cORIGEM )
   IF !USEREDE( "MO01", 1, 99 )
      RETU .F.
   ENDIF
   MDS( "Alterando" )
   dbGoTop()
   WHILE !Eof()
      IF !Empty( PEDIDOCLI )   // Trava Sem Numero
         IF cORIGEM = AllTrim( PEDIDOCLI )
            netgrvcam( "PEDIDOCLI", cDESTINO )
            @ 24, 00 SAY RecNo()
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOZERCLI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOZERCLI()

   MDI( "Zerar Codigo Cliente" )
   mFORNECEDO := 0
   MDS( "Digite o Codigo do Cliente" )
   @ 24, 40 GET mFORNECEDO
   IF !READCUR()
      RETU .F.
   ENDIF
   IF Empty( mFORNECEDO )
      RETU .F.
   ENDIF
   IF !USEREDE( "MO01", 1, 99 )
      RETU .F.
   ENDIF
   MDS( "Alterando" )
   dbGoTop()
   WHILE !Eof()
      IF !Empty( FORNECEDO )   // Trava Sem Numero
         IF FORNECEDO = mFORNECEDO
            netgrvcam( "PEDIDOCLI", "" )
            @ 24, 00 SAY RecNo()
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAODUP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAODUP

   MDI( " Ý Duplica‡ao Pedido" )
   nORI     := 0.00
   nDES     := 0.00
   nQTD     := 1
   dENTREGA := ZDATA
   CRIARVARS( "MO01" )
   CRIARVARS( "MO02" )
   MDS( "Origem Destino Entrega Quantidade" )
   @ 24, 30 GET nORI     PICT "9999.99"
   @ 24, 40 GET nDES     PICT "9999.99"
   @ 24, 50 GET dENTREGA
   @ 24, 60 GET nQTD
   IF !READCUR()
      RETU .F.
   ENDIF
   IF USEMULT( { { "MO01", 1, 99 }, { "MO02", 1, 99 } } )
      FOR X := 1 TO nQTD
         dbSelectAr( "MO01" )
         dbGoTop()
         IF dbSeek( nORi )
            EQUVARS()
            mPEDIDO  := nDES
            mOS      := nDES
            mENTREGA := dENTREGA
            NOVOOPA( "MO01" )
            dbSelectAr( "MO02" )
            dbGoTop()
            IF dbSeek( Str( nORI, 8, 2 ) )
               EQUVARS()
               mPEDIDO  := nDES
               mOS      := nDES
               mENTREGA := dENTREGA
               NOVOOPA( "MO02" )
            ENDIF
         ENDIF
         nDES     += .01
         dENTREGA += 7
      NEXT X
      dbCloseAll()
   ENDIF


// + EOF: m_ao0.prg
// +
