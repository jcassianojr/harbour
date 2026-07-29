#include "dbstruct.ch"
#INCLUDE "TRY.CH"
#INCLUDE "DBINFO.CH"

FUNCTION ParadoxCreateTable( cTablename, aStruct, cPrimaryKey )
   LOCAL oConn, oCat, oTable, nI, oIndex, cField
   LOCAL cDir  := hb_FNameDir( cTablename )
   LOCAL cFile := hb_FNameName( cTablename )
   LOCAL lSuccess := .F.

   // Se não passar a chave, usa o primeiro campo
   IF Empty( cPrimaryKey )
      cPrimaryKey := aStruct[1][1]
   ENDIF

   TRY
      oConn := CreateObject( "ADODB.Connection" )
      oConn:ConnectionString := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + cDir + ";Extended Properties=Paradox 5.x;"
      oConn:Open()

      oCat := CreateObject( "ADOX.Catalog" )
      oCat:ActiveConnection := oConn

      // Tenta remover se existir para evitar erro de objeto duplicado
      TRY ; oCat:Tables:Delete( cFile ) ; CATCH ; END

      oTable := CreateObject( "ADOX.Table" )
      oTable:Name := cFile

      // --- ADICIONA AS COLUNAS COM DO CASE LEGÍVEL ---
      FOR nI := 1 TO Len( aStruct )
         cField := aStruct[nI][1]
         
         DO CASE
            CASE aStruct[nI][2] == "C"
               oTable:Columns:Append( cField, 130, aStruct[nI][3] ) // 130 = adWChar
            
            CASE aStruct[nI][2] == "N"
               oTable:Columns:Append( cField, 5 )                  // 5 = adDouble
            
            CASE aStruct[nI][2] == "D"
               oTable:Columns:Append( cField, 7 )                  // 7 = adDate
            
            CASE aStruct[nI][2] == "L"
               oTable:Columns:Append( cField, 11 )                 // 11 = adBoolean
            
            CASE aStruct[nI][2] == "M"
               oTable:Columns:Append( cField, 203 )                // 203 = adVarWChar (Memo)
         ENDCASE
      NEXT


      /*
      // --- CRIAÇÃO DA CHAVE PRIMÁRIA ---
      oIndex := CreateObject( "ADOX.Index" )
      oIndex:Name       := "PK01"
      oIndex:PrimaryKey := .T.
      oIndex:Unique     := .T.
      
      // Adiciona os campos (se a variável vier com vírgulas, trate antes)
     // Se cPrimaryKey for "NUMERO,SUB", o append abaixo deve ser feito em loop
     aCampos := hb_ATokens( cPrimaryKey, "," )
     FOR nJ := 1 TO Len( aCampos )
        oIndex:Columns:Append( AllTrim( aCampos[nJ] ) )
      NEXT
      
      
      oTable:Indexes:Append( oIndex )
      */

      // Salva no catálogo
      oCat:Tables:Append( oTable )
      lSuccess := .T.
      oConn:Close()

   CATCH oErr
      MDT( "Erro na criação: " + oErr:Description )
      HB_MEMOWRIT("erro.txt",oErr:Description)
   END
RETURN lSuccess

