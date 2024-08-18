#include "dbstruct.ch"
#INCLUDE "BOX.CH"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "DBVER.CH"

#require "rddado"

#include "adordd.ch"

REQUEST ADORDD

/*
select MSysObjects.name
from MSysObjects
where
   MSysObjects.type In (1,4,6)
   and MSysObjects.name not like '~*'   
   and MSysObjects.name not like 'MSys%'
order by MSysObjects.name
*/

/*
Driver={MySQL ODBC 8.0 ANSI Driver};Server=hostname;Database= dbdata;Option=3;  win32
MySQL ODBC 9.0 ANSI Driver win64

DRIVER={MariaDB ODBC 3.2 Driver};DATABASE=weird3;SERVER=localhost;UID=root;PASSWORD=root;PORT=3308;OPTION=2
Driver={MariaDB ODBC 3.1 Driver};SERVER=mydatabase.mydomain.com;USER=odbc_user;PASSWORD=odbc_pw;DATABASE=odbc_test;PORT=3306;SSLCIPHER=DHE-RSA-AES256-GCM-SHA384";

*/

Function mdbmenu(cUSOSQL)
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo
public oDB := nil

aAMBIENTE:=SALVAA()

loledb=.T.
IF cTIPOSQL="MDB"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<64  //mdg("User sim=oledb(32b) nao=accdb(64b)")
ENDIF 
IF cTIPOSQL="MYSQL"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<64 //mdg("User sim=odbc 8.0(32b) nao=odbc 9.0(64b)")
ENDIF 
  

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    DO CASE
       CASE cTIPOSQL="MDB"
            IF loledb
               @ 03,24 SAY "oledb(32b)"
            Else
               @ 03,24 SAY "accdb(64b)"
            endif
       CASE cTIPOSQL="MYSQL"
            IF loledb
               @ 03,24 SAY "odbc 8(32b)"
            Else
               @ 03,24 SAY "odbc 9(64b)"
            endif
            
        OTHERWISE
            @ 03,24 SAY cTIPOSQL
    ENDCASE  
    OPCAO(  4, 24, "&Criar arquivo             ", 67 ) //c 67
    OPCAO(  5, 24, "                           ", 86 ) //V 86
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 73
    OPCAO(  7, 24, "&Exportar Tabelas          ", 69 ) //E 69
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
           mdbcria()
       CASE KEY=2
       CASE KEY=3
            MDBIMPDBF()
       CASE KEY=4
            MDBEXP()
       OTHERWISE
            RETURN NIL
    ENDCASE
ENDDO

RESTAA(aAMBIENTE)
layout()
return nil

function MDBEXP()
LOCAL cTABELA:=SPACE(60)
LOCAL cCAMMDB   :=SPACE(100)
LOCAL lCOPIANAT
local Ldoc
LOCAL aTABELAS
LOCAL nCHOICES


nCHOICES:=0
aTABELAS:={}
DO CASE
   CASE cTIPOSQL="MDB"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
    CASE cTIPOSQL="SQLITE"
        //Abaixo com sqltables usando nativa depois implementar com rddado
    CASE cTIPOSQL="MYSQL"    
ENDCASE        

DO CASE
   CASE cTIPOSQL="SQLITE"
         IF selectdb()
           cTABELA:=SqliteTables(odb)
        endif  
    CASE cTIPOSQL="MDB"    
        aResult:=MDBTABLES(cMDBARQ,loledb )
        IF LEN(aResult)>0
           HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
          nChoices := ACHOICE( 4,23,21,54, aResult)
        ENDIF   
        cTABELA:=IIF( nChoices > 0, aResult[ nChoices ], "")
   CASE cTIPOSQL="MYSQL"     
ENDCASE

cTABELA:=ALLTRIM(cTABELA)
IF EMPTY(cTABELA)
    md()
    @ maxrow(),0 SAY "TABELA"
    @ maxrow(),10 get cTABELA
    READ
ENDIF
cTABELA:=ALLTRIM(cTABELA)
IF EMPTY(cTABELA)
   RETURN NIL
ENDIF
LCOPIANAT:=MDG("Copia Nativa(SIM) Interna(NAO)")

