#require "rddsql"
#require "sddodbc"
#require "sddmy"
#require "sddpg"
#require "sddsqlt3"


#include "dbinfo.ch"
#include "error.ch"
#include "simpleio.ch"


REQUEST SQLMIX
REQUEST SDDODBC
REQUEST SDDMY
REQUEST SDDPG
REQUEST SDDSQLITE3

ANNOUNCE RDDSYS

Function mixmenu(cUSOSQL)
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo


aAMBIENTE:=SALVAA()
cSERVERX:="localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)
cTABELAX  :=SPACE(30)
loledb=.T.

pegcfgbanco()
cTIPOMIX:=cTIPOSQL


//Mariadb nao tem nativo
IF cTIPOSQL="MARIADB" 
   cTIPOMIX:="ODBC"
ENDIF

//access mdb accdb nao tem nativo
IF cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
   cTIPOMIX:="ODBC"
   OPENTIPOARQ()
ENDIF
IF at(".MDB",upper(cdatabaseX))>0 .or. at(".ACCDB",upper(cdatabaseX))>0
   cTIPOMIX:="ODBC"
ENDIF

//esoolhe o arquivos sqlite
IF cTIPOSQL="SQLITE"
   OPENTIPOARQ()
ENDIF

//sqlite mysql postgresql tem nativos e opcao para odbc
IF cTIPOMIX<>"ODBC"
  if .NOT. mdg("MIXRDD (SIM) MIXODBC (NAO)")
     cTIPOMIX:="ODBC"
  endif
ENDIF

//Usando mdtabela depois criar nativa sqlmix
//precisa retornar rdd se for usar de charmar ddSetDefault( "SQLMIX" ) novamente nao ter connecao aberta sqlmix tambem
mdbtabela(cdatabasex)

altd()
cOLDRDD:=rddSetDefault( "SQLMIX" )
nAREAMIX:=OPENSQLMIX()

//Usando mdtabela depois criar nativa sqlmix
dbUseArea( .T., , "SELECT * FROM "+cTABELAX, cTABELAX )
dbclosearea()


RddSetDefault(cOLDRDD)
RESTAA(aAMBIENTE)
LAYOUT()
RETURN .T.


FUNCTION OPENSQLMIX() //cTABELA)
LOCAL nRETU
nRETU := 0
DO CASE
   CASE cTIPOMIX="MYSQL" .OR. cTIPOMIX="MYSQL64"
        nRETU:=rddInfo( RDDI_CONNECT, { "MYSQL"     , cSERVERX, cUSERX, cPASSX, cDATABASEX} ) 
    CASE cTIPOMIX="PGSQL" .OR. cTIPOMIX="PGSQL64"
        nRETU:=rddInfo( RDDI_CONNECT, { "POSTGRESQL", cSERVERX, cUSERX, cPASSX, cDATABASEX} )      
   CASE cTIPOMIX="SQLITE" 
        nRETU:=rddInfo( RDDI_CONNECT, { "SQLITE3", cDATABASEX} )    
   CASE cTIPOMIX="ODBC"  //Cserver Conneccao
       Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
       cCONN:=GERACONN(cDATABASEX,.F.) //Sqlmix usa driver no lugar de provider(adooledb) geraconn(cCAMBASE,lPROVIDER)
       nRETU:=rddInfo( RDDI_CONNECT, { "ODBC", cCONN } )
ENDCASE
IF nRETU=0
   mdt("Unable connect to server", rddInfo( RDDI_ERRORNO ), rddInfo( RDDI_ERROR ))
   return 0
ELSE
   mdt("Connectado")   
ENDIF
return nRETU


