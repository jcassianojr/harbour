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
FUNCTION Dialeto_begin()

   LOCAL cCOMANDO

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
   //   CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
   //        cCOMANDO =""
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
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cSQLCNV := StrTran( cSQLCNV, "TODAY()", "GETDATE() " )
      cSQLCNV := StrTran( cSQLCNV, "ASC(", "ASCII(" )
      cSQLCNV := StrTran( cSQLCNV, "TRIM(", "RTRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "ALLTRIM(", "TRIM(" )
      cSQLCNV := StrTran( cSQLCNV, "REPL(", "REPLICATE(" )
      cSQLCNV := StrTran( cSQLCNV, "CHR(", "CHAR(" )
      cSQLCNV := StrTran( cSQLCNV, "SUBSTR(", "SUBSTRING(" )
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

// + EOF: dbudialeto.prg
// +
