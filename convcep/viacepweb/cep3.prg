/*******************************************************************************
 *  Test the use of classes to check the Brazilian postal code (CEP) 
 *em
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
 
announce HB_GTSYS
request  HB_GT_WVT_DEFAULT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX
 
PROCEDURE Main( cCEP )

   LOCAL oCep


HB_IDLESTATE()

    
setmode(25,80)	
cls
	
rddsetdefault( "DBFCDX" )
SET OPTIMIZE ON
set deleted on
set softseek on
   Set( _SET_CODEPAGE, "PTISO")
   CLS
   
   nGRAVA:=FCREATE("cepruaimp.csv")
   cLINHA:="cep,codibge,rua,obs,bairro,cidade,uf"+HB_OSNEWLINE()
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
					  //INKEY(0)
					  
					  cCEP:=STRTRAN(oCep:cCEP,"-","")	
					  cCIDADE:=STRTRAN(oCep:cLocalidade,'"',"")
					  
					 
					  dbselectar("cepruaimp")
					  dbappend()
					  field->cep:=cCEP
					  field->codibge:=oCep:cIBGE 
					  field->rua:=UPPER(oCep:cLogradouro)
					  field->obs:=UPPER(oCep:cComplemento)
					  field->bairro:=UPPER(oCep:cBairro)
					  field->cidade:=UPPER(cCIDADE)
					  field->uf:=UPPER(oCep:cUF)
					 // field->DDD:=UPPER(oCep:cDDD)
					  
					  
					  
					 
						cLINHA:=cCEP+","+oCep:cIBGE+","+oCep:cLogradouro+","+oCep:cComplemento+","+oCep:cBairro+","+CCIDADE+","+oCep:cUF+HB_OSNEWLINE()
							 
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
	  
RETURN


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

   oHttp := TIPClientHTTP():new( "http://viacep.com.br/ws/" + cCEP + "/piped/" )

   IF ! oHttp:open()
      alert('open erro')
	  QUIT
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
  
  
FUNCTION TRATANOME(cNOME)
//cNOME:=XmlTransform( cNOME)
//cNOME:=STRTRAN(cNOME,","," ")
//cNOME:=STRTRAN(cNOME,"‚","e")
RETURN cNOME



FUNCTION XmlTransform( cXml )

   LOCAL nCont, cRemoveTag, cLetra, nPos, lTroca, nAscii


   cRemoveTag := { ;
      [<?xml version="1.0" encoding="utf-8"?>], ; // Petrobras inventou de usar assim
      [<?xml version="1.0" encoding="ISO-8859-1"?>], ; // Petrobras agora assim
      [<?xml version="1.0" encoding="UTF-8"?>], ; // o mais correto
      [<?xml version="1.0" encoding="UTF-8" standalone="yes"?>], ;
      [<?xml version="1.00"?>], ;
      [<?xml version="1.0"?>] }

   cXml := AllTrim( cXml )
   FOR nCont = 1 TO Len( cRemoveTag )
      cXml := StrTran( cXml, cRemoveTag[ nCont ], "" )
   NEXT
   IF ! ["] $ cXml // Pode ser usado aspas simples
      cXml := StrTran( cXml, ['], ["] )
   ENDIF
   IF Chr(195) $ cXml
      nPos := At( Chr(195), cXml )
      IF Asc( Substr( cXml, nPos + 1 ) ) > 122
         cXml := hb_Utf8ToStr( cXml )
      ENDIF
   ENDIF
   
   
   FOR nCont = 1 TO 2
      cXml := StrTran( cXml, Chr(26), "" )
      cXml := StrTran( cXml, Chr(13), "" )
      cXml := StrTran( cXml, Chr(10), "" )
      IF Substr( cXml, 1, 1 ) $ Chr(239) + Chr(187) + Chr(191)
         cXml := Substr( cXml, 2 )
      ENDIF
      cXml := StrTran( cXml, " />", "/>" )
      cXml := StrTran( cXml, Chr(195) + Chr(173), "i" )
      cXml := StrTran( cXml, Chr(195) + Chr(135), "C" )
      cXml := StrTran( cXml, Chr(195) + Chr(141), "I" )
      cXml := StrTran( cXml, Chr(195) + Chr(163), "a" )
      cXml := StrTran( cXml, Chr(195) + Chr(167), "c" )
      cXml := StrTran( cXml, Chr(195) + Chr(161), "a" )
      cXml := StrTran( cXml, Chr(195) + Chr(131), "A" )
      cXml := StrTran( cXml, Chr(194) + Chr(186), "o." )
      cxml := StrTran( cxml, Chr(195) + Chr(162), "a" )
      cxml := StrTran( cxml, Chr(195) + Chr(161), "a" )
      cxml := StrTran( cxml, Chr(195) + Chr(163), "a" )
      cxml := StrTran( cxml, Chr(195) + Chr(173), "i" )
      cxml := StrTran( cxml, Chr(195) + Chr(179), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(167), "c" )
      cxml := StrTran( cxml, Chr(195) + Chr(169), "e" )
      cxml := StrTran( cxml, Chr(195) + Chr(170), "e" )
      cxml := StrTran( cxml, Chr(195) + Chr(181), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(160), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(181), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(129), "A" )
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(156), [*] ) // aspas de destaque "cames"
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(157), [*] ) // aspas de destaque "cames"
      cxml := StrTran( cxml, Chr(195) + Chr(180), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(186), "u" )
      cxml := StrTran( cxml, Chr(195) + Chr(147), "O" )
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(153), [ ] ) // caixa d'agua
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(147), [-] ) // - mesmo
      cxml := StrTran( cxml, Chr(194) + Chr(179), [3] ) // m3
      // so pra corrigir no SQL
      cXml := StrTran( cXml, "+" + Chr(129), "A" )
      cXml := StrTran( cXml, "+" + Chr(137), "E" )
      cXml := StrTran( cXml, "+" + Chr(131), "A" )
      cXml := StrTran( cXml, "+" + Chr(135), "C" )
      cXml := StrTran( cXml, "?" + Chr(167), "c" )
      cXml := StrTran( cXml, "?" + Chr(163), "a" )
      cXml := StrTran( cXml, "?" + Chr(173), "i" )
      cXml := StrTran( cXml, "?" + Chr(131), "A" )
      cXml := StrTran( cXml, "?" + Chr(161), "a" )
      cXml := StrTran( cXml, "?" + Chr(141), "I" )
      cXml := StrTran( cXml, "?" + Chr(135), "C" )
      cXml := StrTran( cXml, Chr(195) + Chr(156), "a" )
      cXml := StrTran( cXml, Chr(195) + Chr(159), "A" )
      cXml := StrTran( cXml, "?" + Chr(129), "A" )
      cXml := StrTran( cXml, "?" + Chr(137), "E" )
      cXml := StrTran( cXml, Chr(195) + "?", "C" )
      cXml := StrTran( cXml, "?" + Chr(149), "O" )
      cXml := StrTran( cXml, "?" + Chr(154), "U" )
      cXml := StrTran( cXml, "+" + Chr(170), "o" )
      cXml := StrTran( cXml, "?" + Chr(128), "A" )
      cXml := StrTran( cXml, Chr(195) + Chr(166), "e" )
      cXml := StrTran( cXml, Chr(135) + Chr(227), "ca" )
      cXml := StrTran( cXml, "n" + Chr(227), "na" )
      cXml := StrTran( cXml, Chr(162), "o" )
      cXml := StrTran( cXml, " " + Chr(241) + " ", " " )
      cXml := StrTran( cXml, Chr(176), "" ) // graus
      cXml := StrTran( cXml, Chr(186), "o" ) // numero
      cXml := StrTran( cXml, Chr(220), "U" ) // u com trema
      cXml := StrTran( cXml, Chr(170), "" ) // desconhecido
   NEXT
   FOR nCont = 1 TO Len( cXml )
      cLetra := Substr( cXml, nCont, 1 )
      nAscii := Asc( cLetra )
      lTroca := .T.
      DO CASE
      CASE cLetra $ "abcdefghijklmnopqrstuvwxyz"; lTroca := .F.
      CASE cLetra $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; lTroca := .F.
      CASE cLetra $ "01234567889"; lTroca := .F.
      CASE cLetra $ ",.:/;%*$@?<>()+-#=:_" + Chr(34) + Chr(32); lTroca := .F.
      CASE nAscii == 231; cLetra := "c"
      CASE nAscii == 199; cLetra := "C"
      CASE hb_AScan( { 193, 194, 195, 192 }, nAscii ) != 0 ; cLetra := "A"
      CASE hb_AScan( { 224, 225, 226, 227, 228, 229 }, nAscii ) != 0 ; cLetra := "a"
      CASE hb_AScan( { 242, 243, 244, 245, 246 }, nAscii ) != 0 ; cLetra := "o"
      CASE hb_AScan( { 210, 211, 212, 213, 214 }, nAscii ) != 0 ; cLetra := "O"
      CASE hb_AScan( { 200, 201, 202, 203 }, nAscii ) != 0 ; cLetra := "E"
      CASE hb_AScan( { 232, 233, 234, 235 }, nAscii ) != 0 ; cLetra := "e"
      CASE hb_AScan( { 236, 237, 238, 239 }, nAscii ) != 0 ; cLetra := "i"
      CASE hb_AScan( { 204, 205, 206, 207 }, nAscii ) != 0 ; cLetra := "I"
      CASE hb_AScan( { 249, 250, 251, 252 }, nAscii ) != 0 ; cLetra := "u"
      CASE hb_AScan( { 217, 218, 219 }, nAscii ) != 0 ; cLetra := "U"
      CASE nAscii == 128 ; cLetra := "C" // experimental
      CASE nAscii == 144 ; cLetra := "E" // experimental
      CASE nAscii == 248 ; cLetra := "" // experimental
      CASE nAscii == 167 ; cLetra := "o" // experimental
      ENDCASE
      IF lTroca
         cXml := Substr( cXml, 1, nCont - 1 ) + cLetra + Substr( cXml, nCont + 1 )
      ENDIF
   NEXT

   RETURN cXml
