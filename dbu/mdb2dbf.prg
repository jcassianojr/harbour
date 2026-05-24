*+--------------------------------------------------------------------
*+
*+    Programa  : mdb2dbf.prg
*+
*+     Sistema:
*+
*+     Linguagem: HarbourF
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+    Documentado em 28-Dez-2024 as 10:07 am
*+
*+--------------------------------------------------------------------
*+

#include "dbstruct.ch"
#INCLUDE "BOX.CH"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "hbVER.CH"

#require "rddado"

#include "adordd.ch"

REQUEST ADORDD



*+--------------------------------------------------------------------
*+
*+    Function mdbmenu()
*+
*+--------------------------------------------------------------------
*+
Function mdbmenu(cUSOSQL)

cTIPOSQL := cUSOSQL   //Passa para privada usadas nas funcoes aBaixo
public oDB := nil

aAMBIENTE := SALVAA()

cSERVERX   := "localhost"+space(21)
cDATABASEX := space(30)
cUSERX     := SPACE(30)
cPASSX     := SPACE(30)
cTABELAX   := SPACE(30)
cBANCOX   := Space(30)
cOWNERX   := Space(30)
cPORTAX    :=SPACE(30)
loledb     := .T.
lmdb       := .f.
laccdb     := .f.


pegcfgbanco()

WHILE .T.
   HB_dispbox(3,22,22,55,B_DOUBLE+" ")
   DO CASE
   CASE cTIPOSQL = "MDB" .OR. cTIPOSQL = "ACCESS"
      IF loledb
         @ 03,40 SAY "oledb(32b)"         
      Else
         @ 03,40 SAY "accdb(64b)"         
      endif
   CASE cTIPOSQL = "MYSQL"
      IF loledb
         @ 03,40 SAY "odbc 8(32b)"         
      Else
         @ 03,40 SAY "odbc 9(64b)"         
      endif

   OTHERWISE
      @ 03,24 SAY "ADORDD"+" "+cTIPOSQL         
   ENDCASE
   if cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" ;
              .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      OPCAO(4,24,"&Criar database             ",67)   //c 67
   else
      OPCAO(4,24,"&Criar arquivo              ",67)   //c 67
   endif
   OPCAO(5,24,"Executar arquivo &SQL      ",83)   //S 83
   OPCAO(6,24,"&Importar  DBF             ",73)   //I 73
   OPCAO(7,24,"Exportar Tabela &Formatos  ",69)   //F 70
   OPCAO(8,24,"&Database Selecionar       ",68)   //D 68
   OPCAO(9,24,"&Exportar  DBF             ",69)   //E 69
   OPCAO(10,24,"&SQL Create DBF           ",83)   //S 83
   
   OPCAO(11,24,"DBF &TO DBML               ",84)   //T 85
   OPCAO(12,24,"Trocar &Usuario/Senha     ",85)
   
   KEY := menu(1,0)
   DO CASE
   CASE KEY = 1
      mdbcria()
   CASE KEY = 2
      ExecArqSql()
   CASE KEY = 3
      MDBIMPDBF()
   CASE KEY = 4
      MDBEXP(2)
   CASE KEY = 5
      IF lMDB .OR. lACCDB
      ELSE
         mdbdatabases()
      ENDIF
   CASE KEY = 6
      MDBEXP(1)
   CASE KEY = 7 
        IF MDG("Individual") 
          tDOC = 5 //SQL
          ZANOFOR := cTIPOSQL
          zEXPOREXT = "SQL"
          lDOCCAB:=MDG( "Gravar Informacao Estrutura" )
          lDOCDAD:=MDG( "Gravar Dados" )
          lDOCRECNO:=.F. //MDG( "Incluir Recno()/ID" )
          cSUBTIPO:="SQL"
          cMASK:="*.DBF"
          FAZERDBF( {|| multidocg( lDOCCAB, lDOCDAD, lDOCRECNO, cSUBTIPO ) }, .F.,,, cMASK )
        else
          sqltodos(cTIPOSQL)
        endif  
   CASE KEY=8
        mdltodos() 
   CASE KEY=9
        trocasenhaarq()  
          
   OTHERWISE
      EXIT
   ENDCASE
ENDDO

RESTAA(aAMBIENTE)
layout()
return nil


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function pegcfgbanco()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function pegcfgbanco()


IF cTIPOSQL="LETO"
   cSERVERX   := PADR("//127.0.0.1:2812/",30," ")  
   cPORTAX:= PADR("2812",30," ")
ENDIF   

IF cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
   cUSERX := PADR("root",30," ")   
   cPORTAX:= PADR("3306",30," ")
ENDIF

IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
   cUSERX := PADR("postgres",30," ") 
   cPORTAX:= PADR("5432",30," ")
ENDIF
IF cTIPOSQL = "FIREBIRD"
   cSERVERX := PADR("localhost", 30, " ")   //net://
   cUSERX := PADR("SYSDBA",30," ")  //masterkey
   cPORTAX:= PADR("3050",30," ")

ENDIF



//
// ajustes nomes de drivers para 32 e 64 bits
//
loledb := .T.
IF cTIPOSQL = "MDB" .OR. cTIPOSQL = "ACCESS"
   loledb := hb_Version(HB_VERSION_BITWIDTH) <> 64  //oledb jet (32b) oledb accdb(64b)")
ENDIF
IF cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64"
   loledb := hb_Version(HB_VERSION_BITWIDTH) <> 64  //odbc 8.0(32b) odbc 9.0(64b)")
ENDIF
IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
   loledb := hb_Version(HB_VERSION_BITWIDTH) <> 64  //odbc 8.0(32b) odbc 9.0(64b)")
ENDIF
// No bloco de ajustes de drivers (linha ~200)
IF cTIPOSQL == "FIREBIRD"
   loledb := hb_Version(HB_VERSION_BITWIDTH) <> 64 // .T. se 32-bit, .F. se 64-bit
ENDIf

//
//mariadb mesmo nome de driver para 32 e 64 bits
//


IF cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64"
   loledb := .F.  //Requer aceole.db 32 e ou 64 instalado
ENDIF

IF cTIPOSQL = "MYSQL" .or. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" ;
           .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" 
   OPENTIPOARQ()
   mdbdatabases()
ENDIF

IF cTIPOSQL = "LETO"
   OPENTIPOARQ()
ENDIF

lMDB := .F.
IF cTIPOSQL = "MDB" .OR. cTIPOSQL = "ACCESS" .OR. cTIPOSQL = "MDB64" .OR. cTIPOSQL = "ACCESS64"
   lMDB := .T.
ENDIF
lACCDB := .F.
IF cTIPOSQL = "ACCDB" .OR. cTIPOSQL = "ACCDB64"
   lACCDB := .T.
ENDIF


return .t.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ExecArqSql()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function ExecArqSql

LOCAL cCOMANDO := ""
LOCAL aCOMANDO := {}
LOCAL cARQIMP  := ""
LOCAL nFILEUSO
LOCAL cDELIM
LOCAL cLINHA

cARQIMP := win_GetOPENFileName(,"Arquivos SQL",HB_CWD(),"Arquivos SQL","*.SQL",1)
cARQORI := OPENTIPOARQ()

IF FILE(cARQIMP)
   nLASTREC := FLINECOUNT(cARQIMP)
   zei_fort(nLASTREC,,,0)

   cDELIM   := FDELIM(cARQIMP,1024)   //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
   nFILEuso := FOPEN(cARQIMP)   //abre o arquivo
   WHILE .T.
      cLINHA := FREADLINE(nFILEuso,1024,.T.,cDELIM)   //FREADLINE (handle, line_len,lremchrexp,cDELI)

      AADD(aCOMANDO,cLINHA)

      IF cLINHA = '__FINAL__'   //freadline retorna __FINAL__   quando nao e mais linhas
         EXIT
      ENDIF

      zei_fort(nLASTREC,,,1)

   enddo
   fclose(nFILEuso)   //fecha o arquivo
   executacmd(cARQORI,aCOMANDO)
endif
return .t.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mdbdatabases()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function mdbdatabases()

local nChoices
nChoices := 0
aResult  := MDBTABLES()
IF LEN(aResult) > 0
   HB_dispbox(3,22,22,55,B_DOUBLE+" ")
   nChoices := ACHOICE(4,23,21,54,aResult)
ENDIF
cDATABASEX := ALLTRIM(IIF(nChoices > 0,aResult[nChoices],""))
RETURN aResult



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mdbtabela()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function mdbtabela(cMDBARQ)

local nChoices
nChoices := 0
IF VALTYPE(cMDBARQ) = "A"
   aResult := cMDBARQ
ELSE
   aResult := MDBTABLES(cMDBARQ)
ENDIF
IF LEN(aResult) > 0
   HB_dispbox(3,22,22,55,B_DOUBLE+" ")
   nChoices := ACHOICE(4,23,21,54,aResult)
ENDIF
cTABELAX := ALLTRIM(IIF(nChoices > 0,aResult[nChoices],""))
RETURN aResult


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDBEXP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function MDBEXP(nTIPO)

LOCAL cCAMMDB      := SPACE(100)
LOCAL lCOPIANAT
local Ldoc
local Lgrvstruinfo
LOCAL aSTRU
LOCAL nFIM
LOCAL i

cMDBARQ := OPENTIPOARQ()

mdbtabela(cMDBARQ)

cTABELA := cTABELAX

IF EMPTY(cTABELA)
   cTABELA := INPUTBOX(SPACE(30),"Tabela")
ENDIF
cTABELA := ALLTRIM(cTABELA)
IF EMPTY(cTABELA)
   RETURN NIL
ENDIF

IF nTIPO = 1
   tdoc      := 14  //dbf
   zEXPOREXT := "DBF"
ENDIF

IF nTIPO = 2
   LCOPIANAT := .f.   //MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado PGsqlrddd
   tDOC      := pegtipodoc()  // .t. Inclui dbf se for nativa
   pegparexp()
   lDOCCAB   := .F.
   lDOCDAD   := .F.
   lDOCRECNO := .F.
   cSUBTIPO  := " "
   PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF


hb_FNameSplit(cMDBARQ,@cCAMMDB,NIL,NIL)
cDESTINO := cCAMMDB+cTABELA+"_"+Ctiposql+"."+zEXPOREXT
MDT(cDESTINO)


