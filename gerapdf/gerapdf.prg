REQUEST HB_CODEPAGE_PTISO

#include "inkey.ch"
#include "set.ch"
#include "hbgtinfo.ch"

FUNCTION Main( cXmlDocumento, cLogoFile, cXmlAuxiliar )

   LOCAL  oDanfe,  cTEMPFILE
   

   SET DATE BRITISH   
   SetMode( 25, 80 )
   cls
   Set( _SET_CODEPAGE, "PTISO" )
   SetColor( "W/B,N/W,,,W/B" )

   aXML:={}
   IF cXmlDocumento != NIL
       aXML:={cXmlDocumento}
   ELSE
	  aARQ:= Directory("*.XML")
	  nFIM:=LEN(aARQ)    
	  For ii := 1 to nFIM      
		 cARQUIVO:= UPPER(Aarq[ii,1])      
		 aadd(AXML,cARQUIVO)
	  next ii	 
   ENDIF
   
  
    nFIM:=LEN(aXML)    
   FOR ZZ=1 TO LEN(aXML)
       
       cXmlDocumento := aXML[ZZ]
   
   
      cTEMPFILE:=STRTRAN(UPPER(cXmlDocumento),".XML",".PDF")
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
      oDanfe := hbNFeDaGeral():New()
      oDanfe:cDesenvolvedor := "NFEXMLDANFE"
      oDanfe:cLogoFile      := cLogoFile
      oDanfe:ToPDF( cXmlDocumento, ctempfile, cXmlAuxiliar )
//      PDFOpen( ctempfile)
      
   NEXT ZZ

RETURN NIL

   
FUNCTION PDFOpen( cFile )

   IF File( cFile )
      //WAPI_ShellExecute( NIL, "open", cFile, "",, WIN_SW_SHOWNORMAL )
	  WAPI_ShellExecute( NIL, "open", cFile, "",, )
      Inkey(1)
   ENDIF

   RETURN NIL

