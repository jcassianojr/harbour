#include "fileio.ch"
#include "directry.ch"
#include "hbsqlit3.ch"
#include "dbinfo.ch"
#include "dbstruct.ch"
#include "try.ch"

#require "hbsqlit3"


FUNCTION GeraMDdbml(cMASK)
   LOCAL aArquivos 
   LOCAL nHandle, nHandleDbml, oFile, cExt
   LOCAL cOut := "documentacao_dados.md"
   LOCAL cOutDbml := "estrutura.dbml"
   LOCAL  cCAMMASK



   aArquivos := Directory( cMASK )
   cCAMMASK:=SPACE(100)

   hb_FNameSplit( cMASK, @cCAMMASK, ,  )
   
   IF LEN(aArquivos)=1
       cOut     := HB_FNAMENAME(cMASK)+"_documentacao.md"
       cOutDbml := HB_FNAMENAME(cMASK)+"_estrutura.dbml"
   ENDIF
    

   // Cria o arquivo de Documentacao Markdown
   nHandle := fCreate( cOut )
   IF nHandle == -1
      ? "Erro ao criar arquivo de documentacao."
      RETURN
   ENDIF

   // Cria o arquivo unificado .dbml[cite: 1]
   nHandleDbml := fCreate( cOutDbml )
   IF nHandleDbml == -1
      ? "Erro ao criar arquivo estrutura.dbml."
      fClose(nHandle)
      RETURN
   ENDIF

   fWrite( nHandle, hb_StrToUTF8("# ") + "Dicionario de Estruturas de Dados do Projeto" + hb_eol() )
   fWrite( nHandle, "> Varredura automatica realizada em: " + DToC(Date()) + hb_eol() + hb_eol() )

   FOR EACH oFile IN aArquivos
      cExt := Lower( SubStr( oFile[ F_NAME ], At( ".", oFile[ F_NAME ] ) + 1 ) )
      
      DO CASE
         CASE cExt == "dbf"
            Doc_DBF( cCAMMASK+oFile[ F_NAME ], nHandle, nHandleDbml )
         
         CASE cExt == "sqlite" .or. cExt == "sqlite3" .or. cExt == "fossil" .or. cExt == "db" .or. cExt == "db3"
            Doc_SQLite( cCAMMASK+oFile[ F_NAME ], nHandle, nHandleDbml )
         
         CASE cExt == "mdb" .OR. cExt == "accdb"
            Doc_Access( cCAMMASK+oFile[ F_NAME ], nHandle, nHandleDbml )
      ENDCASE
   NEXT

   fClose( nHandle )
   fClose( nHandleDbml )
   
   ? "Documentacao gerada em " + cOut + " e " + cOutDbml + " com sucesso."

RETURN

// --- Processa DBF com Indices e gera Documentacao e DBML ---
FUNCTION Doc_DBF( cFile, nHandle, nHandleDbml )
   LOCAL nI, cTag, cExpr, cDbmlStr, aSTRU, aINDICES := {}
   
   ? cFILE 
   dbUseArea( .T.,zusovia, cFile, "TEMP", .T., .T. )
   
   cFILE:=HB_FNAMENAME(cFILE)

   IF ! NetErr()
      // Inclui informacao da origem no cabecalho do Markdown
      fWrite( nHandle, hb_StrToUTF8("## ") + "Tabela DBF: `" + cFile + "`" + hb_eol() )
      fWrite( nHandle, "> **Origem:** `" + cFile + "` (Driver: DBFCDX)" + hb_eol() + hb_eol() )
      fWrite( nHandle, "| Campo | Tipo | Tam | Dec |" + hb_eol() )
      fWrite( nHandle, "| :--- | :--- | :--- | :--- |" + hb_eol() )

      FOR nI := 1 TO FCount()
         fWrite( nHandle, "| " + FieldName(nI) + " | " + FieldType(nI) + " | " + ;
                 AllTrim(Str(FieldLen(nI))) + " | " + AllTrim(Str(FieldDec(nI))) + " |" + hb_eol() )
      NEXT

      IF dbOrderInfo( DBOI_ORDERCOUNT ) > 0
         fWrite( nHandle, hb_eol() + "**Indices vinculados:**" + hb_eol() )
         FOR nI := 1 TO dbOrderInfo( DBOI_ORDERCOUNT )
            cTag  := dbOrderInfo( DBOI_NAME, , nI )
            cExpr := dbOrderInfo( DBOI_EXPRESSION, , nI )
            fWrite( nHandle, "- Tag: `" + cTag + "` Expressao: `" + cExpr + "`" + hb_eol() )
            AAdd( aINDICES, { nI, cTag, cExpr } )
         NEXT
      ENDIF
      
      aSTRU := DBSTRUCT()
      
      // Passa o arquivo físico e tipo para o DBML
      cDbmlStr := GERADBML_Custom( HB_FNAMENAME(cFile), aSTRU, aINDICES, cFile, zusovia )
      fWrite( nHandleDbml, cDbmlStr + hb_eol() )

      dbCloseArea()
      fWrite( nHandle, hb_eol() + "---" + hb_eol() )
   ENDIF
