// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk71.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Module => DISK71.PRG
// +
// +     FormataRG(Valor,cTIPO)
// +     CheckRG(Valor, lMES,cTIPO,dDATANASC,cUF )
// +     PEGDDD(cTEL)
// +     PEGTEL(cTEL)
// +     PEGPREF(cTEL,lCEL)
// +     formataTel(cNUMERO)
// +     ForTel2(cNUMERO)
// +     chkufcep(cCEP,cUF,lMES)
// +     cep2uf(cepuso)
// +     Formatacep(eCEP)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#include "INKEY.CH"




// +--------------------------------------------------------------------
// +
// +    Function FormataRG(cRG,cTIPO)
// +    cTIPO RH RNI RNE CNI CPF)
// +
// +--------------------------------------------------------------------
// +
FUNCTION FormataRG( Valor, cTIPO )

   LOCAL cRETU
   LOCAL nPOS
   LOCAL cDAC

   cDAC  := ""
   nPOS  := 0
   cRETU := ""
// So formata se o valor for caracter
   IF ValType( Valor ) <> "C"
      RETURN VALOR
   ENDIF

   IF ValType( cTIPO ) = "C"
      // RNE E RIC sem formatacao
      IF cTIPO = "RNE" .OR. cTIPO = "RIC"
         RETURN VALOR
      ENDIF
      // CPF E CNI formatacao CPF
      IF cTIPO = "CPF" .OR. cTIPO = "CNI"
         RETURN formatacpf( valor )
      ENDIF
   ENDIF

// Tipo escrito no valor
// ISENT RNE RIC sem formatacao
   IF At( "ISENT", Upper( valor ) ) > 0 .OR. At( "RNE", Upper( valor ) ) > 0 .OR. At( "RIC", Upper( valor ) ) > 0   // registro nacional estrangeiro isentos(incricao estadual no campo)
      RETURN VALOR
   ENDIF

// CPF E CNI formatacao CPF
   IF At( "CPF", Upper( valor ) ) > 0 .OR. At( "CNI", Upper( valor ) ) > 0
      RETURN formatacpf( valor )
   ENDIF

// sem valor nao formata
   IF Val( tiraout( valor ) ) = 0
      RETURN valor
   ENDIF

// sem tipo mas se validar CPF formata como CPF
   IF VALCPF( VALOR, .F. )
      RETURN formatacpf( valor )
   ENDIF
// gerando o DAC verificador as vezes e prenchido o Rg SEM o dac
   valor := AllTrim( valor )
   valor := Upper( valor )
   nPOS  := At( "-", Valor )
   IF nPOS = 0
      valor := tiraout( Valor )
      valor := AllTrim( valor )
      IF Len( VALOR ) = 9
         cDAC  := SubStr( VALOR, 9, 1 )
         valor := SubStr( valor, 1, 8 )
      ENDIF
   ELSE
      cDAC  := SubStr( Valor, nPOS + 1, 1 )
      Valor := SubStr( Valor, 1, nPOS - 1 )
      IF cDAC = "x"
         cDAC := "X"
      ENDIF
      IF cDAC <> "X"   // 'evita erros como -- -. -/ caracter inves de numero no dac
         cDAC := Str( Val( cDAC ), 1 )
      END IF
   END IF
   valor := StrTran( valor, "x", "" )  // x-X
   valor := StrTran( valor, "X", "" )  // X-X
   valor := tiraout( Valor )
   valor := AllTrim( valor )
// formata conforme a quantidade de digitos sem o dac
   DO CASE
   CASE Len( VALOR ) = 8
      Valor := AllTrim( Str( Val( SubStr( Valor, 1, 8 ) ), 8 ) )
      cRETU := Trim( SubStr( Valor, 1, 2 ) + "." + SubStr( Valor, 3, 3 ) + "." + SubStr( Valor, 6 ) )
   CASE Len( VALOR ) = 7
      Valor := AllTrim( Str( Val( SubStr( Valor, 1, 8 ) ), 7 ) )
      cRETU := Trim( SubStr( Valor, 1, 1 ) + "." + SubStr( Valor, 2, 3 ) + "." + SubStr( Valor, 5 ) )
   OTHERWISE
      cRETU := VALOR
   ENDCASE
