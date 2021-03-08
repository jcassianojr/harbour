*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+   Module => DISK59.PRG
*+
*+             function VALCGC( xgcg, xTIPO ,lMES,cUF)
*+             function Valcpf( xcpf ,lMES)
*+             function Mod11( campo, posdv, pesomax )
*+             FUNCTION formatacpf(xCPF)
*+             FUNCTION formatacnpj(xCNPJ)
*+             FUNCTION CNPJCPFPICT(oGet,v_Tipo,nROW,nCOL)  
*+             FUNCTION CNPJCPFVAL(cCGC,cPESSOA,cESTADO)
*+             function VALCEI(wk_cei,lMES) 
*+             function coduf(cBUSCA,cTIPO) //ibge
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function VALCGC()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function VALCGC( xgcg, xTIPO ,lMES,cUF)
local x
ZNERRO:=0
ZERRO:=""

if lastkey() = K_UP .or. lastkey() = K_DOWN                 // retorna caso seta para cima ou baixo
   return .T.
endif
IF VALTYPE(LMES)<>"L"
   lMES:=.T.
ENDIF
if valtype( xTIPO ) <> "C"
   xTIPO := "X"
endif
if valtype(xgcg)='N'
   xgcg:=alltrim(str(xgcg))
endif
P1 := alltrim( TIRAOUT( xGCG ) )

if val( p1 ) = 0
   ZNERRO:=1
   ZERRO:="CNPJ Invalido - Em Branco"         
   return .F.
endif
if len( p1 ) <> 14
   ZNERRO:=2
   ZERRO:="CNPJ Invalido - nao tem 14 Digitos"
endif
for X := 0 to 9
   if p1 = repl( str( X, 1 ), 14 )
      ZNERRO:=3
      ZERRO:="CNPJ Invalido - Sequencia Repetitiva de " + str( X, 1 ) 
   endif
next X
//if xtipo = 'M' //desabilitada pois a matriz nao mais precisa ser 0001
   //if substr( P1, 9, 4 ) != '0001'
      //ZNERRO:=4
      //ZERRO:="CNPJ Invalido - Nao e Matriz"
   //endif
//endif
if Left(p1, 7) = "9999999" //     inicio 999999             
   ZNERRO:=5
   ZERRO:="CNPJ Generico 9999999"
endif
if substr(p1,9,4)="9999"    //depois da barra /9999
   ZNERRO:=6
   ZERRO:="CNPJ Generico /9999-"
endif
IF VALTYPE(cUF)="C"
   aUF    := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
            "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
            "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}
   IF ASCAN(aUF,cUF)=0
      ZNERRO:=7
      ZERRO:="Estado invalido: "+ cUF
   ENDIF   
ENDIF

IF ZNERRO=0
  if Mod11( P1, 13, 9 )
     if Mod11( P1, 14, 9 )
        return .T.
     else
        ZNERRO:=8
        ZERRO:="Cheque 14o. Digito - 2 Verificador"
     endif
  else
     ZNERRO:=9
     ZERRO:="Cheque 13o. Digito - 1 Verificador"
  endif
endif  
IF ZNERRO>0 
   if lMES   
      ALERTX(zERRO)
   endif
   return .f.      
ENDIF
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Valcpf()
*+    CPF no 000.000.008-00
*+1. Tocantins, Mato Grosso do Sul, Goias e Distrito Federal;
*+2. Roraima,Amapa, Amazonas, Acre, Rondonia e Para;
*+3. Piaui, Maranhao e Ceara;
*+4. Rio Grande do Norte, Pernambuco, Alagoas e Paraiba;
*+5. Bahia e Sergipe;
*+6. Minas Gerais;
*+7. Rio de Janeiro e Espirito Santo;
*+8. Sao Paulo;
*+9. Parana e Santa Catarina;
*+0. Rio Grande do Sul
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function Valcpf( xcpf ,lMES)
local X,cDIGEST
ZNERRO:=0
ZERRO:=""

if lastkey() = K_UP .or. lastkey() = K_DOWN                 // retorna caso seta para cima ou baixo
   return .T.
endif
IF VALTYPE(lMES)#'L'
   lMES:=.T.
ENDIF

p1 := alltrim( tiraout( xCPF ) )

