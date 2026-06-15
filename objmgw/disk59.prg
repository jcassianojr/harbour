// +--------------------------------------------------------------------
// +
// +
// +    Programa  : disk59.prg
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

// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
// +
// +   Module => DISK59.PRG
// +
// +
// +             FUNCTION valcnpj(cCNPJ,lMES,cUF) //Chama VALCGC( cCNPJ, xTIPO ,lMES,cUF)
// +             FUNCTION VALCGC( cCNPJ, xTIPO ,lMES,cUF)
// +             FUNCTION Valcpf( xCPF ,lMES)
// +             FUNCTION Mod11( campo, posdv, pesomax )
// +             FUNCTION formatacpf(xCPF)
// +             FUNCTION formatacnpj(xCNPJ)
// +             FUNCTION CNPJCPFPICT(oGet,v_Tipo,nROW,nCOL)
// +             FUNCTION CNPJCPFVAL(cCGC,cPESSOA,cESTADO)
// +             FUNCTION VALCEI(wk_cei,lMES)
// +
// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

#include "INKEY.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function valcnpj(cCNPJ,lMES) //Chama vaccgc
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION valcnpj( cCNPJ, lMES, cUF )

   RETURN VALCGC( cCNPJ, "", lMES, cUF )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALCGC(cCNPJ, xTIPO, lMES, cUF)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VALCGC( cCNPJ, xTIPO, lMES, cUF )

   LOCAL x
   LOCAL nCHAR
   LOCAL P1
   LOCAL aUF

   ZNERRO := 0
   ZERRO  := ""

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   IF ValType( LMES ) <> "L"
      lMES := .T.
   ENDIF
   IF ValType( xTIPO ) <> "C"
      xTIPO := "X"
   ENDIF
   IF ValType( cCNPJ ) = 'N'
      cCNPJ := AllTrim( Str( cCNPJ ) )
   ENDIF

// valor cnpj sem traco e pontos
   P1 := AllTrim( TIRAOUT( cCNPJ ) )

   IF Val( p1 ) = 0
      ZNERRO := 1
      ZERRO  := "CNPJ Invalido - Em Branco"
      RETURN .F.
   ENDIF
   IF Len( p1 ) <> 14
      ZNERRO := 2
      ZERRO  := "CNPJ Invalido - nao tem 14 Digitos"
   ENDIF
   FOR X := 0 TO 9
      IF p1 = REPL( Str( X, 1 ), 14 )
         ZNERRO := 3
         ZERRO  := "CNPJ Invalido - Sequencia Repetitiva de " + Str( X, 1 )
      ENDIF
   NEXT X
// if xtipo = 'M' //desabilitada pois a matriz nao mais precisa ser 0001
// if substr( P1, 9, 4 ) != '0001'
// ZNERRO:=4
// ZERRO:="CNPJ Invalido - Nao e Matriz"
// endif
// endif
// CNPJ-Numeric (current): NN.NNN.NNN/NNNN-NN
// CNPJ-Alphanumeric (new): SS.SSS.SSS/SSSS-NN
// 12 345 678 9012 34
   FOR X := 1 TO 12
      nCHAR := SubStr( P1, X, 1 )
      IF IsAlpha( nCHAR ) .OR. IsDigit( nCHAR )
      ELSE
         ZNERRO := 11
         ZERRO  := "CNPJ Invalido - digito Posicao " + Str( X, 1 )
      ENDIF
   NEXT X

   FOR X := 13 TO 14
      nCHAR := SubStr( P1, X, 1 )
      IF IsDigit( nCHAR )
      ELSE
         ZNERRO := 12
         ZERRO  := "CNPJ Invalido - digito nao numerico Posicao " + Str( X, 1 )
      ENDIF
   NEXT X



   IF Left( p1, 7 ) = "9999999"   // inicio 999999
      ZNERRO := 5
      ZERRO  := "CNPJ Generico 9999999"
   ENDIF
   IF SubStr( p1, 9, 4 ) = "9999"  // depois da barra 9999
      ZNERRO := 6
      ZERRO  := "CNPJ Generico /9999-"
   ENDIF
   IF ValType( cUF ) = "C" .AND. !Empty( cUF )
      aUF := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
         "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
         "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO", "EX", "XX" }
      IF AScan( aUF, cUF ) = 0
         ZNERRO := 7
         ZERRO  := "Estado invalido: " + cUF
      ENDIF
   ENDIF

   IF ZNERRO = 0
      IF !CNPJ_Novo( P1 )
         ZNERRO := 10
         ZERRO  := "CNPJ Invalido"
      ENDIF
      // funcao nova validar nova versao com caracteres
   /*
  if Mod11( P1, 13, 9 )
     if Mod11( P1, 14, 9 )
        return .T.
     else
        ZNERRO:=8
        ZERRO:="Cheque 14o. Digito - 2 Verificador"
     endif
  else
     ZNERRO:=9
     ZERRO:="Cheque 13o. Digito - 1 Verificador"
  endif
  */
   ENDIF
   IF ZNERRO > 0
      IF lMES
         ALERTX( zERRO )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.

// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
// +
// +    FUNCTION Valcpf(xCPF, lMES)
// +    CPF no 000.000.008-00
// +1. Tocantins, Mato Grosso do Sul, Goias e Distrito Federal;
// +2. Roraima,Amapa, Amazonas, Acre, Rondonia e Para;
// +3. Piaui, Maranhao e Ceara;
// +4. Rio Grande do Norte, Pernambuco, Alagoas e Paraiba;
// +5. Bahia e Sergipe;
// +6. Minas Gerais;
// +7. Rio de Janeiro e Espirito Santo;
// +8. Sao Paulo;
// +9. Parana e Santa Catarina;
// +0. Rio Grande do Sul
// +
// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
// +

FUNCTION Valcpf( xCPF, lMES )

   LOCAL X, cDIGEST

   ZNERRO := 0
   ZERRO  := ""

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   IF ValType( lMES ) # 'L'
      lMES := .T.
   ENDIF

   p1 := AllTrim( tiraout( xCPF ) )

// 00001008268143 programa do governo com 3 zeros a frente e comprimento 14
   IF Len( p1 ) = 14 .AND. SubStr( p1, 1, 3 ) = "000"
      p1 := SubStr( p1, 4 )
   ENDIF


   IF Val( p1 ) = 0
      ZNERRO := 1
      ZERRO  := "CPF/CNI Em Branco"
   ENDIF

   IF Len( p1 ) <> 11
      ZNERRO := 2
      ZERRO  := "CPF/CNI nao tem 11 digitos"
   ENDIF

   FOR X := 0 TO 9
      IF p1 = repl( Str( X, 1 ), 11 )
         ZNERRO := 3
         ZERRO  := "CPF/CNI Invalido - Sequencia Repetitiva de " + Str( X, 1 )
      ENDIF
   NEXT X

   IF znerro = 0
      IF Mod11( P1, 10, 10 )
         IF Mod11( P1, 11, 11 )
            RETURN .T.
         ELSE
            ZNERRO := 4
            ZERRO  := "CPF/CNI - Invalido Cheque 11o. Digito - 2 Verificador"
         ENDIF
      ELSE
         ZNERRO := 5
         ZERRO  := "CPF/CNI - Invalido Cheque 10o. Digito - 1 Verificador"
      ENDIF
   ENDIF
// Estado Emissor
   cDIGEST := SubStr( P1, 9, 1 )
   DO CASE
   CASE cDIGEST = '1'
      cDIGEST := 'GO/MT/MS/DF/TO'
   CASE cDIGEST = '2'
      cDIGEST := 'AM/AC/PA/RR/RO/AP'
   CASE cDIGEST = '3'
      cDIGEST := 'MA/CE/PI'
   CASE cDIGEST = '4'
      cDIGEST := 'RN/PB/PE/AL'
   CASE cDIGEST = '5'
      cDIGEST := 'SE/BA'
   CASE cDIGEST = '6'
      cDIGEST := 'MG'
   CASE cDIGEST = '7'
      cDIGEST := 'RJ/ES'
   CASE cDIGEST = '8'
      cDIGEST := 'SP'
   CASE cDIGEST = '9'
      cDIGEST := 'PR/SC'
   CASE cDIGEST = '0'
      cDIGEST := 'RS'
   ENDCASE
   IF ZNERRO > 0
      IF lMES
         ALERTX( zERRO )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CNPJ_Novo(pCNPJ)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CNPJ_Novo( pCNPJ )   // , plMsg )

   LOCAL lResult := .T.
   LOCAL soma    := 0
   LOCAL dv      := ""
   LOCAL digito  := 0
   LOCAL num     := 0
   LOCAL wCGC    := iif( ValType( pCNPJ ) = "U", "", pCNPJ )
   LOCAL i       := 0
   LOCAL j       := 0
   LOCAL Validos := "0123456789"   // Incia so numeros mas se for a versao nova muda para alfa+numeros

