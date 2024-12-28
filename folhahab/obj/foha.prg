// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foha.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOHA.PRG: Imprimir Guia de INPS
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 20/11/97     14:43
// :
// :*****************************************************************************


// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foha()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foha

   PARA CC, CW, CT

   IF CW = 9 .OR. CW = 10
      MDT( 'Use a opcao Folha' )
      RETU
   ENDIF
   IF CW = 6
      ALERTX( "Nao Disponivel VT" )
      RETU .F.
   ENDIF

   IF !MDL( 'Guia de IAPAS', 0 )
      RETU
   ENDIF
   mTEMP := tmpfile( cRDDEXT )

   ATUALIZA := 1.000000
   FPAS     := OBTER( "FIRMA",, NREMP, "FPAS" )
   QTFUN    := VALVEND := PROLABO := NATALI := PROAUTO := 0
   TOT1     := TOT2 := TOT6 := TXSEGU := TXEMPRE := TXTERCE := 0
   BASEINPS := TOTRECO := TOTDEDU := 0
   PROAUT2  := PROLAB2 := ADCACI := 0
   PERLABO  := PERAUTO := 0
   CREDITO  := COMPENSA := 0
   cMES     := StrZero( MESTRAB, 2 )
   cANO     := StrZero( ANO, 4 )
   dINI     := BOM( zdata )
   dFIM     := EOM( ZDATA )
   cINCPG   := "N"
   TERCE    := "0000"
   mPAGGPS  := "2100"

   CLSCOR()
   MDS( "Confirme seu FPAS/cPAG" )
   SET KEY K_F11 TO TECLAF11
   @ 24, 40 GET FPAS PICT '####' VALID VERSEHA( "CONFINSS",, FPAS,, 'C¢digo FPAS INEXISTENTE', .T., ;
      { { "ACIDENTE", "TXSEGU" }, ;
      { "EMPRESA", "TXEMPRE" }, ;
      { "TOTAL", "TXTERCE" }, ;
      { "STRZERO(TERCEIRO,4)", "TERCE" }, ;
      { "PEMP", "PERLABO" }, { "PAUT", "PERAUTO" } } )
   @ 24, 50 GET mPAGGPS VALID VERSEHA( "TBCODPG", "TBCODPG", mPAGGPS, "NOME", '"Codigo Pagamento N„o Cadastrado"' )
   IF !READCUR()
      SET KEY K_F11
      RETU .F.
   ENDIF
   SET KEY K_F11



   CLSROW( 03 )
   @ 03, 00 SAY 'Confirme Taxas e Valores de Calculo'
   @ 04, 01 SAY "Competencia"
   @ 05, 01 SAY "Pro Labore e %"
   @ 06, 01 SAY "Autonomos e %"
   @ 07, 01 SAY "Fator de Atualiza‡„o"
   @ 08, 01 SAY 'Taxa Acidente de Trabalho '
   @ 09, 01 SAY 'Taxa da Empresa           '
   @ 10, 01 SAY 'Taxa de Terceiros         '
   @ 11, 01 SAY 'Codigo dos Terceiros      '
   @ 04, 30 GET cMES
   @ 04, 35 GET cANO
   IF CT # 1
      @ 05, 24 GET PROLABO PICT '###,###,###.##'
      @ 05, 17 GET PERLABO PICT '##.##'
      @ 06, 24 GET PROAUTO PICT '###,###,###.##'
      @ 06, 17 GET PERAUTO PICT '##.##'
   ENDIF
   @ 07, 20 GET ATUALIZA PICT "99999999999.999999"
   IF CT # 1
      @ 08, 30 GET TXSEGU  PICT '###.##'
      @ 09, 30 GET TXEMPRE PICT '###.##'
      @ 10, 30 GET TXTERCE PICT '###.##'
      @ 11, 30 GET TERCE
   ENDIF
   IF CT = 1
      @ 13, 01 SAY "Periodo Inclui Pagas"
      @ 13, 30 GET dINI
      @ 13, 40 GET dFIM
      @ 13, 50 GET cINCPG                 PICT "!" VALID cINCPG $ "SN"
   ENDIF
   READCUR()


   MDS( 'Somando o Numero de Empregados' )
   IF !ARQPES( CW, 1, 1 )
      RETU
   ENDIF
   dbGoTop()
   WHILE !Eof()
      IF ( ( Empty( DEMITIDO ) ) .OR. ( Month( DEMITIDO ) >= MES .AND. Year( DEMITIDO ) >= ANO ) )
         QTFUN++
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()


   IF CT = 0
      MDS( 'Aguarde Acumulando dados para GUIA' )
      IF !ARQUSAR( CW, 1, 1 )
         dbCloseAll()
         RETU .F.
      ENDIF
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      ordDestroy( "temp" )
      ordCreate(, "temp", "conta" )
      ordSetFocus( "temp" )


      cSELE1 := Alias()

      IF !ARQCTA( CW )
         dbCloseAll()
         RETU .F.
      ENDIF
      cSELE2 := Alias()

      dbSelectAr( cSELE1 )
      dbGoTop()
      WHILE !Eof()
         CTA      := CONTA
         GUIAINPS := 1
         TOTCTA   := 0
         WHILE CTA = CONTA .AND. !Eof()
            TOTCTA += VALOR
            dbSkip()
         ENDDO
         TOTCTA := IF( ATUALIZA # 1, Round( TOTCTA * ATUALIZA, 2 ), TOTCTA )
         dbSelectAr( cSELE2 )
         dbGoTop()
         IF dbSeek( CTA )
            GUIAINPS := GUIA_IAPAS
            IF CW = 8  // Autonomos BaseReduzida
               TOTCTA := Round( TOTCTA * BASERED / 100, 2 )
            ENDIF
         ENDIF
         BASEINPS += IF( GUIAINPS = 0 .OR. GUIAINPS = 5, TOTCTA, 0 )
         BASEINPS -= IF( GUIAINPS = 2, TOTCTA, 0 )
         TOTRECO  += IF( GUIAINPS = 3, TOTCTA, 0 )
         TOTDEDU  += IF( GUIAINPS = 4 .OR. GUIAINPS = 5, TOTCTA, 0 )
         ADCACI   += IF( GUIAINPS = 6, TOTCTA, 0 )
         dbSelectAr( cSELE1 )
      ENDDO
      dbCloseAll()
      // IF MDG("Confirmar Valores Acumulados")
      @ 03, 40 SAY "Confirme os Acumuladores"
      @ 04, 40 SAY "Base INSS"
      @ 05, 40 SAY "Segurados"
      @ 06, 40 SAY "Dedu‡”es "
      @ 07, 40 SAY "Adc.Ac.Trab."
      @ 08, 40 SAY "Creditos"
      @ 09, 40 SAY "Compensa‡ao"
      @ 04, 55 GET BASEINPS                   PICT '###,###,###.##'
      @ 05, 55 GET TOTRECO                    PICT '###,###,###.##'
      @ 06, 55 GET TOTDEDU                    PICT '###,###,###.##'
      @ 07, 55 GET ADCACI                     PICT '###,###,###.##'
      @ 08, 55 GET CREDITO                    PICT '###,###,###.##'
      @ 09, 55 GET COMPENSA                   PICT '###,###,###.##'
      READCUR()
      // ENDIF
   ENDIF

   IF CT = 1
      ACIDENT := TOTRECO := EMPRESA := TERCEIRO := TOTDEDU := LIQUIDO := 0
      IF !netuse( "GINSSE" )   // AREDE("GINSSE","GINSSE",1)
         dbCloseAll()
         RETU .F.
      ENDIF
      dbSelectAr( "GINSSE" )
      dbGoTop()
      dbSeek( StrZero( NREMP, 5 ) )
      WHILE NREMP = NUMEMP .AND. !Eof()
         IF PAGA # "S" .OR. cINCPG = "S"
            cDAT := "01/" + StrZero( MES, 2 ) + "/" + StrZero( ANO, 4 )
            dDAT := CToD( cDAT )
            IF dDAT >= dINI .AND. dDAT <= dFIM
               TOTRECO  += VALREC
               EMPRESA  += VALEMA
               ACIDENT  += VALACI
               TERCEIRO += VALTER
               TOTDEDU  += VALDED
               LIQUIDO  += VALLIQ
               CREDITO  += VALCRE
               COMPENSA += VALCOM
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      dbCloseAll()
   ENDIF

   FPAS1  := OBTER( "FIRMA",, NREMP, "FPAS" )
   CODSAT := OBTER( "FIRMA",, NREMP, "ACID" )

   IF FPAS = 770
      TOTRECO := 0
      TOTDEDU := 0
   ENDIF
   IF CT = 0
      LABO     := Round( PROAUTO * PERAUTO / 100, 2 ) + Round( PROLABO * PERLABO / 100, 2 )
      EMPRESA  := Round( ( BASEINPS ) * ( TXEMPRE / 100 ), 2 )
      EMPRESA  += LABO
      ACIDENT  := Round( BASEINPS * ( TXSEGU / 100 ), 2 )
      EMPRESA1 := ACIDENT + EMPRESA + ADCACI
      TERCEIRO := Round( BASEINPS * ( TXTERCE / 100 ), 2 )
   ENDIF
   IF CT = 1
      EMPRESA1 := ACIDENT + EMPRESA
   ENDIF
// Terceiro Sempre Paga
   SOMA     := TOTRECO + EMPRESA1
   DESSOMA  := TOTDEDU + CREDITO + COMPENSA
   DESCONTO := IF( DESSOMA > SOMA, SOMA, DESSOMA )
   LIQUIDO  := SOMA - DESCONTO + TERCEIRO
   ATUAL    := 0.00
   JUROS    := 0.00
   TOTAL    := 0
   FOHA04( "" )
   IF CC = 0
      FOHA01( CT )
   ENDIF
   IF CC = 1
      IF !MDG( "Modelo GPS" )
         FOHA02( CT )
      ELSE
         FOHA03( CT )
      ENDIF
   ENDIF
   IF CT = 1
      IF MDG( "Deseja Apenas Resumo" )
         FOHA01( CT )
      ELSE
         IF !MDG( "Modelo GPS" )
            FOHA02( CT )
         ELSE
            FOHA03( CT )
         ENDIF
      ENDIF
      RETU .T.
   ENDIF
   IF MDG( "Gravar Resultados do Mes" )
      IF !NETUSE( "GINSSE" )   // AREDE("GINSSE","GINSSE",0)
         RETU .F.
      ENDIF
      dbGoTop()
      IF !dbSeek( StrZero( NREMP, 5 ) + StrZero( Val( cANO ), 4 ) + StrZero( Val( cMES ), 2 ) )
         netrecapp()
      ELSE
         netreclock()
      ENDIF
      FIELD->VALREC := TOTRECO
      FIELD->VALEMP := EMPRESA1
      FIELD->VALEMA := EMPRESA
      FIELD->VALACI := ACIDENT
      FIELD->VALTER := TERCEIRO
      FIELD->VALDED := TOTDEDU
      FIELD->VALLIQ := LIQUIDO
      FIELD->VALCRE := CREDITO
      FIELD->VALCOM := COMPENSA
      FIELD->SUB01  := VALREC + VALEMA
      FIELD->SUB02  := SUB01 + VALACI
      nTEMP         := SOMA - TOTDEDU
      IF nTEMP > 0 .AND. CREDITO > 0
         nTEMP := CREDITO - nTEMP
         IF nTEMP > 0
            FIELD->SUB03 := CREDITO - nTEMP
         ELSE
            FIELD->SUB03 := CREDITO
         ENDIF
         FIELD->VALUSO := CREDITO - SUB03
      ENDIF
      FIELD->MES    := Val( cMES )
      FIELD->ANO    := Val( cANO )
      FIELD->NUMEMP := NREMP
      dbCloseAll()
   ENDIF
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOHA01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOHA01( CT )

   IMPRESSORA()
   @  0, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
   @  1, 0   SAY "MINISTERIO DA PREVIDENCIA E ASSISTENCIA SOCIAL"
   @  2, 0   SAY "INSS - Instituto Nacional do Seguro Social"
   @  3, 70  SAY "G R P S - Guia de Recolhimento da Previdencia Social"
   @  5, 70  SAY "9-Tipo de Identificacao"
   @  5, 109 SAY "10-Identificacao"
   IF zCEI # SPAC( 12 )
      @  6, 70  SAY "|1| 1 - CGC/CNPJ   2 - CEI "
      @  6, 109 SAY CGC
   ELSE
      @  6, 70  SAY "|2| 1 - CGC/CNPJ   2 - CEI "
      @  6, 109 SAY ZCEI
   ENDIF
   @  7, 0   SAY "2-Nome ou Razao Social"
   @  7, 70  SAY Replicate( "_", 62 )
   @  8, 0   SAY MSG2
   @  8, 70  SAY "11-FPAS"
   @  8, 109 SAY "12-Referencia(uso INSS)"
   @  9, 0   SAY Replicate( "_", 66 )
   @  9, 70  SAY FPAS
   @ 10, 0   SAY "3-Endereco"
   @ 10, 51  SAY "4-Telefone"
   @ 10, 70  SAY Replicate( "_", 62 )
   @ 11, 0   SAY ENDER1
   @ 11, 51  SAY zTELEFONE
   @ 11, 70  SAY "13-Comp.(mes/ano)"
   @ 11, 89  SAY "14-Comp.(uso INSS)"
   @ 11, 109 SAY "15-Vencto.(uso do INSS)"
   @ 12, 70  SAY cMES + '/' + cANO
   @ 13, 0   SAY Replicate( "_", 66 )
   @ 13, 70  SAY Replicate( "_", 62 )
   @ 14, 0   SAY "5-CEP"
   @ 14, 12  SAY "6-Municipio"
   @ 14, 60  SAY "7-UF"
   @ 15, 0   SAY CEP1
   @ 15, 12  SAY CID1
   @ 15, 60  SAY EST1
   @ 15, 70  SAY "DISCRIMINATIVO"
   @ 15, 101 SAY "CODIGO"
   @ 15, 126 SAY "VALOR"
   @ 16, 0   SAY Replicate( "_", 66 )
   @ 16, 70  SAY Replicate( "_", 62 )
   @ 17, 0   SAY "8-Outras Informacoes"
   @ 17, 40  SAY "No. de Empregados"
   @ 18, 46  SAY QTFUN
   @ 18, 70  SAY "16 - Segurados"
   @ 18, 101 SAY "1031"
   @ 18, 113 SAY TOTRECO                   PICTURE "@E 999,999,999,999.99"
   IF CT = 2
      @ 19, 00 SAY IMPCHR( cIMPTIT ) + Str( DEPTO ) + "-" + Str( SETOR ) + "-" + Str( SECAO ) + "-" + NOME
   ENDIF
   IF CT = 1
      @ 19, 00 SAY 'Acumulada Periodo: ' + DToC( dINI ) + " a " + DToC( dFIM )
   ENDIF
   @ 20, 70  SAY "17 - Empresa"
   @ 20, 101 SAY "1040"
   @ 20, 113 SAY EMPRESA1                     PICTURE "@E 999,999,999,999.99"
   @ 21, 0   SAY "Salario-Contribuicao"
   @ 21, 60  SAY "%"
   @ 22, 0   SAY "-Empregados              :"
   @ 22, 32  SAY BASEINPS                     PICTURE "@E 999,999,999,999.99"
   @ 22, 55  SAY TXEMPRE                      PICT "999.99"
   @ 22, 70  SAY "18 - Terceiros"
   @ 22, 101 SAY TERCE
   @ 22, 106 SAY TXTERCE
   @ 22, 113 SAY TERCEIRO                     PICTURE "@E 999,999,999,999.99"
   @ 23, 0   SAY "-Empregadores(Pr¢-Labore):"
   @ 23, 32  SAY PROLABO                      PICT "@E 999,999,999,999.99"
   @ 23, 55  SAY PERLABO                      PICT "999.99"
   @ 24, 0   SAY "-Autonomos               :"
   @ 24, 32  SAY PROAUTO                      PICT "@E 999,999,999,999.99"
   @ 24, 55  SAY PERAUTO                      PICT "999.99"
   @ 24, 70  SAY "19 - Creditos"
   @ 24, 113 SAY CREDITO                      PICTURE "@E 999,999,999,999.99"
   @ 25, 0   SAY "-Sub Total               :"
   @ 25, 32  SAY BASEINPS + PROLABO + PROAUTO     PICT "@E 999,999,999,999.99"
   @ 26, 0   SAY "-SAT                     :"
   @ 26, 28  SAY CODSAT
   @ 26, 36  SAY ACIDENT                      PICT "@E 999,999,999.99"
   @ 26, 55  SAY TXSEGU                       PICT "999.99"
   @ 26, 70  SAY "20 - Compensacoes"
   @ 26, 113 SAY COMPENSA                     PICTURE "@E 999,999,999,999.99"
   @ 27, 0   SAY "Somente Empresa"
   @ 27, 32  SAY EMPRESA                      PICT "@E 999,999,999,999.99"
   @ 28, 0   SAY Replicate( "_", 66 )
   @ 28, 70  SAY "21 - Deducoes FPAS"
   @ 28, 101 SAY "1058"
   @ 28, 113 SAY TOTDEDU                      PICTURE "@E 999,999,999,999.99"
   @ 30, 70  SAY "22 - Total Liquido"
   @ 30, 101 SAY "1066"
   @ 30, 113 SAY LIQUIDO                      PICTURE "@E 999,999,999,999.99"
   @ 32, 70  SAY "23 - Atualizacao Monetaria"
   @ 32, 101 SAY "1074"
   @ 32, 113 SAY ATUAL                        PICTURE "@E 999,999,999,999.99"
   @ 34, 70  SAY "24 - Juros/Multa"
   @ 34, 101 SAY "1082"
   @ 34, 113 SAY JUROS                        PICTURE "@E 999,999,999,999.99"
   @ 36, 70  SAY "25 - Total"
   @ 36, 101 SAY "1090"
   @ 36, 113 SAY TOTAL                        PICTURE "@E 999,999,999,999.99"
   IF CT # 2
      IMPFOL()
      VIDEO()
      IMPEND()
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOHA02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOHA02( CT )

   SET PRIN ON
   QQOut( Chr( 27 ) + 'C' + Chr( 36 ) )
   SET PRIN OFF
   SET DEVI TO PRINT
   @ PRow() + 1, 1 SAY IMPSTR( cIMPEXP )
   IF ZCEI <> SPAC( 12 )
      @ PRow(), 44 SAY '2'
      @ PRow(), 60 SAY ZCEI
   ELSE
      @ PRow(), 44 SAY '1'
      @ PRow(), 60 SAY CGC
   ENDIF
   @ PRow() + 1, 12 SAY 'CGC :'
   @ PRow(), 18    SAY CGC
   IF ZCEI <> SPAC( 12 )
      @ PRow() + 1, 12 SAY 'CEI :'
      @ PRow(), 18    SAY ZCEI
   ELSE
      @ PRow() + 1, 6 SAY ' '
   ENDIF
   @ PRow(), 45    SAY FPAS
   @ PRow() + 1, 15 SAY IMPSTR( cIMPCOM ) + MSG2 + IMPSTR( cIMPEXP )
   @ PRow() + 1, 43 SAY SubStr( cMES, 1, 1 )
   @ PRow(), 46    SAY SubStr( cMES, 2, 1 )
   @ PRow(), 49    SAY SubStr( cANO, 3, 1 )
   @ PRow(), 52    SAY SubStr( cANO, 4, 1 )
   @ PRow() + 1, 15 SAY IMPSTR( cIMPCOM ) + ENDER1 + IMPSTR( cIMPEXP )
   @ PRow() + 1, 15 SAY IMPSTR( cIMPCOM ) + BAI1 + ' - CEP ' + CEP1 + IMPSTR( cIMPEXP )
   @ PRow() + 1, 15 SAY IMPSTR( cIMPCOM ) + Trim( CID1 ) + ' - ' + EST1 + IMPSTR( cIMPEXP )
   @ PRow(), 0    SAY ' '
   @ PRow(), 63    SAY TOTRECO                                               PICT '#,###,###,###.##'
   @ PRow() + 2, 63 SAY EMPRESA1                                              PICT '#,###,###,###.##'
   @ PRow() + 1, 2  SAY MSG2
   @ PRow() + 1, 56 SAY TERCE
   @ PRow(), 63    SAY TERCEIRO                                              PICTURE '#,###,###,###.##'
   @ PRow() + 3, 2  SAY ENDER1
   @ PRow() + 2, 32 SAY IMPSTR( cIMPCOM ) + ZTELEFONE + IMPSTR( cIMPEXP )
   @ PRow() + 1, 63 SAY TOTDEDU                                               PICTURE '#,###,###,###.##'
   @ PRow() + 1, 2  SAY IMPSTR( cIMPCOM ) + CEP1 + IMPSTR( cIMPEXP )
   @ PRow(), 9    SAY CID1
   @ PRow(), 36    SAY EST1
   @ PRow() + 1, 63 SAY LIQUIDO                                               PICT '#,###,###,###.##'
   @ PRow() + 1, 31 SAY IF( NRSEN # 'DiReT', QTFUN, 0 )                           PICT '####'
   @ PRow() + 2, 20 SAY BASEINPS                                              PICTURE '###,###,###,###.##'
   @ PRow() + 2, 20 SAY PROAUTO + PROLABO                                       PICT '###,###,###,###.##'
   @ PRow() + 2, 20 SAY CODSAT
   IF PROLABO # 0
      @ PRow() + 1, 4 SAY 'Pro-Labore '
      @ PRow(), 20   SAY PROLABO       PICT '###,###,###,###.##'
   ENDIF
   IF PROAUTO # 0
      @ PRow() + 1, 4 SAY 'Autonomo   '
      @ PRow(), 20   SAY PROAUTO       PICT '###,###,###,###.##'
   ENDIF
   IF CT = 1
      @ PRow() + 1, 4 SAY 'Acumulada Periodo  ' + DToC( dINI ) + "-" + DToC( dFIM )
   ENDIF
   IMPFOL()
   SET DEVI TO SCRE
   SET PRIN ON
   QQOut( Chr( 27 ) + 'C' + Chr( 66 ) )
   SET PRIN OFF
   IF CT # 2
      IMPEND()
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOHA03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOHA03( CT )

   SET PRIN ON
   QQOut( Chr( 27 ) + 'C' + Chr( 20 ) )
   SET PRIN OFF
   SET DEVI TO PRINT
   @ PRow(), 60 SAY mPAGGPS
// @ PROW()  ,60 SAY FPAS
   @ PRow() + 2, 55 SAY cMES + "/" + cANO
   IF ZCEI <> SPAC( 12 )
      @ PRow() + 2, 50 SAY ZCEI
   ELSE
      @ PRow() + 2, 50 SAY CGC
   ENDIF
   @ PRow() + 2, 50 SAY LIQUIDO - TERCEIRO                           PICT '@E ###,###,###.##'
   @ PRow() + 1, 02 SAY MSG2
   @ PRow() + 1, 02 SAY ZTELEFONE
   @ PRow() + 1, 02 SAY ENDER1
   @ PRow() + 1, 02 SAY CEP1 + " - " + AllTrim( CID1 ) + " - " + AllTrim( EST1 )
   @ PRow() + 2, 50 SAY TERCEIRO                                     PICT '@E ###,###,###.##'
   IF JUROS > 0 .OR. ATUAL > 0
      @ PRow() + 2, 50 SAY JUROS + ATUAL PICT '@E ###,###,###.##'
   ELSE
      @ PRow() + 2, 0 SAY ""
   ENDIF
   IF TOTAL > 0
      @ PRow() + 2, 50 SAY TOTAL PICT '@E ###,###,###.##'
   ELSE
      @ PRow() + 2, 0 SAY ""
   ENDIF
   IMPFOL()
   SET DEVI TO SCRE
   SET PRIN ON
   QQOut( Chr( 27 ) + 'C' + Chr( 66 ) )
   SET PRIN OFF
   IF CT # 2
      IMPEND()
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOHA04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOHA04( cTITULO )

// IF MDG("Confirmar Calculos: "+cTITULO)
   @ 14, 00 CLEA
   @ 14, 00 SAY "Valores Calculados"
   @ 15, 00 SAY "Segurados"
   @ 15, 35 SAY "Empresa  "
   @ 15, 50 SAY "Acidente "
   @ 16, 00 SAY "Empresa  "
   @ 17, 00 SAY "Terceiros"
   @ 18, 00 SAY "Dedu‡”es "
   @ 19, 00 SAY "Credito  "
   @ 20, 00 SAY "Compensa"
   @ 21, 00 SAY "Liquido  "
   @ 22, 00 SAY "ATul.Monetaria"
   @ 23, 00 SAY "Juros/Multa   "
   @ 15, 20 GET TOTRECO              PICT '###,###,###.##'
   @ 16, 20 GET EMPRESA1             PICT '###,###,###.##'
   @ 16, 35 GET EMPRESA              PICT '###,###,###.##'
   @ 16, 50 GET ACIDENT              PICT '###,###,###.##'
   @ 17, 20 GET TERCEIRO             PICT '###,###,###.##'
   @ 18, 20 GET TOTDEDU              PICT '###,###,###.##'
   @ 19, 20 GET CREDITO              PICT '###,###,###.##'
   @ 20, 20 GET COMPENSA             PICT '###,###,###.##'
   @ 21, 20 GET LIQUIDO              PICT '###,###,###.##'
   @ 22, 20 GET ATUAL                PICT '###,###,###.##'
   @ 23, 20 GET JUROS                PICT '###,###,###.##'
   READCUR()
   TOTAL := LIQUIDO + JUROS + ATUAL
// ENDIF
   RETU .T.


// : FIM: FOHA.PRG

// + EOF: foha.prg
// +
