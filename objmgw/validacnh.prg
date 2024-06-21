#INCLUDE "INKEY.CH"

*+ validaPlaca(cPlaca)
** ValidaRenavam( cRenavam,lmes )
** validacnh(eVALOR)
**   ValidaCnhAntiga( cPgu )
**   ValidaCnhImpresso( cNumero )
**   ValidaCnhAtual( cCnh )
** CheckCNHCat(cCNHCAT)

FUNCTION ValidaRenavam( cRenavam,lmes )
LOCAL nSoma, nCont, nDigito, lOk
    
IF ValType(lMES)#"L"
   lMES:=.T.
ENDIF
ZNERRO:=0
ZERRO:=""

IF Empty(cRenavam)
   ZNERRO:=1
   zerro:="Codigo em branco"
   IF Lmes
   	  ALERTX(zerro)
   ENDIF
   RETURN .F.
ENDIF

cRenavam := sonumero( cRenavam )
cRenavam := StrZero( Val( cRenavam ), 11 )
nSoma := 0
FOR nCont = 1 TO 10
    nSoma += ( Val( SubStr( cRenavam, nCont, 1 ) ) * Val( SubStr( "8923456789", nCont, 1 ) ) )
NEXT
nDigito := Mod( nSoma, 11 )
nDigito := iif( nDigito == 10, 0, nDigito )
lOk     := ( nDigito == Val( Right( cRenavam, 1 ) ) )
IF ! lOK
   ZNERRO:=3
   zerro:="Digito renavam invalido"
   IF Lmes
  	  ALERTX(zerro)
   ENDIF
ENDIF
RETURN lOk
  

*+????????????????????????????????????????????????????????????????????
*+
*+    Function Validaplaca()
*+
*+????????????????????????????????????????????????????????????????????
*+
function validaPlaca(cPlaca)
LOCAL lRetorno := .T., nI,cPLACA3
ZNERRO:=0
ZERRO:=""

cPLACA:=ALLTRIM(STRVAL(cPLACA))
cPLACA:=TIRAOUT(cPLACA)
cPLACA:=UPPER(cPLACA)

// Regex regex = new Regex(@"^[a-zA-Z]{3}\-\d{4}$");
IF LEN(cPlaca) = 7 // ABC1234
  FOR nI = 1 TO LEN(cPlaca)
	 IF nI <= 3 // tem que ser letra
		IF ! SUBStr ( cPlaca, nI, 1 ) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
		   lRetorno := .F.
		   ZNERRO:=1
		   ZERRO:="digito "+strzero(ni,1)+" nao e letra"
		   EXIT
		ENDIF
	 ELSE        // tem que ser numero
		IF ! SUBStr ( cPlaca, nI, 1 ) $ '0123456789'
		   lRetorno := .F.
		   ZNERRO:=2
		   ZERRO:="digito "+strzero(ni,1)+" nao e numero"
		   EXIT
		ENDIF
	 ENDIF
  NEXT
ELSE
  lRetorno := .F.
ENDIF
   
IF cPLACA="XXX9999" .OR. cPLACA="XXX999"  .OR. cPLACA="XX9999"  .OR. cPLACA="XXXX999"  
   LRetorno := .F. //placas genericas
    ZNERRO:=3
    ZERRO:="placa generica"+cPLACA   
ENDIF   

