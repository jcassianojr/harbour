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

Function Dialeto_GetIdentity()
LOCAL cCOMANDO
cCOMANDO:=""
  DO CASE
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
           cCOMANDO ="select @@IDENTITY"
      CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
           cCOMANDO ="select LAST_INSERT_ID()"
   //   CASE cTIPOSQL="FIREBIRD"
   //        cCOMANDO =""
      CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabaseX))>0
           cCOMANDO ="SELECT last_insert_rowid()"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
           cCOMANDO ="SELECT lastval();"
       CASE cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
           cCOMANDO ="select LAST_INSERT_ID()"     
   ENDCASE
return cCOMANDO

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
// + EOF: dbudialeto.prg
// +
