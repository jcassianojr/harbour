// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dc3.prg
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

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_dc3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_dc3( nTIPO )

   LOCAL cARQZPL := Space( 80 )
   LOCAL cCAMZPL := Space( 80 )
   LOCAL nPOS    := 0
   LOCAL aARQZLP := {}

   MDI( "  Imprimir Etiquetas" )

   IF ntipo = 98 .OR. ntipo = 88
      cCAMZPL := PadR( ProfileString( "MANA5.INI", "PATH", "ZPL", hb_cwd() ), 80 )
      @ 23, 00 SAY "digite o caminhos com os arquivos zpl"
      @ 24, 00 GET cCAMZPL
      READCUR()
      cCAMZPL := AllTrim( CCAMZPL )
      IF Right( cCAMZPL ) <> "\"
         cCAMZPL += "\"
      ENDIF

      aARQZLP := FILENAMES( CCAMZPL + "*.Zpl" )

      nPOS := ESCARR( aARQZLP, 7, 7, 21, 78, aARQZLP, nPOS, "Arquivos zpl" )

      IF nPOS > 0
         cARQZPL := aARQZLP[ nPOS ]
         IF File( cCAMZPL + cARQZPL ) .AND. ntipo = 98   // tipo 88 sofrera macro subtirtuicao variaveis
            cPDFILE := filezebrapdf( cCAMZPL + cARQZPL )
            IF cPDFILE
               wapi_ShellExecute( 0, 0, cPDFILE, "", cCAMZPL, 1 )
               // hwnd,   lpOperation,  lpFile,   lpParameters,   lpDirectory,    nShowCmd
               // essSW_SHOWNORMAL = 1
            ENDIF
         ENDIF
      ENDIF
      RETURN
   ENDIF
   IF ntipo = 99 .OR. ntipo = 89
      cARQZPL := win_GetOpenFileName(, "Arquivos ZPL", ProfileString( "MANA5.INI", "PATH", "ZPL", hb_cwd() ), "Modelos ZPL", "*.ZPL", 1 )
      // @ 23,00 say "digite o caminho do arquivo zpl)"
      // @ 24,00 get cARQZPL
      // reADCUR()
      // cARQZPL:=ALLTRIM(CARQZPl)
      IF File( cARQZPL ) .AND. ntipo = 99  // tipo 89 sofrera macro subtirtuicao variaveis
         cPDFILE := filezebrapdf( cARQZPL )
         IF cPDFILE
            wapi_ShellExecute( 0, 0, cPDFILE, "", 0, 1 )
         ENDIF
      ENDIF
      RETURN
   ENDIF

   IF nTIPO = 4
      cFORN := Upper( OBTER( "CODIMP", "MDC3EY", "CONTEUDO" ) )
   ELSE
      cFORN := Upper( OBTER( "CODIMP", "MDC3EM", "CONTEUDO" ) )
   ENDIF
   lPERG := SENHAX( "MDC301" )
   nSEQ  := 1

   WHILE .T.
      cEQUIP   := Space( 6 )
      nCLIENTE := 1201
      cCLINOME := ""
      cLOTE    := "    /" + StrZero( Year( ZDATA ), 4 )
      cCODIGO  := Space( 24 )
      cNOME    := Space( 40 )
      nETIQ    := 0
      nQTDE    := 0
      cCODFNT  := "B"
      cCODSIZ  := "64"
      cBARSIZ  := "96"
      cDELIV   := Space( 15 )
      cUSING   := Space( 10 )
      cKANBAN  := Space( 5 )
      cDATA    := ZDATA
      nNF      := 1
      dDATANF  := ZDATA
      cINSP    := Space( 15 )  // Cliente Codigo
      TELASAY( "MDC301" )
      EDITSAY( "MDC301" )
      IF !READCUR()
         RETU
      ENDIF
      MDC3A()
   ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDC3A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MDC3A

   cETIQ    := StrTran( Str( nETIQ, 5 ), " ", "" )
   cLOTE    := StrTran( cLOTE, " ", "" )
   cQTDE    := StrTran( Str( nQTDE, 5 ), " ", "" )
   cEQUIP   := AllTrim( cEQUIP )
   cDELIV   := AllTrim( cDELIV )
   cUSING   := AllTrim( cUSING )
   cCODIGO  := StrTran( cCODIGO, ".", "" )
   cNOME    := AllTrim( cNOME )
   cCLINOME := AllTrim( cCLINOME )
   cKANBAN  := StrTran( cKANBAN, " ", "" )
   cCODIGO  := AllTrim( cCODIGO )
   cDATANF  := StrZero( Year( dDATANF ), 4 ) + "-" + StrZero( Month( dDATANF ), 2 ) + "-" + StrZero( Day( dDATANF ), 2 )
   cFORN    := AllTrim( cFORN )
   IF nTIPO = 88 .OR. nTIPO = 89
      IF nTIPO = 88  // 89 Ja esta com o caminho
         cARQZPL := cCAMZPL + cARQZPL
      ENDIF
      IF File( cARQZPL )
         cETIQUETA := hb_MemoRead( cARQZPL )
         // nem sempre o nome da substituicao sera igual a variaveis
         //
         // atencao a sequencia exemplo cDATANF cDATA usar mais palavras longas na frente
         aTROCA := {}
         aVALOR := {}
         AAdd( aTROCA, "cBARSIZ" )
         AAdd( aVALOR, cBARSIZ )
         AAdd( aTROCA, "cCLINOME" )
         AAdd( aVALOR, cCLINOME )
         AAdd( aTROCA, "cCODFNT" )
         AAdd( aVALOR, cCODFNT )
         AAdd( aTROCA, "cCODIGO" )
         AAdd( aVALOR, cCODIGO )
         AAdd( aTROCA, "cCODSIZ" )
         AAdd( aVALOR, cCODSIZ )
         AAdd( aTROCA, "cDATANF" )
         AAdd( aVALOR, cDATANF )
         AAdd( aTROCA, "cDATA" )
         AAdd( aVALOR, cDATA )
         AAdd( aTROCA, "cDELIV" )
         AAdd( aVALOR, cDELIV )
         AAdd( aTROCA, "cEQUIP" )
         AAdd( aVALOR, cEQUIP )
         AAdd( aTROCA, "cETIQ" )
         AAdd( aVALOR, cETIQ )
         AAdd( aTROCA, "cFORN" )
         AAdd( aVALOR, CcFORN )
         AAdd( aTROCA, "cINSP" )
         AAdd( aVALOR, cINSP )
         AAdd( aTROCA, "cKANBAN" )
         AAdd( aVALOR, cKANBAN )
         AAdd( aTROCA, "cLOTE" )
         AAdd( aVALOR, cLOTE )
         AAdd( aTROCA, "cNOME" )
         AAdd( aVALOR, cNOME )
         AAdd( aTROCA, "cQTDE" )
         AAdd( aVALOR, cQTDE )
         AAdd( aTROCA, "cUSING" )
         AAdd( aVALOR, cUSING )


         // AADD(aTROCA,"")
         // /    AADD(aVALOR,C)


         FOR XYZ := 1 TO Len( aTROCA )
            cETIQUETA := StrTran( cETIQUETA, aTROCA[ XYZ ], aVALOR[ ZYZ ] )
         NEXT XYZ
      ENDIF
   ENDIF


   IF lPERG
      IF !CHECKIMP( 0,, .T. )
         RETU .F.
      ENDIF
   ELSE
      IF !CHECKIMP()
         RETU .F.
      ENDIF
   ENDIF
   IMPRESSORA()
   IF nTIPO = 88 .OR. nTIPO = 89
      // imprimindo toda etiquetas
      // caso nao imprmir corretamnet usar memolinecount e uma a uma memoline
      @ PRow(), 0 SAY cETIQUETA
      IF At( "^PQ", cETIQUETA )   // Inclui quantidade se faltou no layout
         @ PRow() + 1, 0 SAY "^PQ" + cETIQ + ",0,0,N"
      ENDIF
      IF At( "^XZ", cETIQUETA )   // inclui fechamento se faltou no layout
         @ PRow() + 1, 0 SAY "^XZ"
      ENDIF

   ENDIF
   IF nTIPO = 1
      @ PRow(), 0   SAY "^XA"
      @ PRow() + 1, 0 SAY "^PRC"
      @ PRow() + 1, 0 SAY "^LH0,0^FS"
      @ PRow() + 1, 0 SAY "^LL839"
      @ PRow() + 1, 0 SAY "^MD0"
      @ PRow() + 1, 0 SAY "^MNY"
      @ PRow() + 1, 0 SAY "^LH16,24^FS"
      @ PRow() + 1, 0 SAY "^FO56,104^AD,19,0^FDFORNECEDOR^FS"
      @ PRow() + 1, 0 SAY "^FO56,196^AD,19,0^FDPECA NOME^FS"
      @ PRow() + 1, 0 SAY "^FO56,274^AD,19,0^FDNUMERO^FS"
      @ PRow() + 1, 0 SAY "^FO56,490^AD,19,0^FDQUANTIDADE^FS"
      @ PRow() + 1, 0 SAY "^FO342,490^AD,19,0^FDLOTE FABRICACAO^FS"
      @ PRow() + 1, 0 SAY "^FO56,664^AD,19,0^FDDELIVERY LOCATION^FS"
      @ PRow() + 1, 0 SAY "^FO442,729^AD,19^FDDATA FABRICACAO^FS"
      @ PRow() + 1, 0 SAY "^FO56,729^AD,19,0^FDKABAN^FS"
      @ PRow() + 1, 0 SAY "^FO224,729^AD,19,0^FDPLT/STK^FS"
      @ PRow() + 1, 0 SAY "^FO442,664^AD,19,0^FDEQUIPAMENTO^FS"
      @ PRow() + 1, 0 SAY "^FO81,54^AB,27,0^FD" + cCLINOME + "^FS"
      @ PRow() + 1, 0 SAY "^FO58,140^AB,27,0^FD" + cFORN + "^FS"
      @ PRow() + 1, 0 SAY "^FO58,689^AD,27,0^FD" + cDELIV + "^FS"
      @ PRow() + 1, 0 SAY "^FO444,687^AD,27,0^FD" + cEQUIP + "^FS"
      @ PRow() + 1, 0 SAY "^FO56,751^AD,27,0^FD" + cKANBAN + "^FS"
      @ PRow() + 1, 0 SAY "^FO224,751^AD,27,0^FD" + cUSING + "^FS"
      IF !Empty( cDATA )
         @ PRow() + 1, 0 SAY "^FO442,753^AD,27,0^FD" + DToC( cDATA ) + "^FS"
      ENDIF
      @ PRow() + 1, 0 SAY "^FO54,514^AD,29,0^FD" + cQTDE + "^FS"
      @ PRow() + 1, 0 SAY "^FO342,514^AD,29,0^FD" + cLOTE + "^FS"
      @ PRow() + 1, 0 SAY "^FO64,292^A" + cCODFNT + "," + cCODSIZ + ",0^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,3.0^FO74,360^B3N,N," + cBARSIZ + ",N,Y^FR^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^BY2,3.0^FO74,552^B3N,N,96,N,Y^FR^FD" + cQTDE + "^FS"
      IF !Empty( cLOTE )
         @ PRow() + 1, 0 SAY "^BY1,3.0^FO348,552^B3N,N,96,N,Y^FR^FD" + cLOTE + "^FS"
      ENDIF
      @ PRow() + 1, 0 SAY "^FO56,220^AD,35,0^FD" + cNOME + "^FS"
      @ PRow() + 1, 0 SAY "^FO40,42^GB599,751,4^FS"
      @ PRow() + 1, 0 SAY "^FO40,96^GB593,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO44,190^GB589,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO40,262^GB597,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO40,478^GB597,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO42,657^GB598,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO324,482^GB0,174,4^FS"
      @ PRow() + 1, 0 SAY "^FO430,663^GB0,128,4^FS"
      @ PRow() + 1, 0 SAY "^FO43,723^GB592,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO212,727^GB0,64,4^FS"
      @ PRow() + 1, 0 SAY "^PQ" + cETIQ + ",0,0,N"
      @ PRow() + 1, 0 SAY "^XZ"
   ENDIF
   IF nTIPO = 2
      @ PRow() + 1, 0 SAY "^XA"
      @ PRow() + 1, 0 SAY "^PRC"
      @ PRow() + 1, 0 SAY "^LH0,0^FS"
      @ PRow() + 1, 0 SAY "^LL1239"
      @ PRow() + 1, 0 SAY "^MD0"
      @ PRow() + 1, 0 SAY "^MNY"
      @ PRow() + 1, 0 SAY "^LH16,24^FS"
      @ PRow() + 1, 0 SAY "^FO32,48^AD,19,0^FDCLIENTE^FS"
      @ PRow() + 1, 0 SAY "^FO32,134^AD,19,0^FDFORNECEDOR^FS"
      @ PRow() + 1, 0 SAY "^FO32,208^AD,19,0^FDPECA NOME^FS"
      @ PRow() + 1, 0 SAY "^FO32,296^AD,19,0^FDNUMERO^FS"
      @ PRow() + 1, 0 SAY "^FO32,570^AD,19,0^FDQUANTIDADE^FS"
      @ PRow() + 1, 0 SAY "^FO354,568^AD,19,0^FDLOTE FABRICACAO^FS"
      @ PRow() + 1, 0 SAY "^FO32,813^AD,19,0^FDDELIVERY LOCATION^FS"
      @ PRow() + 1, 0 SAY "^FO548,811^AD,19,0^FDEQUIP.EMBALAGEM^FS"
      @ PRow() + 1, 0 SAY "^FO32,971^AD,19,0^FDPLT/STK^FS"
      @ PRow() + 1, 0 SAY "^FO354,973^AD,14,0^FDDATA DE FABRICACAO^FS"
      @ PRow() + 1, 0 SAY "^FO32,1091^AD,19,0^FDKABAN^FS"
      @ PRow() + 1, 0 SAY "^FO108,72^AB,27,0^FD" + cCLINOME + "^FS"
      @ PRow() + 1, 0 SAY "^FO32,152^AB,27,0^FD" + cFORN + "^FS"
      @ PRow() + 1, 0 SAY "^FO32,234^AB,27,0^FD" + cNOME + "^FS"
      @ PRow() + 1, 0 SAY "^F120,290^AD,94,0^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^BY4,3.0^FO80,400^B3N,N,142,N,Y^FR^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^FO32,591^AD,45,0^FDQTDE^FS"
      @ PRow() + 1, 0 SAY "^FO368,589^AD,45,0^FDLOTE^FS"
      @ PRow() + 1, 0 SAY "^BY2,3.0^FO48,653^B3N,N,120,N,Y^FR^FD" + cQTDE + "^FS"
      IF !Empty( cLOTE )
         @ PRow() + 1, 0 SAY "^BY2,3.0^FO374,653^B3N,N,120,N,Y^FR^FD" + cLOTE + "^FS"
      ENDIF
      @ PRow() + 1, 0 SAY "^FO32,880^AD,45,0^FD" + cDELIV + "^FS"
      @ PRow() + 1, 0 SAY "^FO548,880^AD,45,0^FD" + cEQUIP + "^FS"
      @ PRow() + 1, 0 SAY "^FO32,1015^AD,45,0^FD" + cUSING + "^FS"
      @ PRow() + 1, 0 SAY "^FO32,1129^AD,45,0^FD" + cKANBAN + "^FS"
      IF !Empty( cDATA )
         @ PRow() + 1, 0 SAY "^FO354,1099^AD,72,0^FD" + DToC( cDATA ) + "^FS"
      ENDIF
      @ PRow() + 1, 0 SAY "^FO32,42^GB841,1155,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,122^GB835,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,202^GB835,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,282^GB835,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,562^GB835,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,802^GB835,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,962^GB835,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO32,1081^GB332,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO350,562^GB0,236,4^FS"
      @ PRow() + 1, 0 SAY "^FO538,802^GB0,160,4^FS"
      @ PRow() + 1, 0 SAY "^FO350,962^GB0,226,4^FS"
      @ PRow() + 1, 0 SAY "^PQ" + cETIQ + ",0,0,N"
      @ PRow() + 1, 0 SAY "^XZ"
   ENDIF
   IF nTIPO = 3  // Benteler
      SET CENTURY ON
      @ PRow(), 0   SAY "^XA"
      @ PRow() + 1, 0 SAY "^PRC"
      @ PRow() + 1, 0 SAY "^LH0,0^FS"
      @ PRow() + 1, 0 SAY "^LL839"
      @ PRow() + 1, 0 SAY "^MD0"
      @ PRow() + 1, 0 SAY "^MNY"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO49,31^FD" + cCLINOME + "^FS"
      @ PRow() + 1, 0 SAY "^FO24,73^GB823,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO28,103^GB823,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO31,106^FDNR. DE EMBALAGENS (E)^FS"
      @ PRow() + 1, 0 SAY "^FO24,218^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,343^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,487^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,559^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,743^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO25,822^GB820,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,1014^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,1141^GB822,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO24,1183^GB824,0,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^FO434,561^GB0,183,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO32,77^FDCRIADA EM:^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO28,1151^FDUSO EXCLUSIVO BCA^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO40,223^FDNR. PECA (P)^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO30,351^FDQUANTIDADE (Q)^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO30,496^FDDESCRICAO^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO32,567^FDFORNECEDOR (V)^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO448,566^FDNR. DO LOTE (S)^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO32,751^FDDESIGNACAO:^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO32,775^FD" + cFORN + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO312,832^FDNR. NF (N)^FS "
      @ PRow() + 1, 0 SAY "^FO305,824^GB0,191,4,B,0^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO30,1023^FDDATA DA NF (D)^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO104,144^FD" + cEQUIP + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,2.0^FO505,107^B3N,N,80,Y,N^FD" + cEQUIP + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO39,261^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,2.0^FO321,231^B3N,N,80,Y,N^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,2.0^FO463,366^B3N,N,80,Y,N^FD" + cQTDE + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO36,376^FD" + cQTDE + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO31,519^FD" + cNOME + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO568,648^FD" + cLOTE + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO38,592^FD" + AllTrim( cINSP ) + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,2.0^FO29,629^B3N,N,80,Y,N^FD" + AllTrim( cINSP ) + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO312,857^FD" + AllTrim( Str( nNF ) ) + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,2.0^FO366,896^B3N,N,80,Y,N^FD" + AllTrim( Str( nNF ) ) + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO33,1063^FD" + cDATANF + "^FS"
      @ PRow() + 1, 0 SAY "^BY3,2.0^FO363,1027^B3N,N,80,Y,N^FD" + cDATANF + "^FS"
      // @ PROW()+1,0  SAY "^ADN,90,50^FO39,879^FD04.3^FS"    //Semana do ano dia da semana
      @ PRow() + 1, 0 SAY "^ADN,90,50^FO39,879^FD" + StrZero( woy( cDATA ), 2 ) + "." + StrZero( DoW( cDATA ), 1 ) + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO190,77^FD" + DToC( cDATA ) + "^FS"

      // @ PROW()+1,0  SAY ^XFR:TEMP_FMT.ZPL
      // @ PROW()+1,0  SAY ^IDR:TEMP_FMT.ZPL

      @ PRow() + 1, 0 SAY "^PQ" + cETIQ + ",0,0,N"
      @ PRow() + 1, 0 SAY "^XZ"
      SET CENTURY OFF
   ENDIF
   IF nTIPO = 4  // YAMAHA
      FOR I := 1 TO nETIQ
         @ PRow(), 0   SAY "^XA" // Padrao etiquetas
         @ PRow() + 1, 0 SAY "^PRC"
         @ PRow() + 1, 0 SAY "^LH0,0^FS"
         @ PRow() + 1, 0 SAY "^MD0"
         @ PRow() + 1, 0 SAY "^MNY"

         @ PRow() + 1, 0 SAY "^MMT" // Aqui comeca yamaha
         @ PRow() + 1, 0 SAY "^LL0607"
         @ PRow() + 1, 0 SAY "^PW831"
         @ PRow() + 1, 0 SAY "^LS0"
         @ PRow() + 1, 0 SAY "^FO29,499^GB786,0,3^FS"
         @ PRow() + 1, 0 SAY "^FO29,421^GB786,0,4^FS"
         @ PRow() + 1, 0 SAY "^FO30,266^GB786,0,4^FS"
         @ PRow() + 1, 0 SAY "^FO29,342^GB786,0,3^FS"
         @ PRow() + 1, 0 SAY "^FO30,189^GB786,0,4^FS"
         @ PRow() + 1, 0 SAY "^FO30,109^GB786,0,4^FS"
         @ PRow() + 1, 0 SAY "^FO168,425^GB0,75,3^FS"
         @ PRow() + 1, 0 SAY "^FO463,344^GB0,157,3^FS"
         @ PRow() + 1, 0 SAY "^FO565,192^GB0,75,4^FS"
         @ PRow() + 1, 0 SAY "^FO323,192^GB0,75,3^FS"
         @ PRow() + 1, 0 SAY "^FO681,41^GB0,69,3^FS"
         @ PRow() + 1, 0 SAY "^FO575,41^GB0,69,4^FS"
         @ PRow() + 1, 0 SAY "^FT37,66^A0N,20,19^FH\^FDLPN:^FS"
         @ PRow() + 1, 0 SAY "^FT37,448^A0N,20,19^FH\^FDQTDE:^FS"
         @ PRow() + 1, 0 SAY "^FT172,448^A0N,20,19^FH\^FDNF/INVOICE:^FS"
         @ PRow() + 1, 0 SAY "^FT469,448^A0N,20,19^FH\^FDUSO EXCLUSIVO DO FORNECEDOR:^FS"
         @ PRow() + 1, 0 SAY "^FT468,368^A0N,20,19^FH\^FDFORNECEDOR:^FS"
         @ PRow() + 1, 0 SAY "^FT37,368^A0N,20,19^FH\^FDNOME:^FS"
         @ PRow() + 1, 0 SAY "^FT570,214^A0N,20,19^FH\^FDUSER:^FS"
         @ PRow() + 1, 0 SAY "^FT328,214^A0N,20,19^FH\^FDSUPPLIER:^FS"
         @ PRow() + 1, 0 SAY "^FT37,216^A0N,20,19^FH\^FDCODIGO:^FS"
         @ PRow() + 1, 0 SAY "^FT169,94^A0N,28,28^FH\^FD" + AllTrim( cINSP ) + StrZero( nNF, 6 ) + StrZero( nSEQ, 5 ) + "^FS"
         @ PRow() + 1, 0 SAY "^FT716,92^A0N,42,40^FH\^FD" + cQTDE + "^FS"
         @ PRow() + 1, 0 SAY "^FT605,92^A0N,42,40^FH\^FD" + cKANBAN + "^FS"
         @ PRow() + 1, 0 SAY "^FT76,251^A0N,28,28^FH\^FD" + cCODIGO + "^FS"
         @ PRow() + 1, 0 SAY "^FT427,248^A0N,28,28^FH\^FD" + cUSING + "^FS"
         @ PRow() + 1, 0 SAY "^FT662,247^A0N,28,28^FH\^FD" + cDELIV + "^FS"
         @ PRow() + 1, 0 SAY "^FT69,404^A0N,28,28^FH\^FD" + cNOME + "^FS"
         @ PRow() + 1, 0 SAY "^FT82,482^A0N,28,28^FH\^FD" + cQTDE + "^FS"
         @ PRow() + 1, 0 SAY "^FT254,482^A0N,28,28^FH\^FD" + AllTrim( Str( nNF ) ) + "^FS"
         @ PRow() + 1, 0 SAY "^FT518,404^A0N,28,28^FH\^FD" + cFORN + "^FS"
         @ PRow() + 1, 0 SAY "^PQ1,0,0,N" // YAMAHA POR sequencia cria loop
         @ PRow() + 1, 0 SAY "^XZ"
         nSEQ++
      NEXT X
   ENDIF

   IF nTIPO = 5  // Intermediaia
      SET CENTURY ON
      @ PRow(), 0   SAY "^XA"
      @ PRow() + 1, 0 SAY "^PRC"
      @ PRow() + 1, 0 SAY "^LH0,0^FS"
      @ PRow() + 1, 0 SAY "^LL839"
      @ PRow() + 1, 0 SAY "^MD0"
      @ PRow() + 1, 0 SAY "^MNY"
      @ PRow() + 1, 0 SAY "^FO9,9^GB390,579,4^FS"
      @ PRow() + 1, 0 SAY "^FO9.115^GB390,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO9,278^GB390,0,4^FS"
      @ PRow() + 1, 0 SAY "^FO9,436^GB390,0,4^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO256,47^FDETIQUETA^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO287,85^FDINTERMEDIARIA^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO40,152^FDITEM^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO40,315^FDRASTRO/LOTE^FS"
      @ PRow() + 1, 0 SAY "^ADN,18,10^FO40,473^FDENDERECO^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO40,215^FD" + cCODIGO + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO40,378^FD" + cLOTE + "^FS"
      @ PRow() + 1, 0 SAY "^ADN,36,20^FO40,534^FD" + cDELIV + "^FS"
      @ PRow() + 1, 0 SAY "^PQ" + cETIQ + ",0,0,N"
      @ PRow() + 1, 0 SAY "^XZ"
      SET CENTURY OFF
   ENDIF



   VIDEO()
   IMPEND()

// + EOF: m_dc3.prg
// +
