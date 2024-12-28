// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a74.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( "Copia de Nota Fiscal" )
xNUMERO := 0
yNUMERO := 0
ULTIMOREG( "MM01", "NUMERO", "yNUMERO" )
MDS( "Digite a Nota Origem/Destino" )
@ 24, 40 GET xNUMERO PICT "99999999"
@ 24, 50 GET yNUMERO PICT "99999999"
IF !READCUR()
RETU .F.
ENDIF
lATUAL := MDG( "Nota Origem Mes Atual" )

IF !lATUAL
cANO    := MESANO()
ARQWORK := "M1" + cANO
ARQWOR2 := "M2" + cANO
ENDIF



IF VERSEHA( "MM01", yNUMERO )
ALERTX( "Nota destino j  cadastrada" )
RETU .F.
ENDIF
IF !VERSEHA( IF( lATUAL, "MM01", ARQWORK ), xNUMERO )
ALERTX( "Nota Origem n„o cadastrada" )
RETU .F.
ENDIF
CRIARVARS( "MM01" )
CRIARVARS( "MM02" )
IF lATUAL
IF !USEMULT( { { "MM01", 1, 99 }, { "MM02", 1, 99 } } )
RETU .F.
ENDIF
ARQWORK := "MM01"
ARQWOR2 := "MM02"
ELSE
IF !USEMULT( { { "MM01", 1, 99 }, { "MM02", 1, 99 }, { ARQWORK, 1, 99 }, { ARQWOR2, 1, 99 } } )
RETU .F.
ENDIF
ENDIF
dbSelectAr( ARQWORK )
dbGoTop()
IF dbSeek( xNUMERO )
EQUVARS()
mNUMERO := yNUMERO   // Ajusta nota destino
netgrvcam( "COPIA", yNUMERO )
dbSelectAr( "MM01" )
NOVOOPA(, .F. )
netgrvcam( "COPIA", xNUMERO )
dbSelectAr( ARQWOR2 )
dbGoTop()
dbSeek( Str( xNUMERO, 8 ) )
WHILE NUMERO = xNUMERO .AND. !Eof()
nREC := RecNo()
EQUVARS()
mNUMERO := yNUMERO  // Ajusta nota destino
dbSelectAr( "MM02" )
NOVOOPA()
dbSelectAr( ARQWOR2 )
dbGoto( nREC )
dbSkip()
ENDDO
ENDIF
dbCloseAll()

// + EOF: m_a74.prg
// +
