#include "dbstruct.ch"
#INCLUDE "BOX.CH"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "hbVER.CH"

#require "rddado"

#include "adordd.ch"

REQUEST ADORDD


Function mdbmenu(cUSOSQL)
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo
public oDB := nil

aAMBIENTE:=SALVAA()

cSERVERX:="localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)
cTABELAX  :=SPACE(30)

IF cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"
   cUSERX:=PADR("root",30," ")
   IF MDG("MARIADB (SIM) MYSQL(NAO)")
      cTIPOSQL:="MARIADB" 
   ENDIF
ENDIF

IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"
   cUSERX:=PADR("postgres",30," ")
ENDIF

//
// ajustes nomes de drivers para 32 e 64 bits
//

loledb=.T.
IF cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64  //mdg("User sim=oledb jet (32b) nao=oledb accdb(64b)")
ENDIF 
IF cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64 //mdg("User sim=odbc 8.0(32b) nao=odbc 9.0(64b)") 
ENDIF 
IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64 //mdg("User sim=odbc 8.0(32b) nao=odbc 9.0(64b)") 
ENDIF 
//mariadb mesmo nome de driver para 32 e 64 bits
 IF cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" 
   IF .not. MDG("MDB/ACCESS (SIM) ACCDB(NAO)")
      cTIPOSQL:="ACCDB" 
   ENDIF
ENDIF
IF cTIPOSQL="ACCDB"
   loledb:=.F. //Requer aceole.db 32 e ou 64 instalado
ENDIF

IF cTIPOSQL="MYSQL"  .or. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
   OPENTIPOARQ()
   mdbdatabases()
ENDIF


WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    DO CASE
       CASE cTIPOSQL="MDB" .OR.  cTIPOSQL="ACCESS" 
            IF loledb
               @ 03,24 SAY "oledb(32b)"
            Else
               @ 03,24 SAY "accdb(64b)"
            endif
       CASE cTIPOSQL="MYSQL"
            IF loledb
               @ 03,24 SAY "odbc 8(32b)"
            Else
               @ 03,24 SAY "odbc 9(64b)"
            endif
            
        OTHERWISE
            @ 03,24 SAY cTIPOSQL
    ENDCASE  
    if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"
       OPCAO(  4, 24, "&Criar database             ", 67 ) //c 67
    else
       OPCAO(  4, 24, "&Criar arquivo              ", 67 ) //c 67
    endif   
    OPCAO(  5, 24, "Executar arquivo &SQL      ", 83 ) //S 83
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 73 
    OPCAO(  7, 24, "&Exportar Tabelas          ", 69 ) //E 69
    OPCAO(  8, 24, "&Database Selecionar       ", 68 ) //D 68

    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
           mdbcria()
       CASE KEY=2
            ExecArqSql()
       CASE KEY=3
            MDBIMPDBF()
       CASE KEY=4
            MDBEXP()
       CASE KEY=5     
            mdbdatabases()
       OTHERWISE
            EXIT
    ENDCASE
ENDDO

RESTAA(aAMBIENTE)
layout()
return nil


function ExecArqSql
LOCAL cCOMANDO:=""
LOCAL aCOMANDO:={}
LOCAL cARQIMP:=""
LOCAL nFILEUSO
LOCAL cDELIM
LOCAL cLINHA

cARQIMP:=win_GetOPENFileName(, "Arquivos SQL",HB_CWD(), "Arquivos SQL", "*.SQL", 1 )
cARQORI:=OPENTIPOARQ()

IF FILE(cARQIMP)
    nLASTREC:=FLINECOUNT(cARQIMP)
    zei_fort( nLASTREC,,,0)
    
    cDELIM:=FDELIM (cARQIMP,1024) //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
    nFILEuso:=FOPEN(cARQIMP) //abre o arquivo
     WHILE .T.  
        cLINHA:=FREADLINE (nFILEuso, 1024 ,.T. ,cDELIM) //FREADLINE (handle, line_len,lremchrexp,cDELI)
        
        AADD(aCOMANDO,cLINHA)
        
        IF cLINHA='__FINAL__' //freadline retorna __FINAL__   quando nao e mais linhas
           EXIT
        ENDIF
        
        zei_fort(nLASTREC,,,1)
       
     enddo
     fclose(nFILEuso)   //fecha o arquivo
    executacmd(cARQORI,aCOMANDO)
endif
return .t.

function mdbdatabases()
aResult:=MDBTABLES()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cDATABASEX:=ALLTRIM(IIF( nChoices > 0, aResult[ nChoices ], ""))
RETURN .T.

function mdbtabela(cMDBARQ)
aResult:=MDBTABLES(cMDBARQ )
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cTABELAX:=ALLTRIM(IIF( nChoices > 0, aResult[ nChoices ], ""))
RETURN .T.

function MDBEXP()
LOCAL cCAMMDB   :=SPACE(100)
LOCAL lCOPIANAT
local Ldoc
local Lgrvstruinfo
LOCAL aSTRU

