// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bs6.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BS6.PRG
// +
// +    Functions: Function MBS601()
// +
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"
MDI( " Э Resumo de Vendas" )

// Verificando a Impressora
IF !CHECKIMP( 0 )
RETURN .F.
ENDIF
cAE := IMP( "AE" )

nANO    := 0
nMES    := 0
nMARKUP := 12.95
MDS( "Confirme Markup sem Icms" )
@ 24, 30 GET nMARKUP
IF !READCUR()
RETU .F.
ENDIF

sMBS601 := SENHAX( "MBS601" )

aGRUPO := {}
aGRUPV := {}
IF !USEREDE( "MD02", 1, 1 )
dbCloseAll()
ENDIF
dbGoTop()
dbSeek( "GRUPOEMP" )
WHILE AllTrim( CODIGO ) = "GRUPOEMP" .AND. !Eof()
IF VARIACAO = 1
AAdd( aGRUPO, CODIGO1 )
AAdd( aGRUPV, { 0, 0, 0, if( VALOR = 1, .T., .F. ) } )  // 4=Exportacao
ENDIF
dbSkip()
ENDDO
dbCloseArea()

lLISTA1 := MDG( "Listar Resumo Fornecimento Produtos" )
lLISTA4 := MDG( "Listar Resumo Margem de Lucros" )

cDES  := "Atual"
cVAR  := "ATU"
ARQNF := ""

aRETU := PERFEC( { "MM02" }, { "M2" }, { "MM92" } )
ARQNF := aRETU[ 5, 1 ]
cDES  := aRETU[ 7 ]
cVAR  := aRETU[ 4 ] + aRETU[ 3 ]
nMES  := aRETU[ 1 ]
nANO  := aRETU[ 2 ]

IF !USEMULT( { { "MA01", 1, 1 }, { "MS01P", 1, 1 }, { "MS01", 1, 1 }, { "MD05", 1, 1 }, { "APURA5", 0, 99 }, ;
         { "APURA5A", 0, 99 }, { "APU5G2", 0, 99 }, { "APU5G3", 0, 99 }, ;
         { "APURA5D", 0, 0 }, { "APU5G5", 0, 99 } } )
RETU .F.
ENDIF

FILTRA := RFILORD( "MM02", .F. )
IF !USEREDE( ARQNF, 1, 0 )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "str( FORNECEDO, 8 ) + CODIGO" )
ordSetFocus( "temp" )


SET FILTER TO &FILTRA
dbGoTop()

dbSelectAr( "APURA5" )
ZAP
dbSelectAr( "APURA5A" )
ZAP

dbSelectAr( "APU5G2" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = nMES .AND. ANO = nANO }, {|| zei_fort( nLASTREC,,, 1 ) } )

dbSelectAr( "APU5G3" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = nMES .AND. ANO = nANO }, {|| zei_fort( nLASTREC,,, 1 ) } )

dbSelectAr( "APURA5D" )
ZAP

dbSelectAr( "APU5G5" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| MES = nMES .AND. ANO = nANO }, {|| zei_fort( nLASTREC,,, 1 ) } )


dbSelectAr( "MA01" )
dbGoTop()
WHILE !Eof()
mFORNECEDO := NUMERO
mCOGNOME   := COGNOME
mGRUPO     := GRUPOEMP
mESTADO    := ESTADO
mSUBGER    := SUBGER
mICM       := 0
@ 24, 00 SAY NUMERO
@ 24, 10 SAY COGNOME
dbSelectAr( "MD05" )
dbGoTop()
IF dbSeek( mESTADO )
mICM := ALIQUOTA
ENDIF
dbSelectAr( ARQNF )
dbGoTop()
dbSeek( Str( mFORNECEDO, 8 ) )
IF FORNECEDO # mFORNECEDO
dbSelectAr( "MA01" )
dbSkip()
LOOP
ENDIF
dbSelectAr( ARQNF )
WHILE mFORNECEDO = FORNECEDO .AND. !Eof()
@ 24, 40 SAY CODIGO
mCODIGO   := CODIGO
mTIPOSERV := ""
nQTDE     := 0
nPRECOM   := 0
nPRECOT   := 0
WHILE mFORNECEDO = FORNECEDO .AND. CODIGO = mCODIGO .AND. !Eof()
IF TIPOENT = "P" .AND. ( TIPOSERV = "1" .OR. TIPOSERV = "3" ) .AND. APURA # "N" ;
                  .AND. ESPECIE # "NFC"
