*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    DISK55.PRG funcoes conversoes
*+
*+    DIGADATA() retorna uma data formatada
*+    Cmes()     VEM DATA RETORNA MES POR EXTENSO
*+    Mmes()     VEM O NUMERO DO MES , RETORNA MES POR EXTENSO
*+    Cdia()     VEM A DATA , RETORNA DIA POR EXTENSO
*+    Ddia()     VEM NUMERO DIA , RETORNA DIA POR EXTENSO
*+    data2STR(dData,cFOR,cSEP,cDIG) retorna uma data formatada
*+    DifDatas(dDataInicial,dDataFinal)   retorna quantidade de ano/mes/dias
*+    str2html(cStr, lAnsi, loem )  harbour   tip_StrToHtml hbtip.lib hb_oemtoansi() HB_ansitooem()
*+    GRVVAL()   -->numero para strzero sem . //muitos layout de exportacao nao usam separadores . , centesimal decimal
*+    CAPFIRS2() Capitalizar corrigindo palavras  como de ou e os ...
*+    TIRAOUT()  remove .:/-
*+    CHOR()     100/60 decimal para base 60 minutos
*+    BHOR()     60/100 base 60 para decimal
*+    Strval( xdado, nLEN, nDEC, cSEPDEC )  converte variaval para string 
*+    ctohora() converte carater HH:MM numerico hh.mm
*+    geotodec(cVAL,cHEM) convert posicao geo para decimal
*+    calcgeokm(lat1,lon1,lat2,lon2,unit)     calcula distancia dois pontos
*+    deg2rad() grau para radiano
*+    rad2deg() radiano para grau
*+    lastday      =DAY(EOM()) CA-TOOLS/HARBOUR  Retorna o numero do ultimo dia do mes para qualquer data.
*+    DTOF         =EOM()      CA-TOOLS/HARBOUR  Determina o primeiro dia do mes a partir de um valor de data.
*+    DTOL         =BOM()      CA-TOOLS/HARBOUR  Determina o ultimo dia do mes a partir de um valor de data.
*+    SEMANAANO    =WEEK()     CA-TOOLS/HARBOUR  retorna a semana do ano
*+    ANO_BISSEXTO =ISLEAP()   CA-TOOLS/HARBOUR  retorna falso ou verdadeiro
*+    convansi( ctexto )   =hb_oemtoansi() win_oemtoansi
*+    convoem( ctexto )    =HB_ansitooem() win_ANSIToOEM
*+    StrLogic(cVAL,lDEFAULT) convert text to logical 
*+    Logic2Str(lValor,cFORMATO)   convert logical to text
*+    aconvertend() matriz com os tipos de endereco rua avenida...
*+    MinutoToHora( horas )
*+    SonumeroX(cInString,lPONTO,lVIRGULA)
*+
*+  added new .prg functions to mange date and timestamp values:
*+      HB_DATETIME() -> <tTimeStamp>
*+      HB_CTOD( <cDate> [, <cDateFormat> ] ) -> <dDate>
*+      HB_DTOC( <dDate> [, <cDateFormat> ] ) -> <cDate>
*+      HB_NTOT( <nValue> ) -> <tTimeStamp>
*+      HB_TTON( <tTimeStamp> ) -> <nValue>
*+      HB_TTOC( <tTimeStamp>, [ <cDateFormat> ] [, <cTimeFormat> ] ) ->      <cTimeStamp>
*+      HB_CTOT( <cTimeStamp>, [ <cDateFormat> ] [, <cTimeFormat> ] ) ->        <tTimeStamp>
*+      HB_TTOS( <tTimeStamp> ) -> <cYYYYMMDDHHMMSSFFF>
*+      HB_STOT( <cDateTime> ) -> <tTimeStamp>
*+         <cDateTime> should be in one of the above form:
*+            - "YYYYMMDDHHMMSSFFF"
*+            - "YYYYMMDDHHMMSSFF"
*+            - "YYYYMMDDHHMMSSF"
*+            - "YYYYMMDDHHMMSS"
*+            - "YYYYMMDDHHMM"
*+            - "YYYYMMDDHH"
*+            - "YYYYMMDD"
*+            - "HHMMSSFFF"
*+            - "HHMMSSF"
*+            - "HHMMSS"
*+            - "HHMM"
*+            - "HH"
*+         Important is number of digits.
*+      HB_TSTOSTR( <tTimeStamp> ) -> <cTimeStamp> // YYYY-MM-DD HH:MM:SS.fff
*+      HB_STRTOTS( <cTimeStamp> ) -> <tTimeStamp>
*+         <cTimeStamp> should be in one of the above form:
*+            YYYY-MM-DD [H[H][:M[M][:S[S][.f[f[f[f]]]]]]] [PM|AM]
*+            YYYY-MM-DDT[H[H][:M[M][:S[S][.f[f[f[f]]]]]]] [PM|AM]
*+         The folowing characters can be used as date delimiters: "-", "/", "."
*+         T - is literal "T" - it's for XML timestamp format
*+         if PM or AM is used HH is in range < 1 : 12 > otherwise
*+         in range < 0 : 23 >
*+      HB_HOUR( <tTimeStamp> ) -> <nHour>
*+      HB_MINUTE( <tTimeStamp> ) -> <nMinute>
*+      HB_SEC( <tTimeStamp> ) -> <nSeconds>   // with milliseconds
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí

