// +--------------------------------------------------------------------
// +
// +    Programa  : sql2dbf.prg
// +
// +     Sistema: DBU
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:08 am
// +
// +--------------------------------------------------------------------
// +

#include "dbstruct.ch"
#include "BOX.CH"
#include "dbinfo.ch"
#include "hbVER.CH"

#require "hbsqlit3"
#require "hbmemio"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sqlitemenu()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sqlitemenu()

   PUBLIC oDB         := nil
   PUBLIC oDB1        := nil
   PRIVATE cTableName := ''
   PRIVATE cNewTable  := ''
   PRIVATE lOpened    := .F.

   loledb    := hb_Version( HB_VERSION_BITWIDTH ) <> 64
   lMDB      := .F.
   lACCDB    := .F.
   cTIPOSQL  := "SQLITE"
   aAMBIENTE := SALVAA()

   WHILE .T.
      hb_DispBox( 3, 22, 22, 55, B_DOUBLE + " " )
      OPCAO( 4, 24, "&Criar base sqllite        ", 67 )   // c
      OPCAO( 5, 24, "&VACUUM (PACK)             ", 86 )   // V
      OPCAO( 6, 24, "&Importar  DBF             ", 73 )   // I
      OPCAO( 7, 24, "&Exportar  DBF             ", 69 )   // E
      OPCAO( 8, 24, "&Tabelas                   ", 84 )   // T
      OPCAO( 9, 24, "&Apagar Tabela             ", 65 )   // A
      OPCAO( 10, 24, "Exportar &Formatos         ", 70 )  // F
      KEY := menu( 1, 0 )
      DO CASE
      CASE KEY = 1
         createSqlitedb()
      CASE KEY = 2
         IF selectdb()
            sqlitepack( odb )
         ENDIF
      CASE KEY = 3
         IF selectdb()
            nOLDTIPO := TIPODBF
            alertX( "escolha origem" )
            tipodbfesc()
            nORITIPO   := TIPODBF
            cORIDRIVER := RDDNOME( TIPODBF )
            cARQORI    := win_GetOpenFileName(, "Arquivos de Origem", hb_cwd(), "Arquivos de Origem", "*.dbf", 1 )
            IF File( cARQORI )
               export2sql( odb, cARQORI )
               RDDNOME( nOLDTIPO )   // retorna tipo anterior
            ENDIF
         ENDIF
      CASE KEY = 4
         IF selectdb()
            exportadbf( odb, 1 )
         ENDIF
      CASE KEY = 5
         IF selectdb()
            SqliteTables( odb )
         ENDIF
      CASE KEY = 6
         IF selectdb()
            SqliteTables( odb )
            sqllitedeltable( odb )
         ENDIF
      CASE KEY = 7
         IF selectdb()
            exportadbf( odb, 2 )
         ENDIF
      OTHERWISE
         RETURN
      ENDCASE
   ENDDO

   RESTAA( aAMBIENTE )
   layout()

   RETURN NIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sqllitedeltable()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sqllitedeltable( db )

   IF ! MDG( "Apagar Tabela" + cTABELAX )
      RETURN .F.
   ENDIF
   IF sqlite3_exec( db, "DROP TABLE  " + cTABELAX ) == SQLITE_OK
      MDT( Ctabelax + " Excluida" )
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function exportadbf()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION exportadbf( db, ntipo )

   LOCAL cTABELAEXP

   IF nTIPO = 2
      LCOPIANAT := .F.   // MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado PGsqlrddd
      tDOC      := pegtipodoc()  // .t. Inclui dbf se for nativa
      pegparexp()
      lDOCCAB   := .F.
      lDOCDAD   := .F.
      lDOCRECNO := .F.
      cSUBTIPO  := " "
   ENDIF
   IF MDG( "Todas(SIM) Escolher Nao" )
      aTable := sqltablestru( DB, "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name" )
      IF Len( aTable ) == 0
         msgstop( 'No Tables in the DB', 'DBF<-->SQLite Exporter' )
         RETURN NIL
      ENDIF
      FOR i := 1 TO Len( aTable )
         MDT( aTable[ i, 1 ] )
         Export2dbf( DB, aTable[ i, 1 ], ntipo )
      NEXT i
   ELSE
      cTABELAEXP := SQLITETABLES( DB )
      IF !Empty( cTABELAEXP )
         Export2dbf( DB, cTABELAEXP, Ntipo )
      ENDIF
   ENDIF

   RETURN NIL


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function C2SQLTS
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
Function C2SQLTS (dpDate,cpTime)

