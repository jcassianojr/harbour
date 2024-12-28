// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_eb.prg
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
// :   FORES_EB.PRG: Solicita‡„o de Abono Pecuniario de F‚rias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:08
// :
// :  Procs & Fncts: FORES_EB()
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

EMITIDO := DATFERIASF - 16
MDS( 'Confirme Data de Emissao' )
@ 24, 40 GET EMITIDO
READCUR()
IMPRESSORA()
FOR X := 1 TO COP
@ PRow() + 1, 0  SAY IMPCHR( cIMPTIT ) + 'SOLICITACAO DE ABONO PECUNIARIO DE FERIAS'
@ PRow() + 1, 20 SAY IMPSTR( cIMPCOM ) + 'Paragrafo 1. artigo 143 da C.L.T., com as alteracoes do Dec. Lei nro. 1535 de 13/04/1977' + IMPSTR( cIMPEXP )
@ PRow() + 1, 0  SAY REPL( '=', 80 )
@ PRow() + 2, 0  SAY 'Local: ' + CID1 + ',' + EST1 + '-' + DToC( EMITIDO )
@ PRow() + 2, 0  SAY 'Firma ' + MSG2
@ PRow() + 1, 0  SAY 'Endereco ' + ENDER1 + '-' + BAI1 + '-' + CID1 + '-' + EST1
@ PRow() + 2, 0  SAY 'Prezado(s) Senhor(es),'
@ PRow() + 2, 0  SAY IMPSTR( cIMPCOM )
@ PRow(), 0    SAY 'O infra assinado,  funcionario dessa firma, vem  respeitosamente, requerer lhe seja concedido um terco  do periodo de  suas'
@ PRow() + 1, 0  SAY 'ferias, a  quem tem  direito, em abono pecuniario, ficando a  criterio da firma a designacao da data da epoca da concessao,'
@ PRow() + 1, 0  SAY 'tudo de acordo com a Consolidacao das Leis do Trabalho'
@ PRow() + 1, 0  SAY 'Relativas ao periodo aquisitivo de ' + DToC( DATFERIAS ) + ' a ' + DToC( DATFERIASF )
@ PRow() + 1, 0  SAY 'Favor dar o ciente na copia deste.' + IMPSTR( cIMPEXP )
@ PRow() + 1, 0  SAY REPL( '=', 80 )
dbSelectAr( PES )
@ PRow() + 1, 0  SAY 'Numero: ' + Str( NUMERO ) + ' Nome: ' + NOME
@ PRow() + 1, 0  SAY 'CTPS: ' + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
@ PRow() + 1, 0  SAY REPL( '=', 80 )
@ PRow() + 1, 0  SAY 'Atenciosamente'
@ PRow(), 39    SAY 'Ciente em     /    /    '
@ PRow() + 3, 0  SAY REPL( '-', 30 )
@ PRow(), 39    SAY REPL( '-', 30 )
@ PRow() + 1, 10 SAY 'Empregado'
@ PRow(), 49    SAY 'Empregador'
@ PRow() + 2, 0  SAY REPL( '=', 80 )
IMPFOL()
dbSelectAr( "FO_FER" )
NEXT X
VIDEO()
IMPEND()
RETU
// : FIM: FORES_EB.PRG

// + EOF: fores_eb.prg
// +
