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
loledb=.T.
lmdb  :=.f.
laccdb :=.f.

pegcfgbanco()

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    DO CASE
       CASE cTIPOSQL="MDB" .OR.  cTIPOSQL="ACCESS" 
            IF loledb
               @ 03,40 SAY "oledb(32b)"
            Else
               @ 03,40 SAY "accdb(64b)"
            endif
       CASE cTIPOSQL="MYSQL"
            IF loledb
               @ 03,40 SAY "odbc 8(32b)"
            Else
               @ 03,40 SAY "odbc 9(64b)"
            endif
            
        OTHERWISE
            @ 03,24 SAY "ADORDD"+" "+cTIPOSQL
    ENDCASE  
    if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"  ;
                        .OR. cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"
       OPCAO(  4, 24, "&Criar database             ", 67 ) //c 67
    else
       OPCAO(  4, 24, "&Criar arquivo              ", 67 ) //c 67
    endif   
    OPCAO(  5, 24, "Executar arquivo &SQL      ", 83 ) //S 83
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 73  
    OPCAO(  7, 24, "Exportar Tabela &Formatos  ", 69 ) //F 70 
    OPCAO(  8, 24, "&Database Selecionar       ", 68 ) //D 68 
    OPCAO(  9, 24, "&Exportar  DBF             ", 69 ) //E 69 
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
           mdbcria()
       CASE KEY=2
            ExecArqSql()
       CASE KEY=3
            MDBIMPDBF()
       CASE KEY=4
            MDBEXP(2)
       CASE KEY=5     
            mdbdatabases()
        CASE KEY=6
            MDBEXP(1)     
       OTHERWISE
            EXIT
    ENDCASE
ENDDO

RESTAA(aAMBIENTE)
layout()
return nil

function pegcfgbanco()
IF cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB"
   cUSERX:=PADR("root",30," ")
ENDIF

IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
   cUSERX:=PADR("postgres",30," ")
ENDIF
//
// ajustes nomes de drivers para 32 e 64 bits
//
loledb=.T.
IF cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64  //oledb jet (32b) oledb accdb(64b)")
ENDIF 
IF cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64 //odbc 8.0(32b) odbc 9.0(64b)") 
ENDIF 
IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64 //odbc 8.0(32b) odbc 9.0(64b)") 
ENDIF 

//
//mariadb mesmo nome de driver para 32 e 64 bits
//


IF cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
   loledb:=.F. //Requer aceole.db 32 e ou 64 instalado
ENDIF

IF cTIPOSQL="MYSQL"  .or. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64".OR. cTIPOSQL="POSTGRESQL"  ;
                     .OR. cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"
   OPENTIPOARQ()
   mdbdatabases()
ENDIF

lMDB:=.F.
IF cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
   lMDB:=.T.
ENDIF
lACCDB =.F.
IF cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
   lACCDB:=.T.
ENDIF


return .t.



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
local nChoices
nChoices:=0
aResult:=MDBTABLES()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cDATABASEX:=ALLTRIM(IIF( nChoices > 0, aResult[ nChoices ], ""))
RETURN aResult

function mdbtabela(cMDBARQ)
local nChoices
nChoices:=0
aResult:=MDBTABLES(cMDBARQ )
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
   nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cTABELAX:=ALLTRIM(IIF( nChoices > 0, aResult[ nChoices ], ""))
RETURN aResult

function MDBEXP(nTIPO)
LOCAL cCAMMDB   :=SPACE(100)
LOCAL lCOPIANAT
local Ldoc
local Lgrvstruinfo
LOCAL aSTRU
LOCAL nFIM
LOCAL i

cMDBARQ:=OPENTIPOARQ() 

mdbtabela(cMDBARQ)

cTABELA:=cTABELAX

IF EMPTY(cTABELA)
   cTABELA:=INPUTBOX(SPACE(30),"Tabela")
ENDIF
cTABELA:=ALLTRIM(cTABELA)
IF EMPTY(cTABELA)
   RETURN NIL
ENDIF

IF nTIPO=1
   tdoc=14 //dbf
   zEXPOREXT="DBF"
ENDIF

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


hb_FNameSplit(cMDBARQ , @cCAMMDB, NIL, NIL )
cDESTINO:=cCAMMDB+cTABELA+"_"+Ctiposql+"."+zEXPOREXT
MDT(cDESTINO)