*+ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
*+
*+    Function convansi()
*+
*+ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
*+
functiOn convansi( ctexto )
if valtype( cTEXTO ) # "C"
   retu cTEXTO
endif
cTEXTO := win_oemtoansi(cTEXTO) //hb_oemtoansi(cTEXTO)
return cTEXTO

*+ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
*+
*+    Function convoem()
*+
*+ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
*+
function convoem( ctexto )

if valtype( cTEXTO ) # "C"
   retu cTEXTO
endif
cTEXTO := win_ansitooem(cTEXTO)  //HB_ansitooem(cTEXTO)
return cTEXTO
 

*+ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
*+
*+    Function str2html(cStr, lAnsi, loem )
*+
*+ðððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð
*+
FUNCTION str2html( cStr, lAnsi, loem )
IF VALTYPE(lANSI)<>"L"
  lAnsi:=.F.
ENDIF
IF VALTYPE(loem)<>"L"
  loem:=.T.
ENDIF
IF lansi
  cSTR:=win_oemtoansi(cSTR)    //AnsiToHtml( cSTR)
endif  
if loem
  cSTR:=win_ANSIToOEM(cSTR)   //OemToHtml( cSTR)
endif
cSTR:=tip_StrToHtml(cSTR)
return cSTR

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function CAPFIRS2()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function CAPFIRS2( string )
local ret_string := ''
ret_string:= TOKENUPPER(lower(string))
ret_string:= strtran(ret_string , " Em ", " em " )
ret_string:= strtran(ret_string , " Da ", " da " )
ret_string:= strtran(ret_string , " De ", " de " )
ret_string:= strtran(ret_string , " Do ", " do " )
ret_string:= strtran(ret_string , " Das ", " das " )
ret_string:= strtran(ret_string , " Des ", " des " )
ret_string:= strtran(ret_string , " Dos ", " dos " )
ret_string:= strtran(ret_string , " Para ", " para " )
ret_string:= strtran(ret_string , " Por ", " por " )
ret_string:= strtran(ret_string , " A ", " a " )
ret_string:= strtran(ret_string , " E ", " e " )
ret_string:= strtran(ret_string , " O ", " o " )
ret_string:= strtran(ret_string , " Ou ", " ou " )
ret_string:= strtran(ret_string , " Com ", " com " )
string:=ret_string //Caso passar @como parametro
return ret_string

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function SonumeroX(cInString,lPONTO,lVIRGULA)
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+

FUNCTION SonumeroX(cInString,lPONTO,lVIRGULA)
local nIter,cThisLetter
local nLenString := LEN(cInString)
local cOutValue := ''
local cCompString:='0123456789'
IF VALTYPE(cInString)<>"C"
   cInString:=STRVAL(cInString)
ENDIF
IF VALTYPE(lPONTO)="L"
   if lPONTO
      cCompString+="."
   endif	  
ENDIF
IF VALTYPE(lVIRGULA)="L"
   if lVIRGULA
      cCompString+=","
   ENDIF	  
ENDIF
for nIter = 1 TO nLenString
  cThisLetter := SUBST(cInString,nIter,1)
  IF cThisLetter$cCOMPSTRING 
    cOutValue += cThisLetter
  ENDIF
NEXT
RETURN cOutValue


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function TIRAOUT()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function TIRAOUT( TEXTO )
texto := strtran( texto, ".", "" )
texto := strtran( texto, ":", "" )
texto := strtran( texto, "-", "" )
texto := strtran( texto, "/", "" )
return texto


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function GRVVAL()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function GRVVAL( nVAL, nTAM, nDEC )
local cVAR := ""
cVAR := strzero( nVAL, nTAM + 1, nDEC )                     //mAIS 1 por causa do ponto
cVAR := strtran( cVAR, ".", "" )
return cVAR

