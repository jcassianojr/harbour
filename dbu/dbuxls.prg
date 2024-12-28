// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : dbuxls.prg
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
// +    Documentado em 28-Dez-2024 as 10:07 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// ----------------------------------------------------------
// XLS.PRG
//
// Rutinas para escribir un archivo Excel 2.0 de
// forma nativa
//
// Basada en la implementacion de Mark O'Brien
// Microsoft Corporation
//
// Version Clipper :
// Nov,1999
// Caracas, Venezuela
// ----------------------------------------------------------

// Label Header
#define TXT_ELEMS 12
#define TXT_OPCO1  1
#define TXT_OPCO2  2
#define TXT_LEN1  3
#define TXT_LEN2  4
#define TXT_ROW1  5
#define TXT_ROW2  6
#define TXT_COL1  7
#define TXT_COL2  8
#define TXT_RGBAT1 9
#define TXT_RGBAT2 10
#define TXT_RGBAT3 11
#define TXT_LEN  12

// ----------------------------------------------------------
// Proposito :
// Abre el archivo xls y escribe marcador inicial
// Parametros:
// cFile  - Nombre del Archivo
// Retorna :
// nHandle  - Handle del archivo Excel
// ----------------------------------------------------------

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function xlsOpen()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION xlsOpen( cFile )

   LOCAL nHandle
   LOCAL cBof    := Chr( 9 ) + Chr( 0 ) + Chr( 4 ) + Chr( 0 ) + ;
      Chr( 2 ) + Chr( 0 ) + Chr( 10 ) + Chr( 0 )

   nHandle := FCreate( cFile )
   FWrite( nHandle, cBof, Len( cBof ) )

   RETURN nHandle


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function docOpen()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION docOpen( cFile )

   LOCAL nHandle
   LOCAL cBof    := Chr( 208 ) + Chr( 207 ) + Chr( 17 ) + Chr( 224 ) + ;
      Chr( 161 ) + Chr( 177 ) + Chr( 26 ) + Chr( 0 )

   nHandle := FCreate( cFile )
   FWrite( nHandle, cBof, Len( cBof ) )

   RETURN nHandle

// ----------------------------------------------------------
// Proposito :
// Cierra el archivo xls y escribe marcador final
// Parametros:
// Nada
// Retorna :
// nil
// ----------------------------------------------------------

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function xlsClose()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION xlsClose( nHandle )

   LOCAL cEof := Chr( 10 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 )

   FWrite( nHandle, cEof, Len( cEof ) )
   FClose( nHandle )

   RETURN NIL


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function docClose()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION docClose( nHandle )

   LOCAL cEof := Chr( 10 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 )

   FWrite( nHandle, cEof, Len( cEof ) )
   FClose( nHandle )

   RETURN NIL

// ----------------------------------------------------------
// Proposito :
// Escribe un string en la celda (nRow, nCol)
// nRow, nCol Comienzan en 1
// Parametros:
// nHandle - Handle del archivo xls
// nRow  - Fila
// nCol  - Columna
// cString - String a escribir
// Retorna :
// nil
// ----------------------------------------------------------

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function xlsWrite()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION xlsWrite( nHandle, nRow, nCol, cString )

   LOCAL anHeader
   LOCAL nLen
   LOCAL nI

// ---------------------------------------------------
// Arreglo para almacenar el marcador de registro
// etiqueta
// ---------------------------------------------------
   anHeader               := Array( TXT_ELEMS )
   anHeader[ TXT_OPCO1 ]  := 4
   anHeader[ TXT_OPCO2 ]  := 0
   anHeader[ TXT_LEN1 ]   := 10
   anHeader[ TXT_LEN2 ]   := 0
   anHeader[ TXT_ROW2 ]   := 0
   anHeader[ TXT_COL2 ]   := 0
   anHeader[ TXT_RGBAT1 ] := 0
   anHeader[ TXT_RGBAT2 ] := 0
   anHeader[ TXT_RGBAT3 ] := 0
   anHeader[ TXT_LEN ]    := 2

   nLen := Len( cString )

// ------------------------------
// Longitud del texto a escribir
// ------------------------------
   anHeader[ TXT_LEN ] := nLen

// ----------------------
// Longitud del registro
// ----------------------
   anHeader[ TXT_LEN1 ] := 8 + nLen

// ---------------------------------------------
// En le formato BIFF se comienza desde cero y
// no desde 1 como estamos pasando los datos
// ---------------------------------------------
   nI                   := nRow - 1
   anHeader[ TXT_ROW1 ] := nI - ( Int( nI / 256 ) * 256 )
   anHeader[ TXT_ROW2 ] := Int( nI / 256 )
   anHeader[ TXT_COL1 ] := nCol - 1

