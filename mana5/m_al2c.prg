// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_al2c.prg
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


// #INCLUDE "COMANDO.CH"
dDATAINI := dDATAFIM := ZDATA
yNRNOTA  := 0
yFATURA  := 0.00
MDI( " þ ",,, "ML02" )
MDS( "Digite o Periodo e Faturamento" )
@ 24, 30 GET dDATAINI
@ 24, 40 GET dDATAFIM
@ 24, 50 GET yFATURA
IF !READCUR()
RETU .F.
ENDIF

CRIARVARS( "ML01" )
CRIARVARS( "ML02" )

CORPAD := CORARR( "MAL2" )
PAD001 := CORPAD[ 1 ]
PAD002 := CORPAD[ 2 ]
PAD005 := CORPAD[ 3 ]
PAD006 := CORPAD[ 4 ]
PAD007 := CORPAD[ 5 ]



TELASAY( "MAL201" )
EDITSAY( "MAL201" )

mFORNECEDO := CLIENTE
mDATA      := ZDATA

IF !USEREDE( "ML01", 1, 99 )
RETU .F.
ENDIF

IF Empty( mNRNOTA )
mNRNOTA := yNRNOTA
yNRNOTA++
ENDIF
IF !Empty( mFATPER )
mVALOR  := Round( yFATURA * mFATPER / 100, 2 )
mTOTFAT := Round( yFATURA * mFATPER / 100, 2 )
ENDIF
dREF := dDATAINI
WHILE dREF <= dDATAFIM
// Entrega Semanal
IF mVENTIP = "S"
// O dia da semana Coincide com o da Entrega
IF DoW( dREF ) = mDATENT
mVENCIMENT := dREF
NOVOOPE(, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
ENDIF
ENDIF
// Entrega Mensal
IF mVENTIP = "M"
// O dia do mes Coincide com o da Entrega
IF Day( dREF ) = mDATENT
mVENCIMENT := dREF
NOVOOPE(, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
ENDIF
ENDIF
dREF++
ENDDO
dbCloseAll()

// + EOF: m_al2c.prg
// +