FUNCTION DBF2Paradox( cDbfOrigem, cParadoxDestino )
   LOCAL oConn, oRs, nI, aStruct, cConnString
   
   // Lógica de destino automático [cite: 1, 7]
   IF Empty( cParadoxDestino )
      cParadoxDestino := hb_FNameDir( cDbfOrigem ) + hb_FNameName( cDbfOrigem ) + ".db"
   ENDIF
   
   // 1. Abre o DBF original
   IF !File( cDbfOrigem )
      MDT( "Arquivo DBF não encontrado: " + cDbfOrigem )
      RETURN .F.
   ENDIF

   USE (cDbfOrigem) ALIAS ORIGEM SHARED NEW
   aStruct := dbStruct()
   
   /*
   // 1. Verifica quantos índices existem no CDX/NTX
   nTotalIndices := dbOrderInfo(DBOI_ORDERCOUNT)
   
   // 2. Se houver pelo menos um índice, pega a expressão dele
   IF nTotalIndices > 0
      cPrimaryKey := MDPCHAVEI(dbOrderInfo( DBOI_EXPRESSION, , 1 ))
     // alert(cPrimaryKey)
   ENDIF
   
   // 3. Fallback: Se não houver índice ou a expressão for vazia, 
   // usamos o primeiro campo da estrutura como chave (segurança absoluta)
   IF Empty( cPrimaryKey )
      cPrimaryKey := aStruct[1][1]
   ENDIF
   */
   
   // 2. Cria a estrutura [cite: 3, 7]
   IF !ParadoxCreateTable( cParadoxDestino, aStruct) //,cPrimaryKey )
      DBCLOSEAREA()
      RETURN .F.
   ENDIF

   // 3. Conexão Manual para Testes
   // Substitua o caminho abaixo pelo caminho real da pasta onde o arquivo .db será criado
   cConnString := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + hb_FNameDir( cParadoxDestino ) + ";Extended Properties=Paradox 5.x;"
   
   oConn := CreateObject( "ADODB.Connection" )
   oConn:ConnectionString := cConnString
   oConn:Mode := 3 // adModeReadWrite
   oConn:Open()

   // 4. Abre o Recordset [cite: 4]
   /*
   oRs := CreateObject( "ADODB.Recordset" )
   //oRs:Open( hb_FNameName(cParadoxDestino), oConn, 1, 3 ) 
   oRs:CursorLocation := 3 // adUseClient (Força o uso de cursor em memória, evitando bloqueios do disco)
   oRs:Open( "SELECT * FROM " + hb_FNameName(cParadoxDestino), oConn, 2, 3 )
   
   //oRs:Open( hb_FNameName(cParadoxDestino), oConn, 2, 4 )
   */
   
   oRs := CreateObject( "ADODB.Recordset" )
   //oRs:Open( hb_FNameName(cParadoxDestino), oConn, 1, 3 ) 
   oRs:CursorLocation := 3 // adUseClient (Força o uso de cursor em memória, evitando bloqueios do disco)
   //oRs:Open( "SELECT * FROM " + hb_FNameName(cParadoxDestino), oConn, 1, 2 )
  oRs:Open( hb_FNameName(cParadoxDestino), oConn, 1, 2 )

   // 5. Loop de migração [cite: 5]
   SELECT ORIGEM
   DbGoTop()
   WHILE !Eof()
      /*
      mSql := "INSERT INTO " + hb_FNameName(cParadoxDestino) + " VALUES "
      msql := msql + "("
      FOR i := 1 TO Len( aStruct )
         mFldNm := aStruct[ i, DBS_NAME ]
         IF i > 1
            mSql += ", "
         ENDIF
         mSql += c2sql( &mFldNm )
      NEXT
      mSql += ")"
      oConn:Execute(MSQL)
      */
      
      /*
      cCAMPOS:=""
      cVALORES:=""
      // Dentro do seu loop de gravação:
      FOR nI := 1 TO Len( aStruct )
         cCampos  += "[" + AllTrim(aStruct[nI][1]) + "],"
         cValores += "'" + hb_ValToStr(FieldGet(nI)) + "',"
      NEXT
      cCampos  := Left(cCampos, Len(cCampos)-1)
      cValores := Left(cValores, Len(cValores)-1)

      // O uso de colchetes no nome da tabela e nos campos é OBRIGATÓRIO no Paradox via Jet
      cSql := "INSERT INTO [" + hb_FNameName(cParadoxDestino)  + "] (" + cCampos + ") VALUES (" + cValores + ")"
      oConn:Execute( cSql )
      */
      
      
      oRs:AddNew()
      FOR nI := 1 TO Len( aStruct )
         oRs:Fields( aStruct[nI][1] ):Value := hb_FieldGet( nI )
      NEXT
      oRs:Update()
      
      DbSkip()
   ENDDO

   // 6. Limpeza [cite: 6]
   oRs:Close()
   oConn:Close()
   DBCLOSEAREA()
   
   MDT( "Migração concluída com sucesso!" )
RETURN .T.

