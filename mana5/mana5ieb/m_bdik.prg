// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdik.prg
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
// +    Source Module => J:\ITAESBRA\M_BDIK.PRG
// +
// +    Functions: Function MBDIK02()
// +
// +    Reformatted by Click! 2.03 on Feb-10-2003 at  7:59 am
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"
MDI( "Apura‡„o Pis/Cofins" )

ZFOL      := 1
LIN       := 80
CTLIN     := 80
nTOTOUT   := nTOTISS := 0
nTOTNFE   := nTOTNFS := nTOTIPIE := nTOTIPIS := 0   // Finsocial
nTOTNFE2  := nTOTNFS2 := nTOTIPIE2 := nTOTIPIS2 := 0  // Pis
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

aRETU        := PERFEC( { "MK06", "MM06", "MM01", "MK01" }, { "K6", "M6", "M1", "K1" }, { "MK96", "MM96", "MM91", "MK91" } )
ARQENT       := aRETU[ 5, 1 ]
ARQSAI       := aRETU[ 5, 2 ]
ARQMM01      := aRETU[ 5, 3 ]
ARQMK01      := aRETU[ 5, 4 ]
mCOMPETENCIA := aRETU[ 7 ]

@ 18, 00 CLEA TO 24, 79
@ 18, 00 SAY "Digite o ISS Apurado"
@ 19, 00 SAY "Outros LEI 9.718/98"
@ 20, 00 SAY "% PIS"
@ 20, 40 SAY "% Red PIS"
@ 21, 00 SAY "% COFINS"
@ 22, 00 SAY "Checar MP/Co-Entrada"
@ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24, 00 SAY "Apurar CFO Novo"
@ 18, 25 GET nTOTISS                                       PICT "999999.99"
@ 19, 25 GET nTOTOUT                                       PICT "999999.99"
@ 20, 25 GET nPPIS                                         PICT "999.9999"
@ 20, 48 GET nREDPIS                                       PICT "999.9999"
@ 21, 25 GET nPCOFIN                                       PICT "999.9999"
@ 22, 25 GET cPISCON                                       PICT "!"         VALID cPISCON $ "SN"
@ 23, 48 GET cTIPOCAN                                      PICT "!"         VALID cTIPOCAN $ "TCN"
@ 24, 40 GET cAPUNEW                                       PICT "!"         VALID cAPUNEW $ "SN"
IF !READCUR()
RETU .F.
ENDIF


IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cAE := IMP( "AE" )

PRIV wNOME
PRIV wINSCR
PRIV wCGC
PRIV wJUCESPC
PRIV wJUCESPD
PRIV wIMUNICI
PRIV wENDERECO
PRIV wCIDADE
PRIV wESTADO
PRIV wCEP
PRIV wBAIRRO
pegempmbdi()

IF MDG( "Apurar Entrada" )
MDS( "Aguarde Apurando Entrada" )
MBDIK02( ARQENT, ARQMK01, "E" )
ENDIF

IF MDG( "Apurar Saida" )
MDS( "Aguarde Apurando Saida" )
MBDIK02( ARQSAI, ARQMM01, "S" )
ENDIF

@ 10, 00 CLEA TO 24, 00
@ 10, 00 SAY "Confirme Valores"
@ 10, 01 SAY "Faturamento/MaoObraPis"
@ 10, 30 GET nAPUSAI                  PICT "@E 999,999,999.99"
@ 10, 50 GET nMAOOBRA2                PICT "@E 999,999,999.99"
READCUR()