cMDBARQ:=OPENTIPOARQ()

mdbtabela(cMDBARQ)

cTABELA:=cTABELAX

IF EMPTY(cTABELA)
    cTABELA:=SPACE(60)
    md()
    @ maxrow(),0 SAY "TABELA"
    @ maxrow(),10 get cTABELA
    READ
ENDIF
cTABELA:=ALLTRIM(cTABELA)
IF EMPTY(cTABELA)
   RETURN NIL
ENDIF

Lgrvstruinfo:=MDG("Gravar info das estruturas")


LCOPIANAT:=MDG("Copia Nativa(SIM) Interna(NAO)")
tDOC:=pegtipodoc(lCOPIANAT) // .t. Inclui dbf se for nativa
if tDOC<>14 //dbf nao precisa adcional
   pegparexp() 
endif   
lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "

//
// formatos nao disponiveis no copy to (nativa)
//
IF tDOC=1 //XML 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=2 //TAM 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=3 //TEC 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=4 //DBE 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=7 //XML
   lCOPIANAT:=.F.
ENDIF
IF tDOC=8 //JSON 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=13 //SQL
   lCOPIANAT:=.F.
ENDIF

IF .NOT. lCOPIANAT
   PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF

hb_FNameSplit(cMDBARQ , @cCAMMDB, NIL, NIL )
cDESTINO:=cCAMMDB+cTABELA+"_"+Ctiposql+"."+zEXPOREXT
MDT(cDESTINO)


cTABELAGRV:=cTABELA
IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="POSTGRESQL" //Dupla aspas maiuscula
   cTABELA:=CHR(34)+UPPER(cTABELA)+CHR(34)
ENDIF


MDT("abrindo arquivo de origem: "+cMDBARQ)
opencmdbarq()
nLASTREC:=   reccount() 
zei_fort( nLASTREC,,,0)
aSTRU:=dbstruct()
//ajustar adordd para melhor tratativa campos @ datatime m diferenciando logwchar memos
//pois cria com tipos @ e M deixando o dbf com tipos incompativeis
//criar opcao de criar o dbf tratado con mdbtables 
//importar via pipe ou outro
IF lCOPIANAT
   COPYTO(cDESTINO)
ELSE
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO))
ENDIF   



if lgrvstruinfo
    //tDOC = 4 gera dbe
    //GRAVADOC( tdoc, cARQ, aESTRU ,aVAL,lDOCCAB,lDOCDAD,cSUBTIPO,lDOCRECNO )
    aSTRU:=sqltodbfstru(aSTRU)
    if tdoc=14 //destino dbf tdoc=14  grava dbe
       GRAVADOC( 4, ctabela+"_"+Ctiposql+"_1", aSTRU ,{},.t.,.f.,"",.f. )
    endif
    //stru2 pelo schema
    aSTRU:=MDBTABLES(cMDBARQ,cTABELAgrv )
    if tdoc=14 //destino dbf tdoc=14 grava dbe
       GRAVADOC( 4, ctabela+"_"+Ctiposql+"_2", aSTRU ,{},.t.,.f.,"",.f. )
    endif
endif
dbcloseall()
return nil

function sqltodbfstru(aStruct)
local nFIM 
local i
LOCAL aTAM
LOCAL nLENMAX
//#define DBS_NAME        1
//#define DBS_TYPE        2
//#define DBS_LEN         3
//#define DBS_DEC         4
nFIM:=LEN(aStruct)
for i:=1 to NFIM
    //mFldNm := aStruct[i, DBS_NAME]
    //  mFldType := aStruct[i, DBS_TYPE]
    //  mFldLen := aStruct[i, DBS_LEN]
    //  mFldDec := aStruct[i, DBS_DEC]
    nLENMAX:=0
    IF (aStruct[i, DBS_TYPE]="I" .or. aStruct[i, DBS_TYPE]="B") .and. aStruct[i, DBS_LEN]=0 .AND. cTIPOSQL="SQLITE" 
       Ctmp:="select max( length( " + aStruct[i, DBS_NAME] + " ) ) from " + cTABELA
       aTAM :=MDBTABLES(cMDBARQ,cTABELA , ctmp) 
        if len( aTAM ) > 0
           nLenMAX := aTAM[ 1 ]
        endif
    ENDIF

    
    // Casos datasting que nao retornam 8
    IF aStruct[i, DBS_TYPE]="D" .AND. aStruct[i, DBS_LEN]<>8
       aStruct[i, DBS_LEN]=8
       aStruct[i, DBS_DEC]=0
    ENDIF
    
    //DBS_TYPE="@" datetime no adordd possivel implancatacao string 16 por enquanto data
    IF aStruct[i, DBS_TYPE]="@"
       aStruct[i, DBS_TYPE]="D"
       aStruct[i, DBS_LEN]=8
       aStruct[i, DBS_DEC]=0
    ENDIF
    
    //DBS_TYPE="M"  mudando para char 250 ate melhor tratativa para longwchar e memos
    IF aStruct[i, DBS_TYPE]="M"
       aStruct[i, DBS_TYPE]="C"
       aStruct[i, DBS_LEN]=250
       aStruct[i, DBS_DEC]=0
    ENDIF
    
    //Tipo integer 4 =numerico 8
    IF aStruct[i, DBS_TYPE]="I" //integer
       aStruct[i, DBS_TYPE]="N"
       IF nLENMAX>8
          aStruct[i, DBS_LEN]=nLENMAX
       ELSE
          aStruct[i, DBS_LEN]=8
       ENDIF   
    ENDIF 

    //Tipo B
    IF aStruct[i, DBS_TYPE]="B" 
       aStruct[i, DBS_TYPE]="N"
       IF nLENMAX>15
         aStruct[i, DBS_LEN]=nLENMAX+ 4 //acrecenta 4 decimais
       ELSE
          aStruct[i, DBS_LEN]=15
       ENDIF   
       aStruct[i, DBS_LEN]=4
    ENDIF