// if left( OPERACAO, 3 ) # "593" .and. left( OPERACAO, 3 ) # "693" ;
// .and. APURA # "N" .and. ESPECIE # "NFC" ;
// .and. TIPOSERV # "2" .and. TIPOENT = "P"  //Tiposerv 2 Ferramental
nQTDE   += CONVUN( QTDE, UNID )
nPRECOM += VALORMER
nPRECOT += VALORTOT
ENDIF
dbSelectAr( ARQNF )
dbSkip()
ENDDO
mNOME  := ""
mPARTI := 0
mPPLAN := 0
IF nQTDE > 0 .AND. !Empty( mCODIGO ) ;
               .AND. Left( mCODIGO, 4 ) <> "LENG" ;
               .AND. Left( mCODIGO, 5 ) <> "6600 " ;
               .AND. Left( mCODIGO, 6 ) <> "6950 "
// LENG 6600 6950 Prototipo
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( mCODIGO )
mNOME  := AllTrim( NOME )
mPARTI := PARTI
mPPLAN := PPLAN
ENDIF
dbSelectAr( "MS01P" )
dbGoTop()
IF dbSeek( PadR( mCODIGO, 24 ) + Str( mFORNECEDO, 5 ) )
mPPLAN := PPLAN
ENDIF
dbSelectAr( "APURA5" )
netrecapp()
field->CLIENTE  := mFORNECEDO
field->CODIGO   := mCODIGO
field->COGCLI   := mCOGNOME
field->GRUPO    := mGRUPO
field->SUBGER   := mSUBGER
field->NOME     := mNOME
field->PARTI    := mPARTI
field->QTDDE    := nQTDE
field->VALORMER := nPRECOM
field->VALORTOT := nPRECOT
field->PRECOM   := Round( VALORMER / QTDDE, 4 )
field->PPLAN    := if( Empty( mPPLAN ), PRECOM * .9, mPPLAN )
field->PPLANL   := if( Empty( mPPLAN ), "*", " " )
field->ICM      := mICM
field->PPCAL    := PPLAN + ( PRECOM * ( nMARKUP + ICM ) / 100 )
ENDIF
dbSelectAr( ARQNF )
ENDDO
dbSelectAr( "MA01" )
dbSkip()
ENDDO

dbSelectAr( ARQNF )
dbCloseArea()
nGERAL := 0
dbSelectAr( "APURA5" )
dbGoTop()
WHILE !Eof()
nGERAL += VALORTOT
dbSkip()
ENDDO
dbGoTop()
WHILE !Eof()
@ 24, 60 SAY perc( VALORTOT, nGERAL )
field->PERCLI := perc( VALORTOT, nGERAL )
dbSkip()
ENDDO
dbSelectAr( "APURA5" )
dbGoTop()
WHILE !Eof()
mCLIENTE := CLIENTE
mCOGNOME := COGCLI
mGRUPO   := GRUPO
mSUBGER  := SUBGER
mNOME    := ""
nVAL     := 0
mTGRUPO  := ""
dbSelectAr( "APURA5" )
WHILE mCLIENTE = CLIENTE .AND. !Eof()
nVAL += VALORTOT
dbSkip()
ENDDO
IF !Empty( mGRUPO )
nPOS := AScan( aGRUPO, AllTrim( mGRUPO ) )
IF nPOS > 0
aGRUPV[ nPOS, 1 ] += nVAL
aGRUPV[ nPOS, 2 ] += perc( nVAL, nGERAL )
aGRUPV[ nPOS, 3 ] = aGRUPV[ nPOS, 2 ] * 1000
mTGRUPO := "S"
ENDIF
ENDIF
NOVOOPA( "APURA5A", .F., .F. )
field->CLIENTE  := mCLIENTE
field->COGCLI   := mCOGNOME
field->VALORTOT := nVAL
field->PERCLI   := perc( nVAL, nGERAL )
field->INTPERC  := PERCLI * 1000
field->TGRUPO   := mTGRUPO
field->SUBGER   := mSUBGER
dbSelectAr( "APURA5" )
ENDDO
dbSelectAr( "APURA5A" )
FOR W := 1 TO Len( aGRUPO )
IF aGRUPV[ W, 1 ] > 0
NOVOOPA(, .F., .F. )
field->CLIENTE  := 99990000 + W
field->COGCLI   := aGRUPO[ W ]
field->VALORTOT := aGRUPV[ W, 1 ]
field->PERCLI   := aGRUPV[ W, 2 ]
field->INTPERC  := aGRUPV[ W, 3 ]
field->VALOREXP := if( aGRUPV[ W, 4 ], VALORTOT, 0 )
ENDIF
NEXT W

