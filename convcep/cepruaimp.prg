*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : cepruaimp.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:21 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function main()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function main()


HB_IDLESTATE()

Set(_SET_CODEPAGE,"PTISO")

setmode(25,80)
cls

rddsetdefault("DBFCDX")
Set(_SET_OPTIMIZE,.t.)
Set(_SET_DELETED,.t.)
Set(_SET_SOFTSEEK,.t.)
__SetCentury(.t.)
Set(_SET_EPOCH,year(date()) - 60)
Set(_SET_DATEFORMAT,"dd/mm/yyyy")


if !file("cepruaimp.dbf")
   alert("Falta cepruaimp.dbf")
   quit
endif

if !file("cepruaerr.dbf")
   alert("Falta cepruaerr.dbf")
   quit
endif

if !file("MD10.dbf") .OR. !file("MD10.CDX")
   alert("Falta MD10.dbf ou md10.cdx")
   quit
endif

if !file("cidconv.dbf") .OR. !file("cidconv.CDX")
   alert("Falta cidconv.dbf ou cidconv.cdx")
   quit
endif

if !file("cepbai.dbf") .OR. !file("cepbai.CDX")
   alert("Falta cepbai.dbf ou cepbai.cdx")
   quit
endif

if !file("cepbailx.dbf") .OR. !file("cepbailx.CDX")
   alert("Falta cepbailx.dbf ou cepbailx.cdx")
   quit
endif

use cepruaerr new exclusive
zap


IF FILE("cepruaimp.cdx")  //apaga o indice caso algum importador use outra chave para o index primario
   ferase("cepruaimp.cdx")
endif
use cepruaimp new exclusive
index on UF+CIDADE+CEP tag ufcidade
nLASTREC := LASTREC()
if file("logradouro.dbf")
   append from logradouro
endif

cARQUIVO := "MD10"
dbusearea(.T.,"DBFCDX",cARQUIVO,,.T.)
ordlistadd(cARQUIVO)
dbsetorder(1)   //

cARQUIVO := "CIDCONV"
dbusearea(.T.,"DBFCDX",cARQUIVO,,.T.)
ordlistadd(cARQUIVO)
dbsetorder(1)   //

cARQUIVO := "CEPBAILX"
dbusearea(.T.,"DBFCDX",cARQUIVO,,.T.)
ordlistadd(cARQUIVO)

cARQUIVO := "CEPBAI"
dbusearea(.T.,"DBFCDX",cARQUIVO,,.T.)
ordlistadd(cARQUIVO)
//trabalhando por id para preenher vaos depois retornar pelo ultimo id
nLASTBAIRRO := 1
idbairro()


nUSO := FCREATE("erro.txt")


//01/02/2O21 ajusta  cidade esta junto com o estado separado pela barra Ex: SAO PAULO/SP antes de comecar a importacao
//manter a tratativa abaixo tambem pois algum registro pode estar sem a barra
dbselectar("cepruaimp")
dbsetorder(0)
dbgotop()
lPROCESSA := empty(cepruaimp->UF) .and. at("/",CEPRUAIMP->CIDADE) > 0   //checa o primeiro registro pra evitar loop descnecesario
IF lPROCESSA
   while !eof()
      @ 24,00 say str(recno(),10)+"/"+str(nLASTREC,10)+" - "+CEPRUAIMP->CIDADE         
      cCIDADE := CEPRUAIMP->CIDADE
      if empty(cepruaimp->UF) .and. at("/",cCIDADE) > 0
         IF at("  - DISTRITO",cCIDADE) > 0 .AND. at("(",cCIDADE) > 0  //NOSSA SENHORA DO REMEDIO (SALESOPOLIS)/SP  - DISTRITO
            nPOS    := at("(",cCIDADE)
            cCIDADE := SUBSTR(cCIDADE,nPOS+1)
            cCIDADE := STRTRAN(cCIDADE,")","")
         endif
         IF at("  - POVOADO",cCIDADE) > 0 .AND. at("(",cCIDADE) > 0   //NOSSA SENHORA DO REMEDIO (SALESOPOLIS)/SP  - POVOADO
            nPOS    := at("(",cCIDADE)
            cCIDADE := SUBSTR(cCIDADE,nPOS+1)
            cCIDADE := STRTRAN(cCIDADE,")","")
         endif
         nPOS              := at("/",cCIDADE)
         cepruaimp->UF     := LEFT(SUBSTR(cCIDADE,nPOS+1),2)
         CEPRUAIMP->CIDADE := SUBSTR(cCIDADE,1,nPOS - 1)
      ENDIF
      dbskip()
   enddo
