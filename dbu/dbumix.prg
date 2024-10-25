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

nCONN     := 0
aAMBIENTE:=SALVAA()
cSERVERX:="localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)
cTABELAX  :=SPACE(30)
loledb=.T.
lMDB  =.F.
lACCDB =.F.

pegcfgbanco()
cTIPOMIX:=cTIPOSQL

//Mariadb nao tem nativo
IF cTIPOSQL="MARIADB" .OR. cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"
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
//OPENSQLMIX()

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
            closemix()
       CASE KEY=2
            mdbdatabases()
       CASE KEY=3
            miximpdbf()
       CASE KEY=4
            mdbtabela(cdatabasex)          
       CASE KEY=5
            mixexpdbf(1)
       CASE KEY=6
            mdbtabela(cdatabasex)
            IF MDG("Apagar Tabela"+cTABELAX)  
               OPENSQLMIX() 
               mixexecutesql("DROP TABLE  "+cTABELAX) 
               closemix()
            ENDIF  
       CASE KEY=7
            mixexpdbf(2)
            //mixexpformat() usando sqlmix array memory migrar rdd quando disponivel
       OTHERWISE
            RETURN
    ENDCASE
ENDDO


RddSetDefault(cOLDRDD)
RESTAA(aAMBIENTE)
LAYOUT()
RETURN .T.

function mixexpdbf(nTIPO)
LOCAL cDESTINO
LOCAL aSTRU
LOCAL aVALOR
LOCAL I
LOCAL nFIM
LOCAL eVALOR

IF nTIPO=2
  LCOPIANAT:=.f. //MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado PGsqlrddd
  tDOC:=pegtipodoc() // .t. Inclui dbf se for nativa
  pegparexp() 
  lDOCCAB  :=.F.
  lDOCDAD  :=.F.
  lDOCRECNO:=.F.
  cSUBTIPO :=" "
  PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF


mdbtabela(cdatabasex)

cDESTINO:=cTABELAX+"_"+cTIPOSQL
MDT(cDESTINO)


MDT("abrindo arquivo de origem: "+cTABELAX)
dbUseArea( .T., , "SELECT * FROM "+cTABELAX, "ORIGEM" )
nLASTREC :=  lastrec() 
nFIM     :=  FCOUNT()
zei_fort( nLASTREC,,,0)
aSTRU:=DBSTRUCT()
aSTRU:=sqltodbfstru(aSTRU)

IF nTIPO=1 //arquivo fisico
   MDT(cDESTINO)
   DBCreate(cDESTINO, aSTRU, "DBFCDX" ) 
   DBUseArea( .T. , "DBFCDX" , cDESTINO, "DESTINO" , .T. , .F. ) 
else
  //cria um arrayrdd para usar na exportacao usar memoria mudar para rdd quqndo disponivel
  //dbCreate( "persons", { { "NAME", "C", 20, 0 }, { "FAMILYNAME", "C", 20, 0 }, { "BIRTH", "D", 8, 0 }, { "AMOUNT", "N", 9, 2 } }, , .T., "persons" )
  //nao passa o driver sqlmix ja e default rddSetDefault( "SQLMIX" )
  dbCreate( "DESTINO" , aSTRU, , .T., "DESTINO"  )
  
  //DBCreate(<cDatabase>, <aStruct>, <cDriver> ) -> Nil 
  //nao precisa abrir area 4 parametro mantem aberto 
  //5 parametro alias
endif


dbselectar("ORIGEM")
while ! eof()
      aVALOR:={}
     FOR I= 1 TO nFIM
        AADD(aVALOR,FIELDGET(I))
     NEXT I
    dbselectar("DESTINO")
    netrecapp()

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

    dbselectar("ORIGEM")
    dbskip()
    zei_fort(nLASTREC,,,1)
enddo
dbselectar("ORIGEM")
dbclosearea()

IF nTIPO=2
   cDESTINO:=cTABELAX+"_"+cTIPOSQL+zEXPOREXT
   MDT(cDESTINO)
   dbselectar("DESTINO")
   nLASTREC:=   lastrec() 
   zei_fort( nLASTREC,,,0)
   dbgotop()
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO),aSTRU)
ENDIF

dbselectar("DESTINO")
dbclosearea()


return .t.

function miximpdbf()
   local aINDICES
    LOCAL nINDICES
    LOCAL cINDEXNAME
    LOCAL J
    local msql
    LOCAL cTABLE
    
    
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
    OPENSQLMIX()  
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
    closemix()
return .t.

function mixcreatedatabase()
cnewDATABASEX:=INPUTBOX(SPACE(30),"Novo database")
cnewDATABASEX:=alltrim(cnewDATABASEX)
IF ! EMPTY(cnewDATABASEX)
   if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" ;
                       .OR. cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"
       mixexecutesql("CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
       //fechar a connecao e trocar o database
       //CDATABASEX:=CNEWDATABASEX
   ENDIF
   IF cTIPOSQL="SQLITE" .OR. cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB64"
      mdbcria()
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
        nCONN:=rddInfo( RDDI_CONNECT, { "MYSQL"     , cSERVERX, cUSERX, cPASSX, cDATABASEX} ) 
    CASE cTIPOMIX="PGSQL" .OR. cTIPOMIX="PGSQL64"
        nCONN:=rddInfo( RDDI_CONNECT, { "POSTGRESQL", cSERVERX, cUSERX, cPASSX, cDATABASEX} )      
   CASE cTIPOMIX="SQLITE" 
        nCONN:=rddInfo( RDDI_CONNECT, { "SQLITE3", cDATABASEX} )    
   CASE cTIPOMIX="ODBC"  //Cserver Conneccao
       Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
       cCONN=GERACONN(cDATABASEX,.F.) //Sqlmix usa driver no lugar de provider(adooledb) geraconn(cCAMBASE,lPROVIDER)
       nCONN:=rddInfo( RDDI_CONNECT, { "ODBC", cCONN } )
ENDCASE
RETURN

FUNCTION CLOSEMIX()
IF .NOT. EMPTY(nconn)
   RDDINFO(RDDI_DISCONNECT, nConn1)
ENDIF

function mixexpformat()
mdbtabela(cdatabasex)
LCOPIANAT:=.f. //MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado mysqlrddd
tDOC:=pegtipodoc() // .t. Inclui dbf se for nativa
pegparexp() 
lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "
PegcsUB(tDOC)  //pegar o subtipo conforme tipo
cDESTINO:=cTABELAX+"_"+cTIPOSQL+"_rddmix."+zEXPOREXT
MDT(cDESTINO)
MDT("abrindo arquivo de origem: "+cTABELAX)
dbUseArea( .T., , "SELECT * FROM "+cTABELAX, cTABELAX )
nLASTREC:=   lastrec() 
zei_fort( nLASTREC,,,0)
aSTRU:=DBSTRUCT()
multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO),aSTRU)
dbcloseaREA()

