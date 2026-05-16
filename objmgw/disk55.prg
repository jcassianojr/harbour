// +--------------------------------------------------------------------
// +
// +    Programa  : disk55.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +--------------------------------------------------------------------
// +

// +íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
// +
// +    DISK55.PRG funcoes conversoes
// +
// +    DIGADATA() retorna uma data formatada
// +    Cmes()     VEM DATA RETORNA MES POR EXTENSO
// +    Mmes()     VEM O NUMERO DO MES , RETORNA MES POR EXTENSO
// +    Cdia()     VEM A DATA , RETORNA DIA POR EXTENSO
// +    Ddia()     VEM NUMERO DIA , RETORNA DIA POR EXTENSO
// +    data2STR(dData,cFOR,cSEP,cDIG) retorna uma data formatada
// +    DifDatas(dDataInicial,dDataFinal)   retorna quantidade de ano/mes/dias
// +    str2html(cStr, lAnsi, loem )  harbour   tip_StrToHtml hbtip.lib hb_oemtoansi() HB_ansitooem()
// +    GRVVAL()   -->numero para strzero sem . //muitos layout de exportacao nao usam separadores . , centesimal decimal
// +    CAPFIRS2() Capitalizar corrigindo palavras  como de ou e os ...
// +    TIRAOUT()  remove .:/-
// +    CHOR()     100/60 decimal para base 60 minutos
// +    BHOR()     60/100 base 60 para decimal
// +    Strval( xdado, nLEN, nDEC, cSEPDEC )  converte variaval para string
// +    ctohora() converte carater HH:MM numerico hh.mm
// +    geotodec(cVAL,cHEM) convert posicao geo para decimal
// +    calcgeokm(lat1,lon1,lat2,lon2,unit)     calcula distancia dois pontos
// +    deg2rad() grau para radiano
// +    rad2deg() radiano para grau
// +    lastday      =DAY(EOM()) CA-TOOLS/HARBOUR  Retorna o numero do ultimo dia do mes para qualquer data.
// +    DTOF         =EOM()      CA-TOOLS/HARBOUR  Determina o primeiro dia do mes a partir de um valor de data.
// +    DTOL         =BOM()      CA-TOOLS/HARBOUR  Determina o ultimo dia do mes a partir de um valor de data.
// +    SEMANAANO    =WEEK()     CA-TOOLS/HARBOUR  retorna a semana do ano
// +    ANO_BISSEXTO =ISLEAP()   CA-TOOLS/HARBOUR  retorna falso ou verdadeiro
// +    convansi( ctexto )   =hb_oemtoansi() win_oemtoansi
// +    convoem( ctexto )    =HB_ansitooem() win_ANSIToOEM
// +    StrLogic(cVAL,lDEFAULT) convert text to logical
// +    Logic2Str(lValor,cFORMATO)   convert logical to text
// +    aconvertend() matriz com os tipos de endereco rua avenida...
// +    MinutoToHora( horas )
// +    SonumeroX(cInString,lPONTO,lVIRGULA)
// +
// +  added new .prg functions to mange date and timestamp values:
// +      HB_DATETIME() -> <tTimeStamp>
// +      HB_CTOD( <cDate> [, <cDateFormat> ] ) -> <dDate>
// +      HB_DTOC( <dDate> [, <cDateFormat> ] ) -> <cDate>
// +      HB_NTOT( <nValue> ) -> <tTimeStamp>
// +      HB_TTON( <tTimeStamp> ) -> <nValue>
// +      HB_TTOC( <tTimeStamp>, [ <cDateFormat> ] [, <cTimeFormat> ] ) ->      <cTimeStamp>
// +      HB_CTOT( <cTimeStamp>, [ <cDateFormat> ] [, <cTimeFormat> ] ) ->        <tTimeStamp>
// +      HB_TTOS( <tTimeStamp> ) -> <cYYYYMMDDHHMMSSFFF>
// +      HB_STOT( <cDateTime> ) -> <tTimeStamp>
// +         <cDateTime> should be in one of the above form:
// +            - "YYYYMMDDHHMMSSFFF"
// +            - "YYYYMMDDHHMMSSFF"
// +            - "YYYYMMDDHHMMSSF"
// +            - "YYYYMMDDHHMMSS"
// +            - "YYYYMMDDHHMM"
// +            - "YYYYMMDDHH"
// +            - "YYYYMMDD"
// +            - "HHMMSSFFF"
// +            - "HHMMSSF"
// +            - "HHMMSS"
// +            - "HHMM"
// +            - "HH"
// +         Important is number of digits.
// +      HB_TSTOSTR( <tTimeStamp> ) -> <cTimeStamp> // YYYY-MM-DD HH:MM:SS.fff
// +      HB_STRTOTS( <cTimeStamp> ) -> <tTimeStamp>
// +         <cTimeStamp> should be in one of the above form:
// +            YYYY-MM-DD [H[H][:M[M][:S[S][.f[f[f[f]]]]]]] [PM|AM]
// +            YYYY-MM-DDT[H[H][:M[M][:S[S][.f[f[f[f]]]]]]] [PM|AM]
// +         The folowing characters can be used as date delimiters: "-", "/", "."
// +         T - is literal "T" - it's for XML timestamp format
// +         if PM or AM is used HH is in range < 1 : 12 > otherwise
// +         in range < 0 : 23 >
// +      HB_HOUR( <tTimeStamp> ) -> <nHour>
// +      HB_MINUTE( <tTimeStamp> ) -> <nMinute>
// +      HB_SEC( <tTimeStamp> ) -> <nSeconds>   // with milliseconds
// +
// +íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí


