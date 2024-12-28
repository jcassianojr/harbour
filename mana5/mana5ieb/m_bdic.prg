// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdic.prg
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

// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
// +
// +    Source Module => J:\ITAESBRA\M_BDIC.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdic()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdic

   PARA cARQPRI, cARQACU, cCARREF, cCABREF

// Modo de Trabalho no Video
   MDI( " Ý Imprimir Relat¢rio de Classifica‡ao " )

   cZEMP := IMP( "ZEMP" )
   cEMP  := IMP( "ZEMP" )


   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   cCABAUX  := Space( 40 )
   cTIPOCAN := "T"
   @ 22, 00 SAY "Cabe‡ario Aux."
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Æo Canceladas"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 22, 20 GET cCABAUX
   @ 23, 50 GET cTIPOCAN                                      PICT "!" VALID cTIPOCAN $ "TCN"
   @ 24, 40 GET cAPUNEW                                       PICT "!" VALID cAPUNEW $ "SN"
   IF !READCUR()
      RETU .F.
   ENDIF



   aRETU   := PERFEC( { "MM02", "MK02" }, { "M2", "K2" }, { "MM92", "MK92" } )
   MES     := aRETU[ 1 ]
   ANO     := aRETU[ 2 ]
   cARQSAI := aRETU[ 5, 1 ]
   cARQENT := aRETU[ 5, 2 ]
   cVAR    := aRETU[ 7 ]



   IF MDG( "Entradas" )
      M_BDIC01( cARQENT, "Classifica‡Æo Fisal - Nota Fiscal de Entradas", "E" )
   ENDIF
   IF MDG( "Saidas" )
      M_BDIC01( cARQSAI, "Classifica‡Æo Fiscal - Nota Fiscal de Saidas", "S" )
   ENDIF
   VIDEO()
   IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_BDIC01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC m_BDIC01( ARQWORK, cCABREF, cTIPO )

   CTLIN  := 80
   ZFOL   := 0
   FILTRO := ''
   FILTRO := RFILORD( ARQWORK, .F. )
   IF !USEREDE( ARQWORK, 1, 0 )
      RETU
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cAPUNEW = "N"
      ordDestroy( "temp" )
      ordCreate(, "temp", "OPERACAO+classipi" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "CFONEW+CFONEWB+classipi" )
      ordSetFocus( "temp" )
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF

   dbGoTop()
   IMPRESSORA()
   WHILE !Eof()
      xOPERACAO := IF( cAPUNEW = "N", OPERACAO, CFONEW + CFONEWB )
      yVALMER   := yTOTIPI := yTOTPES := yVALOUT := yTOTQTE := 0
      WHILE xOPERACAO = IF( cAPUNEW = "N", OPERACAO, CFONEW + CFONEWB ) .AND. !Eof()
         xCLASSIPI := CLASSIPI
         xVALMER   := xTOTIPI := xTOTPES := xVALOUT := xTOTQTE := 0
         WHILE xCLASSIPI = CLASSIPI .AND. xOPERACAO = IF( cAPUNEW = "N", OPERACAO, CFONEW + CFONEWB ) .AND. !Eof()
            IF IF( cTIPO = "E", .T., ESPECIE # "NFE" )
               IF VALORIPI > 0
                  xVALMER += VALORMER
                  yVALMER += VALORMER
               ELSE
                  xVALOUT += VALORMER
                  yVALOUT += VALORMER
               ENDIF
               xTOTIPI += VALORIPI
               xTOTPES += if( cTIPOE = "S", PESTOT, PESLIQ * QTDE )
               yTOTIPI += VALORIPI
               yTOTPES += if( cTIPOE = "S", PESTOT, PESLIQ * QTDE )
               xTOTQTE += QTDE
               yTOTQTE += QTDE
            ENDIF
            dbSkip()
         ENDDO
         IF CTLIN > 55
            ZFOL++
            @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
            @  1, 83  SAY cVAR
            @  1, 97  SAY ZDATA
            @  1, 113 SAY Left( Time(), 5 )
            @  1, 128 SAY Str( ZFOL, 4 )
            @  2, 0   SAY repl( "-", 132 )
            @  3, 01  SAY 'DIPI-C'
            @  3, 20  SAY cCABAUX
            @  5, 30  SAY impchr( cIMPTIT ) + ACENTO( cCABREF )
            @  6, 2   SAY impchr( cIMPTIT ) + cZEMP + impchr( cIMPEXP )
            @  7, 00  SAY repl( '-', 130 )
            @ 09, 01  SAY "CFO     Classifica‡„o  Valor Mercadoria   Valor IPI" + spac( 10 ) + "Outros" + spac( 13 ) + "Quantidade" + spac( 9 ) + "Peso total"
            @ 10, 00  SAY repl( '-', 130 )
            CTLIN := 11
         ENDIF
         @ CTLIN, 00 SAY xOPERACAO
         @ CTLIN, 08 SAY xCLASSIPI
         @ cTLIN, 23 SAY xVALMER   PICT '@E 999,999,999.99'
         @ CTLIN, 42 SAY xTOTIPI   PICT '@E 999,999,999.99'
         @ CTLIN, 61 SAY xVALOUT   PICT '@E 999,999,999.99'
         @ CTLIN, 80 SAY xTOTQTE   PICT '@E 9,999,999.999'
         @ CTLIN, 99 SAY xTOTPES   PICT '@E 9,999,999.999'
         CTLIN++
      ENDDO
      @ CTLIN, 0 SAY repl( '-', 132 )
      CTLIN++
      @ CTLIN, 00 SAY "Totais Gerais ................"
      @ CTLIN, 23 SAY yVALMER                          PICT '@E 999,999,999.99'
      @ CTLIN, 42 SAY yTOTIPI                          PICT '@E 999,999,999.99'
      @ CTLIN, 61 SAY yVALOUT                          PICT '@E 999,999,999.99'
      @ CTLIN, 80 SAY yTOTQTE                          PICT '@E 9,999,999.999'
      @ CTLIN, 99 SAY yTOTPES                          PICT '@E 9,999,999.999'
      CTLIN++
      @ CTLIN, 0 SAY repl( '-', 132 )
      CTLIN++
   ENDDO
   IMPFOL()
   dbCloseAll()

// + EOF: M_BDIC.PRG

// + EOF: m_bdic.prg
// +
