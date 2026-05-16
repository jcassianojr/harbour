// +--------------------------------------------------------------------
// +
// +    Programa  : adofix.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +--------------------------------------------------------------------
// +


// +--------------------------------------------------------------------
// +
// +    Function FIX02()
// +
// +--------------------------------------------------------------------
// +
FUNCTION FIX02( cVALOR )

   IF Empty( cVALOR )
      RETURN ""
   ENDIF
   IF ValType( cVALOR ) <> "C"
      RETURN ""
   ENDIF
   cVALOR := RANGEREPL( Chr( 0 ), Chr( 31 ), cVALOR, " " )
   cVALOR := RANGEREPL( Chr( 127 ), Chr( 255 ), cVALOR, " " )
   cVALOR := AllTrim( cVALOR )

   RETURN cVALOR


// +--------------------------------------------------------------------
// +
// +    Function FIXINT()
// +
// +--------------------------------------------------------------------
// +
FUNCTION FIXINT( eVALOR )

   RETURN Int( FIXNUM( eVALOR ) )


// +--------------------------------------------------------------------
// +
// +    Function FIXNUM()
// +
// +--------------------------------------------------------------------
// +
FUNCTION FIXNUM( cCAMPO )

   IF ValType( cCAMPO ) # "N"
      RETURN 0
   ENDIF

   RETURN cCAMPO



// +--------------------------------------------------------------------
// +
// +    Function FIXSTR()
// +
// +--------------------------------------------------------------------
// +
FUNCTION FIXSTR( cCAMPO, lTRIM )

   IF ValType( cCAMPO ) <> "C"
      RETURN ""
   ENDIF
   IF ValType( lTRIM ) <> 'L'
      lTRIM := .F.
   ENDIF

   RETURN IF( lTRIM, AllTrim( cCAMPO ), cCAMPO )



// +--------------------------------------------------------------------
// +  Função: FIXDATS()
// +  Objetivo: Trata e limpa strings de datas vindas do Banco de Dados,
// +            eliminando valores nulos ou padrões vazios de motores SQL.
// +  Retorno:  cString - String contendo a data limpa ou string vazia.
// +--------------------------------------------------------------------
FUNCTION FIXDATS( cCAMPO )

   LOCAL cLimpa

   IF ValType( cCAMPO ) <> "C"
      RETURN ""
   ENDIF

   cCAMPO := AllTrim( cCAMPO )

   // Identifica se é um padrão de data nula/vazia de banco (ex: 01/01/1900 ou zerados) 
   IF cCAMPO == '01/01/1900'
      RETURN ""
   ENDIF

   // Remove separadores para checar máscaras zeradas comuns em bancos
   cLimpa := StrTran( cCAMPO, "/", "" )
   cLimpa := StrTran( cLimpa, "-", "" )
   cLimpa := StrTran( cLimpa, ".", "" )
   cLimpa := Left( cLimpa, 8 ) // Pega apenas a porção da data, ignora a hora se houver

   // Trata "01011900" ou marcas nulas do SQLite/MySQL ("00000101", "00000000") 
   IF cLimpa == '01011900' .OR. cLimpa == '00000101' .OR. cLimpa == '00000000' .OR. Left(cLimpa, 4) == '0000'
      RETURN ""
   ENDIF

   RETURN cCAMPO


// +--------------------------------------------------------------------
// +  Função: FIXDATA()
// +  Objetivo: Garante o retorno de um tipo DATA (D) válido para o Harbour,
// +            interceptando variações de bancos de dados.
// +  Retorno:  dData - Objeto do tipo Data (vazio ou preenchido).
// +--------------------------------------------------------------------
FUNCTION FIXDATA( cCAMPO )

   LOCAL dResult := CToD( "" )

   // Se já vier como Data legítima do Driver/ODBC, passa direto 
   IF ValType( cCAMPO ) == 'D' 
      RETURN cCAMPO 
   ENDIF

   // Se não for caractere e nem data, aborta com data vazia 
   IF ValType( cCAMPO ) <> 'C' 
      RETURN dResult 
   ENDIF

   // Filtra e limpa registros textuais nulos usando a nova FIXDATS
   cCAMPO := FIXDATS( cCAMPO )
   
   IF Empty( cCAMPO )
      RETURN dResult
   ENDIF

   // Utiliza a função Universal centralizada do seu sistema (do disk55.prg)
   // para converter strings bagunçadas com segurança
   dResult := UniversalToDate( cCAMPO )

   RETURN dResult


// +--------------------------------------------------------------------
// +  Função: FIXLOGIC()
// +  Objetivo: Garante o retorno de um valor lógico booleano (.T. ou .F.)
// +            tratando retornos lógicos, textuais ou numéricos de bancos.
// +  Retorno:  Valor lógico (.T. ou .F.)
// +--------------------------------------------------------------------
FUNCTION FIXLOGIC( cCAMPO )

   LOCAL cType := ValType( cCAMPO )

   // 1. Se já for lógico puro (ex: PostgreSQL ou ODBC bem configurado), retorna direto
   IF cType == 'L'
      RETURN cCAMPO
   ENDIF

   // 2. Se for numérico (comum no SQLite que armazena booleanos como 0 ou 1)
   IF cType == 'N'
      RETURN ( cCAMPO == 1 )
   ENDIF

   // 3. Se for caractere/texto, delega para a inteligência da StrLogic
   IF cType == 'C'
      RETURN StrLogic( AllTrim( cCAMPO ), .F. )
   ENDIF

   // Fallback de segurança para outros tipos (como NIL/NULL)
   RETURN .F.

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXHORA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXHORA( cCampo )

   cCAMPO := FIXSTR( cCAMPO )
   cCAMPO := SubStr( cCAMPO, At( " ", cCAMPO ) + 1 )
   cCAMPO := Left( cCAMPO, 5 )
   cCAMPO := StrTran( cCAMPO, ":", "." )

   RETURN cCAMPO



// +--------------------------------------------------------------------
// +
// +    Function DateToMySQL()
// +
// +--------------------------------------------------------------------
// +
FUNCTION DateToMySQL( dDate )
   RETURN data2str( dDate, "MYS", "-", "4" )

// + EOF: adofix.prg
// +