LOCAL cDate := ""
LOCAL cTime := ""
LOCAL cRetu := ""

	If Pcount () == 0

		cDate := DtoS (Date ())
		cTime := Time ()

	Else
	
		DO Case
		
			Case Pcount () == 1
			
				cDate := DtoS (dpDate)
				cTime := "23:59:59"
				
			Case Pcount () == 2
		
				cDate := DtoS (dpDate)
				cTime := AllTrim (cpTime)
				
		EndCase
		
	EndIf
	
	cRetu := "'"+subStr(cDate,1,4)+"-"+subStr(cDate,5,2)+"-"+subStr(cDate,7,2)+" "+cTime+"'"

Return cRetu


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function C2SQL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION C2SQL( Value )

   LOCAL cValue := ""
   LOCAL cdate  := ""

   IF ValType( value ) == "C" .AND. Len( AllTrim( value ) ) > 0
      value := StrTran( value, "'", "''" )
   ENDIF
   DO CASE
   CASE ValType( Value ) == "N"
      cValue := AllTrim( Str( Value ) )
   CASE ValType( Value ) == "@"    //Datetime
       cValue :=C2SQLTS( Value)
   CASE ValType( Value ) == "D"
      IF !Empty( Value )
         cdate  := DToS( value )
         cValue := "'" + SubStr( cDate, 1, 4 ) + "-" + SubStr( cDate, 5, 2 ) + "-" + SubStr( cDate, 7, 2 ) + "'"
      ELSE
         cValue := "''"
      ENDIF
   CASE ValType( Value ) $ "CM"
      IF Empty( Value )
         cValue := "''"
      ELSE
         // troca caracteres ',() usados pelo sql language
         cVALUE := StrTran( cVALUE, "'", " " )
         cVALUE := StrTran( cVALUE, ",", " " )
         cVALUE := StrTran( cVALUE, "(", " " )
         cVALUE := StrTran( cVALUE, ")", " " )
         cVALUE := AllTrim( cVALUE )
         cValue := "'" + value + "'"
      ENDIF
   CASE ValType( Value ) == "L"
      cValue := AllTrim( Str( iif( Value == .F., 0, 1 ) ) )
   OTHERWISE
      cValue := "''"   // NOTE: Here we lose values we cannot convert
   ENDCASE

   RETURN cValue



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sqltablestru()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sqltablestru( dbo1, qstr )

   LOCAL table    := {}
   LOCAL stmt
   LOCAL currow   := nil
   LOCAL tablearr := {}
   LOCAL rowarr   := {}
   LOCAL typesarr := {}
   LOCAL cdate    := ""
   LOCAL current  := ""
   LOCAL i        := 0
   LOCAL j        := 0
   LOCAL type1    := ""

   IF Empty( dbo1 )
      msgstop( "Database Connection Error!" )
      RETURN tablearr
   ENDIF
   table := sqlite3_get_table( dbo1, qstr )
   IF sqlite3_errcode( dbo1 ) > 0  // error
      msgstop( sqlite3_errmsg( dbo1 ) + " Query is : " + qstr )
      RETURN NIL
   ENDIF
   stmt := sqlite3_prepare( dbo1, qstr )
   IF !Empty( stmt )
      FOR i := 1 TO sqlite3_column_count( stmt )
         type1 := Upper( AllTrim( sqlite3_column_decltype( stmt, i ) ) )
         DO CASE
         CASE type1 == "INTEGER" .OR. type1 == "REAL" .OR. type1 == "FLOAT" .OR. type1 == "DOUBLE" .OR. type1 == "INT" .OR. type1 == "SMALLINT"
            AAdd( typesarr, "N" )
         CASE type1 == "DATE" .OR. type1 == "DATETIME" .OR. type1 == "TIMESTAMP"
            AAdd( typesarr, "D" )
         CASE type1 == "BOOL"
            AAdd( typesarr, "L" )
         OTHERWISE
            AAdd( typesarr, "C" )
         ENDCASE
      NEXT i
   ENDIF
   sqlite3_reset( stmt )
   IF Len( table ) > 1
      ASize( tablearr, 0 )
      FOR i := 2 TO Len( table )
         rowarr := table[ i ]
         FOR j := 1 TO Len( rowarr )
            DO CASE
            CASE typesarr[ j ] == "D"
               cDate       := SubStr( rowarr[ j ], 1, 4 ) + SubStr( rowarr[ j ], 6, 2 ) + SubStr( rowarr[ j ], 9, 2 )
               rowarr[ j ] := SToD( cDate )
            CASE typesarr[ j ] == "N"
               rowarr[ j ] := Val( rowarr[ j ] )
            CASE typesarr[ j ] == "L"
               IF Val( rowarr[ j ] ) == 1
                  rowarr[ j ] := .T.
               ELSE
                  rowarr[ j ] := .F.
               ENDIF
            ENDCASE
         NEXT j
         AAdd( tablearr, AClone( rowarr ) )
      NEXT i
   ENDIF

   RETURN tablearr


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function sqlitepack()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION sqlitepack( db )

   IF !Empty( db )
      IF sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
         MDT( "VACUUM PACK - Done" )
         // sqlite3_sleep( 3000 )
      ENDIF
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function selectdb()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION selectdb

   LOCAL cFileName := ''
   LOCAL cDBName   := ''
   LOCAL nSlash    := 0
   LOCAL nDot      := 0
   LOCAL lRETU     := .F.

   cFileName := win_GetOpenFileName(, "SQLite Files", hb_cwd(), "SQLite", ;
      { { 'SQLite', '*.sqlite' }, { 'SQLite db', '*.DB' }, ;
      { 'SQLite3', '*.sqlite3' }, { 'SQLite db3', '*.DB3' }, ;
      { 'SQLite Fossil', '*.fossil' }, { 'All Files', '*.*' } }, 1 )

   IF Len( AllTrim( cFileName ) ) > 0
      cDBName := tiraext( cFileName )
      oDB     := Connect2DB( cFileName, .F. )
      IF oDB == Nil
         msgstop( 'Not a valid SQLite file.', 'SQLite File Selection' )
         RETURN .F.
      ELSE
         lRETU := .T.
         // MDT(" is Connected! Version: "+cFILENAME) //+ valtostr(sqlite3_libversion_number())

         mdt( cFILENAME + "Version library = " + sqlite3_libversion() + ;
            "number version library = " + LTrim( Str( sqlite3_libversion_number() ) ) )

      ENDIF
   ELSE
      msgstop( 'You have to select a SQLite File!', 'SQLite File Selection' )
      RETURN lRETU
   ENDIF

   RETURN lRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SqliteTables()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SqliteTables( DB )

