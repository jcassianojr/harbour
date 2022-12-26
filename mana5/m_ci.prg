*+--------------------------------------------------------------------
*+
*+    Programa  : m_ci cadastro de usuarios
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2021, Jorge Cassiano
*+
*+    Documentado em 13-03-2021
*+
*+--------------------------------------------------------------------
*+

#include "adordd.ch"
#include "try.ch"

function m_ci(ntipo)
MDI("Usuarios e Senhas de Acesso")
if nTIPO = 1
   while .T.
      MDS("Digite Nova Senha")
      mSENHA := PEGAPASS(24,20,8,,"*",.T.)
      MDS("Digite Novamente")
      mSENH2 := PEGAPASS(24,20,8,,"*",.T.)
      if mSENHA = mSENH2 .and. !empty(mSENHA) .and. len(alltrim(mSENHA)) >= 8
         exit
      else
         ALERTX("Senhas Diferentes, em Branco, Menos de 8 Caracter")
      endif
   enddo
   if USEREDE("MUSER",1,99)
      if dbseek(XENCODE(ZUSER))
         netreclock()
         field->SENHA   := XENCODE(mSENHA)
         field->DATATRO := ZDATA+90
         FIELD->CHAVEH:=StrToHex(hb_SHA256(ALLTRIM(zuser)+alltrim(mSENHA), .t.))
         
         dbunlock()
      endif
      dbclosearea()
   endif
else
   IF ZSUPER
      PADRAX(0, ,0,{"MUSER"},"Usuario Equivalencia","' '+XDECODE(mUSUARIO)+' '+XDECODE(mEQUIVALE)","MCI001","MCI001",,,;
       ,"MCIINS","MCI",{|| MCIIGU()},,{|| MCIANT()},{|| MCIINS()})
	   
//	   para wPAX,wpPAX,wcPAX,aWARQ,PAXCAB,PAXDIZ,bPAXTEL,bPAXGET,bPAXEN2,bDELSEC,;
//         bPOSREP,bPAXINS,PAXCOR,bPOSIGU,bPAXTEC,bANTREP,bPOSINS,bPOSEDI,eFILTRO

	   
	   IF MDG("Gerar postela chave para Muser mana5")
	      gerapostela(1)
	   endif
       
       	IF MDG("Gerar postela chave para Muser folha")
	      gerapostela(2)
	   endif
       
   ELSE
      ALERTX("Somente Administrador")
   ENDIF
endif


*+--------------------------------------------------------------------
*+
*+    Function MCIINS()
*+
*+--------------------------------------------------------------------
*+
function MCIINS
mUSUARIO := XENCODE(mUSUARIO)
mCHAVE   := mUSUARIO
return .T.


*+--------------------------------------------------------------------
*+
*+    Function MCIIGU()
*+
*+--------------------------------------------------------------------
*+
function MCIIGU
mUSUARIO  := padr(XDECODE(mUSUARIO),10)
mEQUIVALE := padr(XDECODE(mEQUIVALE),8)
mSENHA    := padr(XDECODE(mSENHA),8)
mVALIDADE := XDECDAT(mVALIDADE)
return .T.


*+--------------------------------------------------------------------
*+
*+    Function MCIANT()
*+
*+--------------------------------------------------------------------
*+
function MCIANT
mUSUARIO  := XENCODE(mUSUARIO)
mEQUIVALE := XENCODE(mEQUIVALE)
mSENHA    := XENCODE(mSENHA)
mVALIDADE := XENCODE(strtran(dtoc(mVALIDADE),'/',''))
mCHAVE    := mUSUARIO
return .T.


*+--------------------------------------------------------------------
*+
*+    Function XDECODE()
*+
*+--------------------------------------------------------------------
*+
function XDECODE(cVAR)
return if(empty(cVAR),cVAR,DECODE(cVAR))

*+--------------------------------------------------------------------
*+
*+    Function XENCODE()
*+
*+--------------------------------------------------------------------
*+
function XENCODE(cVAR)
return if(empty(cVAR),cVAR,ENCODE(cVAR))

*+--------------------------------------------------------------------
*+
*+    Function XDECDAT()
*+
*+--------------------------------------------------------------------
*+
function XDECDAT(cVAR)
cVAR := XDECODE(cVAR)
cVAR := ctod(left(cVAR,2)+'/'+substr(cVAR,3,2)+'/'+right(cVAR,2))
return cVAR

