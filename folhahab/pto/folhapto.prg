*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOLHAPTO.PRG
*+
*+    Function pegcompete
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

REQUEST HB_LANG_PT
REQUEST DBFCDX
REQUEST HB_GT_WVG_DEFAULT

#INCLUDE "HBGTINFO.CH"
#INCLUDE "INKEY.CH"


function main
PARA ZUSER,cSENHA

set date BRITI
set score OFF
SET TALK OFF
set conf OFF
set dele on
set mess to 6 CENTER
set softseek on     // QDO PROCURA UM REGISTRO VIA SEEK E NAO ACHA PARA NO PROXIMO

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



set key 39 to AC_AGUDO                  //SET-UP ACENTUACAO
set key 94 to AC_CIRC
set key 96 to AC_CRASE
set key 126 to AC_TIL
set key K_ALT_S to LIGA_ACENTO          //A TECLA ALT_S LIGA E DESLIGA A ACENTUACAO

ACENTUA := .T.
set key K_F1 to HELP                    // AJUDA ON LINE
set key K_F2 to TELE                    // AGENDA TELEFONICA
set key K_F3 to NOTEP                   // BLOCO DE ANOTACOES
set key K_F4 to AGEN                    // AGENDA
set key K_F5 to TECLAS                  // TECLADO
//set key K_F6 to GRMEMO                  // MEMORANDO
set key K_F7 to CALEND                  // CALENDARIO
set key K_F8 to CALC                    // CALCULADORA
set key K_F9 to RELOGIO                 // RELOGIO
set key K_F10 to MUDADATA               // ALTERACAO DE DATA OPERACIONAL
set key K_F12 to SECULO
set epoch to year( date() ) - 60        //Flutuante

RDDSETDEFAULT("DBFCDX")
cRDDEXT="CDX"
SET OPTIMIZE ON

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


RELOGIO()

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
IF ZUSER = "SUPERVISOR".AND.ZUSER="SOFTEC"
   ZSUPER:=.T.
ENDIF



IF AT("__$",ZUSER)>0.AND.AT("%__",ZUSER)>0
   ZUSER:=SUBSTR(ZUSER,4)
   ZUSER:=LEFT(ZUSER,LEN(ZUSER)-3)
   cSENHA:= XDECODE( OBTER( "MUSER", , ENCODE( ZUSER ), "SENHA" ) )
ENDIF


if ZUSER <> "SUPERVISOR"
   if ! VERSEHA( "MUSER", , ENCODE( ZUSER ) )
      ALERTX( "Usuario Nao Cadastrado" )
      quit
   endif
   if XDECDAT( OBTER( "MUSER", , ENCODE( ZUSER ), "VALIDADE" ) ) < ZDATA
      ALERTX( "Se acesso expirou comunique ao Supervisor" )
      quit
   endif
endif




IF EMPTY(cSENHA)
   MDS( "Senha" )
   cSENHA:=PEGAPASS( 24, 10, 8,, "*", .T. )
ENDIF
IF cSENHA # XDECODE( OBTER( "MUSER", , ENCODE( ZUSER ), "SENHA" ) )
   ALERTX( "Senha nao Confere, retente ou comunique ao Supervisor" )
   quit
ENDIF

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