endif

//alguns importadores tranzem somente o ibge gravando a cidade para usar o cidlooop
dbselectar("cepruaimp")
dbgotop()
while !eof()
   cCODIBGE := CEPRUAIMP->CODIBGE
   @ 24,00 say str(recno(),10)+"/"+str(nLASTREC,10)+" - "+cCODIBGE         
   IF EMPTY(cepruaimp->UF) .AND. EMPTY(CEPRUAIMP->CIDADE)
      dbselectar("MD10")
      dbsetorder(3)
      dbgotop()
      if dbseek(cCODIBGE)
         cepruaimp->UF     := MD10->UF
         CEPRUAIMP->CIDADE := MD10->NOME
      ENDIF
   endif
   dbselectar("cepruaimp")
   dbskip()
enddo

dbselectar("MD10")  //retorna ordem 1 pois a 3 foi usada acima
dbsetorder(1)
cCODIBGE := ""  //zera a variavel do loop acima

////algumas vem com nome no parentes distrito(cidade)
dbselectar("cepruaimp")
dbgotop()
while !eof()
   cCIDADE := CEPRUAIMP->CIDADE
   @ 24,00 say str(recno(),10)+"/"+str(nLASTREC,10)+" - "+cCIDADE         
   IF AT("(",cCIDADE) > 0
      CEPRUAIMP->CIDADE := TRATACIDADE(CEPRUAIMP->uf,cCIDADE)
   ENDIF
   dbselectar("cepruaimp")
   dbskip()
enddo
cCidade := ""   //zera a variavel do loop acima


