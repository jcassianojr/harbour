// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Source Module => DBUDOC.PRG
// +
// +    Functions: Function GERADOC()
// +               Function multidocs()
// +               Function multidocg()
// +               Function FAZERDBF()
// +               Function GRAVADOC()
// +               Function TIPOC()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

#include "BOX.CH"
#include "dbinfo.ch"
#include "dbstruct.ch"

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function PEGTIPO2VAL()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
FUNCTION PEGTIPO2VAL()

   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE ! Eof()
      FOR X = 1 TO nFIELDS
         @ 3, 40 SAY PadR( aESTRU[ X ][ 1 ] )
         nVAL := FieldGet( X )
         IF aESTRU[ X ][ 2 ] = "N"
            IF nVAL > aVAL[ X ]
               aVAL[ X ] := nVAL
            ENDIF
         ENDIF
         IF aESTRU[ X ][ 2 ] = "C"
            nVAL := Len( AllTrim( nVAL ) )
            IF nVAL > aVAL[ X ]
               aVAL[ X ] := nVAL
            ENDIF
         ENDIF
      NEXT X
      ZEI_FORT( nLASTREC,,, 1 )
      dbSkip()
   ENDDO

   RETURN

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function GERADOC()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
FUNCTION GERADOC( tdoc )

   LOCAL stru_name
   LOCAL stru_base

