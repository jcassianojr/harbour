/*
Visualizacao interna de XML.
Nao abre navegador externo. A funcao retorna HTML ou texto pronto para
um controle interno do sistema.
*/

FUNCTION SefazXmlVisualizacaoHtml( cXmlOuArquivo, lCabecalho )

   LOCAL cXml, cTexto

   lCabecalho := hb_DefaultValue( lCabecalho, .T. )
   cXml       := SefazXmlViewerLoad( cXmlOuArquivo )
   cTexto     := SefazXmlViewerPretty( SefazXmlViewerSanitize( cXml ) )

RETURN ;
   '<!doctype html>' + hb_Eol() + ;
   '<html>' + hb_Eol() + ;
   '<head>' + hb_Eol() + ;
   '<meta charset="utf-8">' + hb_Eol() + ;
   '<style>' + hb_Eol() + ;
   'body{margin:0;background:#fff;color:#111;font-family:Consolas,monospace;font-size:14px;}' + hb_Eol() + ;
   '.xml-browser-msg{font-family:"Times New Roman",serif;font-size:18px;padding:12px 14px 8px;border-bottom:3px solid #111;}' + hb_Eol() + ;
   '.xml-view{padding:12px 16px;line-height:1.35;white-space:pre-wrap;}' + hb_Eol() + ;
   '.xml-tag{color:#881280;font-weight:bold;}' + hb_Eol() + ;
   '.xml-attr{color:#994500;}' + hb_Eol() + ;
   '.xml-text{color:#111;}' + hb_Eol() + ;
   '</style>' + hb_Eol() + ;
   '</head>' + hb_Eol() + ;
   '<body>' + hb_Eol() + ;
   IIf( lCabecalho, '<div class="xml-browser-msg">This XML file does not appear to have any style information associated with it. The document tree is shown below.</div>' + hb_Eol(), '' ) + ;
   '<pre class="xml-view">' + SefazXmlViewerHtmlColor( cTexto ) + '</pre>' + hb_Eol() + ;
   '</body>' + hb_Eol() + ;
   '</html>'

FUNCTION SefazXmlVisualizacaoTexto( cXmlOuArquivo )

   LOCAL cXml

   cXml := SefazXmlViewerLoad( cXmlOuArquivo )

RETURN SefazXmlViewerPretty( SefazXmlViewerSanitize( cXml ) )

FUNCTION SefazXmlVisualizacaoSalvarHtml( cXmlOuArquivo, cArquivoSaida, lCabecalho )

   LOCAL cHtml

   IF Empty( cArquivoSaida )
      RETURN .F.
   ENDIF

   cHtml := SefazXmlVisualizacaoHtml( cXmlOuArquivo, lCabecalho )

RETURN hb_MemoWrit( cArquivoSaida, cHtml )

FUNCTION SefazXmlVisualizacaoSalvarTexto( cXmlOuArquivo, cArquivoSaida )

   IF Empty( cArquivoSaida )
      RETURN .F.
   ENDIF

RETURN hb_MemoWrit( cArquivoSaida, SefazXmlVisualizacaoTexto( cXmlOuArquivo ) )

STATIC FUNCTION SefazXmlViewerLoad( cXmlOuArquivo )

   IF Empty( cXmlOuArquivo )
      RETURN ""
   ENDIF

   IF File( cXmlOuArquivo )
      RETURN hb_MemoRead( cXmlOuArquivo )
   ENDIF

RETURN cXmlOuArquivo

STATIC FUNCTION SefazXmlViewerPretty( cXml )

   LOCAL cOut := "", nI := 1, nLen, nPos, cPart, nNivel := 0

   cXml := AllTrim( cXml )
   cXml := StrTran( cXml, "><", ">" + Chr( 10 ) + "<" )
   nLen := Len( cXml )

   DO WHILE nI <= nLen
      nPos := hb_At( Chr( 10 ), cXml, nI )
      IF nPos == 0
         cPart := SubStr( cXml, nI )
         nI := nLen + 1
      ELSE
         cPart := SubStr( cXml, nI, nPos - nI )
         nI := nPos + 1
      ENDIF

      cPart := AllTrim( cPart )
      IF Empty( cPart )
         LOOP
      ENDIF

      IF Left( cPart, 2 ) == "</"
         nNivel := Max( 0, nNivel - 1 )
      ENDIF

      cOut += Replicate( "  ", nNivel ) + cPart + hb_Eol()

      IF Left( cPart, 1 ) == "<" .AND. ;
         Left( cPart, 2 ) != "</" .AND. ;
         Left( cPart, 2 ) != "<?" .AND. ;
         Left( cPart, 4 ) != "<!--" .AND. ;
         Right( cPart, 2 ) != "/>" .AND. ;
         ! "</" $ SubStr( cPart, 2 )
         nNivel++
      ENDIF
   ENDDO

RETURN RTrim( cOut )

STATIC FUNCTION SefazXmlViewerSanitize( cXml )

   LOCAL nI, c, cOut := ""

   cXml := hb_DefaultValue( cXml, "" )

   IF Left( cXml, 3 ) == Chr( 239 ) + Chr( 187 ) + Chr( 191 )
      cXml := SubStr( cXml, 4 )
   ENDIF

   FOR nI := 1 TO Len( cXml )
      c := SubStr( cXml, nI, 1 )
      IF Asc( c ) >= 32 .OR. c $ Chr( 9 ) + Chr( 10 ) + Chr( 13 )
         cOut += c
      ENDIF
   NEXT

RETURN cOut

STATIC FUNCTION SefazXmlViewerHtmlColor( cText )

   LOCAL nI := 1, nStart, nEnd, cOut := "", cChunk

   cText := hb_DefaultValue( cText, "" )

   DO WHILE nI <= Len( cText )
      nStart := hb_At( "<", cText, nI )
      IF nStart == 0
         cOut += '<span class="xml-text">' + SefazXmlViewerHtmlEscape( SubStr( cText, nI ) ) + '</span>'
         EXIT
      ENDIF

      IF nStart > nI
         cOut += '<span class="xml-text">' + SefazXmlViewerHtmlEscape( SubStr( cText, nI, nStart - nI ) ) + '</span>'
      ENDIF

      nEnd := hb_At( ">", cText, nStart )
      IF nEnd == 0
         cOut += '<span class="xml-text">' + SefazXmlViewerHtmlEscape( SubStr( cText, nStart ) ) + '</span>'
         EXIT
      ENDIF

      cChunk := SubStr( cText, nStart, nEnd - nStart + 1 )
      cOut += '<span class="xml-tag">' + SefazXmlViewerHtmlEscape( cChunk ) + '</span>'
      nI := nEnd + 1
   ENDDO

RETURN cOut

STATIC FUNCTION SefazXmlViewerHtmlEscape( cText )

   cText := hb_DefaultValue( cText, "" )
   cText := StrTran( cText, "&", "&amp;" )
   cText := StrTran( cText, "<", "&lt;" )
   cText := StrTran( cText, ">", "&gt;" )
   cText := StrTran( cText, ["], "&quot;" )

RETURN cText

