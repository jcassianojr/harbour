// classes.prg - Harbour OOP wrappers over C++ core
// User-facing classes: TForm, TLabel, TEdit, TButton, TCheckBox, TComboBox, TGroupBox

#include "hbclass.ch"
//#include "hbide.ch"

// xHarbour does not predefine __PLATFORM__WINDOWS. The xHarbour build path
// is Win32-only, so normalize the macro here — otherwise platform #ifdefs
// fall through to the GTK/Unix branch and pull in unresolved externals.
#ifdef __XHARBOUR__
   #ifndef __PLATFORM__WINDOWS
      #define __PLATFORM__WINDOWS
   #endif
#endif


//============================================================================//
//  DATABASE COMPONENTS (non-visual, Data Access tab)
//============================================================================//

//----------------------------------------------------------------------------//
// TDatabase - Abstract base class for all database connections
//----------------------------------------------------------------------------//

CLASS TDatabase

   DATA cServer     INIT ""        // Host/server name
   DATA nPort       INIT 0         // Port number
   DATA cDatabase   INIT ""        // Database name or file path
   DATA cUser       INIT ""        // Username
   DATA cPassword   INIT ""        // Password
   DATA cCharSet    INIT "UTF8"    // Character set
   DATA lConnected  INIT .F.       // Connection status
   DATA cLastError  INIT ""        // Last error message
   DATA pHandle     INIT nil       // Native connection handle
   DATA cDriver     INIT ""        // Driver name (for identification)

   METHOD New() CONSTRUCTOR
   METHOD Open()
   METHOD Close()
   METHOD Execute( cSQL )
   METHOD Query( cSQL )
   METHOD TableExists( cTable )
   METHOD Tables()
   METHOD LastError()
   METHOD IsConnected()

ENDCLASS

METHOD New() CLASS TDatabase
return Self

METHOD Open() CLASS TDatabase
   ::cLastError := "Abstract: override Open() in subclass"
return .F.

METHOD Close() CLASS TDatabase
   ::lConnected := .F.
   ::pHandle := nil
return nil

METHOD Execute( cSQL ) CLASS TDatabase
   HB_SYMBOL_UNUSED( cSQL )
   ::cLastError := "Abstract: override Execute() in subclass"
return .F.

METHOD Query( cSQL ) CLASS TDatabase
   HB_SYMBOL_UNUSED( cSQL )
   ::cLastError := "Abstract: override Query() in subclass"
return {}

METHOD TableExists( cTable ) CLASS TDatabase
   HB_SYMBOL_UNUSED( cTable )
return .F.

METHOD Tables() CLASS TDatabase
return {}

METHOD LastError() CLASS TDatabase
return ::cLastError

METHOD IsConnected() CLASS TDatabase
return ::lConnected

//----------------------------------------------------------------------------//
// TDBFTable - Native DBF/NTX/CDX table access via Harbour RDD
//----------------------------------------------------------------------------//

CLASS TDBFTable INHERIT TDatabase

   DATA cFileName   INIT ""        // DBF file path
   DATA cAlias      INIT ""        // Work area alias
   DATA cRDD        INIT "DBFCDX"  // RDD driver: DBFNTX, DBFCDX, DBFFPT
   DATA cIndexFile  INIT ""        // Index file (.ntx, .cdx)
   DATA lExclusive  INIT .F.       // Open exclusive
   DATA lReadOnly   INIT .F.       // Open read-only
   DATA nArea       INIT 0         // Work area number

   METHOD New() CONSTRUCTOR
   METHOD Open()
   METHOD Close()
   METHOD Execute( cSQL )
   METHOD Query( cSQL )
   METHOD Tables()

   // DBF-specific methods
   METHOD GoTop()
   METHOD GoBottom()
   METHOD Skip( n )
   METHOD GoTo( nRec )
   METHOD RecNo()
   METHOD RecCount()
   METHOD Eof()
   METHOD Bof()
   METHOD FieldGet( nField )
   METHOD FieldPut( nField, xValue )
   METHOD FieldName( nField )
   METHOD FieldCount()
   METHOD Append()
   METHOD Delete()
   METHOD Recall()
   METHOD Deleted()
   METHOD Seek( xKey )
   METHOD Found()
   METHOD CreateIndex( cFile, cKey )
   METHOD Structure()

