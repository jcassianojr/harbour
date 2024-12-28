// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk06.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +




#include "INKEY.CH"
// +$arr_uf = array(
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TituloUF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TituloUF( cTITULO )

   LOCAL cRETU, cUF
   LOCAL aCOD, aUF
   LOCAL nPOS

   cRETU := ''
   IF ValType( CTITULO ) = "N"
      CTITULO := StrZero( CTITULO, 13, 0 )
   ELSE
      CTITULO := AllTrim( CTITULO )
   ENDIF
   IF Len( CTITULO ) < 13
      CTITULO := Replicate( "0", 13 - Len( CTITULO ) ) + CTITULO
   ENDIF
   aCOD  := { '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28' }
   aUF   := { 'SP', 'MG', 'RJ', 'RS', 'BA', 'PR', 'CE', 'PE', 'SC', 'GO', 'MA', 'PB', 'PA', 'ES', 'PI', 'RN', 'AL', 'MT', 'MS', 'DF', 'SE', 'AM', 'RO', 'AC', 'AP', 'RR', 'TO', 'EX' }
   cRETU := ''
   cUF   := SubStr( cTITULO, 10, 2 )   // UF dig 9-10 porem padronizando para treze digitos passar para a posicao dez
   nPOS  := AScan( aCOD, cUF )
   IF nPOS > 0
      cRETU := aUF[ nPOS ]
   ENDIF
   RETU cRETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CheckTitulo()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CheckTitulo( NUMERO, lMES )

   LOCAL DV1
   LOCAL DV2
   LOCAL RESTO
   LOCAL resto2
   LOCAL cTITULO

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF

   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   cTITULO := STRVAL( NUMERO )
   cTITULO := AllTrim( TIRAOUT( cTITULO ) )
   IF Len( cTITULO ) <> 12 .OR. Len( cTITULO ) <> 13
      ZNERRO := 4
      ZERRO  := "Titulo nao tem 12 ou 13 digitos"
   ENDIF

// ajusta titulo de 12 digitos para 13 digitos=SP/MG
   IF ValType( NUMERO ) = "N"
      Numero := StrZero( NUMERO, 13, 0 )
   ELSE
      NUMERO := AllTrim( NUMERO )
   ENDIF
   IF Len( NUMERO ) < 13
      NUMERO := Replicate( "0", 13 - Len( NUMERO ) ) + NUMERO
   ENDIF

   ZNERRO := 0
   ZERRO  := ""

   IF Val( SubStr( Numero, 10, 2 ) ) > 28
      ZNERRO := 3
      ZERRO  := "Titulo Digito do Estado Invalido " + SubStr( Numero, 10, 2 )
   ENDIF



   DV1 := ( ( Val( SubStr( Numero, 1, 1 ) ) * 2 ) + ;
      ( Val( SubStr( Numero, 2, 1 ) ) * 9 ) + ;
      ( Val( SubStr( Numero, 3, 1 ) ) * 8 ) + ;
      ( Val( SubStr( Numero, 4, 1 ) ) * 7 ) + ;
      ( Val( SubStr( Numero, 5, 1 ) ) * 6 ) + ;
      ( Val( SubStr( Numero, 6, 1 ) ) * 5 ) + ;
      ( Val( SubStr( Numero, 7, 1 ) ) * 4 ) + ;
      ( Val( SubStr( Numero, 8, 1 ) ) * 3 ) + ;
      ( Val( SubStr( Numero, 9, 1 ) ) * 2 ) )

   RESTO := Mod( DV1, 11 )

   IF RESTO = 1
      DV1 := 0
   ELSE
      IF RESTO = 0
         IF SubStr( Numero, 10, 2 ) = "01" .OR. SubStr( numero, 10, 2 ) = "02"
            DV1 := 1
         ELSE
            DV1 := 0
         END IF
      ELSE
         DV1 := 11 - resto
      END IF
   END IF

