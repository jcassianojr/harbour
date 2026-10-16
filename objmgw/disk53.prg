*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : disk53.prg
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
*+    Documentado em 16-Out-2026 as  4:12 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "INKEY.CH"

#define CHR_A_AGUDO 193 // Á
#define CHR_a_AGUDO 225 // á
#define CHR_E_AGUDO 201 // É
#define CHR_e_AGUDO 233 // é
#define CHR_I_AGUDO 205 // Í
#define CHR_i_AGUDO 237 // í
#define CHR_O_AGUDO 211 // Ó
#define CHR_o_AGUDO 243 // ó
#define CHR_U_AGUDO 218 // Ú
#define CHR_u_AGUDO 250 // ú
#define CHR_C_CEDIL 199 // Ç
#define CHR_c_CEDIL 231 // ç
#define CHR_A_TIL   195 // Ã
#define CHR_a_TIL   227 // ã
#define CHR_O_TIL   213 // Õ
#define CHR_o_TIL   245 // õ
#define CHR_N_TIL   209 // Ñ
#define CHR_n_TIL   241 // ñ
#define CHR_A_CIRC  194 // Â
#define CHR_a_CIRC  226 // â
#define CHR_E_CIRC  202 // Ê
#define CHR_e_CIRC  234 // ê
#define CHR_I_CIRC  206 // Î
#define CHR_i_CIRC  238 // î
#define CHR_O_CIRC  212 // Ô
#define CHR_o_CIRC  244 // ô
#define CHR_U_CIRC  219 // Û
#define CHR_u_CIRC  251 // û
#define CHR_A_TREM  196 // Ä
#define CHR_a_TREM  228 // ä
#define CHR_E_TREM  203 // Ë
#define CHR_e_TREM  235 // ë
#define CHR_I_TREM  207 // Ï
#define CHR_i_TREM  239 // ï
#define CHR_O_TREM  214 // Ö
#define CHR_o_TREM  246 // ö
#define CHR_U_TREM  220 // Ü
#define CHR_u_TREM  252 // ü
#define CHR_A_CRASE 192 // À
#define CHR_a_CRASE 224 // à
#define CHR_E_CRASE 200 // È
#define CHR_e_CRASE 232 // è
#define CHR_I_CRASE 204 // Ì
#define CHR_i_CRASE 236 // ì
#define CHR_O_CRASE 210 // Ò
#define CHR_o_CRASE 242 // ò
#define CHR_U_CRASE 217 // Ù
#define CHR_u_CRASE 249 // ù
#define CHR_ORD_FEM  170 // ª Ordinal Feminino
#define CHR_ORD_MASC 186 // º Ordinal Masculino
#define CHR_GRAU     176 // ° Grau (Temperatura/Geográfico)
#define CHR_COPY     169 // © Copyright
#define CHR_REG      174 // ® Registrado
#define CHR_SECAO    167 // § Seção

// +--------------------------------------------------------------------
// +
// +    Function Readcur()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Readcur  // DESLIGA E LIGA O CURS PARA UM READ


SetCursor(if(ReadInsert(),1,2))
SetKey(K_ALT_Q,{|| XBHOR()})  // --CONVERT hora to decimal  *100/60
SetKey(K_ALT_W,{|| XCHOR()})  // --CONVERT decimal to horas  *60/100
SetKey(K_ALT_I,{|| XLERTXT()})  // -Le um Arquivo de Texto
// --SetKey( K_ALT_V, {|| hb_gtInfo( HB_GTI_CLIPBOARDPASTE, .T. ) } ) //necessario estar em hmg
SetKey(K_ALT_O,{|| XPOSESQ()})
SetKey(K_ALT_P,{|| XPOSDIR()})
SetKey(K_ALT_F,{|| XGRATXT()})
SetKey(K_ALT_G,{|| XCENTER()})
SetKey(K_ALT_H,{|| xcaptxt()})
SetKey(K_ALT_J,{|| xediwor()})
SetKey(K_ALT_K,{|| xtirace()})
SetKey(K_ALT_L,{|| XEXPAND()})
SetKey(K_ALT_B,{|| XCAPFIRS()})
SetKey(K_ALT_N,{|| XCONVMIN()})
SetKey(K_ALT_M,{|| XCONVMAI()})
SetKey(K_ALT_INS,{|| XALTINS()})
SetKey(K_CTRL_DEL,{|| XCTRLDEL()})
SetKey(K_CTRL_INS,{|| XCTRLINS()})


