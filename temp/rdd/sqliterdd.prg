#include "rddsys.ch"
#include "usrrdd.ch"
#include "fileio.ch"
#include "error.ch"
#include "dbstruct.ch"
#include "common.ch"

/* Definições de Status da Engine */
#define HB_RNET_OK       0
#define HB_RNET_ERROR    -1
#define SQLITE_ROW       100
#define SQLITE_DONE      101

/* Índices da Área de Dados da WorkArea (Mesmo padrão do seu MYSQLRDD) */
#define WA_DB_HANDLE    1   
#define WA_STMT_HANDLE  2   
#define WA_TABLE_NAME   3   
#define WA_EOF          4   
#define WA_BOF          5   
#define WA_RECNO        6   
#define WA_FIELDS_TYPE  7   
#define WA_LEN          7

ANNOUNCE SL3RDD

/* Registo automático da RDD ao iniciar o binário */
INIT PROCEDURE SL3_InitRDD()
   rddRegister( "SL3RDD", SL3RDD_GETFUNCTABLE() )
RETURN

/* MECÂNICA ESTRITA DO MYSQLRDD: Sem chamadas a RDDINHERIT() */
FUNCTION SL3RDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID )
   LOCAL aMyFunc[ UR_METHODCOUNT ]

   /* Vinculação dos Blocos Operacionais nativos da USRRDD */
   aMyFunc[ UR_INIT ]          := ( @SL3_INIT() )
   aMyFunc[ UR_NEW ]           := ( @SL3_NEW() )
   aMyFunc[ UR_OPEN ]          := ( @SL3_OPEN() )
   aMyFunc[ UR_CLOSE ]         := ( @SL3_CLOSE() )
   aMyFunc[ UR_CREATE ]        := ( @SL3_CREATE() )
   
   aMyFunc[ UR_GOTOP ]         := ( @SL3_GOTOP() )
   aMyFunc[ UR_GOBOTTOM ]      := ( @SL3_GOBOTTOM() )
   aMyFunc[ UR_GOTO ]          := ( @SL3_GOTO() )
   aMyFunc[ UR_GOTOID ]        := ( @SL3_GOTO() )
   aMyFunc[ UR_SKIP ]          := ( @SL3_SKIP() )
   
   aMyFunc[ UR_GETVALUE ]      := ( @SL3_GETVALUE() )
   aMyFunc[ UR_PUTVALUE ]      := ( @SL3_PUTVALUE() )
   aMyFunc[ UR_APPEND ]        := ( @SL3_APPEND() )
   aMyFunc[ UR_DELETE ]        := ( @SL3_DELETE() )
   
   aMyFunc[ UR_RECNO ]         := ( @SL3_RECNO() )
   aMyFunc[ UR_RECCOUNT ]      := ( @SL3_RECCOUNT() )
   aMyFunc[ UR_EOF ]           := ( @SL3_EOF() )
   aMyFunc[ UR_BOF ]           := ( @SL3_BOF() )
   aMyFunc[ UR_DELETED ]       := ( @SL3_DELETED() )

   /* O Harbour usa esta função interna para construir os ponteiros na tabela física */
   USRRDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID, aMyFunc )

RETURN pFuncTable

// --- MÉTODOS DE GERENCIAMENTO DE TRABALHO (WORKAREA) ---

STATIC FUNCTION SL3_INIT( nRDD )
   USRRDD_RDDDATA( nRDD )
RETURN HB_RNET_OK

STATIC FUNCTION SL3_NEW( pWA )
   USRRDD_AREADATA( pWA, Array( WA_LEN ) )
RETURN HB_RNET_OK

STATIC FUNCTION SL3_OPEN( nWA, aOpenInfo )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL db, cName, nResult
   
   cName := aOpenInfo[ UR_OI_NAME ]
   db := sqlite3_open( cName )
   
   IF Empty( db ) 
      RETURN HB_RNET_ERROR 
   ENDIF
   
   aWAData[ WA_DB_HANDLE ]   := db
   aWAData[ WA_TABLE_NAME ]  := hb_FNameName( cName )
   aWAData[ WA_FIELDS_TYPE ] := {} 

   /* Inicializa posicionado no topo */
   SL3_GOTOP( nWA )

   /* Amarração de herança de abertura padrão do Harbour (Igual ao MYSQLRDD) */
   nResult := UR_SUPER_OPEN( nWA, aOpenInfo )

