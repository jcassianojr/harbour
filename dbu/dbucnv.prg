*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+   DBUCNV.PRG
*+
*+   Function Dbf2Xml()
*+   Function GetXMLString()
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
#INCLUDE "DBINFO.CH"
#INCLUDE "Dbstruct.ch"

*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Function Dbf2Xml()
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
function Dbf2Xml() //Requer Area Aberta

local sRet           := ""
local hXML
local sXML
local sAlias
local s
local sType
local sData
local dwBytesWritten
local i



//if !dbusearea( TRUE, "DBFCDX", DbfFile + ".dbf",, TRUE )
//   ALERTX( "Erro Abrindo DBF" )
//   retu
//endif
sAlias := upper( alias() )
sXML   := sAlias + ".xml"

hXML := fcreate( sXML,0)
if hXML == -1
   ALERTX("Erro Criando XML")
   retu
endif

s := '<?xml version="1.0" encoding="windows-1252"?>' + HB_OsNewLine()
FWrite( hXML,  s  )
s := '<' + sAlias + 's>' + HB_OsNewLine()
fwrite( hXML,  s  )

s := '<xsd:schema id="' + sAlias + 's"' + ;
     ' xmlns="" ' + ;
     'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' + ;
     'xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">' + HB_OsNewLine()
fwrite( hXML,  s  )

s := '  <xsd:element name="' + sAlias + 's" msdata:IsDataSet="true" msdata:Locale="en-US">' + HB_OsNewLine()
fwrite( hXML,  s  )

s := '    <xsd:complexType>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '      <xsd:choice maxOccurs="unbounded">' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '        <xsd:element name="' + sAlias + '">' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '          <xsd:complexType>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '            <xsd:sequence>' + HB_OsNewLine()
fwrite( hXML,  s  )
for i := 1 to fcount()
   if dbfieldinfo( DBS_TYPE, i ) == "L"
      sType := "boolean"
   elseif dbfieldinfo( DBS_TYPE, i ) == "N"
      if dbfieldinfo( DBS_DEC, i ) == 2
         sType := "decimal"
      elseif dbfieldinfo( DBS_DEC, i ) == 0
         sType := "integer"
      else
         sType := "double"
      endif
   elseif dbfieldinfo( DBS_TYPE, i ) == "D"
      sType := "date"                   // date correlates to CLR DateTime which can't be null
   else
      sType := "string"
   endif
   s := '              <xsd:element name="' + UPPER( fieldname( i ) ) + '"  type="xsd:' + sType + '" minOccurs="0"/>' + HB_OsNewLine()
   fwrite( hXML,  s  )
next
s := '            </xsd:sequence>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '          </xsd:complexType>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '        </xsd:element>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '      </xsd:choice>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '    </xsd:complexType>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '  </xsd:element>' + HB_OsNewLine()
fwrite( hXML,  s  )
s := '</xsd:schema>' + HB_OsNewLine()
fwrite( hXML,  s  )

// Write XML data -----------------------------------------------------------------------
dbgotop()
while !eof()
   s := '  <' + sAlias + '>' + HB_OsNewLine()
   fwrite( hXML,  s  )
   for i := 1 to fcount()
      sData := GetXMLString( fieldget( i ) )
      s     := '    <' + UPPER( fieldname( i ) ) + '>' + sData + '</' + UPPER( fieldname( i ) ) + '>' + HB_OsNewLine()
      fwrite( hXML,  s  )
   next
   s := '  </' + sAlias + '>' + HB_OsNewLine()
   fwrite( hXML,  s  )
   dbskip( 1 )
end
s := '</' + sAlias + 's>' + HB_OsNewLine()
fwrite( hXML,  s  )
FClose( hXML )
//dbclosearea()
return sRet


*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Function GetXMLString()
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
function GetXMLString( x )

local d
local sRet

if valtype( x ) == "L"
   sRet := iif( x, "1", "0" )
elseif valtype( x ) == "D"
   d := x
   if empty( d )
      sRet := DATA2STR(ctod("01/01/0001"),ZANOFOR,ZANOSEP,ZANOTAM) //"0001-01-01"
   else
      sRet := DATA2STR(d,ZANOFOR,ZANOSEP,ZANOTAM) //substr( dtos( d ), 1, 4 ) + "-" + substr( dtos( d ), 5, 2 ) + "-" + substr( dtos( d ), 7, 2 )
   endif
elseif valtype( x ) == "C"
   sRet := str2html(x)
else
   sRet := StrVAL( x )
endif
return sRet

*+ EOF: FAZ.PRG
