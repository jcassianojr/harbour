#include "inifile.ch"

#define _INI_RESULT   1
#define _INI_TEXT     2
#define _INI_SECTIONS 3
#define _INI_NFES     4

#xcommand DEFAULT <var> TO <defvl> => <var> := if(<var> = nil, <defvl>, <var>)

#define _EOL   Chr(13)+Chr(10)
#define _EOL_SIZE 2
#define _TRUE  .t.
#define _FALSE  .f.


// *************************************************************************************************
// A matriz de retorno desta fun‡Æo nÆo est  ligada … configura‡Æo do ACBrNFeMonitor mas as demais
// fun‡äes de manipula‡Æo de INI nÆo tem essa liga‡Æo. Ou seja, aINI[3] (configura‡Æo) e aINI[4]
// (NFe) devem ser informadas isoladamente para essas fun‡äes de apoio. Ademais, essa fun‡äes podem
// ser utilizadas em qualquer arquivo INI que nÆo tenha v¡nculo com a estrutura do ACBrNFeMonitor.
// *************************************************************************************************
function ExtractINI(cContent) // O conte£do inteiro do INI que, normalmente, ‚ um arquivo pequeno.
local cSection        // 
local nCol1         // 
local nCol2         // 
local cSymb         // 
local aItem         //
local i1           //
local i2           //
local lNFe := _FALSE     // se _TRUE, est  lendo dados de uma NFe.
local aINI := {0,"",{},{}}  // Elementos: 1=se for o n£mero 0, indicar  sucesso na leitura
               //          Obs: havendo erro, ser  devolvido o valor -1
               //      2=texto encontrado antes da primeira se‡Æo ("", se nÆo existir)
               //      3=matriz de se‡äes, que conter  matrizes com dois elementos:
               //          1=nome da se‡Æo
               //          2=matriz de propriedades, que conter  dois elementos:
               //                1=nome da propriedade
               //                2=conte£do
               //      4=matriz de NFes, conter  matrizes com dois elementos:
               //          1=n£mero da NFe (texto, sem o prefixo "NFE")
               //          2=matriz de propriedades da NFe, com dois elementos:
               //                1=nome da propriedade
               //                2=conte£do

// Alguns INIs terminam sem um par CR/LF. Fica mais f cil analisar se ele existir.
cContent += _EOL

// Se o INI contiver algum texto antes de qualquer s¡mbolo, ele ser  copiado
// integralmente para o segundo elemento da matriz de retorno. Um caso assim
// ocorre no arquivo de retorno do ACBrNFeMonitor.
if (nCol1 := At("[",cContent)) = 0
 // Se nÆo for um INI v lido, nÆo h  o que fazer.
 return {-1,cContent} // retorna apenas dois elementos: o erro no primeiro e o pr¢prio conte£do no segundo
end

// Pode haver um texto antes da primeira se‡Æo.
if nCol1 > 1
 nCol2 := At(_EOL,cContent)
 nCol2 := if(nCol2=0, nCol1-1, nCol2-1)
 aINI[_INI_TEXT] := SubStr(cContent,1,nCol2)
end

// Cada linha ser  tratada individualmente, come‡ando pela primeira se‡Æo.
// SerÆo armazenados todos os pares (XXX=YYY) em sub-matrizes dentro da
// se‡Æo atualmente aberta. A vari vel "nCol1" vai percorrer as linhas,
// sempre parando no primeiro caractere de cada uma, para a pr¢xima itera‡Æo.
while _TRUE
 // Separar a linha, j  suprimindo o par CR/LF (dois in£teis).
 nCol2 := At(_EOL,SubStr(cContent,nCol1))+nCol1-1
 cLine := AllTrim(SubStr(cContent,nCol1,nCol2-nCol1))
 nCol1 := nCol2+_EOL_SIZE

 if Left(cLine,1) = "["
   nCol2 := At("]",cLine)
   cSymb := SubStr(cLine,2,nCol2-2)
   *
   if (lNFe := Left(cSymb,3) = "NFE")
    AAdd(aINI[_INI_NFES],{SubStr(cSymb,4),{}})
   else
    AAdd(aINI[_INI_SECTIONS],{cSymb,{}})
   end
 else
   // Se o operador de atribui‡Æo nÆo for encontrado, a linha ser  ignorada por completo.
   if (nCol2 := At("=",cLine)) > 0
    aItem := {Left(cLine,nCol2-1),SubStr(cLine,nCol2+1)}
    if lNFE
      nIdx := Len(aINI[_INI_NFES])
      AAdd(aINI[_INI_NFES][nIdx],aItem)
    else
      i1 := Len(aINI[_INI_SECTIONS])
      i2 := Len(aINI[_INI_SECTIONS][i1])
      AAdd(aINI[_INI_SECTIONS][i1][i2],aItem)
    end
   end
 end
 if nCol1 > Len(cContent)
   return aINI
 end
end


// Constr¢i um INI a partir de uma matriz com a estrutura do elemento 3 ([_INI_SECTIONS]) j  descrito
// *************************************************************************************************
function BuildINI(aINI,nLinSep) // Opcional, o argumento nLinSep representa a quantidade de linhas
local cStrOut := ""      // que separarÆo as se‡äes.
local cSection         // Essa fun‡Æo constr¢i o INI a partir de uma matriz com a estrutura
local cProperty        // do elemento 3 [_INI_SECTIONS] acima descrito.
local cValue
*
default nLinSep to 0
for j := 1 to Len(aINI)
  cSection := aINI[j][1]
  cStrOut += if(j>1, Replicate(_EOL,nLinSep), "") + "[" + cSection + "]" + _EOL
  *
  for k := 1 to Len(aINI[j][2])
    cProperty := aINI[j][2][k][1]
    cValue  := aINI[j][2][k][2]
    cStrOut += cProperty + "=" + cValue + _EOL
  next
next
return cStrOut


// Retorna o valor de uma propriedade, de uma certa se‡Æo.
// *************************************************************************************************
function GetINIProp(aINI,cSecName,cProperty) // aINI ‚ a matriz de se‡äes
static cSection
local aLocation
*
cSection := if(cSecName=VOID, cSection, cSecName)
aLocation := SearchINI(aINI,cSection,cProperty)
if aLocation[1] > 0
 return aINI[aLocation[1]][2][aLocation[2]][2]
end
return ""


// Procura pelas "coordenadas" de uma propriedade e sua se‡Æo dentro da matriz informada.
// *************************************************************************************************
function SearchINI(aINI,cSection,cProperty) // aINI ‚ a matriz de se‡äes
local nSection
local nProperty
*
nSection := AScan(aINI,{|a|Upper(a[1]) == Upper(cSection)})
if nSection > 0
 nProperty := AScan(aINI[nSection][2],{|a|Upper(a[1]) == Upper(cProperty)})
 if nProperty > 0
   return {nSection,nProperty}
 end
end
return {0,0}


// Atribui valor a uma propriedade, em uma certa se‡Æo.
// *************************************************************************************************
function SetINIProp(aINI,cSection,cProperty,cValue) // aINI ‚ a matriz de se‡äes
local aLocation := SearchINI(aINI,cSection,cProperty)
if aLocation[1] > 0
 aINI[aLocation[1]][2][aLocation[2]][2] := cValue
 return _TRUE
end
return _FALSE
