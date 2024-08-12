*+--------------------------------------------------------------------
*+
*+    Programa  : mlib38.prg
*+    Sistema   : MANAEXO
*+    Linguagem : Harbour
*+    Autor     : Jorge Cassiano
*+    Copyright (c) 2010, Jorge Cassiano
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+--------------------------------------------------------------------
*+

#require "hbsqlit3"
#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+    Function FIXAR()
*+
*+--------------------------------------------------------------------
*+
function FIXAR(P01,lINDEX)
local cDBF := alias()
local res  :=.f.
if valtype(lINDEX) # "L"
   lINDEX := .T.
endif
while .T.
   if USEREDE(P01,0,if(lINDEX,99,0))
      MDS("Reorganizando arquivo, por favor aguarde..."+P01)
      pack
      dbgotop()
      dbclosearea()
      RES := .T.
      exit
   else
      MDS("Tentando reorganizar arquivo ... (F2 desiste)")
      KEY := inkey(2)
      if KEY = K_F2 .or. KEY = K_ESC
         GRAVALOG("Funcao Fixar - Usado Esc")
         exit
      endif
   endif
enddo
dbclosearea()
if !empty(cDBF)
   dbselectar(cDBF)
endif
return RES


*+--------------------------------------------------------------------
*+
*+    Function GRAVALOG()
*+
*+--------------------------------------------------------------------
*+
function GRAVALOG
para cERRO,cOPR,cARQ  //recebe os parametros aqui para ter scopo privadas
local cDBF := alias()
LOCAL cARQVAZIO:= ""
local cCAMERRO :=""
local csql :=""
local oDB
if valtype(cERRO) = "U"
   cERRO := ""
endif
if valtype(cOPR) = "U"
   cOPR := ""
endif
if valtype(cARQ) = "U"
   cDBF:= alias()
endif
if cARQ = "MANARQ" .or. cARQ = "MANARQ1"  .or. left(cARQ,5) = "MUSER" //nao grava para evitar loop infinito
   return .T.
endif
IF zTIPERRO="DBF" .AND. cARQ=zARQERRO
   return .t.
ENDIF


IF Empty(zTIPERRO)
   cARQVAZIO:=Lower(ProfileString( "MANA5.INI", "PATH", "LOG","MANERR.DBF" ))
   DO CASE
   	  CASE At(".sqlite",carqvazio)>0
   	  	  zTIPERRO:="SQLITE"
     CASE At(".mdb",carqvazio)>0
   	  	  zTIPERRO:="MDB"
     OTHERWISE
   	  	  zTIPERRO:="DBF"
   ENDCASE	
ENDIF	


IF Empty(ZARQERRO)
   cARQVAZIO:=ProfileString( "MANA5.INI", "PATH", "LOG","")
   cCAMERRO:= ProfileString( "MANA5.INI", "PATH", "LOGCAM",HB_CWD()+"\LOG")
   ZARQERRO:=cCAMERRO+"log"+StrZero(zANO,4,0)+StrZero(zmes,2,0)+"."+Lower(zTIPERRO)
   IF zTIPERRO="SQLITE" .OR. zTIPERRO="MDB"
	   IF .NOT. File(ZARQERRO)
          filecopy(cARQVAZIO,ZARQERRO)
	   ENDIF
	ENDIF
    IF zTIPERRO="DBF"
       ZARQERRO := "ER"+strzero(day(ZDATA),2)+strzero(month(ZDATA),2)+substr(strzero(year(ZDATA),4),3,2)
       CHECKARQ("MANERR",ZARQERR,,,ZDIRP+"LOG\",year(ZDATA),month(ZDATA)) //mantendo caminho original mudar para logcam posteriormente checar inclusao manarq
    ENDIF
ENDIF


cARQ  := alltrim(cARQ)
cARQ  := strtran(cARQ," ","")
cERRO := alltrim(STRVAL(cERRO))
cERRO := strtran(cERRO," ","")

DO CASE
    CASE zTIPERRO="SQLITE"
        oDB := sqlite3_open( ZARQERRO, .f. )
        if oDB == Nil
        else
        
         cSQL:="INSERT INTO manerr ( usuario,  data, hora, erro, opr, arquivo  )  VALUES ("
    			cSQL:=cSQL+ "'"+ZUSER+"',"
    			cSQL:=cSQL+ " current_timestamp,"
    			cSQL:=cSQL+ "'"+left(Time(),5)+"',"
    			cSQL:=cSQL+ "'"+Cerro+"',"
    			cSQL:=cSQL+ "'"+Copr+"',"
    			cSQL:=cSQL+ "'"+Carq+"'"
    			cSQL:=cSQL+ " );"
        
        
            sqlite3_exec(odb,csql)
            if sqlite3_errcode(odb) > 0 // error
               alert(sqlite3_errmsg(odb)+" Query is : "+csql)
//               return .f.
           endif
        endif
    //MDB implantacao futura usando dbf por enquanto
    CASE zTIPERRO="DBF" .OR. zTIPERRO="MDB"
       GRAVALAY({{"USUARIO","DATA","HORA","ERRO","ARQUIVO","OPR"},{"ZUSER","DATE()","LEFT(TIME(),5)","cERRO","cARQ","cOPR"}},ZARQERR,,.T.,,.T.,)
        
ENDCASE

//retorna area 
if !  empty(cDBF)
   dbselectar(cDBF)
endif
return .T.


/*
*+--------------------------------------------------------------------
*+
*+
*+
*+    Function pegdiaerro()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func pegdiaerro

mDATA := ZDATA
@ 24,00 GET mDATA         
READCUR()
retu "ER"+strzero(day(mDATA),2)+strzero(month(mDATA),2)+substr(strzero(year(mDATA),4),3,2)
*/
