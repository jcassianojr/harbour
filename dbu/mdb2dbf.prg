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
    OPCAO(  4, 24, "&Criar arquivo             ", 67 ) //c 67
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
LOCAL cTABELA:=SPACE(60)
LOCAL cCAMMDB   :=SPACE(100)
LOCAL lCOPIANAT
local Ldoc
LOCAL aTABELAS
LOCAL nCHOICES
LOCAL cMDBARQ

nCHOICES:=0
aTABELAS:={}

cMDBARQ:=OPENTIPOARQ()


aResult:=MDBTABLES(cMDBARQ,loledb )
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
pegparexp()

hb_FNameSplit(cMDBARQ , @cCAMMDB, NIL, NIL )
cDESTINO:=cCAMMDB+cTABELA+"."+zEXPOREXT
MDT(cDESTINO)


lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "
IF .NOT.  lCOPIANAT
   PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF

MDT("abrindo arquivo de origem: "+cMDBARQ)
opencmdbarq()
nLASTREC:=   reccount() 
zei_fort( nLASTREC,,,0)
IF lCOPIANAT
   COPYTO(cDESTINO)
ELSE
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO))
ENDIF   
dbcloseall()
return nil

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
   CASE cTIPOSQL="MDB"
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
        //necessario uma tabela para criar
        Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
   CASE cTIPOSQL="SQLITE" 
        cARQORI:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )  
   CASE cTIPOSQL="MYSQL"  
   CASE cTIPOSQL="MYSQL64"  
   CASE cTIPOSQL="MARIADB"  
ENDCASE

 cCONCREATE:=criaconcreate(cARQORI,'table1')

 do case
    
    otherwise
       dbCreate( cCONCREATE, { ;
            { "FIRST",   "C", 10, 0 }, ;
            { "LAST",    "C", 10, 0 }, ;
            { "AGE",     "N",  8, 0 }, ;
            { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
endcase            
IF cTIPOSQL="MDB"      
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )   
ENDIF
RETURN NIL


/* sequencia dos parametros adordd
 LOCAL cDataBase  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 1, ";" )
   LOCAL cTableName := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 2, ";" )
   LOCAL cDbEngine  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 3, ";" )
   LOCAL cServer    := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 4, ";" )
   LOCAL cUserName  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 5, ";" )
   LOCAL cPassword  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 6, ";" )
*/   

function criaconcreate(cMDBARQ,cNOMETABELA)
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

    msqlindex:=""
     //Cria do os indices append from nao faz  
     for j=1 to nIndexes
        Msql=Aindices[j]
        msqlindex:= msqlindex+msql+hb_osnewline()
        executacmd(cMDBARQ,msql)
     next j
     
      IF lGRAVASQL.AND. .NOT. EMPTY(msqlindex)
       MEMOWRIT(cNOMETABELA+"_createindex_"+cTIPOSQL+".sql",Msqlindex)
    ENDIF

    
    cTABELA:=cNOMETABELA //publica usada o opencmdarq
    opencmdbarq()
    append from &cDBFARQ. WHILE zei_fort(nLASTREC,,,1)
    dbcloseall()
    
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
        
        
FUNCTION MDBTABLES(cDataBase,lUSEOLE )
LOCAL aRETU
local cCONN
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

      TRY
        oRS:Open(cCOMANDO, oConN, adOpenDynamic, adLockOptimistic )
      CATCH oERR
        //ShowADOError(oERR,oConn,cCOMANDO) 
        return  aRETU 
      END

while ! ors:eof
     AADD(aRETU,ors:fields(0):value)  //ors:fields(0) inicia as colunas com zero ou pelo nome da coluna fields("name")
    ors:movenext()
enddo

oRs:Close()
oConN:close()  
RETURN aRETU       

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
        if loledb
           cConn:="Driver={MySQL ODBC 8.0 ANSI Driver};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //32 driver versao 8 
        else
           cConn:="Driver={MySQL ODBC 9.0 ANSI Driver};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //64 driver versao 9 
        endif
   case cTIPOSQL="MARIADB"   
        cConn:="DRIVER={MariaDB ODBC 3.2 Driver};DATABASE="+cDATABASEX+";SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
ENDCASE      
RETURN cConn   




Function executacmd(cCAMBASE,cCOMANDO)
LOCAL cCHAVEV
LOCAL cConn
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

oComm:=WIN_OLECreateObject( "ADODB.Command" )
  try
      with object oComm
          :CommandText:=cCOMANDO
          :CommandType:=adCmdText
          :ActiveConnection:=oConn
          :Execute()
      end
  end

oConn:Close()
oConn:=NIL		
RETURN .t.