tDOC:=pegtipodoc(lCOPIANAT) // .t. Inclui dbf se for nativa
pegparexp()

hb_FNameSplit(cMDBARQ , @cCAMMDB, NIL, NIL )
cDESTINO:=cCAMMDB+cTABELA+"."+zEXPOREXT
MDT(cDESTINO)


lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "
IF .NOT.  lCOPIANAT
   PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF

MDT("abrindo arquivo de origem: "+cMDBARQ)
DO CASE
    CASE cTIPOSQL="MDB"
        if loledb
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
        else
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
        endif 
    CASE cTIPOSQL="SQLITE"  
         USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA SQLITE
    CASE cTIPOSQL="MYSQL"
    
    CASE cTIPOSQL="MARIADB"     
    
ENDCASE
   
nLASTREC:=   reccount() //NetRegCount(cOLDDBF)
zei_fort( nLASTREC,,,0)
IF lCOPIANAT
   COPYTO(cDESTINO)
ELSE
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO))
ENDIF   

dbcloseall()
return nil



function mdbcria()
local cCONCREATE
cCONCREATE:=""
DO CASE
   CASE cTIPOSQL="MDB"
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
        //necessario uma tabela para criar
        Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 

        cCONCREATE:=cARQORI+";table1"
        IF .not. loledb //se nao for oledb e sim aceoledb inclui engine parse ; 3 parametro ADO_CREATE em adordd.prg
           cCONCREATE:=cARQORI+";table1;ACEOLEDB"
        endif
   CASE cTIPOSQL="SQLITE" 
        cARQORI:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )  
        cCONCREATE:=cARQORI+";table1;SQLITE"
   CASE cTIPOSQL="MYSQL"     
ENDCASE
/*
 dbCreate( cARQORI+";table1", { ;
      { "FIRST",   "C", 10, 0 }, ;
      { "LAST",    "C", 10, 0 }, ;
      { "AGE",     "N",  8, 0 }, ;
      { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
*/

 dbCreate( cCONCREATE, { ;
      { "FIRST",   "C", 10, 0 }, ;
      { "LAST",    "C", 10, 0 }, ;
      { "AGE",     "N",  8, 0 }, ;
      { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
IF cTIPOSQL="MDB"      
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )   
ENDIF
RETURN NIL
   
FUNCTION DBF2MDB(cMDBARQ,cDBFARQ)
    local cCONCREATE
    local aINDICES
    LOCAL nINDICES
    LOCAL cINDEXNAME
    LOCAL J
    local msql
    
    
    aINDICES:={}
    use &cDBFARQ.
    aSTRU:=DBSTRUCT() 
    nLASTREC:=reccount() 
    zei_fort( nLASTREC,,,0)
    cNOMETABELA:=ALIAS()
    
     nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
     FOR j = 1 TO  nIndexes
        cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
        cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
         msql:="create index " + cINDEXNAME + " on " + cNometabela + " ( "+MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j )) + " ) ;"
         aadd(Aindices,msql)
     NEXT j
    dbclosearea()

    MDT(cNOMETABELA)
    
    Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
    
    cCONCREATE:=cMDBARQ+";"+cNOMETABELA
    DO CASE
       CASE cTIPOSQL="MDB"
            IF .not. loledb //se nao for oledb e sim aceoledb inclui engine parse ; 3 parametro ADO_CREATE em adordd.prg
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
            endif
       CASE cTIPOSQL="SQLITE"  
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";SQLITE"
       CASE cTIPOSQL="MYSQL"     
    ENDCASE
    
    dbCreate( cCONCREATE, aSTRU,"ADORDD" )
    
    do case
       case cTIPOSQL="MDB"
            if loledb
               USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA
            else
               USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA ACEOLEDB
            endif  
       case cTIPOSQL="SQLITE"    
            USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA SQLITE
       case cTIPOSQL="MYSQL"     
    endcase 
         
    append from &cDBFARQ. WHILE zei_fort(nLASTREC,,,1)
    dbcloseall()
    
    Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
    
  
     for j=1 to nIndexes
        Msql=Aindices[j]
        executacmd(cMDBARQ,msql)
     next j
    