// +--------------------------------------------------------------------
// +
// +    Function convansi()
// +
// +--------------------------------------------------------------------
// +
FUNCTION convansi( ctexto )

   IF ValType( cTEXTO ) # "C"
      RETU cTEXTO
   ENDIF
   cTEXTO := win_oemtoansi( cTEXTO )   // hb_oemtoansi(cTEXTO)

   RETURN cTEXTO


// +--------------------------------------------------------------------
// +
// +    Function convoem()
// +
// +--------------------------------------------------------------------
// +
FUNCTION convoem( ctexto )

   IF ValType( cTEXTO ) # "C"
      RETU cTEXTO
   ENDIF
   cTEXTO := win_ansitooem( cTEXTO )   // HB_ansitooem(cTEXTO)

   RETURN cTEXTO


// +--------------------------------------------------------------------
// +
// +    Function str2html(cStr, lAnsi, loem)
// +
// +--------------------------------------------------------------------
// +
FUNCTION str2html( cStr, lAnsi, loem )

   IF ValType( lANSI ) <> "L"
      lAnsi := .F.
   ENDIF
   IF ValType( loem ) <> "L"
      loem := .T.
   ENDIF
   IF lansi
      cSTR := win_oemtoansi( cSTR )  // AnsiToHtml( cSTR)
   ENDIF
   IF loem
      cSTR := win_ANSIToOEM( cSTR )  // OemToHtml( cSTR)
   ENDIF
   cSTR := tip_StrToHtml( cSTR )

   RETURN cSTR

// +--------------------------------------------------------------------
// +
// +    Function CAPFIRS2()
// +
// +--------------------------------------------------------------------
// +
FUNCTION CAPFIRS2( string )

   LOCAL ret_string := ''

   ret_string := TOKENUPPER( Lower( string ) )
   ret_string := StrTran( ret_string, " Em ", " em " )
   ret_string := StrTran( ret_string, " Da ", " da " )
   ret_string := StrTran( ret_string, " De ", " de " )
   ret_string := StrTran( ret_string, " Do ", " do " )
   ret_string := StrTran( ret_string, " Das ", " das " )
   ret_string := StrTran( ret_string, " Des ", " des " )
   ret_string := StrTran( ret_string, " Dos ", " dos " )
   ret_string := StrTran( ret_string, " Para ", " para " )
   ret_string := StrTran( ret_string, " Por ", " por " )
   ret_string := StrTran( ret_string, " A ", " a " )
   ret_string := StrTran( ret_string, " E ", " e " )
   ret_string := StrTran( ret_string, " O ", " o " )
   ret_string := StrTran( ret_string, " Ou ", " ou " )
   ret_string := StrTran( ret_string, " Com ", " com " )
   string     := ret_string  // Caso passar @como parametro

   RETURN ret_string

// +--------------------------------------------------------------------
// +
// +    Function SonumeroX(cInString,lPONTO,lVIRGULA)
// +
// +--------------------------------------------------------------------
// +
FUNCTION SonumeroX( cInString, lPONTO, lVIRGULA )

   LOCAL nIter, cThisLetter
   LOCAL nLenString  := Len( cInString )
   LOCAL cOutValue   := ''
   LOCAL cCompString := '0123456789'

   IF ValType( cInString ) <> "C"
      cInString := STRVAL( cInString )
   ENDIF
   IF ValType( lPONTO ) = "L"
      IF lPONTO
         cCompString += "."
      ENDIF
   ENDIF
   IF ValType( lVIRGULA ) = "L"
      IF lVIRGULA
         cCompString += ","
      ENDIF
   ENDIF
   FOR nIter := 1 TO nLenString
      cThisLetter := SUBST( cInString, nIter, 1 )
      IF cThisLetter $ cCOMPSTRING
         cOutValue += cThisLetter
      ENDIF
   NEXT

   RETURN cOutValue


// +--------------------------------------------------------------------
// +
// +    Function TIRAOUT()
// +
// +--------------------------------------------------------------------
// +
FUNCTION TIRAOUT( TEXTO )

   texto := StrTran( texto, ".", "" )
   texto := StrTran( texto, ":", "" )
   texto := StrTran( texto, "-", "" )
   texto := StrTran( texto, "/", "" )

   RETURN texto



// +--------------------------------------------------------------------
// +
// +    Function GRVVAL()
// +
// +--------------------------------------------------------------------
// +
FUNCTION GRVVAL( nVAL, nTAM, nDEC )

   LOCAL cVAR := ""

   cVAR := StrZero( nVAL, nTAM + 1, nDEC )   // mAIS 1 por causa do ponto
   cVAR := StrTran( cVAR, ".", "" )

   RETURN cVAR

// +--------------------------------------------------------------------
// +
// +    Function data2STR(dData,cFOR,cSEP,cDIG) retorna uma data formatada
// +    cFOR= DMA AMD MDA DMY YMD MDY ADM YDM SQL DMY/4 DMY2 DMY4 DMY-4
// +    cSEP = /-.              (compatibilidade usar formato 5 digitos DMY/4)
// +    cDIG 2 ou 4             (compatibilidade usar formato 5 digitos)
// +    30/12/2O22 Inclusao MYS MYSQL 2000-12-01 e DHZ 2000-12-01  00:00:00
// +
// +--------------------------------------------------------------------
// +

