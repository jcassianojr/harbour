// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7g.prg
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
// :       FO7G.PRG : Ficha de Salario Familia
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 22/10/97     11:25
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

IF !MDG( "Voce ja  checou as Baixas" )
RETU .F.
ENDIF
IF !MDL( 'Ficha Salario Familia', 0 )
RETU .F.
ENDIF


IF !NETUSE( pes )
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

IF !NETUSE( "FOSFAM" )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "STR(NUMERO,8)+DTOS(NASCTO)" )
ordSetFocus( "temp" )

IMPRESSORA()
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
lCAB := .T.
VIDEO()
PETELA( 8 )
IMPRESSORA()
mNUMERO   := NUMERO
mNOME     := NOME
mCTPS     := IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF )   // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
nORD      := 1
mADMITIDO := ADMITIDO
dbSelectAr( "FOSFAM" )
dbGoTop()
dbSeek( Str( mNUMERO, 8 ) )
WHILE mNUMERO = NUMERO .AND. !Eof()
IF Empty( FOSFAM->BAIXA ) .OR. FOSFAM->SALFAM = 'S'
IF lCAB
lCAB := .F.
@  0, 0   SAY IF( IM1 = 'A', IMPstr( Cimpcom ), impstr( Cimpexp ) )
@  0, 40  SAY IMPCHR( 14 ) + "FICHA DE SALARIO FAMILIA"
@  2, 0   SAY "Empresa: " + MSG2
@  2, 100 SAY "CGC: " + CGC1
@  3, 00  SAY "Endereco: " + ENDER1
@  4, 00  SAY "Bairro: " + AllTrim( BAI1 ) + " Cidade: " + AllTrim( CID1 ) + " Estado: " + AllTrim( EST1 )
@  5, 00  SAY "Nome do Empregado: " + mNOME
@  5, 90  SAY "No. CTPS: " + mCTPS
@  6, 00  SAY "Data de Admissao na Empresa: " + DToC( mADMITIDO )
@  6, 90  SAY "Data da Cessacao da Relacao de Emprego"
@  7, 20  SAY "FILHOS MENORES DE 14 ANOS - (Dados Extra¡dos das Certidoes)"
@  8, 00  SAY REPl( "-", 200 )
@  9, 0   SAY "Ord"
@  9, 4   SAY "Nome do Filho"
@  9, 44  SAY "Nascto"
@  9, 53  SAY "Local Nascto"
@  9, 89  SAY "Cartorio"
@  9, 105 SAY "No.Reg"
@  9, 116 SAY "Livro"
@  9, 122 SAY "Folha"
@  9, 128 SAY "D.Entr."
@  9, 137 SAY "D.Baixa"
@  9, 146 SAY "Visto Fiscalizacao"
ENDIF
@ PRow() + 1, 0 SAY nORD         PICT "99"
@ PRow(), 3   SAY NOME
@ PRow(), 44   SAY NASCTO
@ PRow(), 53   SAY LOCAL
@ PRow(), 89   SAY CARTORIO
@ PRow(), 105  SAY NREGIS
@ PRow(), 116  SAY LIVRO
@ PRow(), 122  SAY FOLHA
@ PRow(), 128  SAY ENTREGA
@ PRow(), 137  SAY BAIXA
@ PRow(), 146  SAY REPL( "_", 40 )
nORD++
ENDIF
dbSelectAr( "FOSFAM" )
dbSkip()
ENDDO
IF !lCAB   // /se fez cabecario tem rodape
@ 55, 0   SAY "Recebi os Documentos Acima"
@ 55, 50  SAY "Data da Rescisao"
@ 55, 100 SAY REPL( "_", 50 )
@ 56, 100 SAY "Assinatura"
IMPFOL()
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
VIDEO()
dbCloseAll()
IMPEND()
RETU .T.

// + EOF: fo7g.prg
// +
