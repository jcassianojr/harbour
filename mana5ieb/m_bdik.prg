*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIK.PRG
*+
*+    Functions: Function MBDIK02()
*+
*+    Reformatted by Click! 2.03 on Feb-10-2003 at  7:59 am
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"
MDI( "Apura‡„o Pis/Cofins" )

ZFOL      := 1
LIN       := 80
CTLIN     := 80
nTOTOUT   := nTOTISS := 0
nTOTNFE   := nTOTNFS := nTOTIPIE := nTOTIPIS := 0           //Finsocial
nTOTNFE2  := nTOTNFS2 := nTOTIPIE2 := nTOTIPIS2 := 0        //Pis
mTOTNF    := mTOTNF2 := 0
nPPIS     := 0.0165
nEXPORTA  := nATIVO := 0
nEXPORTA2 := nATIVO2 := 0
nMAOOBRA  := nMAOOBRA2 := 0
nPCOFIN   := 0.0300
nAPUSAI   := 0
cPISCON   := "N"
nREDPIS   := 0.6015
cTIPOCAN  := "T"
cAPUNEW   := "S"

aRETU   := PERFEC( { "MK06", "MM06", "MM01", "MK01" }, { "K6", "M6", "M1", "K1" }, { "MK96", "MM96", "MM91", "MK91" } )
ARQENT  := aRETU[ 5, 1 ]
ARQSAI  := aRETU[ 5, 2 ]
ARQMM01 := aRETU[ 5, 3 ]
ARQMK01 := aRETU[ 5, 4 ]
mCOMPETENCIA := aRETU[ 7 ]

@ 18, 00 clea to 24, 79
@ 18, 00 say "Digite o ISS Apurado"
@ 19, 00 say "Outros LEI 9.718/98"
@ 20, 00 say "% PIS"
@ 20, 40 say "% Red PIS"
@ 21, 00 say "% COFINS"
@ 22, 00 say "Checar MP/Co-Entrada"
@ 23, 00 say "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24, 00 say "Apurar CFO Novo"
@ 18, 25 get nTOTISS                                       pict "999999.99"
@ 19, 25 get nTOTOUT                                       pict "999999.99"
@ 20, 25 get nPPIS                                         pict "999.9999"
@ 20, 48 get nREDPIS                                       pict "999.9999"
@ 21, 25 get nPCOFIN                                       pict "999.9999"
@ 22, 25 get cPISCON                                       pict "!"         valid cPISCON $ "SN"
@ 23, 48 get cTIPOCAN                                      pict "!"         valid cTIPOCAN $ "TCN"
@ 24, 40 get cAPUNEW                                       pict "!"         valid cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif


if !CHECKIMP( 0 )
   retu .F.
endif
cAE := IMP( "AE" )

priv wNOME
priv wINSCR
priv wCGC
priv wJUCESPC
priv wJUCESPD
priv wIMUNICI
priv wENDERECO
priv wCIDADE
priv wESTADO
priv wCEP
priv wBAIRRO
pegempmbdi()

if MDG( "Apurar Entrada" )
   MDS( "Aguarde Apurando Entrada" )
   MBDIK02( ARQENT, ARQMK01, "E" )
endif

if MDG( "Apurar Saida" )
   MDS( "Aguarde Apurando Saida" )
   MBDIK02( ARQSAI, ARQMM01, "S" )
endif

@ 10, 00 clea to 24, 00
@ 10, 00 say "Confirme Valores"
@ 10, 01 say "Faturamento/MaoObraPis"
@ 10, 30 get nAPUSAI       pict "@E 999,999,999.99"
@ 10, 50 get nMAOOBRA2     pict "@E 999,999,999.99"
READCUR()

