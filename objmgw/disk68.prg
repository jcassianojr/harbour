#include "INKEY.CH"

/*
 * Função: CARDCHEK( cArg1, lMes )
 * Objetivo: Validar cartões de crédito (Luhn + Identificação de Bandeira)
 */
FUNCTION CARDCHEK( cArg1, lMes )
   LOCAL nSum    := 0
   LOCAL nLen, i, nDigit
   LOCAL lEven   := .F.
   LOCAL lRetu   := .F.
   LOCAL aCards  := { "AmEx", "Visa", "MasterCard", "Discover", ;
                      "Carte Blanche", "Diners", "JCB", "Elo", "Hipercard" }
   LOCAL nBrand  := 0

   lMes := IF( ValType(lMes) != "L", .F., lMes )

   IF LastKey() == K_UP .OR. LastKey() == K_DOWN
      RETURN .T.
   ENDIF

   IF ValType( cArg1 ) != "C"
      cArg1 := AllTrim(Str(cArg1))
   ENDIF

   cArg1 := hb_RegExReplace( "[^0-9]", AllTrim(cArg1), "" )

   IF Empty( cArg1 )
      RETURN .F.
   ENDIF

   nLen := Len( cArg1 )
   FOR i := nLen TO 1 STEP -1
      nDigit := Val( SubStr( cArg1, i, 1 ) )
      IF lEven
         nDigit *= 2
         IF nDigit > 9 ; nDigit -= 9 ; ENDIF
      ENDIF
      nSum += nDigit
      lEven := !lEven
   NEXT

   IF ( nSum % 10 == 0 .AND. nSum > 0 )
      DO CASE
      CASE Left( cArg1, 2 ) $ "34,37" .AND. nLen == 15
         nBrand := 1 // AmEx
      CASE Left( cArg1, 1 ) == "4"
         nBrand := 2 // Visa
      CASE ( Val(Left(cArg1, 2)) >= 51 .AND. Val(Left(cArg1, 2)) <= 55 ) .OR. ;
           ( Val(Left(cArg1, 6)) >= 222100 .AND. Val(Left(cArg1, 6)) <= 272099 )
         nBrand := 3 // MasterCard
      CASE Left( cArg1, 4 ) == "6011" .OR. Left( cArg1, 3 ) $ "644,645,646,647,648,649"
         nBrand := 4 // Discover
      CASE Left( cArg1, 3 ) >= "300" .AND. Left( cArg1, 3 ) <= "305"
         nBrand := 5 // Carte Blanche
      CASE Left( cArg1, 2 ) $ "30,36,38"
         nBrand := 6 // Diners
      CASE ( Val(Left(cArg1, 4)) >= 3528 .AND. Val(Left(cArg1, 4)) <= 3589 )
         nBrand := 7 // JCB
      CASE Left( cArg1, 4 ) $ "4011,4389,4514,4576,5041,5066,5090,6277,6362" 
         nBrand := 8 // Elo
      CASE Left( cArg1, 2 ) $ "38,60,62" .AND. nLen > 13
         nBrand := 9 // Hipercard
      ENDCASE
   ENDIF

   IF nBrand > 0
      lRetu := .T.
      IF lMes ; AlertX( aCards[nBrand] ) ; ENDIF
   ELSE
      IF lMes ; AlertX( "Numero Invalido" ) ; ENDIF
   ENDIF

RETURN lRetu

/*
 * Função: CHECKCTA( cBanco, cAgencia, cConta, lMes )
 * Objetivo: Validar DV de contas correntes (Bancos Tradicionais + Fintechs)
 */
