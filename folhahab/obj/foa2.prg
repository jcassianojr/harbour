// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa2.prg
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

#include "BOX.CH"

CABEX( 'Entrada de Dados Para Folha' )
PARA CX, CY

OPCAO1 := 'S'
XA     := XB := XC := XD := XE := XF := CTR := CTCONTA := 0

CW := if( MDG( 'Deseja Confirmar os Valores' ), 1, 0 )

IF !NETUSE( PES )
dbCloseAll()
RETU .F.
ENDIF
FILTRO := "EMPTY(DEMITIDO)"   // .AND.(EMPTY(SITUACAO).OR.SITUACAO='P')"
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO

IF !ARQUSAR( CX )
dbCloseAll()
RETU .F.
ENDIF
cSELE2 := Alias()


IF !NETUSE( "CONTAS" )
dbCloseAll()
RETU .F.
ENDIF

IF CY = 1
CC := PEGRELCTA( "" )
X  := 0
ENDIF

WHILE OPCAO1 = 'S'
@ 07, 00 clea
IF CY = 0
MDS( 'NUMERO DA CONTA ------->' )
@ 24, 57 GET CTCONTA PICT '#####'
READCUR()
ENDIF
IF CY = 1
X++
IF X = 16
OPCAO1 := 'N'
LOOP
ENDIF
CTCONTA := CC[ X ]
IF CTCONTA = 0
OPCAO1 := 'N'
LOOP
ENDIF
ENDIF
// ** (LOCALIZANDO A CONTA )
dbSelectAr( "CONTAS" )
dbGoTop()
IF dbSeek( CTCONTA )
IF ACEITE # "S" .OR. ZUSER = "SUPERVISOR"
HORA := VALE := 0
XB   := TIPO
hb_DispBox( 12, 8, 16, 71, B_DOUBLE + " " )
@ 12, 16 SAY "-" + repl( '-', 37 ) + "-"
@ 16, 16 SAY "-" + repl( '-', 37 ) + "-"
@ 13, 10 SAY "Conta Ý Descrimina‡„o" + spac( 23 ) + "Ý Valor/Horas"
@ 14, 08 SAY 'Ç' + repl( '-', 7 ) + "+" + repl( '-', 37 ) + "+" + repl( '-', 16 ) + '¶'
@ 15, 16 SAY "Ý" + spac( 37 ) + "Ý"
@ 15, 11 SAY CODIGO                                                PICTURE "###"
@ 15, 18 SAY DESCR
IF XB = 1 .OR. XB = 3 .OR. XB = 4
@ 15, 56 GET HORA PICT '###.##'
ELSE
@ 15, 56 GET VALE PICT '###,###,###.##'
ENDIF
READCUR()
IF VALE # 0 .OR. HORA # 0
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 7 )
IF !Empty( SITUACAO )
ALERTX( SITUACAO + '-' + CHECKTAB( "SITU" + SITUACAO,,, "Situacao nao Cadastrado", 2 ) )
ENDIF
CTR := NUMERO
IF CW = 1 .OR. !Empty( SITUACAO )
dbSelectAr( cSELE2 )
VALE := VALCTA( CTR, CTCONTA )
HORA := if( Found(), HORAS, 0 )
IF XB = 1 .OR. XB = 3 .OR. XB = 4
@ 15, 56 GET HORA PICT '###.##'
READCUR()
ELSE
@ 15, 56 GET VALE PICT '###,###,###.##'
READCUR()
ENDIF
ENDIF
GRAVA2( CTCONTA )
IF XB = 1 .OR. XB = 3 .OR. XB = 4
field->HORAS := HORA
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
ENDIF
ELSE
ALERTX( "Inclus„o desta Conta Permitida Somente para o Supervisor" )
ENDIF
ELSE
ALERTX( "Conta n„o Cadastrada" )
ENDIF
IF CY = 0
@  7, 00 clear
MDS( 'Deseja Continuar (S/N)=>' )
@ 24, 57 GET OPCAO1
READCUR()
ENDIF
ENDDO
dbSelectAr( cSELE2 )
FODZER()
dbCloseAll()
RETU


// + EOF: foa2.prg
// +
