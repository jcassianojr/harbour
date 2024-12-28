// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : classecurl.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include 'hbclass.ch'
#include "hbcurl.ch"

#ifndef __XHARBOUR__
#include "hbcompat.ch"
#endif

#pragma /w2
#pragma /es2

/*
oWeb:=oSyg_curl():New()

   WITH OBJECT oWeb

      :cUrl       := 'https://olinda.bcb.gov.br/olinda/servico/Informes_Agencias/versao/v1/odata/Agencias?$format=json'
      :cHttpReq   := 'GET'
      :lJsonDecode:= .T.
      IF !:SendHttp()  // .T. deu certo , .F. ocorreu erro
         lRET:=.F.
      ENDIF

      ::hAgencias := :hResposta // aqui guarda a resposta em um HASH

      :End()
   END
*/


// +--------------------------------------------------------------------
// +
// +
// +
// +    Class oSyg_curl
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
Jo∆o Alpande
$ *CATEGORIA * $
WEBSERVICE
$ *SUB - CATEGORIA * $
WEBSERVICE
$ *PARAMETROS * $
N«O RECEBE
$ *RETORNO * $
DEFINIÄ«O DA CLASSE oSyg_curl
$ *DESCRICAO * $
Classe PARA uso da biblioteca libcurl
$ *HISTORICO * $
CRIAÄ«O: 05 / 12 / 2022
$ *EXEMPLOS * $
oServerWS := oSyg_curl():New()
$ *FIM * $
// /
transferància libcurl execute o temmpo limite padr∆o Ç 0 ( zero ),
o que significa que ele nunca expira durante a transferància.  * /
// ou o fluxo definido comCURLOPT_STDERR
CLASS oSyg_curl


   /* $*AUTOR*$

   DATA hCurl
   DATA nRetCurl INIT 0 // CURLE_OK(0) significa que tudo estava OK, diferente de zero significa que ocorreu um erro
   DATA nHttpcode INIT 0  // £ltimo c¢digo de resposta
   DATA cRetorno INIT ''  // Mensagem de Retorno
   DATA cUrl INIT ''  // URL
   DATA cHttpReq INIT 'POST'  // mÇtodo da requisiá∆o(POST, GET, DELETE, PUT)
   DATA aHeader INIT {} // array dos Headers
   DATA cEmailFrom INIT ''  // E-mail From
   DATA aEmailTo INIT {}  // array dos e-mails para oonde vai enviar
   DATA aEmailcc INIT {}  // array dos e-mails que vai enviar como cc
   DATA aAnexos INIT {} // array dos Anexos que vai enviar no e-mail
   DATA cAssunto INIT ''  // Assunto do Email
   DATA cMensagem INIT '' // Mensagem do Email
   DATA cJsonorXml INIT ''
   DATA cCertFilePub INIT ''
   DATA cCertPass INIT ''
   DATA cCertFilePriv INIT ''
   DATA lAssinaturaDigital INIT .F. // .T. = vai enviar  cCertFilePub, cCertPass, cCertFilePriv
   DATA nFollowlocation INIT 0  // 0  = Desativado 1=siga redirecionamentos HTTP 3xx
   DATA nVerifypeer INIT 0  // 0  = Desabilitando a verificaá∆o de mesmo n°vel SSL
   DATA nTimeout INIT 0 /* Tempo m†ximo em segundos que vocà permite que a operaá∆o de
   DATA nConnectTimeout INIT 60 // Tempo limite para a fase de conex∆o - 60 segundos
   DATA lVerbose INIT .F. // .T. = Mostra informaá‰es detalhadas, ser∆o enviadas para stderr,
   DATA lInfHeader INIT .F. // .T. = Retorna o cabeáalho de resposta
   DATA lJsonDecode INIT .F.  // .T. = Decodifica a resposta em um objeto JSON
   DATA lMostraMsgRet INIT .T.  // .T. = Mostra mensagem de Retorno
   DATA hResposta INIT Hash() // Hash da resposta

   DATA cProxyUrl INIT ''
   DATA nProxyPort INIT 0
   DATA cProxyUser INIT ''
   DATA cProxyPass INIT ''
   DATA cUrlApiEmail INIT 'http:  //email.seusitecomapi.com.br'

   DATA bCodeProgress

   METHOD New() CONSTRUCTOR
   METHOD SendHttp()
   METHOD SendMailSendGrid()
   METHOD SendTokenApiEmail(cToken)
   METHOD SendMailApi()
   METHOD DownloadFile(cArquivo,cSalvaOnde)
   METHOD MsgStatusHttp()
   METHOD Reset()
   METHOD End ()

ENDCLASS

// ****************************
METHOD New() CLASS oSyg_curl


// ****************************

::hCurl     := curl_easy_init()
::hResposta := Hash()

RETURN self

// ******************************
METHOD Reset() CLASS oSyg_curl


// ******************************

curl_easy_reset(::hCurl)

RETURN NIL

// ****************************
METHOD End () CLASS oSyg_curl


// ****************************

IF !Empty(::hCurl)
   curl_easy_cleanup(::hCurl)
ENDIF
::hCurl := Nil

#ifdef _XHARBOUR_
hb_gcAll(.T.)
#endif

RETURN NIL




// ***************************************
METHOD SendHttp() CLASS oSyg_curl


// ***************************************
LOCAL lRET := .T.

IF Empty(::hCurl)
   IF ::lMostraMsgRet
      ShowMsg('N∆o INICIOU a classe da libcurl.dll corretamente.')
   ENDIF
   RETURN .F.
ENDIF

IF Empty(::cUrl)
   IF ::lMostraMsgRet
      ShowMsg('N∆o enviou a Url para a classe.')
   ENDIF
   RETURN .F.
ENDIF
IF Empty(::cHttpReq)
   IF ::lMostraMsgRet
      ShowMsg('N∆o enviou o mÇtodo da requisiá∆o(POST, GET, DELETE, PUT) para a classe.')
   ENDIF
   RETURN .F.
ENDIF

/*n∆o retirar este c¢digo comentado , podemos usar para fazer algum teste
    showmsg_edit('URL : ' + ::cUrl     +hb_osnewline()+;
                 'METODO:'+ ::cHttpReq +hb_osnewline()+;
                 IF(!EMPTY(::cJsonorXml), 'JSON/XML: '+hb_osnewline()+ ::cJsonorXml   ,'' ) )
*/

   IF ::cHttpReq = 'POST'
      IF ::aHeader = Nil
         AAdd( ::aHeader, "Content-Type: application/json" )
      ELSEIF Len( ::aHeader ) = 0
         AAdd( ::aHeader, "Content-Type: application/json" )
      ENDIF
   ENDIF

   curl_easy_setopt( ::hCurl, HB_CURLOPT_URL, ::cUrl )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_FOLLOWLOCATION, ::nFollowlocation )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_SSL_VERIFYPEER, ::nVerifypeer )

   IF ::lAssinaturaDigital
      curl_easy_setopt( ::hCurl, HB_CURLOPT_SSLCERT, ::cCertFilePub )
      curl_easy_setopt( ::hCurl, HB_CURLOPT_KEYPASSWD, ::cCertPass )
      curl_easy_setopt( ::hCurl, HB_CURLOPT_SSLKEY, ::cCertFilePriv )
   ENDIF

   IF !Empty( ::cProxyUrl )
      curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXY, ::cProxyUrl + ":" + AllTrim( Str( ::nProxyPort ) ) )
      IF !Empty( ::cProxyUser )
         curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXYUSERPWD, ::cProxyUser + ":" + ::cProxyPass )
      ENDIF
   ENDIF

   curl_easy_setopt( ::hCurl, HB_CURLOPT_TIMEOUT, ::nTimeout )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_CONNECTTIMEOUT, ::nConnectTimeout )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_VERBOSE, ::lVerbose )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_HEADER, ::lInfHeader )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_CUSTOMREQUEST, ::cHttpReq )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_POSTFIELDS, ::cJsonorXml )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_DL_BUFF_SETUP )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_HTTPHEADER, ::aHeader )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_DL_BUFF_SETUP )

   ::nRetCurl  := curl_easy_perform( ::hCurl )
   ::nHttpcode := curl_easy_getinfo( ::hCurl, HB_CURLINFO_RESPONSE_CODE )
   ::cRetorno  := curl_easy_dl_buff_get( ::hCurl )

