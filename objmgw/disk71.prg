*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Module => DISK71.PRG
*+
*+     FormataRG(Valor,cTIPO)
*+     CheckRG(Valor, lMES,cTIPO,dDATANASC,cUF )
*+     PEGDDD(cTEL)
*+     PEGTEL(cTEL)
*+     PEGPREF(cTEL,lCEL)
*+     formataTel(cNUMERO)
*+     ForTel2(cNUMERO)
*+     chkufcep(cCEP,cUF,lMES)
*+     cep2uf(cepuso)
*+     Formatacep(eCEP)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function formataRG(cRG,cTIPO)
*+    cTIPO RH RNI RNE CNI CPF
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

Function FormataRG(Valor,cTIPO)
local cRETU
local nPOS
local cDAC
cDAC = ""
nPOS = 0
cRETU = ""
//So formata se o valor for caracter
IF VALTYPE(Valor) <> "C" 
   return VALOR
ENDIF

IF VALTYPE(cTIPO)="C"
   //RNE E RIC sem formatacao
   IF cTIPO="RNE" .OR.  cTIPO="RIC"  
      return VALOR
   ENDIF
   //CPF E CNI formatacao CPF
  IF cTIPO="CPF" .OR.  cTIPO="CNI"  
      return formatacpf(valor)  
   ENDIF   
ENDIF

//Tipo escrito no valor
//ISENT RNE RIC sem formatacao
If At("ISENT",upper(valor)) >0  .OR. At("RNE",upper(valor)) >0 .OR. At("RIC",upper(valor)) >0  //registro nacional estrangeiro isentos(incricao estadual no campo)
   return VALOR
EndIf

//CPF E CNI formatacao CPF
IF At("CPF",upper(valor))>0  .OR. At("CNI",upper(valor))>0 
   return formatacpf(valor)         
ENDIF

//sem valor nao formata
IF VAL(tiraout(valor))=0
   return valor
ENDIf

//sem tipo mas se validar CPF formata como CPF
IF VALCPF(VALOR,.F.) 
   return formatacpf(valor)        
ENDIF
//gerando o DAC verificador as vezes e prenchido o Rg SEM o dac
valor := alltrim(valor)
valor := upper(valor)
nPOS = at( "-",Valor)
If nPOS = 0
   valor := tiraout(Valor)
   valor := alltrim(valor)
   IF LEN(VALOR)=9 
      cDAC=substr(VALOR,9,1)
   	valor:=SubStr(valor,1,8)     
   ENDIF
Else
   cDAC = substr(Valor, nPOS + 1, 1)
   Valor = substr(Valor, 1, nPOS - 1)
   If cDAC = "x"
     cDAC = "X"
   endif
   If cDAC <> "X" //'evita erros como -- -. -/ caracter inves de numero no dac
      cDAC = str(val(cDAC),1)
   End If
End If
valor := StrTran(valor,"x","")  //x-X
valor := StrTran(valor,"X","")  //X-X
valor := tiraout(Valor)
valor := alltrim(valor)
//formata conforme a quantidade de digitos sem o dac
DO CASE           
   CASE LEN(VALOR)=8
        Valor := alltrim(str(val(SUBSTR(Valor,1,8)),8))
        cRETU := Trim(substr(Valor, 1, 2) + "." + substr(Valor, 3, 3) + "." + substr(Valor, 6))
   CASE LEN(VALOR)=7
        Valor := alltrim(str(val(SUBSTR(Valor,1,8)),7))
        cRETU := Trim(substr(Valor, 1, 1) + "." + substr(Valor, 2, 3) + "." + substr(Valor, 5))
   otherwise
        cRETU := VALOR
ENDCASE
//inclui o DAC
If ! EMPTY(cDAC)
   cRETU = cRETU + "-" + cDAC
End If
If Left(cRETU , 1) = "0"
   cRETU = substr(cRETU , 2)
End If
If Left(cRETU , 1) = "."
   cRETU = substr(cRETU , 2)
End If
return cRETU

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CheckRG(Valor, lMES,cTIPO,dDATANASC,cUF  )
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