ENDCLASS

METHOD New() CLASS TDBFTable
   ::cDriver := "DBF"
return Self

METHOD Open() CLASS TDBFTable
   local lOk := .F., nArea

   // cFileName is the primary property; sync to cDatabase for TDatabase compat
   if ! Empty( ::cFileName )
      ::cDatabase := ::cFileName
   endif

   if Empty( ::cDatabase )
      ::cLastError := "Database (file path) not specified"
      return .F.
   endif

   begin sequence
      if ! Empty( ::cAlias )
         if ::lExclusive
            dbUseArea( .T., ::cRDD, ::cDatabase, ::cAlias, .F., ::lReadOnly )
         else
            dbUseArea( .T., ::cRDD, ::cDatabase, ::cAlias, .T., ::lReadOnly )
         endif
      else
         ::cAlias := hb_FNameName( ::cDatabase )
         dbUseArea( .T., ::cRDD, ::cDatabase, ::cAlias, ! ::lExclusive, ::lReadOnly )
      endif

      ::nArea := Select()
      ::lConnected := .T.
      lOk := .T.

      if ! Empty( ::cIndexFile )
         dbSetIndex( ::cIndexFile )
      endif

   recover
      ::cLastError := "Error opening " + ::cDatabase
      ::lConnected := .F.
   end sequence

return lOk

METHOD Close() CLASS TDBFTable
   if ::lConnected .and. ::nArea > 0
      ( ::cAlias )->( dbCloseArea() )
   endif
   ::lConnected := .F.
   ::nArea := 0
return nil

METHOD Execute( cSQL ) CLASS TDBFTable
   HB_SYMBOL_UNUSED( cSQL )
   ::cLastError := "DBF does not support SQL. Use DBF methods directly."
return .F.

METHOD Query( cSQL ) CLASS TDBFTable
   HB_SYMBOL_UNUSED( cSQL )
   ::cLastError := "DBF does not support SQL. Use DBF methods directly."
return {}

METHOD Tables() CLASS TDBFTable
   local aFiles := Directory( hb_FNameDir( ::cDatabase ) + "*.dbf" )
   local aNames := {}, i
   for i := 1 to Len( aFiles )
      AAdd( aNames, aFiles[i][1] )
   next
return aNames

METHOD GoTop() CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( dbGoTop() ); endif
return nil

METHOD GoBottom() CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( dbGoBottom() ); endif
return nil

METHOD Skip( n ) CLASS TDBFTable
   if n == nil; n := 1; endif
   if ::lConnected; ( ::cAlias )->( dbSkip( n ) ); endif
return nil

METHOD GoTo( nRec ) CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( dbGoTo( nRec ) ); endif
return nil

METHOD RecNo() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( RecNo() ); endif
return 0

METHOD RecCount() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( RecCount() ); endif
return 0

METHOD Eof() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( Eof() ); endif
return .T.

METHOD Bof() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( Bof() ); endif
return .T.

METHOD FieldGet( nField ) CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( FieldGet( nField ) ); endif
return nil

METHOD FieldPut( nField, xValue ) CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( FieldPut( nField, xValue ) ); endif
return nil

METHOD FieldName( nField ) CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( FieldName( nField ) ); endif
return ""

METHOD FieldCount() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( FCount() ); endif
return 0

METHOD Append() CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( dbAppend() ); endif
return nil

METHOD Delete() CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( dbDelete() ); endif
return nil

METHOD Recall() CLASS TDBFTable
   if ::lConnected; ( ::cAlias )->( dbRecall() ); endif