/*n∆o retirar este c¢digo comentado , podemos usar para fazer algum teste
   showmsg_edit('RETCURL : ' + ALLTRIM(STR(::nRetCurl))   +hb_osnewline()+;
                'HTTPCOD : ' + ALLTRIM(STR(::nHttpcode))  +hb_osnewline()+;
                'RESPOSTA: ' + ALLTRIM(::cRetorno)  )
*/

   IF ::nRetCurl = HB_CURLE_OK   // 0= OK
      IF ::nHttpcode >= 200 .AND. ::nHttpcode < 300  // Sucesso
         lRET := .T.
      ELSE
         lRET := .F.
         IF ::lMostraMsgRet
            ::MsgStatusHttp()
         ENDIF
      ENDIF
   ELSE
      lRET := .F.
   /*
   Isso n∆o pode est† na classe, se precisar tem que ler o ::cRetorno onde est† chamando a classe - Leonardo Machado - 13/06/2023
   IF ::lMostraMsgRet
      Showmsg_Edit( ::cRetorno ,'Erro Inesperado' )
   ENDIF
   */
   ENDIF

   IF lRET .AND. ::lJsonDecode
      hb_jsonDecode( ::cRetorno, @::hResposta )
   ENDIF

RETURN ( lRET )

// ****************************************
METHOD SendMailSendGrid() CLASS oSyg_curl

// ****************************************
   LOCAL lRET := .T., nI := 0, cTipo := 'text/plain', cExtensao := '', cAnexo := ''

   IF Empty( ::cEmailFrom )
      ::cEmailFrom := 'no-reply@meusite.com.br'
   ENDIF

   IF Len( ::aEmailTo ) = 0
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o enviou o e-mail para onde vai enviar.' )
      ENDIF
      RETURN .F.
   ENDIF

   IF Empty( ::cAssunto )
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o enviou o assunto do e-mail.' )
      ENDIF
      RETURN .F.
   ENDIF

   IF Empty( ::cMensagem )
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o enviou o mensagem do e-mail.' )
      ENDIF
      RETURN .F.
   ENDIF

