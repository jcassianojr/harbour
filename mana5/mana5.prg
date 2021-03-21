*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mana5.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


#INCLUDE "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT
REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX

#INCLUDE "INKEY.CH"


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
function main
para ZUSER,cSENHA,cDEBUG

MVINFOConfTela("MANA5")

netregosok()
HB_IDLESTATE()
HB_LANGSELECT('PT')   



IF VALTYPE(cDEBUG) # "C"
   cDEBUG := "NAO"
ENDIF



IF cDEBUG = "SIM"
   INKEY(0)
ENDIF

deletaarq("TEMP*.*")
deletaarq("*.tmp")
deletaarq("*.LOG")

IF VALTYPE(ZUSER) = "C"
   ZUSER := UPPER(ZUSER)
ENDIF
IF VALTYPE(cSENHA) = "C"
   cSENHA := UPPER(cSENHA)
ENDIF


HB_IDLESTATE()
Set( _SET_CODEPAGE, "PTISO")    
rddsetdefault( "DBFCDX" )
Set( _SET_OPTIMIZE, .t.)
Set( _SET_DELETED, .t.)
Set( _SET_SOFTSEEK, .t.)
__SetCentury( .t. )
Set( _SET_EPOCH, year( date() ) - 60 )
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )


Set( _SET_TYPEAHEAD, 50 )
Set( _SET_WRAP, .t. )
Set( _SET_EXACT, .f. )
SetCursor(.t.)

cRDDEXT := "CDX"


ACENTUA=.T.
SetKey( 39, {|| AC_AGUDO() } )
SetKey( 94, {|| AC_CIRC() } )
SetKey( 96, {|| AC_CRASE() } )
SetKey( 126, {|| AC_TIL() } )
SetKey( K_ALT_S, {|| ACENTUA := ! ACENTUA, ALERT( "Acentuacao: " +if(acentua,"ligada","desligada") )} )   //usar {|| ACENTUA := ! ACENTUA, mds(if(acentua,"ligado","desligado")) }
SetKey( K_F12  , {|| __SetCentury( ! __SetCentury() ) , alert("Seculos em Datas: " +if(__SetCentury(),"ligado","desligado")) } ) //usar {|| __SetCentury( ! __SetCentury() ) , mds(if(__SetCentury(),"ligado","desligado")) }

SetKey( K_F1, {|| HELP() } )  //checar alguns nao tem help

SetKey( K_F2, {|| TELE() } )
SetKey( K_F3, {|| NOTEP() } )
SetKey( K_F4, {|| AGEN() } )
SetKey( K_F5, {|| TECLAS() } )
SetKey( K_F10, {|| MUDADATA() } )

SetKey( K_F8, {|| hb_run("calc") } )



//Inicializa o Mouse Clipper 5.3c
set(_SET_EVENTMASK,HB_INKEY_ALL )
lMOUSE       := mpresent()
MOUSE_X      := 0
MOUSE_Y      := 0
MOUSE_B      := 0
aMENUPROMPTS := {}
if lMOUSE
   clear
   msetbounds()
   msetcursor(.T.)
endif

//  Variavel Para Copy/Cut/Paste no READCUR()
READVAR := ""
//  Zera a Variavel Erro Inicial
HELPARQ := ""
//  Zera Variaveis de Trabalho
ZDDD    := ""
ZCEP    := ""
ZCEPFIM := ""
ZRUA    := ""
ZKM     := 0
LASTCOR := ""
ZERRO:=""
zNERRO:=0

//Variveis de Spool
cARQSPO:=""
nTIPSPO:=0
cIMPCOM:=CHR(15)
cIMPEXP:=CHR(18)
cIMPTIT:=CHR(14)
cIMPNEG:=CHR(27)+CHR(69)
cIMPNER:=CHR(27)+CHR(70)
cIMPORI:=""
lIMPEMAIL:=.F.


//Variavel Uso para Pausa telas de edicao
ZCONTINUA := " "

if ! HB_FILEEXISTS("CONFIGU.DBF")
   ALERTX("Falta Arquivo de Configura‡„o CONFIGU.DBF")
   quit
endif

if ZUSER = "/C"
   M_CD(.F.)
   ALERTX("Reinicie O Sistema")
   CLS
   QUIT
endif