// Aplica DV da UF
   DV2    := ( ( Val( SubStr( Numero, 10, 1 ) ) * 4 ) + ( Val( SubStr( Numero, 11, 1 ) ) * 3 ) + ( DV1 * 2 ) )
   Resto2 := Mod( DV2, 11 )

   IF Resto2 = 1
      DV2 := 0
   ELSE
      IF Resto2 = 0
         IF SubStr( Numero, 10, 2 ) = "01" .OR. SubStr( Numero, 10, 2 ) = "02"
            DV2 := 1
         ELSE
            DV2 := 0
         END IF
      ELSE
         DV2 := 11 - Resto2
      END IF
   END IF

// checa dv digitos 12 e 13
   IF SubStr( Numero, 12, 2 ) = Str( DV1, 1 ) + Str( DV2, 1 )
   ELSE
      ZNERRO := 2
      zerro  := "Digitos de Controle titulo Nao Confere sugerido: " + SubStr( numero, 1, 11 ) + "/" + Str( DV1, 1 ) + Str( DV2, 1 )
   END IF
   IF znerro > 0
      IF Lmes
         ALERTX( zerro )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function valcns()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION valcns( cCNS, lMES )

   LOCAL X, soma, resto, dv

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   ZNERRO := 0
   ZERRO  := ""
   cCNS   := TIRAOUT( cCNS )
   IF Val( cCNS ) = 0
      ZERRO  := "Numero cns Nao Informado(em Branco)"
      ZNERRO := 1
   ENDIF
   IF ZNERRO = 0
      IF Len( AllTrim( cCNS ) ) <> 15
         ZERRO  := 'CNS nao tem 15 digitos ' + Str( Len( AllTrim( cCNS ) ), 0 )
         ZNERRO := 2
      ENDIF
      IF SubStr( cCNS, 1, 1 ) $ "789"
         soma := 0
         FOR x := 1 TO 15
            soma += Val( SubStr( ccns, X, 1 ) ) * ( 16 - x )
         NEXT x
         RESTO := Mod( soma, 11 )
         IF RESTO <> 0
            ZERRO  := 'CNS invalido'
            ZNERRO := 3
         ELSE
            RETURN .T.
         ENDIF
      ELSE
         soma := 0
         FOR x := 1 TO 11
            soma += Val( SubStr( ccns, X, 1 ) ) * ( 16 - x )
         NEXT x
         RESTO := Mod( soma, 11 )
         dv    := 11 - resto
         IF dv = 11
            dv := 0
         ENDIF
         IF dv = 10
            soma  += 2
            RESTO := Mod( soma, 11 )
            dv    := 11 - resto
            IF cCNS <> SubStr( cCNS, 1, 11 ) + '001' + Str( dv, 1 )
               ZERRO  := 'CNS invalido'
               ZNERRO := 3
            ENDIF
         ELSE
            IF ccns <> SubStr( cCNS, 1, 11 ) + '000' + Str( dv, 1 )
               ZERRO  := 'CNS invalido'
               ZNERRO := 3
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF znerro > 0
      IF Lmes
         ALERTX( zerro )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formataRICI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION formataRICI( cRICI )

   cRICI := TIRAOUT( cRICI )
   cRICI := AllTrim( cRICI )
// cRICI:=VAL(cRICI) estava cortando digitos possivel erro de precisao da funcao valsao que e 32 carateres
// cRICI:=STRZERO(cRIRI,32)
   cRICI := Transform( cRICI, "@R 999999.99.99.9999.9.99999.999.9999999-99" )

   RETURN cRICI



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKRICI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECKRICI( VALOR, lMES )