/*n∆o retirar este c¢digo comentado , podemos usar para fazer algum teste
    showmsg_edit('URL : ' + ::cUrl     +hb_osnewline()+;
                 'METODO:'+ ::cHttpReq +hb_osnewline()+;
                 IF(!EMPTY(::cJsonorXml), 'JSON/XML: '+hb_osnewline()+ ::cJsonorXml   , ) )
*/
   ::cJsonorXml := ' { "personalizations": ' + hb_osNewLine() + ;
      ' [ ' + hb_osNewLine() + ;
      ' {"to": [' + hb_osNewLine()

   FOR nI := 1 TO Len( ::aEmailTo )
      IF !Empty( ::aEmailTo[ nI, 1 ] )
         ::cJsonorXml += '{"email": "' + AllTrim( ::aEmailTo[ nI, 1 ] ) + '"} ' + IF( Len( ::aEmailTo ) > nI, ',', '' ) + hb_osNewLine()
      ENDIF
   NEXT
   ::cJsonorXml += '] '

   IF Len( ::aEmailcc ) > 0
      ::cJsonorXml += ', "cc": ['
      FOR nI := 1 TO Len( ::aEmailcc )
         IF !Empty( ::aEmailcc[ nI, 1 ] )
            ::cJsonorXml += '{"email": "' + AllTrim( ::aEmailcc[ nI, 1 ] ) + '"} ' + IF( Len( ::aEmailcc ) > nI, ',', '' ) + hb_osNewLine()
         ENDIF
      NEXT
      ::cJsonorXml += '] '
   ENDIF

   ::cMensagem := StrTran( ::cMensagem, '\', '\\' )
   ::cMensagem := StrTran( ::cMensagem, '"', "'" )
   ::cMensagem := StrTran( ::cMensagem, Chr( 13 ), ' ' )
   ::cMensagem := StrTran( ::cMensagem, Chr( 10 ), ' \n ' )
   ::cMensagem := hb_StrToUTF8( ::cMensagem )

   ::cJsonorXml += ' }], ' + hb_osNewLine()
   ::cJsonorXml += ' "from": {"email": "' + AllTrim( ::cEmailFrom ) + '"}, ' + hb_osNewLine()
   ::cJsonorXml += ' "subject": "' + hb_StrToUTF8( AllTrim( ::cAssunto ) ) + '", ' + hb_osNewLine()
   ::cJsonorXml += ' "content": [{"type": "text/plain", "value": "' + AllTrim( ::cMensagem ) + '"} ]  ' + hb_osNewLine()

// se tem anexos
   IF Len( ::aAnexos ) > 0
      ::cJsonorXml += ', "attachments": [ ' + hb_osNewLine()
      FOR nI := 1 TO Len( ::aAnexos )
         IF !Empty( ::aAnexos[ nI, 2 ] )
            cAnexo := MemoRead( ::aAnexos[ nI, 2 ] )
            cAnexo := SYG_BASE64ENCODE( cAnexo )
            cAnexo := Syg_Limpa( AllTrim( cAnexo ) )

            cExtensao := Upper( Subs( ::aAnexos[ nI, 2 ], RAt( ".", ::aAnexos[ nI, 2 ] ) + 1 ) )
            IF AllTrim( cExtensao ) = 'PDF'
               cTipo := 'application/pdf'
            ELSEIF AllTrim( cExtensao ) = 'BMP' .OR. AllTrim( cExtensao ) = 'JPEG' .OR. ;
                  AllTrim( cExtensao ) = 'JPG' .OR. AllTrim( cExtensao ) = 'PNG' .OR. ;
                  AllTrim( cExtensao ) = 'JPG' .OR. AllTrim( cExtensao ) = 'GIF'
               cTipo := 'image/' + Lower( AllTrim( cExtensao ) )
            ELSEIF AllTrim( cExtensao ) = 'CSV' .OR. AllTrim( cExtensao ) = 'HTML' ;
                  .OR. AllTrim( cExtensao ) = 'HTM' .OR. AllTrim( cExtensao ) = 'CSS'
               cTipo := 'text/' + Lower( AllTrim( cExtensao ) )
            ELSEIF AllTrim( cExtensao ) = 'ICO'
               cTipo := 'image/image/vnd.microsoft.icon'
            ELSEIF AllTrim( cExtensao ) = 'XML'
               cTipo := 'application/xml'
            ELSEIF AllTrim( cExtensao ) = 'ZIP'
               cTipo := 'application/zip'
            ELSEIF AllTrim( cExtensao ) = 'RAR'
               cTipo := 'application/vnd.rar'
            ELSEIF AllTrim( cExtensao ) = 'XLS'
               cTipo := 'application/vnd.ms-excel'
            ELSEIF AllTrim( cExtensao ) = 'XLSX'
               cTipo := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            ELSEIF AllTrim( cExtensao ) = 'ODS'
               cTipo := 'application/vnd.oasis.opendocument.spreadsheet'
            ELSE
               cTipo := 'text/plain'
            ENDIF

            ::cJsonorXml += ' { "content": "' + AllTrim( cAnexo ) + '",' + hb_osNewLine()
            ::cJsonorXml += ' "type": "' + AllTrim( cTipo ) + '",' + hb_osNewLine()
            ::cJsonorXml += ' "filename": "' + AllTrim( ::aAnexos[ nI, 1 ] ) + '"' + hb_osNewLine()
            ::cJsonorXml += ' }  ' + IF( Len( ::aAnexos ) > nI, ',', '' ) + hb_osNewLine()
         ENDIF
      NEXT
      ::cJsonorXml += ' ] ' + hb_osNewLine()
   ENDIF
   ::cJsonorXml += '}'
// hwg_WriteLog(::cJsonorXml, 'testecurl.txt' )

   IF Empty( ::cUrl )  // se n∆o envia a url do sendgrid usa a conta sendgrid da Sygecom
      ::cUrl := 'https://api.sendgrid.com/v3/mail/send'
      AAdd( ::aHeader, "Authorization: Bearer " + 'aqui vai o token do sendgrid' )
   ENDIF

   AAdd( ::aHeader, "Content-Type: application/json" )

   curl_easy_setopt( ::hCurl, HB_CURLOPT_URL, ::cUrl )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_FOLLOWLOCATION, ::nFollowlocation )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_SSL_VERIFYPEER, ::nVerifypeer )

   IF !Empty( ::cProxyUrl )
      curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXY, ::cProxyUrl + ":" + AllTrim( Str( ::nProxyPort ) ) )
      IF !Empty( ::cProxyUser )
         curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXYUSERPWD, ::cProxyUser + ":" + ::cProxyPass )
      ENDIF
   ENDIF

   curl_easy_setopt( ::hCurl, HB_CURLOPT_TIMEOUT, ::nTimeout )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_CONNECTTIMEOUT, ::nConnectTimeout )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_VERBOSE, ::lVerbose )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_HEADER, ::lInfHeader )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_CUSTOMREQUEST, ::cHttpReq )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_POSTFIELDS, ::cJsonorXml )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_DL_BUFF_SETUP )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_HTTPHEADER, ::aHeader )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_DL_BUFF_SETUP )

   ::nRetCurl  := curl_easy_perform( ::hCurl )
   ::nHttpcode := curl_easy_getinfo( ::hCurl, HB_CURLINFO_RESPONSE_CODE )
   ::cRetorno  := curl_easy_dl_buff_get( ::hCurl )

