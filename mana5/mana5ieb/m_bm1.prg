// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm1.prg
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
// +    Source Module => J:\ITAESBRA\M_BM1.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bm1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bm1

   PARA cARQPRI

   IF cARQPRI = "MM01"
      cCABREF := "Resumo NF Saidas"
      aRETU   := PERFEC( { "MM01" }, { "M1" }, { "MM91" }, { "PADRAO" } )
   ELSE
      cCABREF := "Resumo NF Entradas"
      aRETU   := PERFEC( { "MK01" }, { "K1" }, { "MK91" }, { "PADRAO" } )
   ENDIF



// Modo de Trabalho no Video
   MDI( " Э Imprimir Relatўrio da " + cCABREF )

   lCOM := MDG( "Comprimido" )

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF
   cEMP   := IMP( "ZEMP" )
   cRESET := IMP( "RESET" )


   nMES    := aRETU[ 1 ]
   nANO    := aRETU[ 2 ]
   ARQWORK := aRETU[ 5, 1 ]
   cCAB    := aRETU[ 7 ]


   OPCAO( 10, 10, " A - Marcados Para Apurar     ", 65 )
   OPCAO( 12, 10, " B - Marcados Para NЋO Apurar ", 66 )
   OPCAO( 14, 10, " C - Todos os Itens           ", 67 )
   nAPURA := menu(, 0 )
   FILTRO := ""
   DO CASE
   CASE nAPURA = 1
      FILTRO := 'APURA#"N"'
   CASE nAPURA = 2
      FILTRO := 'APURA="N"'
   ENDCASE

   FILTRO := RFILORD( cARQPRI, .F., FILTRO )
   CTLIN  := NRCOPIA := 1
   VEZES  := 0
   @ 24, 00
   @ 24, 00 SAY "NЈmero de cўpias:" GET NRCOPIA PICT '99'
   READCUR()

   IF !USEREDE( ARQWORK, 1, 1 )
      RETU
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF

   IMPRESSORA()
   IF Lcom
      @  0, 0 SAY IMPSTR( aCHR[ 1 ] )
   ENDIF

   FOR W := 1 TO NRCOPIA
      CTLIN   := 80
      ZPAGINA := 0
      TOT1    := TOT2 := TOT3 := TOT4 := TOT5 := 0.00
      dbGoTop()
      WHILE !Eof()
         IF CTLIN > 55
            ZPAGINA++
            @  0, 0 SAY cEMP
            IF cARQPRI = "MM01"
               @  1, 01 SAY 'M_BM1'
            ELSE
               @  1, 01 SAY 'M_BK1'
            ENDIF
            @  1, 20  SAY cCABREF
            @  1, 80  SAY Time()
            @  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
            @  1, 110 SAY ACENTO( '    Folha: ' ) + Str( ZPAGINA, 2 )
            @  2, 0   SAY repl( '-', 132 )
            @ 03, 00  SAY 'N.Fis'
            @ 03, 12  SAY ' Emissao'
            @ 03, 24  SAY 'Cliente Destinado'
            @ 03, 47  SAY 'Operacao'
            @ 03, 58  SAY 'Vencimento' // NOVO
            @ 03, 73  SAY 'Total Mercador'
            @ 03, 95  SAY 'Total da Nota '
            @ 04, 0   SAY repl( '-', 132 )
            CTLIN := 5
         ENDIF
         IF cARQPRI = "MM01"
            @ CTLIN, 00 SAY NUMERO PICT '99999999'
         ELSE
            @ CTLIN, 00 SAY NRNOTA PICT '99999999'
         ENDIF
         @ CTLIN, 12 SAY DATA
         @ CTLIN, 24 SAY StrZero( FORNECEDO, 4 )
         @ CTLIN, 30 SAY COGNOME
         @ CTLIN, 48 SAY IF( Empty( CFONEW ), Left( OPERACAO, 10 ), AllTrim( CFONEW ) + "/" + AllTrim( CFONEWB ) )
         @ CTLIN, 58 SAY DAT01
         @ CTLIN, 73 SAY TOTMER                                                                   PICT '999,999,999.99'
         @ CTLIN, 95 SAY TOTNF                                                                    PICT '999,999,999.99'
         TOT1 += TOTMER
         TOT3 += TOTNF
         CTLIN++
         dbSkip()
      ENDDO
      @ CTLIN, 0 SAY '*' + repl( '-', 131 ) + '*'
      CTLIN++
      @ CTLIN, 56 SAY TOT1 PICT '999,999,999.99'
      @ CTLIN, 87 SAY TOT3 PICT '999,999,999.99'
      CTLIN++
      IF ZPAGINA > 0
         @ CTLIN, 0 SAY '*' + repl( '-', 131 ) + '*'
         CTLIN++
      ENDIF
      ZPAGINA := 0
   NEXT W
   VIDEO()
   dbCloseArea()
   IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function PERACU()
// +
// +    Called from ( m_bdia.prg   )   1 -
// +                ( m_bdib.prg   )   1 -
// +                ( m_bdic.prg   )   1 -
// +                ( m_bm1.prg    )   1 - function peracu()
// +                ( m_bm3.prg    )   1 - function peracu()
// +                ( m_bm4.prg    )   1 - function peracu()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PERACU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PERACU

   IF MDG( "Mes j  Fechado" )
      cVAR    := MESANO()
      ARQWORK := cCARREF + cVAR
      IF MDG( "Deseja Convertido" )
         MES := Val( Right( cVAR, 2 ) )
         ANO := Val( "19" + Left( cVAR, 2 ) )
         MDS( "Confirme MES/ANO Conversao" )
         @ 24, 40 GET MES
         @ 24, 60 GET ANO
         READCUR()
         lACUMULA := .T.
      ENDIF
   ENDIF
   IF MDG( "Acumulado" )
      IF MDG( "Deseja Reacumular" )
         SOMAANO( cARQACU, cCARREF, "PADRAO" )   // pela competencia
      ENDIF
      ARQWORK  := cARQACU
      lACUMULA := .T.
   ENDIF
   MDS( "Informe Cabe‡ario Auxiliar" )
   @ 24, 30 GET cCABAUX
   READCUR()
   RETU .T.

// + EOF: M_BM1.PRG

// + EOF: m_bm1.prg
// +
