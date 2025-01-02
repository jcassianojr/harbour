// +--------------------------------------------------------------------
// +
// +    Programa  : folis_a8.prg  Preparar Arquivo DIRF Juridica
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


FUNCTION folis_a8()

   CABE2( 'Gera IRRF Avulsa Juridica' )



   ALERTX( "So ‚ Gerado um codigo reten‡„o por arquivo" )
   ALERTX( "Sera necess rio gerar um arquivo para cada codigo e importar um a um" )

   GRAVA1     := "S"
   mrXTEL     := mrXDDD := mrXFAX := ""
   xrCGC      := xrNOME := ""
   xrDDD      := xrTEL := xrPESSOA := ""
   xrRESN     := xrRESC := xrFAX := xrRAMAL := mNOME := mNRCLIEN := ""
   mEMAIL     := CPFCNPJ := ""
   ANO        := "2005"
   ANOREF     := "2006"
   ARQ        := "C:\FOLHA\DIRF2006        "
   ARQDET     := "C:\FOLHA\DETA2006        "
   xNUMEROANT := Space( 12 )
   OPER       := "O"
   CODRET     := "0561"
   xNUMEROANT := Space( 12 )
   SITU       := "1"
   NATUR      := "0"
   IDEN       := "0"



   IF !DIRFEMPDAD()
      RETU .F.
   ENDIF


   IF !DIRFPEGDAD()
      RETU .F.
   ENDIF


   ARQ := AllTrim( ARQ )


   mCGC     := SubStr( xrCGC, 1, 2 ) + SubStr( xrCGC, 4, 3 ) + SubStr( xrCGC, 8, 3 )
   mEST     := SubStr( xrCGC, 12, 4 ) + SubStr( xrCGC, 17, 2 )
   mrCPF    := SubStr( xrRESC, 1, 3 ) + SubStr( xrRESC, 5, 3 ) + SubStr( xrRESC, 9, 3 ) + SubStr( xrRESC, 13, 2 )
   mCPFCNPJ := SubStr( CPFCNPJ, 1, 3 ) + SubStr( CPFCNPJ, 5, 3 ) + SubStr( CPFCNPJ, 9, 3 ) + SubStr( CPFCNPJ, 13, 2 )

   SEQ     := 1
   BEN     := 0
   aTOTREN := Array( 13 )
   aTOTDED := Array( 13 )
   aTOTIRR := Array( 13 )
   AFill( aTOTREN, 0 )
   AFill( aTOTDED, 0 )
   AFill( ATOTIRR, 0 )
   nREG02 := 0


   IF !netuse( "IRRF01" )  // AREDE("IRRF01","IRRF01",1) //Shared Brede PES
      RETU .F.
   ENDIF

   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "cgc" )
   ordSetFocus( "temp" )


   IF !NETUSE( "IRRF02" )  // AREDE("IRRF02","IRRF02",1) //SHARED Arede ajudir
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
// Gravano o Header Empresa Tipo 1
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

   RETURN .T.

// + EOF: folis_a8.prg
// +