FUNCTION data2str( dData, cFOR, cSEP, cDIG, cINI, cFIM )

   LOCAL cDIA    := cMES := cANO := cRETU := ""
   LOCAL cFORINI

    dDATA := UniversalToDate( dDATA )
	
   IF ValType( dDATA ) <> "D" .AND. ValType( dDATA ) <> "T"
      cDIA := "00"
      cMES := "00"
      cANO := "0000"
   ELSE
      cDIA := StrZero( Day( dDATA ), 2 )
      cMES := StrZero( Month( dDATA ), 2 )
      cANO := StrZero( Year( dDATA ), 4 )
   ENDIF
   IF ValType( cFOR ) # "C"
      cFOR := "DMA"
   ENDIF
   cFOR    := AllTrim( cFOR )  // remove espacos para comparar corretamente
   cFORINI := cFOR   // guarda o inicial se precisar correcoes como o mysql data em branco para null
   IF At( "AAAA", cFOR ) > 0
      cDIG := "4"
      cFOR := StrTran( cFOR, "AAAA", "Y" )
   ENDIF
   IF At( "YYYY", cFOR ) > 0
      cDIG := "4"
      cFOR := StrTran( cFOR, "YYYY", "Y" )
   ENDIF
   IF At( "AA", cFOR ) > 0
      cDIG := "2"
      cFOR := StrTran( cFOR, "AA", "Y" )
   ENDIF
   IF At( "YY", cFOR ) > 0
      cDIG := "2"
      cFOR := StrTran( cFOR, "YY", "Y" )
   ENDIF
   IF At( "MM", cFOR ) > 0
      cFOR := StrTran( cFOR, "MM", "M" )
   ENDIF
   IF At( "DD", cFOR ) > 0
      cFOR := StrTran( cFOR, "DD", "D" )
   ENDIF
   IF At( "A", cFOR ) > 0   // troca ano(A) para (Y)year padrao funcoes harbour
      cFOR := StrTran( cFOR, "A", "Y" )
   ENDIF
   IF Len( cFOR ) = 5  // FFFSD EX: DMY/4
      cSEP := SubStr( cFOR, 4, 1 )
      CDIG := SubStr( cFOR, 5, 1 )
      cFOR := SubStr( cFOR, 1, 3 )
   ENDIF
   IF ValType( cSEP ) # "C"  // passar "" se nao quiser separador
      cSEP := "/"
   ENDIF
   IF ValType( cDIG ) # "C"
      cDIG := "4"
   ENDIF
   cSEP := AllTrim( cSEP )   // espaco vira vazio

   IF ValType( cINI ) # "C"
      cINI := ""
   ENDIF

   IF ValType( cINI ) # "C"
      cFIM := ""
   ENDIF

   IF cFOR = "NDL"   // ''yyyymmdd
      cDIG := "4"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "NDC"   // 'yymmdd
      cDIG := "2"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "ASPAS"   // "'" & Year(dDATA) & "/" & Month(dDATA) & "/" & Day(dDATA) & "'"
      cINI := "'"
      cCEP := "/"
      cDIG := "4"
      cFOR := "YMD"
      cFIM := "'"
   ENDIF

   IF cFOR = "ACESSS"  // "#" & Year(dDATA) & "/" & Month(dDATA) & "/" & Day(dDATA) & "#"
      cINI := "#"
      cCEP := "/"
      cDIG := "4"
      cFOR := "YMD"
      cFIM := "#"
   ENDIF

   IF cFOR = "CRYSTAL" .OR. cFOR = "DATE(,"  // "DATE(" & Year(dDATA) & "," & Month(dDATA) & "," & Day(dDATA) & ")"
      cINI := "DATE("
      cFIM := ")"
      cCEP := ","
      cDIG := "4"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "DATESERIAL"  // DateSerial(1969, 2, 12)    ' Return a date.
      cINI := "DATESERIAL("
      cFIM := ")"
      cCEP := ","
      cDIG := "4"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "CRYSTALX" .OR. cFOR = "CDATE(,"  // "CDATE(" & Year(dDATA) & "," & Month(dDATA) & "," & Day(dDATA) & ")"
      cINI := "CDATE("
      cFIM := ")"
      cCEP := ","
      cDIG := "4"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "MYSQL-" .OR. cFOR = "SQLITE"   // "'" & Year(dDATA) & "-" & Month(dDATA) & "-" & Day(dDATA) & "'"  YYYY-MM-DD
      cINI := "'"
      cFIM := "'"
      cCEP := "-"
      cDIG := "4"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "MYSQL" .OR. cFOR = "MYSQL/"  // "'" & Year(dDATA) & "/" & Month(dDATA) & "/" & Day(dDATA) & "'"
      cINI := "'"
      cFIM := "'"
      cCEP := "/"
      cDIG := "4"
      cFOR := "YMD"
   ENDIF

   IF cFOR = "ORACLE" .OR. cFOR = "TO_DATE"  // to_date('" + Format(dDATA, "dd/mm/yyyy") + "','DD/MM/YYYY')
      cINI := "to_date('"
      cFIM := "','DD/MM/YYYY')"
      cCEP := "/"
      cDIG := "4"
      cFOR := "DMY"
   ENDIF

   IF cFOR = "MSSQL" .OR. cFOR = "SQL" .OR. cFOR = "103"   // convert(datetime, '" + DTOC(dDATA)+ "', 103)"
      cINI := "convert(datetime, ''"
      cFIM := "', 103)"
      cCEP := "/"
      cDIG := "4"
      cFOR := "DMY"
   ENDIF

   IF cFOR = "SQLSERVER" .OR. cFOR = "102"   // CONVERT(datetime, '" + Format(DateValue(dDATA), "yyyy-mm-dd") + "', 102)     //datetime
      cINI := "convert(datetime, ''"
      cFIM := "', 102)"
      cCEP := "-"
      cDIG := "4"
      cFOR := "DMY"
   ENDIF

   IF cSEP = "2"   // Ano 2 digitos passado na quarta posicao DMY2
      cSEP := ""
      cANO := Right( cANO, 2 )
   ENDIF
   IF cSEP = "4"   // Ano 4 digitos passado na quarta posicao DMY4
      cSEP := ""
      cANO := Right( cANO, 4 )
   ENDIF


   IF !Empty( cINI )
      cRETU := cINI
   ENDIF

   DO CASE
   CASE cFOR = "MYS"
      cRETU := StrZero( Year( dDATA ), 4 ) + "-" + StrZero( Month( dDATA ), 2 ) + "-" + StrZero( Day( dDATA ), 2 )
      IF cRETU == "0000-00-00"
         cRETU := "NULL"
         cFIM  := ""
      ENDIF
   CASE cFOR = "DHZ"
      cRETU += StrZero( Year( dDATA ), 4 ) + "-" + StrZero( Month( dDATA ), 2 ) + "-" + StrZero( Day( dDATA ), 2 ) + " 00:00:00"
      // CASE cFOR="SQL" acima
      // cRETU:="convert(datetime, '" + DTOC(dDATA)+ "', 103)"
   CASE cFOR = "DMY"
      cRETU += cDIA + cSEP + cMES + cSEP + cANO
   CASE cFOR = "YMD"
      cRETU += cANO + cSEP + cMES + cSEP + cDIA
   CASE cFOR = "MDY"
      cRETU += cMES + cSEP + cDIA + cSEP + cANO
   CASE cFOR = "YDM"
      cRETU += cANO + cSEP + cDIA + cSEP + cMES
   CASE cFOR = "MY"
      cRETU += cMES + cSEP + cANO
   CASE cFOR = "YM"
      cRETU += cANO + cSEP + cMES
   CASE cFOR = "YD"
      cRETU += cANO + cSEP + cDIA
   CASE cFOR = "DY"
      cRETU += cDIA + cSEP + cANO
   CASE cFOR = "DM"
      cRETU += cDIA + cSEP + cMES
   CASE cFOR = "MD"
      cRETU += cMES + cSEP + cDIA
   CASE cFOR = "Y"
      cRETU += cANO
   CASE cFOR = "M"
      cRETU += cMES
   CASE cFOR = "D"
      cRETU += cDIA
   OTHERWISE   // DMY
      cRETU += cDIA + cSEP + cMES + cSEP + cANO
   END CASE


   IF cFORINI = "MYSQL" .OR. cFORINI = "MYSQL/" .OR. cFORINI = "MYSQL-"
      IF StrZero( Year( dDATA ), 4 ) + "-" + StrZero( Month( dDATA ), 2 ) + "-" + StrZero( Day( dDATA ), 2 ) == "0000-00-00"
         cRETU := "NULL"
         cFIM  := ""
      ENDIF
   ENDIF

   IF !Empty( cFIM )   // inicia e fecha com # abaixo
      cRETU += cFIM
   ENDIF

   RETURN cRETU


