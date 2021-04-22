*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIG.PRG
*+
*+    Functions: Function MBDG01()
*+               Function MBDG02()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bdig
para nTIPO

if !CHECKIMP( 0 )
   retu .F.
endif

if nTIPO = 1
   MDI( " Э LIVRO DE APURAЂЋO IPI" )
else
   MDI( " Э LIVRO DE APURAЂЋO ICMS" )
endif

cPERIODO := "1o. Decendio" + space( 10 )
cTIPOCAN :="T"

aRETU        := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
nMES         := aRETU[ 1 ]
nANO         := aRETU[ 2 ]
mCOMPETENCIA := aRETU[ 7 ]
cAPUNEW:="S"


@ 21,00 SAY "Mes Ano"
@ 22,00 SAY "Complemento"
@ 23,00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 21,20 get nMES PICT "99"
@ 21,30 GET nANO PICT "9999"
@ 22,30 get cPERIODO
@ 23,50 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif

priv   wNOME,wINSCR,wCGC,wJUCESPC,wJUCESPD
priv   wIMUNICI,wENDERECO,wCIDADE,wESTADO,wCEP,wBAIRRO
pegempmbdi()


if !USEREDE( "APUCFO", 0, 99 )
   retu .F.
endif
zap
if cAPUNEW="S"
   DBSETORDER(2)
ENDIF

IF ! MBDG02( aRETU[ 5, 1 ], "Entrada" )
   RETU .F.
ENDIF
IF ! MBDG02( aRETU[ 5, 2 ], "Saida" )
   RETU .F.
ENDIF

ZFOL    := ZLIM := ZLIV := 0
ZULT    := ZDATA
CTLIN   := 80
l200    := l300 := l500 := l600 := l700 := .T.
aTOTSUB := array( 6 )
aTOTGER := array( 6 )
afill( aTOTSUB, 0 )
afill( aTOTGER, 0 )

if nTIPO = 1
   PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGIPI", "FILIMIPI", "FILIVIPI", "FILAIPI" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
else
   PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGICM", "FILIMICM", "FILIVICM", "FILAICM" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
endif

if !USEREDE( "MD04", 1, IF(cAPUNEW="S",2,3))
   DBCLOSEALL()
   retu .F.
endif
dbselectar( "APUCFO" )
dbgotop()
while !eof()
   cCFO := IF(cAPUNEW="S",CFONEW,CFO)
   cDES := ""
   dbselectar( "MD04" )
   dbgotop()
   if dbseek( cCFO )
      cDES := left( DESCRICAO, 45 )
   endif
   dbselectar( "APUCFO" )
   if ! empty( cDES )
      field->DESCRICAO := cDES
   endif
   dbskip()
enddo
dbselectar( "MD04" )
dbclosearea()

IMPRESSORA()
dbselectar( "APUCFO" )
dbgotop()
while !eof()
   if CTLIN > 54
      ZFOL++
      if ZFOL = ZLIM
         M_BDIN( if( nTIPO = 2, 6, 8 ) )
         ZLIV ++
         ZFOL := 1
         M_BDIN( if( nTIPO = 2, 5, 7 ) )
         ZFOL := 2
      endif
      @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
      @  1, 82  say left( MMES( nMES ), 3 ) + "/" + str( nANO, 4 )
      @  1, 97  say ZDATA
      @  1, 113 say left( time(), 5 )
      @  1, 128 say str( ZFOL, 4 )
      @  2,  0  say repl( "-", 132 )
      if nTIPO = 1
         @  3,  0 say "R E G I S T R O  D E  A P U R A C A O  D O  I P I"
      else
         @  3,  0 say "R E G I S T R O  D E  A P U R A C A O  D O  I C M S"
      endif
      @  4,  0  say "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
      @  4,  7  say wNOME
      @  4, 71  say alltrim( cPERIODO ) + " " + mCOMPETENCIA
      @  5,  0  say "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 12 ) + "INSC. Municipal:"
      @  5, 11  say wINSCR
      @  5, 32  say wCGC
      @  5, 59  say wJUCESPC
      @  5, 78  say wJUCESPD
      @  5, 106 say wIMUNICI
      @  6,  0  say "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
      @  6, 10  say wENDERECO
      @  6, 59  say wCIDADE
      @  6, 103 say wESTADO
      @  6, 111 say wCEP
      @  7,  0  say repl( "-", 132 )
      @  8,  0  say "CFO DESCRICAO" + spac( 40 ) + "VALOR          BASE DE      IMPOSTO    ISENTAS OU     O U T R A S   OBSERVACAO"
      @  9, 53  say "CONTABIL       CALCULO     CREDITADO  N/TRIBUTADAS"
      @ 10,  0  say repl( "=", 132 )
      CTLIN := 11
   endif
   cCFO:=ALLTRIM(IF(cAPUNEW="S",CFONEW,CFO))
   nCFO:=VAL(cCFO)
   if l200 .and. nCFO >= if(cAPUNEW="N",200,2000)
      MBDG01( "Sub-Total", aTOTSUB ,,.F.)
      l200 := .F.
      afill( aTOTSUB, 0 )
   endif
   if l300 .and. nCFO >= if(cAPUNEW="N",300,3000)
      MBDG01( "Sub-Total", aTOTSUB,,.F. )
      l300 := .F.
      afill( aTOTSUB, 0 )
   endif
   if l500 .and. nCFO >= if(cAPUNEW="N",500,5000)
      MBDG01( "Sub-Total", aTOTSUB,,.F. )
      MBDG01( "T O T A L", aTOTGER, "=" )
      l500 := .F.
      afill( aTOTSUB, 0 )
      afill( aTOTGER, 0 )
   endif
   if l600 .and. nCFO >= if(cAPUNEW="N",600,6000)
      MBDG01( "Sub-Total", aTOTSUB,,.F. )
      l600 := .F.
      afill( aTOTSUB, 0 )
   endif
   if l700 .and. nCFO >= if(cAPUNEW="N",700,7000)
      MBDG01( "Sub-Total", aTOTSUB,,.F. )
      l700 := .F.
      afill( aTOTSUB, 0 )
   endif
   aVAL := { CONTABIL, BASE, VALOR, ISENTA, OUTRA, OBS }