/*n∆o retirar este c¢digo comentado , podemos usar para fazer algum teste
   showmsg_edit('RETCURL : ' + ALLTRIM(STR(::nRetCurl))   +hb_osnewline()+;
                'HTTPCOD : ' + ALLTRIM(STR(::nHttpcode))  +hb_osnewline()+;
                'RESPOSTA: ' + ALLTRIM(::cRetorno)  )
*/

   IF ::nRetCurl = HB_CURLE_OK   // 0= OK
      IF ::nHttpcode >= 200 .AND. ::nHttpcode < 300  // Sucesso
         lRET := .T.
         IF Len( ::aEmailTo ) > 0
            FOR nI := 1 TO Len( ::aEmailTo )
               IF !Empty( ::aEmailTo[ nI, 1 ] )
                  // GRAVALOG('ENVIADO E-MAIL PARA: ' + ::aEmailTo[nI,1] )
               ENDIF
            NEXT
         ENDIF
      ELSE
         lRET := .F.
         IF ::lMostraMsgRet
            ::MsgStatusHttp()
         ENDIF
      ENDIF
   ELSE
      lRET := .F.

   /*
   Isso n∆o pode est† na classe, se precisar tem que ler o ::cRetorno onde est† chamando a classe - Leonardo Machado - 13/06/2023
   IF ::lMostraMsgRet
      Showmsg_Edit( ::cRetorno ,'Erro Inesperado' )
   ENDIF
   */
   ENDIF

   IF lRET .AND. ::lJsonDecode
      hb_jsonDecode( ::cRetorno, @::hResposta )
   ENDIF

   RETURN ( lRET )

// *******************************************************
METHOD DownloadFile( cArquivo, cSalvaOnde ) CLASS oSyg_curl

// *******************************************************
   LOCAL lRet := .F., cUrl

   cArquivo   := IF( cArquivo = NIL, '', cArquivo )
   cSalvaOnde := IF( cSalvaOnde = NIL, '', cSalvaOnde )

   IF !Empty( cArquivo ) .AND. !Empty( cSalvaOnde )
      IF !Empty( cUrl := curl_easy_init() )
         curl_easy_setopt( cUrl, HB_CURLOPT_SSL_VERIFYPEER, ::nVerifypeer )
         IF !Empty( ::cProxyUrl )
            curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXY, ::cProxyUrl + ":" + AllTrim( Str( ::nProxyPort ) ) )
            IF !Empty( ::cProxyUser )
               curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXYUSERPWD, ::cProxyUser + ":" + ::cProxyPass )
            ENDIF
         ENDIF

         curl_easy_setopt( cUrl, HB_CURLOPT_DOWNLOAD )
         curl_easy_setopt( cUrl, HB_CURLOPT_URL, ::cUrl )
         curl_easy_setopt( curl, HB_CURLOPT_DL_FILE_SETUP, cSalvaOnde )
         IF !Empty( ::bCodeProgress )
            curl_easy_setopt( curl, HB_CURLOPT_PROGRESSBLOCK, ::bCodeProgress )
         ENDIF
         curl_easy_setopt( curl, HB_CURLOPT_NOPROGRESS, 0 )
         curl_easy_perform( curl )
         lRet := .T.
      ENDIF
   ENDIF

   RETURN ( lRET )

// ****************************************
METHOD SendMailApi() CLASS oSyg_curl

// ****************************************
   LOCAL lRET := .T., nI := 0, cTipo := 'text/plain', cExtensao := '', cAnexo := '', cToken := '', lMostraMsgRet_Old := .F.

   IF Len( ::aEmailTo ) = 0
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o enviou o e-mail para onde vai enviar.' )
      ENDIF
      RETURN .F.
   ENDIF

   IF Empty( ::cAssunto )
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o enviou o assunto do e-mail.' )
      ENDIF
      RETURN .F.
   ENDIF

   IF Empty( ::cMensagem )
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o enviou o mensagem do e-mail.' )
      ENDIF
      RETURN .F.
   ENDIF

