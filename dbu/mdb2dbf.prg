#include "dbstruct.ch"
#INCLUDE "BOX.CH"

#require "rddado"

#include "adordd.ch"

REQUEST ADORDD

//Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
// USE ( hb_DirBase() + "test.mdb" ) VIA "ADORDD" TABLE "Table1"

Function mdbmenu()
aAMBIENTE:=SALVAA()

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
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
cMDBARQ:=win_GetOPENFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
md()
@ maxrow(),0 SAY "TABELA"
@ maxrow(),10 get cTABELA
READ

cTABELA:=ALLTRIM(cTABELA)

pegtipodoc()
pegparexp()

hb_FNameSplit(cMDBARQ , @cCAMMDB, NIL, NIL )
cDESTINO:=cCAMMDB+cTABELA+"."+zEXPOREXT
MDT(cDESTINO)

MDT("abrindo arquivo de origem: "+cMDBARQ)
USE ( cMDBARQ ) VIA "ADORDD" TABLE cTABELA
 nLASTREC:=   reccount() //NetRegCount(cOLDDBF)
    zei_fort( nLASTREC,,,0)
 
COPYTO(cDESTINO)
dbcloseall()
return nil



function mdbcria()
cARQORI:=win_GetSAVEFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos mdb", "*.MDB", 1 )
//necessario uma tabela para criar
Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
 dbCreate( cARQORI+";table1", { ;
      { "FIRST",   "C", 10, 0 }, ;
      { "LAST",    "C", 10, 0 }, ;
      { "AGE",     "N",  8, 0 }, ;
      { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )      

FUNCTION DBF2MDB(cMDBARQ,cDBFARQ)
    use &cDBFARQ.
    aSTRU:=DBSTRUCT() 
    nLASTREC:=   reccount() //NetRegCount(cOLDDBF)
    zei_fort( nLASTREC,,,0)
    cNOMETABELA:=ALIAS()
    dbclosearea()
    ALERTX(cNOMETABELA)
    
    Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
    
    dbCreate( cMDBARQ+";"+cNOMETABELA, aSTRU,"ADORDD" )
    
    USE ( cMDBARQ ) VIA "ADORDD" TABLE cNOMETABELA
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
               
