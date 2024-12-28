// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aoy.prg
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


MDI( " Ý Reprocessar Passos da Ordem de Fabricacao" )
IF !USEREDE( "OF03", 0, 99 )
RETU .F.
ENDIF
MDS( "Apagando Reprocesso Anterior" )
ZAP
INITVARS()
CLRVARS()
IF !USEREDE( "OF01", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !USEREDE( "MS06", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF

MDS( "Gerando Processos" )
dbSelectAr( "OF01" )
WHILE !Eof()
IF QFABRICAR > 0
@ 24, 30 SAY OF PICT "999.99"
mOF      := OF
mITEM    := ITEM
mCODIGO  := CODIGO
mDLIMP   := DLIMP
mDLIMITE := DLIMITE
mDPEDI   := DPEDI
mQTFAB   := CONVUN( QFABRICAR, UNID )
mQTFAL   := mQTFAB
dbSelectAr( "MS06" )
dbGoTop()
dbSeek( mCODIGO )
WHILE mCODIGO = CODIGO .AND. !Eof()
IF SEQ = 99  // Encerrou Sequencia
EXIT
ENDIF
@ 24, 40 SAY SEQ PICT "999"
@ 24, 44 SAY SSQ PICT "999"
mSEQ      := SEQ
mSSQ      := SSQ
mCODMP01  := CODMP01
mCODMP02  := CODMP02
mCODMP02B := CODMP02B
mCODMP02C := CODMP02C
mCODMP02D := CODMP02D
mCODMP03  := CODMP03
mQTTIME   := IF( PCHORA > 0, 1 / PCHORA, 0 )
IF FATOR # 0
mQTTIME := mQTTIME * FATOR
ENDIF
dbSelectAr( "OF03" )
netrecapp()
REPLVARS()
dbSelectAr( "MS06" )
dbSkip()
ENDDO
ENDIF
dbSelectAr( "OF01" )
dbSkip()
ENDDO
dbSelectAr( "OF01" )
dbCloseArea()

dbSelectAr( "OF03" )
dbSetOrder( 2 )
MDS( "Distribuindo Saldos" )
dbSelectAr( "MS06" )
dbGoTop()
WHILE !Eof()
@ 24, 30 SAY SEQ    PICT "999"
@ 24, 34 SAY SSQ    PICT "999"
@ 24, 40 SAY CODIGO
nREG    := RecNo()
cCODIGO := CODIGO
cSEQ    := SEQ
nSALDO  := 0
dbSkip()   // O Processo e calculado com o saldo posterior
WHILE cCODIGO = CODIGO .AND. !Eof()  // Pois o saldo deste processo ainda n„o foi finalizado
IF ESTQSAL > 0 .AND. Empty( SSQ )   // Nao soma sub processos
nSALDO += ESTQSAL
ENDIF
dbSkip()
ENDDO
IF nSALDO > 0
dbSelectAr( "OF03" )
dbGoTop()
dbSeek( cCODIGO + Str( cSEQ, 3 ) )
WHILE cCODIGO = CODIGO .AND. cSEQ = SEQ .AND. !Eof() .AND. nSALDO > 0.0001
mFAZER := QTFAB
DO CASE
CASE mFAZER = nSALDO
FIELD->QTRES := QTRES + mFAZER
nSALDO       := 0
CASE mFAZER > nSALDO
FIELD->QTRES := QTRES + nSALDO
nSALDO       := 0
CASE nSALDO > mFAZER
FIELD->QTRES := QTRES + mFAZER
nSALDO       -= mFAZER
ENDCASE
FIELD->QTFAL := QTFAB - QTRES
dbSkip()
ENDDO
ENDIF
dbSelectAr( "MS06" )
dbGoto( nREG )
dbSkip()
ENDDO
dbCloseAll()

// + EOF: m_aoy.prg
// +