nBASE    := nTOTNFS - nTOTIPIS - Abs( nTOTNFE ) + Abs( nTOTIPIE ) + nTOTISS + nTOTOUT - nEXPORTA + nATIVO
nBASE2   := nTOTNFS2 - nTOTIPIS2 - Abs( nTOTNFE2 ) + Abs( nTOTIPIE2 ) + nTOTISS + nTOTOUT - nEXPORTA2 + nATIVO2
nBASERED := nTOTNFS2 - nMAOOBRA2
nBASE3   := Round( ( nBASERED ) * nREDPIS, 2 )
nBASE4   := nBASE2 - nBASE3
IMPRESSORA()
@  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S  REF.:" + mCOMPETENCIA + " DATA:" + DToC( ZDATA ) + " HORA:" + Left( Time(), 5 ) + " F.:" + Str( ZFOL, 4 )
@  3, 0   SAY "APURACAO DOS VALORES DO PIS E COFINS"
@  4, 0   SAY "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
@  4, 7   SAY wNOME
@  4, 71  SAY aRETU[ 7 ]
@  5, 0   SAY "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
@  5, 11  SAY wINSCR
@  5, 32  SAY wCGC
@  5, 62  SAY wJUCESPC
@  5, 78  SAY wJUCESPD
@  5, 105 SAY wIMUNICI
@  6, 0   SAY "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
@  6, 10  SAY wENDERECO
@  6, 62  SAY wCIDADE
@  6, 103 SAY wESTADO
@  6, 111 SAY wCEP
@  7, 0   SAY repl( "-", 132 )
// if lLISTOT
// @ 10, 01 say "Faturamento"
// @ 10, 48 say nAPUSAI
// endif
@ 12, 48 SAY "COFINS"
@ 12, 64 SAY "PIS"
@ 14, 01 SAY "(A) Total do Valor Contabil Apurado (Saida)   +"
@ 14, 48 SAY nTOTNFS                                                   PICT "@E 99,999,999.99"
@ 14, 62 SAY nTOTNFS2                                                  PICT "@E 99,999,999.99"
@ 16, 01 SAY ACENTO( "(B) Total do Valor Presta‡Жo Servi‡o          +" )
@ 16, 48 SAY nTOTISS                                                   PICT "@E 99,999,999.99"
@ 16, 62 SAY nTOTISS                                                   PICT "@E 99,999,999.99"
@ 18, 01 SAY "(C) Outras Receitas LEI 9.718/98              +"
@ 18, 48 SAY Abs( nTOTOUT )                                              PICT "@E 99,999,999.99"
@ 18, 62 SAY Abs( nTOTOUT )                                              PICT "@E 99,999,999.99"
@ 20, 01 SAY "(D) Total Do Valor Do IPI Apurado (Saida)     -"
@ 20, 48 SAY Abs( nTOTIPIS )                                             PICT "@E 99,999,999.99"
@ 20, 62 SAY Abs( nTOTIPIS2 )                                            PICT "@E 99,999,999.99"
@ 22, 01 SAY "(E) Total Do Valor Contabil Apurado(Devolucao)-"
@ 22, 48 SAY Abs( nTOTNFE )                                              PICT "@E 99,999,999.99"
@ 22, 62 SAY Abs( nTOTNFE2 )                                             PICT "@E 99,999,999.99"
@ 24, 01 SAY "(F) Total Do Valor Do IPI Apurado (Devolucao) +"
@ 24, 48 SAY Abs( nTOTIPIE )                                             PICT "@E 99,999,999.99"
@ 24, 62 SAY Abs( nTOTIPIE2 )                                            PICT "@E 99,999,999.99"
@ 26, 01 SAY "(G) Exportacao                                -"
@ 26, 48 SAY nEXPORTA                                                  PICT "@E 99,999,999.99"
@ 26, 62 SAY nEXPORTA2                                                 PICT "@E 99,999,999.99"
@ 28, 01 SAY "(H) Ativo                                     +"
@ 28, 48 SAY nATIVO                                                    PICT "@E 99,999,999.99"
@ 28, 62 SAY nATIVO2                                                   PICT "@E 99,999,999.99"
@ 30, 48 SAY "_____________________________"
@ 32, 01 SAY "(I) BASE DE CALCULO (A+B+C-D-E+F-G+H)          "
@ 32, 48 SAY nBASE                                                     PICT "@E 99,999,999.99"
@ 32, 62 SAY nBASE2                                                    PICT "@E 99,999,999.99"
@ 34, 01 SAY "(J) COFINS"
@ 34, 30 SAY Str( nPCOFIN * 100 ) + " %"
@ 34, 48 SAY Round( nBASE * nPCOFIN, 2 )                                  PICT "@E 99,999,999.99"
@ 36, 01 SAY ACENTO( "(K) MЖo de Obra                               -" )
@ 36, 48 SAY nMAOOBRA                                                  PICT "@E 99,999,999.99"
@ 36, 62 SAY nMAOOBRA2                                                 PICT "@E 99,999,999.99"
@ 38, 01 SAY "(L) BASE DE REDUCAO PIS  (A-K)"
@ 38, 62 SAY nBASERED                                                  PICT "@E 99,999,999.99"
@ 40, 01 SAY "(M) REDUCAO BASE PIS"
@ 40, 30 SAY Str( nREDPIS * 100 ) + " %"
@ 40, 62 SAY nBASE3                                                    PICT "@E 99,999,999.99"
@ 42, 01 SAY "(N) BASE PIS (I-M)"
@ 42, 62 SAY nBASE4                                                    PICT "@E 99,999,999.99"
@ 44, 01 SAY "(O) PIS"
@ 44, 30 SAY Str( nPPIS * 100 ) + " %"
@ 44, 62 SAY Round( nBASE4 * nPPIS, 2 )                                   PICT "@E 99,999,999.99"
@ 46, 00 SAY repl( "-", 80 )
CTLIN := 45
// FECFOL()
VIDEO()
IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDIK02()
// +
// +    Called from ( m_bdik.prg   )   2 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDIK02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBDIK02( cARQ, cARQNF, cTIPO )

   aUFE := {}
   IF MDG( "Especificar Grupo Clientes/Fornecedores" )
      nNUMERO := 0
      @ 24, 00 SAY "Cliente No."
      @ 24, 60 SAY "Esc ou 0 para encerrar"
      WHILE .T.
         @ 24, 20 GET nNUMERO
         IF !READCUR()
            EXIT
         ENDIF
         IF Empty( nNUMERO )
            EXIT
         ENDIF
         AAdd( aUFE, nNUMERO )
      ENDDO
      IF Empty( aUFE )
         ALERTX( "Grupo NЖo Especificado" )
      ENDIF
      FILTRO := "FORNECEDO=" + AllTrim( Str( aUFE[ 1 ] ) )
      FOR X := 2 TO Len( aUFE )
         FILTRO += ".OR.FORNECEDO=" + AllTrim( Str( aUFE[ X ] ) )
      NEXT
   ELSE
      FILTRO := ''
      FILTRO := RFILORD( cARQ, .F. )
   ENDIF

   IF !USEMULT( { { "MD04", 1, if( cAPUNEW = "N", 3, 2 ) }, { cARQ, 1, 0 }, { cARQNF, 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( cARQ )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cAPUNEW = "N"
      ordDestroy( "temp" )
      ordCreate(, "temp", "DOPER" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "DCFONEW" )
      ordSetFocus( "temp" )
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      xDOPER  := if( cAPUNEW = "N", DOPER, DCFONEW )
      lPISCRE := lPISDEB := lPISEXP := lPISATI := lPISMAO := .F.
      lFINCRE := lFINDEB := lFINEXP := lFINATI := lFINMAO := .F.
      dbSelectAr( "MD04" )
      dbGoTop()
      IF dbSeek( xDOPER )
         lPISCRE := if( PIS = "+" .OR. PIS = "M", .T., .F. )
         lPISDEB := if( PIS = "-", .T., .F. )
         lPISEXP := if( PIS = "E", .T., .F. )
         lPISATI := if( PIS = "A", .T., .F. )
         lPISMAO := if( PIS = "M", .T., .F. )
         lFINCRE := if( FIN = "+" .OR. FIN = "M", .T., .F. )
         lFINDEB := if( FIN = "-", .T., .F. )
         lFINEXP := if( FIN = "E", .T., .F. )
         lFINATI := if( FIN = "A", .T., .F. )
         lFINMAO := if( FIN = "M", .T., .F. )
      ENDIF
      dbSelectAr( carq )
      WHILE xDOPER = if( cAPUNEW = "N", DOPER, DCFONEW ) .AND. !Eof()
         IF SOMACANCEL()
            @ 24, 00 SAY NUMERO
            IF cTIPO = "S"
               mNUMERO := NUMERO
               lSOMANF := .F.
               dbSelectAr( carqNF )
               dbGoTop()
               IF dbSeek( mNUMERO )
                  IF APURA # "N"
                     lSOMANF := .T.
                  ENDIF
               ENDIF
               dbSelectAr( carq )
            ENDIF
            IF lFINCRE
               mTOTNF += DVALORNF
               IF cTIPO = "E"
                  nTOTNFE  += DVALORNF
                  nTOTIPIE += DVALIPI
               ENDIF
               IF cTIPO = "S"
                  nTOTNFS  += DVALORNF
                  nTOTIPIS += DVALIPI
               ENDIF
            ENDIF
            IF lFINDEB
               mTOTNF -= DVALORNF
               IF cTIPO = "E"
                  nTOTNFE  -= DVALORNF
                  nTOTIPIE -= DVALIPI
               ENDIF
               IF cTIPO = "S"
                  nTOTNFS  -= DVALORNF
                  nTOTIPIS -= DVALIPI
               ENDIF
            ENDIF
            IF lFINEXP
               nEXPORTA += DVALORNF
            ENDIF
            IF lFINMAO
               nMAOOBRA += DVALORNF
            ENDIF
            IF lFINATI
               nATIVO += DVALORNF
            ENDIF
            IF lPISCRE
               mTOTNF2 += DVALORNF
               IF cTIPO = "E"
                  nTOTNFE2  += DVALORNF
                  nTOTIPIE2 += DVALIPI
               ENDIF
               IF cTIPO = "S"
                  nTOTNFS2  += DVALORNF
                  nTOTIPIS2 += DVALIPI
               ENDIF
            ENDIF
            IF lPISDEB
               mTOTNF2 -= DVALORNF
               IF cTIPO = "E"
                  nTOTNFE2  -= DVALORNF
                  nTOTIPIE2 -= DVALIPI
               ENDIF
               IF cTIPO = "S"
                  nTOTNFS2  -= DVALORNF
                  nTOTIPIS2 -= DVALIPI
               ENDIF
            ENDIF
            IF lPISEXP
               nEXPORTA2 += DVALORNF
            ENDIF
            IF lPISMAO
               nMAOOBRA2 += DVALORNF
            ENDIF
            IF lPISATI
               nATIVO2 += DVALORNF
            ENDIF
            IF cTIPO = "S" .AND. lSOMANF
               nAPUSAI += DVALORNF
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      dbSelectAr( cARQ )
   ENDDO
   dbCloseAll()

// + EOF: M_BDIK.PRG

// + EOF: m_bdik.prg
// +
