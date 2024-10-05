#require "rddsql"
#require "sddodbc"
#require "sddmy"
#require "sddpg"
#require "sddsqlt3"


#include "dbinfo.ch"
#include "error.ch"
#include "simpleio.ch"
#INCLUDE "BOX.CH"
#include "dbstruct.ch"


REQUEST SQLMIX
REQUEST SDDODBC
REQUEST SDDMY
REQUEST SDDPG
REQUEST SDDSQLITE3

ANNOUNCE RDDSYS

Function mixmenu(cUSOSQL)
LOCAL aAMBIENTE
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo

eCONN     :=""
aAMBIENTE:=SALVAA()
cSERVERX:="localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)
cTABELAX  :=SPACE(30)
loledb=.T.

pegcfgbanco()
cTIPOMIX:=cTIPOSQL

//Mariadb nao tem nativo
IF cTIPOSQL="MARIADB" 
   cTIPOMIX:="ODBC"
ENDIF

//access mdb accdb nao tem nativo
IF cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
   cTIPOMIX:="ODBC"
   OPENTIPOARQ()
ENDIF
IF at(".MDB",upper(cdatabaseX))>0 .or. at(".ACCDB",upper(cdatabaseX))>0
   cTIPOMIX:="ODBC"
ENDIF

//esoolhe o arquivos sqlite
IF cTIPOSQL="SQLITE"
   OPENTIPOARQ()
ENDIF


//sqlite mysql postgresql tem nativos e opcao para odbc
IF cTIPOMIX<>"ODBC"
  if .NOT. mdg("MIXRDD (SIM) MIXODBC (NAO)")
     cTIPOMIX:="ODBC"
  endif
ENDIF

//Usando mdtabela depois criar nativa sqlmix
//precisa retornar rdd se for usar de charmar ddSetDefault( "SQLMIX" ) novamente nao ter connecao aberta sqlmix tambem
//mdbtabela(cdatabasex)

cOLDRDD:=rddSetDefault( "SQLMIX" )
OPENSQLMIX()

//Usando mdtabela depois criar nativa sqlmix
//dbUseArea( .T., , "SELECT * FROM "+cTABELAX, cTABELAX )
//dbclosearea()



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
            OPENSQLMIX()
            mixcreatedatabase()
       CASE KEY=2
            //troca database
       CASE KEY=3
            miximpdbf()
       CASE KEY=4
            mdbtabela(cdatabasex)          
       CASE KEY=5
            //exp tabelas
       CASE KEY=6
            //mixexecutesql("CREATE TABLE country (CODE char(3), NAME char(50), RESIDENTS int(11))")
            //mixexecutesql("CREATE TABLE country2 (CODE char(3), NAME char(50), RESIDENTS int(11))")
            mdbtabela(cdatabasex)
            //ALTD()
            IF MDG("Apagar Tabela"+cTABELAX)  
               OPENSQLMIX() 
               mixexecutesql("DROP TABLE  "+cTABELAX) 
            ENDIF  
       CASE KEY=7
            //exp formatos
       OTHERWISE
            RETURN
    ENDCASE
ENDDO


RddSetDefault(cOLDRDD)
RESTAA(aAMBIENTE)
LAYOUT()
RETURN .T.

function miximpdbf()
   local aINDICES
    LOCAL nINDICES
    LOCAL cINDEXNAME
    LOCAL J
    local msql
    LOCAL cTABLE
    
    
   // altd()
   // rddInfo( RDDI_CONNECT)
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
    //USE (cARQORI) ALIAS (cTABLE) NEW VIA  (cORIDRIVER) 
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
   // dbclosearea()

    altd()
    msql:=""
    DO CASE
       CASE cTIPOSQL="SQLITE"
             msql:= SqliteCreateTable(cTABLE,aSTRU,"SQLITE")
       CASE  cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB"
             msql:= SqliteCreateTable(cTABLE,aSTRU,"MYSQL")
      CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
             msql:= SqliteCreateTable(cTABLE,aSTRU,"PGSQL")
       CASE  cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" 
              msql:= SqliteCreateTable(cTABLE,aSTRU,"MDB")
        CASE  cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
              msql:= SqliteCreateTable(cTABLE,aSTRU,"ACCDB")
       OTHERWISE
            RETURN .F.
    ENDCASE   
    OPENSQLMIX()  
  //  hb_memowrit("uso.txt",msql) 
    mixexecutesql(msql) 
    if len(aindices)>0
        mixexecutesql(Aindices) //Executa comando unico ou array de comandos
    endif    
    
    
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
      mixexecutesql(msql)
      dbskip()
   enddo
    
    dbclosearea()

return .t.

function mixcreatedatabase()
cnewDATABASEX:=INPUTBOX(SPACE(30),"Novo database")
cnewDATABASEX:=alltrim(cnewDATABASEX)
IF ! EMPTY(cnewDATABASEX)
   if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
       mixexecutesql("CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
       //fechar a connecao e trocar o database
       //CDATABASEX:=CNEWDATABASEX
   ENDIF
ENDIF


function mixexecutesql(eCOMANDO)
LOCAL aCOMANDOS:={}
LOCAL nFIM
LOCAL i
IF VALTYPE(eCOMANDO)="C"
   AAdd(aCOMANDOS,eCOMANDO) 
ELSE
   aCOMANDOS:=eCOMANDO
ENDIF
nFIM:=LEN(aCOMANDOS)
for i:=1 to nfim
    cCOMANDO:=aCOMANDOS[I]
    rddInfo( RDDI_EXECUTE, cCOMANDO )
next i
RETURN .T.


FUNCTION OPENSQLMIX() 
LOCAL cCONN
cCONN:=""
rddSetDefault( "SQLMIX" )
DO CASE
   CASE cTIPOMIX="MYSQL" .OR. cTIPOMIX="MYSQL64"
        eCONN:=rddInfo( RDDI_CONNECT, { "MYSQL"     , cSERVERX, cUSERX, cPASSX, cDATABASEX} ) 
    CASE cTIPOMIX="PGSQL" .OR. cTIPOMIX="PGSQL64"
        eCONN:=rddInfo( RDDI_CONNECT, { "POSTGRESQL", cSERVERX, cUSERX, cPASSX, cDATABASEX} )      
   CASE cTIPOMIX="SQLITE" 
        eCONN:=rddInfo( RDDI_CONNECT, { "SQLITE3", cDATABASEX} )    
   CASE cTIPOMIX="ODBC"  //Cserver Conneccao
       Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
       cCONN=GERACONN(cDATABASEX,.F.) //Sqlmix usa driver no lugar de provider(adooledb) geraconn(cCAMBASE,lPROVIDER)
       eCONN:=rddInfo( RDDI_CONNECT, { "ODBC", cCONN } )
ENDCASE
RETURN