cTABELAGRV := cTABELA
IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"  //Dupla aspas maiuscula
   cTABELA := CHR(34)+UPPER(cTABELA)+CHR(34)
ENDIF


MDT("abrindo arquivo de origem: "+cMDBARQ)
opencmdbarq()
nLASTREC := reccount()
zei_fort(nLASTREC,,,0)
aSTRU := dbstruct()

//ajustar adordd para melhor tratativa campos @ datatime m diferenciando logwchar memos
//pois cria com tipos @ e M deixando o dbf com tipos incompativeis
//criar opcao de criar o dbf tratado con mdbtables
//importar via pipe ou outro
IF tDOC = 90
   aINDICES := {}
   IF lMDB .OR. lACCDB
      //Ainda nao implantado testes com catalog ver outras opcoes
      //utilizando sqltodbfstru
      aSTRU := sqltodbfstru(aSTRU)
      //funcionou o catalog porem com ordem diferente dos campos
      //gerando erro na gravacao
      //aSTRU   :=MDBTABLES(cMDBARQ,cTABELAgrv)
      aINDICES := MDBTABLES(cMDBARQ,cTABELAgrv,"__INDEX__")
   ELSE
      aSTRU := MDBTABLES(cMDBARQ,cTABELAgrv)
   ENDIF
   cALIASADO := ALIAS()
   DBCreate(ctabela+"_"+Ctiposql,aSTRU,"DBFCDX")
   DBUseArea(.T.,,ctabela+"_"+Ctiposql,,.F.,.F.)
   IF LEN(aINDICES) > 0
      cCHAVEINDEX  := aINDICES[1,1]
      cCAMPOSINDEX := ""
      FOR I := 1 TO LEN(aINDICES)
         IF cCHAVEINDEX <> aINDICES[I,1]
            cCHAVEINDEX  := aINDICES[I,1]
            cCAMPOSINDEX := aINDICES[I,2]
         ELSE
            IF EMPTY(cCAMPOSINDEX)
               cCAMPOSINDEX := aINDICES[I,2]
            ELSE
               cCAMPOSINDEX := cCAMPOSINDEX+","+aINDICES[I,2]
            ENDIF
         ENDIF
         //          alert(Cchaveindex+" "+CCAMPOSINDEX)
      NEXT I
   ENDIF
   cALIASDBF := ALIAS()
   nFIM      := FCOUNT()
   dbselectar(cALIASADO)
   dbgotop()
   while !eof()
      aVALOR := {}
      FOR I := 1 TO nFIM
         AADD(aVALOR,{FIELDGET(I),FIELDNAME(I)})  //guarda o nome do campo caso a ordem venha invertida
      NEXT I
      dbselectar(cALIASDBF)
      NETRECAPP()
      FOR I := 1 TO nFIM
         eVALOR := aVALOR[I,1]
         if valtype(eVALOR) = "C" .AND. SUBSTR(eVALOR,5,1) = "-" .AND. SUBSTR(eVALOR,8,1) = "-"
            eVALOR := substr(eVALOR,6,2)+"/"+substr(eVALOR,9,2)+"/"+substr(eVALOR,1,4)
            eVALOR := CTOD(eVALOR)
         ENDIF
         if valtype(eVALOR) = "C" .OR. valtype(eVALOR) = "M"
            eVALOR := RANGEREPL(chr(0),chr(31),eVALOR," ")  //Remove caracteres de controle
            eVALOR := TIRACE(eVALOR)
            eVALOR := ALLTRIM(eVALOR)
         ENDIF
         IF !EMPTY(eVALOR)
            nPOSDBF := FieldPos(aVALOR[I,2])
            fieldput(nPOSDBF,Evalor)
            //grava com o nome do campo casos a posicao dos campos ados seja difetente dos campos dbf
            //FIELDPUT(I,eVALOR)
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function sqltodbfstru()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function sqltodbfstru(aStruct)

local nFIM
local i
LOCAL aTAM
LOCAL nLENMAX
LOCAL aRETU
nFIM := LEN(aStruct)
for i := 1 to NFIM
   nLENMAX := 0
   IF (aStruct[i,DBS_TYPE] = "I" .or. aStruct[i,DBS_TYPE] = "B") .and. aStruct[i,DBS_LEN] = 0 .AND. cTIPOSQL = "SQLITE"
      Ctmp := "select max( length( "+aStruct[i,DBS_NAME]+" ) ) from "+cTABELA
      aTAM := MDBTABLES(cMDBARQ,cTABELA,ctmp)
      if len(aTAM) > 0
         nLenMAX := aTAM[1]
      endif

      //Tipo integer 4 =numerico 8
      IF aStruct[i,DBS_TYPE] = "I"  //integer
         aStruct[ i, DBS_TYPE ] := "N"
         IF nLENMAX > 8
            aStruct[i,DBS_LEN] = nLENMAX
         ELSE
            aStruct[i,DBS_LEN] = 8
         ENDIF
      ENDIF

      //Tipo B double
      IF aStruct[i,DBS_TYPE] = "B"
         aStruct[ i, DBS_TYPE ] := "N"
         IF nLENMAX > 15
            aStruct[i,DBS_LEN] = nLENMAX+4  //acrecenta 4 decimais
         ELSE
            aStruct[i,DBS_LEN] = 15
         ENDIF
         aStruct[i,DBS_LEN] = 4
      ENDIF
   endif

   IF aStruct[i,DBS_TYPE] = "I" .AND. (lmdb .or. Laccdb)
      aStruct[ i, DBS_TYPE ] := "N"
      //DBS_LEN TRAS precision int2 int4 int8
      //Ajustustando o tamanho precisao para numerico para  2->4  4->8  8->16
      aStruct[i,DBS_LEN] = aStruct[i,DBS_LEN] * 2
   ENDIF

   IF aStruct[i,DBS_TYPE] = "L" .AND. (lmdb .or. Laccdb) .AND. aStruct[i,DBS_LEN] > 1
      aStruct[ i, DBS_LEN ] := 1
   ENDIF

   aRETU := geracampodbf(aStruct[i,DBS_NAME],aStruct[i,DBS_TYPE],aStruct[i,DBS_LEN],aStruct[i,DBS_DEC])

   aStruct[ i, DBS_NAME ] := aRETU[DBS_NAME]
   aStruct[ i, DBS_TYPE ] := aRETU[DBS_TYPE]
   aStruct[ i, DBS_LEN ]  := aRETU[DBS_LEN]
   aStruct[ i, DBS_DEC ]  := aRETU[DBS_DEC]

next i
return aStruct


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function opencmdbarq()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function opencmdbarq()

local lRETU
lRETU := .T.
DO CASE
CASE lMDB
   // DBUseArea( <lNewArea> , <cDriver> , <cName>, <xcAlias> , <lShared> , <lReadOnly> ) -> Nil
   if loledb
      hb_adoSetTable(cTABELA) 
      dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
   else
      hb_adoSetTable(cTABELA) 
      hb_adoSetEngine("ACEOLEDB") 
      dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
   endif
CASE lACCDB
   hb_adoSetTable(cTABELA) 
   hb_adoSetEngine("ACEOLEDB") 
   dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
CASE  cTIPOSQL = "FIREBIRD"
   hb_adoSetTable(cTABELA) 
   hb_adoSetEngine("FIREBIRD") 
   hb_adoSetUser(CUSERX) 
  hb_adoSetPassword(CPASSX) 

   dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
CASE cTIPOSQL = "SQLITE"
   hb_adoSetTable(cTABELA) 
   hb_adoSetEngine("SQLITE") 
   dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64"
   if loledb
      hb_adoSetTable(cTABELA) 
      hb_adoSetEngine("MYSQL") 
      hb_adoSetServer(cSERVERx) 
      hb_adoSetUser(CUSERX) 
      hb_adoSetPassword(CPASSX) 
      dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
   else
      hb_adoSetTable(cTABELA) 
      hb_adoSetEngine("MYSQL64") 
      hb_adoSetServer(cSERVERx) 
      hb_adoSetUser(CUSERX) 
      hb_adoSetPassword(CPASSX) 
      dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
   endif
CASE cTIPOSQL = "MARIADB"
   hb_adoSetTable(cTABELA) 
   hb_adoSetEngine("MARIADB") 
   hb_adoSetServer(cSERVERx) 
   hb_adoSetUser(CUSERX) 
   hb_adoSetPassword(CPASSX) 
   dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
   hb_adoSetTable(cTABELA) 
   hb_adoSetEngine("SQL") 
   hb_adoSetServer(cSERVERx) 
   hb_adoSetUser(CUSERX) 
   hb_adoSetPassword(CPASSX) 
   dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
   if loledb
      TRY
      hb_adoSetTable(cTABELA) 
      hb_adoSetEngine("PGSQL") 
      hb_adoSetServer(cSERVERx) 
      hb_adoSetUser(CUSERX) 
      hb_adoSetPassword(CPASSX) 
      dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
      catch oErR
      MDT("Erro Abrindo")
      lRETU := .F.
   END
else
   TRY
   hb_adoSetTable(cTABELA) 
   hb_adoSetEngine("PGSQL64") 
   hb_adoSetServer(cSERVERx) 
   hb_adoSetUser(CUSERX) 
   hb_adoSetPassword(CPASSX) 
   dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
   catch oErR
   MDT("Erro Abrindo")
   lRETU := .F.
END
endif
ENDCASE
return lRETU




*+--------------------------------------------------------------------
*+
*+    Function mdbcria()
*+
*+--------------------------------------------------------------------
*+
function mdbcria()


DO CASE
CASE lMDB
   cARQORI := win_GetSAVEFileName(,"Arquivos de Origem",HB_CWD(),"Arquivos mdb","*.MDB",1)
CASE lACDB
   cARQORI := win_GetSAVEFileName(,"Arquivos de Origem",HB_CWD(),"Arquivos accdb","*.accdb",1)
CASE cTIPOSQL = "SQLITE"
   cARQORI := win_GetsaveFileName(,"SQLite Files",HB_CWD(),"SQLite",;
    {{'SQLite','*.sqlite'},{'SQLite db','*.DB'},;
    {'SQLite3','*.sqlite3'},{'SQLite db3','*.DB3'},;
    {'SQLite Fossil','*.fossil'},{'All Files','*.*'}},1)
