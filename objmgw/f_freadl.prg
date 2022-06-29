*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    f_freadl.prg         funcoes de arquivos
*+
*+    Function FREADLINE(handle, line_len,lremchrexp) le uma linha
*+    FUNCTION FDELIM (cARQ, line_len) verifica se o delimitador e chr(13)chr(10) dos ou chr(10) linux
*+    SplitCommaAspas(cLINHA) "33600823";"0001";"07";"1";"SALGADOS DA ERIDIANA";"08" todos os campos estao delimitados por ";"
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　

#include "Directry.ch"

/*
    nLASTREC:=FLINECOUNT(cARQIMP)
    zei_fort( nLASTREC,,,0)
    
    cDELIM:=FDELIM (cARQIMP,1024) //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
    nFILE:=FOPEN(cARQIMP) //abre o arquivo
     WHILE .T.  
        cLINHA:=FREADLINE (nFILE, 1024 ,.T. ,cDELIM) //FREADLINE (handle, line_len,lremchrexp,cDELI)
        
        //operacoes da rotina
        
        IF cLINHA='__FINAL__' //freadline retorna __FINAL__   quando nao e mais linhas
           EXIT
        ENDIF
        
        zei_fort(nLASTREC,,,1)
       
     enddo
     fclose(nFILE)   //fecha o arquivo
*/

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
    IF cDELI=CHR(10) //*-1 negativo pois o buffer passa do ponto e precisa retornar ao final real da linha
       FSEEK(handle, (num_bytes * -1) + line_end , 1) //chr(10) e so um caractere nao  precisa somar +1
    ELSE
       FSEEK(handle, (num_bytes * -1) + line_end + 1, 1) //como chr(13)+chr(10) sao dois caracteres precisa somar +1
    ENDIF   
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
*+    FUNCTION FDELIM (cARQ, line_len) verifica se o delimitador e chr(13)chr(10) dos ou chr(10) linux
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
FUNCTION FDELIM (cARQ, line_len)
LOCAL buffer, line_end, num_bytes,nhandle,cRETU
IF VALTYPE(line_len) <> 'N'
    line_len = 1024
ENDIF
cRETU:=""
buffer = SPACE(line_len)
nHANDLE:=FOPEN(cARQ)
num_bytes = FREAD(nhandle, @buffer, line_len)
FCLOSE(NHANDLE)
line_end = AT(CHR(13)+CHR(10), buffer)
IF line_end > 0
   cRETU:=CHR(13)+CHR(10) //dos
  // alert("dos")
   return cRETU
endif
line_end = AT(CHR(10), buffer)
IF line_end > 0
   cRETU:=CHR(10)  //linux
  // alert("linux")
   return cRETU
endif
IF EMPTY(cRETU)
  line_end = AT(CHR(255)+CHR(254), buffer)
  IF line_end > 0
     cRETU:=CHR(255)+ CHR(254) //unicode
  endif
ENDIF
IF EMPTY(cRETU)
  line_end = AT(CHR(239)+CHR(187)+CHR(191), buffer)
  IF line_end > 0
     cRETU:=CHR(239)+ CHR(187)+CHR(191) //utf-8
  endif
ENDIF
RETURN cRETU


*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    SplitCommaAspas(cLINHA)
*+    todos os campos devem estar com aspas 
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　

FUNCTION SplitCommaAspas(cLINHA)
LOCAL aRETU,cVALOR,nPOS
//CLINHA:='"33600823";"0001";"07";"1";"SALGADOS DA ERIDIANA";"08";"20190722";"01";"";"";"20190513";"5620104";"1096100,1093702";"RUA";"EMILIO VASCONCELOS";"288";"";"CENTRO";"39790000";"MG";"4011";"33";"88333829";"";"";"";"";"adelano.deptofiscal@gmail.com";"";"'
aRETU:={}
while at('";"',cLINHA)>0
    nPOS:=at('";"',cLINHA)
    IF LEFT(cLINHA,1)='"' //as vezes o primeiro campo nao e "33600823"; e sim 33600823";
       cVALOR:=SUBSTR(cLINHA,2,nPOS-2)
    ELSE
       cVALOR:=SUBSTR(cLINHA,1,nPOS-1)
    ENDIF   
    cLINHA:=SUBSTR(cLINHA,nPOS+2)
//    ALERT(cVALOR)
//    ALERT(cLINHA)
    AADD(aRETU,cVALOR)
enddo
IF LEN(cLINHA)>0 //caso o ultimo campo nao tenha delimitador
    AADD(aRETU,strtran(cLINHA,'"',''))
ENDIF
RETURN aRETU