cTABELAGRV:=cTABELA
IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" //Dupla aspas maiuscula
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
IF tDOC=14
   IF lMDB .OR. lACCDB
      //Ainda nao implantado testes com catalog ver outras opcoes
      //utilizando sqltodbfstru
      aSTRU:=sqltodbfstru(aSTRU)
      //altd()
      //aSTRU:=MDBTABLES(cMDBARQ,cTABELAgrv)
   ELSE
      aSTRU:=MDBTABLES(cMDBARQ,cTABELAgrv)
   ENDIF   
   altd()
   cALIASADO:=ALIAS()
   DBCreate(ctabela+"_"+Ctiposql, aSTRU) 
   DBUseArea( .T. ,  , ctabela+"_"+Ctiposql,  , .F. , .F. ) 
   cALIASDBF:=ALIAS()
   nFIM:=FCOUNT()
   dbselectar(cALIASADO)
   dbgotop()
   while ! eof()
     aVALOR:={}
     FOR I= 1 TO nFIM
        AADD(aVALOR,FIELDGET(I))
     NEXT I
     dbselectar(cALIASDBF)
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
     dbselectar(cALIASADO)
     zei_fort(nLASTREC,,,1)
     dbskip()
   enddo
ELSE
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO))
ENDIF
dbcloseall()
return nil

function sqltodbfstru(aStruct)
local nFIM 
local i
LOCAL aTAM
LOCAL nLENMAX
LOCAL aRETU
nFIM:=LEN(aStruct)
for i:=1 to NFIM
    nLENMAX:=0
    IF (aStruct[i, DBS_TYPE]="I" .or. aStruct[i, DBS_TYPE]="B") .and. aStruct[i, DBS_LEN]=0 .AND. cTIPOSQL="SQLITE" 
       Ctmp:="select max( length( " + aStruct[i, DBS_NAME] + " ) ) from " + cTABELA
        aTAM :=MDBTABLES(cMDBARQ,cTABELA , ctmp) 
        if len( aTAM ) > 0
           nLenMAX := aTAM[ 1 ]
        endif
    
        //Tipo integer 4 =numerico 8
        IF aStruct[i, DBS_TYPE]="I" //integer
           aStruct[i, DBS_TYPE]:="N"
           IF nLENMAX>8
              aStruct[i, DBS_LEN]=nLENMAX
           ELSE
              aStruct[i, DBS_LEN]=8
           ENDIF   
        ENDIF 

        //Tipo B double
        IF aStruct[i, DBS_TYPE]="B" 
           aStruct[i, DBS_TYPE]:="N"
           IF nLENMAX>15
             aStruct[i, DBS_LEN]=nLENMAX+ 4 //acrecenta 4 decimais
           ELSE
              aStruct[i, DBS_LEN]=15
           ENDIF   
           aStruct[i, DBS_LEN]=4
        ENDIF
     endif
     
     IF aStruct[i, DBS_TYPE]="I" .AND. (lmdb .or. Laccdb)
        aStruct[i, DBS_TYPE]:="N"
     ENDIF
     
     IF aStruct[i, DBS_TYPE]="L" .AND. (lmdb .or. Laccdb) .AND. aStruct[i, DBS_LEN]>1
        aStruct[i, DBS_LEN]:=1
     ENDIF
     
     aRETU:=geracampodbf(aStruct[i, DBS_NAME],aStruct[i, DBS_TYPE],aStruct[i, DBS_LEN],aStruct[i, DBS_DEC])
     
     aStruct[i, DBS_NAME]:=aRETU[DBS_NAME]
     aStruct[i, DBS_TYPE]:=aRETU[DBS_TYPE]
     aStruct[i, DBS_LEN] :=aRETU[DBS_LEN]
     aStruct[i, DBS_DEC] :=aRETU[DBS_DEC]
     
next i
return aStruct

function opencmdbarq()
local lRETU
lRETU:=.T.
DO CASE
    CASE lMDB //cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
        if loledb
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
        else
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
        endif 
    CASE lACCDB //cTIPOSQL="ACCDB"  .OR. cTIPOSQL="ACCDB64" 
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
    CASE cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"    
        USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA SQL  FROM cSERVERx  USER CUSERX PASSWORD CPASSX
    CASE cTIPOSQL="PGSQL" .or. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
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

DO CASE
   CASE lMDB 
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
   CASE lACDB 
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos accdb", "*.accdb", 1 )
   CASE cTIPOSQL="SQLITE" 
        cARQORI:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )  
ENDCASE