*+--------------------------------------------------------------------
*+
*+    Function encodpos() gera postela para login windows usa outra charset
*+
*+--------------------------------------------------------------------
*+
FUNCTION ENCODEPOS (in_string,nPOS,lGRAVA)
# define ADJVAL  30
LOCAL counter := in_len := 0, next_char := out_string := ''
IF in_string != NIL
    in_string := ALLTRIM(UPPER(in_string))
    in_len := LEN(in_string)
    FOR counter = 1 TO in_len
         next_char = SUBSTR(in_string, counter * -1, 1)
         nCHAR:=0
         IF next_char == '.'.OR. next_char == '_' .OR.     ISDIGIT(next_char) .OR. ISALPHA(next_char)   
             nCHAR:= (ASC(next_char) + ADJVAL) * 2
             out_string := out_string +    CHR(nCHAR)
         ENDIF
		 IF lGRAVA
			cCAMPO:="POSTEL"+STRZERO(counter+NPOS,2)
			field->&cCAMPO.:=nCHAR
		 ELSE
            AADD(aCHAVE,nCHAR)		 
		 ENDIF	
    NEXT
ENDIF
RETURN out_string

*+--------------------------------------------------------------------
*+
*+    Function gerapostela() gera postela para login windows usa outra charset
*+
*+--------------------------------------------------------------------
*+
function gerapostela(nARQ)
LOCAL cARQMUSER
LOCAL lOPEN
cCAMWRPT:=ProfileString( "MANA5.INI", "PATH", "WRPT", HB_CWD())
cCAMCONT:=ProfileString( "MANA5.INI", "PATH", "CONTROLE", HB_CWD())
cCAMSYSU:=ProfileString( "MANA5.INI", "PATH", "SYSUSER", HB_CWD())

lOPEN:=.F.
IF nARQ=1
   lOPEN:=USEREDE("MUSER",1,99)
ENDIF
IF nARQ=2
   cARQMUSER:=ProfileString( "MANA5.INI", "PATH", "MUSERFOLHA", HB_CWD())+"MUSER"
   ALERT(cARQMUSER)
   lOPEN:=USECHK(cARQMUSER,,.T.)
   //USECHK(cARQ,cIND,lSHA,cDRIVER,lNEW,nTIME)
   ALERT(cARQMUSER)
ENDIF



if lOPEN
	dbsetorder(1) //
	dbgotop()
	while ! eof()
	    netreclock()
		cUSUARIO:=DECODE(FIELD->USUARIO)
		ENCODEPOS(cUSUARIO,0,.t.)
		cSENHA:=DECODE(FIELD->SENHA)
		ENCODEPOS(cSENHA,10,.t.)       //senha comeca na 10+1 postel11
        cCHAVEH:=StrToHex(hb_SHA256(ALLTRIM(cUSUARIO)+alltrim(cSENHA), .t.))
        FIELD->CHAVEH:=cCHAVEH
        
		dbunlock()
		
		aCHAVE:={}
		cCHAVEUSR:=""
		ENCODEPOS(cUSUARIO,0,.F.)
		FOR X:=1 TO LEN(aCHAVE)
			cCHAVEUSR+=STRZERO(aCHAVE[X],3) 
		NEXT X
		
		aCHAVE:={}
		cSENHAUSR:=""
		ENCODEPOS(cSENHA,0,.F.)
		FOR X:=1 TO LEN(aCHAVE)
			cSENHAUSR+=STRZERO(aCHAVE[X],3) 
		NEXT X

        IF nARQ=1 //so processa muser do mana5
    		gravaposTELA(cUSUARIO,cCHAVEUSR,cSENHAUSR,cCHAVEH,cCAMWRPT)
    		gravaposTELA(cUSUARIO,cCHAVEUSR,cSENHAUSR,cCHAVEH,cCAMCONT)
    		gravaposTELA(cUSUARIO,cCHAVEUSR,cSENHAUSR,cCHAVEH,cCAMSYSU)
		endif
		
	   dbskip()
	enddo
    dbcloseall()
ENDIF

IF nARQ=2 //nao processa para muserM MUSERB da folha
   return 
ENDIF