IF lLISTA1
FILTROA := ""
FILTROA := RFILORD( "MA01", .F., FILTROA )
IMPRESSORA()
dbSelectAr( "MA01" )
IF !Empty( FILTROA )
SET FILTER TO &FILTROA
ENDIF
dbGoTop()
WHILE !Eof()
CTLIN    := 80
mCLIENTE := NUMERO
mNOMECLI := NOME
mCLIPER  := 0
mTOTCLI  := 0
aTOT     := { 0, 0, 0 }
dbSelectAr( "APURA5A" )
dbGoTop()
IF dbSeek( mCLIENTE )
mCLIPER := PERCLI
mTOTCLI := VALORTOT
ENDIF
dbSelectAr( "APURA5" )
dbGoTop()
dbSeek( Str( mCLIENTE, 8 ) )
WHILE mCLIENTE = CLIENTE .AND. !Eof()
IF CTLIN > 55
@  0, 0   SAY cAE + "RELATORIO MENSAL - FORNECIMENTO IEB - " + cDES
@  1, 0   SAY "M_BS6A "
@  1, 60  SAY Time()
@  1, 70  SAY ZDATA
@  2, 00  SAY cAE + Str( mCLIENTE )
@  2, 9   SAY Left( mNOMECLI, 40 )
@  2, 50  SAY mCLIPER                                           PICT "999.99"
@  3, 00  SAY "Codigo"
@  3, 25  SAY "Descri‡„o"
@  3, 57  SAY "Fatia"
@  3, 69  SAY "Qtde"
@  3, 74  SAY "Total Merc."
@  3, 86  SAY "Preco"
@  3, 99  SAY "Total NF"
@  3, 109 SAY "% FAT"
@  3, 116 SAY "% CLI"
@  4, 00  SAY repl( "=", 132 )
CTLIN := 5
ENDIF
@ CTLIN, 0  SAY CODIGO
@ CTLIN, 25 SAY Left( NOME, 30 )
@ CTLIN, 56 SAY PARTI         PICT "999.99"
@ CTLIN, 63 SAY QTDDE         PICT "@E 99,999,999"
IF sMBS601
@ CTLIN, 74  SAY VALORMER               PICT "@E 9999,999.99"
@ CTLIN, 85  SAY PRECOM                 PICT "@E 999.99"
@ CTLIN, 96  SAY VALORTOT               PICT "@E 9999,999.99"
@ CTLIN, 108 SAY PERCLI                 PICT "@E 999.99"
@ CTLIN, 115 SAY perc( VALORTOT, mTOTCLI ) PICT "@E 999.99"
ENDIF
aTOT[ 1 ] += QTDDE
aTOT[ 2 ] += VALORMER
aTOT[ 3 ] += VALORTOT
CTLIN++
dbSkip()
ENDDO
IF aTOT[ 1 ] > 0
@ CTLIN, 0  SAY "TOTAL GERAL:"
@ CTLIN, 63 SAY aTOT[ 1 ]        PICT "@E 99,999,999"
IF sMBS601
@ CTLIN, 74 SAY aTOT[ 2 ] PICT "@E 9999,999.99"
@ CTLIN, 96 SAY aTOT[ 3 ] PICT "@E 9999,999.99"
ENDIF
ENDIF
dbSelectAr( "MA01" )
dbSkip()
ENDDO
VIDEO()
ENDIF

nGERAL := 0
nEXPOR := 0
dbSelectAr( "APURA5A" )
dbGoTop()
WHILE !Eof()
mCLIENTE := CLIENTE
mNOME    := ""
dbSelectAr( "MA01" )
dbGoTop()
IF dbSeek( mCLIENTE )
mNOME := Left( NOME, 40 )
ENDIF
dbSelectAr( "APURA5A" )
IF mCLIENTE < 9999000
nGERAL += VALORTOT
ELSE
nEXPOR += VALOREXP
ENDIF
dbSkip()
ENDDO
IF nGERAL > 0
IF !Empty( nANO ) .AND. !Empty( nMES )
IF !VERSEHA( "APU5TOT", Str( nANO, 4 ) + Str( nMES, 2 ) )
mANO      := nANO
mMES      := nMES
mVALORTOT := nGERAL
mVALOREXP := nEXPOR
mJUNTO    := StrZero( nMES, 2 ) + "/" + Right( StrZero( nANO, 4 ), 2 )
NOVOREG( "APU5TOT", Str( nANO, 4 ) + Str( nMES, 2 ) )
ELSE
GRAVAMVAR( "APU5TOT", Str( nANO, 4 ) + Str( nMES, 2 ), { "VALORTOT", "VALOREXP" }, { "nGERAL", "nEXPOR" } )
ENDIF
ENDIF
ENDIF