RETURN nResult

STATIC FUNCTION SL3_CLOSE( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) 
      sqlite3_finalize( aWAData[ WA_STMT_HANDLE ] ) 
   ENDIF
   sqlite3_close( aWAData[ WA_DB_HANDLE ] )
RETURN UR_SUPER_CLOSE( nWA )

// --- LEITURA E GRAVAÇÃO DE VALORES (CAMPOS) ---

STATIC FUNCTION SL3_GETVALUE( nWA, nCol, uVal )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   IF Empty( aWAData[ WA_STMT_HANDLE ] ) ; RETURN HB_RNET_ERROR ; ENDIF
   uVal  := sqlite3_column_value( aWAData[ WA_STMT_HANDLE ], nCol )
RETURN HB_RNET_OK

STATIC FUNCTION SL3_PUTVALUE( nWA, nCol, uVal )
   LOCAL aWAData := USRRDD_AREADATA( nWA ), cField, cSql, cVal
   IF Empty( aWAData[ WA_STMT_HANDLE ] ) ; RETURN HB_RNET_ERROR ; ENDIF
   
   cField := sqlite3_column_name( aWAData[ WA_STMT_HANDLE ], nCol )
   
   DO CASE
      CASE HB_ISDATE( uVal )    ; cVal := "'" + hb_dtoc( uVal, "YYYY-MM-DD" ) + "'"
      CASE HB_ISLOGICAL( uVal ) ; cVal := iif( uVal, "1", "0" )
      CASE HB_ISNUMERIC( uVal ) ; cVal := AllTrim( hb_ValToStr( uVal ) )
      OTHERWISE                  ; cVal := "'" + hb_ValToStr( uVal ) + "'"
   ENDCASE
   
   cSql := "UPDATE " + aWAData[ WA_TABLE_NAME ] + " SET " + cField + " = " + cVal + ;
           " WHERE rowid = " + AllTrim( hb_ValToStr( aWAData[ WA_RECNO ] ) )
           
   sqlite3_exec( aWAData[ WA_DB_HANDLE ], cSql )
RETURN HB_RNET_OK

// --- MOVIMENTAÇÃO DE PONTEIRO (CURSORES) ---

STATIC FUNCTION SL3_GOTOP( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) ; sqlite3_finalize( aWAData[ WA_STMT_HANDLE ] ) ; ENDIF
   
   aWAData[ WA_STMT_HANDLE ] := sqlite3_prepare( aWAData[ WA_DB_HANDLE ], "SELECT rowid, * FROM " + aWAData[ WA_TABLE_NAME ] + " ORDER BY rowid ASC" )
   
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) .AND. sqlite3_step( aWAData[ WA_STMT_HANDLE ] ) == SQLITE_ROW
      aWAData[ WA_RECNO ] := sqlite3_column_int64( aWAData[ WA_STMT_HANDLE ], 0 )
      aWAData[ WA_EOF ]   := .F.
   ELSE
      aWAData[ WA_EOF ]   := .T.
   ENDIF
RETURN HB_RNET_OK

STATIC FUNCTION SL3_GOBOTTOM( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) ; sqlite3_finalize( aWAData[ WA_STMT_HANDLE ] ) ; ENDIF
   
   aWAData[ WA_STMT_HANDLE ] := sqlite3_prepare( aWAData[ WA_DB_HANDLE ], "SELECT rowid, * FROM " + aWAData[ WA_TABLE_NAME ] + " ORDER BY rowid DESC LIMIT 1" )
   
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) .AND. sqlite3_step( aWAData[ WA_STMT_HANDLE ] ) == SQLITE_ROW
      aWAData[ WA_RECNO ] := sqlite3_column_int64( aWAData[ WA_STMT_HANDLE ], 0 )
      aWAData[ WA_EOF ]   := .F.
   ELSE
      aWAData[ WA_EOF ]   := .T.
   ENDIF
