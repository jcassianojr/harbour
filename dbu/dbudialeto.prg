// +--------------------------------------------------------------------
// +
// +    Programa  : dbudialeto.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +    Documentado em 28-Dez-2024 as 10:06 am
// +
// +--------------------------------------------------------------------
// +
#include "dbstruct.ch"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_begin()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Dialeto_begin(cTipo)

   LOCAL cCOMANDO
   
   hb_Default( @cTipo, cTIPOSQL ) // Usa a global como fallback

   cCOMANDO := "BEGIN TRANSACTION"
   DO CASE
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "BEGIN TRANSACTION"
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "START TRANSACTION;"
   CASE cTIPOSQL = "FIREBIRD"
      cCOMANDO := "SET TRANSACTION"
   CASE cTIPOSQL = "SQLITE" .OR. At( ".SQLITE", Upper( cdatabaseX ) ) > 0
      cCOMANDO := "BEGIN TRANSACTION;"
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := "BEGIN;"
    CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO ="SET TRANSACTION READ WRITE;"        
      
      
   ENDCASE

   RETURN cCOMANDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_commit()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Dialeto_commit()

   LOCAL cCOMANDO

   cCOMANDO := "COMMIT TRANSACTION"
   DO CASE
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "IF @@TRANCOUNT > 0 COMMIT"
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "COMMIT;"
   CASE cTIPOSQL = "FIREBIRD"
      cCOMANDO := "COMMIT"
   CASE cTIPOSQL = "SQLITE" .OR. At( ".SQLITE", Upper( cdatabaseX ) ) > 0
      cCOMANDO := "end transaction"
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := "COMMIT;"
   ENDCASE

   RETURN cCOMANDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_rollback()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Dialeto_rollback()

   LOCAL cCOMANDO

   cCOMANDO := "ROLLBACK TRANSACTION"
   DO CASE
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "IF @@TRANCOUNT > 0 ROLLBACK"
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "ROLLBACK;"
   CASE cTIPOSQL = "FIREBIRD"
      cCOMANDO := "ROLLBACK"
   CASE cTIPOSQL = "SQLITE" .OR. At( ".SQLITE", Upper( cdatabaseX ) ) > 0
      cCOMANDO := "ROLLBACK;"
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := "ROLLBACK;"
   ENDCASE

   RETURN cCOMANDO
   
// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_DataBanco()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +   
 Function Dialeto_DataBanco()
LOCAL cCOMANDO
cCOMANDO:=""
  DO CASE
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
           cCOMANDO ="GETDATE()"
      CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
           cCOMANDO ="SYSDATE()"
    //  CASE cTIPOSQL="FIREBIRD"
    //       cCOMANDO =""
      CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO ="CURRENT_DATE"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
           cCOMANDO ="CURRENT_DATE"
        CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO ="SYSDATE"               
   ENDCASE
return cCOMANDO  

// +--------------------------------------------------------------------
// +    Function Dialeto_Operador( cOp )
// +    Exemplo de uso: Dialeto_Operador("!=") ou Dialeto_Operador("<>")
//// Antes:
//cSql := "SELECT * FROM tabela WHERE campo " + cOperador + " 10"

// Depois (mais seguro):
//cSql := "SELECT * FROM tabela WHERE campo " + Dialeto_Operador(cOperador) + " 10"
// +--------------------------------------------------------------------
FUNCTION Dialeto_Operador( cOp )

   LOCAL cNovoOp := cOp

   DO CASE
   // Padronização para MSSQL/SQLServer
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      IF cOp = "!=" ; cNovoOp := "<>" ; ENDIF
   
   // Padronização para PostgreSQL
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      IF cOp = "<>" ; cNovoOp := "!=" ; ENDIF

   // Padronização para SQLite
   CASE cTIPOSQL = "SQLITE" .OR. At(".SQLITE", Upper(cdatabaseX)) > 0
      // SQLite aceita ambos, mantemos o original ou forçamos um padrão
      
   // Padronização para MySQL/MariaDB
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      // MySQL aceita ambos, mas prefere != ou <>
      
   ENDCASE

   RETURN cNovoOp

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_DataHoraBanco()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +   
 Function Dialeto_DataHoraBanco()
LOCAL cCOMANDO
cCOMANDO:=""
  DO CASE
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
           cCOMANDO ="SYSDATETIME()"
      CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
           cCOMANDO ="CURRENT_TIMESTAMP ()"
    //  CASE cTIPOSQL="FIREBIRD"
    //       cCOMANDO =""
      CASE cTIPOSQL="SQLITE" //.or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO ="CURRENT_TIMESTAMP"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
           cCOMANDO ="NOW()"
        CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO ="SYSTIMESTAMP"               
   ENDCASE
return cCOMANDO  

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_DataVazia()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +   
   
 Function Dialeto_DataVazia(cSQLDIALETO)
LOCAL cCOMANDO
IF VALTYPE(cSQLDIALETO)<>"C"
   cSQLDIALETO:=cTIPOSQL //utiliza global
ENDIF
cCOMANDO:=""
  DO CASE
      CASE cSQLDIALETO="MSSQL" .OR. cSQLDIALETO="SQLSERVER"
           cCOMANDO ="NULL"
      CASE cSQLDIALETO="MYSQL" .OR. cSQLDIALETO="MYSQL64"  .OR. cSQLDIALETO="MARIADB"
           cCOMANDO ="NULL"
    //  CASE cTIPOSQL="FIREBIRD"
    //       cCOMANDO =""
      CASE cSQLDIALETO="SQLITE" //.or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO =""
      CASE cSQLDIALETO="PGSQL" .OR. cSQLDIALETO="PGSQL64" .OR. cSQLDIALETO="POSTGRESQL"
           cCOMANDO ="NULL"
      CASE cSQLDIALETO="ORACLE" .OR. cSQLDIALETO="OCI"
           cCOMANDO ="NULL"               
   ENDCASE
return cCOMANDO  


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_GetIdentity ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +   

Function Dialeto_GetIdentity() // AS LAST_ID; facilita implantacao pois todos voltam lat_id
LOCAL cCOMANDO
cCOMANDO:=""
  DO CASE
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
           cCOMANDO ="select @@IDENTITY  AS LAST_ID;"
      CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
           cCOMANDO ="select LAST_INSERT_ID() AS LAST_ID;"
   //   CASE cTIPOSQL="FIREBIRD"
   //        cCOMANDO =""
      CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO ="SELECT last_insert_rowid()  AS LAST_ID;"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
           cCOMANDO ="SELECT lastval() AS LAST_ID;"
       CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO ="select LAST_INSERT_ID()  AS LAST_ID;"     
   ENDCASE
return cCOMANDO

// +--------------------------------------------------------------------
// +
// +    Function Dialeto_ShowDatabases()
// +
// +    Retorna o comando SQL para listar as bases de dados/schemas
// +    Padroniza o retorno com o alias "DB_NAME"
// +
// +--------------------------------------------------------------------
FUNCTION Dialeto_ShowDatabases(cTipo)
   LOCAL cCOMANDO := ""
   
   hb_Default( @cTipo, cTIPOSQL ) // Usa a global como fallback

   DO CASE
   CASE cTipo == "MYSQL" .OR. cTipo == "MYSQL64" .OR. cTipo == "MARIADB"
      // O MySQL não aceita bem alias direto no SHOW DATABASES se usado de forma simples,
      // para garantir o alias padronizado em consultas relacionais estritas, podemos usar a information_schema:
      cCOMANDO := "SELECT SCHEMA_NAME AS DB_NAME FROM INFORMATION_SCHEMA.SCHEMATA;"  //"SHOW DATABASES;"

   CASE cTipo == "PGSQL" .OR. cTipo == "PGSQL64" .OR. cTipo == "POSTGRESQL"
      cCOMANDO := "SELECT datname AS DB_NAME FROM pg_database WHERE datistemplate = false;"

   CASE cTipo == "MSSQL" .OR. cTipo == "SQLSERVER"
      cCOMANDO := "SELECT name AS DB_NAME FROM master.dbo.sysdatabases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');"

   CASE cTipo == "ORACLE" .OR. cTipo == "OCI" 
      // No Oracle, o conceito de "Database" equivale mais ao "User/Schema" aberto
      cCOMANDO := "SELECT username AS DB_NAME FROM dba_users WHERE account_status = 'OPEN' ORDER BY username;"

   CASE cTipo == "SQLITE" .OR. At( ".SQLITE", Upper( cdatabaseX ) ) > 0    
      cCOMANDO := "SELECT name AS DB_NAME FROM pragma_database_list;"

   CASE cTipo == "FIREBIRD" .OR. cTipo == "FDB" .OR. cTipo == "GDB"
      // No Firebird, por arquitetura, ele não lista outros bancos nativamente via SQL (cada arquivo FDB é isolado).
      // O padrão para retornar o alias do banco conectado na sessão atual é:
      cCOMANDO := "SELECT RDB$GET_CONTEXT('SYSTEM', 'DB_NAME') AS DB_NAME FROM RDB$DATABASE;"
   ENDCASE

