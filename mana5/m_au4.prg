// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_au4.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_au4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_au4

   PARA ARQBASE, cSTR

   aRETU := PEGMES( { "" }, .F., { "" } )
   cVAR  := aRETU[ 4 ] + aRETU[ 3 ]

   CHECKARQ( ARQBASE, cSTR + cVAR,,, ZDIRP + "E" + StrZero( znumero, 3 ) + StrZero( aRETU[ 2 ], 4 ) + "\", aRETU[ 2 ], aRETU[ 1 ] )

   PADRAO( 1, 1, 0, cSTR + cVAR, "C¢digo" + spac( 7 ) + "Seq   Data     Hist¢rico" + spac( 22 ) + "T Quantidade", ;
      "' '+mCODIGO+' '+STR(mSEQ,  5)+' '+DTOC(mDATA)+' '+mHISTORICO+' '+mTIPOENT+' '+STR(mQTDDE, 12, 2)", ;
      "MAU4",, {|| gMAU4() }, ;
      {|| mCODIGO := xCODIGO }, {|| PADARR( ARQWORK, xCODIGO, "CODIGO", "XCODIGO" ) } )

   MDS( "Aguarde Calculando" )
   WHILE !USEREDE( ARQWORK, 1, 99 )
   ENDDO
   dbGoTop()
   dbSeek( xCODIGO )
   WHILE xCODIGO = CODIGO .AND. !Eof()
      mESTOQUE  := TOTQTDDE
      mVALORANT := TOTPRECO
      mMEDIO    := Round( mVALORANT / mESTOQUE, 3 )
      dbSkip()
      IF xCODIGO = CODIGO .AND. !Eof()
         netreclock()
         field->TOTQTDDE := mESTOQUE + if( TIPOENT = "E", QTDDE, - QTDDE )
         IF TIPOENT = "S" .OR. TIPOENT = "F"
            field->PRECO := mMEDIO
         ENDIF
         IF TIPOENT # "F"
            field->TOTITEM := Round( PRECO * QTDDE, 2 )
         ENDIF
         DO CASE
         CASE TIPOENT = "S"
            field->TOTPRECO := mVALORANT - TOTITEM
         CASE TIPOENT = "E"
            field->TOTPRECO := mVALORANT + TOTITEM
         CASE TIPOENT = "F"
            field->TOTPRECO := mVALORANT + TOTITEM
         ENDCASE
         field->MEDIO := Round( TOTPRECO / TOTQTDDE, 3 )
         dbUnlock()
      ENDIF
   ENDDO
   dbCloseAll()
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAU4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAU4

   SetColor( PAD002 )
   @  4, 20 GET mDATA
   @  4, 29 GET mHISTORICO
   @  4, 60 GET mTIPOENT   VALID mTIPOENT $ "ESF "
   @  4, 62 GET mQTDDE     PICTURE '999999999.99'  WHEN mTIPOENT # "F"
   READCUR()
   IF mTIPOENT = "E"
      @  6, 20 SAY "Pre‡o"
      @  7, 20 GET mPRECO
   ENDIF
   IF mTIPOENT = "F"
      @  6, 20 SAY "Valor Frete"
      @  7, 20 GET mTOTITEM
   ENDIF
   IF mSEQ = 1
      @  6, 1  SAY "Estoque" + spac( 12 ) + "     " + spac( 8 ) + "Acumulado"
      @  7, 1  GET mTOTQTDDE
      @  7, 33 GET mTOTPRECO
   ENDIF
   READCUR()
   IF mSEQ = 1
      mMEDIO := Round( mTOTPRECO / mTOTQTDDE, 3 )
   ENDIF
   RETU .T.


// + EOF: m_au4.prg
// +
