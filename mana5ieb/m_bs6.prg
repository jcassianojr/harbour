*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BS6.PRG
*+
*+    Functions: Function MBS601()
*+
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"
MDI( " Э Resumo de Vendas" )

//Verificando a Impressora
if !CHECKIMP( 0 )
   return .F.
endif
cAE := IMP( "AE" )

nANO    := 0
nMES    := 0
nMARKUP := 12.95
MDS( "Confirme Markup sem Icms" )
@ 24, 30 get nMARKUP
if !READCUR()
   retu .f.
endif

sMBS601 := SENHAX( "MBS601" )

aGRUPO := {}
aGRUPV := {}
if !USEREDE( "MD02", 1, 1 )
   dbcloseall()
endif
dbgotop()
dbseek( "GRUPOEMP" )
while alltrim( CODIGO ) = "GRUPOEMP" .and. !eof()
   if VARIACAO = 1
      aadd( aGRUPO, CODIGO1 )
      aadd( aGRUPV, { 0, 0, 0, if( VALOR = 1, .T., .F. ) } )                    //4=Exportacao
   endif
   dbskip()
enddo
dbclosearea()

lLISTA1 := MDG( "Listar Resumo Fornecimento Produtos" )
lLISTA4 := MDG( "Listar Resumo Margem de Lucros" )

cDES  := "Atual"
cVAR  := "ATU"
ARQNF := ""

aRETU   := PERFEC( { "MM02" }, { "M2" }, { "MM92" } )
ARQNF   := aRETU[ 5, 1 ]
cDES    := aRETU[ 7 ]
cVAR    := aRETU[ 4 ] + aRETU[ 3 ]
nMES    := aRETU[ 1 ]
nANO    := aRETU[ 2 ]

if !USEMULT( { { "MA01", 1, 1 }, { "MS01P", 1, 1 }, { "MS01", 1, 1 }, { "MD05", 1, 1 }, { "APURA5", 0, 99 }, ;
               { "APURA5A", 0, 99 }, { "APU5G2", 0, 99 }, { "APU5G3", 0, 99 }, ;
               { "APURA5D", 0, 0 }, { "APU5G5", 0, 99 } } )
   retu .F.
endif

FILTRA := RFILORD( "MM02", .F. )
if !USEREDE( ARQNF, 1, 0 )
   dbcloseall()
   retu .F.
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","str( FORNECEDO, 8 ) + CODIGO")
ordSetFocus("temp")


set filter to &FILTRA
dbgotop()

dbselectar( "APURA5" )
zap
dbselectar( "APURA5A" )
zap

dbselectar( "APU5G2" )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DBEVAL({|| netrecdel()},{||MES = nMES .and. ANO = nANO}, {|| zei_fort(nLASTREC,,,1)})

dbselectar( "APU5G3" )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DBEVAL({|| netrecdel()},{||MES = nMES .and. ANO = nANO}, {|| zei_fort(nLASTREC,,,1)})

dbselectar( "APURA5D" )
zap

dbselectar( "APU5G5" )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DBEVAL({|| netrecdel()},{||MES = nMES .and. ANO = nANO}, {|| zei_fort(nLASTREC,,,1)})


dbselectar( "MA01" )
dbgotop()
while !eof()
   mFORNECEDO := NUMERO
   mCOGNOME   := COGNOME
   mGRUPO     := GRUPOEMP
   mESTADO    := ESTADO
   mSUBGER    := SUBGER
   mICM       := 0
   @ 24, 00 say NUMERO
   @ 24, 10 say COGNOME
   dbselectar( "MD05" )
   dbgotop()
   if dbseek( mESTADO )
      mICM := ALIQUOTA
   endif
   dbselectar( ARQNF )
   dbgotop()
   dbseek( str( mFORNECEDO, 8 ) )
   if FORNECEDO # mFORNECEDO
      dbselectar( "MA01" )
      dbskip()
      loop
   endif
   dbselectar( ARQNF )
   while mFORNECEDO = FORNECEDO .and. !eof()
      @ 24, 40 say CODIGO
      mCODIGO   := CODIGO
      mTIPOSERV := ""
      nQTDE     := 0
      nPRECOM   := 0
      nPRECOT   := 0
      while mFORNECEDO = FORNECEDO .and. CODIGO = mCODIGO .and. !eof()
        IF TIPOENT="P".AND.(TIPOSERV="1".OR.TIPOSERV="3").AND.APURA#"N" ;
           .and.ESPECIE#"NFC"