RETURN cCOMANDO


FUNCTION Dialeto_Version(cTipo)
   LOCAL cCOMANDO := ""
   
   hb_Default( @cTipo, cTIPOSQL ) // Usa a global como fallback

   DO CASE
   CASE cTipo == "MSSQL" .OR. cTipo == "SQLSERVER"
      cCOMANDO := "SELECT @@VERSION AS VER;"

   CASE cTipo == "MYSQL" .OR. cTipo == "MYSQL64" .OR. cTipo == "MARIADB"
      cCOMANDO := "SELECT VERSION() AS VER;"

   CASE cTipo == "FIREBIRD" .OR. cTipo == "FDB" .OR. cTipo == "GDB"
      // Em SQL padrão, apelidos de colunas usam aspas duplas ou nenhuma aspa.
      cCOMANDO := 'SELECT RDB$GET_CONTEXT("SYSTEM", "ENGINE_VERSION") AS VER FROM RDB$DATABASE;'

   CASE cTipo == "SQLITE" .OR. At( ".SQLITE", Upper( cdatabaseX ) ) > 0
      cCOMANDO := "SELECT sqlite_version() AS VER;"

   CASE cTipo == "PGSQL" .OR. cTipo == "PGSQL64" .OR. cTipo == "POSTGRESQL"
      cCOMANDO := "SELECT VERSION() AS VER;"

   CASE cTipo == "ORACLE" .OR. cTipo == "OCI"
      cCOMANDO := "SELECT BANNER AS VER FROM V$VERSION WHERE ROWNUM = 1;"
   ENDCASE

RETURN cCOMANDO

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_GetRowCount()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +   

Function Dialeto_GetRowCount()
LOCAL cCOMANDO
cCOMANDO:=""
  DO CASE
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
           cCOMANDO ="select @@ROWCOUNT"
      CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
           cCOMANDO ="select ROW_COUNT()"
   //   CASE cTIPOSQL="FIREBIRD"
   //        cCOMANDO =""
      CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO ="SELECT changes()"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
           cCOMANDO =""
       CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO ="select SQL%ROWCOUNT"     
   ENDCASE
return cCOMANDO


// +--------------------------------------------------------------------
// +    Function Dialeto_TopPrefix( nQtd )
// +--------------------------------------------------------------------
FUNCTION Dialeto_TopPrefix( nQtd )
   LOCAL cCOMANDO := ""
   LOCAL cQtd     := AllTrim( hb_ntos( nQtd ) )

   DO CASE
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := " TOP " + cQtd + " "
   
   CASE cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI"
      // Em versões antigas do Oracle usa-se ROWNUM no WHERE, 
      // mas no padrão 12c+ pode-se usar o sufixo.
      cCOMANDO := "" 
   ENDCASE

   RETURN cCOMANDO

// +--------------------------------------------------------------------
// +    Function Dialeto_TopSuffix( nQtd )
// +--------------------------------------------------------------------
FUNCTION Dialeto_TopSuffix( nQtd )
   LOCAL cCOMANDO := ""
   LOCAL cQtd     := AllTrim( hb_ntos( nQtd ) )

   DO CASE
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := " LIMIT " + cQtd
      
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := " LIMIT " + cQtd

   CASE cTIPOSQL = "SQLITE" .OR. At( ".SQLITE", Upper( cdatabaseX ) ) > 0
      cCOMANDO := " LIMIT " + cQtd
      
   CASE cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI"
      // Padrão ANSI/Oracle 12c
      cCOMANDO := " FETCH FIRST " + cQtd + " ROWS ONLY"
   ENDCASE

   RETURN cCOMANDO

/* maria mysql
SELECT CONNECTION_ID();
SHOW VARIABLES;
*/

/* sqlite
PRAGMA busy_timeout=30000;
*/


/*
SELECT NOW();
SELECT 'citext'::regtype::oid;
SET statement_timeout TO 30000;
SELECT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP - pg_postmaster_start_time())::INTEGER;
SHOW ssl;
SELECT table_name FROM information_schema.tables WHERE table_schema='information_schema';
SELECT "nspname" FROM "pg_catalog"."pg_namespace" ORDER BY "nspname";
SET search_path TO 'public', '$user';
SELECT *, pg_table_size(QUOTE_IDENT(t.TABLE_SCHEMA) || '.' || QUOTE_IDENT(t.TABLE_NAME))::bigint AS data_length, pg_relation_size(QUOTE_IDENT(t.TABLE_SCHEMA) || '.' || QUOTE_IDENT(t.TABLE_NAME))::bigint AS index_length, c.reltuples, obj_description(c.oid) AS comment FROM "information_schema"."tables" AS t LEFT JOIN "pg_namespace" n ON t.table_schema = n.nspname LEFT JOIN "pg_class" c ON n.oid = c.relnamespace AND c.relname=t.table_name WHERE t."table_schema"='public';
SELECT "p"."proname", "p"."proargtypes" FROM "pg_catalog"."pg_namespace" AS "n" JOIN "pg_catalog"."pg_proc" AS "p" ON "p"."pronamespace" = "n"."oid" WHERE "n"."nspname"='public';
*/