nBASE  := nTOTNFS - nTOTIPIS - abs( nTOTNFE ) + abs( nTOTIPIE ) + nTOTISS + nTOTOUT - nEXPORTA + nATIVO
nBASE2 := nTOTNFS2 - nTOTIPIS2 - abs( nTOTNFE2 ) + abs( nTOTIPIE2 ) + nTOTISS + nTOTOUT - nEXPORTA2 + nATIVO2
nBASERED:=nTOTNFS2-nMAOOBRA2
nBASE3 := round( (nBASERED) * nREDPIS, 2 )
nBASE4 := nBASE2-nBASE3
IMPRESSORA()
@  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S  REF.:"+mCOMPETENCIA+" DATA:"+ DTOC(ZDATA)+ " HORA:"+left(time(),5) +" F.:"+str(ZFOL,4)
@  3,  0  say "APURACAO DOS VALORES DO PIS E COFINS"
@  4,  0  say "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
@  4,  7  say wNOME
@  4, 71  say aRETU[ 7 ]
@  5,  0  say "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
@  5, 11  say wINSCR
@  5, 32  say wCGC
@  5, 62  say wJUCESPC
@  5, 78  say wJUCESPD
@  5, 105 say wIMUNICI
@  6,  0  say "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
@  6, 10  say wENDERECO
@  6, 62  say wCIDADE
@  6, 103 say wESTADO
@  6, 111 say wCEP
@  7,  0  say repl( "-", 132 )
//if lLISTOT
//   @ 10, 01 say "Faturamento"
//   @ 10, 48 say nAPUSAI
//endif
@ 12, 48 say "COFINS"
@ 12, 64 say "PIS"
@ 14, 01 say "(A) Total do Valor Contabil Apurado (Saida)   +"
@ 14, 48 say nTOTNFS                                           pict "@E 99,999,999.99"
@ 14, 62 say nTOTNFS2                                          pict "@E 99,999,999.99"
@ 16, 01 say ACENTO("(B) Total do Valor Presta‡Жo Servi‡o          +")
@ 16, 48 say nTOTISS                                           pict "@E 99,999,999.99"
@ 16, 62 say nTOTISS                                           pict "@E 99,999,999.99"
@ 18, 01 say "(C) Outras Receitas LEI 9.718/98              +"
@ 18, 48 say abs( nTOTOUT )                                    pict "@E 99,999,999.99"
@ 18, 62 say abs( nTOTOUT )                                    pict "@E 99,999,999.99"
@ 20, 01 say "(D) Total Do Valor Do IPI Apurado (Saida)     -"
@ 20, 48 say abs( nTOTIPIS )                                   pict "@E 99,999,999.99"
@ 20, 62 say abs( nTOTIPIS2 )                                  pict "@E 99,999,999.99"
@ 22, 01 say "(E) Total Do Valor Contabil Apurado(Devolucao)-"
@ 22, 48 say abs( nTOTNFE )                                    pict "@E 99,999,999.99"
@ 22, 62 say abs( nTOTNFE2 )                                   pict "@E 99,999,999.99"
@ 24, 01 say "(F) Total Do Valor Do IPI Apurado (Devolucao) +"
@ 24, 48 say abs( nTOTIPIE )                                   pict "@E 99,999,999.99"
@ 24, 62 say abs( nTOTIPIE2 )                                  pict "@E 99,999,999.99"
@ 26, 01 say "(G) Exportacao                                -"
@ 26, 48 say nEXPORTA                                          pict "@E 99,999,999.99"
@ 26, 62 say nEXPORTA2                                         pict "@E 99,999,999.99"
@ 28, 01 say "(H) Ativo                                     +"
@ 28, 48 say nATIVO                                            pict "@E 99,999,999.99"
@ 28, 62 say nATIVO2                                           pict "@E 99,999,999.99"
@ 30, 48 say "_____________________________"
@ 32, 01 say "(I) BASE DE CALCULO (A+B+C-D-E+F-G+H)          "
@ 32, 48 say nBASE                                             pict "@E 99,999,999.99"
@ 32, 62 say nBASE2                                            pict "@E 99,999,999.99"
@ 34, 01 say "(J) COFINS"
@ 34, 30 say str( nPCOFIN * 100 ) + " %"
@ 34, 48 say round( nBASE * nPCOFIN, 2 )                       pict "@E 99,999,999.99"
@ 36, 01 say ACENTO("(K) MЖo de Obra                               -")
@ 36, 48 say nMAOOBRA                                          pict "@E 99,999,999.99"
@ 36, 62 say nMAOOBRA2                                         pict "@E 99,999,999.99"
@ 38, 01 say "(L) BASE DE REDUCAO PIS  (A-K)"
@ 38, 62 say nBASERED                                            pict "@E 99,999,999.99"
@ 40, 01 say "(M) REDUCAO BASE PIS"
@ 40, 30 say str( nREDPIS * 100 ) + " %"
@ 40, 62 say nBASE3                                            pict "@E 99,999,999.99"
@ 42, 01 say "(N) BASE PIS (I-M)"
@ 42, 62 say nBASE4                                            pict "@E 99,999,999.99"
@ 44, 01 say "(O) PIS"
@ 44, 30 say str( nPPIS * 100 ) + " %"
@ 44, 62 say round( nBASE4 * nPPIS, 2 )                        pict "@E 99,999,999.99"
@ 46, 00 say repl( "-", 80 )
CTLIN := 45
//FECFOL()
VIDEO()
IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDIK02()
*+
*+    Called from ( m_bdik.prg   )   2 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDIK02( cARQ, cARQNF, cTIPO )