dbselectar("cepruaimp")
dbsetorder(1)
dbgotop()
while !eof()

   //IF RECNO()=579443
   //   ALTD()
   //ENDIF
   cUF      := cepruaimp->UF
   cUFLOOP  := cepruaimp->UF
   cCIDLOOP := cepruaimp->CIDADE  //nome usado para o loop usar sem nenhum tratamento
   cCIDADE  := UPPER(TRATANOME(cepruaimp->CIDADE))
   //01/02/2021 07:27 a cidade esta junto com o estado separado pela barra Ex: SAO PAULO/SP
   if empty(cUF) .and. at("/",cCIDADE) > 0
      nPOS    := at("/",cCIDADE)
      cUSO    := cCIDADE
      cCIDADE := SUBSTR(cUSO,1,nPOS - 1)
      cUF     := LEFT(SUBSTR(cUSO,nPOS+1),2)
      //Tratado com cufloop pois quando alterado a chave do uf cidade reposicionava o recno()
      // IF EMPTY(cepruaimp->UF) //grava a uf obtida para nao ficar travado no loop do while abaixo implantar futuramente cUFLOOP para melhorar tratativa
      //   cepruaimp->UF:=cUF
      // ENDIF	
   ENDIF

   // erro tamanho codigo zera para nao gravar errado
   cCODIBGE := alltrim(cepruaimp->CODIBGE)
   IF LEN(cCODIBGE) < 7
      cCODIBGE := ""
   ENDIF

   //01/02/2021 os dois numeros iniciais do ibge sao invalidos sera o codigo para nao zerar erro
   if !EMPTY(cCODIBGE) .AND. coduf(cCODIBGE,"UF") = "??"
      cCODIBGE := ""
   endif

   //01/02/2021 a sigla do estado ibge sao invalidos sera o codigo para nao zerar erro
   if !EMPTY(cCODIBGE) .AND. coduf(cCODIBGE) = "??"
      cCODIBGE := ""
   endif

   //01/02/2021 07:32 a uf esta em branco mas tem o ibge para a sigla da uf pelo ibge
   IF !EMPTY(cCODIBGE) .AND. EMPTY(cUF)
      cUF := coduf(cCODIBGE,"UF")
   ENDIF

   ncodibge  := 0   //sequencia sempre zero pois agora e o ibge como sequencia
   eLOCALBAI := 0
   lACHEI    := .F.
   @ 24,00 say cUF+PADR(cCIDADE,30)+STR(RECNO(),10)+"/"+STR(nLASTREC,10)         
   if !empty(cUF) .AND. !EMPTY(cCIDADE)
      cCIDBUSCA := TRATANOME(cCIDADE)
      cCODIBGE  := BUSCAIBGE(cUF,cCIDBUSCA)   //1a tentativa com o nome  tratanome
      if !empty(cCODIBGE)
         ncodibge := VAL(cCODIBGE)
         cCIDADE  := cCIDBUSCA
         lACHEI   := .T.
      ENDIF

      if ncodibge = 0 .AND. AT("(",cCIDLOOP) > 0
         cCIDBUSCA := TRATACIDADE(cUF,cCIDADE)
         cCODIBGE  := BUSCAIBGE(cUF,cCIDBUSCA)  //2a. tentativa //cidades com nome parentes tratacidade
         if !empty(cCODIBGE)
            ncodibge := VAL(cCODIBGE)
            cCIDADE  := cCIDBUSCA
            lACHEI   := .T.
         ENDIF
      endif
   endif

   if ncodibge = 0 .AND. !EMPTY(cCODIBGE) .and. !empty(cCIDLOOP)  //no comeca tras a cidade pelo codigo ibge //aqui e necessario ibge e nome da cidade para o cidloop while abaixo
      dbselectar("MD10")
      dbsetorder(3)
      dbgotop()
      if dbseek(cCODIBGE)
         IF VAL(MD10->CODIBGE) > 0
            ncodibge := VAL(MD10->CODIBGE)
         ENDIF
         IF EMPTY(cUF) .OR. EMPTY(cCIDADE)
            cUF     := MD10->UF
            cCIDADE := MD10->NOME
            //cCIDLOOP :=MD10->NOME // se cidloop manter da base para nao entrar em loop no  while abaixo
         ENDIF
         lACHEI := .T.
      ENDIF
   endif


   if ncodibge = 0 .AND. lACHEI
      ncodibge := 9999999   //tratado abaixo pois ibge 7 digitos cepnrua 6
   endif
   lCEPRUA := .F.
   lCEPGEO := .F.

   IF ncodibge > 0  //agora sempre ibge
      cARQRUA  := "c"+cCODIBGE
      ncodibge := val(cCODIBGE)
      if !file(cARQRUA+".dbf")
         fileCOPY("CEPRUA.DBF",cARQRUA+".dbf")
         dbusearea(.T.,"DBFCDX",cARQRUA,,.T.)
         index on RUA tag &cARQRUA.1
         index on CEP tag &cARQRUA.2
         dbclosearea()
      endif
      if !file(cARQRUA+".cdx")
         dbusearea(.T.,"DBFCDX",cARQRUA,,.T.)
         index on RUA tag &cARQRUA.1
         index on CEP tag &cARQRUA.2
         dbclosearea()
      endif
      if file(cARQRUA+".dbf") .and. file(cARQRUA+".cdx")
         lCEPRUA := .T.
         dbusearea(.T.,"DBFCDX",cARQRUA,,.T.)
         ordlistadd(cARQRUA)
         dbsetorder(2)  //      cep
      ENDIF
      //dados adcionais de
      cARQGEO := "g"+cCODIBGE
      if !file(cARQGEO+".dbf")
         fileCOPY("CEPGEO.DBF",cARQGEO+".dbf")
         dbusearea(.T.,"DBFCDX",cARQGEO,,.T.)
         index on CEP tag &cARQGEO.1
         dbclosearea()
      endif
      if !file(cARQGEO+".cdx")
         dbusearea(.T.,"DBFCDX",cARQGEO,,.T.)
         index on CEP tag &cARQGEO.1
         dbclosearea()
      endif
      if file(cARQGEO+".dbf") .and. file(cARQGEO+".cdx")
         lCEPGEO := .T.
         dbusearea(.T.,"DBFCDX",cARQGEO,,.T.)
         ordlistadd(cARQGEO)
         dbsetorder(1)  //      cep
      ENDIF
   ENDIF

   if !lCEPRUA .OR. (EMPTY(cUF) .OR. EMPTY(cCIDADE))  //
      if !empty(alltrim(cUF+" "+cCIDADE+" "+cCODIBGE))
         fwrite(nUSO,cUF+" "+cCIDLOOP+" "+cCODIBGE+hb_osnewline())
      endif
      if !empty(cepruaimp->RUA) .and. !empty(cepruaimp->bairro)
         dbselectar("cepruaerr")
         dbappend()
         cepruaerr->cep     := cepruaimp->cep
         cepruaerr->obs     := cepruaimp->obs
         cepruaerr->RUA     := cepruaimp->RUA
         cepruaerr->Bairro  := cepruaimp->bairro
         cepruaerr->codibge := cepruaimp->codibge
         cepruaerr->uf      := cepruaimp->uf
         cepruaerr->cidade  := cepruaimp->cidade
      endif
      dbselectar("cepruaimp")
      dbdelete()  //deletando os erros para nao fazer na proxima rodada
      dbskip()
      loop
   endif

   dbselectar("cepruaimp")
   while cUFLOOP = cepruaimp->UF .AND. cCIDLOOP = ALLTRIM(cepruaimp->CIDADE) .AND. !EOF()
      @ 24,00 say cUF+PADR(cCIDADE,30)+CEP+STR(RECNO(),10)+"/"+STR(nLASTREC,10)         
      IF lCEPRUA  //grava ou skip abaixo uf/cidade
         cCEP    := ALLTRIM(TIRAOUT(CEP))
         cRUA    := TRATANOME(cepruaimp->RUA)
         cBAIRRO := TRATANOME(cepruaimp->BAIRRO)
         cBAIRRO := strtran(alltrim(cBAIRRO),"'"," ")
         cBAIRRO := strtran(alltrim(cBAIRRO),'"'," ")
         cTIPO   := ALLTRIM(cepruaimp->TIPO)  //rua avenida .....
         cOBS    := ALLTRIM(cepruaimp->OBS)

         IF cRUA = "ull,"   //alguns web service trazem null
            cRUA := ""
         ENDIF

         IF cBAIRRO = "ull,"  //alguns web service trazem null
            cBAIRRO := ""
         ENDIF

         IF lCEPGEO .AND. (!EMPTY(cepruaimp->DDD) .OR. !EMPTY(cepruaimp->LATITUDE) .OR. !EMPTY(cepruaimp->LONGITUDE))
            dbselectar(cARQGEO)
            dbgotop()
            IF !dbseek(cCEP)
               dbappend()
               FIELD->CEP := cCEP
            ELSE
               dbrlock()
            ENDIF
            if empty(field->DDD) .AND. !EMPTY(cepruaimp->DDD)
               field->DDD := cepruaimp->DDD
            endif
            if empty(field->LATITUDE) .AND. !EMPTY(cepruaimp->LATITUDE)
               field->LATITUDE := cepruaimp->LATITUDE
            endif

            if empty(field->LONGITUDE) .AND. !EMPTY(cepruaimp->LONGITUDE)
               field->LONGITUDE := cepruaimp->LONGITUDE
            endif

            dbunlock()
         ENDIF

         dbselectar(cARQRUA)
         dbgotop()
         IF !dbseek(cCEP)
            dbappend()
            FIELD->CEP := cCEP
         ELSE
            dbrlock()
         ENDIF
         if empty(field->rua)
            field->rua := cRUA
         endif
         if len(alltrim(field->rua)) < 5 .and. LEN(ALLTRIM(cRUA)) > 5   //ruas que iram A B 1 UM ... e passaram a ter nome
            field->rua := cRUA
         endif


         if empty(field->tipo)
            field->tipo := cTIPO
         endif
         if at("LADO PAR",cOBS) > 0 .AND. EMPTY(field->PARID)
            field->PARID := "P"
            cOBS         := STRTRAN(cOBS,"LADO PAR","")
            cOBS         := STRTRAN(cOBS," - ","")
         endif

         if at("(NUMERACAO COM ZERO A ESQUERDA)",cOBS) > 0 .AND. EMPTY(field->PARID)
            field->PARID := "E"
            cOBS         := STRTRAN(cOBS,"(NUMERACAO COM ZERO A ESQUERDA)","")
            cOBS         := STRTRAN(cOBS," - ","")
         endif

         if at("LADO IMPAR",cOBS) > 0 .AND. EMPTY(field->PARID)
            field->PARID := "I"
            cOBS         := STRTRAN(cOBS,"LADO IMPAR","")
            cOBS         := STRTRAN(cOBS," - ","")
         endif

         if at("AO FIM",cOBS) > 0 .AND. EMPTY(field->NFIM)
            field->NFIM := 99999
            cOBS        := STRTRAN(cOBS,"AO FIM","")
         endif

         //FLORENCA SEIS   DE 7700/7701 A 8099/8100 trata quando a observacao
         if at(" DE ",cobs) > 0 .and. at(" A ",cobs) > 0 .and. at("/",cobs) > 0
            nPOS    := at("DE ",cOBS)
            nvalini := 0
            NVALFIM := 0
            CINI    := ""
            CFIM    := ""
            IF nPOS > 0
               cINI := SUBSTR(cOBS,nPOS+3)  //7700/7701 A 8099/8100 separa a parde de
               cOBS := SUBSTR(cOBS,nPOS+3)  //7700/7701 A 8099/8100 se for lado para o impar pega o para para o inicial que e menor
               nPOS := at("/",cINI)   // quando nao e separado para ou impar nao tem o traco
               IF nPOS > 0
                  cINI    := SUBSTR(cINI,1,nPOS - 1)  //7700
                  nVALINI := VAL(cINI)
               ENDIF
               nPOS := at(" A ",cOBS)
               IF nPOS > 0  ////7700/7701 A 8099/8100 separa a parde A
                  cFIM := SUBSTR(cOBS,nPOS+3)   //8099/8100
               ENDIF
               nPOS := at("/",cFIM)
               IF nPOS > 0
                  cFIM    := SUBSTR(cFIM,1,nPOS - 1)  //8099
                  nVALFIM := VAL(cFIM)
               ENDIF
               if Nvalini > 0 .and. NVALFIM > 0
                  FIELD->NINI := Nvalini
                  FIELD->NFIM := NvalFIM
               ENDIF
            ENDIF

         endif





         //usando nvalini,nvalfim para nao confundir com os campos NINI,NFIM
         if at(" A ",cOBS) > 0 .AND. EMPTY(field->NFIM)
            nVALINI := 0
            nVALFIM := 0
            nPOS    := at(" A ",cOBS)
            cOBS    := STRTRAN(cOBS,"LADO IMPAR","")  //tratados acima mas o parid pode ja estar preenchido ajustando aqui novamente
            cOBS    := STRTRAN(cOBS," - ","")
            cOBS    := STRTRAN(cOBS,"LADO PAR","")
            cOBS    := STRTRAN(cOBS," - ","")
            cOBS    := STRTRAN(cOBS,"(NUMERACAO COM ZERO A ESQUERDA)","")
            cOBS    := STRTRAN(cOBS," - ","")
            cOBS    := STRTRAN(cOBS,"AO FIM","")
            cOBS    := STRTRAN(cOBS," - ","")
            IF nPOS > 0
               cFIM := SUBSTR(cOBS,nPOS+3)
               nPOS := at("/",cFIM)
               IF nPOS > 0
                  cFIM := SUBSTR(cFIM,nPOS+1)
               ENDIF
               nVALFIM := VAL(cFIM)
               cOBS    := SUBSTR(cOBS,1,nPOS - 1)
               nPOS    := at("DE ",cOBS)
               IF nPOS > 0
                  cINI := SUBSTR(cOBS,nPOS+3)
                  nPOS := at("/",cINI)
                  IF nPOS > 0
                     cINI := SUBSTR(cINI,1,nPOS - 1)
                  ENDIF
                  nVALINI := VAL(cINI)
                  cOBS    := SUBSTR(cOBS,1,nPOS - 1)
               ENDIF
            ENDIF
            IF nVALFIM > 0 .AND. EMPTY(field->NFIM)
               field->NFIM := nVALFIM
            ENDIF
            IF nVALINI > 0 .AND. EMPTY(field->NINI)
               field->NINI := nVALINI
            ENDIF
         endif


         if at("DE ",cOBS) > 0 .AND. EMPTY(field->NINI)
            nVALINI := 0
            nPOS    := at("DE ",cOBS)
            cOBS    := STRTRAN(cOBS,"LADO IMPAR","")  //tratados acima mas o parid pode ja estar preenchido ajustando aqui novamente
            cOBS    := STRTRAN(cOBS," - ","")
            cOBS    := STRTRAN(cOBS,"LADO PAR","")
            cOBS    := STRTRAN(cOBS," - ","")
            cOBS    := STRTRAN(cOBS,"(NUMERACAO COM ZERO A ESQUERDA)","")
            cOBS    := STRTRAN(cOBS," - ","")
            cOBS    := STRTRAN(cOBS,"AO FIM","")
            cOBS    := STRTRAN(cOBS," - ","")
            IF nPOS > 0
               cINI := SUBSTR(cOBS,nPOS+3)
               nPOS := at("/",cINI)
               IF nPOS > 0
                  cINI := SUBSTR(cINI,1,nPOS - 1)
               ENDIF
               nVALINI := VAL(cINI)
               cOBS    := SUBSTR(cOBS,1,nPOS - 1)
            ENDIF
            IF nVALINI > 0 .AND. EMPTY(field->NINI)
               field->NINI := nVALINI
            ENDIF
         endif


         if empty(field->chvbai) .AND. !EMPTY(cBAIRRO)
            nCHVBAI := 0
            eBUSCA  := ALLTRIM(cBAIRRO)   //antes a chave era a cidade e o bairro STR(ncodibge,7)+cBAIRRO agora so o nome do bairro
            dbselectar("cepbai")
            dbsetorder(2)   //    4 cep_bai_old nome bairro agora na cep_bai nova e o indice 2
            dbgotop()
            if dbseek(eBUSCA)
               nCHVBAI := bai_nu_seq
            endif
            //if nCHVBAI=0  //as tabelas novas e buscas web nao trazem mais o nome reduzido utilizando agora so nome
            //   eBUSCA:=STR(ncodibge,7)+cBAIRRO
            //   dbselectar("cepbai")
            //   dbsetorder(5) // nome bairro abreviado
            //   dbgotop()
            //	if dbseek(eBUSCA)
            //	   nCHVBAI:=bai_nu_seq
            //	endif
            //endif
            if nCHVBAI = 0  //inclui o bairro
               idbairro()   //utilizando idbairro ate completar os vaos no id
               dbselectar("cepbai")
               dbappend()
               cepbai->bai_nu_seq := nLASTBAIRRO
               cepbai->bai_no     := cBAIRRO
               //cepbai->loc_nu_seq:=ncodibge //agora a chave e so o nome do bairro
               //cepbai->bai_no_abr:=cBAIRRO  //as bases nao trazem mais o bairro abreviado
               nCHVBAI := bai_nu_seq
               dbunlock()
            endif
            //Grava a chave
            dbselectar(cARQRUA)
            IF nCHVBAI > 0 .and. (empty(field->chvbai) .or. field->chvbai <> nCHVBAI)   //sem o codigo do bairro ou bairro trocou de nome
               field->chvbai := nCHVBAI
            ENDIF
            IF nCHVBAI > 0  //grava tambem na cepbailx (bairros cidades)
               eBUSCA := cCODIBGE+STR(nCHVBAI,7)
               dbselectar("cepbailx")
               dbsetorder(1)  // ibge chave bairro
               dbgotop()
               if !dbseek(eBUSCA)
                  dbappend()
                  cepbailx->BAI_NU_NEW := nCHVBAI
                  cepbailx->CODIBGE    := cCODIBGE
               endif
               dbunlock()
            ENDIF
            dbselectar(cARQRUA)
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
   if lCEPGEO
      dbselectar(cARQGEO)
      dbclosearea()
   ENDIF

   dbselectar("cepruaimp")  //skip no loop acima linhas acima
