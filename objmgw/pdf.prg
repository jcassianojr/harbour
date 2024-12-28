// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : pdf.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "harupdf.ch"
#include "hbcompat.ch"

// **********************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FILETOPDF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FILETOPDF( cARQ, cFileToSave )

// **********************
   LOCAL nFileHandle
   LOCAL cLINHA
   LOCAL cAuthor
   LOCAL cCreator
   LOCAL cTitle
   LOCAL cSubject
   LOCAL aAMB

   PRIVATE nLINES
   PRIVATE page, height, width, def_font, font
   PRIVATE pdf


   IF !hb_FileExists( cARQ )
      ALERTX( "Falta Arquivo " + cARQ )
      RETURN ""
   ENDIF

   cAuthor  := Space( 60 )
   cCreator := Space( 60 )
   cTitle   := Space( 60 )
   cSubject := Space( 60 )

   aAMB := SALVAA()
   CLSBOX( 19, 00, MaxRow(), MaxCol() )
   @ 20, 00 SAY "Autor:"
   @ 21, 00 SAY "Criador:"
   @ 22, 00 SAY "Titulo"
   @ 23, 00 SAY "Assunto:"
   @ 20, 15 GET cAuthor
   @ 21, 15 GET cCreator
   @ 22, 15 GET cTitle
   @ 23, 15 GET cSubject
   READ
   RESTAA( aAMB )

   IF ValType( cFileToSave ) # "C"
      cFileToSave := trocaext( cARQ, ".PDF" )   // substr( cARQ, 1, at( ".", cARQ ) - 1 ) + ".PDF"
   ENDIF

   nLINES      := FLineCount( cARQ )
   nFileHandle := hb_FOpen( cARQ )

   pdf := HPDF_New()

   IF pdf == NIL
      ALERTX( " Erro ao tentar gerar o Arquivo Pdf, Favor Tente novamente", "Aviso do Sistema" )
      RETURN "erro.txt"
   ENDIF

/* set compression mode */
   HPDF_SetCompressionMode( pdf, HPDF_COMP_ALL )
   HPDF_SetCurrentEncoder( PDF, "WinAnsiEncoding" )   // "WinAnsiEncoding" // "CP1252"


   IF !Empty( cAuthor )
      HPDF_SetInfoAttr( PDF, HPDF_INFO_AUTHOR, cAuthor )
   ENDIF
   IF !Empty( cCreator )
      HPDF_SetInfoAttr( PDF, HPDF_INFO_CREATOR, cCreator )
   ENDIF
   IF !Empty( cTitle )
      HPDF_SetInfoAttr( PDF, HPDF_INFO_TITLE, cTitle )
   ENDIF
   IF !Empty( cSubject )
      HPDF_SetInfoAttr( Pdf, HPDF_INFO_SUBJECT, cSubject )
   ENDIF
   HPDF_SetInfoDateAttr( PDF, HPDF_INFO_CREATION_DATE, { Year( Date() ), Month( Date() ), Day( Date() ), Val( SubStr( Time(), 1, 2 ) ), Val( SubStr( Time(), 4, 2 ) ), Val( SubStr( Time(), 7, 2 ) ), "+", 4, 0 } )



// HPDF_SetPassword(pdf, "senha","usuario" )  // colocar senha no PDF

   page   := HPDF_AddPage( pdf )
   height := HPDF_Page_GetHeight( page )
   width  := HPDF_Page_GetWidth( page )

   def_font := HPDF_GetFont( pdf, "Helvetica", "WinAnsiEncoding" )   // , nil
   HPDF_Page_BeginText( page )
   HPDF_Page_MoveTextPos( page, 10, height - 10 )

   vCONT := 0

   @ MaxRow(), 0 SAY "Gerando PDF"
   zei_fort( nLines,,, 0 )
   DO WHILE HB_FReadLine( nFileHandle, @cLinha ) == 0
      IF cLINHA = "##page##"   // salto pagina indicada na geracao do txt
         vCONT := 79
      ELSE
         cLINHA := RANGEREM( Chr( 0 ), Chr( 09 ), cLINHA )   // CHR(13)+CHR(10)
         cLINHA := RANGEREM( Chr( 11 ), Chr( 12 ), cLINHA )  // Line Feed Manter
         cLINHA := RANGEREM( Chr( 14 ), Chr( 31 ), cLINHA )  //
         clinha := hb_OEMToANSI( cLINHA )
         font   := HPDF_GetFont( pdf, "Courier", "WinAnsiEncoding" )   // nil
         HPDF_Page_SetFontAndSize( page, def_font, 7 )
         HPDF_Page_SetFontAndSize( page, font, 7 )
         HPDF_Page_ShowText( page, cLinha )
         HPDF_Page_MoveTextPos( page, 0, - 10 )
      ENDIF
      vCONT := vCONT + 1
      IF vCONT = 80
         page := HPDF_AddPage( pdf )
         HPDF_Page_SetLineWidth( page, 1 )
         HPDF_Page_BeginText( page )
         HPDF_Page_MoveTextPos( page, 10, height - 10 )
         vCONT := 0
      ENDIF
      zei_fort( nLINES,,, 1 )
   ENDDO

   HPDF_Page_EndText( page )
   HPDF_SaveToFile( pdf, cFileToSave )

   HPDF_Free( pdf )
   FClose( nFileHandle )
   @ MaxRow(), 0 SAY "Gerado PDF " + cFILETOSAVE

   RETURN cFileToSave


// Function PdfRow(nRow)
// Return nAltura - nRow*6*1.2

// Function PdfCol(nCol)
// Return nCol*6/1.5

// + EOF: pdf.prg
// +
