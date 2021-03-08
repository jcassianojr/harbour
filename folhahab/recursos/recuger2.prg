*:*****************************************************************************
*:
*:   RECUGER2.PRG: Editor de Cartas
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 05/12/94     12:16
*:
**:*****************************************************************************


 PADRAO('RECUEDIT','RECUEDIT',"' '+mARQUIVO+' '+mDESCRICAO+' '","mARQUIVO","Codigos","Arquivo Descricao",;
       {|| PEGCHAVE("mARQUIVO",SPACE(8),"Arquivo")},{|| tREDIT()},{||gREDIT()},{|| lREDIT() })



function tREDIT
@ 10, 2 SAY "Nome do Arquivo do Texto :"
@ 11, 2 SAY "Descri‡„o Do Arquivo :"
@ 13, 2 SAY "Set-up Inicial de Impress„o:"
@ 16,03 SAY "Margem Esquerda    :"
@ 17,03 SAY "Margem Direita     :"
@ 18,03 SAY "Margem Superior    :"
@ 19,03 SAY "Margem Inferior    :"
@ 20,03 SAY "Linhas  Formul rio :"
@ 21,03 SAY "Colunas Formul rio :"
return .t.


function gREDIT
@ 10,31 SAY mARQUIVO
@ 12, 2 GET mDESCRICAO
@ 14, 2 GET mSETUP
@ 16,25 GET mMARESQ PICT '##'
@ 17,25 GET mMARDIR PICT '##'
@ 18,25 GET mMARSUP PICT '##'
@ 19,25 GET mMARINF PICT '##'
@ 20,25 GET mMARLIN PICT '##'
@ 21,24 GET mMARCOL PICT '###'
READCUR()
return .t.

function lREDIT
mARQUIVO:=ProfileString( "FOLHA.INI","PATH","RECUEDIT" , "" )+mARQUIVO+".txt"
imparq(marquivo,msetup,mmarlin,mmarinf,mmarsup,mmaresq,mmardir,mmarcol) //,mgraf)
return .t.


*: FIM: RECUGER2.PRG