// DEFAULT plMsg := .t.

   wCGC := StrTran( wCGC, ".", "" )
   wCGC := StrTran( wCGC, "-", "" )
   wCGC := StrTran( wCGC, "/", "" )
   IF Empty( wCGC )
      lResult := .F.   // .t.
   ELSE
      IF Len( wCGC ) < 14
         lResult := .F.
      ELSE
         FOR i := 1 TO 12
            IF SubStr( wCGC, i, 1 ) $ "ABCDEFGHIJKLMNOPQRSTUWYXZ"
               Validos := "0123456789ABCDEFGHIJKLMNOPQRSTUWYXZ"
               EXIT
            ENDIF
         NEXT
         dv  := ""
         num := 5
         FOR j := 1 TO 2
            soma := 0
            FOR i := 1 TO 12
               soma += ( Asc( SubStr( wCGC, i, 1 ) ) - 48 ) * num
               num--
               IF num == 1
                  num := 9
               ENDIF
            NEXT
            IF j == 2
               soma += ( 2 * Val( dv ) )
            ENDIF
            digito := soma - ( Int( soma / 11 ) * 11 )
            IF digito == 0 .OR. digito == 1
               dv := dv + "0"
            ELSE
               dv := dv + Str( 11 - digito, 1 )
            ENDIF
            num := 6
         NEXT
         IF dv <> SubStr( wCGC, 13, 2 )
            lResult := .F.
         ENDIF
      ENDIF
   /*
        if !lResult
           if plMsg
               Msg_OK("CNPJ Incorreto ou Digito Invalido..." + " [" + dv + "]" )
           endif
       endif
    */
   ENDIF

   RETURN lResult


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Mod11(campo, posdv, pesomax ))
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Mod11( campo, posdv, pesomax )

   dv   := 0
   peso := 1
   FOR imod := posdv TO 1 STEP - 1
      dv += peso * Val( SubStr( campo, imod, 1 ) )
      peso++
      IF peso > pesomax
         peso := 2
      ENDIF
   NEXT
   REST := Mod( dv, 11 )
   IF REST = 0
      RETURN .T.
   ELSE
      IF REST = 1 .AND. Val( SubStr( campo, posdv, 1 ) ) = 0
         RETURN .T.
      ELSE
         RETURN .F.
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formatacpf(xCPF)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION formatacpf( xCPF )

   IF ValType( xCPF ) = 'N'
      xCPF := AllTrim( Str( xCPF ) )
   ENDIF
   xCPF := AllTrim( TIRAOUT( xCPF ) )
   IF Val( xCPF ) = 0 .OR. Len( xCPF ) <> 11
      RETURN xCPF
   ENDIF
   xCPF := StrZero( Val( xCPF ), 11 )

   RETURN Transform( xCPF, "@R 999.999.999-99" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formatacnpj(xCNPJ )
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION formatacnpj( xCNPJ )

// @ 01,10 GET CGC1 PICTURE "99.999.999/9999-99" so numeros
// /@ 02,10 GET CGC2  PICTURE "NN.NNN.NNN/NNNN-99" numeros e letras
// @ 03,10 GET CGC3  PICTURE "@! NN.NNN.NNN/NNNN-99" numero e letras comente maisculas

   IF ValType( xCNPJ ) = 'N'
      xCNPJ := AllTrim( Str( xCNPJ ) )
   ENDIF
   xCNPJ := AllTrim( TIRAOUT( xCNPJ ) )
   IF Val( xCNPJ ) = 0 .OR. Len( xCNPJ ) <> 14
      RETURN xCNPJ
   ENDIF
   xCNPJ := StrZero( Val( xCNPJ ), 14 )

   RETURN Transform( xCNPJ, "@R! NN.NNN.NNN/NNNN-99" )  // ! Para converter maisculas ou usar upper("@R NN.NNN.NNN/NNNN-99")


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CNPJCPFPICT(oGet, v_Tipo, nROW, nCOL ))
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CNPJCPFPICT( oGet, v_Tipo, nROW, nCOL )