// inclui o DAC
   IF !Empty( cDAC )
      cRETU := cRETU + "-" + cDAC
   END IF
   IF Left( cRETU, 1 ) = "0"
      cRETU := SubStr( cRETU, 2 )
   END IF
   IF Left( cRETU, 1 ) = "."
      cRETU := SubStr( cRETU, 2 )
   END IF

   RETURN cRETU


/*
 * Funзгo inteligente para ofuscar RG (Identifica o padrгo antigo ou o novo unificado/CPF)
 */
FUNCTION MascararRG( cRgRaw )
    LOCAL cRgLimpo := ""
    LOCAL cRgMascarado := ""
    LOCAL i, cChar, nLen
    
    // 1. Limpa a string deixando apenas nъmeros (RG antigo e CPF usam apenas nъmeros na essкncia)
    FOR i := 1 TO LEN( cRgRaw )
        cChar := SUBSTR( cRgRaw, i, 1 )
        IF cChar >= "0" .AND. cChar <= "9"
            cRgLimpo += cChar
        ENDIF
    NEXT
    
    nLen := LEN( cRgLimpo )
    
    // Se estiver vazio, devolve o que veio original
    IF nLen == 0
        RETURN cRgRaw
    ENDIF

    // 2. DESVIO INTELIGENTE BASEADO NO TAMANHO
    
    IF nLen == 11
        // --- NOVO PADRГO: Identidade Nacional (CPF) ---
        // Mбscara: XXX.***.***-XX
        cRgMascarado := SUBSTR( cRgLimpo, 1, 3 ) + "." + ; // Mantйm os 3 primeiros
                        "***.***"                 + "-" + ; // Oculta o miolo
                        SUBSTR( cRgLimpo, 10, 2 )           // Mantйm os 2 ъltimos dнgitos
                        
    ELSE
        // --- PADRГO ANTIGO: RG Estadual (7 a 9 dнgitos) ---
        // Como varia por estado, mantemos visнveis os 2 primeiros caracteres e o ъltimo dнgito
        IF nLen > 3
            cRgMascarado := SUBSTR( cRgLimpo, 1, 2 ) + "." + ;
                            REPLICATE( "*", nLen - 3 ) + "-" + ;
                            SUBSTR( cRgLimpo, nLen, 1 )
        ELSE
            // Se o dado for curtнssimo/invбlido, apenas preenche com asteriscos
            cRgMascarado := REPLICATE( "*", nLen )
        ENDIF
    ENDIF

RETURN cRgMascarado

// +--------------------------------------------------------------------
// +
// +    Function CheckRG(Valor, lMES,cTIPO,dDATANASC,cUF )
// +
// +--------------------------------------------------------------------
// +
FUNCTION CheckRG( Valor, lMES, cTIPO, dDATANASC, cUF )

   LOCAL d
   LOCAL soma
   LOCAL nPOS
   LOCAL cDAC
   LOCAL x
   LOCAL p1
   LOCAL aPESOS

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETURN .T.   // Mandou Prosseguir
   ENDIF

   IF ValType( lMES ) # "L"
      lmes := .T.
   ENDIF
   ZDAC   := " "
   ZNERRO := 0
   ZERRO  := ""
   IF ValType( cTIPO ) = "C" .AND. At( "ISENT", valor ) > 0
      RETURN .T.
   ENDIF
   IF Len( Valor ) = 0
      znerro := 7
      zerro  := "RG/RNE/RIC/CPF/CNI em branco"
   ENDIF
   IF ( ValType( cTIPO ) = "C" .AND. cTIPO = "RNE" ) .OR. At( "RNE", valor ) > 0
      RETURN .T.
   ENDIF
   IF At( "CPF", valor ) > 0
      cTIPO := "CPF"
      valor := StrTran( valor, 'CPF', '' )
   ENDIF