IF lRETORNO
   cPLACA3:=SUBSTR(cPLACA,1,3)
   DO CASE
      CASE cPLACA3>="MZN" .AND. cPLACA3<="NAG" //AC|MZN|NAG|
	       ZERRO:="AC"
      CASE cPLACA3>="MUA" .AND. cPLACA3<="MVK" // AL|MUA|MVK|
	       ZERRO:="AL"
      CASE cPLACA3>="JWF" .AND. cPLACA3<="JXY" //AM|JWF|JXY|
	       ZERRO:="AM"
      CASE cPLACA3>="NEI" .AND. cPLACA3<="NFB" //AP|NEI|NFB|
	       ZERRO:="AP"
      CASE cPLACA3>="JKS" .AND. cPLACA3<="JSZ" //BA|JKS|JSZ|
	       ZERRO:="BA"
      CASE cPLACA3>="HTX" .AND. cPLACA3<="HZA" //CE|HTX|HZA|
	       ZERRO:="CE"
      CASE cPLACA3>="JDP" .AND. cPLACA3<="JKR" //DF|JDP|JKR|
	       ZERRO:="DF"
      CASE cPLACA3>="MOX" .AND. cPLACA3<="MTZ" //ES|MOX|MTZ|
	       ZERRO:="ES"
      CASE cPLACA3>="KAV" .AND. cPLACA3<="KFC" //GO|KAV|KFC|
	       ZERRO:="GO"
      CASE cPLACA3>="HOL" .AND. cPLACA3<="HQE" //MA|HOL|HQE|
	       ZERRO:="MA"
      CASE cPLACA3>="GKJ" .AND. cPLACA3<="HOK" //MG|GKJ|HOK|
	       ZERRO:="MG"
      CASE cPLACA3>="HQF" .AND. cPLACA3<="HTW" //MS|HQF|HTW|
	       ZERRO:="MS"
      CASE cPLACA3>="JXZ" .AND. cPLACA3<="KAU" //MT|JXZ|KAU|
	       ZERRO:="MT"
      CASE cPLACA3>="JTA" .AND. cPLACA3<="JWE" //PA|JTA|JWE|
	       ZERRO:="PA"
      CASE cPLACA3>="MMN" .AND. cPLACA3<="MOW" //PB|MMN|MOW|
	       ZERRO:="PB"
      CASE cPLACA3>="KFD" .AND. cPLACA3<="KME" //PE|KFD|KME|
	       ZERRO:="PE"
      CASE cPLACA3>="LVF" .AND. cPLACA3<="LWQ" //PI|LVF|LWQ|
	       ZERRO:="PI"
      CASE cPLACA3>="AAA" .AND. cPLACA3<="BEZ" //PR|AAA|BEZ|
	       ZERRO:="PR"
      CASE cPLACA3>="KMF" .AND. cPLACA3<="LVE" //RJ|KMF|LVE|
	       ZERRO:="RJ"
      CASE cPLACA3>="MXH" .AND. cPLACA3<="MZM" //RN|MXH|MZM|
	       ZERRO:="RN"
      CASE cPLACA3>="NBB" .AND. cPLACA3<="NEH" //RO|NBB|NEH|
	       ZERRO:="RO"
      CASE cPLACA3>="NAH" .AND. cPLACA3<="NBA" //RR|NAH|NBA|
	       ZERRO:="RR"
      CASE cPLACA3>="IAQ" .AND. cPLACA3<="JDO" //RS|IAQ|JDO|
	       ZERRO:="RS"
      CASE cPLACA3>="LVW" .AND. cPLACA3<="MMM" //SC|LWR|MMM|
	       ZERRO:="SC"
      CASE cPLACA3>="HZB" .AND. cPLACA3<="IAP" //SE|HZB|IAP| 
	       ZERRO:="SE"
      CASE cPLACA3>="BFA" .AND. cPLACA3<="GKI" //SP|BFA|GKI|
	       ZERRO:="SP"		   
      CASE cPLACA3>="MVL" .AND. cPLACA3<="MXG" //TO|MVL|MXG|
	       ZERRO:="TO"		   		   
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

function validacnh(eVALOR)
IF VALTYPE(eVALOR)<>"C"
   eVALOR:=AllTrim(STR(eVALOR))
endif
IF ! ValidaCnhAntiga( strzero(val(eVALOR),9) ) .and. !  ValidaCnhAtual( strzero(val(eVALOR),11) ) .and. !  ValidaCnhImpresso(eVALOR)
   RETURN .F.
endif
RETURN .T.


FUNCTION ValidaCnhAntiga( cPgu )
   LOCAL Result, PGU_Forn, Dig_Forn, Soma, Mult, J, Digito, Dig_Enc
   Result := .F.
   IF Len( AllTrim( cPgu ) ) != 9
      RETURN Result
   ENDIF
   PGU_Forn := Substr( cPgu, 1, 8 )
   Dig_Forn := Substr( cPgu, 9, 1 )
   Soma := 0
   Mult := 2
   FOR j := 1 to 8
       Soma := Soma + ( Val( Substr( PGU_Forn, j, 1 ) ) * Mult )
       Mult := Mult + 1
   NEXT
   Digito := Int( Mod( Soma, 11 ) )
   IF Digito > 9
      Digito := 0
   ENDIF
   Dig_Enc := AllTrim( Str( Digito ) )
   IF Dig_Forn = Dig_enc
      Result := .T.
   ENDIF
   IF Dig_Forn <> Dig_enc
      Result := .F.
   ENDIF
