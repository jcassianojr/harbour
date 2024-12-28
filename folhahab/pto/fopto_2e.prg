// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2e.prg
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


CABE2( 'FOPTO_2E - Transferir Totais Para a Folha' )
CX := Array( 24 )
LF := Chr( 13 ) + Chr( 10 )

aCODCTA := PEGCX()
aTR     := PEGCX( "T" )

IF !NETUSE( "FOPTOCON" )
RETU .F.
ENDIF
IF !dbSeek( nremp )
dbGoTop()
ENDIF
cARQUIVO := AllTrim( CAMINEX )
eFORMULA := AllTrim( EXPORTA )
dbCloseAll()

cPT := "PT" + ANOMESW


IF !NETUSE( PES )
RETU
ENDIF
FILTRO := "EMPTY(DEMITIDO)"
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO
INITVARS()
CLRVARS()


IF !NETUSE( cPT )
RETU
ENDIF

nHANDLE := FCreate( cARQUIVO )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF


dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
EQUVARS()
// Anlise feita com arquivo pes pois checar tipo horista/mensalista entre outros na macro
AFill( CX, 0 )
FOR X := 1 TO 24
cVAR := aCODCTA[ X ]
IF !Empty( &cVAR. )
CX[ X ] = &CVAR
ENDIF
NEXT X
dbSelectAr( cPT )
dbGoTop()
IF dbSeek( mNUMERO )
HX := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
            CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
            CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
VX := { VAL01, VAL02, VAL03, VAL04, VAL05, VAL06, VAL07, VAL08, ;
            VAL09, VAL10, VAL11, VAL12, VAL13, VAL14, VAL15, VAL16, ;
            VAL17, VAL18, VAL19, VAL20, VAL21, VAL22, VAL23, VAL24 }
FOR X := 1 TO 24
IF HX[ X ] # 0 .AND. aTR[ X ] # "N"
FWrite( nHANDLE, &eFORMULA )
ENDIF
NEXT X
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()
FWrite( nHANDLE, Chr( 26 ) )
FClose( nHANDLE )
IF MDG( "Deseja Imprimir o arquivo Gerado" )
IMPARQ( cARQUIVO )
ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function STRHOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC STRHOR( nVAL, nPOS, nDEC )

   LOCAL cRETVAL := 0

   cRETVAL := StrTran( StrZero( nVAL, nPOS, nDEC ), ".", "" )
   RETU cRETVAL


// + EOF: fopto_2e.prg
// +
