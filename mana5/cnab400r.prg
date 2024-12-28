// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : cnab400r.prg
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


MDI( " LER Arquivo CNAB Retorno" )
cARQUIVO := "p:\novell\ITAESBRA\RETCOB\" + Space( 50 )
@ 23, 00 SAY "Arquivo"
@ 24, 00 GET cARQUIVO
IF !READCUR()
RETU .F.
ENDIF
cARQUIVO := AllTrim( cARQUIVO )
cBANCO   := "   "
IF !File( cARQUIVO )
ALERTX( "Arquivo Inexistente " + Carquivo )
RETU .F.
ENDIF
IF !USEREDE( "CNAB400R", 0, 99 )
RETU .F.
ENDIF
INITVARS()
CLRVARS()
ZAP
nHANDLE := hb_FOPEN( cARQUIVO )
IF nHANDLE <= 0
dbCloseAll()
ALERTX( "Erro Abrindo " + Carquivo )
RETU .F.
ENDIF
lPRI     := .F.
cLINHA01 := ""
nLINHA   := 0
WHILE .T.
cVAR := FREADLINE( nHANDLE )
IF Empty( cLINHA01 )
cLINHA01 := cVAR
ELSE
lPRI := .T.
ENDIF
nLINHA++
@ 23, 00 SAY "Linha " + Str( nLINHA, 8 )
@ 24, 00 SAY Left( cVAR, 3 )
DO CASE
CASE cLINHA01 = cVAR .AND. lPRI
ALERTX( "Retornou ao primeiro Registro" )
IF MDG( "Encerrar Importacao-Recomendavel" )
EXIT
ENDIF
CASE Left( cVAR, 3 ) = "   "
ALERTX( "Linha em Branco" )
IF MDG( "Encerrar Importacao-Recomendavel" )
EXIT
ENDIF
CASE Left( cVAR, 1 ) = "0"
mCODBCO := SubStr( cVAR, 77, 3 )
CASE Left( cVAR, 1 ) = "1"
mTITEMP := SubStr( cVAR, 38, 25 )
DO CASE
CASE mCODBCO = "074"  // Safra
mTITBAN := SubStr( cVAR, 127, 20 )
OTHERWISE   // 104 Caixa 021 banestes 479 boston
mTITBAN := SubStr( cVAR, 63, 11 )
mINDOPE := SubStr( cVAR, 83, 24 )
ENDCASE
mCODREG := SubStr( cVAR, 80, 3 )
DO CASE
CASE mCODBCO = "104"  // CAIXA
mCODCAR := SubStr( cVAR, 107, 2 )
OTHERWISE
mCODCAR := SubStr( cVAR, 108, 1 )  // 1-simples 2-direto 3-escritural
ENDCASE
mCODOCO  := SubStr( cVAR, 109, 2 )
mDATAOCO := CToD( SubStr( cVAR, 111, 2 ) + "/" + SubStr( cVAR, 113, 2 ) + "/" + SubStr( cVAR, 115, 2 ) )
mSEUNUM  := SubStr( cVAR, 117, 10 )
cDATA    := SubStr( cVAR, 147, 2 ) + "/" + SubStr( cVAR, 149, 2 ) + "/" + SubStr( cVAR, 151, 2 )
// ALERTX(cDATA)
mDATAVEN := CToD( cDATA )
DO CASE
CASE mCODBCO = "021"  // Banestes
mVALTIT := Val( SubStr( cVAR, 156, 10 ) ) / 100
OTHERWISE
mVALTIT := Val( SubStr( cVAR, 153, 13 ) ) / 100
ENDCASE
mAGCBCO := SubStr( cVAR, 169, 5 )
mESPTIT := SubStr( cVAR, 174, 2 )
// dm dupmercantil ds-dupservico ns-nota seguro
// re recibo escola rs-rescibo associacao rc recibo concodminio
// nd nota  debito ot outros
mVALDEP    := Val( SubStr( cVAR, 176, 13 ) ) / 100
mVALDEPOUT := Val( SubStr( cVAR, 189, 13 ) ) / 100
mVALJURATR := Val( SubStr( cVAR, 202, 13 ) ) / 100
mVALIOF    := Val( SubStr( cVAR, 215, 13 ) ) / 100
mVALABT    := Val( SubStr( cVAR, 228, 13 ) ) / 100
mVALDES    := Val( SubStr( cVAR, 241, 13 ) ) / 100
mVALPAG    := Val( SubStr( cVAR, 254, 13 ) ) / 100
mVALJUR    := Val( SubStr( cVAR, 267, 13 ) ) / 100
DO CASE
CASE mCODBCO = "479"
OTHERWISE
mVALMUL := Val( SubStr( cVAR, 280, 13 ) ) / 100  // Outros Creditos
ENDCASE
DO CASE
CASE mCODBCO = "104"  // CAIXA
mCODMOD := SubStr( cVAR, 293, 1 )
CASE mCODBCO = "021"  // bANESTES
mCODMOD := SubStr( cVAR, 394, 1 )
ENDCASE
DO CASE
CASE mCODBCO = "021"  // bANESTES
mMOTPRO := SubStr( cVAR, 295, 1 )
ENDCASE
IF mMOTPRO = "0"
mMOTPRO := "N"
ENDIF
IF mMOTPRO = "1"
mMOTPRO := "S"
ENDIF
IF mMOTPRO = "D"  // Despresado
mMOTPRO := "N"
ENDIF
IF mMOTPRO = "A"  // aCEITO
mMOTPRO := "S"
ENDIF
mMOTREG01 := SubStr( cVAR, 319, 10 )  // 5 Motivos 2 digitos
mMOTREG02 := SubStr( cVAR, 321, 10 )  // 5 Motivos 2 digitos
mMOTREG03 := SubStr( cVAR, 323, 10 )  // 5 Motivos 2 digitos
mMOTREG04 := SubStr( cVAR, 325, 10 )  // 5 Motivos 2 digitos
mMOTREG05 := SubStr( cVAR, 327, 10 )  // 5 Motivos 2 digitos
DO CASE
CASE mCODBCO = "479"  // Boston
mLIQDATA := CToD( SubStr( cVAR, 280, 2 ) + "/" + SubStr( cVAR, 282, 2 ) + "/" + SubStr( cVAR, 284, 2 ) )
ENDCASE
DO CASE
CASE mCODBCO = "479"  // Boston
mCREDATA := CToD( SubStr( cVAR, 286, 2 ) + "/" + SubStr( cVAR, 288, 2 ) + "/" + SubStr( cVAR, 290, 2 ) )
CASE mCODBCO = "104"  // Caixa
mCREDATA := CToD( SubStr( cVAR, 294, 2 ) + "/" + SubStr( cVAR, 296, 2 ) + "/" + SubStr( cVAR, 298, 2 ) )
CASE mCODBCO = "074"  // Safra
mCREDATA := CToD( SubStr( cVAR, 296, 2 ) + "/" + SubStr( cVAR, 298, 2 ) + "/" + SubStr( cVAR, 300, 2 ) )
ENDCASE
mSEQARQ := Val( SubStr( cVAR, 395 ) )
netrecapp()
replvars()
ENDCASE
ENDDO
FClose( nHANDLE )

PADRAO( 0, 1, 0, "CNAB400R", "Titulo Empresa            SeuNumero  Vcto     Valor        Seq", "' '+mTITEMP+' '+mSEUNUM+' '+DTOC(mDATAVEN)+' '+STR(mVALTIT, 12, 2)+' '+STR(mSEQARQ,  6)", "CNABR1" )




// + EOF: cnab400r.prg
// +