//Pegando Configura‡”es do Sistema
PRIV ZARQHIS,ZARQMAN
PRIV ZARQ,ZARQ1,ZDIRC,ZDIRI,ZDIRP,ZDIRA,ZDIRB,ZDIREx
PRIV ZMOEDA01,ZMOEDA02,ZMOEDA03,ZMOEDA04,ZMOEDA05,ZMOEDA06,zMULTIEMP
PRIV zARQFON,zIMPPAD,ZIMA,ZIMB
if !MCD01()
   ALERTX("Erro Abrindo Arquivos de Configura‡ao")
   quit
endif

//Data do Sistema
ZDATA := date()

ARQENT("MANARQ","MANARQ","ARQUIVO")
ARQENT("MANARQ1","MANARQ1","ARQUIVO+STR(ITEM,2)")
ARQENT("MANOPT","MANOPT","ITEMENU+STR(POSICAO,2)")
ARQENT("MUSER","MUSER","USUARIO")
ARQENT("MUSERM","MUSERM","CONTROLE")
ARQENT("MUSERN","MUSERN","USUARIO")

ZNUMERO := 1
if ZMULTIEMP = 'S'
   @ 24,00 clear
   @ 24,00 say "Digite o Codigo da Empresa"         
   @ 24,40 get ZNUMERO                              
   READCUR()
endif

//Monta Temporariamento o DIRE E CODIGO EMPRESA
ZDIRE := ZDIREx+strzero(ZNUMERO,5)+"\"

ZDIA := day(ZDATA)
ZMES := month(ZDATA)
ZANO := year(ZDATA)
if empty(ZUSER) .or. ZUSER = "/C"
   ZUSER := padr(NNETWHOAMI(),10)
endif
ZROW := 24

//Pegando Configura‡”es de Cores
priv ZCOR001
priv ZCOR002
priv ZCOR003
priv ZCOR004
priv ZCOR005
priv ZCOR006
priv ZCOR007
priv ZCOR008
priv ZCOR009
priv ZCOR010
CORARR({"COR001","COR002","COR003","COR004","COR005","COR006","COR007","COR008","COR009","COR010"},;
 {"ZCOR001","ZCOR002","ZCOR003","ZCOR004","ZCOR005","ZCOR006","ZCOR007","ZCOR008","ZCOR009","ZCOR010"})

//Dados do Cadastro da Empresa
ZREDUZ   := " "
ZPOSI    := 0
ZNIV     := {0,0,0,0,0,0,0,0,0}
ZEMPRESA := space(40)
ZBATE    := 0
ZLANC    := 0
ZMEDIA   := 0
ZCIDADE  := ""
ZUF      := ""
if USEREDE("MANEMP",1,1)
   dbgotop()
   if dbseek(ZNUMERO)
      ZREDUZ   := REDUZIDO
      ZPOSI    := POSI
      ZNIV     := {NIVEL1,NIVEL2,NIVEL3,NIVEL4,NIVEL5,NIVEL6,NIVEL7,NIVEL8,NIVEL9}
      ZEMPRESA := NOME
      ZBATE    := BATE
      ZLANC    := LANC
      ZMEDIA   := if(MEDIA > 0,MEDIA,30)
      ZCIDADE  := ALLTRIM(CIDADE)
      ZESTADO  := ESTADO
   endif
   dbclosearea()
endif
if empty(ZREDUZ)
   MDE("EMP001")
endif
if ZNIV[1] = 0
   ZPICCC := "XXXXXXXXXXX"
   ZTAMCC := 11
else
   ZPICCC := "@R "
   for X := 1 to 9
      if ZNIV[X] > 0
         if X # 1
            ZPICCC += "."
         endif
         ZPICCC += repl("9",ZNIV[X])
      endif
   next X
   ZTAMCC := len(ZPICCC) - 3
endif

