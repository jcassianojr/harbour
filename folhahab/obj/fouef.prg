// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fouef.prg
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
// :      FOUEF.PRG: IMPRIMIR CONTRATO DE EXPERIENCIA
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94      8:39
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

DECLARE SEM[ 7 ]
SEM[ 1 ] = 'Segunda : '
SEM[ 2 ] = 'Terca   : '
SEM[ 3 ] = 'Quarta  : '
SEM[ 4 ] = 'Quinta  : '
SEM[ 5 ] = 'Sexta   : '
SEM[ 6 ] = 'Sabado  : '
SEM[ 7 ] = 'Domingo : '
IF !MDL( 'Imprimir contrado de Experiencia' )
RETU
ENDIF
IF !CHECKIMP( 0 )
RETU .F.
ENDIF
CTR := 0
MDS( 'Digite o n£mero do Funcionario' )
@ 24, 40 GET CTR
READCUR()

lPRORROGA := MDG( "Deseja Termo de Prorrogacao" )
IF !NETUSE( PES )
RETU
ENDIF
dbGoTop()
IF !dbSeek( CTR )
MDT( 'Funcionario nao Encontrado' )
dbCloseAll()
RETU
ENDIF
BUSCAD := DEPTO * 1000000 + SETOR * 1000 + SECAO
BUSCAF := FUNCAO

IF !NETUSE( "FO_EXP" )
dbCloseAll()
RETU
ENDIF
dbGoTop()
IF !dbSeek( CTR )
MDT( 'Experiencia nao Encontrada' )
dbCloseAll()
RETU
ENDIF

NFUNCAO := OBTER( "FUNCAO",, FUNCAO, "NOME" )
NSETOR  := OBTER( "DEPTO",, BUSCAD, "NOME" )



IF !NETUSE( "FO_HOR" )
RETU
ENDIF
dbSelectAr( PES )
VAR1 := SALM := SALH := 0
SALHM()
TIPOS := CHECKTAB( "TSA2" + TIPO + "    ",,, "Tipo naoCadastrado", 2 )
IF MDG( 'Deseja detalhes em negrito' )
N := cIMPNEG
M := cIMPNER
ELSE
N := ""
m := ""
ENDIF