FUNCTION CheckRG(Valor, lMES,cTIPO,dDATANASC,cUF )
LOCAL d
LOCAL soma
LOCAL nPOS
LOCAL cDAC
local x
local p1
LOCAL aPESOS
if lastkey() = K_UP .or. lastkey() = K_DOWN
   return .T.         //Mandou Prosseguir
endif

IF ValType(lMES)#"L"
   lmes:=.T.
ENDIF
ZDAC:=" "
ZNERRO:=0
ZERRO:=""
IF VALTYPE(cTIPO)="C"  .AND. At("ISENT",valor) >0 
   return .t.
ENDIF 
IF Len(Valor) = 0
   znerro:=7
   zerro:="RG/RNE/RIC/CPF/CNI em branco"
ENDIF
IF (VALTYPE(cTIPO)="C" .AND. cTIPO="RNE" ).OR. At("RNE",valor) >0 
   return .t.
ENDIF 
IF At("CPF",valor) >0
   cTIPO:="CPF"
   valor:=strtran(valor,'CPF','')
ENDIF
//Valida do CPF
IF Valcpf( VALOR ,.F.)
   IF VALTYPE(cTIPO)<>"C" .OR. (VALTYPE(cTIPO)="C" .AND. (cTIPO<>"CPF" .OR. cTIPO<>"CNI" ))
      IF LMES
         ALERTX("Preencha o tipo como CPF ou CNI")
      ENDIF 
      return .t. 	  
   ENDIF
ENDIF  
IF At("RIC",valor) >0
   cTIPO:="RIC"
   valor:=strtran(valor,'RIC','')
ENDIF
Valor:= StrTran(Valor,".","")  //tiraout tambem tira o traco(-)usado no DAC nao pode ser usada aqui

//IF LEN(valor)=11 AS Vezes o RG e digitado errado com 11 digitos somente 11 digitos nao garante que e RIC //Agora valida cpf que tambem e 11
//   cTIPO:="RIC" 
//ENDIF
IF VALTYPE(cTIPO)<>'C'
   cTIPO:="RG"
ENDIF

for X := 0 to 9
   P1:=TIRAOUT(valor)
   if p1 = repl( str( X, 1 ), 11 )
      znerro:=6
      zerro:="RG Invalido - Sequencia Repetitiva de " + str( X, 1 )
   endif
next X
nPOS := At("-",Valor)
IF nPOS = 0
   cDAC:=" "
ELSE
   cDAC := SubStr(Valor, nPOS + 1, 1)
   Valor := SubStr(Valor, 1, nPOS - 1)
END IF
Valor := Str(Val(Valor))
IF Len(AllTrim(Valor)) <= 7 .AND. cTIPO='RG' .AND. (Empty(CUF) .OR. cUF="SP")
   IF ValType(dDATANASC)<>"D" .OR. dDATANASC>CToD('31/12/1990')
	   zerro:="RG com Menos de 7 Digitos"
	   znerro:=3 
	 ENDIF
END IF
IF Len(AllTrim(Valor)) >9  .AND. (cTIPO='RG' .OR. EMPTY(cTIPO)) .AND. (Empty(CUF) .OR. cUF="SP")
   zerro:="RG com Mais de 9 Digitos"
   znerro:=8
END IF 

IF cTIPO='RIC'
   IF Len(AllTrim(Valor)) <>11 
      zerro:="RIC nao tem 11 Digitos"
      znerro:=9
   ELSE
     aPESOS:={8,9,2,3,4,5,6,7,8,9}
     soma:=0
     FOR X=1 TO 10    
        soma+=VAL(SUBSTR(valor,X,1))*aPESOS[X]
     NEXT X
     d := MOD(soma,11)
     IF d=10
        d:=0
     ENDIF
     If d <> VAL(SUBSTR(valor,11,1))
        zDAC:=StrZero(D,1,0)      
        zerro:="Digito de Controle RIC "+SUBSTR(valor,11,1)+" Nao Confere sugerido: " +zDAC
        znerro:=10       
     ENDIF
   ENDIF     
