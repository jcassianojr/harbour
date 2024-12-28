// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_c5.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :
// :  FOLIS_C5.PRG : Listar Ficha Financeira de Funcion rios
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


// //#INCLUDE "COMANDO.CH"
IF !MDL( 'Listar Ficha Financeira', 0 )
RETU
ENDIF

SetColor( "W/N,N/W" )
@ 08, 00 CLEA
IF IM1 = 'A'
@ 17, 00 TO 21, 79 DOUB
@ 18, 10 SAY 'ATENCAO !!!'
@ 19, 10 SAY 'Sua Impressora nao permite o preenchimento completo.'
@ 20, 10 SAY 'Sendo Assim altera a configracao e use o 132 colunas'
IF !MDG( "Deseja Continuar" )
RETU
ENDIF
ENDIF

MESTADO  := ""
MCIDADE  := ""
MNESTADO := ""
MNCIDADE := ""
MPAIS    := ""


FL  := CONTINUA := 0
VAL := Array( 12 )

IF !NETUSE( PES )
RETU
ENDIF
FILTRO := ''
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO
dbGoTop()

IF !NETUSE( "CONTAS" )
RETU
ENDIF

IF !NETUSE( "FUNCAO" )
RETU
ENDIF


IF !NETUSE( "SINDICAT" )
RETU
ENDIF

IF !NETUSE( "DEPTO" )
RETU
ENDIF