RETURN Result

FUNCTION ValidaCnhAtual( cCnh )
   LOCAL Result, Cnh_Forn, Dig_Forn, Incr_Dig2, Soma, Mult, J, Digito1, Digito2, Dig_Enc
   Result := .F.
   IF ! ( len( allTrim( cCnh ) ) ) = 11
      RETURN Result
   ENDIF
   CNH_Forn := Substr( cCnh, 1, 9 )
   Dig_Forn := Substr( cCnh, 10, 2 )
   Incr_Dig2 := 0
   Soma := 0
   Mult := 9
   FOR j := 1 to 9
       Soma := Soma + ( val( substr( CNH_Forn, j, 1 ) ) * Mult )
       Mult := Mult - 1
   NEXT
   Digito1 := int( mod( Soma, 11 ) )
   IF Digito1 = 10
      Incr_Dig2 := -2
   ENDIF
   IF Digito1 > 9
      Digito1 := 0
   ENDIF
   Soma := 0
   Mult := 1
   FOR j := 1 to 9
       Soma := Soma + ( val( substr( CNH_Forn, j, 1 ) ) * Mult)
       Mult := Mult + 1
   NEXT
   IF int( mod( Soma, 11 ) ) + Incr_Dig2 < 0
      Digito2 := 11 + Int( Mod( Soma, 11 ) ) + Incr_Dig2
   ELSE
      Digito2 := Int( Mod( Soma, 11 ) ) + Incr_Dig2
   ENDIF
   IF Digito2 > 9
      Digito2 := 0
   ENDIF
   Dig_Enc := allTrim( str( Digito1 ) ) + AllTrim( Str( Digito2 ) )
   IF Dig_Forn = Dig_enc
      Result := .T.
   ENDIF
   IF ! ( Dig_Forn = Dig_enc )
      Result := .F.
   ENDIF
RETURN Result

FUNCTION ValidaCnhImpresso( cNumero )
   LOCAL lOk := .F., nDigito
   cNumero = sonumero( cNumero )  
   IF Len( cNumero ) <> 0
      nDigito := 11 - Mod( Val( Substr( cNumero, 1, Len( cNumero ) - 1 ) ), 11 )
      nDigito := iif( nDigito > 9, 0, nDigito )
      lOk := ( nDigito == Val( Substr( cNumero, Len( cNumero ), 1 ) ) )
   ENDIF
RETURN lOk


function CheckCNHCat(cCNHCAT)
/*
CATEGORIA	TIPOS DE VEÍCULOS	EXEMPLOS
ACC	Ciclomotores de duas até três rodas, com velocidade máxima até 50km/h. 	Bicicleta motorizada e cinquentinha.
A	Condutor de veículo motorizado de duas ou três rodas.	Motos, motoneta e triciclo.
B	Veículos de carga leve até 3.500kg ou oito lugares para passageiros.	Carro, picape, van e SUV.
C	Veículos entre 3.500kg e 6.000kg de peso total.	Caminhão, caminhonete e van de carga.
D	Veículos com mais de oito lugares para passageiros.	Ônibus, micro-ônibus e van de passageiros.
E	Todos os veículos das outras categorias, combinações de veículos, tratores e veículos com mais de 6.000kg.	Automóvel tracionando, trailer, caminhão tracionando, duas carretas (treminhão) e ônibus articulado.
*/
LOCAL aCAT:={'A','B','C','D','E','AB','AC','AD','AE','ACC'}
znerro:=0
zerro :=''
cCNHCAT:=ALLTRIM(cCNHCAT)
IF ! EMPTY(cCNHCAT)
   if  ascan(aCAT,cCNHCAT)=0
	   znerro :=1
	   zerro  :='Categoria Habilitacao invalida: ' +cCNHCAT      
       return .f.
   endif
endif
RETURN .T.
   
   