return nil

METHOD Deleted() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( Deleted() ); endif
return .F.

METHOD Seek( xKey ) CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( dbSeek( xKey ) ); endif
return .F.

METHOD Found() CLASS TDBFTable
   if ::lConnected; return ( ::cAlias )->( Found() ); endif
return .F.

METHOD CreateIndex( cFile, cKey ) CLASS TDBFTable
   if ::lConnected
      ( ::cAlias )->( dbCreateIndex( cFile, cKey ) )
   endif
return nil

METHOD Structure() CLASS TDBFTable
   local aStruct := {}, i, nFields
   if ::lConnected
      nFields := ( ::cAlias )->( FCount() )
      for i := 1 to nFields
         AAdd( aStruct, { ;
            ( ::cAlias )->( FieldName(i) ), ;
            ( ::cAlias )->( hb_FieldType(i) ), ;
            ( ::cAlias )->( hb_FieldLen(i) ), ;
            ( ::cAlias )->( hb_FieldDec(i) ) } )
      next
   endif
return aStruct

//----------------------------------------------------------------------------//
// TSQLite - SQLite3 database via Harbour's hbsqlit3 library
//----------------------------------------------------------------------------//

CLASS TSQLite INHERIT TDatabase

   DATA lAutoCommit   INIT .T.       // Auto-commit mode
   DATA cFileName     INIT ""        // SQLite file path (alias for cDatabase)
   DATA cTable        INIT ""        // Table for cursor navigation
   DATA cSQL          INIT ""        // Custom SQL for cursor navigation
   DATA aRows         INIT {}        // Cached rows for cursor
   DATA aFieldNames   INIT {}        // Cached field names for cursor
   DATA nRecord       INIT 0         // Current record (1-based, 0=empty)

   METHOD New() CONSTRUCTOR
   METHOD Open()
   METHOD Close()
   METHOD Execute( cSQL )
   METHOD Query( cSQL )
   METHOD TableExists( cTable )
   METHOD Tables()

   // Cursor navigation (for DBGrid compatibility)
   METHOD FieldCount()
   METHOD FieldName( n )
   METHOD GoTop()
   METHOD Eof()
   METHOD FieldGet( n )
   METHOD Skip( n )

   // SQLite-specific
   METHOD CreateTable( cName, aFields )
   METHOD BeginTransaction()
   METHOD Commit()
   METHOD Rollback()
   METHOD LastInsertId()
   METHOD LoadCursor()   // reload rows from cTable/cSQL without reopening file

ENDCLASS

METHOD New() CLASS TSQLite
   ::cDriver := "SQLite"
   ::nPort   := 0
return Self

METHOD Open() CLASS TSQLite
   if ! Empty( ::cFileName )
      ::cDatabase := ::cFileName
   endif
   if Empty( ::cDatabase )
      ::cLastError := "Database file path not specified"
      return .F.
   endif
   ::pHandle := sqlite3_open( ::cDatabase, .T. )
   if ::pHandle == nil
      ::cLastError := "Failed to open SQLite database: " + ::cDatabase
      return .F.
   endif
   ::lConnected := .T.
   if ! Empty( ::cCharSet )
      sqlite3_exec( ::pHandle, "PRAGMA encoding = '" + ::cCharSet + "'" )
   endif
   ::LoadCursor()
return .T.

