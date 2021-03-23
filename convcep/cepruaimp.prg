REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

function main()

HB_IDLESTATE()

Set( _SET_CODEPAGE, "PTISO")    
	
setmode(25,80)	
cls
	
rddsetdefault( "DBFCDX" )
Set( _SET_OPTIMIZE, .t.)
Set( _SET_DELETED, .t.)
Set( _SET_SOFTSEEK, .t.)
__SetCentury( .t. )
Set( _SET_EPOCH, year( date() ) - 60 )
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )



use cepruaimp new exclusive
index on UF+CIDADE+CEP tag ufcidade
nLASTREC:=LASTREC()
if file("logradouro.dbf")
   append from logradouro
endif


cARQUIVO:="MD10"
dbusearea( .T., "DBFCDX", cARQUIVO,, .T. )
ordlistadd( cARQUIVO)
dbsetorder(1) //

//cARQUIVO:="MD05"
//dbusearea( .T., "DBFCDX", cARQUIVO,, .T. )
//ordlistadd( cARQUIVO)
//dbsetorder(1) //

cARQUIVO:="CIDCONV"
dbusearea( .T., "DBFCDX", cARQUIVO,, .T. )
ordlistadd( cARQUIVO)
dbsetorder(1) //


cARQUIVO:="CEPBAI"
dbusearea( .T., "DBFCDX", cARQUIVO,, .T. )
ordlistadd( cARQUIVO)
//dbsetorder(1)
//dbgobottom()
//nLASTBAIRRO:=BAI_NU_SEQ //pega a ultima sequencia
//dbsetorder(4) // localcep + nome

//trabalhando por id para preenher vaos depois retornar pelo ultimo id
nLASTBAIRRO:=1
idbairro()


nUSO:=FCREATE("erro.txt")


//01/02/2O21 ajusta  cidade esta junto com o estado separado pela barra Ex: SAO PAULO/SP antes de comecar a importacao
//manter a tratativa abaixo tambem pois algum registro pode estar sem a barra
dbselectar("cepruaimp")
dbsetorder(0)
dbgotop()
lPROCESSA:=empty(cepruaimp->UF) .and. at("/",CEPRUAIMP->CIDADE)>0 //checa o primeiro registro pra evitar loop descnecesario
IF lPROCESSA
	while ! eof()   
	   @ 24,00 say str(recno()) + CEPRUAIMP->CIDADE 
	   cCIDADE:=CEPRUAIMP->CIDADE
	   if empty(cepruaimp->UF) .and. at("/",cCIDADE)>0
	      IF at("  - DISTRITO",cCIDADE)>0 .AND. at("(",cCIDADE)>0 //NOSSA SENHORA DO REMEDIO (SALESOPOLIS)/SP  - DISTRITO
		     nPOS:=at("(",cCIDADE)
			 cCIDADE:=SUBSTR(cCIDADE,nPOS+1)
			 cCIDADE:=STRTRAN(cCIDADE,")","")
		  endif
		  IF at("  - POVOADO",cCIDADE)>0 .AND. at("(",cCIDADE)>0 //NOSSA SENHORA DO REMEDIO (SALESOPOLIS)/SP  - POVOADO
		     nPOS:=at("(",cCIDADE)
			 cCIDADE:=SUBSTR(cCIDADE,nPOS+1)
			 cCIDADE:=STRTRAN(cCIDADE,")","")
		  endif
		  
		  nPOS:=at("/",cCIDADE)
		  cepruaimp->UF:=LEFT(SUBSTR(cCIDADE,nPOS+1),2)
		  CEPRUAIMP->CIDADE:=SUBSTR(cCIDADE,1,nPOS-1)
	    ENDIF	
       dbskip()	   
	enddo
endif	

