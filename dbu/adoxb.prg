****************************************************************************************
*
* CursorType
*
* adOpenForwardOnly     0 O cursor so navega para frente. Bom para listar dados
* adOpenKeyset          1 Nao permite ver os registro adicionados e eliminados
* adOpenDynamic         2 Aceita todas operacoes do utilizador e dos outros
* adOpenStatic          3 Serve apenas para procurar dados ou gerar relatorios
*
* LockTypeEnum - Contantes de Seguranca
*
* adLockReadOnly        1 Apenas pode ler os registros
* adLockPessimistic     2 O fornecedor dos dados fecha o registro apos edicao
* adLockOptimistic      3 O fornecedor dos dados fecha o registro apos chamar o update
* adLockBatchOptimistic 4 O mesmo que Optmistic mas para sequencia de comandos
*
* SortOrdEnum - Contantes de Ordenacao
*
* adSortAscending       1 Ordem ascendente
* adSortDescending      2 Ordem descendente
*
****************************************************************************************

#include "adoxb.ch"
#ifndef _ADO_xHarbour_
        #define _ADO_Harbour_
#endif

*
*---------------------------------------------------------
Function ADOSetRDD( cRDDName )
   public cADORDD
   PUBLIC aRecordSet, oRS, oRecordSet, nConnection, nRecordSet, aIndexOrder, ;
          nIndexOrder, StrConnection, aADOConection, oADOConection, oADOIndex, ;
          oADOErrDescription, oADOCatalog, oADOTable, oADOStream
   nConnection   := 1
   aADOConection := {}
   oADOConection := Array(10)
   cADORDD       := iif( cRDDName=NIL, "DBF", cRDDName )
   return cADORDD

*
*---------------------------------------------------------
#ifdef _ADO_Harbour_
Function ADOConnect( StrDriver )
   //PUBLIC aRecordSet, oRecordSet, nRecordSet, aIndexOrder, nIndexOrder, StrConnection, oADOConection, oADOErrDescription, oADOIndex, oADOCatalog, oADOTable
   aRecordSet         := {}
   oRecordSet         := Array(50)
   oADOIndex          := Array(10)
   nRecordSet         := 0
   aIndexOrder        := {}
   nIndexOrder        := 1
   StrConnection      := StrDriver
   AADD( aADOConection, StrDriver ) // Controla numero de conexoes
   nConnection        := len( aADOConection )
   oADOConection      := TOLEAUTO():New("ADODB.connection")
   oADOStream         := TOLEAUTO():New("ADODB.Stream")
   oADOErrDescription := TOLEAUTO():New("ADODB.Err")
   oADOIndex          := TOLEAUTO():New("ADOX.Index")
   oADOCatalog        := TOLEAUTO():New("ADOX.Catalog")
   oADOConection:CommandTimeOut    := 200
   oADOConection:ConnectionTimeOut := 10
   oADOConection:CursorLocation    := adUseClient
   oADOConection:Mode              := adModeShareDenyNone // adModeRead 1, adModeWrite 2, adModeReadWrite 3
   oADOConection:Open( StrConnection )
   return 'connected'
   #endif _ADO_Harbour_

*
*---------------------------------------------------------
#ifdef _ADO_Harbour_
Function ADODBCREATE( cDatabase )
   oADOCreateCatalog := TOLEAUTO():New("ADOX.Catalog")
   StrConnection := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + cDatabase
   oADOCreateCatalog:Create( StrConnection )
   oADOCreateCatalog := nil
   return .t.

*
*---------------------------------------------------------
Function ADODBCREATESQL( cFname, aFields )
   LOCAL cTmp := ""
   cTmp := cTmp + "CREATE TABLE "+lower(cFname)+"("
   cTmp := cTmp + "RECNO INT NOT NULL AUTO_INCREMENT,"
   for i = 1 to len(aFields)
       cName := lower(aFields[i][1])
       cType := aFields[i][2]
       nLen  := aFields[i][3]
       nDec  := aFields[i][4]
       do case
           case cType == "C"
                cTmp := cTmp + " " + cName + " CHAR("+alltrim(str(nLen)) + "), "
           case cType == "M"
                cTmp := cTmp + " " + cName + " BLOB, "
           case cType == "L"
                cTmp := cTmp + " " + cName + " TINYINT(1), "
           case cType == "D"
                cTmp := cTmp + " " + cName + " DATE, "
           case cType == "N"
                if( nDec == 0 )
                    cTmp := cTmp + " " + cName + " INT("+alltrim(str(nLen)) + "), "
                else
                    cTmp := cTmp + " " + cName + " DOUBLE("+alltrim(str(nLen))+","+alltrim(str(nDec)) + "), "
                endif
       endcase        
   next        
   cTmp := cTmp + "PRIMARY KEY(RECNO) )" + CR
   ADO EXECUTE "DROP TABLE IF EXISTS "+lower(cFname)
   ADO EXECUTE cTmp
   return .t.

Function ADOCREATE( cTable, aFields )
   //local oADOTable := TOLEAUTO():New("ADOX.Table")
   //oADOCatalog:ActiveConnection := StrConnection
   //oADOTable:Name := cTable
   //for i = 1 to len( aFields )
   //    oADOTable:Columns:Append( aFields[i][1], GetFieldType(aFields[i][2]), aFields[i][3] )
   //next
   //oADOCatalog:Tables:Append( oADOTable )
   //oADOTable:Close()
   //oADOTable:End()
   //
   //oADOCreateCatalog := TOLEAUTO():New("ADOX.Catalog")
   //oADOCreateTable   := TOLEAUTO():New("ADOX.Table")
   //oADOCreateCatalog:Create( StrConnection )
   //oADOCreateTable:Name := cTable
   //for i = 1 to len( aFields )
   //    oADOCreateTable:Columns:Append( aFields[i][1], GetFieldType(aFields[i][2]) ) //, aFields[i][3] )
   //next
   //oADOCreateCatalog:Tables:Append( cTable )
   //return .t.
   #endif _ADO_Harbour_