//         if left( OPERACAO, 3 ) # "593" .and. left( OPERACAO, 3 ) # "693" ;
//                  .and. APURA # "N" .and. ESPECIE # "NFC" ;
//                  .and. TIPOSERV # "2" .and. TIPOENT = "P"  //Tiposerv 2 Ferramental
            nQTDE   += CONVUN( QTDE, UNID )
            nPRECOM += VALORMER
            nPRECOT += VALORTOT
         endif
         dbselectar( ARQNF )
         dbskip()
      enddo
      mNOME  := ""
      mPARTI := 0
      mPPLAN := 0
      if nQTDE > 0 .and. !empty( mCODIGO ) ;
                 .and. left( mCODIGO, 4 ) <> "LENG" ;
                 .and. left( mCODIGO, 5 ) <> "6600 " ;
                 .and. left( mCODIGO, 6 ) <> "6950 "
         //LENG 6600 6950 Prototipo
         dbselectar( "MS01" )
         dbgotop()
         if dbseek( mCODIGO )
            mNOME  := alltrim( NOME )
            mPARTI := PARTI
            mPPLAN := PPLAN
         endif
         dbselectar( "MS01P" )
         dbgotop()
         if dbseek( padr( mCODIGO, 24 ) + str( mFORNECEDO, 5 ) )
            mPPLAN := PPLAN
         endif
         dbselectar( "APURA5" )
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
         field->PRECOM   := round( VALORMER / QTDDE, 4 )
         field->PPLAN    := if( empty( mPPLAN ), PRECOM * .9, mPPLAN )
         field->PPLANL   := if( empty( mPPLAN ), "*", " " )
         field->ICM      := mICM
         field->PPCAL    := PPLAN + ( PRECOM * ( nMARKUP + ICM ) / 100 )
      endif
      dbselectar( ARQNF )
   enddo
   dbselectar( "MA01" )
   dbskip()
enddo

dbselectar( ARQNF )
dbclosearea()
nGERAL := 0
dbselectar( "APURA5" )
dbgotop()
while !eof()
   nGERAL += VALORTOT
   dbskip()
enddo
dbgotop()
while !eof()
   @ 24, 60 say perc( VALORTOT, nGERAL )
   field->PERCLI := perc( VALORTOT, nGERAL )
   dbskip()
enddo
dbselectar( "APURA5" )
dbgotop()
while !eof()
   mCLIENTE := CLIENTE
   mCOGNOME := COGCLI
   mGRUPO   := GRUPO
   mSUBGER  := SUBGER
   mNOME    := ""
   nVAL     := 0
   mTGRUPO  := ""
   dbselectar( "APURA5" )
   while mCLIENTE = CLIENTE .and. !eof()
      nVAL += VALORTOT
      dbskip()
   enddo
   if !empty( mGRUPO )
      nPOS := ascan( aGRUPO, alltrim( mGRUPO ) )
      if nPOS > 0
         aGRUPV[ nPOS, 1 ] += nVAL
         aGRUPV[ nPOS, 2 ] += perc( nVAL, nGERAL )
         aGRUPV[ nPOS, 3 ] = aGRUPV[ nPOS, 2 ] * 1000
         mTGRUPO := "S"
      endif
   endif
   NOVOOPA( "APURA5A", .F., .F. )
   field->CLIENTE  := mCLIENTE
   field->COGCLI   := mCOGNOME
   field->VALORTOT := nVAL
   field->PERCLI   := perc( nVAL, nGERAL )
   field->INTPERC  := PERCLI * 1000
   field->TGRUPO   := mTGRUPO
   field->SUBGER   := mSUBGER
   dbselectar( "APURA5" )
enddo
dbselectar( "APURA5A" )
for W := 1 to len( aGRUPO )
   if aGRUPV[ W, 1 ] > 0
      NOVOOPA(, .F., .F. )
      field->CLIENTE  := 99990000 + W
      field->COGCLI   := aGRUPO[ W ]
      field->VALORTOT := aGRUPV[ W, 1 ]
      field->PERCLI   := aGRUPV[ W, 2 ]
      field->INTPERC  := aGRUPV[ W, 3 ]
      field->VALOREXP := if( aGRUPV[ W, 4 ], VALORTOT, 0 )
   endif
