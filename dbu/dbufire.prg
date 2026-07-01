*+--------------------------------------------------------------------
*+
*+    Programa  : dbufire.prg
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+    Documentado em 6-Jan-2025 as  3:37 pm
*+
*+--------------------------------------------------------------------
*+

#include "BOX.CH"
#include "TRY.CH"
#include "dbstruct.ch"


#require "hbfbird"


// +--------------------------------------------------------------------
// +    Function firebirdmenu()
// +--------------------------------------------------------------------
FUNCTION Firebirdmenu()

LOCAL aAMBIENTE
LOCAL KEY


 /*
 LOCAL cServer := "localhost:"
   LOCAL cDatabase
   LOCAL cUser := "SYSDBA"
   LOCAL cPass := "masterkey"
   LOCAL nPageSize := 1024
   LOCAL cCharSet := "ASCII"
   LOCAL nDialect := 1
   LOCAL cName
 */  

nPageSize := 1024
cCharSet := "ISO8859_1" //"ASCII"
nDialect := 3 //deixando com 1 caso de erro criacao com 3
//Dialeto 1 Focado em compatibilidade retroativa (InterBase 6.0 ou inferior).
//Dialeto 2 Criado como uma zona de transição para ajudar programadores na migração do Dialeto 1 para o 3.
//Dialeto 3 É o padrão moderno e o recomendado para todos os novos sistemas.

aAMBIENTE  := SALVAA() 
cSERVERX   := PADR("localhost",30)  // localhost:cARQUIVO no connection
cDATABASEX := Space(30) 
cUSERX     :=  PADR("SYSDBA",30)
cPASSX     := PADR("masterkey",30)
cTABELAX   := Space(30) 
cBANCOX    := Space(30) 
cOWNERX   := Space(30)
cPORTAX    :=SPACE(30)
cPATH      := "" 
loledb     := .T. 
lMDB       := .F. 
lACCDB     := .F. 
lFDB       := .T.

cOLDRDD     := RDDSETDEFAULT("") 
nOLDTIPORDD := TIPODBF 
cTIPOSQL := "FIREBIRD"  // Passa para privada usadas nas funcoes abaixo 


// Busca as credenciais e o caminho do banco dinamicamente via cofre do sistema
pegcfgbanco() 

// Seleção do arquivo físico .fdb se aplicável à rotina local pegcfgbanco ja chama opentiparq quando e firebird
//OPENTIPOARQ()

WHILE .T.
   hb_DispBox(3,22,22,55,B_DOUBLE+" ") 
   @ 03,24 SAY "FIREBIRD"+" "+ALLTRIM(cSERVERX) 
   
   OPCAO( 4,24,"&Criar Database            ",67)   // c 
   OPCAO( 5,24,"&Tabelas                   ",84)   // T 
   OPCAO( 6,24,"&Importar  DBF             ",73)   // I 
   OPCAO( 7,24,"&Exportar  DBF             ",69)   // E 
   OPCAO( 8,24,"&Apagar Tabela             ",65)   // A 
   OPCAO( 9,24,"Exportar &Formatos         ",70)   // F 
   OPCAO(10,24,"&Versao Info               ",86)   // V 
   OPCAO(11,24,"Executar arquivo &SQL      ",83)   //S 83
   
   KEY := menu(1,0) 
   DO CASE
   CASE KEY = 1
      firecreate()
   CASE KEY = 2
      fireTABELAS() 
   CASE KEY = 3
      fireimpdbf()
   CASE KEY = 4
      fireexpdbf( 1 )
   CASE KEY = 5
      firedeltable()
   CASE KEY = 6
      fireexpdbf( 2 )
   CASE KEY = 7
      fireverinfo()
   CASE KEY = 8
      fireExecArqSql()
         
       
   OTHERWISE
      EXIT 
   ENDCASE
ENDDO 

TIPODBF := nOLDTIPORDD 
rddSetDefault(cOLDRDD) 
RDDNOME(TIPODBF) 

RESTAA(aAMBIENTE) 
LAYOUT() 

RETURN .T. 

