// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_ec.prg
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
// :   FORES_EC.PRG: Recibo de Ferias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 03/03/99
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

EMITIDO := GOZOU1DE - 1
EMITIDO := EMITIDO - IF( DoW( EMITIDO ) = 7, 1, 0 )
EMITIDO := EMITIDO - IF( DoW( EMITIDO ) = 7, 2, 0 )
MDS( 'Confirme a Data de Emiss„o' )
@ 24, 40 GET EMITIDO
READCUR()
IMPRESSORA()
@ PRow(), 0 SAY IMPSTR( cIMPEXP )
FOR X := 1 TO COP
@ PRow() + 1, 0  SAY REPL( '=', 80 )
@ PRow() + 1, 0  SAY IMPCHR( cIMPTIT ) + ' RECIBO  DE  FERIAS ' + IF( OPX # 3, 'COMPLEMENTO', '' )
@ PRow() + 1, 15 SAY 'De acordo com o paragrafo unico do artigo 145 da C.L.T.'
@ PRow() + 1, 0  SAY REPL( '=', 80 )
dbSelectAr( PES )
VAR1 := SALH := SALM := 0
SALHM( MEF )
@ PRow() + 1, 5 SAY 'nome do empregado'
@ PRow(), 50   SAY 'c.t.p.s.'
@ PRow(), 70   SAY 'registro'
@ PRow() + 1, 0 SAY REPL( '-', 80 )
@ PRow() + 1, 7 SAY NOME
@ PRow(), 44   SAY IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
@ PRow(), 70   SAY NUMERO
@ PRow() + 1, 0 SAY REPL( '-', 80 )
dbSelectAr( "FO_FER" )
@ PRow() + 1, 10 SAY 'periodo de aquisicao'
@ PRow(), 54    SAY IF( OPX = 3, 'periodo de gozo', 'periodo de complemento' )
@ PRow() + 1, 0  SAY REPL( '-', 80 )
@ PRow() + 1, 6  SAY DATFERIAS
@ PRow(), 20    SAY 'A'
@ PRow(), 25    SAY DATFERIASF
@ PRow(), 48    SAY IF( OPX = 3, GOZOU1DE, COMPDATAI )
@ PRow(), 60    SAY 'A'
@ PRow(), 65    SAY IF( OPX = 3, GOZOU1ATE, COMPDATAF )
VENC := DESC := 0
@ PRow() + 1, 0  SAY REPL( '-', 80 )
@ PRow() + 1, 10 SAY 'BASE PARA CALCULO DA REMUNERACAO DAS FERIAS'
@ PRow() + 1, 0  SAY REPL( '-', 80 )
@ PRow() + 1, 1  SAY 'Faltas|'
@ PRow(), 9    SAY 'Salario base |'
@ PRow(), 24    SAY 'Tipo            | Salario Variavel | Remuneracao Base'
@ PRow() + 1, 1  SAY REPL( '-', 80 )
@ PRow() + 1, 4  SAY FALTAS                                                  PICT '###'
@ PRow(), 9    SAY VAR1                                                    PICT '###,###,###.##'
dbSelectAr( PES )
VIDEO()
XTIPO := CHECKTAB( "TSA2" + TIPO + "    ",,, "Tipo nao Cadastrado", 2 )
IMPRESSORA()
@ PRow(), 24 SAY xTIPO
dbSelectAr( "FO_FER" )
@ PRow(), 42    SAY IF( OPX = 3, SALVAR, SALVARC )      PICT '###,###,###.##'
@ PRow(), 62    SAY SALM + IF( OPX = 3, SALVAR, SALVARC ) PICT '###,###,###.##'
@ PRow() + 1, 0  SAY REPL( '*', 80 )
@ PRow() + 1, 25 SAY 'DEMONSTRATIVO FINANCEIRO'
@ PRow() + 1, 0  SAY REPL( '*', 80 )
@ PRow() + 1, 1  SAY 'CONTA'
@ PRow(), 7    SAY 'DESCRIMINACAO DA CONTA'
@ PRow(), 49    SAY '  VENCIMENTOS '
@ PRow(), 64    SAY '   DESCONTOS  '
@ PRow() + 1, 0  SAY REPL( '-', 80 )
dbSelectAr( "FO_PFE" )
dbGoTop()
WHILE !Eof()
CTA := CONTA
dbSelectAr( "CONTAS" )
dbGoTop()
IF dbSeek( CTA )
IF ( PRFER = 0 .AND. OPX = 3 ) .OR. ( PRFCO = 0 .AND. OPX = 5 )
@ PRow() + 1, 3 SAY CODIGO PICT '###'
@ PRow(), 9   SAY DESCR
dbSelectAr( "FO_PFE" )
VENC += IF( CONTA < 400, VALOR, 0 )
DESC += IF( CONTA > 500, VALOR, 0 )
@ PRow(), IF( CONTA < 400, 49, 64 ) SAY VALOR PICT '###,###,###.##'
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
@ PRow(), 64    SAY SALDO                                                                                                                             PICT '###,###,###.##'
@ PRow(), 64    SAY SALDO                                                                                                                             PICT '###,###,###.##'
@ PRow() + 2, 2  SAY IMPSTR( cIMPCOM ) + 'Recebi da ' + MSG2 + '; Estabelecida a ' + ENDER1 + ';'
@ PRow() + 1, 2  SAY + BAI1 + '-' + CID1 + '-' + EST1
@ PRow() + 1, 2  SAY 'a importancia de ' + ZMOEDA06
@ PRow(), 24    SAY SALDO                                                                                                                             PICT '###,###,###.##'
@ PRow() + 1, 02 SAY EXT( SALDO, 1, 132, 0, 0 )
@ PRow() + 1, 2  SAY 'Que me paga adiantadamente por motivo de minhas ferias regulamentares, ora concedidas e que vou gozar de acordo com a descricao'
@ PRow() + 1, 2  SAY 'acima; tudo conforme o aviso que recebi em tempo, ao qual dei meu ciente.'
@ PRow() + 1, 2  SAY 'Para clareza e documento, firmo o presente recibo, dando a firma plena e geral quitacao.' + IMPSTR( cIMPEXP )
@ PRow() + 2, 0  SAY 'Local: ' + CID1 + ',' + EST1 + '-' + DToC( EMITIDO )
@ PRow(), 52    SAY '___________________________'
@ PRow() + 1, 63 SAY 'Empregado'
@ PRow() + 1, 0  SAY REPL( '=', 80 )
IMPFOL()
NEXT X
VIDEO()
dbCloseAll()
IMPEND()
RETU
// : FIM: FORES_EC.PRG

// + EOF: fores_ec.prg
// +