READ
SetKey(K_ALT_INS,nil)
SetKey(K_CTRL_DEL,nil)
SetKey(K_CTRL_INS,nil)
SetKey(K_ALT_B,nil)
SetKey(K_ALT_N,nil)
SetKey(K_ALT_M,nil)
SetKey(K_ALT_L,nil)
SetKey(K_ALT_K,nil)
SetKey(K_ALT_J,nil)
SetKey(K_ALT_H,nil)
SetKey(K_ALT_G,nil)
SetKey(K_ALT_F,nil)
SetKey(K_ALT_O,nil)
SetKey(K_ALT_P,nil)
SetKey(K_ALT_I,nil)
SetKey(K_ALT_Q,nil)
SetKey(K_ALT_W,nil)
SetCursor(0)
IF LastKey() == K_ESC
   RETURN .F.
ENDIF

RETURN .T.



// +--------------------------------------------------------------------
// +
// +    Function Xctrldel()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xctrldel(p,l,v)


IF ValType(v) = "U"
   RETURN .T.
ENDIF
READVAR := &v.
KEYBOARD Chr(1)+Chr(25)

RETURN .T.



// +--------------------------------------------------------------------
// +
// +    Function Xbhor()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xbhor(p,l,v)


LOCAL nHORA

IF ValType(v) = "U"
   RETURN .T.
ENDIF
nHORA := &v.
IF ValType(nHORA) = "N"
   &V. := bhor(nHORA)
ENDIF

RETURN .T.



// +--------------------------------------------------------------------
// +
// +    Function Xchor()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xchor(p,l,v)


IF ValType(v) = "U"
   RETURN .T.
ENDIF
nHORA := &v.
IF ValType(nHORA) = "N"
   &V. := chor(nHORA)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function Xctrlins()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xctrlins(p,l,v)


IF ValType(v) = "U"
   RETURN .T.
ENDIF
READVAR := &v.

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XCENTER()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XCENTER(P,L,V)


LOCAL cTEXTO
LOCAL nLEN

IF ValType(v) = "U"
   RETURN .T.
ENDIF
cTEXTO := &v.
IF ValType(cTEXTO) = "C"
   nLEN := Len(cTEXTO)
   &V.  := PadC(AllTrim(cTEXTO),nLEN)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XPOSDIR()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XPOSDIR(P,L,V)


LOCAL cTEXTO
LOCAL nLEN

IF ValType(v) = "U"
   RETURN .T.
ENDIF
cTEXTO := &v.
IF ValType(cTEXTO) = "C"
   nLEN := Len(cTEXTO)
   &V.  := PadR(AllTrim(cTEXTO),nLEN)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XPOSESQ()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XPOSESQ(P,L,V)


LOCAL cTEXTO
LOCAL nLEN

IF ValType(v) = "U"
   RETURN .T.
ENDIF
cTEXTO := &v.
IF ValType(cTEXTO) = "C"
   nLEN := Len(cTEXTO)
   &V.  := PadL(AllTrim(cTEXTO),nLEN)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function Xaltins()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xaltins


READVAR := AllTrim(Strval(READVAR))
KEYBOARD READVAR

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function Xcapfirs()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xcapfirs(p,l,v)


LOCAL texto
LOCAL nLEN

IF ValType(v) = "U"
   RETURN .T.
ENDIF
texto := &v.
IF ValType(TEXTO) = "C"
   nLEN  := Len(TEXTO)
   texto := Convmini(texto)
   texto := Capfirs2(texto)
   &v.   := PadR(texto,nLEN)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XEXPAND()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XEXPAND(P,L,V)


LOCAL cTEXTO
LOCAL nLEN

IF ValType(v) = "U"
   RETURN .T.
ENDIF
cTEXTO := &v.
IF ValType(cTEXTO) = "C"
   &V. := expand(cTEXTO)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XCONVMIN()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XCONVMIN(P,L,V)


