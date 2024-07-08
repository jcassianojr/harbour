*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+   Module => DISK59.PRG
*+
*+
*+             FUNCTION valcnpj(cCNPJ,lMES,cUF) //Chama VALCGC( cCNPJ, xTIPO ,lMES,cUF)
*+             FUNCTION VALCGC( cCNPJ, xTIPO ,lMES,cUF)
*+             FUNCTION Valcpf( xCPF ,lMES)
*+             FUNCTION Mod11( campo, posdv, pesomax )
*+             FUNCTION formatacpf(xCPF)
*+             FUNCTION formatacnpj(xCNPJ)
*+             FUNCTION CNPJCPFPICT(oGet,v_Tipo,nROW,nCOL)  
*+             FUNCTION CNPJCPFVAL(cCGC,cPESSOA,cESTADO)
*+             FUNCTION VALCEI(wk_cei,lMES) 
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FUNCTION valcnpj(cCNPJ,lMES) //Chama vaccgc
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
 FUNCTION valcnpj(cCNPJ , lMES , cUF)
 return VALCGC( cCNPJ , "" , lMES , cUF)

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FUNCTION VALCGC()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION VALCGC( cCNPJ, xTIPO ,lMES, cUF)
local x
local nCHAR
local P1
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
if valtype(cCNPJ)='N'
   cCNPJ:=alltrim(str(cCNPJ))
endif

//valor cnpj sem traco e pontos
P1 := alltrim( TIRAOUT( cCNPJ ) )

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
   if p1 = repl ( str( X, 1 ), 14 )
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
// CNPJ-Numeric (current): NN.NNN.NNN/NNNN-NN
//CNPJ-Alphanumeric (new): SS.SSS.SSS/SSSS-NN       
//                         12 345 678 9012 34
for X := 1 to 12
   nCHAR := SUBSTR(P1,X,1)
   if ISALPHA(nCHAR) .OR. ISDIGIT(nCHAR)
   else 
      ZNERRO:=11
      ZERRO:="CNPJ Invalido - digito Posicao " + str( X, 1 ) 
   endif
next X

for X := 13 to 14
  nCHAR := SUBSTR(P1,X,1)
   if ISDIGIT(nCHAR)
   else 
      ZNERRO:=12
      ZERRO:="CNPJ Invalido - digito nao numerico Posicao " + str( X, 1 ) 
   endif
next X



if Left(p1, 7) = "9999999" //     inicio 999999             
   ZNERRO:=5
   ZERRO:="CNPJ Generico 9999999"
endif
if substr(p1,9,4)="9999"    //depois da barra /9999
   ZNERRO:=6
   ZERRO:="CNPJ Generico /9999-"
endif
IF VALTYPE(cUF)="C" .AND. ! EMPTY(cUF)
   aUF    := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
            "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
            "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}
   IF ASCAN(aUF,cUF)=0
      ZNERRO:=7
      ZERRO:="Estado invalido: "+ cUF
   ENDIF   
ENDIF

IF ZNERRO=0 
   if ! CNPJ_Novo(P1)
       ZNERRO:=10
       ZERRO:="CNPJ Invalido"
   endif
   //funcao nova validar nova versao com caracteres
   /*
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
  */
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
*+    FUNCTION Valcpf()
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
FUNCTION Valcpf( xCPF ,lMES)
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
if len(p1)=14 .and. substr(p1,1,3)="000"
   p1=substr(p1,4)
endif


if val( p1 ) = 0
   ZNERRO:=1
   ZERRO:="CPF/CNI Em Branco"  
endif

if len( p1 ) <> 11
   ZNERRO:=2
   ZERRO:="CPF/CNI nao tem 11 digitos"  
endif

for X := 0 to 9
   if p1 = repl( str( X, 1 ), 11 )
      ZNERRO:=3
      ZERRO:="CPF/CNI Invalido - Sequencia Repetitiva de " + str( X, 1 )
   endif
next X

