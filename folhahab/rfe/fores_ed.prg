// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_ed.prg
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
// :   FORES_ED.PRG: Recibo Abono Pecuniario Ferias
// :      Linguagem: harbour
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/26/94      9:09
// :
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fores_ed()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fores_ed

   PARA CC

   EMITIDO := GOZOU1DE - 1
   EMITIDO := EMITIDO - IF( DoW( EMITIDO ) = 7, 1, 0 )
   EMITIDO := EMITIDO - IF( DoW( EMITIDO ) = 7, 2, 0 )
   MDS( 'Confirme Data de Pagamento' )
   @ 24, 40 GET EMITIDO
   READCUR()
   POS1   := IMPCHR( cIMPTIT ) + IMPSTR( cIMPCOM ) + 'RECIBO DE 1/3 (um terco) DE ABONO PECUNIARIO DE FERIAS'
   POS1   := POS1 + IF( CC = 0, "", " Complemento" ) + IMPSTR( cIMPEXP )
   COMPAR := IF( CC = 0, "CTA=82.OR.CTA=83.OR.CTA=174.OR.CTA=175.OR.CTA=583.OR.CTA=992", "CTA=176.OR.CTA=177.OR.CTA=992" )

   IMPRESSORA()
   FOR X := 1 TO COP
      @ PRow() + 1, 0  SAY REPL( '=', 80 )
      @ PRow() + 1, 0  SAY POS1
      @ PRow() + 1, 48 SAY 'Artigo 145 e Paragrafo da C.L.T.' + IMPSTR( cIMPEXP )
      @ PRow() + 1, 0  SAY REPL( '=', 80 )
      dbSelectAr( PES )
      VAR1 := SALM := SALH := 0
      SALHM( MEF )
      @ PRow() + 1, 5 SAY 'nome do empregado'
      @ PRow(), 50   SAY 'c.t.p.s.'
      @ PRow(), 70   SAY 'registro'
      @ PRow() + 1, 0 SAY REPL( '-', 80 )
      @ PRow() + 1, 1 SAY NUMERO
      @ PRow(), 7   SAY NOME
      @ PRow(), 48   SAY IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ) + "/" + SubStr( TIRAOUT( CPF ), 8 ), PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
      @ PRow() + 1, 0 SAY REPL( '-', 80 )
      dbSelectAr( "FO_FER" )
      @ PRow() + 1, 8 SAY 'periodo completo das ferias'
      @ PRow(), 44   SAY 'dias  - periodo de 1/3 das Licenca '
      @ PRow() + 1, 0 SAY REPL( '-', 80 )
      @ PRow() + 1, 8 SAY IF( ABONO1DE > GOZOU1DE, GOZOU1DE, ABONO1DE )
      @ PRow(), 22   SAY 'A'
      @ PRow(), 27   SAY IF( ABONO1ATE > GOZOU1ATE, ABONO1ATE, GOZOU1ATE )
      @ PRow(), 45   SAY DIASPAGO2                                     PICT '##'
      @ PRow(), 48   SAY ABONO1DE
      @ PRow(), 60   SAY 'A'
      @ PRow(), 65   SAY ABONO1ATE
      VENC := DESC := 0
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      @ PRow() + 1, 18 SAY 'BASE PARA CALCULO DA REMUNERACAO DAS FERIAS '
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      @ PRow() + 1, 1  SAY 'Faltas|'
      @ PRow(), 9    SAY 'Salario base |'
      @ PRow(), 24    SAY 'Tipo            | Salario Variavel | Remuneracao Base'
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      @ PRow() + 1, 4  SAY FALTAS                                                  PICT '###'
      @ PRow(), 9    SAY VAR1                                                    PICT '###,###,###.##'
      @ PRow(), 9    SAY VAR1                                                    PICT '###,###,###.##'
      dbSelectAr( PES )
      VIDEO()
      XTIPO := CHECKTAB( "TSA2" + TIPO + "    ",,, "Tipo nao Cadastrado", 2 )
      IMPRESSORA()
      dbSelectAr( "FO_FER" )
      @ PRow(), 42    SAY IF( OPX = 4, SALVAR, SALVARC )      PICT '###,###,###.##'
      @ PRow(), 62    SAY SALM + IF( OPX = 4, SALVAR, SALVARC ) PICT '###,###,###.##'
      @ PRow() + 1, 0  SAY REPL( '*', 80 )
      @ PRow() + 1, 25 SAY 'DEMONSTRATIVO FINANCEIRO'
      @ PRow() + 1, 0  SAY REPL( '*', 80 )
      @ PRow() + 1, 0  SAY 'CONTA'
      @ PRow(), 7    SAY 'DESCRIMINACAO DA CONTA'
      @ PRow(), 49    SAY '  VENCIMENTOS '
      @ PRow(), 64    SAY '   DESCONTOS  '
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      dbSelectAr( "FO_PFE" )
      dbGoTop()
      WHILE !Eof()
         CTA := CONTA
         IF &COMPAR
            dbSelectAr( "CONTAS" )
            dbGoTop()
            IF dbSeek( CTA )
               COL := IF( CTA < 400, 49, 64 )
               @ PRow() + 1, 3 SAY CODIGO PICT '###'
               @ PRow(), 9   SAY DESCR
               dbSelectAr( "FO_PFE" )
               @ PRow(), COL SAY VALOR PICT '###,###,###.##'
               VENC := VENC + IF( CTA < 400, VALOR, 0 )
               DESC := DESC + IF( CTA > 500, VALOR, 0 )
            ENDIF
         ENDIF
         dbSelectAr( "FO_PFE" )
         dbSkip()
      ENDDO
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      @ PRow() + 1, 38 SAY 'Totais => '
      @ PRow(), 49    SAY VENC                          PICT '###,###,###.##'
      @ PRow(), 64    SAY DESC                          PICT '###,###,###.##'
      @ PRow() + 1, 0  SAY REPL( '=', 80 )
      @ PRow() + 1, 35 SAY 'Total Liquido a Receber => '
      SALDO := VENC - DESC
      @ PRow(), 64    SAY SALDO                                                                                                                        PICT '###,###,###.##'
      @ PRow(), 64    SAY SALDO                                                                                                                        PICT '###,###,###.##'
      @ PRow() + 1, 0  SAY REPL( '=', 80 )
      @ PRow() + 1, 0  SAY POS1
      @ PRow() + 1, 35 SAY IMPSTR( cIMPCOM ) + 'De acordo com o paragrafo unico do artigo 145 da C.L.T.' + IMPSTR( cIMPEXP )
      @ PRow() + 1, 0  SAY REPL( '=', 80 )
      @ PRow() + 2, 0  SAY IMPSTR( cIMPCOM ) + 'Recebi da ' + msg2 + '; Estabelecida a ' + ENDER1
      @ PRow() + 1, 0  SAY BAI1 + '-' + CID1 + '-' + EST1
      @ PRow() + 1, 0  SAY 'a importancia de ' + ZMOEDA06
      @ PRow(), 24    SAY SALDO                                                                                                                        PICT '###,###,###.##'
      @ PRow() + 1, 0  SAY EXT( SALDO, 1, 132, 0, 0 )
      @ PRow() + 2, 0  SAY 'correspondente ao abono pecuniario de 1/3 (um terco) das minhas ferias, referente ao periodo acima descrito, tudo conforme'
      @ PRow() + 1, 0  SAY 'requerimento que apresentei em tempo habil, dando plena e geral quitacao deste recebimento ' + IMPSTR( cIMPEXP )
      @ PRow() + 2, 0  SAY 'Local: ' + CID1 + ',' + EST1 + '-' + DToC( EMITIDO )
      @ PRow(), 52    SAY '___________________________'
      @ PRow() + 1, 63 SAY 'Empregado'
      @ PRow() + 1, 1  SAY REPL( '=', 80 )
      IMPFOL()
   NEXT X
   VIDEO()
   dbCloseAll()
   IMPEND()
   RETU
// : FIM: FORES_ED.PRG

// + EOF: fores_ed.prg
// +