// Obter Token
   lMostraMsgRet_Old := ::lMostraMsgRet
   ::lMostraMsgRet   := .F.
   IF !::SendTokenApiEmail( @cToken ) .OR. Empty( cToken )
      ::lMostraMsgRet := lMostraMsgRet_Old
      IF ::lMostraMsgRet
         ShowMsg( 'N∆o gerou corretamento o token do e-mail.' )
      ENDIF
      RETURN .F.
   ENDIF
   ::lMostraMsgRet := lMostraMsgRet_Old

   ::New()

   ::cJsonorXml := '{ "destinatario": [' + hb_osNewLine()

   FOR nI := 1 TO Len( ::aEmailTo )
      IF !Empty( ::aEmailTo[ nI, 1 ] )
         ::cJsonorXml += '"' + AllTrim( ::aEmailTo[ nI, 1 ] ) + '"' + IF( Len( ::aEmailTo ) > nI, ',' + hb_osNewLine(), '' )
      ENDIF
   NEXT
   ::cJsonorXml += '], '

   ::cJsonorXml += ' "assunto": "' + hb_StrToUTF8( AllTrim( ::cAssunto ) ) + '", ' + hb_osNewLine()

   IF Len( ::aEmailcc ) > 0
      ::cJsonorXml += '"copiados": ['
      FOR nI := 1 TO Len( ::aEmailcc )
         IF !Empty( ::aEmailcc[ nI, 1 ] )
            ::cJsonorXml += '"' + AllTrim( ::aEmailcc[ nI, 1 ] ) + '"' + IF( Len( ::aEmailcc ) > nI, ',' + hb_osNewLine(), '' )
         ENDIF
      NEXT
      ::cJsonorXml += '], ' + hb_osNewLine()
   ENDIF

   ::cMensagem := StrTran( ::cMensagem, '\', '\\' )
   ::cMensagem := StrTran( ::cMensagem, '"', "'" )
   ::cMensagem := StrTran( ::cMensagem, Chr( 13 ), ' ' )
   ::cMensagem := StrTran( ::cMensagem, Chr( 10 ), ' \n ' )
   ::cMensagem := ::cMensagem

   ::cJsonorXml += ' "texto": "' + hb_StrToUTF8( AllTrim( ::cMensagem ) ) + '" ' + hb_osNewLine()

// se tem anexos
   IF Len( ::aAnexos ) > 0

      ::cJsonorXml += ', "anexos": [ ' + hb_osNewLine()
      FOR nI := 1 TO Len( ::aAnexos )
         IF !Empty( ::aAnexos[ nI, 2 ] )
            cAnexo := MemoRead( ::aAnexos[ nI, 2 ] )
            cAnexo := SYG_BASE64ENCODE( cAnexo )
            cAnexo := Syg_Limpa( AllTrim( cAnexo ) )

            cExtensao := Upper( Subs( ::aAnexos[ nI, 2 ], RAt( ".", ::aAnexos[ nI, 2 ] ) + 1 ) )
            IF AllTrim( cExtensao ) = 'PDF'
               cTipo := 'application/pdf'
            ELSEIF AllTrim( cExtensao ) = 'BMP' .OR. AllTrim( cExtensao ) = 'JPEG' .OR. ;
                  AllTrim( cExtensao ) = 'JPG' .OR. AllTrim( cExtensao ) = 'PNG' .OR. ;
                  AllTrim( cExtensao ) = 'JPG' .OR. AllTrim( cExtensao ) = 'GIF'
               cTipo := 'image/' + Lower( AllTrim( cExtensao ) )
            ELSEIF AllTrim( cExtensao ) = 'CSV' .OR. AllTrim( cExtensao ) = 'HTML' ;
                  .OR. AllTrim( cExtensao ) = 'HTM' .OR. AllTrim( cExtensao ) = 'CSS'
               cTipo := 'text/' + Lower( AllTrim( cExtensao ) )
            ELSEIF AllTrim( cExtensao ) = 'ICO'
               cTipo := 'image/image/vnd.microsoft.icon'
            ELSEIF AllTrim( cExtensao ) = 'XML'
               cTipo := 'application/xml'
            ELSEIF AllTrim( cExtensao ) = 'ZIP'
               cTipo := 'application/zip'
            ELSEIF AllTrim( cExtensao ) = 'RAR'
               cTipo := 'application/vnd.rar'
            ELSEIF AllTrim( cExtensao ) = 'XLS'
               cTipo := 'application/vnd.ms-excel'
            ELSEIF AllTrim( cExtensao ) = 'XLSX'
               cTipo := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            ELSEIF AllTrim( cExtensao ) = 'ODS'
               cTipo := 'application/vnd.oasis.opendocument.spreadsheet'
            ELSE
               cTipo := 'text/plain'
            ENDIF
            ::cJsonorXml += ' { "base64": "' + AllTrim( cAnexo ) + '",' + hb_osNewLine()
            ::cJsonorXml += ' "formato": "' + AllTrim( cTipo ) + '",' + hb_osNewLine()
            ::cJsonorXml += ' "filename": "' + AllTrim( ::aAnexos[ nI, 1 ] ) + '"' + hb_osNewLine()
            ::cJsonorXml += ' }  ' + IF( Len( ::aAnexos ) > nI, ',', '' ) + hb_osNewLine()
         ENDIF
      NEXT
      ::cJsonorXml += ' ] ' + hb_osNewLine()

   ENDIF
   ::cJsonorXml += '}'
// hwg_WriteLog('JsonI: ' + ::cJsonorXml+  HB_OsNewLine() + Alltrim(::cUrlApiEmail)+'/sendEmail' + HB_OsNewLine() , 'testecurl.txt' )

   ::aHeader := {}

   AAdd( ::aHeader, "Authorization: Bearer " + AllTrim( cToken ) )
   AAdd( ::aHeader, "Content-Type: application/json" )

   curl_easy_setopt( ::hCurl, HB_CURLOPT_URL, AllTrim( ::cUrlApiEmail ) + '/sendEmail' )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_FOLLOWLOCATION, ::nFollowlocation )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_SSL_VERIFYPEER, ::nVerifypeer )

   IF !Empty( ::cProxyUrl )
      curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXY, ::cProxyUrl + ":" + AllTrim( Str( ::nProxyPort ) ) )
      IF !Empty( ::cProxyUser )
         curl_easy_setopt( ::hCurl, HB_CURLOPT_PROXYUSERPWD, ::cProxyUser + ":" + ::cProxyPass )
      ENDIF
   ENDIF

   curl_easy_setopt( ::hCurl, HB_CURLOPT_TIMEOUT, ::nTimeout )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_CONNECTTIMEOUT, ::nConnectTimeout )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_VERBOSE, ::lVerbose )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_HEADER, ::lInfHeader )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_CUSTOMREQUEST, 'POST' )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_POSTFIELDS, AllTrim( ::cJsonorXml ) )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_DL_BUFF_SETUP )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_HTTPHEADER, ::aHeader )
   curl_easy_setopt( ::hCurl, HB_CURLOPT_DL_BUFF_SETUP )

   ::nRetCurl  := curl_easy_perform( ::hCurl )
   ::nHttpcode := curl_easy_getinfo( ::hCurl, HB_CURLINFO_RESPONSE_CODE )
   ::cRetorno  := curl_easy_dl_buff_get( ::hCurl )