RETURN HB_RNET_OK

STATIC FUNCTION SL3_GOTO( nWA, nRec )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) ; sqlite3_finalize( aWAData[ WA_STMT_HANDLE ] ) ; ENDIF
   
   aWAData[ WA_STMT_HANDLE ] := sqlite3_prepare( aWAData[ WA_DB_HANDLE ], "SELECT rowid, * FROM " + aWAData[ WA_TABLE_NAME ] + " WHERE rowid = " + AllTrim( hb_ValToStr( nRec ) ) )
   
   IF !Empty( aWAData[ WA_STMT_HANDLE ] ) .AND. sqlite3_step( aWAData[ WA_STMT_HANDLE ] ) == SQLITE_ROW
      aWAData[ WA_RECNO ] := nRec
      aWAData[ WA_EOF ]   := .F.
   ELSE
      aWAData[ WA_EOF ]   := .T.
   ENDIF
RETURN HB_RNET_OK

STATIC FUNCTION SL3_SKIP( nWA, nSkip )
   LOCAL aWAData := USRRDD_AREADATA( nWA ), i
   IF nSkip == NIL ; nSkip := 1 ; ENDIF
   IF nSkip == 0 ; RETURN HB_RNET_OK ; ENDIF
   
   IF nSkip < 0 
      RETURN SL3_GOTO( nWA, aWAData[ WA_RECNO ] + nSkip ) 
   ENDIF
   
   FOR i := 1 TO nSkip
      IF sqlite3_step( aWAData[ WA_STMT_HANDLE ] ) == SQLITE_ROW
         aWAData[ WA_RECNO ] := sqlite3_column_int64( aWAData[ WA_STMT_HANDLE ], 0 )
         aWAData[ WA_EOF ]   := .F.
      ELSE
         aWAData[ WA_EOF ]   := .T.
         EXIT
      ENDIF
   NEXT
RETURN HB_RNET_OK

// --- ESCRITA E DELEÇÃO ---

STATIC FUNCTION SL3_APPEND( nWA, lUnL )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cSql := "INSERT INTO " + aWAData[ WA_TABLE_NAME ] + " DEFAULT VALUES"
   
   sqlite3_exec( aWAData[ WA_DB_HANDLE ], cSql )
   aWAData[ WA_RECNO ] := sqlite3_last_insert_rowid( aWAData[ WA_DB_HANDLE ] )
   
   RETURN SL3_GOTO( nWA, aWAData[ WA_RECNO ] )