// +--------------------------------------------------------------------
// +    Function firecreate()
// +--------------------------------------------------------------------
function firecreate(nDIAUSO)
    cARQORI := win_GetsaveFileName(,"Firebase Files",HB_CWD(),"Firebase",;
        {{'Firebird fdb','*.fdb'},{'Firebird gdb','*.gdb'},{'Firebird ib','*.ib'},;
         {'All Files','*.*'}},1)  
   cDATABASEX := cARQORI
   cBANCOX:=hb_FNameSplit(cARQORI,NIL,cBANCOX,NIL)

    FBCreateDB( AllTrim(cSERVERX) + ":" + AllTrim(cARQORI), cUSERX, cPASSX, nPageSize, cCharSet, nDialect )


    //ccharset  e ndialect a prior nao podem ser alterados por isso se define na criacao    
   //fireexecuteSQL({"DEFAULT CHARACTER SET WIN1252","COLLATION PT_BR;"})
   //ALTER CHARACTER SET NOME_DO_CHARSET SET DEFAULT COLLATION NOME_DO_COLLATION;
    //DEFAULT CHARACTER SET WIN1252
    //COLLATION PT_BR;
return .T.

// +--------------------------------------------------------------------
// +    Function fireconnect()
// +--------------------------------------------------------------------
STATIC FUNCTION fireconnect()
LOCAL oServer
LOCAL cConnString

// Monta string de conexão no formato "host:caminho_ou_alias"
cConnString := AllTrim(cSERVERX) + ":" + AllTrim(cDATABASEX)

// Instancia o servidor nativo usando TFBServer (Dialeto padrão 3)
oServer := TFBServer():New( cConnString, AllTrim(cUSERX), AllTrim(cPASSX), 3 )

IF oServer:NetErr()
   Alert( "Falha na conexao Nativa Firebird: " + oServer:Error() )
   RETURN NIL
ENDIF

RETURN oServer

// +--------------------------------------------------------------------
// +    Function fireverinfo()
// +--------------------------------------------------------------------
FUNCTION fireverinfo()
LOCAL oServer
LOCAL cVersionInfo := ""

oServer := fireconnect()
IF oServer != NIL
   // Captura a string de versão retornada diretamente pela API do cliente Firebird
   cVersionInfo := oServer:GetServerInfo()
   
   IF Empty( cVersionInfo )
      cVersionInfo := "Nao foi possivel ler os detalhes da versao."
   ENDIF

   // Exibe a mensagem de sucesso junto com a versão detectada
   MDT( "Conectado com Sucesso!#Versao: " + AllTrim( cVersionInfo ) )
   
   oServer:Destroy()
ELSE
   MDT( "Falha ao obter informacoes do servidor." )
ENDIF

RETURN .T.

// +--------------------------------------------------------------------
// +    Function GetTablesFB( oServer )
// +--------------------------------------------------------------------
FUNCTION GetTablesFB( oServer )
   LOCAL oQuery
   LOCAL aTables := {}
   LOCAL cSQL := "SELECT CAST(RDB$RELATION_NAME AS VARCHAR(31)) AS TABLE_NAME " + ;
                 "FROM RDB$RELATIONS " + ;
                 "WHERE COALESCE(RDB$SYSTEM_FLAG, 0) = 0 " + ;
                 "AND RDB$VIEW_BLR IS NULL " + ;
                 "ORDER BY RDB$RELATION_NAME"

   oQuery := oServer:Query( cSQL )
   
   IF oQuery != NIL
      WHILE !oQuery:Eof()
         oRow := oQuery:GetRow()
         // Adiciona o nome da tabela à matriz
         eVALOR:=ALLTRIM(oRow:FieldGet( 1 ))
         AAdd( aTables,eVALOR  )// oQuery:FieldGet( 1 ) )
         oQuery:Skip()
      ENDDO
      oQuery:Destroy()
   ENDIF

RETURN aTables

// +--------------------------------------------------------------------
// +    Function fireTABELAS()
// +--------------------------------------------------------------------
FUNCTION fireTABELAS()
mdbtabela( cDATABASEX )
RETURN .T.