SET DEVI TO PRINT
@ PRow(), 0   SAY 'CONTRATO DE TRABALHO A TITULO DE EXPERIENCIA'
@ PRow() + 1, 0 SAY REPL( '-', 80 )
@ PRow() + 1, 0 SAY 'Por este instrumento particular, que entre si fazem a firma'
@ PRow() + 1, 0 SAY N + MSG2 + M
@ PRow() + 1, 0 SAY 'sita: ' + N + ender1 + ' - ' + bai1 + ' - ' + cid1 + m + ' Estado ' + N + est1 + m
@ PRow() + 1, 0 SAY 'Neste ato denominada simplismente "Empregadora", e o SR.'
@ PRow() + 1, 0 SAY N + NOME + M
@ PRow() + 1, 0 SAY 'portador da Carteira Profissional No.' + N + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ), PROFIS + m + ' Serie: ' + N + SERIE + m + ' UF:' + N + CTPSUF ) + M
@ PRow() + 1, 0 SAY 'PIS: ' + N + pis + m + ' CPF: ' + N + cpf + m
@ PRow() + 1, 0 SAY 'Doravante, denominado, simplesmente ,"empregado:, firmam o presente contrato'
@ PRow() + 1, 0 SAY 'Individual de trabalho, em caracter de experiencia, conforme a letra "C",do '
@ PRow() + 1, 0 SAY 'artigo 443 da Consolidacao das Leis do Trabalho, mediante as seguintes condicoes'
@ PRow() + 1, 0 SAY REPL( '-', 80 )
@ PRow() + 1, 0 SAY ACENTO( '1) - O Empregado trabalhar  para a Empregadora, exercendo as funcoes de: ' )
@ PRow() + 1, 5 SAY N + Trim( NFUNCAO ) + m + ' na secao: ' + N + Trim( NSETOR ) + m
@ PRow() + 1, 5 SAY 'percebendo o salario de: ' + N + Str( VAR1 ) + m + ' por ' + N + tipos + m
@ PRow() + 1, 5 SAY impstr( Cimpcom ) + N + EXT( VAR1, 1, 132, 132, 132 ) + M + impstr( CimpexP )
@ PRow() + 1, 0 SAY '2) - O horario a ser obdecido sera o seguinte: de ' + ht
@ PRow() + 1, 5 SAY 'sendo um total de ' + Str( HRSEM ) + ' horas semanais, podendo ser alterado quantas '
@ PRow() + 1, 5 SAY ACENTO( 'vezes se fizer necess rio' )
L := 3
dbSelectAr( "FO_HOR" )
dbGoTop()
IF dbSeek( CTR )
FOR X := 1 TO 7
HORD := 'D' + Str( X, 1 )
@ PRow() + 1, 5 SAY SEM[ X ] + &HORD
NEXT X
L := 1
ENDIF
dbSelectAr( "FO_EXP" )
IF lPRORROGA
@ PRow() + L, 0  SAY '3) - Este contrato tem inicio a partir de ' + N + DToC( admitido ) + M + ' Vencendo-se em'
@ PRow() + 1, 5 SAY N + DToC( DATAFIM1 ) + M + ',podendo ser prorrogado, obedecido o disposto no Paragrafo Unico'
@ PRow() + 1, 5 SAY 'do Artigo 445 da CLT.'
ELSE
@ PRow() + L, 0  SAY '3) - Este contrato tem inicio a partir de ' + N + DToC( admitido ) + M + ' Vencendo-se em ' + N + DToC( DATAFIM1 ) + M
@ PRow() + 1, 5 SAY 'se o contrato continuar ap¢s esta data se considera automaticamente  '
@ PRow() + 1, 5 SAY 'prorrogado at‚ ' + N + DToC( DATAFIM2 ) + M + ' obedecido o disposto no ' + impCHR( 21 ) + ' Unico do Art 445 da CLT.'
ENDIF
@ PRow() + 1, 0  SAY '4) - O empregado se compromete a trabalhar em regime de compensacao e de'
@ PRow() + 1, 5  SAY 'prorrogacao de horas, inclusive em periodo noturno, sempre que as'
@ PRow() + 1, 5  SAY 'necessidades assim o exigirem, observadas as formalidades legais.'
@ PRow() + 1, 0  SAY '5) - Obriga-se o empregado, alem de executar com dedicacao e lealdade o seu '
@ PRow() + 1, 5  SAY 'servico, a cumprir o Regulamento Interno da Empregadora, as instrucoes de'
@ PRow() + 1, 5  SAY 'sua administracao e as ordens de seus chefes e superiores hieararquicos,'
@ PRow() + 1, 5  SAY 'relativas as peculiaridades dos servicos que lhe forem confiados.'
@ PRow() + 1, 0  SAY '6) - Aplicam-se a este contrato todas as normas em vigor,relativos aos contratos'
@ PRow() + 1, 5  SAY 'a prazo determinado, devendo sua rescis„o antecipada, por justa causa,'
@ PRow() + 1, 5  SAY 'obdecer ao disposto nos artigos 482 e 483 da C.L.T., conforme o caso:'
@ PRow() + 1, 0  SAY '7) - Vencido o periodo experimental e continuando o empregado a prestar servicos'
@ PRow() + 1, 5  SAY 'a Empregadora, por tempo indeterminado,ficam prorrogados todas as clausulas'
@ PRow() + 1, 5  SAY 'aqui estabelecidas, enquanto n„o se rescindir o contrato de trabalho.'
@ PRow() + 1, 0  SAY '8)- A empregadora descontara dos salarios do EMPREGADO, com sua expressa '
@ PRow() + 1, 5  SAY 'concordancia, nao so o que ja e de lei ou Convencao Coletiva como ainda a '
@ PRow() + 1, 5  SAY 'importancia corespondente dos danos causados pelo EMPREGADO, por dolo ou'
@ PRow() + 1, 5  SAY 'culpa,nos termos do paragrafo 1o do artigo 462 da CLT'
@ PRow() + 1, 0  SAY REPL( '=', 80 )
@ PRow() + 1, 0  SAY 'CONTRATO'
@ PRow() + 1, 0  SAY 'E por estarem de pleno acordo, assinam ambas as partes, em duas vias de igual'
@ PRow() + 1, 0  SAY 'teor na presenca de duas testemunhas'
@ PRow() + 1, 0  SAY cid1 + N + DToC( admitido ) + M
@ PRow() + 1, 39 SAY REPL( '-', 35 )
@ PRow() + 1, 39 SAY 'Responsavel quando menor'
@ PRow() + 2, 0  SAY REPL( '-', 35 )
@ PRow(), 39    SAY REPL( '-', 35 )
@ PRow() + 1, 0  SAY 'Empregador'
@ PRow(), 39    SAY 'Empregado'
@ PRow() + 1, 0  SAY REPL( '=', 80 )
IF lPRORROGA
@ PRow() + 1, 0  SAY 'TERMO DE PRORROGACAO'
@ PRow() + 1, 0  SAY 'Por mutuo acordo entre as partes, fica o presente contrato de experiencia, que'
@ PRow() + 1, 0  SAY 'deveria vencer nesta data,prorrogado ate:     /     /'
@ PRow() + 1, 0  SAY cid1
@ PRow() + 1, 39 SAY REPL( '-', 35 )
@ PRow() + 1, 0  SAY REPL( '=', 80 )
ENDIF
@ PRow() + 1, 0 SAY 'TESTEMUNHAS'
@ PRow() + 2, 0 SAY REPL( '-', 35 )
@ PRow(), 39   SAY REPL( '-', 35 )
@ PRow() + 2, 0 SAY REPL( '=', 80 )
IMPFOL()
dbCloseAll()
IMPEND()
RETU
// : FIM: FOUEF.PRG

// + EOF: fouef.prg
// +
