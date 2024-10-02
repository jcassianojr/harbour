*+ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
*+
*+    Function netregosok() verifica registros XP/W98
*+    FUNCTION netgrvcam(cCAMPO,eVAL)   grava campo com lock unlock
*+    Function netgrvd()  grava se houver diferenca e o valor passado nao for em branco (nao zerara o campo)
*+    Function netgrvz()  grava se o banco estiver vazio e o valor nao for igual
*+    FUNCTION dbskipex(nSKIP)    salta n registros
*+    FUNCTION netrecapp()          inclui um registro 
*+    FUNCTION netrecdel()          deteta um registro
*+    FUNCTION netreclock()         trava um registro   
*+    FUNCTION netrecunlcom()        destrava um registro e comita 
*+    FUNCTION netpack(cARQ,lPCK)      pack em um arquivo
*+    FUNCTION netzap(cARQ,lINDEX)     zap em um arquivo
*+    Function netregcount(cARQ)       conta registro de um arquivo 
*+    FUNCTION netuse(cARQ,cDRIVER,lSHA,lREAD,lNEW,lINDEX,nTIME)
*+    FUNCTION zei_fort(nLASTREC,lSAYREC,nPOS,nINC)
*+    funcoes para trabalhar linha como dbf aDBF=estrutura posicao [5]posicao na linha [6]tipo de conversao
*+    FUNCTION sdvpegpos(pSTRING,aCampos,pnCAMPO,lCONV,eCONV) 
*+    FUNCTION sdvarrpos(aDBF,lESP)     Retorna novo dbf com [X][5] com posicoes do campo com ou sem espacamentos
*+    FUNCTION sdvarrcam(cLINHA,aCAMPOS,lCONV)
*+
*+ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
*+


#INCLUDE "INKEY.CH"
#include "dbinfo.ch"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netregosok()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netregosok()
If ! WIN_OSNETREGOK() //Precisa direitos ADM
   If ! WIN_OSNETREGOK(.t.,.t.) //primeiro .t. ‚ para ajustar XP/W98..., o segundo ajusta no vista.
    //  ALERTX('Registro do windows nЖo ajustado !')
   else 
  //    ALERTX('Registro windows ajustado')   
   EndIf
else
//   ALERTX('Ja Ajustado')      
EndIf
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netgrvcam()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netgrvcam(cCAMPO,eVAL,lLOCK)
if valtype(lLOCK)<>"L" 
   lLOCK:=.T.
endif
IF lLOCK
	netreclock()
endif	
field->&cCAMPO. :=eVAL
IF lLOCK
   dbunlock()
endif   


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netgrvd() //grava se houver diferenca e o valor passado nao for em branco (nao zerara o campo)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netgrvd(cCAMPO,eVAL,lLOCK)
if valtype(lLOCK)<>"L" 
   lLOCK:=.T.
endif
if ! empty(EVAL) .and. eVAL<>&cCAMPO.
   IF lLOCK
	  netreclock()
    endif	  
    field->&cCAMPO. :=eVAL
   IF lLOCK
      dbunlock()
   endif	  
endif   

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netgrvz()   //grava se o banco estiver vazio e o valor nao
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netgrvz(cCAMPO,eVAL,lLOCK)
if valtype(lLOCK) <> "L" 
   lLOCK:=.T.
endif
if ! empty(eVAL) .AND. EMPTY(&cCAMPO.)
   IF lLOCK
      netreclock()
   ENDIF	  
   field->&cCAMPO. :=eVAL
   IF lLOCK
      dbunlock()
   endif	  
ENDIF   

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function dbSkipEx()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION dbSkipEx(nSKIP)
IF VALTyPE(nSKIP)#"N"
   nSKIP:=1
ENDIF
DBSkip(nSKIP)	
IF BoF()
	DBGoTOP()
ENDIF
IF EOF()
	DBgobottom()
ENDIF
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netrecapp()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netrecapp()
local nkey:=0
nKEY:=0
dbappend()
WHILE NETERR()
   dbappend()   
   WaitPeriod(100)
   nKEY:=INKEY(1)
   IF nKEY=K_ESC
      return .F.
   endif
   MDS( "Tentando Incluir Registro: "+alias() )
ENDDO
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netrecdel()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netrecdel()
while !dbrlock( recno() )
enddo
dbdelete()
dbunlock()
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netreclock()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netreclock()
while !dbrlock( recno() )
enddo
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netrecunlcom()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netrecunlcom()
dbunlock()
dbcommit()
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netpack(cARQ,lPCK) lPCK usado rotinas internas
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netpack(cARQ,lPCK)
IF VALTYPE(lPCK)#"L"
   lPCK:=.T.
