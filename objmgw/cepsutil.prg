// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : cepsutil.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegcidconv()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION pegcidconv( cUF, cNOME )

   LOCAL cDBF

   cDBF := Alias()
   IF Empty( cUF ) .OR. Empty( cNOME )
      RETURN cNOME
   ENDIF
   dbSelectAr( "cidconv" )
   dbGoTop()
   IF dbSeek( cUF + cNOME )
      cNOME := CIDDES
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF

   RETURN cNOME



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function BUSCAIBGE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION BUSCAIBGE( cUF, cCIDADE )

   LOCAL cIBGE
   LOCAL cALIAS
   LOCAL cBUSCA

   cALIAS := Alias()

   cBUSCA := cUF + cCIDADE
   cIBGE  := ""
   cBUSCA := StrTran( AllTrim( cBUSCA ), "'", " " )  // tirar como d'agua d'olho

   dbSelectAr( "MD10" )
   dbSetOrder( 1 )
   dbGoTop()
   IF dbSeek( cbUSCA )
      cIBGE := MD10->CODIBGE
   ELSE
      cBUSCA := cUF + PEGCIDCONV( cUF, cCIDADE )
      dbSelectAr( "MD10" )
      dbGoTop()
      IF dbSeek( cBUSCA )
         cIBGE := MD10->CODIBGE
      ENDIF
   ENDIF
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN cIBGE


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IRRFIBGE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION IRRFIBGE( cBUSCA )

   LOCAL cIBGE
   LOCAL cALIAS

   cIBGE  := ""
   cALIAS := Alias()
   dbSelectAr( "MD10" )
   dbSetOrder( 5 )
   dbGoTop()
   IF dbSeek( cbUSCA )
      cIBGE := MD10->CODIBGE
   ENDIF
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN cIBGE


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function coduf()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION coduf( cBUSCA, cTIPO )  // ibge

   LOCAL nPos  := 0
   LOCAL cRETU := "??"
   LOCAL aUF, aIBGE

   aUF := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
      "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
      "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO", "EX", "XX" }

   aIBGE := { "12", "27", "13", "16", "29", "23", "53", "32", "52", ;
      "21", "31", "50", "51", "15", "25", "26", "22", "41", ;
      "33", "24", "11", "14", "43", "42", "28", "35", "17", "54", "54" }


   IF ValType( cTIPO ) <> "C"
      cTIPO := "UF"
   ENDIF
// @ 23,00 SAY cBUSCA
// inkey(0)
   IF cTIPO = "UF"   // codigo->Sigla uf
      IF Len( cBUSCA ) > 2   // codigo ibge 7 digitos 2 primeiros estados
         cBUSCA := SubStr( cBUSCA, 1, 2 )
      ENDIF
      nPos := AScan( aIBGE, cBUSCA )
      IF nPos > 0
         cRETU := aUF[ nPos ]  // retorna o codigo do Estado
      ENDIF
   ELSE  // sigla uf->codigo
      nPos := AScan( aUF, cBUSCA )
      IF nPos > 0
         cRETU := aIBGE[ nPos ]  // retorna o codigo numerico do estado
      ENDIF
   ENDIF

   RETURN cRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tratanome()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tratanome( mNOME, lANSI, lACEN, lRANG )

   LOCAL nPOS

   IF ValType( lANSI ) <> "L"
      lANSI := .F.
   ENDIF
   IF ValType( lACEN ) <> "L"
      lACEN := .T.
   ENDIF
   IF ValType( lRANG ) <> "L"
      lACEN := .F.
   ENDIF

   mNOME := StrTran( AllTrim( mNOME ), "'", " " )  // tirar como d'agua d'olho
   mNOME := StrTran( mNOME, "  ", " " )  // tirar os duplos espacos
   mNOME := StrTran( mNOME, "-", " " )   // tirar os tracos
   mNOME := StrTran( mNOME, "  ", " " )  // tirar os duplos espacos
   IF lACEN
      mNOME := TIRACE( mNOME )
   ENDIF
   mNOME := StrTran( mNOME, ".", " " )   // tirar os .
   mNOME := StrTran( mNOME, ",", " " )   // tirar os ,
   mNOME := StrTran( mNOME, "&39;", " " )  // algum encode nao tratado
   mNOME := StrTran( mNOME, "  ", " " )  // tirar os duplos espacos
   IF lANSI
      mNOME := win_ANSIToOEM( mNOME )  // HB_ansitooem(mNOME)
   ENDIF
   mNOME := AllTrim( Upper( mNOME ) )
   nPOS  := At( "(", mNOME )
   IF nPOS > 0
      mNOME := SubStr( mNOME, 1, nPOS - 1 )
   ENDIF
   IF lRANG  // remove nao carateres numero e simbolos
      mNOME := RANGEREPL( Chr( 0 ), Chr( 31 ), mNOME, " " )
      mNOME := RANGEREPL( Chr( 127 ), Chr( 255 ), mNOME, " " )
   ENDIF

   RETURN mNOME

// + EOF: cepsutil.prg
// +
