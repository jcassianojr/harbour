// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3a.prg Escala de Revezamento
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


function fopto_3a()
IF !MDL( 'FOPTO_3A - Escala de Revezamento' )
RETU
ENDIF

PAG  := 1
DIAX := Date()
cPE  := "PE" + ANOMESW



IF !NETUSE( "FO_RELHR" )
dbCloseAll()
RETU .F.
ENDIF


IF !NETUSE( cPE )
dbCloseAll()
RETU .F.
ENDIF

FILTRO := ''
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO



IMPRESSORA()
dbSelectAr( "FO_RELHR" )
dbGoTop()
WHILE !Eof()
IF HFOL00 = "S" .AND. !Empty( GRUPO )
xGRUPO := GRUPO
CABEC( 'Escala de Revezamento', '',, "Grupo Data       Horario Entrada Refeitorio  Saida" )
@ PRow() + 1, 0 SAY NUMERO
@ PRow(), 10   SAY NOME
@ PRow() + 1, 0 SAY REPL( "=", 80 )
dbSelectAr( cPE )
dbGoTop()
dbSeek( xGRUPO )
WHILE xGRUPO = GRUPO .AND. !Eof()
@ PRow() + 1, 0 SAY GRUPO
@ PRow(), 03   SAY DATA
@ PRow(), 12   SAY TIRACE( CDIA( DATA ) )
@ PRow(), 20   SAY CODREV
DO CASE
CASE CODREV = "FO"
@ PRow(), 25 SAY "FOLGA"
CASE CODREV = "FE"
@ PRow(), 25 SAY "FERIADO"
CASE CODREV = "SA"
@ PRow(), 25 SAY "SABADO"
CASE CODREV = "DO"
@ PRow(), 25 SAY "DOMINGO"
OTHERWISE
@ PRow(), 23 SAY ENTREV
IF !Empty( ALIREV ) .AND. !Empty( ALSREV )
@ PRow(), 30 SAY ALIREV
@ PRow(), 37 SAY ALSREV
ENDIF
@ PRow(), 44 SAY SAIREV
ENDCASE
dbSkip()
ENDDO
IMPFOL()
ENDIF
dbSelectAr( "FO_RELHR" )
dbSkip()
ENDDO
dbCloseAll()
IMPEND()
return .t.


// + EOF: fopto_3a.prg
// +