//00001008268143 programa do governo com 3 zeros a frente e comprimento 14
if len(p1)=14.and.substr(p1,1,3)="000"
   p1=substr(p1,4)
endif


if val( p1 ) = 0
   ZNERRO:=1
   ZERRO:="CPF Em Branco"  
endif

if len( p1 ) <> 11
   ZNERRO:=2
   ZERRO:="Cpf nao tem 11 digitos"  
endif

for X := 0 to 9
   if p1 = repl( str( X, 1 ), 11 )
      ZNERRO:=3
      ZERRO:="CPF Invalido - Sequencia Repetitiva de " + str( X, 1 )
   endif
next X

if znerro=0
   if Mod11( P1, 10, 10 )
      if Mod11( P1, 11, 11 )
         return .t.
      else
         ZNERRO:=4
         ZERRO:="CPF - Invalido Cheque 11o. Digito - 2 Verificador"
      endif
   else
      ZNERRO:=5
      ZERRO:="CPF - Invalido Cheque 10o. Digito - 1 Verificador"      
   endif
endif
//Estado Emissor
cDIGEST:=SUBSTR(P1,9,1)
DO CASE
   CASE cDIGEST='1' 
   	    cDIGEST:='GO/MT/MS/DF/TO'
   CASE cDIGEST='2' 
      	cDIGEST:='AM/AC/PA/RR/RO/AP'
   CASE cDIGEST='3' 
      	cDIGEST:='MA/CE/PI'
   CASE cDIGEST='4' 
      	cDIGEST:='RN/PB/PE/AL'
   CASE cDIGEST='5' 
      	cDIGEST:='SE/BA'
   CASE cDIGEST='6' 
       	cDIGEST:='MG'
   CASE cDIGEST='7' 
       	cDIGEST:='RJ/ES'
   CASE cDIGEST='8' 
       	cDIGEST:='SP'
   CASE cDIGEST='9' 
   	    cDIGEST:='PR/SC'
   CASE cDIGEST='0' 
   	    cDIGEST:='RS'
ENDCASE  
IF ZNERRO>0 
   if lMES   
      ALERTX(zERRO)
   endif
   return .f.      
ENDIF

return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Mod11()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function Mod11( campo, posdv, pesomax )

dv   := 0
peso := 1
for imod := posdv to 1 STEP - 1
   dv += peso * val( substr( campo, imod, 1 ) )
   peso ++
   if peso > pesomax
      peso := 2
   endif
next
rest := mod( dv, 11 )
if rest = 0
   return .T.
else
   if rest = 1 .and. val( substr( campo, posdv, 1 ) ) = 0
      return .T.
   else
      return .F.
   endif
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function formatacfp()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION formatacpf(xCPF)
if valtype(xCPF)='N'
   xCPF:=alltrim(str(xCPF))
endif
XCPF:=AllTrim(TIRAOUT(xCPF))
IF VAL(xCPF)=0 .OR. LEN(xCPF)<>11
   return xCPF
ENDIf
xCPF:=StrZero(Val(XCPF),11)
RETUrn Transform(xCPF,"@R 999.999.999-99")

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function formatacnpj()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION formatacnpj(xCNPJ)
if valtype(xCNPJ)='N'
   xCNPJ:=alltrim(str(xCNPJ))
endif
xCNPJ:=AllTrim(TIRAOUT(xCNPJ))
IF VAL(xCNPJ)=0 .OR. LEN(xCNPJ)<>14
   return xCNPJ
ENDIf
xCNPJ:=StrZero(Val(xCNPJ),14)
RETU Transform(xCNPJ,"@R 99.999.999/9999-99")

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CNPJCPFPICT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION CNPJCPFPICT(oGet,v_Tipo,nROW,nCOL)     // ,NLEN
@ nROW,nCOL SAY SPACE(18)
DO CASE 
  CASE v_Tipo = "J" 
       oGet:picture :="99.999.999/9999-99"
  CASE v_Tipo = "F"
      oGet:picture :="999.999.999-99"                      
  otherwise  //CEI //CNO
      oGet:picture :="@S18" 
      //X   Any character allowed.
      //oGet:picture :=repl("X",nLEN)
