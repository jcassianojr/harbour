// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod2enc.prg
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
// :    FOD2ENC.PRG: Calculando Conta de Encargos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:50
// :
// :*****************************************************************************
#include "BOX.CH"

CABEX( 'Calculando Conta de Encargos' )
XA := XB := XC := XD := XE := XF := 1
DECLARE BUSX[ 5 ]
BUSX[ 1 ] = 420
BUSX[ 2 ] = 422
BUSX[ 3 ] = 434
BUSX[ 4 ] = 0
BUSX[ 5 ] = 0
ENC := 0

FPAS1 := OBTER( "FIRMA",, NREMP, "FPAS" )

IF !VERSEHA( "CONFINSS",, Val( FPAS1 ),, 'COdigo FPAS INEXISTENTE', .F., { { "EMPRESA+TOTAL+ACIDENTE", "ENC" } } )
RETU .F.
ENDIF
hb_DispBox( 7, 0, 21, 79, B_DOUBLE + " " )
@  9, 3  SAY "Contas Referencias:" + SPAC( 9 ) + "Fator de Encargos:" + SPAC( 8 ) + "Conta Destino:"
@ 11, 3  SAY "01 -" + Chr( 16 ) + SPAC( 7 ) + REPL( '-', 6 ) + "+"
@ 12, 21 SAY "Ý"
@ 13, 3  SAY "02 -" + Chr( 16 ) + SPAC( 7 ) + REPL( '-', 6 ) + "Ý"
@ 14, 21 SAY "Ý"
@ 15, 3  SAY "03 -" + Chr( 16 ) + SPAC( 7 ) + REPL( '-', 6 ) + "Ý     x" + SPAC( 25 ) + "=" + SPAC( 8 ) + "439"
@ 16, 21 SAY "Ý"
@ 17, 3  SAY "04 -" + Chr( 16 ) + SPAC( 7 ) + REPL( '-', 6 ) + "Ý"
@ 18, 21 SAY "Ý"
@ 19, 3  SAY "05 -" + Chr( 16 ) + SPAC( 7 ) + REPL( '-', 6 ) + "+"
@ 11, 9  GET BUSX[ 1 ]                                                                     PICT "###"
@ 13, 9  GET BUSX[ 2 ]                                                                     PICT "###"
@ 15, 9  GET BUSX[ 3 ]                                                                     PICT "###"
@ 17, 9  GET BUSX[ 4 ]                                                                     PICT "###"
@ 19, 9  GET BUSX[ 5 ]                                                                     PICT "###"
@ 15, 36 GET ENC                                                                         PICTURE "#####.#####"
READCUR()

IF !NETUSE( PES )
RETU
ENDIF
IF nFOLTIP = 1
IF !NETUSE( FOL )
RETU
ENDIF
ELSE
IF !NETUSE( "FO_COMP" )
RETU
ENDIF
ENDIF
cSELE2 := Alias()
IF !NETUSE( "CONTAS" )
RETU
ENDIF


dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
CTR  := NUMERO
VALE := 0
dbSelectAr( cSELE2 )
FOR X := 1 TO 5
IF BUSX[ X ] # 0
VALE := VALE + VALCTA( CTR, BUSX[ X ] )
ENDIF
NEXT X
IF VALE > 0
VALE := VALE * ENC / 100
dbSelectAr( cSELE2 )
GRAVA2( 439 )
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()

// : FIM: FOD2ENC.PRG

// + EOF: fod2enc.prg
// +