METHOD LoadCursor() CLASS TSQLite
   local cQuery, pStmt, nCols, i, nRet, aRow, xCol
   if ! ::lConnected; return Self; endif
   cQuery := iif( ! Empty( ::cSQL ), ::cSQL, ;
             iif( ! Empty( ::cTable ), "SELECT * FROM " + ::cTable, "" ) )
   if Empty( cQuery ); return Self; endif
   ::aRows       := {}
   ::aFieldNames := {}
   pStmt := sqlite3_prepare( ::pHandle, cQuery )
   if pStmt != nil
      nCols := sqlite3_column_count( pStmt )
      for i := 1 to nCols
         AAdd( ::aFieldNames, sqlite3_column_name( pStmt, i ) )
      next
      nRet := sqlite3_step( pStmt )
      while nRet == 100  // SQLITE_ROW
         aRow := Array( nCols )
         for i := 1 to nCols
            xCol := sqlite3_column_text( pStmt, i )
            aRow[i] := iif( xCol == nil, "", hb_ValToStr( xCol ) )
         next
         AAdd( ::aRows, aRow )
         nRet := sqlite3_step( pStmt )
      enddo
      sqlite3_finalize( pStmt )
      ::nRecord := iif( Len( ::aRows ) > 0, 1, 0 )
   endif
return Self

METHOD FieldCount() CLASS TSQLite
return Len( ::aFieldNames )

METHOD FieldName( n ) CLASS TSQLite
   if n >= 1 .and. n <= Len( ::aFieldNames )
      return ::aFieldNames[n]
   endif
return ""

METHOD GoTop() CLASS TSQLite
   ::nRecord := iif( Len( ::aRows ) > 0, 1, 0 )
return Self

METHOD Eof() CLASS TSQLite
return ::nRecord == 0 .or. ::nRecord > Len( ::aRows )

METHOD FieldGet( n ) CLASS TSQLite
   if ! ::Eof() .and. n >= 1 .and. n <= Len( ::aRows[::nRecord] )
      return ::aRows[::nRecord][n]
   endif
return nil

METHOD Skip( n ) CLASS TSQLite
   ::nRecord += n
   if ::nRecord < 1; ::nRecord := 1; endif
return Self

METHOD Close() CLASS TSQLite
   // Harbour's hbsqlit3 uses GC-managed handles - no explicit close needed
   ::pHandle := nil
   ::lConnected := .F.
return nil

METHOD Execute( cSQL ) CLASS TSQLite
   local nResult
   if ! ::lConnected; ::cLastError := "Not connected"; return .F.; endif
   nResult := sqlite3_exec( ::pHandle, cSQL )
   if ValType( nResult ) == "N" .and. nResult != 0
      ::cLastError := sqlite3_errmsg( ::pHandle )
      return .F.
   elseif ValType( nResult ) != "N"
      // sqlite3_exec may return non-numeric on some errors
      ::cLastError := "Unexpected return from sqlite3_exec"
      return .F.
   endif
return .T.

METHOD Query( cSQL ) CLASS TSQLite
   local pStmt, aRows := {}, aRow, nCols, i, nRet
   if ! ::lConnected; ::cLastError := "Not connected"; return {}; endif

   pStmt := sqlite3_prepare( ::pHandle, cSQL )
   if pStmt == nil
      ::cLastError := sqlite3_errmsg( ::pHandle )
      return {}
   endif

   nCols := sqlite3_column_count( pStmt )

   nRet := sqlite3_step( pStmt )
   while nRet == 100  // SQLITE_ROW
      aRow := Array( nCols )
      for i := 1 to nCols
         // Use text for all columns - simplest, most portable
         aRow[i] := sqlite3_column_text( pStmt, i )
      next
      AAdd( aRows, aRow )
      nRet := sqlite3_step( pStmt )
   enddo

   sqlite3_finalize( pStmt )
return aRows

METHOD TableExists( cTable ) CLASS TSQLite
   local aResult
   if ! ::lConnected; return .F.; endif
   aResult := ::Query( "SELECT name FROM sqlite_master WHERE type='table' AND name='" + cTable + "'" )
return Len( aResult ) > 0

METHOD Tables() CLASS TSQLite
   local aResult, aNames := {}, i
   if ! ::lConnected; return {}; endif
   aResult := ::Query( "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name" )
   for i := 1 to Len( aResult )
      AAdd( aNames, aResult[i][1] )
   next
return aNames

