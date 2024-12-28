// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a7i.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// #INCLUDE "COMANDO.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_a7i()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_a7i

   PARA wNRNOTA, lNOT, lCLI

   xNOTADEV := xDATADEV := xTOTDEV := xDEV := xBAIXA := ""
   IF !CHECKIMP()
      ALERTX( "Erro Impressora" )
      RETU .F.
   ENDIF
   MDS( "Aguarde Impress„o" )
   IF ValType( lCLI ) # "L"
      lCLI := .F.
   ENDIF
   IF ValType( lNOT ) # "L"
      lNOT := .F.
   ENDIF
   mNOMECLI := ""
   mNUMECLI := ""
   IF lNOT
      IF !IGUALVARS( ARQWORK1, wNRNOTA )
         RETU .F.
      ENDIF
   ENDIF
   wDATA := mDATA
   IF lCLI
      xNOME := mNOME
      TIPCAD( mTIPOCLI, "ARQUSO" )
      IF !IGUALVARS( ARQUSO, mFORNECEDO )
         RETU .F.
      ENDIF
      // Retorna o Numero Fixo da Nota
      mNUMERO  := wNRNOTA
      mNOMECLI := mNOME
      mNOME    := xNOME
      IF ARQUSO = "MB01"
         mINSCR := mIESTADUAL
      ENDIF
      IF ARQUSO = "MA01"
         mNUMECLI := mCODIGO
      ENDIF
   ENDIF
   cCFO3   := Left( mOPERACAO, 3 )
   mDESCFO := OBTER( "MD04", mCFONEW, "NOMENOTA", 2 )
// IF cCFO3="599".OR.cCFO3="699".OR.cCFO3="799";
// .OR.cCFO3="199".OR.cCFO3="299".OR.cCFO3="594";
// .OR.cCFO3="593".OR.cCFO3="693"
   MDS( "Confirme a Descri‡„o da Opera‡„o" )
   @ 24, 40 GET mDESCFO
   READCUR()
