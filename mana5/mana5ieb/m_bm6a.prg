// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm6a.prg
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
// +    Source Module => J:\ITAESBRA\M_BM6A.PRG
// +
// +    Functions: Function MBM6AB()
// +               Function COMPRAS()
// +               Function TRUNCAR()
// +
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
MDI( " Э Imprimir Relatўrio de Apura‡„o de Vendas" )

// Variaveis de Trabalho
CRIARVARS( "APURA2" )
lCPI := MDG( "Deseja Imprimir 12 CPI" )
lCOM := MDG( "Comprimido" )

NRCOPIA := 1
aNFNR   := {}
aBATE   := {}
mTOTD   := mTOTDNF := 0.00
nBATE   := 0

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cAN  := IMP( "AN" )
cDN  := IMP( "DN" )
cEMP := IMP( "ZEMP" )

@ 24, 00
@ 24, 00 SAY "NЈmero de cўpias:" GET NRCOPIA PICT '99'
READCUR()

COMPRAS()

IF !USEREDE( "APURA2", 0, 99 )
RETU
ENDIF
WHILE !Eof()
nBATE := 0
FOR Z := 1 TO Len( aBATE )
IF aBATE[ Z, 2 ] = COGNOME
nBATE += aBATE[ Z, 5 ]
ENDIF
NEXT Z
field->ABADEV := nBATE
dbSkip()
ENDDO

