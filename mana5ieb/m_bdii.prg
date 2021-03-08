*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDII.PRG
*+
*+    Functions: Function MBDII()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bdii
PARA cIMPOSTO

IF cIMPOSTO="IPI"
   MDI( " Э Resumo por UF IPI" )
ELSE
   MDI( " Э Resumo por UF ICM" )
ENDIF



aUF  := {}
aVAL := {}
ZFOL := 1
cTIPOCAN :="T"

@ 22,00 SAY "Confirme o numero da Folha"
@ 23,00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 22,40 get ZFOL
@ 23,45 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
if !READCUR()
   retu .F.
endif



aRETU := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
ARQENT := aRETU[ 5, 1 ]
ARQSAI := aRETU[ 5, 2 ]
mCOMPETENCIA   := aRETU[ 7 ]


priv   wNOME,wINSCR,wCGC,wJUCESPC,wJUCESPD
priv   wIMUNICI,wENDERECO,wCIDADE,wESTADO,wCEP,wBAIRRO
pegempmbdi()


if MDG( "Apurar Entrada" )
   MDS( "Aguarde Apurando Entrada" )
   MBDII01(ARQENT)
endif

if MDG( "Apurar Saida" )
   MDS( "Aguarde Apurando Saida" )
   MBDII01(ARQSAI)
endif

if !CHECKIMP( 0 )
   retu .F.
endif

MBDII()


*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDII()
*+
*+    Called from ( m_bdie.prg   )   1 -
*+                ( m_bdii.prg   )   1 - function mbdih()
*+                ( m_bdil.prg   )   1 - function mbdik01()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDII( lCAB )

if valtype( lCAB ) # "L"
   lCAB := .T.
endif
IMPRESSORA()
if lCAB .or. CTLIN > 40
   @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
   @  1, 83  say mCOMPETENCIA
   @  1, 97  say ZDATA
   @  1, 113 say left( time(), 5 )
   @  1, 128 say str( ZFOL, 4 )
   @  2,  0  say repl( "-", 132 )
   @  3,  0  say "RESUMO MENSAL DE OPERACOES E/OU PRESTACOES POR UNIDADE DA FEDERACAO"
   @  4,  0  say "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
   @  4,  7  say wNOME
   @  4, 71  say mCOMPETENCIA
   @  5,  0  say "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
   @  5, 11  say wINSCR
   @  5, 32  say wCGC
   @  5, 59  say wJUCESPC
   @  5, 78  say wJUCESPD
   @  5, 105 say wIMUNICI
   @  6,  0  say "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
   @  6, 10  say wENDERECO
   @  6, 59  say wCIDADE
   @  6, 103 say wESTADO
   @  6, 111 say wCEP
   @  7,  0  say repl( "-", 132 )
   @  8, 27  say "UNI.FED.            VALOR CONTABIL           BASE DE CALCULO"
   @  9,  0  say repl( "=", 132 )
   CTLIN := 10
else
   @ CTLIN,  0 say repl( "=", 132 )
   CTLIN ++
   @ CTLIN,  0 say "RESUMO MENSAL DE OPERACOES E/OU PRESTACOES POR UNIDADE DA FEDERACAO    "
   CTLIN ++
   @ CTLIN,  0 say repl( "-", 132 )
   CTLIN ++
   @ CTLIN, 27 say "UNI.FED.            VALOR CONTABIL           BASE DE CALCULO"
   CTLIN ++
   @ CTLIN,  0 say repl( "=", 132 )
   CTLIN ++
endif
for X := 1 to len( aUF )
   cUF := if( aUF[ X ] == "XX", "EX", aUF[ X ] )
   @ CTLIN, 30 say cUF
   @ CTLIN, 47 say aVAL[ X, 1 ] pict "@E 999,999,999.99"
   @ CTLIN, 73 say aVAL[ X, 2 ] pict "@E 999,999,999.99"
   CTLIN ++
next X
IMPFOL()
VIDEO()
IMPEND()

FUNC MBDII01(cARQ)
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF ! USEMULT({{"MA01", 1, 1 },{"MB01", 1, 1 },{ cARQ, 1, 0 }})
      dbcloseall()
      retu .F.
   endif
   if !empty( FILTRO )
      set filter to &FILTRO
   endif
   dbgotop()
   while !eof()
      @ 24, 40 say NUMERO
      IF SOMACANCEL()
      mTIPOFOR   := TIPOFOR
      mESTADO    := "  "
      mFORNECEDO := FORNECEDO
      dbselectar( if( mTIPOFOR = "C", "MA01", "MB01" ) )
      dbgotop()
      IF dbseek( mFORNECEDO )
         mESTADO := ESTADO
      endif
      dbselectar( cARQ )
      nPOS := ascan( aUF, mESTADO )
      if nPOS > 0
         IF cIMPOSTO="IPI"
           aVAL[ nPOS, 1 ] += DVALORNF
           aVAL[ nPOS, 2 ] += DBASEIPI
         ELSE
           aVAL[ nPOS, 1 ] += DVALORNF
            aVAL[ nPOS, 2 ] += DBASEICM
         ENDIF
      else
         aadd( aUF, mESTADO )
         IF cIMPOSTO="IPI"
            aadd( aVAL, { DVALORNF, DBASEIPI } )
         ELSE
            aadd( aVAL, { DVALORNF, DBASEICM } )
         ENDIF
      endif
      ENDIF
      dbskip()
   enddo
   dbcloseall()
RETU

*+ EOF: M_BDII.PRG