LOCAL texto

IF ValType(v) = "U"
   RETURN .T.
ENDIF
TEXTO := &V.
IF ValType(TEXTO) = "C"
   &V. := CONVMINI(TEXTO)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function Xconvmai()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Xconvmai(p,l,v)


LOCAL texto

IF ValType(v) = "U"
   RETURN .T.
ENDIF
texto := &v
IF ValType(TEXTO) = "C"
   &v. := Convmais(texto)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function xcaptxt()
// +
// +--------------------------------------------------------------------
// +
FUNCTION xcaptxt


LOCAL CURSOR  := SetCursor(1)
LOCAL getlist := {}

// priv nomearq  := space( 60 )
// @ 24, 00 clea
// @ 24, 01 say "Digite o nome do Arquivo"
// @ 24, 40 get nomearq                    pict "@S40"
// read
// nomearq := alltrim( nomearq )
nomearq := win_GetOpenFileName(,"Ler conteudo",hb_cwd(),"txt","*.txt",1)
IF File(nomearq)
   IF Filesize(nomearq) > 64000
      ALERTX("Arquivo muito Grande")
   ELSE
      READVAR := hb_MemoRead(nomearq)
   ENDIF
ELSE
   ALERTX("Nao Encontrei o Arquivo")
ENDIF
@ 24,00 clea
SetCursor(CURSOR)

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XGRATXT()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XGRATXT


LOCAL GETLIST := {}
LOCAL CURSOR  := SetCursor(1)

// priv NOMEARQ  := space( 60 )
// @ 24, 00 clea
// @ 24, 01 say "Digite o nome do Arquivo"
// @ 24, 40 get NOMEARQ                    pict "@S40"
// read
// NOMEARQ := alltrim( NOMEARQ )
NOMEARQ := WIN_GETSAVEFILENAME(,"Salvar conteudo",hb_cwd(),"txt","*.txt",1)
hb_MemoWrit(NOMEARQ,StrTran(STRVAL(READVAR),Chr(141)+Chr(10),Chr(13)+Chr(10)))
SetCursor(CURSOR)
@ 24,00 clea

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function xediwor()
// +
// +--------------------------------------------------------------------
// +
FUNCTION xediwor


edi_cur := SetCursor()
edi_row := Row()
edi_col := Col()
edi_scr := SaveScreen(00,00,24,79)
edi_cor := SetColor()
READVAR := AllTrim(Strval(READVAR))
cls
lstatus := 0
cSTATUS := 0
SetColor("N/W")
@ 00,00 CLEAR TO 00,79
@ 24,00 CLEAR TO 24,79
@ 00,00 SAY " Linha:"+spac(6)+"Coluna:    íí Mover: "+Chr(24)+" "+Chr(25)+" PGUP PGDN ^PGDN ^PGUP         í Sair: ESC "         
@ 24,01 SAY 'Ctrl+W -> Grava, ESC -> Anula, Alt+T ->Teclas '                                                                    
SetColor("W/R")
SetCursor(if(ReadInsert(),1,2))
READVAR := MemoEdit(READVAR,01,00,24 - 1,79,.T.,)
SetCursor(edi_cur)
SetColor(edi_cor)
RestScreen(00,00,24,79,edi_scr)
SetPos(edi_row,edi_col)

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function xtirace()
// +
// +--------------------------------------------------------------------
// +
FUNCTION xtirace(p,l,v)


LOCAL texto

IF ValType(v) = "U"
   RETURN .T.
ENDIF
texto := &v.
IF ValType(TEXTO) = "C"
   &v. := tirace(texto)
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function Nobreak()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Nobreak()


// clear typeahead
hb_keyClear()
KEYBOARD ""

RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function XLERTXT()
// +
// +--------------------------------------------------------------------
// +
FUNCTION XLERTXT


LOCAL GETLIST := {}
LOCAL CURSOR  := SetCursor(1)
PRIV DADO     := Space(80)

@ 24,00
@ 24,01 SAY "Digite o nome do Arquivo"                    
@ 24,40 GET DADO                       PICT "@S40"        
READ
VERTXT(DADO)

