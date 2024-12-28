// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_21.prg
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



// Carnaval      CalcPascoa(aaaa)- 47
// QuartaCinzas  CalcPascoa(aaaa)- 46
// SextaSanta    CalcPascoa(aaaa)- 2
// CorpusChristi CalcPascoa(aaaa)+ 60
// Pascoa        calcpascoa(aaaa)
// ConfrUniv     01/01/aaaa
// AnivSaoPaulo  25/01/aaaa
// Tiradentes    21/04/aaaa
// DiaTrabalho   01/05/aaaa
// IndepBrasil   07/09/aaaa
// NossaSra      12/10/aaaa
// Finados       02/11/aaaa
// ProcRepublica 15/11/aaaa
// Natal         25/12/aaaa

CABE2( 'FOPTO_21 - Iniciando o mEs' )


IF !MDG( 'Voce tem certeza' )
RETU .F.
ENDIF

// FO21CRI("PE","FOPTOREV", "GRUPO+DTOS(DATA)" ) //ja cria na fopto_43
fopto_43()

dINI := zdataini
dFIM := zdatafim
MDS( 'Digite o Periodo ' )
@ 24, 40 GET dINI
@ 24, 50 GET dFIM
IF !READCUR()
RETU .F.
ENDIF
nMES := Month( dFIM )
nANO := Year( dFIM )
MDS( 'Confirme a Competencia' )
@ 24, 40 GET nMES
@ 24, 50 GET nANO
IF !READCUR()
RETU .F.
ENDIF
cMESANO := SubStr( StrZero( nANO, 4 ), 3, 2 ) + StrZero( nMES, 2 )

// Serao Usados Arede
cPN := "PN" + cMESANO
cPE := "PE" + cMESANO


