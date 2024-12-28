// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : valida_placa.prg
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

#include "INKEY.CH"

// + validaPlaca(cPlaca)
// * ValidaRenavam( cRenavam,lmes )
// * validacnh(eVALOR)
// *   ValidaCnhAntiga( cPgu )
// *   ValidaCnhImpresso( cNumero )
// *   ValidaCnhAtual( cCnh )
// * CheckCNHCat(cCNHCAT)



// +????????????????????????????????????????????????????????????????????
// +
// +    Function Validaplaca()
// +
// +????????????????????????????????????????????????????????????????????
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function validaPlaca()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION validaPlaca( cPlaca )

   LOCAL lRetorno := .T., nI, cPLACA3

   ZNERRO := 0
   ZERRO  := ""

   cPLACA := AllTrim( STRVAL( cPLACA ) )
   cPLACA := TIRAOUT( cPLACA )
   cPLACA := Upper( cPLACA )

// Regex regex = new Regex(@"^[a-zA-Z]{3}\-\d{4}$");
   IF Len( cPlaca ) = 7  // ABC1234
      FOR nI := 1 TO Len( cPlaca )
         IF nI <= 3  // tem que ser letra
            IF !SubStr( cPlaca, nI, 1 ) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
               lRetorno := .F.
               ZNERRO   := 1
               ZERRO    := "digito " + StrZero( ni, 1 ) + " nao e letra"
               EXIT
            ENDIF
         ELSE  // tem que ser numero
            IF !SubStr( cPlaca, nI, 1 ) $ '0123456789'
               lRetorno := .F.
               ZNERRO   := 2
               ZERRO    := "digito " + StrZero( ni, 1 ) + " nao e numero"
               EXIT
            ENDIF
         ENDIF
      NEXT
   ELSE
      lRetorno := .F.
   ENDIF

   IF cPLACA = "XXX9999" .OR. cPLACA = "XXX999" .OR. cPLACA = "XX9999" .OR. cPLACA = "XXXX999"
      LRetorno := .F.  // placas genericas
      ZNERRO   := 3
      ZERRO    := "placa generica" + cPLACA
   ENDIF

   IF lRETORNO
      cPLACA3 := SubStr( cPLACA, 1, 3 )
      DO CASE
      CASE cPLACA3 >= "MZN" .AND. cPLACA3 <= "NAG"   // AC|MZN|NAG|
         ZERRO := "AC"
      CASE cPLACA3 >= "MUA" .AND. cPLACA3 <= "MVK"   // AL|MUA|MVK|
         ZERRO := "AL"
      CASE cPLACA3 >= "JWF" .AND. cPLACA3 <= "JXY"   // AM|JWF|JXY|
         ZERRO := "AM"
      CASE cPLACA3 >= "NEI" .AND. cPLACA3 <= "NFB"   // AP|NEI|NFB|
         ZERRO := "AP"
      CASE cPLACA3 >= "JKS" .AND. cPLACA3 <= "JSZ"   // BA|JKS|JSZ|
         ZERRO := "BA"
      CASE cPLACA3 >= "HTX" .AND. cPLACA3 <= "HZA"   // CE|HTX|HZA|
         ZERRO := "CE"
      CASE cPLACA3 >= "JDP" .AND. cPLACA3 <= "JKR"   // DF|JDP|JKR|
         ZERRO := "DF"
      CASE cPLACA3 >= "MOX" .AND. cPLACA3 <= "MTZ"   // ES|MOX|MTZ|
         ZERRO := "ES"
      CASE cPLACA3 >= "KAV" .AND. cPLACA3 <= "KFC"   // GO|KAV|KFC|
         ZERRO := "GO"
      CASE cPLACA3 >= "HOL" .AND. cPLACA3 <= "HQE"   // MA|HOL|HQE|
         ZERRO := "MA"
      CASE cPLACA3 >= "GKJ" .AND. cPLACA3 <= "HOK"   // MG|GKJ|HOK|
         ZERRO := "MG"
      CASE cPLACA3 >= "HQF" .AND. cPLACA3 <= "HTW"   // MS|HQF|HTW|
         ZERRO := "MS"
      CASE cPLACA3 >= "JXZ" .AND. cPLACA3 <= "KAU"   // MT|JXZ|KAU|
         ZERRO := "MT"
      CASE cPLACA3 >= "JTA" .AND. cPLACA3 <= "JWE"   // PA|JTA|JWE|
         ZERRO := "PA"
      CASE cPLACA3 >= "MMN" .AND. cPLACA3 <= "MOW"   // PB|MMN|MOW|
         ZERRO := "PB"
      CASE cPLACA3 >= "KFD" .AND. cPLACA3 <= "KME"   // PE|KFD|KME|
         ZERRO := "PE"
      CASE cPLACA3 >= "LVF" .AND. cPLACA3 <= "LWQ"   // PI|LVF|LWQ|
         ZERRO := "PI"
      CASE cPLACA3 >= "AAA" .AND. cPLACA3 <= "BEZ"   // PR|AAA|BEZ|
         ZERRO := "PR"
      CASE cPLACA3 >= "KMF" .AND. cPLACA3 <= "LVE"   // RJ|KMF|LVE|
         ZERRO := "RJ"
      CASE cPLACA3 >= "MXH" .AND. cPLACA3 <= "MZM"   // RN|MXH|MZM|
         ZERRO := "RN"
      CASE cPLACA3 >= "NBB" .AND. cPLACA3 <= "NEH"   // RO|NBB|NEH|
         ZERRO := "RO"
      CASE cPLACA3 >= "NAH" .AND. cPLACA3 <= "NBA"   // RR|NAH|NBA|
         ZERRO := "RR"
      CASE cPLACA3 >= "IAQ" .AND. cPLACA3 <= "JDO"   // RS|IAQ|JDO|
         ZERRO := "RS"
      CASE cPLACA3 >= "LVW" .AND. cPLACA3 <= "MMM"   // SC|LWR|MMM|
         ZERRO := "SC"
      CASE cPLACA3 >= "HZB" .AND. cPLACA3 <= "IAP"   // SE|HZB|IAP|
         ZERRO := "SE"
      CASE cPLACA3 >= "BFA" .AND. cPLACA3 <= "GKI"   // SP|BFA|GKI|
         ZERRO := "SP"
      CASE cPLACA3 >= "MVL" .AND. cPLACA3 <= "MXG"   // TO|MVL|MXG|
         ZERRO := "TO"
      ENDCASE
   ENDIF
