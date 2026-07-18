// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fouc3.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FOUC3.PRG: Op‡„o FGTS
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94     11:21
// :
// :  Procs & Fncts: FOUC3()
// :
// :          Chama: CABEX()  (fun‡„o em FOLPROC.PRG)
// :
// :     Arq. Dados: BCOFGTS
// :
// :         Indice: BCOFGTS   Por ordem de n£mero de Empresas
// :                           EMP
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

CABEX( 'IMPRIMIR OP€ŽO DE FGTS' )
IF !netuse( "BCOFGTS" )
RETU
ENDIF
dbGoTop()
IF dbSeek( NREMP )
BANCFGTS := NOME
AGENFGTS := NOMEAGENC
ELSE
BANCFGTS := AGENFGTS := ""
ENDIF
dbCloseArea()

IF MDG( 'Deseja detalhes em negrito' )
N := cIMPNEG
M := cIMPNER
ELSE
N := ""
M := ""
ENDIF

mTEMP  := tmpfile( cRDDEXT )
INX    := ""
FILTRO := ""
aRETU  := RFILORD( PES )
INX    := aRETU[ 1 ]
FILTRO := aRETU[ 2 ]

IF !NETUSE( PES )
RETU
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )


SET FILTER TO &FILTRO
SET DEVICE TO PRINT
dbGoTop()
WHILE !Eof()
@ PRow(), 1    SAY REPL( '-', 80 )
@ PRow() + 1, 1  SAY 'DECLARACAO DE OPCAO PARA FUNDO DE GARANTIA DO TEMPO DE SERVICO)'
@ PRow() + 1, 20 SAY '(Lei No. 5.107 de 13 de setembro de 1966)'
@ PRow() + 1, 1  SAY REPL( '-', 80 )
@ PRow() + 5, 1  SAY 'Eu,' + N + NOME + M
@ PRow() + 1, 1  SAY 'portador da Carteira Profissional No.' + N + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ), PROFISM + ' Serie: ' + N + SERIE + M + ' UF:' + N + CTPSUF ) + M
@ PRow() + 1, 1  SAY 'Empregado da empresa:' + N + msg2 + M
@ PRow() + 1, 1  SAY 'Sito A: ' + N + ender1 + ' - ' + bai1 + ' - ' + cid1 + M + ' Estado ' + N + est1 + M
@ PRow() + 1, 1  SAY '      Declaro para todos os fins, que nesta data, exerco a opcao'
@ PRow() + 1, 1  SAY 'pelo regime do Regulamento do Fundo de Garantia do Tempo de servico,'
@ PRow() + 1, 1  SAY 'aprovado pelo decreto no. 68.910, de 20 de dezembro de 1966.'
@ PRow() + 2, 1  SAY cid1
@ PRow(), 30    SAY N + DToC( fgts ) + M
@ PRow() + 2, 1  SAY REPL( '_', 40 )
@ PRow() + 1, 1  SAY 'Assinatura'
@ PRow() + 2, 1  SAY 'TESTEMUNHAS'
@ PRow() + 2, 1  SAY REPL( '_', 40 )
@ PRow() + 2, 1  SAY REPL( '_', 40 )
@ PRow() + 2, 1  SAY REPL( '_', 40 )
@ PRow() + 1, 1  SAY 'Assistente responsavel legal pelo menor, quando couber'
@ PRow() + 1, 1  SAY REPL( '-', 80 )
@ PRow() + 2, 1  SAY 'Recebemos o Original'
@ PRow() + 1, 30 SAY CID1 + ', ' + N + DToC( fgts ) + M
@ PRow() + 2, 1  SAY REPL( '_', 40 )
@ PRow() + 2, 1  SAY REPL( '-', 80 )
@ PRow() + 1, 1  SAY '1 - Em'
@ PRow(), 8    SAY N + DToC( fgts ) + M
@ PRow(), 18    SAY 'optou pelo sistema estabelecido na Lei no. 5.107,'
@ PRow() + 1, 5  SAY 'de 13 de setembro de 1966, que estabeleceu o Fundo de Garantia'
@ PRow() + 1, 5  SAY 'do Tempo de Servico'
@ PRow() + 2, 1  SAY '2 - Os depositos na conta vinculada do empregado, decorrente da'
@ PRow() + 1, 5  SAY 'Lei no. 5.1l07 de 13 de setembro de 1966, sao feitos no'
@ PRow() + 1, 5  SAY 'Banco: ' + N + BANCFGTS + M
@ PRow() + 1, 5  SAY 'Agencia: ' + N + AGENFGTS + M
EJEC
dbSkip()
ENDDO
dbCloseArea()
SET DEVI TO SCRE
FErase( mTEMP )
RETU .T.

// : FIM: FOUC3.PRG

// + EOF: fouc3.prg
// +
