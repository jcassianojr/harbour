// +--------------------------------------------------------------------
// +    Programa  : sl3rdd.prg
// +    Linguagem : Harbour
// +    Objetivo  : RDD SQLite3 construído sob o esqueleto original
// +--------------------------------------------------------------------

#include "rddsys.ch"
#include "usrrdd.ch"
#include "fileio.ch"
#include "error.ch"
#include "dbstruct.ch"
#include "common.ch"
#include "hbsqlit3.ch" // Biblioteca Nativa do SQLite3

/* Mapeamento idêntico ao esqueleto */
#define AREA_QUERY    1  // Guardará o ponteiro/objeto da tabela/STMT
#define AREA_ROW      2  // Cache local do registro ou RowID atual
#define AREA_APPEND   3  // Flag indicador de inclusão ativa

#define AREA_LEN      3

ANNOUNCE SL3RDD

STATIC s_aConnections := {}
STATIC oSERVER           // Handle do Banco Ativo (sqlite3_open)
STATIC aSTRUCAMPOS

// +--------------------------------------------------------------------
// +    Function DBSL3CONNECTION()
// +--------------------------------------------------------------------
FUNCTION DBSL3CONNECTION( cDatabaseFile )
   LOCAL db

   // No SQLite, a string de conexão é simplesmente o caminho do arquivo .db
   db := sqlite3_open( cDatabaseFile )

   IF Empty( db )
      Alert( "Erro ao abrir o banco SQLite: " + cDatabaseFile )
      RETURN 0
   ELSE
      oServer := db
      AAdd( s_aConnections, db )
   ENDIF

   RETURN Len( s_aConnections )

// +--------------------------------------------------------------------
// +    Function DBSL3STRU()
// +--------------------------------------------------------------------
FUNCTION DBSL3STRU()
   RETURN aSTRUCAMPOS

// +--------------------------------------------------------------------
// +    Function DBSL3CLEARCONNECTION()
// +--------------------------------------------------------------------
FUNCTION DBSL3CLEARCONNECTION( nConn )
   IF nConn > 0 .AND. nConn <= Len( s_aConnections )
      sqlite3_close( s_aConnections[ nConn ] )
      s_aConnections[ nConn ] := nil
      oServer := nil
   ENDIF
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_INIT()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_INIT( nRDD )
   USRRDD_RDDDATA( nRDD )
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_NEW()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_NEW( pWA )
   USRRDD_AREADATA( pWA, Array( AREA_LEN ) )
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_OPEN()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_OPEN( nWA, aOpenInfo )
   LOCAL oError, lError := .F., cError := "", nResult
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL nFIELDSCOUNT, iFIELDNUM, eTIPODECODE, aField, aTableInfo
   LOCAL cTableName := aOpenInfo[ UR_OI_NAME ]

   IF Empty( oServer )
      lError := .T.
      cError := "Conexao SQLite invalida ou nao iniciada."
   ENDIF

   IF lError
      oError             := ErrorNew()
      oError:GenCode     := EG_OPEN
      oError:SubCode     := 1000
      oError:Description := hb_langErrMsg( EG_OPEN ) + ", " + cError
      oError:FileName    := cTableName
      oError:CanDefault  := .T.
      UR_SUPER_ERROR( nWA, oError )
      RETURN FAILURE
   ENDIF

   // No SQLite passamos a tabela física. Montamos a estrutura interna de paginação/navegação
   // Para manter o esqueleto, criamos uma área simulada de query
   aWAData[ AREA_QUERY ]  := Hash()
   aWAData[ AREA_QUERY ]["table"]  := cTableName
   aWAData[ AREA_QUERY ]["rowid"]  := 0
   aWAData[ AREA_QUERY ]["bof"]    := .T.
   aWAData[ AREA_QUERY ]["eof"]    := .T.
   
   // Obter metadados da tabela idêntico à decodificação do esqueleto
   aTableInfo := sqlite3_get_table( oServer, "PRAGMA table_info(" + cTableName + ")" )
   
   IF Len( aTableInfo ) <= 1
      oError             := ErrorNew()
      oError:GenCode     := EG_OPEN
      oError:Description := "Tabela nao encontrada ou sem colunas: " + cTableName
      UR_SUPER_ERROR( nWA, oError )
      RETURN FAILURE
   ENDIF

   nFIELDSCOUNT := Len( aTableInfo ) - 1
   UR_SUPER_SETFIELDEXTENT( nWA, nFIELDSCOUNT )
   aSTRUCAMPOS  := {}

   FOR iFIELDNUM := 1 TO nFIELDSCOUNT
      // Linha do pragma: [1]=cid, [2]=name, [3]=type, [4]=notnull, [5]=dflt_value, [6]=pk
      // Comparação exata de tipos igual ao hb_Decode do esqueleto
      eTIPODECODE := hb_Decode( Upper( aTableInfo[ iFIELDNUM + 1, 3 ] ), ;
                                "TEXT", HB_FT_STRING, ;
                                "INTEGER", HB_FT_INTEGER, ;
                                "NUMERIC", HB_FT_DOUBLE, ;
                                "BOOLEAN", HB_FT_LOGICAL, ;
                                "DATE", HB_FT_DATE, HB_FT_STRING )

      aField                  := Array( UR_FI_SIZE )
      aField[ UR_FI_NAME ]    := Upper( aTableInfo[ iFIELDNUM + 1, 2 ] )
      aField[ UR_FI_TYPE ]    := eTIPODECODE
      aField[ UR_FI_TYPEEXT ] := 0
      aField[ UR_FI_LEN ]     := 10 // Padrão genérico se não especificado
      aField[ UR_FI_DEC ]     := 0
      UR_SUPER_ADDFIELD( nWA, aField )
      
      AAdd( aSTRUCAMPOS, { aField[ UR_FI_NAME ], aTableInfo[ iFIELDNUM + 1, 3 ], aField[ UR_FI_LEN ], aField[ UR_FI_DEC ], eTIPODECODE } )
   NEXT

   nResult := UR_SUPER_OPEN( nWA, aOpenInfo )
   
   // Posiciona no topo ao abrir
   SL3_GOTOP( nWA )

   RETURN nResult