/*n∆o retirar este c¢digo comentado , podemos usar para fazer algum teste
   showmsg_edit('RETCURL : ' + ALLTRIM(STR(::nRetCurl))   +hb_osnewline()+;
                'HTTPCOD : ' + ALLTRIM(STR(::nHttpcode))  +hb_osnewline()+;
                'RESPOSTA: ' + ALLTRIM(::cRetorno)  )
*/

   IF ::nRetCurl = HB_CURLE_OK   // 0= OK
      IF ::nHttpcode >= 200 .AND. ::nHttpcode < 300  // Sucesso
         lRET := .T.
      ELSE
         lRET := .F.
         IF ::lMostraMsgRet
            ::MsgStatusHttp()
         ENDIF
      ENDIF
   ELSE
      lRET := .F.
   ENDIF

   IF lRET .AND. ::lJsonDecode
      hb_jsonDecode( ::cRetorno, @::hResposta )
   ENDIF

   RETURN ( lRET )

// *****************************************************************
METHOD SendTokenApiEmail( cToken ) CLASS oSyg_curl

// ****************************************************************
   LOCAL lRet := .F.

   ::cUrl        := AllTrim( ::cUrlApiEmail ) + '/auth'
   ::cHttpReq    := 'POST'
   ::cJsonorXml  := '{ "username": "nome_usuario", "password": "senha_do_usuario" }'
   ::lJsonDecode := .T.

   IF ::SendHttp()   // .T. deu certo
      cToken := ::hResposta[ "token" ]
      lRet   := .T.
   ENDIF
   ::End()

   RETURN ( lRET )

// *******************************************
METHOD MsgStatusHttp() CLASS oSyg_curl

