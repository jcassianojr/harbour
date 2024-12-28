// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : validaie.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Module => validae.PRG
// +
// +     ValIE( cinsc, cUF, cPESSOA,lMES ,lOLD)
// +     FormataIE(Valor,cUF,cPESSOA)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#include "INKEY.CH"

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function ValIE()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ValIE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ValIE( cinsc, cUF, cPESSOA, lMES, lOLD )   // mantida lold telas com get via macro ainda usam este parametro

   LOCAL lRETU
   LOCAL nRet
   LOCAL x
   LOCAL nPOS
   LOCAL aUF, aTAM

   ZNERRO := 0
   ZERRO  := ""


   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.   // Mandou Prosseguir
   ENDIF

   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF
// IF VALTYPE(lOLD)<>"L" //SP TIPO P tradado pela formula ValidIE_SP
// lOLD:=.T.
// ENDIF


   IF ( Empty( cinsc ) )
      ZNERRO := 1
      ZERRO  := "Inscricao em Branco"
   ENDIF

   IF ( Empty( cUF ) )
      ZNERRO := 2
      ZERRO  := "Estado em Branco"
   ENDIF



   IF cUF = "XX" .OR. cUF = "EX"
      IF Left( Upper( cINSC ), 5 ) = "ISENT" .OR. cINSC = "00000000000000"
         RETURN .T.  // Exterior //isent
      ELSE
         ZNERRO := 3
         ZERRO  := "Exterior <> Isento ou 00000000000000"
      ENDIF
   ENDIF

   IF Left( Upper( cINSC ), 5 ) = "ISENT" .OR. ( At( "NAO", Upper( cINSC ) ) > 0 .AND. At( "CONTRIB", Upper( cINSC ) ) > 0 )
      RETURN .T.   // isento isenta //nao contribuinte
   ENDIF


   IF ValType( cPESSOA ) = "C"
      IF cPESSOA # "J"
         RETURN .T.  // Nao E Pessoa Juridica
      ENDIF
   ENDIF
   lRETU := .F.
   cINSC := AllTrim( cINSC )
   cINSC := StrTran( cINSC, ".", "" )
   cINSC := StrTran( cINSC, "", "" )
   cINSC := StrTran( cINSC, "/", "" )
   cINSC := StrTran( cINSC, 'ME', '' )   // Micro Empresa
   cINSC := StrTran( cINSC, ' ', '' )
   cINSC := StrTran( cINSC, ',', '' )


// if ! lOLD
// cINSC := STRTRAN(cINSC,'P','')   //SP TIPO P tradado pela formula ValidIE_SP
// ENDIF


   IF Len( cINSC ) < 8
      ZNERRO := 4
      ZERRO  := "IE Invalido  menos de 8 digitos "
   ENDIF


   FOR X := 0 TO 9
      IF cINSC = repl( Str( X, 1 ), Len( cINSC ) )
         ZNERRO := 5
         ZERRO  := "IE Invalido  Sequencia Repetitiva de " + Str( X, 1 )
      ENDIF
   NEXT X

   aUf := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MG", "MS", ;
      "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC", ;
      "SE", "SP", "TO" }

   aTAM := { 13, 09, 09, 09, 09, 09, 13, 09, 09, 09, 13, 09, ;
      11, 09, 09, 14, 09, 10, 08, 09, 14, 09, 10, 09, ;
      09, 12, 11 }
