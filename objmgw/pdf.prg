  #include "harupdf.ch"
  #include "hbcompat.ch"
	
	***********************
	FUNCTION FILETOPDF(cARQ,cFileToSave)
	***********************
  LOCAL nFileHandle
  LOCAL cLINHA
  LOCAL cAuthor
  LOCAL cCreator
  LOCAL cTitle 
  LOCAL cSubject
  LOCAL aAMB
	
	PRIVATE nLINES
	   Private page, height, width, def_font, font
	   Private pdf 
	

     if ! HB_FILEEXISTS( cARQ )
        ALERTX( "Falta Arquivo " + cARQ )
        return ""
     endif
  
    cAuthor:=space(60)
    cCreator:=space(60)
    cTitle :=space(60)
    cSubject:=space(60)
     
     aAMB:=SALVAA()
     CLSBOX(19,00,MAXROW(),MAXCOL()) 
     @ 20,00 SAY "Autor:"
     @ 21,00 say "Criador:"
     @ 22,00 say "Titulo"
     @ 23,00 say "Assunto:"
     @ 20,15 get cAuthor
     @ 21,15 get cCreator
     @ 22,15 get cTitle
     @ 23,15 get cSubject
     read
     RESTAA(aAMB)

     IF valtype(cFileToSave)#"C"
       cFileToSave := trocaext(cARQ,".PDF") //substr( cARQ, 1, at( ".", cARQ ) - 1 ) + ".PDF"
     endif
	
	   nLINES      :=FLineCount(cARQ)
       nFileHandle := hb_FOpen( cARQ )

	   pdf := HPDF_New()
	
	   if pdf == NIL
	      ALERTX( " Erro ao tentar gerar o Arquivo Pdf, Favor Tente novamente","Aviso do Sistema" )
	      Return "erro.txt"
	   endif
	
	   /* set compression mode */
	   HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
       HPDF_SetCurrentEncoder( PDF, "WinAnsiEncoding" )  //"WinAnsiEncoding" // "CP1252"
       
       
          IF ! Empty( cAuthor )
              HPDF_SetInfoAttr( PDF, HPDF_INFO_AUTHOR, cAuthor )
        ENDIF
        IF ! Empty( cCreator )
            HPDF_SetInfoAttr( PDF, HPDF_INFO_CREATOR, cCreator )
        ENDIF
        IF ! Empty( cTitle )
            HPDF_SetInfoAttr( PDF, HPDF_INFO_TITLE, cTitle )
        ENDIF
        IF ! Empty( cSubject )
            HPDF_SetInfoAttr( Pdf, HPDF_INFO_SUBJECT, cSubject )
        ENDIF
        HPDF_SetInfoDateAttr( PDF, HPDF_INFO_CREATION_DATE, { Year( Date() ), Month( Date() ), Day( Date() ), Val( Substr( Time(), 1, 2 ) ), Val( Substr( Time(), 4, 2 ) ), Val( Substr( Time(), 7, 2 ) ), "+", 4, 0 } )


       
	   *HPDF_SetPassword(pdf, "senha","usuario" )  // colocar senha no PDF
	
	   page := HPDF_AddPage(pdf)
	   height := HPDF_Page_GetHeight(page)
	   width  := HPDF_Page_GetWidth(page)
	
	   def_font := HPDF_GetFont( pdf, "Helvetica", "WinAnsiEncoding") //, nil
	   HPDF_Page_BeginText( page )
	   HPDF_Page_MoveTextPos( page, 10, height - 10 )
	
	   vCONT=0
	
     @ maxrow(),0 say "Gerando PDF"
     zei_fort( nLines,,,0)
	   DO WHILE HB_FReadLine( nFileHandle, @cLinha ) == 0
        IF cLINHA="##page##" //salto pagina indicada na geracao do txt
           vCONT=79
        ELSE
            cLINHA := RANGEREM( chr( 0 ), chr( 09 ), cLINHA )            // CHR(13)+CHR(10)
            cLINHA := RANGEREM( chr( 11 ), chr( 12 ), cLINHA )           // Line Feed Manter
            cLINHA := RANGEREM( chr( 14 ), chr( 31 ), cLINHA )           //
            clinha := hb_oemtoansi(cLINHA)        
    	      font := HPDF_GetFont( pdf, "Courier" , "WinAnsiEncoding" ) //nil
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