SET DEVI TO PRIN
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
FL++
NUM := NUMERO
ALLTRUE( CHECKCID(,, .F., IBGE, { { "UF", "mESTADO" }, { "NOME", "mCIDADE" } } ) )
ALLTRUE( CheckBacen( NASCPAIS, mPAIS, .F., { { "STRZERO(BACEN,4)", "NACPAIS" }, { "NOME", "mPAIS" } } ) )
@  1, 1   SAY IMPSTR( cIMPEXP )
@  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
@  3, 20  SAY IMPCHR( cIMPTIT ) + 'FICHA FINANCEIRA FUNCIONARIO ( ANUAL )'
@  4, 30  SAY IMPCHR( cIMPTIT ) + MMES + '/' + StrZero( ANO, 4 )
@  5, 100 SAY Time()
@  5, 110 SAY DXDIA
@  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
// * DADOS DO FUNCIONARIO
@ PRow() + 1, 0 SAY REPL( '-', 132 )
@ PRow() + 1, 1 SAY 'DEPTO'
@ PRow(), 8   SAY 'SETOR'
@ PRow(), 15   SAY 'SECAO'
@ PRow(), 59   SAY 'CHAPA'
@ PRow(), 65   SAY 'N. Reg'
@ PRow(), 73   SAY 'NOME FUNCIONARIO'
@ PRow(), 105  SAY 'ORDEM'
@ PRow() + 1, 2 SAY DEPTO
@ PRow(), 9   SAY SETOR
@ PRow(), 16   SAY SECAO
DDEM := DEPTO * 1000000 + SETOR * 1000 + SECAO
@ PRow(), 60  SAY CHAPA
@ PRow(), 66  SAY NUMERO
@ PRow(), 73  SAY NOME
@ PRow(), 107 SAY ORDEM
IF !Empty( DEMITIDO )
@ PRow(), 102 SAY 'D E M I T I D O'
@ PRow(), 102 SAY 'D E M I T I D O'
@ PRow(), 102 SAY 'D E M I T I D O'
ENDIF
@ PRow() + 1, 0 SAY REPL( '-', 132 )
@ PRow() + 1, 2 SAY 'ENDERECO -->'
@ PRow(), 14   SAY ENDER + "," + AllTrim( ENDNUM ) + " " + AllTrim( ENDCOMPL )
@ PRow(), 50   SAY 'PIS --------->'
@ PRow(), 64   SAY PIS
@ PRow(), 92   SAY 'BANCO --------->'
@ PRow(), 108  SAY BANCO
@ PRow() + 1, 2 SAY 'BAIRRO ---->'
@ PRow(), 14   SAY BAIRRO
@ PRow(), 50   SAY 'F.G.T.S ----->'
@ PRow(), 64   SAY FGTS
@ PRow(), 92   SAY 'AGENCIA ------->'
@ PRow(), 108  SAY AGENCIA
@ PRow() + 1, 2 SAY 'CIDADE ---->'
@ PRow(), 14   SAY CIDADE
@ PRow(), 50   SAY 'DT ADMISSAO ->'
@ PRow(), 64   SAY ADMITIDO
@ PRow(), 92   SAY 'N. CONTA ------>'
@ PRow(), 108  SAY CONTA
@ PRow() + 1, 2 SAY 'ESTADO ---->'
@ PRow(), 14   SAY ESTADO
@ PRow(), 50   SAY 'TIPO -------->'
@ PRow(), 64   SAY TIPO + '-' + CHECKTAB( "TSA2" + TIPO + "    ",,, "Tipo n„o Cadastrado", 2 )
@ PRow(), 65   SAY '-'
@ PRow(), 66   SAY TIP
@ PRow(), 92   SAY 'SOCIO SIND ---->'
@ PRow(), 108  SAY SOCIOSIND
@ PRow() + 1, 2 SAY 'CEP ------->'
@ PRow(), 14   SAY CEP
@ PRow(), 50   SAY 'H. SEMANAIS ->'
@ PRow(), 64   SAY HRSEM
@ PRow(), 92   SAY 'SITUACAO ------>'
@ PRow(), 108  SAY SITUACAO + '-' + CHECKTAB( "SITU" + SITUACAO,,, "Situacao nao Cadastrado", 2 )
@ PRow() + 1, 2 SAY 'TELEFONE -->'
@ PRow(), 14   SAY FONE
@ PRow(), 50   SAY 'FUNCAO ------>'
@ PRow(), 64   SAY FUNCAO
@ PRow(), 68   SAY '-'
@ PRow(), 69   SAY OBTER( "FUNCAO",, FUNCAO, "FNOME" )
dbSelectAr( PES )
@ PRow(), 92   SAY 'INSALUBRIDADE-->'
@ PRow(), 108  SAY INSALUBRI
@ PRow() + 1, 2 SAY 'DT NASCTO ->'
@ PRow(), 14   SAY NASC
@ PRow(), 50   SAY 'CBO ->'
@ PRow(), 62   SAY OBTER( "FUNCAO",, FUNCAO, "CBONEW" ) // CBONEW
@ PRow(), 92   SAY 'PERICULOSIDADE->'
@ PRow(), 108  SAY PERICULO
@ PRow() + 1, 2 SAY 'EST. CIVIL->'
@ PRow(), 14   SAY ESTCIVIL + "-" + CHECKTAB( "ECIV" + ESTCIVIL,,, "Estado Civil nao Cadastrado", 2 )
@ PRow(), 50   SAY 'DEMITIDO ---->'
@ PRow(), 64   SAY DEMITIDO
@ PRow() + 1, 2 SAY 'Escolarid.->'
@ PRow(), 14   SAY ESCRAIS + '-' + CHECKTAB( "EESC" + ESCRAIS,,, "Escolaridade nao Cadastrada", 2 )
@ PRow(), 50   SAY 'DT REC.SIND.->'
@ PRow(), 64   SAY DATCONTSIN
@ PRow(), 92   SAY 'N. SINDICATO--->'
@ PRow(), 108  SAY SINDICATO
@ PRow(), 110  SAY '-'
DDEM := SINDICATO
dbSelectAr( "SINDICAT" )
@ PRow(), 111 SAY IF( dbSeek( DDEM ), COGNOME, 'NAO CADASTRADO' )
dbSelectAr( PES )
@ PRow() + 1, 2 SAY 'Nacionalidade: ' + NACPAIS + " " + mPAIS
@ PRow(), 50   SAY 'C.P.F ------->'
@ PRow(), 64   SAY CPF
@ PRow(), 92   SAY 'CTPS:' + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ) + "/" + SubStr( TIRAOUT( CPF ), 8 ), PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
@ PRow() + 1, 0 SAY REPL( '-', 132 )
@ PRow() + 1, 1 SAY IMPSTR( cIMPCOM )
@ PRow(), 1   SAY 'CONTA'
@ PRow(), 8   SAY 'Nome Conta '
FOR X := 1 TO 12
COL := 24 + ( X * 14 )
@ PRow(), COL SAY MMES( X )
NEXT X
@ PRow(), 208  SAY 'Total   Ano'
@ PRow() + 1, 1 SAY '000 - Salario do Mes'
FOR X := 1 TO 12
COL  := 22 + ( X * 14 )
XSAL := MMES( X )
XSAL := SubStr( XSAL, 1, 3 )
XSAL := 'SAL' + XSAL
@ PRow(), COL SAY &XSAL PICT '###,###,###.##'
NEXT X
CONTAR := 0
dbSelectAr( RES )
dbGoTop()
dbSeek( NUM * 10000000 )
DO WHILE NUMERO = NUM .AND. !Eof()
CTA := CONTA
@ PRow() + 1, 1 SAY CONTA PICT '###'
HOR  := .F.
TVAL := 0.00
AFill( VAL, 0 )
dbSelectAr( "CONTAS" )
dbGoTop()
IF dbSeek( CTA )
DESC := SubStr( DESCR, 1, 30 )
IF TIPO = 1 .OR. TIPO = 3
@ PRow(), 6 SAY DESC + '(HR)'
HOR := .T.
ENDIF
ELSE
DESC := "Conta nao Cadastrada"
ENDIF
dbSelectAr( RES )
DO WHILE CONTA = CTA .AND. !Eof()
COL := MES * 14 + 22
IF HOR
@ PRow(), COL SAY HORAS PICT '###,###,###.##'
TVAL := TVAL + HORAS
ENDIF
VAL[ MES ] = VALOR
dbSkip()
ENDDO
IF HOR
@ PRow(), 208 SAY TVAL PICT '#########.##'
CONTAR := CONTAR + 1
@ PRow() + 1, 6 SAY DESC
ELSE
@ PRow(), 6 SAY DESC
ENDIF
FOR X := 1 TO 12
IF VAL[ X ] # 0
COL := X * 14 + 22
@ PRow(), COL SAY VAL[ X ] PICT '###,###,###.##'
TVAL := TVAL + VAL[ X ]
ENDIF
NEXT X
@ PRow(), 208 SAY TVAL PICT '#########.##'
CONTAR := CONTAR + 1
IF CONTAR > 35
dbSelectAr( PES )
CONTAR := 0
FL     := FL + 1
@  1, 1  SAY IMPSTR( cIMPEXP )
@  2, 01 SAY IMPCHR( cIMPTIT )
@  2, 20 SAY MSG2
@  3, 1  SAY IMPCHR( cIMPTIT )
@  3, 20 SAY 'FICHA FINANCEIRA FUNCIONARIO ( ANUAL )'
XANO := Str( Year( DXDIA ), 4 )
@  4, 1   SAY IMPCHR( cIMPTIT )
@  4, 30  SAY MMES + '/' + XANO
@  5, 120 SAY 'FL. '
@  5, 125 SAY FL              PICT '##'
@  5, 100 SAY 'DATA =>'
@  5, 108 SAY DXDIA
// * DADOS DO FUNCIONARIO
@ PRow() + 1, 0 SAY REPL( '-', 132 )
@ PRow() + 1, 1 SAY 'DEPTO'
@ PRow(), 8   SAY 'SETOR'
@ PRow(), 15   SAY 'SECAO'
@ PRow(), 59   SAY 'CHAPA'
@ PRow(), 65   SAY 'N. Reg'
@ PRow(), 73   SAY 'NOME FUNCIONARIO'
@ PRow(), 105  SAY 'ORDEM'
@ PRow() + 1, 2 SAY DEPTO
@ PRow(), 9   SAY SETOR
@ PRow(), 16   SAY SECAO
DDEM := DEPTO * 1000000 + SETOR * 1000 + SECAO
dbSelectAr( "DEPTO" )
dbGoTop()
IF dbSeek( DDEM )
@ PRow(), 20 SAY NOME
ELSE
@ PRow(), 20 SAY 'SECAO NAO CADASTRADA'
ENDIF
dbSelectAr( PES )
@ PRow(), 60  SAY CHAPA
@ PRow(), 66  SAY NUMERO
@ PRow(), 73  SAY NOME
@ PRow(), 107 SAY ORDEM
IF !Empty( DEMITIDO )
@ PRow(), 102 SAY 'D E M I T I D O'
@ PRow(), 102 SAY 'D E M I T I D O'
@ PRow(), 102 SAY 'D E M I T I D O'
ENDIF
@ PRow() + 1, 0 SAY REPL( '-', 132 )
@ PRow() + 1, 1 SAY IMPSTR( cIMPCOM )
@ PRow(), 1   SAY 'CONTA'
@ PRow(), 8   SAY 'Nome Conta '
FOR X := 1 TO 12
COL := 24 + ( X * 14 )
@ PRow(), COL SAY MMES( X )
NEXT X
@ PRow(), 208 SAY 'Total   Ano'
ENDIF
dbSelectAr( RES )
ENDDO
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
IMPEND()
RETU
// : FIM: FOLIS_C5.PRG

// + EOF: folis_c5.prg
// +
