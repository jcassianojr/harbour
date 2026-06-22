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

 /*
  oServer := TFBServer():New( cServer + cDatabase, cUser, cPass, nDialect )
  oServer:NetErr() ? oServer:Error()
  oServer:ListTables()
  oServer:TableExists( "TEST" )
  oServer:Execute( "DROP TABLE Test" )
  oServer:StartTransaction()
  oServer:Commit()
  oServer:Query( "SELECT code, dept, name, sales, salary, creation FROM test" )
   aStruct := oServer:TableStruct( "test" )
   aKey := oQuery:GetKeyField()
  ? "Fields: ", oQuery:FCount(), "Primary Key: ", aKey[ 1 ]
   oRow := oQuery:Blank()

   ? ;
      oRow:FCount(), ;
      oRow:FieldPos( "code" ), ;
      oRow:FieldGet( 1 ), ;
      oRow:FieldName( 1 ), ;
      oRow:FieldType( 1 ), ;
      oRow:FieldDec( 1 ), ;
      oRow:FieldLen( 1 ), ;
      Len( oRow:Getkeyfield() )

   oRow:FieldPut( 1, 150 )
   oRow:FieldPut( 2, "MY TEST" )

   ? oRow:FieldGet( 1 ), oRow:FieldGet( 2 )

   ? oServer:Append( oRow )

   ? oServer:Delete( oQuery:blank(), "code = 200" )

   DO WHILE oQuery:Fetch()
      oRow := oQuery:getrow()
     oRow:FieldGet( oRow:FieldPos( "code" ) ), ;
    oQuery:Skip()

 
   oQuery:Destroy()

   oServer:Destroy()


*/

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
cCharSet := "ASCII"
nDialect := 1


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
   
   OPCAO(4,24,"&Criar Database            ",67)   // c 
   OPCAO(5,24,"&Tabelas                   ",84)   // T 
   OPCAO(6,24,"&Importar  DBF             ",73)   // I 
   OPCAO(7,24,"&Exportar  DBF             ",69)   // E 
   OPCAO(8,24,"&Apagar Tabela             ",65)   // A 
   OPCAO(9,24,"Exportar &Formatos         ",70)   // F 
   OPCAO(10,24,"Trocar &Usuario/Senha     ",85)
   OPCAO(11,24,"&Versao Info               ",86)   // V 
   
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
       trocasenhaarq()   
   CASE KEY = 8
      fireverinfo()
       
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

function firecreate()
    cARQORI := win_GetsaveFileName(,"Firebase Files",HB_CWD(),"Firebase",;
        {{'Firebird gdb','*.gdb'},{'Firebird fdb','*.fDB'},;
         {'All Files','*.*'}},1)  
   cDATABASEX := cARQORI
   cBANCOX:=hb_FNameSplit(cARQORI,NIL,cBANCOX,NIL)

    FBCreateDB( AllTrim(cSERVERX) + ":" + AllTrim(cARQORI), cUSERX, cPASSX, nPageSize, cCharSet, nDialect )
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
// +    Function fireTABELAS()
// +--------------------------------------------------------------------
FUNCTION fireTABELAS(lNATIVE)
LOCAL oServer

IF VALTYPE(lNATIVE)<>"L" //testar a native nao esta trazendo a array
   lNATIVE:=.F.
ENDIF

IF lNATIVE
    oServer := fireconnect()
    IF oServer != NIL
       mdbtabela(oServer:ListTables())  
       oServer:Destroy()
    ELSE
       MDT( "Falha ao obter informacoes do servidor." )
    ENDIF
ELSE
   mdbtabela( cDATABASEX ) //via ado 
ENDIF
RETURN .T.


// +--------------------------------------------------------------------
// +    Function fireimpdbf()
// +--------------------------------------------------------------------
FUNCTION fireimpdbf()
LOCAL oServer
LOCAL aINDICES := {}
LOCAL nINDICES, cINDEXNAME, cINDEXUSO, msql, cTABLE
LOCAL i, nCont

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

// Se a tabela já existir, dropa para evitar conflitos de reimportação
IF oServer:TableExists( cTABLE )
   oServer:Execute( "DROP TABLE " + cTABLE )
ENDIF

// Gera a estrutura DDL adaptada para o Firebird usando seu tradutor existente
msql := SqliteCreateTable( cTABLE, aSTRU, "FIREBIRD" )
oServer:Execute( msql )

// Criação dos índices coletados
FOR i := 1 TO Len( aINDICES )
   oServer:Execute( aINDICES[i] )
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
   
   FOR i := 1 TO nFIM
      AAdd( aVALOR, oQuery:FieldGet( i ) )
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
      
      // Limpeza de strings e caracteres de controle oriundos do banco
      IF ValType( eVALOR ) == "C" .OR. ValType( eVALOR ) == "M"
         eVALOR := RANGEREPL( Chr( 0 ), Chr( 31 ), eVALOR, " " )
         eVALOR := TIRACE( eVALOR )
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