next W

if lLISTA1
   FILTROA := ""
   FILTROA := RFILORD( "MA01", .F., FILTROA )
   IMPRESSORA()
   dbselectar( "MA01" )
   if !empty( FILTROA )
      set filter to &FILTROA
   endif
   dbgotop()
   while !eof()
      CTLIN    := 80
      mCLIENTE := NUMERO
      mNOMECLI := NOME
      mCLIPER  := 0
      mTOTCLI  := 0
      aTOT     := { 0, 0, 0 }
      dbselectar( "APURA5A" )
      dbgotop()
      if dbseek( mCLIENTE )
         mCLIPER := PERCLI
         mTOTCLI := VALORTOT
      endif
      dbselectar( "APURA5" )
      dbgotop()
      dbseek( str( mCLIENTE, 8 ) )
      while mCLIENTE = CLIENTE .and. !eof()
         if CTLIN > 55
            @  0,  0  say cAE + "RELATORIO MENSAL - FORNECIMENTO IEB - " + cDES
            @  1,  0  say "M_BS6A "
            @  1, 60  say time()
            @  1, 70  say ZDATA
            @  2, 00  say cAE + str( mCLIENTE )
            @  2,  9  say left( mNOMECLI, 40 )
            @  2, 50  say mCLIPER                                               pict "999.99"
            @  3, 00  say "Codigo"
            @  3, 25  say "Descri‡„o"
            @  3, 57  say "Fatia"
            @  3, 69  say "Qtde"
            @  3, 74  say "Total Merc."
            @  3, 86  say "Preco"
            @  3, 99  say "Total NF"
            @  3, 109 say "% FAT"
            @  3, 116 say "% CLI"
            @  4, 00  say repl( "=", 132 )
            CTLIN := 5
         endif
         @ CTLIN,  0 say CODIGO
         @ CTLIN, 25 say left( NOME, 30 )
         @ CTLIN, 56 say PARTI            pict "999.99"
         @ CTLIN, 63 say QTDDE            pict "@E 99,999,999"
         if sMBS601
            @ CTLIN, 74  say VALORMER                  pict "@E 9999,999.99"
            @ CTLIN, 85  say PRECOM                    pict "@E 999.99"
            @ CTLIN, 96  say VALORTOT                  pict "@E 9999,999.99"
            @ CTLIN, 108 say PERCLI                    pict "@E 999.99"
            @ CTLIN, 115 say perc( VALORTOT, mTOTCLI ) pict "@E 999.99"
         endif
         aTOT[ 1 ] += QTDDE
         aTOT[ 2 ] += VALORMER
         aTOT[ 3 ] += VALORTOT
         CTLIN ++
         dbskip()
      enddo
      if aTOT[ 1 ] > 0
         @ CTLIN,  0 say "TOTAL GERAL:"
         @ CTLIN, 63 say aTOT[ 1 ]      pict "@E 99,999,999"
         if sMBS601
            @ CTLIN, 74 say aTOT[ 2 ] pict "@E 9999,999.99"
            @ CTLIN, 96 say aTOT[ 3 ] pict "@E 9999,999.99"
         endif
      endif
      dbselectar( "MA01" )
      dbskip()
   enddo
   VIDEO()
endif

nGERAL := 0
nEXPOR := 0
dbselectar( "APURA5A" )
dbgotop()
while !eof()
   mCLIENTE := CLIENTE
   mNOME    := ""
   dbselectar( "MA01" )
   dbgotop()
   if dbseek( mCLIENTE )
      mNOME := left( NOME, 40 )
   endif
   dbselectar( "APURA5A" )
   if mCLIENTE < 9999000
      nGERAL += VALORTOT
   else
      nEXPOR += VALOREXP
   endif
   dbskip()
