#require "rddsql"
#require "sddmy"
//oracle implantacao posterior
//#require "sddoci"
#require "sddodbc"
#require "sddsqlt3"


#include "dbinfo.ch"
#include "error.ch"
#include "simpleio.ch"

//oracle implantacao posterior
//SDDOCI
REQUEST SDDODBC,SDDSQLITE3,SDDMY, SQLMIX





FUNCTION OPENSQLMIX(cTIPOMIX,cSERVER,cPASS,cUSER,cBANCO,cTABELA)
//salvar e retornat rdd
LOCAL cOLDRDD
LOCAL nRETU
nRETU := 0
//cOLDRDD:=rddSetDefault( "SQLMIX" ) tratar retrono fora da funcao
//pois o rdddefault dever esta setado para executar rddi_execute outros
DO CASE
   CASE cTIPOMIX="MYSQL" .OR. cTIPOMIX="MYSQL64"
        //retorna 0 caso nao conect
        nRETU:=rddInfo( RDDI_CONNECT, { "MYSQL", "localhost", "test", , "test" } ) == 0
   CASE cTIPOMIX="SQLITE" 
        //retorna 0 caso nao conect
        nRETU:=rddInfo( RDDI_CONNECT, { "SQLITE3", cBANCO )    //rddInfo( RDDI_CONNECT, { "SQLITE3", hb_DirBase() + "test.sqlite3" } )  
//   CASE cTIPOMIX="OCI"  .OR. cTIPOMIX="ORACLE"
 //      Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
 //      nRETU:=rddInfo( RDDI_CONNECT, { "OCILIB", "ORCL", "scott", "tiger" } ) == 0
   CASE cTIPOMIX="ODBC"  //Cserver Conneccao
       Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
       
       cSERVER:=GERACO(
       //rddInfo( RDDI_CONNECT, { "ODBC", "DBQ=" + hb_DirBase() + "..\..\hbodbc\tests\test.mdb;Driver={Microsoft Access Driver (*.mdb)}" } ) == 0
       //RDDI_CONNECT, { "ODBC", "Server=localhost;Driver={MySQL ODBC 5.1 Driver};dsn=;User=test;database=test;" } 
       nRETU:=rddInfo( RDDI_CONNECT, { "ODBC", cSERVER } )==0
ENDCASE
IF nRETU=0
   // mdt("Unable connect to server", rddInfo( RDDI_ERRORNO ), rddInfo( RDDI_ERROR ))
   return .f.
ENDIF
IF VALTYPE(cTABELA)="C"
   dbUseArea( .T., , "SELECT * FROM "+cTABELA, cTABELA ) //ddbUseArea( .T., , "select * from test", "test" )
ENDIF     
//RddSetDefault(cOLDRDD)
return .t.


