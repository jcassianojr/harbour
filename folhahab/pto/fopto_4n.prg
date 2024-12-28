// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4n.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


CABE2( "FOPTO_4N - Importar Ferias Folha" )

cPO := "PO" + ANOMESW   // ANOWORK + strzero( MES, 2 )
CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )

DATAINI := zdataini
DATAFIM := zdatafim
MDS( 'Digite as Datas Iniciais e Finais' )
@ 24, 40 GET DATAINI
@ 24, 50 GET DATAFIM
IF !READCUR()
RETU .F.
ENDIF


IF !NETUSE( "FO_FER" )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( cPO )   // AREDE( cPO, cPO, 1 )
dbCloseAll()
RETU .F.
ENDIF

dbSelectAr( "FO_FER" )
dbGoTop()
WHILE !Eof()
IF ( GOZOU1DE >= DATAINI .AND. GOZOU1DE <= DATAFIM ) .OR. ;
            ( GOZOU2DE >= DATAINI .AND. GOZOU2DE <= DATAFIM ) .OR. ;
            ( GOZOU1ATE >= DATAINI .AND. GOZOU1ATE <= DATAFIM .AND. !Empty( GOZOU1ATE ) ) .OR. ;
            ( GOZOU2ATE >= DATAINI .AND. GOZOU2ATE <= DATAFIM .AND. !Empty( GOZOU2ATE ) )
@ 24, 26 SAY NUMERO
@ 24, 33 SAY NOME
@ 24, 64 SAY DATFERIAS
@ 24, 74 SAY DATFERIASF
IF ( GOZOU1DE >= DATAINI .AND. GOZOU1DE <= DATAFIM ) .OR. ;
               ( GOZOU1ATE >= DATAINI .AND. GOZOU1ATE <= DATAFIM .AND. !Empty( GOZOU1ATE ) )
mCHAVE := Str( NUMERO, 8 ) + DToS( GOZOU1DE )
dbSelectAr( cPO )
dbGoTop()
IF !dbSeek( mCHAVE )
netrecapp()
field->NUMERO := FO_FER->NUMERO
field->OCOINI := FO_FER->GOZOU1DE
ELSE
netreclock()
ENDIF
field->OCOFIM := FO_FER->GOZOU1ATE
field->OCOCOD := "FN"
dbUnlock()
dbSelectAr( "FO_FER" )
ENDIF
IF ( GOZOU2DE >= DATAINI .AND. GOZOU2DE <= DATAFIM ) .OR. ;
               ( GOZOU2ATE >= DATAINI .AND. GOZOU2ATE <= DATAFIM .AND. !Empty( GOZOU2ATE ) )
mCHAVE := Str( NUMERO, 8 ) + DToS( GOZOU2DE )
dbSelectAr( cPO )
dbGoTop()
IF !dbSeek( mCHAVE )
netrecapp()
field->NUMERO := FO_FER->NUMERO
field->OCOINI := FO_FER->GOZOU2DE
ELSE
netreclock()
ENDIF
field->OCOFIM := FO_FER->GOZOU2ATE
field->OCOCOD := "FN"
dbUnlock()
dbSelectAr( "FO_FER" )
ENDIF
ENDIF
dbSelectAr( "FO_FER" )
dbSkip()
ENDDO
dbCloseAll()


// + EOF: fopto_4n.prg
// +