RETURN .T.



// +--------------------------------------------------------------------
// +
// +    Function ACEPAD()
// +
// +--------------------------------------------------------------------
// +
FUNCTION ACEPAD(cSTR,nTAM)


RETURN PadR(AllTrim(Upper(TIRACE(cSTR))),nTAM)


// +--------------------------------------------------------------------
// +
// +    Function Convmini()
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Convmini(texto)


IF ValType(TEXTO) = "C"
   texto := Lower(texto)
   TEXTO := CHARCONV(TEXTO,"UACENTO","LACENTO")
ENDIF

RETURN texto

// +--------------------------------------------------------------------
// +
// +    Function Convmais()
// +
// +--------------------------------------------------------------------
// +
FUNCTION Convmais(texto)


IF ValType(TEXTO) = "C"
   texto := Upper(texto)
   TEXTO := CHARCONV(TEXTO,"LACENTO","UACENTO")
ENDIF

RETURN texto


// +--------------------------------------------------------------------
// +
// +    Function tirace()
// +
// +--------------------------------------------------------------------
// +
FUNCTION tirace(texto)


IF ValType(TEXTO) = "C"
   texto := tirace2(texto)
ENDIF

RETURN texto


// +--------------------------------------------------------------------
// +
// +    Function CHARCONV()
// +
// +--------------------------------------------------------------------
// +
FUNCTION CHARCONV(cTEXTO,eORI,eDES)


LOCAL nLEN
LOCAL aORI
LOCAL aDES
LOCAL X

IF ValType(eORI) = "C"
   DO CASE
   CASE eORI = "OEM" .AND. eDES = "ANSI"
      cTEXTO := convansi(ctexto)
   CASE eORI = "ANSI" .AND. eDES = "OEM"
      cTEXTO := convoem(cTEXTO)
   CASE eORI = "UACENTO"  //converte acentos minusculos para maisuculos PTISO
      cTEXTO := ConverterAcentos(cTexto,"UACENTO")
   CASE eORI = "UACETIR"  //remove acentos maisculos  PTISO
      cTEXTO := ConverterAcentos(cTexto,"UACETIR")
   CASE eORI = "LACENTO"  //converte acentos maisculos para minusculos PTISO
      cTEXTO := ConverterAcentos(cTexto,"LACENTO")
   CASE eORI = "LACETIR"  //remove acentos minusculos PTISO
      cTEXTO := ConverterAcentos(cTexto,"LACETIR")
   CASE eORI = "TIRACE"
      cTEXTO := TIRACE(cTexto)
   OTHERWISE
      aORI := CHARCNVMT(eORI)   //Monta array origem
      aDES := CHARCNVMT(eDES)   //Monta array destino
      nLEN := Len(aORI)
      FOR X := 1 TO nLEN
         cTEXTO := StrTran(cTEXTO,aORI[X],aDES[X])
      NEXT
   ENDCASE
ENDIF
IF ValType(eORI) = "A" .AND. ValType(eDES) = "A"
   nLEN := Len(eORI)
   FOR X := 1 TO nLEN
      cTEXTO := StrTran(cTEXTO,eORI[X],eDES[X])
   NEXT
ENDIF

RETURN cTEXTO


// +--------------------------------------------------------------------
// +
// +    Function CHARCNVMT()
// +
// +--------------------------------------------------------------------
// +
FUNCTION CHARCNVMT(eCNV)


LOCAL aRETU
LOCAL X

