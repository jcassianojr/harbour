#require "rddsql"
#require "sddodbc"
#require "sddmy"
#require "sddpg"
//oracle firebird implantacao posterior
//#require "sddoci"
//#require "sddFB"
#require "sddsqlt3"


#include "dbinfo.ch"
#include "error.ch"
#include "simpleio.ch"

//oracle,SDDFB implantacao posterior
//SDDOCI
//SDDFB
//
//REQUEST SDDODBC,SDDSQLITE3,SDDMY,SDDPG SQLMIX

//REQUEST SQLMIX
REQUEST SDDODBC,SQLMIX
REQUEST SDDMY
REQUEST SDDPG
REQUEST SDDSQLITE3

//ANNOUNCE RDDSYS

Function mixmenu(cUSOSQL)
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo


aAMBIENTE:=SALVAA()
cOLDRDD:=rddSetDefault( "SQLMIX" )
cSERVERX:="localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)
cTABELAX  :=SPACE(30)
loledb=.T.
pegcfgbanco()
cTIPOMIX:=cTIPOSQL
if .NOT. mdg("MIXRDD (SIM) MIXODBC (NAO)")
   cTIPOMIX:="ODBC"
endif
IF cTIPOSQL="MARIADB" 
   cTIPOMIX:="ODBC"
ENDIF

IF cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
   cTIPOMIX:="ODBC"
   OPENTIPOARQ()
ENDIF

IF at(".MDB",upper(cdatabaseX))>0 .or. at(".ACCDB",upper(cdatabaseX))>0
   cTIPOMIX:="ODBC"
ENDIF


RddSetDefault(cOLDRDD)
RESTAA(aAMBIENTE)
LAYOUT()
RETURN .T.

/*
 1) URI string
        RDDINFO(RDDI_CONNECT, {"POSTGRESQL", "postgresql://host"})
      2) Key=value parameter pairs
        RDDINFO(RDDI_CONNECT, {"POSTGRESQL", "host=localhost port=5432"})
      3) separate parameters. Support for port, options, tty is added
        RDDINFO(RDDI_CONNECT, {"POSTGRESQL", "host", "user", "passwd", "db",
                "port", "options", "tty"})
*/

FUNCTION OPENSQLMIX(cTIPOMIX,cSERVER,cPASS,cUSER,cBANCO,cTABELA)
//salvar e retornat rdd
LOCAL nRETU
nRETU := 0
DO CASE
   CASE cTIPOMIX="MYSQL" .OR. cTIPOMIX="MYSQL64"
        nRETU:=rddInfo( RDDI_CONNECT, { "MYSQL"     , cSERVERX, cUSERX, cPASSX, cDATABASEX} ) 
    CASE cTIPOMIX="PGSQL" .OR. cTIPOMIX="PGSQL64"
        nRETU:=rddInfo( RDDI_CONNECT, { "POSTGRESQL", cSERVERX, cUSERX, cPASSX, cDATABASEX} )      
   CASE cTIPOMIX="SQLITE" 
        nRETU:=rddInfo( RDDI_CONNECT, { "SQLITE3", cDATABASEX} )    
//   CASE cTIPOMIX="OCI"  .OR. cTIPOMIX="ORACLE"
 //      Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
 //      nRETU:=rddInfo( RDDI_CONNECT, { "OCILIB", "ORCL", "scott", "tiger" } ) == 0
   CASE cTIPOMIX="ODBC"  //Cserver Conneccao
       Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
       cCONN:=cCONN:=GERACONN(cDATABASEX)
       nRETU:=rddInfo( RDDI_CONNECT, { "ODBC", cCONN } )==0
ENDCASE
IF nRETU=0
   mdt("Unable connect to server", rddInfo( RDDI_ERRORNO ), rddInfo( RDDI_ERROR ))
   return .f.
ENDIF
IF VALTYPE(cTABELAX)="C"
   dbUseArea( .T., , "SELECT * FROM "+cTABELAX, cTABELAX ) //ddbUseArea( .T., , "select * from test", "test" )
ENDIF     
return .t.