// Valida do CPF
   IF Valcpf( VALOR, .F. )
      IF ValType( cTIPO ) <> "C" .OR. ( ValType( cTIPO ) = "C" .AND. ( cTIPO <> "CPF" .OR. cTIPO <> "CNI" ) )
         IF LMES
            ALERTX( "Preencha o tipo como CPF ou CNI" )
         ENDIF
         RETURN .T.
      ENDIF
   ENDIF
   IF At( "RIC", valor ) > 0
      cTIPO := "RIC"
      valor := StrTran( valor, 'RIC', '' )
   ENDIF
   Valor := StrTran( Valor, ".", "" )  // tiraout tambem tira o traco(-)usado no DAC nao pode ser usada aqui

// IF LEN(valor)=11 AS Vezes o RG e digitado errado com 11 digitos somente 11 digitos nao garante que e RIC //Agora valida cpf que tambem e 11
// cTIPO:="RIC"
// ENDIF
   IF ValType( cTIPO ) <> 'C'
      cTIPO := "RG"
   ENDIF

   FOR X := 0 TO 9
      P1 := TIRAOUT( valor )
      IF p1 = repl( Str( X, 1 ), 11 )
         znerro := 6
         zerro  := "RG Invalido - Sequencia Repetitiva de " + Str( X, 1 )
      ENDIF
   NEXT X
   nPOS := At( "-", Valor )
   IF nPOS = 0
      cDAC := " "
   ELSE
      cDAC  := SubStr( Valor, nPOS + 1, 1 )
      Valor := SubStr( Valor, 1, nPOS - 1 )
   END IF
   Valor := Str( Val( Valor ) )
   IF Len( AllTrim( Valor ) ) <= 7 .AND. cTIPO = 'RG' .AND. ( Empty( CUF ) .OR. cUF = "SP" )
      IF ValType( dDATANASC ) <> "D" .OR. dDATANASC > CToD( '31/12/1990' )
         zerro  := "RG com Menos de 7 Digitos"
         znerro := 3
      ENDIF
   END IF
   IF Len( AllTrim( Valor ) ) > 9 .AND. ( cTIPO = 'RG' .OR. Empty( cTIPO ) ) .AND. ( Empty( CUF ) .OR. cUF = "SP" )
      zerro  := "RG com Mais de 9 Digitos"
      znerro := 8
   END IF

   IF cTIPO = 'RIC'
      IF Len( AllTrim( Valor ) ) <> 11
         zerro  := "RIC nao tem 11 Digitos"
         znerro := 9
      ELSE
         aPESOS := { 8, 9, 2, 3, 4, 5, 6, 7, 8, 9 }
         soma   := 0
         FOR X := 1 TO 10
            soma += Val( SubStr( valor, X, 1 ) ) * aPESOS[ X ]
         NEXT X
         d := Mod( soma, 11 )
         IF d = 10
            d := 0
         ENDIF
         IF d <> Val( SubStr( valor, 11, 1 ) )
            zDAC   := StrZero( D, 1, 0 )
            zerro  := "Digito de Controle RIC " + SubStr( valor, 11, 1 ) + " Nao Confere sugerido: " + zDAC
            znerro := 10
         ENDIF
      ENDIF
   END IF
   IF ZNERRO = 0 .AND. cTIPO = 'RG' .AND. Len( VALOR ) = 8
      Valor := StrZero( Val( Valor ), 8 )
      SOMA  := Val( SubStr( Valor, 1, 1 ) ) * 9
      SOMA  += Val( SubStr( Valor, 2, 1 ) ) * 8
      SOMA  += Val( SubStr( Valor, 3, 1 ) ) * 7
      SOMA  += Val( SubStr( Valor, 4, 1 ) ) * 6
      SOMA  += Val( SubStr( Valor, 5, 1 ) ) * 5
      SOMA  += Val( SubStr( Valor, 6, 1 ) ) * 4
      SOMA  += Val( SubStr( Valor, 7, 1 ) ) * 3
      SOMA  += Val( SubStr( Valor, 8, 1 ) ) * 2
      d     := soma - ( Floor( soma / 11 ) * 11 )
      IF cDAC = "X" .OR. cDAC = "x" .OR. cDAC = " "
         IF D = 10
            RETURN .T.
         ELSE
            zDAC   := StrZero( D, 1, 0 )
            znerro := 5
            zerro  := "Digito de Controle RG " + cDAC + " Nao Confere sugerido: " + zDAC
         ENDIF
      ELSE
         IF d = Val( cDAC ) .OR. d = 0
         ELSE
            IF d = 10
               zDAC  := "X"
               zerro := "Digito de Controle RG Nao Confere sugerido: X"
            ELSE
               zDAC  := StrZero( D, 1, 0 )
               zerro := "Digito de Controle RG Nao Confere sugerido: " + zDAC
            ENDIF
            znerro := 4
         END IF
      ENDIF
   ENDIF
   IF ZNERRO > 0
      IF lMES
         ALERTX( zerro )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +    Function PEGDDD(cTEL)
