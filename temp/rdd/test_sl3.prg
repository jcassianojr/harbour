#include "common.ch"

// A REQUEST garante que a RDD autocontida (sqliterdd.prg) seja incluída na linkagem
REQUEST SL3RDD 

PROCEDURE Main()
   LOCAL aStruct := { { "NOME",  "C", 40, 0 }, ;
                      { "DATA",  "D",  8, 0 }, ;
                      { "VALOR", "N", 12, 2 }, ;
                      { "ATIVO", "L",  1, 0 } }
   LOCAL cDbName := "sistema_vendas.db"
   LOCAL nI
   LOCAL cOldName := ""

   CLS
    SetMode( 25, 80 )
   cls
   
   ?
   ? "--- INICIANDO TESTE EXAUSTIVO DA SL3RDD (AUTOCONTIDA) ---"
   ? "Data do Teste:", Date()
   ? "Motor: SQLite3 incorporado no PRG"
   ? Replicate("-", 50)

   // 1. TESTE DE CRIAÇÃO (UR_CREATE)
   ? "1. Criando tabela com dbCreate()..."
   dbCreate( cDbName, aStruct, "SL3RDD" )
   
   // 2. TESTE DE ABERTURA (UR_OPEN / UR_INIT)
   USE (cDbName) VIA "SL3RDD" ALIAS VENDAS NEW
   IF NetErr()
      ? "!!! ERRO CRITICO: Nao foi possivel abrir a tabela."
      RETURN
   ENDIF
   ? "   Tabela aberta com sucesso. Alias:", Alias()

   // 3. TESTE DE TRANSAÇÕES E APPEND (UR_TRANSBEGIN / UR_APPEND / UR_PUTVALUE)
   ? "2. Testando Transacoes e dbAppend()..."
   
   // No Harbour puro, chamamos o slot de transação diretamente na WorkArea atual via dbInfo()
   // UR_I_COMMIT e associados controlam isso, ou enviamos via dbInfo se necessário.
   // Para simplificar e rodar direto no seu slot 140/141/142 criado na USRRDD:
   
   dbInfo( 140 ) // Dispara o seu SL3_TRANSBEGIN()
   FOR nI := 1 TO 10
      dbAppend()
      REPLACE VENDAS->NOME  WITH "CLIENTE EXEMPLO " + StrZero( nI, 3 )
      REPLACE VENDAS->DATA  WITH Date() - nI
      REPLACE VENDAS->VALOR WITH 1500.50 * nI
      REPLACE VENDAS->ATIVO WITH ( nI % 2 == 0 )
      ?? "."
   NEXT
   dbInfo( 141 ) // Dispara o seu SL3_TRANSCOMMIT()
   ? "   10 registros inseridos com sucesso."

   // 4. TESTE DE NAVEGAÇÃO E RECNO (UR_GOTOP / UR_SKIP / UR_RECNO / UR_EOF)
   ? "3. Testando Navegacao (dbGoTop / dbSkip)..."
   dbGoTop()
   ? "   Topo (RecNo):", RecNo(), "| Nome:", VENDAS->NOME
   
   dbSkip( 5 )
   ? "   Skip 5 (RecNo):", RecNo(), "| Nome:", VENDAS->NOME

   // 5. TESTE DE BUSCA (UR_SEEK / UR_FOUND)
   ? "4. Testando dbSeek (Simulado)..."
   dbSeek( "CLIENTE EXEMPLO 005" )
   IF Found()
      ? "   Encontrado! Valor:", VENDAS->VALOR
   ELSE
      ? "   Aviso: Seek nao retornou resultado (verificar implementacao de busca)."
   ENDIF

   // 6. TESTE DE DELEÇÃO (UR_DELETE / UR_DELETED)
   ? "5. Testando Delecao Logica (dbDelete)..."
   dbGoto( 2 )
   dbDelete()
   IF Deleted()
      ? "   Registro 2 marcado como deletado com sucesso."
   ENDIF

   // 7. TESTE DE CONTAGEM E POSICIONAMENTO (UR_RECCOUNT / UR_GOBOTTOM)
   ? "6. Testando dbGoBottom e LastRec()..."
   dbGoBottom()
   ? "   Fim (RecNo):", RecNo(), "| Total registros (LastRec):", LastRec()

   // 8. TESTE DE FILTRAGEM DE TRANSAÇÃO (ROLLBACK)
   ? "7. Testando Rollback (Abortando alteracao)..."
   dbInfo( 140 ) // Começa transação
      dbGoto( 5 )
      cOldName := VENDAS->NOME
      REPLACE VENDAS->NOME WITH "NOME PARA CANCELAR"
      ? "   Nome alterado temporariamente:", VENDAS->NOME
   dbInfo( 142 ) // Dispara o seu SL3_TRANSROLLBACK()
   
   dbGoto( 5 )
   ? "   Nome apos Rollback (deve ser o original):", VENDAS->NOME

   // 9. FECHAMENTO (UR_CLOSE)
   ? Replicate("-", 50)
   dbCloseAll()
   ? "Teste finalizado com sucesso. Ficheiro", cDbName, "gerado."
   ?
   ? "Pressione qualquer tecla..."
   Inkey(0)

RETURN