*
*---------------------------------------------------------
#ifdef _ADO_Harbour_
Function ADOIndex( cTable, cIDXField, cIDXName, cIDXAscend )
   local adSortAscending := 1, adSortDescending := 2
   local oADOTable := TOLEAUTO():New("ADOX.Table")
   cIDXAscend := iif( cIDXAscend = nil, .t., cIDXAscend )
   if .not. ADOFILE( "INDEXES" )
      oADOCatalog:ActiveConnection := StrConnection
      oADOTable:Name := "INDEXES"
      oADOTable:Columns:Append( "NumField", adInteger, 20 )
      oADOTable:Columns:Append( "TextField", adVarWChar, 20 )
      oADOCatalog:Tables:Append( oADOTable )
   endif
   AADD( aIndexOrder, cTable )
   nIndexOrder        := len( aIndexOrder )
   oADOIndex[nIndexOrder] := TOLEAUTO():New("ADOX.Index")
   oADOIndex[nIndexOrder]:Name       := cIDXName
   oADOIndex[nIndexOrder]:Columns:Append( cIDXField )
   oADOIndex[nIndexOrder]:Columns( cIDXField ):SortOrder = iif( cIDXAscend, adSortAscending, adSortDescending )
   //oADOIndex[nIndexOrder]:PrimaryKey := .t.
   //oADOIndex[nIndexOrder]:Unique     := .t.
   oADOIndex[nIndexOrder]:IndexNulls := adIndexNullsAllow
   // Adciona o indice criado ao catalogo
   //oADOCatalog:Tables( cTable ) //:Indexes:Append( oADOIndex[nIndexOrder] )
   oADOTable:Indexes:Append( oADOIndex )
   oADOCatalog:Tables:Append( oADOTable )
   oADOTable:Close()
   oADOTable:End()
   return .t.
   #endif _ADO_Harbour_

*
*---------------------------------------------------------
#ifdef _ADO_Harbour_
Function ADOUse( cDatabase, lShared )
   local oError
   if "XML" $ cADORDD
      cDatabase := cDatabase + ".xml"
   endif
   if cADORDD = "XLS"
      cDatabase := "[" + cDatabase + "$]"
   endif
   if cDatabase = NIL
      oRecordSet[nRecordSet]:Close()
      oRecordSet[nRecordSet]:End()
   else
      AADD( aRecordSet, cDatabase )
      cRecordSet := cDatabase
      nRecordSet := len( aRecordSet )
      oRS := oRecordSet[nRecordSet] := TOleAuto():New( "ADODB.Recordset" )
      if "XML" $ cADORDD
         oRecordSet[nRecordSet]:Open( cDatabase, StrConnection, 1, 3 )
      else
         oRecordSet[nRecordSet]:CacheSize      := 50
         oRecordSet[nRecordSet]:CursorLocation := adUseClient
         if lShared = .t.
            oRecordSet[nRecordSet]:CursorType  := adOpenDynamic
            oRecordSet[nRecordSet]:LockType    := adLockOptimistic
         else
            oRecordSet[nRecordSet]:CursorType  := adOpenStatic
            oRecordSet[nRecordSet]:LockType    := adLockPessimistic
         endif
         oRecordSet[nRecordSet]:Open( "Select * from " + cDatabase, StrConnection, iif(lShared=.t.,3,1), 3 )
      endif
      ADOGOTOP() // oRecordSet[nRecordSet]:MoveFirst()
   endif
   //oRS := oRecordSet
   * CursorType
   *
   * adOpenForwardOnly     0 O cursor so navega para frente. Bom para listar dados
   * adOpenKeyset          1 Nao permite ver os registro adicionados e eliminados
   * adOpenDynamic         2 Aceita todas operacoes do utilizador e dos outros
   * adOpenStatic          3 Serve apenas para procurar dados ou gerar relatorios
   *
   * LockTypeEnum - Contantes de Seguranca
   *
   * adLockReadOnly        1 Apenas pode ler os registros
   * adLockPessimistic     2 O fornecedor dos dados fecha o registro apos edicao
   * adLockOptimistic      3 O fornecedor dos dados fecha o registro apos chamar o update
   * adLockBatchOptimistic 4 O mesmo que Optmistic mas para sequencia de comandos
   return oRecordSet
   #endif _ADO_Harbour_

*
*---------------------------------------------------------
#ifdef _ADO_Harbour_
Function ADOConnectRemote( StrDSN, StrServer )
   PUBLIC aRecordSet, oRecordSet, nRecordSet, aIndexOrder, nIndexOrder, StrConnection, oADOConection, oADOErrDescription, oADOIndex, oADOCatalog
   aRecordSet    := {}
   oRecordSet    := Array(50)
   oADOIndex     := Array(10)
   nRecordSet    := 0
   aIndexOrder   := {}
   nIndexOrder   := 1
   StrConnection := StrDriver
   oADOConection := TOLEAUTO():New("RDS.DataControl")
   oADOConection:ExecuteOptions := adcExecAsync
   oADOConection:Connect        := "DSN=" + StrDriver
   oADOConection:Server         := StrServer
   oADOConection:Refresh()
   return .t.
   #endif _ADO_Harbour_

*
*---------------------------------------------------------
Function ADOConnected()
   if !(valtype(oADOConection) = "O")
      return .f. // Nao foi definido o Objecto
   endif
   if valtype(oADOConection) = "L"
      return .f. // Se ja existe a variavel mas nao foi definida como Objeto
   endif
   cADOConectionState := oADOConection:State 
   return iif( cADOConectionState=1, .t., .f. )

*
*---------------------------------------------------------
Function ADOMsgAlert( cMsg )
   Alert( cMsg )
   return .t.

