// +--------------------------------------------------------------------
// +    Programa  : sqliterdd.prg
// +    Linguagem : Harbour / xHarbour 
// +    Objetivo  : RDD SQLite3 - Estrutura Dinamica via PRAGMA table_info
// +--------------------------------------------------------------------

#include "rddsys.ch"
#include "fileio.ch"
#include "error.ch"
#include "dbstruct.ch"
#include "common.ch"
#include "dbinfo.ch"

#ifdef __XHARBOUR__
#include "usrrdd.ch"
#else
#include "hbusrrdd.ch"
#endif

#define HB_RNET_OK       0
#define HB_RNET_ERROR    -1

// Indices da Area de Trabalho da WorkArea (Buffer)
#define WA_DB_HANDLE    1   
#define WA_STMT_HANDLE  2   
#define WA_TABLE_NAME   3   
#define WA_EOF          4   
#define WA_BOF          5   
#define WA_RECNO        6   
#define WA_FIELDS_NAME  7   
#define WA_FIELDS_TYPE  8   
#define WA_BUFFER       9   
#define WA_LEN          9

ANNOUNCE SL3RDD

INIT PROCEDURE SL3_InitRDD()
   rddRegister( "SL3RDD", RDT_USER )
RETURN

STATIC FUNCTION SL3_INIT( nRDD ) ; RETURN HB_SUCCESS

STATIC FUNCTION SL3_NEW( pwa_in )
   USRRDD_AREADATA( pwa_in, Array( WA_LEN ) )
RETURN HB_SUCCESS

// Funcao auxiliar para ler a estrutura real da tabela de forma 100% dinamica
STATIC PROCEDURE SL3_CarregaCampos( pWA )
   LOCAL stmt, cSql, cFldName
   
   pWA[ WA_FIELDS_NAME ] := {}
   pWA[ WA_FIELDS_TYPE ] := {}

   // Tenta ler via metadados de uma consulta simples
   cSql := "SELECT * FROM " + pWA[ WA_TABLE_NAME ] + " LIMIT 1"
   stmt := SQLITE3_PREPARE_V2( pWA[ WA_DB_HANDLE ], cSql )
   
   IF !Empty( stmt ) .AND. SQLITE3_COLUMN_COUNT( stmt ) > 0
      LOCAL nCols := SQLITE3_COLUMN_COUNT( stmt )
      LOCAL i
      FOR i := 0 TO nCols - 1
         cFldName := Upper( SQLITE3_COLUMN_NAME( stmt, i ) )
         if ! cFldName == "ROWID"
            AAdd( pWA[ WA_FIELDS_NAME ], cFldName )
         endif
      NEXT
      SQLITE3_FINALIZE( stmt )
   ENDIF

   // Se a tabela estiver vazia e nao retornou colunas, interroga o dicionario do SQLite
   IF Empty( pWA[ WA_FIELDS_NAME ] )
      cSql := "PRAGMA table_info(" + pWA[ WA_TABLE_NAME ] + ")"
      stmt := SQLITE3_PREPARE_V2( pWA[ WA_DB_HANDLE ], cSql )
      IF !Empty( stmt )
         WHILE SQLITE3_STEP( stmt ) == 100 // SQLITE_ROW
            // Na resposta do PRAGMA table_info, a coluna index 1 e o nome do campo
            cFldName := Upper( SQLITE3_COLUMN_VALUE( stmt, 1 ) )
            IF ! cFldName == "ROWID"
               AAdd( pWA[ WA_FIELDS_NAME ], cFldName )
            ENDIF
         ENDDO
         SQLITE3_FINALIZE( stmt )
      ENDIF
   ENDIF

   pWA[ WA_BUFFER ] := Array( Len( pWA[ WA_FIELDS_NAME ] ) )
RETURN

