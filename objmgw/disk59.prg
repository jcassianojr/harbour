// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk59.prg
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
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#include "INKEY.CH"

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION valcnpj(cCNPJ,lMES) //Chama vaccgc
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function valcnpj()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION valcnpj( cCNPJ, lMES, cUF )

   RETURN VALCGC( cCNPJ, "", lMES, cUF )

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION VALCGC()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALCGC()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION Valcpf()
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
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Valcpf()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
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
// +    Function CNPJ_Novo()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION Mod11()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Mod11()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION formatacfp()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formatacpf()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION formatacnpj()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function formatacnpj()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION CNPJCPFPICT()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CNPJCPFPICT()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION cnpjcpfval()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CNPJCPFVAL()
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    FUNCTION VALCEI(wk_cei,LMES)        //mascara="  .   .     /  "
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALCEI()
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

// + EOF: disk59.prg
// +