// ba mudou 8 para 9 em 2012

   nPOS := AScan( aUF, cUF )
   lTAM := .T.
   IF nPOS > 0
      nPOS := aTAM[ nPOS ]
      DO CASE

      CASE cUF = "AC" .AND. Len( cINSC ) <> 13 .AND. Len( cINSC ) <> 9   // 13 9
         lTAM := .F.
      CASE cUF = "PE" .AND. Len( cINSC ) <> 9 .AND. Len( cINSC ) <> 14   // 9 Nova ou 14 Antiga
         lTAM := .F.
         // Case cUF="RN" .AND. LEN(cINSC)<>9 .AND. LEN(cINSC) <> 10  //9 digitos  ou 10 digitos
         // lTAM:=.F. verificado somente nove digitos
      CASE cUF = "RO" .AND. Len( cINSC ) <> 9 .AND. Len( cINSC ) <> 14   // 9 atual ou 14 Antiga
         lTAM := .F.
      CASE cUF = "TO" .AND. Len( cINSC ) <> 9 .AND. Len( cINSC ) <> 11   // 9 atual ou 11 Antiga
         lTAM := .F.
      CASE cUF = "BA" .AND. Len( cINSC ) <> 8 .AND. Len( cINSC ) <> 9  // 8 Antiga
         lTAM := .F.
      CASE cUF = "SP" .AND. Len( cINSC ) <> 12 .AND. Len( cINSC ) <> 13  // 12 13='P'+IE inscricao produtor rural
         lTAM := .F.

      OTHERWISE
         IF nPOS <> Len( cINSC )
            lTAM := .F.
         ENDIF
      ENDCASE
   ENDIF
   IF lMES .AND. !lTAM
      ZNERRO := 8
      ZERRO  := "Tamanho da Inscricao Invalido:" + Str( nPOS ) + "/" + Str( Len( cINSC ) )
   ENDIF

   aTAM := { "01", "24", "", "03", "", "06", "07", "", "10", "12", "", "28", ;
      "", "15", "16", "18", "19", "", "", "20", "", "24", "", "25", ;
      "27", "", "29" }
   nPOS := AScan( aUF, cUF )
   lTAM := .T.
   IF nPOS > 0
      nPOS := aTAM[ nPOS ]
      IF Len( nPOS ) = 2
         DO CASE
         CASE cUF = "GO" .AND. SubStr( cINSC, 1, 2 ) <> "10" .AND. SubStr( cINSC, 1, 2 ) <> "11" .AND. SubStr( cINSC, 1, 2 ) <> "15"
            lTAM := .F.
         OTHERWISE
            IF nPOS <> SubStr( cINSC, 1, 2 )
               lTAM := .F.
            ENDIF
         ENDCASE
      ENDIF
   ENDIF
   IF !lTAM
      ZNERRO := 7
      ZERRO  := "Inicio  da Inscricao Invalido:" + nPOS + "/" + SubStr( cINSC, 1, 2 )
   ENDIF

   AAdd( aUF, "XX" )
   AAdd( aUF, "EX" )

   IF AScan( aUF, cUF ) = 0
      ZNERRO := 8
      ZERRO  := "Estado invalido: " + cUF
   ENDIF

   IF ZNERRO = 0
      IF !ValidIE( cINSC, cUF )   // funcao classe sefaz
         ZNERRO := 6
         ZERRO  := "Inscricao Invalida"
      ENDIF
   ENDIF
   IF ZNERRO > 0
      IF lMES
         ALERTX( zerro )
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function formatIE(eIECPF,cUF,cPESSOA[F,J])
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FormataIE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FormataIE( Valor, cUF, cPESSOA )

   LOCAL cMASK

   IF ValType( cPESSOA ) <> "C"
      cPESSOA := "J"
   ENDIF
   cRETU := valor
   Valor := AllTrim( tiraout( Valor ) )
   cMASK := ""

// sem inscricao
   IF Left( Upper( cInscricao ), 5 ) = "ISENT" .OR. ( At( "NAO", Upper( cInscricao ) ) > 0 .AND. At( "CONTRIB", Upper( cInscricao ) ) > 0 )
      RETURN cRETU   // isento isenta //nao contribuinte
   ENDIF

// pessoa fisica
   IF cPESSOA = "F"
      RETURN cRETU
   ENDIF

// nao prenchida em branco
   IF Len( Valor ) = 0
      RETURN cRETU
   ENDIF