// +--------------------------------------------------------------------
// +
// +    Function str2data(cDATA,cFOR,cSEP,cDIG)
// +
// +--------------------------------------------------------------------
// +
FUNCTION str2data( cDATA, cFOR, cSEP, cDIG )

   LOCAL cDIA, cMES, cANO
   LOCAL dDATA   := CToD( Space( 8 ) )
   LOCAL nLENANO := 4

// padrao para o case abaixo
   IF ValType( cFOR ) # "C"
      cFOR := "DMA"
   ENDIF
   IF cFOR = "DMY"
      cFOR := "DMA"
   ENDIF
   IF ValType( cSEP ) # "C"
      cSEP := ""
   ENDIF
   IF ValType( cDIG ) = "N"
      cDIG := StrZero( cDIG, 1 )
   ENDIF
   IF ValType( cDIG ) # "C"
      cDIG := ""
   ENDIF
   IF Len( cFOR ) = 5  // FFFSD EX: DMY/4
      CDIG := SubStr( cFOR, 5, 1 )
      cSEP := SubStr( cFOR, 4, 1 )
      cFOR := SubStr( cFOR, 1, 3 )
   ENDIF
   cSEP := AllTrim( cSEP )   // espaco vira vazio
   IF cSEP = "2" .OR. cSEP = "4"   // Ano 2 4 digitos passado na quarta posicao
      cDIG := cSEP
   ENDIF
   nLENANO := Val( cDIG )
   IF nLENANO = 0
      nLENANO := 4
   ENDIF
   IF ValType( cSEP ) = "C"
      cDATA := StrTran( cDATA, cSEP, "" )
   ENDIF
   DO CASE
   CASE cFOR = "AMD" .OR. cFOR = "YMD"
      cANO := SubStr( cDATA, 1, nLENANO )
      cMES := SubStr( cDATA, nLENANO + 1, 2 )
      cDIA := SubStr( cDATA, nLENANO + 3 )
   CASE cFOR = "MDA" .OR. cFOR = "MDY"
      cMES := SubStr( cDATA, 1, 2 )
      cDIA := SubStr( cDATA, 3, 2 )
      cANO := SubStr( cDATA, 5 )
   CASE cFOR = "ADM" .OR. cFOR = "YDM"
      cANO := SubStr( cDATA, 1, nLENANO )
      cDIA := SubStr( cDATA, nLENANO + 1, 2 )
      cMES := SubStr( cDATA, nLENANO + 3 )
   OTHERWISE   // "DMA" //DMY //Padrao acima
      cDIA := SubStr( cDATA, 1, 2 )
      cMES := SubStr( cDATA, 3, 2 )
      cANO := SubStr( cDATA, 5 )
   END CASE
   IF Val( cDIA ) > 0 .AND. Val( cMES ) > 0 .AND. Val( cANO ) > 0
      IF Val( cDIA ) > 0 .AND. Val( cDIA ) < 32
         IF Val( cMES ) > 0 .AND. Val( cMES ) < 13
            cDATA := cDIA + "/" + cMES + "/" + cANO
            dDATA := CToD( cDATA )
         ENDIF
      ENDIF
   ENDIF

   RETURN dDATA