METHOD CreateTable( cName, aFields ) CLASS TSQLite
   local cSQL := "CREATE TABLE IF NOT EXISTS " + cName + " (", i
   for i := 1 to Len( aFields )
      if i > 1; cSQL += ", "; endif
      cSQL += aFields[i][1] + " " + aFields[i][2]
   next
   cSQL += ")"
return ::Execute( cSQL )

METHOD BeginTransaction() CLASS TSQLite
return ::Execute( "BEGIN TRANSACTION" )

METHOD Commit() CLASS TSQLite
return ::Execute( "COMMIT" )

METHOD Rollback() CLASS TSQLite
return ::Execute( "ROLLBACK" )

METHOD LastInsertId() CLASS TSQLite
   local aResult
   if ! ::lConnected; return 0; endif
   aResult := ::Query( "SELECT last_insert_rowid()" )
   if Len( aResult ) > 0; return aResult[1][1]; endif
return 0

//----------------------------------------------------------------------------//
// TMySQL - MySQL/MariaDB connection via libmysqlclient (cocoa_mysql.c)
//
// Properties (inherited from TDatabase + own):
//    cServer    - host name (default "127.0.0.1")
//    nPort      - TCP port (default 3306)
//    cDatabase  - schema/database name
//    cUser      - login user
//    cPassword  - login password
//    cCharSet   - character set (sent via SET NAMES, default "utf8mb4")
//    lAutoCommit- auto-commit mode (default .T.)
//    cTable     - table for cursor navigation
//    cSQL       - custom SELECT for cursor navigation
//
// Events (code blocks, fired when assigned):
//    bOnConnect    - { || ... }       fires after successful Open()
//    bOnDisconnect - { || ... }       fires after Close()
//    bOnError      - { |cMsg| ... }   fires when any operation fails
//----------------------------------------------------------------------------//

CLASS TMySQL INHERIT TDatabase

   DATA lAutoCommit  INIT .T.
   DATA cTable       INIT ""
   DATA cSQL         INIT ""
   DATA aRows        INIT {}
   DATA aFieldNames  INIT {}
   DATA nRecord      INIT 0

   DATA bOnConnect    INIT nil
   DATA bOnDisconnect INIT nil
   DATA bOnError      INIT nil

   METHOD New() CONSTRUCTOR
   METHOD Open()
   METHOD Close()
   METHOD Execute( cSQL )
   METHOD Query( cSQL )
   METHOD TableExists( cTable )
   METHOD Tables()
   METHOD LastInsertId()

   // Cursor navigation (DBGrid compatible)
   METHOD LoadCursor()
   METHOD FieldCount()
   METHOD FieldName( n )
   METHOD GoTop()
   METHOD Eof()
   METHOD FieldGet( n )
   METHOD Skip( n )

   METHOD FireError( cMsg )

ENDCLASS

METHOD New() CLASS TMySQL
   ::cDriver := "MySQL"
   ::cServer := "127.0.0.1"
   ::nPort   := 3306
   ::cCharSet := "utf8mb4"
return Self

METHOD FireError( cMsg ) CLASS TMySQL
   ::cLastError := cMsg
   if ::bOnError != nil
      Eval( ::bOnError, cMsg )
   endif
return Self

METHOD Open() CLASS TMySQL
   ::pHandle := HBMYSQL_OPEN( ::cServer, ::cUser, ::cPassword, ;
                              ::cDatabase, ::nPort )
   if ::pHandle == 0 .or. ::pHandle == nil
      ::pHandle    := nil
      ::lConnected := .F.
      ::FireError( "Connection failed: " + HBMYSQL_ERROR( 0 ) )
      return .F.
   endif
   ::lConnected := .T.
   if ! Empty( ::cCharSet )
      HBMYSQL_EXEC( ::pHandle, "SET NAMES '" + ::cCharSet + "'" )
   endif
   if ! ::lAutoCommit
      HBMYSQL_EXEC( ::pHandle, "SET autocommit=0" )
   endif
   ::LoadCursor()
   if ::bOnConnect != nil
      Eval( ::bOnConnect )
   endif