END IF 
IF ZNERRO=0  .AND. cTIPO='RG' .AND. LEN(VALOR)=8
   Valor := StrZero(Val(Valor), 8)  
   SOMA := Val(SubStr(Valor, 1, 1)) * 9
   SOMA += Val(SubStr(Valor, 2, 1)) * 8
   SOMA += Val(SubStr(Valor, 3, 1)) * 7
   SOMA += Val(SubStr(Valor, 4, 1)) * 6
   SOMA += Val(SubStr(Valor, 5, 1)) * 5
   SOMA += Val(SubStr(Valor, 6, 1)) * 4
   SOMA += Val(SubStr(Valor, 7, 1)) * 3
   SOMA += Val(SubStr(Valor, 8, 1)) * 2  
   d := soma - (Floor( soma / 11 ) * 11)
   IF cDAC = "X" .Or. cDAC = "x" .OR. cDAC=" "
      IF D=10
     	  RETURN .T.
      ELSE
         zDAC:=StrZero(D,1,0)  	  
    	   znerro:=5
         zerro:="Digito de Controle RG "+cDAC+" Nao Confere sugerido: " +zDAC
      ENDIF
  ELSE
    IF d = Val(cDAC) .Or. d = 0
    ELSE
       IF d=10
       	  zDAC:="X"
          zerro:="Digito de Controle RG Nao Confere sugerido: X"
       ELSE
     	    zDAC:=StrZero(D,1,0)
          zerro:="Digito de Controle RG Nao Confere sugerido: " +zDAC
       ENDIF
       znerro:=4
    END IF
  ENDIF
ENDIF  
if ZNERRO>0   
   IF lMES      
      ALERTX(zerro)      
   endif
   return .f.   
endif
return .t.



*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PEGDDD(cTEL)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

FUNCTION PEGDDD(cTEL)
LOCAL cPEGDDD
cTEL := formataTel(cTEL)
cPEGDDD := ""
IF At("(",cTEl ) > 0
   cPEGDDD := SubStr(cTEL, 2, 2)
ENDIF
RETURN cPEGDDD

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PEGTEL(cTEL)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

FUNCTION PEGTEL(cTEL)
LOCAL cPEGTEL
cTEL := formataTel(cTEL)
cPEGTEL := cTEL
IF At("(",cTEl ) > 0
   cPEGTEL := SubStr(cTEL, 5)
ENDIF
RETURN cPEGTEL

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PEGPREF(cTEL)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION PEGPREF(cTEL,lCEL)
LOCAL cPEGREF
IF VALTYPE(lCEL)<>"L"
   lCEL:=.T.
ENDIF
//cTEL = tem que ser so o numero telefone sem o ddd antes de chamar usar pegtel se necessario
cPEGREF := ""
IF At("-",cTEL) > 0
   cPEGREF := SubStr(cTEL, 1, At("-",cTEL) - 1)
   IF lCEL
      IF Len(cPEGREF)=5.AND.Left(cPEGREF,1)="9" //Celular com 9
          cPEGREF:=SubStr(cPEGREF,2)
      ENDIF
   ENDIF   
END IF
RETU cPEGREF



*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function formataTel(cNUMERO)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
Function formataTel(cNUMERO)
/*
 99-12435678	->(99)1234-5678
 99,12345678	->(99)1234-5678
 99-12345678	->(99)1234-5678
 (099)12345678	->(99)1234-5678
 99 12345678	->(99)1234-5678
 099 12345678	->(99)1234-5678
 (99)12345678	->(99)1234-5678
 (99)1234567	->(99)123-4567
 12345678901    ->(99)91234-5678  //celular  11 digitos
 1234567890     ->(99)1234-5678   //telefone 10 digitos
 123456789      ->91234-5678      //celular sem ddd   9 digitos
 12345678       ->1234-5678       //telefone sem ddd  8 digitos
 1234567        ->123-4567        //telefone antigos  7 digitos  999-9999  
*/
cNUMERO:=AllTrim(cNUMERO)
cNUMERO:=StrTran(cNUMERO," ","")