dbselectar("cepruaimp")
dbsetorder(1)
dbgotop()
while ! eof()   

   //IF RECNO()=579443
   //   ALTD()
   //ENDIF
   cUF      :=cepruaimp->UF
   cUFLOOP  :=cepruaimp->UF
   cCIDLOOP :=cepruaimp->CIDADE
   cCIDADE  :=TRATANOME(CIDADE)   
   //01/02/2021 07:27 a cidade esta junto com o estado separado pela barra Ex: SAO PAULO/SP
   if empty(cUF) .and. at("/",cCIDADE)>0
      nPOS:=at("/",cCIDADE)
	  cUSO:=cCIDADE
	  cCIDADE:=SUBSTR(cUSO,1,nPOS-1)
	  cUF    :=LEFT(SUBSTR(cUSO,nPOS+1),2)
	  //Tratado com cufloop pois quando alterado a chave do uf cidade reposicionava o recno()
	 // IF EMPTY(cepruaimp->UF) //grava a uf obtida para nao ficar travado no loop do while abaixo implantar futuramente cUFLOOP para melhorar tratativa
	 //   cepruaimp->UF:=cUF
	 // ENDIF	
   ENDIF	  
   
   // erro tamanho codigo zera para nao gravar errado
   cCODIBGE:=alltrim(cepruaimp->CODIBGE)
   IF LEN(cCODIBGE)<7 
      cCODIBGE:=""
   ENDIF
   
   //01/02/2021 os dois numeros iniciais do ibge sao invalidos sera o codigo para nao zerar erro
   if ! EMPTY(cCODIBGE) .AND. coduf(cCODIBGE,"UF")="??" 
       cCODIBGE:=""
   endif

  //01/02/2021 a sigla do estado ibge sao invalidos sera o codigo para nao zerar erro
   if ! EMPTY(cCODIBGE) .AND. coduf(cCODIBGE)="??" 
       cCODIBGE:=""
   endif
   
   //01/02/2021 07:32 a uf esta em branco mas tem o ibge para a sigla da uf pelo ibge
   IF ! EMPTY(cCODIBGE) .AND. EMPTY(cUF)
      cUF:=coduf(cCODIBGE,"UF")
   ENDIF
   
   eBUSCA   :=cUF+TRATANOME(cCIDADE)
   nCEPNUSEQ:=0 //sequencia sempre zero pois agora e o ibge como sequencia
   eLOCALBAI:=0
   lACHEI:=.F.
   @ 24,00 say  cUF+ cCIDADE + STR(RECNO()) + "/" + STR(nLASTREC)   
   if ! empty(cUF) .AND. ! EMPTY(cCIDADE)
	   dbselectar("MD10")
	   dbsetorder(1)
	   dbgotop()
	   if dbseek(eBUSCA)
		  //nCEPNUSEQ:=MD10->CEPNUSEQ     
		  cCODIBGE:=alltrim(MD10->CODIBGE)
		  IF VAL(MD10->CODIBGE)>0
			nCEPNUSEQ:=VAL(MD10->CODIBGE)
		  ENDIF
		  lACHEI:=.T.
	   endif
	   if nCEPNUSEQ=0
		  dbselectar("cidconv")
		  dbgotop()
		  if dbseek(eBUSCA)
			 eBUSCA:=ESTDES+ALLTRIM(CIDDES)
		  ENDIF
		  dbselectar("MD10")
		  dbsetorder(1)
		  dbgotop()
		  if dbseek(eBUSCA)
//			 nCEPNUSEQ:=MD10->CEPNUSEQ     
			cCODIBGE:=alltrim(MD10->CODIBGE)
	 		IF VAL(MD10->CODIBGE)>0
				nCEPNUSEQ:=VAL(MD10->CODIBGE)
			ENDIF
			 lACHEI:=.T.
		  endif      
	   endif
	   if nCEPNUSEQ=0 .AND. AT("(",cCIDLOOP)>0  //cidades com nome parentes
		  eBUSCA   :=cUF+TRATACIDADE(cCIDLOOP)
		  dbselectar("MD10")
		  dbsetorder(1)
		  dbgotop()
		  if dbseek(eBUSCA)
			cCODIBGE:=alltrim(MD10->CODIBGE)
	 		IF VAL(MD10->CODIBGE)>0
				nCEPNUSEQ:=VAL(MD10->CODIBGE)
			ENDIF
			 lACHEI:=.T.
		  endif      
	   endif
   endif	   
   if nCEPNUSEQ=0 .AND. ! EMPTY(cCODIBGE)
     dbselectar("MD10")
     dbsetorder(3)
	 dbgotop()
	 if dbseek(cCODIBGE)
