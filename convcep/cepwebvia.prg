/*
http://www.pctoledo.com.br/forum/viewtopic.php?f=39&t=17470&start=75#p118783
*/


/*  Msxml2.XMLHTTP.6.0 Msxml2.XMLHTTP.3.0
1. Microsoft XML, v 3.0.
2. Microsoft XML, v 4.0 (if you have installed MSXML 4.0 separately).
3. Microsoft XML, v 5.0 (if you have installed Office 2003 – 2007 which provides MSXML 5.0 for Microsoft Office Applications).
4. Microsoft XML, v 6.0 for latest versions of MS Office.
*/

#include "tshead.ch"

REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

FUNCTION Main()
PRIVATE  cCep, cBairro, cCidade, cEndereco, cUF, cID

   Set( _SET_CODEPAGE, "PTISO" )
   SetMode( 25, 80 )
   CLS    //necessario as vezes trava apos a mudanca para 25,80
   HB_IDLESTATE()
   rddsetdefault( "DBFCDX" )
	Set( _SET_OPTIMIZE, .t.)
	Set( _SET_DELETED, .t.)
	Set( _SET_SOFTSEEK, .t.)
	__SetCentury( .t. )
    Set( _SET_EPOCH, year( date() ) - 60 )
    Set( _SET_DATEFORMAT, "dd/mm/yyyy" )



nERRO:=0

if ! file("cepruaimp.dbf")
   alert("Falta cepruaimp.dbf")
   quit
endif
     
     
lRUAVAZIA:=MSGYESNO("Checar Ruas Em Branco")
lBAIRROVAZIO:=MSGYESNO("Checar Bairro em Branco")
lNOMECURTO:=MSGYESNO("Checar Ruas com nomes menores que 5 letras")   
lAPAGANAO:=MSGYESNO("Apaga Nao encontrado")
lCHECKVIACEP:=MSGYESNO("Usar viacep")
lCHECKAPICOR:=MSGYESNO("Usar apicor")
lCHECKREPVIR:=MSGYESNO("Usar RepVirtual")
lCHECKAPICEP:=MSGYESNO("Usar apicep")
lCHECKAPIAWE:=MSGYESNO("Usar apiAWE")
lGERACEPTXT:=MSGYESNO("Gerar ceps.csv")
lGERACEPRUA:=MSGYESNO("Gerar cepruaimp.csv ")

IF lGERACEPTXT
   nFILECEPS:=FCREATE("ceps.csv")
ENDIF

IF lGERACEPRUA
  nGRAVA:=FCREATE("cepruaimp.csv")
  cLINHA:="cep,ibge,rua,complemento,bairro,cidade,uf"+HB_OSNEWLINE()
  FWRITE(nGRAVA,cLINHA)
ENDIF  
  

IF FILE("cepruaimp.cdx")  //apaga o indice caso algum importador use outra chave para o index primario
   ferase("cepruaimp.cdx")
endif  
   
use cepruaimp new exclusive

dbRecall() //retorna os que nao achou na busca anterior pois uf cidade estao em branco e o cepruaimp deleta para tratativas
           // o web service tem limite diario de consultas assim nao busca novamente nao consumindo o web service
index on CEP tag cep


