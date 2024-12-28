// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aop.prg
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



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_aop()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_aop

   PARA cARQOP, cARQOP2

   IF ValType( cARQOP ) # "C"
      cARQOP  := "OP01"
      cARQOP2 := "OP02"
   ENDIF


// OP01
// QATR Atraso
// QSEM 1 Semana
// QSE2 2 Semana
// QSAI Estoque
// QIN2 ATR+1   (QATR+QSEM)
// QINI ATR+1+2 (QATR+QSEM+QSE2)
// QSA2 - Saldo Atraso (QATR-QSAI)
// QSAS - Saldo 1      (QATR-QSAI*)
// QSAA - Saldo 2      (QATR-QSAI*)
// QSAI* considerando Semanas Anteriores
// QSAL - Inicial - Estoque Saldo (QINI-QSAI)

   PRIV xOP
   PRIV xQINI

// M_DB("ARQUIVO='"+cARQOP+"'.OR.ARQUIVO='"+cARQOP2+"'")

   MAOPCHKSEQ( cARQOP, cARQOP2 )

   PADRAX( 0,, 0, { cARQOP, cARQOP2 }, "OP      Produto" + spac( 18 ) + "Semanas             Total Estoque Produzir", ;
      "' '+STR(mOP,6)+' '+mCODIGO+' '+STR(mQATR,6)+' '+STR(mQSEM,6)+' '+STR(mQSE2,6)+' '+STR(mQINI,6)+' '+STR(mQSAI,6)+' '+STR(mQSAL,6)", "MAOP01", "MAOP01", ;
      , {|| PADDEL( "OP02", Str( xCHAVE, 8, 2 ), "OP", "xCHAVE" ) }, {|| MAOP01() }, {|| ULTIMOREG( "OP01", "OP", "mOP" ) }, "MAOP" )

