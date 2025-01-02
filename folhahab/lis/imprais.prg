// +--------------------------------------------------------------------
// +
// +    Programa  : imprais.prg importar rais para folha
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


function imprais()
CABE2( 'Sincronizar Arquivo' )
nMESINI := 1
nMESFIM := 12
@ 22, 00 SAY "Ano  MesIni MesFim"
cANO := StrZero( Year( Date() ) - 1, 4 )
@ 23, 00 GET cano
@ 24, 05 GET nMESINI PICT "99"
@ 24, 10 GET nMESFIM PICT "99"
READcur()
carq    := "RAIS" + CANO
cARQTXT := cARQ + ".txt"
cCGCUSO := TIRAOUT( zCGC )


IF !netuse( "fo_pes" )
RETU
ENDIF
ordDestroy( "temp" )
ordCreate(, "temp", "PIS+DTOS(ADMITIDO)" )
ordSetFocus( "temp" )



IF !NETUSE( "FORAIS" )
dbCloseAll()
RETU .F.
ENDIF
IF mdg( "Apagar Importacao anterior" )
DELETE ALL FOR ano = Val( cANO )
ENDIF

IF !netuse( cARQ,, .F.,,, .F., )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF File( carqTXT ) .AND. mdg( "Importar txt" )
ZAP
APPEND FROM &carqTXT. SDF
ENDIF


dbSelectAr( cARQ )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY Space( 50 )
IF FIELD->TIPOREG = "2" .AND. cCGCUSO = FIELD->CGC
mADMITIDO := CToD( SubStr( ADMISSAO, 1, 2 ) + "/" + SubStr( ADMISSAO, 3, 2 ) + "/" + SubStr( ADMISSAO, 5 ) )
mPIS      := PIS
cBUSCA    := mPIS + DToS( mADMITIDO )
mPIS      := PIS
mNOME     := NOME
mNASC     := CToD( SubStr( NASCTO, 1, 2 ) + "/" + SubStr( NASCTO, 3, 2 ) + "/" + SubStr( NASCTO, 5 ) )
mNACION   := NACIO
mNACPAIS  := ""
IF mNACION = 10
mNACPAIS := "1058"
ELSE
mNACPAIS := OBTER( "FO_TAB",, "NACI" + AllTrim( Str( mNACION ) ), "CODIG2" )
ENDIF
mANONASCI := CHEGADA
MESCOLA   := StrZero( INSTRU, 2 )
IF mESCOLA = "10"
mESCOLA := "11"
ENDIF
IF mESCOLA = "11"
mESCOLA := "12"
ENDIF
mCPF      := CPF
MPROFIS   := IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ), PROFIS )  // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
MSERIE    := IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, SubStr( TIRAOUT( CPF ), 8 ), SERIE )
mADMITIDO := CToD( SubStr( ADMISSAO, 1, 2 ) + "/" + SubStr( ADMISSAO, 3, 2 ) + "/" + SubStr( ADMISSAO, 5 ) )
mTIPO     := TIPOHOR
IF Val( CANO ) < 2001
mTIPOADM := ""
ELSE
mTIPOADM := TIPOADM
ENDIF
mHRSEM  := HORASMES
mCBONEW := ""
IF Val( CANO ) >= 2004
mCBONEW := CBO
ENDIF
mRAISVINC := VINCULO
mRAISDEM  := MOTDEM
mDEMITIDO := CToD( SubStr( DATADEM, 1, 2 ) + "/" + SubStr( DATADEM, 3, 2 ) + "/" + CANO )
IF Val( CANO ) < 1997
mRAISDEM  := "00"
mDEMITIDO := Space( 8 )
ENDIF
IF Val( CANO ) < 2001
mRACS     := ""
mDEFICI   := ""
Mtipodefi := ""
mALVARA   := ""
mSEXO     := ""
ELSE
mRACS     := OBTER( "FO_TAB",, "RACA" + AllTrim( RACA ), "CODIG2" )
mDEFICI   := DEFICIENTE
Mtipodefi := TIPODEFI
mALVARA   := ALVARA
mSEXO     := SEXO
IF mSEXO = "1"
mSEXO := "M"
ELSE
mSEXO := "F"
ENDIF
IF mALVARA = "1"
mALVARA := "S"
ELSE
mALVARA := "N"
ENDIF
ENDIF
DO CASE
CASE mTIPO = "1"
Mtipo := "M"
CASE mTIPO = "2"
Mtipo := "Q"
CASE mTIPO = "3"
Mtipo := "S"
CASE mTIPO = "4"
Mtipo := "D"
CASE mTIPO = "5"
Mtipo := "H"
CASE mTIPO = "6"
Mtipo := "T"
CASE mTIPO = "7"
Mtipo := "O"
ENDCASE

