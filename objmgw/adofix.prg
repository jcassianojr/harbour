// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : adofix.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIX02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIX02( cVALOR )

   IF Empty( cVALOR )
      RETURN ""
   ENDIF
   IF ValType( cVALOR ) <> "C"
      RETURN ""
   ENDIF
   cVALOR := RANGEREPL( Chr( 0 ), Chr( 31 ), cVALOR, " " )
   cVALOR := RANGEREPL( Chr( 127 ), Chr( 255 ), cVALOR, " " )
   cVALOR := AllTrim( cVALOR )

   RETURN cVALOR


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXINT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXINT( eVALOR )

   RETURN Int( FIXNUM( eVALOR ) )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXNUM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXNUM( cCAMPO )

   IF ValType( cCAMPO ) # "N"
      RETURN 0
   ENDIF

   RETURN cCAMPO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXSTR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXSTR( cCAMPO, lTRIM )

   IF ValType( cCAMPO ) <> "C"
      RETURN ""
   ENDIF
   IF ValType( lTRIM ) <> 'L'
      lTRIM := .F.
   ENDIF

   RETURN IF( lTRIM, AllTrim( cCAMPO ), cCAMPO )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXDATS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXDATS( cCAMPO )

   IF ValType( cCAMPO ) <> "C"
      RETURN ""
   ENDIF
   IF cCAMPO = '01/01/1900' .OR. TIRAOUT( cCAMPO ) = '01011900'
      RETURN ""
   ENDIF
// if TIRAOUT(cCAMPO)='00000101' //sqllite
// RETURN ""
// ENDIF

   RETURN cCAMPO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXDATA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXDATA( cCAMPO )

   IF ValType( cCAMPO ) <> 'C' .AND. ValType( cCAMPO ) <> 'D'
      RETURN CToD( Space( 8 ) )
   ELSE
      IF ValType( cCAMPO ) = "D"
         RETURN cCAMPO
      ENDIF
      cCAMPO := Left( cCAMPO, 10 )
      cCAMPO := StrTran( cCAMPO, "-", "" )
      cCAMPO := SToD( cCAMPO )
   ENDIF

   RETURN cCAMPO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXLOGIC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXLOGIC( cCAMPO )

   IF ValType( cCAMPO ) <> 'L'
      RETURN .F.
   ENDIF

   RETURN cCAMPO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXHORA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXHORA( cCampo )

   cCAMPO := FIXSTR( cCAMPO )
   cCAMPO := SubStr( cCAMPO, At( " ", cCAMPO ) + 1 )
   cCAMPO := Left( cCAMPO, 5 )
   cCAMPO := StrTran( cCAMPO, ":", "." )

   RETURN cCAMPO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DateToMySQL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DateToMySQL( dDate )

   RETURN data2str( dDate, "MYS", "-", "4" )
// LOCAL cString
// cString := StrZero( Year( dDate ), 4 ) + "-" + StrZero( Month( dDate ), 2 ) + "-" + StrZero( Day( dDate ), 2 )
// IF cString == "0000-00-00"
// cString := "NULL"
// ENDIF
// RETURN cString


// sqllite '0000-01-01 00:00:00''0000-01-01 00:00:00'

// + EOF: adofix.prg
// +