for z:=1 to 2
	if USEREDE(IF(Z=1,"MUSERW","MUSERB"),1,99)
		dbsetorder(1)
		dbgotop()
		while ! eof()
		    netreclock()
			cCONTROLE:=DECODE(FIELD->CONTROLE) //cGRU+StrZero(nPOS,3)+zUSER
			cSISTEMA:=SUBSTR(cCONTROLE,1,3)
			cPOS    :=SUBSTR(cCONTROLE,4,3)
			cUSUARIO:=SUBSTR(cCONTROLE,7)
			IF cSISTEMA ="RH0"
				cSISTEMA:=SUBSTR(cCONTROLE,1,2)
				cPOS    :=SUBSTR(cCONTROLE,3,3)
				cUSUARIO:=SUBSTR(cCONTROLE,6)
			ENDIF
			FIELD->ITEMENU:=cSISTEMA
			FIELD->POSICAO:=VAL(cPOS)
			aCHAVE:={}
			cCHAVEARR:=""
			ENCODEPOS(cUSUARIO,0,.F.)
			FOR X:=1 TO LEN(aCHAVE)
				cCHAVEARR+=STRZERO(aCHAVE[X],3) 
			NEXT X
			FIELD->POSTELA:=cCHAVEARR
			dbunlock()
		   dbskip()
		enddo
        dbcloseall()
	ENDIF
NEXT Z
return .t.

*+--------------------------------------------------------------------
*+
*+    Function gravaposTELA() gera postela para login windows usa outra charset nos mdb
*+
*+--------------------------------------------------------------------
*+

function gravaposTELA(cUSUARIO,cPOSTELAa,cPOSTELAB,cCHAVEH,cCAMBASE)
//altd()
//IF ! FILE(cCAMBASE)
//   RETURN ALERT(cCAMBASE)
//ENDIF
//cConn:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Mode=Share Deny None"
//     "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=P:\NOVELL\ITAESBRA\PECAS\FMP04CPF.MDB;Mode=Share Deny None"

cConn:="Provider=Microsoft.ACE.OLEDB.16.0;Data Source="+cCAMBASE+";Mode=Share Deny None"
        
try
   oConn:=WIN_OLECreateObject( "ADODB.Connection" )
   with object oConn
      :ConnectionString:=cConn
      :Open()
   END  //end do with
catch oErr
   ShowAdoError(oERR,oCoNn)   
   return 
end

oRSDES:= WIN_OLECreateObject('ADODB.RecordSet')
oRSDES:CursorLocation := 3

oComm:=WIN_OLECreateObject( "ADODB.Command" )


  cCOMANDO = "SELECT * FROM USUARIO WHERE USUARIO = '"+cUSUARIO+"' ;"

      TRY
        oRSDES:Open(cCOMANDO, oConN, adOpenDynamic, adLockOptimistic )
      CATCH oERR
        ShowADOError(oERR,oConn,cCOMANDO)          
      END
      If oRSDES:EOF 
      //---->inclusao do usuario com max do id    
      //   cCOMANDO = "INSERT INTO USUARIO (USUARIO)"
      //   cCOMANDO+= " VALUES ('"+cUSUARIO+"') ;"
    //    with object oComm
     //         :CommandText:=cCOMANDO
     //         :CommandType:=adCmdText
     //         :ActiveConnection:=oConn
     //         :Execute()
    //     end
      EndIf
      oRSDES:Close()

if ! empty(cPOSTELAA)
    cCOMANDO:="UPDATE USUARIO SET POSTELAA = '"+cPOSTELAA+"'  WHERE USUARIO = '"+cUSUARIO+"' ;"
    try
        with object oComm
             :CommandText:=cCOMANDO
             :CommandType:=adCmdText
             :ActiveConnection:=oConn
             :Execute()
        end
    end	
endif    		

if ! empty(cPOSTELAB)
  cCOMANDO:="UPDATE USUARIO SET POSTELAB = '"+cPOSTELAB+"'  WHERE USUARIO = '"+cUSUARIO+"' ;"
  try
      with object oComm
           :CommandText:=cCOMANDO
           :CommandType:=adCmdText
           :ActiveConnection:=oConn
           :Execute()
      end
  end	
endif

if ! empty(cCHAVEH)
  cCOMANDO:="UPDATE USUARIO SET CHAVEH = '"+cCHAVEH+"'  WHERE USUARIO = '"+cUSUARIO+"' ;"
  try
      with object oComm
          :CommandText:=cCOMANDO
          :CommandType:=adCmdText
          :ActiveConnection:=oConn
          :Execute()
      end
  end
endif  	

oConn:Close()
oConn:=NIL		

