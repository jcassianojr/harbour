// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_11.prg Transferindo e Atualizando dados do Relogio
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

function fopto_11()
CABE2( 'FOPTO_11 - Transferindo e Atualizando dados do Relogio' )
PARA nTIPO, lPER
IF ValType( lPER ) # "L"
lPER := .T.
ENDIF
IF nTIPO = 0
nTIPO := PEGRELOGIO()
ENDIF

IF !NETUSE( "foptorel" )
RETU .F.
ENDIF
dbGoTop()
IF !dbSeek( ntipo )
dbCloseAll()
ALERTX( "falta configuracao relogio " + Str( ntipo ) )
RETU .F.
ENDIF
cCAMINHO := AllTrim( caminho )
DADO     := AllTrim( ARQUIVO )
cARQ     := AllTrim( ARQDEST )
TIPC     := PROCESSO
lDIVIDE  := if( HORADEC = "S", .T., .F. )
TIPD     := ANOREL
dbCloseAll()


DCORTE := zdataini
DCORTF := zdatafim
MDS( 'Digite o periodo ' )
@ 24, 40 GET DCORTE
@ 24, 60 GET DCORTF
IF !READCUR()
RETU .F.
ENDIF

MDS( 'Aguarde Carregando Dados do Rel¢gio' )
cPD := PARQDIO( nTIPO )
// if ! lPER .OR. MDG( "Apagar Importa‡ao Anterior" )
// DELETEFILE( ZDIRE + cPD + ".DBF" )
// DELETEFILE( ZDIRE + cPD + "." + cRDDEXT )
// endif

CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )

IF !File( cARQ + ".DBF" )
ALERTX( "Falta arquivo de migracao" )
RETURN
ENDIF

IF !NETUSE( cARQ,,,,, .F., )
dbCloseAll()
RETURN
ENDIF
ZAP
IF !FOPTO1101( DADO )
dbCloseAll()
RETURN
ENDIF

nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| Empty( DATA ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| Empty( NUMERO ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| Empty( HORA ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
netpack( cARQ )




IF !NETUSE( cARQ,,,,, .F., )
dbCloseAll()
RETU .F.
ENDIF

IF !netuse( cPD )
dbCloseAll()
RETU
ENDIF


MDS( 'Aguarde Atualizando Dados do Relogio' )
dbSelectAr( cARQ )
GRAPP := 1
GRAPT := LastRec()
GRAPT( 'AGUARDE ATUALIZANDO DADOS ' )
dbGoTop()
WHILE !Eof()
NUM := NUMERO
DAT := DATA
HOR := HORA
IF ValType( DATA ) = "N"
IF TIPD = "3" .OR. TIPD = "4"
DIC := StrZero( DAT, 8 )
ELSE
DIC := Str( DAT, 6 )
ENDIF
ENDIF
DO CASE
CASE TIPD = "1"
DIAX := SubStr( DIC, 1, 2 )
nMES := SubStr( DIC, 3, 2 )
ANO  := SubStr( DIC, 5, 2 )
CASE TIPD = "2"
ANO  := SubStr( DIC, 1, 2 )
nMES := SubStr( DIC, 3, 2 )
DIAX := SubStr( DIC, 5, 2 )
CASE TIPD = "3"
DIAX := SubStr( DIC, 1, 2 )
nMES := SubStr( DIC, 3, 2 )
ANO  := SubStr( DIC, 5, 4 )
DAT  := diax + nmes + SubStr( DIC, 7, 2 )
DAT  := Val( DAT )
CASE TIPD = "4"
ANO  := SubStr( DIC, 1, 4 )
nMES := SubStr( DIC, 5, 2 )
DIAX := SubStr( DIC, 7, 2 )
DAT  := diax + nmes + SubStr( DIC, 3, 2 )
DAT  := Val( DAT )
ENDCASE
DIX := CToD( DIAX + "/" + nMES + "/" + ANO )
IF lDIVIDE
HOR /= 100
ENDIF
IF HOR < 1
HOR += 24
DIX--
ENDIF
BUSCA := Str( NUM, 8 ) + DToS( DIX ) + Str( HORA, 5, 2 )
IF DIX >= DCORTE .AND. DIX <= DCORTF
IF !Empty( DIX ) .AND. !Empty( NUM ) .AND. !Empty( HOR )
dbSelectAr( cPD )
dbGoTop()
IF !dbSeek( BUSCA )
netrecapp()
field->NUMERO := NUM
field->HORA   := HOR
field->DATA   := DIX
dbUnlock()
ENDIF
ENDIF
ENDIF
dbSelectAr( cARQ )
GRAPS()
dbSkip()
ENDDO
dbCloseAll()


IF nTIPO = 1 .OR. nTIPO = 4 .OR. nTIPO = 5
trocapro( cpd, dcorte, dcortf )
IF lPER
IF MDG( "Deseja Transferir Dados Ponto do Mes" )
FOPTO_12()
ENDIF
ELSE
FOPTO_12( DCORTE, DCORTF )
ENDIF
ENDIF
RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO1101()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO1101( cORI )

   IF At( ".", cORI ) = 0
      cORI += ".TXT"
   ENDIF
   IF !hb_FileExists( cORI )
      ALERTX( "Falta Arquivo: " + cORI )
      RETU .F.
   ENDIF
   nLASTREC := FLINECOUNT( cORI )
   zei_fort( nLASTREC,,, 0 )
   DO CASE
   CASE TIPC = "D"
      APPEND FROM &cORI. DELIMITED WHILE zei_fort( nLASTREC,,, 1 )
   CASE TIPC = "S"
      APPEND FROM &cORI. SDF WHILE zei_fort( nLASTREC,,, 1 )
   ENDCASE

   RETURN .T.




// + EOF: fopto_11.prg
// +