dbSelectAr( "fo_pes" )
dbGoTop()
IF dbSeek( cBUSCA )   // cBUSCA:=mPIS+DTOS(mADMITIDO)
mNUMERO := NUMERO
@ 24, 00 SAY mNUMERO
@ 24, 10 SAY NOME
netreclock()
IF Empty( NOME )
FIELD->NOME := MNOME
ENDIF
IF Empty( NASC )
FIELD->NASC := mNAsc
ENDIF
IF Empty( anonasci )
FIELD->anonasci := manonasci
ENDIF
IF Empty( escRAIS )
FIELD->escRAIS := mescola
ENDIF
IF Empty( cpf )
FIELD->cpf := mcpf
ENDIF
IF Val( profis ) = 0
FIELD->profis := mprofis
ENDIF
IF Val( serie ) = 0
FIELD->serie := mserie
ENDIF
IF Empty( tipo ) .AND. !Empty( mTIPO )
field->tipo := mtipo
ENDIF
IF Empty( hrsem )
FIELD->hrsem := mhrsem
ENDIF
IF Empty( NASCPAIS ) .AND. !Empty( mNACPAIS )
FIELD->NASCPAIS := mNACPAIS
ENDIF
IF Empty( RACS ) .AND. !Empty( mRACS )
FIELD->RACS := MRACS
ENDIF
// IF (EMPTY(DEFICI) .AND. ! EMPTY(mDEFICI)) .OR. DEFICI="S" .OR. DEFICI="N"
// FIELD->DEFICI:=mDEFICI
// ENDIF

IF Val( mDEFICI ) = 1 .AND. Val( Mtipodefi ) > 0   // deficiente 1 sim 2 nao //grava tipo deficiente
FIELD->DEFICI := mDEFICI
ENDIF

IF Val( mDEFICI ) = 2  // deficiente 2 nao  zera campo alguns esta gravando 2 que e o tipo de deficiente e nao se e deficiente
FIELD->DEFICI := ""
ENDIF


