/*
 * WRTParser.prg - Motor com SET FILTER Dinâmico via Macrosubstituição (&)
 */

#include "fileio.ch"

FUNCTION ExecutarParserRetLocal( cFileRet, cFileOut, hParams )
    LOCAL cConteudo := MemoRead( cFileRet )
    LOCAL cHeaderRTF, cPHD, cGHD, cBDY, cGFT, cPFT
    LOCAL cGroupField := ""
    LOCAL cLastGroupValue := "___INIT___"
    LOCAL cCurrentGroupValue := ""
    LOCAL cRTFFinal := ""
    LOCAL aCampos := {}
    LOCAL aTabelas := {}
    LOCAL nX, nPosSect, cTabelaLocal

    IF Empty( cConteudo )
        ? "   [ERRO] Arquivo '" + cFileRet + "' nao foi encontrado."
        RETURN .F.
    ENDIF

    // 1. ISOLAR O CABEÇALHO PADRÃO DO RTF
    nPosSect := At( "\sectd \linex0 \pard", cConteudo )
    IF nPosSect == 0
        ? "   [ERRO] Estrutura RTF invalida."
        RETURN .F.
    ENDIF
    cHeaderRTF := SubStr( cConteudo, 1, nPosSect + 17 )

    // 2. EXTRAIR AS SEÇÕES VISUAIS
    cPHD := ExtrairSecaoRet( cConteudo, "{\PHD" )
    cGHD := ExtrairSecaoRet( cConteudo, "{\GHD" )
    cBDY := ExtrairSecaoRet( cConteudo, "{\BDY" )
    cGFT := ExtrairSecaoRet( cConteudo, "{\GFT" )
    cPFT := ExtrairSecaoRet( cConteudo, "{\PFT" )

    // 3. DETECTAR SE O RELATÓRIO TEM GRUPO
    IF !Empty( cGHD )
        LOCAL nPosGrp := At( "{\grpvbllst ", cGHD )
        IF nPosGrp > 0
            cGroupField := SubStr( cGHD, nPosGrp + 12 )
            cGroupField := SubStr( cGroupField, 1, At( "}", cGroupField ) - 1 )
            cGroupField := AllTrim( cGroupField )
            ? "   [INFO] Tipo de Layout: Colunar (Grupo por: " + cGroupField + ")"
        ENDIF
    ELSE
        ? "   [INFO] Tipo de Layout: Formulario / Ficha Simples"
    ENDIF

    // 4. ABERTURA DAS TABELAS LOCALMENTE
    aTabelas := MapearTabelasDoRet( cConteudo )
    IF Len( aTabelas ) == 0
        RETURN .F.
    ENDIF

    CLOSE DATABASES

    FOR nX := 1 TO Len( aTabelas )
        cTabelaLocal := aTabelas[nX]
        IF !File( cTabelaLocal + ".DBF" )
            ? "   [ERRO CRITICO] Arquivo local '" + cTabelaLocal + ".DBF' nao encontrado."
            RETURN .F.
        ENDIF
        
        IF nX == 1
            USE (cTabelaLocal) NEW SHARED VIA "DBFCDX"
        ELSE
            USE (cTabelaLocal) NEW SHARED VIA "DBFCDX" ALIAS (cTabelaLocal + "_LINK")
        ENDIF
    NEXT

    // 5. [NOVO] APLICAR O SET FILTER DINÂMICO BASEADO NOS PARÂMETROS
    // Descobre quais campos estão associados aos parâmetros e aplica o filtro antes do loop
    AplicarFiltroDinamico( cConteudo, hParams )

    // Verifica quantos registros restaram após o filtro
    COUNT TO nRegFiltro
    GO TOP
    ? "   [FILTRO] " + AllTrim(Str(nRegFiltro)) + " registro(s) encontrados para o filtro aplicado."

    IF nRegFiltro == 0
        ? "   [AVISO] O relatorio sera gerado em branco (Filtro nao retornou dados)."
    ENDIF

    // 6. MAPEIA OS CAMPOS E MONTA O RTF
    aCampos := MapearCamposDoRet( cConteudo )
    cRTFFinal := cHeaderRTF + Chr(13)+Chr(10)
    cRTFFinal += ProcessarMacrosDinamicas( cPHD, aCampos, hParams )

    // LOOP DE IMPRESSÃO - RODA CASO RETORNE MAIS DE UM REGISTRO (COLUNAR)
    DO WHILE !Eof()
        
        // Controle de quebra de grupo (Relatórios Colunares)
        IF !Empty( cGroupField )
            cCurrentGroupValue := cValToChar( FieldGet( FieldPos( cGroupField ) ) )
            
            IF cCurrentGroupValue != cLastGroupValue
                IF cLastGroupValue != "___INIT___" .AND. !Empty( cGFT )
                    cRTFFinal += ProcessarMacrosDinamicas( cGFT, aCampos, hParams )
                ENDIF
                
                IF !Empty( cGHD )
                    cRTFFinal += ProcessarMacrosDinamicas( cGHD, aCampos, hParams )
                ENDIF
                cLastGroupValue := cCurrentGroupValue
            ENDIF
        ENDIF

        // Imprime o detalhe (Se colunar, acumula várias linhas. Se formulário, acumula fichas)
        cRTFFinal += ProcessarMacrosDinamicas( cBDY, aCampos, hParams )

        // Se for Tipo Formulário puro, quebra uma página por registro
        IF Empty( cGroupField )
            cRTFFinal += "\page "
        ENDIF

        SKIP
    ENDDO

    // Fechamentos finais do relatório
    IF !Empty( cGroupField ) .AND. !Empty( cGFT )
        cRTFFinal += ProcessarMacrosDinamicas( cGFT, aCampos, hParams )
    ENDIF

    IF !Empty( cPFT )
        cRTFFinal += ProcessarMacrosDinamicas( cPFT, aCampos, hParams )
    ENDIF

    cRTFFinal += "}"
    MemoWrit( cFileOut, cRTFFinal )
    CLOSE DATABASES
