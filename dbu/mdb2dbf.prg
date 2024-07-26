#include "dbstruct.ch"
#INCLUDE "BOX.CH"

#require "rddado"

#include "adordd.ch"

REQUEST ADORDD

//Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
// USE ( hb_DirBase() + "test.mdb" ) VIA "ADORDD" TABLE "Table1"

Function mdbmenu()
aAMBIENTE:=SALVAA()

loledb:=mdg("User sim=oledb(32b) nao=accdb(64b)")

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    IF loledb
       @ 03,24 SAY "oledb(32b)"
    Else
       @ 03,24 SAY "accdb(64b)"
    endif
    OPCAO(  4, 24, "&Criar arquivo mdb         ", 67 ) //c 67
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
cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
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
if loledb
   USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
else
   USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA ACEOLEDB
endif 
   
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
cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
//necessario uma tabela para criar
Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 

cCONCREATE:=cARQORI+";table1"
IF .not. loledb //se nao for oledb e sim aceoledb inclui engine parse ; 3 parametro ADO_CREATE em adordd.prg
   cCONCREATE:=cARQORI+";table1;ACEOLEDB"
endif

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
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )      

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
    IF .not. loledb //se nao for oledb e sim aceoledb inclui engine parse ; 3 parametro ADO_CREATE em adordd.prg
        cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
    endif
    
    dbCreate( cCONCREATE, aSTRU,"ADORDD" )
    //dbCreate( cMDBARQ+";"+cNOMETABELA, aSTRU,"ADORDD" )
    
    if loledb
       USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA
    else
       USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA ACEOLEDB
    endif   
    append from &cDBFARQ. WHILE zei_fort(nLASTREC,,,1)
    dbcloseall()
    Set( _SET_DATEFORMAT, "dd/mm/yyyy" )

FUNCTION MDBIMPDBF()
cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
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
               