RETURN


// --- Processa SQLite e gera Documentacao e DBML ---
FUNCTION Doc_SQLite( cDbFile, nHandleDoc, nHandleDbml )
   LOCAL db, stmt, stmtCol, stmtIdx, stmtInfo
   LOCAL cTabName, cIdxName, cCamposIdx, cIsUnique
   LOCAL lHasIdx, cDbmlStr, aStruct, aIndicesTab

   db := sqlite3_open( cDbFile )
   
   cDbFile:=HB_FNAMENAME(cDbFile)

   IF Empty( db )
      fWrite( nHandleDoc, hb_StrToUTF8("### ") + "Erro ao abrir: " + cDbFile + hb_eol() )
      RETURN
   ENDIF



   stmt := sqlite3_prepare( db, "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'" )

   DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
      cTabName := sqlite3_column_text( stmt, 1 )
      
      // Inclui informacao da origem no cabecalho do Markdown
      fWrite( nHandleDoc, hb_eol() + hb_StrToUTF8("#### ") + "Tabela: `" + cTabName + "`" + hb_eol() )
      fWrite( nHandleDoc, "> **Origem:** `" + cDbFile + "` (SQLite)" + hb_eol() + hb_eol() )
      fWrite( nHandleDoc, "| Campo | Tipo | PK | NotNull |" + hb_eol() )
      fWrite( nHandleDoc, "| :--- | :--- | :---: | :---: |" + hb_eol() )

      aStruct := {}
      stmtCol := sqlite3_prepare( db, "PRAGMA table_info('" + cTabName + "')" )
      DO WHILE sqlite3_step( stmtCol ) == SQLITE_ROW
         AAdd( aStruct, { sqlite3_column_text( stmtCol, 2 ), sqlite3_column_text( stmtCol, 3 ), iif( sqlite3_column_int( stmtCol, 4 ) == 1, .T., .F. ) } )
         fWrite( nHandleDoc, "| " + sqlite3_column_text( stmtCol, 2 ) + ;
                          " | " + sqlite3_column_text( stmtCol, 3 ) + ;
                          " | " + iif( sqlite3_column_int( stmtCol, 6 ) == 1, "Sim", " " ) + ;
                          " | " + iif( sqlite3_column_int( stmtCol, 4 ) == 1, "Sim", " " ) + " |" + hb_eol() )
      ENDDO
      sqlite3_finalize( stmtCol )

      aIndicesTab := {}
      fWrite( nHandleDoc, hb_eol() + "**Indices e Chaves:**" + hb_eol() )
      stmtIdx := sqlite3_prepare( db, "PRAGMA index_list('" + cTabName + "')" )
      lHasIdx := .F.

      DO WHILE sqlite3_step( stmtIdx ) == SQLITE_ROW
         lHasIdx   := .T.
         cIdxName  := sqlite3_column_text( stmtIdx, 2 )
         cIsUnique := iif( sqlite3_column_int( stmtIdx, 3 ) == 1, " (Unico)", "" )
         
         stmtInfo   := sqlite3_prepare( db, "PRAGMA index_info('" + cIdxName + "')" )
         cCamposIdx := ""
         
         DO WHILE sqlite3_step( stmtInfo ) == SQLITE_ROW
            cCamposIdx += sqlite3_column_text( stmtInfo, 3 ) + ", "
         ENDDO
         sqlite3_finalize( stmtInfo )
         
         IF !Empty(cCamposIdx)
            cCamposIdx := Left( cCamposIdx, Len(cCamposIdx) - 2 )
            AAdd( aIndicesTab, { cIdxName, cCamposIdx } )
            fWrite( nHandleDoc, "- **" + cIdxName + "**: `" + cCamposIdx + "`" + cIsUnique + hb_eol() )
         ENDIF
      ENDDO
      
      IF !lHasIdx
         fWrite( nHandleDoc, "> *Nenhum indice definido.*" + hb_eol() )
      ENDIF
      sqlite3_finalize( stmtIdx )

      cDbmlStr := GERADBML_SQLite( cTabName, aStruct, aIndicesTab, cDbFile, "SQLite" )
      fWrite( nHandleDbml, cDbmlStr + hb_eol() )

      fWrite( nHandleDoc, hb_eol() + "---" + hb_eol() )
   ENDDO

   sqlite3_finalize( stmt )
RETURN

