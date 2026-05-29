#include "common.ch"

REQUEST SL3RDD 

PROCEDURE Main()
   LOCAL cDbFile := "c:\temp\vendas.sqlite"
   LOCAL nTotalGravado := 0

   CLS
   SetMode( 25, 80 )
   
   ? "--- TESTE EXAUSTIVO MULTI-TABELAS (SL3RDD) ---"
   ? "Data do Teste:", Date()
   ? "Banco de Dados:", cDbFile
   ? Replicate("-", 50)

   // -----------------------------------------------------------------
   // 1. ABERTURA DA PRIMEIRA ÁREA: PRODUTOS
   // -----------------------------------------------------------------
   ? "-> Abrindo Area 1 [PRODUTOS]..."
   dbUseArea( .T., "SL3RDD", cDbFile, "PRODUTOS", .T., .F. )
   IF NetErr() .OR. Empty( Alias() )
      ? "!!! ERRO: Nao foi possivel abrir a tabela PRODUTOS"
      RETURN
   ENDIF
   ? "   Area 1 ativa com Sucesso. Alias:", Alias()

   // -----------------------------------------------------------------
   // 2. ABERTURA DA SEGUNDA ÁREA: NOTAFISCALSAIDA (Em outra WorkArea)
   // -----------------------------------------------------------------
   ? "-> Abrindo Area 2 [NOTAFISCALSAIDA] em Nova WorkArea..."
   dbUseArea( .T., "SL3RDD", cDbFile, "NOTAFISCALSAIDA", .T., .F. )
   IF NetErr() .OR. Empty( Alias() )
      ? "!!! ERRO: Nao foi possivel abrir a tabela NOTAFISCALSAIDA"
      dbSelectArea( "PRODUTOS" )
      dbCloseArea()
      RETURN
   ENDIF
   ? "   Area 2 ativa com Sucesso. Alias:", Alias()
   ? Replicate("-", 50)

   // -----------------------------------------------------------------
   // 3. SELEÇÃO E NAVEGAÇÃO ENTRE AS ÁREAS (TRANSFERÊNCIA DE DADOS)
   // -----------------------------------------------------------------
   ? "-> Iniciando loop de transferencia de dados entre tabelas..."
   
   // Iniciamos uma transação global para garantir velocidade máxima no SQLite
 //  NOTAFISCALSAIDA->( dbInfo( 140 ) )

   // Posiciona no primeiro produto
   dbselectar("produtos")
   dbgotop()
  // PRODUTOS->( dbGoTop() )
   
   WHILE ! PRODUTOS->( Eof() )
      
      ? "Lendo de PRODUTOS -> ID Ficticio (RecNo):", PRODUTOS->( RecNo() ), "| Nome:", PRODUTOS->NOME
      
      // Criamos um novo registro na tabela de Nota Fiscal
      NOTAFISCALSAIDA->( dbAppend() )
      
      // Transfere os dados de uma tabela para a outra cruzando as informações
      REPLACE NOTAFISCALSAIDA->NOME  WITH "NF DISPARADA: " + AllTrim( PRODUTOS->NOME )
      REPLACE NOTAFISCALSAIDA->VALOR WITH PRODUTOS->VALOR * 1.10  // Adiciona 10% de imposto fictício
      REPLACE NOTAFISCALSAIDA->DATA  WITH Date()
      REPLACE NOTAFISCALSAIDA->ATIVO WITH .T.
      
      ? "   -> Gravado em NOTAFISCALSAIDA -> Valor com Imposto:", NOTAFISCALSAIDA->VALOR
      nTotalGravado++

      // Avança na tabela de origem (PRODUTOS) para testar se os ponteiros estão isolados
      PRODUTOS->( dbSkip() )
      
   ENDDO

   // Confirma as gravações no banco de dados
   //NOTAFISCALSAIDA->( dbInfo( 141 ) )
   
   ? Replicate("-", 50)
   ? "-> Processo concluido!"
   ? "   Registros transferidos com sucesso:", nTotalGravado
   
   // -----------------------------------------------------------------
   // 4. FECHAMENTO SELETIVO DE ÁREAS
   // -----------------------------------------------------------------
   ? "-> Fechando as tabelas individualmente..."
   
   dbSelectArea( "PRODUTOS" )
   ? "   Fechando Area:", Alias()
   dbCloseArea()

   dbSelectArea( "NOTAFISCALSAIDA" )
   ? "   Fechando Area:", Alias()
   dbCloseArea()

   ? "--- TESTE MULTI-TABELA FINALIZADO COM SUCESSO ---"
   Inkey(0)
RETURN