IF Empty( SEXO ) .AND. !Empty( mSEXO )
FIELD->SEXO := mSEXO
ENDIF
IF MRAISDEM <> "00"
IF Empty( demitido )
FIELD->demitido := mdemitido
ENDIF
ENDIF
IF Empty( E1ADM ) .AND. !Empty( mTIPOADM )
IF mTIPOADM = "1"
FIELD->E1ADM := "S"
ENDIF
IF mTIPOADM = "2" .OR. mTIPOADM = "4"
FIELD->E1ADM := "N"
ENDIF
ENDIF
DO CASE
CASE mraisvinc = "10"  // funcionario
IF Empty( FO_PES->EVINC )
FO_PES->EVINC := "101"
ENDIF
IF Empty( FO_PES->CATEGORIA )
FO_PES->CATEGORIA := "01"
ENDIF
CASE mraisvinc = "50"  // temporario
IF Empty( FO_PES->EVINC )
FO_PES->EVINC := "105"
ENDIF
CASE mraisvinc = "55"  // aprendiz
IF Empty( FO_PES->EVINC )
FO_PES->EVINC := "103"
ENDIF
IF Empty( FO_PES->CATEGORIA )
FO_PES->CATEGORIA := "07"
ENDIF
CASE mraisvinc = "80"  // Diretor
IF Empty( FO_PES->EVINC )
FO_PES->EVINC := "722"
ENDIF
IF Empty( FO_PES->CATEGORIA )
FO_PES->CATEGORIA := "11"
ENDIF
ENDCASE
dbUnlock()
eBUSCA := cANO + Str( mNUMERO, 8 )
dbSelectAr( "forais" )
dbGoTop()
IF dbSeek( eBUSCA )
netreclock()
ELSE
netrecapp()
FORAIS->NUMERO := mNUMERO
FORAIS->ANO    := Val( cANO )
ENDIF
IF Empty( FORAIS->NOME )
FORAIS->NOME := mNOME
ENDIF
IF Empty( FORAIS->RAISVINC )
FORAIS->RAISVINC := mraisvinc
ENDIF
IF MRAISDEM <> "00"
IF Empty( FORAIS->raisdem )
FORAIS->raisdem := mraisdem
ENDIF
ENDIF
IF Empty( FORAIS->ALvara ) .AND. !Empty( mALVARA )
FORAIS->alvara := mALVARA
ENDIF
IF Empty( FORAIS->tipoadm ) .AND. !Empty( mTIPOADM )
FORAIS->tipoadm := mtipoadm
ENDIF
aMESES := { "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ" }
FOR X := 1 TO 12
cCAMPO := 'RAIZ' + aMESES[ X ]
cSAL   := 'SAL' + StrZero( X, 2 )
IF X >= nMESINI .AND. X <= nMESFIM
FORAIS->&cCAMPO. := Val( ( Carq )->&cSAL. ) / 100
ENDIF
NEXT X
IF Val( ( Carq )->SAL13AM ) >= NMESINI .AND. Val( ( Carq )->SAL13AM ) <= NMESFIM
FORAIS->SAL13_1 := Val( ( Carq )->SAL13A ) / 100
FORAIS->MES_1   := Val( ( Carq )->SAL13AM )
ENDIF
IF Val( ( Carq )->SAL3BM ) >= NMESINI .AND. Val( ( Carq )->SAL3BM ) <= NMESFIM
FORAIS->SAL13_2 := Val( ( Carq )->SAL13B ) / 100
FORAIS->MES_2   := Val( ( Carq )->SAL3BM )
ENDIF
FORAIS->RAIZAVI  := Val( ( Carq )->AVISO ) / 100
FORAIS->RAIZFER  := Val( ( Carq )->RAIZFER ) / 100
FORAIS->RAIZACR  := Val( ( Carq )->RAIZACR ) / 100
FORAIS->RAIZGRA  := Val( ( Carq )->RAIZGRA ) / 100
FORAIS->RAIZMUL  := Val( ( Carq )->RAIZMUL ) / 100
FORAIS->RAIZBCH  := Val( ( Carq )->RAIZBCH ) / 100
FORAIS->MESBCH   := ( Carq )->MESBCH
FORAIS->MESACR   := ( Carq )->MESACR
FORAIS->MESGRA   := ( Carq )->MESGRA
FORAIS->IBGECOD  := ( Carq )->IBGECOD
FORAIS->CODAFA01 := ( Carq )->MOTAFA01
FORAIS->INIAFA01 := ( Carq )->DATIAFA01
FORAIS->FIMAFA01 := ( Carq )->DATFAFA01
FORAIS->CODAFA02 := ( Carq )->MOTAFA02
FORAIS->INIAFA02 := ( Carq )->DATIAFA02
FORAIS->FIMAFA02 := ( Carq )->DATFAFA02
FORAIS->CODAFA03 := ( Carq )->MOTAFA03
FORAIS->INIAFA03 := ( Carq )->DATIAFA03
FORAIS->FIMAFA03 := ( Carq )->DATFAFA03
FORAIS->DIASAFA  := ( Carq )->QTDIAS
aMESES           := { "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ" }
FOR X := 1 TO 12
cCAMPO := 'HOR' + aMESES[ X ]
IF X >= nMESINI .AND. X <= nMESFIM
IF ValType( ( Carq )->&cCAMPO. ) = 'N'
FORAIS->&cCAMPO. := ( Carq )->&cCAMPO.
ELSE
FORAIS->&cCAMPO. := Val( ( Carq )->&cCAMPO. )
ENDIF
ENDIF
NEXT X
aMESES := { "SOC1", "SOC2", "SIN", "ASS", "CON" }
FOR X := 1 TO 5
cCAMPO := 'CGC' + aMESES[ X ]
cSAL   := 'VAL' + aMESES[ X ]
IF Val( ( Carq )->&cSAL. ) > 0
FORAIS->&cSAL.   := Val( ( Carq )->&cSAL. ) / 100
FORAIS->&cCAMPO. := ( Carq )->&cCAMPO.
ENDIF
NEXT X
dbUnlock()
ENDIF