next i
return aStruct

function opencmdbarq()
local lRETU
lRETU:=.T.
DO CASE
    CASE cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
        if loledb
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
        else
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
        endif 
    CASE cTIPOSQL="ACCDB"  .OR. cTIPOSQL="ACCDB64" 
         USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
    CASE cTIPOSQL="SQLITE"  
         USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA SQLITE
    CASE cTIPOSQL="MYSQL" .or. cTIPOSQL="MYSQL64"
        if loledb
            USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA MYSQL    FROM cSERVERx  USER CUSERX PASSWORD CPASSX
        else
            USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA MYSQL64  FROM cSERVERx  USER CUSERX PASSWORD CPASSX
        endif    
    CASE cTIPOSQL="MARIADB"     
        USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA MARIADB  FROM cSERVERx  USER CUSERX PASSWORD CPASSX
    CASE cTIPOSQL="PGSQL" .or. cTIPOSQL="PGSQL64"
        if loledb
            TRY
              USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA PGSQL    FROM cSERVERx  USER CUSERX PASSWORD CPASSX
            catch oErR
              MDT("Erro Abrindo")  
              lRETU = .F.
            END  
        else
            TRY
              USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA PGSQL64  FROM cSERVERx  USER CUSERX PASSWORD CPASSX
            catch oErR
              MDT("Erro Abrindo")  
              lRETU = .F.  
            END  
        endif        
ENDCASE
return lRETU



function mdbcria()
local cCONCREATE
cCONCREATE:=""

DO CASE
   CASE cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
        //necessario uma tabela para criar
   CASE cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos accdb", "*.accdb", 1 )
        //necessario uma tabela para criar
   CASE cTIPOSQL="SQLITE" 
        cARQORI:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )  
          
   CASE cTIPOSQL="MYSQL"  .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
      //con sql create database
      
ENDCASE