// local aESTRU usada na pegval2 nao pode ser local
// local nFIELDS usada na pegval2 nao pode ser local
   LOCAL stru_nome
   LOCAL cTEXTO
   lDOCCAB := .F.
   lDOCDAD := .F.
   lDOCRECNO := .F.
   cSUBTIPO := " "
   IF Empty( M->cur_dbf )
      RETU .F.
   ENDIF

   IF tDOC = 0
      tdoc := pegtipodoc()
      IF tdoc = 0
         RETURN .F.
      ENDIF
      IF tDOC = 5 // parametros da exportacao
         pegparexp()
      ENDIF
   ENDIF


   stat_msg( "Lendo Estrutura do Arquivo" )
   stru_name := M->cur_dbf
   stru_base := SubStr( stru_name, 1, At( ".", stru_name ) - 1 )
   IF RAt( "\", STRU_BASE ) > 0
      STRU_BASE := SubStr( STRU_BASE, RAt( "\", STRU_BASE ) + 1 )
   ENDIF
   Select( M->cur_area )
   aESTRU := dbStruct()
   nFIELDS := Len( aESTRU )
   AVAL := Array( nFIELDS )
   AFill( aVAL, 0 )
   IF tDOC = 2 // Verificando o tamanho utilizado por cada campo
      PEGTIPO2VAL()
   ENDIF
   PegcsUB( tDOC )
   GRAVADOC( tdoc, stru_base, aESTRU, aVAL, lDOCCAB, lDOCDAD, cSUBTIPO, lDOCRECNO )
   stat_msg( "Documentacao Gerada" )



// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function PegcsUB()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
//

FUNCTION PegcsUB( tDOC )

   IF tDOC = 7
      lDOCDAD := MDG( "Gravar Dados" )
      IF MDG( "Tipo DATAPACKET(S) TIPO ISO-8859-1(N)" )
         cSUBTIPO := "PCK"
      ELSE
         cSUBTIPO := "ISO"
      ENDIF
   ENDIF
   IF  tDOC = 5 .OR.  tDOC = 6
      lDOCCAB := MDG( "Gravar Informacao Estrutura" )
      lDOCDAD := MDG( "Gravar Dados" )
      IF lDOCDAD
         lDOCRECNO := MDG( "Incluir Recno()/ID" )
      ENDIF
      IF ZEXPOREXT = "XLS" .AND. tDOC = 5
         nCHOICE := ALERTX( "Tipo XML", { "TAB", "TRH-HTML", "TDB" } )
         DO CASE
         CASE nCHOICE = 1
            cSUBTIPO := "TAB"
         CASE nCHOICE = 2
            cSUBTIPO := "TRH"
         CASE nCHOICE = 3
            cSUBTIPO := "TDB"
         ENDCASE
      ENDIF
      IF ZEXPOREXT = "SQL" .AND. tDOC = 5
         cSUBTIPO := "SQL"
      ENDIF
   ELSE
      lDOCCAB := .T.
   ENDIF
   IF  tDOC = 8
      lDOCDAD := .T.
      lDOCRECNO := .F. // A id do recno ja faz parte do json
   ENDIF


// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function multidocs()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +

FUNCTION multidocs

   PARA tDOC, cMASK           // Passara outra funcao manter aqui para ficar como priv

   IF ValType( cMASK ) # "C"
      cMASK := "*.DBF"
   ENDIF

   IF tDOC = 0
      tdoc := pegtipodoc()
      IF tdoc = 0
         RETURN .F.
      ENDIF
   ENDIF
   IF tDOC = 5 // parametros da exportacao
      pegparexp()
   ENDIF
   lDOCCAB  := .F.
   lDOCDAD  := .F.
   lDOCRECNO := .F.
   cSUBTIPO := " "
   PegcsUB( tDOC )  // pegar o subtipo conforme tipo
   IF tdoc = 1
      FAZERDBF( {|| dbf2xml() }, .F.,,, cMASK )
   ELSE
      FAZERDBF( {|| multidocg( lDOCCAB, lDOCDAD, lDOCRECNO, cSUBTIPO ) }, .F.,,, cMASK )
   ENDIF
   stat_msg( "Documentacao Gerada" )

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function multidocg()
// +
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +

FUNCTION multidocg( lDOCCAB, lDOCDAD, lDOCRECNO, cSUBTIPO, cARQDIC, aESTRU )

// Recebe aSTRU caso a base seja sql e tenha que sofrer transformacao
   IF ValType( aESTRU ) <> "A"
      aESTRU  := dbStruct()
   ENDIF
   IF ValType( cARQDIC ) <> "C" // memvar->ARQUIVO public do dbu melhorar posteriormente para sempre pegar paramentro cARQDIC
      cARQDIC := TIRAEXT( memvar->ARQUIVO )
   ENDIF
   aVAL := Array( Len( aESTRU ) )
   AFill( aVAL, 0 )
   nFIELDS := Len( aESTRU )
   IF tDOC = 2 // Verificando o tamanho utilizado por cada campo
      PEGTIPO2VAL()
   ENDIF
   altd()
   GRAVADOC( tdoc, cARQDIC, aESTRU, aVAL, lDOCCAB, lDOCDAD, cSUBTIPO, lDOCRECNO )

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function FAZERDBF()
// +
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +

FUNCTION FAZERDBF( bUSO, lSHARE, bPRE, bPOS, cMASK )

   LOCAL cCAMMASK  := Space( 100 )

   IF ValType( cMASK ) # "C"
      cMASK := "*.DBF"
   ENDIF

   IF At( "\", cMASK ) > 0  // o mascara tem caminho
      hb_FNameSplit( cMASK, @cCAMMASK, NIL, NIL )
   ENDIF
   cCAMMASK := AllTrim( cCAMMASK )

   MATDBF := FILENAMES( cMASK )
   nARQ   := Len( MATDBF )
   IF nARQ > 0
      FOR w := 1 TO nARQ
         ARQUIVO := AllTrim( MATDBF[ w ] )
         IF ValType( bPRE ) = "B"
            Eval( bPRE )
         ENDIF
         IF ValType( bUSO ) = "B"
            IF File( cCAMMASK + ARQUIVO )
               MDS( "Arquivo: " + cCAMMASK + ARQUIVO )
               DBUREDE( cCAMMASK + ARQUIVO,, lSHARE )
               nLASTREC := LastRec()
               zei_fort( nLASTREC,,, 0 )
               Eval( bUSO,, {|| zei_fort( nLASTREC,,, 1 ) } )
               dbCloseArea()
            ENDIF
         ENDIF
         IF ValType( bPOS ) = "B"
            Eval( bPOS )
         ENDIF
      NEXT w
   ENDIF
   MDS( "" )

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function GRAVADOC()
// aVAL maior dos campos usado no tipo 2 TAM
// lDOCCAB inclui cabecario
// lDOCDAD inclui dados registros
// cSUBTIPO subtipo alguns formartos
// lDOCREcno inclui uma coluna adicional com o recno()(id)
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +

FUNCTION GRAVADOC( tdoc, cARQ, aESTRU, aVAL, lDOCCAB, lDOCDAD, cSUBTIPO, lDOCRECNO )


   LOCAL cARQGRV := cARQ
   LOCAL cLIN := hb_osNewLine()
   LOCAL cVAL
   LOCAL cCAMPO
   LOCAL J, nIndexes
   LOCAL cINDEXNAME
   LOCAL cFieldName := ''
   LOCAL cFieldType := ''
   LOCAL nFieldLength := 0
   LOCAL nFieldDec := 0

   IF tDOC = 0
      tdoc := pegtipodoc()
      IF tdoc = 0
         RETURN .F.
      ENDIF
      IF tDOC = 5 // parametros da exportacao
         pegparexp()
      ENDIF
      PegcsUB( tDOC )  // pegar o subtipo conforme tipo
   ENDIF

   IF tdoc = 1
      Dbf2Xml()
      RETURN .T.
   ENDIF

   IF zEXPOREXT = "XML" .AND. tDOC = 5
      tDOC := 7
   ENDIF

   IF zEXPOREXT = "JSON"
      tDOC := 8
   ENDIF
   IF tDOC = 4 // dbe
      lDOCDAD := .F.
      lDOCRECNO := .F.
      cSUBTIPO := ""
   ENDIF


   DO CASE
      // case tDOC = 1 //acima dbf2xml
   CASE tDOC = 2
      cARQGRV += ".TAM"
   CASE tDOC = 3
      cARQGRV += ".TEC"
   CASE tDOC = 4
      cARQGRV += ".DBE"
   CASE tDOC = 5  .OR. zEXPOREXT = "SQL" .OR. zEXPOREXT = "SSV" .OR. zEXPOREXT = "CSV" ;
         .OR. zEXPOREXT = "UNL" .OR. zEXPOREXT = "TSV" .OR. zEXPOREXT = "PSV"
      cARQGRV += "." + ZEXPOREXT
   CASE tDOC = 6
      cARQGRV += ".SDF"
   CASE tDOC = 7
      cARQGRV += ".XML"
   CASE tDOC = 8
      cARQGRV += ".JSON"
   ENDCASE
   IF File( cARQGRV )
      FErase( cARQGRV )
   ENDIF

   nFIELDS := Len( aESTRU )
   cTEXTO  := ""
   IF nFIELDS = 0
      stat_msg( "Nao exitem campos na area selecionada" )
      RETURN .F.
   ENDIF
   IF tDOC = 4
      cTEXTO += 'DBFDEF ' + Upper( cARQ ) + cLIN
   ENDIF
   IF tDOC = 3 .OR. tDOC = 2
      cTEXTO += '+-----------------------------------------------------------------------------+' + cLIN
      cTEXTO += '| Arquivo          : ' + PadR( cARQ, 57 ) + '|' + cLIN
      cTEXTO += '| Atualizado em    : ' + PadR( LUpdate(), 57 ) + '|' + cLIN
      cTEXTO += '| No.de Registros  : ' + PadR( Str( LastRec(), 8, 0 ), 57 ) + '|' + cLIN
      cTEXTO += '| No.de Campos     : ' + PadR( Str( FCount(), 8, 0 ), 57 ) + '|' + cLIN
      cTEXTO += '| Tamanho Registro : ' + PadR( Str( RecSize(), 8, 0 ), 57 ) + '|' + cLIN
      cTEXTO += '|-----+------------+----------+-----+----+------------------------------------|' + cLIN
      cTEXTO += '| No. | Nome Campo | Tipo     | Com | De | Observacoes                        |' + cLIN
      cTEXTO += '|-----+------------+----------+-----+----+------------------------------------+' + cLIN
   ENDIF
   IF tDOC = 7 .AND. cSUBTIPO = "PCK"
      cTEXTO += "<?xml version=" + Chr( 34 ) + "1.0" + Chr( 34 ) + " standalone=" + Chr( 34 ) + "yes" + Chr( 34 ) + "?>" + cLIN
      cTEXTO += "<DATAPACKET Version=" + Chr( 34 ) + "2.0" + Chr( 34 ) + ">" + cLIN
      cTEXTO += "<METADATA>" + cLIN
      cTEXTO += "   <FIELDS>" + cLIN
   ENDIF
   IF tDOC = 7 .AND. cSUBTIPO = "ISO"
      cTEXTO := '<?xml version="1.0" encoding="ISO-8859-1"?>' + cLIN
      cTEXTO += "<DataRoot>" + cLIN
      cTEXTO += "<Estrutura>" + cLIN
   ENDIF
   IF tDOC = 5 .AND. cSUBTIPO = "TRH"
      cTEXTO += "<html>" + cLIN
      cTEXTO += "<body>" + cLIN
      cTEXTO += "<table border=" + Chr( 34 ) + "1" + Chr( 34 ) + ">" + cLIN
      cTEXTO += "<!-- cabecalho com os nomes dos campos da tabela -->" + cLIN
      cTEXTO += "<tr>" + cLIN
   ENDIF
   IF tDOC = 5 .AND. cSUBTIPO = "TDB"
      nHANDLEDOC := xlsOpen( cARQGRV )
   ENDIF


   IF lDOCCAB
      FOR MEMVAR->x := 1 TO nFIELDS      // aqui menvar evitar confusao dbf que tem o campo X
         cCAMPO := aESTRU[ X, 1 ]
         DO CASE
         CASE tDOC = 3  .OR. tDOC = 2
            cOBS := Space( 35 )
            IF tDOC = 2 .AND. aVAL[ X ] > 0
               cOBS := PadR( StrZero( aVAL[ X ] ), 35 )
            ENDIF
            cTEXTO += '| ' + Str( X, 3 ) + ' | ' + ;
               PadR( cCAMPO, 10 ) + ' | ' + ;
               TIPOC( aESTRU[ X, 2 ] ) + ' | ' + ;
               Str( aESTRU[ X, 3 ], 3 ) + ' | ' + ;
               Str( aESTRU[ X, 4 ], 2 ) + ' | ' + ;
               cOBS + '|' + cLIN
         CASE tDOC = 4
            cTEXTO += '   ' + PadR( cCAMPO, 10 ) + ' ' + ;
               aESTRU[ X, 2 ] + ' ' + ;
               Str( aESTRU[ X, 3 ], 3 ) + ' ' + ;
               Str( aESTRU[ X, 4 ], 2 ) + cLIN
         CASE tDOC = 5 .AND. cSUBTIPO <> "TRH" .AND. cSUBTIPO <> "TDB"  .AND. cSUBTIPO <> "SQL"
            cCAMPO := AllTrim( cCAMPO )
            cCAMPO := RANGEREPL( Chr( 0 ), Chr( 31 ), cCAMPO, " " ) // Remove caracteres de controle
            IF lDOCDAD
               cTEXTO +=  AllTrim( cCAMPO ) + ZDELIMITE // clin no final
            ELSE
               cTEXTO += PadR( cCAMPO, 10 ) + ZDELIMITE + ;
                  aESTRU[ X, 2 ] + ZDELIMITE + ;
                  Str( aESTRU[ X, 3 ], 3 ) + ZDELIMITE + ;
                  Str( aESTRU[ X, 4 ], 2 ) + cLIN
            ENDIF
         CASE tDOC = 5 .AND. cSUBTIPO = "TRH"
            cTEXTO += "<th nowrap>" + AllTrim( cCAMPO ) + "</th>" + cLIN
         CASE tDOC = 5 .AND. cSUBTIPO = "TDB"
            xlsWrite( nHANDLEDOC, 1, X, AllTrim( cCAMPO ) )
         CASE tDOC = 6
            IF lDOCDAD
               cTEXTO +=  AllTrim( cCAMPO ) + " " // + cLIN //So nome do campo
            ELSE
               cTEXTO += PadR( cCAMPO, 10 ) + ' ' + ;
                  aESTRU[ X, 2 ] + ' ' + ;
                  Str( aESTRU[ X, 3 ], 3 ) + ' ' + ;
                  Str( aESTRU[ X, 4 ], 2 ) + cLIN
            ENDIF
         CASE tDOC = 7 .AND. cSUBTIPO = "PCK"  // <FIELD attrname="Descricao" fieldtype="string" WIDTH="10"/>
            cTEXTO += "   <FIELD attrname=" + Chr( 34 ) + AllTrim( cCAMPO ) + Chr( 34 )
            cTEXTO += " fieldtype="
            cTEXTO += Chr( 34 ) + TIPOXML( aESTRU[ X, 2 ], aESTRU[ X, 3 ], aESTRU[ X, 4 ] ) + Chr( 34 )
            IF aESTRU[ X, 2 ] = "C"
               cTEXTO += " WIDTH=" + Chr( 34 ) + AllTrim( Str( aESTRU[ X, 3 ], 3 ) ) + Chr( 34 )
            ENDIF
            IF aESTRU[ X, 2 ] = "M"
               cTEXTO += " WIDTH=" + Chr( 34 ) + AllTrim( Str( 255 ) ) + Chr( 34 )
            ENDIF
            cTEXTO += "/>" + cLIN
         CASE tDOC = 7 .AND. cSUBTIPO = "ISO"
            cTEXTO += "<Campo>" + CLIN
            cTEXTO += "<Nome>"    + AllTrim( cCAMPO ) +          "</Nome>" + CLIN
            cTEXTO += "<Tipo>"    + aESTRU[ X ][ 2 ] +             "</Tipo>" + CLIN
            cTEXTO += "<Tamanho>" + LTrim( Str( aESTRU[ X ][ 3 ] ) ) + "</Tamanho>" + CLIN
            cTEXTO += "<Decimal>" + LTrim( Str( aESTRU[ X ][ 4 ] ) ) + "</Decimal>" + CLIN
            cTEXTO += "</Campo>" + CLIN
         ENDCASE
      NEXT x
      // Grava os indices
      IF tDOC = 7 .AND. cSUBTIPO = "ISO"
         nIndexes  :=  dbOrderInfo( DBOI_ORDERCOUNT )
         FOR j = 1 TO  nIndexes
            cTEXTO += "<Indice>" + cLIN
            cTEXTO += "<Chave>" + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + "</Chave>" + CLIN
            cTEXTO += "</Indice>" + cLIN
         NEXT j
      ENDIF

      altd()
      // cabecario sql  nao precisa loop nos fields
      IF (tDOC = 7 .AND. cSUBTIPO <> "ISO") .OR. (tDOC = 5 .AND. cSUBTIPO = "SQL" .AND. lDOCCAB ) //.AND. .NOT. lDOCDAD)
         aUSO := aESTRU
         IF Empty( aESTRU )
            aUSO := dbStruct()
         ENDIF
         // select case ZANOFOR="SQLITE" criar conforme o tipo sql difere datatypes
         //
         DO CASE
         CASE ZANOFOR = "SQLITE"
            cTEXTO := SqliteCreateTable( cARQ, aUSO, "SQLITE" )
         CASE  ZANOFOR = "MYSQL" .OR. ZANOFOR = "MYSQL64" .OR. ZANOFOR = "MARIADB"
            cTEXTO := SqliteCreateTable( cARQ, aUSO, "MYSQL" )
         CASE  ZANOFOR = "PGSQL" 
            cTEXTO := SqliteCreateTable( cARQ, aUSO, "PGSQL" )  
        CASE  ZANOFOR = "ORACLE" 
            cTEXTO := SqliteCreateTable( cARQ, aUSO, "ORACLE" )      
         CASE  ZANOFOR = "MDB" .OR. ZANOFOR = "ACCESS"
            cTEXTO := SqliteCreateTable( cARQ, aUSO, "MDB" )
         CASE  ZANOFOR = "MSSQL"
            cTEXTO := SqliteCreateTable( cARQ, aUSO, "MSSQL" )   
         OTHERWISE
            cTEXTO := "CREATE TABLE " + cARQ + hb_osNewLine()
            cTEXTO += " ("
            FOR K = 1 TO Len( aUSO )
               cTEXTO += AllTrim( aUSO[ K ][ DBS_NAME ] ) + " " // 1
               DO CASE
               CASE aUSO[ K ][ DBS_TYPE ] = "C"
                  IF aUSO[ K ][ DBS_LEN ] = 254
                     cTEXTO += "VARCHAR (512)"
                  ELSE
                     cTEXTO += "VARCHAR (" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) + ")"
                  ENDIF
               CASE aUSO[ K ][ DBS_TYPE ] = "D"
                  cTEXTO += "SMALLDATETIME"
               CASE aUSO[ K ][ DBS_TYPE ] = "N"
                  cTEXTO += "DECIMAL (" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) + "," + AllTrim( Str( aUSO[ K ][ DBS_DEC ] ) ) + ")"
               ENDCASE
               IF K <> Len( aUSO )
                  cTEXTO += " ," + hb_osNewLine()
               ENDIF
            NEXT K
            cTEXTO += ") ; "  + cLIN
         ENDCASE

        
         nIndexes  :=  dbOrderInfo( DBOI_ORDERCOUNT )
         cTEXTO    +=  hb_osNewLine()
         FOR j = 1 TO  nIndexes
            cINDEXNAME := dbOrderInfo( DBOI_NAME, ,  j )
            cINDEXNAME := StrTran( cINDEXNAME, "-", "_"  )  // Tracos nao aceitos trocando por undescore
            cSQLINDEX := "create index " + cINDEXNAME + " on " + cARQ + " ( " + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + " ) ;"
            cTEXTO += cSQLINDEX + hb_osNewLine()
         NEXT j
      ENDIF
   ENDIF


   IF tDOC = 5 .AND. cSUBTIPO = "TRH"
      cTEXTO += "</tr>" + cLIN
   ENDIF
   IF tDOC = 7 .AND. cSUBTIPO = "PCK"
      cTEXTO += "  </FIELDS>" + cLIN
      cTEXTO += "</METADATA>" + cLIN
      cTEXTO += "<ROWDATA>" + cLIN
   ENDIF
   IF tDOC = 7 .AND. cSUBTIPO = "ISO"
      cTEXTO += "</Estrutura>" + cLIN
      cTEXTO += "<Dados>" + cLIN
   ENDIF

   IF tDOC = 5 .AND. lDOCCAB .AND. cSUBTIPO <> "TRH" .AND. cSUBTIPO <> "TDB"
      cTEXTO += cLIN
   ENDIF
   IF tDOC = 6
      cTEXTO += cLIN
   ENDIF

   IF tDOC = 5 .AND. cSUBTIPO = "TDB" // ja aberto Acima
   ELSE
      nHANDLEDOC := FCreate( cARQGRV )
      IF Len( cTEXTO ) > 0
         FWrite( nHANDLEDOC, cTEXTO )
      ENDIF
   ENDIF

   IF tDOC = 8
      hRecords := { => }
   ENDIF

   cTEXTO := ""

   IF tDOC = 3  .OR. tDOC = 2
      cTEXTO += '+-----+------------+----------+-----+----+------------------------------------+' + cLIN
   ENDIF
   
   
   
   IF tDOC = 4 
      cTEXTO += 'ENDDEF' + cLIN
      nIndexes  :=  dbOrderInfo( DBOI_ORDERCOUNT )
      IF nIndexes > 0
         cTEXTO += 'DEFINDEX ' + Upper( cARQ ) + cLIN
         FOR j = 1 TO  nIndexes
            cTEXTO += "   "
            cTEXTO += dbOrderInfo( DBOI_NAME, ,  j )
            cTEXTO += " "
            cTEXTO += dbOrderInfo( DBOI_EXPRESSION, ,  j )
            cTEXTO += " "
            cTEXTO += MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) )
            cTEXTO += clin
         NEXT j
         cTEXTO += 'ENDINDEX' + cLIN
      ENDIF
      cTEXTO += 'ENDFILE' + cLIN
      cTEXTO +=  cLIN
      cTEXTO += "[" + Upper( AllTrim( carq ) ) + ".DBF]" + clin
      cTEXTO += "CAMINHO=" + hb_cwd() + clin
      cTEXTO += "DRIVER=" + rddName() + clin
      cTEXTO += "NUMMAINTAINED=" + Str( nIndexes, 1 ) + cLIN
      cTEXTO += "MAINTAIN0=" + cARQ + ".CDX" + cLIN
      cINDEXTEXTO := ""
      IF nIndexes > 0
         FOR j = 1 TO  nIndexes
            cTEXTO += "TAG"   + Str( j - 1, 1 ) + "=" + dbOrderInfo( DBOI_NAME, ,  j ) + clin
            cTEXTO += "INDEX" + Str( j - 1, 1 ) + "=" + dbOrderInfo( DBOI_EXPRESSION, ,  j ) + clin
            cTEXTO += "INDEXFIELDS" + Str( j - 1, 1 ) + "=" + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + clin
            cINDEXNAME := dbOrderInfo( DBOI_NAME, ,  j )
            cINDEXNAME := StrTran( cINDEXNAME, "-", "_"  )  // Tracos nao aceitos trocando por undescore
            cINDEXTEXTO += "create index " + cINDEXNAME + " on " + cARQ + " ( " + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + " ) ;" + clin
         NEXT j
      ENDIF
      cTEXTO += clin + "[SQLITE]"
      cTEXTO += clin + SqliteCreateTable( cARQ, aESTRU, "SQLITE" )
      CTEXTO += clin + cINDEXTEXTO
      cTEXTO += clin + "[MSSQL]"
      cTEXTO += clin + SqliteCreateTable( cARQ, aESTRU, "MSSQL" )
      CTEXTO += clin + cINDEXTEXTO
      cTEXTO += clin + "[MYSQL]"
      cTEXTO += clin + SqliteCreateTable( cARQ, aESTRU, "MYSQL" )
      CTEXTO += clin + cINDEXTEXTO
      cTEXTO += clin + "[POSTGRESQL]"
      cTEXTO += clin + SqliteCreateTable( cARQ, aESTRU, "POSTGRESQL" )
      CTEXTO += clin + cINDEXTEXTO
      cTEXTO += clin + "[ACCESS]"
      cTEXTO += clin + SqliteCreateTable( cARQ, aESTRU, "ACCESS" )
      CTEXTO += clin + cINDEXTEXTO
      cTEXTO += clin + "[ORACLE]"
      cTEXTO += clin + SqliteCreateTable( cARQ, aESTRU, "ORACLE" )
      CTEXTO += clin + cINDEXTEXTO
      //
      CTEXTO += GERADBML(cARQ,aESTRU)

   ENDIF