areturn := {}
IF ValType(eCNV) = "C"
   DO CASE
   CASE eCNV = "UACENTO"  // Retorna Array com acentuadas maiúsculas
      aRETU := {Chr(CHR_A_AGUDO),Chr(CHR_E_AGUDO),Chr(CHR_I_AGUDO),Chr(CHR_O_AGUDO),Chr(CHR_U_AGUDO),Chr(CHR_C_CEDIL),Chr(CHR_A_TIL),Chr(CHR_O_TIL),Chr(CHR_A_CIRC),Chr(CHR_E_CIRC),Chr(CHR_O_CIRC),Chr(CHR_U_CIRC),Chr(CHR_A_CRASE)}

   CASE eCNV = "UACETIR"  // Retorna Array correspondente SEM acento (Maiúsculas)
      aRETU := {"A","E","I","O","U","C","A","O","A","E","O","U","A"}

   CASE eCNV = "LACENTO"  // Retorna Array com acentuadas minúsculas
      aRETU := {Chr(CHR_a_AGUDO),Chr(CHR_e_AGUDO),Chr(CHR_i_AGUDO),Chr(CHR_o_AGUDO),Chr(CHR_u_AGUDO),Chr(CHR_c_CEDIL),Chr(CHR_a_TIL),Chr(CHR_o_TIL),Chr(CHR_a_CIRC),Chr(CHR_e_CIRC),Chr(CHR_o_CIRC),Chr(CHR_u_CIRC),Chr(CHR_a_CRASE)}

   CASE eCNV = "LACETIR"  // Retorna Array correspondente SEM acento (Minúsculas)
      aRETU := {"a","e","i","o","u","c","a","o","a","e","o","u","a"}
   ENDCASE
ENDIF
IF ValType(eCNV) = "A"
   areturn := eCNV
ENDIF
IF ValType(eCNV) = "C"
   nLEN := Len(eCNV)
   FOR X := 1 TO nLEN
      DO CASE
      CASE SubStr(eCNV,X,1) = chr(170)  // ª Ordinal Feminino
         AAdd(aRETU,"a.")
      CASE SubStr(eCNV,X,1) = chr(186)  // º Ordinal Masculino
         AAdd(aRETU,"o.")
      OTHERWISE
         AAdd(aRETU,SubStr(eCNV,X,1))
      ENDCASE
   NEXT X
ENDIF

RETURN aRETU



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ConverterAcentos()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION ConverterAcentos(cTexto,cAcao)   //usando ptiso do define

LOCAL aOri := {},aDes := {},i

// Definição dos mapeamentos baseados em CHR()
LOCAL aMaiAcent := {Chr(CHR_A_AGUDO),Chr(CHR_E_AGUDO),Chr(CHR_I_AGUDO),Chr(CHR_O_AGUDO),Chr(CHR_U_AGUDO),;
 Chr(CHR_C_CEDIL),Chr(CHR_A_TIL),Chr(CHR_O_TIL),Chr(CHR_N_TIL),Chr(CHR_A_CIRC),;
 Chr(CHR_E_CIRC),Chr(CHR_I_CIRC),Chr(CHR_O_CIRC),Chr(CHR_U_CIRC),Chr(CHR_A_TREM),;
 Chr(CHR_A_CRASE)}

LOCAL aMinAcent := {Chr(CHR_a_AGUDO),Chr(CHR_e_AGUDO),Chr(CHR_i_AGUDO),Chr(CHR_o_AGUDO),Chr(CHR_u_AGUDO),;
 Chr(CHR_c_CEDIL),Chr(CHR_a_TIL),Chr(CHR_o_TIL),Chr(CHR_n_TIL),Chr(CHR_a_CIRC),;
 Chr(CHR_e_CIRC),Chr(CHR_i_CIRC),Chr(CHR_o_CIRC),Chr(CHR_u_CIRC),Chr(CHR_a_TREM),;
 Chr(CHR_a_CRASE)}

LOCAL aSemAcentMAI := {"A","E","I","O","U","C","A","O","N","A","E","I","O","U","A","A"}
LOCAL aSemAcentmin := {"a","e","i","o","u","c","a","o","n","a","e","i","o","u","a","a"}

DO CASE
CASE cAcao == "UACETIR" 
   aOri := aMaiAcent
   aDes := aSemAcentMAI
CASE cAcao == "LACETIR" 
   aOri := aMinAcent
   aDes := aSemAcentmin
CASE cAcao == "UACENTO" 
   aOri := aMinAcent
   aDes := aMaiAcent
CASE cAcao == "LACENTO" 
   aOri := aMaiAcent
   aDes := aMinAcent
ENDCASE

// Aplica as trocas
FOR i := 1 TO Len(aOri)
   cTexto := StrTran(cTexto,aOri[i],aDes[i])
NEXT

