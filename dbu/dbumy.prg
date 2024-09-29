#require "hbmysql"

#include "dbstruct.ch"
#include "box.ch"
#INCLUDE "DBINFO.CH"


function mysqlmenu()
 PRIV oServer, oQuery, oRow
 aAMBIENTE:=SALVAA()
 cTIPOSQL="MYSQL"
 cSERVERX:="localhost"+space(21)
 cUSERX:=PADR("root",30," ")
 cDATABASEX:=space(30)
 cPASSX    :=SPACE(30)
 cTABELAX  :=SPACE(30)
 OPENTIPOARQ()
 
 oServer := TMySQLServer():New( cSERVERX, cUSERX, cPASSX) //
   IF oServer:NetErr()
      Alert( oServer:Error() )
      return .f.
   ENDIF

MYSELECTDB()


WHILE .T.
    HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
    @ 03,24 SAY cDATABASEX
    OPCAO(  4, 24, "&Criar database            ", 67 ) //C
    OPCAO(  5, 24, "&Database Selecionar       ", 68 ) //D
    OPCAO(  6, 24, "&Importar  DBF             ", 73 ) //I 
    OPCAO(  7, 24, "&Tabelas                   ", 84 ) //T
    OPCAO(  8, 24, "                           ", 83 ) //S
    KEY := menu( 1, 0 )
    DO CASE
       CASE KEY=1
            mysqlnewdatabase()
       CASE KEY=2
            MYSELECTDB()
       CASE KEY=3
           dbf2mysql()
       CASE KEY=4
            MYSELECTTABLE()
       CASE KEY=5
            mdt("nao disponivel")
       OTHERWISE
            RETURN
    ENDCASE
ENDDO



oserver:destroy() 
RESTAA(aAMBIENTE)
layout()
return .t.

FUNCTION MYSELECTDB()
aResult:=Oserver:ListDBs()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cDATABASEX:=IIF( nChoices > 0, aResult[ nChoices ], "")
Oserver:SelectDB( cDATABASEX )
IF oServer:NetErr()
    Alert( oServer:Error() )
    return .f.
ENDIF
RETURN .T.


FUNCTION MYSELECTTABLE()
aResult:=oServer:ListTables()
IF LEN(aResult)>0
   HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
  nChoices := ACHOICE( 4,23,21,54, aResult)
ENDIF   
cTABELAX:=IIF( nChoices > 0, aResult[ nChoices ], "")
RETURN .T.

function mysqlnewdatabase()
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
          oSERVER:CREATEDATABASE(cNEWDATABASEx)
          IF oServer:NetErr()
             Alert( oServer:Error() )
            return .f.
          ENDIF
          Oserver:SelectDB( cNEWDATABASEx )
          IF oServer:NetErr()
             Alert( oServer:Error() )
            return .f.
          ENDIF
          cDATABASEX:=cNEWDATABASEx
       ENDIF
    ENDIF  
return .t.


function dbf2mysql()
cTABLE:=SPACE(30)
nOLDTIPO:=TIPODBF
mdt("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )
IF FILE (cARQORI)
   hb_FNameSplit(cARQORI ,nil,@cTable, NIL )
   cTABLE:=ALLTRIM(cTABLE)
   dbUseArea( .T.,, cARQORI, "dbffile",, .T. )
   aDbfStruct := dbffile->( dbStruct() )
   nLASTREC:=   reccount() 
   zei_fort( nLASTREC,,,0)

      IF hb_AScan( oServer:ListTables(), cTable,,, .T. ) > 0
         IF MDG("Criar novamente "+cTABLE+" apagara todas informacoes")
           oServer:DeleteTable( cTable )
           IF oServer:NetErr()
              MDT( oServer:Error())
              RETURN .F.
           ENDIF
         ELSE
            RETURN .F.  
         ENDIF   
      ENDIF
      oServer:CreateTable( cTable, aDbfStruct )
      IF oServer:NetErr()
         MDT(oServer:Error())
         dbcloseall()
         return .f.
      ENDIF


     nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
     FOR j = 1 TO  nIndexes
         cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
         cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
         cCHAVES :=MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j ))
         aFNAMES:= hb_atokens(cCHAVES,",")
         oSERVER:CreateIndex( cINDEXNAME, cTable, aFNames, .F. )
     NEXT j

   // Initialize MySQL table
   oTable := oServer:Query( "SELECT * FROM " + cTable + " LIMIT 1" )
   IF oTable:NetErr()
      Alert( oTable:Error() )
      return .f.
   ENDIF

   DO WHILE ! dbffile->( Eof() ) 

      oRecord := oTable:GetBlankRow()

      FOR i := 1 TO dbffile->( FCount() )
         oRecord:FieldPut( i, dbffile->( FieldGet( i ) ) )
      NEXT

      oTable:Append( oRecord )
      IF oTable:NetErr()
         mdt( oTable:Error() )
      ENDIF

      dbffile->( dbSkip() )

      zei_fort(nLASTREC,,,1)
   ENDDO

   dbffile->( dbCloseArea() )


   oTable:Destroy()
   RDDNOME(nOLDTIPO) //retorna tipo anterior
ENDIF   
return .t.


