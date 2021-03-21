*:*****************************************************************************
*:
*:      FOLHA.PRG: Programa Principal
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:30
*:
*:
*:     Documentado 05/13/94 em 14:53                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "HBGTINFO.CH"
REQUEST HB_GT_WVG_DEFAULT

REQUEST HB_CODEPAGE_PTISO
REQUEST HB_LANG_PT
REQUEST DBFCDX

#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"


function main
PARA ZUSER,cSENHA


MVINFOConfTela("Folha")

netregosok()
HB_LANGSELECT('PT')       
HB_IDLESTATE()

HB_IDLESTATE()
Set( _SET_CODEPAGE, "PTISO")   
HB_LANGSELECT('PT') 
rddsetdefault( "DBFCDX" )
Set( _SET_OPTIMIZE, .t.)
Set( _SET_DELETED, .t.)
Set( _SET_SOFTSEEK, .t.)
__SetCentury( .t. )
Set( _SET_EPOCH, year( date() ) - 60 )
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
SetCursor(.t.)

Set( _SET_SCOREBOARD, .f. )
//Set( _SET_TYPEAHEAD, 50 )
Set( _SET_WRAP, .t. )
//Set( _SET_EXACT, .f. )
//Set( _SET_CONFIRM, .t.)

Set( _SET_CONSOLE, .F. )

SET TALK OFF ''checar nao tem ainda na std.ch changelog.txt
SET SAFETY OFF ''checar nao tem ainda na std.ch changelog.txt



SETCOLOR("W+/N")

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
SetKey( K_F8, {|| hb_run("calc") } )
SetKey( K_F10, {|| MUDADATA() } )

deletaarq("TEMP*.*")
deletaarq("*.tmp")
deletaarq("*.LOG")

RELOGIO()

//Inicializa o Mouse Clipper 5.3c
SET ( _SET_EVENTMASK, HB_INKEY_ALL)
lMOUSE:=MPRESENT()
MOUSE_X:=0
MOUSE_Y:=0
MOUSE_B:=0
aMENUPROMPTS:={}
IF lMOUSE
   CLS
   MSETBOUNDS()
   MSETCURSOR ( .T. )
ENDIF


//Variaveis Controle Impressora,Video Arquivo
cARQSPO:=""
nTIPSPO:=0
cIMPCOM:=CHR(15)
cIMPEXP:=CHR(18)
cIMPTIT:=CHR(14)
cIMPNEG:=CHR(27)+CHR(69)
cIMPNER:=CHR(27)+CHR(70)
cIMPORI:=""
lIMPEMAIL:=.F.



HELPARQ="FOLREL"
HELPDBF="FOLHA1"
READVAR=""
ZDIRE:="ERRO ZDIRE"
ZDIRN:="ERRO ZDIRN"
ZCODMANA5=1
ZERRO:=""
zNERRO:=0



cRDDEXT:="CDX"



IF ! NETUSE("CONFIGU",,,,,.F.,)
   RETU
ENDIF
TEMPO    := TEMP
IM1      := IMPRE
DRI      := DRIVE
ZMOEDA01 := ALLTRIM(MOEDA01)
ZMOEDA02 := ALLTRIM(MOEDA02)
ZMOEDA03 := ALLTRIM(MOEDA03)
ZMOEDA04 := ALLTRIM(MOEDA04)
ZMOEDA05 := ALLTRIM(MOEDA05)
ZMOEDA06 := ALLTRIM(MOEDA06)
DBCLOSEALL()


LOGOTIPO("FOLHA DE PAGAMENTO")
//CO = '|'

PCK=.F.
DXDIA=DATE()
ZDATA=DATE()
mSEMANA:=0
NREMP=0
CONSEN=.T.

INFOR("MUSER","USUARIO","MUSER",.T.)
INFOR("FIRMA","NRCLIEN","FIRMA",.T.)
INFOR("FOLHANTX","DBF+NTX+STR(SEQ,3)","FOLHANTX",.T.)

NOBREAK()
MUDADATA()

ZUSER:=SPACE(10)
ZUSER:=PADR(NNETWHOAMI(),10)
IF EMPTY(ZUSER)
   ZUSER:=PADR("USUARIO",10)
ENDIF
MDS("Seu nome, por favor: ")
@ 24,40 GET ZUSER VALID ! EMPTY(ZUSER)
READ
IF EMPTY(ZUSER)
   QUIT
ENDIF
ZUSER:=UPPER(ZUSER)

