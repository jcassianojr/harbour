// +--------------------------------------------------------------------
// +
// +    Programa  : profile.prg
// +
// +    Sistema   :
// +
// +    Linguagem : Harbour
// +
// +    Autor     : jcassiano (Atualizado/Modernizado)
// +
// +    Copyright (c) 2024, jcassiano
// +
// +--------------------------------------------------------------------

// +--------------------------------------------------------------------
// +
// +    PROFILE.PRG
// +
// +  FUNCOES PUBLICAS:
// +
// +  ProfileString( cINIFile, cSection, cKey, cDefault )
// +  ProfileNum( cINIFile, cSection, cKey, nDefault )
// +  ProfileDate( cINIFile, cSection, cKey, dDefault )
// +  ProfileLogical( cINIFile, cSection, cKey, lDefault )
// +  SetProfile( cINIFile, cSection, cKey, xValue )
// +
// +  ProfileString e usada para ler uma string do arquivo .INI especificado.
// +  Ex: cSystemPath := ProfileString( "TEST.INI", "System", "Path", "." )
// +
// +  ProfileNum e usada para ler um valor numerico do arquivo .INI especificado,
// +  incluindo valores logicos (armazenados como 0 ou 1).
// +  Ex: nMaxUsers := ProfileNum( "TEST.INI", "System", "MaxUsers", 20 )
// +
// +  ProfileDate e usada para ler um valor de data do arquivo .INI especificado.
// +  (SetProfile armazena datas no formato AAAAMMDD.)
// +  Ex: dDownload := ProfileDate( "TEST.INI", "System", "LastDnld", DATE() )
// +
// +  SetProfile e usada para armazenar um valor de qualquer tipo de dado,
// +  exceto objetos, blocos de codigo e arrays, no arquivo .INI.
// +  Ex: lSuccess := SetProfile( "TEST.INI", "System", "MaxUsers", 20 )
// +
// +--------------------------------------------------------------------

#include "FileIO.ch"
#include "Set.ch"

// +--------------------------------------------------------------------+
// +  Função: ProfileString() - ULTRA RESILIENTE (Ignora erros de INI)
// +--------------------------------------------------------------------+
FUNCTION ProfileString( cINIFile, cSection, cKey, cDefault )

   LOCAL cConteudo, aLinhas, cLinha, nI
   LOCAL lNaSecao := .F.
   LOCAL nPosIgual
   LOCAL cChaveAtual, cValorAtual

   IF ValType( cDefault ) <> "C"
      cDefault := ""
   ENDIF

   IF RAt( ".", cINIFile ) == 0
      cINIFile := Upper( AllTrim( cINIFile ) ) + ".INI"
   ENDIF

   // Garante padronização sem colchetes e em maiúsculo para busca
   cSection := Upper( StrTran( StrTran( cSection, "[", "" ), "]", "" ) )
   cKey     := Upper( AllTrim( cKey ) )

   IF ! File( cINIFile )
      RETURN cDefault
   ENDIF

   // Lê o arquivo inteiro para a memória
   cConteudo := MemoRead( cINIFile )
   
   // Quebra o arquivo em um array de linhas (suporta CR+LF ou apenas LF)
   aLinhas := hb_RegExSplit( hb_Eol(), cConteudo )
   IF Len( aLinhas ) == 0
      aLinhas := hb_RegExSplit( Chr(10), cConteudo )
   ENDIF

   FOR nI := 1 TO Len( aLinhas )
      cLinha := AllTrim( aLinhas[nI] )

      // Ignora linhas vazias ou comentários legítimos do arquivo INI
      IF Empty( cLinha ) .OR. Left( cLinha, 1 ) == ";" .OR. Left( cLinha, 1 ) == "#"
         LOOP
      ENDIF

      // Detecta se entramos na seção procurada ex: [MPOINT]
      IF Left( cLinha, 1 ) == "[" .AND. Right( cLinha, 1 ) == "]"
         IF Upper( StrTran( StrTran( cLinha, "[", "" ), "]", "" ) ) == cSection
            lNaSecao := .T.
         ELSE
            lNaSecao := .F. // Saiu da seção procurada e entrou em outra
         ENDIF
         LOOP
      ENDIF

      // Se estiver dentro da seção correta, processa a chave
      IF lNaSecao
         nPosIgual := At( "=", cLinha )
         IF nPosIgual > 0
            cChaveAtual := Upper( AllTrim( Left( cLinha, nPosIgual - 1 ) ) )
            
            // Se achou a chave ex: "CONECCAO"
            IF cChaveAtual == cKey
               cValorAtual := SubStr( cLinha, nPosIgual + 1 )
               RETURN AllTrim( cValorAtual )
            ENDIF
         ENDIF
      ENDIF
   NEXT

   RETURN cDefault

