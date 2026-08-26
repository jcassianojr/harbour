#include "hbclass.ch"

REQUEST DBFCDX
REQUEST SL3RDD
REQUEST ADSADT

PROCEDURE Main()
   setmode(25,80)
   CLS
   ? "========================================================"
   ? "          TESTE DE ABERTURA COM A FUNCAO NETUSE         "
   ? "========================================================"
   ?

   // Registra as RDDs necessárias
   RddSetDefault( "DBFCDX" )
   
   // -------------------------------------------------------------------------
   // TESTE 1: Abrindo o arquivo tradicional DBF (cartaobandeira.dbf)
   // -------------------------------------------------------------------------
   ? "[TESTE 1] Tentando abrir: cartaobandeira.dbf"
   altd()
   
   // A função netuse aceita o nome sem extensão ou com extensão
   IF netuse( "cartaobandeira", "DBFCDX", .T., .T. )  // Compartilhado (.T.), Somente Leitura (.T.)
      ? " -> Sucesso! Arquivo 'cartaobandeira.dbf' aberto com o alias: ", Alias()
      ? " -> Total de registros (LastRec):", LastRec()
      
      // Fecha a área atual
      DbCloseArea()
      ? " -> Área fechada com sucesso."
   ELSE
      ? " -> FALHA ao abrir 'cartaobandeira.dbf'."
   ENDIF

   ? "--------------------------------------------------------"

   // -------------------------------------------------------------------------
   // TESTE 2: Abrindo tabela SQLite via netuse com a sintaxe de conexão (:)
   // Caminho: fiscal.sqlite contendo a tabela cartaobandeira
   // Conforme a netuse() no netdbf.prg:
   //   cDriver == "SL3RDD" trata string com dois pontos (:) dividindo caminho e tabela.
   // -------------------------------------------------------------------------
   ? "[TESTE 2] Tentando abrir SQLite: fiscal.sqlite:cartaobandeira"

   // Passamos "fiscal.sqlite:cartaobandeira". O driver SL3RDD e a netuse 
   // vão automaticamente conectar no banco 'fiscal.sqlite' e abrir a tabela 'cartaobandeira'.
   IF netuse( "fiscal.sqlite:cartaobandeira", "SL3RDD", .T., .T. )
      ? " -> Sucesso! Tabela SQLite aberta com o alias: ", Alias()
      ? " -> Total de registros na tabela:", LastRec() // ou recount equivalente na RDD
      
      // Fecha a área atual (e a conexão se gerenciada pelo driver)
      DbCloseArea()
      ? " -> Área SQLite fechada com sucesso."
   ELSE
      ? " -> FALHA ao abrir a tabela no SQLite 'fiscal.sqlite:cartaobandeira'."
      ? "    Verifique se o arquivo 'fiscal.sqlite' existe e se a tabela 'cartaobandeira' foi criada nele."
   ENDIF
   
   
   RddSetDefault( "ADSADT" )
   // -------------------------------------------------------------------------
   // TESTE3: Abrindo o arquivo ADT (animals.adt)
   // -------------------------------------------------------------------------
   ? "[TESTE ADT] Tentando abrir: animals.adt"
   
   // A função netuse(cARQ, cDRIVER, lSHA, lREAD, lNEW, lINDEX, nTIME, lOPENCON)
   // Como o arquivo é .adt, a netuse deve identificar automaticamente o driver ADSADT 
   // pelo valor retornado de hb_rddInfo( RDDI_TABLEEXT ) ou podemos forçar o driver "ADSADT".
   
   IF netuse( "animals", "ADSADT", .T., .T. )  // Compartilhado (.T.), Somente Leitura (.T.)
      ? " -> Sucesso! Arquivo 'animals.adt' aberto com o alias: ", Alias()
      ? " -> Total de registros (LastRec):", LastRec()
      
      // Fecha a área atual
      DbCloseArea()
      ? " -> Área ADT fechada com sucesso."
   ELSE
      ? " -> FALHA ao abrir 'animals.adt'."
      ? "    Verifique se o arquivo 'animals.adt' existe no diretório de trabalho"
      ? "    e se o driver ADSADT está linkado corretamente no projeto."
   ENDIF

   ? "========================================================"
   ? "Fim dos testes."
   WAIT
RETURN


function MDS()
return  nil
function        ALERTX()
return  nil
function         MDG()
return  nil
function          STRLOGIC()
return  nil