// +--------------------------------------------------------------------
// +    Static Function SL3_CLOSE()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_CLOSE( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   aWAData[ AREA_QUERY ] := nil
   RETURN UR_SUPER_CLOSE( nWA )

// +--------------------------------------------------------------------
// +    Static Function SL3_GETVALUE()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_GETVALUE( nWA, nField, xValue )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL nRowId  := aWAData[ AREA_QUERY ]["rowid"]
   LOCAL cField  := aSTRUCAMPOS[ nField, 1 ]
   LOCAL aRes
   
   IF !Empty( aWAData[ AREA_ROW ] ) .AND. HB_HHasKey( aWAData[ AREA_ROW ], cField )
      xValue := aWAData[ AREA_ROW ][ cField ]
   ELSE
      aRes := sqlite3_get_table( oServer, "SELECT " + cField + " FROM " + cTable + " WHERE rowid = " + AllTrim(Str(nRowId)) )
      xValue := iif( Len( aRes ) > 1, aRes[2,1], nil )
   ENDIF
   
   // Conversão tipada baseada no metadado extraído do OPEN
   IF xValue != nil
      DO CASE
         CASE aSTRUCAMPOS[ nField, 5 ] == HB_FT_DATE    ; xValue := STOD( StrTran( xValue, "-", "" ) )
         CASE aSTRUCAMPOS[ nField, 5 ] == HB_FT_LOGICAL ; xValue := ( xValue == "1" .OR. xValue == 1 )
         CASE aSTRUCAMPOS[ nField, 5 ] == HB_FT_INTEGER ; xValue := Val( xValue )
         CASE aSTRUCAMPOS[ nField, 5 ] == HB_FT_DOUBLE  ; xValue := Val( xValue )
      ENDCASE
   ENDIF

   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_PUTVALUE()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_PUTVALUE( nWA, nField, xValue )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cField  := aSTRUCAMPOS[ nField, 1 ]

   IF Empty( aWAData[ AREA_ROW ] )
      aWAData[ AREA_ROW ] := Hash()
   ENDIF

   // Guarda no buffer local idêntico ao comportamento do esqueleto original
   aWAData[ AREA_ROW ][ cField ] := xValue

   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_SKIP()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_SKIP( nWA, nRecords )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL nRowId  := aWAData[ AREA_QUERY ]["rowid"]
   LOCAL aRes, cSql

   IF !Empty( aWAData[ AREA_ROW ] )
      SL3_FLUSH( nWA )
   ENDIF
   
   IF nRecords == 0 ; RETURN SUCCESS ; ENDIF

   IF nRecords > 0
      cSql := "SELECT rowid FROM " + cTable + " WHERE rowid > " + AllTrim(Str(nRowId)) + " ORDER BY rowid ASC LIMIT " + AllTrim(Str(nRecords))
   ELSE
      cSql := "SELECT rowid FROM " + cTable + " WHERE rowid < " + AllTrim(Str(nRowId)) + " ORDER BY rowid DESC LIMIT " + AllTrim(Str(Abs(nRecords)))
   ENDIF
   
   aRes := sqlite3_get_table( oServer, cSql )
   
   IF Len( aRes ) > 1
      aWAData[ AREA_QUERY ]["rowid"] := Val( aRes[ Len(aRes), 1 ] )
      aWAData[ AREA_QUERY ]["eof"]   := .F.
      aWAData[ AREA_QUERY ]["bof"]   := .F.
   ELSE
      IF nRecords > 0
         aWAData[ AREA_QUERY ]["eof"] := .T.
      ELSE
         aWAData[ AREA_QUERY ]["bof"] := .T.
      ENDIF
   ENDIF

   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_GOTOP()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_GOTOP( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL aRes    := sqlite3_get_table( oServer, "SELECT rowid FROM " + cTable + " ORDER BY rowid ASC LIMIT 1" )
   
   IF Len( aRes ) > 1
      aWAData[ AREA_QUERY ]["rowid"] := Val( aRes[2,1] )
      aWAData[ AREA_QUERY ]["bof"]   := .F.
      aWAData[ AREA_QUERY ]["eof"]   := .F.
   ELSE
      aWAData[ AREA_QUERY ]["eof"]   := .T.
   ENDIF
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_GOBOTTOM()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_GOBOTTOM( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL aRes    := sqlite3_get_table( oServer, "SELECT rowid FROM " + cTable + " ORDER BY rowid DESC LIMIT 1" )
   
   IF Len( aRes ) > 1
      aWAData[ AREA_QUERY ]["rowid"] := Val( aRes[2,1] )
      aWAData[ AREA_QUERY ]["bof"]   := .F.
      aWAData[ AREA_QUERY ]["eof"]   := .F.
   ELSE
      aWAData[ AREA_QUERY ]["eof"]   := .T.
   ENDIF
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_GOTOID()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_GOTOID( nWA, nRecord )
   RETURN SL3_GOTO( nWA, nRecord )

// +--------------------------------------------------------------------
// +    Static Function SL3_GOTO()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_GOTO( nWA, nRecord )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL aRes

   IF ( ValType( nRecord ) != "N" ) ; nRecord := 0 ; ENDIF

   IF !Empty( aWAData[ AREA_ROW ] )
      SL3_FLUSH( nWA )
   ENDIF

   aRes := sqlite3_get_table( oServer, "SELECT rowid FROM " + cTable + " WHERE rowid = " + AllTrim(Str(nRecord)) )
   
   IF Len( aRes ) > 1
      aWAData[ AREA_QUERY ]["rowid"] := nRecord
      aWAData[ AREA_QUERY ]["eof"]   := .F.
      aWAData[ AREA_QUERY ]["bof"]   := .F.
   ELSE
      aWAData[ AREA_QUERY ]["eof"]   := .T.
   ENDIF

   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_RECCOUNT()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_RECCOUNT( nWA, nRecords )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL aRes    := sqlite3_get_table( oServer, "SELECT count(*) FROM " + cTable )
   nRecords := iif( Len( aRes ) > 1, Val( aRes[2,1] ), 0 )
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_BOF()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_BOF( nWA, lBof )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   lBof := aWAData[ AREA_QUERY ]["bof"]
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_EOF()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_EOF( nWA, lEof )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   lEof := aWAData[ AREA_QUERY ]["eof"]
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_RECID()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_RECID( nWA, nRecNo )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   nRecno := aWAData[ AREA_QUERY ]["rowid"]
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_DELETED()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_DELETED( nWA, lDeleted )
   lDeleted := .F. // SQLite lida com remoções físicas direto no DELETE
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_FLUSH()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_FLUSH( nWA )
   LOCAL oError
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL nRowId  := aWAData[ AREA_QUERY ]["rowid"]
   LOCAL cSql, cFields := "", cVals := "", cUpdates := ""
   LOCAL key, val, i

   IF aWAData[ AREA_ROW ] != nil
      IF !Empty( aWAData[ AREA_APPEND ] )
         // Monta string de INSERT com o hash armazenado em AREA_ROW
         FOR i := 1 TO Len( aWAData[ AREA_ROW ] )
            key := HB_HKeyAt( aWAData[ AREA_ROW ], i )
            val := HB_HValueAt( aWAData[ AREA_ROW ], i )
            cFields += key + ","
            cVals   += iif(HB_ISNUMERIC(val), AllTrim(Str(val)), "'" + hb_ValToStr(val) + "'") + ","
         NEXT
         cFields := Left( cFields, Len(cFields) - 1 )
         cVals   := Left( cVals, Len(cVals) - 1 )
         cSql := "INSERT INTO " + cTable + " (" + cFields + ") VALUES (" + cVals + ")"
         sqlite3_exec( oServer, cSql )
         nRowId := sqlite3_last_insert_rowid( oServer )
      ELSE
         // Monta string de UPDATE baseado no registro ativo
         FOR i := 1 TO Len( aWAData[ AREA_ROW ] )
            key := HB_HKeyAt( aWAData[ AREA_ROW ], i )
            val := HB_HValueAt( aWAData[ AREA_ROW ], i )
            cUpdates += key + " = " + iif(HB_ISNUMERIC(val), AllTrim(Str(val)), "'" + hb_ValToStr(val) + "'") + ","
         NEXT
         cUpdates := Left( cUpdates, Len(cUpdates) - 1 )
         cSql := "UPDATE " + cTable + " SET " + cUpdates + " WHERE rowid = " + AllTrim(Str(nRowId))
         sqlite3_exec( oServer, cSql )
      ENDIF

      IF !Empty( aWAData[ AREA_APPEND ] )
         aWAData[ AREA_APPEND ] := .F.
      ENDIF
      
      aWAData[ AREA_ROW ] := nil
      SL3_GOTO( nWA, nRowId )
   ENDIF
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_APPEND()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_APPEND( nWA, nRecords )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   aWAData[ AREA_ROW ]    := Hash()
   aWAData[ AREA_APPEND ] := .T.
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Static Function SL3_DELETE()
// +--------------------------------------------------------------------
STATIC FUNCTION SL3_DELETE( nWA )
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL cTable  := aWAData[ AREA_QUERY ]["table"]
   LOCAL nRowId  := aWAData[ AREA_QUERY ]["rowid"]
   
   sqlite3_exec( oServer, "DELETE FROM " + cTable + " WHERE rowid = " + AllTrim(Str(nRowId)) )
   aWAData[ AREA_ROW ] := nil
   
   // Move para o próximo válido após deletar
   SL3_SKIP( nWA, 1 )
   RETURN SUCCESS

// +--------------------------------------------------------------------
// +    Function SL3RDD_GETFUNCTABLE()
// +--------------------------------------------------------------------
FUNCTION SL3RDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID )
   LOCAL cSuperRDD := NIL
   LOCAL aMyFunc[ UR_METHODCOUNT ]

   aMyFunc[ UR_INIT ]     := ( @SL3_INIT() )
   aMyFunc[ UR_NEW ]      := ( @SL3_NEW() )
   aMyFunc[ UR_OPEN ]     := ( @SL3_OPEN() )
   aMyFunc[ UR_GETVALUE ] := ( @SL3_GETVALUE() )
   aMyFunc[ UR_PUTVALUE ] := ( @SL3_PUTVALUE() )
   aMyFunc[ UR_SKIP ]     := ( @SL3_SKIP() )
   aMyFunc[ UR_GOTO ]     := ( @SL3_GOTO() )
   aMyFunc[ UR_GOTOID ]   := ( @SL3_GOTOID() )
   aMyFunc[ UR_GOTOP ]    := ( @SL3_GOTOP() )
   aMyFunc[ UR_GOBOTTOM ] := ( @SL3_GOBOTTOM() )
   aMyFunc[ UR_RECNO ]    := ( @SL3_RECID() )
   aMyFunc[ UR_RECCOUNT ] := ( @SL3_RECCOUNT() )
   aMyFunc[ UR_RECID ]    := ( @SL3_RECID() )
   aMyFunc[ UR_BOF ]      := ( @SL3_BOF() )
   aMyFunc[ UR_EOF ]      := ( @SL3_EOF() )
   aMyFunc[ UR_DELETED ]  := ( @SL3_DELETED() )
   aMyFunc[ UR_FLUSH ]    := ( @SL3_FLUSH() )
   aMyFunc[ UR_APPEND ]   := ( @SL3_APPEND() )
   aMyFunc[ UR_DELETE ]   := ( @SL3_DELETE() )
   aMyFunc[ UR_CLOSE ]    := ( @SL3_CLOSE() )

   RETURN USRRDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID, aMyFunc )