// | no lugar do ponto depois sofre strtran

   DO CASE
   CASE cUF = "AC"   // 13 dig
      cMASK := "@R 00|000|000/00000"   // "@R 99.999.999/999-99"
   CASE cUF = "AL"   // 9 digitos
      cMASK := "@R 000000000"  // "@R 999999999"
   CASE cUF = "AM"   // 9 dig
      cMASK := "@R 00|000|0000"  // "@R 99.999.999-9"
   CASE cUF = "AP"   // 9 dig
      cMASK := "@R 000000000"  // "@R 999999999"
   CASE cUF = "BA"   // 8 digitos
      IF Len( VALOR ) = 8  // antiga
         cMASK := "@R 00000000"  // "@R 999.999-99"
      ENDIF
      IF Len( VALOR ) = 9  // nova
         cMASK := "@R 000|000|000"
      ENDIF

   CASE cUF = "DF"   // 13 digitos
      cMASK := "@R 00|000000|00000"  // "@R 99.999999.999-99"
   CASE cUF = "MA"   // 9 digitos
      cMASK := "@R 000000000"  // "@R 999999999"
   CASE cUF = "MG"   // 13 digitos
      cMASK := "@R 000000000|00|00"  // "@R 999.999.999/9999"
   CASE cUF = "MT"   // 11 digitos
      cMASK := "@R 00000000000"  // "@R 9999999999-9"
   CASE cUF = "PA"   // 9 digitos
      cMASK := "@R 00|0000000"   // "@R 99-999999-9"
   CASE cUF = "PB"   // 9 digitos
      cMASK := "@R 00|000|0000"  // "@R 99-999999-9"
   CASE cUF = "PE"   // 9 nova ou 14 antiga
      IF Len( valor ) > 9
         cMASK := "@R 00|0|000|00000000"   // 14 antiga
      ELSE
         cMASK := "@R 000000000"   // 9 nova "@R 9999999-99"
      ENDIF
   CASE cUF = "PI"   // 9 digitos
      cMASK := "@R 00|000|0000"  // "@R 99.999.999-9"
   CASE cUF = "RN"   // 9 digitos  ou 10 digitos
      IF Len( VALOR ) > 9
         cMASK := "@R 00|0|000|0000"
      ELSE
         cMASK := "@R 00|000|0000"   // "@R 99.999.999-9"
      ENDIF
   CASE cUF = "RO"
      IF Len( VALOR ) = 9
         cMASK := "@R 000|000000"  // antiga  9 digitos
      ELSE
         cMASK := "@R 00000000000000"  // nova 14 digitos
      ENDIF
   CASE cUF = "RR"   // 9 digitos
      cMASK := "@R 00|0000000"   // "@R 99.999.999-9"
   CASE cUF = "SC"   // 9 digitos
      cMASK := "@R 000|000|000"  // "@R 999.999.999"
   CASE cUF = "SP"   // 12 digitos
      cMASK := "@R 000|000|000|000"  // "@R 999.999.999.999"
   CASE cUF = "TO"   // 9 11 digitos
      IF Len( valor ) = 11
         cMASK := "@R 00|00|0000000"   // "@R 99.99.999999-9"
      ELSE
         cMASK := "@R 00|000|0000"
      ENDIF
   CASE cUF = "CE"   // 9 digitos
      cMASK := "@R 00|0000000"   // "@R 99.999999-9"
   CASE cUF = "ES"   // 9 digitos
      cMASK := "@R 000|000|000"  // "@R 999.999.99-9"
   CASE cUF = "GO"   // 9 digitos
      cMASK := "@R 00|000|0000"  // "@R 99.999.999-9"
   CASE cUF = "MS"   // 9 digitos
      cMASK := "@R 00|000|0000"  // "@R 99.999.999-9"
   CASE cUF = "PR"   // 10 digitos
      cMASK := "@R 000|0000000"  // "@R 999.99999-99"
   CASE cUF = "RJ"   // 8 digitos
      cMASK := "@R 00|000|000"   // "@R 99.999.99-9"
   CASE cUF = "RS"   // 10 digitos
      cMASK := "@R 000/0000000"  // "@R 999/9999999"
   CASE cUF = "SE"   // 9 digitos
      cMASK := "@R 00|000|0000"  // "@R 99.999.999-9"
   ENDCASE
   IF Len( cMASK ) > 0
      cRETU := Transform( valor, cMASK )
      cRETU := StrTran( CRETU, "|", "." )
   ENDIF
   RETU cRETU

// + EOF: validaie.prg
// +