IF SubStr(cNUMERO, 1, 4) = "0300" .Or. SubStr(cNUMERO, 1, 4) = "0800" .Or. SubStr(cNUMERO, 1, 4) = "0900" ;
   SubStr(cNUMERO, 1, 4) = "0500" ;
   .OR. SubStr(cNUMERO,1,2)="55".OR. SubStr(cNUMERO,1,1)="+"
   //Internacional e atendimentos
   RETURN cNUMERO
ENDIF
If SUBSTR(cNUMERO, 1, 1) = "(" .And. SUBSTR(cNUMERO, 4, 1) = ")"  //(99)12345678
   cNUMERO := SUBSTR(cNUMERO, 1, 4) + fortel2(SUBSTR(cNUMERO, 5))
End If
If SUBSTR(cNUMERO, 3, 1) = "-"  //99-12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 1, 2) + ")" + fortel2(SUBSTR(cNUMERO, 4))
End If
If SUBSTR(cNUMERO, 3, 1) = ","  //99,12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 1, 2) + ")" + fortel2(SUBSTR(cNUMERO, 4))
End If
If SUBSTR(cNUMERO, 3, 1) = " "  //99 12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 1, 2) + ")" + fortel2(SUBSTR(cNUMERO, 4))
End If
If SUBSTR(cNUMERO, 4, 1) = "-" .And. SUBSTR(cNUMERO, 1, 1) = "0"  //099-12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 2, 2) + ")" + fortel2(SUBSTR(cNUMERO, 5))
End If
If SUBSTR(cNUMERO, 4, 1) = " " .And. SUBSTR(cNUMERO, 1, 1) = "0"  //099 12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 2, 2) + ")" + fortel2(SUBSTR(cNUMERO, 5))
End If
If SUBSTR(cNUMERO, 4, 1) = "-" .And. SUBSTR(cNUMERO, 1, 1) = "0"  //99-12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 2, 2) + ")" + fortel2(SUBSTR(cNUMERO, 5))
End If
If SUBSTR(cNUMERO, 1, 1) = "(" .And. SUBSTR(cNUMERO, 2, 1) = "0" .And. SUBSTR(cNUMERO, 5, 1) = ")" //(099)12345678
   cNUMERO := "(" + SUBSTR(cNUMERO, 3, 2) + ")" + fortel2(SUBSTR(cNUMERO, 6))
End If
if at("(",cNUMERO)=0 .AND. at("-",cNUMERO)=0       //somente numeros   
   do case
      case len(cNUMERO)=10
		  cNUMERO:="("+LEFT(cNUMERO,2)+")"+SUBSTR(cNUMERO,3,4)+"-"+Substr(cNUMERO,7)   
	  CASE LEn(cNUMERO)=11
			cNUMERO:="("+LEFT(cNUMERO,2)+")"+SUBSTR(cNUMERO,3,5)+"-"+Substr(cNUMERO,8)   
      CASE len(cNUMERO)=9 .OR.  len(cNUMERO)=8 .OR. len(cNUMERO)=7
          cNUMERO:=ForTel2(cNUMERO)     
   endCASE
endif          
retu cNUMERO

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function fortel2(cNUMERO)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
Function ForTel2(cNUMERO)
cNUMERO = alltrim(tiraout(cNUMERO)) //nao checa mais o traco pois tem tiraout
If Len(cNUMERO) = 9 // .And. SUBSTR(cNUMERO, 6, 1)='-'    //912345678 91234-5678 Novo celular 9 
  cNUMERO = SUBSTR(cNUMERO, 1, 5) + "-" + SUBSTR(cNUMERO, 6)
End If
If Len(cNUMERO) = 8 // .And. SUBSTR(cNUMERO, 5, 1)='-'    //12345678 1234-5678
  cNUMERO = SUBSTR(cNUMERO, 1, 4) + "-" + SUBSTR(cNUMERO, 5)
End If
If Len(cNUMERO) = 7               //123-4567 1234567 //Algums localidades antigas 7 digitos
   cNUMERO = SUBSTR(cNUMERO, 1, 3) + "-" + SUBSTR(cNUMERO, 4)
End If
retu cNUMERO

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function formatacep(eCEP)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION FormataCEP(eCEP)
IF VALTYPE(eCEP)="N"
   eCEP:=STRZERO(eCEP,8)