// +
// +--------------------------------------------------------------------
// +
FUNCTION PEGDDD( cTEL )

   LOCAL cPEGDDD

   cTEL    := formataTel( cTEL )
   cPEGDDD := ""
   IF At( "(", cTEl ) > 0
      cPEGDDD := SubStr( cTEL, 2, 2 )
   ENDIF

   RETURN cPEGDDD

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function PEGTEL(cTEL)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGTEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGTEL( cTEL )

   LOCAL cPEGTEL

   cTEL    := formataTel( cTEL )
   cPEGTEL := cTEL
   IF At( "(", cTEl ) > 0
      cPEGTEL := SubStr( cTEL, 5 )
   ENDIF

   RETURN cPEGTEL

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function PEGPREF(cTEL)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGPREF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGPREF( cTEL, lCEL )

   LOCAL cPEGREF

   IF ValType( lCEL ) <> "L"
      lCEL := .T.
   ENDIF
// cTEL = tem que ser so o numero telefone sem o ddd antes de chamar usar pegtel se necessario
   cPEGREF := ""
   IF At( "-", cTEL ) > 0
      cPEGREF := SubStr( cTEL, 1, At( "-", cTEL ) - 1 )
      IF lCEL
         IF Len( cPEGREF ) = 5 .AND. Left( cPEGREF, 1 ) = "9"   // Celular com 9
            cPEGREF := SubStr( cPEGREF, 2 )
         ENDIF
      ENDIF
   END IF
   RETU cPEGREF



// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function formataTel(cNUMERO)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formataTel()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION formataTel( cNUMERO )