nCONTA := 0
aCLI   := {}
aDAD   := {}
dbSelectAr( "APURA5" )
dbSetOrder( 2 )
dbGoTop()
WHILE !Eof()
mCLIENTE := CLIENTE
mCLIPER  := 0
mTOTCLI  := 0
dbSelectAr( "APURA5A" )
dbGoTop()
IF dbSeek( mCLIENTE )
mCLIPER := PERCLI
mTOTCLI := VALORTOT
ENDIF
dbSelectAr( "APURA5" )
field->CLITOTPER := mCLIPER
field->CLITOTVAL := mTOTCLI
nPOS             := AScan( aCLI, CLIENTE )
IF nPOS = 0
AAdd( aCLI, CLIENTE )
AAdd( aDAD, { COGCLI, Left( CODIGO, 30 ), PERCLI, perc( VALORTOT, mTOTCLI ), VALORTOT } )
ENDIF
IF PERCLI >= 1 .AND. nCONTA < 15
aGRAVA := { CLIENTE, COGCLI, CODIGO, PERCLI, perc( VALORTOT, mTOTCLI ), VALORTOT }
dbSelectAr( "APU5G3" )
netrecapp()
field->CLIENTE  := aGRAVA[ 1 ]
field->COGCLI   := aGRAVA[ 2 ]
field->CODIGO   := aGRAVA[ 3 ]
field->PRECOM   := aGRAVA[ 4 ]
field->PERCLI   := aGRAVA[ 5 ]
field->INTCOM   := PRECOM * 1000
field->INTCLI   := PERCLI * 1000
field->JUNTO    := AllTrim( CODIGO ) + "-" + COGCLI
field->VALORTOT := aGRAVA[ 6 ]
field->mes      := nMES
field->ano      := Nano
field->ordem    := nCONTA + 1
nCONTA++
ENDIF
dbSelectAr( "APURA5" )
dbSkip()
ENDDO

dbSelectAr( "APU5G2" )
FOR W := 1 TO Len( aCLI )
IF aDAD[ W, 3 ] > 1
netrecapp()
field->CLIENTE := aCLI[ W ]
field->COGCLI  := aDAD[ W, 1 ]
field->CODIGO  := aDAD[ W, 2 ]
field->PRECOM  := aDAD[ W, 3 ]
field->PERCLI  := aDAD[ W, 4 ]
field->INTCOM  := PRECOM * 1000
field->INTCLI  := PERCLI * 1000
field->JUNTO   := AllTrim( CODIGO ) + "-" + COGCLI
field->mes     := nMES
field->ano     := Nano
ENDIF
CTLIN++
NEXT W

