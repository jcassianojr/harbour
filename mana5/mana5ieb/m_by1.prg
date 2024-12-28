// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_by1.prg
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
// +    Source Module => J:\ITAESBRA\M_BY1.PRG
// +
// +    Functions: Function MBY1FIL()
// +               Function MBY101()
// +               Function CABMBY1()
// +
// +
// +    Reformatted by Click! 2.03 on Feb-10-2005 at  1:30 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

MDI( " Э Ficha do Operador" )
nSEQ  := 0
CTLIN := 80
aGER  := {}

lANA := MDG( "Deseja Analitico" )
lDIA := MDG( "Deseja Resumo Dia" )
lMES := MDG( "Deseja Resumo Mensal" )
lGER := MDG( "Deseja Resumo Geral" )

FILTRO := ''
FILTRO := RFILORD( "MY03", .F. )

aRETU   := PERFEC( { "MY03", "MY03A" }, { "Y3", "YA" }, { "Y399", "YA99" }, { "DATOPR", "PADRAO" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQ    := aRETU[ 5, 1 ]
cARQ2   := aRETU[ 5, 2 ]
cCAB    := aRETU[ 7 ]

lGRA := .F.
IF aRETU[ 6 ] = 2   // Mes Fechado
lGRA := MDG( "Gravar Apura‡„o" )
IF lGRA
lGRA := SENHAX( "MBY001" )
ENDIF
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
// cAE := IMP( "AE" )
// cAC := IMP( "AC" )
cAE := aCHR[ 2 ]
cAC := aCHR[ 1 ]

IF !USEMULT( { { CARQ, 1, 1 }, { cARQ2, 1, 1 }, { "MS06", 1, 1 }, { "MP04", 1, 1 } } )
RETU .F.
ENDIF

IF lGRA
IF !USEMULT( { { "RD", 1, 99 }, { "RDF", 0, 99 } } )
RETU .F.
ENDIF
dbSelectAr( "RD" )
dbSetOrder( 2 )
dbGoTop()
IF dbSeek( Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
nSEQ := SEQ
ENDIF
IF nSEQ > 0
dbSelectAr( "RDF" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| SEQ = nSEQ }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK
ENDIF
ENDIF

dbSelectAr( cARQ )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "str( CODOPE, 8 ) + dtos( DATOPR ) + str( INIOPR, 5, 2 )" )
ordSetFocus( "temp" )


IMPRESSORA()
dbSelectAr( cARQ )
dbGoTop()
WHILE Empty( codope ) .AND. !Eof()  // Pula Operador 0 Geralmente Terceiros/Tratamento
dbSkip()
ENDDO
WHILE !Eof()
nCODOPE := CODOPE
mNOME   := ""
dDATOPR := DATOPR
aMES    := {}
dbSelectAr( "MP04" )
dbGoTop()
IF dbSeek( nCODOPE )
IF Empty( demitido ) .OR. ( dDATOPR <= demitido )
mNOME := NOMTEC
ENDIF
ENDIF
VIDEO()
@ 24, 00 SAY "Operador: " + Str( nCODOPE ) + " " + mNOME
IMPRESSORA()
IF CTLIN # 80
@ CTLIN, 0  SAY "Operador: " + Str( nCODOPE )
@ CTLIN, 20 SAY mNOME
CTLIN++
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
ENDIF
dbSelectAr( cARQ )
WHILE nCODOPE = CODOPE .AND. !Eof()
nDIA := DATOPR
aDIA := { 0, 0, 0, 0 }
WHILE nCODOPE = CODOPE .AND. nDIA = DATOPR .AND. !Eof()
mCHAVE  := PadR( CODIGO, 24 ) + Str( SEQ, 3 ) + Str( SSQ, 3 )
nPCHORA := 0
dbSelectAr( "MS06" )
dbGoTop()
IF dbSeek( mCHAVE )
IF nDIA >= DATAINI
nPCHORA := PCHORA
ENDIF
ENDIF
dbSelectAr( cARQ )
nHORAS := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
nHORAS := Round( nHORAS, 2 )
nQTDDE := QTDDE
// if ! empty( CODIG2 )
// nQTDDE := QTDDE * 2
// endif
IF nHORAS < 0
ALERTX( "Cheque Horas Requisi‡„o" + Str( NUMERO ) )
nHORAS := 0
ENDIF
IF nQTDDE < 0
ALERTX( "Cheque Quantidade Requisi‡„o" + Str( NUMERO ) )
ENDIF
nFEITO := 0
IF nQTDDE > 0 .AND. nHORAS > 0.001
nFEITO := Round( nQTDDE / nHORAS, 2 )
ENDIF
nHREF := 0
IF nPCHORA > 0 .AND. nFEITO > 0
nHREF := Round( if( nPCHORA > 0, nFEITO / nPCHORA, 0 ), 2 )
ENDIF
nHRE2 := 0
IF nQTDDE > 0 .AND. nPCHORA > 0
nHRE2 := Round( if( nPCHORA > 0, nQTDDE / nPCHORA, 0 ), 2 )
ENDIF
IF TPMY03 = "S"
nHREF   := 1
nHRE2   := nHORAS
nPCHORA := nFEITO
ENDIF
nPARADA := 0
// Calculos passiveis de implanta‡„o
nPER01 := nHREF * 100
nPER02 := nHREF * 100
nPER03 := 100
aDIA[ 1 ] += nHORAS
aDIA[ 3 ] += nHRE2
aDIA[ 4 ] += nQTDDE
IF lANA
CABMBY1( .T. )
@ CTLIN, 0   SAY NUMERO
@ CTLIN, 9   SAY DATOPR
@ CTLIN, 18  SAY Left( CODIGO, 15 )
@ CTLIN, 34  SAY SEQ
@ CTLIN, 38  SAY SSQ
@ CTLIN, 42  SAY CODMAQ
@ CTLIN, 51  SAY INIOPR          PICT "99.99"
@ CTLIN, 57  SAY FIMOPR          PICT "99.99"
@ CTLIN, 63  SAY nHORAS          PICT "99.99"
@ CTLIN, 69  SAY nPARADA         PICT "99.99"
@ CTLIN, 75  SAY nQTDDE          PICT "999999"
@ CTLIN, 82  SAY nFEITO          PICT "9999.99"
@ CTLIN, 90  SAY nPCHORA         PICT "9999"
@ CTLIN, 95  SAY nHRE2           PICT "99.99"
@ CTLIN, 101 SAY nPER01          PICT "999.99"
CTLIN++
IF !Empty( OBSLAN )
@ CTLIN, 0 SAY "Obs: " + OBSLAN
CTLIN++
ENDIF
ENDIF
mCHAVE := NUMERO
dbSelectAr( cARQ2 )
dbGoTop()
dbSeek( Str( mCHAVE, 8 ) )
WHILE mCHAVE = NUMERO .AND. !Eof()
aDIA[ 2 ] += TEMPO
IF lANA
@ CTLIN, 30 SAY "CHP"
@ CTLIN, 35 SAY CODPAR
@ CTLIN, 38 SAY CODPARD
@ CTLIN, 51 SAY PINI         PICT "99.99"
@ CTLIN, 57 SAY PFIM         PICT "99.99"
@ CTLIN, 69 SAY TEMPO        PICT "99.99"
@ CTLIN, 75 SAY Left( OBS, 55 )
CTLIN++
ENDIF
dbSkip()
ENDDO
dbSelectAr( cARQ )
dbSkip()
ENDDO
nTOT   := aDIA[ 1 ] + aDIA[ 2 ]
nPER01 := PERC( aDIA[ 3 ], aDIA[ 1 ] )   // eFC
nPER02 := PERC( aDIA[ 3 ], nTOT )  // pro
nPER03 := PERC( aDIA[ 1 ], nTOT )  // utl
IF lDIA
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
@ CTLIN, 63  SAY "HRs"
@ CTLIN, 69  SAY "Par"
@ CTLIN, 75  SAY "Qtdde"
@ CTLIN, 95  SAY "Hr.Pr."
@ CTLIN, 101 SAY "Efi"
@ CTLIN, 108 SAY "Pro"
@ CTLIN, 115 SAY "Utl"
CTLIN++
MBY101( { "Data", nDIA, aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
CTLIN++
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
ENDIF
AAdd( aMES, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, nDIA, aDIA[ 4 ] } )
dbSelectAr( cARQ )
ENDDO
aDIA := { 0, 0, 0, 0 }
FOR X := 1 TO Len( aMES )
aDIA[ 1 ] += aMES[ X, 1 ]
aDIA[ 2 ] += aMES[ X, 2 ]
aDIA[ 3 ] += aMES[ X, 3 ]
aDIA[ 4 ] += aMES[ X, 8 ]  // Qtde
IF lMES
CABMBY1( .T. )
MBY101( { "", aMES[ X, 7 ], aMES[ X, 1 ], aMES[ X, 2 ], aMES[ X, 8 ], aMES[ X, 3 ], ;
               aMES[ X, 4 ], aMES[ X, 5 ], aMES[ X, 6 ] } )
CTLIN++
ENDIF
NEXT X
nPER01 := PERC( aDIA[ 3 ], aDIA[ 1 ] )  // efc
nPER02 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )  // pro
nPER03 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )  // utl
IF lMES
MBY101( { "Mes", mNOME, aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
CTLIN++
@ CTLIN, 0 SAY repl( "=", 132 )
CTLIN++
ENDIF
AAdd( aGER, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, nCODOPE, mNOME, aDIA[ 4 ] } )
dbSelectAr( cARQ )
ENDDO
IF lGER
CTLIN := 80  // For‡ar Iniciar Uma FOLHA
ENDIF
aDIA := { 0, 0, 0, 0 }
FOR X := 1 TO Len( aGER )
aDIA[ 1 ] += aGER[ X, 1 ]
aDIA[ 2 ] += aGER[ X, 2 ]
aDIA[ 3 ] += aGER[ X, 3 ]
aDIA[ 4 ] += aGER[ X, 9 ]
IF lGER
CABMBY1( .F. )
MBY101( { aGER[ X, 7 ], aGER[ X, 8 ], aGER[ X, 1 ], aGER[ X, 2 ], aGER[ X, 9 ], aGER[ X, 3 ], ;
            aGER[ X, 4 ], aGER[ X, 5 ], aGER[ X, 6 ] } )
CTLIN++
ENDIF
IF nSEQ > 0 .AND. lGRA
dbSelectAr( "RDF" )
netrecapp()
field->SEQ    := nSEQ
field->HD     := aGER[ X, 1 ] + aGER[ X, 2 ]  // Horas Disponiveis
field->HP     := aGER[ X, 2 ]  // Horas Paradas
field->HT     := aGER[ X, 1 ]  // Horas Trabalhadas
field->PE     := aGER[ X, 4 ]
field->PP     := aGER[ X, 5 ]
field->PU     := aGER[ X, 6 ]
field->NUMERO := aGER[ X, 7 ]
field->NOME   := aGER[ X, 8 ]
field->QP     := aGER[ X, 9 ]
ENDIF
NEXT X
nPER01 := PERC( aDIA[ 3 ], aDIA[ 1 ] )   // efc
nPER02 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )   // prod
nPER03 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )   // utliz
IF lGER
MBY101( { "", "", aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
CTLIN++
ENDIF
IMPFOL()
IF lGRA
dbSelectAr( "RD" )
dbSetOrder( 1 )
dbGoTop()
IF dbSeek( nSEQ )
netgrvcam()
field->FUHD := aDIA[ 1 ] + aDIA[ 2 ]
field->FUHP := aDIA[ 2 ]
field->FUHT := aDIA[ 1 ]
field->FUQP := aDIA[ 4 ]
field->FUPE := nPER01
field->FUPP := nPER02
field->FUPU := nPER03
dbUnlock()
ENDIF
ENDIF
dbCloseAll()
IMPEND()
MBY1FIl()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBY1FIL()
// +
// +    Called from ( m_by1.prg    )   1 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBY1FIL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBY1FIL()

   FOR X := 1 TO 4
      IF X < 4
         Y := X
      ELSE
         Y := 99
      ENDIF
      MDS( "Aguarde Checando Nomes Empresa " + Str( Y, 2 ) )
      IF !USECHK( "p:\novell\itaesbra\emp000" + StrZero( Y, 2 ) + "\mp04.dbf", ;
            "p:\novell\itaesbra\emp000" + StrZero( Y, 2 ) + "\mp04.cdx", .T., "DBFCDX", .T. )
         LOOP
      ENDIF
      IF !USEREDE( "RDF", 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      dbSelectAr( "RDF" )
      nLASTREC := LastRec()
      nPOSREC  := 1
      dbGoTop()
      WHILE !Eof()
         IF Empty( nome )
            mNUMERO := NUMERO
            mNOME   := ""
            dbSelectAr( "MP04" )
            dbGoTop()
            IF dbSeek( mNUMERO )
               IF Empty( demitido )
                  mNOME := NOMTEC
               ENDIF
            ENDIF
            dbSelectAr( "RDF" )
            netgrvcam( "NOME", mNOME )
         ENDIF
         dbSelectAr( "RDF" )
         dbSkip()
         ZEI_FORT( nLASTREC, .T., nPOSREC )
         nPOSREC++
      ENDDO
      dbCloseAll()
   NEXT X

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBY101()
// +
// +    Called from ( m_by1.prg    )   5 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBY101()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBY101( aDAD )

   @ CTLIN, 0   SAY aDAD[ 1 ]
   @ CTLIN, 9   SAY aDAD[ 2 ]
   @ CTLIN, 58  SAY aDAD[ 3 ] PICT "99999.99"
   @ CTLIN, 69  SAY aDAD[ 4 ] PICT "99999.99"
   @ CTLIN, 78  SAY aDAD[ 5 ] PICT "9999999"
   @ CTLIN, 92  SAY aDAD[ 6 ] PICT "99999.99"
   @ CTLIN, 101 SAY aDAD[ 7 ] PICT "999.99"
   @ CTLIN, 108 SAY aDAD[ 8 ] PICT "999.99"
   @ CTLIN, 115 SAY aDAD[ 9 ] PICT "999.99"
   RETU

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function CABMBY1()
// +
// +    Called from ( m_by1.prg    )   3 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABMBY1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CABMBY1( lSAYF )

   IF CTLIN > 55
      @  0, 0   SAY cAE + "Ficha do Operador"
      @  1, 0   SAY cAC + "M_BY1"
      @  1, 60  SAY Time()
      @  1, 70  SAY ZDATA
      @  2, 0   SAY "Req."
      @  2, 9   SAY "Data"
      @  2, 18  SAY "Peca No."
      @  2, 34  SAY "OP"
      @  2, 42  SAY "Maquina"
      @  2, 51  SAY "Ini"
      @  2, 57  SAY "Fim"
      @  2, 63  SAY "HRs"
      @  2, 69  SAY "Par"
      @  2, 75  SAY "Qtdde"
      @  2, 82  SAY "Real"
      @  2, 90  SAY "Pad"
      @  2, 95  SAY "Hr.Pr."
      @  2, 101 SAY "Efi"
      @  2, 108 SAY "Pro"
      @  2, 115 SAY "Utl"
      CTLIN := 3
      IF lSAYF
         @ CTLIN, 0  SAY "Operador: " + Str( nCODOPE )
         @ CTLIN, 20 SAY mNOME
         CTLIN++
         @ CTLIN, 0 SAY repl( "-", 132 )
         CTLIN++
      ENDIF
   ENDIF
   RETU .T.

// + EOF: M_BY1.PRG

// + EOF: m_by1.prg
// +