*
*---------------------------------------------------------
Function ADOSetDriver( StrDatabase, StrSenha, StrUsuario, StrServer, StrPort )
   LOCAL cEXTENSAO
   LOCAL cDIRETORIO
   LOCAL cNAME
   
   cNAME:=""
   cEXTENSAO:=""
   cDIRETORIO:=""
   
   
   hb_FNameSplit( StrDatabase,@cDIRETORIO, @cName, @CEXTENSAO )
   cEXTENSAO=LOWER(cEXTENSAO)

   //public cADORDD := iif( cRDDName=NIL, "DBASE", cRDDName )
   StrConnection := ""
   StrDriver     := ADORDDDefault()
   if StrDriver = "DBASE" //.DBF
      StrConnection := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+StrDatabase+";Extended Properties=dBASE IV;"
   endif
   if StrDriver = "ACCESS" .OR. StrDriver = "MDB" .OR. cEXTENSAO == ".mdb" // ADOMDB .MDB
      StrConnection := "Provider= MicroSoft.Jet.OLEDB.4.0;Data Source="+StrDatabase+";"
   endif
   if StrDriver =  "ACCDB" .OR. cEXTENSAO == ".accdb"
      StrConnection:="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+StrDatabase+";Mode=Share Deny None"
   endif
   if StrDriver =  "SQLITE" .or. cEXTENSAO == ".sqlite" .or. cEXTENSAO == ".sqlite3" .or. cEXTENSAO == ".fossil" .or. cEXTENSAO == ".db3"
      StrConnection:="Driver={SQLite3 ODBC Driver};Database=" + StrDatabase + ";"
   endif
   if StrDriver="PGSQL" .OR. StrDriver="POSTGRESQL"
      StrConnection:="DRIVER={PostgreSQL ANSI};Server="+StrDatabase+";Uid="+StrUsuario+";Pwd="+StrSenha //+";pqopt={search_path=myschema,public}" //32 driver versao 
   endif
   if StrDriver = "FIREBIRD" .or. cEXTENSAO == ".fgb" .or. cEXTENSAO == ".gdb"// ADOGDB
      StrConnection := "DRIVER=Firebird/InterBase(r) driver; UID="+StrUsuario+"; PWD="+StrSenha+"; DBNAME="+StrDatabase
   endif
   if StrDriver = "MYSQL" // ADOMySQL
      StrConnection := "Driver={MySQL ODBC 8.0 ANSI Driver};database=" + StrDatabase + ;
                       ";server=" + StrServer + ;
                       ";uid=" + StrUsuario + ;
                       ";pwd=" + StrSenha + ;
                       ";option=35"
   endif
   if StrDriver = "MARIADB"
      StrConnection:="DRIVER={MariaDB ODBC 3.2 Driver};SERVER="+StrServer+";UID="+StrUsuario+";PASSWORD="+StrSenha
   endif
   if StrDriver = "PARADOX" // ADOPX .DB
      StrConnection := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+StrDatabase+";Extended Properties=Paradox 5.x;" 
   endif
   if StrDriver = "SQL" .OR. StrDriver = "MSSQL" .OR. StrDriver = "SQLSERVER"
      StrConnection := "Provider=MSDASQL;Data Source="+StrDatabase+";User ID="+StrUsuario+";Password="+StrSenha+";" 
   endif
   if ADORDDDefault() == "XMLDB" // ADOXML
      StrConnection := "Provider=MSPersist"
   endif
   if ADORDDDefault() == "XML" .OR. cEXTENSAO == ".xml"// ADOXML .XML
      StrConnection := "Provider=MSDAOSP;Data Source="+StrDatabase+";" //MSXML2.DSOControl.2.6"
   endif
   if StrDriver = "XLS" .OR. cEXTENSAO == ".xls" // ADOXLS .XLS
      StrConnection := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+StrDatabase+";Extended Properties=Excel 8.0;HDR=Yes;IMEX=1" 
   endif
   if StrDriver = "REMOTE" // ADORDS
      StrConnection := "Provider=MS Remote;Remote Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+StrDatabase+";Remote Server=" + StrServer
   endif
   return StrConnection

*
*---------------------------------------------------------
Function ADORDDDefault()
   if cADORDD = nil
      cADORDD := "DBF"
   endif
   return cADORDD

*
*---------------------------------------------------------
Function ADOFile( cFile )
   if "XML" $ cADORDD .or. cADORDD = "XLS"
      return file( cFile )
   else
      oADOCatalog := oADOConection:OpenSchema(adSchemaTables)
      do while .not. oADOCatalog:EOF()
         if upper(alltrim(oADOCatalog:Fields( "TABLE_NAME" ):Value)) = upper(alltrim(cFile))
            return .t.
         endif
         oADOCatalog:MoveNext()
      enddo
   endif
   return .f.

*
*---------------------------------------------------------
Function ADOAlias()
   if nRecordSet < 1
      return ""
   else
      return aRecordSet[nRecordSet]
   endif

*
*---------------------------------------------------------
Function ADOFCount()
   if nRecordSet < 1
      return ""
   else
      return aRecordSet[nRecordSet]:Fields:Count()
   endif

*
*---------------------------------------------------------
Function ADOBEGINTRANSACTION()
   oADOConection:BeginTrans()
   return .t.

*
*---------------------------------------------------------
Function ADOCOMMITTRANSACTION()
   oADOConection:CommitTrans()
   return .t.

*
*---------------------------------------------------------
Function GetFieldType(FieldType)
   do Case
      Case FieldType = "C"
           return adVarWChar
      Case FieldType = "N"
           return adInteger
      Case FieldType = "M"
           return adText
      Case FieldType = "L"
           return adBoolean
      Case FieldType = "D"
           return adDate
   Endcase

*
*---------------------------------------------------------
Function ADOSetOrder( nIDXOrder )
   oRecordSet[nRecordSet]:Index = oADOIndex[nIDXOrder]:Name
   return .t.

*
*---------------------------------------------------------
Function ADODISConnect()
   oADOConection:Close()
   oADOErrDescription:Close()
   oADOIndex:Close()
   oADOCatalog:Close()
   oADOConection:End()
   oADOErrDescription:End()
   oADOIndex:End()
   oADOCatalog:End()
   return .t.