// verificas se a quantidade de registros
   nLASTREC := 0
   IF lDOCDAD
      nLASTREC := LastRec()
   ENDIF
// nao faz o loop se nao incluir dados ou nao tiver registro
// alguns rdd sem registro nao trazem o eof() corretamente gerando loop infinito
   IF lDOCDAD .AND. nLASTREC > 0
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      nXLS := 0
      cTEXTO:=""
      if zEXPOREXT = "SQL" .AND. ZANOFOR = "ORACLE"
         cTEXTO +="SET AUTOCOMMIT ON ;" + HB_OSNEWLINE()
      endif
      dbGoTop()
      WHILE ! Eof()
         IF tDOC = 5 .AND. lDOCRECNO
            cTEXTO += AllTrim( Str( RecNo() ) ) + ZDELIMITE
         ENDIF
         nXLS++
         DO CASE
         CASE tDOC = 7 .AND. cSUBTIPO = "PCK"
            cTEXTO += "<ROW RowState=" + Chr( 34 ) + "12" + Chr( 34 )
         CASE tDOC = 5 .AND. cSUBTIPO = "TRH"
            cTEXTO += "<tr>"         + cLIN
         CASE tDOC = 7 .AND. cSUBTIPO = "ISO"
            cTEXTO += "<Registro>" + cLin
         CASE zEXPOREXT = "SQL"
            cTEXTO += "insert into " + Alias() + " values ("
         ENDCASE

         IF tDOC = 8
            hRecord := { => }
            cTEXTO := ""    // zerando estava gerando acumlando os campos anteriores
         ENDIF

         FOR X = 1 TO nFIELDS
            cCAMPO := aESTRU[ X, 1 ]
            IF tDOC = 7 .AND. cSUBTIPO = "PCK"
               cTEXTO += " " + AllTrim( cCAMPO ) + "=" + Chr( 34 )
            ENDIF
            IF tDOC = 5 .AND. cSUBTIPO = "TRH"
               cTEXTO += "<td align=" + Chr( 34 ) + "right" + Chr( 34 ) + ">"
            ENDIF
            IF tDOC = 7 .AND. cSUBTIPO = "ISO"
               cTEXTO += "<" + cCAMPO + ">"
            ENDIF

            @ 3, 40 SAY AllTrim( PadR( cCAMPO ) )
            nVAL := FieldGet( X )

            cFieldName   := aESTRU[ X ][ 1 ]
            cFieldType   := aESTRU[ X ][ 2 ]
            nFieldLength := aESTRU[ X ][ 3 ]
            nFieldDec    := aESTRU[ X ][ 4 ]

            // HB_FT_CURDOUBLE       14      "Z"
            // HB_FT_CURRENCY       13      "Y"
            // moeda e moeda dupla
            IF cFieldType = "Z" .OR. cFieldType = "Y"
               cFieldType = "N"
               IF Empty( nFieldLength )
                  nFieldLength = 12
               ENDIF
               IF Empty( nFieldLength )
                  nFieldLength = 2
               ENDIF
            ENDIF

            // HB_FT_DOUBLE        7      "B"
            IF cFieldType = "B"
               cFieldType = "N"
               IF Empty( nFieldLength )
                  nFieldLength = 14
               ENDIF
               IF Empty( nFieldLength )
                  nFieldLength = 5
               ENDIF
            ENDIF

            // Integer
            IF cFieldType = "I"
               cFieldType = "N"
               IF Empty( nFieldLength )
                  nFieldLength = 8
               ENDIF
               IF ! Empty( nFieldLength )
                  nFieldLength = 0
               ENDIF
            ENDIF


            DO CASE
               //
               // String ou memo
               //
            CASE cFieldType = "C" .OR. cFieldType = "M"
               nVAL := AllTrim( STRVAL( nVAL ) )
               nVAL := RANGEREPL( Chr( 0 ), Chr( 31 ), nVAL, " " ) // Remove caracteres de controle
               DO CASE
               CASE zCNVCHAR = "O"
                  nVAL := win_ANSIToOEM( nVAL ) // HB_ansitooem(nVAL)
               CASE zCNVCHAR = "A"
                  nVAL := win_oemtoansi( nVAL ) // hb_oemtoansi(nVAL)
               ENDCASE

               // datetime em forma de string
               IF  SubStr( nVAL, 5, 1 ) = "-" .AND. SubStr( nVAL, 8, 1 ) = "-"
                  nVAL = SubStr( nVAL, 6, 2 ) + "/" + SubStr( nVAL, 9, 2 ) + "/" + SubStr( nVAL, 1, 4 )
                  nvAL = CToD( nVAL )
                  nVAL = DATA2STR( nVAL, ZANOFOR, ZANOSEP, ZANOTAM )
               ENDIF

               DO CASE
               CASE tDOC = 7 // xml
                  cTEXTO += str2html( nVAL )
               CASE zEXPOREXT = "SQL"
                  cTEXTO += "'" + nVAL + "'" // sql string recenbem aspas simples
               CASE zEXPOREXT = "DLM" .AND. ( zREGSEP = Chr( 34 ) .OR. zREGSEP = Chr( 39 ) )    // dlm que char recebem aspas ou dupla aspas
                  cTEXTO += zREGSEP + nVAL + ZREGSEP
               OTHERWISE
                  cTEXTO += nVAL
               ENDCASE
               //
               // Data
               //
            CASE cFieldType = "D"
               IF Empty( nVAL )
                  cTEXTO += ""
               ELSE
                  cTEXTO += DATA2STR( nVAL, ZANOFOR, ZANOSEP, ZANOTAM )
               ENDIF

            CASE cFieldType = "@"
               IF Empty( nVAL )
                  cTEXTO += ""
               ELSE
                  cTEXTO += hb_TSToStr( nVAL )   // HB_TSTOSTR( <tTimeStamp> ) -> <cTimeStamp> // YYYY-MM-DD HH:MM:SS.fff
               ENDIF

            CASE cFieldType = "T"
               IF Empty( nVAL )
                  cTEXTO += ""
               ELSE
                  cTEXTO += hb_TSToStr( nVAL )
               ENDIF


               //
               // Logico
               //
            CASE cFieldType = "L"
               cTEXTO += logic2str( nval, 0, 0, zSEPLOGIC )
               //
               // Numerico
               //
            CASE cFieldType = "N"
               cTEXTO += AllTrim( STRVAL( nVAL, nFieldLength, nFieldDec, ZDECSIM ) )
            ENDCASE
            DO CASE
            CASE tDOC = 7 .AND. cSUBTIPO = "PCK"
               cTEXTO += Chr( 34 )
            CASE tDOC = 5 .AND. cSUBTIPO = "TRH"
               cTEXTO += "</td>" + Chr( 13 ) + Chr( 10 )
            CASE tDOC = 5 .AND. cSUBTIPO = "TDB"
               xlsWrite( nHANDLEDOC, nXLS, X, cTEXTO )
               cTEXTO := ""
            CASE ( ( tDOC = 5 .AND. cSUBTIPO = "TAB" ) .OR. tDOC = 6 )
               IF X <> nFIELDS
                  cTEXTO += ZDELIMITE
               ENDIF
            CASE tDOC = 7 .AND. cSUBTIPO = "ISO"
               cTEXTO += "</" + cCAMPO + ">" + cLIN
            CASE Tdoc = 8
               hb_HSet( hRecord, FieldName( x ), Ctexto )// FieldGet(nField)) // for each record, hrecord holds a hash of column name: column value
               cTEXTO := ""
            OTHERWISE
               IF X <> nFIELDS  // O Ultimo campo nao recebe delimitador
                  Ctexto += Zdelimite
               ENDIF
            ENDCASE
         NEXT X
         DO CASE
         CASE tDOC = 7 .AND. cSUBTIPO = "PCK"
            cTEXTO += "/>" + cLIN
         CASE tDOC = 6
            cTEXTO += cLIN
         CASE tDOC = 5 .AND. cSUBTIPO = "TRH"
            cTEXTO += "</tr>" + cLIN
         CASE tDOC = 7 .AND. cSUBTIPO = "ISO"
            cTEXTO += "</Registro>" + cLIN
         CASE zEXPOREXT = "SQL"
            cTEXTO += ") ; " + cLIN
         CASE Tdoc = 8
            // Abaixo
         OTHERWISE
            cTEXTO += cLIN
         ENDCASE
         DO CASE
         CASE tDOC = 5 .AND. cSUBTIPO = "TDB" // ja aberto em cima
         CASE tdoc = 8
            hb_HSet( hRecords, LTrim( Str( nxls ) ), hRecord ) // like so, a hash of recno: hash of columns/values of this record  RecNo() usa nxls para ficar sequencial
         OTHERWISE
            FWrite( nHANDLEDOC, cTEXTO )
         ENDCASE
         cTEXTO := ""
         ZEI_FORT( nLASTREC,,, 1 )
         dbSkip()
      ENDDO
   ENDIF
   IF tDOC = 7 .AND. cSUBTIPO = "PCK"
      cTEXTO += "</ROWDATA>" + cLIN
      cTEXTO += "</DATAPACKET>" + cLIN
   ENDIF
   IF tDOC = 7 .AND. cSUBTIPO = "ISO"
      cTEXTO += "</Dados>" + cLIN
      cTEXTO += "</DataRoot>" + cLIN
   ENDIF
   IF tDOC = 5 .AND. cSUBTIPO = "TRH"
      cTEXTO += "</table>" + cLIN
      cTEXTO += "</body>" + cLIN
      cTEXTO += "</html>" + cLIN
   ENDIF
   IF Len( cTEXTO ) > 0
      IF tDOC = 5 .AND. cSUBTIPO = "TDB" // ja aberto em cima
      ELSE
         FWrite( nHANDLEDOC, cTEXTO )
      ENDIF
   ENDIF
   IF tDOC = 8
      FSeek( nHandledoc, 0, 2 )
      FWrite( nHandledoc, hb_jsonEncode( hRecords, .T. ) )
   ENDIF
   IF tDOC = 5 .AND. cSUBTIPO = "TDB" // ja aberto em cima
      xlsClose( nHANDLEDOC )
   ELSE
      FClose( nHANDLEDOC )
   ENDIF

   RETURN .T.

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function TIPOC()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
FUNCTION TIPOC( cTIPO )

   LOCAL cRETU := ""

   DO CASE
   CASE cTIPO = 'C'
      cRETU := 'Caracter'
   CASE cTIPO = 'N'
      cRETU := 'Numerico'
   CASE cTIPO = 'L'
      cRETU := 'Logico  '
   CASE cTIPO = 'D'
      cRETU := 'Data    '
   CASE cTIPO = 'M'
      cRETU := 'Memo    '

   CASE cTIPO = 'F'
      cRETU := 'Float   '
   CASE cTIPO = 'I'
      cRETU := 'Integer '
   CASE cTIPO = 'B'
      cRETU := 'Double  '
   CASE cTIPO = 'T'
      cRETU := 'Time    '
   CASE cTIPO = '@'
      cRETU := 'Timestamp'
   CASE cTIPO = '='
      cRETU := 'ModeTime'
   CASE cTIPO = '^'
      cRETU := 'Rowver  '
   CASE cTIPO = '+'
      cRETU := 'Autoinc '
   CASE cTIPO = 'Y'
      cRETU := 'Moeda   '
   CASE cTIPO = 'Z'
      cRETU := 'MoedaDup'
   CASE cTIPO = 'Q'
      cRETU := 'Variavel'
   CASE cTIPO = 'V'
      cRETU := 'Any     '
   CASE cTIPO = 'P'
      cRETU := 'Imagen  '
   CASE cTIPO = 'W'
      cRETU := 'Blob    '
   CASE cTIPO = 'G'
      cRETU := 'Ole     '
   ENDCASE

   RETURN cRETU




// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function DBUZAP()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
FUNCTION dbuzap()

   ZAP

   RETURN .T.

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function DBUPACK()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
FUNCTION dbupack()

   PACK

   RETURN .T.

// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function DBETODBF(cMASK,lLAY,lCRIA)
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
FUNCTION DBETODBF( cMASK, lLAY, lCRIA )

   IF ValType( cMASK ) # "C"
      cMASK := "*.DBF"
   ENDIF
   IF ValType( lLAY ) # "L"
      lLAY := .T.
   ENDIF
   IF ValType( lCRIA ) # "L"
      lCRIA := .F.
   ENDIF
   MATDBF = FILENAMES( cMASK )
   nARQ = Len( MATDBF )
   IF nARQ > 0
      FOR X = 1 TO nARQ
         cARQDIC = TIRAEXT( MATDBF[ X ], 'DBE' )
         IF File( cARQDIC )
            @ 24, 00 SAY "Atualizando arquivo " + MATDBF[ X ]
            CLSCOR()
            MAKEDBF( cARQDIC,, lCRIA, RDDNOME( TIPODBF ) )
         ENDIF
      NEXT X
   ENDIF
   IF lLAY
      LAYOUT()
   ENDIF

   RETURN .T.


// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +
// +    Function  GERADBML()
// +
// +||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// +

