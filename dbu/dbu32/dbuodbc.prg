#require "hbodbc"

#include "dbstruct.ch"
#INCLUDE "BOX.CH"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "hbVER.CH"
#INCLUDE "SQL.CH"


Function odbcmenu(cUSOSQL)
LOCAL aAMBIENTE
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo

aAMBIENTE:=SALVAA()
cSERVERX:="localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)
cTABELAX  :=SPACE(30)
loledb=.T.

pegcfgbanco()

//escolhe o arquivos
IF cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64" .OR. cTIPOSQL="SQLITE"
   OPENTIPOARQ()
ENDIF


WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    @ 03,24 SAY cTIPOSQL+" "+cDATABASEX
    OPCAO(  4, 24, "&Criar database            ", 67 ) //C
    OPCAO(  5, 24, "&Database Selecionar       ", 68 ) //D
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 
    OPCAO(  7, 24, "&Tabelas                   ", 84 ) //T
    OPCAO(  8, 24, "&Exportar  DBF             ", 69 ) //E
    OPCAO(  9, 24, "&Apagar Tabela             ", 65 ) //A 
    OPCAO( 10, 24, "Exportar &Formatos         ", 70 ) //F
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
            odbccriadatabase()
       CASE KEY=2
            mdbdatabases()
       CASE KEY=3
            odbcimpdbf()
       CASE KEY=4
            mdbtabela(cdatabasex)
       CASE KEY=5
            odbcexpdbf()
       CASE KEY=6
            odbcdeltable()
       CASE KEY=7
            odbcexpformat()
       OTHERWISE
            RETURN
    ENDCASE
ENDDO


RESTAA(aAMBIENTE)
LAYOUT()
RETURN .T.


function odbccriadatabase()
cnewDATABASEX:=INPUTBOX(SPACE(30),"Novo database")
cnewDATABASEX:=alltrim(cnewDATABASEX)
IF ! EMPTY(cnewDATABASEX)
   if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
       odbcexecsql("CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
   ENDIF
   //SQLITE MDB ACCDB
ENDIF
return .t.

function odbcimpdbf()
    local aINDICES
    LOCAL nINDICES
    LOCAL cINDEXNAME
    LOCAL J
    local msql
    LOCAL cTABLE
    LOCAL cCONN
    
    
    aINDICES:={}

    cTABLE:=SPACE(30)
    mdt("escolha origem")
    tipodbfesc()
    nORITIPO:=TIPODBF
    cORIDRIVER:=RDDNOME(TIPODBF)
    cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
    hb_FNameSplit(cARQORI ,nil,@cTable, NIL )
    cTABLE:=ALLTRIM(cTABLE)
    
    DBUseArea( .T. , cORIDRIVER , cARQORI, cTABLE , .T. , .T. ) 
    aSTRU:=DBSTRUCT() 
    nLASTREC:=reccount() 
    zei_fort( nLASTREC,,,0)
    
     nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
     FOR j = 1 TO  nIndexes
        cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
        cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
        cINDEXUSO  :=MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j ))
         msql:="create index " + cINDEXNAME + " on " + cTABLE + " ( " + cINDEXUSO + " ) "
         aadd(Aindices,msql)
     NEXT j

    msql:= SqliteCreateTable(cTABLE,aSTRU,cTIPOSQL)
    odbcexecsql(msql) 
    if len(aindices)>0
        odbcexecsql(Aindices) //Executa comando unico ou array de comandos
    endif    
    
   cCONN=GERACONN(cDATABASEX,.F.)
   dsFunctions := TODBC():New( cCONN )

    DBSELECTAREA(cTABLE)
    DBGOTOP()
    while !eof()
      zei_fort(nLASTREC,,,1)
      mSql := "INSERT INTO "+cTable+" VALUES "
      msql := msql + "("
      for i := 1 to len(aSTRU)
         mFldNm := aSTRU[i, DBS_NAME]
         if i > 1
            mSql += ", "
         endif
         mSql += c2sql(&mFldNm)
      next
      mSql += ")"
      dsFunctions:SETSQL(mSQL)
      dsFunctions:ExecSQL()
      dbskip()
   enddo
   dbclosearea()
   dsFunctions:Destroy()
return .t.

function odbcexpdbf()
LOCAL aSTRU
LOCAL cCONN
LOCAL i
LOCAL nFIM
LOCAL aVALOR

mdbtabela(cdatabasex)
cCONN=GERACONN(cDATABASEX,.F.)
dsFunctions := TODBC():New( cCONN )
dsFunctions:SetSQL( "SELECT * FROM "+cTABELAX)
dsFunctions:Open()

nLASTREC:=dsFunctions:LASTREC()
zei_fort( nLASTREC,,,0)