aGRAVA := {}
dbSelectAr( "APURA2" )
dbSetOrder( 2 )
dbGoTop()
WHILE !Eof()
// Declara‡„o de vari veis
AAdd( aGRAVA, { 0, COGNOME, GRUPOEMP, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
// 1   2          3   4 5 6 7 8 9 10 11 12 13 14,15,16
nPOS      := Len( aGRAVA )
mGRUPOEMP := GRUPOEMP
WHILE mGRUPOEMP = GRUPOEMP .AND. !Eof()
aGRAVA[ NPOS, 4 ] += PROD
aGRAVA[ NPOS, 5 ] += FERRA
aGRAVA[ NPOS, 6 ] += MOPROD
aGRAVA[ NPOS, 7 ] += MOFERRA
aGRAVA[ NPOS, 8 ] += TOTALMER
aGRAVA[ NPOS, 9 ] += total
aGRAVA[ NPOS, 10 ] += PROD2
aGRAVA[ NPOS, 11 ] += FERRA2
aGRAVA[ NPOS, 12 ] += MOPROD2
aGRAVA[ NPOS, 13 ] += MOFERRA2
aGRAVA[ NPOS, 14 ] += ABADEV
aGRAVA[ NPOS, 15 ] += SERV
aGRAVA[ NPOS, 16 ] += SERV2
dbSkip()
ENDDO
ENDDO
dbCloseArea()

IF !USEREDE( "APURA2C", 0, 99 )
RETU
ENDIF
dbSelectAr( "APURA2C" )
ZAP
FOR X := 1 TO Len( aGRAVA )
IF aGRAVA[ X, 9 ] > 0
netrecapp()
field->FORNECEDO := aGRAVA[ X, 1 ]
field->COGNOME   := aGRAVA[ X, 2 ]
field->GRUPOEMP  := aGRAVA[ X, 3 ]
field->PROD      := aGRAVA[ X, 4 ]
field->FERRA     := aGRAVA[ X, 5 ]
field->MOPROD    := aGRAVA[ X, 6 ]
field->MOFERRA   := aGRAVA[ X, 7 ]
field->TOTALMER  := aGRAVA[ X, 8 ]
field->TOTAL     := aGRAVA[ X, 9 ]
field->PROD2     := aGRAVA[ X, 10 ]
field->FERRA2    := aGRAVA[ X, 11 ]
field->MOPROD2   := aGRAVA[ X, 12 ]
field->MOFERRA2  := aGRAVA[ X, 13 ]
field->ABADEV    := aGRAVA[ X, 14 ]
field->SERV      := aGRAVA[ X, 15 ]
field->SERV2     := aGRAVA[ X, 16 ]
mPORCENTO        := ( TOTALMER * 100 ) / mTOTMERC   // Acha a porcentagem
field->PORCENTO  := mPORCENTO
ENDIF
NEXT X
dbCloseAll()

FOR W := 1 TO NRCOPIA
IF MDG( "Resumo Por Cliente a Cliente" )
MBM6AB( "APURA2" )
ENDIF
IF MDG( "Resumo Por Grupo Empresa" )
MBM6AB( "APURA2C" )
ENDIF
NEXT W

IF MDG( "Imprimir Resumo Checagem Abatimento" )
@  0, 0 SAY "Resumo Checagem Abatimento"
CTLIN := 2
FOR W := 1 TO Len( aNFNR )
@ CTLIN, 0  SAY aNFNR[ W, 1 ]
@ CTLIN, 10 SAY aNFNR[ W, 2 ]
CTLIN++
NEXT W
IMPFOL()
ENDIF
IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBM6AB()
// +
// +    Called from ( m_bm6a.prg   )   2 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBM6AB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBM6AB( cARQ )

   VIDEO()
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IMPRESSORA()
   xTOTMER    := xTOTNF := 0.00
   xFORNECEDO := 0
   xCOGN      := Space( 12 )
   mACUMPORC  := 0.00
   mMERCADO   := mTOTALNF := 0.00
   mSAL1      := mSAL2 := mSAL3 := 0.00
   mTOTNF1    := mTOTNF2 := mTOTNF3 := mTOTNF4 := mTOTNF5 := 0.00
   mTOTAL1    := mTOTAL2 := mTOTAL3 := mTOTAL4 := mTOTAL5 := 0.00
   nTBATE     := 0
   CTLIN      := 80
   IF !USEREDE( cARQ, 1, 1 )
      RETU
   ENDIF
   IF !Empty( fILTRO )
      SET FILTER TO &FILTRO.
   ENDIF
   dbGoTop()
   ZPAGINA := 0
   IMPRESSORA()
   IF Lcom
      @  0, 0 SAY IMPSTR( aCHR[ 1 ] )
   ENDIF
   IF lCPI
      SET PRINT ON
      QQOut( IMPCHR( 27 ) + IMPCHR( 77 ) )
      SET PRINT OFF
   ENDIF
   WHILE !Eof()
      IF CTLIN > 55
         ZPAGINA++
         @  0, 0   SAY cEMP
         @  1, 01  SAY 'M_BM6'
         @  1, 20  SAY 'APURACAO DE VENDAS POR CLIENTE ' + MMES( nMESUSO ) + "/" + cANOUSO
         @  1, 80  SAY Time()
         @  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
         @  1, 110 SAY ACENTO( '   Folha: ' ) + Str( ZPAGINA, 2 )
         @  2, 0   SAY repl( '-', 132 )
         @  3, 1   SAY ' NUM.'
         @  3, 7   SAY 'COGNOME'
         @  3, 22  SAY '1-PRODUCAO  '
         IF lTIPO02
            @  3, 36 SAY '2-FERR.'
         ENDIF
         @  3, 50 SAY '3-MO.PRODUCAO'
         IF lTIPSER
            @  3, 64 SAY 'SERVICOS'
         ENDIF
         @  3, 80  SAY 'TOTAL MERCAD.'
         @  3, 93  SAY '  % '
         @  3, 101 SAY 'TOTAL DA N.F.'
         @  3, 117 SAY "Saldo O/DEV"
         @  4, 0   SAY repl( '-', 132 )
         CTLIN := 5
      ENDIF

      IF TOTAL <> 0.00
         IF cARQ == "APURA2C"
            @ CTLIN, 06 SAY if( Empty( GRUPOEMP ), "OUTROS", GRUPOEMP )
         ELSE
            @ CTLIN, 00 SAY FORNECEDO
            @ CTLIN, 06 SAY COGNOME
         ENDIF
         @ CTLIN, 22 SAY PROD PICT '@E 99,999,999.99'
         IF lTIPO02
            @ CTLIN, 36 SAY FERRA PICT '@E 99,999,999.99'
         ENDIF
         @ CTLIN, 50 SAY MOPROD PICT '@E 99,999,999.99'
         IF lTIPSER
            @ CTLIN, 64 SAY SERV PICT '@E 99,999,999.99'
         ENDIF
         @ CTLIN, 079 SAY TOTALMER       PICT '@E 99,999,999.99'
         @ CTLIN, 094 SAY PORCENTO       PICT '@E 99.99'
         @ CTLIN, 100 SAY TOTAL          PICT '@E 999,999,999.99'
         @ CTLIN, 114 SAY TOTAL - ABADEV PICT '@E 999,999,999.99'
         // Acumuladores dos Totais Gerais das Vendas.
         mTOTAL1  += PROD
         mTOTAL2  += FERRA
         mTOTAL3  += MOPROD
         mTOTAL4  += MOFERRA
         mTOTAL5  += SERV
         mMERCADO += TOTALMER
         mTOTALNF += total
         CTLIN++
         // Acumuladores auxiliares a serem usados no balanco
         mTOTNF1 += PROD2
         mTOTNF2 += FERRA2
         mTOTNF3 += MOPROD2
         mTOTNF4 += MOFERRA2
         mTOTNF5 += SERV2
         // Acumulador de Porcentagem.
         mACUMPORC += PORCENTO
         nTBATE    += ABADEV
      ENDIF
      dbSkip()
   ENDDO
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++
   @ CTLIN, 01  SAY "Total das Vendas=>"
   @ CTLIN, 22  SAY mTOTAL1              PICT '@E 999,999,999.99'
   @ CTLIN, 36  SAY mTOTAL2              PICT '@E 999,999,999.99'
   @ CTLIN, 50  SAY mTOTAL3              PICT '@E 999,999,999.99'
   @ CTLIN, 64  SAY mTOTAL5              PICT '@E 999,999,999.99'
   @ CTLIN, 079 SAY mMERCADO             PICT '@E 999,999,999.99'
   @ CTLIN, 100 SAY mTOTALNF             PICT '@E 999,999,999.99'
   @ CTLIN, 114 SAY mTOTALNF - nTBATE    PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++

// C lculo do Total Final das Vendas
   mMERCADO += mSUCATA1

   @ CTLIN, 01  SAY "Vendas Diversas IMOBILIZADO/SUCATA e Outros==>"
   @ CTLIN, 079 SAY mSUCATA1                                         PICT '@E 999,999,999.99'
   @ CTLIN, 094 SAY ( mSUCATA1 * 100 ) / mTOTMERC                      PICT '@E 99.99'
   @ CTLIN, 100 SAY mSUCATA2                                         PICT '@E 999,999,999.99'

// CTLIN++
// @ CTLIN, 01 SAY "Pretacao de Servicos                       ==>"
// @ CTLIN, 79 SAY mVALPRES PICT '@E 999,999,999.99'
// @ CTLIN,094 SAY (mVALPRES*100)/mTOTMERC       PICT '@E 99.99'
// @ CTLIN,100 SAY mVALPRES PICT '@E 999,999,999.99'

   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++
   @ CTLIN, 01  SAY "Total Final Vendas"
   @ CTLIN, 19  SAY mTOTAL1                             PICT '@E 999,999,999.99'
   @ CTLIN, 49  SAY mTOTAL3                             PICT '@E 999,999,999.99'
   @ CTLIN, 079 SAY mMERCADO                            PICT '@E 999,999,999.99'
   @ CTLIN, 100 SAY mTOTALNF + mSUCATA2 + mVALPRES          PICT '@E 999,999,999.99'
   @ CTLIN, 114 SAY mTOTALNF + mSUCATA2 + mVALPRES - nTBATE PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++

// STORE 0.00 TO NR9A,NR10A
   @ CTLIN, 2 SAY 'DEVOLUCOES/ABATIMENTOS DE VENDAS POR CLIENTE'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++

   FOR Z := 1 TO Len( aBATE )
      IF AScan( aUFE, aBATE[ Z,  1 ] ) = 0
         @ CTLIN, 01  SAY Str( aBATE[ Z, 1 ], 5 )
         @ CTLIN, 07  SAY aBATE[ Z, 2 ]
         @ CTLIN, 70  SAY aBATE[ Z, 3 ]
         @ CTLIN, 079 SAY aBATE[ Z, 4 ]        PICT '@E 999,999,999.99'
         @ CTLIN, 100 SAY aBATE[ Z, 5 ]        PICT '@E 999,999,999.99'
         CTLIN++
      ENDIF
   NEXT Z

   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++
   @ CTLIN, 1   SAY 'TOTAL DEVOLUCOES=>'
   @ CTLIN, 079 SAY mTOTD                PICT '@E 999,999,999.99'
   @ CTLIN, 100 SAY mTOTDNF              PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++
   IF CTLIN > 55
      CTLIN := 0
      @ CTLIN, 00 SAY repl( '-', 132 )
      CTLIN++
   ENDIF
   @ CTLIN, 1 SAY '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BALANCO FINAL DO PERIODO =>>>>>'

// Total Mercadoria menos Total da Devolucao
   mBALANCO1 := mMERCADO - mTOTD
// Total da nota (com imposto) menos o total da devolucao com imposto
   mBALANCO2 := mTOTALNF + mSUCATA2 + mVALPRES - mTOTDNF

   @ CTLIN, 079 SAY mBALANCO1 PICT '@E 999,999,999.99'
   @ CTLIN, 100 SAY mBALANCO2 PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )

// Totais sem Imposto
   PRODUCAO := mTOTAL1 + mTOTAL2 + mTOTAL3

// Totais com Imposto
   mTOTAL1NF := mTOTNF1 + mTOTNF2 + mTOTNF3

   mPORC1 := mPORC4 := mPROC5 := 0.00

   mBASE2 := PRODUCAO + mTOTAL5  // Sem Imposto
   mBASE  := mTOTAL1NF + mTOTNF5   // Com Imposto
   mBASEP := mTOTAL1NF + mTOTNF5 + mTOTDNF

   mPORC1 := if( mTOTAL1NF > 0, TRUNCAR( mTOTAL1NF / mBASEP * 100 ), 0 )
   mPORC4 := if( mTOTDNF > 0, TRUNCAR( mTOTDNF / mBASEP * 100 ), 0 )
   mPORC5 := if( mTOTNF5 > 0, TRUNCAR( mTOTNF5 / mBASEP * 100 ), 0 )

   CTLIN++
   @ CTLIN, 17 SAY ' SEM  IMPOSTO  '
   @ CTLIN, 35 SAY ' COM  IMPOSTO  '
   @ CTLIN, 53 SAY '%'
   CTLIN++
   @ CTLIN, 1  SAY 'PRODUCAO (1+2+3)=>'
   @ CTLIN, 19 SAY PRODUCAO             PICT '@E 999,999,999.99'
   @ CTLIN, 34 SAY mTOTAL1NF            PICT '@E 999,999,999.99'
   @ CTLIN, 50 SAY mPORC1               PICT '@E 999.99'

   CTLIN++
   @ CTLIN, 1  SAY 'SERVICOS        =>'
   @ CTLIN, 19 SAY mTOTAL5              PICT '@E 999,999,999.99'
   @ CTLIN, 34 SAY mTOTNF5              PICT '@E 999,999,999.99'
   @ CTLIN, 50 SAY mPORC5               PICT '@E 999.99'

   CTLIN++
   @ CTLIN, 01 SAY 'DEVOLUCOES    =>'
   @ CTLIN, 19 SAY mTOTD              PICT '@E 999,999,999.99'
   @ CTLIN, 34 SAY mTOTDNF            PICT '@E 999,999,999.99'
   @ CTLIN, 50 SAY mPORC4             PICT '@E 999.99'

   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++
   @ CTLIN, 01 SAY 'RESUMO FINAL ===>'
   @ CTLIN, 19 SAY mBASE2 - mTOTD      PICT '@E 999,999,999.99'
   @ CTLIN, 34 SAY mBASE - mTOTDNF     PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   CTLIN++
   @ CTLIN, 01 SAY 'FATURADO MES ANTERIOR => '
   @ CTLIN, 50 SAY FATMESANT                   PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 01 SAY 'FATURADO MES ATUAL ===>'
   @ CTLIN, 50 SAY mBASE - mTOTDNF           PICT '@E 999,999,999.99'
   CTLIN++
   DIFMES := ( mBASE - mTOTDNF - FATMESANT )
   IF FATMESANT <> 0.00
      PARDIF := ( ( ( ( mBASE - mTOTDNF ) / FATMESANT ) - 1 ) * 100 )
   ELSE
      PARDIF := 0.00
   ENDIF
   @ CTLIN, 01  SAY 'DIFERENCA ENTRE MES ==>'
   @ CTLIN, 050 SAY DIFMES                    PICT '@E 999,999,999.99'
   @ CTLIN, 065 SAY PARDIF                    PICT '@E 999.99'
   @ CTLIN, 072 SAY '%'
   CTLIN++
   @ CTLIN, 01 SAY 'TOTAL DE DESPESAS ====>'
   @ CTLIN, 25 SAY mDESPMES                  PICT '@E 999,999,999.99'
   mSAL3 := ( mBASE - mDESPMES - mTOTDNF )
   @ CTLIN, 44 SAY 'SALDO'
   @ CTLIN, 50 SAY mSAL3   PICT '@E 999,999,999.99'
   CTLIN++
   @ CTLIN, 00 SAY repl( '-', 132 )
   dbCloseAll()
   IMPFOL()

// Gravando o resultado
   IF ( !lTIPO02 ) .OR. ( !lTIPSER )   // Se Nao For Completo nao Grava
      IF !VERSEHA( "APUITA", Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
         mANO   := nANOUSO
         mMES   := nMESUSO
         mSALDO := mSAL3
         NOVOREG( "APUITA", Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
      ELSE
         GRAVAMVAR( "APUITA", Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ), "SALDO", "mSAL3" )
      ENDIF
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function COMPRAS()
// +
// +    Called from ( m_bm6a.prg   )   1 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function COMPRAS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC COMPRAS  // Pega os Dados e Valores armazenados no NF Compras.

   IF !USEREDE( ARQWORK2, 1, 4 )   // Notas Fiscais de Compras (TOTNF decresc.)
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      xFORNECEDO := FORNECEDO
      xCOGN      := COGNOME
      xTOTNF     := xTOTMER := 0.00
      WHILE xCOGN = COGNOME .AND. !Eof()
         IF Left( OPERACAO, 3 ) = "131" .OR. Left( OPERACAO, 3 ) = "231" .OR. Left( OPERACAO, 3 ) = "331"
            xCOGN      := COGNOME
            xFORNECEDO := FORNECEDO
            xTOTMER    += TOTMER
            xTOTNF     += TOTNF
         ENDIF
         dbSkip()
      ENDDO
      IF xTOTNF > 0 .OR. xTOTMER > 0
         AAdd( aBATE, { xFORNECEDO, xCOGN, "DEV", xTOTMER, xTOTNF } )
         mTOTD   += xTOTMER  // Acumula o Total da Devolucao  (TOTDEV)
         mTOTDNF += xTOTNF   // Acumula o Total da Devolucao com imposto (TOTDEVNF)
      ENDIF
   ENDDO
   dbCloseArea()

   IF !USEREDE( ARQWORK3, 1, 3 )   // Contas Recebidas Por Cliente
      RETU .F.
   ENDIF
   SET FILTER TO ABATER > 0
   dbGoTop()
   WHILE !Eof()
      xFORNECEDO := FORNECEDO
      xCOGN      := COGNOME
      xTOTNF     := xTOTMER := 0.00
      WHILE xFORNECEDO = FORNECEDO .AND. !Eof()
         IF ABATER > 0 .AND. !Empty( DOCABATE )
            AAdd( aNFNR, { NUMERO, ABATER } )
            xTOTMER += ABATER
            xTOTNF  += ABATER
         ENDIF
         dbSkip()
      ENDDO
      IF xTOTNF > 0
         AAdd( aBATE, { xFORNECEDO, xCOGN, "ABA", xTOTMER, xTOTNF } )
         mTOTD   += xTOTMER  // Acumula o Total da Devolucao  (TOTDEV)
         mTOTDNF += xTOTNF   // Acumula o Total da Devolucao com imposto (TOTDEVNF)
      ENDIF
   ENDDO
   dbCloseArea()
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function TRUNCAR()
// +
// +    Called from ( m_bm6a.prg   )   3 - function mbm6ab()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TRUNCAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC TRUNCAR( Arg1 )

   LOCAL Local1 := 0
   LOCAL Local2 := 0
   LOCAL vdpos

   vdpos := At( ".", Str( Arg1 * 100 ) ) - 1
   IF ( vdpos > 0 )
      Local2 := Val( SubStr( Str( Arg1 * 100 ), 1, vdpos ) )
      Local1 := Local2 / 100
   ELSE
      Local1 := Arg1
   ENDIF

   RETURN Local1

// + EOF: M_BM6A.PRG

// + EOF: m_bm6a.prg
// +