STATIC FUNCTION SL3_DELETE( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cSql := "DELETE FROM " + aWAData[ WA_TABLE_NAME ] + " WHERE rowid = " + AllTrim( hb_ValToStr( aWAData[ WA_RECNO ] ) )
   
   sqlite3_exec( aWAData[ WA_DB_HANDLE ], cSql )
RETURN HB_RNET_OK

// --- INFORMAÇÕES DE RETORNO DE SINALIZAÇÃO ---

STATIC FUNCTION SL3_RECNO( nWA, n )    ; n := USRRDD_AREADATA( nWA )[ WA_RECNO ] ; RETURN HB_RNET_OK
STATIC FUNCTION SL3_EOF( nWA, l )      ; l := USRRDD_AREADATA( nWA )[ WA_EOF ] ; RETURN HB_RNET_OK
STATIC FUNCTION SL3_BOF( nWA, l )      ; l := .F. ; RETURN HB_RNET_OK
STATIC FUNCTION SL3_RECCOUNT( nWA, n ) ; n := 0 ; RETURN HB_RNET_OK
STATIC FUNCTION SL3_DELETED( nWA, l )  ; l := .F. ; RETURN HB_RNET_OK

// --- CRIAÇÃO DE TABELAS ---

STATIC FUNCTION SL3_CREATE( nWA, aStr )
   LOCAL cSql, i, cType, cName := hb_FNameName( USRRDD_AREADATA( nWA )[ WA_TABLE_NAME ] )
   
   cSql := "CREATE TABLE IF NOT EXISTS " + cName + " ("
   FOR i := 1 TO Len( aStr )
      cType := aStr[i, 2]
      cSql += aStr[i, 1] + " " + iif(cType=="N","NUMERIC",iif(cType=="D","DATE",iif(cType=="L","BOOLEAN","TEXT")))
      IF i < Len( aStr ) ; cSql += ", " ; ENDIF
    NEXT
   cSql += ")"
   
RETURN sqlite3_exec( USRRDD_AREADATA( nWA )[ WA_DB_HANDLE ], cSql )


#pragma BEGINDUMP

#include "hbapi.h"
#include "hbapiitm.h"
#include "sqlite3.h"

HB_FUNC( SQLITE3_OPEN )
{
   const char * szDbName = hb_parc( 1 );
   sqlite3 * db = NULL;
   
   if( sqlite3_open( szDbName, &db ) == SQLITE_OK && db != NULL )
   {
      hb_retptr( ( void * ) db );
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC( SQLITE3_CLOSE )
{
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   if( db )
   {
      hb_retni( sqlite3_close( db ) );
   }
   else
   {
      hb_retni( -1 );
   }
}

HB_FUNC( SQLITE3_EXEC )
{
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   const char * szSql = hb_parc( 2 );
   if( db && szSql )
   {
      hb_retni( sqlite3_exec( db, szSql, NULL, NULL, NULL ) );
   }
   else
   {
      hb_retni( -1 );
   }
}

HB_FUNC( SQLITE3_PREPARE )
{
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   const char * szSql = hb_parc( 2 );
   sqlite3_stmt * stmt = NULL;
   
   if( db && szSql )
   {
      if( sqlite3_prepare_v2( db, szSql, -1, &stmt, NULL ) == SQLITE_OK && stmt != NULL )
      {
         hb_retptr( ( void * ) stmt );
         return;
      }
   }
   hb_ret();
}

HB_FUNC( SQLITE3_STEP )
{
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   if( stmt )
   {
      hb_retni( sqlite3_step( stmt ) );
   }
   else
   {
      hb_retni( -1 );
   }
}

HB_FUNC( SQLITE3_FINALIZE )
{
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   if( stmt )
   {
      hb_retni( sqlite3_finalize( stmt ) );
   }
   else
   {
      hb_retni( -1 );
   }
}

HB_FUNC( SQLITE3_COLUMN_VALUE )
{
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   int iCol = hb_parni( 2 );
   if( stmt )
   {
      int iType = sqlite3_column_type( stmt, iCol );
      if( iType == SQLITE_INTEGER )
      {
         hb_retnd( ( double ) sqlite3_column_int64( stmt, iCol ) );
      }
      else if( iType == SQLITE_FLOAT )
      {
         hb_retnd( sqlite3_column_double( stmt, iCol ) );
      }
      else if( iType == SQLITE_TEXT )
      {
         hb_retc( ( const char * ) sqlite3_column_text( stmt, iCol ) );
      }
      else
      {
         hb_retc( ( const char * ) sqlite3_column_text( stmt, iCol ) );
      }
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC( SQLITE3_COLUMN_NAME )
{
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   int iCol = hb_parni( 2 );
   if( stmt )
   {
      hb_retc( sqlite3_column_name( stmt, iCol ) );
   }
   else
   {
      hb_retc( "" );
   }
}

HB_FUNC( SQLITE3_COLUMN_INT64 )
{
   sqlite3_stmt * stmt = ( sqlite3_stmt * ) hb_parptr( 1 );
   int iCol = hb_parni( 2 );
   if( stmt )
   {
      hb_retnd( ( double ) sqlite3_column_int64( stmt, iCol ) );
   }
   else
   {
      hb_retni( 0 );
   }
}

HB_FUNC( SQLITE3_LAST_INSERT_ROWID )
{
   sqlite3 * db = ( sqlite3 * ) hb_parptr( 1 );
   if( db )
   {
      hb_retnd( ( double ) sqlite3_last_insert_rowid( db ) );
   }
   else
   {
      hb_retni( 0 );
   }
}

#pragma ENDDUMP