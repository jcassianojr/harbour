//---------------------------------------------------------- 
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
//---------------------------------------------------------- 

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

//---------------------------------------------------------- 
// Proposito : 
// Abre el archivo xls y escribe marcador inicial 
// Parametros: 
//  cFile  - Nombre del Archivo 
// Retorna : 
// nHandle  - Handle del archivo Excel 
//---------------------------------------------------------- 
function xlsOpen( cFile ) 
 local nHandle 
 local cBof := Chr( 9 ) + Chr( 0 ) + Chr( 4 ) + Chr( 0 ) + ; 
     Chr( 2 ) + Chr( 0 ) + Chr( 10 ) + Chr( 0 ) 
 nHandle := fCreate( cFile ) 
 fWrite( nHandle, cBof, Len( cBof )) 
return nHandle 

function docOpen( cFile ) 
 local nHandle 
 local cBof := Chr(208 ) + Chr(207 ) + Chr( 17 ) + Chr(224 ) + ; 
        Chr(161 ) + Chr(177 ) + Chr( 26 ) + Chr( 0 ) 
 nHandle := fCreate( cFile ) 
 fWrite( nHandle, cBof, Len( cBof )) 
return nHandle 

//---------------------------------------------------------- 
// Proposito : 
// Cierra el archivo xls y escribe marcador final 
// Parametros: 
//  Nada 
// Retorna : 
// nil 
//---------------------------------------------------------- 
function xlsClose( nHandle ) 
 local cEof := Chr( 10 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 ) 
 fWrite( nHandle, cEof, Len( cEof )) 
 fClose( nHandle ) 
return nil 

function docClose( nHandle ) 
 local cEof := Chr( 10 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 ) 
 fWrite( nHandle, cEof, Len( cEof )) 
 fClose( nHandle ) 
return nil 

//---------------------------------------------------------- 
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
//---------------------------------------------------------- 
function xlsWrite( nHandle, nRow, nCol, cString ) 
 local anHeader 
 local nLen 
 local nI 

 //--------------------------------------------------- 
 // Arreglo para almacenar el marcador de registro 
 // etiqueta 
 //--------------------------------------------------- 
 anHeader       := Array( TXT_ELEMS ) 
 anHeader[ TXT_OPCO1 ] := 4 
 anHeader[ TXT_OPCO2 ] := 0 
 anHeader[ TXT_LEN1 ] := 10 
 anHeader[ TXT_LEN2 ] := 0 
 anHeader[ TXT_ROW2 ] := 0 
 anHeader[ TXT_COL2 ] := 0 
 anHeader[ TXT_RGBAT1 ] := 0 
 anHeader[ TXT_RGBAT2 ] := 0 
 anHeader[ TXT_RGBAT3 ] := 0 
 anHeader[ TXT_LEN  ] := 2 

 nLen       := Len( cString ) 

 //------------------------------ 
 // Longitud del texto a escribir 
 //------------------------------ 
 anHeader[ TXT_LEN ]  := nLen 

 //---------------------- 
 // Longitud del registro 
 //---------------------- 
 anHeader[ TXT_LEN1 ] := 8 + nLen 

 //--------------------------------------------- 
 // En le formato BIFF se comienza desde cero y 
 // no desde 1 como estamos pasando los datos 
 //--------------------------------------------- 
 nI          := nRow - 1 
 anHeader[ TXT_ROW1 ] := nI - (Int( nI / 256 ) * 256 ) 
 anHeader[ TXT_ROW2 ] := Int( nI / 256 ) 
 anHeader[ TXT_COL1 ] := nCol - 1 

 //------------------- 
 // Escribe encabezado 
 //------------------- 
 Aeval( anHeader, { | v | fWrite( nHandle, Chr( v ), 1 )}) 

 //----------------------------------------------------- 
 // Escribe la data 
 //----------------------------------------------------- 
 for nI:=1 to nLen 
  fWrite( nHandle, SubStr( cString, nI, 1 ), 1 ) 
 next nI 
return nil 

//---------------------------------------------------------- 
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
//---------------------------------------------------------- 
function TB2Xls (oTB, cXlsFile, cTitle) 

  local xXls, i, oCol, nTemp 
  local uColData, cAlign, cCell 

  // argument checking 
  if ValType(oTB) != "O" 
    return .f. 
  endif 
  if Empty(cXlsFile) 
    cXlsFile := "TB2Xls.xls" 
  else 
    cXlsFile := cXlsFile+".xls" 
  endif 

  // creating new Xls (.HTM) file 
  xXls := xlsOpen( cXlsFile ) 

  // output column headers 
  for i := 1 TO oTB:ColCount 
    oCol := oTB:GetColumn(i) 
    cCell := oCol:Heading 

    xlsWrite( xXls, 1, i, cCell ) 
  next 

  // here comes the main loop which generate the table body 
  Eval (oTB:goTopBlock) // start from the top 

  cLin := 2 
  do while .t. 

    for i := 1 TO oTB:ColCount 
      oCol  := oTB:GetColumn(i) 
      uColData := Eval(oCol:Block)  // column data (of yet unknown type) 
      do case 
       case ValType(uColData) == "C" // characters 
          if Empty(uColData) 
            cCell := ""     // if empty, display non-breaking space (&nbsp) 
                      // to prevent displaying "hole" in table 
          else 
            cCell := uColData 
          endif 
         //cAlign := ""      // text fields are left aligned 
       case ValType(uColData) == "N" // numbers 
          if ! Empty(oCol:picture) 
            cCell := Transform (uColData, oCol:picture) // display numbers according to column picture 
          else 
            cCell := Str(uColData) 
          endif 
          if Empty(cCell) 
            cCell := 0     // non-breaking space 
          endif 
         //cAlign := "" 
       case ValType(uColData) == "L" // logicals 
          cCell := if (uColData, "Sim", "Nao") 
         //cAlign := ""         // NOTE: if you prefer T/F style, change above line to 
                         //  cCell := if (uColData, "T", "F") 
       case ValType(uColData) == "D" // dates 
          if Empty(uColData) // empty dates 
            cCell := "" 
          else 
            cCell := DToC(uColData) 
          endif 
         //cAlign := "" 
        otherwise 
          cCell := "error" 
         //cAlign := "" 
      end case 
      xlsWrite( xXls, cLin, i, cCell ) 
    next 

    nTemp := Eval (oTB:SkipBlock, 1) 
    if nTemp != 1 // it's the end, so we are getting out 
      exit 
    endif 

    cLin++ 
  end do // main loop 

  Eval (oTB:goTopBlock) // set TBrowse back to top 

  // writing Xls tail 
  xlsClose( xXls ) 

return .t. 

/* 
 * 
 * Exemplo de criacao de .XLS 
 * 
 * 
 */ 
//function main
// nXls := xlsOpen( "teste.xls" ) 
 //xlsWrite( nXls, 1, 1, "Pais" ) 
 //xlsWrite( nXls, 1, 2, "Capital" ) 
 //xlsWrite( nXls, 1, 3, "Populacao" )
 //adata:={}
 //aadd(adata,{"br","brasilia",50})
 //aadd(adata,{"sp","sao paulo",150})
 //f := 2 
 //for i:=1 to Len( aData ) 
//   xlsWrite( nXls, f, 1, aData[ i , 1 ] ) 
//   xlsWrite( nXls, f, 2, aData[ i , 2 ] ) 
//   xlsWrite( nXls, f, 3, Ltrim( Str( aData[ i , 3 ] ))) 
//   f++ 
 //next i 
 //xlsClose( nXls ) 
 //return