/*
 +formata nacional brasil +55 -> ddi+ (DDD)telefone
 +55 (99)1234-5678

 remove 0 do ddd
 (099)12345678 ->(99)1234-5678
 099 12345678 ->(99)1234-5678
 099-12345678 ->(99)1234-5678
 099.12345678 ->(99)1234-5678
 091,12345678 ->(99)1234-5678

 ddd em parentes
 99-12435678 ->(99)1234-5678
 99,12345678 ->(99)1234-5678
 99.12345678 ->(99)1234-5678
 99 12345678 ->(99)1234-5678

 espaco virgula e ponto para traco
 1234 5678 1234-5678
 1234,5678 1234-5678
 1234.5678 1234-5678

 formata para 11 10 9 8 7 digitos
 12345678901    ->(99)91234-5678  //celular  11 digitos
 1234567890     ->(99)1234-5678   //telefone 10 digitos
 123456789      ->91234-5678      //celular sem ddd   9 digitos
 12345678       ->1234-5678       //telefone sem ddd  8 digitos
 1234567        ->123-4567        //telefone antigos  7 digitos  999-9999

*/

   LOCAL lDDIBR

   lDDIBR := .F.

   cNUMERO := AllTrim( cNUMERO )

   IF SubStr( cNUMERO, 1, 4 ) = "0300" .OR. SubStr( cNUMERO, 1, 4 ) = "0800" .OR. SubStr( cNUMERO, 1, 4 ) = "0900" ;
         .OR. SubStr( cNUMERO, 1, 4 ) = "0500" .OR. SubStr( cNUMERO, 1, 4 ) = "0303"
      // atendimentos fixos nacionais
      // 0800 atendimento cliente sem cobranca
      // 0300 cobranca empresas de credito
      // 0303 telemarketing
      // 0900  atendimento cliente com cobranca
      // 0500 governamental
      RETURN cNUMERO
   ENDIF

   IF SubStr( cNUMERO, 1, 1 ) = "+"  // "+1 "  "+11 " "+111 " "+1("  "+11(" "+111(" DDD 1 A 3 digitos espacos ou ( parentes do ddd
      IF SubStr( cNUMERO, 1, 3 ) <> "+55"  // se nao for do brasil retorna sem formatacao
         RETURN cNUMERO
      ENDIF
      lDDIBR  := .T.
      cNUMERO := AllTrim( SubStr( cNUMERO, 4 ) )  // usa trim caso depois do +55 seja espaco "+55 "  formata so o numero ddi sera reincluido no final
   ENDIF
   cNUMERO := StrTran( cNUMERO, " ", "" )


   IF SubStr( cNUMERO, 1, 1 ) = "(" .AND. SubStr( cNUMERO, 4, 1 ) = ")"  // (99)12345678
      cNUMERO := SubStr( cNUMERO, 1, 4 ) + fortel2( SubStr( cNUMERO, 5 ) )
   END IF
   IF SubStr( cNUMERO, 3, 1 ) = "-"  // 99-12345678 traco apos o ddd
      cNUMERO := "(" + SubStr( cNUMERO, 1, 2 ) + ")" + fortel2( SubStr( cNUMERO, 4 ) )
   END IF
   IF SubStr( cNUMERO, 3, 1 ) = ","  // 99,12345678 virgula apos o ddd
      cNUMERO := "(" + SubStr( cNUMERO, 1, 2 ) + ")" + fortel2( SubStr( cNUMERO, 4 ) )
   END IF
   IF SubStr( cNUMERO, 3, 1 ) = "."  // 99.12345678 ponto apos o ddd
      cNUMERO := "(" + SubStr( cNUMERO, 1, 2 ) + ")" + fortel2( SubStr( cNUMERO, 4 ) )
   END IF
   IF SubStr( cNUMERO, 3, 1 ) = " "  // 99 12345678 spaco apos o ddd
      cNUMERO := "(" + SubStr( cNUMERO, 1, 2 ) + ")" + fortel2( SubStr( cNUMERO, 4 ) )
   END IF
   IF SubStr( cNUMERO, 4, 1 ) = "-" .AND. SubStr( cNUMERO, 1, 1 ) = "0"  // 099-12345678 ddd nao tem 0 na frente 0
      cNUMERO := "(" + SubStr( cNUMERO, 2, 2 ) + ")" + fortel2( SubStr( cNUMERO, 5 ) )
   END IF
   IF SubStr( cNUMERO, 4, 1 ) = " " .AND. SubStr( cNUMERO, 1, 1 ) = "0"  // 099 12345678
      cNUMERO := "(" + SubStr( cNUMERO, 2, 2 ) + ")" + fortel2( SubStr( cNUMERO, 5 ) )
   END IF
   IF SubStr( cNUMERO, 4, 1 ) = "-" .AND. SubStr( cNUMERO, 1, 1 ) = "0"  // 099-12345678
      cNUMERO := "(" + SubStr( cNUMERO, 2, 2 ) + ")" + fortel2( SubStr( cNUMERO, 5 ) )
   END IF
   IF SubStr( cNUMERO, 4, 1 ) = "." .AND. SubStr( cNUMERO, 1, 1 ) = "0"  // 099.12345678
      cNUMERO := "(" + SubStr( cNUMERO, 2, 2 ) + ")" + fortel2( SubStr( cNUMERO, 5 ) )
   END IF
   IF SubStr( cNUMERO, 1, 1 ) = "(" .AND. SubStr( cNUMERO, 2, 1 ) = "0" .AND. SubStr( cNUMERO, 5, 1 ) = ")"  // (099)12345678
      cNUMERO := "(" + SubStr( cNUMERO, 3, 2 ) + ")" + fortel2( SubStr( cNUMERO, 6 ) )
   END IF
   IF At( "(", cNUMERO ) = 0 .AND. At( "-", cNUMERO ) = 0  // somente numeros
      DO CASE
      CASE Len( cNUMERO ) = 10
         cNUMERO := "(" + Left( cNUMERO, 2 ) + ")" + SubStr( cNUMERO, 3, 4 ) + "-" + SubStr( cNUMERO, 7 )
      CASE Len( cNUMERO ) = 11
         cNUMERO := "(" + Left( cNUMERO, 2 ) + ")" + SubStr( cNUMERO, 3, 5 ) + "-" + SubStr( cNUMERO, 8 )
      CASE Len( cNUMERO ) = 9 .OR. Len( cNUMERO ) = 8 .OR. Len( cNUMERO ) = 7
         cNUMERO := ForTel2( cNUMERO )
      ENDCASE
   ENDIF
   IF lDDIBR
      cNUMERO := "+55 " + cNUMERO
   ENDIF

   RETURN cNUMERO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ForTel2(cNUMERO)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ForTel2( cNUMERO )

   cNUMERO := AllTrim( tiraout( cNUMERO ) )  // nao checa mais o traco, ponto, ponto virgula pois foi usado tiraout
   IF Len( cNUMERO ) = 9   // .And. SUBSTR(cNUMERO, 6, 1)='-'    //912345678 91234-5678 Novo celular 9
      cNUMERO := SubStr( cNUMERO, 1, 5 ) + "-" + SubStr( cNUMERO, 6 )
   END IF
   IF Len( cNUMERO ) = 8   // .And. SUBSTR(cNUMERO, 5, 1)='-'    //12345678 1234-5678
      cNUMERO := SubStr( cNUMERO, 1, 4 ) + "-" + SubStr( cNUMERO, 5 )
   END IF
   IF Len( cNUMERO ) = 7   // 123-4567 1234567 //Algums localidades antigas 7 digitos
      cNUMERO := SubStr( cNUMERO, 1, 3 ) + "-" + SubStr( cNUMERO, 4 )
   END IF

   RETURN cNUMERO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FormataCEP(eCEP)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FormataCEP( eCEP )

   IF ValType( eCEP ) = "N"
      eCEP := StrZero( eCEP, 8 )
   ENDIF
   eCEP := AllTrim( eCEP )
   IF At( "-", eCEP ) = 0 .AND. Len( eCEP ) = 8
      eCEP := Left( eCEP, 5 ) + "-" + Right( eCEP, 3 )
   ENDIF

   RETURN eCEP