//cria com sql query create database
 if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"  ;
                     .OR. cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"
    cARQORI:=OPENTIPOARQ()
    cnewDATABASEX:=INPUTBOX(SPACE(30),"Novo database")
    cnewDATABASEX:=alltrim(cnewDATABASEX)
    IF .NOT. EMPTy(cnewDATABASEX)
       IF hb_AScan( MDBTABLES(), cnewDATABASEX,,, .T. ) > 0
           MDT("Ja existe Database "+cnewDATABASEX)
          return .f.
       ENDIF   
       cDATABASEX=""
       executacmd(Carqori,"CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
       CDATABASEX:=CNEWDATABASEX
    ENDIF  
endif 

//cria com catalogx
IF lMDB .OR. lACCDB 
   CreateAccessDatabase( cARQORI)   
   EXECUTACMD(cARQORI,"GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC")
   EXECUTACMD(cARQORI,"create view showtables as select name from MSysObjects where MSysObjects.type In (1,4,6) and MSysObjects.name not like '~*' and MSysObjects.name not like 'MSys%'")
ENDIF  

//cria com create native
IF cTIPOSQL="SQLITE"  
   createSqlitedb()
ENDIF
RETURN NIL

   
FUNCTION DBF2MDB(cMDBARQ,cDBFARQ)
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
    
    
    msql:=""
    DO CASE
       CASE cTIPOSQL="SQLITE"
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"SQLITE")
             executacmd(cMDBARQ,msql)
       CASE  cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB"
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MYSQL")
             executacmd(cMDBARQ,msql)
       CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"PGSQL")
             executacmd(cMDBARQ,msql)          
       CASE  lMDB //cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" 
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MDB")
             executacmd(cMDBARQ,msql)
        CASE lACCDB // cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
              msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"ACCDB")
             executacmd(cMDBARQ,msql)         
        CASE cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"  
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MSSQL")
             executacmd(cMDBARQ,msql)     
       OTHERWISE
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
    IF cTIPOSQL="PGSQL" .OR. cTIPOSQL="POSTGRESQL" .OR. cTIPOSQL="PGSQL64" //Dupla aspas maiuscula
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
   CASE lMDB //cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
        cDATABASEX:=cMDBARQ
   CASE lACCDB //cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos accdb", "*.accdb", 1 )
        cDATABASEX:=cMDBARQ
   CASE cTIPOSQL="SQLITE"     
        cMDBARQ:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )
        cDATABASEX:=cMDBARQ  
   CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" ;
                         .OR. cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"
         cSERVERX:=PADR(cSERVERX,30," ")
        // cDATABASEX:=PADR(cDATABASEX,30," ") escolhido nao precisa digitar
         cUSERX:=PADR(cUSERX,30," ")
         cPASSX:=PADR(cPASSX,30," ")
          HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
         @ 04,23 SAY "Server"
         //@ 06,23 SAY "Database"
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
   ShowADOError(oERR,oConn,cConn) 
   return aRETU
end


oRS:= WIN_OLECreateObject('ADODB.RecordSet')
oRS:CursorLocation := 3

cCOMANDO:=""
IF cTIPOINFO="DATABASE"
   DO CASE
     CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
         cCOMANDO = "SHOW DATABASES"
      CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
         cCOMANDO = "SELECT datname FROM pg_database;"    
      CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"  
         cCOMANDO = "SELECT name FROM master.dbo.sysdatabases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') "
   ENDCASE      
ENDIF
IF cTIPOINFO="TABELA"
    DO CASE
       CASE lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
            cCOMANDO = "select MSysObjects.name from MSysObjects where MSysObjects.type In (1,4,6) " ;
              + " and MSysObjects.name not like '~*'   and MSysObjects.name not like 'MSys%' " ;
               + " order by MSysObjects.name "
       CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0         
            cCOMANDO ="SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
       CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
            cCOMANDO = "SHOW TABLES"
       CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
           cCOMANDO ="SELECT tablename FROM pg_tables WHERE schemaname='public'"   
           //SELECT table_name  FROM information_schema.tables  WHERE table_type = 'BASE TABLE' AND table_schema='public'
        CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"    
           cCOMANDO ="SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';"
    endcase   
ENDIF
IF cTIPOINFO="ESTRUTURA"
    DO CASE
        CASE lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
       //Implantar possivelmente com catalogx
       CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0   
            cCOMANDO ="PRAGMA table_info( " +  cTABELA  + ")"   
       CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
            cCOMANDO ="SHOW COLUMNS FROM "+cTABELA
       CASE cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
           cCOMANDO ="SELECT   column_name,  udt_name,   character_maximum_length,   numeric_precision,  numeric_scale ,  data_type "
           cCOMANDO +=" FROM   information_schema.columns "
           cCOMANDO +=" WHERE   table_name = '"+UPPER(cTABELA)+"' ORDER BY ordinal_position ;" 
           //nome tabela em maiusculo postgresql e case sensitive  
           //udt_name melhor retorno mas tambem tras data_type caso necesario
           //where table_schema='public'  tras todas as tabelas do usurio(public)
       CASE cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER"     
         cCOMANDO ="select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='" +  cTABELA  + "'" 
    endcase   