enddo
if nGERAL > 0
   if !empty( nANO ) .and. !empty( nMES )
      if !VERSEHA( "APU5TOT", str( nANO, 4 ) + str( nMES, 2 ) )
         mANO      := nANO
         mMES      := nMES
         mVALORTOT := nGERAL
         mVALOREXP := nEXPOR
         mJUNTO    := strzero( nMES, 2 ) + "/" + right( strzero( nANO, 4 ), 2 )
         NOVOREG( "APU5TOT", str( nANO, 4 ) + str( nMES, 2 ) )
      else
         GRAVAMVAR( "APU5TOT", str( nANO, 4 ) + str( nMES, 2 ), { "VALORTOT", "VALOREXP" }, { "nGERAL", "nEXPOR" } )
      endif
   endif
endif

nCONTA := 0
aCLI   := {}
aDAD   := {}
dbselectar( "APURA5" )
dbsetorder( 2 )
dbgotop()
while !eof()
   mCLIENTE := CLIENTE
   mCLIPER  := 0
   mTOTCLI  := 0
   dbselectar( "APURA5A" )
   dbgotop()
   if dbseek( mCLIENTE )
      mCLIPER := PERCLI
      mTOTCLI := VALORTOT
   endif
   dbselectar( "APURA5" )
   field->CLITOTPER := mCLIPER
   field->CLITOTVAL := mTOTCLI
   nPOS             := ascan( aCLI, CLIENTE )
   if nPOS = 0
      aadd( aCLI, CLIENTE )
      aadd( aDAD, { COGCLI, left( CODIGO, 30 ), PERCLI, perc( VALORTOT, mTOTCLI ), VALORTOT } )
   endif
   if PERCLI >= 1 .and. nCONTA < 15
      aGRAVA := { CLIENTE, COGCLI, CODIGO, PERCLI, perc( VALORTOT, mTOTCLI ), VALORTOT }
      dbselectar( "APU5G3" )
      netrecapp()
      field->CLIENTE  := aGRAVA[ 1 ]
      field->COGCLI   := aGRAVA[ 2 ]
      field->CODIGO   := aGRAVA[ 3 ]
      field->PRECOM   := aGRAVA[ 4 ]
      field->PERCLI   := aGRAVA[ 5 ]
      field->INTCOM   := PRECOM * 1000
      field->INTCLI   := PERCLI * 1000
      field->JUNTO    := alltrim( CODIGO ) + "-" + COGCLI
      field->VALORTOT := aGRAVA[ 6 ]
      field->mes      := nMES
      field->ano      := Nano
      field->ordem    := nCONTA + 1
      nCONTA ++
   endif
   dbselectar( "APURA5" )
   dbskip()
enddo

dbselectar( "APU5G2" )
for W := 1 to len( aCLI )
   if aDAD[ W, 3 ] > 1
      netrecapp()
      field->CLIENTE := aCLI[ W ]
      field->COGCLI  := aDAD[ W, 1 ]
      field->CODIGO  := aDAD[ W, 2 ]
      field->PRECOM  := aDAD[ W, 3 ]
      field->PERCLI  := aDAD[ W, 4 ]
      field->INTCOM  := PRECOM * 1000
      field->INTCLI  := PERCLI * 1000
      field->JUNTO   := alltrim( CODIGO ) + "-" + COGCLI
      field->mes    := nMES
      field->ano    := Nano
   endif
   CTLIN ++
next W