//cria com sql query create database
 if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
    cARQORI:=OPENTIPOARQ()
    cNEWDATABASEX:=SPACE(40)
    @ 24,00 SAY "Novo database"
    @ 24,20 GET cnewDATABASEX
    READ
    cnewDATABASEX:=alltrim(cnewDATABASEX)
    IF .NOT. EMPTy(cnewDATABASEX)
      cDATABASEX=""
      executacmd(Carqori,"CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
      CDATABASEX:=CNEWDATABASEX
    ENDIF  
endif 

//cria com catalogx
IF cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB64"//Cria com catalog
   CreateAccessDatabase( cARQORI)
ENDIF  

//cria com create da rddado 
IF cTIPOSQL="SQLITE"  
   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
   cCONCREATE:=criaconcreate(cARQORI,'table1')
   do case
      
      otherwise
         dbCreate( cCONCREATE, { ;
              { "FIRST",   "C", 10, 0 }, ;
              { "LAST",    "C", 10, 0 }, ;
              { "AGE",     "N",  8, 0 }, ;
              { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
  endcase            
     Set( _SET_DATEFORMAT, "dd/mm/yyyy" )   
ENDIF
RETURN NIL



function criaconcreate(cMDBARQ,cNOMETABELA)
/* sequencia dos parametros adordd
 LOCAL cDataBase  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 1, ";" )
   LOCAL cTableName := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 2, ";" )
   LOCAL cDbEngine  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 3, ";" )
   LOCAL cServer    := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 4, ";" )
   LOCAL cUserName  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 5, ";" )
   LOCAL cPassword  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 6, ";" )
*/   
LOCAL cCONCREATE

   cCONCREATE:=cMDBARQ+";"+cNOMETABELA
    DO CASE
       CASE cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
            IF  loledb
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA
            else
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
            endif
       CASE cTIPOSQL="ACCDB"  .OR. cTIPOSQL="ACCDB64" 
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
       CASE cTIPOSQL="SQLITE"  
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";SQLITE"
       CASE cTIPOSQL="MYSQL"  .OR. cTIPOSQL="MYSQL64"
           if loledb
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MYSQL;"+cSERVERX+";"+CUSERX+";"+cPASSX
            else    
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MYSQL64;"+cSERVERX+";"+CUSERX+";"+cPASSX
            endif   
       CASE cTIPOSQL="MARIADB"  
           cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MARIADB;"+cSERVERX+";"+CUSERX+";"+cPASSX
       CASE cTIPOSQL="PGSQL"  .OR. cTIPOSQL="PGSQL64"
           if loledb
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";PGSQL;"+cSERVERX+";"+CUSERX+";"+cPASSX
            else    
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";PGSQL64;"+cSERVERX+";"+CUSERX+";"+cPASSX
            endif            
    ENDCASE
RETURN cCONCREATE 
   
FUNCTION DBF2MDB(cMDBARQ,cDBFARQ)
    local cCONCREATE
    local aINDICES
    LOCAL nINDICES
    LOCAL cINDEXNAME
    LOCAL J
    local msql
    local lgravasql
    
    
    lgravasql:=mdg("gravar sql")
    aINDICES:={}
    use &cDBFARQ.
    aSTRU:=DBSTRUCT() 
    nLASTREC:=reccount() 
    zei_fort( nLASTREC,,,0)
    cNOMETABELA:=ALIAS()
    
     nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
     FOR j = 1 TO  nIndexes
        cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
        cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
         msql:="create index " + cINDEXNAME + " on " + cNometabela + " ( "+MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j )) + " ) "
         aadd(Aindices,msql)
     NEXT j
    dbclosearea()

    MDT(cNOMETABELA)
    
    Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
    
    cCONCREATE:=criaconcreate(cMDBARQ,cNOMETABELA)
    
    DO CASE
       CASE cTIPOSQL="SQLITE" .OR. cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF"  ;
            .OR. cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"  ;
            .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"
             //Abaixo com executacmd ja com estrutura ajustada pela funcao
       OTHERWISE
          dbCreate( cCONCREATE, aSTRU,"ADORDD" )
    ENDCASE      
    
    msql:=""
    DO CASE
       CASE cTIPOSQL="SQLITE"
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"SQLITE")
             executacmd(cMDBARQ,msql)
       CASE  cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB"
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MYSQL")
             executacmd(cMDBARQ,msql)
          CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"PGSQL")
             executacmd(cMDBARQ,msql)          
       CASE  cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" 
              msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MDB")
             executacmd(cMDBARQ,msql)
        CASE  cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
              msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"ACCDB")
             executacmd(cMDBARQ,msql)         
       OTHERWISE
            //criado acima pela funcao
    ENDCASE      
    
    IF lGRAVASQL.AND. .NOT. EMPTY(msql)
       HB_MEMOWRIT(cNOMETABELA+"_createtable_"+cTIPOSQL+".sql",Msql,.F.)
    ENDIF

    if len(aindices)>0
        //Cria do os indices append from nao faz    
        Executacmd(cMDBARQ,Aindices) //Executa comando unico ou array de comandos
        IF lGRAVASQL
           msql:=""
           for ii=1 to len(aINDICES)
               mSQL+=aINDICEs[II]+ " ; "+HB_OSNEWLINE()
           next ii
           HB_MEMOWRIT(cNOMETABELA+"_createindex_"+cTIPOSQL+".sql",mSQL,.f.)
        endif
    endif    
    
    cTABELA:=cNOMETABELA //publica usada o opencmdarq
    IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="POSTGRESQL" //Dupla aspas maiuscula
       cTABELA:=CHR(34)+UPPER(cTABELA)+CHR(34)
    ENDIF
    
    if nLASTREC>0 //nao importa se nao tiver registros
      try
        opencmdbarq()
        //Criar opcao de append from insert into usando
        try 
          append from &cDBFARQ. WHILE zei_fort(nLASTREC,,,1)
        catch oErR
          MDT("Erro anexando dados")
        end
      catch oErR
        MDT("Erro ao abrir nova tabela")  
      end  
      dbcloseall()
    endif  
      
    Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
    
     
RETURN .T.    

FUNCTION OPENTIPOARQ
LOCAL cMDBARQ
cMDBARQ:=""

DO CASE
   CASE cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" // .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
   CASE cTIPOSQL="ACCDB"  //.OR. cTIPOSQL="ACCDB64"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos accdb", "*.accdb", 1 )
   CASE cTIPOSQL="SQLITE"     
        cMDBARQ:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )
   CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"
         cSERVERX:=PADR(cSERVERX,30," ")
        // cDATABASEX:=PADR(cDATABASEX,30," ") escolhido nao precisa digitar
         cUSERX:=PADR(cUSERX,30," ")
         cPASSX:=PADR(cPASSX,30," ")
          HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
         @ 04,23 SAY "Server"
         @ 06,23 SAY "Database"
         @ 08,23 SAY "user"
         @ 10,23 say "pass"
         @ 05,23 get cSERVERX
         //@ 07,23 gET cDATABASEX escolhido nao precisa digitar
         @ 09,23 get cuserx
         @ 11,23 get cpassx
         READ
         cSERVERX:=ALLTRIM(cSERVERX)
         //cDATABASEX:=ALLTRIM(cDATABASEX) nao precisa digitar
         cuserx:=alltrim(cuserx)
         cpassx:=alltrim(cpassx)
         cMDBARQ:=cDATABASEX     