CASE cTIPOSQL = "FIREBIRD"
   cARQORI := win_GetsaveFileName(,"Firebase Files",HB_CWD(),"Firebase",;
    {{'Firebird','*.gdb'},{'Firebird fdb','*.fDB'},;
     {'All Files','*.*'}},1)    
ENDCASE


//cria com sql query create database
if cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" ;
           .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
   cARQORI       := OPENTIPOARQ()
   cnewDATABASEX := INPUTBOX(SPACE(30),"Novo database")
   cnewDATABASEX := alltrim(cnewDATABASEX)
   IF .NOT. EMPTy(cnewDATABASEX)
      IF hb_AScan(MDBTABLES(),cnewDATABASEX,,,.T.) > 0
         MDT("Ja existe Database "+cnewDATABASEX)
         return .f.
      ENDIF
      cDATABASEX := ""
      executacmd(Carqori,"CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
      CDATABASEX := CNEWDATABASEX
   ENDIF
endif

//cria com catalogx
IF lMDB .OR. lACCDB
   CreateAccessDatabase(cARQORI)
   EXECUTACMD(cARQORI,"GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC")
   EXECUTACMD(cARQORI,"create view showtables as select name from MSysObjects where MSysObjects.type In (1,4,6) and MSysObjects.name not like '~*' and MSysObjects.name not like 'MSys%'")
   //EXECUTACMD(cARQORI,"GRANT SELECT ON VIEW showtableS TO ADMIN,PUBLIC")
ENDIF

IF cTIPOSQL == "FIREBIRD" .OR. cTIPOSQL == "FIRBIRD"
   // Código necessário para disparar a criação do ficheiro .fdb em branco
   // Exemplo utilizando ADOX se suportado pelo driver:
   TRY
      oCatalog := win_OleCreateObject("ADOX.Catalog")
      oCatalog:Create("DRIVER=Firebird ODBC driver;Uid=SYSDBA;Pwd=masterkey;DbName=" + AllTrim(cARQORI) + ";")
      oCatalog := NIL
   CATCH
      MDT("Erro ao criar base de dados Firebird")
   END
ENDIF


//cria com create native
IF cTIPOSQL = "SQLITE"
   createSqlitedb()
ENDIF
RETURN NIL



*+--------------------------------------------------------------------
*+
*+    Function DBF2MDB()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DBF2MDB(cMDBARQ,cDBFARQ)

local aINDICES
LOCAL nINDICES
LOCAL cINDEXNAME
LOCAL J
local msql
local lgravasql
LOCAL cSqlFields, cSqlIndexes

cSqlFields := ""
cSqlIndexes := ""

DO CASE
   CASE cTIPOSQL == "SQLITE"
      cSqlFields  := "CREATE TABLE IF NOT EXISTS table_metadata (table_name TEXT, column_name TEXT, original_type TEXT, length INTEGER, precision INTEGER)"
      cSqlIndexes := "CREATE TABLE IF NOT EXISTS index_metadata (table_name TEXT, index_name TEXT, expression TEXT, is_unique INTEGER)"

   CASE cTIPOSQL == "MYSQL" .OR. cTIPOSQL == "MYSQL64" .OR. cTIPOSQL == "MARIADB"
      cSqlFields  := "CREATE TABLE IF NOT EXISTS table_metadata (table_name VARCHAR(50), column_name VARCHAR(50), original_type VARCHAR(1), length INTEGER, precision INTEGER)"
      cSqlIndexes := "CREATE TABLE IF NOT EXISTS index_metadata (table_name VARCHAR(50), index_name VARCHAR(50), expression TEXT, is_unique INTEGER)"

   CASE cTIPOSQL == "PGSQL" .OR. cTIPOSQL == "PGSQL64" .OR. cTIPOSQL == "POSTGRESQL"
      cSqlFields  := "CREATE TABLE IF NOT EXISTS table_metadata (table_name VARCHAR(50), column_name VARCHAR(50), original_type VARCHAR(1), length INTEGER, precision INTEGER)"
      cSqlIndexes := "CREATE TABLE IF NOT EXISTS index_metadata (table_name VARCHAR(50), index_name VARCHAR(50), expression TEXT, is_unique INTEGER)"

   CASE lMDB .OR. lACCDB // MS ACCESS (MDB ou ACCDB)
      // Access nÃ£o aceita IF NOT EXISTS e exige colchetes em palavras reservadas
      cSqlFields  := "CREATE TABLE table_metadata (table_name TEXT(50), column_name TEXT(50), original_type TEXT(1), [length] INTEGER, [precision] INTEGER)"
      cSqlIndexes := "CREATE TABLE index_metadata (table_name TEXT(50), index_name TEXT(50), expression MEMO, is_unique INTEGER)"

   CASE cTIPOSQL == "MSSQL" .OR. cTIPOSQL == "SQLSERVER"
      cSqlFields  := "IF OBJECT_ID('table_metadata', 'U') IS NULL " + ;
                     "CREATE TABLE table_metadata (table_name VARCHAR(50), column_name VARCHAR(50), original_type VARCHAR(1), length INT, precision INT)"
      cSqlIndexes := "IF OBJECT_ID('index_metadata', 'U') IS NULL " + ;
                     "CREATE TABLE index_metadata (table_name VARCHAR(50), index_name VARCHAR(50), expression VARCHAR(MAX), is_unique INT)"
  // No primeiro DO CASE de DBF2MDB() (Tabelas de Metadados)
   CASE cTIPOSQL == "FIREBIRD"
       cSqlFields  := "CREATE TABLE table_metadata (table_name VARCHAR(50), column_name VARCHAR(50), original_type VARCHAR(1), length INTEGER, precision INTEGER)"
       cSqlIndexes := "CREATE TABLE index_metadata (table_name VARCHAR(50), index_name VARCHAR(50), expression BLOB SUB_TYPE TEXT, is_unique INTEGER)"
ENDCASE

// ExecuÃ§Ã£o dos comandos
IF !Empty( cSqlFields )
   // No caso do Access, usamos TRY/CATCH pois ele nÃ£o tem 'IF NOT EXISTS'
   IF "ACCESS" $ cTIPOSQL .OR. "MDB" $ cTIPOSQL .OR. "ACCDB" $ cTIPOSQL .OR. cTIPOSQL == "FIREBIRD"
      TRY
         executacmd(cMDBARQ, cSqlFields)
         executacmd(cMDBARQ, cSqlIndexes)
      CATCH
         // Tabelas jÃ¡ existem
      END
   ELSE
      executacmd(cMDBARQ, cSqlFields)
      executacmd(cMDBARQ, cSqlIndexes)
   ENDIF
ENDIF


lgravasql := mdg("gravar sql")
aINDICES  := {}
dbUseArea( .F.,, cDBFARQ,, .T., .F. )
//use &cDBFARQ.
aSTRU    := DBSTRUCT()
nLASTREC := reccount()
zei_fort(nLASTREC,,,0)
cNOMETABELA := ALIAS()

// 1. LIMPEZA DOS METADADOS (Geral para todos os bancos)
// Limpa o que existia anteriormente para evitar duplicidade na re-importaÃ§Ã£o
executacmd( cMDBARQ, "DELETE FROM table_metadata WHERE table_name = " + c2sql(cNOMETABELA) )
executacmd( cMDBARQ, "DELETE FROM index_metadata WHERE table_name = " + c2sql(cNOMETABELA) )

// 2. INCLUSÃƒO DOS METADADOS DE CAMPOS (Estrutura do DBF)
FOR i := 1 TO Len( aSTRU )
   mFldNm   := aSTRU[ i, 1 ]
   mFldType := aSTRU[ i, 2 ]
   mFldLen  := aSTRU[ i, 3 ]
   mFldDec  := aSTRU[ i, 4 ]

   msql := "INSERT INTO table_metadata (table_name, column_name, original_type, length, precision) VALUES (" + ;
           c2sql(cTablename) + ", " + ;
           c2sql(mFldNm)    + ", " + ;
           c2sql(mFldType)  + ", " + ;
           ltrim(str(mFldLen)) + ", " + ;
           ltrim(str(mFldDec)) + ")"
   
   executacmd( cMDBARQ, msql )
NEXT

nIndexes := dbORDERINFO(DBOI_ORDERCOUNT)
FOR j := 1 TO nIndexes
   cINDEXNAME := dbORDERINFO(DBOI_NAME,,j)
   cINDEXNAME := StrTran(cINDEXNAME,"-","_")  //Tracos nao aceitos trocando por undescore
   msql       := "create index "+cINDEXNAME+" on "+cNometabela+" ( "+MDPCHAVEI(dbORDERINFO(DBOI_EXPRESSION,,j))+" ) "
   aadd(Aindices,msql)
   
   cIdxName  := dbOrderInfo( DBOI_NAME, , j )
   cKey      := dbOrderInfo( DBOI_EXPRESSION, , j )
   lIsUnique := dbOrderInfo( DBOI_UNIQUE, , j )
   
   // Salva a expressÃ£o literal (ex: "CODIGO+STR(SEQ,3)") para reconstruÃ§Ã£o posterior
   msql := "INSERT INTO index_metadata (table_name, index_name, expression, is_unique) VALUES (" + ;
           c2sql(cTablename) + ", " + ;
           c2sql(cIdxName)   + ", " + ;
           c2sql(cKey)       + ", " + ; 
           iif( lIsUnique, "1", "0" ) + ")"
           
   executacmd( cMDBARQ, msql )
NEXT j
dbclosearea()

MDT(cNOMETABELA)

Set(_SET_DATEFORMAT,"yyyy-mm-dd")




msql := ""
DO CASE
CASE cTIPOSQL = "SQLITE"
   msql := SqliteCreateTable(cNOMETABELA,aSTRU,"SQLITE")
   executacmd(cMDBARQ,msql)
CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
   msql := SqliteCreateTable(cNOMETABELA,aSTRU,"MYSQL")
   executacmd(cMDBARQ,msql)
CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
   msql := SqliteCreateTable(cNOMETABELA,aSTRU,"PGSQL")
   executacmd(cMDBARQ,msql)
CASE lMDB   //cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS"
   msql := SqliteCreateTable(cNOMETABELA,aSTRU,"MDB")
   executacmd(cMDBARQ,msql)
CASE lACCDB   // cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"
   msql := SqliteCreateTable(cNOMETABELA,aSTRU,"ACCDB")
   executacmd(cMDBARQ,msql)
CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
   msql := SqliteCreateTable(cNOMETABELA,aSTRU,"MSSQL")
   executacmd(cMDBARQ,msql)
CASE cTIPOSQL == "FIREBIRD"
   msql := SqliteCreateTable(cNOMETABELA, aSTRU, "FIREBIRD") // Certifique-se que sua SqliteCreateTable suporte este parâmetro
   executacmd(cMDBARQ, msql)   
OTHERWISE
ENDCASE

IF lGRAVASQL .AND. .NOT. EMPTY(msql)
   HB_MEMOWRIT(cNOMETABELA+"_createtable_"+cTIPOSQL+".sql",Msql,.F.)
ENDIF

if len(aindices) > 0
   //Cria do os indices append from nao faz
   Executacmd(cMDBARQ,Aindices)   //Executa comando unico ou array de comandos
   IF lGRAVASQL
      msql := ""
      for ii := 1 to len(aINDICES)
         mSQL += aINDICEs[II]+" ; "+HB_OSNEWLINE()
      next ii
      HB_MEMOWRIT(cNOMETABELA+"_createindex_"+cTIPOSQL+".sql",mSQL,.f.)
   endif
endif

cTABELA := cNOMETABELA  //publica usada o opencmdarq
IF cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "POSTGRESQL" .OR. cTIPOSQL = "PGSQL64"  //Dupla aspas maiuscula
   cTABELA := CHR(34)+UPPER(cTABELA)+CHR(34)
ENDIF

if nLASTREC > 0   //nao importa se nao tiver registros
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

Set(_SET_DATEFORMAT,"dd/mm/yyyy")


RETURN .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OPENTIPOARQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION OPENTIPOARQ

LOCAL cMDBARQ
cMDBARQ := ""

DO CASE
CASE lMDB   
   cMDBARQ    := win_GetOPENFileName(,"Arquivos de Destino",HB_CWD(),"Arquivos mdb","*.MDB",1)
   cDATABASEX := cMDBARQ
    cBANCOX:=hb_FNameSplit(cMDBARQ,NIL,cBANCOX,NIL)
CASE lACCDB   
   cMDBARQ    := win_GetOPENFileName(,"Arquivos de Destino",HB_CWD(),"Arquivos accdb","*.accdb",1)
   cDATABASEX := cMDBARQ
    cBANCOX:=hb_FNameSplit(cMDBARQ,NIL,cBANCOX,NIL)
CASE cTIPOSQL = "SQLITE"
   cMDBARQ := win_GetOpenFileName(,"SQLite Files",HB_CWD(),"SQLite",;
    {{'SQLite','*.sqlite'},{'SQLite db','*.DB'},;
    {'SQLite3','*.sqlite3'},{'SQLite db3','*.DB3'},;
    {'SQLite Fossil','*.fossil'},{'All Files','*.*'}},1)
   cDATABASEX := cMDBARQ
   cBANCOX:=hb_FNameSplit(cMDBARQ,NIL,cBANCOX,NIL)
CASE cTIPOSQL = "FIREBIRD"
   cMDBARQ := win_GetopenFileName(,"Firebase Files",HB_CWD(),"Firebase",;
    {{'Firebird','*.gdb'},{'Firebird fdb','*.fDB'},;
     {'All Files','*.*'}},1)      
   cDATABASEX := cMDBARQ
   cBANCOX:=hb_FNameSplit(cMDBARQ,NIL,cBANCOX,NIL)
CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL" ;
    .OR. cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "LETO"
    cBANCOX := PADR(cBANCOX,30," ")
   cSERVERX := PADR(cSERVERX,30," ")
   cUSERX := PADR(cUSERX,30," ")
   cPASSX := PADR(cPASSX,30," ")
   HB_dispbox(3,22,22,55,B_DOUBLE+" ")
   @ 05,23 SAY "Banco"
   @ 07,23 SAY "Server"         
   @ 09,23 SAY "user"           
   @ 11,23 say "pass"    
   @ 12,23 say "owener"
   @ 13,23 say "port"
   @ 05,23 GET cBANCOX   VALID buscachaves( cBANCOX )  
   @ 07,23 get cSERVERX  
   @ 09,23 get cuserx         
   @ 11,23 get cpassx
   @ 12,23 get cownerx
   @ 13,23 get cportx         
   READ
   cSERVERX := ALLTRIM(cSERVERX)
   cuserx  := alltrim(cuserx)
   cpassx  := alltrim(cpassx)
   cowenrx:= alltrim(cownerx)
   cportx   := alltrim(cportx)
   
   cMDBARQ := cDATABASEX
ENDCASE
RETURN cMDBARQ


*+--------------------------------------------------------------------\
*+    Function buscachaves()
*+--------------------------------------------------------------------\
FUNCTION buscachaves( cNomeBanco )
   LOCAL cSecaoCofre

   // Se o usuário digitou algo manualmente no servidor, aceita e não busca no cofre
   IF ! Empty( cNomeBanco)

       // Garante que a seção do cofre será o nome do banco limpo em maiúsculas
       cSecaoCofre := Upper( AllTrim( cNomeBanco ) )

       // Busca as credenciais de forma segura no config.dat mascarado
       cSERVERX := padr(LerDoCofre( cSecaoCofre, "Server" ),30)
       cUSERX   := padr(LerDoCofre( cSecaoCofre, "User" ),30)
       cPASSX   := padr(LerDoCofre( cSecaoCofre, "Password" ),30)
       cOwnerX   := padr(LerDoCofre( cSecaoCofre, "Owner" ),30)
       cportaX   := padr(LerDoCofre( cSecaoCofre, "portax"),30)
    ENDIF   
   

   RETURN .T.

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDBIMPDBF()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION MDBIMPDBF()


cMDBARQ := OPENTIPOARQ()

nOLDTIPO := TIPODBF
mdt("escolha origem")
tipodbfesc()
nORITIPO   := TIPODBF
cORIDRIVER := RDDNOME(TIPODBF)
cARQORI    := win_GetOpenFileName(,"Arquivos de Origem",HB_CWD(),"Arquivos de Origem","*.dbf",1)
IF FILE(cARQORI)
   DBF2MDB(cMDBARQ,cARQORI)
   RDDNOME(nOLDTIPO)  //retorna tipo anterior
ENDIF



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDBTABLES()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION MDBTABLES(cDataBase,cTABELA,cCAMPOSQL)

LOCAL aRETU
local cCONN
LOCAL cCOMANDO
LOCAL cTIPOINFO
local cFieldName   := ''
local cFieldType   := ''
local nFieldLength := 0
local nFieldDec    := 0
local lopen
Lopen        := .F.
lARQMDBACCDB := .F.
cCOMANDO     := ""


IF lMDB .OR. lACCDB
   lARQMDBACCDB := .T.
ENDIF

cTIPOINFO := "TABELA"
IF VALTYPE(cDATABASE) <> "C"
   cTIPOINFO := "DATABASE"
ENDIF
IF VALTYPE(cTABELA) = "C"
   cTIPOINFO := "ESTRUTURA"
ENDIF
IF VALTYPE(cCAMPOSQL) = "C"
   do case
   case cCAMPOSQL = "__INDEX__"
      cTIPOINFO := "__INDEX__"
   case cCAMPOSQL = "__VERSION__"
      cTIPOINFO := "__VERSION__"
   OTHERWISE
      cTIPOINFO := "CCAMPOSQL"
   ENDCASE
ENDIF

aRETU := {}
cCONN := GERACONN(cDATABASE)

try
oConn := WIN_OLECreateObject("ADODB.Connection")
with object oConn
:ConnectionString := cConn
:Open()
END
catch oErr
ShowADOError(oERR,oConn,cConn)
return aRETU
end


oRS                := WIN_OLECreateObject('ADODB.RecordSet')
oRS:CursorLocation := 3



cCOMANDO := ""
IF cTIPOINFO = "DATABASE"
   DO CASE
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "SHOW DATABASES;"
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := "SELECT datname FROM pg_database;"
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "SELECT name FROM master.dbo.sysdatabases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') "
   CASE cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" 
       cCOMANDO := "SELECT username  FROM dba_users  WHERE account_status = 'OPEN'  ORDER BY username;"
   CASE cTIPOSQL = "SQLITE" .or. at(".SQLITE",upper(cdatabase)) > 0    
       cCOMANDO := "SELECT name FROM pragma_database_list;"
   ENDCASE
ENDIF



IF cTIPOINFO = "TABELA"
   DO CASE
   CASE lARQMDBACCDB  //lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
      cCOMANDO := "select MSysObjects.name from MSysObjects where MSysObjects.type In (1,4,6) " ;
       +" and MSysObjects.name not like '~*'   and MSysObjects.name not like 'MSys%' " ;
       +" order by MSysObjects.name "
   CASE cTIPOSQL = "SQLITE" .or. at(".SQLITE",upper(cdatabase)) > 0
      cCOMANDO := "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name"
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "SHOW TABLES"
      //SHOW TABLES FROM `information_schema`;
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      if empty(cOwnerx)
         cCOMANDO := "SELECT tablename FROM pg_tables WHERE schemaname='public'  order by tablename"
      else
          cCOMANDO := "select tablename from pg_tables where schemaname = '" + cOwnerx + "' order by tablename"
      endif
      
      //SELECT table_name  FROM information_schema.tables  WHERE table_type = 'BASE TABLE' AND table_schema='public'
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';"
    CASE cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI" 
      if empty(cOwnerx)
         cCOMANDO := "SELECT table_name  FROM user_tables  order by TABLE_NAME"    //global SELECT owner, table_name  FROM all_tables
      else
         cCOMANDO :="select TABLE_NAME from all_tables where owner = '" + cOwnerx + "' order by TABLE_NAME"
      endif
    CASE cTIPOSQL = "FIREBIRD" 
      if empty(cOwnerx)
         cCOMANDO := "Select RDB$RELATION_NAME from RDB$RELATIONS where RDB$FLAGS = 1 order by RDB$RELATION_NAME"  
      else
         cCOMANDO := "select RDB$RELATION_NAME from RDB$RELATIONS where RDB$FLAGS = 1 AND RDB$OWNER_NAME = '" + cOwnerx + "' order by RDB$RELATION_NAME"
      endif
      
       CASE cTIPOSQL = "SYBASE"
      IF Empty(cOwner)
         cCOMANDO := "select name from sysobjects where type = N'U' order by name"
      ELSE
         cCOMANDO := "select name from sysobjects where type = N'U' and user_name(uid) = '" + cOwnerx + "' order by name"
      ENDIF

         
   endcase
ENDIF
IF cTIPOINFO = "ESTRUTURA"
   DO CASE
   CASE lARQMDBACCDB  //lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
      //Implantar possivelmente com catalogx
   CASE cTIPOSQL = "SQLITE" .or. at(".SQLITE",upper(cdatabase)) > 0
      cCOMANDO := "PRAGMA table_info( "+cTABELA+")"
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "SHOW COLUMNS FROM "+cTABELA
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := "SELECT   column_name,  udt_name,   character_maximum_length,   numeric_precision,  numeric_scale ,  data_type "
      cCOMANDO += " FROM   information_schema.columns "
      cCOMANDO += " WHERE   table_name = '"+UPPER(cTABELA)+"' ORDER BY ordinal_position ;"
      //nome tabela em maiusculo postgresql e case sensitive
      //udt_name melhor retorno mas tambem tras data_type caso necesario
      //where table_schema='public'  tras todas as tabelas do usurio(public)
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='"+cTABELA+"'"
   endcase
ENDIF
IF cTIPOINFO = "CCAMPOSQL"
   cCOMANDO := cCAMPOSQL
ENDIF
IF cTIPOINFO = "__INDEX__"
   DO CASE
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "SHOW INDEXES FROM "+cTABELA
   ENDCASE
ENDIF
IF cTIPOINFO = "__VERSION__"
   DO CASE
   CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
      cCOMANDO := "SELECT @@VERSION"
   CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
      cCOMANDO := "SELECT Version() AS 'VER'"
   CASE cTIPOSQL = "FIREBIRD"
      cCOMANDO := "SELECT RDB$GET_CONTEXT('SYSTEM', 'ENGINE_VERSION') AS 'VER' FROM RDB$DATABASE"
   CASE cTIPOSQL = "SQLITE" .or. at(".SQLITE",upper(cdatabase)) > 0
      cCOMANDO := "SELECT sqlite_version() AS 'VER'"
   CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
      cCOMANDO := "SELECT version()"
   ENDCASE
ENDIF


lopen := .f.
IF (cTIPOINFO = "ESTRUTURA" .OR. cTIPOINFO = "__INDEX__") .AND. lARQMDBACCDB
   //abaixo com catalog
ELSE
   TRY
   oRS:Open(cCOMANDO,oConN,adOpenDynamic,adLockOptimistic)
   lOPEN := .T.
   CATCH oERR
   lOPEN := .F.
   IF lARQMDBACCDB .AND. cTIPOINFO = "TABELA"
      //erro permisao acesso mysy
      EXECUTACMD(cdatabase,"GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC")
      EXECUTACMD(cdatabase,"create view showtables as select name from MSysObjects where MSysObjects.type In (1,4,6) and MSysObjects.name not like '~*' and MSysObjects.name not like 'MSys%'")
   ELSE
      ShowADOError(oERR,oConn,cCOMANDO)
   ENDIF
END
ENDIF


/* a vezes e preciso conceder este acesso na ide para a consulta na retornar vazia
cCOMANDO:="GRANT SELECT ON TABLE MSysObjects TO ADMIN,PUBLIC" 

create view showtables as select name from MSysObjects where MSysObjects.type In (1,4,6) and MSysObjects.name not like '~*' and MSysObjects.name not like 'MSys%' 
//nao aceita order by na criacao da view
*/


IF lOPEN
   while !ors:eof
      IF cTIPOINFO = "TABELA" .OR. cTIPOINFO = "CCAMPOSQL" .OR. cTIPOINFO = "DATABASE" .OR. cTIPOINFO = "__VERSION__"
         AADD(aRETU,ors:fields(0) :value)   //ors:fields(0) inicia as colunas com zero ou pelo nome da coluna fields("name")
      ENDIF
      IF cTIPOINFO = "ESTRUTURA"
         cFieldName   := ''
         cFieldType   := ''
         nFieldLength := 0
         nFieldDec    := 0

         // eDEFAULT :=""
         //inclusao valores default geracampo posicao 5 futuro correcao de nulls na importacao
         //
         DO CASE
         CASE cTIPOSQL = "SQLITE" .or. at(".SQLITE",upper(cdatabase)) > 0
            //table info colunas
            //cid, name, type, "notnull", dflt_value, pk
            // 1    2     3      4           5         6
            // 0    1     2      3           4         5 ->posicao no recordset
            cFieldName := upper(alltrim(ors:fields(1) :value))
            cFieldType := upper(alltrim(ors:fields(2) :value))
            AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
         CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
            //table info colunas
            // field, type, null, key, default,extra
            // 1      2     3      4      5      6
            // 0      1     2      3      4      5 ->posicao no recordset
            cFieldName := upper(alltrim(ors:fields(0) :value))
            cFieldType := upper(alltrim(ors:fields(1) :value))
            AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
         CASE cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
            cFieldName   := upper(alltrim(ors:fields(0) :value))  //column_name
            cFieldType   := upper(alltrim(ors:fields(1) :value))  // data_type
            nFieldLength := fixnum(ors:fields(2) :value)  //tamanho string character_maximum_length
            if fixnum(ors:fields(3) :value) > 0   //tamannho numeric
               nFieldLength := fixnum(ors:fields(3) :value)   //numeric_precision
               nFieldDec    := fixnum(ors:fields(4) :value)   //numeric_scale
            endif
            AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
         CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER"
            //implantar   catalog? outra?
         ENDCASE

      ENDIF
      IF cTIPOINFO = "__INDEX__"
         DO CASE
         CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64" .OR. cTIPOSQL = "MARIADB"
            //1table,2non_unique,3key_name,4_seq_in_index.5column_name....
            cCHAVENAME  := upper(alltrim(ors:fields(3) :value))
            cCHAVECAMPO := upper(alltrim(ors:fields(5) :value))
            AADD(aRETU,{cCHAVENAME,cCHAVECAMPO})
         ENDCASE
      ENDIF


      ors:movenext()
   enddo
   oRs:Close()
ENDIF


if LEN(aRETU) = 0 .AND. cTIPOINFO = "TABELA"
   //necessario nova conecaro
   //nao funcionou criando olecreate adox.catalog
   IF lARQMDBACCDB  //lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
      oXConection := win_oleCreateObject("ADODB.Connection")
      oXConection:Open(CCONN)
      oXCatalog := oXConection:OpenSchema(adSchemaTables)
      do while .not. oXCatalog:EOF()
         cTABELA := upper(alltrim(oXCatalog:Fields("TABLE_NAME") :Value))
         IF SUBSTR(cTABELA,1,4) <> "MSYS"
            AADD(aRETU,cTABELA)
         ENDIF
         oXCatalog:MoveNext()
      enddo
   ENDIF
endif

if LEN(aRETU) = 0 .AND. cTIPOINFO = "ESTRUTURA"
   IF lARQMDBACCDB  //lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
      //nao funcionou criando olecreate adox.catalog
      //necessario nova conecaro
      oXConection := win_oleCreateObject("ADODB.Connection")
      oXConection:Open(CCONN)
      oXCatalog := oXConection:OpenSchema(adSchemaColumns)
      do while .not. oXCatalog:EOF()
         IF UPPER(cTABELA) = UPPER(oXcatalog:Fields("TABLE_NAME") :Value)
            cFieldName   := UPPER(oXcatalog:Fields("COLUMN_NAME") :Value)
            cFieldType   := TipoDado2(oXcatalog:Fields("DATA_TYPE") :Value)
            nFieldLength := 0
            nFieldDec    := 0
            If cFieldType = "C"
               nFieldLength := oXcatalog:Fields("CHARACTER_MAXIMUM_LENGTH") :Value
               IF nFieldLength > 250
                  nFieldLength := 250
               ENDIF
               IF nFieldLength = 0  //alguns long var estao trazendo 0
                  nFieldLength := 250
               ENDIF
            ENDIF
            If cFieldType = "N"
               nFieldLength := oXcatalog:Fields("NUMERIC_PRECISION") :Value
               nFieldDec    := oXcatalog:Fields("NUMERIC_SCALE") :Value
            ENDIF
            If cFieldType = "D"
               nFieldLength := oXcatalog:Fields("DATETIME_PRECISION") :Value
            ENDIF
            If cFieldType = "L"
               nFieldLength := 1
            ENDIF
            IF oXcatalog:Fields("DATA_TYPE") :Value = 5   // adDouble   5
               IF nFieldDec = 0
                  nFieldDec := 5  //Coloca 5 como decimal
               ENDIF
            ENDIF
            nFieldLength := FIXINT(nFieldLength)
            nFieldDec    := FIXINT(nFieldDec)
            AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
         ENDIF
         oXcatalog:movenext()
      enddo
   ENDIF
endif


if LEN(aRETU) = 0 .AND. cTIPOINFO = "__INDEX__"
   IF lARQMDBACCDB  //lMDB .OR. lACCDB .or. at(".MDB",upper(cdatabase))>0 .or. at(".ACCDB",upper(cdatabase))>0
      //nao funcionou criando olecreate adox.catalog
      //necessario nova conecaro
      oXConection := win_oleCreateObject("ADODB.Connection")
      oXConection:Open(CCONN)
      oXCatalog := oXConection:OpenSchema(adSchemaIndexes)
      do while .not. oXCatalog:EOF()
         IF UPPER(cTABELA) = UPPER(oXcatalog:Fields("TABLE_NAME") :Value)
            cCHAVENAME  := UPPER(oXcatalog:Fields("INDEX_NAME") :Value)
            cCHAVECAMPO := UPPER(oXcatalog:Fields("COLUMN_NAME") :Value)
            //PRIMARY_KEY
            AADD(aRETU,{cCHAVENAME,cCHAVECAMPO})
         ENDIF
         oXcatalog:movenext()
      enddo
   ENDIF
endif

TRY
oConN:close()
END
RETURN aRETU


//TIPOC     tras o descritivo caracter data numeric...(em dbudoc)
//tipodado2 pega o tipo numerico do ado e convert para o tipo dbf padrao CNMDL
// Adotipodbf( nADOFieldType,nTIPORETORNO )
//numerico ado para nTIPORETRONO=1 numerico dbf, =2 tipo caracter exetendio(inclui double,ole...) =3 tuoos Basicos CMDLN

//pega o tipo numerico do ado e convert para o tipo dbf padrao CNMDL

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TipoDado2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
Function TipoDado2(nTipo)

do case
case nTipo = 8 .or. nTipo = 12 .or. nTipo = 72 .or. nTipo = 129 .or. nTipo = 130 .or. (nTipo >= 200 .and. nTipo <= 203)
   // adBSTR             8
   // adGUID             72
   // adChar             129
   // adWChar            130
   // adVarChar          200
   // adLongVarChar      201
   // adVarWChar         202
   // adLongVarWChar     203
   return 'C'

case nTipo = 17 .or. nTipo = 16 .or. nTipo = 14 .or. nTipo = 5 .or. nTipo = 3 .or. nTipo = 131 .or. nTipo = 2 .or. nTipo = 6 .or. ;
    nTipo = 4 .or. nTipo = 020 .or. nTipo = 018 .or. nTipo = 019 .or. nTipo = 21 .or. nTipo = 138 .or. nTipo = 139
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
   return 'N'   // Numerico

case nTipo = 7 .or. nTipo = 64 .or. nTipo = 133 .or. nTipo = 134 .or. nTipo = 135
   // adDate             7
   // adFileTime         64
   // adDBDate           133
   // adDBTime           134
   // adDBTimeStamp      135
   return 'D'   // Data

case nTipo = 11
   // adBoolean          11
   return 'L'   // Logico

case nTipo = 128 .or. nTipo = 201 .or. nTipo = 203 .or. nTipo = 205
   // adLongVarWChar     203
   // adPropVariant      138
   return 'M'   // Memo

case nTipo = 128 .or. nTipo = 204 .or. nTipo = 205
   // adBinary           128
   // adVarBinary        204
   // adLongVarBinary    205
   return 'G'   // Imagem HB_FT_OLE

otherwise
   alert('Tipo de dado invalido: Campo '+cField+' Type='+str(nTipo))
endcase
return 'U'



//numerico ado para nTIPORETRONO=1 numerico dbf, =2 tipo caracter extendido(inclui double,ole...) =3 typos Basicos CMDLN

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function Adotipodbf()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function Adotipodbf(nADOFieldType,nTIPORETORNO)

//HB_FT_PICTURE ="P" sem equivalente ado harbour
//adarray nao padrao rdd harbour conta na adox e na adordd

LOCAL nDBFFieldType := 0
LOCAL cDBFFieldType := ""

IF nTIPORETORNO = 3
   RETURN TipoDado2(nADOFieldType)
ENDIF


DO CASE

CASE nADOFieldType == adEmpty
CASE nADOFieldType == adTinyInt
   nDBFFieldType := HB_FT_INTEGER
   cDBFFieldType := "I"

CASE nADOFieldType == adSmallInt
   nDBFFieldType := HB_FT_INTEGER
   cDBFFieldType := "I"

CASE nADOFieldType == adInteger
   nDBFFieldType := HB_FT_INTEGER
   cDBFFieldType := "I"

CASE nADOFieldType == adBigInt
   nDBFFieldType := HB_FT_INTEGER
   cDBFFieldType := "I"

CASE nADOFieldType == adUnsignedTinyInt
CASE nADOFieldType == adUnsignedSmallInt
CASE nADOFieldType == adUnsignedInt
CASE nADOFieldType == adUnsignedBigInt
CASE nADOFieldType == adSingle

CASE nADOFieldType == adDouble
   nDBFFieldType := HB_FT_DOUBLE
   cDBFFieldType := "B"

CASE nADOFieldType == adCurrency
   nDBFFieldType := HB_FT_INTEGER
   cDBFFieldType := "I"

CASE nADOFieldType == adDecimal
   nDBFFieldType := HB_FT_LONG
   cDBFFieldType := "N"

CASE nADOFieldType == adNumeric
   nDBFFieldType := HB_FT_LONG
   cDBFFieldType := "N"

CASE nADOFieldType == adError
CASE nADOFieldType == adUserDefined
CASE nADOFieldType == adVariant
   nDBFFieldType := HB_FT_ANY
   cDBFFieldType := "V"

CASE nADOFieldType == adIDispatch

CASE nADOFieldType == adIUnknown

CASE nADOFieldType == adGUID
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adDate
   nDBFFieldType := HB_FT_DATE
   cDBFFieldType := "D"

CASE nADOFieldType == adDBDate
   nDBFFieldType := HB_FT_DATE
   cDBFFieldType := "D"

CASE nADOFieldType == adDBTime

CASE nADOFieldType == adDBTimeStamp
   nDBFFieldType := HB_FT_TIMESTAMP
   cDBFFieldType := "@"

CASE nADOFieldType == adFileTime
   nDBFFieldType := HB_FT_DATETIME
   cDBFFieldType := "T"

CASE nADOFieldType == adBSTR
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adChar
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adVarChar
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adLongVarChar
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adWChar
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adVarWChar
   nDBFFieldType := HB_FT_STRING
   cDBFFieldType := "C"

CASE nADOFieldType == adBinary
   nDBFFieldType := HB_FT_OLE
   cDBFFieldType := "G"

CASE nADOFieldType == adVarBinary
   nDBFFieldType := HB_FT_OLE
   cDBFFieldType := "G"

CASE nADOFieldType == adLongVarBinary
   nDBFFieldType := HB_FT_OLE
   cDBFFieldType := "G"

CASE nADOFieldType == adChapter

CASE nADOFieldType == adVarNumeric

   // CASE nADOFieldType == adArray


CASE nADOFieldType == adBoolean
   nDBFFieldType := HB_FT_LOGICAL
   cDBFFieldType := "L"

CASE nADOFieldType == adLongVarWChar
   nDBFFieldType := HB_FT_MEMO
   cDBFFieldType := "M"

CASE nADOFieldType == adPropVariant
   nDBFFieldType := HB_FT_MEMO
   cDBFFieldType := "M"

ENDCASE

RETURN if(nTIPORETORNO = 1,nDBFFieldType,cDBFFieldType)



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function geracampodbf()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec)

