// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdia.prg
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
// +    Source Module => J:\ITAESBRA\M_BDIA.PRG
// +
// +    Functions: Function M_BDIA01()
// +
// +    Reformatted by Click! 2.03 on Dec-5-2002 at  2:54 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"



// Modo de Trabalho no Video
MDI( " Э Imprimir Relatўrio " )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cEMP := IMP( "ZEMP" )

aRETU   := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
MES     := aRETU[ 1 ]
ANO     := aRETU[ 2 ]
cARQENT := aRETU[ 5, 1 ]
cARQSAI := aRETU[ 5, 2 ]
cVAR    := aRETU[ 7 ]
cCABAUX := Space( 40 )
cAPUNEW := "S"


cTIPOCAN := "T"
cTIPREL  := "S"
@ 21, 00 SAY "Quebrar por Unidade"
@ 22, 00 SAY "Cabe‡ario Aux."
@ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24, 00 SAY "Apurar CFO Novo"
@ 21, 00 GET cTIPREL                                       PICTURE "!" VALID cTIPREL $ "SN"
@ 22, 20 GET cCABAUX
@ 23, 45 GET cTIPOCAN                                      PICTURE "!" VALID cTIPOCAN $ "TCN"
@ 24, 40 GET cAPUNEW                                       PICTURE "!" VALID cAPUNEW $ "SN"
IF !READCUR()
RETU .F.
ENDIF

IF MDG( "Entradas" )
M_BDIA01( cARQENT, "DIPI - Nota Fiscal de Entradas" )
ENDIF
IF MDG( "Saidas" )
M_BDIA01( cARQSAI, "DIPI - Nota Fiscal de Saidas" )
ENDIF
VIDEO()

IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function M_BDIA01()
// +
// +    Called from ( m_bdia.prg   )   2 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDIA01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_BDIA01( ARQWORK )