//	    nCEPNUSEQ:=MD10->CEPNUSEQ
 		IF VAL(MD10->CODIBGE)>0
			nCEPNUSEQ:=VAL(MD10->CODIBGE)
		ENDIF
		IF EMPTY(cUF) .OR. EMPTY(cCIDADE)
           cUF      :=MD10->UF
		   cCIDADE  :=MD10->CIDADE
           //cCIDLOOP :=MD10->NOME // se cidloop manter da base para nao entrar em loop no  while abaico
		ENDIF
		lACHEI:=.T.
	 ENDIF   
   endif
   
   
   if nCEPNUSEQ=0  .AND. lACHEI
      /*
			   dbselectar("MD10")
			   dbgotop()
			   if ! dbseek(eBUSCA)
                  dbappend()
				  md10->uf:=cUF
				  md10->nome:=cCIDADE
				  
				  dbrlock()
			   endif
     */		   
   ENDIF
   
   if nCEPNUSEQ=0  .AND. lACHEI      
      nCEPNUSEQ:=9999999 //tratado abaixo pois ibge 7 digitos cepnrua 6
   endif
   lCEPRUA:=.F.
   
   
   
    IF nCEPNUSEQ>0//agora sempre ibge
	   //IF nCEPNUSEQ=9999999
	   cARQRUA := "C" + cCODIBGE
       nCEPNUSEQ:=val(cCODIBGE)
	   //ELSE
	   //cARQRUA := "C" + strzero( nCEPNUSEQ, 6 )	   
	   //endif
	   if ! file( cARQRUA + ".dbf" ) 
   	      fileCOPY("CEPRUA.DBF",cARQRUA+".DBF")
		  dbusearea( .T., "DBFCDX", cARQRUA,, .T. )
	      index on RUA tag &cARQRUA.1 
          index on CEP tag &cARQRUA.2 
          dbclosearea()	   
	   endif
	   if ! file( cARQRUA + ".cdx" )    	      
		  dbusearea( .T., "DBFCDX", cARQRUA,, .T. )
	      index on RUA tag &cARQRUA.1 
          index on CEP tag &cARQRUA.2 
          dbclosearea()	   
	   endif	   
	   if file( cARQRUA + ".dbf" ) .and. file( cARQRUA + ".cdx" )
		  lCEPRUA:=.T.
		  dbusearea( .T., "DBFCDX", cARQRUA,, .T. )
		  ordlistadd( cARQRUA)
		  dbsetorder(2) //      cep
	   ENDIF
	ENDIF   
   
    if ! lCEPRUA .OR. (EMPTY(cUF) .OR. EMPTY(cCIDADE)) //
	    if ! empty(alltrim(cUF+" "+cCIDADE+" "+cCODIBGE))
	       fwrite(nUSO,cUF+" "+cCIDLOOP+" "+cCODIBGE+hb_osnewline())
		endif   
		dbselectar("cepruaimp")
		dbdelete() //deletando os erros para nao fazer na proxima rodada
		dbskip()
		loop
    endif	
 
    
 
 
   dbselectar("cepruaimp")
   
   
   
   while cUFLOOP=cepruaimp->UF .AND. cCIDLOOP=ALLTRIM(cepruaimp->CIDADE) .AND. ! EOF()
      @ 24,00 say  cUF+ cCIDADE + CEP + STR(RECNO()) + "/" + STR(nLASTREC)
      IF lCEPRUA   //grava ou skip abaixo uf/cidade         
         cCEP:=ALLTRIM(TIRAOUT(CEP))
		 cRUA:=TRATANOME(cepruaimp->RUA)
		 cBAIRRO:=TRATANOME(cepruaimp->BAIRRO)
		 
		 cBAIRRO:=strtran( alltrim( cBAIRRO ), "'", " " )
		cBAIRRO:=strtran( alltrim( cBAIRRO ), '"', " " )		 
		 
		 
		 cTIPO  :=ALLTRIM(cepruaimp->TIPO) //rua avenida .....
		 cOBS  :=ALLTRIM(cepruaimp->OBS)
		 
         dbselectar(cARQRUA)
         dbgotop()
         IF ! dbseek(cCEP)            
            dbappend()
            FIELD->CEP:=cCEP            
         ELSE
            dbrlock()
         ENDIF
         if empty(field->rua) 
            field->rua:=cRUA
         endif
		 if len(alltrim(field->rua))<5 .and.  LEN(ALLTRIM(cRUA))>5 //ruas que iram A B 1 UM ... e passaram a ter nome
		    field->rua:=cRUA
		 endif	
         if empty(field->tipo) 
            field->tipo:=cTIPO
         endif		 	
         if at("LADO PAR",cOBS)>0 .AND. EMPTY(field->PARID)
		     field->PARID:="P"
			 cOBS:=STRTRAN(cOBS,"LADO PAR","")
			 cOBS:=STRTRAN(cOBS," - ","")			 
         endif		  

         if at("(NUMERACAO COM ZERO A ESQUERDA)",cOBS)>0 .AND. EMPTY(field->PARID)
		     field->PARID:="E"
			 cOBS:=STRTRAN(cOBS,"(NUMERACAO COM ZERO A ESQUERDA)","")
			 cOBS:=STRTRAN(cOBS," - ","")			 
         endif		  

         if at("LADO IMPAR",cOBS)>0 .AND. EMPTY(field->PARID)
		     field->PARID:="I"
			 cOBS:=STRTRAN(cOBS,"LADO IMPAR","")
			 cOBS:=STRTRAN(cOBS," - ","")
         endif	

         if at("AO FIM",cOBS)>0 .AND. EMPTY(field->NFIM)
		     field->NFIM:=99999
			 cOBS:=STRTRAN(cOBS,"AO FIM","")
         endif	

		  //FLORENCA SEIS   DE 7700/7701 A 8099/8100 trata quando a observacao
	      if at(" DE ",cobs)>0 .and. at(" A ",cobs)>0 .and. at("/",cobs)>0
			   nPOS:=at("DE ",cOBS)
			   nvalini:=0
			   NVALFIM:=0
			   CINI:=""
			   CFIM:=""
			   IF nPOS>0			   
			      cINI:=SUBSTR(cOBS,nPOS+3) //7700/7701 A 8099/8100 separa a parde de 
				  cOBS:=SUBSTR(cOBS,nPOS+3) //7700/7701 A 8099/8100 se for lado para o impar pega o para para o inicial que e menor
			      nPOS:=at("/",cINI) // quando nao e separado para ou impar nao tem o traco
			      IF nPOS>0				     
			         cINI:=SUBSTR(cINI,1,nPOS-1) //7700
					 nVALINI:=VAL(cINI)
			      ENDIF
				  nPOS:=at(" A ",cOBS)
				  IF nPOS>0 ////7700/7701 A 8099/8100 separa a parde A
					 cFIM:=SUBSTR(cOBS,nPOS+3) //8099/8100
				  ENDIF
				  nPOS:=at("/",cFIM)
			      IF nPOS>0				     
			         cFIM:=SUBSTR(cFIM,1,nPOS-1) //8099
					 nVALFIM:=VAL(cFIM)
			      ENDIF
				  if Nvalini>0 .and. NVALFIM>0
				     FIELD->NINI:=Nvalini
					 FIELD->NFIM:=NvalFIM
				  ENDIF
			   ENDIF
			   
			endif
			




         //usando nvalini,nvalfim para nao confundir com os campos NINI,NFIM
         if at(" A ",cOBS)>0 .AND. EMPTY(field->NFIM)
            nVALINI:=0
			nVALFIM:=0
		    nPOS:=at(" A ",cOBS)
 		    cOBS:=STRTRAN(cOBS,"LADO IMPAR","") //tratados acima mas o parid pode ja estar preenchido ajustando aqui novamente
			cOBS:=STRTRAN(cOBS," - ","")
 		    cOBS:=STRTRAN(cOBS,"LADO PAR","")
			cOBS:=STRTRAN(cOBS," - ","")			 			
			cOBS:=STRTRAN(cOBS,"(NUMERACAO COM ZERO A ESQUERDA)","")
			cOBS:=STRTRAN(cOBS," - ","")	
            cOBS:=STRTRAN(cOBS,"AO FIM","")			
			cOBS:=STRTRAN(cOBS," - ","")	
			IF nPOS>0			   
			   cFIM:=SUBSTR(cOBS,nPOS+3)
			   nPOS:=at("/",cFIM)
			   IF nPOS>0			      
			      cFIM:=SUBSTR(cFIM,nPOS+1)
			   ENDIF
   			   nVALFIM:=VAL(cFIM)
			   cOBS:=SUBSTR(cOBS,1,nPOS-1)		
			   nPOS:=at("DE ",cOBS)
			   IF nPOS>0			   
			      cINI:=SUBSTR(cOBS,nPOS+3)				  
 			      nPOS:=at("/",cINI)
			      IF nPOS>0				     
			         cINI:=SUBSTR(cINI,1,nPOS-1)
			      ENDIF
				  nVALINI:=VAL(cINI)
			      cOBS:=SUBSTR(cOBS,1,nPOS-1)			   
			   ENDIF
		    ENDIF 
			IF nVALFIM>0 .AND.  EMPTY(field->NFIM)
			   field->NFIM:=nVALFIM
			ENDIF
			IF nVALINI>0 .AND.  EMPTY(field->NINI)
			   field->NINI:=nVALINI
			ENDIF
         endif	


         if at("DE ",cOBS)>0 .AND. EMPTY(field->NINI)
		     nVALINI:=0
		     nPOS:=at("DE ",cOBS)
 		    cOBS:=STRTRAN(cOBS,"LADO IMPAR","") //tratados acima mas o parid pode ja estar preenchido ajustando aqui novamente
			cOBS:=STRTRAN(cOBS," - ","")
 		    cOBS:=STRTRAN(cOBS,"LADO PAR","")
			cOBS:=STRTRAN(cOBS," - ","")			 			
			cOBS:=STRTRAN(cOBS,"(NUMERACAO COM ZERO A ESQUERDA)","")
			cOBS:=STRTRAN(cOBS," - ","")	
            cOBS:=STRTRAN(cOBS,"AO FIM","")			
			cOBS:=STRTRAN(cOBS," - ","")	
			 IF nPOS>0			   
			    cINI:=SUBSTR(cOBS,nPOS+3)				  
 			    nPOS:=at("/",cINI)
			    IF nPOS>0	                   
			       cINI:=SUBSTR(cINI,1,nPOS-1)
			    ENDIF
			    nVALINI:=VAL(cINI)
			    cOBS:=SUBSTR(cOBS,1,nPOS-1)			   
  		    ENDIF
			IF nVALINI>0 .AND.  EMPTY(field->NINI)
			   field->NINI:=nVALINI
			ENDIF		 
		 endif

		 
		 if empty(field->chvbai) .AND. ! EMPTY(cBAIRRO)                        		 
			nCHVBAI:=0			 
			eBUSCA:=STR(nCEPNUSEQ,7)+cBAIRRO
			dbselectar("cepbai")
			dbsetorder(4) // nome bairro
			dbgotop()
			if dbseek(eBUSCA)               
			   nCHVBAI:=bai_nu_seq
			endif			 
		    if nCHVBAI=0 
			   eBUSCA:=STR(nCEPNUSEQ,7)+cBAIRRO
			   dbselectar("cepbai")
			   dbsetorder(5) // nome bairro abreviado
			   dbgotop()
				if dbseek(eBUSCA)               
				   nCHVBAI:=bai_nu_seq
				endif
			 endif
			 if nCHVBAI=0   //inclui o bairro         
			   //nLASTBAIRRO++
			   idbairro() //utilizando idbairro ate completar os vaos no id
			   dbselectar("cepbai")
			   dbappend()
			   cepbai->bai_nu_seq:=nLASTBAIRRO
			   cepbai->loc_nu_seq:=nCEPNUSEQ
			   cepbai->bai_no    :=cBAIRRO
			   cepbai->bai_no_abr:=cBAIRRO
			   nCHVBAI:=bai_nu_seq
			   dbunlock()	
			 endif
			 dbselectar(cARQRUA)
			 IF nCHVBAI>0
				field->chvbai:=nCHVBAI 
			 ENDIF		   
		 endif	 
        DBUNLOCK()
      ENDIF   
      dbselectar("cepruaimp")
      dbskip()
   enddo   
   if lCEPRUA
      dbselectar(cARQRUA)
      dbclosearea()
   ENDIF
   dbselectar("cepruaimp") //skip loop acima