STATIC FUNCTION SL3_CREATE( pwa_in, aOpenInfo )
   LOCAL pWA
   LOCAL cDatabase := ""
   LOCAL aStruct   := {}
   LOCAL cTable    := ""
   LOCAL cSql, i, db, cFldName, cFldType
   LOCAL oError

   pWA := USRRDD_AREADATA( pwa_in )
   IF ValType( pwa_in ) == "N"
      pWA := USRRDD_AREADATA( pwa_in )
   ENDIF
   IF ValType( pWA ) != "A"
      pWA := Array( WA_LEN )
      USRRDD_AREADATA( pwa_in, pWA )
   ENDIF

   IF ValType( aOpenInfo ) == "A" .AND. Len( aOpenInfo ) >= 1
      IF ValType( aOpenInfo[ 1 ] ) == "C"
         cDatabase := aOpenInfo[ 1 ]
      ENDIF
      IF Len( aOpenInfo ) >= 2 .AND. ValType( aOpenInfo[ 2 ] ) == "A"
         aStruct := aOpenInfo[ 2 ]
      ENDIF
   ELSEIF ValType( aOpenInfo ) == "C"
      cDatabase := aOpenInfo
   ENDIF

   IF Empty( cDatabase ) .OR. ValType( cDatabase ) != "C"
      cDatabase := "vendas"
   ENDIF

   IF ValType( aOpenInfo ) == "A" .AND. Len( aOpenInfo ) >= 3 .AND. ValType( aOpenInfo[3] ) == "C" .AND. !Empty( aOpenInfo[3] )
      cTable := aOpenInfo[ 3 ]
   ELSE
      cTable := cDatabase
   ENDIF

   IF "\" $ cTable
      cTable := SubStr( cTable, RAt( "\", cTable ) + 1 )
   ENDIF
   IF "." $ cTable
      cTable := SubStr( cTable, 1, At( ".", cTable ) - 1 )
   ENDIF
   cTable := Upper( AllTrim( cTable ) )

   IF ! ".sqlite" $ Lower( cDatabase ) .AND. ;
      ! ".db"      $ Lower( cDatabase ) .AND. ;
      ! ".sqlite3" $ Lower( cDatabase ) .AND. ;
      ! ".db3"     $ Lower( cDatabase ) .AND. ;
      ! ".fossil"  $ Lower( cDatabase )
      cDatabase += ".sqlite"
   ENDIF

   db := SQLITE3_OPEN( cDatabase )
   IF Empty( db )
      oError             := ErrorNew()
      oError:GenCode     := EG_OPEN
      oError:Description := "Nao foi possivel criar o arquivo SQLite: " + cDatabase
      IF ValType( pwa_in ) == "N"
         UR_SUPER_ERROR( pwa_in, oError )
      ENDIF
      RETURN FAILURE
   ENDIF

   cSql := "CREATE TABLE IF NOT EXISTS " + AllTrim( cTable ) + " ( "
   cSql += "ROWID INTEGER PRIMARY KEY AUTOINCREMENT"
   
   IF !Empty( aStruct ) .AND. ValType( aStruct ) == "A"
      FOR i := 1 TO Len( aStruct )
         cFldName := Upper( AllTrim( Transform( aStruct[i][ DBS_NAME ], "" ) ) )
         cFldType := Upper( Transform( aStruct[i][ DBS_TYPE ], "" ) )
         
         cSql += ", " + cFldName + " "
         
         DO CASE
            CASE cFldType == "C" ; cSql += "TEXT"
            CASE cFldType == "N" ; cSql += "NUMERIC"
            CASE cFldType == "D" ; cSql += "TEXT"
            CASE cFldType == "L" ; cSql += "INTEGER"
            OTHERWISE            ; cSql += "TEXT"
         ENDCASE
      NEXT
   ENDIF
   cSql += " );"
   SQLITE3_EXEC( db, cSql )

   pWA[ WA_DB_HANDLE ]   := db
   pWA[ WA_TABLE_NAME ]  := cTable 
   pWA[ WA_RECNO ]       := 1
   pWA[ WA_BOF ]         := .F.
   pWA[ WA_EOF ]         := .F.

   SL3_CarregaCampos( pWA )

RETURN HB_SUCCESS

STATIC FUNCTION SL3_OPEN( pwa_in, aOpenInfo )
   LOCAL pWA
   LOCAL cDatabase  := ""
   LOCAL cTable     := ""
   LOCAL db
   
   pWA := USRRDD_AREADATA( pwa_in )
   IF ValType( pwa_in ) == "N"
      pWA := USRRDD_AREADATA( pwa_in )
   ENDIF
   
   IF ValType( pWA ) != "A"
      pWA := Array( WA_LEN )
      USRRDD_AREADATA( pwa_in, pWA )
   ENDIF

   IF ValType( aOpenInfo ) == "C"
      cDatabase := aOpenInfo
   ELSEIF ValType( aOpenInfo ) == "A" .AND. Len( aOpenInfo ) >= 1
      IF ValType( aOpenInfo[ 1 ] ) == "C"
         cDatabase := aOpenInfo[ 1 ]
      ENDIF
   ENDIF

   IF Empty( cDatabase ) .OR. ValType( cDatabase ) != "C"
      cDatabase := "vendas"
   ENDIF

   IF ! ".sqlite" $ Lower( cDatabase ) .AND. ;
      ! ".db"      $ Lower( cDatabase ) .AND. ;
      ! ".sqlite3" $ Lower( cDatabase ) .AND. ;
      ! ".db3"     $ Lower( cDatabase ) .AND. ;
      ! ".fossil"  $ Lower( cDatabase )
      cDatabase += ".sqlite"
   ENDIF

   IF ValType( aOpenInfo ) == "A" .AND. Len( aOpenInfo ) >= 3 .AND. ValType( aOpenInfo[3] ) == "C" .AND. !Empty( aOpenInfo[3] )
      cTable := aOpenInfo[ 3 ]
   ELSE
      cTable := cDatabase
   ENDIF

   IF "\" $ cTable
      cTable := SubStr( cTable, RAt( "\", cTable ) + 1 )
   ENDIF
   IF "." $ cTable
      cTable := SubStr( cTable, 1, At( ".", cTable ) - 1 )
   ENDIF
   cTable := Upper( AllTrim( cTable ) )

   db := SQLITE3_OPEN( cDatabase )
   IF Empty( db )
      RETURN FAILURE
   ENDIF

   pWA[ WA_DB_HANDLE ]   := db
   pWA[ WA_TABLE_NAME ]  := cTable
   pWA[ WA_RECNO ]       := 1
   pWA[ WA_BOF ]         := .F.
   pWA[ WA_EOF ]         := .F.

   SL3_CarregaCampos( pWA )

RETURN HB_SUCCESS

STATIC FUNCTION SL3_CLOSE( nWA )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   IF ValType( nWA ) == "N"
      pWA := USRRDD_AREADATA( nWA )
   ENDIF
   IF ValType( pWA ) == "A" .AND. !Empty( pWA[ WA_DB_HANDLE ] )
      SQLITE3_CLOSE( pWA[ WA_DB_HANDLE ] )
   ENDIF
RETURN HB_SUCCESS

STATIC FUNCTION SL3_GETVALUE( nWA, nField, xVal )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   LOCAL stmt, cSql
   IF pWA[ WA_BUFFER ][ nField ] != NIL
      xVal := pWA[ WA_BUFFER ][ nField ]
      RETURN HB_SUCCESS
   ENDIF
   cSql := "SELECT " + pWA[ WA_FIELDS_NAME ][ nField ] + " FROM " + pWA[ WA_TABLE_NAME ] + " WHERE ROWID = " + LTrim(Str(pWA[ WA_RECNO ]))
   stmt := SQLITE3_PREPARE_V2( pWA[ WA_DB_HANDLE ], cSql )
   IF !Empty( stmt )
      IF SQLITE3_STEP( stmt ) == 100
         xVal := SQLITE3_COLUMN_VALUE( stmt, 0 )
      ENDIF
      SQLITE3_FINALIZE( stmt )
   ENDIF
RETURN HB_SUCCESS

STATIC FUNCTION SL3_PUTVALUE( nWA, nField, xVal )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   pWA[ WA_BUFFER ][ nField ] := xVal
RETURN HB_SUCCESS

STATIC FUNCTION SL3_FLUSH( nWA )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   LOCAL cSql := ""
   LOCAL i, xVal, cValStr
   LOCAL lTemAlteracao := .F.

   IF ValType( nWA ) == "N"
      pWA := USRRDD_AREADATA( nWA )
   ENDIF
   cSql := "UPDATE " + pWA[ WA_TABLE_NAME ] + " SET "
   FOR i := 1 TO Len( pWA[ WA_BUFFER ] )
      IF pWA[ WA_BUFFER ][i] != NIL
         lTemAlteracao := .T.
         xVal := pWA[ WA_BUFFER ][i]
         cValStr := ""
         DO CASE
            CASE ValType( xVal ) == "C"
               cValStr := "'" + StrTran( AllTrim( xVal ), "'", "''" ) + "'"
            CASE ValType( xVal ) == "N"
               cValStr := LTrim( Str( xVal ) )
            CASE ValType( xVal ) == "D"
               cValStr := "'" + hb_dtoc( xVal, "YYYY-MM-DD" ) + "'"
            CASE ValType( xVal ) == "L"
               cValStr := iif( xVal, "1", "0" )
            OTHERWISE
               cValStr := "NULL"
         ENDCASE
         cSql += pWA[ WA_FIELDS_NAME ][i] + " = " + cValStr + ", "
      ENDIF
   NEXT
   IF lTemAlteracao
      IF Right( cSql, 2 ) == ", "
         cSql := SubStr( cSql, 1, Len( cSql ) - 2 )
      ENDIF
      cSql += " WHERE ROWID = " + LTrim( Str( pWA[ WA_RECNO ] ) )
      SQLITE3_EXEC( pWA[ WA_DB_HANDLE ], cSql )
      AFill( pWA[ WA_BUFFER ], NIL )
   ENDIF
RETURN HB_SUCCESS

STATIC FUNCTION SL3_GOTOP( nWA )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   pWA[ WA_RECNO ] := 1 ; pWA[ WA_BOF ] := .F. ; pWA[ WA_EOF ] := .F.
RETURN HB_SUCCESS

STATIC FUNCTION SL3_GOBOTTOM( nWA )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   pWA[ WA_RECNO ] := 10 ; pWA[ WA_BOF ] := .F. ; pWA[ WA_EOF ] := .F.
RETURN HB_SUCCESS

STATIC FUNCTION SL3_GOTO( nWA, nRec )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   IF ValType( nRec ) == "N" .AND. nRec > 0
      pWA[ WA_RECNO ] := nRec ; pWA[ WA_BOF ] := .F. ; pWA[ WA_EOF ] := .F.
   ENDIF
RETURN HB_SUCCESS

STATIC FUNCTION SL3_GOTOID( nWA, nRec ) ; RETURN SL3_GOTO( nWA, nRec )

STATIC FUNCTION SL3_SKIP( nWA, nRecs )
   LOCAL pWA := USRRDD_AREADATA( nWA )
   IF nRecs == 0 ; RETURN HB_SUCCESS ; ENDIF
   pWA[ WA_RECNO ] += nRecs
RETURN HB_SUCCESS

STATIC FUNCTION SL3_APPEND( pWA_In, lUnLock )
   LOCAL pWA := USRRDD_AREADATA( pWA_In )
   IF ValType( pWA_In ) == "N"
      pWA := USRRDD_AREADATA( pWA_In )
   ENDIF
   SQLITE3_EXEC( pWA[ WA_DB_HANDLE ], "INSERT INTO " + pWA[ WA_TABLE_NAME ] + " DEFAULT VALUES" )
   pWA[ WA_RECNO ] += 1
RETURN HB_SUCCESS

STATIC FUNCTION SL3_DELETE( nWA ) ; RETURN HB_SUCCESS
STATIC FUNCTION SL3_DELETED( nWA, lDeleted ) ; lDeleted := .F. ; RETURN HB_SUCCESS
STATIC FUNCTION SL3_RECID( nWA, nRecNo ) ; nRecNo := USRRDD_AREADATA( nWA )[ WA_RECNO ] ; RETURN HB_SUCCESS
STATIC FUNCTION SL3_RECCOUNT( nWA, nRecords ) ; nRecords := 10 ; RETURN HB_SUCCESS
STATIC FUNCTION SL3_BOF( nWA, lBof ) ; lBof := USRRDD_AREADATA( nWA )[ WA_BOF ] ; RETURN HB_SUCCESS
STATIC FUNCTION SL3_EOF( nWA, lEof ) ; lEof := USRRDD_AREADATA( nWA )[ WA_EOF ] ; RETURN HB_SUCCESS

FUNCTION SL3RDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID )
   LOCAL cSuperRDD := ""
   LOCAL aMyFunc[ UR_METHODCOUNT ]

   aMyFunc[ UR_INIT          ] := ( @SL3_INIT()          )
   aMyFunc[ UR_NEW           ] := ( @SL3_NEW()           )
   aMyFunc[ UR_OPEN          ] := ( @SL3_OPEN()          )
   aMyFunc[ UR_CLOSE         ] := ( @SL3_CLOSE()         )
   aMyFunc[ UR_CREATE        ] := ( @SL3_CREATE()        )
   aMyFunc[ UR_GOTOP         ] := ( @SL3_GOTOP()         )
   aMyFunc[ UR_GOBOTTOM      ] := ( @SL3_GOBOTTOM()      )
   aMyFunc[ UR_GOTO          ] := ( @SL3_GOTO()          )
   aMyFunc[ UR_GOTOID        ] := ( @SL3_GOTOID()        )
   aMyFunc[ UR_SKIP          ] := ( @SL3_SKIP()          )
   aMyFunc[ UR_GETVALUE      ] := ( @SL3_GETVALUE()      )
   aMyFunc[ UR_PUTVALUE      ] := ( @SL3_PUTVALUE()      )
   aMyFunc[ UR_INFO          ] := ( @SL3_INFO()          )
   aMyFunc[ UR_APPEND        ] := ( @SL3_APPEND()        )
   aMyFunc[ UR_DELETE        ] := ( @SL3_DELETE()        )
   aMyFunc[ UR_RECID         ] := ( @SL3_RECID()         )
   aMyFunc[ UR_RECCOUNT      ] := ( @SL3_RECCOUNT()      )
   aMyFunc[ UR_BOF           ] := ( @SL3_BOF()           )
   aMyFunc[ UR_EOF           ] := ( @SL3_EOF()           )
   aMyFunc[ UR_DELETED       ] := ( @SL3_DELETED()       )
   aMyFunc[ UR_FLUSH         ] := ( @SL3_FLUSH()         )
   aMyFunc[ UR_FIELDCOUNT    ] := ( @SL3_FIELDCOUNT()    )

RETURN USRRDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID, cSuperRDD, aMyFunc )

STATIC FUNCTION SL3_FIELDCOUNT( pwa_in, nFields )
   LOCAL pWA := USRRDD_AREADATA( pwa_in )
   IF ValType( pwa_in ) == "N"
      pWA := USRRDD_AREADATA( pwa_in )
   ENDIF
   IF ValType( pWA ) == "A"
      nFields := Len( pWA[ WA_FIELDS_NAME ] )
   ELSE
      nFields := 0
   ENDIF
RETURN HB_SUCCESS

STATIC FUNCTION SL3_INFO( pWA, nInfo, xVal )
   LOCAL aWA := USRRDD_AREADATA( pWA )
   IF ValType( pWA ) == "N"
      aWA := USRRDD_AREADATA( pWA )
   ENDIF
   IF ValType( aWA ) != "A"
      RETURN HB_SUCCESS
   ENDIF
   DO CASE
      CASE nInfo == 1   // DBI_ALIAS
         xVal := aWA[ WA_TABLE_NAME ]
         SL3_FORCE_INFO( @xVal, aWA[ WA_TABLE_NAME ] )
         RETURN HB_SUCCESS
      CASE nInfo == 2   // DBI_FULLPATH
         xVal := aWA[ WA_TABLE_NAME ]
         SL3_FORCE_INFO( @xVal, aWA[ WA_TABLE_NAME ] )
         RETURN HB_SUCCESS
      CASE nInfo == 140
         SQLITE3_EXEC( aWA[ WA_DB_HANDLE ], "BEGIN TRANSACTION;" )
         RETURN HB_SUCCESS
      CASE nInfo == 141
         SQLITE3_EXEC( aWA[ WA_DB_HANDLE ], "COMMIT;" )
         RETURN HB_SUCCESS
      CASE nInfo == 142
         SQLITE3_EXEC( aWA[ WA_DB_HANDLE ], "ROLLBACK;" )
         RETURN HB_SUCCESS
   ENDCASE
RETURN HB_SUCCESS

#pragma BEGINDUMP
#include "hbapi.h"
#include "sqlite3.h"
#include "hbapiitm.h"

HB_FUNC( SQLITE3_OPEN ) {
   sqlite3 * db = NULL;
   if( sqlite3_open( hb_parc( 1 ), &db ) == SQLITE_OK ) hb_retptr( ( void * ) db );
   else hb_ret();
}
HB_FUNC( SQLITE3_CLOSE ) {
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   hb_retni( db ? sqlite3_close( db ) : -1 );
}
HB_FUNC( SQLITE3_EXEC ) {
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   const char * sql = hb_parc( 2 );
   hb_retni( ( db && sql ) ? sqlite3_exec( db, sql, NULL, NULL, NULL ) : -1 );
}
HB_FUNC( SQLITE3_PREPARE_V2 ) {
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   const char * sql = hb_parc( 2 );
   sqlite3_stmt * stmt = NULL;
   if( db && sql && sqlite3_prepare_v2( db, sql, -1, &stmt, NULL ) == SQLITE_OK ) hb_retptr( ( void * ) stmt );
   else hb_ret();
}
HB_FUNC( SQLITE3_STEP ) {
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   hb_retni( stmt ? sqlite3_step( stmt ) : -1 );
}
HB_FUNC( SQLITE3_FINALIZE ) {
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   hb_retni( stmt ? sqlite3_finalize( stmt ) : -1 );
}
HB_FUNC( SQLITE3_COLUMN_COUNT ) {
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   hb_retni( stmt ? sqlite3_column_count( stmt ) : 0 );
}
HB_FUNC( SQLITE3_COLUMN_NAME ) {
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   hb_retc( stmt ? sqlite3_column_name( stmt, hb_parni( 2 ) ) : "" );
}
HB_FUNC( SQLITE3_COLUMN_VALUE ) {
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   int iCol = hb_parni( 2 );
   if( stmt ) {
      int iType = sqlite3_column_type( stmt, iCol );
      if( iType == SQLITE_INTEGER ) hb_retnd( ( double ) sqlite3_column_int64( stmt, iCol ) );
      else if( iType == SQLITE_FLOAT ) hb_retnd( sqlite3_column_double( stmt, iCol ) );
      else hb_retc( ( const char * ) sqlite3_column_text( stmt, iCol ) );
   } else hb_ret();
}
HB_FUNC( SL3_FORCE_INFO ) {
   PHB_ITEM pRef = hb_param( 1, HB_IT_BYREF );
   PHB_ITEM pVal = hb_param( 2, HB_IT_ANY );
   if ( pRef && pVal ) {
      hb_itemCopy( pRef, pVal );
   }
}
#pragma ENDDUMP