FUNCTION CHECKCTA( cBANCO, cAGENCIA, cCONTA, lMes )
   LOCAL eTOT := 0
   LOCAL nX, nPeso, nResto, cDVCalc
   LOCAL cNumPuro, cCorpoConta, cDVInformado
   LOCAL aPesosSan := {9, 7, 1, 3, 1, 9, 7, 3} // Pesos padrão Santander para conta

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF

   lMes := IF( ValType(lMes) != "L", .F., lMes )

   // Normalização Robusta
   cBanco   := PadL( AllTrim(hb_ValToStr(cBanco)), 3, "0" )
   cAgencia := hb_RegExReplace( "[^0-9]", AllTrim(cAgencia), "" )
   cNumPuro := hb_RegExReplace( "[^0-9A-Za-z]", AllTrim(cConta), "" )
   
   cCorpoConta := Left(cNumPuro, Len(cNumPuro) - 1)
   cDVInformado := Upper(Right(cNumPuro, 1))

   DO CASE
   CASE cBANCO == "001" // Banco do Brasil
      eTOT := 0 ; nPeso := 2
      FOR nX := Len(cCorpoConta) TO 1 STEP -1
         eTOT += Val(SubStr(cCorpoConta, nX, 1)) * nPeso
         nPeso++
      NEXT
      nResto := 11 - (eTOT % 11)
      cDVCalc := IF(nResto == 10, "X", IF(nResto == 11, "0", Str(nResto, 1)))

   CASE cBANCO == "104" // Caixa Econômica
      eTOT := 0 ; nPeso := 2
      cCorpoConta := PadL(cAgencia, 4, "0") + cCorpoConta
      FOR nX := Len(cCorpoConta) TO 1 STEP -1
         eTOT += Val(SubStr(cCorpoConta, nX, 1)) * nPeso
         nPeso := IF(nPeso == 9, 2, nPeso + 1)
      NEXT
      cDVCalc := Str((eTOT * 10) % 11, 1)
      cDVCalc := IF(cDVCalc == "10", "0", cDVCalc)

   CASE cBANCO == "237" // Bradesco
      eTOT := 0 ; nPeso := 2
      FOR nX := Len(cCorpoConta) TO 1 STEP -1
         eTOT += Val(SubStr(cCorpoConta, nX, 1)) * nPeso
         nPeso := IF(nPeso == 7, 2, nPeso + 1)
      NEXT
      nResto := 11 - (eTOT % 11)
      cDVCalc := IF(nResto == 10, "P", IF(nResto == 11, "0", Str(nResto, 1)))

   CASE cBANCO == "341" // Itaú
      cDVCalc := DAC10( cAgencia + cCorpoConta )

   CASE cBANCO == "033" // Santander
      eTOT := 0
      cAgencia := Right( PadL(cAgencia, 4, "0"), 3 )
      eTOT += CALCDIG( 7, SubStr( cAgencia, 1, 1 ) )
      eTOT += CALCDIG( 3, SubStr( cAgencia, 2, 1 ) )
      eTOT += CALCDIG( 1, SubStr( cAgencia, 3, 1 ) )
      
      cCorpoConta := PadL(cCorpoConta, 8, "0")
      FOR nX := 1 TO 8
         eTOT += CALCDIG( aPesosSan[nX], SubStr(cCorpoConta, nX, 1) )
      NEXT 
      nResto := eTOT % 10
      cDVCalc := Str(IF(nResto == 0, 0, 10 - nResto), 1)

   CASE cBANCO $ "260,077,336,403,323,197,290,655,212,318" // Fintechs
      eTOT := 0 ; nPeso := 2
      FOR nX := Len(cCorpoConta) TO 1 STEP -1
         eTOT += Val(SubStr(cCorpoConta, nX, 1)) * nPeso
         nPeso := IF(nPeso == 9, 2, nPeso + 1)
      NEXT
      nResto := (eTOT * 10) % 11
      cDVCalc := IF(nResto >= 10, "0", Str(nResto, 1))

   OTHERWISE
      RETURN .T. 
   ENDCASE
   
   IF Upper(cDVCalc) != cDVInformado
      IF lMes
          AlertX( "Digito Verificador Invalido para o Banco " + cBANCO )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.

// Funções de apoio
FUNCTION CALCDIG( nPeso, xVal )
   RETURN ( (nPeso * Val(hb_ValToStr(xVal))) % 10 )

FUNCTION DAC10( cString )
   LOCAL nSum := 0, i, nDigit, lMult2 := .T.
   cString := AllTrim(cString)
   FOR i := Len(cString) TO 1 STEP -1
      nDigit := Val(SubStr(cString, i, 1))
      IF lMult2
         nDigit *= 2
         IF nDigit > 9 ; nDigit -= 9 ; ENDIF
      ENDIF
      nSum += nDigit
      lMult2 := !lMult2
   NEXT
   nSum := nSum % 10
   RETURN AllTrim(Str(IF(nSum == 0, 0, 10 - nSum)))