local aRETU
local cSUBTIPO
aRETU := {cFieldName,cFieldType,nFieldLength,nFieldDec}



cTYPE    := cFieldType
cSUBTIPO := ""
IF SUBSTR(cTYPE,2,1) = ":"  //sqlimix manda tipo e subtipo exemplos N:i   C:CU  @:D
   cFieldType := SUBSTR(cTYPE,1,1)
   cSUBTIPO   := SUBSTR(cTYPE,3)
   cTYPE      := SUBSTR(cTYPE,1,1)
ENDIF

do case

   //
   // numeric(l,d) decimal(l,d)  number(l,d) o tamanho esta entre parentes
   //
CASE AT("(",cTYPE) > 0 .AND. AT(")",cTYPE) > 0 .AND. AT(",",cTYPE) > 0 .AND. (AT("NUMERIC",UPPER(CTYPE)) > 0 .OR. AT("DECIMAL",UPPER(CTYPE)) > 0 .OR. AT("NUMBER",UPPER(CTYPE)) > 0)
   cTMPSIZE     := SUBSTR(cTYPE,AT("(",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(",",cTMPSIZE) - 1)
   nFieldLength := val(cTMPSIZE)
   cTMPSIZE     := SUBSTR(cTYPE,AT(",",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE) - 1)
   nFieldDec    := val(cTMPSIZE)
   cFieldType   := 'N'


   //
   //  tyniint(n) int(n) number(n) tamanho esta entre parentes
   //
case AT("(",cTYPE) > 0 .AND. AT(")",cTYPE) > 0 .AND. AT(",",cTYPE) = 0 .AND. (AT("INT",UPPER(CTYPE)) > 0 .or. AT("NUMBER",UPPER(CTYPE)) > 0)
   cTMPSIZE     := SUBSTR(cTYPE,AT("(",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE) - 1)
   nFieldLength := VAL(cTMPSIZE)
   cFieldType   := 'N'
   nFieldDec    := 0


   //
   // varchar(n) char(n) text(n)  VARCHAR2(n) o tamanho esta entre parentes
   //
case AT("(",cTYPE) > 0 .AND. AT(")",cTYPE) > 0 .AND. (AT("CHAR",UPPER(CTYPE)) > 0 .OR. AT("TEXT",UPPER(CTYPE)) > 0 .OR. AT("VARCHAR2",UPPER(CTYPE)) > 0)
   cTMPSIZE     := SUBSTR(cTYPE,AT("(",cTYPE)+1)
   cTMPSIZE     := SUBSTR(cTMPSIZE,1,AT(")",cTMPSIZE) - 1)
   nFieldLength := VAL(cTMPSIZE)
   cFieldType   := 'C'
   nFieldDec    := 0


case cType == "TINYINT"
   cFieldType   := 'N'
   nFieldLength := 2
   nFieldDec    := 0


case cType == "INT2" .OR. cType == "SMALLINT"
   cFieldType   := 'N'
   nFieldLength := 4
   nFieldDec    := 0

case cType == "INT" .or. cType == "MEDIUMINT"
   cFieldType   := 'N'
   nFieldLength := 8
   nFieldDec    := 0


case cType == "INTEGER" .OR. cType == "INT4" .OR. cType == "SERIAL"
   cFieldType   := 'N'
   nFieldLength := 8
   nFieldDec    := 0

case cType == "BIGINT" .OR. cType == "INT8" .OR. cType == "BIGSERIAL"
   cFieldType   := 'N'
   nFieldLength := 16
   nFieldDec    := 0


//no sqllite tem a vezes aparece so DECIMAL nao especificado a precisao DECIMAL(n,d)
case cType == "DOUBLE PRECISION" .or. cType == "FLOAT8"  .OR. cType == "DECIMAL" 
   cFieldType   := 'N'
   nFieldLength := 19
   nFieldDec    := 9

case cType == "MONEY"
   cFieldType   := 'N'
   nFieldLength := 12
   nFieldDec    := 2

case cType == "REAL" .or. cType == "FLOAT" .or. cType == "DOUBLE" .or. cType == "FLOAT4"
   cFieldType   := 'N'
   nFieldLength := 14
   nFieldDec    := 5


case cType == "DATE" .or. cType == 'DATETIME' .or. cType == 'SHORTDATE' .or. cType == 'TIMESTAMP' ;
    .OR. cType == "D" .OR. cType == "TYPE_TIMESTAMP" .or. cType == "TYPE_DATE"
   cFieldType   := 'D'
   nFieldLength := 8
   nFieldDec    := 0

case cType == "@"   //Datetime opcao mudar como texto ou datetime futuramente
   cFieldType   := 'D'
   nFieldLength := 8
   nFieldDec    := 0

case cType == "BOOL" .or. cType == 'BOOLEAN'
   cFieldType   := 'L'
   nFieldLength := 1
   nFieldDec    := 0

CASE cType == "CLOB" .AND. (cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI")  //Memo mas tratando com char(250)
   cFieldType   := 'C'
   nFieldLength := 250
   nFieldDec    := 0


CASE cType == "TEXT" .AND. (cTIPOSQL = "SQLITE" .OR. cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL")   //Memo mas tratando com char(250)
   cFieldType   := 'C'
   nFieldLength := 250
   nFieldDec    := 0

CASE cType == "LONGTEXT" .OR. cType == "M" .OR. cType == "WLONGVARCHAR"   //Memo mas tratando com char(250)
   cFieldType   := 'C'
   nFieldLength := 250
   nFieldDec    := 0
   //
   // TEXT SEM tamanho memo
   //
case AT("(",cTYPE) = 0 .AND. AT(")",cTYPE) = 0 .AND. AT("TEXT",UPPER(CTYPE)) > 0
   nFieldLength := 10
   cFieldType   := 'M'
   nFieldDec    := 0

   //
   // numeric sem ()
   //
case AT("(",cTYPE) = 0 .AND. AT(")",cTYPE) = 0 .AND. AT("NUMERIC",UPPER(CTYPE)) > 0
   cFieldType := 'N'
   IF nFieldLength = 0  //atribui 8 padrao integer caso nao foi passado
      nFieldLength := 8
      nFieldDec    := 0
   ENDIF

   //
   // postgresql varchar bpchar CHARACTER
   //
CASE cType == "VARCHAR" .OR. cType == "BPCHAR" .OR. AT("CHARACTER",UPPER(CTYPE)) > 0 .OR. cType == "WVARCHAR" .OR. cType == "WCHAR"
   cFieldType := 'C'
   nFieldDec  := 0


CASE cType == "NAME"
   cFieldType   := 'C'
   nFieldLength := 64
   nFieldDec    := 0

CASE cType == "C" .AND. nFieldLength > 250  //alguns longchar vem comprimento 65535 estudando mudar para memo por enquanto C 250
   nFieldLength := 250

   //
   // Inteiro sub numerico troca para numerico
   //
CASE cType == "I" .AND. cSUBTIPO == "N"
   cFieldType := 'N'

CASE cType == "OID"
   cFieldType   := 'N'
   nFieldLength := 19
   nFieldDec    := 0

otherwise
   //mantem  os dados enviados

endcase
//Inclusao rotina pegar max quando campo tamanho for zero

aRETU := {cFieldName,cFieldType,nFieldLength,nFieldDec}
return aRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function geraconn()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION geraconn(cCAMBASE,lPROVIDER)

LOCAL cCONN
LOCAL cSQLUSER
cConn    := ""
cSQLUSER := ""
IF VALTYPE(cCAMBASE) <> "C"   //ser for database nao tem caminho usa cservex
   cCAMBASE := ""   //atribui vazio
ENDIF
IF vALTYPE(lPROVIDER) <> "L"
   lPROVIDER := .T.
ENDIF

IF Empty( cUSERX )
      cUSERX := LerDoCofre( cSERVERX, "User" )
   ENDIF

   IF Empty( cPASSX )
      cPASSX := LerDoCofre( cSERVERX, "Password" )
   ENDIF
   
   IF Empty( cSERVERX )
      cSERVERX := LerDoCofre( cSERVERX, "Server" )
   ENDIF

DO CASE

CASE lMDB .OR. at(".MDB",upper(cCAMBASE)) > 0   ///cTIPOSQL="MDB" .OR. cTIPOSQL="MDB64" .or. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCESS64"  .or. at(".MDB",upper(cCAMBASE))>0
   if loledb  // provider ou driver que fixa o nome independente da versao do access sqlmix(usa driver) adordd(use provider)
      IF lPROVIDER
         cConn := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Mode=Share Deny None"  //32 bit jet oledb
      ELSE
         cCONN := "Driver={Microsoft Access Driver (*.mdb)};Dbq="+cDATABASEX+";Mode=Share Deny None"
      ENDIF
   else
      IF lPROVIDER
         cConn := "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+cCAMBASE+";Mode=Share Deny None"   //64 bit ace oledb
      ELSE
         cCONN := "Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq="+cDATABASEX+";Mode=Share Deny None"
      ENDIF
   endif

CASE Laccdb .or. at(".ACCDB",upper(cCAMBASE)) > 0   //cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64" .or. at(".ACCDB",upper(cCAMBASE))>0
   //provider ou driver que fixa o nome independente da versao do access sqlmix(usa driver) adordd(use provider)
   IF lPROVIDER
      cConn := "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="+cCAMBASE+";Mode=Share Deny None"  //driver 32 e 64 devem estar instalados
   ELSE
      cCONN := "Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq="+cDATABASEX+";Mode=Share Deny None"
   ENDIF
CASE cTIPOSQL = "SQLITE" .or. at(".SQLITE",upper(cCAMBASE)) > 0
   cConn := "Driver={SQLite3 ODBC Driver};Database="+cCAMBASE+";"   //mesmo nome de driver para 32 e 64 ambos devem estar instaldos

CASE cTIPOSQL = "MYSQL" .OR. cTIPOSQL = "MYSQL64"
   if empty(cDATABASEX)
      if loledb
         cConn := "Driver={MySQL ODBC 8.0 ANSI Driver};Server="+cSERVERX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //32 driver versao 8
      else
         cConn := "Driver={MySQL ODBC 9.0 ANSI Driver};Server="+cSERVERX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //64 driver versao 9
      endif
   else
      if loledb
         cConn := "Driver={MySQL ODBC 8.0 ANSI Driver};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //32 driver versao 8
      else
         cConn := "Driver={MySQL ODBC 9.0 ANSI Driver};Server="+cSERVERX+";Database="+cDATABASEX+";Uid="+CUSERX+";Pwd="+cPASSX+";"  //64 driver versao 9
      endif
   endif
case cTIPOSQL = "MARIADB"   //mesmo nome de driver para 32 e 64 ambos devem estar instaldos
   if empty(cDATABASEX)
      cConn := "DRIVER={MariaDB ODBC 3.2 Driver};SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
   else
      cConn := "DRIVER={MariaDB ODBC 3.2 Driver};DATABASE="+cDATABASEX+";SERVER="+cSERVERX+";UID="+cUSERX+";PASSWORD="+cPASSX
   endif
case cTIPOSQL = "PGSQL" .OR. cTIPOSQL = "PGSQL64" .OR. cTIPOSQL = "POSTGRESQL"
   //Driver={PostgreSQL ANSI};Server=IP address;Port=5432;Database=myDataBase;Uid=myUsername;Pwd=myPassword;
   if empty(cDATABASEX)
      if loledb
         cConn := "DRIVER={PostgreSQL ANSI};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX +"; ConnSettings=SET client_encoding TO 'WIN1252';"  //+";pqopt={search_path=myschema,public}" //32 driver versao
      else
         cConn := "DRIVER={PostgreSQL ANSI(x64)};Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX +"; ConnSettings=SET client_encoding TO 'WIN1252';" //+";pqopt={search_path=myschema,public}"  //64 driver versao x64
      endif
   else
      if loledb
         cConn := "DRIVER={PostgreSQL ANSI};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX +"; ConnSettings=SET client_encoding TO 'WIN1252';"  //+";pqopt={search_path=myschema,public}"  //32 driver versao
      else
         cConn := "DRIVER={PostgreSQL ANSI(x64)};Database="+cDATABASEX+";Server="+cSERVERX+";Uid="+cUSERX+";Pwd="+cPASSX +"; ConnSettings=SET client_encoding TO 'WIN1252';" //+";pqopt={search_path=myschema,public}" //64 driver versao 964
      endif
   endif
CASE cTIPOSQL = "MSSQL" .OR. cTIPOSQL = "SQLSERVER" .OR. cTIPOSQL = "SQL"
   IF EMPTY(cUSERX)
      cSQLUSER := "; Trusted_Connection=True;"
   ELSE
      cSQLUSER := "; Uid="+cUSERX+"; Pwd="+cPASSX+";"
   ENDIF
   if empty(cDATABASEX)
      IF lPROVIDER
         cCONN := "Provider=SQLOLEDB;Server="+cSERVERX+";Database="+cDATABASEX+cSQLUSER
      ELSE
         cCONN := "Driver={SQL Server};Server="+cSERVERX+";Database="+cDATABASEX+cSQLUSER
      ENDIF
   else
      IF lPROVIDER
         cCONN := "Provider=SQLOLEDB;Server="+cSERVERX+cSQLUSER
      ELSE
         cCONN := "Driver={SQL Server};Server="+cSERVERX+cSQLUSER
      ENDIF
   endif
CASE cTIPOSQL = "DBASE"
   cCONN := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Extended Properties=dBASE IV;"
CASE cTIPOSQL = "FIREBIRD"  // ADOGDB
   cCONN := "DRIVER=Firebird ODBC driver; UID="+cUSERX+"; PWD="+cPASSX+"; DBNAME="+cCAMBASE
   //cCONN := "DRIVER=Firebird/InterBase(r) driver; UID="+cUSERX+"; PWD="+cPASSX+"; DBNAME="+cCAMBASE

CASE cTIPOSQL = "PARADOX"   // ADOPX
   cCONN := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Extended Properties=Paradox 5.x;"
CASE cTIPOSQL == "XMLDB"  // ADOXML
   cCONN := "Provider=MSPersist"
CASE cTIPOSQL == "XML"  // ADOXML
   cCONN := "Provider=MSDAOSP;Data Source="+cCAMBASE+";"  //MSXML2.DSOControl.2.6"
CASE cTIPOSQL = "XLS"   // ADOXLS
   cCONN := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cCAMBASE+";Extended Properties=Excel 8.0;HDR=Yes;IMEX=1"
CASE cTIPOSQL = "REMOTE"  // ADORDS
   cCONN := "Provider=MS Remote;Remote Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cDATABASEX+";Remote Server="+cSERVERX
Case cTIPOSQL = "ORACLE" .OR. cTIPOSQL = "OCI"
   cSQLUSER := ";User ID="+cUSERX+";Password="+cPASSX
   IF lPROVIDER
      cCONN := "Provider=MSDAORA.1;Persist Security Info=False;Data source="+cDATABASEX+cSQLUSER
   ELSE
      cCONN := "DRIVER={Microsoft ODBC For Oracle};SERVER="+cSERVERX+"; UID= "+cUSERX+";PWD="+cPASSX
   ENDIF
   //Provider=OraOLEDB.Oracle.1;Persist Security Info=False;User ID=someuser;Data Source=someserver;
   //"Provider=OraOLEDB.Oracle;dbq=localhost:1521/XE;Database=myDataBase;", User, Pass
   //"Provider=MSDAORA.1;Password=[pwd];User ID=[schema name];Data Source=[db name];Persist Security Info=True")
ENDCASE
RETURN cConn





*+--------------------------------------------------------------------
*+
*+
*+
*+    Function executacmd()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
Function executacmd(cCAMBASE,eCOMANDO)

LOCAL cCHAVEV
LOCAL cConn
LOCAL aCOMANDOS := {}
LOCAL nFIM
LOCAL cCOMANDO  := ""
local i

//Gera array para casos sejam mutilplos comando em uma matriz
//evitando abrir e fechar a conecao para comando em sequencia
IF VALTYPE(eCOMANDO) = "C"
   AAdd(aCOMANDOS,eCOMANDO)
ELSE
   aCOMANDOS := eCOMANDO
ENDIF
nFIM := LEN(aCOMANDOS)

cCHAVEV := ""
cConn   := geraconn(cCAMBASE)

IF EMPTY(cConn)
   return .f.
endif

try
oConn := WIN_OLECreateObject("ADODB.Connection")
with object oConn
:ConnectionString := cConn
:Open()
END   //end do with
catch oErr
ShowAdoError(oERR,oCoNn)
return .f.
end

try
oComm := WIN_OLECreateObject("ADODB.Command")
catch oErr
ShowAdoError(oERR,oCoNn)
return .f.
end

for i := 1 to nfim
   cCOMANDO := aCOMANDOS[I]
   IF .NOT. EMPTY(cCOMANDO)
      try
      with object oComm
      :CommandText      := cCOMANDO
      :CommandType      := adCmdText
      :ActiveConnection := oConn
      :Execute()
   end
end
ENDIF
next i
oConn:Close()
oConn := NIL
RETURN .t.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CreateAccessDatabase()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION CreateAccessDatabase(cDatabase,cUserName,cPassword,lEncrypt)


LOCAL oCatalog  // AS ADOX.Catalog
LOCAL cEXTENSAO
LOCAL cDIRETORIO
LOCAL cNAME

cNAME      := ""
cEXTENSAO  := ""
cDIRETORIO := ""


hb_FNameSplit(cDataBase,@cDIRETORIO,@cName,@CEXTENSAO)
cEXTENSAO := LOWER(cEXTENSAO)


IIF(cPassword == NIL,cPassword := "''",NIL)
IIF(lEncrypt == NIL,lEncrypt := .F.,NIL)

oCatalog := WIN_OLECreateObject("ADOX.Catalog")   //CreateObject( "ADOX.Catalog" )

/* OLEDB:Engine Type=5
   Unknown 0
   Jet 1.0            1
   Jet 1.1            2
   Jet 2.0            3
   Jet 3.x(97)        4
   Jet 4.x(2000)      5
   JetEngineType_Ace12 = 6
  */

IF !hb_FileExists(cDataBase)
   do case
   case lACCDB .OR. cEXTENSAO == ".accdb"
      oCatalog:Create("Provider=Microsoft.ACE.OLEDB.12;"+;
       "Data Source="+cDatabase+";"+;
       "JET OLEDB:Engine Type=6;")
   CASE lMDB .OR. cEXTENSAO == ".mdb"
      if loledb   //32 bits mdb
         oCatalog:Create("Provider=Microsoft.Jet.OLEDB.4.0;"+;
          "Data Source="+cDatabase+";"+;
          "JET OLEDB:Engine Type=5;")
      else
         oCatalog:Create("Provider=Microsoft.ACE.OLEDB.12;"+;
          "Data Source="+cDatabase+";"+;
          "JET OLEDB:Engine Type=5;")
      ENDIF
   CASE cTIPOSQL = "SQLITE" .or. cEXTENSAO == ".sqlite" .or. cEXTENSAO == ".sqlite3" .or. cEXTENSAO == ".fossil" .or. cEXTENSAO == ".db3"
      oCatalog:Create("DRIVER=SQLite3 ODBC Driver;Database="+cDataBase)
   CASE cTIPOSQL = "XLS" .or. cEXTENSAO == ".xls"
      oCatalog:Create("Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cDataBase+";Extended Properties='Excel 8.0;HDR=YES';Persist Security Info=False")
   CASE cEXTENSAO == ".db" .OR. cTIPOSQL == "PARADOX"
      oCatalog:Create("Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cDataBase+";Extended Properties='Paradox 5.x';")
   CASE cEXTENSAO == ".fdb" .OR. cEXTENSAO == ".gdb" .OR. cTIPOSQL == "FIREBIRD"
      //oCatalog:Create( "Driver=Firebird/InterBase(r) driver;Uid=" + cUserName + ";Pwd=" + cPassword + ";DbName=" + cDataBase + ";" )
      oCatalog:Create("DRIVER=Firebird ODBC driver;Uid="+cUserName+";Pwd="+cPassword+";DbName="+cDataBase+";")

   endcase
   oCatalog := NIL  //NULL_OBJECT
endif
/* exemplo pass e ou encripitado
   oCatalog:Create( "Provider=Microsoft.Jet.OLEDB.4.0;" +;
                    "Data Source=" + cDatabase + ";" +;
                    "JET OLEDB:Database Password=" + cPassWord + ";" +;
                    "JET OLEDB:Engine Type=5;" +;
                    "JET OLEDB:Encrypt Database=" + IIF(lEncrypt, "TRUE", "FALSE" ) )
*/
RETURN


function mdltodos()
cTEXTO:=""
FAZERDBF( {|| cTEXTO+=GERADBML(,,.F.) }, .F. )
hb_MemoWrit("estrutura.DBML", cTEXTO ) 
RETURN .T.

function sqltodos(cTIPOSQL)
cTEXTO:=""
FAZERDBF( {|| cTEXTO+=FormataBlocoSql(SqliteCreateTable( , , cTIPOSQL,.T.,.T. )) }, .F. )
hb_MemoWrit(cTIPOSQL+".sql", cTEXTO ) 
RETURN .T.

// +--------------------------------------------------------------------
// +    Function trocasenhaarq()
// +    Objetivo: Centralizar a troca de credenciais APENAS para bancos
// +              baseados em arquivos físicos locais (Tags selecionadas)
// +--------------------------------------------------------------------
FUNCTION trocasenhaarq()
LOCAL aTELA
LOCAL cNovoUser    := PADR(AllTrim(cUSERX), 30, " ")
LOCAL cNovaPass    := PADR(AllTrim(cPASSX), 30, " ")
LOCAL cSessaoCofre := ""
LOCAL cNomeArquivo := ""
LOCAL cExtensao    := ""
LOCAL lValido      := .F.

// 1. Validação estrita por Tag de Banco de Dados ou Extensão
cExtensao := Lower( hb_FNameExt( cDATABASEX ) )

IF cTIPOSQL $ "SQLITE#ACCESS#MDB#ACCDB"
   lValido := .T.
ELSEIF cTIPOSQL == "FIREBIRD" .AND. ( cExtensao $ ".fdb#.gdb#.fgb" )
   // Só aceita Firebird se estiver apontando para um arquivo local válido
   lValido := .T.
ENDIF

IF !lValido
   MDT( "Seguranca de arquivo nao disponivel para o banco: " + cTIPOSQL )
   RETURN .F.
ENDIF

// 2. Extração do nome do arquivo para servir de Seção (Ex: PROCESSO)
IF !Empty( cDATABASEX )
   hb_FNameSplit( cDATABASEX, NIL, @cNomeArquivo, NIL )
   IF !Empty( cNomeArquivo )
      cSessaoCofre := Upper( AllTrim( cNomeArquivo ) )
   ENDIF
ENDIF

IF Empty( cSessaoCofre )
   MDT( "Selecione o arquivo de dados antes de alterar as credenciais." )
   RETURN .F.
ENDIF

aTELA := SALVAA()

hb_DispBox( 10, 15, 16, 70, B_DOUBLE + " " )
@ 10, 17 SAY " Credenciais [" + cTIPOSQL + "] - Cofre: [" + cSessaoCofre + "] "

@ 12, 17 SAY "Arquivo.:" + PadR( cNomeArquivo + cExtensao, 35 )
@ 13, 17 SAY "Usuario.:" GET cNovoUser PICTURE "@!"
@ 14, 17 SAY "Senha...:" GET cNovaPass

READ

IF LastKey() != 27 // Confirmação (Não pressionou ESC)
   cUSERX := cNovoUser
   cPASSX := cNovaPass
   
   // Gravação criptografada no config.dat baseada na tag/nome isolado
   GravarNoCofre( cSessaoCofre, "USER",     AllTrim( cUSERX ) )
   GravarNoCofre( cSessaoCofre, "PASSWORD", AllTrim( cPASSX ) )
   
   MDT("Dados salvos com sucesso no cofre [" + cSessaoCofre + "]!")
ENDIF

RESTAA(aTELA)
RETURN .T.

*+ EOF: mdb2dbf.prg
*+