// ---------------------------------------------------------------------------
// Shows all tables inside the database
// ---------------------------------------------------------------------------
   LOCAL aResult, nChoices, I, aRETU
   LOCAL aAMBIENTE
   nChoices  := 0
   aAMBIENTE := SALVAA()
   aRESULT   := {}

// Show all tables inside database
   aRETU := sqltablestru( DB, "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name" )

   FOR i := 1 TO Len( aRETU )
      AAdd( aRESULT, aRETU[ i, 1 ] )
   NEXT i


   IF Len( aResult ) > 0
      hb_DispBox( 3, 22, 22, 55, B_DOUBLE + " " )
      nChoices := AChoice( 4, 23, 21, 54, aResult )
   ENDIF

   RESTAA( aAMBIENTE )

   RETURN ( iif( nChoices > 0, aResult[ nChoices ], "" ) )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function connect2db()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION connect2db( dbname, lCreate )

   LOCAL dbo1 := sqlite3_open( dbname, lCreate )

   IF Empty( dbo1 )
      alertx( "Database could not be connected!" )
      RETURN NIL
   ENDIF

   RETURN dbo1



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function createSqlitedb()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION createSqlitedb

   LOCAL cFileName := ''
   LOCAL cDBName   := ''
   LOCAL nSlash    := 0
   LOCAL nDot      := 0

   cFileName := win_GetsaveFileName(, "SQLite Files", hb_cwd(), "SQLite", ;
      { { 'SQLite', '*.sqlite' }, { 'SQLite db', '*.DB' }, ;
      { 'SQLite3', '*.sqlite3' }, { 'SQLite db3', '*.DB3' }, ;
      { 'SQLite Fossil', '*.fossil' }, { 'All Files', '*.*' } }, 1 )


   IF Len( AllTrim( cFileName ) ) == 0
      msgstop( 'File name can not be empty!', 'DBF2SQLite Exporter' )
      RETURN NIL
   ENDIF
   IF At( '.', cFileName ) == 0
      cFileName := cFileName + '.sqlite'
   ENDIF
   IF File( cFileName )
      alertx( "Arquivo ja existe" )
      RETURN
   ENDIF
   cDBName := tiraext( cFileName )
   oDB     := Connect2DB( cFileName, .T. )
   IF oDB == Nil
      msgstop( 'Not a valid SQLite file.', 'SQLite File Selection' )
      RETURN NIL
   ELSE
      mdt( cDBName + " is Connected!" )
   ENDIF

   RETURN NIL


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function export2dbf()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION export2dbf( ODB1, cNEWTABLE, Ntipo )

   LOCAL aTable       := {}
   LOCAL aTable1      := {}
   LOCAL cSQLTable    := {}
   LOCAL aStruct      := {}
   LOCAL cType        := ''
   LOCAL cFieldName   := ''
   LOCAL cFieldType   := ''
   LOCAL nFieldLength := ''
   LOCAL nFieldDec    := ''
   LOCAL nLength      := 0
   LOCAL aRecord      := {}
   LOCAL cINDEXNAME   := ""
   LOCAL i, j

   IF Len( AllTrim( cNewTable ) ) == 0
      msgstop( 'You have to select a DBF to export', 'DBF<-->SQLite Exporter' )
      RETURN NIL
   ENDIF
   IF Len( cNEWTABLE ) > 0
      cSQLTable := cNEWTABLE
      aTable    := sqltablestru( oDB1, 'PRAGMA table_info( ' + c2sql( cSQLTable ) + ')' )
      IF Len( aTable ) == 0
         msgstop( 'This is an empty table!' )
         RETURN NIL
      ENDIF
      FOR i := 1 TO Len( aTable )
         // table info colunas
         // cid, name, type, "notnull", dflt_value, pk
         // 1    2     3      4           5         6
         cFieldType   := Upper( AllTrim( aTable[ i, 3 ] ) )
         cFieldName   := AllTrim( aTable[ i, 2 ] )
         nFieldLength := 0
         nFieldDec    := 0


         aTMP := geracampodbf( cFieldName, cFieldType, nFieldLength, nFieldDec )



         IF aTMP[ DBS_LEN ] = 0 .OR. aTMP[ DBS_LEN ] = 250   // text geracampo volta 250 tentando ajustar o valor mais proximo
            aTable1 := sqltablestru( oDB1, 'select max( length( ' + cFieldName + ' ) ) from ' + c2sql( cSQLTable ) )
            IF Len( aTable1 ) > 0
               aTMP[ DBS_LEN ] := Val( AllTrim( aTable1[ 1, 1 ] ) )
            ENDIF
         ENDIF

         AAdd( aStruct, aTMP )
         // aadd( aStruct, { cFieldName, cFieldType, nFieldLength, nFieldDec } )
      NEXT i
      IF Len( aStruct ) > 0
         // cNEWARQ:=cNEWTABLE+"_exp"
         IF ntipo = 1
            dbCreate( cNewTable, aStruct, "DBFCDX" )
            dbUseArea( .T., "DBFCDX", cNewTable, "DESTINO", .T., .F. )
         ELSE
            dbCreate( "mem:destino", aStruct,, .T., "DESTINO" )
         ENDIF

         // use &cNewTable
         IF ! Used()
            msgstop( 'DBF File Creation error!', 'DBF<-->SQLite Exporter' )
            RETURN NIL
         ENDIF
         aTable   := sqltablestru( oDB1, 'select * from ' + c2sql( cSQLTable ) )
         nLASTREC := Len( aTable )
         zei_fort( nLASTREC,,, 0 )
         FOR i := 1 TO nLASTREC
            zei_fort( nLASTREC,,, 1 )
            netrecapp()  // append blank
            aRecord := aTable[ i ]
            FOR j := 1 TO Len( aRecord )
               cFieldName := Left( aStruct[ j, 1 ], 10 )   // dbf nome maximo dez caracteres
               REPLACE &cFieldName WITH aRecord[ j ]
            NEXT j
         NEXT i
         dbCommit()
         dbUnlock()
         mdt( "Successfully exported" + cNEWTABLE )

         IF nTIPO = 2
            cDESTINO := cSQLTable + "_sqlite" + zEXPOREXT
            MDT( cDESTINO )
            dbSelectAr( "DESTINO" )
            nLASTREC := LastRec()
            zei_fort( nLASTREC,,, 0 )
            dbGoTop()
            multidocg( lDOCCAB, lDOCDAD, lDOCRECNO, cSUBTIPO, TIRAEXT( cDESTINO ), aStruct )
         ENDIF

         dbCloseAll()  // close all
         IF nTIPO = 2
            dbDrop( "mem:destino" )
         ENDIF
         cNewTable := ''
      ENDIF
   ELSE
      msgstop( 'You have to select a Table to export!', 'DBF<-->SQLite Exporter' )
      RETURN NIL
   ENDIF

   RETURN NIL


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function miscsql()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION miscsql( dbo1, qstr )

   IF Empty( dbo1 )
      msgstop( "Database Connection Error!" )
      RETURN .F.
   ENDIF
   sqlite3_exec( dbo1, qstr )
   IF sqlite3_errcode( dbo1 ) > 0  // error
      msgstop( sqlite3_errmsg( dbo1 ) + " Query is : " + qstr )
      RETURN .F.
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function export2sql()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION export2sql( odb, cDBFFILE )

   LOCAL aStruct := {}, i, j, mFldNm, mFldtype, mFldLen, mFldDec, mSql
   LOCAL totrec, nrec, nIndexes

   IF oDB == nil
      msgstop( "No Connection to SQLite DB! Try to create a new SQLite DB or select an existing SQLite DB", 'DBF->SQLite Exporter' )
      RETURN NIL
   ENDIF

   IF ! File( cDBFFILE )
      RETURN NIL
   ENDIF


   cTablename := TIRAEXT( cDBFFILE )
