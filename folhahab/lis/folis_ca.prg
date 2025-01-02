// +--------------------------------------------------------------------
// +
// +    Programa  : folis_ca.prg Listar Resumo Rais Empresa
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

function folis_ca()
IF !MDL( 'Listar RAIS Resumo Empresa', 0 )
RETU
ENDIF
CTLIN := 80

IF !NETUSE( arquso )
dbCloseAll()
RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD( .T. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ValType( INX ) = "N"
dbSetOrder( INX )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )
ENDIF
SET FILTER TO &FILTRO


IMPRESSORA()
dbGoTop()
WHILE !Eof()
IF CTLIN > 55
CTLIN := 1
@ CTLIN, 1 SAY "- E S T A B E L E C I M E N T O " + Replicate( "-", 47 )
ENDIF
CTLIN += 2
@ CTLIN, 3 SAY "Inscricao    : " + CGC
CTLIN++
@ CTLIN, 3 SAY "Razao Social : " + RAZAO
CTLIN++
@ CTLIN, 3 SAY "Endereco     : " + ENDERECO
CTLIN++
@ CTLIN, 3  SAY "Bairro       : " + BAIRRO
@ CTLIN, 53 SAY "Cod Municipio: " + CODIBGE
CTLIN++
@ CTLIN, 3  SAY "Municipio    : " + CIDADE
@ CTLIN, 53 SAY "CEP: " + CEP + "  UF: " + ESTADO
CTLIN++
@ CTLIN, 3  SAY "Ativ. Econom.: " + ATIVIDADE
@ CTLIN, 25 SAY "Nat. Estabelecimento  : " + NAT_ESTAB
@ CTLIN, 53 SAY "Nro. Proprietarios: " + Str( NR_SOCIOS )
CTLIN++
@ CTLIN, 3  SAY "Alt. CGC/CEI : " + ALTINS
@ CTLIN, 25 SAY "Causa: " + TIPINS
@ CTLIN, 35 SAY "Alt.Endereco:  " + ALTEND
@ CTLIN, 53 SAY "Ind. Rais Negativa:  " + RAISNEG
CTLIN++
@ CTLIN, 3  SAY "Inscr. Ant.  : " + CGCANT
@ CTLIN, 53 SAY "Data Base " + StrZero( DBASE )
CTLIN++
@ CTLIN, 00 SAY REPL( "-", 80 )
CTLIN++
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()
RETUrn .T.

// + EOF: folis_ca.prg
// +