// +--------------------------------------------------------------------
// +
// +    Function DifDatas((dDataInicial,dDataFinal)
// +    etorna quantidade de ano/mes/dias
// +
// +--------------------------------------------------------------------
// +
FUNCTION DifDatas( dDataInicial, dDataFinal )

   dDataInicial := UniversalToDate( dDataInicial )
   dDataFinal   := UniversalToDate( dDataFinal )

   v_dia  := v_mes := v_ano := 0
   v_anof := Year( dDataFinal )
   v_mesf := Month( dDataFinal )
   v_diaf := Day( dDataFinal )
   v_anoi := Year( dDataInicial )
   v_mesi := Month( dDataInicial )
   v_diai := Day( dDataInicial )
   IF v_diaf < v_diai
      v_diaf += 30
      v_mesf -= 1
   ENDIF
   v_dia := v_diaf - v_diai
   IF v_mesf < v_mesi
      v_mesf += 12
      v_anof -= 1
   ENDIF
   v_mes := v_mesf - v_mesi
   v_ano := v_anof - v_anoi
   v_ret := ''
   IF v_ano > 0
      v_ret := StrZero( v_ano, 2 ) + IF( v_ano = 1, ' ano', ' anos' ) + IF( v_mes > 0, IF( v_dia > 0, ',', ' e ' ), IF( v_dia > 0, ' e ', '' ) )
   ENDIF
   IF v_mes > 0
      v_ret += StrZero( v_mes, 2 ) + IF( v_mes = 1, ' mes ', ' meses ' ) + IF( v_dia > 0, 'e ', '' )
   ENDIF
   IF v_dia > 0
      v_ret += StrZero( v_dia, 2 ) + IF( v_dia = 1, ' dia', ' dias' )
   ENDIF

   RETURN ( v_ret )



// +--------------------------------------------------------------------
// +
// +    Function DIGADATA(dDATA, nDIA, nMES, nANO, cSEP) retorna uma data formatada
// +
// +--------------------------------------------------------------------
// +
FUNCTION DIGADATA( dDATA, nDIA, nMES, nANO, cSEP )

   LOCAL cDIA := cMES := cANO := cRETU := ""

   dDATA := UniversalToDate( dDATA )
   cDIA := StrZero( Day( dDATA ), 2 )
   cMES := StrZero( Month( dDATA ), 2 )
   cANO := StrZero( Year( dDATA ), 4 )
   DO CASE
   CASE nDIA = 1   // dia DD
      cRETU += cDIA + cSEP
   CASE nDIA = 2   // Seg  01
      cRETU += Left( CDIA( dDATA ), 3 ) + cSEP + cDIA + cSEP
   CASE nDIA = 3   // segunda 01
      cRETU += CDIA( dDATA ) + cSEP + cDIA + cSEP
   ENDCASE
   DO CASE
   CASE nMES = 1   // mes NN
      cRETU += cMES + cSEP
   CASE nMES = 2   // mes CCC jan,fev...
      cRETU += Left( CMES( dDATA ), 3 ) + cSEP
   CASE nMES = 3   // mes estenso janeiro,fevereito
      cRETU += CMES( dDATA ) + cSEP
   ENDCASE
   DO CASE
   CASE nANO = 1   // Ano 2 digitos
      cRETU += Right( cANO, 2 )
   CASE nANO = 2   // Ano 4 digitos
      cRETU += cANO
   ENDCASE

   RETURN cRETU


// +--------------------------------------------------------------------
// +
// +    Function Cmes()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Cmes( ddata )

   retorno := Mmes( Month( ddata ) )

   RETURN retorno

