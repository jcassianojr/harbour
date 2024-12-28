// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a6.prg
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
// +    Function MA6JUR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MA6JUR()

   PADRAX( 0,, 0, { "IRRF01", "IRRF02" }, "Numero   Nome" + spac( 37 ) + "CGC", ;
      "' '+STR(mNUMERO,  8)+' '+mNOME+' '+mCGC", "MA6001", "MA6001", ;
      , {|| PADDEL( "IRRF02", Str( xCHAVE, 8 ), "NUMERO", "xCHAVE" ) }, ;
      {|| MA6REP() }, {|| mNUMERO := ULTIMOREG( "IRRF01", "NUMERO", "mNUMERO" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA6FIS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA6FIS()

   PADRAO( 0, 1, 0, "IRRF", "CPF - Nome", "' '+mCPF+' '+mNOME", "MA63", "MA6301", "MA6301" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA6REP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA6REP()

   xNUMERO := mNUMERO
   PADRAO( 1, 1, 0, "IRRF02", "Numero   It Mes  Cod  Natureza" + spac( 13 ) + "Renda" + spac( 8 ) + "Aliq. Reten‡„o", ;
      "' '+STR(mNUMERO,  8)+' '+STR(mITEM,  2)+' '+STR(mMES,  4)+' '+mDARF+' '+mNATUREZA+' '+STR(mRENDA, 12, 2)+' '+STR(mALIQUOTA,  5, 2)+' '+STR(mIRRF,  8, 2)", ;
      "MA62", "MA6201", "MA6201", {|| mNUMERO := xNUMERO }, {|| PADARR( "IRRF02", Str( xNUMERO, 8 ), "STR(xNUMERO,8)", "STR(NUMERO,8)" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DARF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC DARF( cCODIGO )

   IF !USEREDE( "MD02", 1, 1 )
      RETU .T.
   ENDIF
   dbGoTop()
   IF dbSeek( PadR( "CODIRRF", 12 ) + PadR( cCODIGO, 12 ) )
      mNATUREZA := Left( DESCRICAO, 20 )
      IF Empty( mALIQUOTA )
         mALIQUOTA := VARIACAO
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA6GER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA6GER

   GRAVA1     := "S"
   mrXTEL     := mrXDDD := mrXFAX := ""
   xrCGC      := xrNOME := ""
   xrDDD      := xrTEL := xrPESSOA := ""
   xrRESN     := xrRESC := xrFAX := xrRAMAL := mNOME := ""
   mEMAIL     := CPFCNPJ := ""
   ANO        := StrZero( Year( Date() ) - 1, 4 )
   ANOREF     := StrZero( Year( Date() ), 4 )
   ARQ        := "C:\TEMP\DIRF    .TXT"
   ARQDET     := " "
   OPER       := "O"
   CODRET     := "0561"
   SITU       := "1"
   NATUR      := "0"
   IDEN       := "0"
   nREG02     := 0
   xNUMEROANT := Space( 12 )


   MDI( " Gera IRRF " )
   IF !USEREDE( "MANEMP", 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( ZNUMERO )
      dbCloseAll()
      ALERTX( "Falta Cadastro Empresa" )
      RETU
   ENDIF
   xrCGC    := CGC
   xrNOME   := ACEPAD( NOME, 60 )
   xrDDD    := DDD
   xrTEL    := TELEFONE
   xrPESSOA := PESSOA
   xrFAX    := TELEFAX
   xrRAMAL  := ACEPAD( RAMAL, 6 )
   dbCloseAll()

   xrRESN  := Space( 60 )
   xrRESC  := Space( 14 )
   CPFCNPJ := Space( 14 )
   mEMAIL  := Space( 50 )

   mrXTEL := StrTran( xrTEL, "-", "" )
   mrXTEL := StrTran( mrXTEL, " ", "0" )
   mrXTEL := StrZero( Val( mrxTEL ), 8 )
   mrXFAX := StrTran( xrFAX, "-", "" )
   mrXFAX := StrTran( mrXFAX, " ", "0" )
   mrXFAX := StrZero( Val( mrxFAX ), 8 )
   mrXDDD := StrZero( Val( XRDDD ), 4 )

   DIRFPEGDAD( 2 )
   ARQ      := AllTrim( ARQ )
   mCGC     := SubStr( xrCGC, 1, 2 ) + SubStr( xrCGC, 4, 3 ) + SubStr( xrCGC, 8, 3 )
   mEST     := SubStr( xrCGC, 12, 4 ) + SubStr( xrCGC, 17, 2 )
   mrCPF    := SubStr( xrRESC, 1, 3 ) + SubStr( xrRESC, 5, 3 ) + SubStr( xrRESC, 9, 3 ) + SubStr( xrRESC, 13, 2 )
   mCPFCNPJ := SubStr( CPFCNPJ, 1, 3 ) + SubStr( CPFCNPJ, 5, 3 ) + SubStr( CPFCNPJ, 9, 3 ) + SubStr( CPFCNPJ, 13, 2 )

   SEQ     := 1
   aTOTREN := Array( 13 )
   aTOTDED := Array( 13 )
   aTOTIRR := Array( 13 )
   AFill( aTOTREN, 0 )
   AFill( aTOTDED, 0 )
   AFill( ATOTIRR, 0 )

   IF !USEREDE( "IRRF01", 1, 1 )   // Shared Brede PES
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "CGC" )
   ordSetFocus( "temp" )


   IF !USEREDE( "IRRF02", 1, 1 )   // SHARED Arede ajudir
      dbCloseAll()
      RETU .F.
   ENDIF

// Criando o Arquivo
   USO := FCreate( ARQ )
   IF FError() # 0
      ALERTX( "Erro na Cria‡„o do Arquivo" )
      RETU
   ENDIF
   IF GRAVA1 = "S"
      Mnrclien := znumero
      DIRFREG01()
   ENDIF

   dbSelectAr( "IRRF01" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY NOME
      aREND := Array( 13 )
      aDEDU := Array( 13 )
      aIRRF := Array( 13 )
      AFill( aREND, 0 )
      AFill( aDEDU, 0 )
      AFill( aIRRF, 0 )
      mNOME   := NOME
      mNUMERO := NUMERO
      mPESSOA := PESSOA
      IF PESSOA = "J"
         USOCGC := SubStr( CGC, 1, 2 ) + SubStr( CGC, 4, 3 ) + SubStr( CGC, 8, 3 )
         USOCGC += SubStr( CGC, 12, 4 ) + SubStr( CGC, 17, 2 )
      ELSE
         USOCGC := SubStr( CGC, 1, 3 ) + SubStr( CGC, 5, 3 ) + SubStr( CGC, 9, 3 ) + SubStr( CGC, 13, 2 )
         USOCGC := "000" + USOCGC
      ENDIF
      GRAVA := .F.
      dbSelectAr( "IRRF02" )
      dbGoTop()
      dbSeek( Str( mNUMERO, 8 ) )
      WHILE mNUMERO = NUMERO .AND. !Eof()
         IF MES > 0 .AND. MES < 13 .AND. DARF = CODRET
            GRAVA := .T.
            aREND[ MES ] += RENDA
            aDEDU[ MES ] += 0
            aIRRF[ MES ] += IRRF
         ENDIF
         dbSkip()
      ENDDO
      dbSelectAr( "IRRF01" )
      IF GRAVA
         DIRFREG02()
      ENDIF
      dbSelectAr( "IRRF01" )
      dbSkip()
   ENDDO
   dbCloseAll()


   FWrite( USO, Chr( 26 ) )
   FClose( USO )
   RETU .T.




// + EOF: m_a6.prg
// +
