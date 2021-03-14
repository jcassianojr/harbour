

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Module => validae.PRG
*+
*+     ValIE( cinsc, cUF, cPESSOA,lMES ,lOLD)
*+     FormataIE(Valor,cUF,cPESSOA)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ValIE()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ValIE( cinsc, cUF, cPESSOA,lMES ,lOLD)  //mantida lold telas com get via macro ainda usam este parametro

local lRETU
local nRet
local x
local nPOS
LOCAL aUF,aTAM

ZNERRO:=0
ZERRO:=""


if lastkey() = K_UP .or. lastkey() = K_DOWN
   retu .T.         //Mandou Proceguir
endif

IF VALTYPE(lMES)<>"L"
   lMES:=.T.
ENDIF
IF VALTYPE(lOLD)<>"L"
   lOLD:=.T.
ENDIF


if ( empty( cinsc ) )   
   ZNERRO:=1
   ZERRO :="Inscricao em Branco"
endif

if ( empty( cUF) )   
   ZNERRO:=2
   ZERRO:="Estado em Branco"
endif

if cUF = "XX".OR.cUF = "EX"
   if left( upper( cINSC ), 5 ) = "ISENT"   .OR.  cINSC = "00000000000000"
      return .T.         //Exterior
   else   
      ZNERRO:=3
      ZERRO:="Exterior <> Isento ou 00000000000000"
   endif
endif

if left( upper( cINSC ), 5 ) = "ISENT" // isento isenta
   return .T.         
endif


if valtype( cPESSOA ) = "C"
   if cPESSOA # "J"
      return .T.      //Nao E Pessoa Juridica
   endif
endif
lRETU := .F.
cINSC := alltrim( cINSC )
cINSC := strtran( cINSC, ".", "" )
cINSC := strtran( cINSC, "", "" )
cINSC := strtran( cINSC, "/", "" )
cINSC := STRTRAN(cINSC,'ME','')           //Micro Empresa
cINSC := STRTRAN(cINSC,' ','')
cINSC := STRTRAN(cINSC,',','')
if ! lOLD
   cINSC := STRTRAN(cINSC,'P','')           //Produtor rural sp tratado pela formula 
ENDIF   


if LEN(cINSC)<8
   ZNERRO:=4
   ZERRO:="IE Invalido  menos de 8 digitos "
endif


for X := 0 to 9
   if cINSC = repl( str( X, 1 ), len(cINSC) )      
      ZNERRO:=5
      ZERRO:="IE Invalido  Sequencia Repetitiva de " + str( X, 1 )
   endif
next X

aUf:= { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MG", "MS",;
    "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC",;
    "SE", "SP","TO" }

aTAM:= { 13,  09,    09,   09,  09, 09, 13, 09, 09, 09, 13, 09,;
       11, 09, 09, 14, 09, 10, 08, 09, 14, 09, 10, 09,;
       09, 12, 11 }
//ba mudou 8 para 9 em 2012

nPOS:=ASCAN(aUF,cUF)
lTAM:=.T.
IF nPOS>0
   nPOS:=aTAM[nPOS]
   DO CASE
   
       Case cUF="AC" .AND. LEN(cINSC)<> 13 .AND. LEN(cINSC) <> 9 // 13 9
             lTAM:=.F.   
       Case cUF="PE" .AND. LEN(cINSC)<>9 .AND. LEN(cINSC) <> 14 //9 Nova ou 14 Antiga
             lTAM:=.F.
       //Case cUF="RN" .AND. LEN(cINSC)<>9 .AND. LEN(cINSC) <> 10  //9 digitos  ou 10 digitos
       //     lTAM:=.F. verificado somente nove digitos
       Case cUF="RO" .AND. LEN(cINSC)<>9 .AND. LEN(cINSC) <> 14  //9 atual ou 14 Antiga
            lTAM:=.F.
       Case cUF="TO" .AND. LEN(cINSC)<>9 .AND. LEN(cINSC) <> 11  //9 atual ou 11 Antiga
	        lTAM:=.F.
       Case cUF="BA" .AND. LEN(cINSC)<>8 .AND. LEN(cINSC) <> 9  //8 Antiga
	        lTAM:=.F.
       Case cUF="SP" .AND. LEN(cINSC)<>12 .AND. LEN(cINSC) <> 13  //12 13='P'+IE inscricao produtor rural
	        lTAM:=.F.
			
       OTHERWISE
           if nPOS<>LEN(cINSC)
               lTAM:=.F.
           endif
   ENDCASE
ENDIF
IF lMES.AND.! lTAM
   ZNERRO:=8
   ZERRO:="Tamanho da Inscricao Invalido:"+str(nPOS)+"/"+str(len(cINSC))
ENDIF

aTAM:= { "01", "24", "", "03", "", "06", "07", "", "10", "12", "", "28",;
        "", "15", "16", "18", "19", "", "", "20", "", "24", "", "25",;
         "27", "","29" }
nPOS:=ASCAN(aUF,cUF)
lTAM:=.T.
IF nPOS>0
   nPOS:=aTAM[nPOS]
   IF LEN(nPOS)=2
       DO CASE
           Case cUF="GO".AND.substr(cINSC,1,2)<>"10".AND.substr(cINSC,1,2)<>"11".AND.substr(cINSC,1,2)<>"15"
                 lTAM:=.F.
           OTHERWISE
               if nPOS<>substr(cINSC,1,2)
                  lTAM:=.F.
               endif
       ENDCASE
   ENDIF