FUNCTION GERADBML(cARQ,aUSO,lCAB)
/*
Table table_name {
  column_name column_type [column_settings]
}

// table belonged to a schema
Table schema_name.table_name {
  column_name column_type [column_settings]
Note: 'Stores user data'  
}

created_at timestamp [default: `now()`]
column_name column_type [note: 'replace text here']

*/
LOCAL cLINHA
LOCAL K
LOCAL j
IF VALTYPE(cARQ)<>"C"
    cARQ:=ALIAS()
ENDIF
IF VALTYPE(AUSO)<>"A"
    aUSO:=DBSTRUCT()
ENDIF
IF VALTYPE(lCAB)<>"L"
    lCAB:=.T.
ENDIF


cLINHA:=HB_OSNEWLINE()
IF lCAB
    cLINHA+="[DBML]"+HB_OSNEWLINE()
ENDIF    
cLINHA+="Table "+cARQ+" {"+HB_OSNEWLINE()
FOR K:= 1 TO lEN(aUSO)

   cLINHA += CHR(34)+AllTrim( aUSO[ K ][ DBS_NAME ] ) +CHR(34)
        DO CASE
               CASE aUSO[ K ][ DBS_TYPE ] = "C"
                    cLINHA += " CHAR (" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) + ")"
               CASE aUSO[ K ][ DBS_TYPE ] = "D"
                   cLINHA += " DATETIME "
                //PGSQL  TIMESTAMP   
                   
               CASE aUSO[ K ][ DBS_TYPE ] = "L"
                   cLINHA += " BOOLEAN"   
                   //" TINYINT(1)" SQL
               CASE aUSO[ K ][ DBS_TYPE ] = "N"
                   IF aUSO[ K ][DBS_DEC] =0
                     //    cLINHA += " INTEGER [default: 0]"
                     cLINHA += " DECIMAL (" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) +  ") [default: 0]"
                   ELSE
                     cLINHA += " DECIMAL (" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) + "," + AllTrim( Str( aUSO[ K ][ DBS_DEC ] ) ) + ") [default: 0]"
                   ENDIF  
               //CASE 
               //    "BYTEA"    PGSQL BYNARY
               CASE aUSO[ K ][ DBS_TYPE ] = "M"   
                    cLINHA += " LONGTEXT"
        ENDCASE
    cLINHA+= HB_OSNEWLINE()          
               
  //"TIPO" CHAR(20)
