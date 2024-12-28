// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dv.prg
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

MDI( " Ý Ajuste Dipam " )
aRETU    := PERFEC( { "MM06" }, { "M6" }, { "MM96" } )
cARQUIVO := aRETU[ 5, 1 ]
IF !USEREDE( AllTrim( cARQUIVO ), 1, 99 )
RETU
ENDIF
IF !USEREDE( "MD04", 1, 99 )
dbCloseAll()
RETU .F.
ENDIF
dbSelectAr( AllTrim( cARQUIVO ) )
dbGoTop()
WHILE !Eof()
@ 24, 60 SAY NUMERO
IF Empty( DIPAM )
nINDICE := 2
mDOPER  := DCFONEW
IF Empty( mDOPER )
mDOPER  := DOPER
nINDICE := 3
ENDIF
dbSelectAr( "MD04" )
dbSetOrder( nINDICE )
dbGoTop()
dbSeek( mDOPER )
mDIPAM := IF( Found(), DIPAM, "  " )
dbSelectAr( AllTrim( cARQUIVO ) )
IF !Empty( mDIPAM )
NETGRVCAM( "DIPAM", mDIPAM )
ENDIF
ENDIF
dbSkip()
ENDDO
dbCloseArea()

// + EOF: m_dv.prg
// +
