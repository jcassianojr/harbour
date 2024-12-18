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
//REQUEST SDDOCI //erro ao iniciar dbu testar outras versoes ocilib.dll

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

//Mariadb MSSQL nao tem nativo
IF cTIPOSQL="MARIADB" .OR. cTIPOSQL="MSSQL" .OR. cTIPOSQL="SQLSERVER" 
   cTIPOMIX:="ODBC"
ENDIF

//ORACLE COMO ODBC ate ajustar ocilib
IF cTIPOSQL="ORACLE" .OR. cTIPOSQL="OCI"
   cTIPOMIX:="ODBC"
ENDIF

//access mdb accdb nao tem nativo
IF Lmdb .or. laccdb 
   cTIPOMIX:="ODBC"
   OPENTIPOARQ()
ENDIF
//Verifica novamentes apos opentipoarq
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
//mix_open()

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    @ 03,24 SAY "SQLMIX"+" "+cTIPOSQL+" "+cDATABASEX
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
            mix_open()
            mixcreatedatabase()
            mix_close()
       CASE KEY=2
            IF lMDB .OR. lACCDB
            ELSE
                mdbdatabases()
            ENDIF    
       CASE KEY=3
            miximpdbf()
       CASE KEY=4
            mdbtabela(cdatabasex)          
       CASE KEY=5
            mixexpdbf(1)
       CASE KEY=6
            mdbtabela(cdatabasex)
            IF MDG("Apagar Tabela"+cTABELAX)  
               mix_open() 
               mix_executesql("DROP TABLE  "+cTABELAX) 
               mix_close()
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
  
  //cria um arrayrdd para usar na exportacao usar memoria mudar para rdd quando disponivel
 // dbCreate( cFile, aStruct, cRDD, lKeepOpen, cAlias, cDelimArg, cCodePage, nConnection ) --> <lSuccess>
  //nao passa o driver sqlmix ja e default rddSetDefault( "SQLMIX" ) 
   //nao precisa abrir area lKeepOpen 4 parametro mantem aberto 
  dbCreate( "DESTINO" , aSTRU, , .T., "DESTINO"  )
  
endif


dbselectar("ORIGEM")
dbgotop()
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
    mix_open()  
    mix_executesql(msql) 
    if len(aindices)>0
        mix_executesql(Aindices) //Executa comando unico ou array de comandos
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
      mix_executesql(msql)
      dbskip()
   enddo
    
    dbclosearea()
    mix_close()
return .t.

function mixcreatedatabase()
cnewDATABASEX:=INPUTBOX(SPACE(30),"Novo database")
cnewDATABASEX:=alltrim(cnewDATABASEX)
IF ! EMPTY(cnewDATABASEX)
   if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" ;
                       .OR. cTIPOSQL="MSSQL"   .OR. cTIPOSQL="SQLSERVER"
       mix_executesql("CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
       //fechar a connecao e trocar o database
       //CDATABASEX:=CNEWDATABASEX
   ENDIF
   IF cTIPOSQL="SQLITE" .OR. cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64" .OR. cTIPOSQL="ACCDB64"
      mdbcria()
   ENDIF
ENDIF


function mix_executesql(eCOMANDO,lTRANS,lMES)
LOCAL aCOMANDOS:={}
LOCAL nFIM
LOCAL i
Local lRet
lRET:=.T.
IF VALTYPE(LMES)<>"L"
   lMES:=.F.
ENDIF
IF VALTYPE(eCOMANDO)="C"
   AAdd(aCOMANDOS,eCOMANDO) 
ELSE
   aCOMANDOS:=eCOMANDO
ENDIF
nFIM:=LEN(aCOMANDOS)
IF lTRANS
   RDDINFO( RDDI_EXECUTE, "BEGIN TRANSACTION")
ENDIF
for i:=1 to nfim
    cCOMANDO:=aCOMANDOS[I]
    lRet :=rddInfo( RDDI_EXECUTE, cCOMANDO )
    IF RDDINFO(RDDI_ERRORNO) = 9999
			* da este error cuando delete no encuentra nada que borrar. No debería dar error.
			lRet := .T.
	else
       if Lmes
          MDT(cstr(RDDINFO(RDDI_ERROR))+" Error "+cstr(RDDINFO(RDDI_ERRORNO)))
       endif
    endif
next i
IF lTRANS
   RDDINFO(RDDI_EXECUTE, "COMMIT TRANSACTION")
ENDIF
//RDDINFO(RDDI_EXECUTE, "ROLLBACK TRANSACTION")
RETURN lRet 

Function mix_Query()		// returns last sql instruction
Return RDDINFO( RDDI_QUERY )

FUNCTION mix_open() 
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
   CASE cTIPOMIX="ORACLE"   
        nCONN:=rddInfo( RDDI_CONNECT, { "OCILIB", cSERVERX, cUSERX, cPASSX, cDATABASEX} )  
   CASE cTIPOMIX="ODBC"  //Cserver Conneccao
       Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
       cCONN=GERACONN(cDATABASEX,.F.) //Sqlmix usa driver no lugar de provider(adooledb) geraconn(cCAMBASE,lPROVIDER)
       nCONN:=rddInfo( RDDI_CONNECT, { "ODBC", cCONN } )
ENDCASE
 if ! ( nConn > 0) 
		mdt("Erro ao connectar "+cServerx+" "+cstr(RDDINFO(RDDI_ERROR))+" Error"+cstr(RDDINFO(RDDI_ERRORNO)))
		nConn := 0
	endif
RETURN nConn

FUNCTION mix_close()
IF .NOT. EMPTY(nconn) .and. nConn <> 0
   RDDINFO(RDDI_DISCONNECT, nConn)
ENDIF


Function mix_Conn()
	IF HB_ISNIL(nConn)
		//  Select the default connection.
		nConn := RDDINFO(RDDI_CONNECTION)		// esto NO selecciona una conexion, siempre regresa cero 0
	ELSE
		//  Select the current connection.
*		msgbox("Seleccionando conexcion "+str(nConn))
*		RDDINFO(RDDI_CONNECTION,,,nConn)
		nConn := RDDINFO(RDDI_CONNECTION,,,nConn)
	ENDIF
Return nConn

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

