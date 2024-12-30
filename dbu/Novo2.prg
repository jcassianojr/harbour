 CASE mFldType = "" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")
 
 
 CASE mFldType = "" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
 
  CASE mFldType = "" .AND. ( cTIPOSQL = "SQLITE")
  
  CASE mFldType = "" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