return .T.

METHOD Close() CLASS TMySQL
   if ::pHandle != nil
      HBMYSQL_CLOSE( ::pHandle )
   endif
   ::pHandle    := nil
   ::lConnected := .F.
   if ::bOnDisconnect != nil
      Eval( ::bOnDisconnect )
   endif
return nil

METHOD Execute( cSQL ) CLASS TMySQL
   local lOk
   if ! ::lConnected; ::FireError( "Not connected" ); return .F.; endif
   lOk := HBMYSQL_EXEC( ::pHandle, cSQL )
   if ! lOk
      ::FireError( HBMYSQL_ERROR( ::pHandle ) )
   endif
return lOk

METHOD Query( cSQL ) CLASS TMySQL
   local aRet
   if ! ::lConnected; ::FireError( "Not connected" ); return {}; endif
   aRet := HBMYSQL_QUERY( ::pHandle, cSQL )
   if Empty( aRet ) .and. ! Empty( HBMYSQL_ERROR( ::pHandle ) )
      ::FireError( HBMYSQL_ERROR( ::pHandle ) )
   endif
return aRet

METHOD LoadCursor() CLASS TMySQL
   local cQuery
   if ! ::lConnected; return Self; endif
   cQuery := iif( ! Empty( ::cSQL ), ::cSQL, ;
             iif( ! Empty( ::cTable ), "SELECT * FROM " + ::cTable, "" ) )
   ::aRows       := {}
   ::aFieldNames := {}
   ::nRecord     := 0
   if Empty( cQuery ); return Self; endif
   ::aFieldNames := HBMYSQL_FIELDS( ::pHandle, cQuery )
   ::aRows       := HBMYSQL_QUERY ( ::pHandle, cQuery )
   ::nRecord     := iif( Len( ::aRows ) > 0, 1, 0 )
return Self

METHOD FieldCount() CLASS TMySQL
return Len( ::aFieldNames )

METHOD FieldName( n ) CLASS TMySQL
   if n >= 1 .and. n <= Len( ::aFieldNames )
      return ::aFieldNames[ n ]
   endif
return ""

METHOD GoTop() CLASS TMySQL
   ::nRecord := iif( Len( ::aRows ) > 0, 1, 0 )
return Self

METHOD Eof() CLASS TMySQL
return ::nRecord == 0 .or. ::nRecord > Len( ::aRows )

METHOD FieldGet( n ) CLASS TMySQL
   if ! ::Eof() .and. n >= 1 .and. n <= Len( ::aRows[ ::nRecord ] )
      return ::aRows[ ::nRecord ][ n ]
   endif
return nil

METHOD Skip( n ) CLASS TMySQL
   ::nRecord += n
   if ::nRecord < 1; ::nRecord := 1; endif
return Self

METHOD TableExists( cTable ) CLASS TMySQL
   local aResult
   if ! ::lConnected; return .F.; endif
   aResult := ::Query( "SHOW TABLES LIKE '" + cTable + "'" )
return Len( aResult ) > 0

METHOD Tables() CLASS TMySQL
   if ! ::lConnected; return {}; endif
return HBMYSQL_TABLES( ::pHandle )

METHOD LastInsertId() CLASS TMySQL
   if ! ::lConnected; return 0; endif
return HBMYSQL_LASTID( ::pHandle )

//----------------------------------------------------------------------------//
// TMariaDB - alias for TMySQL (wire-compatible)
//----------------------------------------------------------------------------//

CLASS TMariaDB INHERIT TMySQL
   METHOD New() CONSTRUCTOR
ENDCLASS

METHOD New() CLASS TMariaDB
   ::Super:New()
   ::cDriver := "MariaDB"
   ::nPort   := 3306
return Self

//----------------------------------------------------------------------------//
// TPostgreSQL - PostgreSQL connection (requires libpq)
//----------------------------------------------------------------------------//