RETURN .T.


// ============================================================================
// LÓGICA DO SET FILTER DINÂMICO VIA MACRO (&)
// ============================================================================
STATIC PROCEDURE AplicarFiltroDinamico( cConteudo, hParams )
    LOCAL nPosQry := At( "{\*\vrwqry", cConteudo )
    LOCAL cBlocoQry := ""
    LOCAL cFiltroFinal := ""
    LOCAL nPosCnd, cTrechoCnd, aLinha, cCampo, cOpCode, cParam, cCondicaoHarbour
    LOCAL aChaves := HB_HKeys( hParams )

    IF nPosQry == 0 .OR. Len( aChaves ) == 0
        RETURN
    ENDIF

    // Isola o bloco de condições
    cBlocoQry := SubStr( cConteudo, nPosQry, At( "{\*\qryord", cConteudo ) - nPosQry )
    
    // Varre o bloco procurando as tags {\*\qrycnd ...}
    nPosCnd := At( "{\*\qrycnd ", cBlocoQry )
    DO WHILE nPosCnd > 0
        cTrechoCnd := SubStr( cBlocoQry, nPosCnd + 11 )
        cTrechoCnd := SubStr( cTrechoCnd, 1, At( "}", cTrechoCnd ) - 1 )
        
        // Divide os elementos da condição por espaços
        // Exemplo: "CONDITION1 TABLE1 DATAFAT 5 _parameter1 0"
        aLinha := hb_ATokens( cTrechoCnd, " " )
        
        IF Len( aLinha ) >= 5
            cCampo := Upper( AllTrim( aLinha[3] ) )  // Ex: "DATAFAT"
            cOpCode := AllTrim( aLinha[4] )         // Ex: "5"
            cParam := AllTrim( aLinha[5] )          // Ex: "_parameter1"

            // Se o parâmetro extraído foi enviado na chamada do relatório, montamos o filtro
            IF HB_HHasKey( hParams, cParam )
                cCondicaoHarbour := ""
                
                // Tradução dos códigos de operadores do Caret Report Writer para Harbour
                DO CASE
                    CASE cOpCode == "1" ; cOpCode := "==" // Igual
                    CASE cOpCode == "2" ; cOpCode := "!=" // Diferente
                    CASE cOpCode == "3" ; cOpCode := "<=" // Menor ou Igual
                    CASE cOpCode == "4" ; cOpCode := "<"  // Menor
                    CASE cOpCode == "5" ; cOpCode := ">=" // Maior ou Igual
                    CASE cOpCode == "6" ; cOpCode := ">"  // Maior
                    OTHERWISE           ; cOpCode := "=="
                ENDCASE

                // Verifica o tipo do dado para montar a string do filtro corretamente
                IF ValType( hParams[cParam] ) == "D"
                    // Filtro de Data: Campo >= CToD('15/07/1998')
                    cCondicaoHarbour := cCampo + " " + cOpCode + " CToD('" + DToC(hParams[cParam]) + "')"
                ELSEIF ValType( hParams[cParam] ) == "N"
                    // Filtro Numérico: Campo >= 100
                    cCondicaoHarbour := cCampo + " " + cOpCode + " " + AllTrim(Str(hParams[cParam]))
                ELSE
                    // Filtro de Texto: Campo == 'VALOR'
                    cCondicaoHarbour := cCampo + " " + cOpCode + " '" + AllTrim(hParams[cParam]) + "'"
                ENDIF

                // Junta as condições com .AND.
                IF !Empty( cFiltroFinal )
                    cFiltroFinal += " .AND. " + cCondicaoHarbour
                ELSE
                    cFiltroFinal := cCondicaoHarbour
                ENDIF
            ENDIF
        ENDIF

        cBlocoQry := SubStr( cBlocoQry, nPosCnd + 11 + Len(cTrechoCnd) )
        nPosCnd := At( "{\*\qrycnd ", cBlocoQry )
    ENDDO

    // Se uma string de filtro válida foi construída, aplica via Macrosubstituição
    IF !Empty( cFiltroFinal )
        ? "   [FILTRO] SET FILTER TO " + cFiltroFinal
        SET FILTER TO &cFiltroFinal
    ENDIF
