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
