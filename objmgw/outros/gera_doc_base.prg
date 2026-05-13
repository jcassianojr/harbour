#include "fileio.ch"
#include "directry.ch"
#include "hbsqlit3.ch"
#include "dbinfo.ch"
#include "dbstruct.ch"
#include "try.ch"


#require "hbsqlit3"



PROCEDURE Main()
   LOCAL aArquivos := Directory( "*.*" )
   LOCAL nHandle, oFile, cExt
   LOCAL cOut := "DOCUMENTACAO_DADOS.md"
   
   
     REQUEST DBFCDX
   SetMode( 25, 80 )
   cls

   nHandle := fCreate( cOut )
   IF nHandle == -1
      ? "Erro ao criar arquivo de documentacao."
      RETURN
   ENDIF

   fWrite( nHandle, hb_StrToUTF8("# ???")+" Dicionario de Estruturas de Dados do Projeto" + hb_eol() )
   fWrite( nHandle, "> Varredura automatica realizada em: " + DToC(Date()) + hb_eol() + hb_eol() )

   FOR EACH oFile IN aArquivos
      cExt := Lower( SubStr( oFile[ F_NAME ], At( ".", oFile[ F_NAME ] ) + 1 ) )
      
      DO CASE
         CASE cExt == "dbf"
            Doc_DBF( oFile[ F_NAME ], nHandle )
         
         CASE cExt == "sqlite"
            Doc_SQLite( oFile[ F_NAME ], nHandle )
         
         CASE cExt == "mdb" .OR. cExt == "accdb"
            Doc_Access( oFile[ F_NAME ], nHandle )
      ENDCASE
   NEXT

   fClose( nHandle )
   ? "Documentacao de dados gerada com sucesso em " + cOut
RETURN

// --- Processa DBF com Índices ---
STATIC PROCEDURE Doc_DBF( cFile, nHandle )
   LOCAL nI, cTag, cExpr
   
   // Abre em modo compartilhado e leitura para evitar travas
   dbUseArea( .T., "DBFCDX", cFile, "TEMP", .T., .T. )

   IF ! NetErr()
      fWrite( nHandle, hb_StrToUTF8("## ?? ")+"Tabela DBF: `" + cFile + "`" + hb_eol() )
      fWrite( nHandle, "| Campo | Tipo | Tam | Dec |" + hb_eol() )
      fWrite( nHandle, "| :--- | :--- | :--- | :--- |" + hb_eol() )

      FOR nI := 1 TO FCount()
         fWrite( nHandle, "| " + FieldName(nI) + " | " + FieldType(nI) + " | " + ;
                 AllTrim(Str(FieldLen(nI))) + " | " + AllTrim(Str(FieldDec(nI))) + " |" + hb_eol() )
      NEXT

      // LISTAR ÍNDICES REAIS
      IF dbOrderInfo( DBOI_ORDERCOUNT ) > 0
         fWrite( nHandle, hb_eol() + "**Índices vinculados:**" + hb_eol() )
         FOR nI := 1 TO dbOrderInfo( DBOI_ORDERCOUNT )
            cTag  := dbOrderInfo( DBOI_NAME, , nI )
            cExpr := dbOrderInfo( DBOI_EXPRESSION, , nI )
            fWrite( nHandle, "- Tag: `" + cTag + "` Expressão: `" + cExpr + "`" + hb_eol() )
         NEXT
      ENDIF

      dbCloseArea()
      fWrite( nHandle, hb_eol() + "---" + hb_eol() )
   ENDIF
RETURN



