// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ax.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_AX   .PRG : Controle de Horas
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


PRIV xSERVICO, xDATABASE, xTIPBASE

AUTOMENU( " Ý Cadastro de Controles ", "X", 24 )





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AX6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_AX6( nTIPO )

   IF nTIPO = 1
      cVAR  := MESANO()
      cARQ1 := "OC" + cVAR
      cARQ2 := "OA" + cVAR
   ELSE
      cARQ1 := "OC01"
      cARQ2 := "OC01A"
   ENDIF
   PRIV xOC
   PADRAX( 0,, 0, { CARQ1, CARQ2 }, "OC     Data    Total", ;
      "' '+STR(mOC,8)+' '+DTOC(mDATA)+' '+STR(mTOTAL)", "MAX601", "MAX601",, ;
      {|| PADDEL( cARQ2, Str( xCHAVE, 8 ), "OC", "xCHAVE" ) }, ;
      ,, "MX06",,,,, {|| MAX6REP() } )
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX6REP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX6REP

   xOC := mOC
   PADRAO( 1, 1, 0, CARQ2, "OC     C¢digo                Soma", ;
      "' '+STR(mOC,8)+' '+STR(mITEM,3)+' '+mCODIGO+' '+STR(mSOMA)", "MAX6A", "MAX6A1", "MAX6A1", ;
      {|| MAX6INC() }, {|| PADARR( cARQ2, Str( xOC, 8 ), "OC", "xOC" ) },,, ;
      ,,, "mSOMA" )
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX6INC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX6INC

   mOC := xOC
   ULTIMOITEM( cARQ2, Str( xOC, 8 ), "OC", "xOC", "ITEM", "mITEM", .T. )
   RETU





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AX3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AX3()

   PRIV xCODIGO

   PADRAX( 0,, 0, { "MX03", "MX03A" }, "Projeto" + spac( 53 ) + "Total", ;
      "' '+mCODIGO+' '+mDESCRICAO+' '+STR(mTOTAL, 17, 2)", "MAX301", "MAX301",, ;
      {|| PADDEL( "MX03A", xCHAVE, "CODIGO", "xCHAVE" ) }, ;
      ,, "MX03",,,,, {|| MAX3REP() } )
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX3REP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX3REP

   xCODIGO := mCODIGO
   PADRAO( 1, 1, 0, "MX03A", "C¢digo   Seq Descri‡„o" + spac( 22 ) + "Pre‡o", ;
      "' '+mCODIGO+' '+STR(mSEQ,  3)+' '+mDESCRI+' '+STR(mPRECO, 12, 2)", "MAX3A", "MAX3A1", "MAX3A1", ;
      {|| MAX3INC() }, {|| PADARR( "MX03A", xCODIGO, "CODIGO", "XCODIGO" ) },,, ;
      ,,, "mPRECO" )
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX3INC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX3INC

   mCODIGO := xCODIGO
   ULTIMOITEM( "MX03A", xCODIGO, "CODIGO", "XCODIGO", "SEQ", "mSEQ", .T. )
   RETU





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PADULT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PADULT

   PARA cARQU, cDIZU, cBARU, cLAYU, cCAMU, cVARU

   IF ValType( cCAMU ) = "C"
      PADRAO( 0, 1, 0, cARQU, cDIZU, cBARU, cLAYU,,, {|| ULTIMOREG( cARQU, cCAMU, cVARU ) } )
   ELSE
      PADRAO( 0, 1, 0, cARQU, cDIZU, cBARU, cLAYU )
   ENDIF




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AX5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AX5( cARQ )

   PADULT( cARQ, "Seq   Cliente" + spac( 15 ) + "Data     Hora  Valor", ;
      "' '+STR(mSEQ,5)+' '+STR(mCLIENTE,8)+' '+mCOGCLI+' '+DTOC(mDATA)+' '+STR(mHORA,5,2)+' '+STR(mVALOR,12,2)", ;
      "MAX4", "SEQ", "mSEQ" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX04( cARQ )

   PADULT( cARQ, "Nr.Os    Data     Cliente", ;
      "' '+STR(mOS,8,2)+' '+DTOC(mDATA)+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '", ;
      "MAX2", "OS", "mOS" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX03( cARQ )

   PADULT( cARQ, "Nr.Os    Data     Cliente" + spac( 12 ) + "Servico     Horas Valor Total", ;
      "' '+STR(mOS,8,2)+' '+DTOC(mDATA)+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+mSERVICO+' '+STR(mHRQTDE,5,2)+' '+STR(mVALORTOT,12,2)", ;
      "MAX", "OS", "mOS" )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX02

   xSERVICO  := mSERVICO
   xDATABASE := mDATABASE
   xTIPBASE  := mTIPBASE
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAX01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAX01

   mHRQTDE := mHRFIM - mHRINI - mHRDES
   IF Empty( mQTDDE )
      mQTDDE := mHRQTDE
   ENDIF
   @ 13, 28 SAY mHRQTDE PICTURE '99.99'
   IF !Empty( mQTDDE )
      mVALORMER := mQTDDE * mVALOR
   ENDIF
   mVALORIMP := Round( mALIQUOTA * mVALORMER / 100, 2 )
   mVALORTOT := mVALORMER - mVALORIMP
   @ 16, 28 SAY mALIQUOTA PICT "99.99"
   @ 13, 57 SAY mVALORMER PICT "9,999,999.99"
   @ 16, 35 SAY mVALORIMP PICT "9,999,999.99"
   @ 16, 50 SAY mVALORTOT PICT "9,999,999.99"
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGVAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGVAL( mCOD, xCOD, cCLI, dBASE, cTIPO, mVAL, mNOM, mCIPI, mUNI, mIMP )

   LOCAL cBUSCA := PadR( &mCOD., 8 )

   IF &xCOD. # &mCOD.
      IF ValType( mNOM ) = "C"
         &mNOM := OBTER( "MS01", cBUSCA, "NOME" )
      ENDIF
      IF ValType( mCIPI ) = "C"
         &mCIPI := OBTER( "MS01", cBUSCA, "CODIPI" )
      ENDIF
      IF ValType( mUNI ) = "C"
         &mUNI := OBTER( "MS01", cBUSCA, "UNIDADE" )
      ENDIF
      IF ValType( mIMP ) = "C"
         &mIMP := OBTER( "MS01", cBUSCA, "IMPOSTO" )
      ENDIF
      &xCOD. := &mCOD.
   ENDIF
   IF ValType( mNOM ) = "C" .AND. Empty( &mNOM )
      &mNOM := OBTER( "MS01", AllTrim( cBUSCA ), "NOME" )
   ENDIF
   IF ValType( mCIPI ) = "C" .AND. Empty( &mCIPI )
      &mCIPI := OBTER( "MS01", cBUSCA, "CODIPI" )
   ENDIF
   IF ValType( mUNI ) = "C" .AND. Empty( &mUNI )
      &mUNI := OBTER( "MS01", cBUSCA, "UNIDADE" )
   ENDIF
   IF ValType( mIMP ) = "C" .AND. Empty( &mIMP )
      &mIMP := OBTER( "MS01", cBUSCA, "IMPOSTO" )
   ENDIF
   IF Empty( &mVAL )
      IF Empty( dBASE )
         dBASE := CToD( Space( 8 ) )
         IF !Empty( cCLI )
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( cCLI, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ELSE
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( 0, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ENDIF
      ELSE
         IF !Empty( cCLI )
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( cCLI, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ELSE
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( 0, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ENDIF
      ENDIF
   ENDIF
   RETU .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGVALB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGVALB( cCLI, dBASE, cTIPO, mVAL, xDATA, xTIPO, mCOD )

   LOCAL cBUSCA := PadR( &mCOD., 8 )

   IF &xDATA # dBASE .OR. &xTIPO # cTIPO .OR. Empty( &mVAL )
      IF Empty( dBASE )
         dBASE := CToD( Space( 8 ) )
         IF !Empty( cCLI )
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( cCLI, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ELSE
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( 0, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ENDIF
      ELSE
         IF !Empty( cCLI )
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( cCLI, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ELSE
            &mVAL := OBTER( "MS02", cBUSCA + "C" + Str( 0, 8 ) + DToS( dBASE ) + cTIPO, "VALOR" )
         ENDIF
      ENDIF
      IF &xDATA # dBASE
         &xDATA := dBASE
      ENDIF
      IF &xTIPO # cTIPO
         &xTIPO := cTIPO
      ENDIF
   ENDIF
   RETU .T.

// + EOF: m_ax.prg
// +