// +--------------------------------------------------------------------+
// +  Função: SetProfile() - CORRIGIDA NATIVA SEM LIBS EXTRAS
// +--------------------------------------------------------------------+
FUNCTION SetProfile( cINIFile, cSection, cKey, xValue )

   LOCAL hIni
   LOCAL cNewValue
   LOCAL cType := ValType( xValue )

   DO CASE
   CASE cType == "C"
      cNewValue := xValue
   CASE cType == "N"
      cNewValue := AllTrim( Str( xValue ) )
   CASE cType == "L"
      cNewValue := if( xValue, "1", "0" )
   CASE cType == "D"
      cNewValue := DToS( xValue )
   OTHERWISE
      cNewValue := ""
   ENDCASE

   cSection := StrTran( cSection, "[", "" )
   cSection := StrTran( cSection, "]", "" )

   IF RAt( ".", cINIFile ) == 0
      cINIFile := Upper( AllTrim( cINIFile ) ) + ".INI"
   ENDIF

   // Se o arquivo já existe, lê o conteúdo atual para não apagar outras seções
   IF File( cINIFile )
      hIni := hb_IniRead( cINIFile )
   ELSE
      hIni := {=>}
   ENDIF

   // Se a seção não existir no Hash, cria ela
   IF ! HHasKey( hIni, cSection )
      hIni[ cSection ] := {=>}
   ENDIF

   // Altera ou adiciona a chave com o novo valor
   hIni[ cSection ][ cKey ] := cNewValue

   // Salva de volta no arquivo de forma nativa e limpa
   RETURN hb_IniWrite( cINIFile, hIni )

// +--------------------------------------------------------------------+
// +  Função: ProfileString() - UNIFICADA E CORRIGIDA PARA HARBOUR
// +  Parâmetros: cINIFile  - O nome do arquivo .INI a ser usado
// +              cSection  - A secao da qual sera feita a leitura
// +              cKey      - A chave/identificador a ser buscado
// +              cDefault  - O valor padrao caso nao seja encontrado (opcional)
// +  Retorno:    cVAL      - A string lida do arquivo.
// +--------------------------------------------------------------------+

// +--------------------------------------------------------------------
// +  Funcao: ProfileNum()
// +  Parametros: cFile    - O nome do arquivo .INI a ser usado
// +              cSection - A secao da qual sera feita a leitura
// +              cKey     - A chave/identificador a ser buscado
// +              nDefault - O valor padrao caso nao seja encontrado (opcional)
// +
// +  Retorno:    nValue   - O valor numerico lido do arquivo.
// +--------------------------------------------------------------------
FUNCTION ProfileNum( cFile, cSection, cKey, nDefault )

   LOCAL cValue
   LOCAL cDefault
   LOCAL nValue

   IF nDefault == NIL
      nDefault := 0
   ENDIF

   nValue   := nDefault
   cDefault := AllTrim( Str( nDefault ) )

   // Reutiliza a funcao ProfileString atualizada
   cValue := ProfileString( cFile, cSection, cKey, cDefault )

   IF !Empty( cValue )
      nValue := Val( cValue )
   ENDIF

   RETURN nValue


FUNCTION ProfileDate( cFile, cSection, cKey, dDefault )

   LOCAL cValue
   LOCAL cDefault
   LOCAL dDate

   IF ValType( dDefault ) <> "D"
      dDefault := CToD( "" )
   ENDIF

   dDate    := dDefault
   cDefault := AllTrim( DToS( dDefault ) )

   cValue := ProfileString( cFile, cSection, cKey, cDefault )

   IF !Empty( cValue )
      // Usa a funcao universal para garantir a leitura correta
      dDate := UniversalToDate( cValue )
   ENDIF

   RETURN dDate



// +--------------------------------------------------------------------
// +  Funcao: ProfileLogical()
// +  Parametros: cINIFile  - O nome do arquivo .INI a ser usado
// +              cSection  - A secao da qual sera feita a leitura
// +              cKey      - A chave/identificador a ser buscado
// +              lDefault  - O valor logico padrao caso nao encontrado
// +
// +  Retorno:    Valor logico (.T. ou .F.) baseado no conteudo lido.
// +--------------------------------------------------------------------
FUNCTION ProfileLogical( cINIFile, cSection, cKey, lDefault )

   LOCAL cVAL
   LOCAL cDefaultStr

   // Valida se o default recebido e logico, caso contrario assume .F.
   IF ValType( lDefault ) <> "L"
      lDefault := .F.
   ENDIF

   // Define o valor padrao em string para passar para a busca do INI
   cDefaultStr := if( lDefault, "1", "0" )

   // Reutiliza o ProfileString (que usa GetPvProfString internamente)
   cVAL := ProfileString( cINIFile, cSection, cKey, cDefaultStr )

   // Retorna o booleano utilizando estritamente a sua funcao StrLogic()
   RETURN StrLogic( cVAL, lDefault )



// + EOF: profile.prg