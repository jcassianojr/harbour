/*
http://www.pctoledo.com.br/forum/viewtopic.php?f=39&t=17470&start=75#p118783
*/

REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

FUNCTION Main()

   LOCAL cCep, cBairro, cCidade, cEndereco, cUF, cID

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
/*
   CLS
   
 cCep := "03676080"
   ConsultaCep( cCep, @cBairro, @cCidade, @cEndereco, @cUF, @cId )

   ? cCep
   ? cBairro
   ? cCidade
   ? cEndereco
   ? cUF
   ? cId
   Inkey(0)
*/     
     
     
lRUAVAZIA:=MSGYESNO("Checar Ruas Em Branco")
lBAIRROVAZIO:=MSGYESNO("Checar Bairro em Branco")
lNOMECURTO:=MSGYESNO("Checar Ruas com nomes menores que 5 letras")   
lAPAGANAO:=MSGYESNO("Apaga Nao encontrado")
   
nGRAVA:=FCREATE("cepruaimp.csv")
cLINHA:="cep,rua,bairro,cidade,uf"+HB_OSNEWLINE()
FWRITE(nGRAVA,cLINHA)
   
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
  
    IF cFILECEP<>"cepbai" .AND. cFILECEP<>"cepRUA" .AND. cFILECEP<>"cidconv" .and. cFILECEP<>"cepruaimp"
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
  		     
  		  	 cBairro :=""
  			 cCidade  :=""
  		 	 cEndereco :=""
  		 	 cUF :=""
  			 cId :=""
  		  
             altd()
             //correio web primeria busca
  		     lTEMCEP:=ConsultaCep( cCep, @cBairro, @cCidade, @cEndereco, @cUF, @cId )
  			 
  			 IF ! empty(cEndereco+cBairro)
  			  	? cCep
  				? cBairro
  				? cCidade
  				? cEndereco
  				? cUF
  				? cId
  				  
  				  cCEP:=STRTRAN(cCEP,"-","")	
  				  cCIDADE:=STRTRAN(CCIDADE,'"',"")
  				 
  				  dbselectar("cepruaimp")
  				  dbappend()
  				  field->cep:=cCEP
  				  field->rua:=UPPER(cendereco)
                  field->bairro:=UPPER(cBairro)
  				  field->uf:=UPPER(cUF)
  				  field->cidade:=UPPER(cCIDADE)
  				  
  				  cLINHA:=cCEP +","+CENDERECO+","+cBairro+","+CCIDADE +","+cUF+HB_OSNEWLINE()
  						 
  				  FWRITE(nGRAVA,cLINHA)
  			  else
  				  ?
  				  ? 'nao localizado web correio'
  				  ?
  				  dbselectar("cepruaimp") //grava para nao buscr online novamente
                  if ! dbseek(cCEP)
    				  dbappend()
    				  field->cep:=cCEP
                      if ! empty(cCIDADE) .AND. ! EMPTY(cUF)
                         field->cidade:=UPPER(cCIDADE)
                         field->uf:=UPPER(cUF)
                      endif
                 endif   
  		     endif
               
               
           
            //via cep web segunda busca
       		oCep := cepWeb( cCEP )
     		?
    		? '  CEP...:'+ cCEP
		    ? 
		    IF ! oCep == NIL
			  ?   
			  ?
			  ? '  CEP...:', oCep:cCEP
			  ? '  IBGE..:', oCep:cIBGE
			  ? '  LOGRAD:', oCep:cLogradouro
			  ? '  COMPLE:', oCep:cComplemento
			  ? '  BAIRRO:', oCep:cBairro
			  ? '  CIDADE:', oCep:cLocalidade
			  ? '  UF....:', oCep:cUF
			  
			  cCEP:=STRTRAN(oCep:cCEP,"-","")	
			  cCIDADE:=STRTRAN(oCep:cLocalidade,'"',"")
			  
			 
			  dbselectar("cepruaimp")
              if ! dbseek(cCEP)
			     dbappend()
                 field->cep:=cCEP
              endif
              if empty(field->codibge)  
			     field->codibge:=oCep:cIBGE 
              endif
              if empty(field->rua)   
			     field->rua:=UPPER(oCep:cLogradouro)
              endif
              if empty(field->obs)   
			     field->obs:=UPPER(oCep:cComplemento)
              endif
              if empty(field->bairro)   
			     field->bairro:=UPPER(oCep:cBairro)
              endif
              if empty(field->cidade)   
			    field->cidade:=UPPER(cCIDADE)
              endif
              if empty(field->uf)  
			     field->uf:=UPPER(oCep:cUF)
              endif
			 
			  cLINHA:=cCEP+","+oCep:cIBGE+","+oCep:cLogradouro+","+oCep:cComplemento+","+oCep:cBairro+","+CCIDADE+","+oCep:cUF+HB_OSNEWLINE()
			  FWRITE(nGRAVA,cLINHA)
		  else
			  ?
			  ? 'nao localizado viacep'
			  ?
				  dbselectar("cepruaimp") //grava para nao buscr online novamente
                  if ! dbseek(cCEP)
    				  dbappend()
    				  field->cep:=cCEP
                      if ! empty(cCIDADE) .AND. ! EMPTY(cUF)
                         field->cidade:=UPPER(cCIDADE)
                         field->uf:=UPPER(cUF)
                      endif
                 endif   
		  endif	 
              
                  
                  
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
FCLOSE(nGRAVA)
dbselectar("cepruaimp")
delete all for empty(rua).and.empty(bairro)
pack
dbcloseall()
   
   

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
  
  
