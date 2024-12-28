// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdid.prg
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

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_BDID.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"


// Modo de Trabalho no Video
MDI( " þ Imprimir Relat?io Checagem DIPI " )
IF !CHECKIMP( 0 )
RETU
ENDIF
cEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )

cAPUNEW  := "S"
cCABAUX  := Space( 40 )
cTIPOCAN := "T"
aRETU    := PERFEC( { "MK02", "MK06", "MM02", "MM06" }, { "K2", "K6", "M2", "M6" }, { "MK92", "MK96", "MM92", "MM96" } )


@ 21, 00 SAY "Informe Cabe‡ario Auxiliar"
@ 22, 00 SAY "Grupo (T)odos (C)anceladas (N)? Canceladas"
@ 23, 00 SAY "Apurar CFO Novo"
@ 21, 30 GET cCABAUX
@ 22, 45 GET cTIPOCAN                                     PICT "!" VALID cTIPOCAN $ "TCN"
@ 23, 40 GET cAPUNEW                                      PICT "!" VALID cAPUNEW $ "SN"
IF !READCUR()
RETU .F.
ENDIF


nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQENT := aRETU[ 5, 1 ]
cARQEN2 := aRETU[ 5, 2 ]
cARQSAI := aRETU[ 5, 3 ]
cARQSA2 := aRETU[ 5, 4 ]
cVAR    := aRETU[ 7 ]


lRESNF   := MDG( "Deseja Resumo Classifica‡„o NF" )
lRESDIPI := MDG( "Deseja Resumo Classifica‡„o DIPI" )
lXNFDIPI := MDG( "Deseja Resumo NF x DIPI" )
lXDIPINF := MDG( "Deseja Resumo DIPI x NF" )
lRESVAL  := MDG( "Deseja Resumo Soma Valores x Contabil" )


