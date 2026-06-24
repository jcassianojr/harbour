PROCEDURE Main()

   LOCAL cXml, cHtml, cTexto

   IF hb_ArgC() >= 1
      cXml := hb_ArgV( 1 )
   ELSE
    cXml :="nfe_teste_danfe_simplificado.xml"
      //cXml := '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><retorno><status><cdResposta>501</cdResposta><descResposta>Solicitacao de consulta incorreta</descResposta></status></retorno></s:Body></s:Envelope>'
   ENDIF

   cHtml  := SefazXmlVisualizacaoHtml( cXml )
   cTexto := SefazXmlVisualizacaoTexto( cXml )

   hb_MemoWrit( "visualizacao_xml.html", cHtml )
   hb_MemoWrit( "visualizacao_xml.txt", cTexto )

   ? "Gerado visualizacao_xml.html"
   ? "Gerado visualizacao_xml.txt"
   ? "Nada foi aberto fora do sistema."
RETURN