ENDIF
eCEP=ALLTRIM(eCEP)
IF AT("-",eCEP)=0 .AND. LEN(eCEP)=8
   eCEP:=LEFT(eCEP,5)+"-"+RIGHT(eCEP,3)
ENDIF
RETURN eCEP



*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function chkufcep(cCEP,cUF)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function chkufcep(cCEP,cUF,lMES)
if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.         //Mandou Proceguir
endif
IF VALTYPE(lMES)<>"L"
   lMES:=.T.
ENDIF
IF cep2uf(cCEP)<>cUF
   IF lMES
      ALERTX("CEP:"+cCEP+" nao e da UF:"+cUF)
   ENDIF   
   retu .f.
ENDIF
retu .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function cep2uf(cepuso)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function cep2uf(cepuso)
LOCAL cep2uf
cepuso:=tiraout(cepuso)
cepuso=val(cepuso)
cep2uf="EX"
do case
    case cepuso>=01000000.AND.cepuso<=19999999
         cep2uf:="SP"
    CASE cepuso>=20000000.AND.cepuso<=28999999
         cep2uf:="RJ"
    CASE cepuso>=29000000.AND.cepuso<=29999999
         cep2uf:="ES"
    CASE cepuso>=30000000.AND.cepuso<=39999999
         cep2uf:="MG"
    CASE cepuso>=40000000.AND.cepuso<=48999999
         cep2uf:="BA"
    CASE cepuso>=49000000.AND.cepuso<=49999999
         cep2uf:="SE"
    CASE cepuso>=50000000.AND.cepuso<=56999999
         cep2uf:="PE"
    CASE cepuso>=57000000.AND.cepuso<=57999999
         cep2uf:="AL"
    CASE cepuso>=58000000.AND.cepuso<=58999999
         cep2uf:="PB"
    CASE cepuso>=59000000.AND.cepuso<=59999999
         cep2uf:="RN"
    CASE cepuso>=60000000.AND.cepuso<=63999999
         cep2uf:="CE"
    CASE cepuso>=64000000.AND.cepuso<=64999999
         cep2uf:="PI"
    CASE cepuso>=65000000.AND.cepuso<=65999999
         cep2uf:="MA"
    CASE cepuso>=66000000.AND.cepuso<=68899999
         cep2uf:="PA"
    CASE cepuso>=68900000.AND.cepuso<=68999999
         cep2uf:="AP"
    CASE cepuso>=69000000.AND.cepuso<=69299999
         cep2uf:="AM" //1a faixa amazonas
    CASE cepuso>=69300000.AND.cepuso<=69399999
         cep2uf:="RR"
    CASE cepuso>=69400000.AND.cepuso<=69899999
         cep2uf:="AM" //2a faixa amazonas
    CASE cepuso>=69900000.AND.cepuso<=69999999
         cep2uf:="AC"
    CASE cepuso>=70000000.AND.cepuso<=72799999
         cep2uf:="DF"  //1a Faixa Distrito Federal
    CASE cepuso>=72800000.AND.cepuso<=72999999
         cep2uf:="GO" //1a faixa de Goias
    CASE cepuso>=73000000.AND.cepuso<=73699999
         cep2uf:="DF" //2a. faixa distrito federal
    CASE cepuso>=73700000.AND.cepuso<=76799999
         cep2uf:="GO" //2a; faixa de Goias
    CASE cepuso>=77000000.AND.cepuso<=77999999
         cep2uf:="TO"
    CASE cepuso>=78000000.AND.cepuso<=78899999
         cep2uf:="MT"
    CASE cepuso>=78900000.AND.cepuso<=78999999
         cep2uf:="RO"
    CASE cepuso>=79000000.AND.cepuso<=79999999
         cep2uf:="MS"
    CASE cepuso>=80000000.AND.cepuso<=87999999
         cep2uf:="PR"
    CASE cepuso>=88000000.AND.cepuso<=89999999
         cep2uf:="SC"
    CASE cepuso>=90000000.AND.cepuso<=99999999
          cep2uf:="RS"
   otherwise
      cep2uf="EX"
endcase
RETURN cep2uf


