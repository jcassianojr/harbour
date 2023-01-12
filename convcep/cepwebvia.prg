/*
http://www.pctoledo.com.br/forum/viewtopic.php?f=39&t=17470&start=75#p118783
*/

REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

FUNCTION Main()
PRIVATE  cCep, cBairro, cCidade, cEndereco, cUF, cID

   Set( _SET_CODEPAGE, "PTISO" )
   SetMode( 25, 80 )
   CLS
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
lCHECKAPICEP:=MSGYESNO("Usar apicep")
lCHECKAPICOR:=MSGYESNO("Usar apicor")
lGERACEPTXT:=MSGYESNO("Gerar ceps.txt")
lGERACEPRUA:=MSGYESNO("Gerar cepruaimp.csv ")

IF lGERACEPTXT
   nFILECEPS:=FCREATE("ceps.txt")
ENDIF

IF lGERACEPRUA
  nGRAVA:=FCREATE("cepruaimp.csv")
  cLINHA:="cep,ibge,rua,complemento,bairro,cidade,uf"+HB_OSNEWLINE()
  FWRITE(nGRAVA,cLINHA)
ENDIF  
  
   
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
  
    IF cFILECEP<>"cepbai" .AND. cFILECEP<>"ceprua" .AND. cFILECEP<>"cidconv" .and. cFILECEP<>"cepruaimp"
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
  			 cId          :=""
             cIBGE        :=""
             cComplemento :=""
             Clogradouro  :=""
             
             lTEMCEP:=.F.
             
             if lCHECKAPICOR //correio web primeria busca
                ?
    		    ? '  CEPAPI:'+ cCEP
                ?
    		     ConsultaCep( cCep, @cBairro, @cCidade, @cEndereco, @cUF, @cId )
    			 IF ! empty(cEndereco+cBairro)
    				cCIDADE   :=UPPER(STRTRAN(CCIDADE,'"',""))
                    cENDERECO :=UPPER(cendereco)
                    cBAIRRO   :=UPPER(cBairro)
                    cUF       :=UPPER(cBairro)
                    GRAVARUAIMP()
                    lTEMCEP:=.T.
    			 else
                    GRAVARUANAO('nao localizado web correio')
                 endif   
             endif  
           
             if lCHECKAPICEP //via cep web segunda busca
                ?
    		    ? '  CEPCOR:'+ cCEP  
                ?        
           		oCep := cepWeb( cCEP )
    		    IF ! oCep == NIL
    			  cCIDADE      := UPPER(STRTRAN(oCep:cLocalidade,'"',""))
                  cENDERECO    := UPPER(oCep:cLogradouro)
                  cBAIRRO      := UPPER(oCep:cBairro)
                  cComplemento := UPPER(oCep:cComplemento)
                  cUF          := UPPER(oCep:cUF)
                  cIBGE        := oCep:cIBGE
                  GRAVARUAIMP()
                  lTEMCEP:=.T.
    		    else
                  GRAVARUANAO('nao localizado viacep')
                ENDIF
             endif 
             
             IF lGERACEPTXT .AND. lTEMCEP .AND. ! empty(cEndereco+cBairro)
                FWRITE(nFILECEPS,cCEP+HB_OSNEWLINE())
             ENDIF  
             
             
             IF lGERACEPRUA .AND. lTEMCEP  .AND. ! empty(cEndereco+cBairro)
                cLINHA:=cCEP+","+cIBGE+","+cENDERECO+","+cComplemento+","+cBairro+","+cCIDADE+","+cUF+HB_OSNEWLINE()
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

FUNCTION GRAVARUANAO(cMENSAGEM)
?
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
dbselectar("cepruaimp")
if ! dbseek(cCEP)
   dbappend()
   field->cep:=cCEP
endif
if empty(field->codibge)  
  field->codibge:=cIBGE 
endif
if empty(field->rua)   
   field->rua:=cENDERECO
endif
if empty(field->obs)   
   field->obs:=cComplemento
endif
if empty(field->bairro)   
  field->bairro:=cBairro
endif
if empty(field->cidade)   
   field->cidade:=cCIDADE
endif
if empty(field->uf)  
   field->uf:=cUF
endif

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
   ? oSefaz:cXmlRetorno

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


FUNCTION MsgYesNo( cText )

   LOCAL lValue

   lValue := wapi_MessageBox( wvgSetAppWindow():hWnd, cText, "Confirmacao", WIN_MB_YESNO + WIN_MB_ICONQUESTION + WIN_MB_DEFBUTTON2 )  == 6 //6=WIN_IDYES

   RETURN lValue


/*******************************************************************************
 *  This is the function and the class that it uses to work
 *  The engine of this is the contrib 'hbtip'
 *
 *  It uses the free service: ViaCEP (http://viacep.com.br)
 *  Visit the site to learn more
 * 
 *  Special thanks to Leandro and Franco for offering the free service!
 * 
 *  Thanks to Eric for the idea!
 *
 *
 *  Copyright (c) 2015 - Mario Wan Stadnik (Hazael)
 *  wanstadnik(at)gmail.com
 *
 *  Free to the public domain
 *
 *  
 *  To build:  HBMK2 Test_ViaCEP hbtip.hbc -gtwvt
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
      RETURN NIL
   ENDIF

   oHttp := TIPClientHTTP():new( "http://viacep.com.br/ws/" + cCEP + "/piped/" )

   IF ! oHttp:open()
     // alert('open erro')
     ? 'open erro'
      nERRO++
	  RETURN NIL
   ENDIF

   cHtml := oHttp:readAll()
   oHttp:close()
	//cHtml := HB_UTF8TOSTR( cHtml ) 
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
  
  