*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function data2STR(dData,cFOR,cSEP,cDIG) retorna uma data formatada
*+    cFOR= DMA AMD MDA DMY YMD MDY ADM YDM SQL DMY/4 DMY2 DMY4 DMY-4 
*+    cSEP = /-.              (compatibilidade usar formato 5 digitos DMY/4)
*+    cDIG 2 ou 4             (compatibilidade usar formato 5 digitos) 
*+    30/12/2O22 Inclusao MYS MYSQL 2000-12-01 e DHZ 2000-12-01  00:00:00
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function data2str(dData,cFOR,cSEP,cDIG,cINI,cFIM)
local cDIA := cMES := cANO := cRETU := ""
IF VALTYPE(dDATA)<>"D" .AND. VALTYPE(dDATA)<>"T"
   cDIA := "00"
   cMES := "00"
   cANO := "0000"
ELSE
   cDIA := strzero( day( dDATA ), 2 )
   cMES := strzero( month( dDATA ), 2 )
   cANO := strzero( year( dDATA ), 4 )
ENDIF   
IF VALTYPE(cFOR)#"C"
   cFOR:="DMA"
ENDIF
IF AT("AAAA",cFOR)>0
   cDIG:="4"
   cFOR:=STRTRAN(cFOR,"AAAA","Y")
ENDIF
IF AT("YYYY",cFOR)>0
   cDIG:="4"   
   cFOR:=STRTRAN(cFOR,"YYYY","Y")
ENDIF
IF AT("AA",cFOR)>0
   cDIG:="2"
   cFOR:=STRTRAN(cFOR,"AA","Y")
ENDIF
IF AT("YY",cFOR)>0
   cDIG:="2" 
   cFOR:=STRTRAN(cFOR,"YY","Y")
ENDIF
IF AT("MM",cFOR)>0   
   cFOR:=STRTRAN(cFOR,"MM","M")
ENDIF
IF AT("DD",cFOR)>0
   cFOR:=STRTRAN(cFOR,"DD","D")
ENDIF
IF AT("A",cFOR)>0 //troca ano(A) para (Y)year padrao funcoes harbour
   cFOR:=STRTRAN(cFOR,"A","Y")
ENDIF
IF LEN(cFOR)=5 // FFFSD EX: DMY/4
   cSEP:=SUBSTR(cFOR,4,1)
   CDIG:=SUBSTR(cFOR,5,1)
   cFOR:=SUBSTR(cFOR,1,3)
ENDIF
IF VALTYPE(cSEP)#"C" //passar "" se nao quiser separador
   cSEP:="/"
ENDIF
IF VALTYPE(cDIG)#"C"
   cDIG:="4"
ENDIF
cSEP:=ALLTRIM(cSEP) //espaco vira vazio

IF VALTYPE(cINI)#"C"
   cINI:=""
ENDIF

IF VALTYPE(cINI)#"C"
  cFIM:=""
ENDIF

IF cFOR="NDL"  // ''yyyymmdd
   cDIG:="4"
   cFOR:="YMD"
ENDIF

IF cFOR="NDC"  // 'yymmdd
   cDIG:="2"
   cFOR:="YMD"
ENDIF

IF cFOR="ASPAS"  // "'" & Year(dDATA) & "/" & Month(dDATA) & "/" & Day(dDATA) & "'"
   cINI:="'"
   cCEP :="/"
   cDIG:="4"
   cFOR:="YMD"
   cFIM:="'"
ENDIF

IF cFOR="ACESSS"  //"#" & Year(dDATA) & "/" & Month(dDATA) & "/" & Day(dDATA) & "#"
   cINI:="#"
   cCEP := "/"
   cDIG:="4"
   cFOR:="YMD"
   cFIM:="#"
ENDIF

IF cFOR="CRYSTAL"  .OR. cFOR="DATE(,"  //"DATE(" & Year(dDATA) & "," & Month(dDATA) & "," & Day(dDATA) & ")"
   cINI:="DATE("
   cFIM:=")" 
   cCEP := ","
   cDIG:="4"
   cFOR:="YMD"
ENDIF

IF cFOR="DATESERIAL"  // DateSerial(1969, 2, 12)    ' Return a date.
   cINI:="DATESERIAL("
   cFIM:=")" 
   cCEP := ","
   cDIG:="4"
   cFOR:="YMD"
ENDIF