aSTRU:={}
nFIM:=len(dsFunctions:Fields)
FOR i := 1 TO nFIM
    cFieldName   := dsFunctions:Fields[ i ][2]
    cFieldType   := dsFunctions:Fields[ i ][3] 
    nFieldLength := dsFunctions:Fields[ i ][4]
    nFieldDec    := dsFunctions:Fields[ i ][5]
    DO CASE
       CASE cFIELDTYPE=SQL_CHAR
            cFIELDTYPE="CHAR"
       CASE cFIELDTYPE=SQL_NUMERIC
            cFIELDTYPE="NUMERIC"
       CASE cFIELDTYPE=SQL_DECIMAL
            cFIELDTYPE="DECIMAL"
       CASE cFIELDTYPE=SQL_INTEGER
            cFIELDTYPE="INTEGER"
       CASE cFIELDTYPE=SQL_SMALLINT
            cFIELDTYPE="SMALLINT"
       CASE cFIELDTYPE=SQL_FLOAT
            cFIELDTYPE="FLOAT"
       CASE cFIELDTYPE=SQL_REAL
            cFIELDTYPE="REAL"
       CASE cFIELDTYPE=SQL_DOUBLE 
            cFIELDTYPE="DOUBLE"
       CASE cFIELDTYPE= SQL_DATE
            cFIELDTYPE="DATE"
       CASE cFIELDTYPE= SQL_TIME
            cFIELDTYPE="TIME"
       CASE cFIELDTYPE= SQL_TIMESTAMP
            cFIELDTYPE="TIMESTAMP"
       CASE cFIELDTYPE= SQL_VARCHAR 
            cFIELDTYPE="VARCHAR"
       CASE cFIELDTYPE= SQL_TYPE_DATE
            cFIELDTYPE="TYPE_DATE"                        
       CASE cFIELDTYPE= SQL_TYPE_TIME
            cFIELDTYPE="TYPE_TIME"
       CASE cFIELDTYPE= SQL_TYPE_TIMESTAMP
            cFIELDTYPE="TYPE_TIMESTAMP"                        
       CASE cFIELDTYPE= SQL_LONGVARCHAR
            cFIELDTYPE="LONGVARCHAR"
       CASE cFIELDTYPE= SQL_BINARY
            cFIELDTYPE="BINARY"                        
       CASE cFIELDTYPE= SQL_VARBINARY 
            cFIELDTYPE="VARBINARY"
       CASE cFIELDTYPE= SQL_LONGVARBINARY
            cFIELDTYPE="LONGVARBINARY"
       CASE cFIELDTYPE= SQL_BIGINT
            cFIELDTYPE="BIGINT"                        
       CASE cFIELDTYPE= SQL_TINYINT
            cFIELDTYPE="TINYINT"
       CASE cFIELDTYPE= SQL_BIT
            cFIELDTYPE="BIT"                        
       CASE cFIELDTYPE= SQL_WCHAR
            cFIELDTYPE="WCHAR"
       CASE cFIELDTYPE= SQL_WVARCHAR
            cFIELDTYPE="WVARCHAR"                        
       CASE cFIELDTYPE= SQL_NVARCHAR
            cFIELDTYPE="WVARCHAR"
       CASE cFIELDTYPE= SQL_WLONGVARCHAR
            cFIELDTYPE="WLONGVARCHAR"                        
    ENDCASE
    
    AADD(aSTRU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
NEXT

altd()

avalor:={}
cDESTINO:=cTABELAX+"_"+cTIPOSQL
MDT(cDESTINO)
DBCreate(cDESTINO, aSTRU, "DBFCDX" ) 
DBUseArea( .T. , "DBFCDX" , cDESTINO, "DESTINO" , .T. , .F. ) 
WHILE ! dsFunctions:Eof()
     FOR I= 1 TO nFIM
        AADD(aVALOR,dsFunctions:Fields[ i ]:VALUE)
     NEXT I
    dbselectar("DESTINO")
     NETRECAPP()
     FOR I= 1 TO nFIM
         eVALOR:=aVALOR[I]
         if valtype(eVALOR)="C" .AND. SUBSTR(eVALOR,5,1)="-" .AND. SUBSTR(eVALOR,8,1)="-"
            eVALOR = substr(eVALOR, 6, 2) + "/" + substr(eVALOR, 9, 2) + "/" + substr(eVALOR, 1, 4)
            eVALOR = CTOD(eVALOR)
         ENDIF
         if valtype(eVALOR)="C"  .OR. valtype(eVALOR)="M"
           eVALOR:=RANGEREPL(chr(0),chr(31),eVALOR," ") //Remove caracteres de controle
           eVALOR:=TIRACE(eVALOR)
        ENDIF 
         IF ! EMPTY(eVALOR)
            FIELDPUT(I,eVALOR)
         ENDIF   
     NEXT I
     zei_fort(nLASTREC,,,1)
    dsFunctions:Skip()
ENDDO
dsFunctions:Close()
dsFunctions:Destroy()
return .t.

function odbcdeltable()
mdbtabela(cdatabasex)
IF .NOT. MDG("Apagar Tabela"+cTABELAX)  
   return .f.
ENDIF
altd()
odbcexecsql("DROP TABLE  "+cTABELAX) 
return .t.

function odbcexecsql(eCOMANDO)
LOCAL aCOMANDOS:={}
LOCAL nFIM
LOCAL i
LOCAL cCONN
IF VALTYPE(eCOMANDO)="C"
   AAdd(aCOMANDOS,eCOMANDO) 
ELSE
   aCOMANDOS:=eCOMANDO
ENDIF
cCONN=GERACONN(cDATABASEX,.F.)
dsFunctions := TODBC():New( cCONN )
nFIM:=LEN(aCOMANDOS)
for i:=1 to nfim
    cCOMANDO:=aCOMANDOS[I]
    dsFunctions:SetSQL(cCOMANDO)
    dsFunctions:ExecSQL()
next i
dsFunctions:Destroy()
return .t.

function odbcexpformat()
//nao e rdd exp usa skip() odbc use oreg
return .t.