IF MDG( "Listar Entrada" )
M_BDID01( cARQENT, cARQEN2, "E" )
ENDIF
IF MDG( "Listar Saida" )
M_BDID01( cARQSAI, cARQSA2, "S" )
ENDIF
IMPEND()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDID01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_BDID01( ARQWORK, ARQWOR2, Ctipo )

   ZFOL  := 0
   CTLIN := 80
   IF !USEMULT( { { ARQWOR2, 1, 99 }, { ARQWORK, 1, 99 } } )
      RETU
   ENDIF
   dbSelectAr( ARQWORK )
   dbSetOrder( 4 )   // Numero da Nota
   nLAST01 := LastRec()
   dbSelectAr( ARQWOR2 )
   dbSetOrder( 3 )   // Numero da Nota
   nLAST02 := LastRec()

   IMPRESSORA()
   IF lRESNF
      VIDEO()
      MDS( "Resumo Operacao Classificacao NF" )
      IMPRESSORA()
      dbSelectAr( ARQWORK )
      dbGoTop()
      WHILE !Eof()
         IF Empty( IF( cAPUNEW = "S", CFONEW, OPERACAO ) ) .OR. Empty( CLASSIPI ) .AND. SOMACANCEL()
            M_BDID02( "Numero   CFO     Classipi" + spac( 7 ) + "Valor Total" + spac( 8 ) + "Valor Mercadora    Valor Ipi" )
            @ CTLIN, 0  SAY if( cTIPO = "S", NUMERO, NRNOTA )                                                PICTURE '99999999'
            @ CTLIN, 9  SAY IF( cAPUNEW = "S", AllTrim( CFONEW ) + IF( Empty( CFONEWB ), "", "/" + CFONEWB ), OPERACAO )
            @ CTLIN, 19 SAY CLASSIPI
            @ CTLIN, 34 SAY VALORTOT                                                                     PICTURE '@E 9999,999.99'
            @ CTLIN, 50 SAY VALORMER                                                                     PICTURE '@E 9999,999.99'
            @ CTLIN, 64 SAY VALORIPI                                                                     PICTURE '@E 9999,999.99'
            CTLIN++
         ENDIF
         dbSelectAr( ARQWORK )
         dbSkip()
         video()
         zei_fort( nLAST01 )
         impressora()
      ENDDO
      IMPFOL()
   ENDIF
   IF lRESDIPI
      VIDEO()
      MDS( "Resumo Operacao Classificacao DIPI" )
      IMPRESSORA()
      CTLIN := 80
      dbSelectAr( ARQWOR2 )
      dbGoTop()
      WHILE !Eof()
         IF Empty( IF( cAPUNEW = "N", DOPER, DCFONEW ) ) .OR. Empty( DCLASSIPI ) .AND. SOMACANCEL()
            M_BDID02( "Numero   CFO     Classipi" + spac( 7 ) + "Valor Total" + spac( 8 ) + "Valor Mercadora    Valor Ipi" )
            @ CTLIN, 0  SAY NUMERO                          PICTURE '99999999'
            @ CTLIN, 9  SAY IF( cAPUNEW = "N", DOPER, DCFONEW )
            @ CTLIN, 17 SAY DCLASSIPI
            @ CTLIN, 32 SAY DVALORNF                        PICTURE '@E 999,999,999.99'
            @ CTLIN, 62 SAY DVALIPI                         PICTURE '@E 999,999,999.99'
            CTLIN++
         ENDIF
         dbSelectAr( ARQWOR2 )
         dbSkip()
         video()
         zei_fort( nLAST02 )
         impressora()
      ENDDO
      IMPFOL()
   ENDIF
   IF lXNFDIPI
      VIDEO()
      MDS( "Resumo Cruzamento NFxDIPI" )
      IMPRESSORA()
      CTLIN := 80
      dbSelectAr( ARQWORK )
      dbGoTop()
      WHILE !Eof()
         mNUMERO := if( cTIPO = "S", NUMERO, NRNOTA )
         dbSelectAr( ARQWOR2 )
         dbGoTop()
         IF !dbSeek( mNUMERO )
            M_BDID02( "" )
            @ CTLIN, 00 SAY "Nota " + Str( mNUMERO ) + ACENTO( " N„o Esta na Dipi " ) + cVAR
            CTLIN++
         ENDIF
         dbSelectAr( ARQWORK )
         WHILE if( cTIPO = "S", NUMERO, NRNOTA ) = mNUMERO .AND. !Eof()
            dbSkip()
         ENDDO
         video()
         zei_fort( nLAST01 )
         impressora()
      ENDDO
      IMPFOL()
   ENDIF
   IF lRESVAL
      VIDEO()
      MDS( "Resumo Base x Valores" )
      IMPRESSORA()
      CTLIN := 80
      dbSelectAr( ARQWOR2 )
      SET FILTER TO
      dbGoTop()
      WHILE !Eof()
         nVALDIF := DVALORNF - ( DBASEIPI + DVALIPI + OUTRAIPI + OBSIPI + ISENTAIPI )
         IF ( nVALDIF <= -0.01 ) .OR. ( nVALDIF >= 0.01 ) .AND. SOMACANCEL()
            M_BDID02( "" )
            @ CTLIN, 00 SAY "Nota " + Str( NUMERO, 8 ) + "." + Str( ITEM, 3 ) + " Valores Nao Conferem"
            CTLIN++
            @ CTLIN, 00 SAY DVALORNF  PICTURE '@E 9999999.99'
            @ CTLIN, 11 SAY DBASEIPI  PICTURE '@E 9999999.99'
            @ CTLIN, 22 SAY DVALIPI   PICTURE '@E 9999999.99'
            @ CTLIN, 33 SAY OUTRAIPI  PICTURE '@E 9999999.99'
            @ CTLIN, 44 SAY ISENTAIPI PICTURE '@E 9999999.99'
            @ CTLIN, 55 SAY OBSIPI    PICTURE '@E 9999999.99'
            @ CTLIN, 66 SAY nVALDIF   PICTURE '@E 9999999.99'
            CTLIN++
         ENDIF
         dbSkip()
         video()
         zei_fort( nLAST02 )
         impressora()
      ENDDO
      IMPFOL()
   ENDIF
   IF lXDIPINF
      VIDEO()
      MDS( "Resumo Cruzamento DIPIxNF" )
      IMPRESSORA()
      CTLIN := 80
      dbSelectAr( ARQWOR2 )
      SET FILTER TO
      dbGoTop()
      WHILE !Eof()
         mNUMERO := NUMERO
         dbSelectAr( ARQWORK )
         dbGoTop()
         IF !dbSeek( mNUMERO )
            M_BDID02( "" )
            @ CTLIN, 00 SAY "Nota " + Str( mNUMERO ) + ACENTO( " N„o Esta na NF " ) + cVAR
            CTLIN++
         ENDIF
         dbSelectAr( ARQWOR2 )
         WHILE NUMERO = mNUMERO .AND. !Eof()
            dbSkip()
         ENDDO
         video()
         zei_fort( nLAST02 )
         impressora()
      ENDDO
   ENDIF
   dbCloseAll()
   VIDEO()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDID02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_BDID02( cDIZ )

   IF CTLIN > 55
      IF CTLIN <> 80 .AND. CTLIN < 60
         @ CTLIN, 0 SAY repl( '-', 80 )
      ENDIF
      ZFOL++
      @  1, 0  SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S  REF.:" + cVAR + " DATA:" + DToC( ZDATA ) + " HORA:" + Left( Time(), 5 ) + " F.:" + Str( ZFOL, 4 )
      @  2, 01 SAY 'DIPI-D Checagem Nota Fiscal ' + cEMP
      @  3, 20 SAY cCABAUX
      CTLIN := 4
      IF !Empty( cDIZ )
         @ CTLIN, 0 SAY cDIZ
         CTLIN++
      ENDIF
      @ CTLIN, 00 SAY repl( '-', 80 )
      CTLIN++
   ENDIF

// + EOF: M_BDID.PRG

// + EOF: m_bdid.prg
// +
