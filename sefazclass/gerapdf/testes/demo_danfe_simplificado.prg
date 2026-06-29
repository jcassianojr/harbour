PROCEDURE Main()

   LOCAL cXml
   LOCAL cHtmlFile:= "danfe_simplificado.html"
   local cPdfFile := "danfe_simplificado.pdf"
   local cTxtFile := "danfe_simplificado.txt"
   LOCAL cRet

   IF hb_ArgC() >= 1
      cXml := hb_ArgV( 1 )
   ELSE
       cXml :="nfe_teste_danfe_simplificado.xml"
      //? "Informe o XML autorizado nfeProc/NFe."
      //? "Exemplo: demo_danfe_simplificado.exe nfe_autorizada.xml"
     // RETURN
   ENDIF

   SefazDanfeSimplificadoSalvarHtml( cXml, cHtmlFile )
   ? "HTML gerado:", cHtmlFile

   cRet := SefazDanfeSimplificadoPdf( cXml, cPdfFile )
   IF cRet == cPdfFile
      ? "PDF gerado.:", cPdfFile
   ELSE
      ? "PDF erro..:", cRet
   ENDIF

   hb_MemoWrit( cTxtFile, SefazDanfeSimplificadoTexto( cXml ) )   
   
   ? "Texto gerado:", cTxtFile 
RETURN

