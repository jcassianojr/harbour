#require "hbmysql"

#include "dbstruct.ch"


function mysqlmenu()
 PRIV oServer, oQuery, oRow
 aAMBIENTE:=SALVAA()
 cTIPOSQL="MYSQL"
 cSERVERX:="Localhost"+space(21)
 cUSERX:=PADR("root",30," ")
 cDATABASEX:=space(30)
 cPASSX    :=SPACE(30)
 OPENTIPOARQ()
 
 
 RESTAA(aAMBIENTE)
layout()
return


/*


#require "hbmysql"

#include "dbstruct.ch"

PROCEDURE Main( cArg )

   LOCAL oServer, oQuery2, oRow, aStru
   LOCAL oQuery

   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )

   oServer := TMySQLServer():New( "localhost", "root", "" )
   IF oServer:NetErr()
      Alert( oServer:Error() )
   ENDIF

   oServer:SelectDB( "ims" )
#if 0
   oQuery := oServer:Query( "SELECT * from maga limit 10" )
   oRow := oQuery:GetRow()
#endif

   dbUseArea( .T.,, cArg, "wn", .F. )

   IF ! oServer:DeleteTable( "test" )
      Alert( oServer:Error() )
   ENDIF

   aStru := dbStruct()
   IF oServer:CreateTable( "test", aStru )
      Alert( "test created successfully" )
   ELSE
      Alert( oServer:Error() )
   ENDIF

   oQuery := oServer:Query( "SELECT C111, C116, C134 from maga limit 10" )
#if 0
   oRow := oQuery:GetRow()
#endif

   oServer:Destroy()

   DO WHILE ! wn->( Eof() )

      oQuery2 := oServer:Query( "SELECT * from test where CODF='" + wn->CODF + "' and CODP='" + wn->CODP + "'" )

      IF oQuery2:LastRec() > 0

         ? "found "

         oRow := oQuery2:GetRow()

         oRow:FieldPut( oRow:FieldPos( "GIACENZA" ), oRow:FieldGet( oRow:FieldPos( "GIACENZA" ) ) + wn->GIACENZA )
         oRow:FieldPut( oRow:FieldPos( "ACQGR" ), oRow:FieldGet( oRow:FieldPos( "ACQGR" ) ) + wn->ACQGR )
         oRow:FieldPut( oRow:FieldPos( "ACQDI" ), oRow:FieldGet( oRow:FieldPos( "ACQDI" ) ) + wn->ACQDI )

         IF ! oQuery2:Update( oRow )
            Alert( oQuery2:Error() )
         ENDIF
      ELSE
         ? wn->CODF + " " + wn->CODP

         oRow := oQuery:GetBlankRow()

         oRow:FieldPut( oRow:FieldPos( "CODF" ), wn->CODF )
         oRow:FieldPut( oRow:FieldPos( "CODP" ), wn->CODP )
         oRow:FieldPut( oRow:FieldPos( "GIACENZA" ), wn->GIACENZA )
         oRow:FieldPut( oRow:FieldPos( "DATA" ), wn->DATA + 365 * 100 )
         oRow:FieldPut( oRow:FieldPos( "ACQGR" ), wn->ACQGR )
         oRow:FieldPut( oRow:FieldPos( "ACQDI" ), wn->ACQDI )

         IF ! oQuery:Append( oRow )
            Alert( oQuery:Error() )
         ENDIF
      ENDIF

      wn->( dbSkip() )

   ENDDO

   wn->( dbCloseArea() )

   RETURN
/*