//   IF CONTABIL+BASE+VALOR+ISENTA+OUTRA+OBS>0
// Imprimir Sempre
      IF cAPUNEW="S"
         @ CTLIN,  0 say CFONEW
      ELSE
         @ CTLIN,  0 say CFO
         @ CTLIN,  5 say SUBCFO
      ENDIF
      MBDG01( ACENTO( left( DESCRICAO, 45 ) ), aVAL,, .F. )
//   ENDIF
   for X := 1 to 6
      aTOTSUB[ X ] += aVAL[ X ]
      aTOTGER[ X ] += aVAL[ X ]
   next X
   dbskip()
enddo
MBDG01( "Sub-Total", aTOTSUB,,.F. )
MBDG01( "T O T A L", aTOTGER, "=" )
IMPFOL()
VIDEO()

IF MDG("Gravar N§ Folha")
   if nTIPO = 1
      GRAVAMVAR( "FI_MES", str( ZNUMERO, 5 ) + strzero( nANO, 4 ) + strzero( nMES, 2 ), "FIPAXIPI", "ZFOL" )
   else
      GRAVAMVAR( "FI_MES", str( ZNUMERO, 5 ) + strzero( nANO, 4 ) + strzero( nMES, 2 ), "FIPAXICM", "ZFOL" )
   endif
endif

IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDG01()
*+
*+    Called from ( m_bdig.prg   )   9 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDG01( cTITULO, aVAL, cTR, lSAL ,lLIN)

//if aVAL[ 1 ] = 0 Sempre Imprimir
//   retu .T.
//endif
if valtype( cTR ) # "C"
   cTR := "-"
endif
if valtype( lSAL ) # "L"
   lSAL := .T.
endif
if valtype( lLIN ) # "L"
   lLIN := .T.
endif
@ CTLIN,   7  say LEFT(TIRACE( cTITULO ),40)
FOR Y=1 TO 6
     @ CTLIN, 34+(Y*14)  say aVAL[ Y ] pict '@E 999999,999.99'
NEXT Y
if lSAL
   CTLIN ++
   @ CTLIN,  0 say repl( cTR, 132 )
endif
IF lLIN
   CTLIN ++
ENDIF
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDG02()
*+
*+    Called from ( m_bdig.prg   )   2 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDG02( cARQ, cTITULO )

if MDG( "Apurar " + cTITULO )
   MDS( "Aguarde Apurando " + cTITULO )
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   if !USEREDE( Carq, 1, 0 )
      dbcloseall()
      retu .F.
   endif
   if !empty( FILTRO )
      set filter to &FILTRO.
   endif
   dbgotop()
   while !eof()
      @ 24, 40 say NUMERO
      cCFONEW := DCFONEW
      cCFO    := DOPER
      cSUBCFO := SUBDOPER
      IF cAPUNEW="N"
         mCHAVE:=cCFO + cSUBCFO
      ELSE
         mCHAVE:=DCFONEW
      ENDIF
      IF somacancel()
      if nTIPO = 1
         aVAL := { DVALORNF, DBASEIPI, DVALIPI, ISENTAIPI, OUTRAIPI, OBSIPI }
      else
         aVAL := { DVALORNF, DBASEICM, DVALICM, ISENTAICM, OUTRAICM, OBSICM }
      endif
      dbselectar( "APUCFO" )
      dbgotop()
      if !dbseek( mCHAVE)
         netrecapp()
         field->CFO    := cCFO
         field->SUBCFO := cSUBCFO
         field->CFONEW := cCFONEW
      endif
      dbselectar( "APUCFO" )
      field->CONTABIL += aVAL[ 1 ]
      field->BASE     += aVAL[ 2 ]
      field->VALOR    += aVAL[ 3 ]
      field->ISENTA   += aVAL[ 4 ]
      field->OUTRA    += aVAL[ 5 ]
      field->OBS      += aVAL[ 6 ]
      ENDIF
      dbselectar( CArq )
      dbskip()
   enddo
   dbclosearea()
endif
retu .t.

*+ EOF: M_BDIG.PRG