aUFE := {}
if MDG( "Especificar Grupo Clientes/Fornecedores" )
   nNUMERO := 0
   @ 24, 00 say "Cliente No."
   @ 24, 60 say "Esc ou 0 para encerrar"
   while .T.
      @ 24, 20 get nNUMERO
      if !READCUR()
         exit
      endif
      if empty( nNUMERO )
         exit
      endif
      aadd( aUFE, nNUMERO )
   enddo
   if empty( aUFE )
      ALERTX( "Grupo NЖo Especificado" )
   endif
   FILTRO := "FORNECEDO=" + alltrim( str( aUFE[ 1 ] ) )
   for X := 2 to len( aUFE )
      FILTRO += ".OR.FORNECEDO=" + alltrim( str( aUFE[ X ] ) )
   next
else
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
endif

if !USEMULT( { { "MD04", 1, if( cAPUNEW = "N", 3, 2 ) }, { cARQ, 1, 0 }, { cARQNF, 1, 1 } } )
   retu .F.
endif
dbselectar( cARQ )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if cAPUNEW = "N"
   ordDestroy("temp")
   ordcreate(,"temp","DOPER")
   ordSetFocus("temp")
else
   ordDestroy("temp")
   ordcreate(,"temp","DCFONEW")
   ordSetFocus("temp")
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
while !eof()
   xDOPER  := if( cAPUNEW = "N", DOPER, DCFONEW )
   lPISCRE := lPISDEB := lPISEXP := lPISATI:= lPISMAO := .F.
   lFINCRE := lFINDEB := lFINEXP := lFINATI:= lFINMAO := .F.
   dbselectar( "MD04" )
   dbgotop()
   if dbseek( xDOPER )
      lPISCRE := if( PIS = "+".OR.PIS="M", .T., .F. )
      lPISDEB := if( PIS = "-", .T., .F. )
      lPISEXP := if( PIS = "E", .T., .F. )
      lPISATI := if( PIS = "A", .T., .F. )
      lPISMAO := if( PIS = "M", .T., .F. )
      lFINCRE := if( FIN = "+".OR.FIN="M", .T., .F. )
      lFINDEB := if( FIN = "-", .T., .F. )
      lFINEXP := if( FIN = "E", .T., .F. )
      lFINATI := if( FIN = "A", .T., .F. )
      lFINMAO := if( FIN = "M", .T., .F. )
   endif
   dbselectar( carq )
   while xDOPER = if( cAPUNEW = "N", DOPER, DCFONEW ) .and. !eof()
      if SOMACANCEL()
         @ 24, 00 say NUMERO
         if cTIPO = "S"
            mNUMERO := NUMERO
            lSOMANF := .F.
            dbselectar( carqNF )
            dbgotop()
            if dbseek( mNUMERO )
               if APURA # "N"
                  lSOMANF := .T.
               endif
            endif
            dbselectar( carq )
         endif
         if lFINCRE
            mTOTNF += DVALORNF
            if cTIPO = "E"
               nTOTNFE  += DVALORNF
               nTOTIPIE += DVALIPI
            endif
            if cTIPO = "S"
               nTOTNFS  += DVALORNF
               nTOTIPIS += DVALIPI
            endif
         endif
         if lFINDEB
            mTOTNF -= DVALORNF
            if cTIPO = "E"
               nTOTNFE  -= DVALORNF
               nTOTIPIE -= DVALIPI
            endif
            if cTIPO = "S"
               nTOTNFS  -= DVALORNF
               nTOTIPIS -= DVALIPI
            endif
         endif
         if lFINEXP
            nEXPORTA += DVALORNF
         endif
         if lFINMAO
            nMAOOBRA += DVALORNF
         endif
         if lFINATI
            nATIVO += DVALORNF
         endif
         if lPISCRE
            mTOTNF2 += DVALORNF
            if cTIPO = "E"
               nTOTNFE2  += DVALORNF
               nTOTIPIE2 += DVALIPI
            endif
            if cTIPO = "S"
               nTOTNFS2  += DVALORNF
               nTOTIPIS2 += DVALIPI
            endif
         endif
         if lPISDEB
            mTOTNF2 -= DVALORNF
            if cTIPO = "E"
               nTOTNFE2  -= DVALORNF
               nTOTIPIE2 -= DVALIPI
            endif
            if cTIPO = "S"
               nTOTNFS2  -= DVALORNF
               nTOTIPIS2 -= DVALIPI
            endif
         endif
         if lPISEXP
            nEXPORTA2 += DVALORNF
         endif
         if lPISMAO
            nMAOOBRA2 += DVALORNF
         endif
         if lPISATI
            nATIVO2 += DVALORNF
         endif
         if cTIPO = "S" .and. lSOMANF
            nAPUSAI += DVALORNF
         endif
      endif
      dbskip()
   enddo
   dbselectar( cARQ )
enddo
dbcloseall()

*+ EOF: M_BDIK.PRG