ENDCASE   
RETURN cMDBARQ
    

FUNCTION MDBIMPDBF()

cMDBARQ:=OPENTIPOARQ()

nOLDTIPO:=TIPODBF
mdt("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
IF FILE (cARQORI)
   DBF2MDB(cMDBARQ,cARQORI)
   RDDNOME(nOLDTIPO) //retorna tipo anterior
ENDIF   
        
        
FUNCTION MDBTABLES(cDataBase,cTABELA,cCAMPOSQL )
LOCAL aRETU
local cCONN
LOCAL cCOMANDO
LOCAL cTIPOINFO
local cFieldName := ''
local cFieldType := ''
local nFieldLength := 0
local nFieldDec := 0
local lopen
Lopen:=.F.



cTIPOINFO:="TABELA"
IF VALTYPE(cDATABASE)<>"C"
   cTIPOINFO:="DATABASE"
ENDIF
IF VALTYPE(cTABELA)="C"
   cTIPOINFO:="ESTRUTURA"
ENDIF
IF VALTYPE(cCAMPOSQL)="C"
   cTIPOINFO:="CCAMPOSQL"
ENDIF

aRETU:={}
cCONN:=GERACONN(cDATABASE)

try
   oConn:=WIN_OLECreateObject( "ADODB.Connection" )
   with object oConn
      :ConnectionString:=cConn
      :Open()
   END  
catch oErr
   //ShowADOError(oERR,oConn,cCOMANDO) 
   return aRETU
end

/* a vezes e preciso conceder este acesso na ide para a consulta na retornar vazia
cCOMANDO:="GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC" 
*/

oRS:= WIN_OLECreateObject('ADODB.RecordSet')
oRS:CursorLocation := 3

cCOMANDO:=""
IF cTIPOINFO="DATABASE"
   DO CASE
     CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
         cCOMANDO = "SHOW DATABASES"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"  .OR. cTIPOSQL="MARIADB"
         cCOMANDO = "SELECT datname FROM pg_database;"    
   ENDCASE      
ENDIF
IF cTIPOINFO="TABELA"
    DO CASE
       CASE cTIPOSQL="MDB" .or. cTIPOSQL="ACCESS" .or. cTIPOSQL="ACCDB" ;
            .OR. cTIPOSQL="MDB64" .or. cTIPOSQL="ACCESS64" .or. cTIPOSQL="ACCDB64" ;
            .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
            cCOMANDO = "select MSysObjects.name from MSysObjects where MSysObjects.type In (1,4,6) " ;
              + " and MSysObjects.name not like '~*'   and MSysObjects.name not like 'MSys%' " ;
               + " order by MSysObjects.name "
       CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0         
            cCOMANDO ="SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
       CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
            cCOMANDO = "SHOW TABLES"
       CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
           cCOMANDO ="SELECT tablename FROM pg_tables WHERE schemaname='public'"   
           //SELECT table_name  FROM information_schema.tables  WHERE table_type = 'BASE TABLE' AND table_schema='public'
    endcase   
ENDIF
IF cTIPOINFO="ESTRUTURA"
    DO CASE
       //Implantar possivelmente com catalogx
       CASE cTIPOSQL="MDB" .or. cTIPOSQL="ACCESS" .or. cTIPOSQL="ACCDB" ;
             .OR. cTIPOSQL="MDB64" .or. cTIPOSQL="ACCESS64" .or. cTIPOSQL="ACCDB64" ;
             .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
       CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0   
            cCOMANDO ="PRAGMA table_info( " +  cTABELA  + ")"   
       CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
            cCOMANDO ="SHOW COLUMNS FROM "+cTABELA
       CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
           cCOMANDO ="SELECT   column_name,  udt_name,   character_maximum_length,   numeric_precision,  numeric_scale ,  data_type "
           cCOMANDO +=" FROM   information_schema.columns "
           cCOMANDO +=" WHERE   table_name = '"+UPPER(cTABELA)+"' ORDER BY ordinal_position ;" 
           //nome tabela em maiusculo postgresql e case sensitive  
           //udt_name melhor retorno mas tambem tras data_type caso necesario
           //where table_schema='public'  tras todas as tabelas do usurio(public)
    endcase   
ENDIF
IF cTIPOINFO="CCAMPOSQL"
   cCOMANDO:=cCAMPOSQL
ENDIF

      TRY
        oRS:Open(cCOMANDO, oConN, adOpenDynamic, adLockOptimistic )
        lOPEN:=.T.
      CATCH oERR
        lOPEN:=.F.
        //ShowADOError(oERR,oConn,cCOMANDO) 
    //    return  aRETU 
      END
IF .NOT. lOPEN
  IF cTIPOSQL="MDB" .or. cTIPOSQL="ACCESS" .or. cTIPOSQL="ACCDB" ;
     .OR. cTIPOSQL="MDB64" .or. cTIPOSQL="ACCESS64" .or. cTIPOSQL="ACCDB64" ;
      .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
     //atribui direito de select porem as vezes e necessario fazer via ide 
      EXECUTACMD(cdatabase,"GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC")
  ENDIF
ENDIF
IF lOPEN
    while ! ors:eof
         IF cTIPOINFO="TABELA" .OR. cTIPOINFO="CCAMPOSQL" .OR. cTIPOINFO="DATABASE"
            AADD(aRETU,ors:fields(0):value)  //ors:fields(0) inicia as colunas com zero ou pelo nome da coluna fields("name")
         ENDIF   
         IF cTIPOINFO="ESTRUTURA"
            cFieldName := ''
            cFieldType := ''
            nFieldLength := 0
            nFieldDec := 0
            
            // eDEFAULT :=""
            //inclusao valores default geracampo posicao 5 futuro correcao de nulls na importacao
            //
            DO CASE
               CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0 
                   //table info colunas
                   //cid, name, type, "notnull", dflt_value, pk
                   // 1    2     3      4           5         6
                   // 0    1     2      3           4         5 ->posicao no recordset
                   cFieldName := upper(alltrim( ors:fields(1):value ))
                   cType      := upper( alltrim( ors:fields(2):value ) ) 
                   AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
               CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
                   //table info colunas
                   // field, type, null, key, default,extra
                   // 1      2     3      4      5      6
                   // 0      1     2      3      4      5 ->posicao no recordset
                   cFieldName := upper(alltrim( ors:fields(0):value ))
                   cType      := upper( alltrim( ors:fields(1):value ) ) 
                   AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
               CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" 
                   cFieldName := upper(alltrim( ors:fields(0):value )) //column_name
                   cType      := upper( alltrim( ors:fields(1):value ) ) // data_type
                   nFieldLength = fixnum(ors:fields(2):value) //tamanho string character_maximum_length
                   if fixnum(ors:fields(3):value)>0//tamannho numeric
                      nFieldLength = fixnum(ors:fields(3):value)  //numeric_precision
                      nFieldDec    = fixnum(ors:fields(4):value)  //numeric_scale
                   endif
                   AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))                              
             ENDCASE   
            
         ENDIF   
        ors:movenext()
    enddo
    oRs:Close()