// -------------------
// Escribe encabezado
// -------------------
   AEval( anHeader, {| v | FWrite( nHandle, Chr( v ), 1 ) } )

// -----------------------------------------------------
// Escribe la data
// -----------------------------------------------------
   FOR nI := 1 TO nLen
      FWrite( nHandle, SubStr( cString, nI, 1 ), 1 )
   NEXT nI

   RETURN NIL

// ----------------------------------------------------------
// Proposito :
// Escribe un string en la celda (nRow, nCol)
// nRow, nCol Comienzan en 1
// Parametros:
// nHandle - Handle del archivo xls
// nRow  - Fila
// nCol  - Columna
// cString - String a escribir
// Retorna :
// nil
// ----------------------------------------------------------

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TB2Xls()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TB2Xls( oTB, cXlsFile, cTitle )

   LOCAL xXls, i, oCol, nTemp
   LOCAL uColData, cAlign, cCell

// argument checking
   IF ValType( oTB ) != "O"
      RETURN .F.
   ENDIF
   IF Empty( cXlsFile )
      cXlsFile := "TB2Xls.xls"
   ELSE
      cXlsFile := cXlsFile + ".xls"
   ENDIF

// creating new Xls (.HTM) file
   xXls := xlsOpen( cXlsFile )

// output column headers
   FOR i := 1 TO oTB:ColCount
      oCol  := oTB:GetColumn( i )
      cCell := oCol:Heading

      xlsWrite( xXls, 1, i, cCell )
   NEXT

// here comes the main loop which generate the table body
   Eval( oTB:goTopBlock )  // start from the top

   cLin := 2
   DO WHILE .T.

      FOR i := 1 TO oTB:ColCount
         oCol     := oTB:GetColumn( i )
         uColData := Eval( oCol:Block )  // column data (of yet unknown type)
         DO CASE
         CASE ValType( uColData ) == "C"   // characters
            IF Empty( uColData )
               cCell := ""   // if empty, display non-breaking space (&nbsp)
               // to prevent displaying "hole" in table
            ELSE
               cCell := uColData
            ENDIF
            // cAlign := ""      // text fields are left aligned
         CASE ValType( uColData ) == "N"   // numbers
            IF !Empty( oCol:picture )
               cCell := Transform( uColData, oCol:picture )   // display numbers according to column picture
            ELSE
               cCell := Str( uColData )
            ENDIF
            IF Empty( cCell )
               cCell := 0  // non-breaking space
            ENDIF
            // cAlign := ""
         CASE ValType( uColData ) == "L"   // logicals
            cCell := if( uColData, "Sim", "Nao" )
            // cAlign := ""         // NOTE: if you prefer T/F style, change above line to
            // cCell := if (uColData, "T", "F")
         CASE ValType( uColData ) == "D"   // dates
            IF Empty( uColData )   // empty dates
               cCell := ""
            ELSE
               cCell := DToC( uColData )
            ENDIF
            // cAlign := ""
         OTHERWISE
            cCell := "error"
            // cAlign := ""
         END CASE
         xlsWrite( xXls, cLin, i, cCell )
      NEXT

      nTemp := Eval( oTB:SkipBlock, 1 )
      IF nTemp != 1  // it's the end, so we are getting out
         EXIT
      ENDIF

      cLin++
   END DO  // main loop

   Eval( oTB:goTopBlock )  // set TBrowse back to top

// writing Xls tail
   xlsClose( xXls )

   RETURN .T.

/*
 *
 * Exemplo de criacao de .XLS
 *
 *
 */
// function main
// nXls := xlsOpen( "teste.xls" )
// xlsWrite( nXls, 1, 1, "Pais" )
// xlsWrite( nXls, 1, 2, "Capital" )
// xlsWrite( nXls, 1, 3, "Populacao" )
// adata:={}
// aadd(adata,{"br","brasilia",50})
// aadd(adata,{"sp","sao paulo",150})
// f := 2
// for i:=1 to Len( aData )
// xlsWrite( nXls, f, 1, aData[ i , 1 ] )
// xlsWrite( nXls, f, 2, aData[ i , 2 ] )
// xlsWrite( nXls, f, 3, Ltrim( Str( aData[ i , 3 ] )))
// f++
// next i
// xlsClose( nXls )
// return

// + EOF: dbuxls.prg
// +