IF cFOR="CRYSTALX"  .OR. cFOR="CDATE(," //"CDATE(" & Year(dDATA) & "," & Month(dDATA) & "," & Day(dDATA) & ")"
   cINI:="CDATE("
   cFIM:=")"
   cCEP := ","
   cDIG:="4"
   cFOR:="YMD"
ENDIF

IF cFOR="MYSQL"  .OR. cFOR="MYSQL/" //"'" & Year(dDATA) & "/" & Month(dDATA) & "/" & Day(dDATA) & "'"
   cINI := "'"
   cFIM := "'"
   cCEP := "/"
   cDIG:="4"
   cFOR:="YMD"
ENDIF

IF cFOR="MYSQL-"  //"'" & Year(dDATA) & "-" & Month(dDATA) & "-" & Day(dDATA) & "'"
   cINI := "'"
   cFIM := "'"
   cCEP := "-"
   cDIG:="4"
   cFOR:="YMD"
ENDIF
IF cFOR="ORACLE" .OR. cFOR="TO_DATE" //to_date('" + Format(dDATA, "dd/mm/yyyy") + "','DD/MM/YYYY')
   cINI:="to_date('"
   cFIM:="','DD/MM/YYYY')"
   cCEP := "/"
   cDIG:="4"
   cFOR:="DMY"
ENDIF
IF cFOR="SQL" .OR. cFOR="103" //convert(datetime, '" + DTOC(dDATA)+ "', 103)"
   cINI:="convert(datetime, ''"
   cFIM:="', 103)"
   cCEP := "/"
   cDIG:="4"
   cFOR:="DMY"
ENDIF
IF cFOR="SQL" .OR. cFOR="103" //convert(datetime, '" + DTOC(dDATA)+ "', 103)"    //date
   cINI:="convert(datetime, ''"
   cFIM:="', 103)"
   cCEP := "/"
   cDIG:="4"
   cFOR:="DMY"
ENDIF
IF cFOR="SQLSERVER" .OR. cFOR="102" //CONVERT(datetime, '" + Format(DateValue(dDATA), "yyyy-mm-dd") + "', 102)     //datetime
   cINI:="convert(datetime, ''"
   cFIM:="', 102)"
   cCEP := "-"
   cDIG:="4"
   cFOR:="DMY"
ENDIF

IF cSEP = "2" // Ano 2 digitos passado na quarta posicao DMY2
   cSEP:=""
   cANO:= right( cANO, 2 )
ENDIF
IF cSEP = "4" // Ano 4 digitos passado na quarta posicao DMY4
   cSEP:=""
   cANO:= right( cANO, 4 )
ENDIF


IF ! EMPTY(cINI)
   cRETU:=cINI
ENDIF

DO CASE
  CASE cFOR="MYS"
        cRETU:=StrZero( Year( dDATA ), 4 ) + "-" + StrZero( Month( dDATA ), 2 ) + "-" + StrZero( Day( dDATA ), 2 ) 
        IF cRETU == "0000-00-00"
           cRETU := "NULL"
           cFIM  :=  ""
        ENDIF 
    CASE cFOR="DHZ"
        cRETU+=StrZero( Year( dDATA ), 4 ) + "-" + StrZero( Month( dDATA ), 2 ) + "-" + StrZero( Day( dDATA ), 2 ) + " 00:00:00"     
 //  CASE cFOR="SQL" acima
 //       cRETU:="convert(datetime, '" + DTOC(dDATA)+ "', 103)"
   CASE cFOR="DMY"
        cRETU+=cDIA+cSEP+cMES+cSEP+cANO
   CASE cFOR="YMD"
        cRETU+=cANO+cSEP+cMES+cSEP+cDIA
   CASE cFOR="MDY"
        cRETU+=cMES+cSEP+cDIA+cSEP+cANO
   CASE cFOR="YDM"
        cRETU+=cANO+cSEP+cDIA+cSEP+cMES
   CASE cFOR="MY"        
        cRETU+=cMES+cSEP+cANO
   CASE cFOR="YM"        
        cRETU+=cANO+cSEP+cMES
   CASE cFOR="YD"        
        cRETU+=cANO+cSEP+cDIA
   CASE cFOR="DY"        
        cRETU+=cDIA+cSEP+cANO        
   CASE cFOR="DM"
        cRETU+=cDIA+cSEP+cMES
   CASE cFOR="MD"
        cRETU+=cMES+cSEP+cDIA        
   CASE cFOR="Y"        
        cRETU+=cANO
   CASE cFOR="M"
        cRETU+=cMES
   CASE cFOR="D"
        cRETU+=cDIA        
   OTHERWISE //DMY
        cRETU+=cDIA+cSEP+cMES+cSEP+cANO
