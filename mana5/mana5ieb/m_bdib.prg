// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdib.prg
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
// +    Source Module => J:\ITAESBRA\M_BDIB.PRG
// +
// +    Reformatted by Click! 2.03 on Dec-5-2002 at  3:22 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdib()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdib

   PARA cARQPRI, cARQACU, cCARREF, cCABREF

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
   MDI( " Э Relatўrio da DIPI " )

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   cCABAUX  := Space( 40 )
   cTIPOCAN := "T"
   cAPUNEW  := "S"
   @ 22, 00 SAY "Cabe‡ario Aux."
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 22, 20 GET cCABAUX
   @ 23, 45 GET cTIPOCAN                                      PICT "!" VALID cTIPOCAN $ "TCN"
   @ 24, 40 GET cAPUNEW                                       PICT "!" VALID cAPUNEW $ "SN"
   IF !READCUR()
      RETU .F.
   ENDIF

   aRETU   := PERFEC( { "MM06", "MK06" }, { "M6", "K6" }, { "MM96", "MK96" } )
   MES     := aRETU[ 1 ]
   ANO     := aRETU[ 2 ]
   cARQSAI := aRETU[ 5, 1 ]
   cARQENT := aRETU[ 5, 2 ]
   cVAR    := aRETU[ 7 ]


   lCPI := MDG( "Deseja Imprimir 12 CPI" )

   IF MDG( "Entradas" )
      M_BDIB01( cARQENT, "DIPI - Nota Fiscal de Entradas" )
   ENDIF
   IF MDG( "Saidas" )
      M_BDIB01( cARQSAI, "DIPI - Nota Fiscal de Saidas" )
   ENDIF

   VIDEO()
   IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDIB01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

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
   IF !USEREDE( ARQWORK, 1, 0 )
      RETU
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cAPUNEW = "N"
      ordDestroy( "temp" )
      ordCreate(, "temp", "STR(LOTE,5)+DOPER+STR(DIPI,2)+CHKIPI+STR(DICM,5,2)" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "STR(LOTE,5)+DCFONEW+STR(DIPI,2)+CHKIPI+STR(DICM,5,2)" )
      ordSetFocus( "temp" )
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   ZFOL := 0
   IF !Eof()
      IMPRESSORA()
   ENDIF
   IF lCPI
      SET PRINT ON
      QQOut( IMPCHR( 27 ) + IMPCHR( 77 ) )
      SET PRINT OFF
   ENDIF
   WHILE !Eof()
      IF CTLIN > 55
         ZFOL++
         @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
         @  1, 83  SAY cVAR
         @  1, 97  SAY ZDATA
         @  1, 113 SAY Left( Time(), 5 )
         @  1, 128 SAY Str( ZFOL, 4 )
         @  2, 0   SAY repl( "-", 132 )
         @  3, 01  SAY 'DIPI-B'
         @  3, 20  SAY cCABAUX
         @  5, 30  SAY impchr( cIMPTIT ) + ACENTO( cCABREF )
         @  6, 2   SAY impchr( cIMPTIT ) + cEMP + impchr( cIMPEXP )
         @  7, 0   SAY repl( '-', 140 ) + impchr( cIMPCOM )
         @  8, 0   SAY 'Ordem'
         @  8, 6   SAY ' N.F.'
         @  8, 17  SAY 'Data'
         @  8, 27  SAY 'Oper.'
         @  8, 39  SAY 'Total NF'
         @  8, 61  SAY 'Base ICM'
         @  8, 76  SAY '%'
         @  8, 83  SAY 'Valor ICM'
         @  8, 102 SAY 'Isentas'
         @  8, 121 SAY 'Outras'
         @  8, 139 SAY 'Base IPI'
         @  8, 156 SAY '%'
         @  8, 162 SAY 'ValorIPI'
         @  8, 182 SAY 'Isentas'
         @  8, 201 SAY 'Outras'
         @  8, 217 SAY 'Classif.Fiscal'
         @ 09, 0   SAY impchr( cIMPEXP ) + repl( '-', 140 ) + impchr( cIMPCOM )
         CTLIN := 10
      ENDIF
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
      xDOPER     := IF( cAPUNEW = "N", DOPER, DCFONEW )
      xSUBDOPER  := SUBDOPER
      xDIPI      := DIPI
      xDICM      := DICM
      xCHKIPI    := CHKIPI
      WHILE xLOTE = LOTE .AND. xDOPER = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. xDIPI = DIPI .AND. xCHKIPI = CHKIPI .AND. xDICM = DICM .AND. !Eof()
         IF SOMACANCEL()
            mDVALORNF  += DVALORNF
            mDBASEICM  += DBASEICM
            mDVALICM   += DVALICM
            mISENTAICM += ISENTAICM
            mOUTRAICM  += OUTRAICM
            mDBASEIPI  += DBASEIPI
            mDVALIPI   += DVALIPI
            mISENTAIPI += ISENTAIPI
            mOUTRAIPI  += OUTRAIPI
         ENDIF
         dbSkip()
      ENDDO
      @ CTLIN, 0  SAY mORDEM  PICT '999999'
      @ CTLIN, 8  SAY mNUMERO PICT '999999'
      @ CTLIN, 16 SAY mDATA
      IF cAPUNEW = "N"
         @ CTLIN, 28 SAY xDOPER
         @ CTLIN, 32 SAY xSUBDOPER
      ELSE
         @ CTLIN, 28 SAY xDOPER PICT "@R 9.999"
      ENDIF
      @ CTLIN, 35  SAY mDVALORNF  PICT '@E 99,999,999,999.99'
      @ CTLIN, 55  SAY mDBASEICM  PICT '@E 99,999,999,999.99'
      @ CTLIN, 75  SAY mDICM      PICT '99'
      @ CTLIN, 79  SAY mDVALICM   PICT '@E 99,999,999,999.99'
      @ CTLIN, 97  SAY mISENTAICM PICT '@E 99,999,999,999.99'
      @ CTLIN, 117 SAY mOUTRAICM  PICT '@E 99,999,999,999.99'
      @ CTLIN, 136 SAY mDBASEIPI  PICT '@E 99,999,999,999.99'
      @ CTLIN, 155 SAY mDIPI      PICT '99'
      @ CTLIN, 159 SAY mDVALIPI   PICT '@E 99,999,999,999.99'
      @ CTLIN, 178 SAY mISENTAIPI PICT '@E 99,999,999,999.99'
      @ CTLIN, 196 SAY mOUTRAIPI  PICT '@E 99,999,999,999.99'
      @ CTLIN, 218 SAY mDCLASSIPI
      CTLIN++
      // Acumuladores Gerais.
      tDVALORNF += mDVALORNF
      tDBASEICM += mDBASEICM
      tDVALICM  += mDVALICM
      tISENTAIC += mISENTAICM
      tOUTRAICM += mOUTRAICM
      tDBASEIPI += mDBASEIPI
      tDVALIPI  += mDVALIPI
      tISENTAIP += mISENTAIPI
      tOUTRAIPI += mOUTRAIPI
      IF CTLIN > 55
         CTLIN++
         @ CTLIN, 0 SAY impchr( cIMPEXP ) + repl( '-', 140 ) + impchr( cIMPCOM )
         CTLIN++
      ENDIF
   ENDDO
   CTLIN++
   @ CTLIN, 0 SAY impchr( cIMPEXP ) + repl( '-', 140 ) + impchr( cIMPCOM )
   CTLIN++
   @ CTLIN, 00  SAY 'Totais Gerais ....................'
   @ CTLIN, 35  SAY tDVALORNF                            PICT '@E 99,999,999,999.99'
   @ CTLIN, 55  SAY tDBASEICM                            PICT '@E 99,999,999,999.99'
   @ CTLIN, 79  SAY tDVALICM                             PICT '@E 99,999,999,999.99'
   @ CTLIN, 97  SAY tISENTAIC                            PICT '@E 99,999,999,999.99'
   @ CTLIN, 117 SAY tOUTRAICM                            PICT '@E 99,999,999,999.99'
   @ CTLIN, 136 SAY tDBASEIPI                            PICT '@E 99,999,999,999.99'
   @ CTLIN, 159 SAY tDVALIPI                             PICT '@E 99,999,999,999.99'
   @ CTLIN, 178 SAY tISENTAIP                            PICT '@E 99,999,999,999.99'
   @ CTLIN, 196 SAY tOUTRAIPI                            PICT '@E 99,999,999,999.99'
   IF ZFOL > 0
      CTLIN++
      @ CTLIN, 0 SAY impchr( cIMPEXP ) + repl( '-', 140 )
      CTLIN++
   ENDIF
   IMPFOL()
   dbCloseAll()
   RETU

// + EOF: M_BDIB.PRG

// + EOF: m_bdib.prg
// +
