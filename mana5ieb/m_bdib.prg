*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIB.PRG
*+
*+    Reformatted by Click! 2.03 on Dec-5-2002 at  3:22 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

function m_bdib
para cARQPRI, cARQACU, cCARREF, cCABREF

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI( " Э Relatўrio da DIPI " )

if !CHECKIMP( 0 )
   retu .F.
endif

cCABAUX := space( 40 )
cTIPOCAN := "T"
cAPUNEW:="S"
@ 22, 00 say "Cabe‡ario Aux."
@ 23, 00 say "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 22, 20 get cCABAUX
@ 23, 45 get cTIPOCAN                                      pict "!" valid cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif

aRETU   := PERFEC( { "MM06", "MK06" }, { "M6", "K6" }, { "MM96", "MK96" } )
MES     := aRETU[ 1 ]
ANO     := aRETU[ 2 ]
cARQSAI := aRETU[ 5, 1 ]
cARQENT := aRETU[ 5, 2 ]
cVAR    := aRETU[ 7 ]


lCPI := MDG( "Deseja Imprimir 12 CPI" )

if MDG( "Entradas" )
   M_BDIB01( cARQENT, "DIPI - Nota Fiscal de Entradas" )
endif
if MDG( "Saidas" )
   M_BDIB01( cARQSAI, "DIPI - Nota Fiscal de Saidas" )
endif

VIDEO()
IMPEND()

FUNC M_BDIB01( ARQWORK, cCABREF )

// Variaveis de Trabalho
CRIARVARS( ARQWORK )
tDVALORNF := tDBASEICM := tDVALICM := tISENTAIC := tOUTRAICM := 0.00
tDBASEIPI := tDVALIPI := tISENTAIP := tOUTRAIPI := 0.00

FILTRO := ''
FILTRO := RFILORD( ARQWORK, .F. )
CTLIN  := 1
ZFOL   := 0
cEMP   := IMP( "ZEMP" )

CTLIN := 80
if !USEREDE( ARQWORK, 1, 0 )
   retu
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cAPUNEW="N"
   ordDestroy("temp")
   ordcreate(,"temp","STR(LOTE,5)+DOPER+STR(DIPI,2)+CHKIPI+STR(DICM,5,2)")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","STR(LOTE,5)+DCFONEW+STR(DIPI,2)+CHKIPI+STR(DICM,5,2)")
   ordSetFocus("temp")
ENDIF
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
ZFOL := 0
if !eof()
   IMPRESSORA()
endif
if lCPI
   set print on
   qqout( IMPCHR( 27 ) + IMPCHR( 77 ) )
   set print OFF