END CASE

IF ! EMPTY(cFIM)  //inicia e fecha com # abaixo
   cRETU+=cFIM
ENDIF

RETURN cRETU

*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function  str2data(cDATA,cFOR,cSEP,cDIG)
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function str2data(cDATA,cFOR,cSEP,cDIG)
local cDIA,cMES,cANO
LOCAL dDATA := CTOD(SPACE(8)) 
LOCAL nLENANO:=4

//padrao para o case abaixo
IF VALTYPE(cFOR)#"C"
   cFOR:="DMA"
ENDIF
IF cFOR="DMY"
   cFOR:="DMA"
ENDIF
IF VALTYPE(cSEP)#"C"
   cSEP:=""
ENDIF
IF VALTYPE(cDIG)="N"
   cDIG:=STRZERO(cDIG,1)
ENDIF
IF VALTYPE(cDIG)#"C"
   cDIG:=""
ENDIF
IF LEN(cFOR)=5 // FFFSD EX: DMY/4
   CDIG:=SUBSTR(cFOR,5,1)
   cSEP:=SUBSTR(cFOR,4,1)
   cFOR:=SUBSTR(cFOR,1,3)
ENDIF
cSEP:=ALLTRIM(cSEP) //espaco vira vazio
IF cSEP = "2" .OR.cSEP = "4"  // Ano 2 4 digitos passado na quarta posicao
   cDIG:= cSEP
ENDIF
nLENANO:=VAL(cDIG)
IF nLENANO=0
   nLENANO:=4
ENDIF
IF VALTYPE(cSEP)="C"
   cDATA:=STRTRAN(cDATA,cSEP,"")
ENDIF
DO CASE
   CASE cFOR="AMD" .OR. cFOR="YMD"
        cANO:=SUBSTR(cDATA,1,nLENANO)
        cMES:=SUBSTR(cDATA,nLENANO+1,2)
        cDIA:=SUBSTR(cDATA,nLENANO+3)
   CASE cFOR="MDA".OR.cFOR="MDY"
        cMES:=SUBSTR(cDATA,1,2)
        cDIA:=SUBSTR(cDATA,3,2)       
        cANO:=SUBSTR(cDATA,5)
   CASE cFOR="ADM".OR.cFOR="YDM"   
        cANO:=SUBSTR(cDATA,1,nLENANO)
        cDIA:=SUBSTR(cDATA,nLENANO+1,2)
        cMES:=SUBSTR(cDATA,nLENANO+3)   
   OTHERWISE   //"DMA" //DMY //Padrao acima
        cDIA:=SUBSTR(cDATA,1,2)
        cMES:=SUBSTR(cDATA,3,2)       
        cANO:=SUBSTR(cDATA,5)        
END CASE
IF VAL(cDIA)>0.AND.VAL(cMES)>0.AND.vAL(cANO)>0
   IF VAL(cDIA)>0.AND.VAL(cDIA)<32
      IF VAL(cMES)>0.AND.VAL(cMES)<13
         cDATA:=cDIA+"/"+cMES+"/"+cANO
         dDATA:=CTOD(cDATA)
      ENDIF
   ENDIF
ENDIF
RETURN dDATA




*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function  DifDatas(dDataInicial,dDataFinal)
*+    retorna quantidade de ano/mes/dias
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
    Function DifDatas(dDataInicial,dDataFinal)
    v_dia:=v_mes:=v_ano:=0
    v_anof=YEAR(dDataFinal)
    v_mesf=MONTH(dDataFinal)
    v_diaf=DAY(dDataFinal)
    v_anoi=YEAR(dDataInicial)
    v_mesi=MONTH(dDataInicial)
    v_diai=DAY(dDataInicial)
    IF v_diaf < v_diai
      v_diaf+=30
      v_mesf-=1
    ENDIF
    v_dia=v_diaf - v_diai
    IF v_mesf < v_mesi
      v_mesf+=12
      v_anof-=1
    ENDIF
    v_mes=v_mesf - v_mesi
    v_ano=v_anof - v_anoi
    v_ret=''
    IF v_ano>0
      v_ret=STRZERO(v_ano,2)+IF(v_ano=1,' ano',' anos')+IF(v_mes>0,IF(v_dia>0,',',' e '),IF(v_dia>0,' e ',''))
    ENDIF
    IF v_mes>0
      v_ret+=STRZERO(v_mes,2)+IF(v_mes=1,' mes ',' meses ')+IF(v_dia>0,'e ','')
    ENDIF
    IF v_dia>0
      v_ret+=STRZERO(v_dia,2)+IF(v_dia=1,' dia',' dias')
    ENDIF
    Return (v_ret)


