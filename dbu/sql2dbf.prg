#include <dbstruct.ch>

#require "hbsqlit3"
//#include <hbsqlit3.ch>

///REQUEST hbsqlit3

Function Main

public oDB := nil
public oDB1 := nil
private cTableName := ''
private cNewTable := ''
private lOpened := .f.


//createadb()
IF selectdb()
 /*
 sqlite3_exec( odb, "CREATE TABLE t1( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER )")
 sqlite3_exec( odb, ;
         "BEGIN TRANSACTION;" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Bob', 52 );" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Fred', 40 );" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Sasha', 25 );" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Ivet', 28 );" + ;
         "COMMIT;" )
   */  
   exportadbf(odb)    
endif

//sqlitepack(odb)


function exportadbf(db)
 aTable := sqltablestru( DB, "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name" )
 altd()
         if len( aTable ) == 0
            msgstop( 'No Tables in the DB', 'DBF<-->SQLite Exporter' )
            return nil
         endif
        // alertx(atable)
        //altd()
         for i := 1 to len( aTable )
            //sql.tables.additem( aTable[ i, 1 ] ) 
            ? aTable[ i, 1 ]
            Export2dbf(DB,aTable[ i, 1 ])
            sqlite3_sleep( 3000 )
         next i
         //sql.tables.value := 1


function C2SQL(Value)
local cValue := ""
local cdate := ""
if valtype(value) == "C" .and. len(alltrim(value)) > 0
   value := strtran(value,"'","''")
endif
do case
   case Valtype(Value) == "N"
      cValue := AllTrim(Str(Value))
   case Valtype(Value) == "D"
      if !Empty(Value)
         cdate := dtos(value)
         cValue := "'"+substr(cDate,1,4)+"-"+substr(cDate,5,2)+"-"+substr(cDate,7,2)+"'"
      else
         cValue := "''"
      endif
   case Valtype(Value) $ "CM"
      IF Empty( Value)
         cValue="''"
      ELSE
         cValue := "'" + value + "'"
      ENDIF
   case Valtype(Value) == "L"
      cValue := AllTrim(Str(iif(Value == .F., 0, 1)))
   otherwise
      cValue := "''"       // NOTE: Here we lose values we cannot convert
endcase
return cValue


function sqltablestru(dbo1,qstr)
local table := {}
local stmt
local currow := nil
local tablearr := {}
local rowarr := {}
local typesarr := {}
local cdate := ""
local current := ""
local i := 0
local j := 0
local type1 := ""
if empty(dbo1)
   msgstop("Database Connection Error!")
   return tablearr
endif
table := sqlite3_get_table(dbo1,qstr)
if sqlite3_errcode(dbo1) > 0 // error
   msgstop(sqlite3_errmsg(dbo1)+" Query is : "+qstr)
   return nil
endif
stmt := sqlite3_prepare(dbo1,qstr)
IF ! Empty( stmt )
   for i := 1 to sqlite3_column_count( stmt )
      type1 := upper(alltrim(sqlite3_column_decltype( stmt,i)))
      do case
         case type1 == "INTEGER" .or. type1 == "REAL" .or. type1 == "FLOAT" .or. type1 == "DOUBLE"
            aadd(typesarr,"N")
         case type1 == "DATE" .or. type1 == "DATETIME"
            aadd(typesarr,"D")
         case type1 == "BOOL"
            aadd(typesarr,"L")
         otherwise
            aadd(typesarr,"C")
      endcase
   next i
endif
sqlite3_reset( stmt )
if len(table) > 1
   asize(tablearr,0)
   for i := 2 to len(table)
      rowarr := table[i]
      for j := 1 to len(rowarr)
         do case
            case typesarr[j] == "D"
               cDate := substr(rowarr[j],1,4)+substr(rowarr[j],6,2)+substr(rowarr[j],9,2)
               rowarr[j] := stod(cDate)
            case typesarr[j] == "N"
               rowarr[j] := val(rowarr[j])
            case typesarr[j] == "L"
               if val(rowarr[j]) == 1
                  rowarr[j] := .t.
               else
                  rowarr[j] := .f.
               endif
         endcase
      next j
      aadd(tablearr,aclone(rowarr))
   next i
endif
return tablearr

function sqlitepack(db)
IF ! Empty( db )
      IF sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
        // ? "PACK - Done"
         //sqlite3_sleep( 3000 )
      ENDIF
ENDIF
   

function selectdb
   local cFileName := ''
   local cDBName := ''
   local nSlash := 0
   local nDot := 0
   local lRETU := .F.
   
   cFileName:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite Files", "*.sqlite", 1 )
   
  // cFileName := GetFile ( { { 'SQLite Files', '*.sqlite' }, { 'All Files', '*.*' } }, 'Select an Existing SQLite File' )
   if len( alltrim( cFileName ) ) > 0
      cDBName := tiraext(cFileName)
      
      /*
      nSlash := rat( '\', cDBName )
      if nSlash > 0
         cDBName := substr( cDBName, nSlash + 1 )
      endif
      nDot := at( '.', cDBName )
      if nDot > 0
         cDBName := substr( cDBName, 1, nDot - 1 )
      endif
      */
      
      oDB := Connect2DB( cFileName, .f. )
      if oDB == Nil
         msgstop( 'Not a valid SQLite file.', 'SQLite File Selection' )
//         sql.connection.value := "DB Not Connected"
 //        sql.connection.fontcolor := { 255, 0, 0 }
         return nil
      else 
          lRETU:=.T.
          ? sqlite3_libversion_number()
          sqlite3_sleep( 1000 )
 //        sql.connection.value := alltrim( cDBName ) + " is Connected!"
 //        sql.connection.fontcolor := { 0, 98, 0 }
      endif
   else
      msgstop( 'You have to select a SQLite File!', 'SQLite File Selection' )
      return lRETU
   endif   