ENDIF
IF lPCK
   IF ! netuse(cARQ,,.F.,,,,) //.F. nao compartilhado
      RETU .F.
   ENDIF
   PACK
   DBCLOSEAREA()
ENDIF
RETU .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netzap(cARQ)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netzap(cARQ,lINDEX)
IF VALTYPE(lINDEX)#"L"
   lINDEX:=.T.
ENDIF
IF ! netuse(cARQ,,.F.,,,lINDEX,) //.F. nao compartilhado
   RETU .F.
ENDIF
zap
dbclosearea()
RETU .T.


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netregcount(cARQ)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function NetRegCount(cARQ)
LOCAL nREG
LOCAL cALIAS:=ALIAS()
nREG:=0
IF ! netuse(cARQ,,,,,.F.,) //abre sem index pois as vezes
   RETU nREG               //e copia de outro dbf sem o index
ENDIF
nREG:=LASTREC()
dbclosearea()
IF ! EMPTY(cALIAS)
   DBSELECTAR(cALIAS)
ENDIF
RETU nREG


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function netuse()
*+    NETUSE(cARQ,,,,,.F.,)    //BREDE(ARQUSO,1) abre sem index compartilhado
*+    netuse(cARQ,,.F.,,,.F.,) //BREDE(ARQUSO,0) abre sem index exclusivo
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function netuse(cARQ,cDRIVER,lSHA,lREAD,lNEW,lINDEX,nTIME )
LOCAL cEXT
LOCAL cIND
LOCAL nKEY
cEXT:=STRTRAN(UPPER(ordbagext()),".","")
if valtype( cDRIVER ) # "C" .or. empty( cDRIVER )
   cDRIVER := IF(cEXT="CDX","DBFCDX","DBFNTX")
else
   cDRIVER:= ALLTRIm(cDRIVER)
endif
if valtype( lNEW ) # "L"
   lNEW := .T. //abrir nova area
endif
if valtype( lSHA ) # "L"
   lSHA := .T. //abrir compartilhado
endif
if valtype(nTIME)#"N"
  nTIME:=-1   //tenta abrir indeterminadamente (sem limite tempo)
ENDIF
if valtype( lREAD ) # "L"
   lREAD := .F. //Le e grava
endif
if valtype( lINDEX ) # "L"
   lINDEX := .T. //Abre indices
endif
if ! FILE( cARQ + ".DBF" ).and.! file(cARQ) //evitar erro caso o arquivo ja tenha .dbf
   ALERTX( "Netuse: Falta Arquivo: " + Carq )
   retu .F.
endif
while .t.
   //  DBUSEAREA( [<lNewArea>], [<cDriver>], <cName>, [<xcAlias>],[<lShared>], [<lReadonly>])
   dbusearea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )
   if ! neterr()
      exit //sai do loop tenta novamente
   endif
   IF nTIME>0
      nTIME:=nTIME-1
   ENDIF
   IF nTIME=0
      RETU .F.
   ENDIF
   //-1 nao faz nada
   IF nTIME=-2
      if ! MDG("Deseja Retentar")
         retu .f.
      endif
   ENDIF
   MDS( "Nao Estou Conseguindo Abrir aquivo " + cARQ )
   WaitPeriod(100)
   nKEY := inkey( 1 )  
   if nKEY = K_ESC
      retu .F.
   endif
enddo
if lINDEX
   cIND:=cARQ + "."+cEXT
   if file( cIND )
      if cDRIVER = "DBFCDX"
         ordlistadd( cIND )
      else
         dbsetindex( cIND )
     endif
   else
     ALERTX( "Arquivo Indice nao encontrado : " + cIND )
   endif
endif
//#define DBFLOCK_DEFAULT 0
//#define DBFLOCK_CLIP 1
//#define DBFLOCK_CL53 2
//#define DBFLOCK_VFP 3
//#define DBFLOCK_CL53EXT 4
//#define DBFLOCK_XHB64 5
if cDRIVER = "DBFCDX"
  rddinfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 ) //DB_DBFLOCK_VFP)
endif
if cDRIVER = "DBFNTX"
  rddinfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 ) //DB_DBFLOCK_CL53)
endif
retu .T.


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function zei_fort(nLASTREC,lSAYREC,nPOS,nINC )
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function zei_fort( nLASTREC,lSAYREC,nPOS,nINC )
static LD_CHA   := "|"
static nPOSZEI
local cComplete
if valtype( nLASTREC ) # "N"
   nLASTREC := lastrec()