FUNCTION DBF2Paradoxadordd( cDbfOrigem, cParadoxDestino, cPrimaryKey  )
   LOCAL aStruct, nI, oConn, oCat, oTable, oRs
   LOCAL cDir 
   LOCAL cFile 
   
   IF VALTYPE(cParadoxDestino)<>"C"
      cParadoxDestino:=TROCAEXT(cDbfOrigem,".db")
   ENDIF
   
   
   cDir := hb_FNameDir( cParadoxDestino )
   cFile := hb_FNameName( cParadoxDestino )
   // 1. Abre o DBF original (RDD padrão)
   IF !File( cDbfOrigem )
      MDT( "Arquivo DBF não encontrado: " + cDbfOrigem )
      RETURN .F.
   ENDIF
   
   //DBUseArea( <lNewArea> , <cDriver> , <cName>, <xcAlias> , <lShared> , <lReadOnly>,<cCodePage>,<nConnection> ) -> lSuccess
  
   dbUseArea( .F.,, cDbfOrigem,"ORIGEM", .T., .F. )
   
   //USE (cDbfOrigem) ALIAS ORIGEM SHARED NEW
   aStruct := dbStruct()
   
   // 2. Cria a estrutura no Paradox usando a lógica ADOX anterior
   IF ! ParadoxCreateTable( cParadoxDestino, aStruct )
      DBSELECTAR("ORIGEM")
      DBCLOSEAREA()
      RETURN .F.
   ENDIF
   
   // 3. Abre o Paradox via ADORDD para inserir os dados
   // O Paradox aqui é tratado como uma tabela via ADO
      hb_adoSetTable(cFILE)
   // Verifique se o seu ADORDD suporta "PARADOX" ou se requer "MSDASQL" com DSN
   hb_adoSetEngine("PARADOX")
   dbUseArea(.F.,"ADORDD",(cParadoxDestino),"DESTINO",.T.,.F.)

   
   
  // USE (cParadoxDestino) ALIAS DESTINO VIA "ADORDD" NEW
   
   // 4. Loop de migração (Simetria de gravação)
   //SELECT ORIGEM
  
   DBSELECTAR("ORIGEM")
   
   dbGoTop()
   WHILE !Eof()
      DBSELECTAR( "DESTINO")
      DBAPPEND()
      
      FOR nI := 1 TO Len( aStruct )
         // Transfere o campo do DBF para o campo do Paradox
         FieldPut( nI, ORIGEM->(hb_FieldGet( nI )) )
      NEXT
      
      DBSELECTAR("ORIGEM")
      DBSKIP()
   ENDDO
   
   DBSELECTAR("ORIGEM")
   DBCLOSEAREA()
   DBSELECTAR( "DESTINO")
   DBCLOSEAREA()
   
   MDT( "Migração concluída com sucesso para: " + cParadoxDestino )
RETURN .T.



FUNCTION paradoxtocsv(cPASTA,cTABELA)
    LOCAL oConn, oRs
    LOCAL cConnStr, cQuery
    LOCAL nFile, cLine, cVal
    LOCAL i

    CLS
    ? "Iniciando conexao com Paradox via ADO no Harbour..."

    // Cria o objeto de conexao ADO
    oConn := CreateObject("ADODB.Connection")
    
    // ATENCAO: O 'Data Source' no Jet OLEDB para Paradox deve apontar 
    // estritamente para a PASTA (diretorio) onde o arquivo .db esta localizado, 
    // e nao para o arquivo em si.
    // 'Paradox 5.X' pode ser alterado dependendo da versao (ex: Paradox 3.X, 4.X, 5.x 7.X)
    //cConnStr := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\temp\uso\;Extended Properties=Paradox 5.X;"
    //cConnStr := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\caminho\para\sua\pasta;Extended Properties=Paradox 5.X;"
    cConnStr := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+cPASTA+";Extended Properties=Paradox 5.X;"
    

    BEGIN SEQUENCE
        // Abre a conexao
        oConn:Open(cConnStr)
        ? "Conexao aberta com sucesso!"

        // O nome da tabela corresponde ao nome do arquivo .db sem a extensao
        cQuery := "SELECT * FROM "+cTABELA
        oRs := oConn:Execute(cQuery)

        // Cria o arquivo CSV de saida
        nFile := FCreate("resultado_harbour.csv")
        IF FError() != 0
            ? "Erro ao criar o arquivo CSV de saida. Codigo de erro:", FError()
            BREAK
        ENDIF

        // 1. Escreve o Cabecalho (nomes das colunas)
        cLine := ""
        FOR i := 0 TO oRs:Fields:Count - 1
            cLine += oRs:Fields(i):Name
            IF i < oRs:Fields:Count - 1
                cLine += ","
            ENDIF
        NEXT
        FWrite(nFile, cLine + Chr(13) + Chr(10))

        // 2. Percorre os registros e grava as linhas
        DO WHILE !oRs:EOF
            cLine := ""
            FOR i := 0 TO oRs:Fields:Count - 1
                // Converte o valor do campo para string de forma segura
                cVal := hb_ValToStr(oRs:Fields(i):Value)
                
                // Envolve em aspas e trata eventuais aspas internas para preservar o CSV
                cLine += '"' + StrTran(cVal, '"', '""') + '"'
                
                IF i < oRs:Fields:Count - 1
                    cLine += ","
                ENDIF
            NEXT
            FWrite(nFile, cLine + Chr(13) + Chr(10))
            oRs:MoveNext()
        ENDDO

        FClose(nFile)
        oRs:Close()
        oConn:Close()
        
        ? "Processo concluido! Arquivo 'resultado_harbour.csv' gerado com sucesso."

    RECOVER
        ? "Erro criticou durante a execucao ADO."
    END SEQUENCE

    RETURN