/*
UF|De|Ate|
AC|MZN|NAG|
AL|MUA|MVK|
AM|JWF|JXY|
AP|NEI|NFB|
BA|JKS|JSZ|
CE|HTX|HZA|
DF|JDP|JKR|
ES|MOX|MTZ|
GO|KAV|KFC|
MA|HOL|HQE|
MG|GKJ|HOK|
MS|HQF|HTW|
MT|JXZ|KAU|
PA|JTA|JWE|
PB|MMN|MOW|
PE|KFD|KME|
PI|LVF|LWQ|
PR|AAA|BEZ|
RJ|KMF|LVE|
RN|MXH|MZM|
RO|NBB|NEH|
RR|NAH|NBA|
RS|IAQ|JDO|
SC|LWR|MMM|
SE|HZB|IAP|
SP|BFA|GKI|
TO|MVL|MXG|
*/

   RETURN lRetorno


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function validacnh()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION validacnh( eVALOR )

   IF ValType( eVALOR ) <> "C"
      eVALOR := AllTrim( Str( eVALOR ) )
   ENDIF
   IF !ValidCnhAntiga( StrZero( Val( eVALOR ), 9 ) ) .AND. !ValidCnhAtual( StrZero( Val( eVALOR ), 11 ) ) .AND. !ValidCnhImpresso( eVALOR )
      RETURN .F.
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CheckCNHCat()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CheckCNHCat( cCNHCAT )

/*
CATEGORIA TIPOS DE VEÍCULOS EXEMPLOS
ACC Ciclomotores de duas até três rodas, com velocidade máxima até 50km/h.  Bicicleta motorizada e cinquentinha.
A Condutor de veículo motorizado de duas ou três rodas. Motos, motoneta e triciclo.
B Veículos de carga leve até 3.500kg ou oito lugares para passageiros. Carro, picape, van e SUV.
C Veículos entre 3.500kg e 6.000kg de peso total. Caminhão, caminhonete e van de carga.
D Veículos com mais de oito lugares para passageiros. Ônibus, micro-ônibus e van de passageiros.
E Todos os veículos das outras categorias, combinações de veículos, tratores e veículos com mais de 6.000kg. Automóvel tracionando, trailer, caminhão tracionando, duas carretas (treminhão) e ônibus articulado.
*/

   LOCAL aCAT := { 'A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE', 'ACC' }

   znerro  := 0
   zerro   := ''
   cCNHCAT := AllTrim( cCNHCAT )
   IF !Empty( cCNHCAT )
      IF AScan( aCAT, cCNHCAT ) = 0
         znerro := 1
         zerro  := 'Categoria Habilitacao invalida: ' + cCNHCAT
         RETURN .F.
      ENDIF
   ENDIF

   RETURN .T.

// + EOF: valida_placa.prg
// +
