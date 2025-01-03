// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : jason.prg
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
// +    Documentado em 27-Dez-2024 as  9:19 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function main()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Main()

   hb_idleState()

   Set( _SET_CODEPAGE, "PTISO" )

   SetMode( 25, 80 )
   cls

// hb_Alert( "teste", , , 2 )


   rddSetDefault( "DBFCDX" )
   Set( _SET_OPTIMIZE, .T. )
   Set( _SET_DELETED, .T. )
   Set( _SET_SOFTSEEK, .T. )
   __SetCentury( .T. )
   Set( _SET_EPOCH, Year( Date() ) - 60 )
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )



   kk        := 1
   mArquivo  := '*.json'
   mListaArq := Directory( mArquivo, "D" )
   nFIMARQ   := Len( mListaArq )

   FOR kk := 1 TO nFIMARQ
      cARQJSON := Lower( mListaArq[ kk, 1 ] )
      JASONCSV( cARQJSON )
      FErase( cARQJSON )
   NEXT kk



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function JASONCSV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION JASONCSV( cARQJSON, cARQDBF )

   LOCAL cJsonString
   LOCAL cDESTINO
   LOCAL eVALOR
   LOCAL Z
   LOCAL aVALOR
   LOCAL nFILEGRV
   LOCAL nodos
   LOCAL hdata
   LOCAL ldbf

   ldbf := .F.

   IF !File( cARQJSON )
      RETURN .F.
   ENDIF

   IF ValType( cARQDBF ) = "C"
      IF File( cARQDBF + ".dbf" )
         dbUseArea( .T., "DBFCDX", cARQDBF,, .T. )
         IF File( cARQDBF + ".cdx" )
            ordListAdd( cARQDBF )
            dbSetOrder( 1 )  //
         ENDIF
         ldbf := .T.
      ENDIF
   ENDIF

   cJsonString := hb_MemoRead( cARQJSON )
   hData       := hb_jsonDecode( cJsonString )
   cDESTINO    := StrTran( Lower( cARQJSON ), ".json", ".csv" )
   nFILEGRV    := FCreate( cDESTINO )

   IF ValType( hdata ) = "U"
      Alert( ValType( hdata ) + " " + Carqjson )
      RETURN .F.
   ENDIF


   nFILEGRV := FCreate( cDESTINO )


   FOR EACH nodos in hDATA
      eVALOR := hb_ValToExp( nodos )
      // Fwrite(nFilegrv,eVALOR+hb_osnewline())
      eVALOR := StrTran( eVALOR, "{", "" )
      eVALOR := StrTran( eVALOR, "}", "" )
      eVALOR := StrTran( eVALOR, ", ", "|" )
      eVALOR := TIRACE2( eVALOR )


      FWrite( nFilegrv, eVALOR + hb_osNewLine() )



      aVALOR := hb_ATokens( eVALOR, "|" )

      IF Len( aVALOR ) > 0 .AND. lDBF
         eBUSCA  := StrTran( aVALOR[ 1 ], '"', "" )
         mCODIGO := StrTran( aVALOR[ 1 ], '"', "" )
         mNOME   := StrTran( aVALOR[ 2 ], '"', "" )
         AltD()
         dbGoTop()
         IF !dbSeek( eBUSCA )
            dbAppend()
            field->codigo := mCODIGO
         ENDIF
         IF Empty( field->nome ) .AND. !Empty( mNOME )
            field->nome := mNOME
         ENDIF

      ENDIF

      // FOR Z = 1 TO LEN(avaLOR)
      // Fwrite(nFilegrv,avalor[z]+hb_osnewline())
      // NEXT Z
   NEXT

   FClose( nfilegrv )

   IF ValType( cARQDBF ) = "C"
      dbCloseAll()
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tirace2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tirace2( cXml )

   LOCAL nCont, cRemoveTag, cLetra, nPos, lTroca, nAscii

   cRemoveTag := { ;
      [< ? xml version = "1.0" encoding = "utf-8" ? >], ;   // Petrobras inventou de usar assim
      [< ? xml version = "1.0" encoding = "ISO-8859-1" ? >], ;  // Petrobras agora assim
      [< ? xml version = "1.0" encoding = "UTF-8" ? >], ;   // o mais correto
      [< ? xml version = "1.00" ? >], ;
      [< ? xml version = "1.0" ? >] }

   FOR nCont := 1 TO Len( cRemoveTag )
      cXml := StrTran( cXml, cRemoveTag[ nCont ], "" )
   NEXT