ENDIF
IF cTIPOINFO="CCAMPOSQL"
   cCOMANDO:=cCAMPOSQL
ENDIF

lopen:=.f.
IF cTIPOINFO="ESTRUTURA" .AND. (LMDB .OR. lACCDB) 
    //abaixo com catalog
ELSE
      TRY
        oRS:Open(cCOMANDO, oConN, adOpenDynamic, adLockOptimistic )
        lOPEN:=.T.
      CATCH oERR
        lOPEN:=.F.
        ShowADOError(oERR,oConn,cCOMANDO) 
      END
ENDIF      


/* a vezes e preciso conceder este acesso na ide para a consulta na retornar vazia
cCOMANDO:="GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC" 

create view showtables as select name from MSysObjects where MSysObjects.type In (1,4,6) and MSysObjects.name not like '~*' and MSysObjects.name not like 'MSys%' 
//nao aceita order by na criacao da view

*/

IF .NOT. lOPEN
   IF lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
      EXECUTACMD(cdatabase,"GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC")
      EXECUTACMD(cdatabase,"create view showtables as select name from MSysObjects where MSysObjects.type In (1,4,6) and MSysObjects.name not like '~*' and MSysObjects.name not like 'MSys%'")
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
                   cFieldType  := upper( alltrim( ors:fields(2):value ) ) 
                   AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
               CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
                   //table info colunas
                   // field, type, null, key, default,extra
                   // 1      2     3      4      5      6
                   // 0      1     2      3      4      5 ->posicao no recordset
                   cFieldName := upper(alltrim( ors:fields(0):value ))
                   cFieldType  := upper( alltrim( ors:fields(1):value ) ) 
                   AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
               CASE  cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL" 
                   cFieldName := upper(alltrim( ors:fields(0):value )) //column_name
                   cFieldType := upper( alltrim( ors:fields(1):value ) ) // data_type
                   nFieldLength = fixnum(ors:fields(2):value) //tamanho string character_maximum_length
                   if fixnum(ors:fields(3):value)>0//tamannho numeric
                      nFieldLength = fixnum(ors:fields(3):value)  //numeric_precision
                      nFieldDec    = fixnum(ors:fields(4):value)  //numeric_scale
                   endif
                   AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))   
               CASE cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"       
                   //implantar                        
             ENDCASE   
            
         ENDIF   
        ors:movenext()
    enddo
    oRs:Close()
ENDIF

if LEN(aRETU)=0 .AND. cTIPOINFO="TABELA" 
    IF lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
       ocatalog:=win_oleCreateObject( "ADOX.Catalog" )  
       ocatalog:ActiveConnection :=  oConn
       lOPEN:=.F.
       TRY
            ocatalog := oConn:OpenSchema( adSchemaTables )
             lOPEN:=.T.
       CATCH oERR
             lOPEN:=.F. 
       END
       IF lOPEN
           while ! ocatalog:eof()
                 AADD(aRETU,ocatalog:Fields( "TABLE_NAME" ):Value) // ocatalog:fields(0):value)
                 ocatalog:movenext()
            enddo
           ocatalog:close()
        ENDIF
    ENDIF
endif

if LEN(aRETU)=0 .AND. cTIPOINFO="ESTRUTURA" 
    IF lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
       ocatalog:=win_oleCreateObject( "ADOX.Catalog" ) 
       ocatalog:ActiveConnection :=  oConn 
       lOPEN:=.F.
       TRY
            ocatalog := oConn:OpenSchema( adSchemaColumns )
             lOPEN:=.T.
       CATCH oERR
             lOPEN:=.F. 
       END
       IF lOPEN
           while ! ocatalog:eof()
                 IF UPPER(cTABELA)=UPPER(ocatalog:Fields( "TABLE_NAME" ):Value)
                    cFieldName := UPPER(ocatalog:Fields( "COLUMN_NAME" ):Value)
                    cFieldType := TipoDado2(ocatalog:Fields( "DATA_TYPE" ):Value)
                    nFieldLength := 0
                    nFieldDec := 0
                    If cTIPO = "C"
                        nFieldLength:=ocatalog:Fields( "CHARACTER_MAXIMUM_LENGTH" ):Value
                    ENDIF
                    If cTIPO = "N"
                        nFieldLength:=ocatalog:Fields( "NUMERIC_PRECISION" ):Value
                        nFieldDec   :=ocatalog:Fields( "NUMERIC_SCALE" ):Value
                    ENDIF
                    If cTIPO = "D"
                        nFieldLength:=ocatalog:Fields( "DATETIME_PRECISION" ):Value
                    ENDIF
                    AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))   
                 ENDIF
                 ocatalog:movenext()
            enddo
           ocatalog:close()
        ENDIF
    ENDIF
