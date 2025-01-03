// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3h.prg  Passagens Funcionario/Hora por dia
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

function fopto_3h()
IF !MDL( 'FOPTO_3H - Passagens Funcionario/Hora por dia' )
RETU
ENDIF
CTLIN := 80
cPA   := PARQDIO()

IF !NETUSE( "FIRMA" )
RETU
ENDIF
dbGoTop()
dbSeek( NREMP )


IF !NETUSE( PES )
dbCloseAll()
RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
FILTRO := FILTRO( FILTRO )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF


// sele 3
IF !NETUSE( cPA )
dbCloseAll()
RETU
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "DATA" )
ordSetFocus( "temp" )


IMPRESSORA()
dbSelectAr( cPA )   // sele 3
dbGoTop()
WHILE !Eof()
REF := 0
dbSelectAr( cPA )
mDATA := DATA
WHILE mDATA = DATA .AND. !Eof()
IF CTLIN > 55
dbSelectAr( "FIRMA" )
@  0, 0  SAY repl( '=', 79 )
@  1, 0  SAY "FOLHA DE PONTO - " + AllTrim( RAZAO )
@  1, 56 SAY "CGC:" + CGC
@  2, 0  SAY "End: " + ENDERECO + " - " + BAIRRO + " - " + CIDADE + " - " + ESTADO
@  3, 0  SAY "Funcionario"
@  3, 50 SAY "Hora"
@  4, 0  SAY repl( '-', 79 )
CTLIN := 5
dbSelectAr( cPA )
ENDIF
mNUMERO := NUMERO
mHORA   := HORA
dbSelectAr( PES )
dbGoTop()
dbSeek( mNUMERO )
IF Found()
@ CTLIN, 0  SAY mNUMERO
@ CTLIN, 10 SAY NOME
@ CTLIN, 50 SAY mHORA
CTLIN++
dbSelectAr( cPA )
REF++
ENDIF
dbSelectAr( cPA )
dbSkip()
ENDDO
IF REF > 0
@ CTLIN, 0 SAY repl( '-', 79 )
CTLIN++
@ CTLIN, 00 SAY "Total Dia:"
@ CTLIN, 12 SAY mDATA
@ CTLIN, 50 SAY Str( REF )
CTLIN++
@ CTLIN, 0 SAY repl( '=', 79 )
CTLIN++
ENDIF
ENDDO
IF CTLIN # 80
IMPFOL()
ENDIF
dbCloseAll()
IMPEND()
RETU


// + EOF: fopto_3h.prg
// +