FO21CRI( "PN", "FO_PON", "STR(NUMERO,8)+DTOS(DATA)" )
FO21CRI( "PT", "FO_POT", "NUMERO" )
FO21CRI( "PD", "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI( "PA", "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI( "PP", "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI( "PO", "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )
FO21CRI( "PM", "FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )
FO21CRI( "PH", "FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )
FO21CRI( "PX", "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
FO21CRI( "PS", "FO_POS", "STR(NUMERO,8)+DTOS(SEMFIM)" )
FO21CRI( "BK", "BCOREQ", "REQUISI" )
FO21CRI( "BH", "BCOREQ", "REQUISI" )


// Pegando Eventos
aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()


// Feriados Moveis
FOR I := 1 TO 4
DO CASE
CASE I = 1
cTEXTO := "Carnaval"
nPASSO := -47
CASE I = 2
cTEXTO := "Sexta Santa"
nPASSO := -2
CASE I = 3
cTEXTO := "Corpus Christi"
nPASSO := 60
CASE I = 4
cTEXTO := "Pascoa"
nPASSO := 0
ENDCASE
dFERMOV := CalcPascoa( nANO ) + nPASSO
IF dFERMOV >= dINI .AND. dFERMOV <= dFIM
IF MDG( "Gravar Feriado " + cTEXTO )
@ 24, 00 SAY "Confirme data " + cTEXTO
@ 24, 30 GET dFERMOV
READCUR()
AAdd( aEVED, Str( Day( dFERMOV ), 2 ) + Str( Month( dFERMOV ), 2 ) )
AAdd( aEVEC, "FE" )
AAdd( aEVEB, { " ", " ", " " } )
ENDIF
ENDIF
NEXT X


IF !NETUSE( PES )
RETU
ENDIF

/*
FILTRO := "admitido>=ctod('01/08/2009')"
set filter to &FILTRO
dbgotop()
while ! eof()
    PETELA( 8 )
    VALPIS(PIS)
    dbskip()
enddo
*/

FILTRO := FILTRO( '(EMPTY(DEMITIDO).OR.DEMITIDO<=dfim).and.! empty(PIS)' )
SET FILTER TO &FILTRO
dbGoTop()

IF !netuse( cPN )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( "FO_RELHR" )
dbCloseAll()
RETU .T.
ENDIF

IF !NETUSE( "FOPTOHRE" )
dbCloseAll()
RETU .T.
ENDIF


IF !netuse( cPE )
dbCloseAll()
RETU
ENDIF

dbSelectAr( pes )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
VALPIS( PIS, .T., .F., FIELD->EVINC )
NUM     := NUMERO
mBANCO  := " "
mCODADC := "  "
nINI    := dINI


IF nINI < ADMITIDO   // Inicia A partir da data admiss?o
nINI := ADMITIDO
ENDIF
IF !Empty( DATTRANSF )   // Inicia a partir da data transferencia
IF nINI < DATTRANSF
nINI := DATTRANSF
ENDIF
ENDIF
nFIM := dFIM
IF !Empty( DEMITIDO )  // Encerra na data de demiss?o
IF DEMITIDO < nFIM
nFIM := DEMITIDO
ENDIF
ENDIF

aFOLGA   := {}
aNHOR    := {}
aREF     := {}
mGRUPO   := ""
mTURNO   := ""
mALMOCO  := ""
mMARMES  := ""
mHORREF  := ""
mHORARIO := 0
peghorfix( num )

IF mMARMES <> "N"
dbSelectAr( cPN )   // sele 2
FOR X := nINI TO nFIM
@ 24, 00 SAY "Data:" + DToC( x )
cCOD := " "
nEVE := AScan( aEVED, Str( Day( X ), 2 ) + Str( Month( X ), 2 ) )   // Checa Dia/Mes
IF nEVE = 0
nEVE := AScan( aEVED, Str( DoW( X ), 2 ) + Str( 0, 2 ) )   // Checa Dia da Semana
ENDIF
lFOLGA   := .F.
lDOMINGO := .F.
lSABADO  := .F.
lCODBH   := .F.
IF !Empty( mGRUPO ) .AND. mTURNO = "S"
dbSelectAr( cPE )
dbGoTop()
IF dbSeek( mGRUPO + DToS( X ) )
IF CODREV = "FO"
lFOLGA := .T.
ENDIF
IF CODREV = "DO"
lDOMINGO := .T.
ENDIF
IF CODREV = "SA"
lSABADO := .T.
ENDIF
IF CODREV = "BH"
lCODBH := .T.
ENDIF
mCODADC  := CODADC
mBANCO   := BCOSN
mHORARIO := HORARIO
ENDIF
ENDIF
IF !Empty( mHORREF ) .AND. mTURNO = "N"
nDOW := DoW( X )
IF aREF[ nDOW, 1 ] > 0
IF aFOLGA[ nDOW ] <> "S"   // Se nao for folga pega padrao
mHORARIO := aNHOR[ nDOW ]
ENDIF
ELSE
mHORARIO := aNHOR[ 8 ]
ENDIF
ENDIF
dbSelectAr( cPN )
dbGoTop()
IF !dbSeek( Str( NUM, 8 ) + DToS( X ) )
netrecapp()
field->NUMERO := NUM
field->DATA   := X
ELSE
netreclock()
ENDIF
IF Empty( COD )
IF nEVE > 0
IF Empty( mGRUPO ) .OR. mTURNO # "S" .OR. AEVEC[ nEVE ] = "FE"
IF AEVEC[ nEVE ] <> "DO" .AND. AEVEC[ nEVE ] <> "SA"
field->COD := AEVEC[ nEVE ]
ELSE
IF aFOLGA[ DoW( X ) ] = "S"  // so se for folga marca
field->COD := AEVEC[ nEVE ]   // Sabado e Domingo
ENDIF
ENDIF
ENDIF
IF AEVEB[ nEVE, 1 ] = "S"
field->BCOSN := "S"
ENDIF
IF AEVEB[ nEVE, 2 ] = "S"
field->REDSN := "S"
ENDIF
IF AEVEB[ nEVE, 3 ] = "S"
field->FOLSN := "S"
ENDIF
ELSE
field->ALMOCO := mALMOCO
ENDIF
IF lFOLGA
FOPTO21CS( "FO" )
field->FOLSN := "S"
ENDIF
IF lDOMINGO
FOPTO21CS( "DO" )
ENDIF
IF lSABADO
FOPTO21CS( "SA" )
ENDIF
IF lCODBH
FOPTO21CS( "BH" )
ENDIF
IF !Empty( mCODADC )
FOPTO21CS( mCODADC )
ENDIF
IF !Empty( mBANCO )
field->BCOSN := mBANCO
ENDIF
ENDIF
IF cod = "FE" .OR. Cod = "FO" .OR. COD = "SA" .OR. COD = "DO" .OR. COD = "BH"  // gravados acima pela fopot21cs
ELSE
field->HORARIO := mHORARIO
ENDIF
dbCommit()
dbUnlock()
NEXT X
ENDIF
dbSelectAr( pes )
dbSkip()
ENDDO
dbCloseAll()


FOY2( 0, "FOPTONTX", "E" )
pegcompete()

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO21CS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO21CS( cCOD )

   IF COD = "FE"
      field->SOD := "FE"
   ENDIF
   DO CASE
   CASE cCOD = "SA" .AND. DoW( DATA ) <> 7
      ALERTX( "Codigo SA sem ser sabado" )
   CASE cCOD = "DO" .AND. DoW( DATA ) <> 1
      ALERTX( " Codigo DO sem ser domingo" )
   CASE cCOD = "FE" .AND. AScan( aEVED, Str( Day( DATA ), 2 ) + Str( Month( DATA ), 2 ) ) = 0
      ALERTX( " Codigo FE sem feriado cadastrado " )
   OTHERWISE
      field->COD := cCOD
   ENDCASE
   IF cCOD = "SA"
   ELSE
      field->ALMOCO := " "
   ENDIF

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO21CRI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FO21CRI( cARQ, cREF, eCHAVE )

   cARQ := cARQ + cMESANO
   CHECKCRI( cARQ, cREF, eCHAVE )

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FT_EASTER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FT_EASTER( nYear )

   LOCAL nGold, nCent, nCorx, nCorz, nSunday, nEpact, nMoon, ;
      nMonth := 0, nDay := 0

   IF ValType( nYear ) == "C"
      nYear := Val( nYear )
   ENDIF

   IF ValType( nYear ) == "D"
      nYear := Year( nYear )
   ENDIF

   IF ValType( nYear ) == "N"
      IF nYear > 1582

         // <<nGold>> is Golden number of the year in the 19 year Metonic cycle
         nGold := nYear % 19 + 1

         // <<nCent>> is Century
         nCent := Int( nYear / 100 ) + 1

         // Corrections:
         // <<nCorx>> is the no. of years in which leap-year was dropped in order
         // to keep step with the sun
         nCorx := Int( ( 3 * nCent ) / 4 - 12 )

         // <<nCorz>> is a special correction to synchronize Easter with the moon's
         // orbit.
         nCorz := Int( ( 8 * nCent + 5 ) / 25 - 5 )

         // <<nSunday>> Find Sunday
         nSunday := Int( ( 5 * nYear ) / 4 - nCorx - 10 )

         // Set Epact <<nEpact>> (specifies occurance of a full moon)
         nEpact := Int( ( 11 * nGold + 20 + nCorz - nCorx ) % 30 )

         IF nEpact < 0
            nEpact += 30
         ENDIF

         IF ( ( nEpact == 25 ) .AND. ( nGold > 11 ) ) .OR. ( nEpact == 24 )
            ++nEpact
         ENDIF

         // Find full moon - the <<nMoon>>th of MARCH is a "calendar" full moon
         nMoon := 44 - nEpact

         IF nMoon < 21
            nMoon += 30
         ENDIF

         // Advance to Sunday
         nMoon := Int( nMoon + 7 - ( ( nSunday + nMoon ) % 7 ) )

         // Get Month and Day
         IF nMoon > 31
            nMonth := 4
            nDay   := nMoon - 31
         ELSE
            nMonth := 3
            nDay   := nMoon
         ENDIF
      ENDIF
   ELSE
      nYear := 0
   ENDIF

   RETURN SToD( Str( nYear, 4 ) + PadL( nMonth, 2, "0" ) + PadL( Int( nDay ), 2, "0" ) )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CalcPascoa()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CalcPascoa( AAno )

   RETURN FT_EASTER( AAno )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PegFeriados()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PegFeriados()

   IF !NETUSE( "FOPTOEVE" )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      AAdd( aEVED, Str( DIA, 2 ) + Str( MES, 2 ) )
      AAdd( aEVEC, CODIGO )
      AAdd( aEVEB, { BCOSN, REDSN, FOLSN } )
      dbSkip()
   ENDDO
   dbCloseAll()

   RETURN .T.






// + EOF: fopto_21.prg
// +