STATIC PROCEDURE Doc_SQLite( cDbFile, nHandleDoc )
   LOCAL db, stmt, stmtCol, stmtIdx, stmtInfo
   LOCAL cTabName, cIdxName, cCamposIdx, cIsUnique
   LOCAL lHasIdx

   // 1. Abertura do Banco
   db := sqlite3_open( cDbFile )
   
   IF Empty( db )
      fWrite( nHandleDoc,hb_StrToUTF8( "### ?") + "Erro ao abrir: " + cDbFile + hb_eol() )
      RETURN
   ENDIF

   // 2. Iteração pelas Tabelas
   stmt := sqlite3_prepare( db, "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'" )

   DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
      cTabName := sqlite3_column_text( stmt, 1 )
      
      fWrite( nHandleDoc, hb_eol() + hb_StrToUTF8("#### ?? ")+"Tabela: `" + cTabName + "`" + hb_eol() )
      fWrite( nHandleDoc, "| Campo | Tipo | PK | NotNull |" + hb_eol() )
      fWrite( nHandleDoc, "| :--- | :--- | :---: | :---: |" + hb_eol() )

      // 3. Processamento de Colunas
      stmtCol := sqlite3_prepare( db, "PRAGMA table_info('" + cTabName + "')" )
      DO WHILE sqlite3_step( stmtCol ) == SQLITE_ROW
         fWrite( nHandleDoc, "| " + sqlite3_column_text( stmtCol, 2 ) + ;
                          " | " + sqlite3_column_text( stmtCol, 3 ) + ;
                          " | " + iif( sqlite3_column_int( stmtCol, 6 ) == 1, "Sim", " " ) + ;
                          " | " + iif( sqlite3_column_int( stmtCol, 4 ) == 1, "Sim", " " ) + " |" + hb_eol() )
      ENDDO
      sqlite3_finalize( stmtCol )

      // 4. Processamento de Índices
      fWrite( nHandleDoc, hb_eol() + "**Índices e Chaves:**" + hb_eol() )
      stmtIdx := sqlite3_prepare( db, "PRAGMA index_list('" + cTabName + "')" )
      lHasIdx := .F.

      DO WHILE sqlite3_step( stmtIdx ) == SQLITE_ROW
         lHasIdx   := .T.
         cIdxName  := sqlite3_column_text( stmtIdx, 2 )
         cIsUnique := iif( sqlite3_column_int( stmtIdx, 3 ) == 1, " (Único)", "" )
         
         // Busca campos que compõem este índice específico
         stmtInfo   := sqlite3_prepare( db, "PRAGMA index_info('" + cIdxName + "')" )
         cCamposIdx := ""
         
         DO WHILE sqlite3_step( stmtInfo ) == SQLITE_ROW
            cCamposIdx += sqlite3_column_text( stmtInfo, 3 ) + ", "
         ENDDO
         sqlite3_finalize( stmtInfo )
         
         IF !Empty(cCamposIdx)
            cCamposIdx := Left( cCamposIdx, Len(cCamposIdx) - 2 )
            fWrite( nHandleDoc, "- **" + cIdxName + "**: `" + cCamposIdx + "`" + cIsUnique + hb_eol() )
         ENDIF
      ENDDO
      
      IF !lHasIdx
         fWrite( nHandleDoc, "> *Nenhum índice definido.*" + hb_eol() )
      ENDIF

      sqlite3_finalize( stmtIdx )
      fWrite( nHandleDoc, hb_eol() + "---" + hb_eol() )
   ENDDO

   sqlite3_finalize( stmt )
   //sqlite3_close( db )
RETURN

#include "fileio.ch"