CLASS TPostgreSQL INHERIT TDatabase

   DATA cTable        INIT ""
   DATA cSQL          INIT ""
   DATA aRows         INIT {}
   DATA aFieldNames   INIT {}
   DATA nRecord       INIT 0
   DATA cIdSequence   INIT ""           // sequence used by LastInsertId

   DATA bOnConnect    INIT nil
   DATA bOnDisconnect INIT nil
   DATA bOnError      INIT nil

   METHOD New() CONSTRUCTOR
   METHOD Open()
   METHOD Close()
   METHOD Execute( cSQL )
   METHOD Query( cSQL )
   METHOD TableExists( cTable )
   METHOD Tables()
   METHOD LastInsertId( cSeq )

   METHOD LoadCursor()
   METHOD FieldCount()
   METHOD FieldName( n )
   METHOD GoTop()
   METHOD Eof()
   METHOD FieldGet( n )
   METHOD Skip( n )

   METHOD FireError( cMsg )

ENDCLASS

METHOD New() CLASS TPostgreSQL
   ::cDriver := "PostgreSQL"
   ::cServer := "127.0.0.1"
   ::nPort   := 5432
   ::cUser   := "postgres"
   ::cDatabase := "postgres"
return Self

METHOD FireError( cMsg ) CLASS TPostgreSQL
   ::cLastError := cMsg
   if ::bOnError != nil
      Eval( ::bOnError, cMsg )
   endif
return Self

METHOD Open() CLASS TPostgreSQL
   ::pHandle := HBPGSQL_OPEN( ::cServer, ::cUser, ::cPassword, ;
                              ::cDatabase, ::nPort )
   if ::pHandle == 0 .or. ::pHandle == nil
      ::pHandle    := nil
      ::lConnected := .F.
      ::FireError( "Connection failed: " + HBPGSQL_ERROR( 0 ) )
      return .F.
   endif
   ::lConnected := .T.
   ::LoadCursor()
   if ::bOnConnect != nil
      Eval( ::bOnConnect )
   endif
return .T.

METHOD Close() CLASS TPostgreSQL
   if ::pHandle != nil
      HBPGSQL_CLOSE( ::pHandle )
   endif
   ::pHandle    := nil
   ::lConnected := .F.
   if ::bOnDisconnect != nil
      Eval( ::bOnDisconnect )
   endif
return nil

METHOD Execute( cSQL ) CLASS TPostgreSQL
   local lOk
   if ! ::lConnected; ::FireError( "Not connected" ); return .F.; endif
   lOk := HBPGSQL_EXEC( ::pHandle, cSQL )
   if ! lOk
      ::FireError( HBPGSQL_ERROR( ::pHandle ) )
   endif
return lOk

METHOD Query( cSQL ) CLASS TPostgreSQL
   local aRet
   if ! ::lConnected; ::FireError( "Not connected" ); return {}; endif
   aRet := HBPGSQL_QUERY( ::pHandle, cSQL )
   if Empty( aRet ) .and. ! Empty( HBPGSQL_ERROR( ::pHandle ) )
      ::FireError( HBPGSQL_ERROR( ::pHandle ) )
   endif
return aRet

METHOD LoadCursor() CLASS TPostgreSQL
   local cQuery
   if ! ::lConnected; return Self; endif
   cQuery := iif( ! Empty( ::cSQL ), ::cSQL, ;
             iif( ! Empty( ::cTable ), "SELECT * FROM " + ::cTable, "" ) )
   ::aRows       := {}
   ::aFieldNames := {}
   ::nRecord     := 0
   if Empty( cQuery ); return Self; endif
   ::aFieldNames := HBPGSQL_FIELDS( ::pHandle, cQuery )
   ::aRows       := HBPGSQL_QUERY ( ::pHandle, cQuery )
   ::nRecord     := iif( Len( ::aRows ) > 0, 1, 0 )
return Self

