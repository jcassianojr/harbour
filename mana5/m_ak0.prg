// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ak0.prg
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
// +    Function MAK3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAK3( cARQ )

   nGMAK3 := 1
   PADRAO( 0, 1, 0, cARQ, "N§ Nota  Data     Forn. C¢digo" + spac( 6 ) + "Mˆs/Ano Valor", ;
      "' '+STR(mNRNOTA,  8)+' '+DTOC(mDATA)+' '+STR(mFORNECEDO,  5)+' '+mCODIGO+' '+STR(mMES,2)+' '+STR(mANO,4)+' '+STR(mVALORMES, 12, 2)+' '+mCONTA", "MAK3" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AK5A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AK5A()

   CORPAD := CORARR( "MAK5" )
   PAD001 := CORPAD[ 1 ]
   PAD002 := CORPAD[ 2 ]
   PAD005 := CORPAD[ 3 ]
   PAD006 := CORPAD[ 4 ]
   PAD007 := CORPAD[ 5 ]

   aTEL := TELAPEG( "MAK501" )
   aGET := EDITPEG( "MAK501" )
   WHILE .T.
      mFATOR := 1
      CRIARVARS( "MK05" )
      TELASAY( aTEL )
      EDITSAY( aGET )
      MDS( "Numero de Meses" )
      @ 24, 40 GET mFATOR
      IF !READCUR()
         EXIT
      ENDIF
      mVALORTOT := mVALORMES
      nANOREF   := mANO
      nMESREF   := mMES
      FOR X := 1 TO mFATOR
         mVALORMES := Round( mVALORTOT / mFATOR, 2 )
         mANO      := nANOREF
         mMES      := nMESREF
         mCHAVE    := ULTIMOREG( "MK05", "REQUISI", "mREQUISI" )
         NOVOREG( "MK05", mCHAVE )
         nMESREF++
         IF nMESREF > 12
            nMESREF := 1
            nANOREF++
         ENDIF
      NEXT X
      IF !MDG( "Outro Lan‡amento" )
         EXIT
      ENDIF
   ENDDO
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AK5B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC M_AK5B()

   PADRAO( 0, 1, 0, "MK05", "Lancmto  Nota     T Fornecedor/Cliente Conta" + spac( 7 ) + "Mes/Ano Valor", ;
      "' '+STR(mREQUISI,8)+' '+STR(mNRNOTA,8)+' '+mTIPOCLI+' '+STR(mFORNECEDO,5)+' '+mCOGNOME+' '+mCONTA+' '+STR(mMES,2)+' '+STR(mANO,4)+' '+STR(mVALORMES,12,2)", "MAK5" )
   RETU .T.


// + EOF: m_ak0.prg
// +