mArquivo := 'C*.dbf'
mListaArq := Directory(mArquivo)
nFIM:=LEN(mListaArq)   
For KK := 1 to LEN(mListaArq)
    cFILECEP:=lower(mListaArq[KK,1])
    cFILECEP:=strtran(cFILECEP,".dbf","")	
  
    IF cFILECEP<>"cepbai" .AND. cFILECEP<>"ceprua" .AND. cFILECEP<>"cidconv" .and. cFILECEP<>"cepruaimp" .and. cFILECEP<>"cepgeo" .and. cFILECEP<>"ce_f"
       dbusearea( .T., "DBFCDX", cFILECEP,, .F. )
       ordlistadd( cFILECEP)
       @ 23,00 say cFILECEP
       cFILTRO:=""
       cFILTRO+=IF(lRUAVAZIA    , " EMPTY(RUA) "                                            , "")
       cFILTRO+=IF(lBAIRROVAZIO , IF(EMPTY(cFILTRO),""," .OR. ") + " EMPTY(CHVBAI) "        , "")
       cFILTRO+=IF(lNOMECURTO   , IF(EMPTY(cFILTRO),""," .OR. ") + " LEN(ALLTRIM(RUA))<=5 " , "")
       SET FILTER TO &cFILTRO. //EMPTY(RUA) .or. empty(field->chvbai)
       ntotrec:=reccount()
       NRECUSO:=0
     
       dbgotop()
       while ! eof()
  		  nRECUSO++
  		  @ 24,00 say cFILECEP
  		  @ 24,10 SAY nTOTREC
  		  @ 24,20 SAY nRECUSO
    	  
  	      lTEMCEP:=.T. //marca true para nao apagar se consultra cep nao encontrar vira false
  		  cCEP:=field->cep
   
       
          
  		  dbselectar("cepruaimp")
          dbgotop()
  		  if ! dbseek(cCEP) //Ja pesquisado
  		     
  		  	 cBairro      :=""
  			 cCidade      :=""
  		 	 cEndereco    :=""
  		 	 cUF          :=""
             cIBGE        :=""
             cComplemento :=""
             cTIPORUA     :=""
             cDDD         :=""
             cLATITUDE    :=""
             cLONGITUDE   :=""
             
             lTEMCEP:=.F.
             
             if lCHECKAPICOR //correio web primeria busca
    		    ? '  CEPAPI:'+ cCEP
                ?
    		     ConsultaCep( cCep, @cBairro, @cCidade, @cEndereco, @cUF, @cId )
    			 IF ! empty(cEndereco+cBairro)
                    GRAVARUAIMP()
                    lTEMCEP:=.T.
    			 else
                    GRAVARUANAO('nao localizado web correio')
                 endif   
             endif  
           
             if lCHECKVIACEP //via cep web segunda busca
    		    ? '  CEPCOR:'+ cCEP  
                ?
           		oCep := cepWeb( cCEP )
    		    IF ! oCep == NIL
    			  cCIDADE      := oCep:cLocalidade
                  cENDERECO    := oCep:cLogradouro
                  cBAIRRO      := oCep:cBairro
                  cComplemento := oCep:cComplemento
                  cUF          := oCep:cUF
                  cIBGE        := oCep:cIBGE
                  GRAVARUAIMP()
                  lTEMCEP:=.T.
    		    else
                  GRAVARUANAO('nao localizado viacep')
                ENDIF
             endif 
             
             if lCHECKREPVIR
                ? '  CEPREP:'+ cCEP
                ?
                 CepRepublica(cCEP)
                 IF ! empty(cEndereco+cBairro)
                    GRAVARUAIMP()
                    lTEMCEP:=.T.
    			 else
                    GRAVARUANAO('nao localizado rep Virtual')
                 endif   
             ENDIF
             
             IF lCHECKAPICEP
                 ? '  APICEP:'+ cCEP
                ?
                 CepAPICEP(cCEP)
                 IF ! empty(cEndereco+cBairro)
                    GRAVARUAIMP()
                    lTEMCEP:=.T.
    			 else
                    GRAVARUANAO('nao localizado apicep')
                 endif   
             ENDIF
             
             IF lCHECKAPIAWE
                 ? '  APIAWE:'+ cCEP
                 ?
                 CepAPIAWE(cCEP)
                 IF ! empty(cEndereco+cBairro)
                    GRAVARUAIMP()
                    lTEMCEP:=.T.
    			 else
                    GRAVARUANAO('nao localizado apiAWE')
                 endif   
             ENDIF
             
             IF lGERACEPTXT .AND. lTEMCEP .AND. ! empty(cEndereco+cBairro)
                FWRITE(nFILECEPS,cCEP+HB_OSNEWLINE())
             ENDIF  
             
             
             IF lGERACEPRUA .AND. lTEMCEP  .AND. ! empty(cEndereco+cBairro)
                cLINHA:=cCEP+","+cIBGE+","+cENDERECO+","+cComplemento+","+cBairro+","+cCIDADE+","+LEFT(cUF,2)+HB_OSNEWLINE()
                FWRITE(nGRAVA,cLINHA)
             ENDIF          
                  
                  
  	      endif
  	      DBSELECTAR(cFILECEP)
          if lapaganao .and. ! lTEMCEP
             dbdelete()
          endif
    	  dbskip()		
       ENDDO
       DBSELECTAR(cFILECEP)
       dbclosearea()
    endif   
NEXT KK   

IF lGERACEPRUA
    FCLOSE(nGRAVA)
ENDIF    

IF lGERACEPTXT
   FCLOSE(nFILECEPS)
ENDIF

dbselectar("cepruaimp")
delete all for empty(rua).and.empty(bairro)
pack
dbcloseall()

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

FUNCTION GRAVARUANAO(cMENSAGEM)
? cMENSAGEM
?
dbselectar("cepruaimp") //grava para nao buscr online novamente
if ! dbseek(cCEP)
    dbappend()
    field->cep:=cCEP
    if ! empty(cCIDADE) .AND. ! EMPTY(cUF)
        field->cidade:=cCIDADE
        field->uf:=cUF
    endif