endif


oConN:close()  
RETURN aRETU 



Function TipoDado2(nTipo)
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



function geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec)   
local aRETU
local cSUBTIPO
aRETU:={cFieldName,cFieldType,nFieldLength,nFieldDec}  

cTYPE:=cFieldType
cSUBTIPO:=""
IF SUBSTR(cTYPE,2,1)=":"   //sqlimix manda tipo e subtipo exemplos N:i   C:CU  @:D
   cFieldType:=SUBSTR(cTYPE,1,1)
   cSUBTIPO  :=SUBSTR(cTYPE,3)
   cTYPE     :=SUBSTR(cTYPE,1,1)
ENDIF

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
       
 
  case  cType ==  "TINYINT"
    cFieldType := 'N'
    nFieldLength := 2
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
    
    
 case cType == "DATE" .or. cType == 'DATETIME' .or. cType == 'SHORTDATE' .or. cType == 'TIMESTAMP' ;
                      .OR. cType == "D" .OR. cType == "TYPE_TIMESTAMP"  .or. cType ==  "TYPE_DATE" 
    cFieldType := 'D'
    nFieldLength := 8
    nFieldDec := 0
    
case cType == "@" //Datetime opcao mudar como texto fututamente 
    cFieldType := 'D'
    nFieldLength := 8
    nFieldDec := 0    
    
 case cType == "BOOL"  .or. cType == 'BOOLEAN' 
    cFieldType := 'L'
    nFieldLength := 1
    nFieldDec := 0
    
    
  CASE cType == "TEXT" .AND. (cTIPOSQL="PGSQL"   .OR. cTIPOSQL="PGSQL64".OR. cTIPOSQL="POSTGRESQL" )
       cFieldType := 'C'
       nFieldLength := 250
       nFieldDec := 0
    
  CASE cType == "LONGTEXT" .OR. cType == "M"  .OR. cType == "WLONGVARCHAR"
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
  CASE cType == "VARCHAR" .OR. cType == "BPCHAR" .OR. AT("CHARACTER",UPPER(CTYPE))>0 .OR. cType == "WVARCHAR" .OR. cType == "WCHAR"
       cFieldType := 'C'
       nFieldDec := 0
  
  
  CASE cType == "NAME" 
       cFieldType := 'C'
       nFieldLength := 64
       nFieldDec := 0
       
   CASE cType == "C" .AND.   nFieldLength>250 //alguns longchar vem comprimento 65535 estudando mudar para memo por enquanto C 250
        nFieldLength := 250
   
   //
   // Inteiro sub numerico troca para numerico
   //
   CASE cType == "I" .AND. cSUBTIPO=="N"
       cFieldType := 'N'
   
   CASE cType == "OID" 
       cFieldType := 'N'
       nFieldLength := 19
       nFieldDec := 0    
       
 otherwise
       //mantem  os dados enviados 
    
endcase
//Inclusao rotina pegar max quando campo tamanho for zero

aRETU:={cFieldName,cFieldType,nFieldLength,nFieldDec} 
return aRETU

FUNCTION geraconn(cCAMBASE,lPROVIDER)
LOCAL cCONN
cConn  :=""
IF VALTYPE(cCAMBASE)<>"C" //ser for database nao tem caminho usa cservex
   cCAMBASE:="" //atribui vazio 
ENDIF
IF vALTYPE(lPROVIDER)<>"L"
   lPROVIDER:=.T.
