// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdim.prg
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_BDIM.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// #INCLUDE "COMANDO.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdim()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdim

   PARA cIMPOSTO

   IF cIMPOSTO = "IPI"
      MDI( " н Resumo por Aliquotas IPI" )
   ELSE
      MDI( " н Resumo por Aliquotas ICM" )
   ENDIF

   cTIPOCAN := "T"
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Цo Canceladas"
   @ 23, 40 GET cTIPOCAN                                      PICT "!" VALID cTIPOCAN $ "TCN"
   IF !READCUR()
      RETU .F.
   ENDIF


   aRETU   := PERFEC( { "MM06", "MK06" }, { "M6", "K6" }, { "MM96", "MK96" } )
   nMESUSO := aRETU[ 1 ]
   nANOUSO := aRETU[ 2 ]
   cARQSAI := aRETU[ 5, 1 ]
   cARQENT := aRETU[ 5, 2 ]
   CAB     := aRETU[ 7 ]

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   IF MDG( "Listar Entradas" )
      M_BDIM01( cARQENT )
   ENDIF
   IF MDG( "Listar Saidas" )
      M_BDIM01( cARQSAI )
   ENDIF
   IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDIM01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_BDIM01( cARQ )

   ZFOL   := 1
   CTLIN  := 1
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF !USEREDE( cARQ, 1, 0 )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cIMPOSTO = "IPI"
      ordDestroy( "temp" )
      ordCreate(, "temp", "STR(ORDEM,8)+STR(DIPI,5,2)" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "STR(ORDEM,8)+STR(DICM,5,2)" )
      ordSetFocus( "temp" )
   ENDIF

   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   IMPRESSORA()
   dbGoTop()
   WHILE !Eof()
      xLOTE    := LOTE
      xDATA    := DATA
      xDATAREF := DATAREF
      xNUMERO  := NUMERO
      xDOPER   := DOPER
      xORDEM   := ORDEM
      xDIPI    := DIPI
      xDICM    := DICM
      aTOTCOD  := Array( 11 )
      AFill( aTOTCOD, 0 )
      WHILE xORDEM = ORDEM .AND. IF( cIMPOSTO = "IPI", xDIPI, xDICM ) = IF( cIMPOSTO = "IPI", DIPI, DICM ) .AND. !Eof()
         IF SOMACANCEL()
            aTOTCOD[ 1 ] += DVALORNF
            aTOTCOD[ 2 ] += DBASEICM
            aTOTCOD[ 3 ] += DVALICM
            aTOTCOD[ 4 ] += ISENTAICM
            aTOTCOD[ 5 ] += OUTRAICM
            aTOTCOD[ 6 ] += OBSICM
            aTOTCOD[ 7 ] += DBASEIPI
            aTOTCOD[ 8 ] += DVALIPI
            aTOTCOD[ 9 ] += ISENTAIPI
            aTOTCOD[ 10 ] += OUTRAIPI
            aTOTCOD[ 11 ] += OBSIPI
         ENDIF
         dbSkip()
      ENDDO
      IF CTLIN > 55
         @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
         @  1, 83  SAY CAB
         @  1, 97  SAY ZDATA
         @  1, 113 SAY Left( Time(), 5 )
         @  1, 128 SAY Str( ZFOL, 4 )
         @  2, 0   SAY repl( "-", 132 )
         IF cIMPOSTO = "IPI"
            @  3, 0 SAY "Resumo por Aliquotas de IPI"
         ELSE
            @  3, 0 SAY "Resumo por Aliquotas de ICM"
         ENDIF
         @  4, 0 SAY repl( "-", 132 )
         CTLIN := 5
         ZFOL++
      ENDIF
      mXICM := if( aTOTCOD[ 3 ] > 0, "T", "" )
      mXIPI := if( aTOTCOD[ 8 ] > 0, "T", "" )
      mXICM += if( aTOTCOD[ 4 ] > 0, "I", "" )
      mXIPI += if( aTOTCOD[ 9 ] > 0, "I", "" )
      mXICM += if( aTOTCOD[ 5 ] > 0, "O", "" )
      mXIPI += if( aTOTCOD[ 10 ] > 0, "O", "" )

      @ CTLIN, 0 SAY "SEQUENCIA-" + StrZero( xLOTE, 5 ) + " DATA ENTRADA-" + DToC( xDATAREF ) + " DATA DOCUMENTO-" + DToC( xDATA ) + " NUN. DOC.-" + Str( xNUMERO, 8 )
      CTLIN++
      @ CTLIN, 0 SAY "VALOR CONT./SUBST." + spac( 19 ) + "BASE DE CALCULO            VALOR ICMS/IPI      VALOR ISENTO      VALOR OUTROS   OBSERVACAO"
      CTLIN++
      mBDIL01( { aTOTCOD[ 1 ], aTOTCOD[ 2 ], aTOTCOD[ 3 ], aTOTCOD[ 4 ], aTOTCOD[ 5 ], aTOTCOD[ 6 ] }, .F., { "COD.ICMS-", mXICM, xDICM } )
      mBDIL01( { 0, aTOTCOD[ 7 ], aTOTCOD[ 8 ], aTOTCOD[ 9 ], aTOTCOD[ 10 ], aTOTCOD[ 11 ] }, .T., { "COD.IPI -", mXIPI, xDIPI } )
   ENDDO
   IMPFOL()
   VIDEO()

// + EOF: M_BDIM.PRG

// + EOF: m_bdim.prg
// +