ENDIF

/*
altd()
IF cTIPOSQL="MDB" .or. cTIPOSQL="ACCESS".or. at(".MDB",upper(cdatabase))>0
   ocatalog:=win_oleCreateObject( "ADOX.Catalog" )
   IF cTIPOINFO="TABELA" //.AND. LEN(aRETU)=0
        TRY
        ocatalog := oConn:OpenSchema( adSchemaColumns )
      CATCH oERR
        return  aRETU 
      END
      while ! ocatalog:eof()
         Ors:movenext()
      enddo
      ocatalog:close()
   ENDIF
ENDIF
*/

oConN:close()  
RETURN aRETU 

function geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec)   
local aRETU
aRETU:={cFieldName,cFieldType,nFieldLength,nFieldDec}  
do case

    //
    // numeric(l,d) decimal(l,d) o tamanho esta entre parentes
    //
    CASE AT("(",cTYPE)>0 .AND. AT(")",cTYPE)>0 .AND. AT(",",cTYPE)>0 .AND. (AT("NUMERIC",UPPER(CTYPE))>0 .OR. AT("DECIMAL",UPPER(CTYPE))>0 )
       cTMPSIZE:=SUBSTR(cTYPE, AT("(",cTYPE) +1 )
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(",",cTMPSIZE)-1 )
       nFieldLength := val(cTMPSIZE)
       cTMPSIZE:=SUBSTR(cTYPE, AT(",",cTYPE) +1 )
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE)-1 )
       nFieldDec := val(cTMPSIZE)
       cFieldType := 'N'


    //
    //  tyniint(n) int(n) tamanho esta entre parentes
    //
   case AT("(",cTYPE)>0 .AND. AT(")",cTYPE)>0  .AND. AT(",",cTYPE)=0 .AND. AT("INT",UPPER(CTYPE))>0 
       cTMPSIZE:=SUBSTR(cTYPE, AT("(",cTYPE) +1) 
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE)-1 )
       nFieldLength:= VAL(cTMPSIZE)
       cFieldType := 'N'
       nFieldDec := 0
   
   
    //
    // varchar(n) char(n) text(n) o tamanho esta entre parentes
    //
   case AT("(",cTYPE)>0 .AND. AT(")",cTYPE)>0 .AND. (AT("CHAR",UPPER(CTYPE))>0 .OR. AT("TEXT",UPPER(CTYPE))>0 )
       cTMPSIZE:=SUBSTR(cTYPE, AT("(",cTYPE) +1) 
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE)-1 )
       nFieldLength := VAL(cTMPSIZE)
       cFieldType := 'C'
       nFieldDec := 0
       
  case  cType == "INT2" .OR. cType == "SMALLINT"
    cFieldType := 'N'
    nFieldLength := 4
    nFieldDec := 0     
    
 case cType == "INTEGER" .OR. cType == "INT4" .OR. cType == "SERIAL"
    cFieldType := 'N'
    nFieldLength := 8
    nFieldDec := 0
    
  case cType == "BIGINT" .OR. cType == "INT8" .OR. cType == "BIGSERIAL"
    cFieldType := 'N'
    nFieldLength := 16
    nFieldDec := 0   
    
    
 case cType == "DOUBLE PRECISION" .or. cType == "FLOAT8"
    cFieldType := 'N'
    nFieldLength := 19
    nFieldDec := 9
    
