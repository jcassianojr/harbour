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

cSERVERX:="Localhost"+space(21)
cDATABASEX:=space(30)
cUSERX    :=SPACE(30)
cPASSX    :=SPACE(30)

IF cTIPOSQL="MYSQL" .OR. cTIPOSQL="MARIADB" 
   OPENTIPOARQ()
ENDIF



loledb=.T.
IF cTIPOSQL="MDB"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64  //mdg("User sim=oledb(32b) nao=accdb(64b)")
ENDIF 
IF cTIPOSQL="MYSQL"
   loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64 //mdg("User sim=odbc 8.0(32b) nao=odbc 9.0(64b)")
ENDIF 
  

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    DO CASE
       CASE cTIPOSQL="MDB"
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
    if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF"
       OPCAO(  4, 24, "&Criar database             ", 67 ) //c 67
    else
       OPCAO(  4, 24, "&Criar arquivo              ", 67 ) //c 67
    endif   
    OPCAO(  5, 24, "                           ", 86 ) //V 86
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 73 
    OPCAO(  7, 24, "&Exportar Tabelas          ", 69 ) //E 69
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
           mdbcria()
       CASE KEY=2
       CASE KEY=3
            MDBIMPDBF()
       CASE KEY=4
            MDBEXP()
       OTHERWISE
            EXIT
    ENDCASE
ENDDO

RESTAA(aAMBIENTE)
layout()
return nil

function MDBEXP()
LOCAL cCAMMDB   :=SPACE(100)
LOCAL lCOPIANAT
local Ldoc
LOCAL aTABELAS
LOCAL nCHOICES
LOCAL aSTRU

nCHOICES:=0
aTABELAS:={}

cMDBARQ:=OPENTIPOARQ()


aResult:=MDBTABLES(cMDBARQ )
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cTABELA:=IIF( nChoices > 0, aResult[ nChoices ], "")


cTABELA:=ALLTRIM(cTABELA)
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
cDESTINO:=cCAMMDB+cTABELA+"."+zEXPOREXT
MDT(cDESTINO)


MDT("abrindo arquivo de origem: "+cMDBARQ)
opencmdbarq()
nLASTREC:=   reccount() 
zei_fort( nLASTREC,,,0)
aSTRU:=dbstruct()
IF lCOPIANAT
   COPYTO(cDESTINO)
ELSE
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO))
ENDIF   
dbcloseall()

aSTRU:=sqltodbfstru(aSTRU)
memowrit(ctabela+"_"+Ctiposql+"_stru.txt",strval(aSTRU))

aSTRU:=MDBTABLES(cMDBARQ,cTABELA )
memowrit(ctabela+"_"+Ctiposql+"_stru2.txt",strval(aSTRU))


//DBCreate(<cDatabase>, <aStruct>, <cDriver> ) -> Nil

return nil

function sqltodbfstru(aStruct)
local nFIM 
local i
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
    
    // Casos datasting que nao retornam 8
    IF aStruct[i, DBS_TYPE]="D" .AND. aStruct[i, DBS_LEN]<>8
       aStruct[i, DBS_LEN]=8
    ENDIF
    
    //Tipo integer 4 =numerico 8
    IF aStruct[i, DBS_TYPE]="I" //integer
       aStruct[i, DBS_TYPE]="N"
       aStruct[i, DBS_LEN]=8
    ENDIF 

    //Tipo B
    IF aStruct[i, DBS_TYPE]="B" 
       aStruct[i, DBS_TYPE]="N"
       aStruct[i, DBS_LEN]=15
       aStruct[i, DBS_LEN]=4
    ENDIF

next i
return aStruct

function opencmdbarq()
DO CASE
    CASE cTIPOSQL="MDB"
        if loledb
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
        else
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
        endif 
    CASE cTIPOSQL="SQLITE"  
         USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA SQLITE
    CASE cTIPOSQL="MYSQL"
        if loledb
            USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA MYSQL    FROM cSERVERx  USER CUSERX PASSWORD CPASSX
        else
            USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA MYSQL64  FROM cSERVERx  USER CUSERX PASSWORD CPASSX
        endif    
    CASE cTIPOSQL="MARIADB"     
        USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA MARIADB  FROM cSERVERx  USER CUSERX PASSWORD CPASSX
ENDCASE
return .t.



function mdbcria()
local cCONCREATE
cCONCREATE:=""

DO CASE
   CASE cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
        //necessario uma tabela para criar
        
   CASE cTIPOSQL="SQLITE" 
        cARQORI:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )  
          
   CASE cTIPOSQL="MYSQL"  .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF"
      //con sql create database
      
ENDCASE



 if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF"
    cARQORI:=OPENTIPOARQ()
    cNEXDATABASEX:=SPACE(40)
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