enddo
dbcloseall()
FCLOSE(nUSO)


function TIRAOUT( TEXTO )
texto := strtran( texto, ".", "" )
texto := strtran( texto, ":", "" )
texto := strtran( texto, "-", "" )
texto := strtran( texto, "/", "" )
return texto    


function tratanome(cNOME)
LOCAL npOS
cNOME:=ALLTRIM(cNOME)
npOS:=AT("(",cNOME)
IF npOS>0   
   cNOME:=SUBSTR(cNOME,1,nPOS-1)
   cNOME:=ALLTRIM(cNOME)
ENDIF
cNOME:=STRTRAN(cNOME,"&39;"," ")
cNOME:=STRTRAN(cNOME,"-"," ")
cNOME:= strtran( alltrim( cNOME ), "'", " " )
RETURN cNOME


function tratacidade(cNOME) //algumas vem com nome no parentes
npOS:=AT("(",cNOME)
IF npOS>0   
   cNOME:=SUBSTR(cNOME,nPOS+1)
   cNOME:=ALLTRIM(cNOME)
ENDIF
cNOME:=STRTRAN(cNOME,")","")
RETURN cNOME


function coduf(cBUSCA,cTIPO) //ibge
local nPos:=0
local cRETU:="??"
LOCAL aUF,aIBGE