// +--------------------------------------------------------------------
// +
// +    Function Mmes()  VEM O NUMERO DO MES , RETORNA MES POR EXTENSO
// +
// +--------------------------------------------------------------------
// +
FUNCTION Mmes( nmes )

   IF nmes < 1 .OR. nmes > 12
      RETU "Erro MES"
   ENDIF

   RETURN ( { "Janeiro", "Fevereiro", "Marco", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro" }[ nMES ] )

// +--------------------------------------------------------------------
// +
// +    Function Cdia() VEM A DATA , RETORNA DIA POR EXTENSO
// +
// +--------------------------------------------------------------------
// +
FUNCTION Cdia( ddata )
    dDATA := UniversalToDate( dDATA )
   retorno := Ddia( DoW( ddata ) )

   RETURN retorno

// +--------------------------------------------------------------------
// +
// +    Function Ddia() VEM NUMERO DIA , RETORNA DIA POR EXTENSO
// +
// +--------------------------------------------------------------------
// +
FUNCTION Ddia( ndia )

   IF ndia < 1 .OR. ndia > 7
      RETU "Erro DIA"
   ENDIF

   RETURN ( { "Domingo", "Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado" }[ nDIA ] )


// +--------------------------------------------------------------------
// +
// +    Function CTOHORA()
// +
// +--------------------------------------------------------------------
// +
FUNCTION CTOHORA( cHORA AS STRING )

   cHORA := Left( cHORA, 5 )  // Evita hora com milesimos de segundo mm:ss:dd
   cHORA := StrTran( cHORA, ":", "." )
   cHORA := StrTran( cHORA, ":", "." )

   RETURN Val( Chora )



// +--------------------------------------------------------------------
// +
// +    Function StrLogic()
// +    30/12/2O22 Incluso opçoes Y N e 0 1 e T F
// +
// +--------------------------------------------------------------------
// +
FUNCTION StrLogic( cVAL, lDEFAULT )

   IF ValType( lDEFAULT ) <> "L"
      lDEFAULT := .F.
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


// +--------------------------------------------------------------------
// +
// +    Function Logic2Str(lValor,cFORMATO))
// +
// +--------------------------------------------------------------------
// +
FUNCTION Logic2Str( lValor, cFORMATO )

   LOCAL cRETURN AS STRING

   IF ValType( lVALOR ) <> "L"
      lVALOR := .F.
   ENDIF
   IF ValType( cFORMATO ) <> "C"
      cFORMATO := ""   // escolhe otherwise SIM NAO
   ENDIF
   cFORMATO := AllTrim( cFORMATO )
   cRETURN  := ""
   DO CASE
   CASE cFORMATO = ".T."
      cRETURN := IF( lVALOR, ".T.", ".F." )
   CASE cFORMATO = "TRUE"
      cRETURN := IF( lVALOR, "TRUE", "FALSE" )
   CASE cFORMATO = "YES"
      cRETURN := IF( lVALOR, "YES", "NO" )
   CASE cFORMATO = "SIM"
      cRETURN := IF( lVALOR, "SIM", "NAO" )
   CASE cFORMATO = "ON"
      cRETURN := IF( lVALOR, "ON", "OFF" )
   CASE cFORMATO = "Y"
      cRETURN := IF( lVALOR, "Y", "N" )
   CASE cFORMATO = "1"
      cRETURN := IF( lVALOR, "1", "0" )
   CASE cFORMATO = "T"
      cRETURN := IF( lVALOR, "T", "F" )
   OTHERWISE
      cRETURN := IF( lVALOR, "SIM", "NAO" )
   ENDCASE

   RETURN cRETURN


// +--------------------------------------------------------------------
// +
// +    Function Strval()
// +    cSEPDEC Numero .,
// +    cSEPDEC DATA   DMY/4 formatos veja data2str
// +    cSEPDEC LOGIC formatos  veja logic2srt
// +
// +    30/12/2022 utiliza logic2srt para logic
// +
// +--------------------------------------------------------------------
// +

FUNCTION Strval( xdado, nLEN, nDEC, cSEPDEC, lESPACO )

   LOCAL retval := "", i, cVALTYPE

   IF ValType( lESPACO ) # "L"
      lESPACO := .F.
   ENDIF
   cVALTYPE := ValType( xdado )
   DO CASE
   CASE Cvaltype = "C"
      retval := xdado
   CASE Cvaltype = "M"
      retval := hb_StrToExp( xDADO )
   CASE Cvaltype = "A"
      retval := hb_ValToExp( xDADO )
      IF ValType( cSEPDEC ) = "C"
         IF cSEPDEC <> ","
            retval := StrTran( retval, ",", cSEPDEC )
         ENDIF
         retval := StrTran( retval, "{", "" )
         retval := StrTran( retval, "}", "" )
      ENDIF
   CASE cvaltype = "B" .OR. cvaltype = "O" .OR. cvaltype = "S" .OR. cvaltype = "H"
      retval := hb_ValToExp( xDADO )
   CASE cvaltype = "T"
      retval := hb_TSToStr( xDADO )
      IF ValType( cSEPDEC ) = "C"
         i      := At( " ", retval )
         retval := data2str( SToD( StrTran( SubStr( retval, 1, i - 1 ), "-", "" ) ), cSEPDEC ) + " " + SubStr( retval, i + 1, 8 )
      ENDIF
   CASE cvaltype = "D"
      IF ValType( cSEPDEC ) = "C"
         retval := data2str( xdado, cSEPDEC )
      ELSE
         retval := DToC( xdado )
      ENDIF
   CASE cvaltype = "N"
      DO CASE
      CASE ValType( nLEN ) = "N" .AND. ValType( nDEC ) = "N"
         retval := Str( xdado, nLEN, nDEC )
      CASE ValType( nLEN ) = "N"
         retval := Str( xdado, nLEN )
      OTHERWISE
         retval := hb_ntos( xdado )
      ENDCASE
      IF ValType( cSEPDEC ) = "C"  // troca separador decimal . por outro como ,
         IF cSEPDEC <> "."   // se for ponto nada faz
            retval := StrTran( retval, ".", cSEPDEC )
         ENDIF
      ENDIF
   CASE cvaltype = "L"
      retval := Logic2Str( xdado, cSEPDEC )   // if( xdado, "Sim", "Nao" )
   OTHERWISE
      DO CASE
      CASE xDADO == NIL
         cVal := "NIL"
      CASE cvaltype = "U"
         retval := "<NULL>"
      OTHERWISE
         retval := hb_ValToExp( xDADO )
      ENDCASE
   ENDCASE
   IF lESPACO
      retval := AllTrim( retval )
   ENDIF

   RETURN ( retval )


// +--------------------------------------------------------------------
// +
// +    Function CHOR()
// +
// +--------------------------------------------------------------------
// +
FUNCTION CHOR

   PARA QTHOR

   QT1 := Int( QTHOR )
   QT2 := QTHOR - QT1
   QT3 := QT2 * 10 / 6

   RETURN ( QT1 + QT3 )

// +--------------------------------------------------------------------
// +
// +    Function BHOR()
// +
// +--------------------------------------------------------------------
// +
FUNCTION BHOR

   PARA QTHOR

   QT1 := Int( QTHOR )
   QT2 := QTHOR - QT1
   QT3 := Round( QT2 * 6 / 10, 2 )

   RETURN ( QT1 + QT3 )


// +--------------------------------------------------------------------
// +
// +    Function geotodec(cVAL,cHEM) convert posicao geo para decimal)
// +                      posicao, hemisferio 
// +
// +--------------------------------------------------------------------
// +
FUNCTION geotodec( cVAL, cHEM )

   LOCAL nVAL

   nVAL := Val( SubStr( cVAL, 1, 2 ) )
   nVAL += Val( SubStr( cVAL, 3, 2 ) ) / 60
   nVAL += Val( SubStr( cVAL, 5, 2 ) ) / 3600
   nVAL += Val( SubStr( cVAL, 7, 2 ) ) / 216000
   IF cHEM = "S"   // Hemisferio sul coordenada negativas
      nVAL *= -1
   ENDIF

   RETURN nVAL

// +--------------------------------------------------------------------
// +
// +    Function calcgeokm() calcula distancia dois ponto
// +    exemplo  SP/RIO calcgeokm(geotodec("23325413","S"),geotodec("46380889","S"),geotodec("22541197","S"),geotodec("43122893","S")) ~=357KM
// +    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)
// +   lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)
// +    unit = the unit you desire for results
// +          where: 'M' is statute miles
// +                 'K' is kilometers (default)
// +                 'N' is nautical miles
// +
// +--------------------------------------------------------------------
// +

FUNCTION calcgeokm( lat1, lon1, lat2, lon2, unit )

   IF ValType( unit ) # "C"
      UNIT := "K"
   ENDIF
   theta := lon1 - lon2
   dist  := Sin( deg2rad( lat1 ) ) * Sin( deg2rad( lat2 ) ) + Cos( deg2rad( lat1 ) ) * Cos( deg2rad( lat2 ) ) * Cos( deg2rad( theta ) )
   dist  := Acos( dist )
   dist  := rad2deg( dist )
   dist  := dist * 60 * 1.1515
   IF unit = 'K'
      dist := dist * 1.609344
   ENDIF
   IF unit = "N"
      dist := dist * 0.8684
   ENDIF

   RETURN dist

// +--------------------------------------------------------------------
// +
// +    Function deg2rad()
// +
// +--------------------------------------------------------------------
// +
FUNCTION deg2rad( deg )

   RETURN ( deg * PI() / 180.0 )

// +--------------------------------------------------------------------
// +
// +    Function rad2deg()
// +
// +--------------------------------------------------------------------
// +
FUNCTION rad2deg( rad )

   RETURN ( rad / PI() * 180.0 )




// FUNCTION HoraToMinuto( horas )
// Transforma horas passadas no formato caracter em um numero
// INTEIRO que representa o total de minutos do parametro passado
// IF VALTYPE( horas ) = 'C'
// HoraToMinuto( "194:20" ) = 11660 min
// RETURN (VAL(SUBSTR(horas,1,AT(":",horas)-1))*60)+VAL(SUBSTR(horas,AT(":",horas)+1,2))
// ELSE
// HoraToMinuto( 194,20 ) = 11660 min
// RETURN (VAL(SUBSTR(STR(horas,6,2),1,3))*60)+VAL(SUBSTR(STR(horas,6,2),5,2))
// ENDIF

// FUNCTION HoraToNumero( horas )
// Transforma horas passadas no formato caracter em um numero
// DECIMAL que representa o total de minutos do parametro passado
// IF VALTYPE( horas ) = 'C'
// A := VAL(SUBSTR(horas,1,AT(":",horas)-1))*60+VAL(SUBSTR(horas,AT(":",horas)+1,2))
// ELSE
// A := VAL(SUBSTR(STR(horas,6,2),1,3))*60+VAL(SUBSTR(STR(horas,6,2),5,2))
// ENDIF
// RETURN VAL(STRZERO(INT(DIV(A,60)),3,0)+"."+STRZERO(MOD(A,60),2,0))

// +¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
// +
// +    Function MinutoToHora( horas )
// +
// +   //MinutoToHora( "240:00" )
// +  devolve 14400 minutos
// +  MinutoToHora( "240:00" ) - MinutoToHora( "120:00" )
// +  devolve 7200 minutos
// +  Transforma minutos em horario
// +¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
// +


// +--------------------------------------------------------------------
// +
// +    Function MinutoToHora()
// +
// +--------------------------------------------------------------------
// +
FUNCTION MinutoToHora( horas )

   RETURN Int( horas / 60 ) + ( Mod( horas, 60 ) / 100 )


// +--------------------------------------------------------------------
// +
// +    Function aconvertend()
// +
// +--------------------------------------------------------------------
// +
FUNCTION aconvertend()

   LOCAL aCNV := {}

   AAdd( aCNV, { "R ", "R" } )
   AAdd( aCNV, { "RU ", "R" } )
   AAdd( aCNV, { "R.", "R" } )
   AAdd( aCNV, { "R:", "R" } )
   AAdd( aCNV, { "RUA ", "R" } )
   AAdd( aCNV, { "RUA:", "R" } )
   AAdd( aCNV, { "AVENIDA ", "AV" } )
   AAdd( aCNV, { "TRAVESSA ", "TV" } )
   AAdd( aCNV, { "TRAVES ", "TV" } )
   AAdd( aCNV, { "TRAV ", "TV" } )
   AAdd( aCNV, { "TR ", "TV" } )
   AAdd( aCNV, { "TR.", "TV" } )
   AAdd( aCNV, { "ESTRADA ", "EST" } )
   AAdd( aCNV, { "EST.", "EST" } )
   AAdd( aCNV, { "E.", "EST" } )
   AAdd( aCNV, { "EST ", "EST" } )
   AAdd( aCNV, { "VIELA ", "VLA" } )
   AAdd( aCNV, { "AV ", "AV" } )
   AAdd( aCNV, { "AV.", "AV" } )
   AAdd( aCNV, { "ALAMEDA ", "AL" } )
   AAdd( aCNV, { "AL.", "AL" } )
   AAdd( aCNV, { "AL ", "AL" } )
   AAdd( aCNV, { "RODOVIA ", "ROD" } )
   AAdd( aCNV, { "ROD ", "ROD" } )
   AAdd( aCNV, { "PRACA ", "PC" } )
   AAdd( aCNV, { "PCA ", "PC" } )
   AAdd( aCNV, { "ACESSO ", "AC" } )
   AAdd( aCNV, { "BECO ", "BC" } )
   AAdd( aCNV, { "CALCADA ", "CALC" } )
   AAdd( aCNV, { "VIADUTO", "VD" } )
   AAdd( aCNV, { "LADEIRA", "LD" } )
   AAdd( aCNV, { "PASSAGEM", "PSG" } )

   RETURN aCNV


// +--------------------------------------------------------------------
// +  Função: UniversalToDate()
// +  Objetivo: Garantir a leitura correta de datas em múltiplos formatos
// +            (DD/MM/YY, DD-MM-YYYY, DD.MM.YY, AAAAMMDD, YYYY-MM-DD)
// +--------------------------------------------------------------------
FUNCTION UniversalToDate( xData )

   LOCAL dResult := CToD( "" )
   LOCAL cFormatOrig := Set( _SET_DATEFORMAT, "dd/mm/yyyy" ) // Força padrão interno temporário
   LOCAL cData, cLimpa, nLen

   // 1. Se já for do tipo Data, retorna ela mesma
   IF ValType( xData ) == "D"
      Set( _SET_DATEFORMAT, cFormatOrig )
      RETURN xData
   ENDIF

   // 2. Se for nulo ou não for string, retorna data vazia
   IF ValType( xData ) <> "C" .OR. Empty( xData )
      Set( _SET_DATEFORMAT, cFormatOrig )
      RETURN dResult
   ENDIF

   cData := AllTrim( xData )

   // 3. Trata o formato ISO muito comum em bancos de dados (YYYY-MM-DD)
   //    Exemplo: "2026-05-16" vira "16/05/2026"
   IF Len( cData ) == 10 .AND. SubStr( cData, 5, 1 ) == "-" .AND. SubStr( cData, 8, 1 ) == "-"
      dResult := CToD( Right( cData, 2 ) + "/" + SubStr( cData, 6, 2 ) + "/" + Left( cData, 4 ) )
      Set( _SET_DATEFORMAT, cFormatOrig )
      RETURN dResult
   ENDIF

   // 4. Remove separadores comuns (barra, hífen, ponto) para analisar os números limpos
   cLimpa := StrTran( cData, "/", "" )
   cLimpa := StrTran( cLimpa, "-", "" )
   cLimpa := StrTran( cLimpa, ".", "" )
   cLimpa := AllTrim( cLimpa )
   nLen   := Len( cLimpa )

   // 5. Identifica o formato pelo tamanho da string limpa
   DO CASE
   CASE nLen == 8
      // Pode ser AAAAMMDD (DToS) ou DDMMYYYY
      // Testamos primeiro AAAAMMDD (onde os 4 primeiros caracteres são o ano, ex: > 1900)
      IF Val( Left( cLimpa, 4 ) ) > 1900
         dResult := CToD( SubStr( cLimpa, 7, 2 ) + "/" + SubStr( cLimpa, 5, 2 ) + "/" + Left( cLimpa, 4 ) )
      ELSE
         // Se não for, assume DDMMYYYY
         dResult := CToD( Left( cLimpa, 2 ) + "/" + SubStr( cLimpa, 3, 2 ) + "/" + Right( cLimpa, 4 ) )
      ENDIF

   CASE nLen == 6
      // Formato DDMMYY (Ano com 2 dígitos)
      // O Harbour trata o centenário automaticamente baseado no SET EPOCH (padrão geralmente 1950)
      dResult := CToD( Left( cLimpa, 2 ) + "/" + SubStr( cLimpa, 3, 2 ) + "/" + Right( cLimpa, 2 ) )

   OTHERWISE
      // Tentativa padrão caso caia em algo fora do comum
      dResult := CToD( cData )
   ENDCASE

   // Restaura o formato de data original do sistema
   Set( _SET_DATEFORMAT, cFormatOrig )

   RETURN dResult
// + EOF: disk55.prg
// +