RETURN


// ============================================================================
// FUNÇÕES DE EXTRAÇÃO DE METADADOS (MANTIDAS)
// ============================================================================
FUNCTION ObterParametrosDoRet( cFileRet )
    LOCAL cConteudo := MemoRead( cFileRet )
    LOCAL nPosVar := At( "{\*\vrwvar", cConteudo )
    LOCAL cBlocoVars := ""
    LOCAL aParametros := {} 
    LOCAL nPosPrm, cTrechoVar, cNome, cLabel, cTipo, cDefault, nStartVar

    IF nPosVar == 0 .OR. Empty( cConteudo )
        RETURN aParametros
    ENDIF

    cBlocoVars := SubStr( cConteudo, nPosVar, At( "{\*\vrwqry", cConteudo ) - nPosVar )
    nPosPrm := At( "\prm", cBlocoVars )
    
    DO WHILE nPosPrm > 0
        nStartVar := RAt( "{\v", SubStr( cBlocoVars, 1, nPosPrm ) )
        IF nStartVar > 0
            cTrechoVar := SubStr( cBlocoVars, nStartVar, nPosPrm - nStartVar + 10 )
            cNome := SubStr( cTrechoVar, At( " ", cTrechoVar ) + 1 )
            cNome := SubStr( cNome, 1, At( "\", cNome ) - 1 )
            cNome := AllTrim( cNome )

            IF "\colnam " $ cTrechoVar
                cLabel := SubStr( cTrechoVar, At( "\colnam ", cTrechoVar ) + 8 )
                IF "{" $ cLabel .AND. At( "{", cLabel ) < At( "\", cLabel )
                    cLabel := SubStr( cLabel, 1, At( "{", cLabel ) - 1 )
                ELSE
                    cLabel := SubStr( cLabel, 1, At( "\", cLabel ) - 1 )
                ENDIF
                cLabel := AllTrim( cLabel )
            ELSE
                cLabel := cNome
            ENDIF

            IF "\dat" $ cTrechoVar
                cTipo := "D" 
            ELSEIF "\txt" $ cTrechoVar
                cTipo := "C" 
            ELSE
                cTipo := "N" 
            ENDIF

            cDefault := ""
            IF "\dftprm " $ cTrechoVar
                cDefault := SubStr( cTrechoVar, At( "\dftprm ", cTrechoVar ) + 8 )
                cDefault := SubStr( cDefault, 1, At( "}", cDefault ) - 1 )
                cDefault := AllTrim( cDefault )
            ENDIF

            AAdd( aParametros, { cNome, cLabel, cTipo, cDefault } )
        ENDIF

        cBlocoVars := SubStr( cBlocoVars, nPosPrm + 4 )
        nPosPrm := At( "\prm", cBlocoVars )
    ENDDO
RETURN aParametros

STATIC FUNCTION ExtrairSecaoRet( cConteudo, cTag )
    LOCAL nStart := At( cTag, cConteudo )
    LOCAL nEnd, cTrecho := ""
    IF nStart > 0
        nEnd := At( "{\*\vrwsct", SubStr( cConteudo, nStart + 10 ) )
        IF nEnd > 0
            cTrecho := SubStr( cConteudo, nStart, nEnd + 10 )
        ELSE
            cTrecho := SubStr( cConteudo, nStart )
        ENDIF
        LOCAL nPosFecha := At( "}", cTrecho )
        cTrecho := SubStr( cTrecho, nPosFecha + 1 )
    ENDIF
RETURN cTrecho

STATIC FUNCTION MapearTabelasDoRet( cConteudo )
    LOCAL aTabLocal := {}
    LOCAL nPosQry := At( "{\*\vrwqry", cConteudo )
    LOCAL cBlocoQry := ""
    LOCAL nPosT, cSub, cPathCompleto, cNomeDbf
    IF nPosQry > 0
        cBlocoQry := SubStr( cConteudo, nPosQry, At( "{\*\qrycol", cConteudo ) - nPosQry )
        nPosT := At( "{\*\qrytbl ", cBlocoQry )
        DO WHILE nPosT > 0
            cSub := SubStr( cBlocoQry, nPosT + 11 )
            cPathCompleto := SubStr( cSub, 1, At( "}", cSub ) - 1 )
            cNomeDbf := Upper( SubStr( cPathCompleto, RAt( "\", cPathCompleto ) + 1 ) )
            IF ".DBF" $ cNomeDbf
                cNomeDbf := StrTran( cNomeDbf, ".DBF", "" )
            ENDIF
            cNomeDbf := AllTrim( cNomeDbf )
            IF AScan( aTabLocal, cNomeDbf ) == 0
                AAdd( aTabLocal, cNomeDbf )
            ENDIF
            cBlocoQry := SubStr( cBlocoQry, nPosT + 11 + Len(cPathCompleto) )
            nPosT := At( "{\*\qrytbl ", cBlocoQry )
        ENDDO
    ENDIF
RETURN aTabLocal

STATIC FUNCTION MapearCamposDoRet( cConteudo )
    LOCAL aCampos := {}
    LOCAL nPosVar := At( "{\*\vrwvar", cConteudo )
    LOCAL cBlocoVars := ""
    LOCAL nPosV, cSub, cNomeCampo
    IF nPosVar > 0
        cBlocoVars := SubStr( cConteudo, nPosVar, At( "{\*\vrwqry", cConteudo ) - nPosVar )
        nPosV := At( "\colnam ", cBlocoVars )
        DO WHILE nPosV > 0
            cSub := SubStr( cBlocoVars, nPosV + 8 )
            cNomeCampo := SubStr( cSub, 1, At( "\", cSub ) - 1 )
            cNomeCampo := AllTrim( cNomeCampo )
            IF AScan( aCampos, cNomeCampo ) == 0
                AAdd( aCampos, cNomeCampo )
            ENDIF
            cBlocoVars := SubStr( cBlocoVars, nPosV + 8 + Len(cNomeCampo) )
            nPosV := At( "\colnam ", cBlocoVars )
        ENDDO
    ENDIF
RETURN aCampos

STATIC FUNCTION ProcessarMacrosDinamicas( cBlocoBruto, aCampos, hParams )
    LOCAL cBlocoProcessado := cBlocoBruto
    LOCAL nX, cMacro, cMacroTrim, cValor, nPosField, cCampo
    LOCAL aChavesParams, cKey

    FOR nX := 1 TO Len( aCampos )
        cCampo := aCampos[nX]
        cMacro := "{\*\varref " + cCampo + "}"
        cMacroTrim := "{\*\varref " + cCampo + "\trmblk}"
        
        IF At( cMacro, cBlocoProcessado ) > 0 .OR. At( cMacroTrim, cBlocoProcessado ) > 0
            nPosField := FieldPos( cCampo )
            IF nPosField > 0
                cValor := cValToChar( FieldGet( nPosField ) )
                IF ValType( FieldGet( nPosField ) ) == "D"
                    cValor := DToC( FieldGet( nPosField ) )
                ENDIF
            ELSE
                cValor := ""
            ENDIF
            cBlocoProcessado := StrTran( cBlocoProcessado, cMacroTrim, AllTrim(cValor) )
            cBlocoProcessado := StrTran( cBlocoProcessado, cMacro, cValor )
        ENDIF
    NEXT

    aChavesParams := HB_HKeys( hParams )
    FOR nX := 1 TO Len( aChavesParams )
        cKey := aChavesParams[nX]
        cMacro := "{\*\varref " + cKey + "}"
        cMacroTrim := "{\*\varref " + cKey + "\trmblk}"
        IF At( cMacro, cBlocoProcessado ) > 0 .OR. At( cMacroTrim, cBlocoProcessado ) > 0
            IF ValType( hParams[cKey] ) == "D"
                cValor := DToC( hParams[cKey] )
            ELSE
                cValor := cValToChar( hParams[cKey] )
            ENDIF
            cBlocoProcessado := StrTran( cBlocoProcessado, cMacroTrim, AllTrim(cValor) )
            cBlocoProcessado := StrTran( cBlocoProcessado, cMacro, cValor )
        ENDIF
    NEXT
    cBlocoProcessado := StrTran( cBlocoProcessado, "{\*\varref _pagenumber}", "1" )
    cBlocoProcessado := StrTran( cBlocoProcessado, "{\*\varref _date}", DToC( Date() ) )
RETURN cBlocoProcessado