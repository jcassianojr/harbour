// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c6.prg  Imprimir Informe de Rendimentos
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function folis_c6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION folis_c6

   PARA cTIPO, nACU

   CABE2( 'Imprimir Informe de Rendimentos' )
   IF cTIPO = "R"
      CHECKIMP( 0 )
   ENDIF

   IF nACU = 0
      nACU := IRRESC()
   ENDIF

   MDS( '* CARREGANDO DADOS DA FIRMA *' )
   IF !NETUSE( "FIRMA" )   // AREDE( "FIRMA", "FIRMA", 0 )
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( NREMP )
      NRCGC  := CGC
      xrTEL  := TELEFONE
      xrRESN := RESPONSAV
   ENDIF
   dbCloseAll()

   DXDIA2  := Date()
   CONTAR  := 1
   ANOBASE := Year( DXDIA2 )
   IF cTIPO = "R"
      @ 21, 00 clea
      @ 21, 00 SAY 'Nome do Respons vel'
      @ 22, 00 SAY 'Qual a data para impressao'
      @ 23, 00 SAY 'Qual o ano base'
      @ 24, 00 SAY 'Quantas Copias Deseja'
      @ 21, 40 GET xrRESN
      @ 22, 40 GET DXDIA2
      @ 23, 40 GET ANOBASE                      PICT '####'
      @ 24, 40 GET CONTAR                       PICT '##'
      IF !READCUR()
         RETU .F.
      ENDIF
      lGRAVA := MDG( "Grava Resultado Avulso" )
      UFIR   := MDG( 'Deseja em ufir' )
      CONF   := MDG( 'Deseja Conferir um a um' )
   ELSE
      lGRAVA := .T.
      UFIR   := .F.
      CONF   := .F.
   ENDIF


   IF !ARQIRR( nACU, 1, 3 )  // Shared Arede PES
      RETU .F.
   ENDIF
   cSELE1 := Alias()
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO

   IF !ARQIRR( nACU, 1,, 2 )   // SHARED Arede AcuIrrf
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()
   dbGoTop()
   IF lGRAVA
      IF MDG( "Apagar Resultados Gravados Anteriores" )
         NETZAP( "IRRF" )
      ENDIF
      IF !NETUSE( "IRRF" )   // AREDE( "IRRF", "IRRF", 0 )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF

   IF cTIPO = "R"
      SET DEVI TO PRINT
   ENDIF
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      CTR   := NUMERO
      mCPF  := CPF
      mNOME := NOME
      lIMP  := .F.
      V401  := V402 := V403 := V404 := V405 := V406 := V407 := 0.00
      V501  := V502 := V503 := V504 := V505 := V506 := V507 := 0.00
      V601  := V602 := V603 := V604 := V605 := V606 := V607 := 0.00
      V611  := V612 := V613 := V614 := V615 := V616 := V617 := 0.00
      OBS01 := OBS02 := OBS03 := OBS04 := OBS05 := Space( 60 )
      dbSelectAr( cSELE2 )
      dbGoTop()
      dbSeek( mCPF )
      WHILE mCPF = CPF .AND. !Eof()
         lIMP := .T.
         VAL  := if( UFIR, VALUFIR, VALOR )
         DO CASE
         CASE CODREN = 401
            V401 += VAL
         CASE CODREN = 402
            V402 += VAL
         CASE CODREN = 403
            V403 += VAL
         CASE CODREN = 404
            V404 += VAL
         CASE CODREN = 405
            V405 += VAL
         CASE CODREN = 407
            V407 += VAL

         CASE CODREN = 501
            V501 += VAL
         CASE CODREN = 502
            V502 += VAL
         CASE CODREN = 503
            V503 += VAL
         CASE CODREN = 504
            V504 += VAL
         CASE CODREN = 505
            V505 += VAL
         CASE CODREN = 506
            V506 += VAL
         CASE CODREN = 507
            V507 += VAL

         CASE CODREN = 601
            V601 += VAL
         CASE CODREN = 602
            V602 += VAL
         CASE CODREN = 603
            V603 += VAL
         CASE CODREN = 604
            V604 += VAL
         CASE CODREN = 605
            V605 += VAL
         CASE CODREN = 607
            V607 += VAL

         CASE CODREN = 611
            V611 += VAL
         CASE CODREN = 612
            V612 += VAL
         CASE CODREN = 613
            V613 += VAL
         CASE CODREN = 614
            V614 += VAL
         CASE CODREN = 615
            V615 += VAL
         CASE CODREN = 617
            V617 += VAL


         ENDCASE
         dbSelectAr( cSELE2 )
         dbSkip()
      ENDDO
      dbSelectAr( cSELE1 )
      IF lIMP
         IF CONF
            VIDEO()
            IRRFTEL()
            NETRECLOCK()
            IRRFGET( .F. )
            dbUnlock()
            IMPRESSORA()
         ENDIF
         IF cTIPO = "R"
            IMPINFO()
         ENDIF
         IF lGRAVA
            dbSelectAr( "IRRF" )
            dbGoTop()
            IF !dbSeek( mCPF )
               NETRECapp()
               field->CPF := mCPF
               field->CGC := NRCGC
            ELSE
               NETRECLOCK()
            ENDIF
            field->NOME := mNOME

            field->V401 := memvar->V401
            field->V402 := memvar->V402
            field->V403 := memvar->V403
            field->V404 := memvar->V404
            field->V405 := memvar->V405
            field->V407 := memvar->V407

            field->V501 := memvar->V501
            field->V502 := memvar->V502
            field->V503 := memvar->V503
            field->V504 := memvar->V504
            field->V505 := memvar->V505
            field->V506 := memvar->V506
            field->V507 := memvar->V507

            field->V601 := memvar->V601
            field->V602 := memvar->V602
            field->V603 := memvar->V603
            field->V604 := memvar->V604
            field->V605 := memvar->V605
            field->V607 := memvar->V607

            field->V611 := memvar->V611
            field->V612 := memvar->V612
            field->V613 := memvar->V613
            field->V614 := memvar->V614
            field->V615 := memvar->V615
            field->V617 := memvar->V617

            field->OBS01 := memvar->OBS01
            field->OBS02 := memvar->OBS02
            field->OBS03 := memvar->OBS03
            field->OBS04 := memvar->OBS04
            field->OBS05 := memvar->OBS05
            dbUnlock()
         ENDIF
      ENDIF
      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbCloseAll()
   IF cTIPO = "R"
      IMPEND()
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPINFO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IMPINFO

   FOR X := 1 TO CONTAR
      @ PRow(), 0   SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY "| MINISTERIO FAZENDA "
      @ PRow(), 35   SAY ' COMPROVANTE DE RENDIMENTOS PAGOS E DE'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY "| SECRETARIA DA FAZENDA NACIONAL"
      @ PRow(), 35   SAY ' RETENCAO DE IMPOSTO DE RENDA NA FONTE'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 1 SAY '1. FONTE PAGADORA PESSOA JURIDICA OU PESSOA FISICA'
      @ PRow(), 50   SAY "| ANO CALENDARIO: " + Str( ANOBASE )
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '| Nome ' + MSG2
      @ PRow(), 50   SAY "| CGC/CPF: " + NRCGC
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 1 SAY '2. PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '| CPF: ' + CPF + '| Nome Completo: ' + NOME
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '| Natureza do rendimento : RENDIMENTO DO TRABALHO ASSALARIADO'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 1 SAY '3. RENDIMENTOS TRIBUTAVEIS, DEDUCOES E IMPOSTO RETIDO NA FONTE '
      @ PRow(), 64   SAY "VALORES EM " + if( UFIR, 'UFIR', "REAIS" )
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '01 - Total dos Rendimentos (Inclusive Ferias)'
      IF NRSEN = 'DiReT'
         @ PRow(), 45 SAY '(PRO LABORE)'
      ENDIF
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V401                                                      PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '02 - Contribuicao Previdenciaria Oficial'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V402                                                      PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '03 - Contribuicao Previdenciaria Privada e ao FAPI'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V403                                                      PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '04 - Pensao Alimenticia (informar beneficiario campo 6)'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V404                                                      PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      // @ PROW(),1 SAY '05 - Dependentes             '
      // @ PROW(),60 SAY '|'
      // @ PROW(),64 SAY V407 PICT '###,###,###.##'
      // @ PROW(),79 SAY '|'
      // @ PROW()+1,0 SAY '|'
      @ PRow(), 1   SAY '05 - Imposto Retido na Fonte '
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V405                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 1 SAY '4 - RENDIMENTOS ISENTOS NAO TRIBUTAVEIS '
      @ PRow(), 64   SAY "VALORES EM " + if( UFIR, 'UFIR', "REAIS" )
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '01 - Salario Familia '
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V501                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '02 - Proventos Aposentados ou Reforma'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V502                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '03 - Diarias Ajuda de Custo'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V503                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '04 - Pensao Proventos      '
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V504                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '05 - Lucro ou Dividendo Apurado'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V505                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '06 - Valores Pagos a titulares ou Socios'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V506                                       PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '07 - Outros/Especificar'
      IF V507 <> 0.00
         IF !Empty( OBS01 )
            @ PRow(), 26 SAY OBS01
         ELSE
            @ PRow(), 26 SAY ':FGTS/INDENIZACOES/ABONO'
         ENDIF
      ENDIF
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY V507         PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      // @ PROW()+1, 1 SAY '5 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA NA FONTE (RENDIMENTO LIQUIDO) '
      @ PRow() + 1, 1 SAY '5 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA NA FONTE '
      @ PRow(), 64   SAY "VALORES EM " + if( UFIR, 'UFIR', "REAIS" )
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '01 - Decimo Terceiro Salario'
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY if( V601 - ( V602 + V607 + V604 ) > 0, V601 - ( V602 + V607 + V604 ), 0 )   PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY '02 - Outros / Especificar'
      IF !Empty( OBS02 )
         @ PRow(), 26 SAY OBS02
      ENDIF
      @ PRow(), 60   SAY '|'
      @ PRow(), 64   SAY if( V611 - ( V612 + V617 + V614 ) > 0, V611 - ( V612 + V617 + V614 ), 0 ) PICT '###,###,###.##'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 1 SAY '6 - INFORMACOES COMPLEMENTARES'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY OBS01
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY OBS02
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 1   SAY OBS03
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 1 SAY '7 - RESPONSAVEL PELAS INFORMACOES'
      @ PRow() + 1, 0 SAY repl( '-', 80 )
      @ PRow() + 1, 0 SAY '| Nome'
      @ PRow(), 50   SAY '| DATA     | Assinatura'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY '|'
      @ PRow(), 02   SAY xrRESN
      @ PRow(), 50   SAY '| ' + DToC( DXDIA2 ) + ' |'
      @ PRow(), 79   SAY '|'
      @ PRow() + 1, 0 SAY repl( '=', 80 )
      // @ prow() + 1, 1 say 'Aprovado pela IN/SRF  No.120/2000'
      IMPFOL()
   NEXT X
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IRRFTEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IRRFTEL

   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @  3, 3 SAY "PF:" + spac( 20 ) + "Nome:"
   @  4, 3 SAY "Rendimentos/Dedu‡oes/Reten‡”es   Isentos"
   @  5, 3 SAY "Rendimentos" + spac( 22 ) + "Sal.Familia"
   @  6, 3 SAY "Prev.Oficial" + spac( 21 ) + "Prov.Aposen."
   @  7, 3 SAY "Prev.Privada" + spac( 21 ) + "Diarias/Ajudas"
   @  8, 3 SAY "Pens„o" + spac( 27 ) + "Pensao/Aponsenta"
   @  9, 3 SAY "Dependentes" + spac( 22 ) + "Lucro"
   @ 10, 3 SAY "IRRF Retido" + spac( 22 ) + "Pago Soc./Tit"
   @ 11, 3 SAY "C.G.C" + spac( 28 ) + "Outros"
   @ 12, 3 SAY "Descri‡„o Outros Rendimentos Isentos"
   @ 14, 3 SAY "Tributados Fonte  Rendimento   IRRF.Ret. INSS  Dependente Pensao"
   @ 15, 3 SAY "13o.Sal"
   @ 16, 3 SAY "Outros"
   @ 17, 3 SAY "Descri‡„o Outros Rendimentos Exclusivo na Fonte"
   @ 19, 3 SAY "Informa‡”es Complementares"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IRRFGET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IRRFGET( lPEG )

   IF lPEG
      @  3, 7  GET CPF                     PICT "999.999.999-99" VALID VALCPF( CPF ) // num_cgc_cpf_benef
      @  3, 32 GET NOME // nom_beneficiario
   ELSE  // num_matricula
      @  3, 7  SAY CPF
      @  3, 32 SAY NOME // val_plano_saude
   ENDIF
   @  5, 16 GET V401                                    PICTURE '999999999.99' // Total dos Rendimentos   val_renda_bruta
   @  6, 16 GET V402                                    PICTURE '999999999.99' // Prev Oficial            val_inss
   @  7, 16 GET V403                                    PICTURE '999999999.99' // Prev Privada            val_prev_privada
   @  8, 16 GET V404                                    PICTURE '999999999.99' // Pensao                  val_pensao
   @  9, 16 GET V407                                    PICTURE '999999999.99' // Dependentes             val_depend
   @ 10, 16 GET V405                                    PICTURE '999999999.99' // Imposto Retido na Fonte val_ir_retido
   @  5, 56 GET V501                                    PICTURE '999999999.99' // Salario Familia         val_sal_familia
   @  6, 56 GET V502                                    PICTURE '999999999.99' // Aposentadoria
   @  7, 56 GET V503                                    PICTURE '999999999.99' // Diarias                 val_diaria_ajuda
   @  8, 56 GET V504                                    PICTURE '999999999.99' // invalidez
   @  9, 56 GET V505                                    PICTURE '999999999.99' // lucro                   val_lucros
   @ 10, 56 GET V506                                    PICTURE '999999999.99' // titulares
   @ 11, 16 GET CGC
   @ 11, 56 GET V507                                    PICTURE '999999999.99' // Indenizacoes outros //val_aviso_previo val_fgts_indeniz
   @ 13, 3  GET OBS01 // Val_indenizacao val_13_indeniz
// 13o. salario
   @ 15, 21 GET V601 PICTURE '999999999.99' // val_renda_bruta_13
   @ 15, 34 GET V605 PICTURE '9999999.99' // val_ir_retido_13
   @ 15, 45 GET V602 PICTURE '9999999.99' // val_inss_13
   @ 15, 56 GET V607 PICTURE '9999999.99' // val_depend_13
   @ 15, 67 GET V604 PICTURE '9999999.99' // val_pensao_13
// Outras
   @ 16, 21 GET V611 PICTURE '999999999.99' // renda_bruta
   @ 16, 34 GET V615 PICTURE '9999999.99' // ir_retido
   @ 16, 45 GET V612 PICTURE '9999999.99' // inss
   @ 16, 56 GET V617 PICTURE '9999999.99' // depend
   @ 16, 67 GET V614 PICTURE '9999999.99' // pensao
// obs
   @ 18, 3 GET OBS02
   @ 20, 3 GET OBS03
   @ 21, 3 GET OBS04
   @ 22, 3 GET OBS05
   READCUR()
   RETU .T.


// + EOF: folis_c6.prg
// +
