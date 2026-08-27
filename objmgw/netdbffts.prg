// +--------------------------------------------------------------------
// +
// +    Programa  : netdbf.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024-2026,  jcassiano
// + 1. DbGetRec() — Lê o registro atual para um Array
// + 2. DbPutRec( aRegistro ) — Grava um Array de volta no Registro
// + 3.HB_RecToStr() Converte o registro todo para string
// +
// +--------------------------------------------------------------------

//hs := hs_Index( cFile, cExpr, nKeySize, nOpenMode, nBufSize, lCase, nFiltSet )
//hs := hs_Create( cFile, nBufSize, nKeySize, lCase, nFiltSet, xExpr )

#include "INKEY.CH"
#include "try.ch"
#include "fileio.ch"
#include "dbstruct.ch"
#include "dbinfo.ch"

/**
 * Função FTS em Harbour abrindo o DBF diretamente pelo caminho (FOPEN/FSEEK)
 * 
 * Parâmetros:
 *  - cCaminhoDbf : Caminho completo ou relativo do arquivo .dbf
 *  - cTermoBusca : Termo textual a ser buscado (obrigatório)
 *  - cRegExp     : Expressão regular opcional para validação avançada (opcional)
 * 
 * Retorno:
 *  - Array com os recnos encontrados: { { string_formatada, recno }, ... }
 */
FUNCTION FtsBuscaPorArquivo( cCaminhoDbf, cTermoBusca, cRegExp )
    LOCAL pHandle
    LOCAL cRecord
    LOCAL nRecno
    LOCAL aRetu := {}
    LOCAL nLastRec
    LOCAL nHeader, nRecSize
    LOCAL cAliasTemp := "FTS_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
    LOCAL cTermoUpper
    LOCAL lTemRegex := !Empty( cRegExp )

    IF Empty( cCaminhoDbf ) .OR. !File( cCaminhoDbf )
        RETURN aRetu
    ENDIF

    IF Empty( cTermoBusca ) .AND. !lTemRegex
        RETURN aRetu
    ENDIF

    // Abre a tabela temporariamente apenas para extrair metadados estruturais (Header, RecSize, LastRec)
    // de forma segura sem precisar calcular manualmente os bytes do cabeçalho do DBF.
    RddSetDefault( "DBFCDX" )
    IF !DbUseArea( .T., "DBFCDX", cCaminhoDbf, cAliasTemp, .T., .T. )
        RETURN aRetu
    ENDIF

    nLastRec  := (cAliasTemp)->( LastRec() )
   nHeader   := (cAliasTemp)->( DbInfo( DBI_GETHEADERSIZE ) )
    nRecSize  := (cAliasTemp)->( DbInfo( DBI_GETRECSIZE ) )
    // Fecha o alias estrutural, pois agora faremos a leitura via baixo nível (FOPEN)
    (cAliasTemp)->( DbCloseArea() )


    // Abre o arquivo fisicamente em modo de leitura compartilhada de baixo nível
    pHandle := FOpen( cCaminhoDbf, FO_READ + FO_SHARED )
    
    IF FError() != 0 .OR. pHandle == NIL
        RETURN aRetu
    ENDIF

    cTermoUpper := Upper( AllTrim( cTermoBusca ) )

    // Varredura registro a registro usando o ponteiro físico do arquivo
    FOR nRecno := 1 TO nLastRec
        
        // Posiciona o ponteiro do arquivo exatamente no início do registro atual
        FSeek( pHandle, nHeader + ( ( nRecno - 1 ) * nRecSize ), FS_SET )
        
        // Lê os bytes brutos do registro
        cRecord := FReadStr( pHandle, nRecSize )

        IF Empty( cRecord )
            LOOP
        ENDIF

        // 1º Filtro: Verifica o termo textual básico (se informado)
        IF !Empty( cTermoBusca )
            IF !( cTermoUpper $ Upper( cRecord ) )
                LOOP // Se não achou o termo, pula para o próximo
            ENDIF
        ENDIF

        // 2º Filtro: Se houver Regex, valida o padrão na string do registro
        IF lTemRegex
            // hb_RegEx valida a expressão regular contra o registro bruto
            IF !hb_RegEx( cRegExp, cRecord )
                LOOP // Se não bateu com a regex, pula
            ENDIF
        ENDIF

        // Se passou por todas as validações, adiciona ao array de retorno
        // Formato: { "RECNO_FORMATADO-CONTEUDO", numero_do_recno }
        AAdd( aRetu, { StrZero( nRecno, 8 ) + "-" + cRecord, nRecno } )

    NEXT

    // Fecha o handle de baixo nível do arquivo
    FClose( pHandle )