// +--------------------------------------------------------------------
// +
// +    Function chkufcep(cCEP, cUF, lMES)
// +
// +--------------------------------------------------------------------
// +
FUNCTION chkufcep( cCEP, cUF, lMES )

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.   // Mandou Proceguir
   ENDIF
   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF
   IF cep2uf( cCEP ) <> cUF
      IF lMES
         ALERTX( "CEP:" + cCEP + " nao e da UF:" + cUF )
      ENDIF
      RETU .F.
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +    Function cep2uf(cepuso)
// +
// +--------------------------------------------------------------------
// +

FUNCTION cep2uf( cepuso )

   LOCAL cep2uf

   cepuso := tiraout( cepuso )
   cepuso := Val( cepuso )
   cep2uf := "EX"
   DO CASE
   CASE cepuso >= 01000000 .AND. cepuso <= 19999999
      cep2uf := "SP"
   CASE cepuso >= 20000000 .AND. cepuso <= 28999999
      cep2uf := "RJ"
   CASE cepuso >= 29000000 .AND. cepuso <= 29999999
      cep2uf := "ES"
   CASE cepuso >= 30000000 .AND. cepuso <= 39999999
      cep2uf := "MG"
   CASE cepuso >= 40000000 .AND. cepuso <= 48999999
      cep2uf := "BA"
   CASE cepuso >= 49000000 .AND. cepuso <= 49999999
      cep2uf := "SE"
   CASE cepuso >= 50000000 .AND. cepuso <= 56999999
      cep2uf := "PE"
   CASE cepuso >= 57000000 .AND. cepuso <= 57999999
      cep2uf := "AL"
   CASE cepuso >= 58000000 .AND. cepuso <= 58999999
      cep2uf := "PB"
   CASE cepuso >= 59000000 .AND. cepuso <= 59999999
      cep2uf := "RN"
   CASE cepuso >= 60000000 .AND. cepuso <= 63999999
      cep2uf := "CE"
   CASE cepuso >= 64000000 .AND. cepuso <= 64999999
      cep2uf := "PI"
   CASE cepuso >= 65000000 .AND. cepuso <= 65999999
      cep2uf := "MA"
   CASE cepuso >= 66000000 .AND. cepuso <= 68899999
      cep2uf := "PA"
   CASE cepuso >= 68900000 .AND. cepuso <= 68999999
      cep2uf := "AP"
   CASE cepuso >= 69000000 .AND. cepuso <= 69299999
      cep2uf := "AM"   // 1a faixa amazonas
   CASE cepuso >= 69300000 .AND. cepuso <= 69399999
      cep2uf := "RR"
   CASE cepuso >= 69400000 .AND. cepuso <= 69899999
      cep2uf := "AM"   // 2a faixa amazonas
   CASE cepuso >= 69900000 .AND. cepuso <= 69999999
      cep2uf := "AC"
   CASE cepuso >= 70000000 .AND. cepuso <= 72799999
      cep2uf := "DF"   // 1a Faixa Distrito Federal
   CASE cepuso >= 72800000 .AND. cepuso <= 72999999
      cep2uf := "GO"   // 1a faixa de Goias
   CASE cepuso >= 73000000 .AND. cepuso <= 73699999
      cep2uf := "DF"   // 2a. faixa distrito federal
   CASE cepuso >= 73700000 .AND. cepuso <= 76799999
      cep2uf := "GO"   // 2a; faixa de Goias
   CASE cepuso >= 77000000 .AND. cepuso <= 77999999
      cep2uf := "TO"
   CASE cepuso >= 78000000 .AND. cepuso <= 78899999
      cep2uf := "MT"
   CASE cepuso >= 78900000 .AND. cepuso <= 78999999
      cep2uf := "RO"
   CASE cepuso >= 79000000 .AND. cepuso <= 79999999
      cep2uf := "MS"
   CASE cepuso >= 80000000 .AND. cepuso <= 87999999
      cep2uf := "PR"
   CASE cepuso >= 88000000 .AND. cepuso <= 89999999
      cep2uf := "SC"
   CASE cepuso >= 90000000 .AND. cepuso <= 99999999
      cep2uf := "RS"
   OTHERWISE
      cep2uf := "EX"
   ENDCASE

   RETURN cep2uf

// + EOF: disk71.prg
// +