// @ 01,10 GET CGC1 PICTURE "99.999.999/9999-99" so numeros
// /@ 02,10 GET CGC2  PICTURE "NN.NNN.NNN/NNNN-99" numeros e letras
// @ 03,10 GET CGC3  PICTURE "@! NN.NNN.NNN/NNNN-99" numero e letras comente maisculas

   @ nROW, nCOL SAY Space( 18 )
   DO CASE
   CASE v_Tipo = "J"
      oGet:PICTURE := "@! NN.NNN.NNN/NNNN-99"  // "99.999.999/9999-99"
   CASE v_Tipo = "F"
      oGet:PICTURE := "999.999.999-99"
   OTHERWISE   // CEI //CNO
      oGet:PICTURE := "@S18"
      // X   Any character allowed.
      // oGet:picture :=repl("X",nLEN)
   ENDCASE

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CNPJCPFVAL(cCGC, cPESSOA, cESTADO )
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CNPJCPFVAL( cCGC, cPESSOA, cESTADO )

   LOCAL lRETU

   lRETU := .T.
   DO CASE
   CASE cPESSOA = 'J'  // CNPJF
      lRETU := VALCGC( cCGC,,, cESTADO )
   CASE cPESSOA = "F"  // CPF CAEPF
      lRETU := VALCPF( cCGC )
   CASE cPESSOA = "C"  // CEI CNO
      lRETU := VALCEI( cCGC )
   OTHERWISE   // um dos tres e valido pessoa em branco
      lRETU := VALCGC( cCGC,,, cESTADO ) .OR. VALCPF( cCGC ) .OR. VALCEI( cCGC )
   ENDCASE

   RETURN lRETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALCEI(wk_cei,LMES) 
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VALCEI( wk_cei, Lmes )  // mascara="  .   .     /  "

   PRIVATE nTot, cAux, i

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   IF ValType( lMES ) # 'L'
      lMES := .T.
   ENDIF
   ZNERRO  := 0
   ZERRO   := ""
   nTot    := 0
   cAux    := ""
   i       := 0
   pNu_cei := ""
   pNU_CEI := TIRAOUT( wk_cei )
   IF Val( pNU_CEI ) = 0
      znerro := 1
      zerro  := 'CEI invalidos -  branco ou zero , redigite '
   ENDIF
   IF Val( SubStr( pNU_CEI, 1, 2 ) ) < 2 .OR. Val( SubStr( pNU_CEI, 1, 2 ) ) > 29
      znerro := 2
      zerro  := 'Posicao 1,2 nao e 00,01 ou maior que 29 '
   ENDIF
   IF ( SubStr( pNu_cei, 11, 1 ) $ "0678" ) .AND. Val( Left( pNu_cei, 2 ) ) > 0 .AND. ;
         Val( SubStr( pNu_cei, 3, 3 ) ) > 0 .AND. ;
         Val( SubStr( pNu_cei, 6, 5 ) ) > 0
      FOR i := 1 TO 11
         nTot := nTot + Val( SubStr( pNu_cei, i, 1 ) ) * Val( SubStr( "74185216374", i, 1 ) )
      NEXT
      cAux := Right( Str( nTot, 3 ), 2 )
      nTot := Val( Left( cAux, 1 ) ) + Val( Right( cAux, 1 ) )
      nTot := iif( nTot > 9, 0, 10 - nTot )
      IF Val( Right( pNu_cei, 1 ) ) = nTot
         RETURN .T.
      ELSE
         znerro := 3
         zerro  := 'Digito invalido'
      ENDIF
   ELSE
      znerro := 4
      zerro  := 'Posicao 11 nao e 0,6,7,8 ou posicoes 2 345 678910 zeradas'
   ENDIF
   IF ZNERRO > 0
      IF lMES
         ALERTX( zERRO )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.
   
   FUNCTION MascararNumGenerico( cNumero, nExibeInicio, nExibeFinal )
    LOCAL cLimpo := ALLTRIM(cNumero)
    LOCAL nLen   := LEN(cLimpo)
    LOCAL cInicio, cFinal, cMeio
    LOCAL nDigitosOcultos

    // Se o parâmetro de exibição não for passado, define um padrão
    IF VALTYPE(nExibeInicio) != "N"; nExibeInicio := 2; ENDIF
    IF VALTYPE(nExibeFinal)  != "N"; nExibeFinal  := 2; ENDIF

    // Se o número for muito curto para a máscara desejada, esconde apenas o miolo
    IF nLen <= (nExibeInicio + nExibeFinal)
        IF nLen > 2
            // Garante que pelo menos o primeiro e o último fiquem visíveis
            RETURN SUBSTR(cLimpo, 1, 1) + REPLICATE("*", nLen - 2) + SUBSTR(cLimpo, nLen, 1)
        ELSE
            RETURN REPLICATE("*", nLen) // Se for minúsculo (ex: 2 dígitos), esconde tudo
        ENDIF
    ENDIF

    // Extrai as pontas visíveis
    cInicio := SUBSTR(cLimpo, 1, nExibeInicio)
    cFinal  := SUBSTR(cLimpo, nLen - nExibeFinal + 1, nExibeFinal)
    
    // Calcula quantos asteriscos o miolo vai precisar
    nDigitosOcultos := nLen - nExibeInicio - nExibeFinal
    cMeio   := REPLICATE("*", nDigitosOcultos)