*
*---------------------------------------------------------
Function ADOAppend()
   oRecordSet[nRecordSet]:AddNew()
   return .t.

*
*---------------------------------------------------------
Function ADOEdit()
   oRecordSet[nRecordSet]:Edit()
   return .t.

*
*---------------------------------------------------------
Function ADOCommit( lSave )
   lSave := iif( lSave = nil, .f., lSave )
   oRecordSet[nRecordSet]:Update()
   if lSave
      oRecordSet[nRecordSet]:Save( alltrim(aRecordSet[nRecordSet]), adPersistXML )
   endif
   marca := oRecordSet[nRecordSet]:BookMark
   oRecordSet[nRecordSet]:Requery()
   oRecordSet[nRecordSet]:BookMark = marca
   return .t.

*
*---------------------------------------------------------
Function ADORequery()
   oRecordSet[nRecordSet]:Requery()
   return .t.

*
*---------------------------------------------------------
Function ADOReSync()
   oRecordSet[nRecordSet]:ReSync()
   return .t.

*
*---------------------------------------------------------
Function ADOUpdateBatch()
   oRecordSet[nRecordSet]:UpdateBatch()
   return .t.

*
*---------------------------------------------------------
Function ADOCommitAll()
   for i = 1 to len(aRecordSet)
       oRecordSet[nRecordSet]:Update()
   next
   return .t.

*
*---------------------------------------------------------
Function ADOSave( cfile )
   oRecordSet[nRecordSet]:Save( cFile, adPersistXML )
   return .t.

*
*---------------------------------------------------------
Function ADOReglock()
   //oRecordSet[nRecordSet]:CursorLocation := 2
   //oRecordSet[nRecordSet]:CursorType     := 0
   //oRecordSet[nRecordSet]:LockType       := 3
   return .t.

*
*---------------------------------------------------------
Function ADOSkip( nSkip )
   LOCAL nRec := oRecordSet[nRecordSet]:AbsolutePosition()
   oRecordSet[nRecordSet]:Move( iif( nSkip = nil, 1, nSkip ) )
   IF oRecordSet[nRecordSet]:EOF(); oRecordSet[nRecordSet]:MoveLast() ; ENDIF 
   IF oRecordSet[nRecordSet]:BOF(); oRecordSet[nRecordSet]:MoveFirst(); ENDIF 
   return oRecordSet[nRecordSet]:AbsolutePosition() - nRec

*
*---------------------------------------------------------
Function ADODelete()
   oRecordSet[nRecordSet]:Delete()
   oRecordSet[nRecordSet]:Move( -1 ) 
   if cADORDD == "XML" // ".XML" $ upper(aRecordSet[nRecordSet])
      oRecordSet[nRecordSet]:Save( alltrim(aRecordSet[nRecordSet]), adPersistXML )
   endif
   return .t.

*
*---------------------------------------------------------
Function ADOGoTo( nRec )
   //oRecordSet[nRecordSet]:BookMark :=  nRec 
   return .t.

*
*---------------------------------------------------------
Function ADOGoTop()
   if .not. ADOBof()
      if ADORecCount() > 0
         oRecordSet[nRecordSet]:MoveFirst()
      endif
   endif
   return .t.

*
*---------------------------------------------------------
Function ADOGoBottom()
   if .not. ADOEof()
      if ADORecCount() > 0
         oRecordSet[nRecordSet]:MoveLast()
      endif
   endif
   return .t.

*
*---------------------------------------------------------
Function ADOMoveNext()
   if .not. ADOEof()
      if ADORecCount() > 0
         oRecordSet[nRecordSet]:MoveNext()
      endif
   endif
   return .t.

*
*---------------------------------------------------------
Function ADORecno()
   if nRecordSet < 0
      return 0
   else
      return oRecordSet[nRecordSet]:AbsolutePosition()
   endif

*
*---------------------------------------------------------
Function ADORecCount()
   if nRecordSet < 1
      return 0
   else
      nRecord := oRecordSet[nRecordSet]:AbsolutePosition()
      nRecord := iif(nRecord=nil,-1,nRecord)
      if nRecord < 1 //.or. .not. ( oRecordSet[nRecordSet]:EOF() = oRecordSet[nRecordSet]:BOF() )
         return 0
      else
         return oRecordSet[nRecordSet]:RecordCount()
      endif
   endif

*
*---------------------------------------------------------
Function ADOSetFilter( xpr )
   if xpr = NIL
      oRecordSet[nRecordSet]:Filter := 0
   else
      oRecordSet[nRecordSet]:Filter := xpr
   endif
   return .t.

*
*---------------------------------------------------------
Function ADODeleted( criterio )
   if oRecordSet[nRecordSet]:Status = adRecDeleted
      return .t.
   endif
   return .f.

*
*---------------------------------------------------------
Function ADOClose()
   _RecordSet := len( aRecordSet )
   ADEL( aRecordSet, nRecordSet )
   ASIZE( aRecordSet, _RecordSet-1 )
   oRecordSet[nRecordSet]:End()
   return .t.

*
*---------------------------------------------------------
Function ADOCloseAll()
   for i = 1 to len(aRecordSet)
       oRecordSet[nRecordSet]:End()
   next
   aRecordSet := {}
   nRecordSet := 0
   return .t.

*
*---------------------------------------------------------
Function ADOExecute( cSql )
   aADODefines := {}
   AADD( aADODefines, { "VOID("   , "0(" } )
   AADD( aADODefines, { "BYTE("   , "1(" } )
   AADD( aADODefines, { "CHAR("   , "2(" } )
   AADD( aADODefines, { "WORD("   , "3(" } )
   AADD( aADODefines, { "INT("    , "7(" } )
   AADD( aADODefines, { "BOOLEAN(", "5(" } )
   AADD( aADODefines, { "HDC("    , "6(" } )
   AADD( aADODefines, { "LONG("   , "7(" } )
   AADD( aADODefines, { "STRING(" , "8(" } )
   AADD( aADODefines, { "LPSTR("  , "9(" } )
   AADD( aADODefines, { "PTR("    ,"10(" } )
   AADD( aADODefines, { "DOUBLE(" ,"11(" } )
   AADD( aADODefines, { "DWORD("  ,"12(" } )
   for i = 1 to len( aADODefines )
       cSql := StrTran( cSql, aADODefines[i][2], aADODefines[i][1] ) 
   next
   adolog( cSql )
   oADOConection:Execute( cSql )
   return .t.