enddo
dbcloseall()
FCLOSE(nUSO)



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tratacidade()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function tratacidade(cUF,cNOME)   //algumas vem com nome no parentes distrito(cidade)

cDISTRITO := ""
cNOME     := tratanome(cNOME)
npOS      := AT("(",cNOME)
IF npOS > 0
   cDISTRITO := SUBSTR(cNOME,1,nPOS - 1)
   cNOME     := SUBSTR(cNOME,nPOS+1)
   cNOME     := ALLTRIM(cNOME)
ENDIF
cNOME := STRTRAN(cNOME,")","")
dbselectar("cidconv")
dbgotop()
if !dbseek(cUF+cDISTRITO)
   dbappend()
   cidconv->ESTADO := cUF
   cidconv->CIDORI := cDISTRITO
   cidconv->ESTDES := cUF
   cidconv->CIDDES := cNOME
endif
RETURN cNOME


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function idbairro()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function idbairro

dbselectar("cepbai")
dbsetorder(1)
dbgotop()
while dbseek(nLASTBAIRRO)
   nLASTBAIRRO ++
   @ 24,00 say "bairro: "+str(nlastbairro)         
enddo
dbsetorder(2)   // antes 4 localcep ibge + nome agora so o nome index 2
return


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function vertxt()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function vertxt

return .t.

*+ EOF: cepruaimp.prg
*+
