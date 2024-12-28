// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_18.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


CABE2( 'FOPTO_18 - Criando Arquivo TXT Com Base Arquivo Reserva' )

ntipo := PEGRELOGIO()

cDD := TARQREL( nTIPO, .F. )

IF !REDEFILE( cDD, "DBF", .T. )
RETU .F.
ENDIF

TIPC := pegarqcon( nTIPO, "PRO" )

FO21CRI( cDD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )

IF !NETUSE( cDD )
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
cTXT += ".TXT"
IF TIPC = "S"
COPY TO &cTXT. SDF WHILE zei_fort( nLASTREC,,, 1 )
ENDIF
IF TIPC = "D"
COPY TO &cTXT. DELI WHILE zei_fort( nLASTREC,,, 1 )
ENDIF
dbCloseAll()


// + EOF: fopto_18.prg
// +
