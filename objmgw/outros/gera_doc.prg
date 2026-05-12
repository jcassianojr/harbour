/*
*+--------------------------------------------------------------------
*+ Projeto: Gerador de Documentacao Markdown (Versão Corrigida)
*+ Módulo : GERA_DOC.PRG
*+--------------------------------------------------------------------
*/

#include "fileio.ch"

PROCEDURE Main()
   LOCAL cFnc := "Fnc_cros.txt"
   LOCAL cSrc := "Src_cros.txt"
   LOCAL cTbl := "Tbl_cros.txt"
   LOCAL cOut := "DOCUMENTACAO.md"
   LOCAL nHandle
   
   IF !File(cFnc) .OR. !File(cSrc) .OR. !File(cTbl)
      ? "Erro: Certifique-se que Fnc_cros.txt, Src_cros.txt e Tbl_cros.txt estao na pasta."
      RETURN
   ENDIF

   nHandle := fCreate( cOut )
   
   fWrite( nHandle, "# 📘 Documentacao Tecnica do Projeto" + hb_eol() )
   fWrite( nHandle, "> Gerado em: " + DToC(Date()) + " " + Time() + hb_eol() + hb_eol() )
   
   ? "Processando Estrutura (SRC)..."
   fWrite( nHandle, "## 🏗️ Estrutura de Modulos (PRGs)" + hb_eol() )
   Processar_Src( cSrc, nHandle )

   ? "Processando Tabelas (TBL)..."
   fWrite( nHandle, hb_eol() + "## 📊 Dicionario de Dados e Acessos" + hb_eol() )
   Processar_Tbl( cTbl, nHandle )

   ? "Processando Chamadas (FNC) para Mermaid..."
   fWrite( nHandle, hb_eol() + "## 🕸️ Diagrama de Relacionamento (Mermaid)" + hb_eol() )
   fWrite( nHandle, "```mermaid" + hb_eol() )
   fWrite( nHandle, "graph TD" + hb_eol() )
   Processar_Fnc_Mermaid( cFnc, nHandle )
   fWrite( nHandle, "```" + hb_eol() )

   fClose( nHandle )
   ? "Sucesso! DOCUMENTACAO.md atualizado com o diagrama."
RETURN

// --- Processamento Corrigido para Fnc_cros.txt ---
STATIC PROCEDURE Processar_Fnc_Mermaid( cFile, nHandle )
   LOCAL cBuffer := hb_MemoRead( cFile )
   LOCAL aLines  := hb_ATokens( cBuffer, .T. )
   LOCAL nLine, cLine
   LOCAL cCurrentFunc := "", cCaller := ""

   FOR nLine := 1 TO Len( aLines )
      cLine := aLines[ nLine ]
      
      IF Empty(cLine) .OR. Left(cLine, 2) == "*+" ; LOOP ; ENDIF

      // 1. Identifica a Função Destino (esta na margem esquerda)
      IF !Left(cLine, 1) == " " .AND. "(" $ cLine
         cCurrentFunc := AllTrim( Token( cLine, " (", 1 ) )
         // Limpeza de caracteres especiais que quebram o Mermaid
         cCurrentFunc := StrTran(cCurrentFunc, ":", "_")
         cCurrentFunc := StrTran(cCurrentFunc, "&", "REF")
      ENDIF

      // 2. Identifica quem Chama (identado e contém "Called from")
      IF "Called from" $ cLine .AND. ".prg" $ Lower(cLine)
         // Extrai o nome do ficheiro entre os parênteses
         cCaller := SubStr( cLine, At( "(", cLine ) + 1 )
         cCaller := AllTrim( Left( cCaller, At( ".prg", Lower(cCaller) ) + 3 ) )
         
         IF !Empty(cCurrentFunc) .AND. !Empty(cCaller)
            // Escreve a relação no formato Mermaid: ficheiro_prg --> Funcao
            fWrite( nHandle, "    " + StrTran(cCaller, ".", "_") + " --> " + cCurrentFunc + hb_eol() )
         ENDIF
      ENDIF
   NEXT
RETURN

// --- Mantendo as rotinas que já funcionam ---
STATIC PROCEDURE Processar_Src( cFile, nHandle )
   LOCAL aLines := hb_ATokens( hb_MemoRead( cFile ), .T. )
   LOCAL nLine, cLine
   FOR nLine := 1 TO Len( aLines )
      cLine := AllTrim( aLines[ nLine ] )
      IF Empty(cLine) .OR. Left(cLine, 2) == "*+" ; LOOP ; ENDIF
      IF ".prg" $ Lower(cLine)
         fWrite( nHandle, hb_eol() + "### 📄 Arquivo: `" + cLine + "`" + hb_eol() )
      ELSE
         fWrite( nHandle, "- " + cLine + hb_eol() )
      ENDIF
   NEXT
RETURN

STATIC PROCEDURE Processar_Tbl( cFile, nHandle )
   LOCAL aLines := hb_ATokens( hb_MemoRead( cFile ), .T. )
   LOCAL nLine, cLine
   FOR nLine := 1 TO Len( aLines )
      cLine := AllTrim( aLines[ nLine ] )
      IF Empty(cLine) .OR. Left(cLine, 2) == "*+" ; LOOP ; ENDIF
      IF ".prg" $ Lower(cLine)
         fWrite( nHandle, hb_eol() + "**Fonte:** `" + cLine + "`" + hb_eol() )
      ELSE
         fWrite( nHandle, "> " + cLine + hb_eol() )
      ENDIF
   NEXT
RETURN

STATIC FUNCTION Token( cString, cDelim, nPos )
   LOCAL aTokens := hb_ATokens( cString, cDelim )
RETURN iif( nPos <= Len(aTokens), aTokens[nPos], "" )