NEXT K
 // Indexes {
 //   TIPO [name: "TIPO"]
  //}
//   Indexes {
//    DOCUMENTO [name: "DOCUMENTO"]
//    NOVODOC [name: "NOVODOC"]
//    (TIPO, NUMERO) [name: "TIPONUMERO"]
//  }
 nIndexes  :=  dbOrderInfo( DBOI_ORDERCOUNT )
IF nIndexes>0
    cLINHA+="  Indexes {" +HB_OSNEWLINE()
         FOR j = 1 TO  nIndexes
            cINDEXNAME := dbOrderInfo( DBOI_NAME, ,  j )
            cINDEXNAME := StrTran( cINDEXNAME, "-", "_"  )  // Tracos nao aceitos trocando por undescore
            cLINHA+= " ( " + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + " ) "
            cLINHA+= " [name: "+CHR(34)+cINDEXNAME+CHR(34)+"]" +HB_OSNEWLINE() 
            //cSQLINDEX := "create index " + cINDEXNAME + " on " + cARQ + " ( " + MDPCHAVEI( dbOrderInfo( DBOI_EXPRESSION, ,  j ) ) + " ) ;"
            //cTEXTO += cSQLINDEX + hb_osNewLine()
         NEXT j 
    cLINHA+= HB_OSNEWLINE()     
    cLINHA+=" }" +HB_OSNEWLINE()     
 ENDIF 
  
  
cLINHA+="}"+HB_OSNEWLINE()
RETURN cLINHA


// + EOF: DBUDOC.PRG
