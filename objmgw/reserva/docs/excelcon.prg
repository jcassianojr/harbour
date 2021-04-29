FUNCTION ExcelConnection( cFileName, cVersion )

   LOCAL oConexao

   DO CASE
   CASE ValType( cVersion ) == "C"
   CASE ".xlsx" $ Lower( cFileName ); cVersion := "12.0 Xml" // XLSX
   //CASE "t00" $ Lower( cFileName )  ; cVersion := "5.0"  // 95
   OTHERWISE                        ; cVersion := "8.0" // 97/2000/XP
   ENDCASE
   oConexao := win_OleCreateObject( "ADODB.Connection" )
   oConexao:ConnectionString := ;
      [Provider=Microsoft.ACE.OLEDB.12.0;Data Source=] + cFileName + ;
      [;Extended Properties="Excel ] + cVersion + [;HDR=YES";]

   RETURN oConexao

FUNCTION MySQLConnection( cServer, cDatabase, cUser, cPassword )

   LOCAL cnConnection, cString

   cString := iif( win_OsIs10(), "Provider=MSDASQL;", "" )
   DO CASE
   CASE IsMaquinaJPA();                   cString += "Driver={MariaDB ODBC 3.1 Driver};"
   CASE "HAROLDO" $ AppEmpresaApelido() ; cString += "Driver={MySQL ODBC 3.51 Driver};"
   OTHERWISE ;                            cString += "Driver={MySQL ODBC 5.3 ANSI Driver};"
   ENDCASE
   cString += "Server=" + cServer + ";" + ;
      "Port=3306;" + ;
      "Stmt=;"    + ;
      "Database=" + cDatabase + ";" + ;
      "User="     + cUser + ";" + ;
      "Password=" + cPassword + ";" + ;
      "Collation=latin1_swedish_ci;" + ;
      "AUTO_RECONNECT=1;" 

   cnConnection := win_OleCreateObject( "ADODB.Connection" )
   cnConnection:ConnectionString  := cString
   cnConnection:CursorLocation    := AD_USE_CLIENT
   cnConnection:CommandTimeOut    := 600 // seconds
   cnConnection:ConnectionTimeOut := 600 // seconds

   RETURN cnConnection

FUNCTION ADSConnection( cPath )

   LOCAL oConexao := win_OleCreateObject( "ADODB.Connection" )

   oConexao:ConnectionString := "Provider=Advantage OLE DB Provider;" + ;
      "Mode=Share Deny None;" + ;
      "Show Deleted Records in DBF Tables with Advantage=False;" + ;
      "Data Source=" + cPath + ";Advantage Server Type=ADS_Local_Server;" + ;
      "TableType=ADS_CDX;Security Mode=ADS_IGNORERIGHTS;" + ;
      "Lock Mode=Compatible;" + ;
      "Use NULL values in DBF Tables with Advantage=True;" + ;
      "Exclusive=No;Deleted=No;"
   oConexao:CursorLocation := AD_USE_CLIENT
   oConexao:CommandTimeOut := 20

   RETURN oConexao

FUNCTION SQLiteConnection( cFileName )

   LOCAL oConexao := win_OleCreateObject( "ADODB.Connection" )

   oConexao:ConnectionString := iif( win_OsIs10(), "Provider=MSDASQL;", "" ) + ;
      "Driver={SQLite3 ODBC Driver};Database=" + cFileName + ";"
   oConexao:CursorLocation := AD_USE_CLIENT
   oConexao:CommandTimeOut := 20

   RETURN oConexao
