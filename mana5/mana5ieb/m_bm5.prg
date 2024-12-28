// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm5.prg
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
// +    Source Module => J:\ITAESBRA\M_BM5.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bm5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bm5

   PARA cTIPOARQ

   MDI( " Э Cruzar Apuracao NF / Apura‡„o Livro" )


   IF cTIPOARQ = "S"
      aRETU := PERFEC( { "MM02", "MM06" }, { "M2", "M6" }, { "MM92", "MM96" } )
   ELSE
      aRETU := PERFEC( { "MK02", "MK06" }, { "K2", "K6" }, { "MK92", "MK96" } )
   ENDIF
   nMES         := aRETU[ 1 ]
   nANO         := aRETU[ 2 ]
   ARQNF        := aRETU[ 5, 1 ]
   ARQLV        := aRETU[ 5, 2 ]
   mCOMPETENCIA := aRETU[ 7 ]


   cAPUNEW := "S"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 24, 40 GET cAPUNEW           PICT "!" VALID cAPUNEW $ "SN"

   IF !USEMULT( { { ARQLV, 1, 0 }, { ARQNF, 1, 0 }, { "MD04", 1, IF( cAPUNEW = "S", 2, 3 ) } } )
      RETU .F.
   ENDIF


   dbSelectAr( ARQLV )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "str( NUMERO, 8 ) + str( FORNECEDO, 5 ) + str( ITEM,5)" )
   ordSetFocus( "temp" )




   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   CTLIN  := 80
   nTOTNF := 0
   nTOTLV := 0
   nTOTAP := 0

   IMPRESSORA()
   dbSelectAr( ARQNF )
   dbGoTop()
   WHILE !Eof()
      IF cTIPOARQ = "S"
         mNUMERO := NUMERO
      ELSE
         mNUMERO := NRNOTA
      ENDIF
      VIDEO()
      @ 24, 00 SAY mNUMERO
      IMPRESSORA()
      IF APURA # "N"
         IF cTIPOARQ = "E"
            mCHAVE := Str( NRNOTA, 8 ) + Str( FORNECEDO, 5 ) + Str( ITEM, 5 )
         ELSE
            mCHAVE := Str( NUMERO, 8 ) + Str( FORNECEDO, 5 ) + Str( SEQ, 5 )
         ENDIF
         mVALORNF := VALORTOT
         cCFO     := IF( cAPUNEW = "S", CFONEW, Left( OPERACAO, 3 ) )
         nVALLV   := 0
         nTOTNF   += VALORTOT
         IF CTLIN > 50
            CTLIN := 4
         ENDIF
         @ CTLIN, 0  SAY mNUMERO  PICT "999999"
         @ CTLIN, 7  SAY OPERACAO
         @ CTLIN, 18 SAY mVALORNF PICT "@E 999,999.99"
         dbSelectAr( ARQLV )
         dbGoTop()
         IF dbSeek( mCHAVE )
            @ CTLIN, 29 SAY DVALORNF PICT "@E 999,999.99"
            nTOTLV += DVALORNF
            nVALLV := DVALORNF
            IF mVALORNF # DVALORNF
               @ CTLIN, 41 SAY "Dif"
            ENDIF
         ENDIF
         lDEBITA  := .F.
         lCREDITA := .F.
         mCFO     := DCFONEW
         dbSelectAr( "MD04" )
         dbGoTop()
         IF dbSeek( mCFO )
            IF PIS = "+" .AND. FIN = "+"
               @ CTLIN, 45 SAY "CRE"
               lCREDITA := .T.
            ENDIF
            IF PIS = "-" .AND. FIN = "-"
               @ CTLIN, 45 SAY "DEB"
               lDEBITA := .T.
            ENDIF
            IF PIS = "A" .AND. FIN = "A"
               @ CTLIN, 45 SAY "ATV"
            ENDIF
            IF PIS = "E" .AND. FIN = "E"
               @ CTLIN, 45 SAY "EXP"
            ENDIF
            IF PIS = "M" .AND. FIN = "M"
               @ CTLIN, 45 SAY "MAO"
            ENDIF
         ENDIF
         IF lCREDITA
            nTOTAP += nVALLV
            @ CTLIN, 50 SAY nVALLV PICT "@E 999,999.99"
         ENDIF
         IF lDEBITA
            nTOTAP -= nVALLV
            @ CTLIN, 50 SAY - nVALLV PICT "@E 999,999.99"
         ENDIF
         CTLIN++
      ENDIF
      dbSelectAr( ARQNF )
      dbSkip()
   ENDDO
   dbCloseAll()
   @ CTLIN, 0  SAY "TOTAL"
   @ CTLIN, 18 SAY nTOTNF  PICT "@E 9999999.99"
   @ CTLIN, 29 SAY nTOTLV  PICT "@E 9999999.99"
   @ CTLIN, 50 SAY nTOTAP  PICT "@E 9999999.99"
   IMPFOL()
   VIDEO()
   IMPEND()

// + EOF: M_BM5.PRG

// + EOF: m_bm5.prg
// +