*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function DIGADATA() retorna uma data formatada
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function DIGADATA( dDATA, nDIA, nMES, nANO, cSEP )

local cDIA := cMES := cANO := cRETU := ""
cDIA := strzero( day( dDATA ), 2 )
cMES := strzero( month( dDATA ), 2 )
cANO := strzero( year( dDATA ), 4 )
do case
  case nDIA = 1 //dia DD
     cRETU += cDIA + cSEP
  case nDIA = 2 //Seg  01
     cRETU += left( CDIA( dDATA ), 3 ) + cSEP + cDIA + cSEP
  case nDIA = 3 //segunda 01
     cRETU += CDIA( dDATA ) + cSEP + cDIA + cSEP
endcase
do case
  case nMES = 1 //mes NN
     cRETU += cMES + cSEP
  case nMES = 2 //mes CCC jan,fev...
     cRETU += left( CMES( dDATA ), 3 ) + cSEP
  case nMES = 3 //mes estenso janeiro,fevereito
     cRETU += CMES( dDATA ) + cSEP
endcase
do case
  case nANO = 1 //Ano 2 digitos
     cRETU += right( cANO, 2 )
  case nANO = 2 //Ano 4 digitos
     cRETU += cANO
endcase
return cRETU

*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function Cmes() // VEM DATA RETORNA MES POR EXTENSO
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function Cmes( ddata )
retorno := Mmes( month( ddata ) )
return retorno

*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function Mmes()  VEM O NUMERO DO MES , RETORNA MES POR EXTENSO
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function Mmes( nmes )

if nmes < 1 .or. nmes > 12
   retu "Erro MES"