// --- Processa Access e gera Documentacao e DBML ---
FUNCTION Doc_Access( cMdbFile, nHandleDoc, nHandleDbml )
   LOCAL oConn, oCat, oTable, oColumn, oIndex, oIdxCol
   LOCAL cConnStr, nType, cSizeStr, cExt, cIdxFields
   LOCAL nTbl, nCol, nIdx, nIdxC 
   LOCAL aStruct, aIndicesTab, cDbmlStr
   
   cExt := Lower( SubStr( cMdbFile, At( ".", cMdbFile ) + 1 ) )
   
   IF cExt == "mdb"
      cConnStr := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + cMdbFile + ";"
   ELSE
      cConnStr := "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + cMdbFile + ";"
   ENDIF

   cMdbFile:=HB_FNAMENAME(cMdbFile)

   TRY
      oConn := win_oleCreateObject( "ADODB.Connection" )
      oConn:Open( cConnStr )
      
      oCat := win_oleCreateObject( "ADOX.Catalog" )
      oCat:ActiveConnection := oConn
   CATCH
      fWrite( nHandleDoc, hb_StrToUTF8("### ") + "Erro: Falha na conexao OLE com " + cMdbFile + hb_eol() )
      RETURN
   END

   FOR nTbl := 0 TO oCat:Tables:Count - 1
      oTable := oCat:Tables:Item( nTbl )
      
      IF AllTrim( Upper( hb_ValToStr( oTable:Type ) ) ) == "TABLE"
         // Inclui informacao da origem no cabecalho do Markdown
         fWrite( nHandleDoc, hb_eol() + hb_StrToUTF8("#### ") + cMdbFile + " / `" + oTable:Name + "`" + hb_eol() )
         fWrite( nHandleDoc, "> **Origem:** `" + cMdbFile + "` (Access/OLEDB)" + hb_eol() + hb_eol() )
         fWrite( nHandleDoc, "| Campo | Tipo | Tamanho |" + hb_eol() )
         fWrite( nHandleDoc, "| :--- | :--- | :---: |" + hb_eol() )

         aStruct := {}
         FOR nCol := 0 TO oTable:Columns:Count - 1
            oColumn := oTable:Columns:Item( nCol )
            nType := oColumn:Type
            cSizeStr := hb_ValToStr( oColumn:DefinedSize )
            
            IF nType == 203 ; cSizeStr := "Ilimitado" ; ENDIF 
            IF nType == 11  ; cSizeStr := "1 bit"     ; ENDIF 

            AAdd( aStruct, { hb_ValToStr(oColumn:Name), cValToType(nType), cSizeStr } )

            fWrite( nHandleDoc, "| " + PadR( hb_ValToStr(oColumn:Name), 25) + ;
                             " | " + PadR( cValToType(nType), 15) + ;
                             " | " + PadR( cSizeStr, 10) + " |" + hb_eol() )
         NEXT

         fWrite( nHandleDoc, hb_eol() + "**Indices:**" + hb_eol() )
         aIndicesTab := {}
         
         IF oTable:Indexes:Count > 0
            FOR nIdx := 0 TO oTable:Indexes:Count - 1
               oIndex := oTable:Indexes:Item( nIdx )
               cIdxFields := ""
               
               FOR nIdxC := 0 TO oIndex:Columns:Count - 1
                  oIdxCol := oIndex:Columns:Item( nIdxC )
                  cIdxFields += hb_ValToStr( oIdxCol:Name ) + ", "
               NEXT
               
               cIdxFields := Left( cIdxFields, Len(cIdxFields) - 2 )
               AAdd( aIndicesTab, { hb_ValToStr(oIndex:Name), cIdxFields } )

               fWrite( nHandleDoc, "- **" + hb_ValToStr(oIndex:Name) + "**: `" + cIdxFields + "`" + ;
                                iif( oIndex:Unique, " (Unico)", "" ) + hb_eol() )
            NEXT
         ELSE
            fWrite( nHandleDoc, "> *Nenhum indice detectado.*" + hb_eol() )
         ENDIF
         
         cDbmlStr := GERADBML_Access( oTable:Name, aStruct, aIndicesTab, cMdbFile, "Access" )
         fWrite( nHandleDbml, cDbmlStr + hb_eol() )

         fWrite( nHandleDoc, hb_eol() + "---" + hb_eol() )
      ENDIF
   NEXT

   oConn:Close()
RETURN

STATIC FUNCTION cValToType( nType )
   LOCAL cRet
   DO CASE
      CASE nType == 202 ; cRet := "VARCHAR"
      CASE nType == 203 ; cRet := "LONGTEXT"
      CASE nType == 3   ; cRet := "INTEGER"
      CASE nType == 2   ; cRet := "SMALLINT"
      CASE nType == 7   ; cRet := "DATETIME"
      CASE nType == 11  ; cRet := "BOOLEAN"
      CASE nType == 6   ; cRet := "CURRENCY"
      OTHERWISE         ; cRet := "VARCHAR"
   ENDCASE