//Verifica Arquivo de Log
ZARQERR := "ER"+strzero(day(ZDATA),2)+strzero(month(ZDATA),2)+substr(strzero(year(ZDATA),4),3,2)
CHECKARQ("MANERR",ZARQERR,,,ZDIRP+"LOG\",year(ZDATA),month(ZDATA))

//Chama o Menu Principal
clear

IF AT("__$",ZUSER) > 0 .AND. AT("%__",ZUSER) > 0
   //   ALERTX(ZUSER)
   ZUSER := SUBSTR(ZUSER,4)
   ZUSER := LEFT(ZUSER,LEN(ZUSER) - 3)
   //   ALERTX(ZUSER)
   cSENHA := XDECODE(OBTER("MUSER",ENCODE(ZUSER),"SENHA"))
ENDIF

if empty(cSENHA)
   MDS('Seu nome, por favor: ')
   @ 24,40 get ZUSER         
   if !READCUR()
      quit
   endif
endif

ZUSER  := upper(ZUSER)
ZSUPER := .F.


IF ZUSER = "ADMLOG" .Or. ZUSER = "ADMINISTRADOR" .Or. ZUSER = "ADMIN" 
   cUSUARIO := "SUPERVISOR"
END IF

IF ZUSER = "SUPERVISOR" .AND. ZUSER = "SOFTEC"
   ZSUPER := .T.
ENDIF
IF XDECODE(OBTER("MUSER",ENCODE(ZUSER),"EQUIVALE")) = "SUPERVIS"
   IF cDEBUG = "NAO"
      ALERTX("Acesso Equivalente Supervisor")
   ENDIF
   ZSUPER := .T.
ENDIF
IF !ZSUPER
   if !VERSEHA("MUSER",ENCODE(ZUSER))
      ALERTX("Usuario Nao Cadastrado")
      quit
   endif
   if XDECDAT(OBTER("MUSER",ENCODE(ZUSER),"VALIDADE")) < ZDATA
      ALERTX("Se acesso expirou comunique ao Supervisor")
      quit
   endif
endif

MDS("Senha")
if empty(cSENHA)
   cSENHA := PEGAPASS(24,10,8,,"Ý",.T.)
endif
if cSENHA # XDECODE(OBTER("MUSER",ENCODE(ZUSER),"SENHA"))
   ALERTX("Senha n„o Confere, retente ou comunique ao Supervisor")
   quit
endif
if len(alltrim(cSENHA)) < 8
   ALERTX("Senha com menos de 8 digitos - Troque a Senha")
   M_CI(1)
endif
if ZDATA > OBTER("MUSER",ENCODE(ZUSER),"DATATRO")
   ALERTX("Senha Expirada - Troque a Senha")
   M_CI(1)
endif

mUSUARIO := alltrim(ZUSER)
mID      := alltrim(NNETSTAID())  //criado voltar 1 ate achar compativel harbour
IF cDEBUG = "NAO" .AND. mID # REPL("0",12)
   if ! NOVOREG("MUSERN",mUSUARIO,.F.)
      if ! ZSUPER
         if OBTER("MUSERN",mUSUARIO,"ID") # mID .AND. OBTER("MUSERN",mUSUARIO,"ID") # REPL("0",12)
            ALERTX("Voce esta com o sistema aberto em outro terminal")
            quit
         endif
      endif
   endif
ENDIF

ZIDFOLHA := OBTER("MUSER",ENCODE(ZUSER),"FOLHANO")

IF DAY(OBTER("MP04",ZIDFOLHA,"DEMITIDO",,,,,,CTOD(SPACE(8)))) > 0
   ALERTX("Funcionario: "+str(zidfolha)+" Demitido")
   quit
ENDIF

zUSERCHV:=""
ZUSERENC:=ENCODE(ZUSER)
               FOR X:=1 TO len(ZUSERENC)
			     nCHAR:=ASC(SUBSTR(ZUSERENC,x,1)) 
			      IF NCHAR>0
			      	zUSERCHV+=StrZero(nCHAR,3)
			      ENDIF
			  NEXT
      //alert(zUSERCHV)


IF AT("ITAESBR2",UPPER(CURDIR())) > 0
   ALERTX("Voce esta na Firma II Filial")
ENDIF
IF cDEBUG = "NAO"
   MAIL("MAIL")
ENDIF
MMENU()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ARQENT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function ARQENT(cARQ,cNTX,cEXP,lMES,cDRIVER)


if valtype(lMES) # "L"
   lMES := .T.
endif
IF cRDDEXT = "CDX"
   mTAG := cNTX
ENDIF
cARQ := ZDIRC+cARQ
cNTX := ZDIRC+cNTX
if ! file(cARQ+".DBF")
   if lMES
      ALERTX("Falta Arquivo Configucao "+cARQ)
      quit
   else
      retu .F.
   endif
endif
if ! file(cNTX+".NTX") .AND. ! file(cNTX+".CDX")
   if !USECHK(cARQ,,.F.)
      //USECHK( cARQ, cIND, lSHA, cDRIVER, lNEW,nTIME )
      ALERTX("Erro ao criar Indice do "+cARQ)
      quit
   endif
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   IF cRDDEXT = "CDX"
      index on &cEXP. TAG &mTAG. EVAL ZEI_FORT(nLASTREC,,,1)
   ELSE
      index on &cEXP. to &cNTX. EVAL ZEI_FORT(nLASTREC,,,1)
   ENDIF
   dbclosearea()
endif
retu .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NNETSTAID()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function NNETSTAID()

return "1"