/*
// top
pgsql
"select "+ColumnsMacro+" from "+TableNameMacro+" limit "+TopCountMacro
oracle
"select "+ColumnsMacro+" from "+TableNameMacro  //top ou numrows (ver versao) +" top "+TopCountMacro    where numrow<=Nrows
mysql
"select "+ColumnsMacro+" from "+TableNameMacro+" limit "+TopCountMacro
sqlite
  "select "+ColumnsMacro+" from "+TableNameMacro+" limit "+TopCountMacro
 //
 index
 "drop index if exists  
// datetime

//oracle set exemplos
alter session set NLS_TERRITORY = GERMANY
alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS'
alter session set nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SSXFF'
alter session set nls_language = english
ALTER SESSION set NLS_NUMERIC_CHARACTERS = ".,"
alter session set nls_sort = BINARY
ALTER SESSION SET recyclebin = OFF
alter session set ddl_lock_timeout = 600
alter session set session_cached_cursors=1000


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +   

Function Dialeto_()
LOCAL cCOMANDO
cCOMANDO:=""
  DO CASE
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
           cCOMANDO =""
      CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
           cCOMANDO =""
      CASE cTIPOSQL="FIREBIRD"
           cCOMANDO =""
      CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO =""
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
           cCOMANDO =""
       CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO =""     
   ENDCASE
return cCOMANDO

*/




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dialeto_SQL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Dialeto_SQL( cSQLCNV )

   DO CASE
   CASE cTIPOSQL = "SQLITE"
      // '"LOWER(%1%)"        ,"LOWER(%1%)"
      // '"UPPER(%1%)"        ,"UPPER(%1%)"
      cSQLCNV := StrTran( cSQLCNV, "TODAY()", "CURRENT_DATE " )
      cSQLCNV := StrTran( cSQLCNV, "CHR(", "CHAR(" )
      cSQLCNV := StrTran( cSQLCNV, "ASC(", "ASCII(" )
      cSQLCNV := StrTran( cSQLCNV, "TRIM(", "RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "ALLTRIM(", "TRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "LEN(", "LENGTH(" )
      cSQLCNV := StrTran( cSQLCNV, "CURRENTDATETIME", " current_timestamp " )
      
      // Tradução de REPL() (Repetir caracteres)
        cSQLCNV := StrTran( cSQLCNV, "REPL(", "printf('%.*c', " ) // Gambiarra comum em SQLite

        // Tratamento de Substring (Harbour usa 1-based)
        cSQLCNV := StrTran( cSQLCNV, "SUBSTR(", "SUBSTR(" ) 

        // DTOS (Data para String YYYYMMDD)
        cSQLCNV := StrTran( cSQLCNV, "DTOS(", "strftime('%Y%m%d', " )
      
      // '  {"LEFT(%1%,%2%)"      ,"SUBSTR(%1%,1,%2%)"},;
      // '        {"DTOS(%1%)"        ,"strftime('%Y%m%d',%1%)"},;
      // '        {"DAY(%1%)"       ,"cast(strftime('%d',%1) as int)"},;
      // ''        {"MONTH(%1%)"       ,"cast(strftime('%m',%1) as int)"},;
      // '        {"YEAR(%1%)"        ,"cast(strftime('%Y',%1) as int)"},;
      // '        {"REPL(%1%,%2%)"      ,"FORMAT('%.*c',%2%,%1%)"},;
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      // '"LOWER(%1%)"        ,"LOWER(%1%)"
      // '"UPPER(%1%)"        ,"UPPER(%1%)"
      // '"LEFT(%1%,%2%)"     ,"LEFT(%1%,%2%)"
      // '"DAY(%1%)"         ,"DAY(%1%)"
      // '"MONTH(%1%)"       ,"MONTH(%1%)"}
      // '"YEAR(%1%)"        ,"YEAR(%1%)"
      cSQLCNV := StrTran( cSQLCNV, "TODAY()", "SYSDATE()" )
      cSQLCNV := StrTran( cSQLCNV, "CHR(", "CHAR(" )
      cSQLCNV := StrTran( cSQLCNV, "ASC(", "ASCII(" )
      cSQLCNV := StrTran( cSQLCNV, "TRIM(", "RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "ALLTRIM(", "TRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "REPL(", "REPEAT(" )
      // '        {"DTOS(%1%)"        ,"DATE_FORMAT(%1%,'%Y%m%d')"},;
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      // '"LOWER(%1%)"        ,"LOWER(%1%)"
      // '"UPPER(%1%)"        ,"UPPER(%1%)"
      // '"LEFT(%1%,%2%)"      ,"LEFT(%1%,%2%)"
      // '"CHR(%1%)"         ,"CHR(%1%)"
      cSQLCNV := StrTran( cSQLCNV, "TODAY()", "CURRENT_DATE " )
      cSQLCNV := StrTran( cSQLCNV, "ASC(", "ASCII(" )
      cSQLCNV := StrTran( cSQLCNV, "TRIM(", "RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "ALLTRIM(", "TRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "LEN(", "LENGTH(" )
      cSQLCNV := StrTran( cSQLCNV, "DAY(", "EXTRACT('DAY' FROM " )
      cSQLCNV := StrTran( cSQLCNV, "MONTH(", "EXTRACT('MONTH' FROM " )
      cSQLCNV := StrTran( cSQLCNV, "YEAR(", "EXTRACT('YEAR' FROM " )
      cSQLCNV := StrTran( cSQLCNV, "REPL(", "REPEAT(" )
      // Booleano: Converter .T. e .F. do Harbour
     cSQLCNV := StrTran( cSQLCNV, ".T.", "TRUE" )
     cSQLCNV := StrTran( cSQLCNV, ".F.", "FALSE" )
     
     // 2. Limpeza de datas vazias (Clipper adora '  /  /  ')
      // O Postgres quebra se receber uma string vazia em um campo DATE.
      cSQLCNV := StrTran( cSQLCNV, "'  /  /  '", "NULL" )
      cSQLCNV := StrTran( cSQLCNV, "'00/00/0000'", "NULL" )

      // 3. Funções do SQLite/Access para equivalentes Postgres
      cSQLCNV := StrTran( cSQLCNV, "IIF(", "CASE WHEN " ) // Se usar IIF do Access, precisará expandir para CASE WHEN
      cSQLCNV := StrTran( cSQLCNV, "NOW()", "CURRENT_TIMESTAMP" )
      cSQLCNV := StrTran( cSQLCNV, "IFNULL(", "COALESCE(" ) // O SQLite usa IFNULL, o Pos
     
     
     
      
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cSQLCNV := StrTran( cSQLCNV, "TODAY()", "GETDATE() " )
      cSQLCNV := StrTran( cSQLCNV, "ASC(", "ASCII(" )
      cSQLCNV := StrTran( cSQLCNV, "TRIM(", "RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "ALLTRIM(", "TRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "REPL(", "REPLICATE(" )
      cSQLCNV := StrTran( cSQLCNV, "CHR(", "CHAR(" )
      cSQLCNV := StrTran( cSQLCNV, "SUBSTR(", "SUBSTRING(" )
      // No MSSQL, SUBSTR deve ser SUBSTRING
      cSQLCNV := StrTran( cSQLCNV, "SUBSTR(", "SUBSTRING(" )

     // AT() do Harbour para CHARINDEX() do SQL
     cSQLCNV := StrTran( cSQLCNV, "AT(", "CHARINDEX(" )
      
      // '  {"STR(%1%,%2%,%3%)"      ,"STR(%1%,%2%,%3%)"},;
      // '       {"STR(%1%,%2%)"       ,"STR(%1%,%2%,0)"},;
      // '     {"DTOS(%1%)"        ,"CONVERT(char(8), %1%,11)"},;
      // '      {"IIF(%1%,%2%,%3%)"     ,"CASE WHEN %1% THEN %2% ELSE %3% END"},;

      // Case "ODBC"
   /*
        '       {"STR(%1%,%2%,%3%)"      ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,%3%)},SQL_VARCHAR)},%2%)}"},;
        '                {"STR(%1%,%2%)"       ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,0)},SQL_VARCHAR)},%2%)}"},;
         '               {"SUBSTR(%1%,%2%,%3%)"    ,"{fn SUBSTRING(%1%,%2%,%3%)}"},;
          '              {"DTOS(%1%)"        ,"{fn CONVERT({fn YEAR(%1%)}, SQL_VARCHAR)}+{fn RIGHT('0'+ {fn CONVERT({fn MONTH(%1%)},SQL_VARCHAR)},2)}+{fn RIGHT('0'+ {fn CONVERT({fn DAYOFMONTH(%1%)},SQL_VARCHAR)},2)}"},;
      '                  {"DAY(%1%)"         ,"{fn DAYOFMONTH(%1%)}"},;
     '                   {"MONTH(%1%)"       ,"{fn MONTH(%1%)}"},;
      '                  {"YEAR(%1%)"        ,"{fn YEAR(%1%)}"},;
         '               {"UPPER(%1%)"       ,"{fn UCASE(%1%)}"},;
         '               {"LOWER(%1%)"       ,"{fn LCASE(%1%)}"},;
         '               {"LEFT(%1%,%2%)"      ,"{fn LEFT(%1%,%2%)}"},;
          '              {"LEN(%1%)"         ,"{fn LENGTH(%1%)}"},;
         '               {"CHR(%1%)"         ,"{fn CHAR(%1%)}"},;
         '               {"ASC(%1%)"         ,"{fn ASCII(%1%)}"},;
         '               {"TODAY()"          ,"{fn CURDATE()}"},;
         '               {"REPL(%1%,%2%)"      ,"{fn REPEAT(%1%,%2%)}"},;
         '               {"TRIM(%1%)"        ,"{fn RTRIM(%1%)}"},;
         ''               {"ALLTRIM(%1%)"       ,"{fn LTRIM( {fn RTRIM(%1%) } )}"},;
         '               {"RIGHT(%1%)"       ,"{fn RIGHT(%1%)}"},;
            */

      // Case "ADS", "ADVANTAGE"


      // Case "OLEDB"
   /*
   '    {"STR(%1%,%2%,%3%)"      ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,%3%)},SQL_VARCHAR)},%2%)}"},;
   '                     {"STR(%1%,%2%)"       ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,0)},SQL_VARCHAR)},%2%)}"},;
   '                     {"SUBSTR(%1%,%2%,%3%)"    ,"{fn SUBSTRING(%1%,%2%,%3%)}"},;
   '                     {"DTOS(%1%)"        ,"{fn CONVERT({fn YEAR(%1%)}, SQL_VARCHAR)}+{fn RIGHT('0'+ {fn CONVERT({fn MONTH(%1%)},SQL_VARCHAR)},2)}+{fn RIGHT('0'+ {fn CONVERT({fn DAYOFMONTH(%1%)},SQL_VARCHAR)},2)}"},;
   '                     {"DAY(%1%)"         ,"{fn DAYOFMONTH(%1%)}"},;
   '                     {"MONTH(%1%)"       ,"{fn MONTH(%1%)}"},;
   '                     {"YEAR(%1%)"        ,"{fn YEAR(%1%)}"},;
   '                     {"UPPER(%1%)"       ,"{fn UCASE(%1%)}"},;
   '                     {"LOWER(%1%)"       ,"{fn LCASE(%1%)}"},;
   '                     {"LEN(%1%)"         ,"{fn LENGTH(%1%)}"},;
   '                     {"CHR(%1%)"         ,"{fn CHAR(%1%)}"},;
   '                     {"ASC(%1%)"         ,"{fn ASCII(%1%)}"},;
   '                     {"TODAY()"          ,"{fn CURDATE()}"},;
   '                     {"REPL(%1%,%2%)"      ,"{fn REPEAT(%1%,%2%)}"},;
   '                     {"TRIM(%1%)"        ,"{fn RTRIM(%1%)}"},;
   '                     {"ALLTRIM(%1%)"       ,"{fn LTRIM( {fn RTRIM(%1%) } )}"},;
   '                     {"LEFT(%1%,%2%)"      ,"{fn LEFT(%1%,%2%)}"},;
   '                     {"RIGHT(%1%)"       ,"{fn RIGHT(%1%)}"},;
            */
   CASE cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI"
      cSQLCNV := StrTran( cSQLCNV, "TODAY()", "SYSDATE " )
      cSQLCNV := StrTran( cSQLCNV, "CHR(", "CHAR(" )
      cSQLCNV := StrTran( cSQLCNV, "ASC(", "ASCII(" )
      cSQLCNV := StrTran( cSQLCNV, "TRIM(", "RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "ALLTRIM(", "LTRIM(RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "LEN(", "LENGTH(" )
      cSQLCNV := StrTran( cSQLCNV, "REPL(", "REPLICATE(" )
      // '  {"LEFT(%1%,%2%)"     ,"SUBSTR(%1%,1,%2%)"},;
      // '           {"DTOS(%1%)"        ,"TO_CHAR(%1%,'YYYYMMDD')"},;
      // '           {"DAY(%1%)"         ,"TO_NUM(TO_CHAR(%1%,'DD'))"},;
      // '           {"MONTH(%1%)"       ,"TO_NUM(TO_CHAR(%1%,'MM'))"},;
      // '           {"YEAR(%1%)"        ,"TO_NUM(TO_CHAR(%1%,'YYYY'))"},;

   CASE lMDB .OR. lACCDB
      cSQLCNV := StrTran( cSQLCNV, "CURRENTDATETIME", " now " )

   ENDCASE

   RETURN cSQLCNV
   
   
// +--------------------------------------------------------------------
// + Utilitário: FormataBlocoSql
// + Objetivo: Embeleza e formata strings brutas de SQL (CREATE TABLE / INDEX)
// +           Garante compatibilidade estrita, elimina duplicidade de ';'
// +           e protege tipos com decimais como NUMERIC(5,2) ou DECIMAL(12,3)
// +--------------------------------------------------------------------
FUNCTION FormataBlocoSql( cTextoBruto )
   // --- TODAS AS DECLARAÇÕES LOCAL RIGOROSAMENTE NO TOPO ---
   LOCAL aLinhas          := hb_ATokens( cTextoBruto, .T. )
   LOCAL cTextoFormatado  := ""
   LOCAL cInstrucao       := ""
   LOCAL cLinhaLimpa      := ""
   LOCAL cHeader          := ""
   LOCAL cMiolo           := ""
   LOCAL cCampo           := ""
   LOCAL aCampos          := {}
   LOCAL i                := 0
   LOCAL j                := 0
   LOCAL nPosAbre         := 0
   LOCAL nPosFecha        := 0
   LOCAL nContCampo       := 0

   // --- MIOLO DA FUNÇÃO: APENAS COMANDOS EXECUTÁVEIS ---
   FOR i := 1 TO Len( aLinhas )
      cLinhaLimpa := AllTrim( aLinhas[i] )

      // Ignora linhas vazias, pontos e vírgulas isolados ou tags de seções
      IF Empty( cLinhaLimpa ) .OR. cLinhaLimpa == ";" .OR. ( Left( cLinhaLimpa, 1 ) == "[" .AND. Right( cLinhaLimpa, 1 ) == "]" )
         IF !Empty( cLinhaLimpa ) .AND. cLinhaLimpa != ";"
            cTextoFormatado += cLinhaLimpa + hb_eol()
         ENDIF
         LOOP
      ENDIF

      // Limpa pontos e vírgulas residuais colados na linha antes de acumular
      IF Right( cLinhaLimpa, 1 ) == ";"
         cLinhaLimpa := Left( cLinhaLimpa, Len( cLinhaLimpa ) - 1 )
         cLinhaLimpa := AllTrim( cLinhaLimpa )
      ENDIF

      // Acumula pedaços de strings para remontar o comando completo
      cInstrucao += iif( Empty( cInstrucao ), "", " " ) + cLinhaLimpa

      // Se não atingiu o delimitador final da estrutura, continua acumulando
      IF ! ( "CREATE TABLE" $ Upper( cInstrucao ) ) .AND. ! ( "INDEX" $ Upper( cInstrucao ) ) .AND. ! ( "ALTER" $ Upper( cInstrucao ) )
         LOOP
      ENDIF

      // --- TRATAMENTO DO CREATE TABLE ---
      IF "CREATE TABLE" $ Upper( cInstrucao )
         // Aguarda o fechamento do parêntese final da estrutura da tabela para processar
         IF ! ( ")" $ cLinhaLimpa )
            LOOP
         ENDIF

         nPosAbre  := At( "(", cInstrucao )
         nPosFecha := Rat( ")", cInstrucao )

         IF nPosAbre > 0
            cHeader := Left( cInstrucao, nPosAbre ) 
            cMiolo  := SubStr( cInstrucao, nPosAbre + 1, iif( nPosFecha > 0, nPosFecha - nPosAbre - 1, Len( cInstrucao ) ) )
            
            cTextoFormatado += AllTrim( cHeader ) + hb_eol()
            
            aCampos    := hb_ATokens( cMiolo, "," )
            nContCampo := 0
            
            FOR j := 1 TO Len( aCampos )
               cCampo := AllTrim( aCampos[j] )
               
               // === CORREÇÃO CRÍTICA PARA DECIMAIS EM HARBOUR ===
               // Se houver um parêntese aberto "(" mas nenhum ")" fechando neste bloco do array,
               // significa que a vírgula do decimal (ex: NUMERIC(5,2)) separou o campo.
               // Juntamos com a próxima posição de forma limpa.
               IF ( "(" $ cCampo ) .AND. ! ( ")" $ cCampo ) .AND. j < Len( aCampos )
                  j++
                  cCampo += "," + AllTrim( aCampos[j] )
               ENDIF

               IF !Empty( cCampo )
                  nContCampo++
                  IF nContCampo == 1
                     cTextoFormatado += "    " + cCampo + hb_eol()
                  ELSE
                     cTextoFormatado += "    ," + cCampo + hb_eol()
                  ENDIF
               ENDIF
            NEXT
            
            // Fecha o bloco da tabela perfeitamente com um único ponto e vírgula na mesma linha
            cTextoFormatado += ") ;" + hb_eol()
         ELSE
            cTextoFormatado += cInstrucao + " ;" + hb_eol()
         ENDIF

         cInstrucao := "" 

      // --- TRATAMENTO DE ÍNDICES ---
      ELSEIF "CREATE" $ Upper( cInstrucao ) .AND. "INDEX" $ Upper( cInstrucao )
         cInstrucao := StrTran( cInstrucao, " ;", "" )
         cInstrucao := StrTran( cInstrucao, ";", "" )
         
         cTextoFormatado += AllTrim( cInstrucao ) + " ;" + hb_eol()
         cInstrucao := ""
         
      // --- TRATAMENTO DE ALTER TABLE ---
      ELSEIF "ALTER TABLE" $ Upper( cInstrucao )
         cInstrucao := StrTran( cInstrucao, " ;", "" )
         cInstrucao := StrTran( cInstrucao, ";", "" )
         
         cTextoFormatado += AllTrim( cInstrucao ) + " ;" + hb_eol()
         cInstrucao := ""
      ELSE
         // Fallback estrutural seguro
         cTextoFormatado += AllTrim( cInstrucao ) + " ;" + hb_eol()
         cInstrucao := ""
      ENDIF

   NEXT

RETURN cTextoFormatado

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SqliteCreateTable()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SqliteCreateTable( cTablename, aStruct, cTIPOSQL, lINDEX ,lPK)

   LOCAL mSQL
   LOCAL i
   LOCAL llMDB
   LOCAL llACCDB

   IF ValType( cTIPOSQL ) <> "C"
      cTIPOSQL := "SQLITE"
   ENDIF
   
   
   IF VALTYPE(cTablename)<>"C"
      cTablename:=ALIAS()
   ENDIF
   IF VALTYPE(aStruct)<>"A"
     aStruct:=DBSTRUCT()
   ENDIF
   
    IF VALTYPE(lINDEX)<>"L"
      lINDEX:=.F.
   ENDIF
  
    IF VALTYPE(lPK)<>"L"
      lPK:=.F.
   ENDIF 
   
   llMDB:=.F.
   llACCDB:=.F.
   
    IF cTIPOSQL = "MDB" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS64"
       llMDB := .T.
    ENDIF
    IF cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64"
       llACCDB := .T.
    ENDIF

   

   msql := ""
   IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"  // postgree e case sensitive deixando em maisuclav
      cTABLENAME := Upper( cTABLENAME )
   ENDIF
   IF llMDB .OR. llACCDB
      mSql := "CREATE TABLE " + cTablename + " ("
   ELSE
      mSql := "CREATE TABLE IF NOT EXISTS " + cTablename + " ("
   ENDIF

   FOR i := 1 TO Len( aStruct )
      mFldNm   := aStruct[ i, DBS_NAME ]
      mFldType := aStruct[ i, DBS_TYPE ]
      mFldLen  := aStruct[ i, DBS_LEN ]
      mFldDec  := aStruct[ i, DBS_DEC ]

      IF i > 1
         mSql += ", "
      ENDIF
      IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"   // postgreSQL e case sensitive deixando em maisuclas
         mFldnm := Upper( mFldnm )
      ENDIF
      mSql += AllTrim( mFldnm ) + " "

      DO CASE
         //
         // C  == Caracter  HB_FT_STRING          1 
         //
      CASE mFldType = "C" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         mSql += "VARCHAR2 (" + LTrim( Str( mFldLen ) ) + ")"
      CASE mFldType = "C" .AND. ( llMDB .OR. llACCDB ;
                                 .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "VARCHAR(" + LTrim( Str( mFldLen ) ) + ")"
      CASE mFldType = "C" .AND. cTIPOSQL = "SQLITE"
         mSql += "TEXT "
      CASE mFldType = "C" .AND. cTIPOSQL = "FIREBIRD"
         mSql += "VARCHAR(" + LTrim( Str( mFldLen ) ) + ")"   
      CASE mFldType = "C"
         mSql += "CHAR(" + LTrim( Str( mFldLen ) ) + ")"
         //
         //
         // V = Varchar and Varchar (Binary) hB_FT_ANY             17  
         //
         //
      CASE mFldType = "V" .AND. ( cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         IF mFldDec > 0
            mSql += "TEXT(" + hb_ntos( mFldDec ) + ")"
         ELSE
            mSql += "TEXT "
         ENDIF
      CASE mFldType = "V" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "VARCHAR(" + hb_ntos( mFldDec ) + ")"
      
         
         

         //
         // D = date     HB_FT_DATE            3 
         //
      CASE mFldType = "D" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "TIMESTAMP"

      CASE mFldType = "D" .AND. ( llMDB .OR. llACCDB .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "DATETIME"
      CASE mFldType = "D"
         mSql += "DATE"
  
      //
         /// @= datetime  HB_FT_TIMESTAMP       9 
         //    
      
       CASE mFldType = "@" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")   
          mSql += "TIMESTAMP"
       CASE mFldType = "@" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .or. cTIPOSQL = "SQLITE")   
          mSql += "DATETIME"
      CASE mFldType = "@" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
            mSql += "DATETIME"
      CASE mFldType = "@" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "TIMESTAMP"
     CASE mFldType = "@" .AND. ( llMDB .OR. llACCDB  )
         mSql += "DATETIME"
       CASE mFldType = "@" .AND. ( cTIPOSQL = "FIREBIRD" )   
          mSql += "TIMESTAMP"
         
         //
         // T - TIME  HB_FT_TIME            8 
         //
      CASE mFldType = "T" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "FIREBIRD" ;
                                 .OR. cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI"  )
         mSql += "TIMESTAMP"
      CASE mFldType = "T"
         mSql += "DATETIME"


      //
         //HB_FT_MODTIME         10     "="
         //
         //

         //
         // N = NUMERIC   HB_FT_LONG            4  
         // Inteiro
         // numerico ->INTEGER LONG BIGINT
         //
         // com decimais
         // Numerico ->FLOAT DOUBLE NUMERIC
         //
      CASE mFldType = "N" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         IF mFldDec > 0
            mSql += "NUMBER(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")  DEFAULT 0"
         ELSE
            mSql += "NUMBER(" + hb_ntos( mFldLen ) + ")  DEFAULT 0"
         ENDIF

      CASE mFldType = "N" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         IF mFldDec > 0
            mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         ELSE
            IF mFldLen <= 9
               DO CASE
               CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
                  mSQL += "INTEGER"
               OTHERWISE
                  mSql += "INT"  // INTEGER("+hb_ntos(mFldLen)+")" verificar se aceita int(size) ou usar numeric(size,0)
               ENDCASE
            ELSE
               DO CASE
               OTHERWISE
                  mSql += "BIGINT"   // "bigint("+hb_ntos(mFldLen)+")" verificar se aceita int(size) ou usar numeric(size,0)
               ENDCASE
            ENDIF
         ENDIF

     CASE mFldType = "N" .AND. cTIPOSQL = "FIREBIRD"
         IF mFldDec > 0
            mSql += "DECIMAL(" + LTrim( Str( mFldLen ) ) + "," + LTrim( Str( mFldDec ) ) + ")"
         ELSE
            // Adequação crucial para o Firebird não rejeitar o DDL
            IF mFldLen <= 4
               mSql += "SMALLINT"
            ELSEIF mFldLen <= 9
               mSql += "INTEGER"
            ELSE
               mSql += "BIGINT"
            ENDIF
         ENDIF

      CASE mFldType = "N" .AND. ( llMDB .OR. llACCDB )
         IF mFldDec > 0
            mSql += "DOUBLE"
         ELSE
            mSql += "LONG"
         ENDIF
      CASE mFldType = "N" .AND. cTIPOSQL = "SQLITE"
         IF mFldDec > 0
            mSql += "FLOAT"
         ELSE
            mSql += "INTEGER default 0"
         ENDIF

      CASE mFldType = "N" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"  )
         IF mFldDec > 0
            mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         ELSE
            IF mFldLen <= 9
               mSql += "INTEGER(" + hb_ntos( mFldLen ) + ")"
               if cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
                   mSql += " default 0"
               endif
            ELSE
               mSql += "bigint(" + hb_ntos( mFldLen ) + ")"
            ENDIF
         ENDIF
         //
         // F= float  HB_FT_FLOAT           5 
         //
      CASE  mFldType = "F" .AND. ( llMDB .OR. llACCDB )
         mSql += "DOUBLE"
      CASE mFldType = "F" .AND. cTIPOSQL = "SQLITE"
         mSql += "REAL "
      CASE mFldType = "F" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "FLOAT(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "F" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "F" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "DECIMAL(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "F"
         mSql += "FLOAT "
       CASE mFldType = "" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")    
         //verificar se aqui e realmente so as decimais 
         mSql += "FLOAT ("+ hb_ntos( mFldDec ) + ")  DEFAULT 0"
         //
         // Y= CURRENCY MOEDA  HB_FT_CURRENCY        13 
         //
      CASE mFldType = "Y" .AND. cTIPOSQL = "SQLITE"
         IF mFldDec > 0
            mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         ELSE
            mSql += "NUMERIC(" + hb_ntos( mFldLen ) + ")"
         ENDIF
      CASE mFldType = "Y" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "Y" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "MONEY "
      CASE mFldType = "Y" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "FIREBIRD" )
         mSql += "DECIMAL(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"

      CASE mFldType = "Y"
         mSql += "FLOAT"
         //
         // I = integer LONG HB_FT_INTEGER         6  
         //
      CASE mFldType = "I" .AND. ( llMDB .OR. llACCDB )
         mSql += "LONG"
      CASE mFldType = "I" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "INT " 
       CASE mFldType = "I" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"  )
         mSql += "INT  default 0"
       CASE mFldType = "I" .AND. ( cTIPOSQL = "SQLITE")          
         mSql += "INTEGER  default 0"
      CASE mFldType = "I" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )  
         mSql += "INT  default 0 "
      CASE mFldType = "I" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")   
        mSql += "NUMBER(" + hb_ntos( mFldLen ) + ",0)  DEFAULT 0"
        
      CASE mFldType = "I"
         mSql += "INTEGER"
         //
         // B = double HB_FT_DOUBLE          7 
         //
      CASE mFldType = "B"
         mSql += "DOUBLE"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "FLOAT"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "DOUBLE(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "DECIMAL(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         //
         // L = logico boleano bit HB_FT_LOGICAL         2 
         //
      CASE mFldType = "L" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" .OR. cTIPOSQL = "FIREBIRD" )
         mSql += "NUMBER (1)"
      CASE mFldType = "L" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "SQLITE"  )
         mSql += "BOOLEAN"
      CASE mFldType = "L" .AND. ( llMDB .OR. llACCDB .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "BIT"
      CASE mFldType = "L"
         mSql += "BOOL"
      CASE mFldType = "L" // Firebird, SQLite e Access operam com SMALLINT (0 ou 1)
         mSql += "SMALLINT"    
         //
         // M= memo TEXT LONGTEXT  HB_FT_MEMO            16 
         //
      CASE mFldType = "M" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         mSql += "CLOB"
      CASE mFldType = "M" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "TEXT"
      CASE mFldType = "M" .AND. ( llMDB .OR. llACCDB )
         mSql += "LONGTEXT"
      CASE mFldType = "M" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE TEXT" //"BLOB SUB_TYPE 1"
      CASE mFldType = "M"
         mSql += "TEXT"
         //
         // G = blob LONGBINARY  HB_FT_OLE             20  
         //
      CASE mFldType = "G" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BYTEA"
      CASE mFldType = "G" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "VARBINARY"
      CASE mFldType = "G" .AND. ( llMDB .OR. llACCDB )
         mSql += "LONGBINARY"
      CASE mFldType = "G" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
      CASE mFldType = "G"
         mSql += "BLOB"
          //
         // Q = Varbinary  HB_FT_VARLENGTH       15  
         //
      CASE mFldType = "Q" .AND. cTIPOSQL = "SQLITE"
         mSql += "BLOB "
      CASE mFldType = "Q" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "VARBINARY(" + hb_ntos( mFldLen ) + ")"
      CASE mFldType = "Q" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BYTEA"
      CASE mFldType = "Q" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
         //
         // W = Blob  HB_FT_BLOB            19
         //
      CASE mFldType = "W" .AND. ( cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "BLOB "
      CASE mFldType = "W" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "IMAGE"
      CASE mFldType = "W" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
      CASE mFldType = "W" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BYTEA"     
      CASE mFldType = "W" .AND. ( llMDB .OR. llACCDB )
         mSql += "OLEOBJECT"
     
         
         //
         // HB_FT_ROWVER          11     "^"
         //
 
          //
         //HB_FT_AUTOINC         12     "+"
         //
      CASE mFldType = "+" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )   
           MSql += " int  PRIMARY KEY AUTO_INCREMENT "
      
       CASE mFldType = "+" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")  
           MSql += " NUMBER (10,0) GENERATED ALWAYS AS IDENTITY" 
           
    CASE mFldType = "+" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )       
           MSql += "SERIAL "
           
     CASE mFldType = "+" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )      
           MSql += "INT IDENTITY(1,1)"
           
     CASE mFldType = "+" .AND. ( cTIPOSQL = "SQLITE")      
           MSql += "integer primary key AUTOINCREMENT"
           
     CASE mFldType = "+" .AND. ( llMDB .OR. llACCDB )
         mSql += "COUNTER"
           
     CASE mFldType = "+" .AND. ( cTIPOSQL = "FIREBIRD")      
           MSql += "INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY"
           
           //
           //tipo P picuture do ads adt
           //
           
           
           
       CASE mFldType = "P" .AND. ( cTIPOSQL = "SQLITE"  )
         mSql += "BLOB "
      CASE mFldType = "P" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"  )
         mSql += "VARBINARY(" + hb_ntos( mFldLen ) + ")"
      CASE mFldType = "P" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BYTEA" 
      CASE mFldType = "P" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )   
           MSql += "BLOB"
     CASE mFldType = "P" .AND. ( llMDB .OR. llACCDB )
         mSql += "OLEOBJECT"
     CASE mFldType = "P" .AND. ( cTIPOSQL = "FIREBIRD")      
           MSql += "BLOB SUB_TYPE 0"
         
  
     
           //
           //tipo Z rowversion do ads adt
           //
       CASE mFldType = "Z" .AND. ( cTIPOSQL = "SQLITE"  )
         mSql += "INTEGER DEFAULT 0"
      CASE mFldType = "Z" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"  )
         mSql += "rowversion"
      CASE mFldType = "Z" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )   
           MSql += "BIGINT"
       CASE mFldType = "Z" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BIGINT DEFAULT 0"    
       CASE mFldType = "Z" .AND. ( llMDB .OR. llACCDB )
         mSql += "LONG"  
       CASE mFldType = "Z" .AND.  ( cTIPOSQL = "FIREBIRD")
         mSql += "BIGINT DEFAULT 0"  
     CASE mFldType = "Z" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"  )
         mSql += "rowversion"
    
   
         //HB_FT_CURDOUBLE       14     "Z"
         //                

         //
         //  HB_FT_IMAGE           18     "P"                
         //
         
         // invalido
         //
         // define HB_FT_NONE            0
         //
      OTHERWISE
         alertx( "Invalid Field Type: " + mFldType + " "+ cTIPOSQL )
         RETURN ""
      ENDCASE
   NEXT
   mSql += ") "+HB_OSNEWLINE()
   IF cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      mSql += " COLLATE='latin1_swedish_ci' "+HB_OSNEWLINE()
      mSql += " ENGINE=InnoDB "+HB_OSNEWLINE()
   ENDIF
   mSql += " ; "
   mSQL +=HB_OSNEWLINE()
   
   IF lINDEX
      
      aINDICES:=GeraINDICES()
      nIndexes := LEN(aINDICES)
      FOR j := 1 TO nIndexes
          msql += aINDICES[J,1]+hb_osNewLine()  //Create index
          IF J=1 .AND. lPK
             cPKCHAVE=aINDICES[J,6]
             IF ! EMPTY(cPKCHAVE )
                mSQL +="ALTER TABLE " + cTABLENAME + " ADD PRIMARY KEY(" + cPKCHAVE + ") ;"+HB_OSNEWLINE()
             ENDIF   
          ENDIF
      NEXT j

   ENDIF

   RETURN msql
   
   
 *+--------------------------------------------------------------------
*+
*+
*+
*+    Function geracampodbf()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec)

local aRETU
local cSUBTIPO

IF TIPODBF=6 //USOVIA="ADSADT"
   RETURN geracampoadt(cFieldName,cFieldType,nFieldLength,nFieldDec)
ENDIF
aRETU := {cFieldName,cFieldType,nFieldLength,nFieldDec}



cTYPE    := cFieldType
cSUBTIPO := ""
IF SUBSTR(cTYPE,2,1) = ":"  //sqlimix manda tipo e subtipo exemplos N:i   C:CU  @:D
   cFieldType := SUBSTR(cTYPE,1,1)
   cSUBTIPO   := SUBSTR(cTYPE,3)
   cTYPE      := SUBSTR(cTYPE,1,1)
ENDIF

do case

   //
   // numeric(l,d) decimal(l,d)  number(l,d) o tamanho esta entre parentes
   //
CASE AT("(",cTYPE) > 0 .AND. AT(")",cTYPE) > 0 .AND. AT(",",cTYPE) > 0 .AND. (AT("NUMERIC",UPPER(CTYPE)) > 0 .OR. AT("DECIMAL",UPPER(CTYPE)) > 0 .OR. AT("NUMBER",UPPER(CTYPE)) > 0)
   cTMPSIZE     := SUBSTR(cTYPE,AT("(",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(",",cTMPSIZE) - 1)
   nFieldLength := val(cTMPSIZE)
   cTMPSIZE     := SUBSTR(cTYPE,AT(",",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE) - 1)
   nFieldDec    := val(cTMPSIZE)
   cFieldType   := 'N'


   //
   //  tyniint(n) int(n) number(n) tamanho esta entre parentes
   //
case AT("(",cTYPE) > 0 .AND. AT(")",cTYPE) > 0 .AND. AT(",",cTYPE) = 0 .AND. (AT("INT",UPPER(CTYPE)) > 0 .or. AT("NUMBER",UPPER(CTYPE)) > 0)
   cTMPSIZE     := SUBSTR(cTYPE,AT("(",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE) - 1)
   nFieldLength := VAL(cTMPSIZE)
   cFieldType   := 'N'
   nFieldDec    := 0


   //
   // varchar(n) char(n) text(n)  VARCHAR2(n) o tamanho esta entre parentes
   //
case AT("(",cTYPE) > 0 .AND. AT(")",cTYPE) > 0 .AND. (AT("CHAR",UPPER(CTYPE)) > 0 .OR. AT("TEXT",UPPER(CTYPE)) > 0 .OR. AT("VARCHAR2",UPPER(CTYPE)) > 0)
   cTMPSIZE     := SUBSTR(cTYPE,AT("(",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE) - 1)
   nFieldLength := VAL(cTMPSIZE)
   cFieldType   := 'C'
   nFieldDec    := 0


case cType == "TINYINT"
   cFieldType   := 'N'
   nFieldLength := 2
   nFieldDec    := 0


case cType == "INT2" .OR. cType == "SMALLINT"
   cFieldType   := 'N'
   nFieldLength := 4
   nFieldDec    := 0

case cType == "INT" .or. cType == "MEDIUMINT"
   cFieldType   := 'N'
   nFieldLength := 8
   nFieldDec    := 0


case cType == "INTEGER" .OR. cType == "INT4" .OR. cType == "SERIAL"
   cFieldType   := 'N'
   nFieldLength := 8
   nFieldDec    := 0

case cType == "BIGINT" .OR. cType == "INT8" .OR. cType == "BIGSERIAL"
   cFieldType   := 'N'
   nFieldLength := 16
   nFieldDec    := 0


//no sqllite tem a vezes aparece so DECIMAL nao especificado a precisao DECIMAL(n,d)
case cType == "DOUBLE PRECISION" .or. cType == "FLOAT8"  .OR. cType == "DECIMAL" 
   cFieldType   := 'N'
   nFieldLength := 19
   nFieldDec    := 9

case cType == "MONEY"
   cFieldType   := 'N'
   nFieldLength := 12
   nFieldDec    := 2

case cType == "REAL" .or. cType == "FLOAT" .or. cType == "DOUBLE" .or. cType == "FLOAT4"
   cFieldType   := 'N'
   nFieldLength := 14
   nFieldDec    := 5


case cType == "DATE" .or. cType == 'DATETIME' .or. cType == 'SHORTDATE' .or. cType == 'TIMESTAMP' ;
    .OR. cType == "D" .OR. cType == "TYPE_TIMESTAMP" .or. cType == "TYPE_DATE"
   cFieldType   := 'D'
   nFieldLength := 8
   nFieldDec    := 0

case cType == "@"   //Datetime opcao mudar como texto ou datetime futuramente
   cFieldType   := 'D'
   nFieldLength := 8
   nFieldDec    := 0

case cType == "BOOL" .or. cType == 'BOOLEAN'
   cFieldType   := 'L'
   nFieldLength := 1
   nFieldDec    := 0

CASE cType == "CLOB" .AND. (cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")  //Memo mas tratando com char(250)
   cFieldType   := 'C'
   nFieldLength := 250
   nFieldDec    := 0


CASE cType == "TEXT" .AND. (cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL")   //Memo mas tratando com char(250)
   cFieldType   := 'C'
   nFieldLength := 250
   nFieldDec    := 0

CASE cType == "LONGTEXT" .OR. cType == "M" .OR. cType == "WLONGVARCHAR"   //Memo mas tratando com char(250)
   cFieldType   := 'C'
   nFieldLength := 250
   nFieldDec    := 0
   //
   // TEXT SEM tamanho memo
   //
case AT("(",cTYPE) = 0 .AND. AT(")",cTYPE) = 0 .AND. AT("TEXT",UPPER(CTYPE)) > 0
   nFieldLength := 10
   cFieldType   := 'M'
   nFieldDec    := 0

   //
   // numeric sem ()
   //
case AT("(",cTYPE) = 0 .AND. AT(")",cTYPE) = 0 .AND. AT("NUMERIC",UPPER(CTYPE)) > 0
   cFieldType := 'N'
   IF nFieldLength = 0  //atribui 8 padrao integer caso nao foi passado
      nFieldLength := 8
      nFieldDec    := 0
   ENDIF

   //
   // postgresql varchar bpchar CHARACTER
   //
CASE cType == "VARCHAR" .OR. cType == "BPCHAR" .OR. AT("CHARACTER",UPPER(CTYPE)) > 0 .OR. cType == "WVARCHAR" .OR. cType == "WCHAR"
   cFieldType := 'C'
   nFieldDec  := 0


CASE cType == "NAME"
   cFieldType   := 'C'
   nFieldLength := 64
   nFieldDec    := 0

CASE cType == "C" .AND. nFieldLength > 250  //alguns longchar vem comprimento 65535 estudando mudar para memo por enquanto C 250
   nFieldLength := 250

   //
   // Inteiro sub numerico troca para numerico
   //
CASE cType == "I" .AND. cSUBTIPO == "N"
   cFieldType := 'N'

CASE cType == "OID"
   cFieldType   := 'N'
   nFieldLength := 19
   nFieldDec    := 0
   
// Adicionar ao seu DO CASE:
CASE cType == "BYTEA" .OR. cType == "BLOB" .OR. cType == "IMAGE" .OR. cType == "VARBINARY"
   cFieldType   := 'M'
   nFieldLength := 10
   nFieldDec    := 0

// Tratamento específico para o ROWVERSION (Tipo Z do ADS)
CASE cType == "ROWVERSION" // O tipo rowversion do SQL Server
   cFieldType   := 'C'
   nFieldLength := 8
   nFieldDec    := 0   

otherwise

endcase
aRETU := {cFieldName,cFieldType,nFieldLength,nFieldDec}
return aRETU

/*
tipo ADS,Código/ID,Descrição,Equivalente DBF
VARCHAR,V,String Variável,C
CHAR,C,String Fixa,C
MONEY,Y,Monetário (Exato),N
DOUBLE,O,Ponto Flutuante,N
INTEGER,I,Inteiro 32-bit,N
SHORTINT,S,Inteiro 16-bit,N
AUTOINC,+,Auto-incremento,N
LOGICAL,L,Booleano,L
DATE,D,Data,D
TIMESTAMP,@,Data e Hora,C (ou @)
MEMO,M,Texto Longo,M
BLOB,W,Binário/Objetos,M / W
MODIFIED,X,Timestamp Auto,N/A
RAW,R,Binário Fixo,N/A
*/

FUNCTION GERACAMPOADT(cFieldName, cSqlType, nFieldLength, nFieldDec)
   LOCAL aRetu := {cFieldName, "C", 10, 0}
   LOCAL cType := AllTrim(cSqlType)
   LOCAL cUpper := Upper(cType)
   LOCAL cTmpSize

   // 1. Tipos com Tamanho entre Parênteses: (L,D) ou (N)
   // Numeric, Decimal, Number, Int, Tinyint, Varchar, Char, Text, Varchar2
   IF AT("(", cType) > 0 .AND. AT(")", cType) > 0
      cTmpSize := SUBSTR(cType, AT("(", cType) + 1, AT(")", cType) - AT("(", cType) - 1)
      
      IF AT(",", cTmpSize) > 0 // Caso (L,D)
         nFieldLength := VAL(SUBSTR(cTmpSize, 1, AT(",", cTmpSize) - 1))
         nFieldDec    := VAL(SUBSTR(cTmpSize, AT(",", cTmpSize) + 1))
         RETURN {cFieldName, "N", nFieldLength, nFieldDec}
      ELSE // Caso (N)
         nFieldLength := VAL(cTmpSize)
         IF AT("CHAR", cUpper) > 0 .OR. AT("TEXT", cUpper) > 0
            RETURN {cFieldName, "C", nFieldLength, 0}
         ELSE
            RETURN {cFieldName, "N", nFieldLength, 0}
         ENDIF
      ENDIF
   ENDIF

   // 2. Cases Específicos e Exclusivos de Bancos
   DO CASE
      // Numéricos Inteiros
      CASE cUpper == "TINYINT" ; RETURN {cFieldName, "N", 2, 0}
      CASE cUpper == "INT2" .OR. cUpper == "SMALLINT" ; RETURN {cFieldName, "N", 4, 0}
      CASE cUpper == "INT" .OR. cUpper == "MEDIUMINT" ; RETURN {cFieldName, "N", 8, 0}
      CASE cUpper == "INTEGER" .OR. cUpper == "INT4" .OR. cUpper == "SERIAL" ; RETURN {cFieldName, "N", 8, 0}
      CASE cUpper == "BIGINT" .OR. cUpper == "INT8" .OR. cUpper == "BIGSERIAL" ; RETURN {cFieldName, "N", 16, 0}
      CASE cUpper == "OID" ; RETURN {cFieldName, "N", 10, 0}
      
      // Reais e Ponto Flutuante
      CASE cUpper == "DOUBLE PRECISION" .OR. cUpper == "FLOAT8" ; RETURN {cFieldName, "N", 19, 9}
      CASE cUpper == "REAL" .OR. cUpper == "FLOAT" .OR. cUpper == "DOUBLE" .OR. cUpper == "FLOAT4" ; RETURN {cFieldName, "N", 14, 5}
      CASE cUpper == "MONEY" ; RETURN {cFieldName, "N", 12, 2}
      
      // Datas, Horas e Timestamps
      CASE cUpper == "DATE" .OR. cUpper == "DATETIME" .OR. cUpper == "SHORTDATE" .OR. cUpper == "TIMESTAMP" ;
           .OR. cUpper == "D" .OR. cUpper == "TYPE_TIMESTAMP" .OR. cUpper == "TYPE_DATE" 
           RETURN {cFieldName, "@", 8, 0}
      CASE cUpper == "@" ; RETURN {cFieldName, "@", 8, 0}
      
      // Lógicos
      CASE cUpper == "BOOL" .OR. cUpper == "BOOLEAN" ; RETURN {cFieldName, "L", 1, 0}
      
      // Memo, Textos Longos e BLOBs
      CASE cUpper == "CLOB" .OR. cUpper == "TEXT" .OR. cUpper == "LONGTEXT" .OR. cUpper == "M" .OR. cUpper == "WLONGVARCHAR" 
           RETURN {cFieldName, "M", 10, 0}
      CASE cUpper == "BYTEA" .OR. cUpper == "BLOB" .OR. cUpper == "IMAGE" .OR. cUpper == "VARBINARY" 
           RETURN {cFieldName, "P", Max(10, nFieldLength), 0}
      
      // Específicos do ADS
      CASE cUpper == "ROWVERSION" ; RETURN {cFieldName, "Z", 8, 0}
      CASE cUpper == "W" ; RETURN {cFieldName, "W", 10, 0}
      CASE cUpper == "IDENTITY" ; RETURN {cFieldName, "+", 10, 0}
      
      // Tratamento para VARCHAR, BPCHAR, CHARACTER (Compatibilidade Postgres/Oracle)
      CASE cUpper == "VARCHAR" .OR. cUpper == "BPCHAR" .OR. AT("CHARACTER", cUpper) > 0 .OR. cUpper == "WVARCHAR" .OR. cUpper == "WCHAR" .OR. cUpper == "NAME"
         RETURN {cFieldName, "C", Max(1, nFieldLength), 0}

      // Fallback para campos C grandes ou tipos desconhecidos
      CASE cUpper == "C" .AND. nFieldLength > 250 ; RETURN {cFieldName, "M", 10, 0}
      CASE cUpper == "I" .AND. cType == "I:N" ; RETURN {cFieldName, "N", 10, 0}

      OTHERWISE
         RETURN {cFieldName, "C", Max(10, nFieldLength), 0}
   ENDCASE
RETURN aRetu


FUNCTION GeraINDICES()
LOCAL aDUPLA
aDUPLA:={}
nIndexes := dbORDERINFO(DBOI_ORDERCOUNT)
FOR j := 1 TO nIndexes
   // Inicialização correta dos tipos de variáveis a cada iteração
   cINDEXNAME := ""
   cKey       := ""
   lIsUnique  := .F.  // Correção: Deve iniciar como Booleano (.F.) e não String ("")
   cFilter    := ""   // Inicia vazio, caso a RDD não suporte DBOI_CONDITION
   
  // Tenta ler o Nome do Índice
   TRY
      cINDEXNAME := dbORDERINFO(DBOI_NAME,,j)
   CATCH
      cINDEXNAME := "" // Fallback caso a RDD não consiga expor o nome
   END   
   
   // Garante a remoção de espaços antes de testar se está vazio
   cINDEXNAME := AllTrim(cINDEXNAME)
   
   // Se a RDD não retornou um nome válido, usa o fallback sequencial (obrigatório para todos os bancos)
   IF Empty( cINDEXNAME )
      cINDEXNAME := "IDX_" + AllTrim(cTablename) + "_" + AllTrim(Str(j))
   ELSE
      // Se a RDD retornou um nome (ex: "CODIGO"), prefixamos o nome da tabela 
      // APENAS nos bancos com escopo global de índice (SQLite e PostgreSQL)
      IF cTIPOSQL == "SQLITE" .OR. cTIPOSQL == "PGSQL" .OR. cTIPOSQL == "PGSQL64" .OR. cTIPOSQL == "POSTGRESQL"
         cINDEXNAME := "IDX_" + AllTrim(cTablename) + "_" + cINDEXNAME
      ELSE
         // Para os outros bancos (MySQL, SQL Server), mantemos o nome original da TAG do DBF,
         // mas adicionamos o prefixo "IDX_" por boa prática de sintaxe SQL (opcional, se preferir tire o "IDX_")
         cINDEXNAME := "IDX_" + cINDEXNAME 
      ENDIF
   ENDIF   

   // Trata caracteres inválidos (traços e espaços) no nome final gerado
   cINDEXNAME := StrTran(cINDEXNAME, "-", "_") 
   cINDEXNAME := StrTran(cINDEXNAME, " ", "_")
   
   // Tenta ler a Expressão da Chave
   TRY
      cKey := dbOrderInfo( DBOI_EXPRESSION, , j )
   CATCH
      cKey := ""
   END
   
   // Tenta ler a propriedade de Unicidade
   TRY  
      lIsUnique := dbOrderInfo( DBOI_UNIQUE, , j )
   CATCH
      lIsUnique := .F. // Fallback padrão seguro
   END
   
   // Tenta ler a Condição de Filtro (O comando FOR)
   TRY  
      cFilter := dbOrderInfo( DBOI_CONDITION, , j ) 
   CATCH
      cFilter := "" // Se a RDD não suportar filtros (ex: DBFNTX antiga), assume vazio com segurança
   END  
   
   // Só processa e grava se a RDD conseguir extrair uma expressão de chave válida
   IF .NOT. Empty( cKey )
      
      // Transforma a chave Harbour em colunas SQL separadas por vírgula
      cSqlExpr := MDPCHAVEI( cKey ) 
      
      // Gera o comando físico de criação do índice usando a expressão tratada
      msql := "CREATE INDEX " + cINDEXNAME + " ON " + cNometabela + " ( " + cSqlExpr + " ) "
      
      // Monta o INSERT alimentando a estrutura de metadados expandida de forma segura
      msqlMETA := "INSERT INTO index_metadata (table_name, index_name, expression, sql_expression, filter_expression, is_unique, is_bag) VALUES (" + ;
              c2sql(cTablename) + ", " + ;
              c2sql(cINDEXNAME) + ", " + ; 
              c2sql(cKey)       + ", " + ; 
              c2sql(cSqlExpr)   + ", " + ; 
              c2sql(cFilter)    + ", " + ; 
              iif( lIsUnique, "1", "0" ) + ", " + ; // Agora totalmente seguro contra erros de tipo
              "1)"                         
     AADD(aDUPLA,{msql,msqlmeta,cTablename,cINDEXNAME,cKey,cSqlExpr,cFilter,lIsUnique})       
     //             1     2          3          4      5      6        7       8      
   ENDIF 
NEXT j
return aDUPLA


// + EOF: dbudialeto.prg
// +
