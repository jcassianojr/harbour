// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdip.prg
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

( "Acumular DIPI" )

cAPUNEW := "S"
@ 24, 00 SAY "Apurar CFO Novo"
@ 24, 40 GET cAPUNEW           PICT "!" VALID cAPUNEW $ "SN"
IF !READCUR()
RETU .F.
ENDIF


IF MDG( "Acumular NF Entrada" )
SOMAANO( "MK96", "K6" )
ENDIF
IF MDG( "Acumular NF Saida" )
SOMAANO( "MM96", "M6" )
ENDIF

IF MDG( "Apurar NF Entrada" )
MBDIP01( "MK96", "ADIPIE" )
ENDIF
IF MDG( "Apurar NF Saida" )
MBDIP01( "MM96", "ADIPIS" )
ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDIP01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBDIP01( cARQ, cAPU )

   MDS( "Aguarde Apurando" )
   IF !usemult( { { Carq, 1, 99 }, { cAPU, 0, 99 }, { "MD04", 1, IF( cAPUNEW = "S", 2, 3 ) }, { "MB01", 1, 1 }, { "MA01", 1, 1 }, { "FI_NBM", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( CAPU )
   ZAP
   dbSetOrder( IF( cAPUNEW = "N", 1, 2 ) )

   dbSelectAr( Carq )
   MDS( "Iniciando Apuracao" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cAPUNEW = "N"
      ordDestroy( "temp" )
      ordCreate(, "temp", "DCFONEW+STR(FORNECEDO,8)+DCLASSIPI" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "DOPER+STR(FORNECEDO,8)+DCLASSIPI" )
      ordSetFocus( "temp" )
   ENDIF
   MDS()
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      mDOPER   := DOPER
      mDCFONEW := DCFONEW
      mFICHA   := .F.
      dbSelectAr( "md04" )
      dbGoTop()
      IF dbSeek( mDOPER )
         IF FICHA = "S"
            mFICHA := .T.
         ENDIF
      ENDIF
      dbSelectAr( Carq )
      WHILE IF( cAPUNEW = "N", mDOPER, mDCFONEW ) = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. !Eof()
         mFORNECEDO := FORNECEDO
         mDCLASSIPI := DCLASSIPI
         mTIPOFOR   := TIPOFOR
         mCGC       := Space( 14 )
         mCOGNOME   := ""
         mDVALORNF  := 0
         mDVALIPI   := 0
         @ 24, 00 SAY mFORNECEDO
         @ 24, 10 SAY mDCLASSIPI
         WHILE mTIPOFOR = TIPOFOR .AND. IF( cAPUNEW = "N", mDOPER, mDCFONEW ) = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. mFORNECEDO = FORNECEDO .AND. mDCLASSIPI = DCLASSIPI .AND. !Eof()
            mDVALORNF += DVALORNF
            mDVALIPI  += DVALIPI
            dbSkip()
         ENDDO
         IF mDVALORNF > 0
            dbSelectAr( IF( mTIPOFOR = "C", "MA01", "MB01" ) )
            dbGoTop()
            IF dbSeek( Mfornecedo )
               mCGC     := CGC
               mCOGNOME := COGNOME
            ENDIF
            IF Empty( mCGC )
               mCGC := Str( mFORNECEDO, 8 )
            ENDIF
            mDESCRI := ""
            dbSelectAr( "fi_nbm" )
            dbGoTop()
            IF dbSeek( StrTran( AllTrim( mDCLASSIPI ), ".", "" ) )
               mDESCRI := DESCRI
            ENDIF
            dbSelectAr( Capu )
            netrecapp()
            replvars( .F. )
         ENDIF
         dbSelectAr( Carq )
      ENDDO
      dbSelectAr( Carq )
   ENDDO
   dbCloseAll()

// + EOF: m_bdip.prg
// +
