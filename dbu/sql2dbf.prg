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
#include "directry.ch"

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
	  OPCAO( 11,24,"Mar&kdown documentacao       ", 75) //
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
	  case key = 8	
           cFileName := win_GetOpenFileName(, "SQLite Files", hb_cwd(), "SQLite", ;
      { { 'SQLite', '*.sqlite' }, { 'SQLite db', '*.DB' }, ;
      { 'SQLite3', '*.sqlite3' }, { 'SQLite db3', '*.DB3' }, ;
      { 'SQLite Fossil', '*.fossil' }, { 'All Files', '*.*' } }, 1 )
            Doc_SQLite(cFileName)	  
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
   IF sqlite3_exec( db, "DROP TABLE IF EXISTS " + cTABELAX ) == SQLITE_OK
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

   DO CASE
       CASE ValType( Value ) == "N"
          cValue := AllTrim( Str( Value ) )
       CASE ValType( Value ) == "@"    //Datetime
           cValue :=C2SQLTS( Value)
       CASE ValType( Value ) == "D"
          IF ! Empty( Value )
             cdate  := DToS( value )
             cValue := "'" + SubStr( cDate, 1, 4 ) + "-" + SubStr( cDate, 5, 2 ) + "-" + SubStr( cDate, 7, 2 ) + "'"
          ELSE
             cValue := "''"
          ENDIF
       CASE ValType( Value ) $ "CM"
          IF Empty( Value )
             cValue := "''"
          ELSE
             cVALUE := VALUE
             // troca caracteres ',() usados pelo sql language
             cVALUE := StrTran( cVALUE, "'", " " )
             cVALUE := StrTran( cVALUE, ",", " " )
             cVALUE := StrTran( cVALUE, "(", " " )
             cVALUE := StrTran( cVALUE, ")", " " )
             //cVALUE := StrTran( cvalue, "'", "''" )   //  dobra ' acima removendo evitar erros de fechamento string quando ' esta no meio da string
             cVALUE := StrTran( cVALUE, "\", "\\" )   //  inclui nova barra pois e considerada escape no insert into
             cVALUE := AllTrim( cVALUE ) 
             cValue := "'" + cvalue + "'"
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


   if mdg("Implantar configuracao de performace")
      optimize_sqlite( db )
   endif

   IF !Empty( db )
   
       
      MDT( "Otimizando índices..." )
      sqlite3_exec( db, "PRAGMA optimize" )
      
      MDT( "Executando VACUUM (PACK)..." )
      IF sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
         MDT( "Processo concluído com sucesso." )
      ENDIF
   
      
   ENDIF

   RETURN .T.
   
   
 FUNCTION optimize_sqlite( db )
 IF !Empty( db )
   // Armazena arquivos temporários na memória em vez de disco
   sqlite3_exec( db, "PRAGMA temp_store = MEMORY" )
   
   // Aumenta o tamanho do cache (ex: 2000 páginas)
   sqlite3_exec( db, "PRAGMA cache_size = 2000" )
   
   // Modo WAL (Write-Ahead Logging) - Muito mais rápido para inserções
   // e permite leitura e escrita simultâneas
   sqlite3_exec( db, "PRAGMA journal_mode = WAL" )
   
   // Reduz a sincronização com o disco (Normal é seguro o suficiente com WAL)
   sqlite3_exec( db, "PRAGMA synchronous = NORMAL" )
   
   sqlite3_exec( db, "PRAGMA auto_vacuum = INCREMENTAL" )
   // Para liberar o espaço de fato:
   sqlite3_exec( db, "PRAGMA incremental_vacuum" )
   
endif   
RETURN NIL  


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

   if mdg("Implantar configuracao de performace")
      optimize_sqlite( db )
   endif


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
   LOCAL aUsados := {}
   LOCAL cCurName
   LOCAL aUsedNames := {} // Lista para controlar nomes já usados
   LOCAL nSeq := 0
   LOCAL cBaseName := ""
   

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
         cfieldOrigin :=cFieldName //guarda o nome original para para nao utilizar os tratrado maiores que 10 abaixo
         nFieldLength := 0
         nFieldDec    := 0
         
         
         // --- LOGICA DE TRATAMENTO DE NOME ---
        cFieldName := Upper( Left( cFieldName, 10 ) ) // Garante 10 chars
        
        // Se o nome já existe na estrutura, entra no loop de renomeio
        IF AScan( aUsedNames, cFieldName ) > 0
           nSeq := 1
           cBaseName := Left( cFieldName, 8 ) // Deixa espaço para "_1"
           
           DO WHILE .T.
              cFieldName := cBaseName + "_" + AllTrim(Str(nSeq))
              IF AScan( aUsedNames, cFieldName ) == 0
                 EXIT
              ENDIF
              nSeq++
              // Se chegar em 10, reduz o nome base
              IF nSeq > 9
                 cBaseName := Left( cFieldName, 7 )
              ENDIF
           ENDDO
        ENDIF
        AAdd( aUsedNames, cFieldName ) // Registra o nome final como usado
        // ------------------------------------


       //  altd()
         aTMP := geracampodbf( cFieldName, cFieldType, nFieldLength, nFieldDec )



         IF aTMP[ DBS_LEN ] = 0 .OR. aTMP[ DBS_LEN ] >= 250   // text geracampo volta 250 tentando ajustar o valor mais proximo
            //usa o nome nao tratado para puxar corretamente
            aTable1 := sqltablestru( oDB1, 'select max( length( ' + cfieldOrigin + ' ) ) from ' + c2sql( cSQLTable ) )
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
               //cFieldName := Left( aStruct[ j, 1 ], 10 )   // dbf nome maximo dez caracteres
               cFieldName := aStruct[ j, 1 ] // Pega o nome tratado na estrutura
               eVALORGRV  := aRecord[ j ]
               if valtype(eVALORGRV)="C" .AND. aStruct[ j, 2 ]="N"
                  eVALORGRV:=VAL(eVALORGRV)
               ENDIF
               REPLACE &cFieldName WITH eVALORGRV //aRecord[ j ]
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

// 1. Garantir que a tabela de metadados exista
   mSql := "CREATE TABLE IF NOT EXISTS table_metadata (" + ;
           "table_name TEXT, " + ;
           "column_name TEXT, " + ;
           "original_type TEXT, " + ;
           "length INTEGER, " + ;
           "precision INTEGER)"
   miscsql( oDB, mSql )
   
   
   // Metadados de Índices (A nova tabela)
   miscsql( oDB, "CREATE TABLE IF NOT EXISTS index_metadata (" + ;
              "table_name TEXT, index_name TEXT, expression TEXT, " + ;
              "is_unique INTEGER, is_bag INTEGER)" )


   // Verifica se a tabela 
   aTablesExist := sqltablestru( oDB, "SELECT name FROM sqlite_master WHERE type='table' AND name=" + c2sql(cTablename) )
   
   IF Len( aTablesExist ) > 0
      IF MDG( "Tabela " + cTablename + " ja existe. Deseja exclui-la?" )
         IF sqlite3_exec( oDB, "DROP TABLE IF EXISTS " + cTablename ) == SQLITE_OK
            MDT( "Tabela anterior excluida com sucesso." )
         ELSE
            msgstop( "Erro ao excluir tabela existente!" )
            RETURN NIL
         ENDIF
      ELSE
         // Se o usuário não quiser excluir, cancelamos a importação
         RETURN NIL
      ENDIF
   ENDIF


// 2. Limpar metadados antigos desta tabela específica (se houver)
   miscsql( oDB, "DELETE FROM table_metadata WHERE table_name = " + c2sql(cTablename) )
   
   // 1. LIMPA todos os metadados de índices desta tabela de uma vez só (fora do loop)
  miscsql( oDB, "DELETE FROM index_metadata WHERE table_name = " + c2sql(cTablename) )


 dbUseArea( .T., ( cORIDRIVER ), ( cARQORI ), "ORIGEM", .T. , .F. )
  // USE ( cARQORI ) ALIAS ORIGEM SHARED NEW VIA ( cORIDRIVER )
// USE (cDBFFILE)  SHARED NEW //VIA  (cORIDRIVER)

   aStruct := dbStruct()


// 5. Inserir metadados para cada campo
   FOR i := 1 TO Len( aStruct )
      mFldNm   := aStruct[ i, 1 ] // DBS_NAME
      mFldType := aStruct[ i, 2 ] // DBS_TYPE
      mFldLen  := aStruct[ i, 3 ] // DBS_LEN
      mFldDec  := aStruct[ i, 4 ] // DBS_DEC

      mSql := "INSERT INTO table_metadata (table_name, column_name, original_type, length, precision) VALUES (" + ;
              c2sql(cTablename) + ", " + ;
              c2sql(mFldNm) + ", " + ;
              c2sql(mFldType) + ", " + ;
              ltrim(str(mFldLen)) + ", " + ;
              ltrim(str(mFldDec)) + ")"
      miscsql( oDB, mSql )
   NEXT


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
      
      cIdxName := dbOrderInfo( DBOI_NAME, , j )       // Nome do Tag (ex: "ID_CLI")
      cKey     := dbOrderInfo( DBOI_EXPRESSION, , j ) // Expressão (ex: "NOME+DTOS(DATA)")
      lIsUnique := dbOrderInfo( DBOI_UNIQUE, , j )    // Retorna .T. se for UNIQUE
   
     // A. Salva a "receita" para o retorno futuro ao DBF
     mSql := "INSERT INTO index_metadata (table_name, index_name, expression, is_unique) VALUES (" + ;
             c2sql(cTablename) + ", " + ;
             c2sql(cIdxName) + ", " + ;
             c2sql(cKey) + ", " + ;
             iif( lIsUnique, "1", "0" ) + ")"
     miscsql( oDB, mSql )
        
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
         
         //
         // T - TIME  HB_FT_TIME            8 
         //
      CASE mFldType = "T" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "FIREBIRD" ;
                                 .OR. cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
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

      CASE mFldType = "N" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "FIREBIRD" )
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
      CASE mFldType = "Y" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "DECIMAL(" + hb_ntos( mFldLen ) + "," + hb_ntos( mFldDec ) + ")"
         //
         // L = logico boleano bit HB_FT_LOGICAL         2 
         //
      CASE mFldType = "L" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" )
         mSql += "NUMBER (1)"
      CASE mFldType = "L" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "FIREBIRD" )
         mSql += "BOOLEAN"
      CASE mFldType = "L" .AND. ( llMDB .OR. llACCDB .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )
         mSql += "BIT"
      CASE mFldType = "L"
         mSql += "BOOL"
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
         mSql += "BLOB SUB_TYPE 1"
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
      CASE mFldType = "M" .AND. ( cTIPOSQL = "FIREBIRD" )
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
         Sql += "IMAGE"
      CASE mFldType = "W" .AND. ( cTIPOSQL = "FIREBIRD" )
         mSql += "BLOB SUB_TYPE 0"
         
         //
         // HB_FT_ROWVER          11     "^"
         //
 
          //
         //HB_FT_AUTOINC         12     "+"
         //
      CASE mFldType = "+" .AND. ( cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" )   
           Sql += " int  PRIMARY KEY AUTO_INCREMENT "
      
       CASE mFldType = "+" .AND. ( cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")  
           Sql += " NUMBER (10,0) GENERATED ALWAYS AS IDENTITY" 
           
    CASE mFldType = "+" .AND. ( cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" )       
           Sql += "serial4 "
           
     CASE mFldType = "+" .AND. ( cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" )      
           Sql += "int  identity "
           
     CASE mFldType = "+" .AND. ( cTIPOSQL = "SQLITE")      
           Sql += "integer primary key AUTOINCREMENT"
           
           
           
          //
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
         alertx( "Invalid Field Type: " + mFldType )
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
      cPKCHAVE  :=""
      nIndexes  :=  dbOrderInfo( DBOI_ORDERCOUNT )
      mSQL    +=  hb_osNewLine()
      FOR j = 1 TO  nIndexes
          cINDEXNAME := dbOrderInfo( DBOI_NAME, ,  j )
          cINDEXNAME := StrTran( cINDEXNAME, "-", "_"  )  // Tracos nao aceitos trocando por undescore
          cSQLINDEX := "create index " + cINDEXNAME + " on " + cTABLENAME + " ( " + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + " ) ;"
          mSQL += cSQLINDEX + hb_osNewLine()
          IF J=1
             cPKCHAVE=MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) )
          ENDIF
     NEXT j
      mSQL +=HB_OSNEWLINE()
      IF lPK .AND. .NOT. EMPTY(cPKCHAVE)
         mSQL +="ALTER TABLE " + cTABLENAME + " ADD PRIMARY KEY(" + cPKCHAVE + ") ;"+HB_OSNEWLINE()
      ENDIF
   ENDIF

   RETURN msql



Function DocMarkdow()
   LOCAL aArquivos := Directory( "*.*" )
   LOCAL nHandle, oFile, cExt
   
   
   FOR EACH oFile IN aArquivos
      cExt := Lower( SubStr( oFile[ F_NAME ], At( ".", oFile[ F_NAME ] ) + 1 ) )
      
      DO CASE
         CASE cExt == "sqlite3"
            Doc_SQLite( oFile[ F_NAME ] )
         
         CASE cExt == "sqlite"
            Doc_SQLite( oFile[ F_NAME ] )
         
         CASE cExt == "fossil" 
            Doc_SQLite( oFile[ F_NAME ] )
		
        CASE cExt == "fossil" 
            Doc_SQLite( oFile[ F_NAME ] )
			
		 CASE cExt == "db3"
            Doc_SQLite( oFile[ F_NAME ] )
		
        CASE cExt == "db"
            Doc_SQLite( oFile[ F_NAME ] )
         		
         	
			
			
      ENDCASE
   NEXT
RETURN

Function Doc_SQLite( cDbFile )
   LOCAL db, stmt, stmtCol, stmtIdx, stmtInfo
   LOCAL cTabName, cIdxName, cCamposIdx, cIsUnique
   LOCAL lHasIdx
   LOCAL cDrive, cDir, cNome, cExt
   LOCAL cOut := cDbFile+".md"
   
   hb_FNameSplit( cDbFile, @cDir, @cNome, @cExt )

   nHandleDoc := fCreate( cOut )
   IF nHandleDoc == -1
      ? "Erro ao criar arquivo de documentacao."
      RETURN
   ENDIF

   fWrite( nHandleDoc, "# ??? Dicionario de Estruturas de Dados "+ cNome+ "." +cExt + hb_eol() )
   fWrite( nHandleDoc, "> Varredura automatica realizada em: " + DToC(Date()) + hb_eol() + hb_eol() )

   // 1. Abertura do Banco
   db := sqlite3_open( cDbFile )
   
   IF Empty( db )
      fWrite( nHandleDoc, "### ? Erro ao abrir: " + cDbFile + hb_eol() )
      RETURN
   ENDIF

   // 2. Iteração pelas Tabelas
   stmt := sqlite3_prepare( db, "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'" )

   DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
      cTabName := sqlite3_column_text( stmt, 1 )
      
      fWrite( nHandleDoc, hb_eol() + "#### Tabela: `" + cTabName + "`" + hb_eol() )
      fWrite( nHandleDoc, "| Campo | Tipo | PK | NotNull |" + hb_eol() )
      fWrite( nHandleDoc, "| :--- | :--- | :---: | :---: |" + hb_eol() )

      // 3. Processamento de Colunas
      stmtCol := sqlite3_prepare( db, "PRAGMA table_info('" + cTabName + "')" )
      DO WHILE sqlite3_step( stmtCol ) == SQLITE_ROW
         fWrite( nHandleDoc, "| " + sqlite3_column_text( stmtCol, 2 ) + ;
                          " | " + sqlite3_column_text( stmtCol, 3 ) + ;
                          " | " + iif( sqlite3_column_int( stmtCol, 6 ) == 1, "Sim", " " ) + ;
                          " | " + iif( sqlite3_column_int( stmtCol, 4 ) == 1, "Sim", " " ) + " |" + hb_eol() )
      ENDDO
      sqlite3_finalize( stmtCol )

      // 4. Processamento de Índices
      fWrite( nHandleDoc, hb_eol() + "**Índices e Chaves:**" + hb_eol() )
      stmtIdx := sqlite3_prepare( db, "PRAGMA index_list('" + cTabName + "')" )
      lHasIdx := .F.

      DO WHILE sqlite3_step( stmtIdx ) == SQLITE_ROW
         lHasIdx   := .T.
         cIdxName  := sqlite3_column_text( stmtIdx, 2 )
         cIsUnique := iif( sqlite3_column_int( stmtIdx, 3 ) == 1, " (Único)", "" )
         
         // Busca campos que compõem este índice específico
         stmtInfo   := sqlite3_prepare( db, "PRAGMA index_info('" + cIdxName + "')" )
         cCamposIdx := ""
         
         DO WHILE sqlite3_step( stmtInfo ) == SQLITE_ROW
            cCamposIdx += sqlite3_column_text( stmtInfo, 3 ) + ", "
         ENDDO
         sqlite3_finalize( stmtInfo )
         
         IF !Empty(cCamposIdx)
            cCamposIdx := Left( cCamposIdx, Len(cCamposIdx) - 2 )
            fWrite( nHandleDoc, "- **" + cIdxName + "**: `" + cCamposIdx + "`" + cIsUnique + hb_eol() )
         ENDIF
      ENDDO
      
      IF !lHasIdx
         fWrite( nHandleDoc, "> *Nenhum índice definido.*" + hb_eol() )
      ENDIF

      sqlite3_finalize( stmtIdx )
      fWrite( nHandleDoc, hb_eol() + "---" + hb_eol() )
   ENDDO

   sqlite3_finalize( stmt )
   //sqlite3_close( db )
   
   fClose( nHandleDoc )
RETURN

// + EOF: sql2dbf.prg
// +