STATIC PROCEDURE Doc_Access( cMdbFile, nHandleDoc )
   LOCAL oConn, oCat, oTable, oColumn, oIndex, oIdxCol
   LOCAL cConnStr, nType, cSizeStr, cExt, cIdxFields
   LOCAL nTbl, nCol, nIdx, nIdxC // Variáveis para loops numéricos
   
   cExt := Lower( SubStr( cMdbFile, At( ".", cMdbFile ) + 1 ) )
   
   // Define o Provider conforme mdb2dbf.prg
   IF cExt == "mdb"
      cConnStr := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + cMdbFile + ";"
   ELSE
      cConnStr := "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + cMdbFile + ";"
   ENDIF

   TRY
      // Uso de win_oleCreateObject conforme adordd.prg
      oConn := win_oleCreateObject( "ADODB.Connection" )
      oConn:Open( cConnStr )
      
      oCat := win_oleCreateObject( "ADOX.Catalog" )
      oCat:ActiveConnection := oConn
   CATCH
      fWrite( nHandleDoc, hb_StrToUTF8("### ? ")+" Erro: Falha na conexão OLE com " + cMdbFile + hb_eol() )
      RETURN
   END

   // Substituição do FOR EACH por FOR numérico para evitar WINOLE/1005
   FOR nTbl := 0 TO oCat:Tables:Count - 1
      oTable := oCat:Tables:Item( nTbl )
      
      IF AllTrim( Upper( hb_ValToStr( oTable:Type ) ) ) == "TABLE"
      //   fWrite( nHandleDoc, hb_eol() + "#### Tabela (Access): `" + oTable:Name + "`" + hb_eol() )
      // --- ALTERAÇÃO AQUI: Formato ARQUIVO / TABELA ---
         fWrite( nHandleDoc, hb_eol() + hb_StrToUTF8("#### ?? ") + cMdbFile + " / `" + oTable:Name + "`" + hb_eol() )
         fWrite( nHandleDoc, "| Campo | Tipo | Tamanho |" + hb_eol() )
         fWrite( nHandleDoc, "| :--- | :--- | :---: |" + hb_eol() )

         // Loop numérico para Colunas
         FOR nCol := 0 TO oTable:Columns:Count - 1
            oColumn := oTable:Columns:Item( nCol )
            nType := oColumn:Type
            cSizeStr := hb_ValToStr( oColumn:DefinedSize )
            
            IF nType == 203 ; cSizeStr := "Ilimitado" ; ENDIF 
            IF nType == 11  ; cSizeStr := "1 bit"     ; ENDIF 

            fWrite( nHandleDoc, "| " + PadR( hb_ValToStr(oColumn:Name), 25) + ;
                             " | " + PadR( cValToType(nType), 15) + ;
                             " | " + PadR( cSizeStr, 10) + " |" + hb_eol() )
         NEXT

         fWrite( nHandleDoc, hb_eol() + "**Índices:**" + hb_eol() )
         
         IF oTable:Indexes:Count > 0
            // Loop numérico para Índices
            FOR nIdx := 0 TO oTable:Indexes:Count - 1
               oIndex := oTable:Indexes:Item( nIdx )
               cIdxFields := ""
               
               FOR nIdxC := 0 TO oIndex:Columns:Count - 1
                  oIdxCol := oIndex:Columns:Item( nIdxC )
                  cIdxFields += hb_ValToStr( oIdxCol:Name ) + ", "
               NEXT
               
               cIdxFields := Left( cIdxFields, Len(cIdxFields) - 2 )
               fWrite( nHandleDoc, "- **" + hb_ValToStr(oIndex:Name) + "**: `" + cIdxFields + "`" + ;
                                iif( oIndex:Unique, " (Único)", "" ) + hb_eol() )
            NEXT
         ELSE
            fWrite( nHandleDoc, "> *Nenhum índice detectado.*" + hb_eol() )
         ENDIF
         
         fWrite( nHandleDoc, hb_eol() + "---" + hb_eol() )
      ENDIF
   NEXT

   oConn:Close()
RETURN

// Função para traduzir os códigos de tipo ADO
STATIC FUNCTION cValToType( nType )
   LOCAL cRet
   DO CASE
      CASE nType == 202 ; cRet := "Texto"
      CASE nType == 203 ; cRet := "Memo (Longo)"
      CASE nType == 3   ; cRet := "Inteiro Longo"
      CASE nType == 2   ; cRet := "Inteiro"
      CASE nType == 7   ; cRet := "Data/Hora"
      CASE nType == 11  ; cRet := "Logico"
      CASE nType == 6   ; cRet := "Moeda"
      CASE nType == 128 ; cRet := "Binario"
      OTHERWISE         ; cRet := "Outro (" + hb_ValToStr(nType) + ")"
   ENDCASE
RETURN cRet


function apenasinccomp()
strzero()
descend()
return