// Vari veis de Trabalho
   CTLIN     := 1
   xUNIDADE  := Space( 2 )
   xDVALORNF := xDBASEICM := xDVALICM := xISENTAICM := 0.00
   xOUTRAICM := xDBASEIPI := xDVALIPI := xISENTAIPI := xOUTRAIPI := 0.00
   xOBSICM   := xOBSIPI := 0
   tDVALORNF := tDBASEICM := tDVALICM := tISENTAICM := 0.00
   tOUTRAICM := tDBASEIPI := tDVALIPI := tISENTAIPI := tOUTRAIPI := 0.00
   tOBSICM   := tOBSIPI := 0
   xQTDE     := 0.000
   tQTDE     := 0.000

   FILTRO := ''
   FILTRO := RFILORD( ARQWORK, .F. )

   CTLIN := 80
   IF !USEREDE( ARQWORK, 1, 0 )
      RETU
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cAPUNEW = "N"
      ordDestroy( "temp" )
      ordCreate(, "temp", "dcfonew+dclassipi+unidade" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "doper+dclassipi+unidade" )
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

   WHILE !Eof()
      xDOPER := IF( cAPUNEW = "N", DOPER, DCFONEW )
      WHILE xDOPER = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. !Eof()
         xDCLASSIPI := DCLASSIPI
         xUNIDADE   := UNIDADE
         WHILE if( cTIPREL = "S", xUNIDADE = UNIDADE, .T. ) .AND. ;
               xDCLASSIPI = DCLASSIPI .AND. xDOPER = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. !Eof()
            IF SOMACANCEL()
               // Acumuladores de Totais Gerais.
               xDVALORNF  += DVALORNF
               xDBASEICM  += DBASEICM
               xDVALICM   += DVALICM
               xISENTAICM += ISENTAICM
               xOUTRAICM  += OUTRAICM
               xOBSICM    += OBSICM
               xDBASEIPI  += DBASEIPI
               xDVALIPI   += DVALIPI
               xISENTAIPI += ISENTAIPI
               xOUTRAIPI  += OUTRAIPI
               xOBSIPI    += OBSIPI
               xQTDE      += QUANT
            ENDIF
            dbSkip()
         ENDDO
         IF CTLIN > 55
            IF CTLIN <> 80 .AND. CTLIN < 60
               @ CTLIN, 0 SAY repl( '-', 230 )
            ENDIF
            ZFOL++
            @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
            @  1, 83  SAY cVAR
            @  1, 97  SAY ZDATA
            @  1, 113 SAY Left( Time(), 5 )
            @  1, 128 SAY Str( ZFOL, 4 )
            @  2, 0   SAY repl( "-", 132 )
            @  3, 01  SAY 'DIPI-A'
            @  3, 20  SAY cCABAUX
            @  6, 2   SAY impchr( cIMPTIT ) + cEMP + impchr( cIMPEXP )
            @  7, 00  SAY impchr( cIMPCOM ) + repl( '-', 230 )
            @  9, 00  SAY 'Cod.Fisc.'
            @  9, 12  SAY 'Classific.'
            @  9, 32  SAY 'Total da NF'
            @  9, 47  SAY 'Base ICM'
            @  9, 62  SAY 'Valor ICM'
            @  9, 77  SAY 'Isentas ICM'
            @  9, 92  SAY 'Outras ICM'
            @  9, 107 SAY 'OBS ICM'
            @  9, 122 SAY 'Base IPI'
            @  9, 137 SAY 'Valor IPI'
            @  9, 152 SAY 'Isentas IPI'
            @  9, 167 SAY 'Outras IPI'
            @  9, 182 SAY 'Obs IPI'
            IF cTIPREL = "S"
               @  9, 197 SAY 'Unid.  Quantidade'
            ENDIF
            @ 10, 00 SAY repl( '-', 230 )
            CTLIN := 11
         ENDIF
         @ CTLIN, 02  SAY xDOPER + '  -'
         @ CTLIN, 10  SAY xDCLASSIPI
         @ CTLIN, 32  SAY xDVALORNF    PICT '@E 99,999,999.99'
         @ CTLIN, 47  SAY xDBASEICM    PICT '@E 99,999,999.99'
         @ CTLIN, 62  SAY xDVALICM     PICT '@E 99,999,999.99'
         @ CTLIN, 77  SAY xISENTAICM   PICT '@E 99,999,999.99'
         @ CTLIN, 92  SAY xOUTRAICM    PICT '@E 99,999,999.99'
         @ CTLIN, 107 SAY xOBSICM      PICT '@E 99,999,999.99'
         @ CTLIN, 122 SAY xDBASEIPI    PICT '@E 99,999,999.99'
         @ CTLIN, 137 SAY xDVALIPI     PICT '@E 99,999,999.99'
         @ CTLIN, 152 SAY xISENTAIPI   PICT '@E 99,999,999.99'
         @ CTLIN, 167 SAY xOUTRAIPI    PICT '@E 99,999,999.99'
         @ CTLIN, 182 SAY xOBSIPI      PICT '@E 99,999,999.99'
         IF cTIPREL = "S"
            @ CTLIN, 197 SAY xUNIDADE PICT '@!'
            @ CTLIN, 200 SAY xQTDE    PICT '@E 999999999.999'
         ENDIF
         CTLIN++
         // Total Geral de cada item.
         tDVALORNF  += xDVALORNF
         tDBASEICM  += xDBASEICM
         tDVALICM   += xDVALICM
         tISENTAICM += xISENTAICM
         tOUTRAICM  += xOUTRAICM
         tOBSICM    += xOBSICM
         tDBASEIPI  += xDBASEIPI
         tDVALIPI   += xDVALIPI
         tISENTAIPI += xISENTAIPI
         tOUTRAIPI  += xOUTRAIPI
         tOBSIPI    += xOBSIPI
         tQTDE      += xQTDE

         // zera vari veis
         xDVALORNF := xDBASEICM := xDVALICM := xISENTAICM := 0.00
         xOUTRAICM := xDBASEIPI := xDVALIPI := xISENTAIPI := xOUTRAIPI := 0.00
         xQTDE     := 0.000
         xOBSICM   := xOBSIPI := 0
      ENDDO
      @ CTLIN, 00 SAY repl( '-', 230 )
      CTLIN++
      @ CTLIN, 00  SAY 'Totais : '
      @ CTLIN, 32  SAY tDVALORNF   PICT '@E 99,999,999.99'
      @ CTLIN, 47  SAY tDBASEICM   PICT '@E 99,999,999.99'
      @ CTLIN, 62  SAY tDVALICM    PICT '@E 99,999,999.99'
      @ CTLIN, 77  SAY tISENTAICM  PICT '@E 99,999,999.99'
      @ CTLIN, 92  SAY tOUTRAICM   PICT '@E 99,999,999.99'
      @ CTLIN, 107 SAY tOBSICM     PICT '@E 99,999,999.99'
      @ CTLIN, 122 SAY tDBASEIPI   PICT '@E 99,999,999.99'
      @ CTLIN, 137 SAY tDVALIPI    PICT '@E 99,999,999.99'
      @ CTLIN, 152 SAY tISENTAIPI  PICT '@E 99,999,999.99'
      @ CTLIN, 167 SAY tOUTRAIPI   PICT '@E 99,999,999.99'
      @ CTLIN, 182 SAY tOBSIPI     PICT '@E 99,999,999.99'
      @ CTLIN, 200 SAY tQTDE       PICT '@E 999999999.999'
      CTLIN++
      @ CTLIN, 00 SAY repl( '-', 230 )
      CTLIN += 2
      // Zera Totais.
      tDVALORNF := tDBASEICM := tDVALICM := tISENTAICM := 0.00
      tOUTRAICM := tDBASEIPI := tDVALIPI := tISENTAIPI := tOUTRAIPI := 0.00
      tOBSICM   := tOBSIPI := 0
      tQTDE     := 0.000
   ENDDO
   dbCloseAll()
   IMPFOL()

// + EOF: M_BDIA.PRG

// + EOF: m_bdia.prg
// +
