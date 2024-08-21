#include "dbstruct.ch"
#INCLUDE "BOX.CH"
#include "dbinfo.ch"

#require "hbsqlit3"

Function sqlitemenu()
public oDB := nil
public oDB1 := nil
private cTableName := ''
private cNewTable := ''
private lOpened := .f.


aAMBIENTE:=SALVAA()

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    OPCAO(  4, 24, "&Criar base sqllite        ", 67 ) //c 
    OPCAO(  5, 24, "&VACUUM (PACK)             ", 86 ) //V 
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 
    OPCAO(  7, 24, "&Exportar para DBFS        ", 69 ) //E 
    OPCAO(  8, 24, "&Show Tables               ", 83 ) //S
    
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
            createadb()
       CASE KEY=2
             IF selectdb()
               sqlitepack(odb)
            endif      
       CASE KEY=3
              IF selectdb()
                nOLDTIPO:=TIPODBF
                alertX("escolha origem")
                tipodbfesc()
                nORITIPO:=TIPODBF
                cORIDRIVER:=RDDNOME(TIPODBF)
                cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
                IF FILE (cARQORI)
                   export2sql(odb,cARQORI)
                   RDDNOME(nOLDTIPO) //retorna tipo anterior
                ENDIF   
            endif     
       CASE KEY=4
            IF selectdb()
               exportadbf(odb)  
            endif       
       CASE KEY=5
             IF selectdb()
               SqliteTables(odb)
            endif                 
       OTHERWISE
            RETURN
    ENDCASE
ENDDO

RESTAA(aAMBIENTE)
layout()
return NIL



function exportadbf(db)
LOCAL cTABELAEXP
IF MDG("Todas(SIM) Escolher Nao")
    aTable := sqltablestru( DB, "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name" )
     if len( aTable ) == 0
        msgstop( 'No Tables in the DB', 'DBF<-->SQLite Exporter' )
        return nil
     endif
     for i := 1 to len( aTable )
        MDT( aTable[ i, 1 ])
        Export2dbf(DB,aTable[ i, 1 ])
     next i
 else
    cTABELAEXP:=SQLITETABLES(DB)
    IF ! EMPTY(cTABELAEXP)
       Export2dbf(DB,cTABELAEXP)
    ENDIF
 endif    
 return nil


function C2SQL(Value)
local cValue := ""
local cdate := ""
if valtype(value) == "C" .and. len(alltrim(value)) > 0
   value := strtran(value,"'","''")
endif
do case
   case Valtype(Value) == "N"
      cValue := AllTrim(Str(Value))
   case Valtype(Value) == "D"
      if !Empty(Value)
         cdate := dtos(value)
         cValue := "'"+substr(cDate,1,4)+"-"+substr(cDate,5,2)+"-"+substr(cDate,7,2)+"'"
      else
         cValue := "''"
      endif
   case Valtype(Value) $ "CM"
      IF Empty( Value)
         cValue="''"
      ELSE
         cValue := "'" + value + "'"
      ENDIF
   case Valtype(Value) == "L"
      cValue := AllTrim(Str(iif(Value == .F., 0, 1)))
   otherwise
      cValue := "''"       // NOTE: Here we lose values we cannot convert
endcase
return cValue


function sqltablestru(dbo1,qstr)
local table := {}
local stmt
local currow := nil
local tablearr := {}
local rowarr := {}
local typesarr := {}
local cdate := ""
local current := ""
local i := 0
local j := 0
local type1 := ""
if empty(dbo1)
   msgstop("Database Connection Error!")
   return tablearr
endif
table := sqlite3_get_table(dbo1,qstr)
if sqlite3_errcode(dbo1) > 0 // error
   msgstop(sqlite3_errmsg(dbo1)+" Query is : "+qstr)
   return nil
endif
stmt := sqlite3_prepare(dbo1,qstr)
IF ! Empty( stmt )
   for i := 1 to sqlite3_column_count( stmt )
      type1 := upper(alltrim(sqlite3_column_decltype( stmt,i)))
      do case
         case type1 == "INTEGER" .or. type1 == "REAL" .or. type1 == "FLOAT" .or. type1 == "DOUBLE"
            aadd(typesarr,"N")
         case type1 == "DATE" .or. type1 == "DATETIME"
            aadd(typesarr,"D")
         case type1 == "BOOL"
            aadd(typesarr,"L")
         otherwise
            aadd(typesarr,"C")
      endcase
   next i
