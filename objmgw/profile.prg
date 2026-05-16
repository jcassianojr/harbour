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

// +--------------------------------------------------------------------
// +  Funcao: ProfileString()
// +  Parametros: cFile    - O nome do arquivo .INI a ser usado
// +              cSection - A secao da qual sera feita a leitura
// +              cKey     - A chave/identificador a ser buscado
// +              cDefault - O valor padrao caso nao seja encontrado (opcional)
// +
// +  Retorno:    cString  - A string lida do arquivo.
// +--------------------------------------------------------------------
FUNCTION ProfileString( cFile, cSection, cKey, cDefault )

   LOCAL cString

   // Garante que se o valor padrao for omitido, seja uma string vazia
   IF cDefault == NIL
      cDefault := ""
   ENDIF

   // Se nenhuma extensao for fornecida para o arquivo, assume .INI
   IF RAt( ".", cFile ) == 0
      cFile := Upper( AllTrim( cFile ) ) + ".INI"
   ENDIF

   // As funcoes nativas do Harbour nao precisam dos colchetes [] na secao.
   // Caso o seu codigo antigo envie com eles, limpamos aqui para evitar falhas.
   cSection := StrTran( cSection, "[", "" )
   cSection := StrTran( cSection, "]", "" )

   // Utiliza a API nativa de alta performance do Harbour
   cString := GetPvProfString( cSection, cKey, cDefault, cFile )

   RETURN cString


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
// +  Funcao: SetProfile()
// +  Parametros: cFile    - O nome do arquivo .INI a ser usado
// +              cSection - A secao onde o valor sera gravado
// +              cKey     - A chave/identificador a ser gravado ou atualizado
// +              xValue   - O novo valor a ser escrito
// +
// +  Retorno:    .T. se gravado com sucesso, .F. caso contrario.
// +--------------------------------------------------------------------
FUNCTION SetProfile( cFile, cSection, cKey, xValue )

   LOCAL lRetCode
   LOCAL cType
   LOCAL cNewValue

   // Se nenhuma extensao for fornecida para o arquivo, assume .INI
   IF RAt( ".", cFile ) == 0
      cFile := Upper( AllTrim( cFile ) ) + ".INI"
   ENDIF

   // Remove os colchetes se existirem para compatibilidade com o Harbour nativo
   cSection := StrTran( cSection, "[", "" )
   cSection := StrTran( cSection, "]", "" )

   cType := ValType( xValue )

   DO CASE
   CASE cType == "C"
      cNewValue := xValue

   CASE cType == "N"
      cNewValue := AllTrim( Str( xValue ) )

   CASE cType == "L"
      cNewValue := if( xValue, "1", "0" )

   CASE cType == "D"
      cNewValue := DToS( xValue ) // Mantem o formato original AAAAMMDD

   OTHERWISE
      cNewValue := ""
   ENDCASE

   // Grava diretamente no arquivo usando a engine do Harbour e retorna .T. ou .F.
   lRetCode := WritePvProfString( cSection, cKey, cNewValue, cFile )

   RETURN lRetCode


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