METHOD FieldCount() CLASS TPostgreSQL
return Len( ::aFieldNames )

METHOD FieldName( n ) CLASS TPostgreSQL
   if n >= 1 .and. n <= Len( ::aFieldNames )
      return ::aFieldNames[ n ]
   endif
return ""

METHOD GoTop() CLASS TPostgreSQL
   ::nRecord := iif( Len( ::aRows ) > 0, 1, 0 )
return Self

METHOD Eof() CLASS TPostgreSQL
return ::nRecord == 0 .or. ::nRecord > Len( ::aRows )

METHOD FieldGet( n ) CLASS TPostgreSQL
   if ! ::Eof() .and. n >= 1 .and. n <= Len( ::aRows[ ::nRecord ] )
      return ::aRows[ ::nRecord ][ n ]
   endif
return nil

METHOD Skip( n ) CLASS TPostgreSQL
   ::nRecord += n
   if ::nRecord < 1; ::nRecord := 1; endif
return Self

METHOD TableExists( cTable ) CLASS TPostgreSQL
   local aResult
   if ! ::lConnected; return .F.; endif
   aResult := ::Query( "SELECT 1 FROM information_schema.tables WHERE table_name='" + cTable + "'" )
return Len( aResult ) > 0

METHOD Tables() CLASS TPostgreSQL
   if ! ::lConnected; return {}; endif
return HBPGSQL_TABLES( ::pHandle )

METHOD LastInsertId( cSeq ) CLASS TPostgreSQL
   if ! ::lConnected; return 0; endif
   if cSeq == nil; cSeq := ::cIdSequence; endif
   if Empty( cSeq ); return 0; endif
return HBPGSQL_LASTID( ::pHandle, cSeq )

//----------------------------------------------------------------------------//
// TFirebird - Firebird connection (requires libfbclient)
//----------------------------------------------------------------------------//

CLASS TFirebird INHERIT TDatabase
   METHOD New() CONSTRUCTOR
   METHOD Open()
ENDCLASS

METHOD New() CLASS TFirebird
   ::cDriver := "Firebird"
   ::nPort   := 3050
return Self

METHOD Open() CLASS TFirebird
   ::cLastError := "Firebird support requires libfbclient. Install with: apt install firebird-dev"
return .F.

//----------------------------------------------------------------------------//
// TSQLServer - SQL Server connection (requires FreeTDS/ODBC)
//----------------------------------------------------------------------------//

CLASS TSQLServer INHERIT TDatabase
   METHOD New() CONSTRUCTOR
   METHOD Open()
ENDCLASS

METHOD New() CLASS TSQLServer
   ::cDriver := "SQLServer"
   ::nPort   := 1433
return Self

METHOD Open() CLASS TSQLServer
   ::cLastError := "SQL Server support requires FreeTDS. Install with: apt install freetds-dev"
return .F.

//----------------------------------------------------------------------------//
// TOracle - Oracle connection (requires OCI)
//----------------------------------------------------------------------------//

CLASS TOracle INHERIT TDatabase
   METHOD New() CONSTRUCTOR
   METHOD Open()
ENDCLASS

METHOD New() CLASS TOracle
   ::cDriver := "Oracle"
   ::nPort   := 1521
return Self

METHOD Open() CLASS TOracle
   ::cLastError := "Oracle support requires Oracle Instant Client"
return .F.

//----------------------------------------------------------------------------//
// TMongoDB - MongoDB connection (requires mongoc driver)
//----------------------------------------------------------------------------//

CLASS TMongoDB INHERIT TDatabase
   METHOD New() CONSTRUCTOR
   METHOD Open()
ENDCLASS

METHOD New() CLASS TMongoDB
   ::cDriver := "MongoDB"
   ::nPort   := 27017
return Self

METHOD Open() CLASS TMongoDB
   ::cLastError := "MongoDB support requires libmongoc. Install with: apt install libmongoc-dev"
return .F.