*
*---------------------------------------------------------
Function ADOBOF()
   return iif( ADORecCount() > 0, oRecordSet[nRecordSet]:Bof, .t. )

*
*---------------------------------------------------------
Function ADOEOF()
   return iif( ADORecCount() > 0, oRecordSet[nRecordSet]:Eof, .t. )

*
*---------------------------------------------------------
Function ADOFOUND()
   return !oRecordSet[nRecordSet]:Eof

*
*---------------------------------------------------------
Function ADOFind( criterio )
   ADOLocate( criterio )
   return .t.

*
*---------------------------------------------------------
Function ADOLocate( criterio )
   local _nBookMark := oRecordSet[nRecordSet]:Bookmark 
   oRecordSet[nRecordSet]:MoveFirst() 
   oRecordSet[nRecordSet]:Find( criterio ) 
   if oRecordSet[nRecordSet]:Eof() 
      oRecordSet[nRecordSet]:BookMark := _nBookmark 
      return .f.
   else 
      return .t.
   endif

*
*---------------------------------------------------------
Function ADOSort( cField, nModo )
   if valtype(cField)='N'
      cField := oRecordSet[nRecordSet]:Fields( cStrField ):Name
   endi
   if cField = Nil
      Return upper(oRecordSet[nRecordSet]:Sort)
   else
      oRecordSet[nRecordSet]:Sort := cField + iif( nModo = NIL, " ASC", " DESC" )
      oRecordSet[nRecordSet]:MoveFirst() 
   endif
   return .t.

*
*---------------------------------------------------------
Function ADOFiles( cTable )
   return iif(oRecordSet[nRecordSet]:Table(cTable)==cTable,.t.,.f.)

*
*---------------------------------------------------------
Function ADOAREAS()
   return nRecordSet

*
*---------------------------------------------------------
Function ADOSelect( cRecordSet )
   if cRecordSet = nil
   else
      //oRecordSet[nRecordSet]:Close()
      if cADORDD = "XLS"
         cRecordSet := "[" + cRecordSet + "$]"
      endif
      nRecordSet := ASCAN( aRecordSet, cRecordSet )  
      nRecordSet := iif( nRecordSet = 0, 1, nRecordSet )
      //oRecordSet[nRecordSet]:Open( "Select * from " + cRecordSet, StrConnection, 3, 3 )
   endif
   //ADOGotop()
   return nRecordSet

*
*---------------------------------------------------------
Function ADOLOG( cMensagem )
   local nHandle
   if .not. file( "ADOERRO.TXT" )
      nHandle := fcreate("ADOERRO.TXT",0)
   else
      nHandle := fopen("ADOERRO.TXT",1)
      length  := fseek(nHandle,0,2)
      fseek(nHandle,length)
   endif
   fwrite(nHandle, cMensagem + chr(13) + chr(10) )
   fclose(nHandle)
   return NIL

*
*---------------------------------------------------------
Function ADOReplace( cCampo, xDado )
   LOCAL uVal,xValor,nTipo,cType,nLong,cQuery,lRepassa := .f., lBlob := .f.,;
         StrFileName
   uVal  := oRecordSet[nRecordSet]:Fields( cCampo ):Value
   nTipo := oRecordSet[nRecordSet]:Fields( cCampo ):Type
   cType := TypeDat(nTipo,cCampo)
   nLong := oRecordSet[nRecordSet]:Fields( cCampo ):DefinedSize
   if ! Empty( xDado )
      if ValType( xDado ) = 'D'
         if nTipo=  7 .or. nTipo=133 .or. nTipo=135
            if empty( xDado )
               xDado := date() 
            endif
            lRepassa := .t.
         endif
      endif
      if ValType( xDado ) = 'N'
         if nTipo=17 .or. nTipo= 14 .or. nTipo=  5 .or. nTipo=  3 .or. nTipo=131 .or. nTipo=  2 .or. nTipo=  6 .or. ;
            nTipo= 4 .or. nTipo=020 .or. nTipo=018 .or. nTipo=019 .or. nTipo= 21 .or. nTipo=138 .or. nTipo=139
            lRepassa := .t.
         endif
      endif
      if ValType( xDado ) = 'C'
         if nTipo=202 .or. nTipo=130 .or. nTipo=200 .or. nTipo=201 .or. nTipo=129 .or. nTipo= 72
            xDado := substr( xDado, 1, nLong )
            lRepassa := .t.
         endif
         if nTipo=201 .or. nTipo=203 .or. nTipo=205 .or. nTipo=128
            StrFileName := Alltrim(StrZero(ADORandom(99999999),8))+".APL"
            MemoWrit( StrFileName, xDado )
            lRepassa := .t.
            lBlob    := .t.
         endif
      endif
      if ValType( xDado ) = 'L'
         if nTipo= 11 .or. nTipo= 16
            lRepassa := .t.
         endif
      endif
      if ValType( xDado ) = 'M' .or. ValType( xDado ) = 'I'
         if nTipo=201 .or. nTipo=203 .or. nTipo=205 .or. nTipo=128
            lRepassa := .t.
            lBlob    := .t.
         endif
      endif
      if lRepassa
         //if lBlob // adolog( ccampo+"-"+ctype+"-"+strzero(ntipo,3)+"-"+ValType( xDado ) )
         //   oADOStream:Type := 1 // adTypeBinary
         //   oADOStream:Open()
         //   oADOStream:LoadFromFile( StrFileName )
         //   oRecordSet[nRecordSet]:Fields( cCampo ):Value := oADOStream:Read()
         //   oADOStream:Close()
         //else
            oRecordSet[nRecordSet]:Fields( cCampo ):Value := xDado
         //endif
         adolog( ccampo+"-"+ctype+"-"+strzero(ntipo,3)+"-"+ValType( xDado ) )
      endif
   endif
   return .t.