FUNCTION fireTABELASTESTE( lNATIVE )
   LOCAL oServer, aTABELAS := {}

   IF VALTYPE( lNATIVE ) <> "L"
      lNATIVE := .T.
   ENDIF

   IF lNATIVE
      oServer := fireconnect()
      IF oServer != NIL
         // Substituindo o oServer:ListTables() pela nossa nova função
         aTABELAS := GetTablesFB( oServer )
         
         IF !Empty( aTABELAS )
            mdbtabela( aTABELAS ) // Passa a matriz populada para sua rotina de interface
         ELSE
            MDT( "Nenhuma tabela encontrada." )
         ENDIF
         
         oServer:Destroy()
      ENDIF
   ELSE
      mdbtabela( cDATABASEX )
   ENDIF
   
RETURN .T.

// +--------------------------------------------------------------------
// +    Function fireimpdbf()
// +--------------------------------------------------------------------
FUNCTION fireimpdbf()
LOCAL oServer
LOCAL aINDICES := {}
LOCAL nINDICES, cINDEXNAME, cINDEXUSO, msql, cTABLE
LOCAL i,j, nCont

cTABLE := Space( 30 )
mdt( "Escolha o DBF de Origem" )
tipodbfesc()
nORITIPO   := TIPODBF
cORIDRIVER := RDDNOME( TIPODBF )
cARQORI    := win_GetOpenFileName(, "Arquivos de Origem", hb_cwd(), "Arquivos de Origem", "*."+TABLEEXT, 1 )

IF Empty( cARQORI )
   RETURN .F.
ENDIF

hb_FNameSplit( cARQORI, nil, @cTable, NIL )
cTABLE := AllTrim( cTABLE )

dbUseArea( .T., cORIDRIVER, cARQORI, cTABLE, .T., .T. )
aSTRU    := dbStruct()
nLASTREC := RecCount()
zei_fort( nLASTREC,,, 0 )


 aINDICESx:=GeraINDICES()
    nIndexes := LEN(aINDICESx)
    FOR j := 1 TO nIndexes
        msql := aINDICESx[J,1]  //Create index
        AAdd( Aindices, msql )
    NEXT j



// Conecta nativamente via classe TFBServer
oServer := fireconnect()
IF oServer == NIL
   dbCloseArea()
   RETURN .F.
ENDIF


//cria as metadados
aRETUMETA:=GeraSQLMetadata()
  cSqlFields  :=aRETUMETA[1] 
  cSqlIndexes := aRETUMETA[2]
  
  IF ! Empty( cSqlFields )
     oServer:Execute(cSqlFields )
     mSQL="GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE  ON table_metadata TO  SYSDBA WITH GRANT OPTION GRANTED BY SYSDBA;"
     oServer:Execute( msql )
  ENDIF   

  IF ! Empty( cSqlIndexes )
     oServer:Execute(ccSqlIndexes )
     mSQL="GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE  ON index_metadata TO  SYSDBA WITH GRANT OPTION GRANTED BY SYSDBA;"
     oServer:Execute( msql )
  ENDIF 


// Limpar metadados antigos desta tabela específica 
oServer:Execute( "DELETE FROM table_metadata WHERE nome_tabela = " + c2sql(cTable) )
   
// LIMPA todos os metadados de índices desta tabela 
oServer:Execute( "DELETE FROM index_metadata WHERE nome_tabela = " + c2sql(cTable) )

 //Grava metadata do dbf
  aMETADBF:=GeradbfSchema( cTABLE, aStru )
   FOR j := 1 TO LEN(aMETADBF)
       mSQL:=aMETADBF[J]
       oServer:Execute( msql )
   NEXT J



// Se a tabela já existir, dropa para evitar conflitos de reimportação
IF oServer:TableExists( cTABLE )
   oServer:Execute( "DROP TABLE " + cTABLE )
ENDIF



// Gera a estrutura DDL adaptada para o Firebird usando seu tradutor existente
msql := SqliteCreateTable( cTABLE, aSTRU, "FIREBIRD" )
oServer:Execute( msql )


mSQL="GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE  ON "+cTABLE+" TO  SYSDBA WITH GRANT OPTION GRANTED BY SYSDBA;"
oServer:Execute( msql )
 

// Criação dos índices coletados
FOR i := 1 TO Len( aINDICES )
   oServer:Execute( aINDICES[i,1] )  //create index
   oServer:Execute( aINDICES[i,2] )  //metadado
NEXT i


nCont := 0
oServer:StartTransaction()