//criar opcao para access644 nao funciona com catalogo nem  com o adordd
IF loledb .AND. (cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" ) //32 Cria com catalog
   CreateAccessDatabase( cARQORI)
ENDIF  

IF cTIPOSQL="SQLITE" .OR. ((cTIPOSQL="MDB" .OR. cTIPOSQL="SQLITE") .AND. .NOT. loledb) //cria com adorrdd 64 acess ou sqlite
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
       CASE cTIPOSQL="MDB"
            IF  loledb
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA
            else
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
            endif
       CASE cTIPOSQL="SQLITE"  
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";SQLITE"
       CASE cTIPOSQL="MYSQL"  
           if loledb
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MYSQL;"+cSERVERX+";"+CUSERX+";"+cPASSX
            else    
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MYSQL64;"+cSERVERX+";"+CUSERX+";"+cPASSX
            endif   
       CASE cTIPOSQL="MARIADB"  
           cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MARIADB;"+cSERVERX+";"+CUSERX+";"+cPASSX
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
            .OR. cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"
             //Abaixo com executacmd ja com estrutura ajustada pela funcao
       OTHERWISE
          dbCreate( cCONCREATE, aSTRU,"ADORDD" )
    ENDCASE      
    
    msql:=""
    DO CASE
       CASE cTIPOSQL="SQLITE"
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"SQLITE")
             executacmd(cMDBARQ,msql)
       CASE  cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADBF"
             msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MYSQL")
             executacmd(cMDBARQ,msql)
       CASE  cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"    
              msql:= SqliteCreateTable(cNOMETABELA,aSTRU,"MDB")
             executacmd(cMDBARQ,msql)
       OTHERWISE
            //criado acima pela funcao
    ENDCASE      
    
    IF lGRAVASQL.AND. .NOT. EMPTY(msql)
       MEMOWRIT(cNOMETABELA+"_createtable_"+cTIPOSQL+".sql",Msql)
    ENDIF

    if len(aindices)>0
        //Cria do os indices append from nao faz    
        Executacmd(cMDBARQ,Aindices) //Executa comando unico ou array de comandos
        
        IF lGRAVASQL
           MEMOWRIT(cNOMETABELA+"_createindex_"+cTIPOSQL+".sql",STRVAL(aINDICES))
        endif
    endif    
    
    cTABELA:=cNOMETABELA //publica usada o opencmdarq
    if nLASTREC>0 //nao importa se nao tiver registros
      opencmdbarq()
      append from &cDBFARQ. WHILE zei_fort(nLASTREC,,,1)
      dbcloseall()
    endif  
      
    Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
    
     
RETURN .T.    

FUNCTION OPENTIPOARQ
LOCAL cMDBARQ
cMDBARQ:=""
DO CASE
   CASE cTIPOSQL="MDB"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
   CASE cTIPOSQL="SQLITE"     
        cMDBARQ:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )
   CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
         cSERVERX:=PADR(cSERVERX,30," ")
         cDATABASEX:=PADR(cDATABASEX,30," ")
         cUSERX:=PADR(cUSERX,30," ")
         cPASSX:=PADR(cPASSX,30," ")
          HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
         @ 04,23 SAY "Server"
         @ 06,23 SAY "Database"
         @ 08,23 SAY "user"
         @ 10,23 say "pass"
         @ 05,23 get cSERVERX
         @ 07,23 gET cDATABASEX
         @ 09,23 get cuserx
         @ 11,23 get cpassx
         READ
         cSERVERX:=ALLTRIM(cSERVERX)
         cDATABASEX:=ALLTRIM(cDATABASEX)
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
        
        
FUNCTION MDBTABLES(cDataBase,cTABELA )
LOCAL aRETU
local cCONN
LOCAL cCOMANDO
LOCAL cTIPOINFO
local cFieldName := ''
local cFieldType := ''
local nFieldLength := 0
local nFieldDec := 0

cTIPOINFO:="TABELA"
IF VALTYPE(cTABELA)="C"
   cTIPOINFO:="ESTRUTURA"
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
cCOMANDO:="GRANT SELECT ON TABLE MSysObjects TO ADMIN" //PUBLIC 
*/

oRS:= WIN_OLECreateObject('ADODB.RecordSet')
oRS:CursorLocation := 3

cCOMANDO:=""
IF cTIPOINFO="TABELA"
    DO CASE
       CASE cTIPOSQL="MDB" .or. at(".MDB",upper(cdatabase))>0
            cCOMANDO = "select MSysObjects.name from MSysObjects where MSysObjects.type In (1,4,6) " ;
              + " and MSysObjects.name not like '~*'   and MSysObjects.name not like 'MSys%' " ;
               + " order by MSysObjects.name "
       CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0         
            cCOMANDO ="SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
       CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
            cCOMANDO = "SHOW TABLES"
    endcase   
ENDIF
IF cTIPOINFO="ESTRUTURA"
    DO CASE
       CASE cTIPOSQL="MDB" .or. at(".MDB",upper(cdatabase))>0
       CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cdatabase))>0   
            cCOMANDO ="PRAGMA table_info( " +  cTABELA  + ")"   
       CASE cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64"  .OR. cTIPOSQL="MARIADB"
            cCOMANDO ="SHOW COLUMNS FROM "+cTABELA
    endcase   
ENDIF

      TRY
        oRS:Open(cCOMANDO, oConN, adOpenDynamic, adLockOptimistic )
      CATCH oERR
        //ShowADOError(oERR,oConn,cCOMANDO) 
        return  aRETU 
      END