RETURN cTexto

// +--------------------------------------------------------------------
// +
// +    Function tirace2()
// +
// +--------------------------------------------------------------------
// +
FUNCTION tirace2(cXml)


LOCAL nCont,cRemoveTag,cLetra,nPos,lTroca,nAscii

cRemoveTag := {;
 [< ? xml version = "1.0" encoding = "utf-8" ? >],;   // Petrobras inventou de usar assim
 [< ? xml version = "1.0" encoding = "ISO-8859-1" ? >],;  // Petrobras agora assim
 [< ? xml version = "1.0" encoding = "UTF-8" ? >],;   // o mais correto
 [< ? xml version = "1.00" ? >],;
 [< ? xml version = "1.0" ? >]}

FOR nCont := 1 TO Len(cRemoveTag)
   cXml := StrTran(cXml,cRemoveTag[nCont],"")
NEXT


IF ! Chr(34) $ cXml // Pode ser usado aspas simples
      cXml := StrTran( cXml, Chr(39), Chr(34) )
   ENDIF

IF Chr(195) $ cXml
   nPos := At (Chr(195),cXml)
   IF Asc(SubStr(cXml,nPos+1)) > 122
      cXml := hb_UTF8ToStr(cXml)
   ENDIF
ENDIF
FOR nCont := 1 TO 2
   cXml := StrTran(cXml,Chr(26),"")
   cXml := StrTran(cXml,Chr(13),"")
   cXml := StrTran(cXml,Chr(10),"")
   IF SubStr(cXml,1,1) $ Chr(239)+Chr(187)+Chr(191)
      cXml := SubStr(cXml,2)
   ENDIF
   cXml := StrTran(cXml," />","/>")
   cXml := StrTran(cXml,Chr(195)+Chr(173),"i")
   cXml := StrTran(cXml,Chr(195)+Chr(135),"C")
   cXml := StrTran(cXml,Chr(195)+Chr(141),"I")
   cXml := StrTran(cXml,Chr(195)+Chr(163),"a")
   cXml := StrTran(cXml,Chr(195)+Chr(167),"c")
   cXml := StrTran(cXml,Chr(195)+Chr(161),"a")
   cXml := StrTran(cXml,Chr(195)+Chr(131),"A")
   cXml := StrTran(cXml,Chr(194)+Chr(186),"o.")
   cxml := StrTran(cxml,Chr(195)+Chr(162),"a")
   cxml := StrTran(cxml,Chr(195)+Chr(161),"a")
   cxml := StrTran(cxml,Chr(195)+Chr(163),"a")
   cxml := StrTran(cxml,Chr(195)+Chr(173),"i")
   cxml := StrTran(cxml,Chr(195)+Chr(179),"o")
   cxml := StrTran(cxml,Chr(195)+Chr(167),"c")
   cxml := StrTran(cxml,Chr(195)+Chr(169),"e")
   cxml := StrTran(cxml,Chr(195)+Chr(170),"e")
   cxml := StrTran(cxml,Chr(195)+Chr(181),"o")
   cxml := StrTran(cxml,Chr(195)+Chr(160),"o")
   cxml := StrTran(cxml,Chr(195)+Chr(181),"o")
   cxml := StrTran(cxml,Chr(195)+Chr(129),"A")
   cxml := StrTran(cxml,Chr(226)+Chr(128)+Chr(156),[ * ])   // aspas de destaque "cames"
   cxml := StrTran(cxml,Chr(226)+Chr(128)+Chr(157),[ * ])   // aspas de destaque "cames"
   cxml := StrTran(cxml,Chr(195)+Chr(180),"o")
   cxml := StrTran(cxml,Chr(195)+Chr(186),"u")
   cxml := StrTran(cxml,Chr(195)+Chr(147),"O")
   cxml := StrTran(cxml,Chr(226)+Chr(128)+Chr(153),[ ])   // caixa d'agua
   cxml := StrTran(cxml,Chr(226)+Chr(128)+Chr(147),[ - ])   // - mesmo
   cxml := StrTran(cxml,Chr(194)+Chr(179),[ 3 ])  // m3
   // so pra corrigir no MySql
   cXml := StrTran(cXml,"+"+Chr(129),"A")
   cXml := StrTran(cXml,"+"+Chr(137),"E")
   cXml := StrTran(cXml,"+"+Chr(131),"A")
   cXml := StrTran(cXml,"+"+Chr(135),"C")
   cXml := StrTran(cXml,"?"+Chr(167),"c")
   cXml := StrTran(cXml,"?"+Chr(163),"a")
   cXml := StrTran(cXml,"?"+Chr(173),"i")
   cXml := StrTran(cXml,"?"+Chr(131),"A")
   cXml := StrTran(cXml,"?"+Chr(161),"a")
   cXml := StrTran(cXml,"?"+Chr(141),"I")
   cXml := StrTran(cXml,"?"+Chr(135),"C")
   cXml := StrTran(cXml,Chr(195)+Chr(156),"a")
   cXml := StrTran(cXml,Chr(195)+Chr(159),"A")
   cXml := StrTran(cXml,"?"+Chr(129),"A")
   cXml := StrTran(cXml,"?"+Chr(137),"E")
   cXml := StrTran(cXml,Chr(195)+"?","C")
   cXml := StrTran(cXml,"?"+Chr(149),"O")
   cXml := StrTran(cXml,"?"+Chr(154),"U")
   cXml := StrTran(cXml,"+"+Chr(170),"o")
   cXml := StrTran(cXml,"?"+Chr(128),"A")
   cXml := StrTran(cXml,Chr(195)+Chr(166),"e")
   cXml := StrTran(cXml,Chr(135)+Chr(227),"ca")
   cXml := StrTran(cXml,"n"+Chr(227),"na")
   cXml := StrTran(cXml,Chr(162),"o")
   cXml := StrTran(cXml," "+Chr(241)+" "," ")
   cXml := StrTran(cXml,Chr(176),"")  // graus
   cXml := StrTran(cXml,Chr(186),"o")   // numero
   cXml := StrTran(cXml,Chr(220),"U")   // u com trema
   cXml := StrTran(cXml,Chr(170),"")  // desconhecido