RETURN cInicio + cMeio + cFinal
   
  
 /*  
FUNCAO MascararCPF( cCPF )
    // Remove pontos e traços temporariamente para garantir o tamanho (11 digitos)
    cLimpo := LimparCaracteres( cCPF ) 
    
    // Pega os 3 primeiros e os 2 ultimos
    cInicio := Substr( cLimpo, 1, 3 )
    cFinal  := Substr( cLimpo, 10, 2 )
    
    // Monta a string mascarada de retorno
RETURN cInicio + ".***.***-" + cFinal
/*


 * Função para ofuscar CNPJ (Aceita o novo padrão Alfanumérico)
 */
FUNCTION MascaraCNPJ( cCnpjRaw )
    LOCAL cCnpjLimpo := ""
    LOCAL cCnpjMascarado := ""
    LOCAL i, cChar
    
    // 1. Limpa a string removendo APENAS os caracteres de pontuação (ponto, barra, traço e espaços)
    // Mantém tudo o que for número (0-9) e letra (A-Z)
    FOR i := 1 TO LEN( cCnpjRaw )
        cChar := UPPER( SUBSTR( cCnpjRaw, i, 1 ) )
        
        // Se for número ou letra, mantém no bloco limpo
        IF ( cChar >= "0" .AND. cChar <= "9" ) .OR. ( cChar >= "A" .AND. cChar <= "Z" )
            cCnpjLimpo += cChar
        ENDIF
    NEXT
    
    // 2. O CNPJ precisa ter exatamente 14 caracteres (seja letra ou número)
    IF LEN( cCnpjLimpo ) != 14
        RETURN cCnpjRaw 
    ENDIF
    
    // 3. Monta a máscara preservando os extremos alfanuméricos e os dígitos finais
    // Formato final: XX.***.***/****-XX
    cCnpjMascarado := SUBSTR( cCnpjLimpo, 1, 2 )   + "." + ; // Mantém as 2 primeiras posições (letras ou números)
                      "***.***"                     + "/" + ; // Ofusca o miolo da empresa
                      "****"                        + "-" + ; // Ofusca o bloco de filial
                      SUBSTR( cCnpjLimpo, 13, 2 )             // Mantém os 2 dígitos verificadores (sempre numéricos)

RETURN cCnpjMascarado

