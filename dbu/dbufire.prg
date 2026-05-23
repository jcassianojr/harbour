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

cTIPOSQL := "FIREBIRD"  // Passa para privada usadas nas funcoes abaixo 

aAMBIENTE  := SALVAA() 
cSERVERX   := SPACE(30) 
cDATABASEX := Space(30) 
cUSERX     := Space(30) 
cPASSX     := Space(30) 
cTABELAX   := Space(30) 
cBANCOX    := Space(30) 
cPATH      := "" 
loledb     := .T. 
lMDB       := .F. 
lACCDB     := .F. 

cOLDRDD     := RDDSETDEFAULT("") 
nOLDTIPORDD := TIPODBF 

// Busca as credenciais e o caminho do banco dinamicamente via cofre do sistema
pegcfgbanco() 

// Seleção do arquivo físico .fdb se aplicável à rotina local
OPENTIPOARQ()

WHILE .T.
   hb_DispBox(3,22,22,55,B_DOUBLE+" ") 
   @ 03,24 SAY "FIREBIRD"+" "+ALLTRIM(cSERVERX) 
   
   OPCAO(4,24,"&Versao Info               ",86)   // V [cite: 5]
   OPCAO(5,24,"&Tabelas                   ",84)   // T [cite: 5]
   OPCAO(6,24,"&Importar  DBF             ",73)   // I [cite: 5]
   OPCAO(7,24,"&Exportar  DBF             ",69)   // E [cite: 5, 6]
   OPCAO(8,24,"&Apagar Tabela             ",65)   // A 
   OPCAO(9,24,"Exportar &Formatos         ",70)   // F 
   OPCAO(10,24,"Trocar &Usuario/Senha     ",85)
   
   KEY := menu(1,0) 
   DO CASE
   CASE KEY = 1
      fireverinfo()
   CASE KEY = 2
      mdbtabela( cDATABASEX )
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
cARQORI    := win_GetOpenFileName(, "Arquivos de Origem", hb_cwd(), "Arquivos de Origem", "*.dbf", 1 )

IF Empty( cARQORI )
   RETURN .F.
ENDIF

hb_FNameSplit( cARQORI, nil, @cTable, NIL )
cTABLE := AllTrim( cTABLE )

dbUseArea( .T., cORIDRIVER, cARQORI, cTABLE, .T., .T. )
aSTRU    := dbStruct()
nLASTREC := RecCount()
zei_fort( nLASTREC,,, 0 )

// Mapeia índices existentes para recriá-los no Firebird
nIndexes := dbOrderInfo( DBOI_ORDERCOUNT )
FOR i := 1 TO nIndexes
   cINDEXNAME := dbOrderInfo( DBOI_NAME,, i )
   cINDEXNAME := StrTran( cINDEXNAME, "-", "_" )
   cINDEXUSO  := MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION,, i ) )
   msql       := "CREATE INDEX " + cINDEXNAME + " ON " + cTABLE + " ( " + cINDEXUSO + " )"
   AAdd( aINDICES, msql )
NEXT i

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

mdbtabela( cDATABASEX )

oServer := fireconnect()
IF oServer == NIL
   RETURN .F.
ENDIF

oQuery := oServer:Query( "SELECT * FROM " + AllTrim(cTABELAX) )
IF oServer:NetErr()
   Alert( "Erro ao ler tabela: " + oServer:Error() )
   oServer:Destroy()
   RETURN .F.
ENDIF

nLASTREC := oQuery:LastRec()
zei_fort( nLASTREC,,, 0 )

// Obtém metadados da tabela do Firebird e converte em dbStruct compatível
aStructInfo := oQuery:GetStruct()
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

mdbtabela( cDATABASEX )
IF !MDG( "Apagar Tabela " + AllTrim(cTABELAX) + "?" )
   RETURN .F.
ENDIF

oServer := fireconnect()
IF oServer == NIL
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