*
*---------------------------------------------------------
Function ADOField( cStrField )
   LOCAL uVal,nTipo,cType,nLong,xValor:=nil,StrFileName
   if valtype(cStrField)='C'
      cStrField := upper(alltrim(cStrField))
   endif
//?nRecordSet,oRecordSet[nRecordSet],cStrField:=lower(cStrField)
   if nRecordSet > 0
      uVal  := oRecordSet[nRecordSet]:Fields( cStrField ):Value
      nTipo := oRecordSet[nRecordSet]:Fields( cStrField ):Type
      cType := TypeDat(nTipo,cStrField)
      nLong := oRecordSet[nRecordSet]:Fields( cStrField ):DefinedSize
      //adolog( "Area:     "+str(nRecordSet,2)+CRLF+;
      //        "Campo:    "+ cStrField+CRLF+;
      //        "Tipo:     "+ctype+CRLF+;
      //        "Tipo(Num):"+strzero(ntipo,3)+CRLF+;
      //        "Conteudo: "+iif(ctype="C",uVal,"------")+CRLF )
      do case
         case cType='C'; xValor:=if(empty(uVal),spac(nLong),uVal+spac(nLong-len(uVal)))
         case cType='D'; xValor:=if(empty(uVal),ctod('')                    ,uVal)
         case cType='N'; xValor:=if(empty(uVal),0                           ,uVal)
         case cType='L'; xValor:=if(empty(uVal),.f.                         ,uVal)
         case cType='M' .or. cType='I'
              StrFileName := Alltrim(StrZero(ADORandom(99999999),8))+".APL"
              oADOStream:Type := 1 // adTypeBinary
              oADOStream:Open()
              oADOStream:Write( oRecordSet[nRecordSet]:Fields( cStrField ) )
              oADOStream:LoadFromFile( oRecordSet[nRecordSet]:Fields( StrFileName ), 2 ) // adSaveCreateOverWrite
              oADOStream:Close()
              xValor := MemoRead( StrFileName )
         otherwise     ; xValor:=         uVal
      endcase
   endif
   RETURN xValor

*
*---------------------------------------------------------
Function ADOFieldBlank( cStrField )
   LOCAL uVal,nTipo,cType,nLong,xValor:=nil
   if valtype(cStrField)='C'
      cStrField := upper(alltrim(cStrField))
   endif
   if nRecordSet > 0
      uVal  := oRecordSet[nRecordSet]:Fields( cStrField ):Value
      nTipo := oRecordSet[nRecordSet]:Fields( cStrField ):Type
      cType := TypeDat(nTipo,cStrField)
      nLong := oRecordSet[nRecordSet]:Fields( cStrField ):DefinedSize
      do case
         case cType='C'; xValor:=space(nLong)
         case cType='D'; xValor:=ctod('  /  /  ')
         case cType='N'; xValor:=0
         case cType='L'; xValor:=.f.
         otherwise     ; xValor:=''
      endcase
   endif
   RETURN xValor

*
*---------------------------------------------------------
Function TypeDat(nTipo,cField)
   do case
      case nTipo=8.or.nTipo=12.or.nTipo=72.or.nTipo=129.or.nTipo=130.or.(nTipo>=200.and.nTipo<=203)
           // adBSTR             8
           // adGUID             72
           // adChar             129
           // adWChar            130
           // adVarChar          200
           // adLongVarChar      201
           // adVarWChar         202
           // adLongVarWChar     203
           return 'C'

      case nTipo= 17.or.nTipo= 16.or.nTipo= 14.or.nTipo=  5.or.nTipo=  3.or.nTipo=131.or.nTipo= 2 .or.nTipo=  6.or.;
           nTipo=  4.or.nTipo=020.or.nTipo=018.or.nTipo=019.or.nTipo= 21.or.nTipo=138.or.nTipo=139
           // adSmallInt         2
           // adInteger          3
           // adSingle           4
           // adDouble           5
           // adCurrency         6
           // adDecimal          14
           // adTinyInt          16
           // adUnsignedTinyInt  17
           // adUnsignedSmallInt 18
           // adUnsignedInt      19
           // adBigInt           20
           // adUnsignedBigInt   21
           // adNumeric          131
           // adPropVariant      138
           // adVarNumeric       139
           return 'N' // Numerico

      case nTipo=  7.or.nTipo=64.or.nTipo=133.or.nTipo=134.or.nTipo=135
           // adDate             7
           // adFileTime         64
           // adDBDate           133
           // adDBTime           134
           // adDBTimeStamp      135
           return 'D' // Data

      case nTipo= 11
           // adBoolean          11
           return 'L' // Logico

      case nTipo=128.or.nTipo=201.or.nTipo=203.or.nTipo=205
           // adLongVarWChar     203
           // adPropVariant      138
           return 'M' // Memo

      case nTipo=128.or.nTipo=204.or.nTipo=205
           // adBinary           128
           // adVarBinary        204
           // adLongVarBinary    205
           return 'I' // Imagem

   otherwise
      alert('Tipo de dado invalido: Campo '+cField+' Type='+str(nTipo))
   endcase
   return 'U'

*
*---------------------------------------------------------
Function isRSEmpty()
   return ((oRecordSet[nRecordSet]:BOF()=.t.) .and. (oRecordSet[nRecordSet]:EOF()=.t.))

*
*---------------------------------------------------------
Function ADOGetSQL( sqlFileName )
   sqlFileName = sqlFileName + ".SQL"
   if file(sqlFileName)
      cSql := MemoRead( sqlFileName )
      oADOConection:Execute( cSql )
   endif 
   return nil