RETURN aRetu 
 
   
/**
 * Função de FTS (Full-Text Search) para DBF em Harbour por registro
 * 
 * Parâmetros:
 *  - cArquivoDbf : Caminho do arquivo .dbf
 *  - cTermoBusca : Termo textual a ser buscado (obrigatório)
 *  - cRegExp     : Expressão regular opcional para refinar a busca
 * 
 * Retorno:
 *  - Array com os RECNO() encontrados
 */
FUNCTION FtsBuscaDbf( cArquivoDbf, cTermoBusca, cRegExp )
    LOCAL cAlias := "FTS_ALIAS_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
    LOCAL aRecnos := {}
    LOCAL cRegistroStr
    LOCAL cTermoUpper
    LOCAL lTemRegex := !Empty( cRegExp )

    // Valida se o arquivo existe
    IF !File( cArquivoDbf )
        RETURN aRecnos
    ENDIF

    // Abre a tabela em modo compartilhado e somente leitura para segurança
    IF !DbUseArea( .T., "DBFCDX", cArquivoDbf, cAlias, .T., .T. )
        RETURN aRecnos
    ENDIF

    // Pré-processamentos para ganho de performance no loop
    cTermoUpper := Upper( AllTrim( cTermoBusca ) )

    (cAlias)->( DbGoTop() )

    WHILE !(cAlias)->( EoF() )
        // Converte o registro inteiro em string
        cRegistroStr := (cAlias)->( RecToStr() )

        // 1º Passo: Verifica se o termo textual existe (caso o termo não esteja vazio)
        IF Empty( cTermoBusca ) .OR. ( cTermoUpper $ Upper( cRegistroStr ) )
            
            // 2º Passo: Se houver Regex, valida o padrão na string do registro
            IF lTemRegex
                // hb_RegEx aceita a regex e a string alvo (case-sensitive por padrão, 
                // use hb_RegExCase se quiser ignorar case na regex)
                IF hb_RegEx( cRegExp, cRegistroStr )
                    AAdd( aRecnos, (cAlias)->( RecNo() ) )
                ENDIF
            ELSE
                // Se passou no termo e não tem regex, adiciona o recno
                AAdd( aRecnos, (cAlias)->( RecNo() ) )
            ENDIF

        ENDIF

        (cAlias)->( DbSkip() )
    ENDDO

    // Fecha a área de trabalho aberta internamente
    (cAlias)->( DbCloseArea() )

RETURN aRecnos

FUNCTION FilterFtsBusca(cTermoBusca, cRegExp )
IF EMPTY(cRegExp)
   cExprFiltro := '{ || "' + cTermoBusca + '" $ Upper(RecToStr()) }'
ELSE
   cExprFiltro := '{ || "' + cTermoBusca + '" $ Upper(RecToStr()) .AND. hb_RegEx("' + cRegex + '", RecToStr()) }'

ENDIF   
DBSETFILTER( &(cExprFiltro), cExprFiltro )

