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
SET OPTIMIZE ON
set deleted on
set softseek on
   Set( _SET_CODEPAGE, "PTISO")
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
     
   
   nGRAVA:=FCREATE("cepruaimp.csv")
   cLINHA:="cep,rua,bairro,cidade,uf"+HB_OSNEWLINE()
   //cCEP +","+CENDERECO+","+cBairro+","+CCIDADE +","+cUF
   FWRITE(nGRAVA,cLINHA)
   
use cepruaimp new exclusive
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
	   SET FILTER TO EMPTY(RUA) .or. empty(field->chvbai)
	   ntotrec:=reccount()
	   NRECUSO:=0
	   
	   dbgotop()
	   
		
		
		while ! eof()
			  nRECUSO++
			  @ 24,00 say cFILECEP
			  @ 24,10 SAY nTOTREC
			  @ 24,20 SAY nRECUSO
		
		    
			
		  
		  
		  if empty(field->rua) .or. empty(field->chvbai)
		     
			  cCEP:=field->cep
			  dbselectar("cepruaimp")
			  if ! dbseek(cCEP) //Ja pesquisado
			     
			  	cBairro :=""
				cCidade  :=""
				cEndereco :=""
				cUF :=""
				cId :=""

			  
			     ConsultaCep( cCep, @cBairro, @cCidade, @cEndereco, @cUF, @cId )

				 
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
					  field->bairro:=UPPER(cBairro)
					  field->cidade:=UPPER(cCIDADE)
					  field->rua:=UPPER(cendereco)
					  field->uf:=UPPER(cUF)
					  
					  cLINHA:=cCEP +","+CENDERECO+","+cBairro+","+CCIDADE +","+cUF+HB_OSNEWLINE()
							 
					  FWRITE(nGRAVA,cLINHA)
				  else
					  ?
					  ? 'nao localizado'
					  ?
					  dbselectar("cepruaimp") //grava para nao buscr online novamente
					  dbappend()
					  field->cep:=cCEP
				  
				  endif	 
			 endif	  
		  endif
		  DBSELECTAR(cFILECEP)
		  dbskip()		
	   ENDDO
    endif   
   
	NEXT KK   
   FCLOSE(nGRAVA)

   
   
   
   
   
   /*
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

   RETURN NIL

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

   RETURN NIL

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