endif  
RETURN .T.

FUNCTION GRAVARUAIMP()
IF cENDERECO="ull,"  //alguns web service trazem null
   cENDERECO:=""
ENDIF
IF cBAIRRO="ull,"  //alguns web service trazem null
   cBAIRRO:=""
ENDIF
dbselectar("cepruaimp")
if ! dbseek(cCEP)
   dbappend()
   field->cep:=cCEP
endif
if empty(field->codibge)  .AND. ! EMPTY(cIBGE)
  field->codibge:=cIBGE 
endif
if empty(field->rua)   .AND. ! EMPTY(cENDERECO)
   field->rua:=cENDERECO
endif
if empty(field->obs)   .AND. ! EMPTY(cComplemento)
   field->obs:=cComplemento
endif
if empty(field->bairro)   .AND. ! EMPTY(cBairro)
  field->bairro:=cBairro
endif
if empty(field->cidade)   .AND. ! EMPTY(cCIDADE)
   field->cidade:=cCIDADE
endif
if empty(field->uf)  .AND. ! EMPTY(cUF)
   field->uf:=cUF
endif
if empty(field->tipo)  .AND. ! EMPTY(cTIPORUA)
   field->tipo:=cTIPORUA
endif

if empty(field->DDD)  .AND. ! EMPTY(cDDD)
   field->DDD:=cDDD
endif
if empty(field->LATITUDE)  .AND. ! EMPTY(cLATITUDE)
   field->LATITUDE:=cLATITUDE
endif
if empty(field->LONGITUDE)  .AND. ! EMPTY(cLONGITUDE)
   field->LONGITUDE:=cLONGITUDE
endif
RETURN .T.  
   
PROCEDURE CepRepublica(xCep)
   LOCAL oHttp, cXML
   LOCAL xRes, xResTxt, xUf, xCidade, xTipo, xEnde, xBairro, xRetorno := {}

   xCep := strtran(xCep,"-")
   oHttp:= TIpClientHttp():new( "http://cep.republicavirtual.com.br/web_cep.php?cep="+xCep+"&formato=xml" )
   IF ! oHttp:open()
	  Return .F.
   ENDIF
   inkey(.5)
   
   cXML := oHttp:readAll()
   oHttp:close()
   
   cXML := XmlTransform( cXML)
   
   IF Empty(cXML)
	  Return .F.
   ENDIF
      cBairro   := XmlNode( cXml, "bairro" )
      cCidade   := XmlNode( cXml, "cidade" )
      cEndereco := XmlNode( cXml, "logradouro" )
      cUF       := XmlNode( cXml, "uf" )
      cTIPORUA  := XmlNode( cXml, "tipo_logradouro" )
  
RETURN .T.  

   

STATIC FUNCTION ConsultaCep( cCep, cBairro, cCidade, cEndereco, cUF, cId )

   LOCAL cUrlWs := [https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente]
   LOCAL oSefaz

   WITH OBJECT oSefaz := SefazClass():New()
      :cSoapUrl := cUrlWs
      :cXmlSoap := SoapEnvelope( cCep )
      :MicrosoftXmlSoapPost()
      :cXmlRetorno := XmlTransform( :cXmlRetorno )
      cCep      := XmlNode( :cXmlRetorno, "cep" )
      cBairro   := XmlNode( :cXmlRetorno, "bairro" )
      cCidade   := XmlNode( :cXmlRetorno, "cidade" )
      cEndereco := XmlNode( :cXmlRetorno, "end" )
      cUF       := XmlNode( :cXmlRetorno, "uf" )
      cID       := XmlNode( :cXmlRetorno, "id" )
   ENDWITH
  // ? oSefaz:cXmlRetorno

   RETURN AT("CEP NAO ENCONTRADO",oSefaz:cXmlRetorno)=0
   //RETURN NIL

