// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa9.prg
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
// :       FOA9.PRG: Transferindo o Descontos do Vale-Transporte para Folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:31
// :
// :*****************************************************************************



CABEX( 'Transferir Vale-Transporte para Folha' )
IF !MDG( 'Deseja continuar (S/N)' )
RETU
ENDIF
PERCENTUAL := 6
aCONTA     := { 0, 0, 530, 443 }
@ 10, 00 SAY "Percentual M ximo de Desconto"
@ 11, 00 SAY "Conta Total"
@ 12, 00 SAY "Valor Percentual"
@ 13, 00 SAY "Desconto Funcionario"
@ 14, 00 SAY "Encargo Empresa Liquido"
@ 10, 30 GET PERCENTUAL                      PICT "99.99"
@ 11, 30 GET aCONTA[ 1 ]
@ 12, 30 GET aCONTA[ 2 ]
@ 13, 30 GET aCONTA[ 3 ]
@ 14, 30 GET aCONTA[ 4 ]
IF !READCUR()
RETU .F.
ENDIF
// IF ! AREDEM({{PES,PES,1},{FOL,FOL,0},{"VTFOLHA","VTFOLHA",1}})
// RETU .F.
// ENDIF
IF !netuse( pes )
RETU
ENDIF

IF !netuse( fol )
dbCloseAll()
RETU
ENDIF

IF !netuse( "VTFOLHA" )
dbCloseAll()
RETU
ENDIF




dbSelectAr( PES )
FILTRO := FILTRO( '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))' )
SET FILTER TO &FILTRO

XA := XB := XC := XD := XE := XF := 0
MDS( 'Aguarde Fazendo as transferˆncias' )
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 7 )
CTR  := NUMERO
SALH := SALM := VAR1 := 0
aVAL := { 0, 0, 0, 0 }
SALHM()
aVAL[ 2 ] = Round( SALH * MESHORA * PERCENTUAL / 100, 2 )
dbSelectAr( "VTFOLHA" )
FILTRA := 'NUMERO=CTR'
SET FILTER TO &FILTRA
dbGoTop()
WHILE !Eof()
aVAL[ 1 ] += VALOR
dbSkip()
ENDDO
SET FILTER TO
aVAL[ 3 ] := IF( aVAL[ 1 ] >= aVAL[ 2 ], aVAL[ 2 ], aVAL[ 1 ] )
aVAL[ 4 ] := aVAL[ 1 ] - aVAL[ 3 ]
FOR X := 1 TO 4
IF aCONTA[ X ] > 0
VALE := aVAL[ X ]
dbSelectAr( fol )
GRAVA2( aCONTA[ X ] )
ENDIF
NEXT X
dbSelectAr( PES )
dbSkip()
ENDDO
dbSelectAr( FOL )
FODZER()
dbCloseAll()
RETU .T.

// : FIM: FOA9.PRG

// + EOF: foa9.prg
// +
