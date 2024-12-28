// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : gerapdf.prg
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
// +    Documentado em 27-Dez-2024 as  9:24 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

REQUEST HB_CODEPAGE_PTISO

#include "inkey.ch"
#include "set.ch"
#include "hbgtinfo.ch"
#include "tshead.ch"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Main()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Main( cXmlDocumento, cLogoFile, cXmlAuxiliar )

   LOCAL oDanfe, cTEMPFILE

   hb_idleState()
   Set( _SET_CODEPAGE, "PTISO" )
   __SetCentury( .T. )
   Set( _SET_EPOCH, Year( Date() ) - 60 )
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )

   SetMode( 25, 80 )
   cls
   SetColor( "W/B,N/W,,,W/B" )

   aXML := {}
   IF cXmlDocumento != NIL
      aXML := { cXmlDocumento }
   ELSE
      aARQ := Directory( "*.XML" )
      nFIM := Len( aARQ )
      FOR ii := 1 TO nFIM
         cARQUIVO := Upper( Aarq[ ii, 1 ] )
         AAdd( AXML, cARQUIVO )
      NEXT ii
   ENDIF


   nFIM := Len( aXML )
   FOR ZZ := 1 TO Len( aXML )

      cXmlDocumento := aXML[ ZZ ]


      cTEMPFILE := StrTran( Upper( cXmlDocumento ), ".XML", ".PDF" )
      IF File( cXmlDocumento )
         cXmlDocumento := MemoRead( cXmlDocumento )
      ENDIF
      IF cXmlAuxiliar != NIL
         IF File( cXmlAuxiliar )
            cXmlAuxiliar := MemoRead( cXmlAuxiliar )
         ENDIF
      ENDIF
      IF cLogoFile != NIL
         IF File( cLogoFile )
            cLogoFile := MemoRead( cLogoFile )
         ENDIF
      ENDIF
      oDanfe                := hbNFeDaGeral():New()
      oDanfe:cDesenvolvedor := "NFEXMLDANFE"
      oDanfe:cLogoFile      := cLogoFile
      oDanfe:ToPDF( cXmlDocumento, ctempfile, cXmlAuxiliar )
      // PDFOpen( ctempfile)

   NEXT ZZ

   RETURN NIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PDFOpen()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PDFOpen( cFile )

   IF File( cFile )
      // WAPI_ShellExecute( NIL, "open", cFile, "",, WIN_SW_SHOWNORMAL )   essSW_SHOWNORMAL = 1
      // hwnd,   lpOperation,  lpFile,   lpParameters,   lpDirectory,    nShowCmd

      WAPI_ShellExecute( NIL, "open", cFile, "", "", 1 )
      Inkey( 1 )
   ENDIF

   RETURN NIL


// + EOF: gerapdf.prg
// +
