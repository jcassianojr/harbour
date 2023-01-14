*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOLHAPTO.PRG
*+
*+    Function pegcompete
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PTISO
REQUEST DBFCDX
REQUEST HB_GT_WVG_DEFAULT

#INCLUDE "HBGTINFO.CH"
#INCLUDE "INKEY.CH"


function main
PARA ZUSER,cSENHA


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
//Set( _SET_WRAP, .t. )
//Set( _SET_EXACT, .f. )
Set( _SET_CONFIRM, .F.)

SET TALK OFF ''checar nao tem ainda na std.ch changelog.txt

Set( _SET_MESSAGE, 6 , .T. )

MVINFOConfTela("Folha Modulo Ponto")

netregosok()
HB_LANGSELECT('PT')
HB_IDLESTATE()

HELPARQ := "FOLREL"                     //arquivo=nome da dbf do help
HELPDBF := "FOPTO"
ZCODMANA5:=1
ZCONTINUA:=" "
ZERRO:=""
zNERRO:=0
ZCTRALMOCO:=""

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

cRDDEXT="CDX"

deletaarq("TEMP*.*")
deletaarq("*.tmp")
deletaarq("*.LOG")

//Inicializa o Mouse
set( _SET_EVENTMASK, HB_INKEY_ALL )

lMOUSE       := mpresent()
MOUSE_X      := 0
MOUSE_Y      := 0
MOUSE_B      := 0
aMENUPROMPTS := {}
if lMOUSE
   cls
   msetbounds()
   msetcursor( .T. )
endif

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

//Competencia ponto
ZDATAINI:=DATE()
ZDATAFIM:=DATE()
ZFECHADO:="N"
ZTIPVID :="T"

ZDIRE := "ERRO ZDIRE"
ZDIRN := "ERRO ZDIRN"

INFOR( "MUSER", "USUARIO", "MUSER" ,.T.)
INFOR( "FOLOPT", "ITEMENU+STR(POSICAO,2)", "FOLOPT" ,.T.)
INFOR( "MUSERM", "CONTROLE", "MUSERM" ,.T.)
INFOR( "FOLREL", "DBF+CAMPO", "FOLREL" ,.T.)
INFOR( "FIRMA", "NRCLIEN", "FIRMA" ,.T.)
INFOR("FOPTONTX","DBF+NTX+STR(SEQ,3)","FOPTONTX",.T.)
INFOR("FOPTOCOM","STR(ANO,4)+STR(MES,2)+STR(EMPRESA,8)","FOPTOCOM",.T.)


//ALERTX(DECODEVAL({218,206,224,190,230,226,230}))
//ALERTX(DECODEVAL({164,162,160,158,224,198,226,230}))


ZDATA := date()
IF VALTYPE(ZUSER)#"C"
   ZUSER := space( 10 )
   ZUSER := padr( NNETWHOAMI(), 10 )
   if empty( ZUSER )
      ZUSER := padr( "USUARIO", 10 )
   endif
   MDS( "Seu nome, por favor: " )
   @ 24, 40 get ZUSER valid !empty( ZUSER )
   read
ENDIF
if empty( ZUSER )
   quit
endif
ZUSER := upper( ZUSER )

ZSUPER:= .F.
IF ZUSER = "SUPERVISOR"  .OR. ZUSER="SOFTEC"
   ZSUPER:=.T.
ENDIF


IF AT("__$",ZUSER)>0.AND.AT("%__",ZUSER)>0
   ZUSER:=SUBSTR(ZUSER,4)
   ZUSER:=LEFT(ZUSER,LEN(ZUSER)-3)
   cSENHA:= XDECODE( OBTER( "MUSER", , ENCODE( ZUSER ), "SENHA" ) )
ENDIF

MDS("Senha")
if empty(cSENHA)
   cSENHA := PEGAPASS(24,10,8,,"*",.F.)
    // PEGAPASS( PW_ROW, PW_COL, PW_LEN, PW_COR, ECHO_CHAR, p_upcase, p_echochar )
endif



//ALERTX(cSENHA)

IF ZUSER = "ADMLOG" .Or. ZUSER = "ADMINISTRADOR" .Or. ZUSER = "ADMIN" 
   cUSUARIO := "SUPERVISOR"
END IF