// *******************************************

   LOCAL aMsgRetorno := {}, nScan := 0

   AAdd( aMsgRetorno, { 300, 'Mensagem de redirecionamento', 'A requisiá∆o tem mais de uma resposta poss°vel. User-agent ou o user deve escolher uma delas.' + hb_osNewLine() + ;
      'N∆o h† maneira padr∆o para escolher uma das respostas.' } )
   AAdd( aMsgRetorno, { 301, 'Mensagem de redirecionamento', 'Esse c¢digo de resposta significa que a URI do recurso requerido mudou. Provavelmente, a nova URI ser† especificada na resposta.' } )
   AAdd( aMsgRetorno, { 302, 'Mensagem de redirecionamento', 'Esse c¢digo de resposta significa que a URI do recurso requerido foi mudada temporariamente.' + hb_osNewLine() + ;
      'Novas mudanáas na URI poder∆o ser feitas no futuro. Portanto, a mesma URI deve ser usada pelo cliente em requisiá‰es futuras.' } )
   AAdd( aMsgRetorno, { 303, 'Mensagem de redirecionamento', 'O servidor manda essa resposta para instruir ao cliente buscar o recurso requisitado em outra URI com uma requisiá∆o GET.' } )
   AAdd( aMsgRetorno, { 304, 'Mensagem de redirecionamento', 'Essa resposta Ç usada para quest‰es de cache. Diz ao cliente que a resposta n∆o foi modificada. ' + hb_osNewLine() + ;
      'Portanto, o cliente pode usar a mesma vers∆o em cache da resposta.' } )
   AAdd( aMsgRetorno, { 305, 'Mensagem de redirecionamento', 'Foi definida em uma vers∆o anterior da especificaá∆o HTTP para indicar que uma resposta deve ser acessada por um proxy.' + hb_osNewLine() + ;
      'Foi depreciada por quest‰es de seguranáa em respeito a configuraá∆o em banda de um proxy.' } )
   AAdd( aMsgRetorno, { 306, 'Mensagem de redirecionamento', 'Esse c¢digo de resposta n∆o Ç mais utilizado, encontra-se reservado. Foi usado numa vers∆o anterior da especificaá∆o HTTP 1.1.' } )
   AAdd( aMsgRetorno, { 307, 'Mensagem de redirecionamento', 'O servidor mandou essa resposta direcionando o cliente a buscar o recurso requisitado em outra URI com o mesmo mÇtodo que foi ' + hb_osNewLine() + ;
      'utilizado na requisiá∆o original. Tem a mesma semÉntica do c¢digo 302 Found, com a exceá∆o de que o user-agent n∆o deve mudar ' + hb_osNewLine() + ;
      'o mÇtodo HTTP utilizado: se um POST foi utilizado na primeira requisiá∆o, um POST deve ser utilizado na segunda.' } )
   AAdd( aMsgRetorno, { 308, 'Mensagem de redirecionamento', 'Esse c¢digo significa que o recurso agora est† permanentemente localizado em outra URI, especificada pelo cabeáalho de resposta Location. ' + hb_osNewLine() + ;
      'Tem a mesma semÉntica do c¢digo de resposta HTTP 301 Moved Permanently com a exceá∆o de que o user-agent n∆o deve mudar ' + hb_osNewLine() + ;
      'o mÇtodo HTTP utilizado: se um POST foi utilizado na primeira requisiá∆o, um POST deve ser utilizado na segunda.' } )

   AAdd( aMsgRetorno, { 400, 'Resposta de erro do Cliente', 'Essa resposta significa que o servidor n∆o entendeu a requisiá∆o pois est† com uma sintaxe inv†lida.' } )
   AAdd( aMsgRetorno, { 401, 'Resposta de erro do Cliente', 'Embora o padr∆o HTTP especifique "unauthorized", semanticamente, essa resposta significa "unauthenticated". ' + hb_osNewLine() + ;
      'ou seja, o cliente deve se autenticar para obter a resposta solicitada.' } )
   AAdd( aMsgRetorno, { 402, 'Resposta de erro do Cliente', 'Este c¢digo de resposta est† reservado para uso futuro. O objetivo inicial da criaá∆o deste c¢digo era us†-lo' + hb_osNewLine() + ;
      ' para sistemas digitais de pagamento porÇm ele n∆o est† sendo usado atualmente.' } )
   AAdd( aMsgRetorno, { 403, 'Resposta de erro do Cliente', 'O cliente n∆o tem direitos de acesso ao conte£do portanto o servidor est† rejeitando dar a resposta. ' + hb_osNewLine() + ;
      'Diferente do c¢digo 401, aqui a identidade do cliente Ç conhecida.' } )
   AAdd( aMsgRetorno, { 404, 'Resposta de erro do Cliente', 'O servidor n∆o pode encontrar o recurso solicitado. Este c¢digo de resposta talvez seja o mais famoso devido ' + hb_osNewLine() + ;
      'Ö frequància com que acontece na web.' } )
   AAdd( aMsgRetorno, { 405, 'Resposta de erro do Cliente', 'O mÇtodo de solicitaá∆o Ç conhecido pelo servidor, mas foi desativado e n∆o pode ser usado.' } )
   AAdd( aMsgRetorno, { 406, 'Resposta de erro do Cliente', 'Essa resposta Ç enviada quando o servidor da Web ap¢s realizar a negociaá∆o de conte£do orientada pelo servidor, ' + hb_osNewLine() + ;
      'n∆o encontra nenhum conte£do seguindo os critÇrios fornecidos pelo agente do usu†rio.' } )
   AAdd( aMsgRetorno, { 407, 'Resposta de erro do Cliente', 'Semelhante ao 401 porem Ç necess†rio que a autenticaá∆o seja feita por um proxy.' } )
   AAdd( aMsgRetorno, { 408, 'Resposta de erro do Cliente', 'Esta resposta Ç enviada por alguns servidores em uma conex∆o ociosa, mesmo sem qualquer requisiá∆o prÇvia pelo cliente. ' + hb_osNewLine() + ;
      'Ela significa que o servidor gostaria de derrubar esta conex∆o em desuso. Esta resposta Ç muito usada j† que alguns navegadores, ' + hb_osNewLine() + ;
      'como Chrome, Firefox 27+, ou IE9, usam mecanismos HTTP de prÇ-conex∆o para acelerar a navegaá∆o. ' + hb_osNewLine() + ;
      'Note tambÇm que alguns servidores meramente derrubam a conex∆o sem enviar esta mensagem.' } )
   AAdd( aMsgRetorno, { 409, 'Resposta de erro do Cliente', 'Esta resposta ser† enviada quando uma requisiá∆o conflitar com o estado atual do servidor.' } )
   AAdd( aMsgRetorno, { 410, 'Resposta de erro do Cliente', 'Esta resposta ser† enviada quando o conte£do requisitado foi permanentemente deletado do servidor, sem nenhum endereáo de redirecionamento.' + hb_osNewLine() + ;
      'ê esperado que clientes removam seus caches e links para o recurso. A especificaá∆o HTTP espera que este c¢digo de status seja usado para ' + hb_osNewLine() + ;
      '"serviáos promocionais de tempo limitado". APIs n∆o devem se sentir obrigadas a indicar que recursos foram removidos com este c¢digo de status.' } )
   AAdd( aMsgRetorno, { 411, 'Resposta de erro do Cliente', 'O servidor rejeitou a requisiá∆o porque o campo Content-Length do cabeáalho n∆o est† definido e o servidor o requer.' } )
   AAdd( aMsgRetorno, { 412, 'Resposta de erro do Cliente', 'O cliente indicou nos seus cabeáalhos prÇ-condiá‰es que o servidor n∆o atende.' } )
   AAdd( aMsgRetorno, { 413, 'Resposta de erro do Cliente', 'A entidade requisiá∆o Ç maior do que os limites definidos pelo servidor; o servidor pode fechar a conex∆o ou retornar um campo de cabeáalho Retry-After. ' } )
   AAdd( aMsgRetorno, { 414, 'Resposta de erro do Cliente', 'A URI requisitada pelo cliente Ç maior do que o servidor aceita para interpretar.' } )
   AAdd( aMsgRetorno, { 415, 'Resposta de erro do Cliente', 'O formato de m°dia dos dados requisitados n∆o Ç suportado pelo servidor, ent∆o o servidor rejeita a requisiá∆o.' } )
   AAdd( aMsgRetorno, { 416, 'Resposta de erro do Cliente', 'O trecho especificado pelo campo Range do cabeáalho na requisiá∆o n∆o pode ser preenchido; Ç poss°vel que o trecho esteja fora do tamanho dos dados da URI alvo.' } )
   AAdd( aMsgRetorno, { 417, 'Resposta de erro do Cliente', 'Este c¢digo de resposta significa que a expectativa indicada pelo campo Expect do cabeáalho da requisiá∆o n∆o pode ser satisfeita pelo servidor.' } )
   AAdd( aMsgRetorno, { 418, 'Resposta de erro do Cliente', 'O servidor recusa a tentativa de coar cafÇ num bule de ch†' } )
   AAdd( aMsgRetorno, { 421, 'Resposta de erro do Cliente', 'A requisiá∆o foi direcionada a um servidor inapto a produzir a resposta. Pode ser enviado por um servidor que n∆o est† configurado ' + hb_osNewLine() + ;
      'para produzir respostas para a combinaá∆o de esquema ("scheme") e autoridade inclusas na URI da requisiá∆o.' } )
   AAdd( aMsgRetorno, { 422, 'Resposta de erro do Cliente', 'A requisiá∆o est† bem formada mas inabilitada para ser seguida devido a erros semÉnticos.' } )
   AAdd( aMsgRetorno, { 423, 'Resposta de erro do Cliente', 'O recurso sendo acessado est† travado.' } )
   AAdd( aMsgRetorno, { 424, 'Resposta de erro do Cliente', 'A requisiá∆o falhou devido a falha em requisiá∆o prÇvia.' } )
   AAdd( aMsgRetorno, { 425, 'Resposta de erro do Cliente', 'Indica que o servidor n∆o est† disposto a arriscar processar uma requisiá∆o que pode ser refeita.' } )
   AAdd( aMsgRetorno, { 426, 'Resposta de erro do Cliente', 'O servidor se recusa a executar a requisiá∆o usando o protocolo corrente mas estar† pronto a fazà-lo ap¢s o cliente atualizar ' + hb_osNewLine() + ;
      'para um protocolo diferente. O servidor envia um cabeáalho Upgrade (en-US) numa resposta 426 para indicar o(s) protocolo(s) requeridos.' } )
   AAdd( aMsgRetorno, { 428, 'Resposta de erro do Cliente', 'O servidor de origem requer que a resposta seja condicional. Feito para prevenir o problema da atualizaá∆o perdida,' + hb_osNewLine() + ;
      'onde um cliente pega o estado de um recurso (GET) , modifica-o, e o p‰e de volta no servidor (PUT), enquanto um terceiro ' + hb_osNewLine() + ;
      'modificou o estado no servidor, levando a um conflito.' } )
   AAdd( aMsgRetorno, { 429, 'Resposta de erro do Cliente', 'O usu†rio enviou muitas requisiá‰es num dado tempo ("limitaá∆o de frequància").' } )
   AAdd( aMsgRetorno, { 431, 'Resposta de erro do Cliente', 'O servidor n∆o quer processar a requisiá∆o porque os campos de cabeáalho s∆o muito grandes. ' + hb_osNewLine() + ;
      'A requisiá∆o PODE ser submetida novemente depois de reduzir o tamanho dos campos de cabeáalho.' } )
   AAdd( aMsgRetorno, { 451, 'Resposta de erro do Cliente', 'O usu†rio requisitou um recurso ilegal, tal como uma p†gina censurada por um governo.' } )

   AAdd( aMsgRetorno, { 500, 'Resposta de erro do Servidor', 'O servidor encontrou uma situaá∆o com a qual n∆o sabe lidar.' } )
   AAdd( aMsgRetorno, { 501, 'Resposta de erro do Servidor', 'O mÇtodo da requisiá∆o n∆o Ç suportado pelo servidor e n∆o pode ser manipulado. ' + hb_osNewLine() + ;
      'Os £nicos mÇtodos exigidos que servidores suportem (e portanto n∆o devem retornar este c¢digo) s∆o GET e HEAD.' } )
   AAdd( aMsgRetorno, { 502, 'Resposta de erro do Servidor', 'Esta resposta de erro significa que o servidor, ao trabalhar como um gateway a fim de obter uma resposta necess†ria ' + hb_osNewLine() + ;
      'para manipular a requisiá∆o, obteve uma resposta inv†lida.' } )
   AAdd( aMsgRetorno, { 503, 'Resposta de erro do Servidor', 'O servidor n∆o est† pronto para manipular a requisiá∆o.' + hb_osNewLine() + ;
      ' Causas comuns s∆o um servidor em manutená∆o ou sobrecarregado. ' + hb_osNewLine() + ;
      'Note que junto a esta resposta, uma p†gina amig†vel explicando o problema deveria ser enviada. ' + hb_osNewLine() + ;
      'Estas respostas devem ser usadas para condiá‰es tempor†rias e o cabeáalho HTTP Retry-After: dever†, se poss°vel, ' + hb_osNewLine() + ;
      'conter o tempo estimado para recuperaá∆o do serviáo. O webmaster deve tambÇm tomar cuidado com os cabeáalhos ' + hb_osNewLine() + ;
      'relacionados com o cache que s∆o enviados com esta resposta, j† que estas respostas de condiá‰es tempor†rias ' + hb_osNewLine() + ;
      'normalmente n∆o deveriam ser postas em cache.' } )
   AAdd( aMsgRetorno, { 504, 'Resposta de erro do Servidor', 'Esta resposta de erro Ç dada quando o servidor est† atuando como um gateway e n∆o obtÇm uma resposta a tempo.' } )
   AAdd( aMsgRetorno, { 505, 'Resposta de erro do Servidor', 'A vers∆o HTTP usada na requisiá∆o n∆o Ç suportada pelo servidor.' } )
   AAdd( aMsgRetorno, { 506, 'Resposta de erro do Servidor', 'O servidor tem um erro de configuraá∆o interno: a negociaá∆o transparente de conte£do para a requisiá∆o resulta ' + hb_osNewLine() + ;
      'em uma referància circular.' } )
   AAdd( aMsgRetorno, { 507, 'Resposta de erro do Servidor', 'O servidor tem um erro interno de configuraá∆o: o recurso variante escolhido est† configurado para entrar em ' + hb_osNewLine() + ;
      'negociaá∆o transparente de conte£do com ele mesmo, e portanto n∆o Ç uma ponta v†lida no processo de negociaá∆o.' } )
   AAdd( aMsgRetorno, { 508, 'Resposta de erro do Servidor', 'O servidor detectou um looping infinito ao processar a requisiá∆o.' } )
   AAdd( aMsgRetorno, { 510, 'Resposta de erro do Servidor', 'Exigem-se extens‰es posteriores Ö requisiá∆o para o servidor atendà-la.' } )
   AAdd( aMsgRetorno, { 511, 'Resposta de erro do Servidor', 'O c¢digo de status 511 indica que o cliente precisa se autenticar para ganhar acesso Ö rede.' } )

   nScan := AScan( aMsgRetorno, {| x | x[ 1 ] = ::nHttpcode } )
   IF nScan > 0
      ::cRetorno := ::cRetorno + aMsgRetorno[ nScan, 2 ] + ':' + AllTrim( Str( aMsgRetorno[ nScan, 1 ] ) ) + ' - ' + aMsgRetorno[ nScan, 3 ]
      // Showmsg_Edit(ALLTRIM(STR(aMsgRetorno[nScan,1]))+ ' - '+aMsgRetorno[nScan,3] ,aMsgRetorno[nScan,2] )
   ELSE
   /*
   Isso n∆o pode est† na classe, se precisar tem que ler o ::cRetorno onde est† chamando a classe - Leonardo Machado - 13/06/2023
   Showmsg_Edit( ::cRetorno ,'Erro Inesperado' )
   */
   ENDIF

   RETURN NIL

// + EOF: classecurl.prg
// +