if znerro=0
   if Mod11( P1, 10, 10 )
      if Mod11( P1, 11, 11 )
         return .t.
      else
         ZNERRO:=4
         ZERRO:="CPF/CNI - Invalido Cheque 11o. Digito - 2 Verificador"
      endif
   else
      ZNERRO:=5
      ZERRO:="CPF/CNI - Invalido Cheque 10o. Digito - 1 Verificador"      
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

 FUNCTION CNPJ_Novo(pCNPJ) //, plMsg )
   
    Local lResult := .t.
    local soma := 0
    local dv := ""
    local digito := 0
    local num := 0
    Local wCGC := iif(ValType(pCNPJ)="U", "", pCNPJ)
    local i := 0
    local j := 0
    local Validos := "0123456789" //Incia so numeros mas se for a versao nova muda para alfa+numeros

 //   DEFAULT plMsg := .t.

    wCGC := StrTran(wCGC, ".", "")   
    wCGC := StrTran(wCGC, "-", "")   
    wCGC := StrTran(wCGC, "/", "")
    if Empty(wCGC)
        lResult := .f. //.t.
    else
        if len(wCGC) < 14
            lResult := .f.
        else
          for i = 1 to 12
             if substr(wCGC, i, 1) $ "ABCDEFGHIJKLMNOPQRSTUWYXZ"
                Validos := "0123456789ABCDEFGHIJKLMNOPQRSTUWYXZ"
                exit   
             endif
          next
            dv := ""
            num := 5
            for j = 1 to 2
                soma := 0
                for i = 1 to 12
                    soma += (asc(substr(wCGC, i, 1)) - 48) * num
                    num--
                    if num == 1
                        num := 9
                    endif
                next
                if j == 2
                    soma+=( 2 * val(dv))
                endif
                digito = soma - (int(soma / 11) * 11)
                if digito == 0 .or. digito == 1
                    dv := dv + "0"
                else
                    dv := dv + str(11 - digito, 1)
                endif
                num := 6
            next
            if dv <> substr(wCGC, 13, 2)
                lResult := .f.
            endif
        endif
		/*
        if !lResult
           if plMsg
               Msg_OK("CNPJ Incorreto ou Digito Invalido..." + " [" + dv + "]" )
           endif
       endif
	   */
    endif

    return lResult

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FUNCTION Mod11()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION Mod11( campo, posdv, pesomax )

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
*+    FUNCTION formatacfp()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION formatacpf(xCPF)
if valtype(xCPF)='N'
   xCPF:=alltrim(str(xCPF))
endif
xCPF:=AllTrim(TIRAOUT(xCPF))
IF VAL(xCPF)=0 .OR. LEN(xCPF)<>11
   return xCPF
ENDIf
xCPF:=StrZero(Val(xCPF),11)
RETUrn Transform(xCPF,"@R 999.999.999-99")

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FUNCTION formatacnpj()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION formatacnpj(xCNPJ)
//@ 01,10 GET CGC1 PICTURE "99.999.999/9999-99" so numeros
///@ 02,10 GET CGC2  PICTURE "NN.NNN.NNN/NNNN-99" numeros e letras
//@ 03,10 GET CGC3  PICTURE "@! NN.NNN.NNN/NNNN-99" numero e letras comente maisculas

if valtype(xCNPJ)='N'
   xCNPJ:=alltrim(str(xCNPJ))
endif
xCNPJ:=AllTrim(TIRAOUT(xCNPJ))
IF VAL(xCNPJ)=0 .OR. LEN(xCNPJ)<>14
   return xCNPJ
ENDIf
xCNPJ:=StrZero(Val(xCNPJ),14)
RETURN Transform(xCNPJ,"@R! NN.NNN.NNN/NNNN-99")   // ! Para converter maisculas ou usar upper("@R NN.NNN.NNN/NNNN-99")

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FUNCTION CNPJCPFPICT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION CNPJCPFPICT(oGet,v_Tipo,nROW,nCOL)    
//@ 01,10 GET CGC1 PICTURE "99.999.999/9999-99" so numeros
///@ 02,10 GET CGC2  PICTURE "NN.NNN.NNN/NNNN-99" numeros e letras
//@ 03,10 GET CGC3  PICTURE "@! NN.NNN.NNN/NNNN-99" numero e letras comente maisculas

@ nROW,nCOL SAY SPACE(18)
DO CASE 
  CASE v_Tipo = "J" 
       oGet:picture := "@! NN.NNN.NNN/NNNN-99" //"99.999.999/9999-99"
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
*+    FUNCTION cnpjcpfval()
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
*+    FUNCTION VALCEI(wk_cei,LMES)        //mascara="  .   .     /  " 
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION VALCEI(wk_cei,Lmes)        //mascara="  .   .     /  "
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