IF ZUSER<>"SUPERVISOR"
   IF ! VERSEHA("MUSER",,ENCODE(ZUSER))
      ALERTX("Usuario Nao Cadastrado")
      QUIT
   ENDIF
   IF XDECDAT(OBTER("MUSER", ,ENCODE(ZUSER),"VALIDADE"))<ZDATA
      ALERTX("Seu acesso expirou comunique ao Supervisor")
      QUIT
   ENDIF
ENDIF


//23/12/2022 checagem hash ou senha
cCHAVE :=StrToHex(hb_SHA256(ALLTRIM(UPPER(zuser))+alltrim(cSENHA), .t.))

//alertX(CCHAVE)

if cCHAVE = OBTER("MUSER",,ENCODE(ZUSER),"CHAVEH") .OR. ;
   cCHAVE = OBTER("MUSER",,ENCODE(ZUSER),"CHAVEWW") .OR. ;
   cCHAVE = OBTER("MUSER",,ENCODE(ZUSER),"CHAVEWC") .OR. ;
   cCHAVE = OBTER("MUSER",,ENCODE(ZUSER),"CHAVEWS")
   // cARQ,eSemUso, KEYINDEX, cCAMPO, nIND, nROW, nCOL, cMES, cMES2, cDEF
  // ALERTX("HASH OK")
else
  if cSENHA # XDECODE(OBTER("MUSER", ,ENCODE(ZUSER),"SENHA"))
     ALERTX("Senha nao Confere, retente ou comunique ao Supervisor")
     quit
  endif
endif

READVAR  := ""
OP_SENHA := 0
NREMP    := 0
DXDIA    := date()
CONSEN   := .T.
public TELA
public DADO

MUDADATA()

//Controle Secundario Ponto
lSECBCO:=.F.

while .T.
   LOGOTIPO( "MODULO PONTO" )
   do while NREMP = 0
      NREMP=ESCOLHEXI( "FIRMA", "NREMP" , "STR(NRCLIEN,8)+' '+COGNOME+' '+RAZAO", "NRCLIEN","CRTPONTO<>'N'")
      if ! NETUSE("FIRMA")
         LOOP
      endif
      dbgotop()
      IF ! dbseek( NREMP )
         MDT( 'EMPRESA NAO CADASTRADA' )
         NREMP := 0
      else
         MSG3     := SENHA
         ZEMPRESA := RAZAO
         zPESSOA  := PESSOA
         zCGC     := CGC
         ZCODMANA5:= CODMANA5 //uso folget
         ZCTRALMOCO:=CTRALMOCO
      endif
      dbcloseall()
   enddo
   ANOWORK := substr( strzero( year( DXDIA ), 4 ), 3, 2 )
   ANOUSO  := year( DXDIA )
   

   //path      
   if ! pegfolpat()
      loop
   endif   

   //senha
   NRSEN:=pegfolsen(.F.)
   
   //Compentencia
   OP      := PEGFOLMES()
   MES     := OP
   MESTRAB := OP
   MESWORK := strzero( mestrab, 2 )
   ANOMESW := ANOWORK+MESWORK
   MMES    := MMES( OP )
   //Competencia Anterior
   nANOANT:=ANOUSO
   nMESANT:=MESTRAB-1
   IF nMESANT=0
      nMESANT:=12
      nANOANT:=nANOANT-1
   ENDIF
   EMP    := strzero( NREMP, 4 )
   PES    := 'FO_PES'
   PESIND := "FO_PES"
   FOL    := 'FP' + EMP + strzero( MES, 2 )
   @ 07, 00 clea

   if ! HB_FILEEXISTS( ZDIRE + FOL + ".DBF" )
      ALERTX( "Falta Arquivo de Folha do Mes" )
      NREMP := 0
      loop
   endif
   MDS( 'Aguarde organizacao dos arquivos' )
   if file( ZDIRE + FOL + ".DBF" )
     INFOR( ZDIRE + FOL, "CONTROLE", ZDIRE + FOL ,.T.)
   endif
   if file( ZDIRE + "FO_PES.DBF" )
     INFOR( ZDIRE + "FO_PES", "NUMERO", ZDIRE + "FO_PES" ,.T.)
   endif
   pegcompete()
   FOPTOM()
   setcolor( "W/N,N/W" )
   if ! MDG( 'Deseja continuar no Ponto/Relogio ' )
      FIM( "" )
   endif
   if MDG( 'Deseja mudar a Empresa' )
      CONSEN := .T.
      NREMP  := 0
   endif
enddo

*+ EOF: FOLHAPTO.PRG

