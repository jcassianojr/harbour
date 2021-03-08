*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    f_freadl.prg         funcoes de arquivos
*+
*+    Function FREADLINE(handle, line_len,lremchrexp) le uma linha
*+    Function flinecount(Carq)    conta numero de linhas    //nativa harbour flnecount()
*+    Function Data_Hora_ARQ(cArq)  retorna data e hora do arquivo //nativa harbour fdate() ftime()
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　

#include "Directry.ch"

*****************************************************************
* FUNCTION FREADLINE (handle, line_len,lremchrexp,cDELI)
* Carrega uma linha de um arq. texto (a partir da pos.atual do ponteiro)
*****************************************************************
FUNCTION FREADLINE (handle, line_len,lremchrexp,cDELI)
LOCAL buffer, line_end, num_bytes
* Se o tamanho da linha nao for informado, usa o predefinido MAXLINE
IF VALTYPE(line_len) <> 'N'
    line_len = 1024
ENDIF
if valtype(lremchrexp)<>"L"
   lREMCHREXP:=.T.
endif
IF valtype(cDELI)<>"C"
   cDELI:=CHR(13)+CHR(10)
ENDIF
* Define um buffer temporario p/ guardar o tamanho de linha  especificado
buffer = SPACE(line_len)
* Carrega o texto da posicao atual ate' o tamanho de linha especificado
num_bytes = FREAD(handle, @buffer, line_len)
* Localiza a combinacao de retorno de carro/avanco de linha.
line_end = AT(cDELI, buffer)
IF line_end = 0
    * Nao ha' retorno carro/avanco linha. Ponteiro esta' no final do
    * arq. ou linha e' grande demais. Volta ponteiro p/ inicio do arq.
    FSEEK(handle, 0)
    RETURN('__FINAL__')
ELSE
    * Move o ponteiro para o inicio da proxima linha.
    FSEEK(handle, (num_bytes * -1) + line_end + 1, 1)
    * E retorna a linha atual.
    IF lREMCHREXP
       cRETU:= SUBSTR(buffer, 1, line_end - 1)
       cRETU:=  RANGEREPL(CHR(0),CHR(9),cRETU," ")       // CHR(13)+CHR(10)
       cRETU := RANGEREPL( chr( 11 ), chr( 12 ), cRETU," " )  // Line Feed Manter
       cRETU := RANGEREPL( chr( 14 ), chr( 31 ), cRETU," " )  //32 space
       cRETU := RANGEREPL( chr( 127 ), chr( 255 ), cRETU," " )
       RETURN cRETU
    ELSE
       RETURN( SUBSTR(buffer, 1, line_end - 1) )
    ENDIF
ENDIF

*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    Function flinecount(cARQ) //funcao nativa xhb
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
//function flinecount(cARQ,line_len,lremchrexp,cDELI)
//LOCAL nHANDLE
//LOCAL nLINHAS
//LOCAL LINHA
//nLINHAS:=0
//nHANDLE := fopen( cARQ )
//if nHANDLE <= 0
//   ALERTX( "N?o Consegui abrir o Arquivo: " + cARQ )
//endif
//while .T.
//   LINHA:=FREADLINE( nHANDLE,line_len,lremchrexp,cDELI)
//   IF LINHA = "__FINAL__"
//      exit
//   else
//      nLINHAS:=nLINHAS+1
//   endif
//enddo
//fclose( nHANDLE )
//return nLINHAS

*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    Function Data_Hora_ARQ(vArq) //funcao nativa harbour fdate() ftime()
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
//Function Data_Hora_ARQ(vArq)
//aDir  := Directory( vArq )
//aRet  := Transform(DtoC(aDir[1,3]),"@d")
//aRet2 := aDir[1,4]
//Return( aRet + " - " + aRet2 )