FUNCTION RecToStr()
    LOCAL cStr := ""
    LOCAL i
    
    FOR i := 1 TO FCount()
        // Converte qualquer tipo de dado (String, Número, Data, Lógico) para texto
        cStr += hb_ValToStr( FieldGet( i ) ) + " "
    NEXT
    
RETURN cStr

/*
 * ftshsx: Wrapper function usando o motor nativo HiPer-SEEK (.hsx) do Harbour
 * 
 * Parâmetros:
 *  - cDbfFile   : Caminho do arquivo .dbf
 *  - cTermoBusca: Termo textual a ser buscado
 *  - cKeyExpr   : Expressão de chave (opcional: se vazia, indexa a linha inteira de campos)
 *  - lRecriar   : Se .T. (padrão), apaga e recria o .hsx para evitar dados antigos/misturados
 * 
 * Retorno:
 *  - Array com os recnos encontrados: { recno1, recno2, ... }
 */
FUNCTION ftshsx( cDbfFile, cTermoBusca, cKeyExpr, lRecriar )
   LOCAL hs
   LOCAL nRec
   LOCAL aRetu := {}
   LOCAL cHsxPath
   LOCAL cRddAnterior
   LOCAL xExprIndex := NIL
   LOCAL cAliasTemp
   LOCAL i

   // 1. Guarda o RDD atual e define o padrão para RMDBFCDX
   cRddAnterior := rddDefault()
   rddSetDefault( "RMDBFCDX" )

   // Define o valor padrão de lRecriar como .T.
   IF ValType( lRecriar ) # "L"
      lRecriar := .T.
   ENDIF

   // Validações básicas
   IF Empty( cDbfFile ) .OR. !File( cDbfFile )
      rddSetDefault( cRddAnterior )
      RETURN aRetu
   ENDIF

   cHsxPath := cDbfFile + ".hsx"

   // Se solicitado recriar e o índice já existir, apaga-o
   IF lRecriar .AND. File( cHsxPath )
      FErase( cHsxPath )
   ENDIF

   // 2. Define a expressão de índice (Se não informada, cria o CodeBlock unificando todos os campos)
   IF !Empty( cKeyExpr )
      xExprIndex := cKeyExpr
   ELSE
      // Se não passou expressão, abrimos temporariamente para estruturar o CodeBlock de linha inteira
      cAliasTemp := "FTS_EXPR_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
      IF DbUseArea( .T., "DBFCDX", cDbfFile, cAliasTemp, .T., .T. )
         
         // Cria dinamicamente um CodeBlock que simula a união de todos os campos (RecToStr)
         xExprIndex := { || 
            Local cStr := "", _i
            For _i := 1 TO FCount()
               cStr += hb_ValToStr( FieldGet( _i ) ) + " "
            Next
            Return cStr
         }

         (cAliasTemp)->( DbCloseArea() )
      ENDIF
   ENDIF

   // 3. Abre ou Cria o índice HiPer-SEEK usando a chave avaliada (String ou CodeBlock)
   IF File( cHsxPath )
      hs := hs_Open( cDbfFile, , 2 ) // Abre em modo compartilhado/leitura
   ELSE
      // Passa a expressão (seja string ou o codeblock gerado) para o hs_Index nativo
      hs := hs_Index( cDbfFile, xExprIndex, 2, 2, , .T., 3 )
   ENDIF

   IF hs < 0
      rddSetDefault( cRddAnterior )
      RETURN aRetu
   ENDIF

   // 4. Configura o termo de busca no motor HSX e executa
   IF hs_Set( hs, cTermoBusca ) >= 0
      WHILE ( nRec := hs_Next( hs ) ) > 0
         IF hs_Verify( hs ) > 0
            AAdd( aRetu, nRec )
         ENDIF
      ENDDO
   ENDIF

   // 5. Fecha o manipulador do índice
   hs_Close( hs )

   // 6. Restaura o RDD original
   rddSetDefault( cRddAnterior )

RETURN aRetu

// + EOF: netdbf.prg