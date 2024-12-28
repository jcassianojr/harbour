// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ake.prg
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


MDI( "Importando Dados Folha" )
CRIARVARS( "MK04" )
cVAR     := MESANO()
ARQWORK  := "K4" + cVAR
mANO     := Val( Left( cVAR, 2 ) )
mMES     := Val( Right( cVAR, 2 ) )
mDATA    := ZDATA
mTIPOCLI := "M"
mCOGNOME := "FOLHA"
IF !mdg( "Importar os dados da Folha para " + cVAR )
RETU .F.
ENDIF
MDS( "Checando Plano de Conta Folha" )
aCTA := {}
aCON := {}
aCEN := {}
aFOL := {}
IF !USECHK( "\FOLHA\CONTAS",, .T. )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
IF !Empty( CO_COD ) .OR. !Empty( CO_CODD )
AAdd( aCTA, CODIGO )
AAdd( aCON, { CO_COD, CO_CODD } )
ENDIF
dbSkip()
ENDDO
dbCloseArea()
MDS( "Checando Centro Custo Manager" )
IF !USEREDE( "MI03", 1, 1 )
RETU .F.
ENDIF
WHILE !Eof()
IF !Empty( CFOLHA )
AAdd( aFOL, CFOLHA )
AAdd( aCEN, { CENTRO, GASTO } )
ENDIF
dbSkip()
ENDDO
dbCloseArea()
MDS( "Gravando Dados" )
IF !USEREDE( ARQWORK, 1, 99 )
RETU .F.
ENDIF
dbGoBottom()
mNRNOTA := NRNOTA
mNRNOTA++
IF !USECHK( "\FOLHA\APIDEPTO",, .T. )
dbCloseAll()
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
IF Empty( SECAO ) .AND. Empty( SETOR )
mVALORMES := VALOR
xCONTA    := CONTA
mDEPTO    := DEPTO
nPOS      := AScan( aCTA, xCONTA )
IF nPOS > 0
cCREDITO := aCON[ nPOS, 1 ]
cDEBITO  := aCON[ nPOS, 2 ]
wPOS     := AScan( aFOL, mDEPTO )
IF wPOS > 0
mCENTRO := aCEN[ wPOS, 1 ]
mGASTO  := aCEN[ wPOS, 2 ]
dbSelectAr( ARQWORK )
IF !Empty( cCREDITO )
mCONTA := cCREDITO
NOVOOPA()
mNRNOTA++
ENDIF
IF !Empty( cDEBITO )
mCONTA := cDEBITO
NOVOOPA()
mNRNOTA++
ENDIF
ENDIF
ENDIF
ENDIF
dbSelectAr( "APUDEPTO" )
dbSkip()
ENDDO

// + EOF: m_ake.prg
// +
