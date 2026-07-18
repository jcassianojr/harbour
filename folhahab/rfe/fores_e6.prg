// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_e6.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FORES_E6.PRG: Listar RescisÑo contratual Resumo
// :      Linguagem: harbour
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1999,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/03/99
// :
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fores_e6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fores_e6

   PARA CC

   IF !MDL( 'Listar Rescisao contratual Resumo', 0 )
      RETU
   ENDIF

   IF !NETUSE( PES )   // AREDE(PES,PES,1)
      RETU
   ENDIF
   IF !NETUSE( "FO_RSS" )  // AREDE("FO_RSS","FO_RSS",1)
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "CONTAS" )  // AREDE("CONTAS","CONTAS",1)
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "FIRMA" )   // AREDE("FIRMA","FIRMA",1)
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "BCOFTGS" )
      dbCloseAll()
      RETU
   ENDIF
   CTR    := 0
   HOMO   := Date()
   CODSAQ := 0
   @ 21, 00 SAY 'Digite o numero do Funcionario'
   @ 22, 00 SAY 'Qual a Data da HomologaáÑo'
   @ 23, 00 SAY 'Qual o C¢digo de Saque FGTS'
   @ 21, 40 GET CTR
   @ 22, 40 GET HOMO
   @ 23, 40 GET CODSAQ
   IF !READCUR()
      RETU .F.
   ENDIF

   dbSelectAr( PES )
   dbGoTop()
   IF !dbSeek( CTR )
      MDT( 'Funcion†rio nÑo Encontrado' )
      dbCloseAll()
      RETU
   ENDIF
   MEF := Month( DEMITIDO )


   xCAUSA := OBTER( "FO_RCAU",, MOTIVO, "NOME" )
   dbSelectAr( "FO_RSS" )
   xVAL1 := VALCTA( CTR, 109 )
   xVAL1 += VALCTA( CTR, 905 )
   IF xVAL1 > 0 .AND. MDG( "Experiencia Termino Contrato a Termo" )
      xCAUSA := 'Termino de Contrato a Termo '
   ENDIF
   MDS( "Confirme Motivo" )
   @ 24, 20 GET xCAUSA
   READCUR()



   IMPRESSORA()
   dbSelectAr( "FIRMA" )
   dbGoTop()
   dbSeek( NREMP )
   @  1, 0   SAY IMPSTR( cIMPCOM )
   @  1, 86  SAY REPL( "-", 47 )
   @  2, 35  SAY "TERMO DE RESCISAO DO CONTRATO DE TRABALHO"
   @  2, 85  SAY "| 00-Para uso do processamento"
   @  2, 131 SAY "|"
   @  3, 0   SAY "|" + REPL( "-", 84 ) + "|"
   @  3, 131 SAY "|"
   @  4, 0   SAY "|"
   @  4, 35  SAY "IDENTIFICAÄAO"
   @  4, 85  SAY "|" + REPL( "-", 45 ) + "|"
   @  5, 0   SAY "|" + REPL( "-", 84 )
   @  5, 85  SAY "| 01-Carimbo padronizado do C.G.C."
   @  5, 131 SAY "|"
   @  6, 0   SAY "| 02-Empregador " + RAZAO
   dbSelectAr( "BCOFGTS" )
   dbSeek( NREMP )
   @  6, 65  SAY "| 03-Codigo " + CODEMP + "-" + CODEMPDV
   @  6, 85  SAY "|"
   @  6, 131 SAY "|"
   @  7, 0   SAY "|" + REPL( "-", 84 ) + "|"
   dbSelectAr( "FIRMA" )
   @  7, 85  SAY PadC( CGC, 44 )
   @  7, 131 SAY "|"
   @  8, 0   SAY "| 04-Endereco " + ENDERECO
   @  8, 85  SAY "|"
   @  8, 131 SAY "|"
   @  9, 00  SAY "|" + REPL( "-", 84 ) + "| " + PadC( AllTrim( RAZAO ), 44 )
   @  9, 131 SAY "|"
   @ 10, 0   SAY "| 05-CEP"
   @ 10, 15  SAY "| 06-Bairro"
   @ 10, 40  SAY "| 07-Municipio"
   @ 10, 65  SAY "| 08-UF"
   dbSelectAr( "FIRMA" )
   @ 10, 85  SAY "| " + PadC( AllTrim( ENDERECO ), 44 )
   @ 10, 131 SAY "|"
   @ 11, 0   SAY "| " + CEP
   @ 11, 15  SAY "| " + BAIRRO
   @ 11, 40  SAY "| " + CIDADE
   @ 11, 65  SAY "|        " + ESTADO
   @ 11, 85  SAY "|"
   @ 11, 131 SAY "|"
   @ 12, 0   SAY "|" + REPL( "-", 84 ) + "|"
   @ 12, 85  SAY PadC( AllTrim( BAIRRO ) + " - CEP " + CEP, 44 )
   @ 12, 131 SAY "|"
   @ 13, 0   SAY "| 09-Banco"
   @ 13, 40  SAY "| 10-Agencia UF"
   @ 13, 65  SAY "| 11-Codigo"
   @ 13, 85  SAY "| " + PadC( AllTrim( CIDADE ) + " - " + ESTADO, 44 )
   @ 13, 131 SAY "|"
   dbSelectAr( "BCOFGTS" )
   @ 14, 0   SAY "| " + NOME
   @ 14, 40  SAY "| " + AllTrim( NOMEAGENC ) + ' - ' + UF
   @ 14, 65  SAY "| " + AGENCIA + "-" + DIVAGENCI
   @ 14, 85  SAY "|"
   @ 14, 131 SAY "|"
   @ 15, 0   SAY "|" + REPL( "-", 130 ) + "|"
   dbSelectAr( PES )
   @ 16, 00  SAY "| 12-Empregado  " + NOME
   @ 16, 60  SAY Str( NUMERO, 8 )
   @ 16, 85  SAY "| 13-Carteira de Trabalho (no./serie-UF)"
   @ 16, 131 SAY "|"
   @ 17, 00  SAY "|"
   @ 17, 10  SAY OBTER( "FUNCAO",, FUNCAO, "NOME" )
   @ 17, 45  SAY OBTER( "DEPTO",, DEPSETSEC, "NOMER" )
   dbSelectAr( PES )
   @ 17, 85  SAY "|   " + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dÌgitos do CPF e o campo SÈrie, com os 4 dÌgitos restantes
   @ 17, 131 SAY "|"
   @ 18, 0   SAY "|" + REPL( "-", 130 ) + "|"
   @ 19, 0   SAY "| 14-PIS/PASEP"
   @ 19, 20  SAY "| 15-Codigo empregado"
   @ 19, 41  SAY "| 16-Data Nascimento"
   @ 19, 62  SAY "| 17-Data AdmissÑo"
   @ 19, 82  SAY "| 18-Data opáao FGTS"
   @ 19, 110 SAY "| 19-Data afastamento"
   @ 19, 131 SAY "|"
   @ 20, 00  SAY "|    " + PIS
   @ 20, 20  SAY "|    " + CONTAFGTS
   @ 20, 41  SAY "|    " + DToC( NASC )
   @ 20, 62  SAY "|    " + DToC( ADMITIDO )
   @ 20, 82  SAY "|    " + DToC( FGTS )
   @ 20, 110 SAY "|    " + DToC( DEMITIDO )
   @ 20, 131 SAY "|"
   @ 21, 0   SAY "|" + REPL( "-", 130 ) + "|"
   @ 22, 00  SAY "| 20-Maior remuneracao"
   @ 22, 25  SAY "| 21-Data Aviso previo"
   @ 22, 50  SAY "| 22-Pensao Judicial"
   @ 22, 70  SAY "| 23-Causa do Afastamento"
   @ 22, 114 SAY "| 24-Codigo Saque"
   @ 22, 131 SAY "|"
   SALH := SALM := VAR1 := 0
   SALHM( IF( MEF # 0, MEF, MES ) )
   @ 23, 00 SAY "|"
   @ 23, 05 SAY VAR1                    PICT '@E ###,###,###,###.##'
   @ 23, 25 SAY "|    " + DToC( AVISOPREV )
   @ 23, 50 SAY "|"
   @ 23, 70 SAY "|  "
   dbSelectAr( "FO_RSS" )
   @ 23, 73  SAY ACENTO( xCAUSA )
   @ 23, 114 SAY "|"
   @ 23, 120 SAY StrZero( CODSAQ, 2 )
   @ 23, 131 SAY "|"
   @ 24, 00  SAY "|" + REPL( "-", 130 ) + "|"
   @ 25, 00  SAY "|"
   @ 25, 45  SAY "DESCRIMINACAO  /  RECIBO DAS VERBAS RESCISORIAS"
   @ 25, 131 SAY "|"
   @ 26, 00  SAY "|" + REPL( "-", 130 ) + "|"
   aUSO := Array( 30, 3 )
   aFGT := Array( 4, 3 )
   XXX  := 1
   XYZ  := 1
   VEN  := 0
   dbSelectAr( "FO_RSS" )
   FILTRA := 'NUMERO=CTR'
   SET FILTER TO &FILTRA
   dbGoTop()
   WHILE CONTA < 400 .AND. !Eof()
      CTA := CONTA
      HOR := HORAS
      VAL := IF( CC = 1, VALORMES1, VALORMES2 )
      NOM := ""
      dbSelectAr( "CONTAS" )
      dbGoTop()
      IF dbSeek( CTA )
         NOM := DESCR
      ENDIF
      IF CTA = 399
         VAL := VEN
      ELSE
         VEN += VAL
      ENDIF
      IF VAL > 0
         aUSO[ XYZ, 1 ] := NOM
         aUSO[ XYZ, 2 ] := HOR
         aUSO[ XYZ, 3 ] := VAL
         XYZ++
      ENDIF
      dbSelectAr( "FO_RSS" )
      dbSkip()
   ENDDO
   dbSelectAr( "FO_RSS" )
   WHILE CONTA < 500 .AND. !Eof()
      IF CONTA > 445 .AND. CONTA < 450
         CTA := CONTA
         HOR := HORAS
         VAL := IF( CC = 1, VALORMES1, VALORMES2 )
         NOM := ""
         dbSelectAr( "CONTAS" )
         dbGoTop()
         IF dbSeek( CTA )
            NOM := DESCR
         ENDIF
         IF VAL > 0
            aFGT[ XXX, 1 ] := NOM
            aFGT[ XXX, 2 ] := HOR
            aFGT[ XXX, 3 ] := VAL
            XXX++
         ENDIF
      ENDIF
      dbSelectAr( "FO_RSS" )
      dbSkip()
   ENDDO
   DES := 0
   WHILE !Eof()
      IF CONTA = 900
         dbSkip()
         LOOP
      ENDIF
      CTA := CONTA
      HOR := HORAS
      VAL := IF( CC = 1, VALORMES1, VALORMES2 )
      NOM := ""
      dbSelectAr( "CONTAS" )
      dbGoTop()
      IF dbSeek( CTA )
         NOM := DESCR
      ENDIF
      IF VAL > 0
         IF CTA = 999
            VAL := DES
         ELSE
            DES += VAL
         ENDIF
         aUSO[ XYZ, 1 ] := NOM
         aUSO[ XYZ, 2 ] := HOR
         aUSO[ XYZ, 3 ] := VAL
         XYZ++
      ENDIF
      dbSelectAr( "FO_RSS" )
      dbSkip()
   ENDDO
   aUSO[ XYZ, 1 ] := 'Total Liquido'
   aUSO[ XYZ, 2 ] := 0
   aUSO[ XYZ, 3 ] := VEN - DES
   XYZ++
   FOR X := 1 TO 4
      IF !Empty( aFGT[ X,  3 ] )
         aUSO[ XYZ, 1 ] := aFGT[ X, 1 ]
         aUSO[ XYZ, 2 ] := aFGT[ X, 2 ]
         aUSO[ XYZ, 3 ] := aFGT[ X, 3 ]
         XYZ++
      ENDIF
   NEXT X
   CCX := 0
   FOR X := 1 TO 10
      @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + "|" + spac( 43 ) + "|" + spac( 42 ) + "|" + spac( 43 ) + "|"
      IF aUSO[ X,  3 ] # 0
         @ PRow(), 1 SAY PadR( aUSO[ X, 1 ], 23 )
         IF aUSO[ X,  2 ] # 0
            @ PRow(), 26 SAY aUSO[ X, 2 ] PICT '###.##'
         ENDIF
         @ PRow(), 32 SAY aUSO[ X, 3 ] PICT '@E #####,###.##'
      ENDIF
      IF aUSO[ X + 10,  3 ] # 0
         @ PRow(), 45 SAY PadR( aUSO[ X + 10, 1 ], 23 )
         IF aUSO[ X + 10,  2 ] # 0
            @ PRow(), 69 SAY aUSO[ X + 10, 2 ] PICT '###.##'
         ENDIF
         @ PRow(), 75 SAY aUSO[ X + 10, 3 ] PICT '@E #####,###.##'
      ENDIF
      IF aUSO[ X + 20,  3 ] # 0
         @ PRow(), 88 SAY PadR( aUSO[ X + 20, 1 ], 23 )
         IF aUSO[ X + 20,  2 ] # 0
            @ PRow(), 113 SAY aUSO[ X + 20, 2 ] PICT '###.##'
         ENDIF
         @ PRow(), 119 SAY aUSO[ X + 20, 3 ] PICT '@E #####,###.##'
      ENDIF
   NEXT X
   IF VEN - DES > 0
      @ PRow() + 1, 131 SAY IMPSTR( cIMPCOM ) + "|"
      @ PRow(), 0     SAY '|(' + IMPSTR( cIMPCOM ) + EXT( VEN - DES, 1, 125, 125, 0 ) + IMPSTR( cIMPEXP ) + ')'
      @ PRow() + 1, 131 SAY IMPSTR( cIMPCOM ) + "|"
      @ PRow(), 0     SAY '|(' + IMPSTR( cIMPCOM ) + EXT( VEN - DES, 2, 125, 125, 0 ) + IMPSTR( cIMPEXP ) + ')'
   ELSE
      @ PRow() + 2, 0 SAY ''
   ENDIF
// RODAPE
   @ 39, 0   SAY IMPSTR( cIMPCOM ) + "|" + REPL( "-", 130 ) + "|"
   @ 40, 0   SAY "| 51-Data da HomologaáÑo"
   @ 40, 25  SAY "| 52-Carimbo e Assinatura do empregador/preposto"
   @ 40, 85  SAY "| 53-ImpressÑo Digital"
   @ 40, 109 SAY "| 54-impressÑo digital"
   @ 40, 131 SAY "|"
   @ 41, 0   SAY "|   " + DToC( HOMO )
   @ 41, 25  SAY "|"
   @ 41, 85  SAY "|"
   @ 41, 90  SAY "empregado"
   @ 41, 109 SAY "|    responsavel legal"
   @ 41, 131 SAY "|"
   @ 42, 0   SAY "|" + REPL( "-", 84 ) + "|"
   @ 42, 109 SAY "|"
   @ 42, 131 SAY "|"
   @ 43, 0   SAY "| 55- Assinatura do empregado"
   @ 43, 85  SAY "|"
   @ 43, 109 SAY "|"
   @ 43, 131 SAY "|"
   @ 44, 0   SAY "|" + REPL( "-", 84 ) + "|"
   @ 44, 109 SAY "|"
   @ 44, 131 SAY "|"
   @ 45, 0   SAY "| 56- Assinatura do responsavel legal"
   @ 45, 85  SAY "|"
   @ 45, 109 SAY "|"
   @ 45, 131 SAY "|"
   @ 46, 0   SAY "|" + REPL( "-", 130 ) + "|"
   @ 47, 0   SAY "|" + Space( 30 ) + "RECIBO DE FGTS"
   @ 47, 85  SAY "| 58-Data recepáÑo pelo Banco"
   @ 47, 131 SAY "|"
   @ 48, 0   SAY "|" + REPL( "-", 84 ) + "|"
   @ 48, 131 SAY "|"
   @ 49, 0   SAY "| 57-Carimbo e Assinatura autorizada da empresa"
   @ 49, 85  SAY "|"
   @ 49, 131 SAY "|"
   @ 50, 0   SAY "|"
   @ 50, 85  SAY "|"
   @ 50, 131 SAY "|"
   @ 51, 0   SAY "|" + REPL( "-", 130 ) + "|"
   dbSelectAr( PES )
   @ 52, 0   SAY "| 59-Sacador - Nome  " + NOME
   @ 52, 105 SAY "| 60-Carimbo da Agància"
   @ 52, 131 SAY "|"
   @ 53, 0   SAY "|" + REPL( "-", 104 ) + "|  (Norma CSA/CIEF-47/74) |"
   @ 54, 0   SAY "| 61-Valor do Saque - Depositos"
   @ 54, 35  SAY "| 62-Juros e correáÑo monet†ria"
   @ 54, 70  SAY "| 63-Total do Saque"
   @ 54, 105 SAY "|"
   @ 54, 131 SAY "|"
   @ 55, 0   SAY "|"
   @ 55, 35  SAY "|"
   @ 55, 70  SAY "|"
   @ 55, 105 SAY "|"
   @ 55, 131 SAY "|"
   @ 56, 0   SAY "|" + REPL( "-", 104 ) + "|"
   @ 56, 131 SAY "|"
   @ 57, 0   SAY "| 64-impressÑo digital"
   @ 57, 25  SAY "| 65-impressÑo digital"
   @ 57, 55  SAY "| 66-Assinatura do sacador"
   @ 57, 105 SAY "|"
   @ 57, 131 SAY "|"
   @ 58, 0   SAY "|    empregado"
   @ 58, 25  SAY "|    responsavel legal"
   @ 58, 55  SAY "|"
   @ 58, 105 SAY "|"
   @ 58, 131 SAY "|"
   @ 59, 0   SAY "|"
   @ 59, 25  SAY "|"
   @ 59, 55  SAY "|" + REPL( "-", 49 ) + "|"
   @ 59, 131 SAY "|"
   @ 60, 0   SAY "|"
   @ 60, 25  SAY "|"
   @ 60, 55  SAY "| 67-Assinatura do Responsavel Legal"
   @ 60, 105 SAY "|"
   @ 60, 131 SAY "|"
   @ 61, 0   SAY "|"
   @ 61, 25  SAY "|"
   @ 61, 55  SAY "|"
   @ 61, 105 SAY "|"
   @ 61, 131 SAY "|"
   @ 62, 0   SAY "|"
   @ 62, 25  SAY "|"
   @ 62, 55  SAY "|" + REPL( "-", 76 )
   @ 62, 131 SAY "|"
   @ 63, 131 SAY "|"
   @ 63, 0   SAY ACENTO( "|" + REPL( "-", 54 ) + "|    AutenticaáÑo" ) + IMPSTR( cIMPCOM )
   @ 64, 0   SAY ACENTO( "| A ASSISTENCIA NA RESCISéO CONTRATUAL ê GRATUITA" ) + IMPSTR( cIMPCOM )
   @ 64, 55  SAY "|"
   @ 64, 131 SAY "|"
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()
   RETU
// : FIM: FORES_E7.PRG

// + EOF: fores_e6.prg
// +
