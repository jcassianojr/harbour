#require "hbmysql"

#include "dbstruct.ch"
#include "box.ch"


function mysqlmenu()
 PRIV oServer, oQuery, oRow
 aAMBIENTE:=SALVAA()
 cTIPOSQL="MYSQL"
 cSERVERX:="localhost"+space(21)
 cUSERX:=PADR("root",30," ")
 cDATABASEX:=space(30)
 cPASSX    :=SPACE(30)
 //OPENTIPOARQ()
 
 oServer := TMySQLServer():New( "localhost", "root", "admin")
   IF oServer:NetErr()
      Alert( oServer:Error() )
      return .f.
   ENDIF

 
aResult:=Oserver:ListDBs()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cDATABASEX:=IIF( nChoices > 0, aResult[ nChoices ], "")

Oserver:SelectDB( cDATABASEX )
IF oServer:NetErr()
    Alert( oServer:Error() )
    return .f.
ENDIF

oserver:destroy() 
RESTAA(aAMBIENTE)
layout()
return .t.

/*
aResult:=Oserver:ListTables()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cTABELA:=IIF( nChoices > 0, aResult[ nChoices ], "")
cSTRU:=oSERVER:TableStruct( cTabela )
hb_MemoWrit( cTABELA+"_STRU.TXT", cSTRU, .F. ) 

*/


//CreateTable( cTable, aStruct, cPrimaryKey, cUniqueKey, cAuto )
//TableStruct( cTable )
//CreateDatabase( cDataBase )
//SelectDB( cDBName )
//CreateIndex( cName, cTable, aFNames, lUnique )