while ! ors:eof
     IF cTIPOINFO="TABELA"
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
                 
               
         ENDCASE   
        
     ENDIF   
    ors:movenext()
enddo
oRs:Close()
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
       nLength := val(cTMPSIZE)
       cTMPSIZE:=SUBSTR(cTYPE, AT(",",cTYPE) +1 )
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE)-1 )
       nFieldDec := val(cTMPSIZE)
       cFieldType := 'N'


    //
    // int(n) tamanho esta entre parentes
    //
   case AT("(",cTYPE)>0 .AND. AT(")",cTYPE)>0  .AND. AT(",",cTYPE)=0 .AND. AT("INT",UPPER(CTYPE))>0 
       cTMPSIZE:=SUBSTR(cTYPE, AT("(",cTYPE) +1) 
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE)-1 )
       nLength := VAL(cTMPSIZE)
       cFieldType := 'N'
       nFieldDec := 0
   
    //
    // char(n) text(n) o tamanho esta entre parentes
    //
   case AT("(",cTYPE)>0 .AND. AT(")",cTYPE)>0 .AND. (AT("CHAR",UPPER(CTYPE))>0 .OR. AT("TEXT",UPPER(CTYPE))>0 )
       cTMPSIZE:=SUBSTR(cTYPE, AT("(",cTYPE) +1) 
       cTMPSIZE:=SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE)-1 )
       nLength := VAL(cTMPSIZE)
       cFieldType := 'C'
       nFieldDec := 0
       
    
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
    
   //
    // TEXT SEM tamanho memo
    //
  case  AT("(",cTYPE)=0 .AND. AT(")",cTYPE)=0 .AND.  AT("TEXT",UPPER(CTYPE))>0
       nFieldLength := 10
       cFieldType := 'M'
       nFieldDec := 0
       
       
 otherwise
    cFieldType := 'C'
    nFieldDec := 0
    nLength := 0
    
    //
    // Implantar posteriormente especifico sqllite
    //
    //IF nLENGTH=0
    //    aTable1 := sqltablestru( oDB1, 'select max( length( ' + cFieldName + ' ) ) from ' + c2sql( cSQLTable ) )
    //    nLength := 0
    //    if len( aTable1 ) > 0
    //       nLength := val( alltrim( aTable1[ 1, 1 ] ) )
    //    endif
    //ENDIF    
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
aRETU:={cFieldName,cFieldType,nFieldLength,nFieldDec} 
return aRETU

FUNCTION geraconn(cCAMBASE)
cConn  :=""
DO CASE

   CASE cTIPOSQL="MDB" .or. at(".MDB",upper(cCAMBASE))>0
        if loledb
           cConn:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Mode=Share Deny None"  //32 bit jet oledb
        else
           cConn:="Provider=Microsoft.ACE.OLEDB.16.0;Data Source="+cCAMBASE+";Mode=Share Deny None" //64 bit ace oledb
        endif

   CASE cTIPOSQL="SQLITE" .or. at(".SQLITE",upper(cCAMBASE))>0
        cConn:="Driver={SQLite3 ODBC Driver};Database=" + cCAMBASE + ";"

    CASE cTIPOSQL="MYSQL" 
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
   case cTIPOSQL="MARIADB"   
        if empty(cDATABASEX)
            cConn:="DRIVER={MariaDB ODBC 3.2 Driver};SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
        else
           cConn:="DRIVER={MariaDB ODBC 3.2 Driver};DATABASE="+cDATABASEX+";SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
        endif   
   case cTIPOSQL="PGSQL"   
         //Driver={PostgreSQL ANSI};Server=IP address;Port=5432;Database=myDataBase;Uid=myUsername;Pwd=myPassword;
        IF loledb
            if empty(cDATABASEX)
                cConn:="DRIVER={PostgreSQL ANSI};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX
            else
               cConn:="DRIVER={PostgreSQL ANSI(x64)};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX
            endif
        else
            if empty(cDATABASEX)
                cConn:="DRIVER={PostgreSQL ANSI};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX
            else
               cConn:="DRIVER={PostgreSQL ANSI(x64)};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX
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
   
   
   
 //if loledb
   oCatalog:Create( "Provider=Microsoft.Jet.OLEDB.4.0;" +;
                      "Data Source=" + cDatabase + ";" +;
                      "JET OLEDB:Engine Type=4;" )
// else
 
 //  oCatalog:Create( "Provider=Microsoft.ACE.OLEDB.16;" +;
 //                     "Data Source=" + cDatabase + ";" +;
 //                     "JET OLEDB:Engine Type=4;" )
//endif   

/*
   oCatalog:Create( "Provider=Microsoft.Jet.OLEDB.4.0;" +;
                    "Data Source=" + cDatabase + ";" +;
                    "JET OLEDB:Database Password=" + cPassWord + ";" +;
                    "JET OLEDB:Engine Type=4;" +;
                    "JET OLEDB:Encrypt Database=" + IIF(lEncrypt, "TRUE", "FALSE" ) )
*/

                    

   oCatalog := NIL //NULL_OBJECT

RETURN