*
*---------------------------------------------------------
Function ADOUseRemote( cDatabase, lShared )
   local oError
   if cDatabase = NIL
      oRecordSet[nRecordSet]:Close()
   else
      AADD( aRecordSet, cDatabase )
      cRecordSet := cDatabase
      nRecordSet := len( aRecordSet )
      oRecordSet[nRecordSet] := oADOConection
      if cADORDD == "XML" // ".XML" $ upper(cDatabase)
         oRecordSet[nRecordSet]:Open( cDatabase, StrConnection, 1, 3 )
      else
         oRecordSet[nRecordSet]:CacheSize      := 50
         oRecordSet[nRecordSet]:CursorLocation := adUseClient
         if lShared = .t.
            oRecordSet[nRecordSet]:CursorType  := 1 // adOpenKeySet
            oRecordSet[nRecordSet]:LockType    := adLockBatchOptimistic
         else
            oRecordSet[nRecordSet]:CursorType  := adOpenStatic
            oRecordSet[nRecordSet]:LockType    := adLockPessimistic
         endif
         oRecordSet[nRecordSet]:Sql( "Select * from " + cDatabase, StrConnection )
      endif
      oRecordSet[nRecordSet]:MoveFirst()
   endif
   return .t.

function ADORandom( nMaximo )
   static nRandom
   local nTemporal
   nMaximo = if( nMaximo == NIL, 65535, nMaximo )
   if nRandom == NIL
      nRandom = seconds()
   endif
   nTemporal = ( nRandom * seconds() ) % ( nMaximo + 1 )
   nRandom = nTemporal + seconds()
   RETURN int( nTemporal )