endif
if valtype(lSAYREC ) # "L"
   lSAYREC := lSAYREC:=.T.
endif
IF VALTYPE(nINC)="N"
   IF nINC=0
      nPOSZEI:=0
   ELSE
      nPOSZEI+=nINC
   ENDIF
   nPOS:=nPOSZEI
ENDIF
if nLASTREC=0 //evita divisao por zeo
   nLASTREC:=100
endif
IF valtype(nPOS)= "N"
   cComplete := int( ( nPOS / nLASTREC ) * 100 )
ELSE
   cComplete := int( ( recno() / nLASTREC ) * 100 )
endif
if ld_cha = '|'
   ld_cha := '/'
elseif ld_cha = '/'
   ld_cha := '\'
elseif ld_cha = '\'
   ld_cha := '-'
elseif ld_cha = '-'
   ld_cha := '|'
endif
IF lSAYREC
   IF valtype(nPOS)= "N"
      @ maxrow(),38 SAY STR(nPOS,8)+"/"+STR(nLASTREC,8)
   ELSE
      @ maxrow(),38 SAY STR(RECNO(),8)+"/"+STR(nLASTREC,8)
   ENDIF
ENDIF
@ maxrow(), 57 say "["
@ maxrow(), 69 SAY "]"
@ MAXROW(), 59+INT(cCOMPLETE/10) sAY  "#"+ld_cha
@ maxrow(), 71 say  transform( cComplete, '999' )
return .t.


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function sdvpegpos( Pstring,aCAMPOS, PnCampo,lCONV,eCONV ) 
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

 FUNCTION sdvpegpos( Pstring,aCAMPOS, PnCampo,lCONV,eCONV )
 LOCAL eRETU
 eRetu := substr( Pstring, aCAMPOS[PnCampo][5], aCAMPOS[PnCampo][3] )      //Posicao + Tamanho do Campo
 IF VALTYPE(lCONV)#"L"
    lCONV:=.F.
 ENDIF
 IF VALTYPE(eCONV)#"C"
    eCONV:=aCAMPOS[PnCampo][6]
 ENDIF
 IF lCONV
    IF ! EMPTY(eCONV)
       DO CASE
          CASE eCONV="DMY/2".or.eCONV="DMY/4"
               eRETU:=SUBSTR(eRETU,1,2)+"/"+SUBSTR(eRETU,3,2)+"/"+SUBSTR(eRETU,5)
       ENDCASE
    ELSE
    do case
       case aCAMPOS[PnCampo][2]="SD"
            eRETU := Stod( eRETU )
       case aCAMPOS[PnCampo][2]="D"
            eRETU := ctod( eRETU )           
       case aCAMPOS[PnCampo][2]="L"
            eRETU := StrLogic(eRETU) //IF(eRETU="S",.T.,.F.)
       case aCAMPOS[PnCampo][2]="N"
            eRETU := val(eRETU)
            IF aCAMPOS[PnCampo][4]>0
               eRETU:=eRETU/(10^aCAMPOS[PnCampo][4])
            ENDIF
    endcase
    ENDIF
 ENDIF
 return eRETU

 *+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function sdvarrpos(aDBF,lESP)  //Retorna novo dbf com [X][5] com posicoes do campo com ou sem espacamentos
*+                                   //Ja cria com [X][6] para o tipo 
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
 FUNCTION sdvarrpos(aDBF,lESP)   
 LOCAL nFIELDS,nPOS,aRETU,X
      nFIELDS:=LEN(aDBF)
 IF VALTYPE(LESP)#"L"
    lESP:=.F.
 ENDIF
 aRETU :={}
 nPOS:=1
 FOR X=1 TO nFIELDS
     AADD(aRETU,{aDBF[X][1],aDBF[X][2],aDBF[X][3],ADBF[X][4],nPOS,""})
     nPOS+=aDBF[X][3]+IF(lESP,1,0)
 NEXT X
 RETURN aRETU

 *+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function sdvarrcam(cLINHA,aDBF,lCONV) 
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

function sdvarrcam(cLINHA,aDBF,lCONV)
LOCAL X,aRETU,nFIELDS
nFIELDS:=LEN(aDBF)
aRETU:={}
FOR X=1 TO nFIELDS
   AADD(aRETU,sdvpegpos(cLINha,aDBF,X,lCONV))
NEXT X
RETURN aRETU