FUNCTION MDBIMPDBF()
LOCAL cMDBARQ
cMDBARQ:=""
DO CASE
   CASE cTIPOSQL="MDB"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
   CASE cTIPOSQL="SQLITE"     
        cMDBARQ:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )
   CASE cTIPOSQL="MYSQL"       
ENDCASE   
nOLDTIPO:=TIPODBF
mdt("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
IF FILE (cARQORI)
   DBF2MDB(cMDBARQ,cARQORI)
   RDDNOME(nOLDTIPO) //retorna tipo anterior
ENDIF   
        
        
FUNCTION MDBTABLES(cDataBase,lUSEOLE )
LOCAL aRETU
aRETU:={}
IF lUSEOLE
   cCONN:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + cDataBase //+";User Id=admin;Password=;"
ELSE
   cCONN:="Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + cDataBase//+";User Id=admin;Password=;"
ENDIF

try
   oConn:=WIN_OLECreateObject( "ADODB.Connection" )
   with object oConn
      :ConnectionString:=cConn
      :Open()
   END  
catch oErr
   //ShowADOError(oERR,oConn,cCOMANDO) 
   return aRETU
end
//Dim dt As DataTable = olecon.GetSchema("tables")

/*
cCOMANDO:="GRANT SELECT ON TABLE MSysObjects TO ADMIN" //PUBLIC a vezes e preciso conceder este acesso na ide 
oComm:=WIN_OLECreateObject( "ADODB.Command" )

TRY
 with object oComm
				  :CommandText:=cCOMANDO
				  :CommandType:=adCmdText
				  :ActiveConnection:=oConn
                  :ExecuteNonQuery()
				 // :Execute()
			 end
CATCH oERR
  // ? "errr"
  //    RETURN aRETU //continua pois pode executar sem dar retorno
END                  
*/

oRS:= WIN_OLECreateObject('ADODB.RecordSet')
oRS:CursorLocation := 3

cCOMANDO = "select MSysObjects.name from MSysObjects where MSysObjects.type In (1,4,6) " ;
  + " and MSysObjects.name not like '~*'   and MSysObjects.name not like 'MSys%' " ;
   + " order by MSysObjects.name "

      TRY
        oRS:Open(cCOMANDO, oConN, adOpenDynamic, adLockOptimistic )
      CATCH oERR
        //ShowADOError(oERR,oConn,cCOMANDO) 
        //hb_memowrit("erro.txt",cCOMANDO)
        return  aRETU 
      END

while ! ors:eof
     AADD(aRETU,ors:fields("name"):value)  //ors:fields(0) inicia as colunas com zero ou pelo nome da coluna
   //    ? ors:fields("name"):value            //ors:fields(0)
         ors:movenext()
    enddo
oRs:Close()
oConN:close()  
RETURN aRETU       


Function executacmd(cCAMBASE,cCOMANDO)
LOCAL cCHAVEV
LOCAL cConn
cCHAVEV:=""
cConn  :=""

if at(".MDB",upper(cCAMBASE))>0
    if loledb
       cConn:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Mode=Share Deny None"  //32 bit jet oledb
    else
       cConn:="Provider=Microsoft.ACE.OLEDB.16.0;Data Source="+cCAMBASE+";Mode=Share Deny None" //64 bit ace oledb
    endif
ENDIF

if at(".SQLITE",upper(cCAMBASE))>0
   cConn:="Driver={SQLite3 ODBC Driver};Database=" + cCAMBASE + ";"
ENDIF

IF EMPTY(cConn)
   return .f.
endif
        
try
   oConn:=WIN_OLECreateObject( "ADODB.Connection" )
   with object oConn
      :ConnectionString:=cConn
      :Open()
   END  //end do with
catch oErr
  // ShowAdoError(oERR,oCoNn)   
   return .f.
end

oComm:=WIN_OLECreateObject( "ADODB.Command" )
  try
      with object oComm
          :CommandText:=cCOMANDO
          :CommandType:=adCmdText
          :ActiveConnection:=oConn
          :Execute()
      end
  end

oConn:Close()
oConn:=NIL		
RETURN .t.