/*
Function ADOAppendFrom( cStrField )
   //LOAD DATA LOCAL INFILE 'C:/Inetpub/wwwroot/websites/Gercred/planilhas/ok - Todas Tabela.csv' INTO TABLE epropost.tabela (RECNO,tabela,n2,n3,n4,n5,n6,n7,n8)

Function ADOZap( cTable )
   //TRUNCATE TABLE cTable

Index Append Method ************************************************************************

Attribute VB_Name = "IndexesAppend"
Option Explicit

' BeignCreateIndexVB
Sub Main()
    On Error GoTo CreateIndexError

    Dim tbl As New Table
    Dim idx As New ADOX.Index
    Dim cat As New ADOX.Catalog
    
    'Open the catalog.
    ' Open the Catalog.
    cat.ActiveConnection = "Provider='Microsoft.Jet.OLEDB.4.0';" & _
        "Data Source='Northwind.mdb';"
    
    ' Define the table and append it to the catalog
    tbl.Name = "MyTable"
    tbl.Columns.Append "Column1", adInteger
    tbl.Columns.Append "Column2", adInteger
    tbl.Columns.Append "Column3", adVarWChar, 50
    cat.Tables.Append tbl
    Debug.Print "Table 'MyTable' is added."
    
    ' Define a multi-column index
    idx.Name = "multicolidx"
    idx.Columns.Append "Column1"
    idx.Columns.Append "Column2"
    
    ' Append the index to the table
    tbl.Indexes.Append idx
    Debug.Print "The index is appended to table 'MyTable'."
    
    'Delete the table as this is a demonstration
    cat.Tables.Delete tbl.Name
    Debug.Print "Table 'MyTable' is deleted."
    
    'Clean up
    Set cat.ActiveConnection = Nothing
    Set cat = Nothing
    Set tbl = Nothing
    Set idx = Nothing
    Exit Sub
    
CreateIndexError:
    Set cat = Nothing
    Set tbl = Nothing
    Set idx = Nothing
    
    If Err <> 0 Then
        MsgBox Err.Source & "-->" & Err.Description, , "Error"
    End If
End Sub
' EndCreateIndexVB

Primary and Unique Key Example ************************************************************************

' BeginPrimaryKeyVB
Sub Main()
    On Error GoTo PrimaryKeyXError

    Dim catNorthwind As New ADOX.Catalog
    Dim tblNew As New ADOX.Table
    Dim idxNew As New ADOX.Index
    Dim idxLoop As New ADOX.Index
    Dim colLoop As New ADOX.Column
    
    ' Connect the catalog
    catNorthwind.ActiveConnection = "Provider='Microsoft.Jet.OLEDB.4.0';" & _
        "Data Source='Northwind.mdb';"
    
    ' Name new table
    tblNew.Name = "NewTable"
    
    ' Append a numeric and a text field to new table.
    tblNew.Columns.Append "NumField", adInteger, 20
    tblNew.Columns.Append "TextField", adVarWChar, 20
    
    ' Append new Primary Key index on NumField column
    ' to new table
    idxNew.Name = "NumIndex"
    idxNew.Columns.Append "NumField"
    idxNew.PrimaryKey = True
    idxNew.Unique = True
    tblNew.Indexes.Append idxNew
    
    ' Append an index on Textfield to new table.
    ' Note the different technique: Specifying index and
    ' column name as parameters of the Append method
    tblNew.Indexes.Append "TextIndex", "TextField"
    
    ' Append the new table
    catNorthwind.Tables.Append tblNew
    
    With tblNew
        Debug.Print tblNew.Indexes.Count & " Indexes in " & _
            tblNew.Name & " Table"

        ' Enumerate Indexes collection.
        For Each idxLoop In .Indexes
            With idxLoop
                Debug.Print "Index " & .Name
                Debug.Print "   Primary key = " & .PrimaryKey
                Debug.Print "   Unique = " & .Unique

                ' Enumerate Columns collection of each Index
                ' object.
                Debug.Print "    Columns"
                For Each colLoop In .Columns
                    Debug.Print "       " & colLoop.Name
                Next colLoop
            End With
        Next idxLoop

    End With

    ' Delete new table as this is a demonstration.
    catNorthwind.Tables.Delete tblNew.Name
    
    'Clean up
    Set catNorthwind.ActiveConnection = Nothing
    Set catNorthwind = Nothing
    Set tblNew = Nothing
    Set idxNew = Nothing
    Set idxLoop = Nothing
    Set colLoop = Nothing
    Exit Sub
    
PrimaryKeyXError:
    
    Set catNorthwind = Nothing
    Set tblNew = Nothing
    Set idxNew = Nothing
    Set idxLoop = Nothing
    Set colLoop = Nothing
    
    If Err <> 0 Then
        MsgBox Err.Source & "-->" & Err.Description, , "Error"
    End If
End Sub
' EndPrimaryKeyVB

Create new database example ************************************************************************

Attribute VB_Name = "Create"
Option Explicit

' BeginCreateDatabseVB
Sub CreateDatabase()
    On Error GoTo CreateDatabaseError
    
    Dim cat As New ADOX.Catalog
    cat.Create "Provider='Microsoft.Jet.OLEDB.4.0';Data Source='new.mdb'"

    'Clean up
    Set cat = Nothing
    Exit Sub
    
CreateDatabaseError:
    Set cat = Nothing

    If Err <> 0 Then
        MsgBox Err.Source & "-->" & Err.Description, , "Error"
    End If
End Sub
' EndCreateDatabaseVB

Sort Order Property Example ************************************************************************

' BeginSortOrderVB
Sub Main()
    On Error GoTo SortOrderXError

    Dim cnn As New ADODB.Connection
    Dim catNorthwind  As New ADOX.Catalog
    Dim idxAscending  As New ADOX.Index
    Dim idxDescending As New ADOX.Index
    Dim rstEmployees  As New ADODB.Recordset
        
    ' Connect the catalog.
    cnn.Open "Provider='Microsoft.Jet.OLEDB.4.0';" & _
        "Data Source='Northwind.mdb';"
    Set catNorthwind.ActiveConnection = cnn

    ' Append Country column to new index
    idxAscending.Columns.Append "Country"
    idxAscending.Columns("Country").SortOrder = adSortAscending
    idxAscending.Name = "Ascending"
    idxAscending.IndexNulls = adIndexNullsAllow
    
    'Append new index to Employees table
    catNorthwind.Tables("Employees").Indexes.Append idxAscending
    
    rstEmployees.Index = idxAscending.Name
    rstEmployees.Open "Employees", cnn, adOpenKeyset, _
        adLockOptimistic, adCmdTableDirect
        
    With rstEmployees
        .MoveFirst
        Debug.Print "Index = " & .Index
        Debug.Print "  Country - Name"

        ' Enumerate the Recordset. The value of the
        ' IndexNulls property will determine if the newly
        ' added record appears in the output.
        Do While Not .EOF
            Debug.Print "    " & !Country & " - " & _
                !FirstName & " " & !LastName
            .MoveNext
        Loop

        .Close
    End With

    ' Append Country column to new index
    idxDescending.Columns.Append "Country"
    idxDescending.Columns("Country").SortOrder = adSortDescending
    idxDescending.Name = "Descending"
    idxDescending.IndexNulls = adIndexNullsAllow
    
    'Append descending index to Employees table
    catNorthwind.Tables("Employees").Indexes.Append idxDescending
    
    rstEmployees.Index = idxDescending.Name
    rstEmployees.Open "Employees", cnn, adOpenKeyset, _
        adLockOptimistic, adCmdTableDirect
                
    With rstEmployees
        .MoveFirst
        Debug.Print "Index = " & .Index
        Debug.Print "  Country - Name"
        
        ' Enumerate the Recordset. The value of the
        ' IndexNulls property will determine if the newly
        ' added record appears in the output.
        Do While Not .EOF
            Debug.Print "    " & !Country & " - " & _
                !FirstName & " " & !LastName
            .MoveNext
        Loop
        
        .Close
    End With
       
    ' Delete new Indexes because this is a demonstration.
    catNorthwind.Tables("Employees").Indexes.Delete idxAscending.Name
    catNorthwind.Tables("Employees").Indexes.Delete idxDescending.Name
    
    'Clean up
    cnn.Close
    Set catNorthwind = Nothing
    Set idxAscending = Nothing
    Set idxDescending = Nothing
    Set rstEmployees = Nothing
    Set cnn = Nothing
    Exit Sub
    
SortOrderXError:
    
    Set catNorthwind = Nothing
    Set idxAscending = Nothing
    Set idxDescending = Nothing

    If Not rstEmployees Is Nothing Then
        If rstEmployees.State = adStateOpen Then rstEmployees.Close
    End If
    Set rstEmployees = Nothing
    
    If Not cnn Is Nothing Then
        If cnn.State = adStateOpen Then cnn.Close
    End If
    Set cnn = Nothing
    
    If Err <> 0 Then
        MsgBox Err.Source & "-->" & Err.Description, , "Error"
    End If
End Sub
' EndSortOrderVB

Function GetCursorType(CursorType As Integer) As String
    
    ' *******************
    ' CursorTypeEnum
    '
    ' adOpenDynamic = 2
    ' adOpenForwardOnly = 0
    ' adOpenKeyset = 1
    ' adOpenStatic = 3
    ' adOpenUnspecified = -1
    '*******************
    
    Select Case CursorType
        Case 2
            GetCursorType = "Dynamic"
        Case 0
            GetCursorType = "ForwardOnly"
       Case 1
            GetCursorType = "Keyset"
        Case 3
            GetCursorType = "Static"
        Case -1
            GetCursorType = "Unspecified"
    End Select

End Function
        
Function GetLockType(LockType As Integer) As String
    
    '*******************
    ' LockTypeEnum
    '
    ' adLockBatchOptimistic = 4
    ' adLockOptimistic = 3
    ' adLockPessimistic = 2
    ' adLockReadOnly = 1
    ' adLockUnspecified = -1
    '*******************
    
    Select Case LockType
        Case 4
            GetLockType = "BatchOptimistic"
        Case 3
            GetLockType = "Optimistic"
       Case 2
            GetLockType = "Pessimistic"
        Case 1
            GetLockType = "ReadOnly "
        Case -1
            GetLockType = "Unspecified"
    End Select

End Function
*/
