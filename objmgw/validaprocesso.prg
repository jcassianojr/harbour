//10090848820158260161
//NNNNNNNDDAAAAJTROOOO
//12345678901234567890
//100908420158260161

/*
setmode(25,80)
cls
nGRV:=FCREATE("erro.txt")
use benefic
dbgotop()
while ! eof()
   if ! validaprocesso(alltrim(processo))
      FWRITE(nGRV,EMPRESA+' '+STR(NUMERO,8)+' '+ALLTRIM(NOMEBEN)+' '+ALLTRIM(PROCESSO)+HB_OSNEWLINE())
   endif
   dbskip()
enddo
dbcloseall()
fclose(nGRV)
*/


//validaprocesso('10090848820158260161') 
//validaprocesso2('10090848820158260161') 
 
// Sendo o número do processo: N6 N5 N4 N3 N2 N1 N0 A3 A2 A1 A0 J2 T1 R0 O3 O2 O1 O0 01 00 
//    R1 = (N6 N5 N4 N3 N2 N1 N0 mod 97) 
//    R2 = ((R1 concatenado com A3 A2 A1 A0 J2 T1 R0) mod 97) 
//    R3 = ((R2 concatenado com O3 O2 O1 O0 01 00) mod 97) 
//    D1 D0 = 98 - (R3 mod 97) 



//Function valida_mod97(NNNNNNN,DD,AAAA,JTR,OOOO) As Boolean 
//   valor1 = preencheZeros(NNNNNNN, 7) 
//   resto1 = valor1 Mod 97 
//   valor2 = preencheZeros(resto1, 2) & preencheZeros(AAAA, 4) & preencheZeros(JTR, 3) 
//   resto2 = valor2 Mod 97 
//   valor3 = preencheZeros(resto2, 2) & preencheZeros(OOOO, 4) & preencheZeros(DD, 2) 
//   valida_mod97 = ((valor3 Mod 97) = 1) 
//End Function 

function formataprocesso(cPROCESSO)
IF validaprocesso(cPROCESSO)
   //1009084-88.2015.8.26.0161
   //1234567-89-0123.4.56.7890
   //           1            2
   //"@R 9999999-99.9999.9.99.9999"   
   return transform(alltrim(tiraout(cPROCESSO)),"@R 9999999-99.9999.9.99.9999")   
else
  return cPROCESSO
endif

function validaprocesso(cPROCESSO)
cPROCESSO:=TIRAOUT(cPROCESSO)
IF EMPTY(cPROCESSO)
   RETURN .F.
ENDIF
cNUMERO:=SUBSTR(cPROCESSO,1,7)
cDD    :=SUBSTR(cPROCESSO,8,2)
cANO   :=SUBSTR(cPROCESSO,10,4)
cJTR   :=SUBSTR(cPROCESSO,14,3)
cFINAL :=SUBSTR(cPROCESSO,17,4)
resto1 := int(mod(val(cNUMERO),97))
valor2 :=strzero(resto1,2)+cANO+cJTR
resto2 := int(mod(val(valor2),97))
valor3 := strzero(resto2,2)+cFINAL+cDD
resto3 := int(mod(val(valor3),97))
return resto3=1

/*
Function validaprocesso2(cPROCESSO)
cNUMERO:=SUBSTR(cPROCESSO,1,7)
cANO   :=SUBSTR(cPROCESSO,10,4)
cJTR   :=SUBSTR(cPROCESSO,14,3)
cFINAL :=SUBSTR(cPROCESSO,17,4)
   valor1 = val(cNUMERO)
   resto1 = mod(valor1,97 )
   valor2 = VAL( strzero(resto1, 2) + cANO + cJTR)
   resto2 = MOD(valor2,97)
    valor3 = VAL(strzero(resto2, 2) + cFINAL +  "00" )   
    calcula_mod97 = STRZERO(98 - MOD(valor3,97), 2) 
return calcula_mod97
*/