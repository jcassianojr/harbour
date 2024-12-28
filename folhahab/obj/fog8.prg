// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fog8.prg
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
// :       FOG8.PRG: COMPENSACAO DE HORAS
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/18/94     11:44
// :
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"

IF !MDL( 'Imprimir compensa‡„o de Horas', 0 )
RETU
ENDIF
CTR    := 0
N      := cIMPNEG
M      := cIMPNER
TITULO := SPAC( 60 )
MDS( 'Digite o prazo' )
@ 24, 20 GET TITULO
IF !READCUR()
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

IF !NETUSE( "FO_HOR" )
RETU
ENDIF

IMPRESSORA()
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
CTR := NUMERO
FOR X := 1 TO 2
@ PRow() + 2, 10 SAY ACENTO( 'ACORDO PARA COMPENSA€ŽO DE HORAS DE TRABALHO' )
@ PRow() + 2, 10 SAY ACENTO( cid1 + N + DToC( dxdia ) + M )
@ PRow() + 2, 0  SAY ACENTO( 'Pelo Presente acordo de compensa‡„o de horas firmado entre a firma' )
@ PRow() + 1, 0  SAY ACENTO( N + MSG2 + M )
@ PRow() + 1, 0  SAY ACENTO( 'sita: ' + N + ender1 + ' - ' + bai1 + ' - ' + AllTrim( cid1 ) + M + ' Estado ' + N + est1 + M )
@ PRow() + 1, 0  SAY ACENTO( 'e o seu empregado ' + N + NOME + M + ' abaixo assinado ' )
@ PRow() + 1, 0  SAY ACENTO( 'portador da Carteira Profissional No.: ' ) + N + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ), PROFIS ) + M + ' SERIE: ' + N + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, SubStr( TIRAOUT( CPF ), 8 ), SERIE ) + M + ' UF: ' + N + CTPSUF + M
@ PRow() + 1, 0  SAY ACENTO( 'fica convencionado, com base no que faculta a legislacao, que   o' )
@ PRow() + 1, 0  SAY ACENTO( 'hor rio normal de trabalho ser  o seguinte' )
dbSelectAr( "FO_HOR" )
dbGoTop()
IF dbSeek( CTR )
@ PRow() + 2, 0 SAY ACENTO( 'Segunda: ' + N + d1 + M )
@ PRow() + 1, 0 SAY ACENTO( 'Terca  : ' + N + d2 + M )
@ PRow() + 1, 0 SAY ACENTO( 'Quarta : ' + N + d3 + M )
@ PRow() + 1, 0 SAY ACENTO( 'Quinta : ' + N + d4 + M )
@ PRow() + 1, 0 SAY ACENTO( 'Sexta  : ' + N + d5 + M )
@ PRow() + 1, 0 SAY ACENTO( 'Sabado : ' + N + d6 + M )
@ PRow() + 1, 0 SAY ACENTO( 'Domingo: ' + N + d7 + M )
ENDIF
dbSelectAr( PES )
@ PRow() + 2, 0 SAY ACENTO( 'Perfazendo um total de ' + N + Str( HRSEM ) + M + '________ horas semanais' )
@ PRow() + 2, 0 SAY ACENTO( 'E  por  estarem de pleno acordo, as partes contratantes' )
@ PRow() + 1, 0 SAY ACENTO( 'assinam o presente acordo em duas vias, o qual vigorar ' )
@ PRow() + 1, 0 SAY ACENTO( 'ate ' + TITULO )
@ PRow() + 2, 0 SAY 'Empregador : _____________________________________'
@ PRow() + 2, 0 SAY 'Empregado  : _____________________________________'
IF X = 1
@ PRow() + 2, 0 SAY REPL( '-', 80 )
ENDIF
NEXT X
impfol()
dbSkip()
ENDDO
dbCloseAll()
VIDEO()
IMPEND()
RETU

// : FIM: FOG8.PRG

// + EOF: fog8.prg
// +