RETURN cRet

// --- Funcoes Auxiliares de Geracao DBML ---

FUNCTION GERADBML_Custom( cARQ, aUSO, aINDICES, cOrigemFile, cTipoOrigem )
   LOCAL cLINHA := "", K, j
   cLINHA += '// Origem: ' + cOrigemFile + ' (' + cTipoOrigem + ')' + hb_eol()
   cLINHA += 'Table "' + cARQ + '" {' + hb_eol()
   cLINHA += '  Note: "Origem: ' + cOrigemFile + '"' + hb_eol()

   FOR K := 1 TO LEN(aUSO)
      cLINHA += '  "' + AllTrim( aUSO[ K ][ DBS_NAME ] ) + '"'
      DO CASE
         CASE aUSO[ K ][ DBS_TYPE ] = "C"
              cLINHA += " VARCHAR(" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) + ")"
         CASE aUSO[ K ][ DBS_TYPE ] = "D"
              cLINHA += " DATETIME"
         CASE aUSO[ K ][ DBS_TYPE ] = "L"
              cLINHA += " TINYINT(1)"
         CASE aUSO[ K ][ DBS_TYPE ] = "N"
              IF aUSO[ K ][ DBS_DEC ] = 0
                 cLINHA += " INTEGER [default: 0]"
              ELSE
                 cLINHA += " DECIMAL(" + AllTrim( Str( aUSO[ K ][ DBS_LEN ] ) ) + "," + AllTrim( Str( aUSO[ K ][ DBS_DEC ] ) ) + ") [default: 0]"
              ENDIF  
         CASE aUSO[ K ][ DBS_TYPE ] = "M"   
              cLINHA += " LONGTEXT"
      ENDCASE
      cLINHA += hb_eol()          
   NEXT K

   IF LEN(aINDICES) > 0
      cLINHA += "  Indexes {" + hb_eol()
      FOR j := 1 TO LEN(aINDICES)
         cLINHA += "    " + aINDICES[j,3] + " [name: " + CHR(34) + aINDICES[j,2] + CHR(34) + "]" + hb_eol()
      NEXT j 
      cLINHA += "  }" + hb_eol()     
   ENDIF 
   cLINHA += "}" + hb_eol()
RETURN cLINHA

FUNCTION GERADBML_SQLite( cARQ, aUSO, aINDICES, cOrigemFile, cTipoOrigem )
   LOCAL cLINHA := "", K, j
   cLINHA += '// Origem: ' + cOrigemFile + ' (' + cTipoOrigem + ')' + hb_eol()
   cLINHA += 'Table "' + cARQ + '" {' + hb_eol()
   cLINHA += '  Note: "Origem: ' + cOrigemFile + '"' + hb_eol()

   FOR K := 1 TO LEN(aUSO)
      cLINHA += '  "' + AllTrim( aUSO[K, 1] ) + '" ' + AllTrim( aUSO[K, 2] )
      cLINHA += hb_eol()          
   NEXT K

   IF LEN(aINDICES) > 0
      cLINHA += "  Indexes {" + hb_eol()
      FOR j := 1 TO LEN(aINDICES)
         cLINHA += "    (" + aINDICES[j,2] + ") [name: " + CHR(34) + aINDICES[j,1] + CHR(34) + "]" + hb_eol()
      NEXT j 
      cLINHA += "  }" + hb_eol()     
   ENDIF 
   cLINHA += "}" + hb_eol()
RETURN cLINHA

FUNCTION GERADBML_Access( cARQ, aUSO, aINDICES, cOrigemFile, cTipoOrigem )
   LOCAL cLINHA := "", K, j
   cLINHA += '// Origem: ' + cOrigemFile + ' (' + cTipoOrigem + ')' + hb_eol()
   cLINHA += 'Table "' + cARQ + '" {' + hb_eol()
   cLINHA += '  Note: "Origem: ' + cOrigemFile + '"' + hb_eol()

   FOR K := 1 TO LEN(aUSO)
      cLINHA += '  "' + AllTrim( aUSO[K, 1] ) + '" ' + AllTrim( aUSO[K, 2] )
      cLINHA += hb_eol()          
   NEXT K

   IF LEN(aINDICES) > 0
      cLINHA += "  Indexes {" + hb_eol()
      FOR j := 1 TO LEN(aINDICES)
         cLINHA += "    (" + aINDICES[j,2] + ") [name: " + CHR(34) + aINDICES[j,1] + CHR(34) + "]" + hb_eol()
      NEXT j 
      cLINHA += "  }" + hb_eol()     
   ENDIF 
   cLINHA += "}" + hb_eol()
RETURN cLINHA