// Consolida Resultado
   MAOP03(, cARQOP, cARQOP2 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOP04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOP04

   mCODMP01  := CODMP01
   mCODMP02  := CODMP02
   mCODMP02B := CODMP02B
   mCODMP02C := CODMP02C
   mCODMP02D := CODMP02D
   mCODMP03  := CODMP03
   mQTTIME   := if( PCHORA > 0, 1 / PCHORA, 0 )
   mQTTIM2   := if( PCHOR2 > 0, 1 / PCHOR2, 0 )
   mQTTIMM   := if( PCHORMED > 0, 1 / PCHORMED, 0 )
   mQTTIMD   := if( PCHORAMD > 0, 1 / PCHORAMD, 0 )
   IF Empty( mQTTIM2 )
      mQTTIM2 := mQTTIME
   ENDIF
   IF Empty( mQTTIMM )
      mQTTIMM := mQTTIME
   ENDIF
   IF Empty( mQTTIMD )
      mQTTIMD := mQTTIME
   ENDIF
   mDESCRI  := DESCRI
   mPULREQ  := PULREQ
   mTIPFEC  := TIPFEC
   mLIMTIME := LIMTIME
   mNOMER   := NOMER
   mSETOROP := SETOROP
   mFILIAL  := FILIAL
   mLEADESP := LEADESP
   mFATOR   := FATOR
   mCODINT  := CODINT
// if FATOR # 0
// mQTTIME *= FATOR
// endif
// if FATOR # 0
// mQTTIM2 *= FATOR
// endif
// if FATOR # 0
// mQTTIMM *= FATOR
// endif
// if FATOR # 0
// mQTTIMD *= FATOR
// endif
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOP03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOP03( lPER, cARQ, cARQ2 )

   IF ValType( lPER ) # "L" .OR. lPER = .T.
      IF !MDG( "Recalcular Saldos" )
         RETU .F.
      ENDIF
   ENDIF
   IF ValType( cARQ ) # "C"
      cARQ  := "OP01"
      cARQ2 := "OP02"
   ENDIF
   MDS( "Aguarde Atualizando Saldos" )

   IF !USEMULT( { { cARQ, 1, 1 }, { caRQ2, 1, 1 }, { "MS06", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( cARQ )
   INITVARS()
   CLRVARS()
   dbSelectAr( cARQ2 )
   INITVARS()
   CLRVARS()

// recalcula saldo OP01
   dbSelectAr( carq )
   dbGoTop()
   WHILE !Eof()
      EQUVARS()  // Guarda os Valores
      MAOP02()   // Recalcula Saldos
      netreclock()
      REPLVARS()
      dbUnlock()
      dbSkip()
   ENDDO



   dbSelectAr( cARQ2 )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      EQUVARS()
      dbSelectAr( cARQ )
      dbGoTop()
      IF dbSeek( mOP )
         mCODIGO := CODIGO
         @ 24, 10 SAY CODIGO
      ENDIF
      dbSelectAr( "MS06" )
      dbGoTop()
      IF dbSeek( mCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
         MAOP04()
      ENDIF
      dbSelectAr( cARQ2 )
      netreclock()
      REPLVARS()
      dbUnlock()
      dbSkip()
   ENDDO


   dbSelectAr( cARQ2 )
   dbGoBottom()  // Ultimo Registro
   WHILE !Bof()
      @ 24, 00 SAY RecNo()
      // @ 24,10 SAY CODIGO
      xOP    := OP
      lTEMOP := .T.
      nRECNO := RecNo()
      nSALDO := 0
      // nFATOR := 1
      nCONJT := 0
      lCONJT := .F.
      nFATJT := 1
      dbSelectAr( cARQ )
      dbGoTop()
      IF !dbSeek( xOP )
         lTEMOP := .F.
      ELSE
         EQUVARS()   // Guarda os Valores
         MAOP02()  // Recalcula Saldos
         netreclock()
         REPLVARS()
         dbUnlock()
      ENDIF
      dbSelectAr( cARQ2 )
      IF lTEMOP
         WHILE xOP = OP .AND. !Bof()
            IF SSQ = 99 .AND. lCONJT
               nSALDO := nCONJT
               nFATJT := 1
            ENDIF
            netreclock()
            IF SSQ <> 99   //
               nSALDO += QPSAI
            ENDIF
            IF TIPFEC = "9" .OR. TIPFEC = "8"
               nCONJT := nSALDO
               lCONJT := .T.
            ENDIF
            field->QPREF := mQINI
            field->QPINI := mQSAL  // Saldo de Todas Semanas
            // Estoque QPSAI Digitado
            IF FATOR > 0 .AND. TIPFEC = "7"
               nSALDO := QPSAI + ( nCONJT * FATOR )
               nFATJT := FATOR
            ENDIF
            field->QPSAL := if( QPINI > QPSAI, QPINI - QPSAI, 0 )  // Basico
            // IF nFATJT>0
            // FIELD->QSA2:=mQSA2*nFATJT
            // FIELD->QSAS:=mQSAS*nFATJT
            // FIELD->QSAA:=mQSAA*nFATJT
            // ENDIF
            field->QPANT := nSALDO   // *nFATOR
            field->QPIN2 := mQSA2 * nFATJT   // Atraso
            field->QPINS := mQSAS * nFATJT   // 1o Semana
            field->QPINA := mQSAA * nFATJT   // 2o Semana
            nANT         := QPANT
            IF QPIN2 > nANT  // Atraso
               field->QPAA2 := QPIN2 - nANT
               nANT         := 0
            ELSE
               field->QPAA2 := 0
               nANT         -= QPIN2
            ENDIF
            IF QPINS > nANT  // 1a. Semana
               field->QPAAS := QPINS - nANT
               nANT         := 0
            ELSE
               field->QPAAS := 0
               nANT         -= QPINS
            ENDIF
            IF QPINA > nANT  // 1a. Semana
               field->QPAAA := QPINA - nANT
               nANT         := 0
            ELSE
               field->QPAAA := 0
               nANT         -= QPINA
            ENDIF
            // IF FATOR>0
            // nFATOR:=FATOR
            // ENDIF
            dbUnlock()
            dbSkip( - 1 )
         ENDDO
      ELSE
         WHILE xOP = OP .AND. !Bof()
            DELEREG(,, .F., .F. )
            dbSkip( - 1 )
         ENDDO
      ENDIF
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOP02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOP02

   LOCAL nBASE

   IF mATIVO = "N"
      mQATR := 0
      mQSEM := 0
      mQSE2 := 0
      mQSAI := 0
   ENDIF
   mQINI := mQATR + mQSEM + mQSE2
   mQIN2 := mQATR + mQSEM
   mQSAL := if( mQINI > mQSAI, mQINI - mQSAI, 0 )  // Total
   nBASE := mQSAI

   IF mQATR > nBASE  // Atraso
      mQSA2 := mQATR - nBASE
      nBASE := 0
   ELSE
      mQSA2 := 0
      nBASE -= mQATR
   ENDIF

   IF mQSEM > nBASE  // 1a.Semana
      mQSAS := mQSEM - nBASE
      nBASE := 0
   ELSE
      mQSAS := 0
      nBASE -= mQSEM
   ENDIF

   IF mQSE2 > nBASE  // 2a.Semana
      mQSAA := mQSE2 - nBASE
      nBASE := 0
   ELSE
      mQSAA := 0
      nBASE -= mQSE2
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOP01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOP01

   IF mATIVO = "N"
      ALERTX( "OP Nao Ativa" )
      PADDEL( "OP02", Str( xCHAVE, 8, 2 ), "OP", "xCHAVE" )
      RETU .F.
   ENDIF
   IF MDG( "Revisar Sequencia" )
      MAOP02()   // Certifica dos Calculos
      xOP := mOP
      IF !USEMULT( { { "MS06", 1, 1 }, { "OP02", 1, 99 } } )
         RETU .T.
      ENDIF
      dbSelectAr( "MS06" )
      dbGoTop()
      dbSeek( mCODIGO )
      WHILE mCODIGO = CODIGO .AND. !Eof()
         mOP  := xOP
         mSEQ := SEQ
         mSSQ := SSQ
         MAOP04()
         IF !NOVOOPE( "OP02", Str( xOP, 8, 2 ) + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
            netreclock()
            mQPSAI := QPSAI  // Salva o Saldo pois sofrera rplvars
         ELSE
            mQPSAI := 0
         ENDIF
         REPLVARS()
         dbUnlock()
         dbSelectAr( "MS06" )
         dbSkip()
      ENDDO
      dbCloseAll()
      PADRAO( 1, 1, 0, "OP02", "OP" + spac( 7 ) + "Seq Ssq Inicial" + spac( 6 ) + "Produzida    a Produzir", ;
         "' '+STR(mOP,8,2)+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+STR(mQPINI,12,2)+' '+STR(mQPSAI,12,2)+' '+STR(mQPSAL,12,2)", ;
         "MAOP2",,, {|| mOP := xOP }, {|| PADARR( "OP02", Str( xOP, 8, 2 ), "OP", "xOP" ) } )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_AOP4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC m_AOP4()

   MDS( "Aguarde Calculando Saldos Necessidade Horas" )
   IF !USEMULT( { { "OP01", 1, 1 }, { "OP02", 1, 2 }, { "OP03", 0, 99 }, { "MP01", 1, 1 }, ;
         { "MP02", 1, 1 }, { "OP03B", 0, 99 } } )   // OP02-2 Index OP
      RETU .F.
   ENDIF
   dbSelectAr( "OP03" )
   INITVARS()
   CLRVARS()
   ZAP
   dbSelectAr( "OP03B" )
   ZAP
   dbSelectAr( "OP01" )
   INITVARS()
   CLRVARS()
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY CODIGO
      EQUVARS()
      dbSelectAr( "OP02" )
      dbGoTop()
      dbSeek( mOP )
      WHILE mOP = OP .AND. !Eof()
         IF SSQ # 99
            m_AOP4GRV( CODMP01, "E" )
            m_AOP4GRV( CODMP02, "H" )
            m_AOP4GRV( CODMP02B, "H" )
            m_AOP4GRV( CODMP02C, "H" )
            m_AOP4GRV( CODMP02D, "H" )
         ENDIF
         dbSelectAr( "OP02" )
         dbSkip()
      ENDDO
      dbSelectAr( "OP01" )
      dbSkip()
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_AOP4GRV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC m_AOP4GRV( cCOD, cTIPO )

   IF !Empty( cCOD )
      mCODMP01 := cCOD
      mQTTIME  := QTTIME
      mQTTIM2  := QTTIM2
      mQTTIMM  := QTTIMM
      mQTTIMD  := QTTIMD
      mSEQ     := SEQ
      mSSQ     := SSQ
      mCOGMP01 := ""
      mFILIAL  := FILIAL
      mQPRO    := QPAA2 + QPAAS + QPAAA
      dbSelectAr( if( cTIPO = "E", "MP01", "MP02" ) )
      dbGoTop()
      IF dbSeek( cCOD )
         mCOGMP01 := COGNOME
      ENDIF
      NOVOOPA( if( cTIPO = "E", "OP03", "OP03B" ) )  // Grava Sempre Soma via Relatorio
   ENDIF
   dbSelectAr( "OP02" )
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPCALSET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPCALSET

   MAOP03()
   nDIAPRZ  := 2
   nHORAS   := 15.58
   cTEMPO   := "I"
   cSEMANA  := "S"
   xURGEN02 := "S"
   xURGEN03 := "S"
   MDI( "Calcular Lead-Time Setor" )
   @ 10, 00 SAY "Dias Pre Desconto"
   @ 11, 00 SAY "Horas Dias Referencia"
   @ 12, 00 SAY "Calculo Tempo (P)adr∆o (M)edia (I)nte"
   @ 13, 00 SAY "Urgencia 1ß Sem 2ß Sem"
   @ 14, 00 SAY "Estrategia (S)emanal (A)Vig+1¶Sem"
   @ 15, 00 SAY "(T)Vig+1¶+2¶ (B)Vig 1ß+2ß"
   @ 10, 40 GET nDIAPRZ
   @ 11, 40 GET nHORAS
   @ 12, 40 GET cTEMPO                                  PICT "!" VALID cTEMPO $ "PMI"
   @ 13, 40 GET xURGEN02                                PICT "!" VALID xURGEN02 $ " SN"
   @ 13, 44 GET xURGEN03                                PICT "!" VALID xURGEN03 $ " SN"
   @ 14, 40 GET cSEMANA                                 PICT "!" VALID cSEMANA $ "SATB"
   IF !READCUR()
      RETU .F.
   ENDIF
   FILTRO := ''
   FILTRO := RFILORD( "OP02", .F. )

   IF !USEMULT( { { "OP01", 1, 1 }, { "OP02", 1, 1 }, { "OP02SET", 0, 99 }, { "OP02SEX", 0, 99 }, ;
         { "MS06", 1, 1 }, { "MS03", 1, 2 }, { "MP01", 1, 1 }, { "ETI", 1, 1 }, { "FERRAM", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "OP01" )
   INITVARS()
   CLRVARS()
   dbSelectAr( "OP02" )
   INITVARS()
   CLRVARS()
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO.
   ENDIF
   dbSelectAr( "OP02SET" )
   ZAP
   INITVARS()
   CLRVARS()
   dbSelectAr( "OP02SEX" )
   ZAP
   INITVARS()
   CLRVARS()
   dbSelectAr( "OP02" )
   dbGoTop()
   WHILE !Eof()
      @ 23, 00 SAY "Calculando Horas"
      @ 24, 00 SAY mCODIGO
      EQUVARS()
      IF mSSQ <> 99
         mLIMTIME  := 1
         mPCHORMEQ := 0
         mPCHORINT := 0
         mPCHORA   := 0
         mCODMP03  := ""
         mNUMFERR  := 0
         dbSelectAr( "MS06" )
         dbGoTop()
         IF dbSeek( mCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
            mLIMTIME  := LIMTIME
            mPCHORMEQ := PCHORMEQ
            mPCHORINT := PCHORAMD
            mPCHORA   := PCHORA
            mCODMP03  := CODMP03
            mSETOROP  := SETOROP
            mNOMER    := NOMER
            mFILIAL   := FILIAL
            mLEADESP  := LEADESP
            mFERRAMEN := AllTrim( FERRAMEN )
            IF !Empty( mFERRAMEN )
               dbSelectAr( "FERRAM" )
               dbGoTop()
               IF dbSeek( mFERRAMEN )
                  mNUMFERR := NUMERO
               ENDIF
            ENDIF
         ENDIF
         dbSelectAr( "MS03" )
         dbGoTop()
         IF dbSeek( mCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
            netreclock()
            field->QPAA2 := mQPAA2
            field->QPAAS := mQPAAS
            field->QPAAA := mQPAAA
            dbUnlock()
         ENDIF
         dbSelectAr( "MP01" )
         dbGoTop()
         IF dbSeek( mCODMP01 )
            mCOGMP01 := COGNOME
         ENDIF
         dbSelectAr( "OP01" )
         dbGoTop()
         IF dbSeek( mOP )
            EQUVARS()
            dbSelectAr( "OP02SET" )
            FOR X := 1 TO 3
               mSEMANA := Str( X, 1 )
               DO CASE
               CASE X = 1 .AND. cSEMANA = "S"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2
                  mQTDEUSO := mQPAA2
               CASE X = 2 .AND. cSEMANA = "S"
                  mDATAINI := mDATAS
                  mQTDEINI := mQPAAS
                  mQTDEUSO := mQPAAS
               CASE X = 3 .AND. cSEMANA = "S"
                  mDATAINI := mDATA2
                  mQTDEINI := mQPAAA
                  mQTDEUSO := mQPAAA
               CASE X = 1 .AND. cSEMANA = "B"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2
                  mQTDEUSO := mQPAA2
               CASE X = 2 .AND. cSEMANA = "B"
                  mDATAINI := mDATAS
                  mQTDEINI := mQPAAS + mQPAAA
                  mQTDEUSO := mQPAAS + mQPAAA
               CASE X = 1 .AND. cSEMANA = "A"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2 + mQPAAS
                  mQTDEUSO := mQPAA2 + mQPAAS
               CASE X = 2 .AND. ( cSEMANA = "A" .OR. cSEMANA = "T" )
                  mDATAINI := CToD( Space( 8 ) )
                  mQTDEINI := 0
                  mQTDEUSO := 0
               CASE X = 3 .AND. ( cSEMANA = "A" .OR. cSEMANA = "T" .OR. cSEMANA = "B" )
                  mDATAINI := CToD( Space( 8 ) )
                  mQTDEINI := 0
                  mQTDEUSO := 0
               CASE X = 1 .AND. cSEMANA = "T"
                  mDATAINI := mDATAA
                  mQTDEINI := mQPAA2 + mQPAAS + mQPAAA
                  mQTDEUSO := mQPAA2 + mQPAAS + mQPAAA
               ENDCASE
               IF mQTDEINI > 0
                  mDESCRI   := TIRACE( mDESCRI )
                  mDATAPRZ  := mDATAINI - nDIAPRZ
                  mPCHORNEC := 0
                  IF cTEMPO = "I" .AND. mPCHORINT > 0
                     mPCHORMEQ := 1 / mPCHORINT
                  ENDIF
                  IF ( cTEMPO = "P" .OR. mPCHORMEQ = 0 ) .AND. mPCHORA > 0
                     mPCHORMEQ := 1 / mPCHORA
                  ENDIF
                  mPCHORNEC := mPCHORMEQ * mQTDEUSO
                  mPRELEAD  := Round( ( mPCHORNEC / nHORAS ) + .5, 0 )
                  IF mPRELEAD = 0
                     mPRELEAD := 1
                  ENDIF
                  IF mSETOROP = "X"  // Nao Distribuir
                     mPRELEAD := 0
                  ENDIF
                  IF mSETOROP = "F"
                     mPRELEAD := 1   // Contar Embalar
                  ENDIF
                  IF mLEADESP > 0  // Lead Time Especificado + Pre Lead
                     mPRELEAD := mLEADESP + mPRELEAD
                  ENDIF
                  IF !Empty( mCODMP03 )
                     dbSelectAr( "ETI" )
                     dbGoTop()
                     IF dbSeek( mCODMP03 )
                        IF LEADTIME > 0
                           mPRELEAD := LEADTIME
                        ENDIF
                        mCOGMP01 := COGNOME
                     ENDIF
                  ENDIF
                  dbSelectAr( "OP02SET" )
                  netrecapp()
                  REPLVARS()
               ENDIF
            NEXT X
         ENDIF
      ENDIF
      dbSelectAr( "OP02" )
      dbSkip()
   ENDDO
   dbSelectAr( "MS06" )
   dbCloseArea()
   dbSelectAr( "OP02" )
   dbCloseArea()
   dbSelectAr( "MP01" )
   dbCloseArea()
   dbSelectAr( "OP02SET" )
   dbSetOrder( 5 )
   dbGoTop()
   WHILE !Eof()
      @ 23, 00 SAY "Calculando Dias"
      @ 24, 00 SAY CODIGO
      mCODIGO  := CODIGO
      mSEMANA  := SEMANA
      dDATAINI := DATAINI - nDIAPRZ
      WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. mSEMANA = SEMANA .AND. !Eof()
         netreclock()
         field->DATAPRZ := dDATAINI
         field->DATA    := DATAPRZ - PRELEAD
         field->LIMTIME := PRELEAD
         dbUnlock()
         dDATAINI := DATA
         dbSkip()
      ENDDO
   ENDDO
   dbSelectAr( "OP02SET" )
   dbGoTop()
   WHILE !Eof()
      @ 23, 00 SAY "Verificando Urgencias"
      @ 24, 00 SAY CODIGO
      @ 24, 30 SAY SEQ
      @ 24, 40 SAY SSQ
      EQUVARS()
      dbSelectAr( "OP01" )
      dbGoTop()
      IF dbSeek( mOP )
         mDATAI01 := DATAA
         mDATAI02 := DATAS
         mDATAI03 := DATA2
      ENDIF
      dbSelectAr( "OP02SEX" )
      dbGoTop()
      IF !dbSeek( mCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
         netrecapp()
         REPLVARS()
      ENDIF
      dbSelectAr( "OP02SEX" )
      IF DoW( mDATA ) = 1  // Se cai no Domingo
         mDATA--// inicia no sabado
      ENDIF
      IF mSEMANA = "1"
         field->URGEN01 := "S"
         field->PRAZO01 := mDATAPRZ
         field->INICI01 := mDATA
         field->QTDDE01 := mQTDEINI
         field->TEMPO01 := mLIMTIME
         field->HORA01  := mPCHORNEC
         // FIELD->DATAI01:=mDATAINI
      ENDIF
      IF mSEMANA = "2"
         field->URGEN02 := "N"
         field->INICI02 := mDATA
         field->PRAZO02 := mDATAPRZ
         field->QTDDE02 := mQTDEINI
         field->TEMPO02 := mLIMTIME
         field->HORA02  := mPCHORNEC
         // FIELD->DATAI02:=mDATAINI
      ENDIF
      IF mSEMANA = "3"
         field->URGEN03 := "N"
         field->INICI03 := mDATA
         field->PRAZO03 := mDATAPRZ
         field->QTDDE03 := mQTDEINI
         field->TEMPO03 := mLIMTIME
         field->HORA03  := mPCHORNEC
         // FIELD->DATAI03:=mDATAINI
      ENDIF
      dbSelectAr( "OP02SET" )
      dbSkip()
   ENDDO
   dbSelectAr( "OP02SEX" )
   dbGoTop()
   WHILE !Eof()
      @ 23, 00 SAY "Checando datas Urgencia"
      @ 24, 00 SAY CODIGO

      mDATAREF := INICI01
      IF Empty( mDATAREF )
         mDATAREF := INICI02
      ENDIF
      IF Empty( mDATAREF )
         mDATAREF := INICI03
      ENDIF
      field->DATAREF := mDATAREF
      IF PRAZO02 <= DATAI01
         field->URGEN02 := "S"
      ENDIF
      IF PRAZO03 <= DATAI01
         field->URGEN03 := "S"
      ENDIF
      IF Empty( URGEN01 ) .OR. QTDDE01 = 0
         field->URGEN01 := "N"
      ENDIF
      IF Empty( URGEN02 ) .OR. QTDDE02 = 0
         field->URGEN02 := "N"
      ENDIF
      IF Empty( URGEN03 ) .OR. QTDDE03 = 0
         field->URGEN03 := "N"
      ENDIF
      IF !Empty( xURGEN02 ) .AND. QTDDE02 > 0
         field->URGEN02 := xURGEN02
      ENDIF
      IF !Empty( xURGEN03 ) .AND. QTDDE03 > 0
         field->URGEN03 := xURGEN03
      ENDIF
      dbSkip()
   ENDDO

   dbSelectAr( "OP02SEX" )
   dbGoTop()
   WHILE !Eof()
      @ 23, 00 SAY "Verificando Data Base-Produto"
      @ 24, 00 SAY PadR( CODIGO, 24 )
      mCODIGO  := CODIGO
      mDATABAS := DATAREF
      mDATABA2 := CToD( Space( 8 ) )
      mDATABA3 := CToD( Space( 8 ) )
      mTEM01   := "N"
      nREG     := RecNo()
      WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         IF QTDDE01 > 0
            mTEM01 := "S"
         ENDIF
         IF DATAREF <= mDATABAS
            mDATABAS := DATAREF
         ENDIF
         IF !Empty( INICI01 )
            IF INICI01 <= mDATABA2 .OR. Empty( mDATABA2 )
               mDATABA2 := INICI01
            ENDIF
         ENDIF
         IF !Empty( INICI02 )
            IF INICI02 <= mDATABA3 .OR. Empty( mDATABA3 )
               mDATABA3 := INICI02
            ENDIF
         ENDIF
         IF !Empty( INICI03 )
            IF INICI03 <= mDATABA3 .OR. Empty( mDATABA3 )
               mDATABA3 := INICI03
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      dbGoto( nREG )
      WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         field->DATABAS := mDATABAS
         field->DATABA2 := mDATABA2
         field->DATABA3 := mDATABA3
         field->TEM01   := mTEM01
         dbSkip()
      ENDDO
   ENDDO

   dbSelectAr( "OP02SEX" )
   dbSetOrder( 2 )   // SetorOP Codigo
   dbGoTop()
   WHILE !Eof()
      @ 23, 00 SAY "Verificando Data Base-Produto-Setor"
      @ 24, 00 SAY PadR( CODIGO, 24 )
      mCODIGO  := CODIGO
      mSETOROP := SETOROP
      mDATABA4 := CToD( Space( 8 ) )
      nREG     := RecNo()
      WHILE SETOROP = mSETOROP .AND. AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         IF !Empty( INICI01 )
            IF INICI01 <= mDATABA4 .OR. Empty( mDATABA4 )
               mDATABA4 := INICI01
            ENDIF
         ENDIF
         IF !Empty( INICI02 )
            IF INICI02 <= mDATABA4 .OR. Empty( mDATABA4 )
               mDATABA4 := INICI02
            ENDIF
         ENDIF
         IF !Empty( INICI03 )
            IF INICI03 <= mDATABA4 .OR. Empty( mDATABA4 )
               mDATABA4 := INICI03
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      dbGoto( nREG )
      WHILE SETOROP = mSETOROP .AND. AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
         field->DATABA4 := mDATABA4
         dbSkip()
      ENDDO
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OPSEXMK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC OPSEXMK

   PADRAO( 0, 1, 0, "OP01", "OP Codigo     Cliente      Saldos", "STR(mOP,3)+' '+mCODIGO+' '+STR(mCLIENTE,8)+' '+mCOGNOME+' '+STR(QATR,8)+' '+STR(QSEM,8)+' '+STR(QSE2,8)", "OP", ;
      ,,,,, {|| OPSEXMKPOS() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OPSEXMKPOS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC OPSEXMKPOS

   mURGEN02 := "S"
   mURGEN03 := "S"
   MDS( "Digite o Codigo" )
   @ 24, 50 SAY "1ß Sem"
   @ 24, 60 SAY "2ß Sem"
   @ 24, 20 SAY mCODIGO
   @ 24, 58 GET mURGEN02 PICT "!" VALID mURGEN02 $ "SN"
   @ 24, 68 GET mURGEN03 PICT "!" VALID mURGEN03 $ "SN"
   IF !READCUR()
      RETU .T.   // True Encerrar Block
   ENDIF
   IF !USEREDE( "OP02SEX", 1, 99 )
      RETU .T.   // True Encerrar Block
   ENDIF
   dbGoTop()
   dbSeek( AllTrim( mCODIGO ) )
   WHILE AllTrim( mCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
      netreclock()
      IF QTDDE02 > 0 .AND. mURGEN02 = "S"
         field->URGEN02 := "S"
      ENDIF
      IF QTDDE03 > 0 .AND. mURGEN03 = "S"
         field->URGEN03 := "S"
      ENDIF
      IF QTDDE02 = 0 .OR. mURGEN02 = "N"
         field->URGEN02 := "N"
      ENDIF
      IF QTDDE03 = 0 .OR. mURGEN03 = "N"
         field->URGEN03 := "N"
      ENDIF
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.  // True Encerrar Block



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPX

   cORI := "PCP\OP01.DBF"
   cDES := "PCP\OP01X.DBF"
   fileCOPY( cORI, cDES )
   cORI := "PCP\OP02.DBF"
   cDES := "PCP\OP02X.DBF"
   filecopy( cORI, cDES )
// Reindexa pois hove copia somentes do dbf
   M_DB( "ARQUIVO='OP01X'.OR.ARQUIVO='OP02X'" )

   M_AOP3( "OP01X", "OP02X", .F. )

   MAOP2CAL( .T., .F., .T., "OP01X", "OP02X", .F. )   // Estoque,Data,Est.proc FILTRO

   IF !USEMULT( { { "OP02X", 1, 1 }, { "MS03", 1, 2 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "OP02X" )
   dbGoTop()
   WHILE !Eof()
      mCODIGO := CODIGO
      mSEQ    := SEQ
      mSSQ    := SSQ
      mQPAA2  := QPAA2
      mQPAAS  := QPAAS
      mQPAAA  := QPAAA
      dbSelectAr( "MS03" )
      dbGoTop()
      IF dbSeek( mCODIGO + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
         netreclock()
         field->XPAA2 := mQPAA2
         field->XPAAS := mQPAAS
         field->XPAAA := mQPAAA
         dbUnlock()
      ENDIF
      dbSelectAr( "OP02X" )
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPVMES01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPVMES01

   IF !USEREDE( "OP01", 0, 99 )
      RETU .F.
   ENDIF

   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netGRVCAM( "VPRG", QATR + QSEM + QSE2 ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VQUI", QSEM + QSE2 ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AOP5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AOP5()

   MDS( "Aguarde Calculando Cargas Execessivas" )

   aRETU := PERFEC( { "PE01BX" }, { "PE" }, { "PE99" }, { "PADRAO" } )
   cARQ  := aRETU[ 5, 1 ]
   IF !USEMULT( { { CARQ, 1, 0 }, { "PE01AP", 0, 99 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "PE01AP" )
   ZAP
   dbSelectAr( CARQ )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "str(pedido,8)+str(item,3)+dtos(datasai)" )
   ordSetFocus( "temp" )


   INITVARS()
   CLRVARS()
   SET FILTER TO NRNOTASAI > 0
   dbGoTop()
   WHILE !Eof()
      mPEDIDO  := PEDIDO
      mITEM    := ITEM
      nRECNO   := RecNo()
      lGRAVA   := .F.
      mDATASAI := DATASAI
      WHILE mPEDIDO = PEDIDO .AND. mITEM = ITEM .AND. !Eof()
         IF mDATASAI <> DATASAI
            lGRAVA := .T.
         ENDIF
         dbSkip()
      ENDDO
      dbGoto( nRECNO )
      WHILE mPEDIDO = PEDIDO .AND. mITEM = ITEM .AND. !Eof()
         IF lGRAVA
            EQUVARS()
            NOVOOPA( "PE01AP" )
         ENDIF
         dbSelectAr( CARQ )
         dbSkip()
      ENDDO
      dbSelectAr( CARQ )
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPZERVOL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPZERVOL()

   LOCAL cMES := cPRG := cQUI := cMED := cMEQ := "N"

   MDI( " › Zerar Volumes" )
   @ 10, 00 SAY "Zerar"
   @ 11, 00 SAY "Volume Manual"
   @ 12, 00 SAY "Programa"
   @ 13, 00 SAY "Programa Quinzena"
   @ 14, 00 SAY "Media Acumulada"
   @ 15, 00 SAY "Media Acum.Quinzena"
   @ 11, 30 GET cMES                  PICT "!"
   @ 12, 30 GET cPRG                  PICT "!"
   @ 13, 30 GET cQUI                  PICT "!"
   @ 14, 30 GET cMED                  PICT "!"
   @ 15, 30 GET cMEQ                  PICT "!"
   IF !READCUR()
      RETU .F.
   ENDIF
   IF !MDG( "Zerar Lanáamentos" )
      RETU .F.
   ENDIF
   IF !USEREDE( "OP01", 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      netreclock()
      IF cMES = "S"
         field->VMES := 0
      ENDIF
      IF cPRG = "S"
         field->VPRG := 0
      ENDIF
      IF cQUI = "S"
         field->VQUI := 0
      ENDIF
      IF cMED = "S"
         field->VMED := 0
      ENDIF
      IF cMEQ = "S"
         field->VMEQ := 0
      ENDIF
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseAll()
   m_AOP4()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPCHKSEQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPCHKSEQ( cARQOP, cARQOP2 )

   IF !USEREDE( cARQOP2, 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      mOP  := OP
      mSEQ := SEQ
      mSSQ := SSQ
      dbSkip()
      IF !Eof()
         IF mOP = OP .AND. SEQ = mSEQ .AND. SSQ = mSSQ
            DELEREG(,,, .F., )
         ENDIF
      ENDIF
   ENDDO
   dbCloseAll()
// M_DB("ARQUIVO='"+cARQOP+"'.OR.ARQUIVO='"+cARQOP2+"'")




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OP02MS06()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC OP02MS06

   IF !USEMULT( { { "MS06", 1, 1 }, { "OP01", 1, 99 }, { "OP02", 1, 99 } } )
      RETU .T.
   ENDIF
   nHANDLE := FCreate( "OP02MS06.TXT" )
   cPECAS  := ""
   dbSelectAr( "MS06" )
   INITVARS()
   CLRVARS()
   dbSelectAr( "OP01" )
   INITVARS()
   CLRVARS()
   dbSelectAr( "OP02" )
   INITVARS()
   CLRVARS()

   dbSelectAr( "OP01" )
   dbGoTop()
   WHILE !Eof()
      EQUVARS()
      MAOP02()   // Certifica dos Calculos
      xOP := mOP
      dbSelectAr( "MS06" )
      dbGoTop()
      dbSeek( mCODIGO )
      IF AllTrim( mCODIGO ) <> AllTrim( CODIGO )
         ALERTX( "Importar Sequencia Produto" + mCODIGO )
         FWrite( nHANDLE, mCODIGO + Chr( 13 ) + Chr( 10 ) )
      ENDIF
      WHILE mCODIGO = CODIGO .AND. !Eof()
         mOP  := xOP
         mSEQ := SEQ
         mSSQ := SSQ
         MAOP04()
         IF !NOVOOPE( "OP02", Str( xOP, 8, 2 ) + Str( mSEQ, 3 ) + Str( mSSQ, 3 ) )
            netreclock()
            mQPSAI := QPSAI  // Salva o Saldo pois sofrera rplvars
         ELSE
            mQPSAI := 0
         ENDIF
         REPLVARS()
         dbUnlock()
         dbSelectAr( "MS06" )
         dbSkip()
      ENDDO
      dbSelectAr( "OP01" )
      dbSkip()
   ENDDO
   dbCloseAll()
   FClose( nHANDLE )


// + EOF: m_aop.prg
// +