endif
sqlite3_reset( stmt )
if len(table) > 1
   asize(tablearr,0)
   for i := 2 to len(table)
      rowarr := table[i]
      for j := 1 to len(rowarr)
         do case
            case typesarr[j] == "D"
               cDate := substr(rowarr[j],1,4)+substr(rowarr[j],6,2)+substr(rowarr[j],9,2)
               rowarr[j] := stod(cDate)
            case typesarr[j] == "N"
               rowarr[j] := val(rowarr[j])
            case typesarr[j] == "L"
               if val(rowarr[j]) == 1
                  rowarr[j] := .t.
               else
                  rowarr[j] := .f.
               endif
         endcase
      next j
      aadd(tablearr,aclone(rowarr))
   next i
endif
return tablearr

function sqlitepack(db)
IF ! Empty( db )
      IF sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
        MDT("VACUUM PACK - Done")
         //sqlite3_sleep( 3000 )
      ENDIF
ENDIF
   

function selectdb
   local cFileName := ''
   local cDBName := ''
   local nSlash := 0
   local nDot := 0
   local lRETU := .F.
   
   
   cFileName:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
    { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
      { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
      { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )
   
   if len( alltrim( cFileName ) ) > 0
      cDBName := tiraext(cFileName)
      oDB := Connect2DB( cFileName, .f. )
      if oDB == Nil
         msgstop( 'Not a valid SQLite file.', 'SQLite File Selection' )
         return .f.
      else 
          lRETU:=.T.
      //    MDT(" is Connected! Version: "+cFILENAME) //+ valtostr(sqlite3_libversion_number())
          
          mdt(cFILENAME+ "Version library = " + sqlite3_libversion()  + ;
         "number version library = " + LTRIM(STR( sqlite3_libversion_number() )) )

      endif
   else
      msgstop( 'You have to select a SQLite File!', 'SQLite File Selection' )
      return lRETU
   endif   
return lRETU


 FUNCTION SqliteTables(DB)
*---------------------------------------------------------------------------
* Shows all tables inside the database
*---------------------------------------------------------------------------
 LOCAL aResult, nChoices,I,aRETU
 LOCAL aAMBIENTE
 nChoices:=0
 aAMBIENTE:=SALVAA()
 aRESULT:={}

  * Show all tables inside database
  aRETU := sqltablestru( DB, "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name" )
  
  for i := 1 to len( aRETU )
        AADD(aRESULT,aRETU[ i, 1 ])
next i
  
 // altd()

  IF LEN(aResult)>0
     HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
     nChoices := ACHOICE( 4,23,21,54, aResult)
  ENDIF   

RESTAA(aAMBIENTE)

RETURN( IIF( nChoices > 0, aResult[ nChoices ], "") )


FUNCTION connect2db(dbname,lCreate)
local dbo1 := sqlite3_open(dbname,lCreate)
IF Empty( dbo1 )
   alertx("Database could not be connected!")
   RETURN nil
ENDIF
RETURN dbo1


function createadb
   local cFileName := ''
   local cDBName := ''
   local nSlash := 0
   local nDot := 0
   
   
   cFileName:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
    { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
      { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
      { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )
   
    
   if len( alltrim( cFileName ) ) == 0
      msgstop( 'File name can not be empty!', 'DBF2SQLite Exporter' )
      return nil
   endif   
   if at( '.', cFileName ) == 0
      cFileName := cFileName + '.sqlite'
   endif
   if file(cFileName)
      alertx("Arquivo ja existe")
      return
   endif
   cDBName := tiraext(cFileName)
   oDB := Connect2DB( cFileName, .t. )
   if oDB == Nil
      msgstop( 'Not a valid SQLite file.', 'SQLite File Selection' )
      return nil
   else
       mdt(cDBName + " is Connected!")
   endif
return nil

function export2dbf(ODB1,cNEWTABLE)
   local aTable := {}
   local aTable1 := {}
   local cSQLTable := {}
   local aStruct := {}
   local cType := ''
   local cFieldName := ''
   local cFieldType := ''
   local nFieldLength := ''
   local nFieldDec := ''
   local nLength := 0
   local aRecord := {}
   local cINDEXNAME := ""
   local i, j
   if len( alltrim( cNewTable ) ) == 0
      msgstop( 'You have to select a DBF to export', 'DBF<-->SQLite Exporter' )
      return nil
   endif
   if len(cNEWTABLE)>0 
      cSQLTable := cNEWTABLE 
      aTable := sqltablestru( oDB1, 'PRAGMA table_info( ' + c2sql( cSQLTable ) + ')' )
      if len( aTable ) == 0
         msgstop( 'This is an empty table!' ) 
         return nil
      endif
      for i := 1 to len( aTable )
          //table info colunas
         //cid, name, type, "notnull", dflt_value, pk
         // 1    2     3      4           5         6
         cType := upper( alltrim( aTable[ i, 3 ] ) ) 
         cFieldName := alltrim( aTable[ i, 2 ] )
         do case
         case cType == "INTEGER" 
            cFieldType := 'N'
            nFieldLength := 8
            nFieldDec := 0
         case cType == "REAL" .or. cType == "FLOAT" .or. cType == "DOUBLE"
            cFieldType := 'N'
            nFieldLength := 14
            nFieldDec := 5
         case cType == "DATE" .or. cType == 'DATETIME' .or. cType == 'SHORTDATE'
            cFieldType := 'D'
            nFieldLength := 8
            nFieldDec := 0
         case cType == "BOOL"
            cFieldType := 'L'
            nFieldLength := 1
            nFieldDec := 0
         otherwise
            cFieldType := 'C'
            nFieldDec := 0
            nLength := 0
            
            //
            // char(n) text(n) o tamanho esta entre parentes
            //
            IF AT("(",cTYPE)>0 .AND. AT(")",cTYPE)>0 .AND. (AT("CHAR",UPPER(CTYPE))>0 .OR. AT("TEXT",UPPER(CTYPE))>0 )
               cTMPSIZE:=SUBSTR(cTYPE, AT("(",cTYPE) +1 , AT(")",cTYPE) -1)
               nLength := VAL(cTMPSIZE)
            ENDIF
            
            //
            // TEXT SEM () Marca com 256 para tipo memo abaixo
            //
            IF nLength=0 .and. AT("(",cTYPE)=0 .AND. AT(")",cTYPE)=0 .AND.  AT("TEXT",UPPER(CTYPE))>0
               nLength := 256
            ENDIF
            
            IF nLENGTH=0
                aTable1 := sqltablestru( oDB1, 'select max( length( ' + cFieldName + ' ) ) from ' + c2sql( cSQLTable ) )
                nLength := 0
                if len( aTable1 ) > 0
                   nLength := val( alltrim( aTable1[ 1, 1 ] ) )
                endif
            ENDIF    
            do case
              case nLength == 0
                 nFieldLength := 10
              case nLength < 256
                 nFieldLength := nLength
              otherwise
                 nFieldLength := 10
                 cFieldType := 'M'
            endcase
         endcase
         aadd( aStruct, { cFieldName, cFieldType, nFieldLength, nFieldDec } )
      next i
      if len( aStruct ) > 0
         //cNEWARQ:=cNEWTABLE+"_exp"
         dbcreate( cNewTable, aStruct )
         use &cNewTable
         if .not. used()
            msgstop( 'DBF File Creation error!', 'DBF<-->SQLite Exporter' )
            return nil
         endif
         aTable := sqltablestru( oDB1, 'select * from ' + c2sql( cSQLTable ) )
         nLASTREC:= len( aTable )
         zei_fort( nLASTREC,,,0)
         for i := 1 to nLASTREC
             zei_fort(nLASTREC,,,1)
            netrecapp() //append blank
            aRecord := aTable[ i ]
            for j := 1 to len( aRecord )
               cFieldName := Left( aStruct[ j, 1 ], 10 )
               replace &cFieldName with aRecord[ j ]
            next j
         next i
         dbcommit()
         dbunlock()
         mdt( "Successfully exported"+ cNEWTABLE )
         dbcloseall() //close all
         cNewTable := ''
      endif
   else
      msgstop( 'You have to select a Table to export!', 'DBF<-->SQLite Exporter' )
      return nil
   endif
return nil

function miscsql(dbo1,qstr)
if empty(dbo1)
   msgstop("Database Connection Error!")
   return .f.
endif
sqlite3_exec(dbo1,qstr)
if sqlite3_errcode(dbo1) > 0 // error
   msgstop(sqlite3_errmsg(dbo1)+" Query is : "+qstr)
   return .f.
endif
return .t.

Function export2sql(odb,cDBFFILE)
   local aStruct := {}, i,j, mFldNm, mFldtype, mFldLen, mFldDec, mSql
   local totrec, nrec,nIndexes
   
   if oDB == nil
      msgstop( "No Connection to SQLite DB! Try to create a new SQLite DB or select an existing SQLite DB", 'DBF->SQLite Exporter' )
      return nil
   endif
      
    IF .NOT. FILE(cDBFFILE)  
        return nil
    ENDIF
      
      
    cTablename := TIRAEXT(cDBFFILE)
//    use &cTablename.
 
    USE (cARQORI) ALIAS ORIGEM SHARED NEW VIA  (cORIDRIVER) 
 //  USE (cDBFFILE)  SHARED NEW //VIA  (cORIDRIVER)       

   aStruct = DbStruct()
   
   //criado funcao para usar tambem no dbudoc
   
   mSQL:=SqliteCreateTable(cTablename,aStruct)


   if !miscsql( oDB, mSql )
      alertx( 'Table Creation Error!', 'DBF2SQLite' )
      return nil
   endif

  
   nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
   FOR j = 1 TO  nIndexes
      //CREATE INDEX idx_student_name ON Students (name); 
      cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
      cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
       msql:="create index " + cINDEXNAME + " on " + cTablename + " ( "+MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j )) + " ) ;"
       //DbOrderInfo( <nDefine> , <cIndexFile> , <nOrder_or_cIndexName> , <xNewSetting> ) -> xCurrentSetting
       //AAdd( aNtxNames ,  dbORDERINFO( DBOI_NAME , ,  j )+" - "+dbORDERINFO( DBOI_EXPRESSION , ,  j ) )
       if ! miscsql( oDB, mSql )
          MemoWrit("sql"+StrZero( j, 2 , 0 ) +".txt",msql)
       endif
   NEXT j


   nLASTREC:=   reccount() //NetRegCount(cOLDDBF)
   zei_fort( nLASTREC,,,0)
   DBGOTOP()
   if !miscsql( oDB, 'begin transaction' )
      return nil
   endif
   do while !eof()
      zei_fort(nLASTREC,,,1)

      mSql := "INSERT INTO "+cTablename+" VALUES "
      msql := msql + "("
      for i := 1 to len(aStruct)
         mFldNm := aStruct[i, DBS_NAME]
         if i > 1
            mSql += ", "
         endif
         mSql += c2sql(&mFldNm)
      next
      mSql += ")"
      if .not. miscsql( oDB, mSql)
      	 alertx("Problem in Query: "+mSql)
         return nil
      endif
      dbskip()
   enddo
   if !miscsql( oDB, 'end transaction' )
      return nil
   endif
   dbcloseall()
return nil




FUNCTION MDPCHAVEI(cICHAVE)  //Cria string campo1,campo2,... para create index em sql
LOCAL nPOS
LOCAL cCHAVE
LOCAL cTMPCHV
LOCAL aICampos
LOCAL I
cCHAVE:=""
aicampos:=hb_atokens(cICHAVE,"+")
FOR I=1 TO LEN(aICampos)
    cTMPCHV:=aICampos[I]
    nPOS:=AT("(",cTMPCHV)
    IF nPOS>=0
       cTMPCHV:=SUBSTR(cTMPCHV,nPOS+1)
    ENDIF
    nPOS:=AT("(",cTMPCHV)
    IF nPOS>0
       cTMPCHV:=SUBSTR(cTMPCHV,nPOS+1)
    ENDIF
    nPOS:=AT(")",cTMPCHV)
    IF nPOS>0
       cTMPCHV:=SUBSTR(cTMPCHV,1,nPOS-1)
    ENDIF
    nPOS:=AT(",",cTMPCHV)
    IF nPOS>0
       cTMPCHV:=SUBSTR(cTMPCHV,1,nPOS-1)
    ENDIF
    cCHAVE+=cTMPCHV
    IF I<>LEN(aICAMPOS)
       cCHAVE+=","
    ENDIF
NEXT I
return cCHAVE

function SqliteCreateTable(cTablename,aStruct,cTIPOSQL)
LOCAL mSQL
LOCAL i
if valtype(cTIPOSQL)<>"C"
   cTIPOSQL="SQLITE"
ENDIF
 
   msql:=""
   IF cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"
      mSql := "CREATE TABLE "+cTablename+" ("
   ELSE
       mSql := "CREATE TABLE IF NOT EXISTS "+cTablename+" ("
   endif    

   for i := 1 to len(aStruct)
      mFldNm := aStruct[i, DBS_NAME]
      mFldType := aStruct[i, DBS_TYPE]
      mFldLen := aStruct[i, DBS_LEN]
      mFldDec := aStruct[i, DBS_DEC]

      if i > 1
         mSql += ", "
      endif
      mSql += alltrim(mFldnm)+" "

      do case
          //
          // Caracter
          //
          case mFldType = "C" .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER") 
             mSql += "VARCHAR("+LTRIM(STR(mFldLen))+")"
          case mFldType = "C"
             mSql += "CHAR("+LTRIM(STR(mFldLen))+")"    
         //
         // date datetime
         //       
         case (mFldType = "D" .OR. mFldType = "T") .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS".OR. cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER")
             mSql += "DATETIME"
        case mFldType = "D"
             mSql += "DATE"   
          case mFldType = "T"
             mSql += "DATETIME"
         //
         // Inteiro
         // numerico ->INTEGER LONG BIGINT
         //
         // com decimais
         // Numerico ->FLOAT DOUBLE NUMERIC
         //
        case mFldType = "N" .AND. (cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER")
             if mFldDec > 0
                mSql += "NUMERIC("+hb_ntos(mFldLen)+","+hb_ntos(mFldDec)+")"
             else
                IF mFldLen<=9
                    mSql += "INT"  //INTEGER("+hb_ntos(mFldLen)+")" verificar se aceita int(size) ou usar numeric(size,0)
                ELSE
                    mSql += "BIGINT"  //"bigint("+hb_ntos(mFldLen)+")" verificar se aceita int(size) ou usar numeric(size,0)
                ENDIF    
             endif  
             
         case mFldType = "N"  .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS")
             if mFldDec > 0
                mSql += "DOUBLE"
             else
                mSql += "LONG"
             endif       
          case mFldType = "N" .AND. cTIPOSQL="SQLITE"
             if mFldDec > 0
                mSql += "FLOAT"
             else
                mSql += "INTEGER"
             endif
             
         case mFldType = "N" .AND. (cTIPOSQL="MYSQL" .OR. cTIPOSQL="MARIADB")
             if mFldDec > 0
                mSql += "NUMERIC("+hb_ntos(mFldLen)+","+hb_ntos(mFldDec)+")"
             else
                IF mFldLen<=9
                    mSql += "INTEGER("+hb_ntos(mFldLen)+")"
                ELSE
                    mSql += "bigint("+hb_ntos(mFldLen)+")"
                ENDIF    
             endif  
          //
          // float DOUBLE
          // 
          case (mFldType = "F" .or. mFldType = "Y") .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS")     
               mSql += "DOUBLE"
          case (mFldType = "F" .or. mFldType = "Y")
                mSql += "FLOAT"
          //
          //integer LONG
          //   
          case mFldType = "I" .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS")    
             mSql += "LONG"
          case mFldType = "I"
             mSql += "INTEGER"
         //
         // double
         //    
          case mFldType = "B"
             mSql += "DOUBLE"
          //
          // logico boleano bit
          //   
         case mFldType = "L" .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER")
             mSql += "BIT"       
          case mFldType = "L"
             mSql += "BOOL"
          //
          // memo TEXT LONGTEXT
          //   
          case mFldType = "M" .AND. ( cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER")
             mSql += "TEXT" 
          case mFldType = "M" .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS")
             mSql += "LONGTEXT"
          case mFldType = "M"
             mSql += "TEXT"
          //
          // blob LONGBINARY
          //   
           case mFldType = "G" .AND. ( cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER")
             mSql += "VARBINARY"  
           case mFldType = "G" .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS")
             mSql += "LONGBINARY"        
          case mFldType = "G"
             mSql += "BLOB"
          //
          // invalido
          //   
          otherwise
             alertx("Invalid Field Type: "+mFldType)
             return ""
      endcase
   next
   mSql += ")"
return msql