IF lLISTA4 .AND. sMBS601
nTOTGER := 0
CTLIN   := 80
nLUCRO  := 0
dbSelectAr( "APURA5" )
dbGoTop()
WHILE !Eof()
IF PRECOM > PPCAL
nLUCRO += ( PRECOM - PPCAL ) * QTDDE
ENDIF
dbSkip()
ENDDO
IMPRESSORA()
dbSelectAr( "APURA5" )
dbSetOrder( 1 )  // Codigo Produto
dbGoTop()
WHILE !Eof()
IF CTLIN > 50
@  0, 0   SAY cAE + "MARGEM DE LUCRO POR PRODUTO FORNECIDO - " + cDES
@  1, 0   SAY "M_BS6D "
@  1, 10  SAY "Markup:" + Str( nMARKUP, 5, 2 )
@  1, 60  SAY Time()
@  1, 70  SAY ZDATA
@  2, 00  SAY "Cliente"
@  2, 25  SAY "Produto"
@  2, 41  SAY "Preco"
@  2, 50  SAY "Custo"
@  2, 59  SAY "Icm"
@  2, 65  SAY "Calc"
@  2, 74  SAY "Dif"
@  2, 83  SAY "Dif %"
@  2, 90  SAY "Qtde"
@  2, 102 SAY "Lucro"
@  2, 114 SAY "Luc %"
@  3, 00  SAY repl( "=", 132 )
CTLIN := 4
ENDIF
xPRECO  := ( PRECOM - PPCAL ) * QTDDE
xDIF    := PRECOM - PPCAL
nTOTGER += xPRECO
mDIFLUC := 0
mPERLUC := 0
@ CTLIN, 00 SAY CLIENTE
@ CTLIN, 09 SAY COGCLI
@ CTLIN, 25 SAY Left( CODIGO, 15 )
@ CTLIN, 41 SAY PRECOM          PICT "999.9999"
@ CTLIN, 50 SAY PPLAN           PICT "999.9999"
@ CTLIN, 58 SAY PPLANL
@ CTLIN, 59 SAY ICM             PICT "99.99"
@ CTLIN, 65 SAY PPCAL           PICT "999.9999"
@ CTLIN, 74 SAY xDIF            PICT "999.9999"
IF PPCAL > PRECOM
mDIFLUC := perc( PRECOM, xDIF )
mPERLUC := perc( xPRECO, nLUCRO )
@ CTLIN, 83 SAY mDIFLUC PICT "9999.99"
ELSE
mDIFLUC := perc( xDIF, PRECOM )
mPERLUC := perc( xPRECO, nLUCRO )
@ CTLIN, 83 SAY mDIFLUC PICT "999.99"
ENDIF
@ CTLIN, 90  SAY QTDDE   PICT "@E 9999,999.99"
@ CTLIN, 102 SAY xPRECO  PICT "@E 9999,999.99"
@ CTLIN, 114 SAY mPERLUC PICT "999.99"
field->PERLUC := mPERLUC
field->VALLUC := xPRECO
field->DIFLUC := mDIFLUC
CTLIN++
dbSkip()
ENDDO
@ CTLIN, 0 SAY repl( "=", 132 )
CTLIN++
@ CTLIN, 0  SAY "TOTAL"
@ CTLIN, 95 SAY nTOTGER PICT "@E 9999,999.99"
IMPFOL()
VIDEO()
ENDIF

dbSelectAr( "APURA5" )
dbSetOrder( 4 )
dbGoTop()
FOR X := 1 TO 15
IF !Eof() .AND. PERLUC > 0
mJUNTO  := AllTrim( CODIGO ) + "-" + COGCLI
mPERLUC := PERLUC
dbSelectAr( "APURA5D" )
netrecapp()
field->JUNTO  := mJUNTO
field->PERLUC := mPERLUC
field->INTPER := PERLUC * 1000
dbSelectAr( "APURA5" )
dbSkip()
ENDIF
NEXT X

dbSelectAr( "APURA5" )
dbSetOrder( 5 )
dbGoTop()
FOR X := 1 TO 15
IF !Eof() .AND. DIFLUC > 1
mJUNTO  := AllTrim( CODIGO ) + "-" + COGCLI
mPERDIF := DIFLUC
mINTDIF := DIFLUC * 1000
mCODIGO := CODIGO
mCOGCLI := COGCLI
// NOVOOPA( "APU5G5", .T., .T. )
dbSelectAr( "apu5g5" )
netrecapp()
field->junto  := mJUNTO
field->perdif := mPERDIF
field->intdif := mINTDIF
field->codigo := mCODIGO
field->cogcli := mCOGCLI
field->mes    := nMES
field->ano    := Nano
dbSelectAr( "APURA5" )
dbSkip()
ENDIF
NEXT X
dbCloseAll()

IMPEND()

IF MDG( "Gravar Arquivos Resumos" )
MBS601( "EMP00001\APURA5.DBF", "GRAFICOS\A" + cVAR + ".DBF" )
MBS601( "EMP00001\APURA5A.DBF", "GRAFICOS\A1" + cVAR + ".DBF" )
MBS601( "EMP00001\APURA5D.DBF", "GRAFICOS\A4" + cVAR + ".DBF" )
ENDIF
RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBS601()
// +
// +    Called from ( m_bs6.prg    )   4 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBS601()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBS601( cORI, cDES )

   filecopy( cORI, cDES )
   RETU

// + EOF: M_BS6.PRG

// + EOF: m_bs6.prg
// +
