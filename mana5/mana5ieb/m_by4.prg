// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_by4.prg
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

// +께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께
// +
// +    Source Module => J:\ITAESBRA\M_BY4.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께

// #INCLUDE "COMANDO.CH"
MDI( " Historico do Estoque " )
cTIPO := "S"
@ 22, 00 SAY "(P)roduto (M)at.Prima (C)omponentes (S)ub Produto (O)outros/Consumiveis"
@ 23, 00 SAY "Horas (E)Equipamento (H)omem (T)erceiros"
@ 24, 40 GET cTIPO                                                                     VALID cTIPO $ "SPCMOT" PICT "!"
IF !READCUR()
RETU .F.
ENDIF
lFEC := .F.
IF MDG( "M늮 Fechado" )
cFEC := MESANO()
lFEC := .T.
ENDIF
cARQ  := ESTQARQ( cTIPO, if( lFEC, 2, 0 ) )
cARQ2 := ESTQARQ( cTIPO, 1 )

FILTRO := ''
FILTRO := RFILORD( cARQ2, .F. )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cAE := IMP( "AE" )
// cAE := IMP( "AE" )
// cAC := IMP( "AC" )
cAE := aCHR[ 2 ]
cAC := aCHR[ 1 ]


IF !USEMULT( { { cARQ2, 1, 1 }, { cARQ, 1, 2 } } )
RETU .F.
ENDIF

IMPRESSORA()
dbSelectAr( cARQ2 )
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
CTLIN      := 80
mCODIGO    := CODIGO
mNOME      := NOME
mAPLICACAO := ""
nENT       := nSAI := nULT := 0
IF cTIPO $ "TCS"
mAPLICACAO := APLICACAO
ENDIF
dbSelectAr( cARQ )
dbGoTop()
dbSeek( AllTrim( mCODIGO ) )
WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
IF CTLIN > 50
@  0, 0  SAY cAE + "Historico da Movimentacao"
@  1, 0  SAY "M_BY4"
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
@  2, 0  SAY cAE + mCODIGO + " " + mNOME
IF !Empty( mAPLICACAO )
@  3, 00 SAY "Aplicacao: " + mAPLICACAO
ENDIF
@  4, 0  SAY "Codigo"
@  4, 25 SAY "Numero"
@  4, 34 SAY "Data"
@  4, 43 SAY "Rastro"
@  4, 50 SAY "Anterior"
@  4, 63 SAY "Entrada"
@  4, 76 SAY "Saida"
@  4, 89 SAY "Atual"
@  5, 00 SAY repl( "-", 100 )
CTLIN := 6
ENDIF
@ CTLIN, 0  SAY Codigo
@ CTLIN, 25 SAY Numero
@ CTLIN, 34 SAY DATA
@ CTLIN, 43 SAY Rastro
@ CTLIN, 50 SAY ESTQXXX PICT "9999999"
IF ESTQYYY > ESTQXXX
@ CTLIN, 63 SAY QTDE PICT "9999999"
nENT += QTDE
ENDIF
IF ESTQYYY < ESTQXXX
@ CTLIN, 76 SAY QTDE PICT "9999999"
nSAI += QTDE
ENDIF
@ CTLIN, 89 SAY ESTQYYY PICT "9999999"
nULT := ESTQYYY
CTLIN++
dbSkip()
ENDDO
IF nENT > 0 .OR. nSAI > 0
@ CTLIN, 0  SAY "Total"
@ CTLIN, 63 SAY nENT    PICT "9999999"
@ CTLIN, 76 SAY nSAI    PICT "9999999"
@ CTLIN, 89 SAY nULT    PICT "9999999"
ENDIF
dbSelectAr( cARQ2 )
dbSkip()
ENDDO
VIDEO()
dbCloseAll()
IMPEND()

// + EOF: M_BY4.PRG

// + EOF: m_by4.prg
// +
