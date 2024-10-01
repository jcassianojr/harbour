#require "hbpgsql"

#include "dbstruct.ch"
#include "box.ch"
#INCLUDE "DBINFO.CH"
#INCLUDE "hbVER.CH"



function pgsqlmenu()
 PRIV oServer, oQuery, oRow
 aAMBIENTE:=SALVAA()
 cTIPOSQL="PGSQL"
 cSERVERX:="localhost"+space(21)
 cUSERX:=PADR("postgres",30," ")
 cDATABASEX:=space(30)
 cPASSX    :=SPACE(30)
 cTABELAX  :=SPACE(30)
 
 loledb:=hb_Version( HB_VERSION_BITWIDTH )<>64 //mdg("User sim=odbc 8.0(32b) nao=odbc 9.0(64b)") 
 
 OPENTIPOARQ()
 
 //usar mdbdatabases fde mdb2dbf a classe precisa do database para iniciar tambem nao possuio methodo dblist como a do mysql
 mdbdatabases()
 
if empty(cDATABASEX) 
   @ 24,00 SAY "database"
   @ 24,20 GET cDATABASEX
   READ
   @ 24,00 say space(80)
   cDATABASEX:=alltrim(cDATABASEX)
endif    
  
 cPathx := "public"
 pgsetdatabase(.f.)
 

WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    @ 03,24 SAY cDATABASEX
    OPCAO(  4, 24, "&Criar database            ", 67 ) //C
    OPCAO(  5, 24, "&Database Selecionar       ", 68 ) //D
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 
    OPCAO(  7, 24, "&Tabelas                   ", 84 ) //T
    OPCAO(  8, 24, "&Exportar                  ", 69 ) //E
    OPCAO(  9, 24, "&Apagar Tabelas            ", 65 ) //A 
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
            PGsqlnewdatabase()
       CASE KEY=2
            mdbdatabases()
            pgsetdatabase(.T.)
       CASE KEY=3
           dbf2Pgsql()
       CASE KEY=4
            PGSELECTTABLE()
       CASE KEY=5
            PGstrutodbf()
       CASE KEY=6
            PGDELTABLE()     
       OTHERWISE
            RETURN
    ENDCASE
ENDDO



oserver:destroy() 
RESTAA(aAMBIENTE)
layout()
return .t.


FUNCTION PGDELTABLE()
PGSELECTTABLE()
IF hb_AScan( oServer:ListTables(), cTABELAX,,, .T. ) > 0
    IF MDG("Apagar "+cTABELAX+" apagara todas informacoes")
      oServer:DeleteTable( cTABELAX )
      IF oServer:NetErr()
         MDT( oServer:ErrorMSG())
         RETURN .F.
      ENDIF
    ELSE
      RETURN .F.  
    ENDIF
ENDIF
RETURN .T.      

FUNCTION PGSELECTTABLE()
aResult:=oServer:ListTables()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cTABELAX:=IIF( nChoices > 0, aResult[ nChoices ], "")
RETURN aResult

function pgsetdatabase(ldestroy)
if lDESTROY
 oserver:destroy()
ENDIF 
oServer := TPQServer():New( cserverx, cDatabasex, cUserx, cPassx, , cPathx )  
IF oServer:NetErr()
   Alert( oServer:ErrorMSG() )
   return .f.
ENDIF
return .t.
          

function PGsqlnewdatabase()
cNEwDATABASEX:=SPACE(40)
    @ 24,00 SAY "Novo database"
    @ 24,20 GET cnewDATABASEX
    READ
    @ 24,00 say space(80)
    cnewDATABASEX:=alltrim(cnewDATABASEX)
    IF .NOT. EMPTy(cnewDATABASEX)
       IF hb_AScan( Oserver:ListDBs(), cnewDATABASEX,,, .T. ) > 0
          MDT("Ja existe Database "+cnewDATABASEX)
          return .f.
       ELSE
          oSERVER:EXECUTE("CREATE DATABASE IF NOT EXISTS "+Cnewdatabasex)
          IF oServer:NetErr()
             Alert( oServer:ErrorMSG() )
            return .f.
          ENDIF
          cDATABASEX:=cNEWDATABASEx
          pgsetdatabase(.T.)
       ENDIF
    ENDIF  
return .t.

function PGstrutodbf()
local aRETU
local i
local nFIM
local eVALOR
aRETU:={}
PGSELECTTABLE()

  cCOMANDO ="SELECT   column_name,  udt_name,   character_maximum_length,   numeric_precision,  numeric_scale ,  data_type "
           cCOMANDO +=" FROM   information_schema.columns "
           cCOMANDO +=" WHERE   table_name = '"+cTABELAX+"' ORDER BY ordinal_position ;" 

oQuery := oServer:Query( cCOMANDO )
while .not. oQuery:eof()
   cFieldName := ''
   cFieldType := ''
   nFieldLength := 0
   nFieldDec := 0
   oRow := oQuery:GetRow()
   
    //tmsql comeca com 1 padrao harbour
    cFieldName := upper(alltrim( oRow:FieldGet(1) ) ) //column_name 0
    cType      := upper( alltrim( oRow:FieldGet(2) )  ) // data_type1 
    nFieldLength = fixnum(oRow:FieldGet(3) )  //tamanho string character_maximum_length 2
    if fixnum(oRow:FieldGet(4) ) >0//tamannho numeric 3
        nFieldLength = fixnum(oRow:FieldGet(4) )  //numeric_precision 3
        nFieldDec    = fixnum(oRow:FieldGet(5) )  //numeric_scale 4
    endif
    
    AADD(aRETU,geracampodbf(cFieldName,cFieldType,nFieldLength,nFieldDec))
   
   oQuery:skip()