if lLISTA4 .and. sMBS601
   nTOTGER := 0
   CTLIN   := 80
   nLUCRO  := 0
   dbselectar( "APURA5" )
   dbgotop()
   while !eof()
      if PRECOM > PPCAL
         nLUCRO += ( PRECOM - PPCAL ) * QTDDE
      endif
      dbskip()
   enddo
   IMPRESSORA()
   dbselectar( "APURA5" )
   dbsetorder( 1 )  //Codigo Produto
   dbgotop()
   while !eof()
      if CTLIN > 50
         @  0,  0  say cAE + "MARGEM DE LUCRO POR PRODUTO FORNECIDO - " + cDES
         @  1,  0  say "M_BS6D "
         @  1, 10  say "Markup:" + str( nMARKUP, 5, 2 )
         @  1, 60  say time()
         @  1, 70  say ZDATA
         @  2, 00  say "Cliente"
         @  2, 25  say "Produto"
         @  2, 41  say "Preco"
         @  2, 50  say "Custo"
         @  2, 59  say "Icm"
         @  2, 65  say "Calc"
         @  2, 74  say "Dif"
         @  2, 83  say "Dif %"
         @  2, 90  say "Qtde"
         @  2, 102 say "Lucro"
         @  2, 114 say "Luc %"
         @  3, 00  say repl( "=", 132 )
         CTLIN := 4
      endif
      xPRECO  := ( PRECOM - PPCAL ) * QTDDE
      xDIF    := PRECOM - PPCAL
      nTOTGER += xPRECO
      mDIFLUC := 0
      mPERLUC := 0
      @ CTLIN, 00 say CLIENTE
      @ CTLIN, 09 say COGCLI
      @ CTLIN, 25 say left( CODIGO, 15 )
      @ CTLIN, 41 say PRECOM             pict "999.9999"
      @ CTLIN, 50 say PPLAN              pict "999.9999"
      @ CTLIN, 58 say PPLANL
      @ CTLIN, 59 say ICM                pict "99.99"
      @ CTLIN, 65 say PPCAL              pict "999.9999"
      @ CTLIN, 74 say xDIF               pict "999.9999"
      if PPCAL > PRECOM
         mDIFLUC := perc( PRECOM, xDIF )
         mPERLUC := perc( xPRECO, nLUCRO )
         @ CTLIN, 83 say mDIFLUC pict "9999.99"
      else
         mDIFLUC := perc( xDIF, PRECOM )
         mPERLUC := perc( xPRECO, nLUCRO )
         @ CTLIN, 83 say mDIFLUC pict "999.99"
      endif
      @ CTLIN, 90  say QTDDE   pict "@E 9999,999.99"
      @ CTLIN, 102 say xPRECO  pict "@E 9999,999.99"
      @ CTLIN, 114 say mPERLUC pict "999.99"
      field->PERLUC := mPERLUC
      field->VALLUC := xPRECO
      field->DIFLUC := mDIFLUC
      CTLIN ++
      dbskip()
   enddo
   @ CTLIN,  0 say repl( "=", 132 )
   CTLIN ++
   @ CTLIN,  0 say "TOTAL"
   @ CTLIN, 95 say nTOTGER pict "@E 9999,999.99"
   IMPFOL()
   VIDEO()
endif

dbselectar( "APURA5" )
dbsetorder( 4 )
dbgotop()
for X := 1 to 15
   if !eof() .and. PERLUC > 0
      mJUNTO  := alltrim( CODIGO ) + "-" + COGCLI
      mPERLUC := PERLUC
      dbselectar( "APURA5D" )
      netrecapp()
      field->JUNTO  := mJUNTO
      field->PERLUC := mPERLUC
      field->INTPER := PERLUC * 1000
      dbselectar( "APURA5" )
      dbskip()
   endif
next X

dbselectar( "APURA5" )
dbsetorder( 5 )
dbgotop()
for X := 1 to 15
   if !eof() .and. DIFLUC > 1
      mJUNTO  := alltrim( CODIGO ) + "-" + COGCLI
      mPERDIF := DIFLUC
      mINTDIF := DIFLUC * 1000
      mCODIGO := CODIGO
      mCOGCLI := COGCLI
      //NOVOOPA( "APU5G5", .T., .T. )
      dbselectar( "apu5g5" )
      netrecapp()
      field->junto  := mJUNTO
      field->perdif := mPERDIF
      field->intdif := mINTDIF
      field->codigo := mCODIGO
      field->cogcli := mCOGCLI
      field->mes    := nMES
      field->ano    := Nano
      dbselectar( "APURA5" )
      dbskip()
   endif
next X
dbcloseall()

IMPEND()

if MDG( "Gravar Arquivos Resumos" )
   MBS601( "EMP00001\APURA5.DBF", "GRAFICOS\A" + cVAR + ".DBF" )
   MBS601( "EMP00001\APURA5A.DBF", "GRAFICOS\A1" + cVAR + ".DBF" )
   MBS601( "EMP00001\APURA5D.DBF", "GRAFICOS\A4" + cVAR + ".DBF" )
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBS601()
*+
*+    Called from ( m_bs6.prg    )   4 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBS601( cORI, cDES )

filecopy(cORI,cDES)
retu

*+ EOF: M_BS6.PRG