case cType == "MONEY" 
    cFieldType := 'N'
    nFieldLength := 12
    nFieldDec := 2
    
case cType == "REAL" .or. cType == "FLOAT" .or. cType == "DOUBLE" .or. cType == "FLOAT4"
    cFieldType := 'N'
    nFieldLength := 14
    nFieldDec := 5    
    
    
 case cType == "DATE" .or. cType == 'DATETIME' .or. cType == 'SHORTDATE' .or. cType == 'TIMESTAMP'
    cFieldType := 'D'
    nFieldLength := 8
    nFieldDec := 0
    
    
 case cType == "BOOL"  .or. cType == 'BOOLEAN' 
    cFieldType := 'L'
    nFieldLength := 1
    nFieldDec := 0
    
    
  CASE cType == "LONGTEXT"
       cFieldType := 'C'
       nFieldLength := 250
       nFieldDec := 0
   //
    // TEXT SEM tamanho memo
    //
  case  AT("(",cTYPE)=0 .AND. AT(")",cTYPE)=0 .AND.  AT("TEXT",UPPER(CTYPE))>0
       nFieldLength := 10
       cFieldType := 'M'
       nFieldDec := 0
    
    //
    // numeric sem ()
    //
  case  AT("(",cTYPE)=0 .AND. AT(")",cTYPE)=0 .AND.  AT("NUMERIC",UPPER(CTYPE))>0
       cFieldType := 'N'
       IF nFieldLength =0  //atribui 8 padrao integer caso nao foi passado
          nFieldLength := 8
          nFieldDec := 0   
       ENDIF     
  
  //
  // postgresql varchar bpchar CHARACTER
  //
  CASE cType == "VARCHAR" .OR. cType == "BPCHAR" .OR. AT("CHARACTER",UPPER(CTYPE))>0  
       cFieldType := 'C'
       nFieldDec := 0
  
  
  CASE cType == "NAME" 
       cFieldType := 'C'
       nFieldLength := 64
       nFieldDec := 0
   
   CASE cType == "OID" 
       cFieldType := 'N'
       nFieldLength := 19
       nFieldDec := 0    
       
 otherwise
    cFieldType := 'X'
    nFieldDec := 0
    nLength := 0
    
    
endcase
//Inclusao rotina pegar max quando campo tamanho for zero

aRETU:={cFieldName,cFieldType,nFieldLength,nFieldDec} 
return aRETU

FUNCTION geraconn(cCAMBASE)
cConn  :=""
IF VALTYPE(cCAMBASE)<>"C" //ser for database nao tem caminho usa cservex
   cCAMBASE:="" //atribui vazio 