return lRETU


FUNCTION connect2db(dbname,lCreate)
local dbo1 := sqlite3_open(dbname,lCreate)
IF Empty( dbo1 )
   alertx("Database could not be connected!")
   RETURN nil
ENDIF
RETURN dbo1


function createadb
   local cFileName := ''
   local cDBName := ''
   local nSlash := 0
   local nDot := 0
   
    cFileName:=win_GetSaveFileName(, "SQLite Files",HB_CWD(), "SQLite Files", "*.sqlite", 1 )
   //cFileName := PutFile ( { { 'SQLite Files', '*.sqlite' }, { 'All Files', '*.*' } }, 'Create a SQLite File' )
   if len( alltrim( cFileName ) ) == 0
      msgstop( 'File name can not be empty!', 'DBF2SQLite Exporter' )
      return nil
   endif   
   if at( '.', cFileName ) == 0
      cFileName := cFileName + '.sqlite'
   endif
   if file(cFileName)
      alertx("Arquivo ja existe")
      return
   endif
   cDBName := tiraext(cFileName)
   /*
   nSlash := rat( '\', cDBName )
   if nSlash > 0
      cDBName := substr( cDBName, nSlash + 1 )
   endif
   nDot := at( '.', cDBName )
   if nDot > 0
      cDBName := substr( cDBName, 1, nDot - 1 )
   endif
   */
   oDB := Connect2DB( cFileName, .t. )
   if oDB == Nil
      msgstop( 'Not a valid SQLite file.', 'SQLite File Selection' )
  //    sql.connection.value := "DB Not Connected"
  //    sql.connection.fontcolor := { 255, 0, 0 }
      return nil
   else
 //     sql.connection.value := cDBName + " is Connected!"
 //     sql.connection.fontcolor := { 0, 98, 0 }
   endif
return nil

function export2dbf(ODB1,cNEWTABLE)
   local aTable := {}
   local aTable1 := {}
   local cSQLTable := {}
   local aStruct := {}
   local cType := ''
   local cFieldName := ''
   local cFieldType := ''
   local nFieldLength := ''
   local nFieldDec := ''
   local nLength := 0
   local aRecord := {}
   local nTotalRows := 0
   local i, j
   if len( alltrim( cNewTable ) ) == 0
      msgstop( 'You have to select a DBF to export', 'DBF<-->SQLite Exporter' )
      return nil
   endif
   if len(cNEWTABLE)>0 //**sql.tables.value > 0
      cSQLTable := cNEWTABLE //"t1" //**sql.tables.item( sql.tables.value )
      aTable := sqltablestru( oDB1, 'PRAGMA table_info( ' + c2sql( cSQLTable ) + ')' )
      if len( aTable ) == 0
         msgstop( 'This is an empty table!' ) 
         return nil
      endif
      for i := 1 to len( aTable )
         cType := upper( alltrim( aTable[ i, 3 ] ) ) 
         cFieldName := alltrim( aTable[ i, 2 ] )
         do case
         case cType == "INTEGER" 
            cFieldType := 'N'
            nFieldLength := 8
            nFieldDec := 0
         case cType == "REAL" .or. cType == "FLOAT" .or. cType == "DOUBLE"
            cFieldType := 'N'
            nFieldLength := 14
            nFieldDec := 5
         case cType == "DATE" .or. cType == 'DATETIME'
            cFieldType := 'D'
            nFieldLength := 8
            nFieldDec := 0
         case cType == "BOOL"
            cFieldType := 'L'
            nFieldLength := 1
            nFieldDec := 0
         otherwise
            cFieldType := 'C'
            nFieldDec := 0
            aTable1 := sqltablestru( oDB1, 'select max( length( ' + cFieldName + ' ) ) from ' + c2sql( cSQLTable ) )
            nLength := 0
            if len( aTable1 ) > 0
               nLength := val( alltrim( aTable1[ 1, 1 ] ) )
            endif
            do case
            case nLength == 0
               nFieldLength := 10
            case nLength < 256
               nFieldLength := nLength
            otherwise
               nFieldLength := 10
               cFieldType := 'M'
            endcase
         endcase
         aadd( aStruct, { cFieldName, cFieldType, nFieldLength, nFieldDec } )
      next i
      if len( aStruct ) > 0
         dbcreate( cNewTable+"_exp", aStruct )
         use &cNewTable
         if .not. used()
            msgstop( 'DBF File Creation error!', 'DBF<-->SQLite Exporter' )
            return nil
         endif
         aTable := sqltablestru( oDB1, 'select * from ' + c2sql( cSQLTable ) )
      //   sql.progress1.value := 0
      //   sql.progress1.visible := .t.
      //   sql.status1.value := ""
      //   sql.status1.visible := .t.
         nTotalRows := len( aTable )
         for i := 1 to nTotalRows
      //      sql.progress1.value := i / nTotalRows * 100
       //     sql.status1.value := alltrim( str( i ) ) + " of " + alltrim( str( nTotalRows ) ) + " Records processed."
            append blank
            aRecord := aTable[ i ]
            for j := 1 to len( aRecord )
               cFieldName := Left( aStruct[ j, 1 ], 10 )
               replace &cFieldName with aRecord[ j ]
            next j
         next i
         commit
       //  sql.status1.value := ""
       //  sql.progress1.value := 0
        // sql.progress1.visible := .f.
        // sql.status1.visible := .f.
         ALERTX("Successfully exported")   
         close all
      //   sql.newtablename.value := ''
         cNewTable := ''
      endif
   else
      msgstop( 'You have to select a Table to export!', 'DBF<-->SQLite Exporter' )
      return nil
   endif
return nil