// ENDIF
// lCFO:=MDG("Imprimir CFO Novo")
   IF !USEREDE( ARQWORK2, 1, 1 )
      RETU .F.
   ENDIF
   IF !USEREDE( "MO01", 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
// IF LEFT(mOPERACAO,3)#"511".AND.LEFT(mOPERACAO,3)#"611"
// Montando Devolu‡ao
   dbSelectAr( ARQWORK2 )
   dbSeek( Str( wNRNOTA, 8 ) )
   WHILE NUMERO = wNRNOTA .AND. !Eof()
      IF !Empty( NOTADEV )
         xNOTADEV += IF( Empty( xNOTADEV ), "", "/" ) + Str( NOTADEV )
         xDATADEV += IF( Empty( xDATADEV ), "", "-" ) + DToC( DATADEV )
         xTOTDEV  += IF( Empty( xTOTDEV ), "", "/" ) + StrTran( TRANS( TOTDEV, "@E 999,999.99" ), " ", "" )
         xDEV     += IF( Empty( xDEV ), "", "/" ) + StrTran( TRANS( DEV, "@E 999,999.99" ), " ", "" )
         xBAIXA   += IF( Empty( xBAIXA ), "", "/" ) + IF( TOTDEV = DEV, "TOTAL", "PARCIAL" )
      ENDIF

      IF !Empty( NOTADE2 )
         xNOTADEV += IF( Empty( xNOTADEV ), "", "/" ) + Str( NOTADE2 )
         xDATADEV += IF( Empty( xDATADEV ), "", "-" ) + DToC( DATADE2 )
         xTOTDEV  += IF( Empty( xTOTDEV ), "", "/" ) + StrTran( TRANS( TOTDE2, "@E 999,999.99" ), " ", "" )
         xDEV     += IF( Empty( xDEV ), "", "/" ) + StrTran( TRANS( DE2, "@E 999,999.99" ), " ", "" )
         xBAIXA   += IF( Empty( xBAIXA ), "", "/" ) + IF( TOTDE2 = DE2, "TOTAL", "PARCIAL" )
      ENDIF
      dbSkip()
   ENDDO
// ENDIF
   IMPRESSORA()
   @  0, 0                       SAY Chr( 18 )
   @  0, 60                      SAY mFORNECEDO
   @  0, 70                      SAY mCOGNOME
   @  0, IF( mTIPONF = "E", 90, 83 ) SAY "X"
   @  0, 103                     SAY StrZero( wNRNOTA, 6 )
   @  4, 29                      SAY mDESCFO
// IF lCFO
   @  4, 55 SAY Chr( 15 ) + Transform( mCFONEW, "@R 9.999" ) + IF( Empty( mCFONEWB ), "", "/" + Transform( mCFONEWB, "@R 9.999" ) ) + Chr( 18 )
   @  5, 00 SAY Chr( 18 ) + " "
// ELSE
// @ 4, 55 SAY ALLTRIM(mOPERACAO)+IF(EMPTY(mSUBOPER),"","."+mSUBOPER)
// ENDIF
   @  6, 70 SAY Left( mNUMECLI, 10 )
   @  7, 29 SAY mNOMECLI
   SET CENTURY ON
   @  7, 101 SAY wDATA
   SET CENTURY OFF
   @  7, 81 SAY mCGC
   @  7, 01 SAY Chr( 15 ) + xNOTADEV + Chr( 18 )
   @  8, 00 SAY Chr( 18 ) + " "
   @  8, 03 SAY Chr( 15 ) + xDATADEV + Chr( 18 )
   @  9, 29 SAY mENDERECO
   @  9, 75 SAY mBAIRRO
   @  9, 89 SAY mCEP
   @  9, 05 SAY Chr( 15 ) + xTOTDEV + Chr( 18 )
   @ 10, 00 SAY Chr( 18 ) + " "
   @ 10, 05 SAY Chr( 15 ) + xBAIXA + Chr( 18 )
   @ 11, 29 SAY mCIDADE
   @ 11, 78 SAY mESTADO
   @ 11, 81 SAY mINSCR
   @ 11, 65 SAY Chr( 15 ) + "(" + mDDD + ")" + mTELEFONE + Chr( 18 )
   @ 12, 00 SAY Chr( 18 ) + " "
   @ 12, 01 SAY Chr( 15 ) + xDEV + Chr( 18 )
   @ 14, 29 SAY AllTrim( mENDERECO2 ) + " - " + mESTADO2 + " - " + mCEP2
// IF LEFT(mOPERACAO,3)="593".OR.LEFT(mOPERACAO,3)="693"
// @ 14,02 SAY "MATERIAL PARA REVENDA"
// ENDIF
   @ 14, 02 SAY Chr( 15 ) + Left( mOBS1, 48 ) + Chr( 18 )
   @ 15, 00 SAY Chr( 18 ) + " "
   @ 15, 02 SAY Chr( 15 ) + Left( mOBS2, 48 ) + Chr( 18 )
   IF !Empty( mVAL01 )
      @ 16, 40 SAY Chr( 15 ) + StrZero( wNRNOTA, 6 ) + Chr( 18 )
      @ 16, 56 SAY Chr( 15 ) + TRANS( mVAL01, "@E 999,999.99" ) + Chr( 18 )
      DO CASE
      CASE Left( mOPERACAO, 3 ) = "531" .OR. Left( mOPERACAO, 3 ) = "631"
         @ 16, 65 SAY "COM DEBITO"
      OTHERWISE
         IF Left( mOPERACAO, 3 ) # "593" .AND. Left( mOPERACAO, 3 ) # "594" ;
               .AND. Left( mOPERACAO, 3 ) # "599" .AND. Left( mOPERACAO, 3 ) # "693" .AND. Left( mOPERACAO, 3 ) # "694" .AND. Left( mOPERACAO, 3 ) # "699"
            SET CENTURY ON
            @ 16, 77 SAY Chr( 15 ) + DToC( mDAT01 ) + Chr( 18 )
            SET CENTURY OFF
         ENDIF
      ENDCASE
   ENDIF
   IF !Empty( mVAL02 )
      @ 16, 81 SAY StrZero( wNRNOTA, 6 )
      @ 16, 92 SAY mVAL02             PICT "@E 999,999.99"
      SET CENTURY ON
      @ 16, 109 SAY Chr( 15 ) + DToC( mDAT02 ) + Chr( 18 )
      SET CENTURY OFF
   ENDIF
   @ 16, 02 SAY Chr( 15 ) + Left( mOBS3, 48 ) + Chr( 18 )
   CTLIN := 20
   dbSelectAr( ARQWORK2 )
   dbSeek( Str( wNRNOTA, 8 ) )
   WHILE NUMERO = wNRNOTA .AND. !Eof()
      IF TIPOENT = "X"
         cTMPCOD := AllTrim( CODIGO )
         IF cTMPCOD = "FRETE" .OR. cTMPCOD = "SEGURO" .OR. cTMPCOD = "PISCONFINS" ;
               .OR. cTMPCOD = "COMPLEMENTO" .OR. cTMPCOD = "NAOTRIBUTADO" .OR. cTMPCOD = "ACESSORIAS"
            dbSkip()
            LOOP
         ENDIF
      ENDIF
      IF Len( AllTrim( CODIGO ) ) > 14
         @ CTLIN, 00 SAY Chr( 15 ) + AllTrim( CODIGO ) + Chr( 18 )
      ELSE
         @ CTLIN, 00 SAY AllTrim( CODIGO )
      ENDIF
      @ CTLIN, 15 SAY ACENTO( NOME )
      @ CTLIN, 44 SAY CLASSIPI
      @ CTLIN, 57 SAY CODICM
      @ CTLIN, 61 SAY UNID
      IF UNID = 'CT'
         @ CTLIN, 63 SAY QTDE PICT '@E 9999.99'
      ELSE
         IF UNID = 'ML'
            @ CTLIN, 63 SAY Chr( 15 ) + TRANS( QTDE, '@E 9999.999' ) + Chr( 18 )
         ELSE
            IF UNID = 'PC'
               @ CTLIN, 63 SAY QTDE PICT '9999999'
            ELSE
               @ CTLIN, 64 SAY Chr( 15 ) + TRANS( QTDE, '@E 99999.999' ) + Chr( 18 )
            ENDIF
         ENDIF
      ENDIF
      DO CASE
      CASE ( PRECO * 1000 ) - Int( PRECO * 1000 ) > 0
         @ CTLIN, 70 SAY PRECO PICT '@E 9,999.9999'
      CASE ( PRECO * 100 ) - Int( PRECO * 100 ) > 0
         @ CTLIN, 70 SAY PRECO PICT '@E 99,999.999'
      CASE UNID = "FR"
         @ CTLIN, 70 SAY PRECO PICT '@E 999,999.99'
      OTHERWISE
         @ CTLIN, 70 SAY PRECO PICT '@E 999,999.99'
      ENDCASE
      @ CTLIN, 81 SAY VALORMER PICT '@E 9,999,999.99'
      IF ICM > 0 .AND. CODICM # "004"
         IF Int( ICM ) = ICM
            @ CTLIN, 95 SAY ICM PICT '99'
         ELSE
            @ CTLIN, 95 SAY Chr( 15 ) + TRANS( ICM, '99.99' ) + Chr( 18 )
         ENDIF
      ENDIF
      IF IPI > 0
         IF Int( IPI ) = IPI
            @ CTLIN, 99 SAY IPI PICT '99'
         ELSE
            @ CTLIN, 98 SAY IPI PICT '99.9'
         ENDIF
         @ CTLIN, 102 SAY VALORIPI PICT '@E 999,999.99'
      ENDIF
      CTLIN++
      lSALTO := .F.
      mOS    := OS
      IF !Empty( OS )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + 'O.S.=> ' + Chr( 18 ) + Str( OS, 8, 2 )
         lSALTO := .T.
      ENDIF
      xPEDIDOCLI := PEDIDOCLI
      xPEDCLIITE := PEDCLIITE
      dbSelectAr( "MO01" )
      dbGoTop()
      IF dbSeek( mOS )
         xPEDIDOCLI := PEDIDOCLI
         xPEDCLIITE := PEDCLIITE
      ENDIF
      IF !Empty( xPEDIDOCLI )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         IF !Empty( xPEDCLIITE )
            @ CTLIN, 28 SAY Chr( 15 ) + "  PEDIDO=> " + Chr( 18 ) + AllTrim( xPEDIDOCLI ) + "/" + Str( xPEDCLIITE )
         ELSE
            @ CTLIN, 28 SAY Chr( 15 ) + "  PEDIDO=> " + Chr( 18 ) + AllTrim( xPEDIDOCLI )
         ENDIF
         lSALTO := .T.
      ENDIF
      IF lSALTO
         CTLIN++
      ENDIF
      dbSelectAr( ARQWORK2 )
      IF Left( mOPERACAO, 3 ) = "593"
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 28 SAY Chr( 15 ) + "  PESO=> " + Chr( 18 ) + Str( PESTOT, 8, 2 )
         CTLIN++
      ENDIF
      IF mCOGNOME = "AUTOLATINA"
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + 'O.S.=> ' + ALOS + ' Setor=> ' + Str( ALSE ) + ' TM=> ' + ALMA + ' Det.=> ' + ALDE + Chr( 18 )
         CTLIN++
      ENDIF
      IF mCOGNOME = "MERCEDES"
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + 'MBB Numero' + MBBN + 'Protocolo' + MBBP + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( RASTRO )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + 'Rastreabilidade ' + RASTRO + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( RASTR2 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + RASTR2 + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( CODDEV )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + CODDEV + " " + Str( QTDEDEV, 12, 2 ) + " " + UNIDEV + " " + Str( PRCDEV, 10, 3 ) + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( CODDE2 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + CODDE2 + " " + Str( QTDEDE2, 12, 2 ) + " " + UNIDE2 + " " + Str( PRCDE2, 10, 3 ) + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( LINADD01 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + LINADD01 + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( LINADD02 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + LINADD02 + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( LINADD03 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + LINADD03 + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( LINADD04 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + LINADD04 + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( LINADD05 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + LINADD05 + Chr( 18 )
         CTLIN++
      ENDIF
      IF !Empty( LINADD06 )
         @ CTLIN, 00 SAY Chr( 18 ) + " "
         @ CTLIN, 16 SAY Chr( 15 ) + LINADD06 + Chr( 18 )
         CTLIN++
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   IF !Empty( mLIN01 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN01 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN02 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN02 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN03 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN03 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN04 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN04 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN05 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN05 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN06 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN06 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN07 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN07 + Chr( 18 )
      CTLIN++
   ENDIF
   IF !Empty( mLIN08 )
      @ CTLIN, 00 SAY Chr( 18 ) + " "
      @ CTLIN, 16 SAY Chr( 15 ) + mLIN08 + Chr( 18 )
      CTLIN++
   ENDIF
   FOR Y := CTLIN TO 44
      @ Y, 0 SAY Chr( 18 ) + " "
      CTLIN++
   NEXT Y
   @ CTLIN, 0  SAY mTOTBICM PICT '@E 999,999.99'
   @ CTLIN, 14 SAY mTOTICM  PICT '@E 999,999.99'
   @ CTLIN, 61 SAY mTOTMER  PICT '@E 9,999,999.99'
   CTLIN += 2
   @ CTLIN, 0  SAY mTOTFRETE PICT '@E 999,999.99'
   @ CTLIN, 45 SAY mTOTIPI   PICT '@E 9,999,999.99'
   @ CTLIN, 61 SAY mTOTNF    PICT '@E 9,999,999.99'
   CTLIN += 3
   @ CTLIN, 0  SAY IF( Empty( mNOMETRANS ), mMOTORISTA, mNOMETRANS )
   @ CTLIN, 44 SAY mTIPOFR
   @ CTLIN, 51 SAY mCHAPA
   @ CTLIN, 55 SAY mESTATRANS
   @ CTLIN, 58 SAY mCGCTRANS
   CTLIN += 2
   @ CTLIN, 00 SAY Chr( 15 ) + mENDETRANS + Chr( 18 )
   @ CTLIN, 37 SAY Chr( 15 ) + mCIDATRANS + Chr( 18 )
   @ CTLIN, 55 SAY mESTATRANS
   @ CTLIN, 58 SAY mIETRANS
   CTLIN += 2
   @ CTLIN, 00 SAY mQUANTEMB  PICT "999999"
   @ CTLIN, 12 SAY mEMBALAGEM
   @ CTLIN, 28 SAY mMARCAEMB
   @ CTLIN, 42 SAY mNUMEROEMB
   @ CTLIN, 51 SAY mTOTALBRU  PICT "999999.99"
   @ CTLIN, 63 SAY mTOTALPES  PICT "999999.99"
   CTLIN += 3
   @ CTLIN, 002 SAY StrZero( wNRNOTA, 6 )
   EJECT
   VIDEO()
   RETU .T.

// + EOF: m_a7i.prg
// +