IF ZUSER<>"SUPERVISOR"
   IF ! VERSEHA("MUSER",,ENCODE(ZUSER))
      ALERTX("Usuario Nao Cadastrado")
      QUIT
   ENDIF
   IF XDECDAT(OBTER("MUSER",,ENCODE(ZUSER),"VALIDADE"))<ZDATA
      ALERTX("Se acesso expirou comunique ao Supervisor")
      QUIT
   ENDIF
ENDIF

MDS("Senha")
IF PEGAPASS(24,10,8,,"*",.T.) # XDECODE(OBTER("MUSER",,ENCODE(ZUSER),"SENHA"))
   ALERTX("Senha nao Confere, retente ou comunique ao Supervisor")
   QUIT
ENDIF


WHILE .T.
   LOGOTIPO("FOLHA DE PAGAMENTO")
   NREMP:=0
   WHILE NREMP = 0
       NREMP=ESCOLHEXI( "FIRMA", "NREMP" , "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN")
       IF ! netuse("FIRMA")
          LOOP
       ENDIF
       DBGOTOP()
       IF DBSEEK(NREMP)
          MSG2=TRIM(RAZAO)
          MSG2A=TRIM(COGNOME)
          ENDER1=TRIM(ENDERECO)
          BAI1=TRIM(BAIRRO)
          CID1=CIDADE
          EST1=ESTADO
          CEP1=CEP
          MSG3=SENHA
          MESHORA=HORASMES
          CGC       = CGC
          CGC1      = CGC
          ATIV1     = ATIVIDADE
          RECOIRRF  = PAGAR
          zTELEFONE = TELEFONE
          zPESSOA   = PESSOA
          zCEI      = CEI
          ZCODMANA5 = CODMANA5
       ELSE
          FO_1()
          NREMP = 0
          LOOP
       ENDIF
   ENDDO
   DBCLOSEALL()


   ANOWORK=SUBSTR(STRZERO(YEAR(DXDIA),4),3,2)
   ANOUSO  := year( DXDIA )

   //path
   if ! pegfolpat()
      loop
   endif

   //senha
   NRSEN:=pegfolsen()

   //Competencia
   OP:=PEGFOLMES()
   MES=OP
   MESTRAB=MES
   MMES=MMES(OP)
   EMP = STRZERO(NREMP,4)
   ARQMES = STRZERO(MES,2)
   IF NRSEN <> 'DiReT'
      PES = 'FO_PES'
      FOL = 'FP'+EMP+ARQMES
      F13='FO_FP13'
      SEM = 'SS'+ARQMES
      RPA = 'RP'+ARQMES
   ELSE
      PES = 'FO_DIR'
      FOL = 'SO'+EMP+ARQMES
      F13='FO_SO13'
      SEM:="ERRO SEM"
      RPA:="ERRO RPA"
   ENDIF
   @ 7,0 CLEAR
   IF ! file(ZDIRE+FOL+".DBF")
      ALERTX("Falta Arquivo de Folha do Mes")
      NREMP=0
      LOOP
   ENDIF
   MDS('Aguarde organizacao dos arquivos')
   IF file(ZDIRE+FOL+".DBF")
      INFOR(ZDIRE+FOL,"CONTROLE",ZDIRE+FOL,.T.)
   ENDIF
   IF file(ZDIRE+"FO_DIR.DBF")
     if ! file(ZDIRE + "FOODIR.DBF" )
         filecopy(ZDIRE + "FO_DIR.DBF" ,ZDIRE + "FOODIR.DBF" )
         filecopy(ZDIRE + "FO_DIR.cdx" ,ZDIRE + "FOODIR.cdx" )
      ENDIF
      INFOR(ZDIRE+"FO_DIR","NUMERO",ZDIRE+"FO_DIR",.T.)
   ENDIF
   IF file(ZDIRE+"FO_PES.DBF")
      if ! file(ZDIRE + "FOOPES.DBF" )
         filecopy(ZDIRE + "FO_PES.DBF" ,ZDIRE + "FOOPES.DBF" )
         filecopy(ZDIRE + "FO_PES.cdx" ,ZDIRE + "FOOPES.cdx" )
      ENDIF
      INFOR(ZDIRE+"FO_PES","NUMERO",ZDIRE+"FO_PES",.T.)
   ENDIF
   FOLMENU()
   IF ! MDG ('DESEJA CONTINUAR NA FOLHA ')
      FIM("")
   ENDIF
   IF MDG('DESEJA MUDAR A EMPRESA  ??')
      CONSEN=.T.
      NREMP=0
   ENDIF
ENDDO
RETURN .T.

*: FIM: FOLHA1.PRG
