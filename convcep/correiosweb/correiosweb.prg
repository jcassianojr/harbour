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
     
     
     
lRUAVAZIA:=MSGYESNO("Checar Ruas Em Branco")
lBAIRROVAZIO:=MSGYESNO("Checar Bairro em Branco")
lNOMECURTO:=MSGYESNO("Checar Ruas com nomes menores que 5 letras")   
lAPAGANAO:=MSGYESNO("Apaga Nao encontrado")
   
   nGRAVA:=FCREATE("cepruaimp.csv")
   cLINHA:="cep,rua,bairro,cidade,uf"+HB_OSNEWLINE()
   //cCEP +","+CENDERECO+","+cBairro+","+CCIDADE +","+cUF
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
		
		    
			 
		  
		  
		  if .T. //empty(field->rua) .or. empty(field->chvbai) regra no filtro acima
		      lTEMCEP:=.T. //marca true para nao apagar se consultra cep nao encontrar vira false
			  cCEP:=field->cep
			  dbselectar("cepruaimp")
			  if ! dbseek(cCEP) //Ja pesquisado
			     
			  	cBairro :=""
				cCidade  :=""
				cEndereco :=""
				cUF :=""
				cId :=""

			  
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
					  ? 'nao localizado'
					  ?
					  dbselectar("cepruaimp") //grava para nao buscr online novamente
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