dbSelectArea( cTABLE )
dbGoTop()

WHILE !Eof()
   zei_fort( nLASTREC,,, 1 )
   
   msql := "INSERT INTO " + cTABLE + " VALUES ("
   FOR i := 1 TO Len( aSTRU )
      IF i > 1
         msql += ", "
      ENDIF
      msql += c2sql( & ( aSTRU[i, DBS_NAME] ) )
   NEXT i
   msql += ")"
   
   oServer:Execute( msql )
   
   nCont++
   // Bloco de Commit térmico para otimizar transações em lote (Bulk Insert)
   IF nCont % 500 == 0
      oServer:Commit()
      oServer:StartTransaction()
   ENDIF
   
   dbSkip()
ENDDO

oServer:Commit()
dbCloseArea()
oServer:Destroy()

MDT( "Importacao concluida com sucesso!" )
RETURN .T.


// +--------------------------------------------------------------------
// +    Function fireexpdbf()
// +--------------------------------------------------------------------
// Passa nTipo = 1 para criar DBF físico ou 2 para exportação baseada em memória/formatos
FUNCTION fireexpdbf( nTipo )
LOCAL oServer, oQuery
LOCAL aSTRU := {}
LOCAL aVALOR
LOCAL i, nFIM, cFieldName, cFieldType, nFieldLength, nFieldDec, cDESTINO, eVALOR


oServer := fireconnect()
IF oServer == NIL
   RETURN .F.
ENDIF

fireTABELAS() 


oQuery := oServer:Query( "SELECT * FROM " + AllTrim(cTABELAX) )
IF oServer:NetErr()
   Alert( "Erro ao ler tabela: " + oServer:Error() )
   oServer:Destroy()
   RETURN .F.
ENDIF

nLASTREC := oQuery:LastRec()
zei_fort( nLASTREC,,, 0 )

// Obtém metadados da tabela do Firebird e converte em dbStruct compatível
//aStructInfo := oQuery:GetStruct() //voltando matriz vazia
aStructInfo := MDBTABLES(cDATABASEX,cTABELAX)

nFIM        := Len( aStructInfo )

FOR i := 1 TO nFIM
   cFieldName   := aStructInfo[i, 1] // Nome do campo
   cFieldType   := aStructInfo[i, 2] // Tipo ("C", "N", "D", "L", "M")
   nFieldLength := aStructInfo[i, 3] // Tamanho
   nFieldDec    := aStructInfo[i, 4] // Decimais
   
   AAdd( aSTRU, geracampodbf( cFieldName, cFieldType, nFieldLength, nFieldDec ) )
NEXT i


cDESTINO := AllTrim(cTABELAX) + "_FIREBIRD"

IF nTipo == 1
   MDT( cDESTINO )
   dbCreate( cDESTINO, aSTRU, "DBFCDX" )
   dbUseArea( .T., "DBFCDX", cDESTINO, "DESTINO", .T., .F. )
ELSE
   dbCreate( "mem:destino", aSTRU,, .T., "DESTINO" )
ENDIF

oQuery:GoTop()
DO WHILE !oQuery:Eof()
   aVALOR := {}
   
   oRow := oQuery:GetRow()
   FOR i := 1 TO nFIM
      AAdd( aVALOR,oRow:FieldGet( i )) //oQuery:FieldGet( i ) )
   NEXT i
   
   dbSelectArea( "DESTINO" )
   NETRECAPP()
   
   FOR i := 1 TO nFIM
      eVALOR := aVALOR[i]
      
      // CORREÇÃO: Tratamento preventivo de valores Nulos (NULL) vindos do Firebird
    IF eVALOR == NIL
      IF aSTRU[i, DBS_TYPE] == "C"
         eVALOR := Space( aSTRU[i, DBS_LEN] )
      ELSEIF aSTRU[i, DBS_TYPE] == "N"
         eVALOR := 0
      ELSEIF aSTRU[i, DBS_TYPE] == "D"
         eVALOR := CToD("")
      ELSEIF aSTRU[i, DBS_TYPE] == "L"
         eVALOR := .F.
      ELSEIF aSTRU[i, DBS_TYPE] == "M"
         eVALOR := ""
      ENDIF
   ENDIF
   
   IF hb_UTF8Len(eVALOR) != Len(eVALOR)
      eVALOR := hb_UTF8ToStr(eVALOR)  //hb_StrToUTF8(cString)
   ENDIF   
      
      // Limpeza de strings e caracteres de controle oriundos do banco
      IF ValType( eVALOR ) == "C" .OR. ValType( eVALOR ) == "M"
         eVALOR := FixSRTExtendido( eVALOR , .T. , .T. , .T. , .T. , .T. )
            //FixSRTExtendido( cVALOR,lLOW,lUP,lACE,lUTF, lESP )
      ENDIF
      
      IF !Empty( eVALOR )
         FieldPut( i, eVALOR )
      ENDIF
   NEXT i
   
   zei_fort( nLASTREC,,, 1 )
   oQuery:Skip()