/*
certidao nascimento
11520401552010112345123123456712 (32 digitos)
115204 01 55 2010 1 12345 123 1234567 12
XXXXXX.XX.XX.XXXX.X.XXXXX.XXX.XXXXXXX-XX
  A     B C    D  E  F     G        H  I
1234567890123456789012345678901234567890
A  Código Nacional da Serventia (6 primeiros números da matrícula - Ex.: 115204), o qual deve ser obtido no site do CNJ pelos cartórios,
B  Código do acervo (7º e 8º números da matrícula) sendo:
   01 para acervo próprio e
   02 para os acervos incorporados até 31/12/2009, último dia antes da implementação do Código Nacional por todos os registradores civis das pessoas naturais (nesse caso os seis primeiros números serão aqueles da serventia incorporadora). As certidões extraídas de acervos incorporados a partir de 1º de
   janeiro de 2010 (acervo de serventias que já possuíam código nacional próprio por ocasião da incorporação) utilizarão o código da serventia incorporada e o código de acervo 01;
C  Código 55 (9º e 10º números da matrícula), que é o número relativo ao serviço de registro civil das pessoas naturais;
D   Ano do registro do qual se extrai a certidão, com 04 dígitos (11º, 12º, 13º e 14º números da matrícula - Ex.: 2010);
E  Tipo do livro de registro, com um digito numérico (15º número da matrícula - Ex.: 1= Nascimento) sendo:
   1: Livro A (Nascimento)
   2: Livro B (Casamento)
   3: Livro B Auxiliar (Casamento Religioso com efeito civil)
   4: Livro C (Óbito)
   5: Livro C Auxiliar (Natimorto)
   6: Livro D (Registro de Proclamas)
   7: Livro E (Demais atos relativos ao registro civil ou livro E único);
   8: Livro E (Desdobrado para registro especifico das Emancipações);
   9: Livro E (Desdobrado para registro especifico das Interdições);
   Obs.: No GIL deve-se registrar 91- Nascimento, 92-Casamento, ...
F   Número do livro, com cinco dígitos (Ex.: 12345), os quais corresponderão ao 16º, 17º, 18º, 19º e 20º números da matrícula;
G    Número da folha do registro, com três dígitos (21º, 22º e 23º números da matrícula - Ex.: 123);
H     Número do termo na respectiva folha em que foi iniciado, com sete dígitos (Ex.: 1234567), os quais corresponderão aos 24º, 25º, 26º, 27º, 28º, 29º, 30º números da matrícula;
I   Número do dígito verificador (31º e 32º números da matrícula - Ex.: 12),formado automaticamente por meio do programa que pode ser baixado gratuitamente por meio do seguinte endereço eletrônico: www.cnj.jus.br/corregedoria/.
*/

   LOCAL aPESOS, SOMA, X, D

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   ZERRO  := ""
   ZNERRO := 0
   VALOR  := TIRAOUT( VALOR )
   IF Val( VALOR ) = 0
      ZERRO  := "Numero RICI Nao Informado(em Branco)"
      ZNERRO := 3
   ENDIF
   IF Len( AllTrim( VALOR ) ) <> 32
      ZERRO  := 'RICI nao tem 32 digitos ' + Str( Len( AllTrim( VALOR ) ), 0 )
      ZNERRO := 4
   ENDIF


   IF ZNERRO = 0
      // aPESOS:={2,3,4,5,6,7,8,9,10,0,1,2,3,4,5,6,7,8,9,10,0,1,2,3,4,5,6,7,8,9}
      // digitos ** esses dígitos, do 3º e do 5º grupo, são desprezados na formação do DV  digitos 9/10/15
      // 1 0 4 5 3 9 0 1 5 5 2 0 1 3 1 0 0 0 1 2  0 2 1 0 0 0 0 1 2 3
      // 1  0  4  5  3  9  0  1  5  5  2  0  1  3  1  0  0  0  1  2  0  2  1  0  0  0  0  1  2  3 = 2
      // x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x
      // 2  3  4  5  6  7  8  9 10  0  1  2  3  4  5  6  7  8  9 10  0  1  2  3  4  5  6  7  8  9
      // ----------------------------------------------------------------------------------------
      // 2+ 0+16+25+18+63+ 0+ 9+**+**+ 2+ 0+ 3+12+**+ 0+ 0+ 0+ 9+20+ 0+ 2+ 2+ 0+ 0+ 0+ 0+ 7+16+27 = 233

      aPESOS := { 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 1, 2, 3, 4, 0, 6, 7, 8, 9, 10, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
      soma   := 0
      FOR X := 1 TO 30
         soma += Val( SubStr( valor, X, 1 ) ) * aPESOS[ X ]
      NEXT X
      d := Mod( soma, 11 )
      IF d = 10
         // d:=0
         d := 1
      ENDIF
      IF d <> Val( SubStr( valor, 31, 1 ) )
         zDAC   := StrZero( D, 1, 0 )
         zerro  := "1. Digito de Controle RIC " + SubStr( valor, 31, 1 ) + " Nao Confere sugerido: " + zDAC
         znerro := 1
      ENDIF

      // aPESOS:={1,2,3,4,5,6,7,8,9,10,0,1,2,3,4,5,6,7,8,9,10,0,1,2,3,4,5,6,7,8,9}
      // digitos ** esses dígitos, do 3º e do 5º grupo, são desprezados na formação do DV digitos 9/10/15
      // 1 0 4 5 3 9 0 1 5 5 2 0 1 3 1 0 0 0 1 2  0 2 1 0 0 0 0 1 2 3 2
      // 1  0  4  5  3  9  0  1  5  5  2  0  1  3  1  0  0  0  1  2  0  2  1  0  0  0  0  1  2  3  2 = 1
      // x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x
      // 1  2  3  4  5  6  7  8  9 10  0  1  2  3  4  5  6  7  8  9 10  0  1  2  3  4  5  6  7  8  9
      // -------------------------------------------------------------------------------------------
      // 1+ 0+12+20+15+54+ 0+ 8+**+**+ 0+ 0+ 2+ 9+**+ 0+ 0+ 0+ 8+18+ 0+ 0+ 1+ 0+ 0+ 0+ 0+ 6+14+24+18 = 210

      aPESOS := { 1, 2, 3, 4, 5, 6, 7, 8, 0, 0, 0, 1, 2, 3, 0, 5, 6, 7, 8, 9, 10, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
      soma   := 0
      FOR X := 1 TO 31
         soma += Val( SubStr( valor, X, 1 ) ) * aPESOS[ X ]
         // (str(VAL(SUBSTR(valor,X,1))*aPESOS[X]))
      NEXT X
      d := Mod( soma, 11 )
      IF d = 10
         // d:=0
         d := 1
      ENDIF
      IF d <> Val( SubStr( valor, 32, 1 ) )
         zDAC   := StrZero( D, 1, 0 )
         zerro  := "2. Digito de Controle RIC " + SubStr( valor, 32, 1 ) + " Nao Confere sugerido: " + zDAC
         znerro := 1
      ENDIF
   ENDIF
   IF znerro > 0
      IF Lmes
         ALERTX( zerro )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function valpis()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION valpis( wk_pis, lMES, lMESPAS, cVINCULO, lPISIND )

   LOCAL ACUM1, ACUM2, X, NUM, RES, DV
   LOCAL NUMERA

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF ValType( lMESPAS ) # "L"
      lMESPAS := .T.
   ENDIF
   IF ValType( lPISIND ) # "L"
      lPISIND := .T.
   ENDIF
   IF ValType( cVINCULO ) <> "C"
      cVINCULO := ""
   ENDIF
   IF cVINCULO = "722" .OR. cVINCULO = "721"
      RETURN .T.
   ENDIF
   ZNERRO := 0
   ZERRO  := ""
   IF Val( wk_pis ) = 0
      ZERRO  := "Numero PIS Nao Informado(em Branco)"
      ZNERRO := 1
   ENDIF
   IF Len( AllTrim( wk_pis ) ) <> 11
      ZERRO  := 'PIS nao tem 11 digitos ' + Str( Len( AllTrim( wk_pis ) ), 0 )
      ZNERRO := 8
   ENDIF
   IF SubStr( wk_pis, 1, 1 ) <> '1' .AND. SubStr( wk_pis, 1, 1 ) <> '2'
      ZERRO  := 'Codigo do pis nao comeca com 1 ou 2'
      ZNERRO := 2
   ENDIF
   IF SubStr( wk_pis, 1, 3 ) >= '109' .AND. SubStr( wk_pis, 1, 3 ) <= '119'
      ZERRO  := 'Codigo pertence a contribuinte individual da previdencia'
      ZNERRO := 3
      IF lMESPAS
         ALERTX( ZERRO )
      ENDIF
   ENDIF
   IF znerro = 0
      acum1  := acum2 := 0
      numera := SubStr( wk_pis, 1, 10 )
      FOR x := Len( numera ) TO 1 STEP - 1
         num   := SubStr( numera, x, 1 )
         acum1 := iif( x < 3, Val( num ) * ( 4 - x ), Val( num ) * ( 12 - x ) )
         acum2 := acum1 + acum2
      NEXT
      res := Mod( acum2, 11 )
      IF res = 1
         ZERRO  := 'Codigo do pis invalido '
         ZNERRO := 4
      ELSE
         IF res = 0
            dv := 0
            IF Val( SubStr( wk_pis, 11, 1 ) ) != dv
               ZERRO  := 'Codigo do pis invalido'
               ZNERRO := 5
            ENDIF
         ELSE
            dv := 11 - res
            IF Val( SubStr( wk_pis, 11, 1 ) ) != dv
               ZERRO  := 'Codigo do pis invalido'
               ZNERRO := 6
            ENDIF
         ENDIF
      ENDIF
      IF lPISIND
         IF VERSEHA( "PISINDEV",, wk_pis )
            ZERRO  := 'Pis na lista de incorretos da Rais'
            ZNERRO := 7
         ENDIF
      ENDIF
   ENDIF
   IF znerro > 0
      IF Lmes
         ALERTX( zerro )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formatapis()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION formatapis( cPIS )

   cCPF := StrZero( Val( AllTrim( TIRAOUT( cPIS ) ) ), 11 )
   RETU Transform( cPIS, "@R 99.99999.999.9" )





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function valbco()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION valbco( wk_bco_ver )

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN   // retorna caso seta para cima ou baixo
      RETURN .T.
   ENDIF
   ver_dv := .F.
   IF Val( wk_bco_ver ) = 0
      MDT( 'Codigo do banco/agencia invalido ' )
   ELSE
      IF Val( SubStr( wk_bco_ver, 1, 3 ) ) = 104 .OR. Val( SubStr( wk_bco_ver, 1, 3 ) ) > 900
         IF Val( SubStr( wk_bco_ver, 1, 3 ) ) > 900
            numera := '104' + SubStr( wk_bco_ver, 4, 4 )
         ELSE
            numera := SubStr( wk_bco_ver, 1, 7 )
         ENDIF
         wk0 := 9
         dv1 := 0
         dv2 := 0
         FOR y := 1 TO 2
            acum2 := 0
            acum1 := 0
            FOR x := Len( numera ) TO 1 STEP - 1
               num   := SubStr( numera, x, 1 )
               acum1 := Val( num ) * ( wk0 - x )
               acum2 := acum1 + acum2
            NEXT
            IF y < 2
               res1 := Mod( acum2, 11 )
               IF res1 = 0 .OR. res1 = 1
                  dv1 := 0
               ELSE
                  dv1 := 11 - res1
               ENDIF
            ELSE
               res2 := Mod( acum2, 11 )
               IF res2 = 0 .OR. res2 = 1
                  dv2 := 0
               ELSE
                  dv2 := 11 - res2
               ENDIF
            ENDIF
            wk0    := 10
            numera := SubStr( numera, 1, 7 ) + Str( dv1, 1 )
         NEXT
         IF Str( dv2, 1 ) = SubStr( wk_bco_ver, 8, 1 )
            ver_dv := .T.
         ELSE
            MDT( 'Codigo do banco/agencia invalido ' )
         ENDIF
      ELSE
         MDT( 'Codigo do banco nao pertence a cef' )
      ENDIF
   ENDIF

   RETURN ver_dv

// + EOF: disk06.prg
// +
