#require "hbmemio"

#include "dbstruct.ch"
#INCLUDE "BOX.CH"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "hbVER.CH"



Function adoxmenu(cUSOSQL)
LOCAL aAMBIENTE
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes aBaixo

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

//Cria variaveis e inicializa obrigatorio
ADOSetRDD( cTIPOSQL )

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    @ 03,24 SAY "ADOX"+" "+cTIPOSQL+" "+cDATABASEX
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
            adoxcriadatabase()
       CASE KEY=2
            IF lMDB .OR. lACCDB
            ELSE
                mdbdatabases()
            ENDIF    
       CASE KEY=3
            adoximpdbf()
       CASE KEY=4
            mdbtabela(cdatabasex)
       CASE KEY=5
            adoxexpdbf(1)
       CASE KEY=6
            adoxdeltable()
       CASE KEY=7
            adoxexpdbf(2)
       OTHERWISE
            RETURN
    ENDCASE
ENDDO


RESTAA(aAMBIENTE)
LAYOUT()
RETURN .T.


function adoxcriadatabase()
cnewDATABASEX:=INPUTBOX(SPACE(30),"Novo database")
cnewDATABASEX:=alltrim(cnewDATABASEX)
IF ! EMPTY(cnewDATABASEX)
   if cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB" .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64" .OR. cTIPOSQL="MSSQL"  .OR. cTIPOSQL="SQLSERVER"
       adoxexecsql("CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
   ENDIF
   IF cTIPOSQL="SQLITE" .OR. lMDB .OR. lACCDB
      mdbcria()
   ENDIF
ENDIF
return .t.

function adoximpdbf()


   local aINDICES
    LOCAL nINDICES
    LOCAL cINDEXNAME
    LOCAL J
    local msql
    LOCAL cTABLE
    LOCAL cCONN
    LOCAL nCAMPOS
    LOCAL cCAMPO
    
    cMDBARQ:=OPENTIPOARQ()
    
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

     nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
     FOR j = 1 TO  nIndexes
        cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
        cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
        cINDEXUSO  :=MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j ))
         msql:="create index " + cINDEXNAME + " on " + cTABLE + " ( " + cINDEXUSO + " ) "
         aadd(Aindices,msql)
     NEXT j

    msql:= SqliteCreateTable(cTABLE,aSTRU,cTIPOSQL)
    adoxexecsql(msql) 
    if len(aindices)>0
        adoxexecsql(Aindices) //Executa comando unico ou array de comandos
    endif    
    
   cCONN=GERACONN(cDATABASEX)

   ADOCONNECT(cCONN)
   ADOUSE(cTABLE)
   ADOSELECT(cTABLE)
   
   
    DBSELECTAREA(cTABLE)
    nLASTREC:=reccount() 
    nCAMPOS :=FCOUNT()
    zei_fort( nLASTREC,,,0)
    DBGOTOP()
    while ! eof()
      zei_fort(nLASTREC,,,1)
      ADOAPPEND()
      FOR i := 1 TO nCAMPOS
         cCAMPO:=aSTRU[i, DBS_NAME]
         ADOREPLACE( cCAMPO, FieldGet( i ))
      NEXT I  
      ADOCOMMIT() 
      DBSELECTAREA(cTABLE)
      dbskip()
   enddo
   dbclosearea()
   ADOCLOSE()
   ADODISCONNECT()



return .t.

function adoxexpdbf(ntipo)

LOCAL aSTRU
LOCAL cCONN
LOCAL i
LOCAL nFIM
LOCAL aVALOR

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


cMDBARQ:=OPENTIPOARQ()

mdbtabela(cdatabasex)

cCONN=GERACONN(cDATABASEX)
ADOCONNECT(cCONN)
IF EMPTY(cTABELAX)
   mdbtabela(adotables())
ENDIF  


aSTRU2:=MDBTABLES(cDataBaseX,cTABELAX )

ADOUSE(cTABELAX)
ADOSELECT(cTABELAX)
aSTRU:=ADOSTRU() 
nFIM    := LEN(aSTRU)
nLASTREC:=ADORecCount()
zei_fort( nLASTREC,,,0)



avalor:={}
cDESTINO:=cTABELAX+"_"+cTIPOSQL
IF nTIPO=1 //arquivo fisico
   MDT(cDESTINO)
   DBCreate(cDESTINO, aSTRU, "DBFCDX" ) 
   DBUseArea( .T. , "DBFCDX" , cDESTINO, "DESTINO" , .T. , .F. ) 
ELSE
   dbCreate( "mem:destino", aSTRU, , .T., "DESTINO" )
ENDIF   

WHILE .NOT.  ADOEof() //.AND. .NOT. ADOBOF()
     dbselectar("DESTINO")
     NETRECAPP()
     FOR I= 1 TO nFIM
         cCAMPO:=aSTRU[i, DBS_NAME]
         eVALOR:=ADOField(Ccampo)
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
    ADOMoveNext()
ENDDO

ADOCLOSE()
ADODISCONNECT()


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

IF nTIPO=2
   dbDrop( "mem:destino" )
ENDIF
return .t.


            
function adoxdeltable()
mdbtabela(cdatabasex)
IF .NOT. MDG("Apagar Tabela"+cTABELAX)  
   return .f.
ENDIF
adoxexecsql("DROP TABLE  "+cTABELAX) 
return .t.

function adoxexecsql(eCOMANDO)
LOCAL aCOMANDOS:={}
LOCAL nFIM
LOCAL i
LOCAL cCONN
IF VALTYPE(eCOMANDO)="C"
   AAdd(aCOMANDOS,eCOMANDO) 
ELSE
   aCOMANDOS:=eCOMANDO
ENDIF
cCONN=GERACONN(cDATABASEX)
ADOCONNECT(cCONN)
nFIM:=LEN(aCOMANDOS)
for i:=1 to nfim
    cCOMANDO:=aCOMANDOS[I]
    ADOEXECUTE(cCOMANDO)
next i
ADODISCONNECT()
return .t.
