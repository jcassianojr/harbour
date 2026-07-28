// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdih.prg
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
// +    Source Module => J:\empresa\M_BDIH.PRG
// +
// +    Functions: Function MBDIH()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdih()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdih

   PARA cTIP

   ZFOL := ZLIM := ZLIV := 0
   ZULT := ZDATA

   IF cTIP = "1"
      MDI( " Э APURAЂЋO IPI" )
   ELSE
      MDI( " Э APURAЂЋO ICMS" )
   ENDIF


   aRETU        := PERFEC( { "MM06", "MK06" }, { "M6", "K6" }, { "MM96", "MK96" } )
   nMES         := aRETU[ 1 ]
   nANO         := aRETU[ 2 ]
   ARQSAI       := aRETU[ 5, 1 ]
   ARQENT       := aRETU[ 5, 2 ]
   mCOMPETENCIA := aRETU[ 7 ]
   nCRE         := nDEB := 0
   nDEB01       := nDEB02 := nCRE01 := nCRE02 := nCRE03 := 0
   nUFESP       := 0
   cPERIODO     := "1o. Decendio" + Space( 10 )
   cTIPOCAN     := "T"
   cAPUNEW      := "S"


   @ 20, 00 SAY "Digite o M€s e o ano"
   @ 21, 00 SAY "Digite o Complemento"
   @ 22, 00 SAY "Digite a Ufesp"
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 20, 40 GET nMES
   @ 20, 45 GET nANO
   @ 21, 30 GET cPERIODO
   @ 22, 40 GET nUFESP                                        PICT "9999.999"
   @ 23, 40 GET cTIPOCAN                                      PICT "!"        VALID cTIPOCAN $ "TCN"
   @ 24, 40 GET cAPUNEW                                       PICT "!"        VALID cAPUNEW $ "SN"
   IF !READCUR()
      RETU .F.
   ENDIF

   lESTORNO := MDG( "Incluir Estornos" )
   IF lESTORNO .AND. MDG( "Revisar Estornos" )
      PADRAO( 0, 1, 0, "FI_OCO", "Ano/Mes T It Ocorencia" + spac( 22 ) + "Valor/ICM    Valor/IPI", ;
         "' '+STR(mANO,  4)+' '+STR(mMES,  2)+' '+mTIPO+' '+STR(mITEM,  2)+' '+mDESCRICAO+' '+STR(mVALICM, 12, 2)+' '+STR(mVALIPI, 12, 2)", ;
         "MA54", "MA5401", "MA5401", ;
         {|| iMA54() }, {|| PADARR( "FI_OCO", Str( nANO, 4 ) + Str( nMES, 2 ), "STR(nANO,4)+STR(nMES,2)", "STR(ANO,4)+STR(MES,2)" ) } )
   ENDIF


   IF MDG( "Apurar Entrada" )
      MDS( "Aguarde Apurando Entrada" )
      M_BDIH01( ARQENT, "C" )
   ENDIF

   IF MDG( "Apurar Saida" )
      MDS( "Aguarde Apurando Saida" )
      M_BDIH01( ARQSAI )
   ENDIF

   PRIV wNOME, wINSCR, wCGC, wJUCESPC, wJUCESPD
   PRIV wIMUNICI, wENDERECO, wCIDADE, wESTADO, wCEP, wBAIRRO
   pegempmbdi()


   IF cTIP = "1"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAXIPI", "FILIVIPI", "FILIMIPI", "FILAIPI" }, { "ZFOL", "ZLIV", "ZLIM", "ZULT" } )
   ELSE
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAXICM", "FILIVICM", "FILIMICM", "FILAICM" }, { "ZFOL", "ZLIV", "ZLIM", "ZULT" } )
   ENDIF
   ZFOL++

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   IF lESTORNO
      IF !USEREDE( "FI_OCO", 1, 1 )
         RETU .F.
      ENDIF
   ENDIF

   IMPRESSORA()
   IF ZFOL = ZLIM
      M_BDIN( if( cTIP = "2", 6, 8 ) )
      ZLIV++
      ZFOL := 1
      M_BDIN( if( cTIP = "2", 5, 7 ) )
      ZFOL := 2
   ENDIF

   video()
   IF MDG( "Confirmar Valores" )
      @ 23, 00 clea
      @ 23, 00 SAY "Creditos"
      @ 23, 20 SAY "Debitos"
      @ 24, 00 GET nCRE
      @ 24, 20 GET nDEB
      READCUR()
   ENDIF
   impressora()

   @  1, 0 SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S      REF.:" + mCOMPETENCIA + " DATA:" + DToC( ZDATA ) + " HORA:" + Left( Time(), 5 ) + " F.:" + Str( ZFOL, 4 )
   @  2, 0 SAY repl( "-", 132 )
   IF cTIP = "1"
      @  3, 0 SAY "R E G I S T R O  D E  A P U R A C A O  D O  I P I"
   ELSE
      @  3, 0 SAY "R E G I S T R O  D E  A P U R A C A O  D O  I C M S"
   ENDIF
   @  4, 0   SAY "FIRMA:" + wNOME + "MES OU PERIODO/ANO:" + AllTrim( cPERIODO ) + " " + mCOMPETENCIA
   @  5, 0   SAY "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
   @  5, 11  SAY wINSCR
   @  5, 32  SAY wCGC
   @  5, 59  SAY wJUCESPC
   @  5, 78  SAY wJUCESPD
   @  5, 105 SAY wIMUNICI
   @  6, 0   SAY "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
   @  6, 10  SAY wENDERECO
   @  6, 59  SAY wCIDADE
   @  6, 103 SAY wESTADO
   @  6, 111 SAY wCEP
   @  7, 0   SAY repl( "-", 132 )
   @  8, 40  SAY "DEBITO DO IMPOSTO (SAIDAS)"
   @ 10, 0   SAY "Por Saidas com Debito de Imposto    "
   @ 10, 50  SAY nDEB                                                                                       PICT "999,999,999.99"
   @ 12, 0   SAY "Outros Debitos               "
   MBDIH( "A", "nDEB01" )
   IF Empty( nDEB01 )
      @ PRow(), 50 SAY nDEB01 PICT "999,999,999.99"
   ENDIF
   @ PRow() + 2, 0 SAY "Estorno de Creditos                 "
   MBDIH( "B", "nDEB02" )
   IF Empty( nDEB02 )
      @ PRow(), 50 SAY nDEB02 PICT "999,999,999.99"
   ENDIF
   nTOTDEB := nDEB + nDEB01 + nDEB02
   @ PRow() + 2, 0  SAY "TOTAL"
   @ PRow(), 60    SAY nTOTDEB                                PICT "999,999,999.99"
   @ PRow() + 2, 0  SAY repl( "-", 132 )
   @ PRow() + 1, 40 SAY "CREDITO DO IMPOSTO (ENTRADAS)"
   @ PRow() + 2, 0  SAY "Por Entradas com Credito do Imposto "
   @ PRow(), 50    SAY nCRE                                   PICT "999,999,999.99"
   @ PRow() + 2, 0  SAY "Saldo Credor do Periodo Anterior    "
   MBDIH( "C", "nCRE01" )
   IF Empty( nCRE01 )
      @ PRow(), 50 SAY nCRE01 PICT "999,999,999.99"
   ENDIF
   @ PRow() + 2, 0 SAY "Outros Creditos                     "
   MBDIH( "D", "nCRE02" )
   IF Empty( nCRE02 )
      @ PRow(), 50 SAY nCRE02 PICT "999,999,999.99"
   ENDIF
   @ PRow() + 2, 0 SAY "Estorno de Debitos                  "
   MBDIH( "E", "nCRE03" )
   IF Empty( nCRE03 )
      @ PRow(), 50 SAY nCRE03 PICT "999,999,999.99"
   ENDIF
   nTOTCRE := nCRE + nCRE01 + nCRE02 + nCRE03
   @ PRow() + 2, 0  SAY "TOTAL                               "
   @ PRow(), 60    SAY nTOTCRE                                 PICT "999,999,999.99"
   @ PRow() + 2, 0  SAY repl( "-", 132 )
   @ PRow() + 1, 40 SAY "APURACAO DOS SALDOS"
   @ PRow() + 2, 0  SAY "Saldo Devedor (Debito Menos Credito) "
   IF nTOTCRE < nTOTDEB
      @ PRow(), 60 SAY nTOTDEB - nTOTCRE PICT "999,999,999.99"
   ELSE
      @ PRow(), 60 SAY 0 PICT "999,999,999.99"
   ENDIF
   @ PRow() + 2, 0 SAY "Dedu‡”es "
   @ PRow() + 2, 0 SAY "Imposto a Recolher "
   IF nTOTCRE < nTOTDEB
      @ PRow(), 60 SAY nTOTDEB - nTOTCRE PICT "999,999,999.99"
   ELSE
      @ PRow(), 60 SAY 0 PICT "999,999,999.99"
   ENDIF
   @ PRow() + 2, 0 SAY "Saldo Devedor/Imposto a Recolher em Ufesp"
   IF nTOTCRE < nTOTDEB
      @ PRow(), 60 SAY Round( ( nTOTDEB - nTOTCRE ) / nUFESP, 3 ) PICT "999,999,999.999"
   ELSE
      @ PRow(), 60 SAY 0 PICT "999,999,999.99"
   ENDIF
   @ PRow() + 2, 0 SAY "Saldo Credor (Credito menos Debito)   "
   @ PRow() + 1, 0 SAY "A transportar Perido Sequinte"
   IF nTOTCRE > nTOTDEB
      @ PRow(), 60 SAY nTOTCRE - nTOTDEB PICT "999,999,999.99"
   ENDIF
   IMPFOL()
   IF lESTORNO
      dbCloseAll()
   ENDIF
   VIDEO()
   IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDIH()