ENDIF
DO CASE

   CASE lMDB .OR. at(".MDB",upper(cCAMBASE))>0  ///cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .or. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64"  .or. at(".MDB",upper(cCAMBASE))>0
        if loledb // provider ou driver que fixa o nome independente da versao do access sqlmix(usa driver) adordd(use provider)
            IF lPROVIDER
               cConn:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Mode=Share Deny None"  //32 bit jet oledb
            ELSE   
               cCONN:="Driver={Microsoft Access Driver (*.mdb)};Dbq="+cDATABASEX+";Mode=Share Deny None"
            ENDIF   
        else
            IF lPROVIDER
               cConn:="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+cCAMBASE+";Mode=Share Deny None" //64 bit ace oledb
            ELSE   
               cCONN:="Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq="+cDATABASEX+";Mode=Share Deny None" 
            ENDIF   
        endif
        
    CASE Laccdb .or. at(".ACCDB",upper(cCAMBASE))>0    //cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64" .or. at(".ACCDB",upper(cCAMBASE))>0    
        //provider ou driver que fixa o nome independente da versao do access sqlmix(usa driver) adordd(use provider)
        IF lPROVIDER
           cConn:="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+cCAMBASE+";Mode=Share Deny None" //driver 32 e 64 devem estar instalados
        ELSE   
           cCONN:="Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq="+cDATABASEX+";Mode=Share Deny None" 
        ENDIF   
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
   case cTIPOSQL="PGSQL"   .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
        //Driver={PostgreSQL ANSI};Server=IP address;Port=5432;Database=myDataBase;Uid=myUsername;Pwd=myPassword;
        if empty(cDATABASEX)
            if loledb
               cConn:="DRIVER={PostgreSQL ANSI};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX //+";pqopt={search_path=myschema,public}" //32 driver versao 
            else
               cConn:="DRIVER={PostgreSQL ANSI(x64)};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX //+";pqopt={search_path=myschema,public}"  //64 driver versao x64
            endif
        else
            if loledb
               cConn:="DRIVER={PostgreSQL ANSI};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX //+";pqopt={search_path=myschema,public}"  //32 driver versao 
            else
               cConn:="DRIVER={PostgreSQL ANSI(x64)};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX //+";pqopt={search_path=myschema,public}" //64 driver versao 964
            endif
        endif    
    CASE cTIPOSQL="MSSQL"  .OR. cTIPOSQL="SQLSERVER" .OR. cTIPOSQL="SQL"
         if empty(cDATABASEX)
            IF lPROVIDER
               cCONN:="Provider=SQLOLEDB;Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+cUSERX+";Pwd="+cPASSX+";" 
            ELSE
               cCONN:="Driver={SQL Server};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+cUSERX+";Pwd="+cPASSX+";" 
            ENDIF   
         else
            IF lPROVIDER
               cCONN:="Provider=SQLOLEDB;Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX+";" 
            ELSE
               cCONN:="Driver={SQL Server};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX+";" 
            
            ENDIF   
         endif
         
    CASE cTIPOSQL = "DBASE"
      cCONN := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Extended Properties=dBASE IV;"
   CASE cTIPOSQL = "FIREBIRD" // ADOGDB
      cCONN := "DRIVER=Firebird/InterBase(r) driver; UID="+cUSERX+"; PWD="+cPASSX+"; DBNAME="+cCAMBASE
   CASE cTIPOSQL = "PARADOX" // ADOPX
      cCONN := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Extended Properties=Paradox 5.x;" 
   CASE cTIPOSQL == "XMLDB" // ADOXML
      cCONN := "Provider=MSPersist"
   CASE cTIPOSQL == "XML" // ADOXML
      cCONN := "Provider=MSDAOSP;Data Source="+cCAMBASE+";" //MSXML2.DSOControl.2.6"
   CASE cTIPOSQL = "XLS" // ADOXLS
      cCONN :="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Extended Properties=Excel 8.0;HDR=Yes;IMEX=1"
   CASE cTIPOSQL = "REMOTE" // ADORDS
      cCONN := "Provider=MS Remote;Remote Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cDATABASEX+";Remote Server=" + cSERVERX
         
         
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
   ShowAdoError(oERR,oCoNn)   
   return .f.
end

try
  oComm:=WIN_OLECreateObject( "ADODB.Command" )
catch oErr
    ShowAdoError(oERR,oCoNn)   
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

   oCatalog := WIN_OLECreateObject( "ADOX.Catalog" )  //CreateObject( "ADOX.Catalog" )
   
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