//   IF ![
 //     cXml := StrTran( cXml, [ '],["])
 //  ENDIF
   IF Chr( 195 ) $ cXml
      nPos := At( Chr( 195 ), cXml )
      IF Asc( SubStr( cXml, nPos + 1 ) ) > 122
         cXml := hb_UTF8ToStr( cXml )
      ENDIF
   ENDIF
   FOR nCont := 1 TO 2
      cXml := StrTran( cXml, Chr( 26 ), "" )
      cXml := StrTran( cXml, Chr( 13 ), "" )
      cXml := StrTran( cXml, Chr( 10 ), "" )
      IF SubStr( cXml, 1, 1 ) $ Chr( 239 ) + Chr( 187 ) + Chr( 191 )
         cXml := SubStr( cXml, 2 )
      ENDIF
      cXml := StrTran( cXml, " />", "/>" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 173 ), "i" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 135 ), "C" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 141 ), "I" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 163 ), "a" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 167 ), "c" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 161 ), "a" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 131 ), "A" )
      cXml := StrTran( cXml, Chr( 194 ) + Chr( 186 ), "o." )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 162 ), "a" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 161 ), "a" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 163 ), "a" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 173 ), "i" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 179 ), "o" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 167 ), "c" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 169 ), "e" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 170 ), "e" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 181 ), "o" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 160 ), "o" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 181 ), "o" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 129 ), "A" )
      cxml := StrTran( cxml, Chr( 226 ) + Chr( 128 ) + Chr( 156 ), [ * ] )   // aspas de destaque "cames"
      cxml := StrTran( cxml, Chr( 226 ) + Chr( 128 ) + Chr( 157 ), [ * ] )   // aspas de destaque "cames"
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 180 ), "o" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 186 ), "u" )
      cxml := StrTran( cxml, Chr( 195 ) + Chr( 147 ), "O" )
      cxml := StrTran( cxml, Chr( 226 ) + Chr( 128 ) + Chr( 153 ), [ ] )   // caixa d'agua
      cxml := StrTran( cxml, Chr( 226 ) + Chr( 128 ) + Chr( 147 ), [ - ] )   // - mesmo
      cxml := StrTran( cxml, Chr( 194 ) + Chr( 179 ), [ 3 ] )  // m3
      // so pra corrigir no MySql
      cXml := StrTran( cXml, "+" + Chr( 129 ), "A" )
      cXml := StrTran( cXml, "+" + Chr( 137 ), "E" )
      cXml := StrTran( cXml, "+" + Chr( 131 ), "A" )
      cXml := StrTran( cXml, "+" + Chr( 135 ), "C" )
      cXml := StrTran( cXml, "?" + Chr( 167 ), "c" )
      cXml := StrTran( cXml, "?" + Chr( 163 ), "a" )
      cXml := StrTran( cXml, "?" + Chr( 173 ), "i" )
      cXml := StrTran( cXml, "?" + Chr( 131 ), "A" )
      cXml := StrTran( cXml, "?" + Chr( 161 ), "a" )
      cXml := StrTran( cXml, "?" + Chr( 141 ), "I" )
      cXml := StrTran( cXml, "?" + Chr( 135 ), "C" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 156 ), "a" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 159 ), "A" )
      cXml := StrTran( cXml, "?" + Chr( 129 ), "A" )
      cXml := StrTran( cXml, "?" + Chr( 137 ), "E" )
      cXml := StrTran( cXml, Chr( 195 ) + "?", "C" )
      cXml := StrTran( cXml, "?" + Chr( 149 ), "O" )
      cXml := StrTran( cXml, "?" + Chr( 154 ), "U" )
      cXml := StrTran( cXml, "+" + Chr( 170 ), "o" )
      cXml := StrTran( cXml, "?" + Chr( 128 ), "A" )
      cXml := StrTran( cXml, Chr( 195 ) + Chr( 166 ), "e" )
      cXml := StrTran( cXml, Chr( 135 ) + Chr( 227 ), "ca" )
      cXml := StrTran( cXml, "n" + Chr( 227 ), "na" )
      cXml := StrTran( cXml, Chr( 162 ), "o" )
      cXml := StrTran( cXml, " " + Chr( 241 ) + " ", " " )
      cXml := StrTran( cXml, Chr( 176 ), "" )  // graus
      cXml := StrTran( cXml, Chr( 186 ), "o" )   // numero
      cXml := StrTran( cXml, Chr( 220 ), "U" )   // u com trema
      cXml := StrTran( cXml, Chr( 170 ), "" )  // desconhecido
   NEXT
   FOR nCont := 1 TO Len( cXml )
      cLetra := SubStr( cXml, nCont, 1 )
      nAscii := Asc( cLetra )
      lTroca := .T.
      DO CASE
      CASE cLetra $ "abcdefghijklmnopqrstuvwxyz"
         lTroca := .F.
      CASE cLetra $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
         lTroca := .F.
      CASE cLetra $ "01234567889"
         lTroca := .F.
      CASE cLetra $ ",.:/;%*$@?<>()+-#=:_" + Chr( 34 ) + Chr( 32 )
         lTroca := .F.
      CASE nAscii == 231
         cLetra := "c"
      CASE nAscii == 199
         cLetra := "C"
      CASE AScan( { 193, 194, 195, 192 }, nAscii ) != 0
         cLetra := "A"
      CASE AScan( { 224, 225, 226, 227, 228, 229 }, nAscii ) != 0
         cLetra := "a"
      CASE AScan( { 242, 243, 244, 245, 246 }, nAscii ) != 0
         cLetra := "o"
      CASE AScan( { 210, 211, 212, 213, 214 }, nAscii ) != 0
         cLetra := "O"
      CASE AScan( { 200, 201, 202, 203 }, nAscii ) != 0
         cLetra := "E"
      CASE AScan( { 232, 233, 234, 235 }, nAscii ) != 0
         cLetra := "e"
      CASE AScan( { 236, 237, 238, 239 }, nAscii ) != 0
         cLetra := "i"
      CASE AScan( { 204, 205, 206, 207 }, nAscii ) != 0
         cLetra := "I"
      CASE AScan( { 249, 250, 251, 252 }, nAscii ) != 0
         cLetra := "u"
      CASE AScan( { 217, 218, 219 }, nAscii ) != 0
         cLetra := "U"
      CASE nAscii == 128   // experimental
         cLetra := "C"
      CASE nAscii == 144   // experimental
         cLetra := "E"
      CASE nAscii == 248   // experimental
         cLetra := ""
      CASE nAscii == 167   // experimental
         cLetra := "o"
      ENDCASE
      IF lTroca
         cXml := SubStr( cXml, 1, nCont - 1 ) + cLetra + SubStr( cXml, nCont + 1 )
      ENDIF
   NEXT

   RETURN cXml


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GetJson()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GetJson( cJson )

   LOCAL xReturn := hb_jsonDecode( cJson )

   IF !( ValType( xReturn ) $ 'HA' )
      xReturn := Nil
   ENDIF

   RETURN ( xReturn )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IsJsonValid()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION IsJsonValid( cJson )

   RETURN ( GetJson( cJson ) != NIL .AND. ;
      Len( GetJson( cJson ) ) != 0 )


// + EOF: jason.prg
// +