ENDIF
DO CASE

   CASE cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .or. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64"  .or. at(".MDB",upper(cCAMBASE))>0
        if loledb
           cConn:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Mode=Share Deny None"  //32 bit jet oledb
        else
           cConn:="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+cCAMBASE+";Mode=Share Deny None" //64 bit ace oledb
        endif
        
    CASE cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64" .or. at(".ACCDB",upper(cCAMBASE))>0    
         cConn:="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+cCAMBASE+";Mode=Share Deny None" //driver 32 e 64 devem estar instalados
         
   CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cCAMBASE))>0
        cConn:="Driver={SQLite3 ODBC Driver};Database=" + cCAMBASE + ";" //mesmo nome de driver para 32 e 64 ambos devem estar instaldos

    CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"
        if empty(cDATABASEX)
            if loledb
               cConn:="Driver={MySQL ODBC 8.0 ANSI Driver};Server="+cSERVERX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //32 driver versao 8 
            else
               cConn:="Driver={MySQL ODBC 9.0 ANSI Driver};Server="+cSERVERX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //64 driver versao 9 
            endif
        else
            if loledb
               cConn:="Driver={MySQL ODBC 8.0 ANSI Driver};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //32 driver versao 8 
            else
               cConn:="Driver={MySQL ODBC 9.0 ANSI Driver};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //64 driver versao 9 
            endif
        endif    
   case cTIPOSQL="MARIADB"   //mesmo nome de driver para 32 e 64 ambos devem estar instaldos
        if empty(cDATABASEX)
            cConn:="DRIVER={MariaDB ODBC 3.2 Driver};SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
        else
           cConn:="DRIVER={MariaDB ODBC 3.2 Driver};DATABASE="+cDATABASEX+";SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
        endif   
   case cTIPOSQL="PGSQL"   .OR. cTIPOSQL="PGSQL64"
        //Driver={PostgreSQL ANSI};Server=IP address;Port=5432;Database=myDataBase;Uid=myUsername;Pwd=myPassword;
        if empty(cDATABASEX)
            if loledb
               cConn:="DRIVER={PostgreSQL ANSI};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX  //32 driver versao 
            else
               cConn:="DRIVER={PostgreSQL ANSI(x64)};Database="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX  //64 driver versao x64
            endif
        else
            if loledb
               cConn:="DRIVER={PostgreSQL ANSI};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX  //32 driver versao 
            else
               cConn:="DRIVER={PostgreSQL ANSI(x64)};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX //64 driver versao 964
            endif
        endif    
ENDCASE      
RETURN cConn   




Function executacmd(cCAMBASE,eCOMANDO)
LOCAL cCHAVEV
LOCAL cConn
LOCAL aCOMANDOS:={}
LOCAL nFIM
LOCAL cCOMANDO:=""
local i

//Gera array para casos sejam mutilplos comando em uma matriz 
//evitando abrir e fechar a conecao para comando em sequencia
IF VALTYPE(eCOMANDO)="C"
   AAdd(aCOMANDOS,eCOMANDO) 
ELSE
   aCOMANDOS:=eCOMANDO
ENDIF
nFIM:=LEN(aCOMANDOS)

cCHAVEV:=""
cConn  :=geraconn(cCAMBASE)

IF EMPTY(cConn)
   return .f.
endif
        
try
   oConn:=WIN_OLECreateObject( "ADODB.Connection" )
   with object oConn
      :ConnectionString:=cConn
      :Open()
   END  //end do with
catch oErr
  // ShowAdoError(oERR,oCoNn)   
   return .f.
end

try
  oComm:=WIN_OLECreateObject( "ADODB.Command" )
catch oErr
  // ShowAdoError(oERR,oCoNn)   
   return .f.
end

for i:=1 to nfim
    cCOMANDO:=aCOMANDOS[I]
    IF .NOT. EMPTY(cCOMANDO)
      try
          with object oComm
              :CommandText:=cCOMANDO
              :CommandType:=adCmdText
              :ActiveConnection:=oConn
              :Execute()
          end
      end
    ENDIF  
next i
oConn:Close()
oConn:=NIL		
RETURN .t.


FUNCTION CreateAccessDatabase( cDatabase, cPassword, lEncrypt )

   LOCAL oCatalog // AS ADOX.Catalog

   IIF( cPassword == NIL, cPassword := "''", NIL )
   IIF( lEncrypt == NIL, lEncrypt := .F., NIL )

   oCatalog := CreateObject( "ADOX.Catalog" )
   
    /* OLEDB:Engine Type=5
   Unknown 0
   Jet 1.0            1
   Jet 1.1            2
   Jet 2.0            3
   Jet 3.x(97)        4
   Jet 4.x(2000)      5
   JetEngineType_Ace12 = 6
  */
   
   
 if loledb //32 bits mdb
   oCatalog:Create( "Provider=Microsoft.Jet.OLEDB.4.0;" +;
                      "Data Source=" + cDatabase + ";" +;
                      "JET OLEDB:Engine Type=5;" )
 else
   if cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" //64 bits mdb
     oCatalog:Create( "Provider=Microsoft.ACE.OLEDB.12;" +;
                        "Data Source=" + cDatabase + ";" +;
                        "JET OLEDB:Engine Type=5;" )
  else             //accdb  32 ou 64 bits    
    oCatalog:Create( "Provider=Microsoft.ACE.OLEDB.12;" +;
                        "Data Source=" + cDatabase + ";" +;
                        "JET OLEDB:Engine Type=6;" )
  endif
endif   

/* exemplo pass e ou encripitado
   oCatalog:Create( "Provider=Microsoft.Jet.OLEDB.4.0;" +;
                    "Data Source=" + cDatabase + ";" +;
                    "JET OLEDB:Database Password=" + cPassWord + ";" +;
                    "JET OLEDB:Engine Type=5;" +;
                    "JET OLEDB:Encrypt Database=" + IIF(lEncrypt, "TRUE", "FALSE" ) )
*/

                    

   oCatalog := NIL //NULL_OBJECT

RETURN
