  #include "harupdf.ch"
  #include "hbcompat.ch"
	
	***********************
	FUNCTION FILETOPDF(cARQ,cFileToSave)
	***********************
	Local vAUTOR :=""
  LOCAL nFileHandle
  LOCAL cLINHA
	
	PRIVATE nLINES
	

     if ! HB_FILEEXISTS( cARQ )
        ALERTX( "Falta Arquivo " + cARQ )
        retu ""
     endif

     IF valtype(cFileToSave)#"C"
       cFileToSave := substr( cARQ, 1, at( ".", cARQ ) - 1 ) + ".PDF"
     endif
	
	   nLINES      :=FLineCount(cARQ)
     nFileHandle := FOpen( cARQ )

	   Private page, height, width, def_font, font
	   Private pdf := HPDF_New()
	
	   if pdf == NIL
	      ALERTX( " Erro ao tentar gerar o Arquivo Pdf, Favor Tente novamente","Aviso do Sistema" )
	      Return "erro.txt"
	   endif
	
	   /* set compression mode */
	   HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
	   *HPDF_SetPassword(pdf, "senha","leonardo" )  // colocar senha no PDF
	
	   page := HPDF_AddPage(pdf)
	   height := HPDF_Page_GetHeight(page)
	   width  := HPDF_Page_GetWidth(page)
	
	   def_font := HPDF_GetFont( pdf, "Helvetica", NIL )
	   HPDF_Page_BeginText( page )
	   HPDF_Page_MoveTextPos( page, 10, height - 10 )
	
	   vCONT=0
	
     @ maxrow(),0 say "Gerando PDF"
     zei_fort( nLines,,,0)
	   DO WHILE HB_FReadLine( nFileHandle, @cLinha ) == 0
        IF cLINHA="##page##"
           vCONT=79
        ELSE
            cLINHA := RANGEREM( chr( 0 ), chr( 09 ), cLINHA )            // CHR(13)+CHR(10)
            cLINHA := RANGEREM( chr( 11 ), chr( 12 ), cLINHA )           // Line Feed Manter
            cLINHA := RANGEREM( chr( 14 ), chr( 31 ), cLINHA )           //
            clinha := hb_oemtoansi(cLINHA)        
    	      font := HPDF_GetFont( pdf, "Courier" , NIL )
    	      HPDF_Page_SetFontAndSize( page, def_font, 7 )
    	      HPDF_Page_SetFontAndSize( page, font, 7 )
    	      HPDF_Page_ShowText( page, cLinha )
    	      HPDF_Page_MoveTextPos( page, 0, -10 )
        ENDIF    
    	  vCONT=vCONT+1
    	  IF vCONT=80
    	      page := HPDF_AddPage(pdf)
    	      HPDF_Page_SetLineWidth(page, 1)
    	      HPDF_Page_BeginText( page )
    	      HPDF_Page_MoveTextPos( page, 10, height - 10 )
    	      vCONT = 0
    	  ENDIF
	      zei_fort(nLINES,,,1)
	   enddo
	
	   HPDF_Page_EndText( page )
	   HPDF_SaveToFile( pdf, cFileToSave )
	
	   HPDF_Free( pdf )
	   fclose(nFileHandle)
     @ maxrow(),0 say "Gerado PDF " + cFILETOSAVE	

Return cFileToSave


//Function PdfRow(nRow)
//   Return nAltura - nRow*6*1.2
	 
//	Function PdfCol(nCol)
//	   Return nCol*6/1.5