endif
return ( { "Janeiro", "Fevereiro", "Marco", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro" } [nMES] )

*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function Cdia()  VEM A DATA , RETORNA DIA POR EXTENSO
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function Cdia( ddata )

retorno := Ddia( dow( ddata ) )
return retorno

*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function Ddia()  VEM NUMERO DIA , RETORNA DIA POR EXTENSO
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
function Ddia( ndia )

if ndia < 1 .or. ndia > 7
   retu "Erro DIA"
endif
return ( { "Domingo", "Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado" } [nDIA] )


*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function ctohora()
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
FUNCtion CTOHORA(cHORA AS STRING)
cHORA:=Left(cHORA,5) //Evita hora com milesimos de segundo mm:ss:dd
cHORA:=StrTran(cHORA,":",".")
cHORA:=StrTran(cHORA,":",".")
RETUrn Val(Chora)


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function StrLogic()
*+
*+   30/12/2O22 Incluso opçoes Y N e 0 1 e T F
*+ 
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function StrLogic(cVAL,lDEFAULT)
IF VALTYPE(lDEFAULT)<>"L"
   lDEFAULT:=.F.
ENDIF
SWITCH Upper( cVal )
      CASE ".T."
      CASE "TRUE"
      CASE "YES"
      CASE "SIM"
      CASE "ON"
      CASE "Y"
      CASE "1"  
      CASE "T"   
      CASE "S"        
         RETURN .T.
      CASE ".F."
      CASE "FALSE"
      CASE "NO"
      CASE "NAO"
      CASE "OFF"
      CASE "N"
      CASE "0"    
      CASE "F"   
      CASE "<NULL>"
      CASE "NULL"
      CASE "NUL"
      CASE "NIL"
         RETURN .F.
ENDSWITCH
RETURN lDEFAULT


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function Logic2Str(lValor,cFORMATO)
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function Logic2Str(lValor,cFORMATO)
LOCAL cRETURN AS STRING
IF VALTYPE(lVALOR)<>"L"
   lVALOR:=.F.
ENDIF
IF VALTYPE(cFORMATO)<>"C"
   cFORMATO:="" //escolhe otherwise SIM NAO
ENDIF
cFORMATO:=ALLTRIM(cFORMATO)
cRETURN:=""
DO CASE 
   CASE cFORMATO=".T."
        cRETURN:=IF(lVALOR,".T.",".F.")
  CASE cFORMATO="TRUE"
        cRETURN:=IF(lVALOR,"TRUE","FALSE")
  CASE cFORMATO="YES"
        cRETURN:=IF(lVALOR,"YES","NO")
  CASE cFORMATO="SIM"
        cRETURN:=IF(lVALOR,"SIM","NAO")                
  CASE cFORMATO="ON"
        cRETURN:=IF(lVALOR,"ON","OFF")
  CASE cFORMATO="Y"
        cRETURN:=IF(lVALOR,"Y","N")
  CASE cFORMATO="1"
        cRETURN:=IF(lVALOR,"1","0")
  CASE cFORMATO="T"
        cRETURN:=IF(lVALOR,"T","F")       
  OTHERWISE
      cRETURN:=IF(lVALOR,"SIM","NAO")                          
ENDCASE
RETURN cRETURN


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function Strval()
*+    cSEPDEC Numero .,
*+    cSEPDEC DATA   DMY/4 formatos veja data2str
*+    cSEPDEC LOGIC formatos  veja logic2srt
*+
*+    30/12/2022 utiliza logic2srt para logic
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function Strval( xdado, nLEN, nDEC, cSEPDEC,lESPACO ) 
local retval := "",i,cVALTYPE
if valtype(lESPACO)#"L"
   lESPACO:=.F.   
endif
cVALTYPE:=valtype( xdado )
do case
    case Cvaltype = "C" 
         retval := xdado
    CASE Cvaltype = "M" 
         retval := hb_StrToExp( xDADO )
    case Cvaltype = "A"
         retval :=HB_VALTOEXP(xDADO)
         if VALTYPE(cSEPDEC)="C"
            if cSEPDEC<>","
               retval:=strtran(retval,",",cSEPDEC)
            endif
            retval:=strtran(retval,"{","")
            retval:=strtran(retval,"}","")
         endif        
    case cvaltype = "B" .or. cvaltype = "O".or. cvaltype = "S" .or. cvaltype = "H"  
         retval := HB_VALTOEXP(xDADO)
    case cvaltype = "T"
         retval :=hb_TStoSTR(xDADO)
         IF VALTYPE(cSEPDEC)="C"
            i:=AT(" ",retval)            
            retval:=data2str(stod(strtran(substr(retval,1,i-1),"-","")),cSEPDEC)+" "+substr(retval,i+1,8)
         ENDIF   
    case cvaltype = "D"
         IF VALTYPE(cSEPDEC)="C"
            retval := data2str(xdado,cSEPDEC)
         ELSE
            retval := dtoc( xdado )
         ENDIF
    case cvaltype = "N"
         do case
         case valtype( nLEN ) = "N" .and. valtype( nDEC ) = "N"
            retval := str( xdado, nLEN, nDEC )
         case valtype( nLEN ) = "N"
            retval := str( xdado, nLEN )
         otherwise
            retval := hb_NToS( xdado )
         endcase
         IF VALTYPE(cSEPDEC)="C" //troca separador decimal . por outro como ,
            if cSEPDEC<>"." //se for ponto nada faz
               retval:=strtran(retval,".",cSEPDEC)
            ENDIF
         ENDIF
    case cvaltype = "L"
       retval := Logic2Str(xdado,cSEPDEC)   //if( xdado, "Sim", "Nao" )
    otherwise
       do case
         case xDADO == NIL
             cVal := "NIL"
        case cvaltype = "U"
             retval :="<NULL>"
         otherwise
             retval := HB_VALTOEXP(xDADO)
       endcase   
endcase
IF lESPACO
   retval:=alltrim(retval)
ENDIF
return ( retval )



*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function CHOR()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function CHOR
para QTHOR
QT1 := int( QTHOR )
QT2 := QTHOR - QT1
QT3 := QT2 * 10 / 6
return ( QT1 + QT3 )

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function BHOR()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function BHOR
para QTHOR
QT1 := int( QTHOR )
QT2 := QTHOR - QT1
QT3 := round( QT2 * 6 / 10, 2 )
return ( QT1 + QT3 )


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function geotodec(cVAL,cHEM) convert posicao geo para decimal
*+                      posicao, hemisferio
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function geotodec(cVAL,cHEM)
LOCAL nVAL
nVAL:=VAL(substr(cVAL,1,2))
nVAL+=VAL(SUBSTR(cVAL,3,2))/60
nVAL+=VAL(SUBSTR(cVAL,5,2))/3600
nVAL+=VAL(SUBSTR(cVAL,7,2))/216000
if cHEM="S" //Hemisferio sul coordenada negativas
   nVAL*=-1
ENDIF
RETURN nVAL

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function calcgeokm() calcula distancia dois ponto
*+    exemplo  SP/RIO calcgeokm(geotodec("23325413","S"),geotodec("46380889","S"),geotodec("22541197","S"),geotodec("43122893","S")) ~=357KM
*+    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)
*+   lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)
*+    unit = the unit you desire for results
*+          where: 'M' is statute miles
*+                 'K' is kilometers (default)
*+                 'N' is nautical miles
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function calcgeokm(lat1,lon1,lat2,lon2,unit)
if valtype(unit)#"C"
   UNIT:="K"