ENDDO

oQuery:Destroy()
oServer:Destroy()

IF nTipo == 2
   cDESTINO := AllTrim(cTABELAX) + "_FIREBIRD" + zEXPOREXT
   MDT( cDESTINO )
   dbSelectArea( "DESTINO" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   multidocg( lDOCCAB, lDOCDAD, lDOCRECNO, cSUBTIPO, TIRAEXT( cDESTINO ), aSTRU )
ENDIF

dbSelectArea( "DESTINO" )
dbCloseArea()

IF nTipo == 2
   dbDrop( "mem:destino" )
ENDIF

RETURN .T.


// +--------------------------------------------------------------------
// +    Function firedeltable()
// +--------------------------------------------------------------------
FUNCTION firedeltable()
LOCAL oServer
LOCAL X
LOCAL aTABLES
oServer := fireconnect()
IF oServer == NIL
   RETURN .F.
ENDIF

fireTABELAS() 
IF !MDG( "Apagar Tabela " + AllTrim(cTABELAX) + "?" )
   RETURN .F.
ENDIF

IF oServer:TableExists( AllTrim(cTABELAX) )
   oServer:Execute( "DROP TABLE " + AllTrim(cTABELAX) )
   MDT( "Tabela eliminada com sucesso." )
ELSE
   Alert( "Tabela nao encontrada no banco de dados." )
ENDIF

oServer:Destroy()
RETURN .T.


 *+--------------------------------------------------------------------
*+
*+    Function fireExecArqSql()
*+
*+--------------------------------------------------------------------
*+
function fireExecArqSql()

LOCAL cCOMANDO := ""
LOCAL cARQIMP  := ""

cARQIMP := win_GetOPENFileName(,"Arquivos SQL",HB_CWD(),"Arquivos SQL","*.SQL",1)
//cARQORI := OPENTIPOARQ()

IF FILE(cARQIMP)
   //nao pode ser linha a linha pois um comando pode estar em mais de uma linha
   cCOMANDO:=MEMOREAD(cARQIMP)
   oServer := fireconnect()
   fireexecuteSQL(cCOMANDO)
   oServer:Destroy()
endif


 *+--------------------------------------------------------------------
*+
*+    Function fireExecuteSql()
*+
*+--------------------------------------------------------------------
*+

FUNCTION fireexecuteSQL( eCOMANDO, lTRANS, lMES )

   LOCAL aCOMANDOS := {}
   LOCAL nFIM
   LOCAL i
   LOCAL lRet
   LOCAL oServer


   lRET := .T.
   IF ValType( LMES ) <> "L"
      lMES := .F.
   ENDIF
   IF ValType( lTRANS ) <> "L"
      lTRANS := .F.
   ENDIF
   
   IF ValType( eCOMANDO ) = "C"
      AAdd( aCOMANDOS, eCOMANDO )
   ELSE
      aCOMANDOS := eCOMANDO
   ENDIF
   nFIM := Len( aCOMANDOS )
   oServer := fireconnect()
   IF oServer == NIL
      RETURN .F.
   ENDIF
   IF lTRANS
      oServer:StartTransaction()
   ENDIF
   FOR i := 1 TO nfim
      cCOMANDO := aCOMANDOS[ I ]
      oServer:Execute( cCOMANDO )
   NEXT i
   IF lTRANS
      oServer:Commit()
   ENDIF
   oServer:Destroy()
   RETURN lRet