/*
 * Função para ofuscar sobrenomes do meio em uma String de Nome
 */
FUNCTION MascararNome( cNomeRaw )
    LOCAL cNomeTrimmed := ALLTRIM( cNomeRaw )
    LOCAL aPalavras    := {}
    LOCAL cNomeMascarado := ""
    LOCAL nQtdPalavras := 0
    LOCAL i
    
    // 1. Quebra o nome em um array de palavras usando o espaço como delimitador
    aPalavras := HB_ATOKENS( cNomeTrimmed, " " )
    nQtdPalavras := LEN( aPalavras )
    
    // 2. Se o nome tiver apenas 1 palavra, não há o que ofuscar
    IF nQtdPalavras <= 1
        RETURN cNomeTrimmed
    ENDIF
    
    // 3. Se tiver exatamente 2 palavras (Ex: JORGE CASSIANO)
    IF nQtdPalavras == 2
        // Mantém a primeira e mascara a segunda com asteriscos do mesmo tamanho
        cNomeMascarado := aPalavras[1] + " " + REPLICATE( "*", LEN( aPalavras[2] ) )
        RETURN cNomeMascarado
    ENDIF
    
    // 4. Se tiver 3 ou mais palavras (Ex: CARLOS ALBERTO DA SILVA SOUZA)
    // Mantém a primeira palavra
    cNomeMascarado := aPalavras[1] + " "
    
    // Varre o meio do nome aplicando asteriscos correspondentes ao tamanho de cada sobrenome
    FOR i := 2 TO ( nQtdPalavras - 1 )
        cNomeMascarado += REPLICATE( "*", LEN( aPalavras[i] ) ) + " "
    NEXT
    
    // Adiciona a última palavra intacta no final
    cNomeMascarado += aPalavras[ nQtdPalavras ]

RETURN cNomeMascarado

/*
 * Função para ofuscar uma parte ALEATÓRIA da data (Dia, Mês ou Ano)
 */
FUNCTION OfuscarDataAleatoria( uDataRaw )
    LOCAL cDataText := ""
    LOCAL cDia, cMes, cAno
    LOCAL nSorteio := 0
    
    // 1. Padroniza a entrada para String (DD/MM/AAAA)
    IF VALTYPE( uDataRaw ) == "D"
        cDataText := DTOC( uDataRaw )
    ELSEIF VALTYPE( uDataRaw ) == "C"
        cDataText := ALLTRIM( uDataRaw )
    ELSE
        RETURN uDataRaw
    ENDIF
    
    // Valida o tamanho padrão de data
    IF LEN( cDataText ) != 10
        RETURN cDataText
    ENDIF
    
    // 2. Separa os pedaços originais da string
    cDia := SUBSTR( cDataText, 1, 2 )
    cMes := SUBSTR( cDataText, 4, 2 )
    cAno := SUBSTR( cDataText, 7, 4 )
    
    // 3. O PULO DO GATO: Sorteia um número entre 1 e 3
    // 1 = Esconde Dia | 2 = Esconde Mês | 3 = Esconde Ano
    nSorteio := HB_RANDINT( 1, 3 )
    
    // 4. Aplica a máscara baseada no sorteio dinâmico
    DO CASE
        CASE nSorteio == 1
            // Esconde o Dia: **/MM/AAAA
            cDia := "**"
            
        CASE nSorteio == 2
            // Esconde o Mês: DD/**/AAAA
            cMes := "**"
            
        CASE nSorteio == 3
            // Esconde o Ano: DD/MM/****
            cAno := "****"
    ENDCASE

RETURN cDia + "/" + cMes + "/" + cAno


   
FUNCTION MascararCPF( cCPF )
    // Remove pontos e traços temporariamente para garantir o tamanho (11 digitos)
    cLimpo := TIRAOUT( cCPF ) 
    
    // Pega os 3 primeiros e os 2 ultimos
    cInicio := Substr( cLimpo, 1, 3 )
    cFinal  := Substr( cLimpo, 10, 2 )
    
    // Monta a string mascarada de retorno
RETURN cInicio + ".***.***-" + cFinal



// + EOF: disk59.prg
// +