endif
theta = lon1 - lon2
dist = Sin(deg2rad(lat1)) * Sin(deg2rad(lat2)) + Cos(deg2rad(lat1)) * Cos(deg2rad(lat2)) * Cos(deg2rad(theta))
dist = Acos(dist)
dist = rad2deg(dist)
dist = dist * 60 * 1.1515
if unit = 'K'
    dist = dist * 1.609344
ENDIF
IF unit="N"
  dist = dist * 0.8684
endif
return dist

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function deg2rad()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function deg2rad(deg)
  return (deg * PI() / 180.0)

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function rad2deg()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function rad2deg(rad)
  return (rad / PI() * 180.0)




//FUNCTION HoraToMinuto( horas )
   // Transforma horas passadas no formato caracter em um numero
   // INTEIRO que representa o total de minutos do parametro passado
//   IF VALTYPE( horas ) = 'C'
      // HoraToMinuto( "194:20" ) = 11660 min
//      RETURN (VAL(SUBSTR(horas,1,AT(":",horas)-1))*60)+VAL(SUBSTR(horas,AT(":",horas)+1,2))
//   ELSE
      // HoraToMinuto( 194,20 ) = 11660 min
      //RETURN (VAL(SUBSTR(STR(horas,6,2),1,3))*60)+VAL(SUBSTR(STR(horas,6,2),5,2))
//   ENDIF

//FUNCTION HoraToNumero( horas )
   // Transforma horas passadas no formato caracter em um numero
   // DECIMAL que representa o total de minutos do parametro passado
//   IF VALTYPE( horas ) = 'C'
//      A := VAL(SUBSTR(horas,1,AT(":",horas)-1))*60+VAL(SUBSTR(horas,AT(":",horas)+1,2))
//   ELSE
//      A := VAL(SUBSTR(STR(horas,6,2),1,3))*60+VAL(SUBSTR(STR(horas,6,2),5,2))
//   ENDIF
//   RETURN VAL(STRZERO(INT(DIV(A,60)),3,0)+"."+STRZERO(MOD(A,60),2,0))

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function MinutoToHora( horas )
*+
*+   //MinutoToHora( "240:00" )
*+  devolve 14400 minutos
*+  MinutoToHora( "240:00" ) - MinutoToHora( "120:00" )
*+  devolve 7200 minutos
*+  Transforma minutos em horario
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+

FUNCTION MinutoToHora( horas )
RETURN INT(horas/60)+(MOD(horas,60)/100)


*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function aconvertend()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
FUNCTION aconvertend()
local aCNV:={}
AADD(aCNV,{"R ","R"})
AADD(aCNV,{"RU ","R"})
AADD(aCNV,{"R.","R"})
AADD(aCNV,{"R:","R"})
AADD(aCNV,{"RUA ","R"})
AADD(aCNV,{"RUA:","R"})
AADD(aCNV,{"AVENIDA ","AV"})
AADD(aCNV,{"TRAVESSA ","TV"})
AADD(aCNV,{"TRAVES ","TV"})
AADD(aCNV,{"TRAV ","TV"})
AADD(aCNV,{"TR ","TV"})
AADD(aCNV,{"TR.","TV"})
AADD(aCNV,{"ESTRADA ","EST"})
AADD(aCNV,{"EST.","EST"})
AADD(aCNV,{"E."  ,"EST"})
AADD(aCNV,{"EST ","EST"})
AADD(aCNV,{"VIELA ","VLA"})
AADD(aCNV,{"AV ","AV"})
AADD(aCNV,{"AV.","AV"})
AADD(aCNV,{"ALAMEDA ","AL"})
AADD(aCNV,{"AL.","AL"})
AADD(aCNV,{"AL ","AL"})
AADD(aCNV,{"RODOVIA ","ROD"})
AADD(aCNV,{"ROD ","ROD"})
AADD(aCNV,{"PRACA ","PC"})
AADD(aCNV,{"PCA ","PC"})
AADD(aCNV,{"ACESSO ","AC"})
AADD(aCNV,{"BECO ","BC"})
AADD(aCNV,{"CALCADA ","CALC"})
AADD(aCNV,{"VIADUTO","VD"})
AADD(aCNV,{"LADEIRA","LD"})
AADD(aCNV,{"PASSAGEM","PSG"})
RETURN aCNV