// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlibest.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAM2K05()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAM2K05( mOPER, cARQ, nIND )   // Gravando um Movimento no Estoque

   IF ValType( cARQ ) # "C"
      cARQ := "MM02"
   ENDIF
   GRVESTOQUE( mOPER, cARQ, nIND, mNUMERO, "S" )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAK2K05()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAK2K05( mOPER, cARQ, nIND )   // Gravando um Movimento no Estoque

   IF ValType( cARQ ) # "C"
      cARQ := "MK02"
   ENDIF
   GRVESTOQUE( mOPER, cARQ, nIND, mNRNOTA, "E" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRVESTOQUE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC GRVESTOQUE( mOPER, cARQ, nIND, nNRNOTA, cTIPO )

   IF Empty( yCODIGO )
      RETU .F.
   ENDIF
   nESTQXXX := 0
   nESTQYYY := 0
   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   ARQEST := ESTQARQ( mTIPOENT, 0 )
   ARQMOV := ESTQARQ( mTIPOENT, 1 )
   IF ARQEST = "XXXX"
      RETU .F.
   ENDIF
   WHILE !USEREDE( ARQEST, 1, 99 )
   ENDDO
   netrecapp()
   field->ARQUIVO   := PadR( cARQ, 8 )
   field->DOCUMENTO := Str( nNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + yCODIGO
   field->OPERACAO  := mOPER
   field->USUARIO   := ZUSER
   GRAVACAMPO( "QTDE", "mQTDE" )
   netreclock()
   field->OLDQTDE := if( mOPER = "I", 0, mOLDQTDDE )
   field->DATA    := if( Empty( mDATA ), Date(), mdata )
   field->NUMERO  := nNRNOTA
   field->CODIGO  := yCODIGO
   IF Type( "mRASTRO" ) = "C"
      field->RASTRO := mRASTRO
   ENDIF
   dbUnlock()
// Gravando o Estoque
   WHILE !USEREDE( ARQMOV, 1, nIND )
   ENDDO
   dbGoTop()
   IF dbSeek( yCODIGO )
      netreclock()
      IF cTIPO = "S"
         DO CASE
         CASE mOPER = "I"
            field->ESTQSAI := ESTQSAI + mQTDE
         CASE mOPER = "E"
            field->ESTQSAI := ESTQSAI - mQTDE
         CASE mOPER = "A"
            field->ESTQSAI := ESTQSAI - mOLDQTDDE + mQTDE
         CASE mOPER = "R"
            field->ESTQSAI := ESTQSAI - mOLDQTDDE + mQTDE
         ENDCASE
      ELSE
         DO CASE
         CASE mOPER = "E"
            field->ESTQENT := ESTQENT - mQTDE
         CASE mOPER = "I"
            field->ESTQENT := ESTQENT + mQTDE
         CASE mOPER = "A"
            field->ESTQENT := ESTQENT - mOLDQTDDE + mQTDE
         CASE mOPER = "R"
            field->ESTQENT := ESTQENT - mOLDQTDDE + mQTDE
         ENDCASE
      ENDIF
      // Gravando o Saldo de Estoque
      nESTQXXX       := ESTQSAL
      field->ESTQSAL := ESTQINI + ESTQENT - ESTQSAI
      nESTQYYY       := ESTQSAL
      // Acumulando as saidas no Campo Saimim para fazer o estoque minimo
      DO CASE
      CASE mOPER = "I"
         field->SAIMIN := SAIMIN + mQTDE
      CASE mOPER = "E"
         field->SAIMIN := SAIMIN - mQTDE
      CASE mOPER = "A"
         field->SAIMIN := SAIMIN - mOLDQTDDE + mQTDE
      CASE mOPER = "R"
         field->SAIMIN := SAIMIN - mOLDQTDDE + mQTDE
      ENDCASE
      // Calculando o Estoque Minimo
      xDIAS          := mDATA - DATMIN
      VAR1           := SAIMIN / xDIAS
      VAR2           := if( DIASENT > 0, DIASENT, 1 ) * VAR1
      VAR3           := if( DIASEST > 0, DIASEST, 1 ) * VAR1
      field->ESTQMIN := VAR2 + VAR3
      IF xDIAS > zMEDIA
         field->DATMIN := mDATA - zMEDIA
         field->SAIMIN := VAR1 * zMEDIA
      ENDIF
      dbUnlock()
   ENDIF
   dbSelectAr( ARQMOV )
   dbCloseArea()
   GRAVALAY( { { "ESTQXXX", "ESTQYYY" }, { "nESTQXXX", "nESTQYYY" } }, ARQEST,, .F.,, .F. )
   dbCloseArea()
   IF nESTQYYY < 0
      ALERTX( AllTrim( yCODIGO ) + " Estoque Negativo" )
   ENDIF
   IF nESTQYYY > 9999999
      ALERTX( AllTrim( yCODIGO ) + " Estoque >99999999" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegoldqtd()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC pegoldqtd( cARQ, nNRNOTA )

   LOCAL nOLDQTDE := 0.000

   IF ValType( cARQ ) # "C"
      cARQ := "MM02"
   ENDIF
   ARQEST := ESTQARQ( mTIPOENT, 0 )
   IF !USEREDE( ARQEST, 1, 99 )
      RETU 0
   ENDIF
   dbGoTop()
   dbSeek( PadR( cARQ, 8 ) + Str( nNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + Trim( yCODIGO ) )
   WHILE Trim( Str( nNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + YCODIGO ) = Trim( DOCUMENTO ) .AND. !Eof()
      nOLDQTDE := QTDE
      dbSkip()
   ENDDO
   dbCloseArea()
   RETU nOLDQTDE



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAM2K06()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAM2K06( cARQ )

   IF ValType( cARQ ) # "C"
      cARQ := "MM02"
   ENDIF
   RETU pegoldqtd( Carq, mNUMERO )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAK2K06()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAK2K06( cARQ )

   IF ValType( cARQ ) # "C"
      cARQ := "MK02"
   ENDIF
   RETU pegoldqtd( Carq, mNRNOTA )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESTQARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ESTQARQ( cTIP, nTIP )

   LOCAL cRETU := "XXXX"

   DO CASE
   CASE nTIP = 0
      DO CASE
      CASE cTIP = "M"
         cRETU := "MU99"
      CASE cTIP = "P"
         cRETU := "MS99"
      CASE cTIP = "B"
         cRETU := "MR99"
      CASE cTIP = "S"
         cRETU := "MQ99"
      CASE cTIP = "C"
         cRETU := "MT99"
      CASE cTIP = "1" .OR. cTIP = "E"
         cRETU := "MP91"
      CASE cTIP = "2" .OR. cTIP = "H"
         cRETU := "MP92"
      CASE cTIP = "3" .OR. cTIP = "T"
         cRETU := "MP93"
      CASE cTIP = "O"
         cRETU := "MW95"
      CASE cTIP = "R"
         cRETU := "MW97"
      OTHERWISE
         cRETU := "XXXX"
      ENDCASE
   CASE nTIP = 1
      DO CASE
      CASE cTIP = "M"
         cRETU := "MU01"
      CASE cTIP = "P"
         cRETU := "MS01"
      CASE cTIP = "B"
         cRETU := "MR01"
      CASE cTIP = "S"
         cRETU := "MQ01"
      CASE cTIP = "C"
         cRETU := "MT01"
      CASE cTIP = "1" .OR. cTIP = "E"
         cRETU := "MP01"
      CASE cTIP = "2" .OR. cTIP = "H"
         cRETU := "MP02"
      CASE cTIP = "3" .OR. cTIP = "T"
         cRETU := "MP03"
      CASE cTIP = "O"
         cRETU := "MW05"
      CASE cTIP = "I"
         cRETU := "ME04"
      CASE cTIP = "R"
         cRETU := "MW07"
      OTHERWISE
         cRETU := "XXXX"
      ENDCASE
   CASE nTIP = 2
      DO CASE
      CASE cTIP = "M"
         cRETU := "U9"
      CASE cTIP = "B"
         cRETU := "R9"
      CASE cTIP = "P"
         cRETU := "S9"
      CASE cTIP = "S"
         cRETU := "Q9"
      CASE cTIP = "C"
         cRETU := "T9"
      CASE cTIP = "1" .OR. cTIP = "E"
         cRETU := "P1"
      CASE cTIP = "2" .OR. cTIP = "H"
         cRETU := "P2"
      CASE cTIP = "3" .OR. cTIP = "T"
         cRETU := "P3"
      CASE cTIP = "O"
         cRETU := "W5"
      CASE cTIP = "R"
         cRETU := "W7"
      OTHERWISE
         cRETU := "XX"
      ENDCASE
   ENDCASE
   RETU cRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ZERAEST()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ZERAEST( cARQ, cTIPO )

   LOCAL cFILTRO

   IF ValType( cTIPO ) # "C"
      cTIPO := "T"
   ENDIF
   cFILTRO := ''
   cFILTRO := RFILORD( cARQ, .F. )
   IF !MDG( "Zerar Estoque" )
      RETU .F.
   ENDIF
   MDS( "Aguarde Zerando" )
   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   IF !Empty( cFILTRO )
      SET FILTER TO &cFILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 40 SAY RecNo()
      IF cTIPO = "T" .OR. ( cTIPO = "N" .AND. ESTQSAL < 0 )
         netreclock()
         field->ESTQINI   := 0
         field->ESTQENT   := 0
         field->ESTQSAI   := 0
         field->ESTQSAL   := 0
         field->DATABALAN := ZDATA
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()


// + EOF: mlibest.prg
// +