STATIC FUNCTION SoapEnvelope( cCEP )

   LOCAL cxMLSoap

   cxMLSoap := [<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">]
   cxMLSoap +=    [<soapenv:Header/>]
   cxMLSoap +=    [<soapenv:Body>]
   cxMLSoap +=       [<cli:consultaCEP>]
   //cxMLSoap +=          [<!--Optional:-->]
   cxMLSoap +=          [<cep>] + cCEP + [</cep>]
   cxMLSoap +=       [</cli:consultaCEP>]
   cxMLSoap +=    [</soapenv:Body>]
   cxMLSoap += [</soapenv:Envelope>]

   RETURN cxMLSoap

FUNCTION AppVersaoExe(); RETURN ""
FUNCTION AppUserName(); RETURN ""


function CEPapicEp(cCEP)
//https://cdn.apicep.com/file/apicep/06233-030.json //api necessita traco usado formatacep abaico
cURL:="https://cdn.apicep.com/file/apicep/"+formatacep(cCEP)+".json"
	oPg  := CreateObject("Msxml2.XMLHTTP.6.0")  //oPg  := CreateObject("Msxml2.XMLHTTP.3.0") atualizado para versao 6
	oPg:Open("GET",cUrl,.F.)
	oPg:Send()
	cXMl := oPg:ResponseBody
    //{"code":"06233-030","state":"SP","city":"Osasco","district":"Piratininga","address":"Rua Paula Rodrigues","status":200,"ok":true,"statusText":"ok"}
    cXMl := XmlTransform( cXMl)
    
    
    CUF          := pegnodojason(cXMl,'state":')
    cCIDADE      := pegnodojason(cXMl,'city":' )
    cBairro      := pegnodojason(cXMl,'district":')
    cENDERECO    := pegnodojason(cXMl,'address":')

    /*
    CUF          := SUBSTR( cXMl , AT( 'state":'   , cXML) + 8 )
    cCIDADE      := SUBSTR( cXMl , AT( 'city":'    , cXML) + 7 )
    cBairro      := SUBSTR( cXMl , AT( 'district":', cXML) + 11 ) 
    cENDERECO    := SUBSTR( cXMl , AT( 'address":' , cXML) + 10 )
    CUF          := SUBSTR( cUF       ,1, AT( '"'   , cUF)       -1 )
    CCIDADE      := SUBSTR( cCIDADE   ,1, AT( '"'   , cCIDADE)   -1 )
    CBAIRRO      := SUBSTR( cBAIRRO   ,1, AT( '"'   , cBAIRRO)   -1 )
    CENDERECO    := SUBSTR( cENDERECO ,1, AT( '"'   , cENDERECO) -1 )
    */
    
  //  hb_memowrit("c"+cCEP+".txt",cURL+HB_OSNEWLINE()+cXMl+HB_OSNEWLINE()+cENDERECO )
return .t.

function cepapiawe(cCEP)
//https://cep.awesomeapi.com.br/json/05424020
//https://cep.awesomeapi.com.br/xml/05424020
//https://cep.awesomeapi.com.br/05424020

cURL:="https://cep.awesomeapi.com.br/json/"+cCEP
	oPg  := CreateObject("Msxml2.XMLHTTP.6.0")  //oPg  := CreateObject("Msxml2.XMLHTTP.3.0") atualizado para versao 6
	oPg:Open("GET",cUrl,.F.)
	oPg:Send()
	cXMl := oPg:ResponseBody
    cXMl := XmlTransform( cXMl)
    
    IF AT("not_found",cXML)>0 .OR. AT("nao foi encontrado",cXML)>0 
       RETURN .F.
    ENDIF
   
// {"cep":"05424020","address_type":"Rua","address_name":"Professor Carlos Reis","address":"Rua Professor Carlos Reis","state":"SP",
// "district":"Pinheiros","lat":"-23.57021","lng":"-46.69685","city":"São Paulo","city_ibge":"3550308","ddd":"11"}
// disponiveis ddd latitude longitude
//                                    123456789012345   


    CUF          := pegnodojason(cXML,'state":')
    cCIDADE      := pegnodojason(cXML,'city":' )
    cBairro      := pegnodojason(cXML,'district":')
    cENDERECO    := pegnodojason(cXML,'address_name":')
    cTIPORUA     := pegnodojason(cXML,'address_type":')
    cIBGE        := pegnodojason(cXML,'city_ibge":')
    cDDD         := pegnodojason(cXML,'ddd":')
    cLATITUDE    := pegnodojason(cXML,'lat":')
    cLONGITUDE   := pegnodojason(cXML,'lng":')
     
     /*     
    CUF          := SUBSTR( cXMl , AT( 'state":'        , cXML) +  8 )
    cCIDADE      := SUBSTR( cXMl , AT( 'city":'         , cXML) +  7 )
    cBairro      := SUBSTR( cXMl , AT( 'district":'     , cXML) + 11 ) 
    cENDERECO    := SUBSTR( cXMl , AT( 'address_name":' , cXML) + 15 )
    cTIPORUA     := SUBSTR( cXMl , AT( 'address_type":' , cXML) + 15 )
    cIBGE        := SUBSTR( cXMl , AT( 'city_ibge":'    , cXML) + 12 )
    cDDD         := SUBSTR( cXMl , AT( 'ddd":'          , cXML) +  6 )
    CUF          := SUBSTR( cUF       ,1, AT( '"'   , cUF)       -1 )
    CCIDADE      := SUBSTR( cCIDADE   ,1, AT( '"'   , cCIDADE)   -1 )
    CBAIRRO      := SUBSTR( cBAIRRO   ,1, AT( '"'   , cBAIRRO)   -1 )
    CENDERECO    := SUBSTR( cENDERECO ,1, AT( '"'   , cENDERECO) -1 )
    cTIPORUA     := SUBSTR( cTIPORUA ,1,  AT( '"'   , cTIPORUA)  -1 )
    cIBGE        := SUBSTR( cIBGE     ,1, AT( '"'   , cIBGE)     -1 )  
    cDDD         := SUBSTR( cDDD      ,1, AT( '"'   , cDDD)      -1 )    
    */   

 //  hb_memowrit("c"+cCEP+".txt",cURL+HB_OSNEWLINE()+cXMl+HB_OSNEWLINE()+cENDERECO )
return .t.

function pegnodojason(cTEXTO,cNODO)
cTEXTO        := SUBSTR( cTEXTO , AT(cNODO, cTEXTO) +  LEN(cNODO)+1 )
CTEXTO        := SUBSTR( cTEXTO ,1, AT( '"'   , cTEXTO)  -1 )
//ALERT(cTEXTO)
RETURN cTEXTO


/*******************************************************************************
 *
 *  The engine of this is the contrib 'hbtip'
 *
 *  It uses the free service: ViaCEP (http://viacep.com.br)
 *
 */
FUNCTION cepWeb( cCEP)
   LOCAL oCEP := ViaCEP():New( cCEP )
RETURN oCEP


/* 
 *  ViaCEP Class
 */

#include 'hbclass.ch'

CREATE CLASS ViaCEP
   VAR oCep
   VAR cCep         INIT '' 
   VAR cIBGE        INIT '' 
   VAR cLogradouro  INIT '' 
   VAR cComplemento INIT '' 
   VAR cBairro      INIT '' 
   VAR cLocalidade  INIT '' 
   VAR cUF          INIT '' 
   VAR cDDD         INIT ''
   METHOD New( cCEP )
ENDCLASS

   
METHOD New( cCEP )

   IF nERRO>10
      ? 'Open erro >10'
      ?
      RETURN NIL
   ENDIF

   oHttp := TIPClientHTTP():new( "http://viacep.com.br/ws/" + cCEP + "/piped/" )

   IF ! oHttp:open()
     ? 'open erro'
     ? 
      nERRO++
	  RETURN NIL
   ENDIF

   cHtml := oHttp:readAll()
   oHttp:close()
   
	if empty(cHtml)
	   RETURN NIL
	endif
	cHtml := XmlTransform( cHtml)
	aHtml := hb_aTokens( cHtml, '|' )
	
	IF LEN( aHtml ) < 7
      RETURN NIL
   ENDIF
   
   //cep:01001-000|logradouro:Praça da Sé|complemento:lado ímpar|bairro:Sé|localidade:São Paulo|uf:SP|ibge:3550308|gia:1004|ddd:11|siafi:7107
   
   cCEP         := SUBSTR( aHtml[1], AT( ':', aHtml[1] ) + 1 )
   cLogradouro  := SUBSTR( aHtml[2], AT( ':', aHtml[2] ) + 1 )
   cComplemento := SUBSTR( aHtml[3], AT( ':', aHtml[3] ) + 1 )
   cBairro      := SUBSTR( aHtml[4], AT( ':', aHtml[4] ) + 1 )
   cLocalidade  := SUBSTR( aHtml[5], AT( ':', aHtml[5] ) + 1 )
   cUF          := SUBSTR( aHtml[6], AT( ':', aHtml[6] ) + 1 )
   cIBGE        := SUBSTR( aHtml[7], AT( ':', aHtml[7] ) + 1 )
   cDDD         := SUBSTR( aHtml[9], AT( ':', aHtml[9] ) + 1 )
   
   ::cCEP         := cCEP
   ::cLogradouro  := cLogradouro
   ::cComplemento := cComplemento
   ::cBairro      := cBairro
   ::cLocalidade  := cLocalidade
   ::cUF          := cUF
   ::cIBGE        := cIBGE
   ::cDDD         := cDDD
   
RETURN Self
  
  
