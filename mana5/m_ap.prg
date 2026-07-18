// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ap.prg
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


// :*****************************************************************************
// :
// :   M_AP   .PRG : Cadastro de M„o de Obra
// :   Linguagem   : Clipper 5.X
// :        Sistema: MANA5
// :      Copyright (c) 1997, jcassiano 
// :
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_ap()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_ap

   PARA ARQWORK
   PRIV xESTQINI := 0

   PADRAX( 0,, 0, { ARQWORK, ARQWORK + "A", ARQWORK + "I" }, "C¢digo" + spac( 7 ) + "Nome" + spac( 27 ) + "Qtde M¡nima  Custo", ;
      "' '+mCODIGO+' '+mNOME+' '+STR(mQTDEMIN,12,2)+' '+STR(mVALOR,12,2)", "MAP001", "MAP001", ;
      , {|| PADDEL( ARQWORK + "A", xCHAVE, "CODIGO", "xCHAVE" ) }, {|| MAP01() },, "MAP", {|| xESTQINI := mESTQINI } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ETI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ETI

   PRIV xESTQINI

   PADRAX( 0,, 0, { "ETI", "MP03I" }, "C¢digo" + spac( 7 ) + "Nome", ;
      "' '+mCODIGO+' '+mNOME", "ETI001", "ETI001", ;
      , {|| PADDEL( "MP03I", xCHAVE, "CODIGO", "xCHAVE" ) }, {|| MPINS( "MP03I" ) },, "ETI" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MPINS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MPINS( cARQ )

   IF MDG( "Verificar Sequencia de Ensaios" )
      xCODIGO := AllTrim( mCODIGO )
      PADRAO( 1, 1, 0, cARQ, "Codigo" + spac( 19 ) + "Ite Tip Especificado", ;
         "' '+mCODIGO+' '+STR(mITEM,  3)+' '+mTIPA+' '+mESPE", ;
         "MSI", "MSI", "MSI", ;
         {|| mCODIGO := xCODIGO }, {|| PADARR( cARQ, xCODIGO, "CODIGO", "xCODIGO" ) } )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ETI02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ETI02( cCHAVE )

   RETU PadR( OBTER( "ETI", cCHAVE, "ALLTRIM(NOME)+' '+ALLTRIM(CAMADA)+' '+ALLTRIM(SALTO)+' '+ALLTRIM(ESPE)+' '+ALLTRIM(SUPE)" ), 200 )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAP01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAP01

   IF MDG( "Verificar Prioridades de Distribui‡Æo" )
      xCODIGO := mCODIGO
      PADRAO( 1, 1, 0, ARQWORK + "A", "Maq          Seq Codigo        Mao de Obra", ;
         "' '+mCODIGO+' '+STR(mSEQ,  3)+' '+mCODMPSB+' '+mNOMMPSB", ;
         "MAPA", "MAPA01", "MAPA01", ;
         {|| mCODIGO := xCODIGO }, {|| PADARR( ARQWORK + "A", xCODIGO, "CODIGO", "xCODIGO" ) } )
   ENDIF
   MPINS( ARQWORK + "I" )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AP5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AP5

   MDI( "Lan‡ar Balanco de Horas" )
   cTIPO1 := "M"
   cTIPO2 := "M"
   nDIAS  := 1
   @ 22, 00 SAY "(E)quipamentos (H)omem (T)ratamento"
   @ 23, 00 SAY "(M)ensal (S)emanal (D)iario"
   @ 24, 00 SAY "Digite os Tipos"
   @ 24, 20 GET cTIPO1                                PICT "!" VALID cTIPO1 $ "EHT"
   @ 24, 25 GET cTIPO2                                PICT "!" VALID cTIPO2 $ "MSD"
   @ 24, 30 GET nDIAS
   IF !READCUR()
      RETU .F.
   ENDIF
   cARQ := ESTQARQ( cTIPO1, 1 )
   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      netreclock()
      FIELD->ESTQENT := 0
      FIELD->ESTQSAI := 0
      DO CASE
      CASE cTIPO2 = "M"
         FIELD->ESTQINI := CHM * nDIAS * QTDEEQ
      CASE cTIPO2 = "S"
         FIELD->ESTQINI := CHS * nDIAS * QTDEEQ
      CASE cTIPO2 = "D"
         FIELD->ESTQINI := CHD * nDIAS * QTDEEQ
      ENDCASE
      FIELD->ESTQSAL   := ESTQINI
      FIELD->DATABALAN := ZDATA
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSI01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSI01

   IF Empty( mESPE )
      mESPE := OBTER( "CRMENS", mTIPA, "ALLTRIM(NOME)" ) + ;
         ": " + IF( Empty( mVALPAD ), "", Str( mVALPAD ) ) + ;
         " " + IF( Empty( mTOLMAX ), "", "+" + Str( mTOLMAX ) ) + ;
         " " + IF( Empty( mTOLMIN ), "", "-" + Str( mTOLMIN ) ) + ;
         " " + IF( Empty( mVALMAX ), "", "Max=" + Str( mVALMAX ) ) + ;
         " " + IF( Empty( mVALMIN ), "", "Min=" + Str( mVALMIN ) ) + " " + mUNIDADE
      mESPE := StrTran( mESPE, "  ", " " )
      mESPE := PadR( StrTran( mESPE, "  ", " " ), 60 )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MSI02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MSI02

   IF Empty( mENCO )
      mENCO := OBTER( "CRMENS", mTIPA, "ALLTRIM(NOME)" ) + ;
         ":  " + mUNIDADE
      mENCO := StrTran( mENCO, "  ", " " )
      mENCO := PadR( StrTran( mENCO, "  ", " " ), 60 )
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AP6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AP6( cTIPO )

   IF ValType( cTIPO ) # "C"
      mTIPO := " "
   ELSE
      mTIPO := cTIPO
   ENDIF
   CRIARVARS( "MU01I" )
   mCODIGO := Space( 24 )
   MDS( "Tipo e Codigo" )
   IF Empty( mTIPO )
      @ 24, 40 GET mTIPO VALID CHECKTAB( "MW0503", "mTIPO", "MW0503",, "LEFT(CODIGO1,1)" )
   ELSE
      @ 24, 40 GET mTIPO
   ENDIF
   @ 24, 50 GET mCODIGO VALID IF( mTIPO # "X", CHECKEXI( ESTQARQ( mTIPO, 1 ), "mCODIGO", "CODIGO+' '+NOME", "CODIGO", "CODIGO", .F. ), .T. )
   IF !READCUR()
      RETU .F.
   ENDIF
   MPINS( ESTQARQ( mTIPO, 1 ) + "I" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAP8()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAP8( Carq )

   PADULT( cARQ, "Numero   Funcion  Codigo" + spac( 19 ) + "Data     Prazo    Devolucao", ;
      "' '+STR(mNUMERO,8)+' '+STR(mNUMMP04,8)+' '+mCODIGO+' '+DTOC(mDATA)+' '+DTOC(mPRAZO)+' '+DTOC(mRETORNO)", ;
      "MP8", "NUMERO", "mNUMERO" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mapclass()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mapclass()

   IF !usemult( { { "MP03", 1, 99 }, { "MS01", 1, 2 }, { "MQ01", 1, 1 }, { "MD03", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( "MP03" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY CODIGO
      cCODIGO   := AllTrim( CODIGO )
      cAPLICA   := AllTrim( APLICACAO )
      cSUBPRD   := AllTrim( SUBPROD )
      cSUBAPL   := AllTrim( SUBAPL )
      cCLASSIPI := ""
      cCODIPI   := ""
      IF Empty( CLASSIPI )
         DO CASE
         CASE !Empty( cSUBPRD )
            MAPCLASS01( "MQ01", cSUBPRD )
         CASE !Empty( cSUBAPL )
            MAPCLASS01( "MS01", cSUBAPL )
         OTHERWISE
            IF !MAPCLASS01( "MS01", cCODIGO )
               MAPCLASS01( "MS01", cAPLICA )
            ENDIF
         ENDCASE
      ENDIF
      IF Empty( cCLASSIPI ) .AND. !Empty( cCODIPI )
         dbSelectAr( "MD03" )
         dbGoTop()
         IF dbSeek( cCODIPI )
            cCLASSIPI := CLASSIFIC
         ENDIF
      ENDIF
      dbSelectAr( "MP03" )
      IF !Empty( cCLASSIPI ) .AND. Empty( CLASSIPI )
         netgrvcam( "CLASSIPI", cCLASSIPI )
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAPCLASS01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAPCLASS01( cARQ, cCODIGO )

   LOCAL lRETU := .F.

   dbSelectAr( cARQ )
   dbGoTop()
   IF dbSeek( cCODIGO )
      cCLASSIPI := CLASSIPI
      cCODIPI   := CODIPI
      lRETU     := .T.
   ENDIF
   RETU lRETU

// + EOF: m_ap.prg
// +