endif
while !eof()
   if CTLIN > 55
      ZFOL ++
      @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
      @  1, 83  say cVAR
      @  1, 97  say ZDATA
      @  1, 113 say left( time(), 5 )
      @  1, 128 say str( ZFOL, 4 )
      @  2,  0  say repl( "-", 132 )
      @  3, 01  say 'DIPI-B'
      @  3, 20  say cCABAUX
      @  5, 30  say impchr(cIMPTIT) + ACENTO( cCABREF )
      @  6,  2  say impchr(cIMPTIT) + cEMP + impchr(cIMPEXP)
      @  7,  0  say repl( '-', 140 ) + impchr(cIMPCOM)
      @  8,  0  say 'Ordem'
      @  8,  6  say ' N.F.'
      @  8, 17  say 'Data'
      @  8, 27  say 'Oper.'
      @  8, 39  say 'Total NF'
      @  8, 61  say 'Base ICM'
      @  8, 76  say '%'
      @  8, 83  say 'Valor ICM'
      @  8, 102 say 'Isentas'
      @  8, 121 say 'Outras'
      @  8, 139 say 'Base IPI'
      @  8, 156 say '%'
      @  8, 162 say 'ValorIPI'
      @  8, 182 say 'Isentas'
      @  8, 201 say 'Outras'
      @  8, 217 say 'Classif.Fiscal'
      @ 09,  0  say impchr(cIMPEXP) + repl( '-', 140 ) + impchr(cIMPCOM)
      CTLIN := 10
   endif
   mDBASEICM  := mDVALICM := mISENTAICM := mOUTRAICM := 0.00
   mDBASEIPI  := mDVALIPI := mISENTAIPI := mOUTRAIPI := 0.00
   mDVALORNF  := 0.00
   mORDEM     := ORDEM
   mNUMERO    := NUMERO
   mFORNECEDO := FORNECEDO
   mDATA      := DATA
   mDOPER     := DOPER
   mDIPI      := DIPI
   mDICM      := DICM
   mDCLASSIPI := DCLASSIPI
   xDOPER    := IF(cAPUNEW="N",DOPER,DCFONEW)
   xSUBDOPER := SUBDOPER
   xDIPI     := DIPI
   xDICM     := DICM
   xCHKIPI   := CHKIPI
   while xLOTE = LOTE .and. xDOPER = IF(cAPUNEW="N",DOPER,DCFONEW) .and. xDIPI = DIPI .and. xCHKIPI = CHKIPI.and. xDICM = DICM  .and. !eof()
      if SOMACANCEL()
         mDVALORNF  += DVALORNF
         mDBASEICM  += DBASEICM
         mDVALICM   += DVALICM
         mISENTAICM += ISENTAICM
         mOUTRAICM  += OUTRAICM
         mDBASEIPI  += DBASEIPI
         mDVALIPI   += DVALIPI
         mISENTAIPI += ISENTAIPI
         mOUTRAIPI  += OUTRAIPI
      endif
      dbskip()
   enddo
   @ CTLIN,  0  say mORDEM     pict '999999'
   @ CTLIN,  8  say mNUMERO    pict '999999'
   @ CTLIN, 16  say mDATA
   IF cAPUNEW="N"
      @ CTLIN, 28 say xDOPER
      @ CTLIN, 32 say xSUBDOPER
   ELSE
      @ CTLIN, 28 say xDOPER  PICT "@R 9.999"
   ENDIF
   @ CTLIN, 35  say mDVALORNF  pict '@E 99,999,999,999.99'
   @ CTLIN, 55  say mDBASEICM  pict '@E 99,999,999,999.99'
   @ CTLIN, 75  say mDICM      pict '99'
   @ CTLIN, 79  say mDVALICM   pict '@E 99,999,999,999.99'
   @ CTLIN, 97  say mISENTAICM pict '@E 99,999,999,999.99'
   @ CTLIN, 117 say mOUTRAICM  pict '@E 99,999,999,999.99'
   @ CTLIN, 136 say mDBASEIPI  pict '@E 99,999,999,999.99'
   @ CTLIN, 155 say mDIPI      pict '99'
   @ CTLIN, 159 say mDVALIPI   pict '@E 99,999,999,999.99'
   @ CTLIN, 178 say mISENTAIPI pict '@E 99,999,999,999.99'
   @ CTLIN, 196 say mOUTRAIPI  pict '@E 99,999,999,999.99'
   @ CTLIN, 218 say mDCLASSIPI
   CTLIN ++
   //Acumuladores Gerais.
   tDVALORNF += mDVALORNF
   tDBASEICM += mDBASEICM
   tDVALICM  += mDVALICM
   tISENTAIC += mISENTAICM
   tOUTRAICM += mOUTRAICM
   tDBASEIPI += mDBASEIPI
   tDVALIPI  += mDVALIPI
   tISENTAIP += mISENTAIPI
   tOUTRAIPI += mOUTRAIPI
   if CTLIN > 55
      CTLIN ++
      @ CTLIN,  0 say impchr(cIMPEXP) + repl( '-', 140 ) + impchr(cIMPCOM)
      CTLIN ++
   endif
enddo
CTLIN ++
@ CTLIN,  0 say impchr(cIMPEXP) + repl( '-', 140 ) + impchr(cIMPCOM)
CTLIN ++
@ CTLIN, 00  say 'Totais Gerais ....................'
@ CTLIN, 35  say tDVALORNF                            pict '@E 99,999,999,999.99'
@ CTLIN, 55  say tDBASEICM                            pict '@E 99,999,999,999.99'
@ CTLIN, 79  say tDVALICM                             pict '@E 99,999,999,999.99'
@ CTLIN, 97  say tISENTAIC                            pict '@E 99,999,999,999.99'
@ CTLIN, 117 say tOUTRAICM                            pict '@E 99,999,999,999.99'
@ CTLIN, 136 say tDBASEIPI                            pict '@E 99,999,999,999.99'
@ CTLIN, 159 say tDVALIPI                             pict '@E 99,999,999,999.99'
@ CTLIN, 178 say tISENTAIP                            pict '@E 99,999,999,999.99'
@ CTLIN, 196 say tOUTRAIPI                            pict '@E 99,999,999,999.99'
if ZFOL > 0
   CTLIN ++
   @ CTLIN,  0 say impchr(cIMPEXP) + repl( '-', 140 )
   CTLIN ++
endif
IMPFOL()
dbcloseall()
retu

*+ EOF: M_BDIB.PRG
