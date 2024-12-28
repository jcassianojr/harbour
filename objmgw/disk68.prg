// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk68.prg
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

// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
// +
// +    Source Module => C:\DEVELOP\OBJ\DISK68.PRG
// +
// +    Functions: Function CARDCHEK()
// +               Function CHECKCTA()
// +               Function CALCDIG()
// +               Function DAC10()
// +
// +    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
// +
// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

#include "INKEY.CH"

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function CARDCHEK()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CARDCHEK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CARDCHEK( Arg1 )

   LOCAL Local1
   LOCAL Local2
   LOCAL Local3
   LOCAL Local4
   LOCAL Local5
   LOCAL lRETU  := .F.
   LOCAL aCards := { "AmEx", "Visa", "MasterCard", "Discover", ;
      "Carte Blanche", "Diners", "JCB" }

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF

   Local3 := 0

   IF ValType( aRG1 ) # "C"
      ARg1 := StrZero( aRG1, Len( arg1 ) )
   ENDIF

   ARg1 := TIRAOUT( aRG1 )
   Arg1 := AllTrim( Arg1 )

   IF Empty( ARG1 )
      ALERTX( "Numero N苚 Informado" )
      RETU .F.
   ENDIF

   IF ( Left( Arg1, 1 ) == "0" )
      ALERTX( "Numero Come嘺ndo com Zero" )
      RETU .F.
   ENDIF

   IF ( Len( Arg1 ) < 16 )
      Local4 := Replicate( "0", 16 - Len( Arg1 ) ) + Arg1
   ELSE
      Local4 := Arg1
   ENDIF
   FOR Local1 := 1 TO 15 STEP 2
      Local2 := Val( SubStr( Local4, Local1, 1 ) ) * 2
      IF ( Local2 > 9 )
         Local3 += ( 1 + Local2 % 10 )
      ELSE
         Local3 += Local2
      ENDIF
   NEXT
   FOR Local1 := 2 TO 16 STEP 2
      Local3 += Val( SubStr( Local4, Local1, 1 ) )
   NEXT
   IF ( Local3 == 0 .OR. Local3 % 10 != 0 )
      Local5 := -1
   ELSE
      Local4 := Left( Arg1, 2 )
      DO CASE
      CASE Local4 == "34" .OR. Local4 == "37"
         Local5 := 1
      CASE Local4 == "36"
         Local5 := 6
      CASE Local4 == "38"
         IF ( SubStr( Arg1, 3, 1 ) == "9" )
            Local5 := 5
         ELSE
            Local5 := 6
         ENDIF
      CASE Local4 == "31" .OR. Local4 == "33" .OR. Local4 == "35"
         Local4 := Left( Arg1, 6 )
         DO CASE
         CASE Local4 >= "311200" .AND. Local4 <= "312099"
            Local5 := 7
         CASE Local4 >= "315800" .AND. Local4 <= "315999"
            Local5 := 7
         CASE Local4 >= "333700" .AND. Local4 <= "334999"
            Local5 := 7
         CASE Local4 >= "352800" .AND. Local4 <= "358999"
            Local5 := 7
         OTHERWISE
            Local5 := -1
         ENDCASE
      CASE Local4 == "30"
         Local4 := Left( Arg1, 6 )
         IF ( Local4 >= "308800" .AND. Local4 <= "309499" )
            Local5 := 7
         ELSEIF ( Local4 >= "309600" .AND. Local4 <= "310299" )
            Local5 := 7
         ELSE
            Local5 := 6
         ENDIF
      CASE Left( Local4, 1 ) == "4"
         Local5 := 2
      CASE Local4 >= "51" .AND. Local4 <= "55"
         Local5 := 3
      CASE Local4 == "60" .AND. SubStr( Arg1, 3, 2 ) == "11"
         Local5 := 4
      CASE Left( Local4, 1 ) == "9"
         Local5 := 5
      OTHERWISE
         Local5 := 0
      ENDCASE
   ENDIF
   IF local5 > 0
      lRETU := .T.
      ALERTX( aCards[ local5 ] )
   ELSE
      ALERTX( "Nero Inv爈ido" )
   ENDIF

   RETURN lRETU

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function CHECKCTA()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCTA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKCTA( cBANCO, cAGENCIA, cCONTA )

   LOCAL eTOT := 0

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF ValType( cBANCO ) = "N"
      cBANCO := StrZero( cBANCO, 3 )
   ENDIF
   IF cBANCO # "033" .AND. cBANCO # "237" .AND. cBANCO # "341"
      RETU .T.
   ENDIF