ENDIF
IF ! lTAM   
   ZNERRO:=7
   ZERRO:="Inicio  da Inscricao Invalido:"+nPOS+"/"+substr(cINSC,1,2)
ENDIF

aadd(aUF,"XX")
aadd(aUF,"EX")

IF ASCAN(aUF,cUF)=0
   ZNERRO:=8
   ZERRO:="Estado invalido: "+ cUF
ENDIF   

if ZNERRO=0
   if ! ValidIE( cINSC, cUF ) //funcao classe sefaz
      ZNERRO:=6
      ZERRO:="Inscricao Invalida"
  endif
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
*+    Function formatIE(eIECPF,cUF,cPESSOA[F,J])
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
Function FormataIE(Valor,cUF,cPESSOA)
local cMASK
if valtype(cPESSOA)<>"C"
   cPESSOA:="J"
endif
cRETU:=valor
Valor:= alltrim(tiraout(Valor))
cMASK = ""
If Valor = "ISENTO"
   retu cRETU
EndIf
If cPESSOA = "F"
   retu cRETU
EndIf
If Len(Valor) = 0
   retu cRETU
EndIf
//| no lugar do ponto depois sofre strtran

do Case
    Case cUF="AC" //13 dig
         cMASK = "00|000|000/00000" //"@R 99.999.999/999-99" 
    Case cUF="AL" //9 digitos
         cMASK = "000000000"   //"@R 999999999"  
    Case cUF="AM" //9 dig
         cMASK = "00|000|0000" //"@R 99.999.999-9"
    Case cUF="AP" //9 dig
         cMASK = "000000000"  //"@R 999999999" 
    Case cUF="BA" //8 digitos
         IF len(VALOR)=8 //antiga
            cMASK = "00000000"  //"@R 999.999-99" 
         ENDIF
         IF len(VALOR)=9 //nova
            cMASK = "000|000|000" 
         ENDIF         
    Case cUF="DF" //13 digitos
		  cMASK =  "00|000000|00000"         //"@R 99.999999.999-99"
    Case cUF="MA"   //9 digitos
         cMASK = "000000000" //"@R 999999999"
    Case cUF="MG" //13 digitos
         cMASK = "000000000|00|00"  //"@R 999.999.999/9999"
    Case cUF="MT" //11 digitos
         cMASK = "00000000000"  //"@R 9999999999-9"
    Case cUF="PA" //9 digitos
         cMASK = "00|0000000" //"@R 99-999999-9"
    Case cUF="PB" //9 digitos
         cMASK = "00|000|0000"  //"@R 99-999999-9"
    Case cUF="PE" //9 nova ou 14 antiga
         IF Len(valor)>9
            cMASK = "00|0|000|00000000"  //14 antiga
         ELSE
            cMASK ="000000000"  //9 nova "@R 9999999-99"
         ENDIF
    Case cUF="PI" //9 digitos
         cMASK = "00|000|0000" //"@R 99.999.999-9"
    Case cUF="RN" //9 digitos  ou 10 digitos
         if len(VALOR)>9
            cMASK = "00|0|000|0000"
         else
            cMASK = "00|000|0000" //"@R 99.999.999-9" 
         endif
    Case cUF="RO"
         if len(VALOR)=9
            cMASK = "000|000000"  //antiga  9 digitos
         else 
            cMASK = "00000000000000"   //nova 14 digitos
         endif   
    Case cUF="RR" //9 digitos
         cMASK = "00|0000000" //"@R 99.999.999-9"
    Case cUF="SC" //9 digitos
         cMASK = "000|000|000" //"@R 999.999.999"
    Case cUF="SP" //12 digitos
          cMASK = "000|000|000|000"   //"@R 999.999.999.999"
    Case cUF="TO" //9 11 digitos
          If len(valor)=11
             cMASK = "00|00|0000000"  //"@R 99.99.999999-9" 
          else
             cMASK = "00|000|0000"  
          endif
    Case cUF="CE" //9 digitos
         cMASK = "00|0000000"  //"@R 99.999999-9"
    Case cUF="ES" //9 digitos
         cMASK = "000|000|000"  //"@R 999.999.99-9"
    Case cUF="GO"  //9 digitos
         cMASK = "00|000|0000"  //"@R 99.999.999-9"
    Case cUF="MS" //9 digitos         
         cMASK = "00|000|0000"  //"@R 99.999.999-9"
    Case cUF="PR" //10 digitos
         cMASK = "000|0000000"  //"@R 999.99999-99"
    Case cUF="RJ"  //8 digitos
         cMASK = "00|000|000"   //"@R 99.999.99-9"
    Case cUF="RS" //10 digitos
         cMASK = "000/0000000" //"@R 999/9999999"
    Case cUF="SE" //9 digitos  
         cMASK = "00|000|0000" //"@R 99.999.999-9" 
Endcase
If Len(cMASK) > 0
   cRETU = transform(valor, cMASK)
   cRETU = strtran(CRETU, "|", ".")
EndIf
RETU cRETU