endcase
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function cnpjcpfval()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION CNPJCPFVAL(cCGC,cPESSOA,cESTADO)
lRETU:=.T.
DO CASE
   CASE cPESSOA='J'
        lRETU:=VALCGC(cCGC,,,cESTADO)
   CASE cPESSOA="F" // CPF CAEPF
        lRETU:=VALCPF(cCGC)
   cASE cPESSOA="C" // CEI CNO
        lRETU:=VALCEI(cCGC)
ENDCASE
RETURN lRETU



*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function VALCEI(wk_cei,LMES)        //mascara="  .   .     /  " 
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function VALCEI(wk_cei,Lmes)        //mascara="  .   .     /  "
PRIVATE nTot, cAux, i
if lastkey()=K_UP.OR.LASTKEY()=K_DOWN  && retorna caso seta para cima ou baixo
   return .t.
endif
IF VALTYPE(lMES)#'L'
   lMES:=.T.
ENDIF
ZNERRO:=0
ZERRO:=""
nTot = 0
cAux = ""
i = 0
pNu_cei = ""
pNU_CEI:=TIRAOUT(wk_cei)
if val (pNU_CEI) = 0
   znerro=1
   zerro:='CEI invalidos -  branco ou zero , redigite '   
endif
if val (substr (pNU_CEI, 1, 2)) < 2 .or. val (substr (pNU_CEI, 1, 2)) > 29
   znerro=2
   zerro= 'Posicao 1,2 nao e 00,01 ou maior que 29 '    
endif     
IF (SUBSTR(pNu_cei,11,1) $ "0678") .AND. VAL(LEFT(pNu_cei,2)) > 0 .AND. ;
                                      VAL(SUBSTR(pNu_cei,3,3)) > 0 .AND.  ;
                                      VAL(SUBSTR(pNu_cei,6,5)) > 0
      FOR i = 1 TO 11
         nTot = nTot + VAL(SUBSTR(pNu_cei,i,1)) * VAL(SUBSTR("74185216374",i,1))
      next
      cAux = RIGHT(STR(nTot,3),2)
      nTot = VAL(LEFT(cAux,1)) + VAL(RIGHT(cAux,1))
      nTot = IIF(nTot>9, 0, 10-nTot)
      IF VAL(RIGHT(pNu_cei,1)) = nTot
         return .t.
      ELSE
        znerro=3
        zerro= 'Digito invalido'       
      ENDIF
else
    znerro=4
    zerro= 'Posicao 11 nao e 0,6,7,8 ou posicoes 2 345 678910 zeradas'      
ENDIF
IF ZNERRO>0 
   if lMES   
      ALERTX(zERRO)
   endif
   return .f.      
ENDIF
return .T.


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function coduf()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function coduf(cBUSCA,cTIPO) //cTIPO UF=codigo->sigla SI=sigla->codigo
local nPos:=0
local cRETU:="  "
LOCAL aUF,aIBGE

aUF    := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
            "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
            "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}

aIBGE:= { "12", "27", "13", "16", "29", "23", "53", "32", "52", ;
          "21", "31", "50", "51", "15", "25", "26", "22", "41", ;
          "33", "24", "11", "14", "43", "42", "28", "35", "17" ,"54","54"}

/*
          aIRRF   := { "01", "27", "02,98", "06", "33", "13", "DF", "56", "57,92", ;
             "08", "41", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
             "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}
*/
          
IF EMPTY(cBUSCA)
   RETURN cRETU
ENDIF
IF VALTYPE(cTIPO)<>"C"
   cTIPO:="UF"
ENDIF
//@ 23,00 SAY cBUSCA
//inkey(0)
IF cTIPO="UF" // codigo->Sigla uf
   IF LEN(cBUSCA)>2 //codigo ibge 7 digitos 2 primeiros estados
      cBUSCA:=SUBSTR(cBUSCA,1,2)
   ENDIF
   nPos:=ascan( aIBGE, cBUSCA )
   if nPos>0
      cRETU:=aUF[nPos] // retorna o codigo do Estado
   endif
ELSE    //SI sigla uf->codigo
   nPos:=ascan( aUF, cBUSCA )
   if nPos>0
      cRETU:=aIBGE[nPos] // retorna o codigo numerico do estado
   endif
ENDIF
Return cRETU