// +
// +    Called from ( m_bdih.prg   )   5 - function mbdg02()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDIH()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDIH( cREF, cVAR )

   IF !lESTORNO
      RETU .T.
   ENDIF
   dbGoTop()
   dbSeek( Str( nANO, 4 ) + Str( nMES, 2 ) + cREF )
   WHILE nANO = ANO .AND. nMES = MES .AND. cREF = TIPO .AND. !Eof()
      IF cTIP = "1" .AND. !Empty( VALIPI )
         &cVAR. += VALIPI
         @ PRow() + 1, 0 SAY DESCRICAO
         @ PRow(), 60   SAY           VALIPI PICT "999,999,999.99"
      ENDIF
      IF cTIP = "2" .AND. !Empty( VALICM )
         &cVAR. += VALICM
         @ PRow() + 1, 0 SAY DESCRICAO
         @ PRow(), 60   SAY           VALICM PICT "999,999,999.99"
      ENDIF
      dbSkip()
   ENDDO
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function somacancel()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC somacancel()

   lSOMA := .F.
   IF cTIPOCAN = "T"
      lSOMA := .T.
   ENDIF
   IF cTIPOCAN = "C" .AND. !Empty( DCANCEL )
      lSOMA := .T.
   ENDIF
   IF cTIPOCAN = "N" .AND. Empty( DCANCEL )
      lSOMA := .T.
   ENDIF
   RETU lSOMA


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegempmbdi()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC pegempmbdi

   IF !USEREDE( "MANEMP", 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   IF dbSeek( ZNUMERO )
      wNOME     := NOME
      wINSCR    := INSCR
      wCGC      := CGC
      wJUCESPC  := JUCESPC
      wJUCESPD  := JUCESPD
      wIMUNICI  := IMUNICI
      wENDERECO := ENDERECO
      wCIDADE   := CIDADE
      wESTADO   := ESTADO
      wCEP      := CEP
      wBAIRRO   := BAIRRO
   ELSE
      dbCloseAll()
      RETU .F.
   ENDIF
   dbCloseAll()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDIH01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_BDIH01( cARQ, cTIPO )

   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF !USEREDE( cARQ, 1, 0 )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 40 SAY NUMERO
      IF somacancel()
         IF cTIPO = "C"
            IF cTIP = "1"
               nCRE += DVALIPI
            ELSE
               nCRE += DVALICM
            ENDIF
         ELSE
            IF cTIP = "1"
               nDEB += DVALIPI
            ELSE
               nDEB += DVALICM
            ENDIF
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU


// + EOF: M_BDIH.PRG

// + EOF: m_bdih.prg
// +
