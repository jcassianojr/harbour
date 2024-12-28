// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib20.prg
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
// +    Function ENDCID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ENDCID( cESTADO, cCIDADE, eENDCID, eENDCEP, eENDNUM )

   cARQCEP := Space( 8 )
   cENDCID := &eENDCID.
   cEND    := &eENDCID.
   cCEP    := &eENDCEP.
   cNUM    := &eENDNUM.
   cCIDADE := Upper( TIRACE( cCIDADE ) )
   cARQCEP := "C" + OBTER( "MD10", cESTADO + cCIDADE, "CODIBGE" )
   IF Empty( cARQCEP )
      RETU .T.
   ENDIF
   IF Empty( cENDCID )
      ENDCIDP( cARQCEP )
      &eENDCID. := cEND
      &eENDCEP. := cCEP
   ELSE
      IF !CHECKCEP( cARQCEP, cEND, cNUM )
         ENDCIDP( cARQCEP )
         &eENDCID. := cEND
         &eENDCEP. := cCEP
      ELSE
         &eENDCEP. := cCEP
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ENDCIDP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION ENDCIDP( cARQ )

   LOCAL xTELA := SaveScreen( 00, 00, 24, 79 )

   cCOR := "W/N,N/W,N,N,W/N"
   PRIV GETLIST := {}
   PRIV lFIXA
   PRIV nACHO
   PRIV cVIDE
   PRIV lPBUS
   PRIV lPIND
   PRIV mCBAR
   PRIV mCBARM
   PRIV cTIPG
   PRIV aGETS
   PRIV cCBAS
   PRIV nIBUS
   PRIV nIEXI
   PRIV aIND
   PRIV nREG
   PRIV PCK     := .F.
   PRIV mCHAVE
   PRIV mRUA    := Space( 49 )
   PRIV mCEP    := Space( 8 )
   PRIV mLADO   := " "
   PRIV mNINI   := 0
   PRIV mNFIM   := 0
   PRIV mWCHA   := "mRUA"
   PRIV mCHA    := "RUA"

   IF !CONFARQ( cARQCEP, "RUA" + Space( 40 ) + "CEP     L NoIni NoFin" )
      RETU .F.
   ENDIF
   IF !CONFIND( cARQCEP )
      RETU .F.
   ENDIF
   METBRO( cARQ, { { "RUA", "mRUA" } }, { cCOR, cCOR, cCOR, cCOR, cCOR }, ;
      {|| RUA + ' ' + CEP }, {|| ALLTRUE() }, ;
      {|| ALLTRUE() },,, 3,,, {|| eENDCID() }, cEND )
   RestScreen( 00, 00, 24, 79, xTELA )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function eENDCID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION eENDCID

   cEND := RUA
   cCEP := CEP

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECKCEP( cARQ, cEND, cNUM )

   LOCAL cLADO
   LOCAL nNUM
   LOCAL lRETU := .F.

   IF !USEREDE( cARQ, 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   IF dbSeek( cEND )
      cCEP := CEP
   ENDIF
   dbCloseArea()
   RETU lRETU


// + EOF: mlib20.prg
// +