aUF    := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
            "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
            "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}

aIBGE:= { "12", "27", "13", "16", "29", "23", "53", "32", "52", ;
          "21", "31", "50", "51", "15", "25", "26", "22", "41", ;
          "33", "24", "11", "14", "43", "42", "28", "35", "17" ,"54","54"}


IF VALTYPE(cTIPO)<>"C"
   cTIPO:="UF"
ENDIF
//@ 23,00 SAY cBUSCA
//inkey(0)
IF cTIPO="UF" // codigo->Sigla uf
   IF LEN(cBUSCA)>2 //codigo ibge 7 digitos 2 primeiros estados
      cBUSCA:=SUBSTR(cBUSCA,1,2)
   ENDIF
   nPos:=ascan( aIBGE, cBUSCA )
   if nPos>0
      cRETU:=aUF[nPos] // retorna o codigo do Estado
   endif
ELSE    //sigla uf->codigo
   nPos:=ascan( aUF, cBUSCA )
   if nPos>0
      cRETU:=aIBGE[nPos] // retorna o codigo numerico do estado
   endif
ENDIF
Return cRETU


function idbairro
dbselectar("cepbai")
dbsetorder(1)
dbgotop()
while dbseek(nLASTBAIRRO)
	 nLASTBAIRRO++
	 @ 24,00 say "bairro"+str(nlastbairro)
enddo	 
dbsetorder(4) // localcep + nome
