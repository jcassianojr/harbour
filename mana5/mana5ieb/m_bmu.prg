// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bmu.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_BMU.PRG
// +
// +    Reformatted by Click! 2.03 on Jul-30-2001 at 11:33 am
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"

MDI( " þ Resumo Duplicatas" )
IF !CHECKIMP( 0 )
RETU .F.
ENDIF

// Pegando o Filtro do Relatorio
FILTRO := ''
FILTRO := RFILORD( "MM01", .F. )
aGRU   := {}
aVAL   := {}

aRETU := PEGMES( { "M1" }, .T., { "MM01" } )
ARQNF := aRETU[ 5, 1 ]

IF !USEMULT( { { ARQNF, 1, 1 }, { "MD04", 1, 1 }, { "MA01", 1, 1 } } )
RETU .F.
ENDIF

CTLIN := 80
IMPRESSORA()
dbSelectAr( ARQNF )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
nREFNUM := 0
WHILE !Eof()
IF APURA # "N" .OR. CANCELADA = "S"
mCLIENTE  := FORNECEDO
mCGC      := ""
mGRUPO    := ""
mOPERACAO := Left( OPERACAO, 3 )
lREMESSA  := .F.
dbSelectAr( "MD04" )
dbGoTop()
IF dbSeek( mOPERACAO )
IF REMESSA = "S"
lREMESSA := .T.
ENDIF
ENDIF
dbSelectAr( "MA01" )
dbGoTop()
IF dbSeek( mCLIENTE )
mCGC   := CGC
mGRUPO := if( Empty( GRUPOEMP ), COGNOME, GRUPOEMP )
ENDIF
IF CTLIN > 50
@  1, 07 SAY impchr( cIMPTIT ) + "CONTROLE DE DUPLICATAS"
@  2, 08 SAY "Data     Numero      Valor" + spac( 6 ) + "Cliente" + spac( 30 ) + "Vencto.|Banco"
@  3, 07 SAY "|" + repl( "_", 98 ) + "|"
CTLIN := 4
ENDIF
dbSelectAr( ARQNF )
DO CASE
CASE CANCELADA = "S"
@ CTLIN, 16  SAY NUMERO      PICTURE '999999'
@ CTLIN, 27  SAY "CANCELADA"
@ CTLIN, 100 SAY "|"
CTLIN++
@ CTLIN, 07 SAY "|" + repl( "_", 98 ) + "|"
CTLIN++
CASE lREMESSA
@ CTLIN, 07  SAY "|" + DToC( DATA ) + "|"
@ CTLIN, 16  SAY NUMERO                PICTURE '999999'
@ CTLIN, 29  SAY "REMESSA"
@ CTLIN, 36  SAY "|" + Str( FORNECEDO, 5 )
@ CTLIN, 43  SAY COGNOME + " " + mCGC + " |"
@ CTLIN, 100 SAY "|"
CTLIN++
@ CTLIN, 07 SAY "|" + repl( "_", 98 ) + "|"
CTLIN++
OTHERWISE
aDATAS := { DAT01, DAT02, DAT03, DAT04, DAT05, ;
               DAT06, DAT07, DAT08, DAT09, DAT10 }
aVALOR := { VAL01, VAL02, VAL03, VAL04, VAL05, ;
               VAL06, VAL07, VAL08, VAL09, VAL10 }
FOR W := 1 TO 10
IF !Empty( aDATAS[ W ] )
mTIPFAT := IMPCHR( 64 + W )  // Tipo do Faturamento (A,B,C...)
IF W = 1 .AND. Empty( aDATAS[ 2 ] )  // Somente um vencimento
mTIPFAT := " "
ENDIF
IF CTLIN > 50
@  1, 07 SAY impchr( cIMPTIT ) + "CONTROLE DE DUPLICATAS"
@  2, 08 SAY "Data     Numero      Valor" + spac( 6 ) + "Cliente" + spac( 30 ) + "Vencto.|Banco"
@  3, 07 SAY "|" + repl( "_", 98 ) + "|"
CTLIN := 4
ENDIF
SET CENTURY ON
@ CTLIN, 07 SAY "|" + DToC( DATA ) + "|"
SET CENTURY OFF
@ CTLIN, 19  SAY Str( NUMERO, 6 )
@ CTLIN, 26  SAY mTIPFAT
@ CTLIN, 28  SAY aVALOR[ W ]             PICTURE '@E 999,999.99'
@ CTLIN, 39  SAY "|" + Str( FORNECEDO, 5 )
@ CTLIN, 46  SAY COGNOME + " " + mCGC + " |"
@ CTLIN, 79  SAY DToC( aDATAS[ W ] ) + "|"
@ CTLIN, 100 SAY "|"
CTLIN++
@ CTLIN, 07 SAY "|" + repl( "_", 98 ) + "|"
CTLIN++
nPOS := AScan( aGRU, mGRUPO )
IF nPOS > 0
aVAL[ nPOS, 1 ] += aVALOR[ W ]
aVAL[ nPOS, 2 ]++
ELSE
AAdd( aGRU, mGRUPO )
AAdd( aVAL, { aVALOR[ W ], 1 } )
ENDIF
ENDIF
NEXT W
ENDCASE
ENDIF
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
@  0, 0  SAY "Resumo"
@  1, 0  SAY "Grupo"
@  1, 12 SAY "Valor"
@  1, 27 SAY "No.Tit"
@  2, 0  SAY repl( "-", 80 )
CTLIN := 3
FOR W := 1 TO Len( aGRU )
@ CTLIN, 0  SAY aGRU[ W ]
@ CTLIN, 12 SAY aVAL[ W, 1 ] PICTURE '@E 999,999,999.99'
@ CTLIN, 30 SAY aVAL[ W, 2 ] PICT "9999"
CTLIN++
CTLIN++
NEXT W
IMPFOL()
VIDEO()
IMPEND()

// + EOF: M_BMU.PRG

// + EOF: m_bmu.prg
// +