NEXT
FOR nCont := 1 TO Len(cXml)
   cLetra := SubStr(cXml,nCont,1)
   nAscii := Asc(cLetra)
   lTroca := .T.
   DO CASE
   CASE cLetra $ "abcdefghijklmnopqrstuvwxyz"
      lTroca := .F.
   CASE cLetra $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      lTroca := .F.
   CASE cLetra $ "01234567889"
      lTroca := .F.
   CASE cLetra $ ",.:/;%*$@?<>()+-#=:_"+Chr(34)+Chr(32)
      lTroca := .F.
   CASE nAscii == 231
      cLetra := "c"
   CASE nAscii == 199
      cLetra := "C"
   CASE AScan({193,194,195,192},nAscii) != 0
      cLetra := "A"
   CASE AScan({224,225,226,227,228,229},nAscii) != 0
      cLetra := "a"
   CASE AScan({242,243,244,245,246},nAscii) != 0
      cLetra := "o"
   CASE AScan({210,211,212,213,214},nAscii) != 0
      cLetra := "O"
   CASE AScan({200,201,202,203},nAscii) != 0
      cLetra := "E"
   CASE AScan({232,233,234,235},nAscii) != 0
      cLetra := "e"
   CASE AScan({236,237,238,239},nAscii) != 0
      cLetra := "i"
   CASE AScan({204,205,206,207},nAscii) != 0
      cLetra := "I"
   CASE AScan({249,250,251,252},nAscii) != 0
      cLetra := "u"
   CASE AScan({217,218,219},nAscii) != 0
      cLetra := "U"
   CASE nAscii == 128   // experimental
      cLetra := "C"
   CASE nAscii == 144   // experimental
      cLetra := "E"
   CASE nAscii == 248   // experimental
      cLetra := ""
   CASE nAscii == 167   // experimental
      cLetra := "o"
   ENDCASE
   IF lTroca
      cXml := SubStr(cXml,1,nCont - 1)+cLetra+SubStr(cXml,nCont+1)
   ENDIF
NEXT

RETURN cXml


*+ EOF: disk53.prg
*+
