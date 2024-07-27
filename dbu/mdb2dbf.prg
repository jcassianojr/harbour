#include "dbstruct.ch"
#INCLUDE "BOX.CH"

#require "rddado"

#include "adordd.ch"

REQUEST ADORDD


Function mdbmenu(cUSOSQL)
cTIPOSQL:=cUSOSQL   //Passa para privada usadas nas funcoes avaixo

aAMBIENTE:=SALVAA()

loledb=.T.
IF cTIPOSQL="MDB"
   loledb:=mdg("User sim=oledb(32b) nao=accdb(64b)")
ENDIF   

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    IF cTIPOSQL="MDB"
        IF loledb
           @ 03,24 SAY "oledb(32b)"
        Else
           @ 03,24 SAY "accdb(64b)"
        endif
    ELSE
        @ 03,24 SAY cTIPOSQL
    ENDIF    
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
            RETURN NIL
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
DO CASE
   CASE cTIPOSQL="MDB"
        cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
    CASE cTIPOSQL="SQLITE"
        cMDBARQ:=win_GetOpenFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
      { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
        { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
        { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )    
ENDCASE        
md()
@ maxrow(),0 SAY "TABELA"
@ maxrow(),10 get cTABELA
READ

cTABELA:=ALLTRIM(cTABELA)

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
DO CASE
    CASE cTIPOSQL="MDB"
        if loledb
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
        else
           USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
        endif 
    CASE cTIPOSQL="SQLITE"  
         USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA SQLITE
ENDCASE
   
nLASTREC:=   reccount() //NetRegCount(cOLDDBF)
zei_fort( nLASTREC,,,0)
IF lCOPIANAT
   COPYTO(cDESTINO)
ELSE
   multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO))
ENDIF   

dbcloseall()
return nil



function mdbcria()
local cCONCREATE
cCONCREATE:=""
DO CASE
   CASE cTIPOSQL="MDB"
        cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
        //necessario uma tabela para criar
        Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 

        cCONCREATE:=cARQORI+";table1"
        IF .not. loledb //se nao for oledb e sim aceoledb inclui engine parse ; 3 parametro ADO_CREATE em adordd.prg
           cCONCREATE:=cARQORI+";table1;ACEOLEDB"
        endif
   CASE cTIPOSQL="SQLITE" 
        cARQORI:=win_GetsaveFileName(, "SQLite Files",HB_CWD(), "SQLite", ;
        { { 'SQLite', '*.sqlite' },{ 'SQLite db', '*.DB' } , ;
          { 'SQLite3', '*.sqlite3' },{ 'SQLite db3', '*.DB3' } , ;
          { 'SQLite Fossil', '*.fossil' } , { 'All Files', '*.*' }} , 1 )  
        cCONCREATE:=cARQORI+";table1;SQLITE"
ENDCASE
/*
 dbCreate( cARQORI+";table1", { ;
      { "FIRST",   "C", 10, 0 }, ;
      { "LAST",    "C", 10, 0 }, ;
      { "AGE",     "N",  8, 0 }, ;
      { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
*/

 dbCreate( cCONCREATE, { ;
      { "FIRST",   "C", 10, 0 }, ;
      { "LAST",    "C", 10, 0 }, ;
      { "AGE",     "N",  8, 0 }, ;
      { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
IF cTIPOSQL="MDB"      
   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )   
ENDIF
RETURN NIL
   
FUNCTION DBF2MDB(cMDBARQ,cDBFARQ)
    local cCONCREATE
    use &cDBFARQ.
    aSTRU:=DBSTRUCT() 
    nLASTREC:=reccount() 
    zei_fort( nLASTREC,,,0)
    cNOMETABELA:=ALIAS()
    dbclosearea()
    MDT(cNOMETABELA)
    
    Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
    
    cCONCREATE:=cMDBARQ+";"+cNOMETABELA
    DO CASE
       CASE cTIPOSQL="MDB"
            IF .not. loledb //se nao for oledb e sim aceoledb inclui engine parse ; 3 parametro ADO_CREATE em adordd.prg
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
            endif
       CASE cTIPOSQL="SQLITE"  
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";SQLITE"
    ENDCASE
    
    dbCreate( cCONCREATE, aSTRU,"ADORDD" )
    
    do case
       case cTIPOSQL="MDB"
            if loledb
               USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA
            else
               USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA ACEOLEDB
            endif  
       case cTIPOSQL="SQLITE"    
            USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA SQLITE
    endcase
         
    append from &cDBFARQ. WHILE zei_fort(nLASTREC,,,1)
    dbcloseall()
    Set( _SET_DATEFORMAT, "dd/mm/yyyy" )

FUNCTION MDBIMPDBF()
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
ENDCASE   
nOLDTIPO:=TIPODBF
alertX("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
IF FILE (cARQORI)
   DBF2MDB(cMDBARQ,cARQORI)
   RDDNOME(nOLDTIPO) //retorna tipo anterior
ENDIF   
               
