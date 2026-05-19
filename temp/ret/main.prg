/*
 * Main.prg - Programa de varredura em lote e teste automatizado de arquivos .RET
 */

PROCEDURE Main()
    LOCAL aArquivos := Directory( "*.ret" ) // Faz uma busca de todos os .ret na pasta local
    LOCAL nI, nP
    LOCAL cNomeRet := ""
    LOCAL cNomeRtfOut := ""
    LOCAL aMetadadosParams := {}
    LOCAL hValoresParametros := {=>}

    CLS
    ? "=========================================================="
    ? "   MOTOR AUTOMATICO DE VARREDURA E PROCESSAMENTO (.RET)   "
    ? "=========================================================="
    ? " Data do Processamento: " + DToC( Date() )
    ? "----------------------------------------------------------"

    IF Len( aArquivos ) == 0
        ? "[AVISO] Nenhum arquivo .RET encontrado na pasta corrente."
        ? "Copie os arquivos de relatorios antigos para esta pasta para testar."
        ? "=========================================================="
        RETURN
    ENDIF

    ? "Encontrado(s) " + AllTrim(Str(Len(aArquivos))) + " arquivo(s) para conversao."
    ? "----------------------------------------------------------"
    ? ""

    // LOOP PRINCIPAL DOS ARQUIVOS ENCONTRADOS
    FOR nI := 1 TO Len( aArquivos )
        cNomeRet := aArquivos[nI][1] // Pega o nome do arquivo (ex: "ita00005.ret")
        cNomeRtfOut := StrTran( Lower(cNomeRet), ".ret", ".rtf" ) // Define o nome da saída

        ? ">>> [" + AllTrim(Str(nI)) + "/" + AllTrim(Str(Len(aArquivos))) + "] Lendo Relatorio: " + cNomeRet
        
        // 1. Extração dinâmica dos parâmetros exigidos pelo arquivo atual
        aMetadadosParams := ObterParametrosDoRet( cNomeRet )
        hValoresParametros := {=>} // Limpa a hash para o novo relatório

        IF Len( aMetadadosParams ) > 0
            ? "   Mapeando " + AllTrim(Str(Len(aMetadadosParams))) + " parametro(s) de entrada:"
            
            // Alimenta a Hash dinamicamente baseado no metadado do .ret
            FOR nP := 1 TO Len( aMetadadosParams )
                ? "      -> Nome: " + PadR(aMetadadosParams[nP][1], 15) + " Tipo: " + aMetadadosParams[nP][3] + " Prompt: " + aMetadadosParams[nP][2]
                
                // Atribuição de valores simulados inteligentes para o teste não travar
                IF aMetadadosParams[nP][3] == "D"
                    hValoresParametros[ aMetadadosParams[nP][1] ] := CToD("15/07/1998") // Filtro de data padrão de teste
                ELSEIF aMetadadosParams[nP][2] == "N"
                    hValoresParametros[ aMetadadosParams[nP][1] ] := Val( aMetadadosParams[nP][4] )
                ELSE
                    // Tratamento genérico para números de notas ou códigos iniciais/finais comuns
                    IF "NUMERO" $ Upper(aMetadadosParams[nP][2]) .OR. "ATE" $ Upper(aMetadadosParams[nP][2]) .OR. "AO" $ Upper(aMetadadosParams[nP][2])
                        hValoresParametros[ aMetadadosParams[nP][1] ] := 99999999
                    ELSEIF "DO" $ Upper(aMetadadosParams[nP][2]) .OR. "DE" $ Upper(aMetadadosParams[nP][2])
                        hValoresParametros[ aMetadadosParams[nP][1] ] := 1
                    ELSE
                        hValoresParametros[ aMetadadosParams[nP][1] ] := aMetadadosParams[nP][4] // Usa o default nativo do .ret
                    ENDIF
                ENDIF
            NEXT
        ELSE
            ? "   [INFO] Este relatorio nao requer parametros externos."
        ENDIF

        // 2. Executa o parser para gerar o arquivo final .rtf correspondente
        IF ExecutarParserRetLocal( cNomeRet, cNomeRtfOut, hValoresParametros )
            ? "   [SUCESSO] Gerado com exito -> " + cNomeRtfOut
        ELSE
            ? "   [FALHA] Nao foi possivel converter o arquivo " + cNomeRet
        ENDIF
        ? "----------------------------------------------------------"
    NEXT

    ? ""
    ? "=========================================================="
    ? " Processamento em lote finalizado!"
    ? "=========================================================="
RETURN