enddo   
IF LEN(aRETU)=0
   mdt("estrutura em branco")
   return .f.
endif

DBCreate(ctabelaX+"_pgsql", aRETU) 
DBUseArea( .T. ,  , ctabelaX+"_pgsql", , .F. , .F. ) 


oQuery2  := oServer:Query( "SELECT * FROM "+chr(34)+cTABELAx+chr(34))  //aspas duplas tenta maiscula
IF oServer:NetErr()
    MDT( oServer:ErrorMSG())
    RETURN .F.
ENDIF


nFIM     := oQuery2:FCOUNT()
nLASTREC := oQuery2:LastRec()
zei_fort( nLASTREC,,,0)

while .not. oQuery2:eof()
   oRow := oQuery2:GetRow()
   netrecapp()
   FOR I = 1 TO nFIM
       eVALOR:=oRow:FieldGet(I)
       //datetime em modo texto
       if valtype(eVALOR)="C" .AND. SUBSTR(eVALOR,5,1)="-" .AND. SUBSTR(eVALOR,8,1)="-"
          eVALOR = substr(eVALOR, 6, 2) + "/" + substr(eVALOR, 9, 2) + "/" + substr(eVALOR, 1, 4)
          eVALOR = CTOD(eVALOR)
       ENDIF
        
        if valtype(eVALOR)="C"  .OR. valtype(eVALOR)="M"
           eVALOR:=RANGEREPL(chr(0),chr(31),eVALOR," ") //Remove caracteres de controle
           eVALOR:=TIRACE(eVALOR)
        ENDIF 
          
      if .not. empty(evalor)
        fieldput(i,eVALOR) 
      endif 
   NEXT I
   zei_fort(nLASTREC,,,1)
   oQuery2:skip()
enddo

dbcloseall()
return .T.

function dbf2pgsql()
cTABLE:=SPACE(30)
nOLDTIPO:=TIPODBF
mdt("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
IF FILE (cARQORI)
   hb_FNameSplit(cARQORI ,nil,@cTable, NIL )
   cTABLE:=ALLTRIM(cTABLE) //postgresql maiscula upper testar depois cnecar classe se fixa para minusculas 
   dbUseArea( .T.,, cARQORI, "dbffile",, .T. )
   aDbfStruct := dbffile->( dbStruct() )
   nLASTREC:=   reccount() 
   zei_fort( nLASTREC,,,0)
  // for j=1 to len(aDbfStruct)
  //    aDbfStruct[j,1]=upper(aDbfStruct[j,1])  //postgresql maiscula upper testar depois cnecar classe se fixa para minusculas 
  // next j

      IF hb_AScan( oServer:ListTables(), cTable,,, .T. ) > 0
         IF MDG("Criar novamente "+cTABLE+" apagara todas informacoes")
           oServer:DeleteTable( cTable )
           IF oServer:NetErr()
              MDT( oServer:ErrorMSG())
              RETURN .F.
           ENDIF
         ELSE
            RETURN .F.  
         ENDIF   
      ENDIF
      oServer:CreateTable( cTable, aDbfStruct )
      IF oServer:NetErr()
         MDT(oServer:ErrorMSG())
         dbcloseall()
         return .f.
      ENDIF


     nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
     FOR j = 1 TO  nIndexes
         cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
         cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
         cCHAVES :=MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j ))
         msql:="create index " + cINDEXNAME + " on " + ctable + " ( "+MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j )) + " ) "
         oSERVER:execute( msql )
     NEXT j

   // Initialize pgSQL table necessario para getblankrow ter um registro para montar a strutura
   oTable := oServer:Query( "SELECT * FROM "+chr(34) + lower(cTable) + chr(34) +" LIMIT 1" ) //dupla aspas tenta minuscula
   IF oTable:NetErr()
      Alert( oTable:ErrorMSG() )
      oTable := oServer:Query( "SELECT * FROM "+chr(34) + upper(cTable) + chr(34) +" LIMIT 1" ) //dupla aspas maiscula
      IF oTable:NetErr()
         Alert( oTable:ErrorMSG() )
         RETURN .F.
      ENDIF
   ENDIF

   DO WHILE ! dbffile->( Eof() ) 

      oRecord := oTable:GetBlankRow()

      FOR i := 1 TO dbffile->( FCount() )
         oRecord:FieldPut( i, dbffile->( FieldGet( i ) ) )
      NEXT

      oTable:Append( oRecord )
      IF oTable:NetErr()
         mdt( oTable:ErrorMSG() )
      ENDIF

      dbffile->( dbSkip() )

      zei_fort(nLASTREC,,,1)
   ENDDO

   dbffile->( dbCloseArea() )


   oTable:Destroy()
   RDDNOME(nOLDTIPO) //retorna tipo anterior
ENDIF   
return .t.


