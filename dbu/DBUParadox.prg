#INCLUDE "TRY.CH"
FUNCTION DBF2Paradox( cDbfOrigem, cParadoxDestino )
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
         FieldPut( nI, ORIGEM->(FieldGet( nI )) )
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



FUNCTION ParadoxCreateTable( cTablename, aStruct )
   LOCAL oConn, oCat, oTable, nI, cField
   LOCAL cDir := hb_FNameDir( cTablename ) // Pasta onde o .db será criado
   LOCAL cFile := hb_FNameName( cTablename )
   LOCAL lSuccess := .F.
   
  // "C"	Character	130 (adWChar)
//"N"	Number	5 (adDouble)
//"D"	Date	7 (adDate)
//"L"	Logical	11 (adBoolean)
//"M"	Memo	130 (com tamanho 0 ou grande)

   TRY
      // 1. Cria a conexão ADO
      oConn := CreateObject( "ADODB.Connection" )
      oConn:ConnectionString := geraconn(cTABLENAME)//"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + cDir + ";Extended Properties=Paradox 5.x;"
      oConn:Open()

      // 2. Cria o Catálogo ADOX (para manipular DDL/Estrutura)
      oCat := CreateObject( "ADOX.Catalog" )
      oCat:ActiveConnection := oConn

      // 3. Define a Tabela
      oTable := CreateObject( "ADOX.Table" )
      oTable:Name := cFile

      // 4. Adiciona as colunas baseadas no aStruct
      FOR nI := 1 TO Len( aStruct )
         cField := aStruct[nI][DBS_NAME]
         
         // Tradução simples de tipos Harbour para ADOX
         // 130 = adWChar, 5 = adDouble, 7 = adDate, 11 = adBoolean
         DO CASE
            CASE aStruct[nI][DBS_TYPE] == "C"
               oTable:Columns:Append( cField, 130, aStruct[nI][DBS_LEN] )
            CASE aStruct[nI][DBS_TYPE] == "N"
               oTable:Columns:Append( cField, 5 )
            CASE aStruct[nI][DBS_TYPE] == "D"
               oTable:Columns:Append( cField, 7 )
            CASE aStruct[nI][DBS_TYPE] == "L"
               oTable:Columns:Append( cField, 11 ) 
            CASE aStruct[nI][DBS_TYPE] == "M"
              // Memo: 203 (adLongVarWChar) - O Paradox cria automaticamente o arquivo .mb
              oTable:Columns:Append( cField, 203 )   
         ENDCASE
      NEXT

      // 5. Salva a tabela no Catálogo
      oCat:Tables:Append( oTable )
      lSuccess := .T.

   CATCH
      MDT( "Erro ao criar tabela Paradox via ADOX: " + oConn:Errors(0):Description )
   END
   
   oConn:Close()
RETURN lSuccess