// use &cTablename.


 dbUseArea( .T., ( cORIDRIVER ), ( cARQORI ), "ORIGEM", .T. , .F. )
  // USE ( cARQORI ) ALIAS ORIGEM SHARED NEW VIA ( cORIDRIVER )
// USE (cDBFFILE)  SHARED NEW //VIA  (cORIDRIVER)

   aStruct := dbStruct()

// criado funcao para usar tambem no dbudoc

   mSQL := SqliteCreateTable( cTablename, aStruct, "SQLITE" )


   IF !miscsql( oDB, mSql )
      alertx( 'Table Creation Error!', 'DBF2SQLite' )
      RETURN NIL
   ENDIF


   nIndexes := dbOrderInfo( DBOI_ORDERCOUNT )
   FOR j := 1 TO nIndexes
      // CREATE INDEX idx_student_name ON Students (name);
      cINDEXNAME := dbOrderInfo( DBOI_NAME,, j )
      cINDEXNAME := StrTran( cINDEXNAME, "-", "_" )  // Tracos nao aceitos trocando por undescore
      msql       := "create index " + cINDEXNAME + " on " + cTablename + " ( " + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION,, j ) ) + " ) ;"
      // DbOrderInfo( <nDefine> , <cIndexFile> , <nOrder_or_cIndexName> , <xNewSetting> ) -> xCurrentSetting
      // AAdd( aNtxNames ,  dbORDERINFO( DBOI_NAME , ,  j )+" - "+dbORDERINFO( DBOI_EXPRESSION , ,  j ) )
      IF !miscsql( oDB, mSql )
         MemoWrit( "sql" + StrZero( j, 2, 0 ) + ".txt", msql )
      ENDIF
   NEXT j


   nLASTREC := RecCount()  // NetRegCount(cOLDDBF)
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   IF !miscsql( oDB, 'begin transaction' )
      RETURN NIL
   ENDIF
   DO WHILE !Eof()
      zei_fort( nLASTREC,,, 1 )

      mSql := "INSERT INTO " + cTablename + " VALUES "
      msql := msql + "("
      FOR i := 1 TO Len( aStruct )
         mFldNm := aStruct[ i, DBS_NAME ]
         IF i > 1
            mSql += ", "
         ENDIF
         mSql += c2sql( &mFldNm )
      NEXT
      mSql += ")"
      IF ! miscsql( oDB, mSql )
         alertx( "Problem in Query: " + mSql )
         RETURN NIL
      ENDIF
      dbSkip()
   ENDDO
   IF !miscsql( oDB, 'end transaction' )
      RETURN NIL
   ENDIF
   dbCloseAll()

   RETURN NIL





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDPCHAVEI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MDPCHAVEI( cICHAVE )   // Cria string campo1,campo2,... para create index em sql

   LOCAL nPOS
   LOCAL cCHAVE
   LOCAL cTMPCHV
   LOCAL aICampos
   LOCAL I

   cCHAVE   := ""
   aicampos := hb_ATokens( cICHAVE, "+" )
   FOR I := 1 TO Len( aICampos )
      cTMPCHV := aICampos[ I ]
      nPOS    := At( "(", cTMPCHV )
      IF nPOS >= 0
         cTMPCHV := SubStr( cTMPCHV, nPOS + 1 )
      ENDIF
      nPOS := At( "(", cTMPCHV )
      IF nPOS > 0
         cTMPCHV := SubStr( cTMPCHV, nPOS + 1 )
      ENDIF
      nPOS := At( ")", cTMPCHV )
      IF nPOS > 0
         cTMPCHV := SubStr( cTMPCHV, 1, nPOS - 1 )
      ENDIF
      nPOS := At( ",", cTMPCHV )
      IF nPOS > 0
         cTMPCHV := SubStr( cTMPCHV, 1, nPOS - 1 )
      ENDIF
      cCHAVE += cTMPCHV
      IF I <> Len( aICAMPOS )
         cCHAVE += ","
      ENDIF
   NEXT I

   RETURN cCHAVE


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
FUNCTION SqliteCreateTable( cTablename, aStruct, cTIPOSQL )

   LOCAL mSQL
   LOCAL i

   IF ValType( cTIPOSQL ) <> "C"
      cTIPOSQL := "SQLITE"
   ENDIF

   msql := ""
   IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"  // postgree e case sensitive deixando em maisuclav
      cTABLENAME := Upper( cTABLENAME )
   ENDIF
   IF cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64"
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
         // C  == Caracter
         //
      CASE mFldType = "C" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         mSql += "VARCHAR2 (" + LTrim( Str( mFldLen ) ) + ")"
      CASE mFldType = "C" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" ;
            .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "VARCHAR(" + LTrim( Str( mFldLen ) ) + ")"
      CASE mFldType = "C" .AND. cTIPOSQL = "SQLITE"
         mSql += "TEXT "
      CASE mFldType = "C"
         mSql += "CHAR(" + LTrim( Str( mFldLen ) ) + ")"
         //
         //
         // V = Varchar and Varchar (Binary)
      CASE mFldType = "V" .AND. ( cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         IF mFldDec > 0
            mSql += "TEXT(" + hb_ntos( mFldDec ) + ")"
         ELSE
            mSql += "TEXT "
         ENDIF
      CASE mFldType = "V" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "VARCHAR(" + hb_ntos( mFldDec ) + ")"

         //
         // D = date  @= datetime
         //
      CASE mFldType = "D" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "TIMESTAMP"

      CASE mFldType = "D" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" ;
            .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "DATETIME"
      CASE mFldType = "D"
         mSql += "DATE"
         //
         // T - TIME
         //
      CASE mFldType = "T" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "FIREBIRD" )
         mSql += "TIMESTAMP"
      CASE mFldType = "T"
         mSql += "DATETIME"


         //
         // N = NUMERIC
         // Inteiro
         // numerico ->INTEGER LONG BIGINT
         //
         // com decimais
         // Numerico ->FLOAT DOUBLE NUMERIC
         //
      CASE mFldType = "N" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         IF mFldDec > 0
            mSql += "NUMBER(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         ELSE
            mSql += "NUMBER(" + hb_ntos( mFldLen ) + ")"
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

      CASE mFldType = "N" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" )
         IF mFldDec > 0
            mSql += "DOUBLE"
         ELSE
            mSql += "LONG"
         ENDIF
      CASE mFldType = "N" .AND. cTIPOSQL = "SQLITE"
         IF mFldDec > 0
            mSql += "FLOAT"
         ELSE
            mSql += "INTEGER"
         ENDIF

      CASE mFldType = "N" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "FIREBIRD" )
         IF mFldDec > 0
            mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         ELSE
            IF mFldLen <= 9
               mSql += "INTEGER(" + hb_ntos( mFldLen ) + ")"
            ELSE
               mSql += "bigint(" + hb_ntos( mFldLen ) + ")"
            ENDIF
         ENDIF
         //
         // F= float
         //
      CASE ( mFldType = "F" .OR. mFldType = "Y" ) .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" ;
            .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" )
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
         mSql += "FLOAT"
         //
         // Y= CURRENCY MOEDA
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
         // I = integer LONG
         //
      CASE mFldType = "I" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" )
         mSql += "LONG"
      CASE mFldType = "I" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "INT"
      CASE mFldType = "I"
         mSql += "INTEGER"
         //
         // B double
         //
      CASE mFldType = "B"
         mSql += "DOUBLE"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "FLOAT"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "DOUBLE(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "B" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "NUMERIC(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
      CASE mFldType = "Y" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "DECIMAL(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         //
         // L = logico boleano bit
         //
      CASE mFldType = "L" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         mSql += "NUMBER (1)"
      CASE mFldType = "L" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "FIREBIRD" )
         mSql += "BOOLEAN"
      CASE mFldType = "L" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" ;
            .OR. cTIPOSQL = "ACCDDB" .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "BIT"
      CASE mFldType = "L"
         mSql += "BOOL"
         //
         // M= memo TEXT LONGTEXT
         //
      CASE mFldType = "M" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         mSql += "CLOB"
      CASE mFldType = "M" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "TEXT"
      CASE mFldType = "M" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" ;
            .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" )
         mSql += "LONGTEXT"
      CASE mFldType = "M" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 1"
      CASE mFldType = "M"
         mSql += "TEXT"
         //
         // G = blob LONGBINARY
         //
      CASE mFldType = "G" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BYTEA"
      CASE mFldType = "G" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "VARBINARY"
      CASE mFldType = "G" .AND. ( cTIPOSQL = "MDB" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "ACCESS64" ;
            .OR. cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64" )
         mSql += "LONGBINARY"
      CASE mFldType = "G" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         Sql += "IMAGE"
      CASE mFldType = "M" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
      CASE mFldType = "G"
         mSql += "BLOB"

         // Q = Varbinary
      CASE mFldType = "Q" .AND. cTIPOSQL = "SQLITE"
         mSql += "BLOB "
      CASE mFldType = "Q" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "VARBINARY(" + hb_ntos( mFldLen ) + ")"
      CASE mFldType = "Q" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )
         mSql += "BYTEA"
      CASE mFldType = "Q" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
         // W = Blob
      CASE mFldType = "W" .AND. ( cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )
         mSql += "BLOB "
      CASE mFldType = "W" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         Sql += "IMAGE"
      CASE mFldType = "W" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
         //
         // invalido
         //
      OTHERWISE
         alertx( "Invalid Field Type: " + mFldType )
         RETURN ""
      ENDCASE
   NEXT
   mSql += ")"

   RETURN msql

// + EOF: sql2dbf.prg
// +