ENDIF
dbSelectAr( cARQ )
dbSkip()
zei_fort( nLASTREC,,, 1 )
ENDDO
dbCloseAll()
return 

// FORAIS->RAIZJAN:=VAL((Carq)->SAL01)/100
// FORAIS->RAIZFEV:=VAL((Carq)->SAL02)/100
// FORAIS->RAIZMAR:=VAL((Carq)->SAL03)/100
// FORAIS->RAIZABR:=VAL((Carq)->SAL04)/100
// FORAIS->RAIZMAI:=VAL((Carq)->SAL05)/100
// FORAIS->RAIZJUN:=VAL((Carq)->SAL06)/100
// FORAIS->RAIZJUL:=VAL((Carq)->SAL07)/100
// FORAIS->RAIZAGO:=VAL((Carq)->SAL08)/100
// FORAIS->RAIZSET:=VAL((Carq)->SAL09)/100
// FORAIS->RAIZOUT:=VAL((Carq)->SAL10)/100
// FORAIS->RAIZNOV:=VAL((Carq)->SAL11)/100
// FORAIS->RAIZDEZ:=VAL((Carq)->SAL12)/100
// FORAIS->HORJAN :=(Carq)->HORJAN
// FORAIS->HORFEV :=(Carq)->HORFEV
// FORAIS->HORMAR :=(Carq)->HORMAR
// FORAIS->HORABR :=(Carq)->HORABR
// FORAIS->HORMAI :=(Carq)->HORMAI
// FORAIS->HORJUN :=(Carq)->HORJUN
// FORAIS->HORJUL :=(Carq)->HORJUL
// FORAIS->HORAGO :=(Carq)->HORAGO
// FORAIS->HORSET :=(Carq)->HORSET
// FORAIS->HOROUT :=(Carq)->HOROUT
// FORAIS->HORNOV :=(Carq)->HORNOV
// FORAIS->HORDEZ :=(Carq)->HORDEZ
// FORAIS->CGCSOC1 :=(Carq)->CGCSOC1
// FORAIS->VALSOC1 :=VAL((Carq)->VALSOC1)/100
// FORAIS->CGCSOC2 :=(Carq)->CGCSOC2
// FORAIS->VALSOC2 :=VAL((Carq)->VALSOC2)/100
// FORAIS->CGCSIN  :=(Carq)->CGCSIN
// FORAIS->VALSIN  :=VAL((Carq)->VALSIN)/100
// FORAIS->CGCASS  :=(Carq)->CGCASS
// FORAIS->VALASS  :=VAL((Carq)->VALASS)/100
// FORAIS->CGCCON  :=(Carq)->CGCCON
// FORAIS->VALCON  :=VAL((Carq)->VALCON)/100

// + EOF: imprais.prg
// +