Function SQLDialeeto(cSQLCNV)
     DO CASE
            Case cTIPOSQL= "SQLITE"
               //  '"LOWER(%1%)"        ,"LOWER(%1%)"
               //  '"UPPER(%1%)"        ,"UPPER(%1%)"
                 cSQLCNV = STRTRAN(cSQLCNV, "TODAY()", "CURRENT_DATE ")
                 cSQLCNV = STRTRAN(cSQLCNV, "CHR(", "CHAR(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ASC(", "ASCII(")
                 cSQLCNV = STRTRAN(cSQLCNV, "TRIM(", "RTRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ALLTRIM(", "TRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "LEN(", "LENGTH(")
                 cSQLCNV = STRTRAN(cSQLCNV, "CURRENTDATETIME", " current_timestamp ")
               // '  {"LEFT(%1%,%2%)"      ,"SUBSTR(%1%,1,%2%)"},;
               // '        {"DTOS(%1%)"        ,"strftime('%Y%m%d',%1%)"},;
               // '        {"DAY(%1%)"       ,"cast(strftime('%d',%1) as int)"},;
               // ''        {"MONTH(%1%)"       ,"cast(strftime('%m',%1) as int)"},;
               // '        {"YEAR(%1%)"        ,"cast(strftime('%Y',%1) as int)"},;
               // '        {"REPL(%1%,%2%)"      ,"FORMAT('%.*c',%2%,%1%)"},;
            Case cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB"
               //  '"LOWER(%1%)"        ,"LOWER(%1%)"
               //  '"UPPER(%1%)"        ,"UPPER(%1%)"
               //  '"LEFT(%1%,%2%)"     ,"LEFT(%1%,%2%)"
               //  '"DAY(%1%)"         ,"DAY(%1%)"
               //  '"MONTH(%1%)"       ,"MONTH(%1%)"}
               //  '"YEAR(%1%)"        ,"YEAR(%1%)"
                 cSQLCNV = STRTRAN(cSQLCNV, "TODAY()", "SYSDATE()")
                 cSQLCNV = STRTRAN(cSQLCNV, "CHR(", "CHAR(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ASC(", "ASCII(")
                 cSQLCNV = STRTRAN(cSQLCNV, "TRIM(", "RTRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ALLTRIM(", "TRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "REPL(", "REPEAT(")
          //      '        {"DTOS(%1%)"        ,"DATE_FORMAT(%1%,'%Y%m%d')"},;
            Case cTIPOSQL="PGSQL"   .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="POSTGRESQL"
            //     '"LOWER(%1%)"        ,"LOWER(%1%)"
            //     '"UPPER(%1%)"        ,"UPPER(%1%)"
            //     '"LEFT(%1%,%2%)"      ,"LEFT(%1%,%2%)"
            //     '"CHR(%1%)"         ,"CHR(%1%)"
                 cSQLCNV = STRTRAN(cSQLCNV, "TODAY()", "CURRENT_DATE ")
                 cSQLCNV = STRTRAN(cSQLCNV, "ASC(", "ASCII(")
                 cSQLCNV = STRTRAN(cSQLCNV, "TRIM(", "RTRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ALLTRIM(", "TRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "LEN(", "LENGTH(")
                 cSQLCNV = STRTRAN(cSQLCNV, "DAY(", "EXTRACT('DAY' FROM ")
                 cSQLCNV = STRTRAN(cSQLCNV, "MONTH(", "EXTRACT('MONTH' FROM ")
                 cSQLCNV = STRTRAN(cSQLCNV, "YEAR(", "EXTRACT('YEAR' FROM ")
                 cSQLCNV = STRTRAN(cSQLCNV, "REPL(", "REPEAT(")
            Case cTIPOSQL="MSSQL"  .OR. cTIPOSQL="SQLSERVER"
                 cSQLCNV = STRTRAN(cSQLCNV, "TODAY()", "GETDATE() ")
                 cSQLCNV = STRTRAN(cSQLCNV, "ASC(", "ASCII(")
                 cSQLCNV = STRTRAN(cSQLCNV, "TRIM(", "RTRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ALLTRIM(", "TRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "REPL(", "REPLICATE(")
                 cSQLCNV = STRTRAN(cSQLCNV, "CHR(", "CHAR(")
                 cSQLCNV = STRTRAN(cSQLCNV, "SUBSTR(", "SUBSTRING(")
       //          '  {"STR(%1%,%2%,%3%)"      ,"STR(%1%,%2%,%3%)"},;
      //           '       {"STR(%1%,%2%)"       ,"STR(%1%,%2%,0)"},;
      //             '     {"DTOS(%1%)"        ,"CONVERT(char(8), %1%,11)"},;
      //            '      {"IIF(%1%,%2%,%3%)"     ,"CASE WHEN %1% THEN %2% ELSE %3% END"},;
            
      //      Case "ODBC"
            /*
        '       {"STR(%1%,%2%,%3%)"      ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,%3%)},SQL_VARCHAR)},%2%)}"},;
        '                {"STR(%1%,%2%)"       ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,0)},SQL_VARCHAR)},%2%)}"},;
         '               {"SUBSTR(%1%,%2%,%3%)"    ,"{fn SUBSTRING(%1%,%2%,%3%)}"},;
          '              {"DTOS(%1%)"        ,"{fn CONVERT({fn YEAR(%1%)}, SQL_VARCHAR)}+{fn RIGHT('0'+ {fn CONVERT({fn MONTH(%1%)},SQL_VARCHAR)},2)}+{fn RIGHT('0'+ {fn CONVERT({fn DAYOFMONTH(%1%)},SQL_VARCHAR)},2)}"},;
      '                  {"DAY(%1%)"         ,"{fn DAYOFMONTH(%1%)}"},;
     '                   {"MONTH(%1%)"       ,"{fn MONTH(%1%)}"},;
      '                  {"YEAR(%1%)"        ,"{fn YEAR(%1%)}"},;
         '               {"UPPER(%1%)"       ,"{fn UCASE(%1%)}"},;
         '               {"LOWER(%1%)"       ,"{fn LCASE(%1%)}"},;
         '               {"LEFT(%1%,%2%)"      ,"{fn LEFT(%1%,%2%)}"},;
          '              {"LEN(%1%)"         ,"{fn LENGTH(%1%)}"},;
         '               {"CHR(%1%)"         ,"{fn CHAR(%1%)}"},;
         '               {"ASC(%1%)"         ,"{fn ASCII(%1%)}"},;
         '               {"TODAY()"          ,"{fn CURDATE()}"},;
         '               {"REPL(%1%,%2%)"      ,"{fn REPEAT(%1%,%2%)}"},;
         '               {"TRIM(%1%)"        ,"{fn RTRIM(%1%)}"},;
         ''               {"ALLTRIM(%1%)"       ,"{fn LTRIM( {fn RTRIM(%1%) } )}"},;
         '               {"RIGHT(%1%)"       ,"{fn RIGHT(%1%)}"},;
            */
           
           // Case "ADS", "ADVANTAGE"
           
           
        //    Case "OLEDB"
            /*
   '    {"STR(%1%,%2%,%3%)"      ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,%3%)},SQL_VARCHAR)},%2%)}"},;
   '                     {"STR(%1%,%2%)"       ,"{fn RIGHT({fn SPACE(%2%)}+{fn CONVERT({fn ROUND(%1%,0)},SQL_VARCHAR)},%2%)}"},;
   '                     {"SUBSTR(%1%,%2%,%3%)"    ,"{fn SUBSTRING(%1%,%2%,%3%)}"},;
   '                     {"DTOS(%1%)"        ,"{fn CONVERT({fn YEAR(%1%)}, SQL_VARCHAR)}+{fn RIGHT('0'+ {fn CONVERT({fn MONTH(%1%)},SQL_VARCHAR)},2)}+{fn RIGHT('0'+ {fn CONVERT({fn DAYOFMONTH(%1%)},SQL_VARCHAR)},2)}"},;
   '                     {"DAY(%1%)"         ,"{fn DAYOFMONTH(%1%)}"},;
   '                     {"MONTH(%1%)"       ,"{fn MONTH(%1%)}"},;
   '                     {"YEAR(%1%)"        ,"{fn YEAR(%1%)}"},;
   '                     {"UPPER(%1%)"       ,"{fn UCASE(%1%)}"},;
   '                     {"LOWER(%1%)"       ,"{fn LCASE(%1%)}"},;
   '                     {"LEN(%1%)"         ,"{fn LENGTH(%1%)}"},;
   '                     {"CHR(%1%)"         ,"{fn CHAR(%1%)}"},;
   '                     {"ASC(%1%)"         ,"{fn ASCII(%1%)}"},;
   '                     {"TODAY()"          ,"{fn CURDATE()}"},;
   '                     {"REPL(%1%,%2%)"      ,"{fn REPEAT(%1%,%2%)}"},;
   '                     {"TRIM(%1%)"        ,"{fn RTRIM(%1%)}"},;
   '                     {"ALLTRIM(%1%)"       ,"{fn LTRIM( {fn RTRIM(%1%) } )}"},;
   '                     {"LEFT(%1%,%2%)"      ,"{fn LEFT(%1%,%2%)}"},;
   '                     {"RIGHT(%1%)"       ,"{fn RIGHT(%1%)}"},;
            */
            Case "ORACLE", "OCI"
                 cSQLCNV = STRTRAN(cSQLCNV, "TODAY()", "SYSDATE ")
                 cSQLCNV = STRTRAN(cSQLCNV, "CHR(", "CHAR(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ASC(", "ASCII(")
                 cSQLCNV = STRTRAN(cSQLCNV, "TRIM(", "RTRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "ALLTRIM(", "LTRIM(RTRIM(")
                 cSQLCNV = STRTRAN(cSQLCNV, "LEN(", "LENGTH(")
                 cSQLCNV = STRTRAN(cSQLCNV, "REPL(", "REPLICATE(")
          //   '  {"LEFT(%1%,%2%)"     ,"SUBSTR(%1%,1,%2%)"},;
           //  '           {"DTOS(%1%)"        ,"TO_CHAR(%1%,'YYYYMMDD')"},;
           //  '           {"DAY(%1%)"         ,"TO_NUM(TO_CHAR(%1%,'DD'))"},;
           //  '           {"MONTH(%1%)"       ,"TO_NUM(TO_CHAR(%1%,'MM'))"},;
           //  '           {"YEAR(%1%)"        ,"TO_NUM(TO_CHAR(%1%,'YYYY'))"},;
            
            Case lMDB .OR. lACCDB
                 cSQLCNV = STRTRAN(cSQLCNV, "CURRENTDATETIME", " now ")
   
     EndCASE
RETURN cSQLCNV