// Ajustando Conta
   cCONTA := StrTran( cCONTA, " ", "" )
   cCONTA := TIRAOUT( cCONTA )
// Ajustando Agencia
   cAGENCIA := StrTran( cAGENCIA, " ", "" )
   cAGENCIA := TIRAOUT( cAGENCIA )
   DO CASE
   CASE cBANCO = "033"
      IF Len( cCONTA ) # 9
         ALERTX( "Quantidade de Digitos da Conta Diferente de 9" )
         RETU .F.
      ENDIF
      cAGENCIA := Right( cAGENCIA, 3 )
      eTOT     += CALCDIG( 7, SubStr( cAGENCIA, 1, 1 ) )
      eTOT     += CALCDIG( 3, SubStr( cAGENCIA, 2, 1 ) )
      eTOT     += CALCDIG( 1, SubStr( cAGENCIA, 3, 1 ) )
      eTOT     += CALCDIG( 9, SubStr( cCONTA, 1, 1 ) )
      eTOT     += CALCDIG( 7, SubStr( cCONTA, 2, 1 ) )
      eTOT     += CALCDIG( 1, SubStr( cCONTA, 3, 1 ) )
      eTOT     += CALCDIG( 3, SubStr( cCONTA, 4, 1 ) )
      eTOT     += CALCDIG( 1, SubStr( cCONTA, 5, 1 ) )
      eTOT     += CALCDIG( 9, SubStr( cCONTA, 6, 1 ) )
      eTOT     += CALCDIG( 7, SubStr( cCONTA, 7, 1 ) )
      eTOT     += CALCDIG( 3, SubStr( cCONTA, 8, 1 ) )
      eTOT     := StrZero( eTOT )
      eTOT     := Right( eTOT, 1 )
      eTOT     := if( Val( eTOT ) > 0, 10 - Val( eTOT ), 0 )
      IF eTOT # Val( SubStr( cCONTA, 9, 1 ) )
         ALERTX( "Checagem da Conta n刼 Confere" )
         RETU .F.
      ENDIF
   CASE cBANCO = "341"
      IF ( dac10( cAGENCIA + Left( cCONTA, 5 ) ) != Right( cCONTA, 1 ) )
         ALERTX( "Checagem da Conta n刼 Confere" )
         RETU .F.
      ENDIF
   CASE cBANCO = "237"
      eTOT := 0
      nFIM := Len( cCONTA )
      nINI := nFIM
      nFIM--
      FOR X := 1 TO nFIM
         eTOT += nINI * Val( SubStr( cCONTA, X, 1 ) )
         nINI--
      NEXT X
      nRES := eTOT % 11
      nRES := 11 - nRES
      nRES := if( nRES = 10, "P", Str( nRES, 1 ) )
      IF nRES <> Right( cCONTA, 1 )
         ALERTX( "Digito de Controle n刼 confere" )
         RETU .F.
      ENDIF
   ENDCASE
   RETU .T.

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function CALCDIG()
// +
// +    Called from ( disk68.prg   )  11 - function checkcta()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCDIG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCDIG( n1, n2 )

   LOCAL eRETU

   IF ValType( N2 ) = "C"
      N2 := Val( N2 )
   ENDIF
   eRETU := N1 * N2
   eRETU := StrZero( eRETU )
   eRETU := Right( eRETU, 1 )
   eRETU := Val( eRETU )
   RETU eRETU

// *******************************

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function DAC10()
// +
// +    Called from ( disk68.prg   )   1 - function checkcta()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DAC10()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION DAC10( Arg1 )

   LOCAL cnumero
   LOCAL ninicio
   LOCAL ntotal
   LOCAL ccpoaux
   LOCAL x

   ninicio := Len( AllTrim( Arg1 ) ) + 1
   ntotal  := 0
   IF ( ninicio < 2 )
      ninicio := 2
   ENDIF
   ccpoaux := "0" + AllTrim( Arg1 )
   FOR x := ninicio TO 1 STEP - 2
      cnumero := SubStr( ccpoaux, x, 1 )
      ntotal  += At( cnumero, "516273849" )
      ntotal  += Val( SubStr( ccpoaux, x - 1, 1 ) )
   NEXT

   RETURN AllTrim( Str( At( SubStr( Str( ntotal, 3 ), 3, 1 ), "987654321" ) ) )

// + EOF: DISK68.PRG

// + EOF: disk68.prg
// +
